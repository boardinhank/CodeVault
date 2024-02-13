/***************************************************************************************************
 * Name:  WCSegCalloutHelper
 * Platform: Salesforce Connected Journey (SFCJ)
 * Helper class for WireCenter CLLI Segmentation interaction between SFCJ and BRAIN/WCSeg API
 * Code Coverage:  TestWCSegCalloutHelper -- 100%  07/14/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 07/13/2022  	T2Cabato    Feature(Epic) ESCJ-338	        Base version
 * 07/25/2022   T2Cabato	Feature(Epic) ESCJ-338	        Queueable version
 * 11/17/2023   T2Cabato    QFCJ-4712                       Capital Design - Wire Center Segmentation Update Automation
 * 12/08/2023	T2Cabato	QFCJ-4712						Revision for Too many queries error 
 * 12/13/2023	T2Cabato	 								Revision for APEX PMD noted problems
****************************************************************************************************/
public with sharing class WCSegCalloutHelper {
    public class ZeroListException extends Exception {}
    public class NullObjectException extends Exception {}
    public class NullResponseOBJException extends Exception {}
    public class NullResponseJSONException extends Exception {}
    public class BlankValueException extends Exception {}
    public class NamesDoNotMatchException extends Exception {}
    public class IdsDoNotMatchException extends Exception {}
    public class BadStatusCodeException extends Exception {}
    public class InvalidAuthTokenException extends Exception {}
    public class InvalidHttpRequestException extends Exception {} 
    public class InvalidApiNameException extends Exception {}
    public class NoAccessException extends Exception {}

    private static final String NO_PERMXNS_UPSERT = 'No permissions to create or update.';
    private static final String EXC_MSG = '\n Message:  ';
    private static final String EXC_LINE = '\n Line#:  ';
    private static final String EXC_TRACE = '\n StackTrace:  ';
    /*******************************************************************************************************
     * The following final variables are used with Named-Credential settings configured within SFCJ
     * 
     * 
     * This variable is specifically for the BRAIN Financial-Analyses API call through APIGEE
     *     private static final String endPointApigeeForBRAINFAByNamedCredential = 'callout:BRAINApigeeAuthFACall';//https://api-test.lumen.com/Finance/v1/Capital/investmentFinancialAnalysis/financial-analyses
     * These 2 variables are specifically for the BRAIN Wire-Center Segmentation API calls through APIGEE (1 is for use with specific CLLI code, the 2nd is for use as a "get them all")
     *     private static final String endPointApigeeForSingleWCSegByNamedCredential = 'callout:BRAINApigeeAuthWCSegCall';//https://api-test.lumen.com/Finance/v1/Capital/wirecenterDataRegulatoryAreas/regulatory-areas/ 
     *     private static final String endPointApigeeForSearchWCSegByNamedCredential = 'callout:BRAINApigeeAuthSearchWCSegCall';//https://api-test.lumen.com/Finance/v1/Capital/wirecenterDataRegulatoryAreas/search/regulatory-areas?
     * This variable is specifically for the BRAIN AUTH-TOKEN API call through APIGEE
     *     private static final String endPointApigeeForOAuthTokenByBRAINNamedCredential = 'callout:BRAINApigeeTokenGenerator';
     * This variable is the general AUTH-TOKEN API call through APIGEE (GEOS, Loopqual, and at least 2 others)
     *     private static final String endPointApigeeForOAuthTokenByNamedCredential = 'callout:SFCJ_Basic';
     * This variable is the general API call through APIGEE (GEOS, Loopqual, etc)
     *     private static final String endPointApigeeForBaseByNamedCredential = 'callout:Apigee_Test1_Oauth';
     * 
     *******************************************************************************************************/ 
    
    public static String getAccessTokenFromApigee() {
        String accessToken = null;
        
        try {
            //request to Apigee for Token
            HttpRequest httpRequestApigee = new HttpRequest();
            String apigeeURL2Use = null;
            String auth2Use = null;
            //identify if this is a sandbox environment
            Boolean isSandbox = [SELECT IsSandbox, Id FROM Organization].IsSandbox;
            if (isSandbox) {
                apigeeURL2Use = System.Label.ApigeeBRAINTestBaseURL;
                auth2Use = System.Label.BRAIN_APIGEE_AUTHORIZATION_MHOLDEN;
            } else {
                apigeeURL2Use = System.Label.ApigeeBRAINProdBaseURL;
                auth2Use = System.Label.BRAIN_APIGEE_PROD_AUTHORIZATION;
            }
            String endPointToUse = apigeeURL2Use + System.Label.OAuthTokenPath;
            System.debug('(WCSegCalloutHelper.getAccessTokenFromApigee) endPointToUse = ' + endPointToUse);
            
            httpRequestApigee.setEndPoint(endPointToUse);
            httpRequestApigee.setMethod('POST');
            httpRequestApigee.setHeader('Authorization', auth2Use);
            httpRequestApigee.setHeader('Cache-Control', 'no-cache');
            httpRequestApigee.setHeader('Content-Length', '30');
            httpRequestApigee.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            httpRequestApigee.setHeader('Accept', '*/*');
            httpRequestApigee.setHeader('Accept-Encoding', 'gzip, deflate, br');
            httpRequestApigee.setHeader('Connection', 'keep-alive');
            httpRequestApigee.setBody('grant_type=client_credentials');
            
            Http httpProtocol = new Http();
            HttpResponse httpResponseApigee = httpProtocol.send(httpRequestApigee);
            
            if(httpResponseApigee.getStatusCode() == 200) {
                String apigeeResponseBody = httpResponseApigee.getBody();
                System.debug('(WCSegCalloutHelper.getAccessTokenFromApigee) apigeeResponseBody is NULL? ' + String.isBlank(apigeeResponseBody));
                accessToken = parseForAccessToken(apigeeResponseBody);
            } else if (httpResponseApigee.getStatusCode() == 401) {
                accessToken = '401';            
            } else {
                accessToken = httpResponseApigee.toString();
            }//end else statusCode NOT 200
            //System.debug('(WCSegCalloutHelper.getAccessTokenFromApigee) accessToken = ' + accessToken);
        } catch(Exception callAuthX) {
            System.debug('(WCSegCalloutHelper.getAccessTokenFromApigee) EXCEPTION! \n Type: ' + callAuthX.getTypeName() + EXC_MSG + callAuthX.getMessage() + EXC_LINE + callAuthX.getLineNumber() + EXC_TRACE + callAuthX.getStackTraceString());
        }
        
        return accessToken;            
    }//end method getAccessTokenFromApigee
    
    public static String parseForAccessToken(String apigeeResponseBody) {
        String accessToken = null;
        try {
            JSONParser responseJSONParser = JSON.createParser(apigeeResponseBody);
            Integer tokenCtr = 0;
            responseJSONParser.nextToken();
            do {
                responseJSONParser.nextValue();
                switch on responseJSONParser.getCurrentName() {
                    when 'access_token' {
                        if (responseJSONParser.getCurrentName() != responseJSONParser.getText()) {
                            accessToken = responseJSONParser.getText();
                        }
                    }//end when 'access_token'
                    when else {
                        accessToken = null;
                    }
                }//end switch
                tokenCtr++;
            } while (responseJSONParser.nextToken() != null); //end while nextToken NOT NULL            
        } catch(Exception jsonParseX) {
            System.debug('(WCSegCalloutHelper.parseForAccessToken) EXCEPTION! \n Type: ' + jsonParseX.getTypeName() + EXC_MSG + jsonParseX.getMessage() + EXC_LINE + jsonParseX.getLineNumber() + EXC_TRACE + jsonParseX.getStackTraceString());
        }       
        
        return accessToken;
    }//end method parseForAccessToken

    public static HttpRequest buildHttpRequestForSearchWCSegService(String accessToken, String reqCLLI) {
        HttpRequest httpRequestWCSeg = new HttpRequest();
        String adjustedFilter = null;
        try {
            if (String.isBlank(accessToken)) {
                throw new InvalidAuthTokenException('EXCEPTION!  The auth-token was NULL or otherwise invalid and the call to get WCSegmentation could not be made at this time.');
            } else {                
                //request to BRAIN for WCSeg
                httpRequestWCSeg = new HttpRequest();
                String apigeeURL2Use = null;
                //identify if this is a sandbox environment
                Boolean isSandbox = [SELECT IsSandbox, Id FROM Organization].IsSandbox;
                if (isSandbox) {
                    apigeeURL2Use = System.Label.ApigeeBRAINTestBaseURL;
                } else {
                    apigeeURL2Use = System.Label.ApigeeBRAINProdBaseURL;
                }
                String endPointToUse = apigeeURL2Use + System.Label.WCSegSearch_Path;
                if (String.isBlank(reqCLLI) || reqCLLI == '*') {
                    adjustedFilter = System.Label.WCSegSearch_Filter;
                } else {
                    Integer clliSectionIdx = System.Label.WCSegSearch_Filter.indexOf('"clli8":"",');
                    Integer clliValBgnIdx = clliSectionIdx + 9;
                    Integer clliValEndIdx = clliValBgnIdx + 1;
	                adjustedFilter = System.Label.WCSegSearch_Filter.substring(0,clliValBgnIdx) + reqCLLI + System.Label.WCSegSearch_Filter.substring(clliValEndIdx);
                }                
                endPointToUse += adjustedFilter;
                httpRequestWCSeg.setEndPoint(endPointToUse);
                httpRequestWCSeg.setMethod('GET');
                httpRequestWCSeg.setHeader('Grant_Type','Authorization Code');
                httpRequestWCSeg.setHeader('Authorization', ('Bearer ' + accessToken));
                httpRequestWCSeg.setHeader('Cache-Control', 'no-cache');
                httpRequestWCSeg.setHeader('Accept', '*/*');
                httpRequestWCSeg.setHeader('Accept-Encoding', 'gzip, deflate, br');
                httpRequestWCSeg.setHeader('Connection', 'keep-alive');
				httpRequestWCSeg.setTimeout(120000);
                
            }//end else accessToken NOT Empty 
        } catch(Exception httpRequestX) {
            System.debug('(WCSegCalloutHelper.buildHttpRequestForSearchWCSegService) EXCEPTION! \n Type: ' + httpRequestX.getTypeName() + EXC_MSG + httpRequestX.getMessage() + EXC_LINE + httpRequestX.getLineNumber() + EXC_TRACE + httpRequestX.getStackTraceString());
            httpRequestWCSeg = null;
        }   

		return httpRequestWCSeg;        
    }//end method buildHttpRequestForSearchWCSegService
    
    public static HttpResponse getHttpResponseFromSearchWCSegService(HttpRequest httpRequestWCSeg, String reqCLLI) {        
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Http httpProtocol = new Http();

        try {
            if (httpRequestWCSeg == null) {
                throw new InvalidHttpRequestException();                        
            } else {
		        if(Test.isRunningTest()) {
					httpResponseWCSeg = TestWCSegCalloutHelper.getMockWCSegHttpResponse();
                } else {
                    try {
                        httpResponseWCSeg = httpProtocol.send(httpRequestWCSeg);
                    } catch(Exception sendX) {
                        System.debug('(WCSegCalloutHelper.getHttpResponseFromSearchWCSegService) EXCEPTION! \n Type: ' + sendX.getTypeName() + EXC_MSG + sendX.getMessage() + EXC_LINE + sendX.getLineNumber() + EXC_TRACE + sendX.getStackTraceString());
                    }   
                }
            }//end else httpRequestWCSeg NOT NULL
        } catch(Exception callOutX) {
            System.debug('(WCSegCalloutHelper.getHttpResponseFromSearchWCSegService) EXCEPTION! \n Type: ' + callOutX.getTypeName() + EXC_MSG + callOutX.getMessage() + EXC_LINE + callOutX.getLineNumber() + EXC_TRACE + callOutX.getStackTraceString());
        }
        return httpResponseWCSeg;
    }//end method getHttpResponseFromSearchWCSegService
    
    public static String extractDataFromHttpResponse(HttpResponse responseWCSeg, API_Transaction__c apiTransaction) {
        String bodyJSON = null;
        
        try {
            if(responseWCSeg.getStatusCode() >= 200) {
                bodyJSON = responseWCSeg.getBody();
	            if(responseWCSeg.getStatusCode() >= 300) {
                    apiTransaction.Error_Message__c = responseWCSeg.toString();
                    if (API_Transaction__c.SObjectType.getDescribe().isCreateable() == false && API_Transaction__c.SObjectType.getDescribe().isUpdateable() == false) {
                        throw new DmlException(NO_PERMXNS_UPSERT);
                    }
                    update apiTransaction;
                }
            } else {
                throw new BadStatusCodeException(responseWCSeg.getStatusCode() + ': ' + responseWCSeg.getStatus());
            }
        } catch(Exception extractX) {
            System.debug('(WCSegCalloutHelper.extractDataFromHttpResponse) EXCEPTION! \n Type: ' + extractX.getTypeName() + EXC_MSG + extractX.getMessage() + EXC_LINE + extractX.getLineNumber() + EXC_TRACE + extractX.getStackTraceString());
        }
        
        return bodyJSON;
    }//end method extractDataFromHttpResponse

    @AuraEnabled
    public static List<BRAIN_WCSeg_Response__c> parseJSONForNWCResponse(String responseJSON) {
        List<BRAIN_WCSeg_Response__c> nwcResponseList = new List<BRAIN_WCSeg_Response__c>();
        BRAIN_WCSeg_Response__c nwcResponse = new BRAIN_WCSeg_Response__c();
        WCSearchResult wcSearchResult = new WCSearchResult();
        String responseJSONTrimmed = null;
        
        try {
            /******************************************************************************************
             * 
             *  System.debug('(WCSegCalloutHelper.parseJSONForNWCResponse) Incoming responseJSON is NULL? ' + String.isBlank(responseJSON));
             * 
             */ 
            if (!String.isBlank(responseJSON)) {
                Integer searchStartIdx = responseJSON.indexOf('"wireCenterSearchResults"') - 1;
                Integer searchEndIdx = responseJSON.indexOf(']', searchStartIdx) + 1;
                responseJSONTrimmed = responseJSON.substring(searchStartIdx, searchEndIdx);
                /**x***************************************************************************************** 
                 * 
                 *   System.debug('For wireCenterSearchResults, responseJSONTrimmed is NULL? ' + String.isBlank(responseJSONTrimmed));
                 * 
                 *********************************************************************************************/
                if (responseJSONTrimmed.indexOf('"wireCenterSearchResults":') > -1) {
                    responseJSONTrimmed = '[' + responseJSONTrimmed.substringBetween('[', ']') + ']';
                    /**************************************************************************************
                     * 
                     *   System.debug('For wireCenterSearchResults, final responseJSONTrimmed = ' + responseJSONTrimmed);
                     * 
                     *************************************************************************************/ 
                }
                JSONParser responseJSONParser = JSON.createParser(responseJSONTrimmed);
                while (responseJSONParser.nextToken() != null) {
                    // Advance to the start object marker to
                    //  find next invoice statement object.
                    if (responseJSONParser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire invoice object, including its array of line items.
                        wcSearchResult = (WCSearchResult)responseJSONParser.readValueAs(WCSearchResult.class);
                        System.debug('(WCSegCalloutHelper.parseJSONForNWCResponse) wcSearchResult: \n' + wcSearchResult);
                        nwcResponse = new BRAIN_WCSeg_Response__c();
                        nwcResponse.clliCode__c = wcSearchResult.id;
                        nwcResponse.assignedTreatment__c = wcSearchResult.assignedTreatment;
                        nwcResponseList.add(nwcResponse);
                    }//end if START_OBJECT
                }//end while nextToken                
            } else {
                throw new NullResponseJSONException('EXCEPTION! The ResponseJSON provided was NULL.  No parsing for BRAIN_WCSeg_Response could be performed.');
            }//end else NULL value for responseJSON or for nwcResponse.Id or for both
        } catch(Exception jsonParseX) {
            System.debug('(WCSegCalloutHelper.parseJSONForNWCResponse) EXCEPTION! \n Type: ' + jsonParseX.getTypeName() + EXC_MSG + jsonParseX.getMessage() + EXC_LINE + jsonParseX.getLineNumber() + EXC_TRACE + jsonParseX.getStackTraceString());
        }
        
        return nwcResponseList;
    }//end parseJSONForNWCResponse    

    @AuraEnabled
    public static List<BRAIN_WCSeg_Response__c> buildBaseWCSegResponse(String wcSegResponseJSON, List<Network_Wire_Center__c> curNWCList, List<String> curNamesList) {
		List<BRAIN_WCSeg_Response__c> nwcRespList = new List<BRAIN_WCSeg_Response__c>();
		BRAIN_WCSeg_Response__c nwcResponse = new BRAIN_WCSeg_Response__c();
        Network_Wire_Center__c currentNWC = new Network_Wire_Center__c();
        
        try {
            if (String.isBlank(wcSegResponseJSON)) {
                 throw new NullObjectException('EXCEPTION!  The Network_Wire_center__c object was NULL.  No update was possible.');       
            }
            /********************************************************************************
             * System.debug('(WCSegCalloutHelper.buildBaseWCSegResponse) wcSegResponseJSON.length() = ' + wcSegResponseJSON.length());
             ********************************************************************************/ 
            List<BRAIN_WCSeg_Response__c> respFromParsingList = parseJSONForNWCResponse(wcSegResponseJSON);
            if (respFromParsingList == null || respFromParsingList.size() < 0) {
                throw new ZeroListException('EXCEPTION!  There were 0 base-responses returned from parsing of response-JSON.  No additional processing could be performed.');
            }
            /***************************************************************************
             * System.debug('(WCSegCalloutHelper.buildBaseWCSegResponse) respFromParsingList.size() = ' + respFromParsingList.size());
             **************************************************************************/ 
            for (BRAIN_WCSeg_Response__c respFromParse : respFromParsingList) {                        
                nwcResponse = new BRAIN_WCSeg_Response__c();
                nwcResponse.clliCode__c = respFromParse.clliCode__c;
                nwcResponse.assignedTreatment__c = (String.isBlank(respFromParse.assignedTreatment__c) || respFromParse.assignedTreatment__c == 'null') ? 'WEAK' : respFromParse.assignedTreatment__c;
                System.debug('(WCSegCalloutHelper.buildBaseWCSegResponse) respFromParse.clliCode__c = ' + respFromParse.clliCode__c + '  AND respFromParse.assignedTreatment__c = ' + respFromParse.assignedTreatment__c);

                Integer foundAtIdx = curNamesList.indexOf(respFromParse.clliCode__c);	
                System.debug('(WCSegCalloutHelper.buildBaseWCSegResponse) foundAtIdx = ' + foundAtIdx);
                if (foundAtIdx < 0) {
                    throw new ZeroListException('WARNING! No match found in current Network-Wire-Centers for respFromParse.clliCode__c (' + respFromParse.clliCode__c + ')!');
                }
                System.debug('(WCSegCalloutHelper.buildBaseWCSegResponse) EXISTS!  respFromParse.clliCode__c (' + respFromParse.clliCode__c + ') was FOUND to match an existing Network-Wire-Center at position ' + foundAtIdx + ' {' + curNWCList.get(foundAtIdx).Name + '}.');
                currentNWC = curNWCList.get(foundAtIdx);
                /***********************************************************************
                 * System.debug('(WCSegCalloutHelper.buildBaseWCSegResponse) currentNWC.Id = ' + currentNWC.Id + '  AND currentNWC.Name = ' + currentNWC.Name + '  AND currentNWC.Wire_Center_Segmentation__c = ' + currentNWC.Wire_Center_Segmentation__c);
                 ***********************************************************************/
                if (currentNWC.Name == respFromParse.clliCode__c) {
                    nwcResponse.Network_Wire_Center_Master__c = currentNWC.Id;
                    nwcResponse.Network_Wire_Center_Master__r = currentNWC;
                    nwcResponse.Network_Wire_Center_Master__r.Name = currentNWC.Name;
                    nwcResponse.Network_Wire_Center_Master__r.Wire_Center_Segmentation__c = currentNWC.Wire_Center_Segmentation__c;
                    nwcResponse.responseJSON__c = respFromParse.responseJSON__c;
                    nwcRespList.add(nwcResponse);                                    
                }
            }//end for-loop through respFromParsingList
        } catch(Exception methodX) {
            System.debug('(WCSegCalloutHelper.buildBaseWCSegResponse) EXCEPTION! \n Type: ' + methodX.getTypeName() + EXC_MSG + methodX.getMessage() + EXC_LINE + methodX.getLineNumber() + EXC_TRACE + methodX.getStackTraceString());
        }//end catch methodX
        
        return nwcRespList;
    }//end method buildBaseWCSegResponse

    @AuraEnabled
    public static List<BRAIN_WCSeg_Response__c> insertBaseWCSegResponseList(List<BRAIN_WCSeg_Response__c> nwcRespList) {		
        
        try {
            if (nwcRespList == null || nwcRespList.size() <= 0) {
                throw new NullObjectException('EXCEPTION!  The List of BRAIN_WCSeg_Response__c objects was NULL or was empty.  No update was possible.');       
            }
            if (BRAIN_WCSeg_Response__c.SObjectType.getDescribe().isCreateable() == false && BRAIN_WCSeg_Response__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            insert nwcRespList;
        } catch(Exception methodX) {
            System.debug('(WCSegCalloutHelper.insertBaseWCSegResponse) EXCEPTION! \n Type: ' + methodX.getTypeName() + EXC_MSG + methodX.getMessage() + EXC_LINE + methodX.getLineNumber() + EXC_TRACE + methodX.getStackTraceString());
        }//end catch methodX
        
        return nwcRespList;
    }//end method insertBaseWCSegResponse
        
    @AuraEnabled
    public static List<Network_Wire_Center__c> queryAllWirecenterCLLICodes() {
        List<Network_Wire_Center__c> baseNetworkWCList = new List<Network_Wire_Center__c>();

        try {
            if (Network_Wire_Center__c.SObjectType.getDescribe().isAccessible()) {
                baseNetworkWCList = [SELECT Id, Name, OwnerId, Exchange__c, Wire_Center_Region__c, Wire_Center_State__c, Wire_Center_Segmentation__c
                                       FROM Network_Wire_Center__c
                                      ORDER BY Name];
            } else {
                throw new NoAccessException('EXCEPTION! The user does not have access to the Network_Wire_Center__c object.');
            }
              
            if(baseNetworkWCList.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  Query for a list of All Network Wire Center objects returned 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(WCSegCalloutHelper.queryAllWirecenterCLLICodes) EXCEPTION! \n Type: ' + queryX.getTypeName() + EXC_MSG + queryX.getMessage() + EXC_LINE + queryX.getLineNumber() + EXC_TRACE + queryX.getStackTraceString());
        }
        
        return baseNetworkWCList;
    }//end method queryAllWirecenterCLLICodes
      
    @AuraEnabled
    public static List<String> extractNamesOfAllWirecenterCLLICodes(List<Network_Wire_Center__c> nwcList) {
        List<String> nwcNamesOnlyList = new List<String>();
        try {              
            if(nwcList.size() > 0) {
                for (Network_Wire_Center__c nwc : nwcList) {
                    nwcNamesOnlyList.add(nwc.Name);
                }//end for-loop through namesOnlyNWCList
            } else {                
                throw new ZeroListException('EXCEPTION!  Passed-in List of All Network Wire Center objects contained 0 records.  Unable to extract Names-only list.');
            }
        } catch(Exception queryX) {
            System.debug('(WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes) EXCEPTION! \n Type: ' + queryX.getTypeName() + EXC_MSG + queryX.getMessage() + EXC_LINE + queryX.getLineNumber() + EXC_TRACE + queryX.getStackTraceString());
        }
        
        return nwcNamesOnlyList;
    }//end method extractNamesOfAllWirecenterCLLICodes
       
    @AuraEnabled
    public static List<Network_Wire_Center__c> queryWirecenterCLLICodeByName(String nwcName) {
        List<Network_Wire_Center__c> nwcByNameList = new List<Network_Wire_Center__c>();
        try {
            if (Network_Wire_Center__c.SObjectType.getDescribe().isAccessible()) {
                nwcByNameList = [SELECT Id, Name, OwnerId, Exchange__c, Wire_Center_Region__c, Wire_Center_State__c, Wire_Center_Segmentation__c
                                       FROM Network_Wire_Center__c
                                      WHERE Name = :nwcName
                                      ORDER BY Name 
                                      LIMIT 1];
            } else {
                throw new NoAccessException('EXCEPTION! The user does not have access to the Network_Wire_Center__c object.');
            }
              
            if(nwcByNameList.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  Query for a list of All Network Wire Center objects containing Name values only returned 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(WCSegCalloutHelper.queryWirecenterCLLICodeByName) EXCEPTION! \n Type: ' + queryX.getTypeName() + EXC_MSG + queryX.getMessage() + EXC_LINE + queryX.getLineNumber() + EXC_TRACE + queryX.getStackTraceString());
        }
        
        return nwcByNameList;
    }//end method queryWirecenterCLLICodeByName
    
    @AuraEnabled
    public static List<Network_Wire_Center__c> checkNWCForUpdates(List<String> nwcNamesOnlyList, List<Network_Wire_Center__c> curNWCList, List<BRAIN_WCSeg_Response__c> nwcRespList) {
        List<Network_Wire_Center__c> updatedNWCList = new List<Network_Wire_Center__c>();
        Network_Wire_Center__c existingNWC = new Network_Wire_Center__c();
        Network_Wire_Center__c modifiedNWCObj = new Network_Wire_Center__c();
        String currentNWCSegValue = null;
        String newNWCSegValue = null;
        try {
            /**************************************************************
             * System.debug('(WCSegCalloutHelper.checkNWCForUpdates) Incoming nwcNamesOnlyList.size() = ' + nwcNamesOnlyList.size() + '  AND curNWCList.size() = ' + curNWCList.size() + '  AND nwcRespList.size() = ' + nwcRespList.size());
             **************************************************************/ 
            if (nwcNamesOnlyList == null || nwcNamesOnlyList.isEmpty() || curNWCList == null || curNWCList.isEmpty() || nwcRespList == null || nwcRespList.isEmpty()) {
                throw new NullObjectException('EXCEPTION! One or more input lists were null or empty. No update was possible.');
            }
            for (BRAIN_WCSeg_Response__c nwcSegResponse : nwcRespList) {
                existingNWC = null;
                Integer foundAtIdx = nwcNamesOnlyList.indexOf(nwcSegResponse.clliCode__c);	
                if (foundAtIdx > -1) {
                    existingNWC = curNWCList.get(foundAtIdx);
                }
                if (existingNWC == null || String.isBlank(existingNWC?.Name) || nwcSegResponse == null || nwcSegResponse?.Network_Wire_Center_Master__c == null || String.isBlank(nwcSegResponse?.Network_Wire_Center_Master__r?.Name) || String.isBlank(nwcSegResponse?.clliCode__c) || !existingNWC?.Name.equalsIgnoreCase(nwcSegResponse?.clliCode__c) || !existingNWC.Name.equalsIgnoreCase(nwcSegResponse.Network_Wire_Center_Master__r.Name)) {
	                throw new NamesDoNotMatchException('EXCEPTION!  The existing Wire Center object, id, master or name value was NULL or BLANK or the BRAIN_WCSegResponse object was NULL or the 2 names simply do NOT match up.  No update was possible.');
                }
                /*********************************************
                * System.debug('(WCSegCalloutHelper.checkNWCForUpdates) EXISTS!  nwcSegResponse.clliCode__c (' + nwcSegResponse.clliCode__c + ') was FOUND to match an existing Network-Wire-Center at position ' + foundAtIdx + ' {' + curNWCList.get(foundAtIdx).Name + '}.');
                **********************************************/ 
                System.debug('(WCSegCalloutHelper.checkNWCForUpdates) base-WCSegResponse == null? ' + (nwcSegResponse==null) + ',   SO nwcSegResponse.Id = ' + (nwcSegResponse!=null ? nwcSegResponse.Id : null) + '  AND nwcSegResponse.Network_Wire_Center_Master__c = ' + (nwcSegResponse!=null ? nwcSegResponse.Network_Wire_Center_Master__c : null) +
                             '  AND nwcSegResponse.clliCode__c = ' + (nwcSegResponse!=null ? nwcSegResponse.clliCode__c : null)  + '  AND nwcSegResponse.assignedTreatment__c = ' + (nwcSegResponse!=null ? nwcSegResponse.assignedTreatment__c : null) + 
                             '  AND existingNWC.Id = ' + existingNWC.Id + '  AND existingNWC.Name = ' + existingNWC.Name + '  AND existingNWC.Wire_Center_Segmentation__c = ' + existingNWC.Wire_Center_Segmentation__c);
                
                modifiedNWCObj = new Network_Wire_Center__c();                                    
                /*********************************************************
                * System.debug('(WCSegCalloutHelper.checkNWCForUpdates) Incoming nwcSegResponse.Network_Wire_Center_Master__r.Name was NOT BLANK');
                * System.debug('(WCSegCalloutHelper.checkNWCForUpdates) Incoming existingNWC.Name (' + existingNWC.Name + ') == nwcRespObj.Network_Wire_Center_Master__r.Name(' + nwcRespObj.Network_Wire_Center_Master__r.Name + ') ? ' + (existingNWC.Name == nwcRespObj.Network_Wire_Center_Master__r.Name));
                *********************************************************/ 
                if (!String.isBlank(existingNWC.Wire_Center_Segmentation__c) && !String.isBlank(nwcSegResponse.assignedTreatment__c) && existingNWC.Wire_Center_Segmentation__c.equalsIgnoreCase(nwcSegResponse.assignedTreatment__c)) {
                    modifiedNWCObj = existingNWC;
                    /*******************************************
                    * System.debug('(WCSegCalloutHelper.checkNWCForUpdates) Modified Network-Wire-Center-CLLI Id ' + modifiedNWCObj.Id + ' should match with current Id ' + existingNWC.Id + ' -- does it? ' + (modifiedNWCObj.Id == existingNWC.Id));
                    *******************************************/ 
                    modifiedNWCObj.Name = existingNWC.Name;
                    modifiedNWCObj.Wire_Center_Segmentation__c = nwcSegResponse.assignedTreatment__c;
                    System.debug('(WCSegCalloutHelper.checkNWCForUpdates) Modified Network-Wire-Center-CLLI of ' + modifiedNWCObj.Name + ' with Id ' + modifiedNWCObj.Id + '  from existing Segmentation value ' + currentNWCSegValue + ' with new Segmentation value ' + newNWCSegValue);
                    System.debug('(WCSegCalloutHelper.checkNWCForUpdates) Updating Network-Wire-Center-CLLI Id ' + modifiedNWCObj.Id + ' should match with current Id ' + existingNWC.Id + ' -- does it? ' + (modifiedNWCObj.Id == existingNWC.Id));
                    updatedNWCList.add(modifiedNWCObj);
                }
            }//end for-loop through HttpResponse list
        } catch(Exception modifyX) {
            System.debug('(WCSegCalloutHelper.checkNWCForUpdates) EXCEPTION! \n Type: ' + modifyX.getTypeName() + EXC_MSG + modifyX.getMessage() + EXC_LINE + modifyX.getLineNumber() + EXC_TRACE + modifyX.getStackTraceString());
        }        
        return updatedNWCList;
    }//end method checkNWCForUpdates    
    
    @AuraEnabled
    public static void updateWCSegmentation(List<Network_Wire_Center__c> nwcWithUpdatesList) {
        try {
            if (Network_Wire_Center__c.SObjectType.getDescribe().isCreateable() == false && Network_Wire_Center__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (nwcWithUpdatesList != null && nwcWithUpdatesList.size() > 0) {
				update nwcWithUpdatesList;
            } else {
                throw new ZeroListException('EXCEPTION!  The list of Network_Wire_center__c objects with updates contained 0 records.  No updates were performed.');
            }
        } catch(Exception updateX) {
            System.debug('(WCSegCalloutHelper.updateWCSegmentation) EXCEPTION! \n Type: ' + updateX.getTypeName() + EXC_MSG + updateX.getMessage() + EXC_LINE + updateX.getLineNumber() + EXC_TRACE + updateX.getStackTraceString());
        }        
    }//end method updateWCSegmentation

    public static Transaction_Summary__c createAPITransSummary(String wcSegRequestCLLI) {
        Transaction_Summary__c wcSegAPITransSummary = new Transaction_Summary__c();
        
        try {
            //create a new transactionSummary
            wcSegAPITransSummary = new Transaction_Summary__c(
                WireCenter__c = wcSegRequestCLLI,
                Source_System__c = 'BRAIN-WCSeg'
            );
            if (Transaction_Summary__c.SObjectType.getDescribe().isCreateable() == false && Transaction_Summary__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            insert wcSegAPITransSummary;
            
        } catch (Exception createX) {
            System.debug('(WCSegCalloutHelper.createAPITransSummary) EXCEPTION! \n Type: ' + createX.getTypeName() + EXC_MSG + createX.getMessage() + EXC_LINE + createX.getLineNumber() + EXC_TRACE + createX.getStackTraceString());
        }//end catch

        return wcSegAPITransSummary;        
    }//end method createAPITransSummary
    
    public class ApiTransactionParams {
        public String callingApiName;
        public String requestBody;
        public String responseBody;
        public Integer responseStatusCode;
        public String responseStatus;
        public String requestEndpoint;
        public Time startTime;
        public Time endTime;
        public String errorDetails;
        public String wcSegAPITransSummaryId;
    }

    public static API_Transaction__c createApiTransaction(ApiTransactionParams params) {
        String apiTrimResponse = null;
        API_Transaction__c objApiTransaction = new API_Transaction__c();
        
        // If the API Name is not null or blank then proceed
        if (String.isBlank(params.callingApiName)) {
            String debugMsg = 'The Calling API-Name was not valid.  API Transaction was not recorded.';
            objApiTransaction.Error_Message__c = debugMsg;
            return objApiTransaction;
        }
        try {
            // Create API Transaction record
            objApiTransaction.API_Name__c = params.callingApiName;
            objApiTransaction.API_Request_JSON__c = params.requestBody != null && params.requestBody != '' ? params.requestBody : null;
            
            // If the http response body is not null or blank then proceed
            if(String.isNotBlank(params.responseBody))
            {
                apiTrimResponse = params.responseBody;
            }                
            else if (String.isNotBlank(params.errorDetails)) // If there are any error details then add that in the API Response field. 
            {
                apiTrimResponse = params.errorDetails;
            }
            apiTrimResponse = apiTrimResponse?.remove('\n\t\r');
                
            // If the response char length is greater than 131072 them trim & abbreviate it
            while (apiTrimResponse?.length() > 131072) 
            {
                apiTrimResponse = apiTrimResponse?.trim();                    
                apiTrimResponse = apiTrimResponse?.abbreviate(131072);
            }
            objApiTransaction.API_Response_JSON__c = apiTrimResponse;

            objApiTransaction.Internal_Message_Code__c = params.responseStatus != null && params.responseStatus != '' ? params.responseStatus : '';
            objApiTransaction.EndPoint__c = params.requestEndpoint != null && params.requestEndpoint != '' ? params.requestEndpoint : 'There is no end point';
            
            //Remove added path parameters from endpoint                
            Integer position = objApiTransaction.EndPoint__c.indexOfAny('?');
            objApiTransaction.EndPoint__c = objApiTransaction.EndPoint__c.left(position);
            objApiTransaction.API_Status_Code__c = params.responseStatusCode != null && params.responseStatusCode != 0 ? String.valueOf(params.responseStatusCode) : '';
            objApiTransaction.Request_Time__c = params.startTime;
            objApiTransaction.Response_Time__c = params.endTime;                
            objApiTransaction.Transaction_Summary_Id__c = params.wcSegAPITransSummaryId;                
            List<API_Transaction__c> apiTransList = new List<API_Transaction__c>();
            apiTransList.add(objApiTransaction);
            
            // If there is at least single API Transaction then insert it
            if(apiTransList?.size() > 0)
            {
                insert apiTransList;
            }            
            return apiTransList?.get(0);
        } catch (Exception apiX) {
            String debugMsg = 'API Trasansaction Record Create Error: EXCEPTION! \n Type: ' + apiX.getTypeName() + EXC_MSG + apiX.getMessage() + EXC_LINE + apiX.getLineNumber() + EXC_TRACE + apiX.getStackTraceString();
            System.debug('(BRAINFACalloutHelper.createApiTransaction) ' + debugMsg);
            objApiTransaction.Error_Message__c = debugMsg;
            return objApiTransaction;
        }//end catch       
    }//end method createApiTransaction
    
    public class WCSearchResult {
        public String id;
        public String clliData;
        public String address;
        public String city;
        public String stateCode;
        public String zipCode;
        public String county;
        public Decimal sumSquareMiles;
        public Integer centralOfficeCount;
        public String wirecenterName;
        public String companySapId;
        public String assignedTreatment;
        public override String toString() {
            String outString = '{ ';
            outString += '\n "id": "' + id + '", ';
            outString += '\n "clliData": "' + clliData + '", ';
            outString += '\n "address": "' + address + '", ';
            outString += '\n "city": "' + city + '", ';
            outString += '\n "stateCode": "' + stateCode + '", ';
            outString += '\n "zipCode": "' + zipCode + '", ';
            outString += '\n "county": "' + county + '", ';
            outString += '\n "sumSquareMiles": ' + sumSquareMiles + ', ';
            outString += '\n "centralOfficeCount": ' + centralOfficeCount + ', ';
            outString += '\n "wirecenterName": "' + wirecenterName + '", ';
            outString += '\n "companySapId": ' + ((companySapId == null) ? 'null' : '"' + companySapId + '"') + ', ';
            outString += '\n "assignedTreatment": "' + id + '" ';
            outString += '\n }';
            return outString;
        }
        
    }//end class WCSearchResult    

}//end class WCSegCalloutHelper