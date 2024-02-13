/***************************************************************************************************
 * Name:  BRAINFinancialAnalysesResponseController
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for Response aspect of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFinancialAnalysesResponseController -- 88%  05/12/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 05/06/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version
 * 06/03/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Response-Only version (split off from original)
 * 11/10/2022   T2Cabato    Feature(Epic) ESCJ-1946			Converting to Queueable for ESCJ-1744 Automatic Trigger on CapDes Status Planner Design Complete
 * 01/27/2023   T2Cabato    Story ESCJ-2365                 Revised per Story
 * 06/13/2023   T2Cabato    QFCJ-3801                       BRAIN-AutoSubmit-Messaging
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
 * 08/02/2023   T2Cabato    QFCJ-4286                       BRAIN-Drop-Cost-Fix
 * 08/15/2023   T2Cabato    QFCJ-4282                       BRAIN-ONT-Model-Mapping
 * 08/15/2023   T2Cabato    QFCJ-4297                       BRAIN-UPS-Shelf-to-idfElectronics-for-BRAIN
 * 08/15/2023   T2Cabato    QFCJ-4309                       BRAIN-ContractType-and-OtherProviderContractType-Mapping
 * 09/28/2023   T2Cabato    QFCJ-4625/26/27/28              BRAIN-Financial-Analysis-Failures
****************************************************************************************************/
public with sharing class BRAINFinancialAnalysesResponseController implements Queueable, Database.AllowsCallouts {
    public class InvalidParameterParsingException extends Exception {}
    public class CallNotFoundForResponseException extends Exception {}
    public String rcFARequestId;
    public String rcResponseJSON;
    public String rcCallSource;
    public List<BRAINFinancialAnalysesResponseController.ResponseParams> rcResponseParamsList;
    public List<List<BRAIN_API_Call_Tracker__c>> trackerCallListCollection;
    public BRAIN_API_Call_Tracker__c callTracker;
    
    public BRAINFinancialAnalysesResponseController(String faRequestIdIn, String responseJSONIn, String callSourceIn) { 
        this.rcFARequestId = faRequestIdIn;
        this.rcResponseJSON = responseJSONIn;
        this.rcCallSource = callSourceIn;

        //Create list of parameters to be sent to assembleResponseFinancialAnalyses
        this.rcResponseParamsList = new List<BRAINFinancialAnalysesResponseController.ResponseParams>();
        BRAINFinancialAnalysesResponseController.ResponseParams rp = new BRAINFinancialAnalysesResponseController.ResponseParams();
        rp.faRequestId = this.rcFARequestId;
        rp.responseJSON = this.rcResponseJSON;
        rp.callSource = this.rcCallSource;
        rcResponseParamsList.add(rp);
    }//end constructor
   
    public void execute(QueueableContext ctx) { 
        this.trackerCallListCollection = automatedAssembleResponseFinancialAnalyses(this.rcResponseParamsList);
        if (this.trackerCallListCollection != null && this.trackerCallListCollection.size() > 0  && this.trackerCallListCollection.get(0) != null && this.trackerCallListCollection.get(0).size() > 0) {
            this.callTracker = this.trackerCallListCollection.get(0).get(0);
            System.debug('(BRAINFinancialAnalysesResponseController.execute) this.rcFARequestId = ' + this.rcFARequestId + '\n this.callTracker.Name = ' + this.callTracker.Name + '\n this.callSource = ' + this.rcCallSource);
            BRAINFinancialAnalysesUpdateController updateController = new BRAINFinancialAnalysesUpdateController(this.callTracker.Capital_Design__c, this.callTracker.Id, this.rcCallSource);
            if(Test.isRunningTest()) {
                updateController.execute(null);
            } else {
                String updateJobId = System.enqueueJob(updateController);
                System.debug('(BRAINFinancialAnalysesResponseController.execute) updateJobId = ' + updateJobId);
            }
        }
        this.clearState();
    }//end method execute
    
    public class ResponseParams {
        @invocableVariable(label='FARequest Id' description='The id of the BRAIN_FA_Request__c record' required=true)
        public String faRequestId;
        @invocableVariable(label='Response JSON' description='The JSON-Body of the results of returned from Calling BRAIN API Financial Analyses' required=true)
        public String responseJSON;
        @invocableVariable(label='Call Source' description='The source from which the Call was being made (Offer, APVOffer, CapitalDesign)' required=true)
        public String callSource;
    }

    @InvocableMethod(label='Assemble Response from results returned from BRAIN Financial Analyses'
                     description='Assemble Response based on results returned from callout to BRAIN Financial Analyses tool to request financial viability and related analysis details'
                     category='BRAIN API Call Tracker')
    public static List<List<BRAIN_API_Call_Tracker__c>> assembleResponseFinancialAnalyses(List<ResponseParams> responseParams) {        
        List<List<BRAIN_API_Call_Tracker__c>> trackerCallListCollection = new List<List<BRAIN_API_Call_Tracker__c>>();
        List<BRAIN_API_Call_Tracker__c> trackerCallList = new List<BRAIN_API_Call_Tracker__c>();
        List<BRAIN_API_Call_Tracker__c> faCallList = new List<BRAIN_API_Call_Tracker__c>();
        BRAIN_API_Call_Tracker__c faCall = new BRAIN_API_Call_Tracker__c();
        BRAIN_FA_Response__c  faResponse = new BRAIN_FA_Response__c();
        String faRequestId = null;
        String responseJSON = null;
        String callSource = null;

        try {
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) Starting with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Parsing responseParams with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            //Extract parameters into the key variables
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) responseParams.size() = ' + (responseParams != null ? responseParams.size() : 0) );
            faRequestId = responseParams.get(0).faRequestId;
            responseJSON = responseParams.get(0).responseJSON;
            callSource = responseParams.get(0).callSource;
            responseParams = null;
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Parsing responseParams with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) faRequestId = ' + faRequestId +
                          '\n responseJSON = ' + responseJSON + '\n callSource = ' + callSource);
            
            if (String.isBlank(faRequestId) || String.isBlank(responseJSON) || String.isBlank(callSource)) {
                throw new InvalidParameterParsingException();
            }
    /*********************************************************************************************************
     * Next steps: 1. RESPONSE will be parsed and stored in faResponse object and its subobjects
     *             2. BRAIN_API_Call_Tracker__c associated to the incoming parameter BRAIN_FA_Request__c.Id is updated
     *             3. Return the BRAIN_API_Call_Tracker__c associated to this request for Financial Analyses
     *             4. From the calling flow, Data will then be dispersed to the Capital_Design__c object and Offer__c object per mapping
     *********************************************************************************************************/            
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Querying faCallList with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            faCallList = BRAINFAObjectSOQLManager.queryBACTListByRequestId(faRequestId);
            faCall = (faCallList != null ? faCallList.get(0) : new BRAIN_API_Call_Tracker__c() );
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) faCall.Id = ' + (faCall != null ? faCall.Id : null) );
            faCallList = null;
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Querying faCallList with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Create baseFAResponse with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            //create and insert a base BRAIN_FA_Response associated to the master/parent faCall by faCall.Id
            faResponse = BRAINFAResponseHelper.createBaseFAResponse(faCall);
            System.debug('JUMP-START!  After createBaseFAResponse, ' + checkResponseForId(faResponse));
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Create baseFAResponse with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            String faResponseId = getIdFromResponse(faResponse);

            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Populate faResponseFromJSON with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            //parse the returned data results into the relative Response object and subobjects with inserts
            /*** BRAIN_FA_Response__c prePopBkupResp = faResponse; ***/
            faResponse = BRAINFAResponseHelper.populateFAResponseFromJSON(faResponse, responseJSON);
            System.debug('FOLLOWING populateFAResponseFromJSON, ' + checkResponseForId(faResponse));
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Populate faResponseFromJSON with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            faResponseId = getIdFromResponse(faResponse);

            //  check if response is NOT NULL and error_code__c is blank, then should have the data necessary to build out the hl1EvalResults from the response
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) faResponse is NULL? ' + (faResponse==null) + '   AND faResponse?.errorCode__c = ' + faResponse?.errorCode__c + '  AND Is faResponse?.errorCode__c is NULL? ' + (faResponse?.errorCode__c==null));
            if (faResponse != null && (faResponse.errorCode__c == 'null' || faResponse.errorCode__c == null)) {
	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Generate Hl1EvalResult with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                /*** BRAIN_FA_Response__c preHL1ERBkupResp = faResponse;   ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseHl1EvalResultFromJSON(faResponse, responseJSON);
                System.debug('CHECK-HL1ER generateFAResponseHl1EvalResultFromJSON, ' + checkResponseForId(faResponse));
	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Generate Hl1EvalResult with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                faResponseId = getIdFromResponse(faResponse);
                List<hl1EvaluationResult__c> respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);

	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Generate BuildCost with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                /*** BRAIN_FA_Response__c preBuildCostBkupResp = faResponse;  ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseBuildCostFromJSON(faResponse, responseJSON, respHL1EvalResList);
                System.debug('CHECK-BC generateFAResponseBuildCostFromJSON, ' + checkResponseForId(faResponse));
	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Generate BuildCost with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                faResponseId = getIdFromResponse(faResponse);
                respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);

	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Generate CashFlowPeriods with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                /**** BRAIN_FA_Response__c preCashFlowPeriodBkupResp = faResponse;  ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseCashFlowPeriodsFromJSON(faResponse, responseJSON, respHL1EvalResList);
                System.debug('CHECK-CFP generateFAResponseCashFlowPeriodsFromJSON, ' + checkResponseForId(faResponse));
	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Generate CashFlowPeriods with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                faResponseId = getIdFromResponse(faResponse);
                respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);

	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Generate FinancialMetric with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                /**** BRAIN_FA_Response__c preFinMetricBkupResp = faResponse;  ****/
                faResponse = BRAINFAResponseHelper.generateFAResponseFinMetricFromJSON(faResponse, responseJSON, respHL1EvalResList);
                System.debug('CHECK-FM generateFAResponseFinMetricFromJSON, ' + checkResponseForId(faResponse));
	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Generate FinancialMetric with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                faResponseId = getIdFromResponse(faResponse);                
                respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);
                Id respHL1EvalId = getIdFromHL1EvalResult(respHL1EvalResList);
                List<financialMetric__c> respFinMetricList = BRAINFAObjectSOQLManager.queryFinMetricByHl1EvalResId(respHL1EvalId);

	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Generate IncomeStatementMetric with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                /*** BRAIN_FA_Response__c preIncStmtBkupResp = faResponse; ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseIncStmtMetricFromJSON(faResponse, responseJSON, respHL1EvalResList, respFinMetricList);
                System.debug('CHECK-ISM generateFAResponseIncStmtMetricFromJSON, ' + checkResponseForId(faResponse));
	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Generate IncomeStatementMetric with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                faResponseId = getIdFromResponse(faResponse);
                respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);
                respHL1EvalId = getIdFromHL1EvalResult(respHL1EvalResList);
                respFinMetricList = BRAINFAObjectSOQLManager.queryFinMetricByHl1EvalResId(respHL1EvalId);

	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Generate CashFlowMetric with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                /*** BRAIN_FA_Response__c preCashFlowMetricBkupResp = faResponse;  ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseCashFlowMetricFromJSON(faResponse, responseJSON, respHL1EvalResList, respFinMetricList);
                System.debug('CHECK-CFM generateFAResponseCashFlowMetricFromJSON, ' + checkResponseForId(faResponse));
	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Generate CashFlowMetric with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                faResponseId = getIdFromResponse(faResponse);
                respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);

	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Generate GuardrailEvaluation with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                /*** BRAIN_FA_Response__c preGrdrailEvalBkupResp = faResponse;  ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseGuardrailEvalFromJSON(faResponse, responseJSON, respHL1EvalResList);
                System.debug('CHECK-GE generateFAResponseGuardrailEvalFromJSON, ' + checkResponseForId(faResponse));
	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Generate GuardrailEvaluation with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                faResponseId = getIdFromResponse(faResponse);
            
            /******************************************************************************
             * 
             *  BRAIN_FA_Response__c finalComposedFAResponse = BRAINFAObjectSOQLManager.queryForFinalFAResponse(faResponseId);
             * 
             *  String faHl1EvalResId = (faResponse != null ? faResponse.hl1EvaluationResult__c : ' ');
             *  String compHl1EvalResId = (finalComposedFAResponse != null ? finalComposedFAResponse.hl1EvaluationResult__c : ' ');
             *  hl1EvaluationResult__c hl1EvalResult =  BRAINFAObjectSOQLManager.queryForFinalHl1EvalResult(faResponseId, compHl1EvalResId);
             *  String hl1EvalResId = (hl1EvalResult != null ? hl1EvalResult.Id : ' ');
             *  buildCost__c buildCost = BRAINFAObjectSOQLManager.queryForFinalBuildCost(hl1EvalResId, compHl1EvalResId, faHl1EvalResId);
             *  List<cashFlowPeriod__c> cashFlowPeriods =  BRAINFAObjectSOQLManager.queryForFinalCashFlowPeriodList(hl1EvalResId, compHl1EvalResId, faHl1EvalResId);
             *  financialMetric__c finMetric =  BRAINFAObjectSOQLManager.queryForFinalFinMetric(hl1EvalResId, compHl1EvalResId, faHl1EvalResId);
             *                             
             *  String finMetricId = (finMetric != null ? finMetric.Id : ' ');
             *  incomeStatementMetric__c incStmtMetric = BRAINFAObjectSOQLManager.queryForFinalIncStmtMetric(finMetricId);
             *  cashFlowMetric__c cashFlowMetric = BRAINFAObjectSOQLManager.queryForFinalCashFlowMetric(finMetricId);
             *  guardrailEvaluation__c guardrailEval = BRAINFAObjectSOQLManager.queryForFinalGuardrailEval(hl1EvalResId, compHl1EvalResId, faHl1EvalResId);
             * 
             *****************************************************************************/

                /*  If you uncomment this System.debug, be sure to account for potential null objects!
                 *         
                System.debug('The final composed BRAIN_FA_Response__c object consists of the following:' +
                                     '\n\t Id = ' + finalComposedFAResponse.Id +
                                     '\n\t Name = ' + finalComposedFAResponse.Name +
                                     '\n\t applicationVersion__c = ' + finalComposedFAResponse.applicationVersion__c +
                                     '\n\t baseFinancialAnalysisId__c = ' + finalComposedFAResponse.baseFinancialAnalysisId__c +
                                     '\n\t BRAIN_API_Call_Tracker_Master__c = ' + finalComposedFAResponse.BRAIN_API_Call_Tracker_Master__c +
                                     '\n\t BRAIN_ID__c = ' + finalComposedFAResponse.BRAIN_ID__c +
                                     '\n\t conversionScenarioId__c = ' + finalComposedFAResponse.conversionScenarioId__c +
                                     '\n\t costScenarioId__c = ' + finalComposedFAResponse.costScenarioId__c + 
                                     '\n\t errorCode__c = ' + finalComposedFAResponse.errorCode__c +
                                     '\n\t errorMessage__c = ' + finalComposedFAResponse.errorMessage__c +
                                     '\n\t forecastScenario__c = ' + finalComposedFAResponse.forecastScenario__c +
                                     '\n\t incremental__c = ' + finalComposedFAResponse.incremental__c + 
                                     '\n\t investmentFinancialAnalysisId__c = ' + finalComposedFAResponse.investmentFinancialAnalysisId__c +
                                     '\n\t Request_ID__C = ' + finalComposedFAResponse.Request_ID__c +
                                     '\n\t responseDate__c = ' + finalComposedFAResponse.responseDate__c + 
                                     '\n\t salesRateScenarioId__c = ' + finalComposedFAResponse.salesRateScenarioId__c +
                                     '\n\t status__c = ' + finalComposedFAResponse.status__c +
                                     '\n\t hl1EvalResult.Id = ' + hl1EvalResult.Id + 
                                     '\n\t hl1EvalResult.Name = ' + hl1EvalResult.Name +
                                     '\n\t hl1EvalResult.BRAIN_FA_Response_Master__c = ' + hl1EvalResult.BRAIN_FA_Response_Master__c +
                                     '\n\t hl1EvalResult.firstYrOfPositiveCashFlow__c = ' + hl1EvalResult.firstYrOfPositiveCashFlow__c +
                                     '\n\t hl1EvalResult.firstYrOfPositiveEBITDA__c = ' + hl1EvalResult.firstYrOfPositiveEBITDA__c +
                                     '\n\t hl1EvalResult.totalOpExCashFlowPeriods__c = ' + hl1EvalResult.totalOpExCashFlowPeriods__c +
                                     '\n\t hl1EvalResult.totalRevenueCashFlowPeriods__c = ' + hl1EvalResult.totalRevenueCashFlowPeriods__c +
                                     '\n\t hl1EvalResult.endingMRC__c = ' + hl1EvalResult.endingMRC__c +
                                     '\n\t hl1EvalResult.buildCost__c = ' + hl1EvalResult.buildCost__c +
                                     '\n\t hl1EvalResult.cashFlowPeriod__c = ' + hl1EvalResult.cashFlowPeriod__c +
                                     '\n\t hl1EvalResult.financialMetric__c = ' + hl1EvalResult.financialMetric__c +
                                     '\n\t hl1EvalResult.guardrailEvaluation__c = ' + hl1EvalResult.guardrailEvaluation__c +
                                     '\n\t buildCost.Id = ' + buildCost.Id +
                                     '\n\t buildCost.Name = ' + buildCost.Name +
                                     '\n\t buildCost.hl1EvaluationResultMaster__c = ' + buildCost.hl1EvaluationResultMaster__c +
                                     '\n\t buildCost.siteCount__c = ' + buildCost.siteCount__c +
                                     '\n\t buildCost.projectCapEx__c = ' + buildCost.projectCapEx__c +
                                     '\n\t buildCost.directCapEx__c = ' + buildCost.directCapEx__c +
                                     '\n\t buildCost.sharedCapEx__c = ' + buildCost.sharedCapEx__c +
                                     '\n\t buildCost.opExNRC__c = ' + buildCost.opExNRC__c +
                                     '\n\t buildCost.opExMRC__c = ' + buildCost.opExMRC__c +
                                     '\n\t buildCost.netExSharedMRC__c = ' + buildCost.netExSharedMRC__c +
                                     '\n\t cashFlowPeriods.get(0).Id = ' + cashFlowPeriods.get(0).Id +
                                     '\n\t cashFlowPeriods.get(0).Name = ' + cashFlowPeriods.get(0).Name +
                                     '\n\t cashFlowPeriods.get(0).hl1EvaluationResultMaster__c = ' + cashFlowPeriods.get(0).hl1EvaluationResultMaster__c +
                                     '\n\t cashFlowPeriods.get(0).contractMonth__c = ' + cashFlowPeriods.get(0).contractMonth__c +
                                     '\n\t cashFlowPeriods.get(0).currency__c = ' + cashFlowPeriods.get(0).currency__c +
                                     '\n\t cashFlowPeriods.get(0).revenue__c = ' + cashFlowPeriods.get(0).revenue__c +
                                     '\n\t cashFlowPeriods.get(0).netExDirect__c = ' + cashFlowPeriods.get(0).netExDirect__c +
                                     '\n\t cashFlowPeriods.get(0).netExShared__c = ' + cashFlowPeriods.get(0).netExShared__c +
                                     '\n\t cashFlowPeriods.get(0).opEx__c = ' + cashFlowPeriods.get(0).opEx__c +
                                     '\n\t cashFlowPeriods.get(0).capExDirect__c = ' + cashFlowPeriods.get(0).capExDirect__c +
                                     '\n\t cashFlowPeriods.get(0).capExSharedGammaAdjusted__c = ' + cashFlowPeriods.get(0).capExSharedGammaAdjusted__c +
                                     '\n\t cashFlowPeriods.get(0).incomeTax__c = ' + cashFlowPeriods.get(0).incomeTax__c +
                                     '\n\t cashFlowPeriods.size() = ' + cashFlowPeriods.size() +
                                     '\n\t finMetric.Id = ' + finMetric.Id +
                                     '\n\t finMetric.Name = ' + finMetric.Name +
                                     '\n\t finMetric.incomeStatementMetric__c = ' + finMetric.incomeStatementMetric__c +
                                     '\n\t finMetric.cashFlowMetric__c = ' + finMetric.cashFlowMetric__c +
                                     '\n\t incStmtMetric.Id = ' + incStmtMetric.Id +
                                     '\n\t incStmtMetric.Name = ' + incStmtMetric.Name +
                                     '\n\t incStmtMetric.financialMetricMaster__c = ' + incStmtMetric.financialMetricMaster__c +
                                     '\n\t incStmtMetric.currency__c = ' + incStmtMetric.currency__c +
                                     '\n\t incStmtMetric.revenue__c = ' + incStmtMetric.revenue__c +
                                     '\n\t incStmtMetric.netExDirect__c = ' + incStmtMetric.netExDirect__c +
                                     '\n\t incStmtMetric.netExShared__c = ' + incStmtMetric.netExShared__c +
                                     '\n\t incStmtMetric.grossMargin__c = ' + incStmtMetric.grossMargin__c +
                                     '\n\t incStmtMetric.grossMarginPct__c = ' + incStmtMetric.grossMarginPct__c +
                                     '\n\t incStmtMetric.opEx__c = ' + incStmtMetric.opEx__c +
                                     '\n\t incStmtMetric.ebitda__c = ' + incStmtMetric.ebitda__c +
                                     '\n\t incStmtMetric.ebitdaPct__c = ' + incStmtMetric.ebitdaPct__c +
                                     '\n\t incStmtMetric.capExDirect__c = ' + incStmtMetric.capExDirect__c +
                                     '\n\t incStmtMetric.capExSharedGammaAdjusted__c = ' + incStmtMetric.capExSharedGammaAdjusted__c +
                                     '\n\t incStmtMetric.ebitdaLessCapEx__c = ' + incStmtMetric.ebitdaLessCapEx__c +
                                     '\n\t incStmtMetric.ebitdaLessCapExPct__c = ' + incStmtMetric.ebitdaLessCapExPct__c +
                                     '\n\t incStmtMetric.incomeTax__c = ' + incStmtMetric.incomeTax__c +
                                     '\n\t cashFlowMetric.Id = ' + cashFlowMetric.Id +
                                     '\n\t cashFlowMetric.Name = ' + cashFlowMetric.Name +
                                     '\n\t cashFlowMetric.financialMetricMaster__c = ' + cashFlowMetric.financialMetricMaster__c +
                                     '\n\t cashFlowMetric.currency__c = ' + cashFlowMetric.currency__c +
                                     '\n\t cashFlowMetric.netPresentValue__c = ' + cashFlowMetric.netPresentValue__c +
                                     '\n\t cashFlowMetric.discountedPaybackPeriodMonths__c = ' + cashFlowMetric.discountedPaybackPeriodMonths__c +
                                     '\n\t cashFlowMetric.simplePaybackPeriodMonths__c = ' + cashFlowMetric.simplePaybackPeriodMonths__c +
                                     '\n\t cashFlowMetric.internalRateOfReturn__c = ' + cashFlowMetric.internalRateOfReturn__c +
                                     '\n\t cashFlowMetric.averageContractTermMonths__c = ' + cashFlowMetric.averageContractTermMonths__c +
                                     '\n\t guardrailEval.Id = ' + guardrailEval.Id +
                                     '\n\t guardrailEval.Name = ' + guardrailEval.Name +
                                     '\n\t guardrailEval.hl1EvaluationResultMaster__c = ' + guardrailEval.hl1EvaluationResultMaster__c +
                                     '\n\t guardrailEval.resultCode__c = ' + guardrailEval.resultCode__c +
                                     '\n\t guardrailEval.displayMessage__c = ' + guardrailEval.displayMessage__c +
                                     '\n\t guardrailEval.simplePaybackPeriodThresholdMonths__c = ' + guardrailEval.simplePaybackPeriodThresholdMonths__c +
                                     '\n\t guardrailEval.currencyCode__c = ' + guardrailEval.currencyCode__c +
                                     '\n\t guardrailEval.incrementalATCToMeetGuardrail__c = ' + guardrailEval.incrementalATCToMeetGuardrail__c +
                                     '\n\r\n\r\n\r\n\r');
                   */     
            }//end if No ERRORs (errorCode__c was NULL)

            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Assembling Final Call-Tracker with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            //Get the updated BRAIN_API_Call_Tracker__c object associated with this request
            String faCallId = (faCall != null ? faCall.Id : ' ');
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) faCallId = ' + faCallId);
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Querying Final Call-Tracker with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            trackerCallList =  BRAINFAObjectSOQLManager.queryForFinalTracker(faCallId);
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Querying Final Call-Tracker with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            if (trackerCallList != null && trackerCallList.size() > 0 && trackerCallList.get(0) != null) {
	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) trackerCallList.get(0) is NULL? ' + (trackerCallList.get(0)==null) +
                            '\n Id = ' + trackerCallList.get(0).Id +
                            '\n Name = ' + trackerCallList.get(0).Name +
                            '\n CapDesignId = ' + trackerCallList.get(0).Capital_Design__c +
                            '\n CapDesignName = ' + trackerCallList.get(0).Capital_Design__r.Name +
                            '\n OfferId = ' + trackerCallList.get(0).Offer__c +
                            '\n OfferName = ' + trackerCallList.get(0).Offer__r.Name +
                            '\n RequesId = ' + trackerCallList.get(0).BRAIN_FA_Request__c +
                            '\n RequestName = ' + trackerCallList.get(0).BRAIN_FA_Request__r.Name +
                            '\n ResponseId = ' + trackerCallList.get(0).BRAIN_FA_Response__c +
                            '\n ResponseName = ' + trackerCallList.get(0).BRAIN_FA_Response__r.Name +
                            '\n BRAIN-ID = ' + trackerCallList.get(0).BRAIN_FA_Response__r.BRAIN_ID__c +
                            '\n ErrorCode = ' + trackerCallList.get(0).BRAIN_FA_Response__r.errorCode__c +
                            '\n ErrorMessage = ' + trackerCallList.get(0).BRAIN_FA_Response__r.errorMessage__c);                
            } 
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) trackerCallList.size() = ' + (trackerCallList != null ? trackerCallList.size() : 0) );
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) BEGIN Adding trackerCallList to trackerCallListCollection with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            trackerCallListCollection.add(trackerCallList);
            trackerCallList = null;
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Adding trackerCallList to trackerCallListCollection with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) trackerCallListCollection.size() = ' + (trackerCallListCollection != null ? trackerCallListCollection.size() : 0) );
    	        //dispersal of response data to Capital-Design and Offer objects is handled via Flows in SFCJ
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) END Assembling Final Call-Tracker with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) Completing with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
        } catch(Exception mainX) {
            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) EXCEPTION! \n Type: ' + mainX.getTypeName() + '\n Message:  ' + mainX.getMessage() + '\n Line#: ' + mainX.getLineNumber() + '\n StackTrace:  ' + mainX.getStackTraceString());
            try {
	            BRAIN_Automation_Fault__c excFault = BRAINFACalloutHelper.buildBaseFault(mainX.getMessage(), mainX.getStackTraceString());
                BRAINFACalloutHelper.associateFaultToCapDesignByRequestId(excFault, faRequestId);
	        } catch(Exception faultX) {
	            System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) EXCEPTION! \n Type: ' + faultX.getTypeName() + '\n Message:  ' + faultX.getMessage() + '\n Line#: ' + faultX.getLineNumber() + '\n StackTrace:  ' + faultX.getStackTraceString());
            }
        }
        
        System.debug('(BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses) PRIOR TO Returning trackerCallListCollection, Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
        //return the List/Collection of BRAIN_API_Call_Tracker__c Lists for Flow
        return trackerCallListCollection;
    }//end method assembleResponseFinancialAnalyses
    
    public List<List<BRAIN_API_Call_Tracker__c>> automatedAssembleResponseFinancialAnalyses(List<ResponseParams> responseParams) {        
        List<List<BRAIN_API_Call_Tracker__c>> trackerCallListCollection = new List<List<BRAIN_API_Call_Tracker__c>>();
        List<BRAIN_API_Call_Tracker__c> trackerCallList = new List<BRAIN_API_Call_Tracker__c>();
        List<BRAIN_API_Call_Tracker__c> faCallList = new List<BRAIN_API_Call_Tracker__c>();
        BRAIN_API_Call_Tracker__c faCall = new BRAIN_API_Call_Tracker__c();
        BRAIN_FA_Response__c  faResponse = new BRAIN_FA_Response__c();
        String faRequestId = null;
        String responseJSON = null;
        String callSource = null;

        try {
            if (responseParams == null || responseParams.size() == 0) {
                responseParams = this.rcResponseParamsList;
            }
            //Extract parameters into the key variables
            System.debug('(BRAINFinancialAnalysesResponseController.automatedAssembleResponseFinancialAnalyses) responseParams.size() = ' + (responseParams != null ? responseParams.size() : 0) );
            faRequestId = responseParams.get(0).faRequestId;
            responseJSON = responseParams.get(0).responseJSON;
            callSource = responseParams.get(0).callSource;
            System.debug('(BRAINFinancialAnalysesResponseController.automatedAssembleResponseFinancialAnalyses) faRequestId = ' + faRequestId + '\n responseJSON = ' + responseJSON + '\n callSource = ' + callSource);
            
            if (String.isBlank(faRequestId) || String.isBlank(responseJSON) || String.isBlank(callSource)) {
                throw new InvalidParameterParsingException();
            }    
            /*********************************************************************************************************
             * Next steps: 1. RESPONSE will be parsed and stored in faResponse object and its subobjects
             *             2. BRAIN_API_Call_Tracker__c associated to the incoming parameter BRAIN_FA_Request__c.Id is updated
             *             3. Return the BRAIN_API_Call_Tracker__c associated to this request for Financial Analyses
             *             4. From the calling flow, Data will then be dispersed to the Capital_Design__c object and Offer__c object per mapping
             *********************************************************************************************************/            
                    
            faCallList = BRAINFAObjectSOQLManager.queryBACTListByRequestId(faRequestId);
            faCall = (faCallList != null ? faCallList.get(0) : new BRAIN_API_Call_Tracker__c() );
            System.debug('(BRAINFinancialAnalysesResponseController.automatedAssembleResponseFinancialAnalyses) faCall.Id = ' + (faCall != null ? faCall.Id : null) );

            //create and insert a base BRAIN_FA_Response associated to the master/parent faCall by faCall.Id
            faResponse = BRAINFAResponseHelper.createBaseFAResponse(faCall);
            System.debug('(automatedAssembleResponseFinancialAnalyses) JUMP-START!  After createBaseFAResponse, ' + checkResponseForId(faResponse));
            String faResponseId = getIdFromResponse(faResponse);
            //parse the returned data results into the relative Response object and subobjects with inserts
            /**** BRAIN_FA_Response__c prePopBkupResp = faResponse; ****/
            faResponse = BRAINFAResponseHelper.populateFAResponseFromJSON(faResponse, responseJSON);
            System.debug('(automatedAssembleResponseFinancialAnalyses) FOLLOWING populateFAResponseFromJSON, ' + checkResponseForId(faResponse));
            faResponseId = getIdFromResponse(faResponse);
            //  check if response is NOT NULL and error_code__c is blank, then should have the data necessary to build out the hl1EvalResults from the response
            System.debug('(automatedAssembleResponseFinancialAnalyses) faResponse is NULL? ' + (faResponse==null) + '   AND faResponse?.errorCode__c = ' + faResponse?.errorCode__c + '  AND Is faResponse?.errorCode__c is NULL? ' + (faResponse?.errorCode__c==null));
            if (faResponse != null && (faResponse.errorCode__c == 'null' || faResponse.errorCode__c == null)) {
                /*** BRAIN_FA_Response__c preHL1ERBkupResp = faResponse; ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseHl1EvalResultFromJSON(faResponse, responseJSON);
                System.debug('(automatedAssembleResponseFinancialAnalyses) CHECK-HL1ER generateFAResponseHl1EvalResultFromJSON, ' + checkResponseForId(faResponse));
                faResponseId = getIdFromResponse(faResponse);
                List<hl1EvaluationResult__c> respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);
                /**** BRAIN_FA_Response__c preBuildCostBkupResp = faResponse; ****/
                faResponse = BRAINFAResponseHelper.generateFAResponseBuildCostFromJSON(faResponse, responseJSON, respHL1EvalResList);
                System.debug('(automatedAssembleResponseFinancialAnalyses) CHECK-BC generateFAResponseBuildCostFromJSON, ' + checkResponseForId(faResponse));
                faResponseId = getIdFromResponse(faResponse);
                respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);
                /*** BRAIN_FA_Response__c preCashFlowPeriodBkupResp = faResponse; ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseCashFlowPeriodsFromJSON(faResponse, responseJSON, respHL1EvalResList);
                System.debug('(automatedAssembleResponseFinancialAnalyses) CHECK-CFP generateFAResponseCashFlowPeriodsFromJSON, ' + checkResponseForId(faResponse));
                faResponseId = getIdFromResponse(faResponse);
                respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);
                /*** BRAIN_FA_Response__c preFinMetricBkupResp = faResponse; ****/
                faResponse = BRAINFAResponseHelper.generateFAResponseFinMetricFromJSON(faResponse, responseJSON, respHL1EvalResList);
                System.debug('(automatedAssembleResponseFinancialAnalyses) CHECK-FM generateFAResponseFinMetricFromJSON, ' + checkResponseForId(faResponse));
                faResponseId = getIdFromResponse(faResponse);                
                respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);
                Id respHL1EvalId = getIdFromHL1EvalResult(respHL1EvalResList);
                List<financialMetric__c> respFinMetricList = BRAINFAObjectSOQLManager.queryFinMetricByHl1EvalResId(respHL1EvalId);
                /*** BRAIN_FA_Response__c preIncStmtBkupResp = faResponse; ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseIncStmtMetricFromJSON(faResponse, responseJSON, respHL1EvalResList, respFinMetricList);
                System.debug('(automatedAssembleResponseFinancialAnalyses) CHECK-ISM generateFAResponseIncStmtMetricFromJSON, ' + checkResponseForId(faResponse));
                faResponseId = getIdFromResponse(faResponse);
                respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);
                respHL1EvalId = getIdFromHL1EvalResult(respHL1EvalResList);
                respFinMetricList = BRAINFAObjectSOQLManager.queryFinMetricByHl1EvalResId(respHL1EvalId);
                /*** BRAIN_FA_Response__c preCashFlowMetricBkupResp = faResponse; ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseCashFlowMetricFromJSON(faResponse, responseJSON, respHL1EvalResList, respFinMetricList);
                System.debug('(automatedAssembleResponseFinancialAnalyses) CHECK-CFM generateFAResponseCashFlowMetricFromJSON, ' + checkResponseForId(faResponse));
                faResponseId = getIdFromResponse(faResponse);
                respHL1EvalResList = BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId(faResponseId);
                /*** BRAIN_FA_Response__c preGrdrailEvalBkupResp = faResponse; ***/
                faResponse = BRAINFAResponseHelper.generateFAResponseGuardrailEvalFromJSON(faResponse, responseJSON, respHL1EvalResList);
                System.debug('(automatedAssembleResponseFinancialAnalyses) CHECK-GE generateFAResponseGuardrailEvalFromJSON, ' + checkResponseForId(faResponse));
                faResponseId = getIdFromResponse(faResponse);

            /********************************************************************************
			 * 
             *  BRAIN_FA_Response__c finalComposedFAResponse = BRAINFAObjectSOQLManager.queryForFinalFAResponse(faResponseId);
             *  String faHl1EvalResId = (faResponse != null ? faResponse.hl1EvaluationResult__c : ' ');
             *  String compHl1EvalResId = (finalComposedFAResponse != null ? finalComposedFAResponse.hl1EvaluationResult__c : ' ');
             *  hl1EvaluationResult__c hl1EvalResult =  BRAINFAObjectSOQLManager.queryForFinalHl1EvalResult(faResponseId, compHl1EvalResId);
             *  String hl1EvalResId = (hl1EvalResult != null ? hl1EvalResult.Id : ' ');
             *  buildCost__c buildCost = BRAINFAObjectSOQLManager.queryForFinalBuildCost(hl1EvalResId, compHl1EvalResId, faHl1EvalResId);
             *  List<cashFlowPeriod__c> cashFlowPeriods =  BRAINFAObjectSOQLManager.queryForFinalCashFlowPeriodList(hl1EvalResId, compHl1EvalResId, faHl1EvalResId);
             *  financialMetric__c finMetric =  BRAINFAObjectSOQLManager.queryForFinalFinMetric(hl1EvalResId, compHl1EvalResId, faHl1EvalResId);
             *                             
             *  String finMetricId = (finMetric != null ? finMetric.Id : ' ');
             *  incomeStatementMetric__c incStmtMetric = BRAINFAObjectSOQLManager.queryForFinalIncStmtMetric(finMetricId);
             *  cashFlowMetric__c cashFlowMetric = BRAINFAObjectSOQLManager.queryForFinalCashFlowMetric(finMetricId);
             *  guardrailEvaluation__c guardrailEval = BRAINFAObjectSOQLManager.queryForFinalGuardrailEval(hl1EvalResId, compHl1EvalResId, faHl1EvalResId);
             * 
             **********************************************************************************/

             /*  If you uncomment this System.debug, be sure to account for potential null objects!
              *         
                System.debug('The final composed BRAIN_FA_Response__c object consists of the following:' +
                                     '\n\t Id = ' + finalComposedFAResponse.Id +
                                     '\n\t Name = ' + finalComposedFAResponse.Name +
                                     '\n\t applicationVersion__c = ' + finalComposedFAResponse.applicationVersion__c +
                                     '\n\t baseFinancialAnalysisId__c = ' + finalComposedFAResponse.baseFinancialAnalysisId__c +
                                     '\n\t BRAIN_API_Call_Tracker_Master__c = ' + finalComposedFAResponse.BRAIN_API_Call_Tracker_Master__c +
                                     '\n\t BRAIN_ID__c = ' + finalComposedFAResponse.BRAIN_ID__c +
                                     '\n\t conversionScenarioId__c = ' + finalComposedFAResponse.conversionScenarioId__c +
                                     '\n\t costScenarioId__c = ' + finalComposedFAResponse.costScenarioId__c + 
                                     '\n\t errorCode__c = ' + finalComposedFAResponse.errorCode__c +
                                     '\n\t errorMessage__c = ' + finalComposedFAResponse.errorMessage__c +
                                     '\n\t forecastScenario__c = ' + finalComposedFAResponse.forecastScenario__c +
                                     '\n\t incremental__c = ' + finalComposedFAResponse.incremental__c + 
                                     '\n\t investmentFinancialAnalysisId__c = ' + finalComposedFAResponse.investmentFinancialAnalysisId__c +
                                     '\n\t Request_ID__C = ' + finalComposedFAResponse.Request_ID__c +
                                     '\n\t responseDate__c = ' + finalComposedFAResponse.responseDate__c + 
                                     '\n\t salesRateScenarioId__c = ' + finalComposedFAResponse.salesRateScenarioId__c +
                                     '\n\t status__c = ' + finalComposedFAResponse.status__c +
                                     '\n\t hl1EvalResult.Id = ' + hl1EvalResult.Id + 
                                     '\n\t hl1EvalResult.Name = ' + hl1EvalResult.Name +
                                     '\n\t hl1EvalResult.BRAIN_FA_Response_Master__c = ' + hl1EvalResult.BRAIN_FA_Response_Master__c +
                                     '\n\t hl1EvalResult.firstYrOfPositiveCashFlow__c = ' + hl1EvalResult.firstYrOfPositiveCashFlow__c +
                                     '\n\t hl1EvalResult.firstYrOfPositiveEBITDA__c = ' + hl1EvalResult.firstYrOfPositiveEBITDA__c +
                                     '\n\t hl1EvalResult.totalOpExCashFlowPeriods__c = ' + hl1EvalResult.totalOpExCashFlowPeriods__c +
                                     '\n\t hl1EvalResult.totalRevenueCashFlowPeriods__c = ' + hl1EvalResult.totalRevenueCashFlowPeriods__c +
                                     '\n\t hl1EvalResult.endingMRC__c = ' + hl1EvalResult.endingMRC__c +
                                     '\n\t hl1EvalResult.buildCost__c = ' + hl1EvalResult.buildCost__c +
                                     '\n\t hl1EvalResult.cashFlowPeriod__c = ' + hl1EvalResult.cashFlowPeriod__c +
                                     '\n\t hl1EvalResult.financialMetric__c = ' + hl1EvalResult.financialMetric__c +
                                     '\n\t hl1EvalResult.guardrailEvaluation__c = ' + hl1EvalResult.guardrailEvaluation__c +
                                     '\n\t buildCost.Id = ' + buildCost.Id +
                                     '\n\t buildCost.Name = ' + buildCost.Name +
                                     '\n\t buildCost.hl1EvaluationResultMaster__c = ' + buildCost.hl1EvaluationResultMaster__c +
                                     '\n\t buildCost.siteCount__c = ' + buildCost.siteCount__c +
                                     '\n\t buildCost.projectCapEx__c = ' + buildCost.projectCapEx__c +
                                     '\n\t buildCost.directCapEx__c = ' + buildCost.directCapEx__c +
                                     '\n\t buildCost.sharedCapEx__c = ' + buildCost.sharedCapEx__c +
                                     '\n\t buildCost.opExNRC__c = ' + buildCost.opExNRC__c +
                                     '\n\t buildCost.opExMRC__c = ' + buildCost.opExMRC__c +
                                     '\n\t buildCost.netExSharedMRC__c = ' + buildCost.netExSharedMRC__c +
                                     '\n\t cashFlowPeriods.get(0).Id = ' + cashFlowPeriods.get(0).Id +
                                     '\n\t cashFlowPeriods.get(0).Name = ' + cashFlowPeriods.get(0).Name +
                                     '\n\t cashFlowPeriods.get(0).hl1EvaluationResultMaster__c = ' + cashFlowPeriods.get(0).hl1EvaluationResultMaster__c +
                                     '\n\t cashFlowPeriods.get(0).contractMonth__c = ' + cashFlowPeriods.get(0).contractMonth__c +
                                     '\n\t cashFlowPeriods.get(0).currency__c = ' + cashFlowPeriods.get(0).currency__c +
                                     '\n\t cashFlowPeriods.get(0).revenue__c = ' + cashFlowPeriods.get(0).revenue__c +
                                     '\n\t cashFlowPeriods.get(0).netExDirect__c = ' + cashFlowPeriods.get(0).netExDirect__c +
                                     '\n\t cashFlowPeriods.get(0).netExShared__c = ' + cashFlowPeriods.get(0).netExShared__c +
                                     '\n\t cashFlowPeriods.get(0).opEx__c = ' + cashFlowPeriods.get(0).opEx__c +
                                     '\n\t cashFlowPeriods.get(0).capExDirect__c = ' + cashFlowPeriods.get(0).capExDirect__c +
                                     '\n\t cashFlowPeriods.get(0).capExSharedGammaAdjusted__c = ' + cashFlowPeriods.get(0).capExSharedGammaAdjusted__c +
                                     '\n\t cashFlowPeriods.get(0).incomeTax__c = ' + cashFlowPeriods.get(0).incomeTax__c +
                                     '\n\t cashFlowPeriods.size() = ' + cashFlowPeriods.size() +
                                     '\n\t finMetric.Id = ' + finMetric.Id +
                                     '\n\t finMetric.Name = ' + finMetric.Name +
                                     '\n\t finMetric.incomeStatementMetric__c = ' + finMetric.incomeStatementMetric__c +
                                     '\n\t finMetric.cashFlowMetric__c = ' + finMetric.cashFlowMetric__c +
                                     '\n\t incStmtMetric.Id = ' + incStmtMetric.Id +
                                     '\n\t incStmtMetric.Name = ' + incStmtMetric.Name +
                                     '\n\t incStmtMetric.financialMetricMaster__c = ' + incStmtMetric.financialMetricMaster__c +
                                     '\n\t incStmtMetric.currency__c = ' + incStmtMetric.currency__c +
                                     '\n\t incStmtMetric.revenue__c = ' + incStmtMetric.revenue__c +
                                     '\n\t incStmtMetric.netExDirect__c = ' + incStmtMetric.netExDirect__c +
                                     '\n\t incStmtMetric.netExShared__c = ' + incStmtMetric.netExShared__c +
                                     '\n\t incStmtMetric.grossMargin__c = ' + incStmtMetric.grossMargin__c +
                                     '\n\t incStmtMetric.grossMarginPct__c = ' + incStmtMetric.grossMarginPct__c +
                                     '\n\t incStmtMetric.opEx__c = ' + incStmtMetric.opEx__c +
                                     '\n\t incStmtMetric.ebitda__c = ' + incStmtMetric.ebitda__c +
                                     '\n\t incStmtMetric.ebitdaPct__c = ' + incStmtMetric.ebitdaPct__c +
                                     '\n\t incStmtMetric.capExDirect__c = ' + incStmtMetric.capExDirect__c +
                                     '\n\t incStmtMetric.capExSharedGammaAdjusted__c = ' + incStmtMetric.capExSharedGammaAdjusted__c +
                                     '\n\t incStmtMetric.ebitdaLessCapEx__c = ' + incStmtMetric.ebitdaLessCapEx__c +
                                     '\n\t incStmtMetric.ebitdaLessCapExPct__c = ' + incStmtMetric.ebitdaLessCapExPct__c +
                                     '\n\t incStmtMetric.incomeTax__c = ' + incStmtMetric.incomeTax__c +
                                     '\n\t cashFlowMetric.Id = ' + cashFlowMetric.Id +
                                     '\n\t cashFlowMetric.Name = ' + cashFlowMetric.Name +
                                     '\n\t cashFlowMetric.financialMetricMaster__c = ' + cashFlowMetric.financialMetricMaster__c +
                                     '\n\t cashFlowMetric.currency__c = ' + cashFlowMetric.currency__c +
                                     '\n\t cashFlowMetric.netPresentValue__c = ' + cashFlowMetric.netPresentValue__c +
                                     '\n\t cashFlowMetric.discountedPaybackPeriodMonths__c = ' + cashFlowMetric.discountedPaybackPeriodMonths__c +
                                     '\n\t cashFlowMetric.simplePaybackPeriodMonths__c = ' + cashFlowMetric.simplePaybackPeriodMonths__c +
                                     '\n\t cashFlowMetric.internalRateOfReturn__c = ' + cashFlowMetric.internalRateOfReturn__c +
                                     '\n\t cashFlowMetric.averageContractTermMonths__c = ' + cashFlowMetric.averageContractTermMonths__c +
                                     '\n\t guardrailEval.Id = ' + guardrailEval.Id +
                                     '\n\t guardrailEval.Name = ' + guardrailEval.Name +
                                     '\n\t guardrailEval.hl1EvaluationResultMaster__c = ' + guardrailEval.hl1EvaluationResultMaster__c +
                                     '\n\t guardrailEval.resultCode__c = ' + guardrailEval.resultCode__c +
                                     '\n\t guardrailEval.displayMessage__c = ' + guardrailEval.displayMessage__c +
                                     '\n\t guardrailEval.simplePaybackPeriodThresholdMonths__c = ' + guardrailEval.simplePaybackPeriodThresholdMonths__c +
                                     '\n\t guardrailEval.currencyCode__c = ' + guardrailEval.currencyCode__c +
                                     '\n\t guardrailEval.incrementalATCToMeetGuardrail__c = ' + guardrailEval.incrementalATCToMeetGuardrail__c +
                                     '\n\r\n\r\n\r\n\r');
                   */     
            }//end if no ERRORs (error_code__c was NULL)
	        
            //Get the updated BRAIN_API_Call_Tracker__c object associated with this request
            String faCallId = (faCall != null ? faCall.Id : ' ');
            trackerCallList =  BRAINFAObjectSOQLManager.queryForFinalTracker(faCallId);
            System.debug('(BRAINFinancialAnalysesResponseController.automatedAssembleResponseFinancialAnalyses) trackerCallList.size() = ' + (trackerCallList != null ? trackerCallList.size() : 0) );
            trackerCallListCollection.add(trackerCallList);
            System.debug('(BRAINFinancialAnalysesResponseController.automatedAssembleResponseFinancialAnalyses) trackerCallListCollection.size() = ' + (trackerCallListCollection != null ? trackerCallListCollection.size() : 0) );
                //dispersal of response data to Capital-Design and Offer objects is handled via Flows in SFCJ
        } catch(Exception mainX) {
            System.debug('(BRAINFinancialAnalysesResponseController.automatedAssembleResponseFinancialAnalyses) EXCEPTION! \n Type: ' + mainX.getTypeName() + '\n Message:  ' + mainX.getMessage() + '\n Line#: ' + mainX.getLineNumber() + '\n StackTrace:  ' + mainX.getStackTraceString());
            try {
	            BRAIN_Automation_Fault__c excFault = BRAINFACalloutHelper.buildBaseFault(mainX.getMessage(), mainX.getStackTraceString());
                BRAINFACalloutHelper.associateFaultToCapDesignByRequestId(excFault, faRequestId);
	        } catch(Exception faultX) {
	            System.debug('(BRAINFinancialAnalysesResponseController.automatedAssembleResponseFinancialAnalyses) EXCEPTION! \n Type: ' + faultX.getTypeName() + '\n Message:  ' + faultX.getMessage() + '\n Line#: ' + faultX.getLineNumber() + '\n StackTrace:  ' + faultX.getStackTraceString());
            }
        }
        
        //return the List/Collection of BRAIN_API_Call_Tracker__c Lists for Flow
        return trackerCallListCollection;

    }//end method automatedAssembleResponseFinancialAnalyses
        
    public void clearState() {
    	this.rcFARequestId = null;
    	this.rcResponseJSON = null;
        this.rcCallSource = null;
    	this.rcResponseParamsList = null;
        this.trackerCallListCollection = null;
	    this.callTracker = null;
    }//end method clearState
    
    private static String checkResponseForId(BRAIN_FA_Response__c faResponse) {
        return 'faResponse==null? ' + (faResponse==null) + '   AND faResponse.Id = ' + getIdFromResponse(faResponse);
    }//end method checkResponseForId

    private static String getIdFromResponse(BRAIN_FA_Response__c faResponse) {
        return faResponse.Id;
    }//end method getIdFromResponse
    
    private static String getIdFromHL1EvalResult(List<hl1EvaluationResult__c> respHL1EvalResList) {
        return ((respHL1EvalResList != null && respHL1EvalResList.size() > 0 && respHL1EvalResList.get(0) != null) ? respHL1EvalResList.get(0).Id : ' ');
    }//end method getIdFromHL1EvalResult
    
}//end class BRAINFinancialAnalysesResponseController