/***************************************************************************************************
 * Name:  BRAINFAResponseHelper
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for Response aspect of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFAResponseHelper -- 88%  05/12/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 05/06/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version
 * 06/03/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Response-Only version (split off from original)
 * 01/27/2023   T2Cabato    Story ESCJ-2365                 Revised per Story
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
 * 08/02/2023   T2Cabato    QFCJ-4286                       BRAIN-Drop-Cost-Fix
 * 08/15/2023   T2Cabato    QFCJ-4282                       BRAIN-ONT-Model-Mapping
 * 08/15/2023   T2Cabato    QFCJ-4297                       BRAIN-UPS-Shelf-to-idfElectronics-for-BRAIN
 * 08/15/2023   T2Cabato    QFCJ-4309                       BRAIN-ContractType-and-OtherProviderContractType-Mapping
****************************************************************************************************/
public with sharing class BRAINFAResponseHelper { 
    public class ZeroListException extends Exception {}
    public class InvalidParameterParsingException extends Exception {}
    public class CallNotFoundForResponseException extends Exception {}
    public class NullResponseOBJException extends Exception {}
    public class NullHl1EvalResultOBJException extends Exception {}
    public class NullFinMetricOBJException extends Exception {}
    public class NullResponseIdException extends Exception {}
    public class NullResponseJSONException extends Exception {}
    public class NullCallMasterException extends Exception {}
    public class NullCallMasterIdException extends Exception {}

    public static final String UNFORMATTED_BRAIN_RESPONSE = 'UnformattedBRAINResponse';
    private static final String SWITCH_DEFAULT = 'ELSE not an expected name';
    private static final String RESP_OBJ_NULL = 'EXCEPTION! The BRAINFAResponse object provided was NULL.  No further processing could be performed.';
    private static final String HL1ER_LIST_NULL = 'EXCEPTION! The hl1EvaluationResult-List had 0 records.  There is nothing there to process.';
    private static final String HL1ER_OBJ_NULL = 'EXCEPTION! The hl1EvaluationResult object was NULL.  No further processing could be performed.';

	private static String thisFAResponseId = null;    

    @AuraEnabled
    public static BRAIN_FA_Response__c createBaseFAResponse(BRAIN_API_Call_Tracker__c faCallMaster) {        
        try {
            if(faCallMaster == null || faCallMaster.Id == null) {
              	throw new NullCallMasterException('EXCEPTION! The BRAIN-API-Call-Tracker-Master provided was NULL.');    
            }
            System.debug('ENTERING createBaseFAResponse with CALL-TRACKER: faCallMaster.Id = ' + faCallMaster.Id + '   AND faCallMaster.Name = ' + faCallMaster.Name);
			BRAIN_FA_Response__c faResponse = new BRAIN_FA_Response__c();
            faResponse.BRAIN_API_Call_Tracker_Master__c = faCallMaster.Id;
            List<BRAIN_FA_Response__c> faResponseList = new List<BRAIN_FA_Response__c>();
            faResponseList.add(faResponse);
            faResponseList = BRAINFAObjectDMLManager.upsertFAResponseList(faResponseList);
            System.debug('AFTER FA-RESPONSE INSERT >> faResponse.Id = ' + faResponseList?.get(0)?.Id + '  AND faResponse.Name = ' + faResponseList?.get(0)?.Name + '  AND faResponse.BRAIN_API_Call_Tracker_Master__c = ' + faResponseList?.get(0)?.BRAIN_API_Call_Tracker_Master__c);
            thisFAResponseId = faResponseList?.get(0)?.Id;
            System.debug('BACK-IT-UP!  thisFAResponseId = ' + thisFAResponseId + '  BASED ON faResponse.Id = ' + faResponseList?.get(0)?.Id);
            /****************************************************************************************************************
             *  BRAIN_FA_Response__c checkInsertResponse = [SELECT Id, Name FROM BRAIN_FA_Response__c WHERE id = :faResponse.Id];
             *  System.debug('AFTER CHECK-INSERT-FA-RESPONSE QUERY: checkInsertResponse.Id = ' + checkInsertResponse.Id + '   AND checkInsertResponse.Name = ' + checkInsertResponse.Name);
             ****************************************************************************************************************/
            
            //associate the newly inserted faResponse as child to faCallMaster by faResponse.Id
            faCallMaster.BRAIN_FA_Response__c = thisFAResponseId;
            System.debug('PRIOR TO UPDATE CALL-TRACKER: faCallMaster.Id = ' + faCallMaster.Id + '   AND faCallMaster.Name = ' + faCallMaster.Name);
            List<BRAIN_API_Call_Tracker__c> faCallList = new List<BRAIN_API_Call_Tracker__c>();
            faCallList.add(faCallMaster);
            faCallList = BRAINFAObjectDMLManager.upsertFACallList(faCallList);        
	        return faResponse;
        } catch(Exception methodX) {
            System.debug('(BRAINFAResponseHelper.createBaseFAResponse) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX
    }//end method createBaseFAResponse
        
    @AuraEnabled
    public static BRAINFAResponseWrap parseJSONForFAResponse(String responseJSON) {
        try {
            if (String.isBlank(responseJSON)) {        
	            throw new NullResponseJSONException('EXCEPTION! The ResponseJSON provided was NULL.  No parsing for BRAIN_FA_Response could be performed.');    
            }//end if NULL value for responseJSON or for faResponse.Id or for both
	        BRAINFAResponseWrap respWrap = new BRAINFAResponseWrap();
            Integer hl1SimulationResultStartIdx = responseJSON.indexOf('"hl1SimulationResult') - 1;
            if (hl1SimulationResultStartIdx > 0) {
                String segment1ResponseJSON = responseJSON.substring(0, hl1SimulationResultStartIdx);
                Integer errorCodeStartIdx = responseJSON.indexOf('"errorCode', hl1SimulationResultStartIdx) - 1;
                String segment2ResponseJSON = responseJSON.substring(errorCodeStartIdx);
                String responseJSONTrimmed = segment1ResponseJSON + segment2ResponseJSON;
                /***  System.debug('For faResponse, responseJSONTrimmed = ' + responseJSONTrimmed); ***/
                respWrap = BRAINFAResponseWrap.parse(responseJSONTrimmed);
            } else { //Got a Response but not fully formatted having no hl1EvaluationResult
                System.debug('(BRAINFAResponseHelper.parseJSONForFAResponse) responseJSON had no "hl1EvaluationResult", checking now for "errorCode"...' );
                Integer errorCodeStartIdx = responseJSON.indexOf('"errorCode') - 1;
                if (errorCodeStartIdx > 0) {
                    Integer errorMessageStartIdx = responseJSON.indexOf('"errorMessage', errorCodeStartIdx) - 1;
                    Integer errorMessageEndIdx = responseJSON.indexOf('",', errorMessageStartIdx) + 1;            
                    String responseJSONTrimmed = responseJSON.substring(errorCodeStartIdx, errorMessageEndIdx);
                    BRAINFAErrorResponseWrap errorWrap = BRAINFAErrorResponseWrap.parse(responseJSONTrimmed);
                    respWrap.errorCode = errorWrap.errorCode;
                    respWrap.errorMessage = errorWrap.errorMessage;
                } else {
                    System.debug('(BRAINFAResponseHelper.parseJSONForFAResponse) responseJSON had no "errorCode" either, thus setting errorCode to 400, and errorMessage to full text of responseJSON: ' + responseJSON);
                    respWrap.errorCode = 'BadRequest';
                    respWrap.errorMessage = responseJSON;
                }//end else Response had no errorCode
            }//end else Response had no hl1EvaluationResult
	        return respWrap;
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.parseJSONForFAResponse) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }
    }//end parseJSONForFAResponse    
    
    @AuraEnabled
    public static BRAIN_FA_Response__c populateFAResponseFromJSON(BRAIN_FA_Response__c faResponse, String responseJSON) {
        try {
            if (faResponse == null) {
                throw new NullResponseOBJException(RESP_OBJ_NULL);
            }//end else NULL faResponse
            System.debug('Incoming parameter faResponse is NOT NULL, and has faResponse.Id = ' + faResponse.Id);
            if (responseJSON.contains('errorCode')) {
                BRAINFAResponseWrap respWrap = parseJSONForFAResponse(responseJSON);
                faResponse.applicationVersion__c = respWrap.applicationVersion;
                faResponse.baseFinancialAnalysisId__c = respWrap.id;
                faResponse.BRAIN_ID__c = respWrap.id;
                faResponse.conversionScenarioId__c = respWrap.conversionScenarioId;
                faResponse.costScenarioId__c = respWrap.costScenarioId;
                faResponse.errorCode__c = respWrap.errorCode;
                faResponse.errorMessage__c = respWrap.errorMessage;
                faResponse.forecastScenario__c = respWrap.forecastScenario;
                faResponse.incremental__c = respWrap.incremental;
                faResponse.investmentFinancialAnalysisId__c = respWrap.id;
                faResponse.Request_ID__c = respWrap.requestId;
                faResponse.responseDate__c = respWrap.responseDate;
                faResponse.salesRateScenarioId__c = respWrap.salesRateScenarioId;
                faResponse.status__c = respWrap.status;
                faResponse.survivalScenarioId__c = respWrap.survivalScenarioId;
            } else {
                faResponse.errorCode__c = UNFORMATTED_BRAIN_RESPONSE;
                faResponse.errorMessage__c = responseJSON;
                faResponse.status__c = 'FAIL';
            }
            faResponse.hl1EvaluationResult__c = null;
            /******************************************************************************************************************************** 
                System.debug('BEFORE UPDATE BRAIN_FA_Response >> \n faResponse.Id = ' + faResponse.Id + 
                                '\n faResponse.applicationVersion__c = ' + faResponse.applicationVersion__c +
                                '\n faResponse.baseFinancialAnalysisId__c = ' + faResponse.baseFinancialAnalysisId__c +
                                '\n faResponse.BRAIN_API_Call_Tracker_Master__c = ' + faResponse.BRAIN_API_Call_Tracker_Master__c +
                                '\n faResponse.BRAIN_ID__c = ' + faResponse.BRAIN_ID__c +
                                '\n faResponse.conversionScenarioId__c = ' + faResponse.conversionScenarioId__c +
                                '\n faResponse.costScenarioId__c = ' + faResponse.costScenarioId__c +
                                '\n faResponse.errorCode__c = ' + faResponse.errorCode__c +
                                '\n faResponse.errorMessage__c = ' + faResponse.errorMessage__c +
                                '\n faResponse.forecastScenario__c = ' + faResponse.forecastScenario__c +
                                '\n faResponse.incremental__c = ' + faResponse.incremental__c +
                                '\n faResponse.investmentFinancialAnalysisId__c = ' + faResponse.investmentFinancialAnalysisId__c +
                                '\n faResponse.Request_ID__c = ' + faResponse.Request_ID__c +
                                '\n faResponse.responseDate__c = ' + faResponse.responseDate__c +
                                '\n faResponse.salesRateScenarioId__c = ' + faResponse.salesRateScenarioId__c +
                                '\n faResponse.status__c = ' + faResponse.status__c +
                                '\n faResponse.survivalScenarioId__c = ' + faResponse.survivalScenarioId__c +
                                '\n faResponse.hl1EvaluationResult__c = ' + faResponse.hl1EvaluationResult__c);
			 *********************************************************************************************************************/
            List<BRAIN_FA_Response__c> faResponseList = new List<BRAIN_FA_Response__c>();
            faResponseList.add(faResponse);
            faResponseList = BRAINFAObjectDMLManager.upsertFAResponseList(faResponseList);
            faResponse = faResponseList?.get(0);
            /********************************************************************************************************************
             *   System.debug('AFTER UPDATE BRAIN_FA_Response >> \n faResponse.Id = ' + faResponse.Id + 
                                '\n faResponse.applicationVersion__c = ' + faResponse.applicationVersion__c +
                                '\n faResponse.baseFinancialAnalysisId__c = ' + faResponse.baseFinancialAnalysisId__c +
                                '\n faResponse.BRAIN_API_Call_Tracker_Master__c = ' + faResponse.BRAIN_API_Call_Tracker_Master__c +
                                '\n faResponse.BRAIN_ID__c = ' + faResponse.BRAIN_ID__c +
                                '\n faResponse.conversionScenarioId__c = ' + faResponse.conversionScenarioId__c +
                                '\n faResponse.costScenarioId__c = ' + faResponse.costScenarioId__c +
                                '\n faResponse.errorCode__c = ' + faResponse.errorCode__c +
                                '\n faResponse.errorMessage__c = ' + faResponse.errorMessage__c +
                                '\n faResponse.forecastScenario__c = ' + faResponse.forecastScenario__c +
                                '\n faResponse.incremental__c = ' + faResponse.incremental__c +
                                '\n faResponse.investmentFinancialAnalysisId__c = ' + faResponse.investmentFinancialAnalysisId__c +
                                '\n faResponse.Request_ID__c = ' + faResponse.Request_ID__c +
                                '\n faResponse.responseDate__c = ' + faResponse.responseDate__c +
                                '\n faResponse.salesRateScenarioId__c = ' + faResponse.salesRateScenarioId__c +
                                '\n faResponse.status__c = ' + faResponse.status__c +
                                '\n faResponse.survivalScenarioId__c = ' + faResponse.survivalScenarioId__c +
                                '\n faResponse.hl1EvaluationResult__c = ' + faResponse.hl1EvaluationResult__c);
            **********************************************************************************************************************/
	        return faResponse;
        } catch(Exception methodX) {
            System.debug('(BRAINFAResponseHelper.populateFAResponseFromJSON) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX
    }//end method populateFAResponseFromJSON
        
    @AuraEnabled
    public static BRAIN_FA_Response__c generateFAResponseHl1EvalResultFromJSON(BRAIN_FA_Response__c faResponse, String responseJSON) {
        try {
            if(faResponse == null) {
                throw new NullResponseOBJException(RESP_OBJ_NULL);
            }//end if NULL faResponse
	        hl1EvaluationResult__c respHL1EvalResult = new hl1EvaluationResult__c();
            Integer hl1EvaluationResultStartIdx = (!String.isBlank(responseJSON) ? responseJSON.indexOf('"hl1EvaluationResult') - 1 : 0);
            Integer buildBOMItemsHl1EvalStartIdx = (!String.isBlank(responseJSON) ? responseJSON.indexOf('"buildBOMItems', hl1EvaluationResultStartIdx) - 1 : 0);
            String segment1ResponseJSON = (!String.isBlank(responseJSON) ? responseJSON.substring(hl1EvaluationResultStartIdx, buildBOMItemsHl1EvalStartIdx) : responseJSON);
            String responseJSONTrimmed = segment1ResponseJSON + ' },';
            if (responseJSONTrimmed.indexOf('"hl1EvaluationResult":') > -1) {
                responseJSONTrimmed = '{' + responseJSONTrimmed.substringBetween('{', '}') + '}';
                /***/  
                System.debug('For hl1EvaluationResult, final responseJSONTrimmed = ' + responseJSONTrimmed); 
                /***/
            }            
            JSONParser responseJSONParser = JSON.createParser(responseJSONTrimmed);
            Integer tokenCtr = 0;
            responseJSONParser.nextToken();
            do {
                responseJSONParser.nextValue();
                /******************************************************************************************************************/
                    System.debug('thisTokenName[' + tokenCtr + '] = ' + responseJSONParser.getCurrentName() );
                    System.debug('thisTokenText[' + tokenCtr + '] = ' + responseJSONParser.getText() );
                 /******************************************************************************************************************/ 
                switch on responseJSONParser.getCurrentName() {
                    when '{' {
                        System.debug('Starting "{" of hl1EvaluationResult');
                    }
                    when '}' {
                        System.debug('Ending "}" of hl1EvaluationResult');
                    }
                    when else {
                        System.debug(SWITCH_DEFAULT);
                    }
                }//end switch
                tokenCtr++;
            } while (responseJSONParser.nextToken() != null); //end while nextToken NOT NULL
            /***  System.debug('After ALL tokens, the tokenCtr = ' + tokenCtr); ***/
                                            
            respHL1EvalResult.BRAIN_FA_Response_Master__c = faResponse?.Id;
            if(faResponse?.Id != null) {
                List<hl1EvaluationResult__c> hl1EvalResultList = new List<hl1EvaluationResult__c>();
                hl1EvalResultList.add(respHL1EvalResult);
                hl1EvalResultList = BRAINFAObjectDMLManager.upsertHL1EvalResultList(hl1EvalResultList);
                respHL1EvalResult = hl1EvalResultList?.get(0);
                /**************************************************************************************************/
                if (respHL1EvalResult != null) {
                    System.debug('AFTER INSERT hl1EvaluationResult >> ' + 
                         '\n respHL1EvalResult.Id = ' + respHL1EvalResult.Id + 
                         '\n respHL1EvalResult.BRAIN_FA_Response_Master__c = ' + respHL1EvalResult.BRAIN_FA_Response_Master__c +
                         '\n respHL1EvalResult.financialMetric__c = ' + respHL1EvalResult.financialMetric__c +
                         '\n respHL1EvalResult.guardrailEvaluation__c = ' + respHL1EvalResult.guardrailEvaluation__c +
                         '\n respHL1EvalResult.buildCost__c = ' + respHL1EvalResult.buildCost__c +
                         '\n respHL1EvalResult.cashFlowPeriod__c = ' + respHL1EvalResult.cashFlowPeriod__c);
                }
                /***********************************************************************************************/              
                faResponse.hl1EvaluationResult__c = respHL1EvalResult?.Id;
            	List<BRAIN_FA_Response__c> faResponseList = new List<BRAIN_FA_Response__c>();
            	faResponseList.add(faResponse);
	            faResponseList = BRAINFAObjectDMLManager.upsertFAResponseList(faResponseList);
            	faResponse = faResponseList?.get(0);
                      /***********************************************************************************************************
                       * 
                       */ System.debug('AFTER UPDATE BRAIN_FA_Response >> \n faResponse.Id = ' + faResponse.Id + 
                       /*            '\n faResponse.applicationVersion__c = ' + faResponse.applicationVersion__c +
                       *            '\n faResponse.baseFinancialAnalysisId__c = ' + faResponse.baseFinancialAnalysisId__c +
                       *            '\n faResponse.BRAIN_API_Call_Tracker_Master__c = ' + faResponse.BRAIN_API_Call_Tracker_Master__c +
                       *            '\n faResponse.BRAIN_ID__c = ' + faResponse.BRAIN_ID__c +
                       *            '\n faResponse.conversionScenarioId__c = ' + faResponse.conversionScenarioId__c +
                       *            '\n faResponse.costScenarioId__c = ' + faResponse.costScenarioId__c +
                       *            '\n faResponse.errorCode__c = ' + faResponse.errorCode__c +
                       *            '\n faResponse.errorMessage__c = ' + faResponse.errorMessage__c +
                       *            '\n faResponse.forecastScenario__c = ' + faResponse.forecastScenario__c +
                       *            '\n faResponse.incremental__c = ' + faResponse.incremental__c +
                       *            '\n faResponse.investmentFinancialAnalysisId__c = ' + faResponse.investmentFinancialAnalysisId__c +
                       *            '\n faResponse.Request_ID__c = ' + faResponse.Request_ID__c +
                       *            '\n faResponse.responseDate__c = ' + faResponse.responseDate__c +
                       *            '\n faResponse.salesRateScenarioId__c = ' + faResponse.salesRateScenarioId__c +
                       *            '\n faResponse.status__c = ' + faResponse.status__c +
                       *            '\n faResponse.survivalScenarioId__c = ' + faResponse.survivalScenarioId__c +
                       */            '\n faResponse.hl1EvaluationResult__c = ' + faResponse.hl1EvaluationResult__c);
                       /****************************************************************************************************************************/
            }            
	        return faResponse;
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.generateFAResponseHl1EvalResultFromJSON) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }//end catch
    }//end method generateFAResponseHl1EvalResultFromJSON
                
    @AuraEnabled
    public static BRAINFARespBuildCostWrap parseJSONForBuildCost(String responseJSON) {
        try {
            if (String.isBlank(responseJSON)) {        
                throw new NullResponseJSONException('EXCEPTION! The ResponseJSON provided was NULL.  No parsing for buildCost could be performed.');    
            }//end if NULL value for responseJSON or for faResponse.Id or for both
            Integer buildCostHl1EvalStartIdx = responseJSON.indexOf('"buildCost":') - 1;
            /***  System.debug('buildCostHl1EvalStartIdx = ' + buildCostHl1EvalStartIdx); ***/
            Integer bomLinesHl1EvalStartIdx = responseJSON.indexOf('"bomLines":', buildCostHl1EvalStartIdx) - 1;
            /***  System.debug('bomLinesHl1EvalStartIdx = ' + bomLinesHl1EvalStartIdx); ***/
            String responseJSONTrimmed = responseJSON.substring(buildCostHl1EvalStartIdx, bomLinesHl1EvalStartIdx);
            /***  System.debug('For buildCost, responseJSONTrimmed = ' + responseJSONTrimmed); ***/
            if (responseJSONTrimmed.indexOf('"buildCost":') > -1) {
                responseJSONTrimmed = '{' + responseJSONTrimmed.substringBetween('{', '}') + '}';
                /***  System.debug('For buildCost, final responseJSONTrimmed = ' + responseJSONTrimmed); ***/
            }
            return BRAINFARespBuildCostWrap.parse(responseJSONTrimmed);
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.parseJSONForBuildCost) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }
    }//end parseJSONForBuildCost    
    
    @AuraEnabled
    public static BRAIN_FA_Response__c generateFAResponseBuildCostFromJSON(BRAIN_FA_Response__c faResponse, String responseJSON, List<hl1EvaluationResult__c> respHL1EvalResList) {
		hl1EvaluationResult__c respHL1EvalResult = new hl1EvaluationResult__c(); 
    	buildCost__c respBuildCost = new buildCost__c();

        try {
            if(faResponse == null) {
                throw new NullResponseOBJException(RESP_OBJ_NULL);
            }//end if NULL faResponse
            /***System.debug('respHL1EvalResList.size() = ' + (respHL1EvalResList != null ? respHL1EvalResList.size() : -1)); ***/
            if(respHL1EvalResList == null || respHL1EvalResList?.size() < 1) {
                throw new ZeroListException(HL1ER_OBJ_NULL);
            }                        
            respHL1EvalResult = respHL1EvalResList.get(0);
            /***System.debug('respHL1EvalResult = ' + respHL1EvalResult + '    AND respHL1EvalResult = ' + (respHL1EvalResult!=null ? respHL1EvalResult.Id : null) );***/
            if(respHL1EvalResult == null || respHL1EvalResult?.Id == null) {
                throw new ZeroListException(HL1ER_OBJ_NULL);
            }                        
            BRAINFARespBuildCostWrap bcWrap = parseJSONForBuildCost(responseJSON);
            //assign hl1eval id to hl1-master id of buildCost then insert buildCost  
            respBuildCost.hl1EvaluationResultMaster__c = respHL1EvalResult.Id;
            respBuildCost.siteCount__c = bcWrap.siteCount;
            respBuildCost.currencyCode__c = bcWrap.currencyCode;
            respBuildCost.projectCapEx__c = bcWrap.projectCapEx;
            respBuildCost.directCapEx__c = bcWrap.directCapEx;
            respBuildCost.sharedCapEx__c = bcWrap.sharedCapEx;
            respBuildCost.opExNRC__c = bcWrap.opExNRC;
            respBuildCost.opExMRC__c = bcWrap.opExMRC;
            respBuildCost.netExSharedMRC__c = bcWrap.netExSharedMRC;
            List<buildCost__c> bcList = new List<buildCost__c>();
            bcList.add(respBuildCost);
            bcList = BRAINFAObjectDMLManager.upsertBuildCostList(bcList);
            respBuildCost = bcList?.get(0);
            /************************************************************************************************************************
             *   System.debug('AFTER INSERT buildCost >> ' +
             *     '\n respBuildCost.Id = ' + respBuildCost.Id +
             *     '\n respBuildCost.hl1EvaluationResultMaster__c = ' + respBuildCost.hl1EvaluationResultMaster__c +
             *     '\n respBuildCost.siteCount__c = ' + respBuildCost.siteCount__c +
             *     '\n respBuildCost.projectCapEx__c = ' + respBuildCost.projectCapEx__c +
             *     '\n respBuildCost.directCapEx__c = ' + respBuildCost.directCapEx__c +
             *     '\n respBuildCost.sharedCapEx__c = ' + respBuildCost.sharedCapEx__c +
             *     '\n respBuildCost.opExNRC__c = ' + respBuildCost.opExNRC__c +
             *     '\n respBuildCost.opExMRC__c = ' + respBuildCost.opExMRC__c +
             *     '\n respBuildCost.netExSharedMRC__c =  = ' + respBuildCost.netExSharedMRC__c);
             **************************************************************************************************************************/
            respHL1EvalResult.buildCost__c = respBuildCost.Id;
            List<hl1EvaluationResult__c> hl1EvalResultList = new List<hl1EvaluationResult__c>();
            hl1EvalResultList.add(respHL1EvalResult);
            hl1EvalResultList = BRAINFAObjectDMLManager.upsertHL1EvalResultList(hl1EvalResultList);
            respHL1EvalResult = hl1EvalResultList?.get(0);
            /**********************************************************************************************************
             *   System.debug('AFTER UPDATE hl1EvaluationResult >> ' + 
             *     '\n respHL1EvalResult.Id = ' + respHL1EvalResult.Id + 
             *     '\n respHL1EvalResult.BRAIN_FA_Response_Master__c = ' + respHL1EvalResult.BRAIN_FA_Response_Master__c +
             *     '\n respHL1EvalResult.financialMetric__c = ' + respHL1EvalResult.financialMetric__c +
             *     '\n respHL1EvalResult.guardrailEvaluation__c = ' + respHL1EvalResult.guardrailEvaluation__c +
             *     '\n respHL1EvalResult.buildCost__c = ' + respHL1EvalResult.buildCost__c +
             *     '\n respHL1EvalResult.cashFlowPeriod__c = ' + respHL1EvalResult.cashFlowPeriod__c);
             ************************************************************************************************************/                
            faResponse.hl1EvaluationResult__c = respHL1EvalResult.Id;
            List<BRAIN_FA_Response__c> faResponseList = new List<BRAIN_FA_Response__c>();
            faResponseList.add(faResponse);
            faResponseList = BRAINFAObjectDMLManager.upsertFAResponseList(faResponseList);
            faResponse = faResponseList?.get(0);
            /************************************************************************************************************
             *   System.debug('AFTER UPDATE BRAIN_FA_Response >> \n faResponse.Id = ' + faResponse.Id + 
             *     '\n faResponse.applicationVersion__c = ' + faResponse.applicationVersion__c +
             *     '\n faResponse.baseFinancialAnalysisId__c = ' + faResponse.baseFinancialAnalysisId__c +
             *     '\n faResponse.BRAIN_API_Call_Tracker_Master__c = ' + faResponse.BRAIN_API_Call_Tracker_Master__c +
             *     '\n faResponse.BRAIN_ID__c = ' + faResponse.BRAIN_ID__c +
             *     '\n faResponse.conversionScenarioId__c = ' + faResponse.conversionScenarioId__c +
             *     '\n faResponse.costScenarioId__c = ' + faResponse.costScenarioId__c +
             *     '\n faResponse.errorCode__c = ' + faResponse.errorCode__c +
             *     '\n faResponse.errorMessage__c = ' + faResponse.errorMessage__c +
             *     '\n faResponse.forecastScenario__c = ' + faResponse.forecastScenario__c +
             *     '\n faResponse.incremental__c = ' + faResponse.incremental__c +
             *     '\n faResponse.investmentFinancialAnalysisId__c = ' + faResponse.investmentFinancialAnalysisId__c +
             *     '\n faResponse.Request_ID__c = ' + faResponse.Request_ID__c +
             *     '\n faResponse.responseDate__c = ' + faResponse.responseDate__c +
             *     '\n faResponse.salesRateScenarioId__c = ' + faResponse.salesRateScenarioId__c +
             *     '\n faResponse.status__c = ' + faResponse.status__c +
             *     '\n faResponse.survivalScenarioId__c = ' + faResponse.survivalScenarioId__c +
             *     '\n faResponse.hl1EvaluationResult__c = ' + faResponse.hl1EvaluationResult__c);
             ****************************************************************************************************************************/
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.generateFAResponseBuildCostFromJSON) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }//end catch
        
        return faResponse;
    }//end method generateFAResponseBuildCostFromJSON
        
    @AuraEnabled
    public static List<cashFlowPeriod__c> parseJSONForCashFlowPeriods(String responseJSON, hl1EvaluationResult__c respHL1EvalResult) {
        Decimal totalRevenue = 0.0;
        Decimal totalOpEx = 0.0;
        Decimal totalCapExDirect = 0.0;
        Decimal totalCapExSharedGamma = 0.0;
        Decimal totalIncomeTax = 0.0;        
        
        try {
            if (String.isBlank(responseJSON)) {
                throw new NullResponseJSONException('EXCEPTION! The ResponseJSON provided was NULL.  No parsing for cashFlowPeriod could be performed.');    
            }//end if NULL value for responseJSON or for faResponse.Id or for both
	        List<cashFlowPeriod__c> respCashFlowPeriods = new List<cashFlowPeriod__c>();
            Integer cashFlowPeriodsHl1EvalStartIdx = responseJSON.indexOf('"cashFlowPeriods') - 1;
            Integer cashFlowPeriodsHl1EvalEndIdx = responseJSON.indexOf('],', cashFlowPeriodsHl1EvalStartIdx) + 1;
            String responseJSONTrimmed = responseJSON.substring(cashFlowPeriodsHl1EvalStartIdx, cashFlowPeriodsHl1EvalEndIdx);
            /***  System.debug('For cashFlowPeriods, responseJSONTrimmed = ' + responseJSONTrimmed); ***/
            if (responseJSONTrimmed.indexOf('"cashFlowPeriods":') > -1) {
                responseJSONTrimmed = '{' + responseJSONTrimmed + '}';
                /***  System.debug('For cashFlowPeriods, final responseJSONTrimmed = ' + responseJSONTrimmed); ***/
            }
            BRAINFARespCashFlowPeriodsWrap cfpWrap = BRAINFARespCashFlowPeriodsWrap.parse(responseJSONTrimmed);
            
            cashFlowPeriod__c thisCFP = new cashFlowPeriod__c();
            boolean alreadyDetermined1stYrEbitda = false;
            boolean alreadyDetermined1stYrPosCashFlow = false;
            List<BRAINFARespCashFlowPeriodsWrap.CashFlowPeriod> periods = cfpWrap.cashFlowPeriods;
            for (BRAINFARespCashFlowPeriodsWrap.CashFlowPeriod period : periods) {
                thisCFP = new cashFlowPeriod__c();
                if (!alreadyDetermined1stYrEbitda && ((totalRevenue - totalOpEx) > 0) ) {
                    /***  System.debug('For cashFlowPeriods, (totalRevenue - totalOpEx) > 0 in contractMonth = ' + thisCFP.contractMonth__c); ***/
                    Decimal cMth = thisCFP.contractMonth__c;
                    respHL1EvalResult.firstYrOfPositiveEBITDA__c = determineYearBasedOnContractMonth(cMth);
                    alreadyDetermined1stYrEbitda = true;
                }//end if (totalRevenue - totalOpEx) > 0 AND NOT alreadyDetermined1stYrEbitda
                
                if (!alreadyDetermined1stYrPosCashFlow && (totalRevenue > (totalOpEx + totalCapExDirect + totalCapExSharedGamma + totalIncomeTax)) ) {
                    /***  System.debug('For cashFlowPeriods, totalRevenue > (totalOpEx + totalCapExDirect + totalCapExSharedGamma + totalIncomeTax) in contractMonth = ' + thisCFP.contractMonth__c); ***/
                    Decimal cMth = thisCFP.contractMonth__c;
                    respHL1EvalResult.firstYrOfPositiveCashFlow__c = determineYearBasedOnContractMonth(cMth);
                    alreadyDetermined1stYrPosCashFlow = true;
                }//end if totalRevenue >  (totalOpEx + totalCapExDirect + totalCapExSharedGamma + totalIncomeTax) AND NOT alreadyDetermined1stYrPosCashFlow                                                        
                
                thisCFP.revenue__c = period.revenue;
                totalRevenue += period.revenue;
                
                thisCFP.opEx__c = period.opEx;
                totalOpEx += period.opEx;
                
                thisCFP.capExDirect__c = period.capExDirect;
                totalCapExDirect += period.capExDirect;
                
                thisCFP.capExSharedGammaAdjusted__c = period.capExSharedGammaAdjusted;
                totalCapExSharedGamma += period.capExSharedGammaAdjusted;
                
                thisCFP.incomeTax__c = period.incomeTax;
                totalIncomeTax += period.incomeTax;                
                
                thisCFP.contractMonth__c = period.contractMonth;
                respCashFlowPeriods.add(thisCFP);
            }                    
	        return respCashFlowPeriods;
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.parseJSONForCashFlowPeriods) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }
    }//end parseJSONForCashFlowPeriods    

    @AuraEnabled
    public static BRAIN_FA_Response__c generateFAResponseCashFlowPeriodsFromJSON(BRAIN_FA_Response__c faResponse, String responseJSON, List<hl1EvaluationResult__c> respHL1EvalResList) {
        try {
            if(faResponse == null) {
                throw new NullResponseOBJException(RESP_OBJ_NULL);
            }//end else NULL faResponse
            /***System.debug('respHL1EvalResList.size() = ' + (respHL1EvalResList != null ? respHL1EvalResList.size() : -1)); ***/
            if(respHL1EvalResList == null || respHL1EvalResList.size() < 1) {
                throw new ZeroListException(HL1ER_OBJ_NULL);
            }            
            hl1EvaluationResult__c respHL1EvalResult = respHL1EvalResList.get(0);
            /***System.debug('respHL1EvalResult = ' + respHL1EvalResult + '    AND respHL1EvalResult.Id = ' + (respHL1EvalResult!=null ? respHL1EvalResult.Id : null) );***/
            
            List<cashFlowPeriod__c> respCashFlowPeriods = parseJSONForCashFlowPeriods(responseJSON, respHL1EvalResult);
            
            //assign hl1eval id to hl1-master id of each cash-flow-period then insert each cashFlowPeriod
            System.debug('# of CashFlowPeriods examined = ' + respCashFlowPeriods.size());
            cashFlowPeriod__c respCFP = new cashFlowPeriod__c();
            if(respHL1EvalResult != null && respHL1EvalResult.Id != null) {
                for (cashFlowPeriod__c cashFP : respCashFlowPeriods) {
                    cashFP.hl1EvaluationResultMaster__c = respHL1EvalResult.Id;
                    respCFP = cashFP;
                                /**********************************************************************************
                                 *  System.debug('AFTER INSERT cashFlowPeriod >> ' + 
                                 *    '\n cashFP.Id = ' + cashFP.Id + 
                                 *    '\n cashFP.hl1EvaluationResultMaster__c = ' + cashFP.hl1EvaluationResultMaster__c + 
                                 *    '\n cashFP.contractMonth__c = ' + cashFP.contractMonth__c +
                                 *    '\n cashFP.currency__c = ' + cashFP.currency__c +
                                 *    '\n cashFP.revenue__c = ' + cashFP.revenue__c +
                                 *    '\n cashFP.netExDirect__c = ' + cashFP.netExDirect__c +
                                 *    '\n cashFP.netExShared__c = ' + cashFP.netExShared__c +
                                 *    '\n cashFP.opEx__c = ' + cashFP.opEx__c + 
                                 *    '\n cashFP.capExDirect__c = ' + cashFP.capExDirect__c +
                                 *    '\n cashFP.capExSharedGammaAdjusted__c = ' + cashFP.capExSharedGammaAdjusted__c +
                                 *    '\n cashFP.incomeTax__c = ' + cashFP.incomeTax__c);
                                *******************************************************************************/
                }
                respCashFlowPeriods = BRAINFAObjectDMLManager.upsertCashFlowPeriodList(respCashFlowPeriods);
                
                respHL1EvalResult.cashFlowPeriod__c = respCashFlowPeriods.size() > 0 ? respCashFlowPeriods.get(0).Id : respCFP.Id;
                List<hl1EvaluationResult__c> hl1EvalResultList = new List<hl1EvaluationResult__c>();
                hl1EvalResultList.add(respHL1EvalResult);
                hl1EvalResultList = BRAINFAObjectDMLManager.upsertHL1EvalResultList(hl1EvalResultList);
                respHL1EvalResult = hl1EvalResultList?.get(0);
                            /**************************************
                             *   System.debug('AFTER UPDATE hl1EvaluationResult >> ' + 
                                         '\n respHL1EvalResult.Id = ' + respHL1EvalResult.Id + 
                                         '\n respHL1EvalResult.BRAIN_FA_Response_Master__c = ' + respHL1EvalResult.BRAIN_FA_Response_Master__c +
                                         '\n respHL1EvalResult.financialMetric__c = ' + respHL1EvalResult.financialMetric__c +
                                         '\n respHL1EvalResult.guardrailEvaluation__c = ' + respHL1EvalResult.guardrailEvaluation__c +
                                         '\n respHL1EvalResult.buildCost__c = ' + respHL1EvalResult.buildCost__c +
                                         '\n respHL1EvalResult.cashFlowPeriod__c = ' + respHL1EvalResult.cashFlowPeriod__c);
                             *****************************************/            
                faResponse.hl1EvaluationResult__c = respHL1EvalResult.Id;
                List<BRAIN_FA_Response__c> faResponseList = new List<BRAIN_FA_Response__c>();
                faResponseList.add(faResponse);
                faResponseList = BRAINFAObjectDMLManager.upsertFAResponseList(faResponseList);
                faResponse = faResponseList?.get(0);
                            /******************************
                             *   System.debug('AFTER UPDATE BRAIN_FA_Response >> \n faResponse.Id = ' + faResponse.Id + 
                                        '\n faResponse.applicationVersion__c = ' + faResponse.applicationVersion__c +
                                        '\n faResponse.baseFinancialAnalysisId__c = ' + faResponse.baseFinancialAnalysisId__c +
                                        '\n faResponse.BRAIN_API_Call_Tracker_Master__c = ' + faResponse.BRAIN_API_Call_Tracker_Master__c +
                                        '\n faResponse.BRAIN_ID__c = ' + faResponse.BRAIN_ID__c +
                                        '\n faResponse.conversionScenarioId__c = ' + faResponse.conversionScenarioId__c +
                                        '\n faResponse.costScenarioId__c = ' + faResponse.costScenarioId__c +
                                        '\n faResponse.errorCode__c = ' + faResponse.errorCode__c +
                                        '\n faResponse.errorMessage__c = ' + faResponse.errorMessage__c +
                                        '\n faResponse.forecastScenario__c = ' + faResponse.forecastScenario__c +
                                        '\n faResponse.incremental__c = ' + faResponse.incremental__c +
                                        '\n faResponse.investmentFinancialAnalysisId__c = ' + faResponse.investmentFinancialAnalysisId__c +
                                        '\n faResponse.Request_ID__c = ' + faResponse.Request_ID__c +
                                        '\n faResponse.responseDate__c = ' + faResponse.responseDate__c +
                                        '\n faResponse.salesRateScenarioId__c = ' + faResponse.salesRateScenarioId__c +
                                        '\n faResponse.status__c = ' + faResponse.status__c +
                                        '\n faResponse.survivalScenarioId__c = ' + faResponse.survivalScenarioId__c +
                                        '\n faResponse.hl1EvaluationResult__c = ' + faResponse.hl1EvaluationResult__c);
                               ************************************/
            }        
	        return faResponse;
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.generateFAResponseCashFlowPeriodsFromJSON) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }//end catch
    }//end method generateFAResponseCashFlowPeriodsFromJSON
        
    @AuraEnabled
    public static BRAIN_FA_Response__c generateFAResponseFinMetricFromJSON(BRAIN_FA_Response__c faResponse, String responseJSON, List<hl1EvaluationResult__c> respHL1EvalResList) {
        try {
            /***/
            System.debug('faResponse == null? ' + (faResponse == null) + '  AND faResponse?.Id = ' + faResponse?.Id); 
            /***/
            if(faResponse == null) {
                throw new NullResponseOBJException(RESP_OBJ_NULL);
            }//end if NULL faResponse
            /***/
            System.debug('respHL1EvalResList == null? ' + (respHL1EvalResList == null) + '  AND respHL1EvalResList?.size() = ' + respHL1EvalResList?.size()); 
            /***/
            if(respHL1EvalResList == null || respHL1EvalResList.size() < 1) {
                throw new ZeroListException(HL1ER_LIST_NULL);
            }
            hl1EvaluationResult__c respHL1EvalResult = respHL1EvalResList.get(0);
            /***/
            System.debug('respHL1EvalResult == null? ' + (respHL1EvalResult == null) + '    AND respHL1EvalResult?.Id = ' + respHL1EvalResult?.Id);
            /***/

            if(respHL1EvalResult == null || respHL1EvalResult.Id == null) {
                throw new NullHl1EvalResultOBJException(HL1ER_OBJ_NULL);
            }
            financialMetric__c respFinMetric = new financialMetric__c();
            respFinMetric.hl1EvaluationResultMaster__c = respHL1EvalResult.Id;
            /***/
            System.debug('respFinMetric == null? ' + (respFinMetric == null) + '    AND respFinMetric?.hl1EvaluationResultMaster__c = ' + respFinMetric?.hl1EvaluationResultMaster__c);
            /***/
            List<financialMetric__c> fmList = new List<financialMetric__c>();
            fmList.add(respFinMetric);
            fmList = BRAINFAObjectDMLManager.upsertFinMetricList(fmList);
            respFinMetric = fmList?.get(0);
            System.debug('respFinMetric = ' + respFinMetric + '    AND respFinMetric.Id = ' + (respFinMetric!=null ? respFinMetric.Id : null) );
            
            respHL1EvalResult.financialMetric__c = respFinMetric.Id;
            List<hl1EvaluationResult__c> hl1EvalResultList = new List<hl1EvaluationResult__c>();
            hl1EvalResultList.add(respHL1EvalResult);
            hl1EvalResultList = BRAINFAObjectDMLManager.upsertHL1EvalResultList(hl1EvalResultList);
            respHL1EvalResult = hl1EvalResultList?.get(0);
                        /********************************************************
                         *   System.debug('AFTER UPDATE hl1EvaluationResult >> ' + 
                                    '\n respHL1EvalResult.Id = ' + respHL1EvalResult.Id + 
                                    '\n respHL1EvalResult.BRAIN_FA_Response_Master__c = ' + respHL1EvalResult.BRAIN_FA_Response_Master__c +
                                    '\n respHL1EvalResult.financialMetric__c = ' + respHL1EvalResult.financialMetric__c +
                                    '\n respHL1EvalResult.guardrailEvaluation__c = ' + respHL1EvalResult.guardrailEvaluation__c +
                                    '\n respHL1EvalResult.buildCost__c = ' + respHL1EvalResult.buildCost__c +
                                    '\n respHL1EvalResult.cashFlowPeriod__c = ' + respHL1EvalResult.cashFlowPeriod__c);
                         ********************************************************/            
            faResponse.hl1EvaluationResult__c = respHL1EvalResult.Id;                
            List<BRAIN_FA_Response__c> faResponseList = new List<BRAIN_FA_Response__c>();
            faResponseList.add(faResponse);
            faResponseList = BRAINFAObjectDMLManager.upsertFAResponseList(faResponseList);
            faResponse = faResponseList?.get(0);
                        /**************************************************************
                         *   System.debug('AFTER UPDATE BRAIN_FA_Response >> \n faResponse.Id = ' + faResponse.Id + 
                                    '\n faResponse.applicationVersion__c = ' + faResponse.applicationVersion__c +
                                    '\n faResponse.baseFinancialAnalysisId__c = ' + faResponse.baseFinancialAnalysisId__c +
                                    '\n faResponse.BRAIN_API_Call_Tracker_Master__c = ' + faResponse.BRAIN_API_Call_Tracker_Master__c +
                                    '\n faResponse.BRAIN_ID__c = ' + faResponse.BRAIN_ID__c +
                                    '\n faResponse.conversionScenarioId__c = ' + faResponse.conversionScenarioId__c +
                                    '\n faResponse.costScenarioId__c = ' + faResponse.costScenarioId__c +
                                    '\n faResponse.errorCode__c = ' + faResponse.errorCode__c +
                                    '\n faResponse.errorMessage__c = ' + faResponse.errorMessage__c +
                                    '\n faResponse.forecastScenario__c = ' + faResponse.forecastScenario__c +
                                    '\n faResponse.incremental__c = ' + faResponse.incremental__c +
                                    '\n faResponse.investmentFinancialAnalysisId__c = ' + faResponse.investmentFinancialAnalysisId__c +
                                    '\n faResponse.Request_ID__c = ' + faResponse.Request_ID__c +
                                    '\n faResponse.responseDate__c = ' + faResponse.responseDate__c +
                                    '\n faResponse.salesRateScenarioId__c = ' + faResponse.salesRateScenarioId__c +
                                    '\n faResponse.status__c = ' + faResponse.status__c +
                                    '\n faResponse.survivalScenarioId__c = ' + faResponse.survivalScenarioId__c +
                                    '\n faResponse.hl1EvaluationResult__c = ' + faResponse.hl1EvaluationResult__c);
                         ******************************************/
	        return faResponse;
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.generateFAResponseFinMetricFromJSON) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }//end catch
    }//end method generateFAResponseFinMetricFromJSON
        
    @AuraEnabled
    public static BRAINFARespIncomeStmtWrap parseJSONForIncomeStatementMetric(String responseJSON) {
        try {
            if (String.isBlank(responseJSON)) {
                throw new NullResponseJSONException('EXCEPTION! The ResponseJSON provided was NULL.  No parsing for incomeStatementMetric could be performed.');    
            }//end else NULL value for responseJSON
            Integer incomeStatementMetricStartIdx = responseJSON.indexOf('"incomeStatementMetric') - 1;
            Integer incomeStatementMetricEndIdx = responseJSON.indexOf('},', incomeStatementMetricStartIdx) + 2;
            String responseJSONTrimmed = responseJSON.substring(incomeStatementMetricStartIdx, incomeStatementMetricEndIdx);
            System.debug('For incomeStatementMetric, responseJSONTrimmed = ' + responseJSONTrimmed);
            if (responseJSONTrimmed.indexOf('"incomeStatementMetric":') > -1) {
                responseJSONTrimmed = '{' + responseJSONTrimmed.substringBetween('{', '}') + '}';
                System.debug('For incomeStatementMetric, final responseJSONTrimmed = ' + responseJSONTrimmed);
            }
            return BRAINFARespIncomeStmtWrap.parse(responseJSONTrimmed);
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.parseJSONForIncomeStatementMetric) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }
    }//end parseJSONForIncomeStatementMetric    

    @AuraEnabled
    public static BRAIN_FA_Response__c generateFAResponseIncStmtMetricFromJSON(BRAIN_FA_Response__c faResponse, String responseJSON, List<hl1EvaluationResult__c> respHL1EvalResList, List<financialMetric__c> respFinMetricList) {
        try {
            if(faResponse == null) {
                throw new NullResponseOBJException(RESP_OBJ_NULL);
            }//end else NULL faResponse
            /***System.debug('respHL1EvalResList.size() = ' + (respHL1EvalResList != null ? respHL1EvalResList.size() : -1)); ***/
            if(respHL1EvalResList == null || respHL1EvalResList.size() < 1) {
                throw new ZeroListException('EXCEPTION! The ResponseHL1EvaluationResult-List had 0 records.  There is nothing there to process.');
            }                        
            hl1EvaluationResult__c respHL1EvalResult = respHL1EvalResList.get(0);
            /***System.debug('respHL1EvalResult = ' + respHL1EvalResult + '    AND respHL1EvalResult = ' + (respHL1EvalResult!=null ? respHL1EvalResult.Id : null) );***/
                    
            if(respFinMetricList == null && respFinMetricList.size() < 1) {
                throw new ZeroListException('EXCEPTION! The financialMetric-List had 0 records.  There is nothing there to process.');
            }                        
            financialMetric__c respFinMetric = respFinMetricList.get(0);
            if(respHL1EvalResult == null || respHL1EvalResult.Id == null) {
                throw new NullHl1EvalResultOBJException(HL1ER_OBJ_NULL);
            }
            respHL1EvalResult.financialMetric__c = respFinMetric != null ? respFinMetric.Id : null;
            List<hl1EvaluationResult__c> hl1EvalResultList = new List<hl1EvaluationResult__c>();
            hl1EvalResultList.add(respHL1EvalResult);
            hl1EvalResultList = BRAINFAObjectDMLManager.upsertHL1EvalResultList(hl1EvalResultList);
            respHL1EvalResult = hl1EvalResultList?.get(0);
            
            BRAINFARespIncomeStmtWrap ismWrap = parseJSONForIncomeStatementMetric(responseJSON);
	        incomeStatementMetric__c respIncStmtMetric = new incomeStatementMetric__c();
            respIncStmtMetric.currency__c = ismWrap.currencyCode;    
            respIncStmtMetric.revenue__c = ismWrap.revenue;
            respIncStmtMetric.netExDirect__c = ismWrap.netExDirect;
            respIncStmtMetric.netExShared__c = ismWrap.netExShared;
            respIncStmtMetric.grossMargin__c = ismWrap.grossMargin;
            respIncStmtMetric.grossMarginPct__c = ismWrap.grossMarginPct;
            respIncStmtMetric.opEx__c = ismWrap.opEx;
            respIncStmtMetric.ebitda__c = ismWrap.ebitda;
            respIncStmtMetric.ebitdaPct__c = ismWrap.ebitdaPct;
            respIncStmtMetric.capExDirect__c = ismWrap.capExDirect;
            respIncStmtMetric.capExSharedGammaAdjusted__c = ismWrap.capExSharedGammaAdjusted;
            respIncStmtMetric.ebitdaLessCapEx__c = ismWrap.ebitdaLessCapEx;
            respIncStmtMetric.ebitdaLessCapExPct__c = ismWrap.ebitdaLessCapExPct;
            respIncStmtMetric.incomeTax__c = ismWrap.incomeTax;
            
            //assign hl1eval.financialMetric id to financialMetricMaster id of incomeStatementMetric then insert incomeStatementMetric                  
            respIncStmtMetric.financialMetricMaster__c = respFinMetric != null ? respFinMetric.Id : null;
            List<incomeStatementMetric__c> ismList = new List<incomeStatementMetric__c>();
            ismList.add(respIncStmtMetric);
            ismList = BRAINFAObjectDMLManager.upsertIncStmtList(ismList);
            respIncStmtMetric = ismList?.get(0);
                            /***********************
                             *   System.debug('AFTER INSERT incomeStatementMetric >> ' + 
                                        '\n respIncStmtMetric.Id = ' + respIncStmtMetric.Id + 
                                        '\n respIncStmtMetric.financialMetricMaster__c = ' + respIncStmtMetric.financialMetricMaster__c +
                                        '\n respIncStmtMetric.currency__c = ' + respIncStmtMetric.currency__c + 
                                        '\n respIncStmtMetric.revenue__c = ' + respIncStmtMetric.revenue__c + 
                                        '\n respIncStmtMetric.netExDirect__c = ' + respIncStmtMetric.netExDirect__c + 
                                        '\n respIncStmtMetric.netExShared__c = ' + respIncStmtMetric.netExShared__c + 
                                        '\n respIncStmtMetric.grossMargin__c = ' + respIncStmtMetric.grossMargin__c + 
                                        '\n respIncStmtMetric.grossMarginPct__c = ' + respIncStmtMetric.grossMarginPct__c + 
                                        '\n respIncStmtMetric.opEx__c = ' + respIncStmtMetric.opEx__c + 
                                        '\n respIncStmtMetric.ebitda__c = ' + respIncStmtMetric.ebitda__c + 
                                        '\n respIncStmtMetric.ebitdaPct__c = ' + respIncStmtMetric.ebitdaPct__c + 
                                        '\n respIncStmtMetric.capExDirect__c = ' + respIncStmtMetric.capExDirect__c + 
                                        '\n respIncStmtMetric.capExSharedGammaAdjusted__c = ' + respIncStmtMetric.capExSharedGammaAdjusted__c + 
                                        '\n respIncStmtMetric.ebitdaLessCapEx__c = ' + respIncStmtMetric.ebitdaLessCapEx__c + 
                                        '\n respIncStmtMetric.ebitdaLessCapExPct__c = ' + respIncStmtMetric.ebitdaLessCapExPct__c + 
                                        '\n respIncStmtMetric.incomeTax__c = ' + respIncStmtMetric.incomeTax__c);
                             ************************************************************************************/
                            
            respFinMetric.incomeStatementMetric__c = respIncStmtMetric.Id;
            List<financialMetric__c> fmList = new List<financialMetric__c>();
            fmList.add(respFinMetric);
            fmList = BRAINFAObjectDMLManager.upsertFinMetricList(fmList);
            respFinMetric = fmList?.get(0);
                            /************************************************
                             *   System.debug('AFTER UPDATE financialMetric__c >> ' +
                                        '\n respFinMetric.Id = ' + respFinMetric.Id + 
                                        '\n respFinMetric.hl1EvaluationResultMaster__c = ' + respFinMetric.hl1EvaluationResultMaster__c +
                                        '\n respFinMetric.incomeStatementMetric__c = ' + respFinMetric.incomeStatementMetric__c + 
                                        '\n respFinMetric.cashFlowMetric__c = ' + respFinMetric.cashFlowMetric__c); 
                             ***********************************************/
            faResponse.hl1EvaluationResult__c = respHL1EvalResult.Id;                
            List<BRAIN_FA_Response__c> faResponseList = new List<BRAIN_FA_Response__c>();
            faResponseList.add(faResponse);
            faResponseList = BRAINFAObjectDMLManager.upsertFAResponseList(faResponseList);
            faResponse = faResponseList?.get(0);
                            /******************************************************
                             *   System.debug('AFTER UPDATE BRAIN_FA_Response >> \n faResponse.Id = ' + faResponse.Id + 
                                        '\n faResponse.applicationVersion__c = ' + faResponse.applicationVersion__c +
                                        '\n faResponse.baseFinancialAnalysisId__c = ' + faResponse.baseFinancialAnalysisId__c +
                                        '\n faResponse.BRAIN_API_Call_Tracker_Master__c = ' + faResponse.BRAIN_API_Call_Tracker_Master__c +
                                        '\n faResponse.BRAIN_ID__c = ' + faResponse.BRAIN_ID__c +
                                        '\n faResponse.conversionScenarioId__c = ' + faResponse.conversionScenarioId__c +
                                        '\n faResponse.costScenarioId__c = ' + faResponse.costScenarioId__c +
                                        '\n faResponse.errorCode__c = ' + faResponse.errorCode__c +
                                        '\n faResponse.errorMessage__c = ' + faResponse.errorMessage__c +
                                        '\n faResponse.forecastScenario__c = ' + faResponse.forecastScenario__c +
                                        '\n faResponse.incremental__c = ' + faResponse.incremental__c +
                                        '\n faResponse.investmentFinancialAnalysisId__c = ' + faResponse.investmentFinancialAnalysisId__c +
                                        '\n faResponse.Request_ID__c = ' + faResponse.Request_ID__c +
                                        '\n faResponse.responseDate__c = ' + faResponse.responseDate__c +
                                        '\n faResponse.salesRateScenarioId__c = ' + faResponse.salesRateScenarioId__c +
                                        '\n faResponse.status__c = ' + faResponse.status__c +
                                        '\n faResponse.survivalScenarioId__c = ' + faResponse.survivalScenarioId__c +
                                        '\n faResponse.hl1EvaluationResult__c = ' + faResponse.hl1EvaluationResult__c);
                                ******************************************************************/
	        return faResponse;
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.generateFAResponseIncStmtMetricFromJSON) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }//end catch        
    }//end method generateFAResponseIncStmtMetricFromJSON
        
    @AuraEnabled
    public static BRAINFARespCashFlowMetricWrap parseJSONForCashFlowMetric(String responseJSON) {
        try {
            if (String.isBlank(responseJSON)) {
                throw new NullResponseJSONException('EXCEPTION! The ResponseJSON provided was NULL.  No parsing for cashFlowMetric could be performed.');    
            }//end if NULL value for responseJSON
            Integer cashFlowMetricStartIdx = responseJSON.indexOf('"cashFlowMetric') - 1;
            Integer cashFlowMetricEndIdx = responseJSON.indexOf('},', cashFlowMetricStartIdx) + 2;
            String responseJSONTrimmed = responseJSON.substring(cashFlowMetricStartIdx, cashFlowMetricEndIdx);
            /***  System.debug('For cashFlowMetric, responseJSONTrimmed = ' + responseJSONTrimmed); ***/
            if (responseJSONTrimmed.indexOf('"cashFlowMetric":') > -1) {
                responseJSONTrimmed = '{' + responseJSONTrimmed.substringBetween('{', '}') + '}';
                /***  System.debug('For cashFlowMetric, final responseJSONTrimmed = ' + responseJSONTrimmed); ***/
            }
            return BRAINFARespCashFlowMetricWrap.parse(responseJSONTrimmed);
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.parseJSONForCashFlowMetric) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }        
    }//end parseJSONForCashFlowMetric    
    
    @AuraEnabled
    public static BRAIN_FA_Response__c generateFAResponseCashFlowMetricFromJSON(BRAIN_FA_Response__c faResponse, String responseJSON, List<hl1EvaluationResult__c> respHL1EvalResList, List<financialMetric__c> respFinMetricList) {
        try {
            if(faResponse == null) {
                throw new NullResponseOBJException(RESP_OBJ_NULL);
            }//end if NULL faResponse
            /***System.debug('respHL1EvalResList.size() = ' + (respHL1EvalResList != null ? respHL1EvalResList.size() : -1)); ***/
            if(respHL1EvalResList == null || respHL1EvalResList.size() < 1) {
                throw new ZeroListException(HL1ER_OBJ_NULL);
            }//end if NULL or 0-size hl1EvalList                
            hl1EvaluationResult__c respHL1EvalResult = respHL1EvalResList.get(0);
            /***System.debug('respHL1EvalResult = ' + respHL1EvalResult + '    AND respHL1EvalResult = ' + (respHL1EvalResult!=null ? respHL1EvalResult.Id : null) );***/
                    
            if(respFinMetricList == null || respFinMetricList.size() < 1) {
                throw new ZeroListException('EXCEPTION! The financialMetric-List had 0 records.  There is nothing there to process.');
            }                        
            financialMetric__c respFinMetric = respFinMetricList.get(0);
            if(respHL1EvalResult == null || respHL1EvalResult.Id == null) {
                throw new NullHl1EvalResultOBJException(HL1ER_OBJ_NULL);
            }
            respHL1EvalResult.financialMetric__c = respFinMetric != null ? respFinMetric.Id : null;
            List<hl1EvaluationResult__c> hl1EvalResultList = new List<hl1EvaluationResult__c>();
            hl1EvalResultList.add(respHL1EvalResult);
            hl1EvalResultList = BRAINFAObjectDMLManager.upsertHL1EvalResultList(hl1EvalResultList);
            respHL1EvalResult = hl1EvalResultList?.get(0);
            
            BRAINFARespCashFlowMetricWrap cfmWrap = parseJSONForCashFlowMetric(responseJSON);
            cashFlowMetric__c respCashFlowMetric = new cashFlowMetric__c();
            
            //assign hl1eval.financialMetric id to financialMetricMaster id of cashFlowMetric then insert cashFlowMetric  
            respCashFlowMetric.financialMetricMaster__c = respFinMetric != null ? respFinMetric.Id : null; 
            respCashFlowMetric.currency__c = cfmWrap.currencyCode;
            respCashFlowMetric.netPresentValue__c = cfmWrap.netPresentValue;
            respCashFlowMetric.discountedPaybackPeriodMonths__c = cfmWrap.discountPaybackPeriodMonths;
            respCashFlowMetric.simplePaybackPeriodMonths__c = cfmWrap.simplePaybackPeriodMonths;
            respCashFlowMetric.internalRateOfReturn__c = cfmWrap.internalRateOfReturn;
            respCashFlowMetric.averageContractTermMonths__c = cfmWrap.averageContractTermMonths;
            
            List<cashFlowMetric__c> cfmList = new List<cashFlowMetric__c>();
            cfmList.add(respCashFlowMetric);
            cfmList = BRAINFAObjectDMLManager.upsertCashFlowMetricList(cfmList);
            respCashFlowMetric = cfmList?.get(0);
                            /******************************
                             *   System.debug('AFTER INSERT cashFlowMetric__c >> ' + 
                                        '\n respCashFlowMetric.Id = ' + respCashFlowMetric.Id + 
                                        '\n respCashFlowMetric.financialMetricMaster__c = ' + respCashFlowMetric.financialMetricMaster__c +
                                        '\n respCashFlowMetric.currency__c = ' + respCashFlowMetric.currency__c +
                                        '\n respCashFlowMetric.netPresentValue__c = ' + respCashFlowMetric.netPresentValue__c +
                                        '\n respCashFlowMetric.discountedPaybackPeriodMonths__c = ' + respCashFlowMetric.discountedPaybackPeriodMonths__c +
                                        '\n respCashFlowMetric.simplePaybackPeriodMonths__c = ' + respCashFlowMetric.simplePaybackPeriodMonths__c +
                                        '\n respCashFlowMetric.internalRateOfReturn__c = ' + respCashFlowMetric.internalRateOfReturn__c + 
                                        '\n respCashFlowMetric.averageContractTermMonths__c = ' + respCashFlowMetric.averageContractTermMonths__c);
                             ***********************************************/
            respFinMetric.cashFlowMetric__c = respCashFlowMetric.Id;
            List<financialMetric__c> fmList = new List<financialMetric__c>();
            fmList.add(respFinMetric);
            fmList = BRAINFAObjectDMLManager.upsertFinMetricList(fmList);
            respFinMetric = fmList?.get(0);
                            /****************************
                             *   System.debug('AFTER UPDATE financialMetric__c >> ' +
                                        '\n respFinMetric.Id = ' + respFinMetric.Id + 
                                        '\n respFinMetric.hl1EvaluationResultMaster__c = ' + respFinMetric.hl1EvaluationResultMaster__c +
                                        '\n respFinMetric.incomeStatementMetric__c = ' + respFinMetric.incomeStatementMetric__c + 
                                        '\n respFinMetric.cashFlowMetric__c = ' + respFinMetric.cashFlowMetric__c); 
                             ******************************/         
                            
            faResponse.hl1EvaluationResult__c = respHL1EvalResult.Id;
            List<BRAIN_FA_Response__c> faResponseList = new List<BRAIN_FA_Response__c>();
            faResponseList.add(faResponse);
            faResponseList = BRAINFAObjectDMLManager.upsertFAResponseList(faResponseList);
            faResponse = faResponseList?.get(0);
                            /************************
                             *   System.debug('AFTER UPDATE BRAIN_FA_Response >> \n faResponse.Id = ' + faResponse.Id + 
                                        '\n faResponse.applicationVersion__c = ' + faResponse.applicationVersion__c +
                                        '\n faResponse.baseFinancialAnalysisId__c = ' + faResponse.baseFinancialAnalysisId__c +
                                        '\n faResponse.BRAIN_API_Call_Tracker_Master__c = ' + faResponse.BRAIN_API_Call_Tracker_Master__c +
                                        '\n faResponse.BRAIN_ID__c = ' + faResponse.BRAIN_ID__c +
                                        '\n faResponse.conversionScenarioId__c = ' + faResponse.conversionScenarioId__c +
                                        '\n faResponse.costScenarioId__c = ' + faResponse.costScenarioId__c +
                                        '\n faResponse.errorCode__c = ' + faResponse.errorCode__c +
                                        '\n faResponse.errorMessage__c = ' + faResponse.errorMessage__c +
                                        '\n faResponse.forecastScenario__c = ' + faResponse.forecastScenario__c +
                                        '\n faResponse.incremental__c = ' + faResponse.incremental__c +
                                        '\n faResponse.investmentFinancialAnalysisId__c = ' + faResponse.investmentFinancialAnalysisId__c +
                                        '\n faResponse.Request_ID__c = ' + faResponse.Request_ID__c +
                                        '\n faResponse.responseDate__c = ' + faResponse.responseDate__c +
                                        '\n faResponse.salesRateScenarioId__c = ' + faResponse.salesRateScenarioId__c +
                                        '\n faResponse.status__c = ' + faResponse.status__c +
                                        '\n faResponse.survivalScenarioId__c = ' + faResponse.survivalScenarioId__c +
                                        '\n faResponse.hl1EvaluationResult__c = ' + faResponse.hl1EvaluationResult__c);
                             ***************************************************/
	        return faResponse;
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.generateFAResponseCashFlowMetricFromJSON) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }//end catch
    }//end method generateFAResponseCashFlowMetricFromJSON
        
    @AuraEnabled
    public static BRAINFARespGuardrailEvalWrap parseJSONForGuardrailEvaluation(String responseJSON) {
        try {
            if (String.isBlank(responseJSON)) {
                throw new NullResponseJSONException('EXCEPTION! The ResponseJSON provided was NULL.  No parsing for guardrailEvaluation could be performed.');    
            }//end if NULL value for responseJSON
            Integer guardrailEvaluationStartIdx = responseJSON.indexOf('"guardrailEvaluation') - 1;
            Integer guardrailEvaluationEndIdx = responseJSON.indexOf('},', guardrailEvaluationStartIdx) + 2;
            String responseJSONTrimmed = responseJSON.substring(guardrailEvaluationStartIdx, guardrailEvaluationEndIdx);
            /***  System.debug('For guardrailEvaluation, responseJSONTrimmed = ' + responseJSONTrimmed); ***/
            if (responseJSONTrimmed.indexOf('"guardrailEvaluation":') > -1) {
                responseJSONTrimmed = '{' + responseJSONTrimmed.substringBetween('{', '}') + '}';
                /***  System.debug('For guardrailEvaluation, final responseJSONTrimmed = ' + responseJSONTrimmed); ***/
            }
            return BRAINFARespGuardrailEvalWrap.parse(responseJSONTrimmed);
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.parseJSONForGuardrailEvaluation) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }
    }//end parseJSONForGuardrailEvaluation    

    @AuraEnabled
    public static BRAIN_FA_Response__c generateFAResponseGuardrailEvalFromJSON(BRAIN_FA_Response__c faResponse, String responseJSON, List<hl1EvaluationResult__c> respHL1EvalResList) {
        try {
            if(faResponse == null) {
                throw new NullResponseOBJException(RESP_OBJ_NULL);
            }//end else NULL faResponse
            respHL1EvalResList = BRAINFAObjectSOQLManager.queryAssocHl1EvalList(faResponse.Id, respHL1EvalResList?.get(0)?.Id);
            System.debug('respHL1EvalResList.size() = ' + (respHL1EvalResList != null ? respHL1EvalResList.size() : -1)); 
            if(respHL1EvalResList == null || respHL1EvalResList.size() < 1) {
                throw new ZeroListException(HL1ER_OBJ_NULL);
            }//end else NOT respHL1EvalResList.size >= 1
            hl1EvaluationResult__c respHL1EvalResult = respHL1EvalResList.get(0);
            System.debug('respHL1EvalResult = ' + respHL1EvalResult + '    AND respHL1EvalResult = ' + (respHL1EvalResult!=null ? respHL1EvalResult.Id : null) );
            
            BRAINFARespGuardrailEvalWrap geWrap = parseJSONForGuardrailEvaluation(responseJSON);
            
            if(respHL1EvalResult == null || respHL1EvalResult.Id == null) {
                throw new NullHl1EvalResultOBJException(HL1ER_OBJ_NULL);
            }
            //assign hl1eval id to hl1-master id of guardrail then insert guardrail  
	        guardrailEvaluation__c respGuardrailEval = new guardrailEvaluation__c();
            respGuardrailEval.resultCode__c = geWrap.resultCode;
            respGuardrailEval.displayMessage__c = geWrap.displayMessage;
            respGuardrailEval.simplePaybackPeriodThresholdMonths__c = geWrap.simplePaybackPeriodThresholdMonths;
            respGuardrailEval.currencyCode__c = geWrap.currencyCode;
            respGuardrailEval.incrementalATCToMeetGuardrail__c = geWrap.incrementalATCToMeetGuardrail;
            respGuardrailEval.hl1EvaluationResultMaster__c = respHL1EvalResult.Id;
            List<guardrailEvaluation__c> geList = new List<guardrailEvaluation__c>();
            geList.add(respGuardrailEval);
            geList = BRAINFAObjectDMLManager.upsertGuardrailEvalList(geList);
            respGuardrailEval = geList?.get(0);
                        /**************************
                         *   System.debug('AFTER INSERT guardrailEvaluation >> ' + 
                                    '\n respGuardrailEval.Id = ' + respGuardrailEval.Id + 
                                    '\n respGuardrailEval.hl1EvaluationResultMaster__c = ' + respGuardrailEval.hl1EvaluationResultMaster__c + 
                                    '\n respGuardrailEval.resultCode__c = ' + respGuardrailEval.resultCode__c +
                                    '\n respGuardrailEval.displayMessage__c = ' + respGuardrailEval.displayMessage__c +
                                    '\n respGuardrailEval.simplePaybackPeriodThresholdMonths__c = ' + respGuardrailEval.simplePaybackPeriodThresholdMonths__c +
                                    '\n respGuardrailEval.currencyCode__c = ' + respGuardrailEval.currencyCode__c +
                                    '\n respGuardrailEval.incrementalATCToMeetGuardrail__c = ' + respGuardrailEval.incrementalATCToMeetGuardrail__c);
                         **********************************/
            respHL1EvalResult.guardrailEvaluation__c = respGuardrailEval.Id;
            List<hl1EvaluationResult__c> hl1EvalResultList = new List<hl1EvaluationResult__c>();
            hl1EvalResultList.add(respHL1EvalResult);
            hl1EvalResultList = BRAINFAObjectDMLManager.upsertHL1EvalResultList(hl1EvalResultList);
            respHL1EvalResult = hl1EvalResultList?.get(0);
                        /******************************************************
                         *   System.debug('AFTER UPDATE hl1EvaluationResult >> ' + 
                                    '\n respHL1EvalResult.Id = ' + respHL1EvalResult.Id + 
                                    '\n respHL1EvalResult.BRAIN_FA_Response_Master__c = ' + respHL1EvalResult.BRAIN_FA_Response_Master__c +
                                    '\n respHL1EvalResult.financialMetric__c = ' + respHL1EvalResult.financialMetric__c +
                                    '\n respHL1EvalResult.guardrailEvaluation__c = ' + respHL1EvalResult.guardrailEvaluation__c +
                                    '\n respHL1EvalResult.buildCost__c = ' + respHL1EvalResult.buildCost__c +
                                    '\n respHL1EvalResult.cashFlowPeriod__c = ' + respHL1EvalResult.cashFlowPeriod__c);
                         **************************************************************************/            
            faResponse.hl1EvaluationResult__c = respHL1EvalResult.Id;
            List<BRAIN_FA_Response__c> faResponseList = new List<BRAIN_FA_Response__c>();
            faResponseList.add(faResponse);
            faResponseList = BRAINFAObjectDMLManager.upsertFAResponseList(faResponseList);
            faResponse = faResponseList?.get(0);
                        /***************************************************************************************************
                         *   System.debug('AFTER UPDATE BRAIN_FA_Response >> \n faResponse.Id = ' + faResponse.Id + 
                                    '\n faResponse.applicationVersion__c = ' + faResponse.applicationVersion__c +
                                    '\n faResponse.baseFinancialAnalysisId__c = ' + faResponse.baseFinancialAnalysisId__c +
                                    '\n faResponse.BRAIN_API_Call_Tracker_Master__c = ' + faResponse.BRAIN_API_Call_Tracker_Master__c +
                                    '\n faResponse.BRAIN_ID__c = ' + faResponse.BRAIN_ID__c +
                                    '\n faResponse.conversionScenarioId__c = ' + faResponse.conversionScenarioId__c +
                                    '\n faResponse.costScenarioId__c = ' + faResponse.costScenarioId__c +
                                    '\n faResponse.errorCode__c = ' + faResponse.errorCode__c +
                                    '\n faResponse.errorMessage__c = ' + faResponse.errorMessage__c +

                                    '\n faResponse.incremental__c = ' + faResponse.incremental__c +
                                    '\n faResponse.investmentFinancialAnalysisId__c = ' + faResponse.investmentFinancialAnalysisId__c +
                                    '\n faResponse.Request_ID__c = ' + faResponse.Request_ID__c +
                                    '\n faResponse.responseDate__c = ' + faResponse.responseDate__c +
                                    '\n faResponse.salesRateScenarioId__c = ' + faResponse.salesRateScenarioId__c +
                                    '\n faResponse.status__c = ' + faResponse.status__c +
                                    '\n faResponse.survivalScenarioId__c = ' + faResponse.survivalScenarioId__c +
                                    '\n faResponse.hl1EvaluationResult__c = ' + faResponse.hl1EvaluationResult__c);
                         ******************************************************************************************************/
	        return faResponse;
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFAResponseHelper.generateFAResponseGuardrailEvalFromJSON) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }//end catch
    }//end method generateFAResponseGuardrailEvalFromJSON

    private static Integer determineYearBasedOnContractMonth(Decimal cMth) {
        return (cMth <= 120 ? (cMth.divide(12, 3, System.RoundingMode.CEILING)).intValue() : null);
    }//end method determineYearBasedOnContractMonth
}//end class BRAINFAResponseHelper