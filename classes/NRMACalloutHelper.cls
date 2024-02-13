/***************************************************************************************************
 * Name:  NRMACalloutHelper
 * Platform: Salesforce Connected Journey (SFCJ)
 * Helper class for BRAIN/NRMA Approval-Tool interaction between SFCJ and BRAIN API
 * Code Coverage:  TestNRMACalloutController -- 88%  01/04/2023
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 01/04/2023  	T2Cabato    Feature(Epic) ESCJ-3932	        Base version
****************************************************************************************************/
public with sharing class NRMACalloutHelper {
	public static APITransactionService apiTransactionServiceManager; 
    private static Id transactionSummaryId;
    
    private class BadStatusCodeException extends Exception {}
    private class InvalidAuthTokenException extends Exception {}
    private class InvalidHttpRequestException extends Exception {}
    private class NullObjectException extends Exception {}
    private class BlankStringException extends Exception {}
    //CONSTANTS
    private static final String BRAIN_APIGEE_AUTHORIZATION = 'Basic T2lhc2xQU0ZIQno3dDFGcnVjMEZIZDVWakhLVXZyMkU6eERkZkw5aXJqZ3ppYnJ4OQ==';
    private static final String APIGEETOKENNAMEDCRED = 'callout:SFCJ_Basic';
    private static final String APIGEETESTNAMEDCRED = 'callout:Apigee_Test_Oauth';
    private static final String APIGEEPRODNAMEDCRED = 'callout:Apigee_Prod_Oauth';
    private static final String APIGEETESTBASEURL = 'https://api-test.lumen.com';
    private static final String APIGEEPRODBASEURL = 'https://api.lumen.com';
    private static final String PATHFOROAUTHTOKEN = '/oauth/token';
    private static final String PATHFORAPPROVALTOOLREQUEST = '/Finance/v1/Capital/approvalToolRequests/nrma-requests';
    private static final String PATHFORAPPROVALTOOLSTATUS = '/Finance/v1/Capital/approvalToolRequests/nrma-requests/{nrmaRequestId}/status';
        
    private static String getAccessTokenFromApigee() {
        String accessToken = null;
        
        try {
            //request to Apigee for Token
            HttpRequest httpRequestApigee = new HttpRequest();
            String apigeeURL2Use = null;
            //identify if this is a sandbox environment
            Boolean isSandbox = System.Url.getSalesforceBaseUrl().getHost().contains('sandbox');
            System.debug('(NRMACalloutHelper.getAccessTokenFromApigee) isSandbox = ' + isSandbox);
            if (isSandbox) {
                apigeeURL2Use = APIGEETESTBASEURL;
            } else {
                apigeeURL2Use = APIGEEPRODBASEURL;
            }
            String endPointToUse = apigeeURL2Use + PATHFOROAUTHTOKEN;
            System.debug('(NRMACalloutHelper.getAccessTokenFromApigee) endPointToUse = ' + endPointToUse);
            //build httpRequest
            httpRequestApigee.setEndPoint(endPointToUse);
            httpRequestApigee.setMethod('POST');
            httpRequestApigee.setHeader('Authorization', BRAIN_APIGEE_AUTHORIZATION);
            httpRequestApigee.setHeader('Content-Length', '30');
            httpRequestApigee.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            httpRequestApigee = setCommonHeaders(httpRequestApigee);
            httpRequestApigee.setBody('grant_type=client_credentials');
            
            Http httpProtocol = new Http();
            HttpResponse httpResponseApigee = null;
	        if(Test.isRunningTest()) {
                httpResponseApigee = TestNRMACalloutHelper.getMockApigeeHttpResponse();
            } else {
	            httpResponseApigee = httpProtocol.send(httpRequestApigee);
            }
            
            if(httpResponseApigee.getStatusCode() == 200) {
                String apigeeResponseBody = httpResponseApigee.getBody();
                System.debug('(NRMACalloutHelper.getAccessTokenFromApigee) apigeeResponseBody = ' + apigeeResponseBody);
                accessToken = parseForAccessToken(apigeeResponseBody);
            } else {
                accessToken = httpResponseApigee.toString();
            }//end else statusCode NOT 200
        } catch(Exception callAuthX) {
            System.debug('(NRMACalloutHelper.getAccessTokenFromApigee) EXCEPTION! \n' + callAuthX.getTypeName() + '\n' + callAuthX.getMessage() + '\n' + callAuthX.getLineNumber() + '\n' + callAuthX.getStackTraceString());
        }
        
        return accessToken;            
    }//end method getAccessTokenFromApigee
    
    public static String parseForAccessToken(String apigeeResponseBody) {
        String accessToken = null;
        Boolean isNotAccessToken = true;
        try {
            System.debug('(NRMACalloutHelper.parseForAccessToken) apigeeResponseBody.lengthd() = ' + apigeeResponseBody.length());
            JSONParser responseJSONParser = JSON.createParser(apigeeResponseBody);
            Integer tknCtr = 0;
            responseJSONParser.nextToken();
            do {
                responseJSONParser.nextValue();
                System.debug('(NRMACalloutHelper.parseForAccessToken) thisTknName[' + tknCtr + '] = ' + responseJSONParser.getCurrentName() );
                System.debug('(NRMACalloutHelper.parseForAccessToken) thisTknText[' + tknCtr + '] = ' + responseJSONParser.getText() );
                switch on responseJSONParser.getCurrentName() {
                    when 'access_token' { 
                        if (responseJSONParser.getCurrentName() != responseJSONParser.getText()) {
                            accessToken = responseJSONParser.getText();
                            isNotAccessToken = false;
                        }
                    }//end when 'access_token' 
                    when else { 
                        isNotAccessToken = true;
                     }
                }//end switch
                tknCtr++;
            } while (responseJSONParser.nextToken() != null); //end while nextToken NOT NULL            
        } catch(Exception jsonParseX) {
            System.debug('(NRMACalloutHelper.parseForAccessToken) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
        }       
        
        return accessToken;
    }//end method parseForAccessToken

    public static HttpRequest buildHttpRequestByCallType(String callType, String requestJSON, String requestId) {
        if (callType == 'Request') {
            return buildHttpRequestForNRMARequestService(requestJSON); 
        } else {
            return buildHttpRequestForNRMAStatusService(requestId);
        }
    }//end method buildHttpRequestByCallType
    
    public static String executeCallout(List<NRMACalloutController.CalloutParams> calloutParams, String requestJSON, String requestId) {
        String responseJSON = null;
        try {            
            HttpResponse httpResponseNRMA = NRMACalloutHelper.makeServiceCallout(calloutParams, requestJSON, requestId);
            //extract the JSON-body from the HttpResponse
            responseJSON = NRMACalloutHelper.extractDataFromHttpResponse(httpResponseNRMA);
            System.debug('(NRMACalloutHelper.executeCallout) responseJSON = ' + responseJSON);
        } catch(Exception executeCalloutX) {
            System.debug('(NRMACalloutHelper.executeCallout) EXCEPTION! \n' + executeCalloutX.getTypeName() + '\n' + executeCalloutX.getMessage() + '\n' + executeCalloutX.getLineNumber() + '\n' + executeCalloutX.getStackTraceString());
            throw executeCalloutX;
        }
        return responseJSON;
    }//end method executeCallout
    
    public static HttpResponse makeServiceCallout(List<NRMACalloutController.CalloutParams> calloutParams, String requestJSON, String requestId) {
		HttpResponse httpResponseNRMA = null;
        try {
            String recordId = calloutParams.get(0).nrmaRecordId;
            String callType = calloutParams.get(0).nrmaCallType;
            //build the appropriate HttpRequest based on the specified callType (Request or Status)
            HttpRequest httpRequestNRMA = NRMACalloutHelper.buildHttpRequestByCallType(callType, requestJSON, requestId);
            if (httpRequestNRMA == null) {
                throw new NullObjectException('EXCEPTION!  The HttpRequest built for NRMA-Record ' + recordId + ' with NRMA-Request-Id "' + requestId + '" using Call-Type "' + callType + '" was NULL.');
            }
            
            //Get the HttpResponse
            httpResponseNRMA = NRMACalloutHelper.getHttpResponseFromNRMA(httpRequestNRMA);
            System.debug('(NRMACalloutHelper.makeServiceCallout) httpResponseNRMA.getStatusCode() = ' + httpResponseNRMA.getStatusCode());
            String detailsMsg = 'The Response returned from the API-Service-Callout for NRMA-Record ' + recordId + ' with NRMA-Request-Id "' + requestId + '" using Call-Type "' + callType + '" resulted in Status-Code: ' + httpResponseNRMA.getStatusCode() + '.';
            NRMACalloutHelper.logApiTransaction(httpRequestNRMA, httpResponseNRMA, detailsMsg);
        } catch(Exception makeServiceCalloutX) {
            System.debug('(NRMACalloutHelper.makeServiceCallout) EXCEPTION! \n' + makeServiceCalloutX.getTypeName() + '\n' + makeServiceCalloutX.getMessage() + '\n' + makeServiceCalloutX.getLineNumber() + '\n' + makeServiceCalloutX.getStackTraceString());
            throw makeServiceCalloutX;
        }
        return httpResponseNRMA;
    }//end method makeServiceCallout
    
    public static HttpRequest buildHttpRequestForNRMARequestService(String requestJSON) {
        HttpRequest httpRequestNRMA = new HttpRequest();
        try {
            String accessToken = NRMACalloutHelper.getAccessTokenFromApigee();
            if (String.isBlank(accessToken)) {
                throw new InvalidAuthTokenException();
            } else {                
                //request to NRMA
                httpRequestNRMA = new HttpRequest();
                System.debug('(NRMACalloutHelper.buildHttpRequestForNRMARequestService) requestJSON = \n ' + requestJSON);
                String apigeeURL2Use = null;
                //identify if this is a sandbox environment
                Boolean isSandbox = System.Url.getSalesforceBaseUrl().getHost().contains('sandbox');
                System.debug('(NRMACalloutHelper.buildHttpRequestForNRMARequestService) isSandbox = ' + isSandbox);
                if (isSandbox) {
                    apigeeURL2Use = APIGEETESTBASEURL;
                } else {
                    apigeeURL2Use = APIGEEPRODBASEURL;
                }
                String endPointToUse = apigeeURL2Use + PATHFORAPPROVALTOOLREQUEST;
                /************************************************************************
                 *  The following code would be used in conjunction with APITrancsactionService class
                 *    should that class be modified to utilize other NamedCredentials such that would
                 *    be acceptable by BRAIN API via APIGEE on api-test.lumen.com and not api-test1.lumen.com
                 *
                 *  API_Util__mdt MDT_BRAND = API_Util__mdt.getInstance('NRMANewRequest');
                 *  String endPointMDT = MDT_BRAND.Name_Endpoint__c;                
                 *
                 * 
                 ************************************************************************/
                System.debug('(NRMACalloutHelper.buildHttpRequestForNRMARequestService) endPointToUse = ' + endPointToUse);
                //build httpRequest
                httpRequestNRMA.setEndPoint(endPointToUse);
                httpRequestNRMA.setMethod('POST');
                httpRequestNRMA.setHeader('Grant_Type','Authorization Code');
                httpRequestNRMA.setHeader('Authorization', ('Bearer ' + accessToken));
                httpRequestNRMA.setHeader('Content-Length', String.valueOf(requestJSON.length()));
                httpRequestNRMA.setHeader('Content-Type', 'application/json;charset=UTF-8');
                httpRequestNRMA = setCommonHeaders(httpRequestNRMA);
                httpRequestNRMA.setBody(requestJSON);
            }//end else accessToken NOT Empty 
        } catch(Exception httpRequestX) {
            System.debug('(NRMACalloutHelper.buildHttpRequestForNRMARequestService) EXCEPTION! \n' + httpRequestX.getTypeName() + '\n' + httpRequestX.getMessage() + '\n' + httpRequestX.getLineNumber() + '\n' + httpRequestX.getStackTraceString());
        }   

		return httpRequestNRMA;        
    }//end method buildHttpRequestForNRMARequestService
    
    public static HttpRequest buildHttpRequestForNRMAStatusService(String requestId) {
        HttpRequest httpRequestNRMA = new HttpRequest();
        try {
            String accessToken = NRMACalloutHelper.getAccessTokenFromApigee();
            if (String.isBlank(accessToken)) {
                throw new InvalidAuthTokenException();
            } else {                
                //request to NRMA
                httpRequestNRMA = new HttpRequest();
                System.debug('(NRMACalloutHelper.buildHttpRequestForNRMAStatusService) requestId = \n ' + requestId);
                String apigeeURL2Use = null;
                //identify if this is a sandbox environment
                Boolean isSandbox = System.Url.getSalesforceBaseUrl().getHost().contains('sandbox');
                System.debug('(NRMACalloutHelper.buildHttpRequestForNRMAStatusService) isSandbox = ' + isSandbox);
                if (isSandbox) {
                    apigeeURL2Use = APIGEETESTBASEURL;
                } else {
                    apigeeURL2Use = APIGEEPRODBASEURL;
                }
                String endPointToUse = apigeeURL2Use + PATHFORAPPROVALTOOLSTATUS.replace('{nrmaRequestId}', requestId);
                System.debug('(NRMACalloutHelper.buildHttpRequestForNRMAStatusService) endPointToUse = ' + endPointToUse);
                //build httpRequest
                httpRequestNRMA.setEndPoint(endPointToUse);
                httpRequestNRMA.setMethod('GET');
                httpRequestNRMA.setHeader('Grant_Type','Authorization Code');
                httpRequestNRMA.setHeader('Authorization', ('Bearer ' + accessToken));
                httpRequestNRMA = setCommonHeaders(httpRequestNRMA);
            }//end else accessToken NOT Empty 
        } catch(Exception httpRequestX) {
            System.debug('(NRMACalloutHelper.buildHttpRequestForNRMARequestService) EXCEPTION! \n' + httpRequestX.getTypeName() + '\n' + httpRequestX.getMessage() + '\n' + httpRequestX.getLineNumber() + '\n' + httpRequestX.getStackTraceString());
        }   

		return httpRequestNRMA;        
    }//end method buildHttpRequestForNRMAStatusService

    private static HttpRequest setCommonHeaders(HttpRequest httpRequestIn) {
        httpRequestIn.setHeader('Cache-Control', 'no-cache');
        httpRequestIn.setHeader('Accept', '*/*');
        httpRequestIn.setHeader('Accept-Encoding', 'gzip, deflate, br');
        httpRequestIn.setHeader('Connection', 'keep-alive');
        return httpRequestIn;
    }//end method setCommonHeaders
    
    public static HttpResponse getHttpResponseFromNRMA(HttpRequest httpRequestNRMA) {        
        HttpResponse httpResponseNRMA = new HttpResponse();
        Http httpProtocol = new Http();

        try {
            if (httpRequestNRMA == null) {
                throw new InvalidHttpRequestException();                        
            } else {
                try {
                    if(Test.isRunningTest()) {
                        httpResponseNRMA = TestNRMACalloutHelper.getHttpResponseFromStaticResource();
                    } else {
                        httpResponseNRMA = httpProtocol.send(httpRequestNRMA);
                    }
                } catch(Exception sendX) {
                    System.debug('(NRMACalloutHelper.getHttpResponseFromNRMARequestService) EXCEPTION! \n' + sendX.getTypeName() + '\n' + sendX.getMessage() + '\n' + sendX.getLineNumber() + '\n' + sendX.getStackTraceString());
                }   
            }//end else httpRequestNRMA NOT NULL
        } catch(Exception callOutX) {
            System.debug('(NRMACalloutHelper.getHttpResponseFromNRMARequestService) EXCEPTION! \n' + callOutX.getTypeName() + '\n' + callOutX.getMessage() + '\n' + callOutX.getLineNumber() + '\n' + callOutX.getStackTraceString());
            throw callOutX;
        }
        return httpResponseNRMA;
    }//end method getHttpResponseFromNRMA
    
    public static String extractDataFromHttpResponse(HttpResponse responseNRMA) {
        String bodyJSON = null;
        
        try {
            if(responseNRMA.getStatusCode() == 200 || responseNRMA.getStatusCode() == 400 || responseNRMA.getStatusCode() == 500 || responseNRMA.getStatusCode() == 503) {
                bodyJSON = responseNRMA.getBody();
                System.debug('(NRMACalloutHelper.extractDataFromHttpResponse) bodyJSON: \n' + bodyJSON);
            } else {
                throw new BadStatusCodeException(responseNRMA.getStatusCode() + ': ' + responseNRMA.getStatus());
            }
        } catch(Exception extractX) {
            System.debug('(NRMACalloutHelper.extractDataFromHttpResponse) EXCEPTION! \n' + extractX.getTypeName() + '\n' + extractX.getMessage() + '\n' + extractX.getLineNumber() + '\n' + extractX.getStackTraceString());
            throw extractX;
        }
        
        return bodyJSON;
    }//end method extractDataFromHttpResponse

    public static void logApiTransaction(HttpRequest httpRequestNRMA, HttpResponse httpResponseNRMA, String detailsMsg) {

        // Create API Transaction record for history and reports
        NRMACalloutHelper.RequestDetails reqDetails = new NRMACalloutHelper.RequestDetails();
        reqDetails.requestEndpoint = httpRequestNRMA?.getEndpoint();
        reqDetails.requestBody = httpRequestNRMA?.getBody();
        reqDetails.callingApiName = 'NRMAApprovalTool';
        NRMACalloutHelper.ResponseDetails resDetails = new NRMACalloutHelper.ResponseDetails();
        resDetails.responseStatus = httpResponseNRMA?.getStatus();
        resDetails.responseStatusCode = httpResponseNRMA?.getStatusCode();
        resDetails.responseBody = httpResponseNRMA?.getBody();
        NRMACalloutHelper.TransactionDetails trDetails = new NRMACalloutHelper.TransactionDetails();
        trDetails.startTime = DateTime.now().Time();
        trDetails.endTime = DateTime.now().Time();
        trDetails.errorDetails = detailsMsg;
        trDetails.transactionSummaryId = null;
        NRMACalloutHelper.createApiTransaction(
            reqDetails,
            resDetails,
            trDetails);
    	    
    }//end method logApiTransaction
    
    public static String trimString(String targetString) {
        String trimmedString = null;
        if (targetString?.length() > 131072) {
            trimmedString = targetString?.remove('\n\t\r')?.trim();            
            if(trimmedString?.length() > 131072) {
                trimmedString = trimmedString?.abbreviate(131072);
            }
        } else {
            trimmedString = targetString;
        }
        return trimmedString;
    }//end method trimString

    private static void createApiTransaction(
        RequestDetails 	reqDetails,
        ResponseDetails respDetails,
        TransactionDetails trDetails)
    {            
        List<API_Transaction__c> apiTransactions = new List<API_Transaction__c>();
        API_Transaction__c objApiTransaction = new API_Transaction__c();
        
        // Create API Transaction record
        objApiTransaction.API_Name__c = reqDetails.callingApiName;
        
        objApiTransaction.API_Request_JSON__c = reqDetails.requestBody;

        String apiTrimResponse = (String.isNotEmpty(respDetails.responseBody)) ? respDetails.responseBody : trDetails.errorDetails;
                
        objApiTransaction.API_Response_JSON__c = trimString(apiTrimResponse);


        objApiTransaction.Internal_Message_Code__c = respDetails.responseStatus;
        objApiTransaction.EndPoint__c = (String.isNotEmpty(reqDetails.requestEndpoint)) ? reqDetails.requestEndpoint : 'There is no end point';

        Integer position = objApiTransaction.EndPoint__c.indexOfAny('?');
        objApiTransaction.EndPoint__c = objApiTransaction.EndPoint__c.left(position);
                
        System.debug('endpoint url: '+ objApiTransaction.EndPoint__c);
                
        objApiTransaction.API_Status_Code__c = String.isNotEmpty(respDetails.responseStatusCode.format()) ? respDetails.responseStatusCode.format().isNumeric() ? String.valueOf(respDetails.responseStatusCode) : '' : '';
        objApiTransaction.Request_Time__c = trDetails.startTime;
        objApiTransaction.Response_Time__c = trDetails.endTime;
                
        objApiTransaction.Transaction_Summary_Id__c = trDetails.transactionSummaryId;

        apiTransactions.add(objApiTransaction);

        // If there is atleast single API Transaction then insert it
        if(apiTransactions?.size() > 0) {
            try {
                if (API_Transaction__c.SObjectType.getDescribe().isCreateable() == true) {
                    insert apiTransactions;
                    System.debug('API Transaction record inserted Id-->'+apiTransactions[0].id);
                } else {
                    throw new DmlException('No permissions to update.');
                }
            } catch (Exception e) {
                System.debug(
                    'API Trasansaction Record Create Error: ' + e.getMessage() + ' | ' +
                    'Line number - '+e.getLineNumber()
                );
            }
        }//emd if size > 0
                
    }//end method createApiTransaction
    
    /**********************************************************************************************
    Purpose: To get API details from API Utils custom metadata
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************
    **** private static API_Util__mdt getApiUtils(String apiUtilName) {
    ****     API_Util__mdt apiUtil;
    ****     if (apiUtilName != null || apiUtilName != '') {
    ****         apiUtil = [SELECT DeveloperName, EndPoint__C FROM API_Util__mdt WHERE DeveloperName = :apiUtilName];
    ****     }
    ****     return apiUtil;
    **** }//end method getApiUtils
	************************************************************************************************/

    private class ResponseDetails {
        private String 	responseStatus;
        private Integer responseStatusCode;
        private String 	responseBody;
    }//end class ResponseDetails

    private class RequestDetails {
        private String 	requestEndpoint;
        private String 	requestBody;
        private String 	callingApiName;
    }//end class RequestDetails

    private class TransactionDetails {
        private Time 	startTime;
        private Time 	endTime;
        private String   errorDetails;
        private String 	transactionSummaryId;
    }
}//end class NRMACalloutHelper