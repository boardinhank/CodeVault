/***************************************************************************************************
 * Name:  BRAINFACalloutHelper
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFACalloutHelper -- 88%  05/12/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 06/23/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version extracted from BRAINFACalloutHelper
 * 01/27/2023   T2Cabato    Story ESCJ-2365                 Revised per Story
 * 06/13/2023   T2Cabato    QFCJ-3801                       BRAIN-AutoSubmit-Messaging
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
 * 08/02/2023   T2Cabato    QFCJ-4286                       BRAIN-Drop-Cost-Fix
 * 08/15/2023   T2Cabato    QFCJ-4282                       BRAIN-ONT-Model-Mapping
 * 08/15/2023   T2Cabato    QFCJ-4297                       BRAIN-UPS-Shelf-to-idfElectronics-for-BRAIN
 * 08/15/2023   T2Cabato    QFCJ-4309                       BRAIN-ContractType-and-OtherProviderContractType-Mapping
 * 08/18/2023   T2Cabato    QFCJ-4397                       Heap-Size-Too-Large on manual Submit to BRAIN
 * 08/23/2023   T2Cabato    eGCR-0222347                    BRAIN_APIGEE_PROD_AUTHORIZATION
 * 09/28/2023   T2Cabato    QFCJ-4625/26/27/28              BRAIN-Financial-Analysis-Failures
 * 11/17/2023   T2Cabato    QFCJ-4712                       Capital Design - Wire Center Segmentation Update Automation 
****************************************************************************************************/
public class BRAINFACalloutHelper {
    public class BadStatusCodeException extends Exception {}
    public class InvalidAuthTokenException extends Exception {}
    public class InvalidHttpRequestException extends Exception {}
    
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
            System.debug('(BRAINFACalloutHelper.getAccessTokenFromApigee) endPointToUse = ' + endPointToUse);
            
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
            System.debug('(BRAINFinancialAnalysesCalloutHelper.getAccessTokenFromApigee) BEGIN http.Send with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            HttpResponse httpResponseApigee = httpProtocol.send(httpRequestApigee);
            System.debug('(BRAINFinancialAnalysesCalloutHelper.getAccessTokenFromApigee) END http.Send with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

			httpRequestApigee = null;            
            if(httpResponseApigee.getStatusCode() == 200) {                
                System.debug('(BRAINFACalloutHelper.getAccessTokenFromApigee) httpResponseApigee.getBody() = ' + httpResponseApigee.getBody());
                accessToken = parseForAccessToken(httpResponseApigee.getBody());
            } else {
                accessToken = httpResponseApigee.toString();
            }//end else statusCode NOT 200
            System.debug('(BRAINFACalloutHelper.getAccessTokenFromApigee) accessToken = ' + accessToken);
        } catch(Exception callAuthX) {
            System.debug('(BRAINFACalloutHelper.getAccessTokenFromApigee) EXCEPTION! \n Type: ' + callAuthX.getTypeName() + '\n Message:  ' + callAuthX.getMessage() + '\n Line#: ' + callAuthX.getLineNumber() + '\n StackTrace:  ' + callAuthX.getStackTraceString());
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
                System.debug('(BRAINFACalloutHelper.getAccessTokenFromApigee) thisTokenName[' + tokenCtr + '] = ' + responseJSONParser.getCurrentName() );
                System.debug('(BRAINFACalloutHelper.getAccessTokenFromApigee) thisTokenText[' + tokenCtr + '] = ' + responseJSONParser.getText() );                        
                switch on responseJSONParser.getCurrentName() {
                    when 'access_token' {
                        if (responseJSONParser.getCurrentName() != responseJSONParser.getText()) {
                            accessToken = responseJSONParser.getText();
                        }
                    }//end when 'access_token'
                }//end switch
                tokenCtr++;
            } while (responseJSONParser.nextToken() != null); //end while nextToken NOT NULL       
            responseJSONParser = null;
        } catch(Exception jsonParseX) {
            System.debug('(BRAINFACalloutHelper.parseForAccessToken) EXCEPTION! \n Type: ' + jsonParseX.getTypeName() + '\n Message:  ' + jsonParseX.getMessage() + '\n Line#: ' + jsonParseX.getLineNumber() + '\n StackTrace:  ' + jsonParseX.getStackTraceString());
        }       
        
        return accessToken;
    }//end method parseForAccessToken

    public static HttpRequest buildHttpRequestForBRAINFAService(String accessToken, String requestJSON) {
        HttpRequest httpRequestBRAIN = new HttpRequest();
        try {
            if (String.isBlank(accessToken)) {
                throw new InvalidAuthTokenException();
            } else {                
                //request to BRAIN
                httpRequestBRAIN = new HttpRequest();
                System.debug('(BRAINFACalloutHelper.buildHttpRequestForBRAINFAService) requestJSON = \n ' + requestJSON);
                String apigeeURL2Use = null;
                //identify if this is a sandbox environment
                Boolean isSandbox = [SELECT IsSandbox, Id FROM Organization].IsSandbox;
                if (isSandbox) {
                    apigeeURL2Use = System.Label.ApigeeBRAINTestBaseURL;
                } else {
                    apigeeURL2Use = System.Label.ApigeeBRAINProdBaseURL;
                }
                String endPointToUse = apigeeURL2Use + System.Label.BRAINFA_Path;
                httpRequestBRAIN.setEndPoint(endPointToUse);
                httpRequestBRAIN.setMethod('POST');
                httpRequestBRAIN.setHeader('Grant_Type','Authorization Code');
                httpRequestBRAIN.setHeader('Authorization', ('Bearer ' + accessToken));
                httpRequestBRAIN.setHeader('Cache-Control', 'no-cache');
                httpRequestBRAIN.setHeader('Content-Length', String.valueOf(requestJSON.length()));
                httpRequestBRAIN.setHeader('Content-Type', 'application/json;charset=UTF-8');
                httpRequestBRAIN.setHeader('Accept', '*/*');
                httpRequestBRAIN.setHeader('Accept-Encoding', 'gzip, deflate, br');
                httpRequestBRAIN.setHeader('Connection', 'keep-alive');
                httpRequestBRAIN.setBody(requestJSON);
            }//end else accessToken NOT Empty 
        } catch(Exception httpRequestX) {
            System.debug('(BRAINFACalloutHelper.buildHttpRequestForBRAINFAService) EXCEPTION! \n Type: ' + httpRequestX.getTypeName() + '\n Message:  ' + httpRequestX.getMessage() + '\n Line#: ' + httpRequestX.getLineNumber() + '\n StackTrace:  ' + httpRequestX.getStackTraceString());
        }   

		return httpRequestBRAIN;        
    }//end method buildHttpRequestForBRAINFAService
    
    public static HttpResponse getHttpResponseFromBRAINFAService(HttpRequest httpRequestBRAIN) {        
        HttpResponse httpResponseBRAIN = new HttpResponse();
        Http httpProtocol = new Http();
        Time startTime;
      	Time endTime;	
        String callingApiName = 'BRAINFinancialAnalyses';
        String errorMsg = null;

        try {
            if (httpRequestBRAIN == null) {
                throw new InvalidHttpRequestException();                        
            } else {
                try {
		            System.debug('(BRAINFinancialAnalysesCalloutHelper.getHttpResponseFromBRAINFAService) BEGIN http.Send with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    httpResponseBRAIN = httpProtocol.send(httpRequestBRAIN);
		            System.debug('(BRAINFinancialAnalysesCalloutHelper.getHttpResponseFromBRAINFAService) END http.Send with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                } catch(Exception sendX) {
                    System.debug('(BRAINFACalloutHelper.getHttpResponseFromBRAINFAService) EXCEPTION! \n Type: ' + sendX.getTypeName() + '\n Message:  ' + sendX.getMessage() + '\n Line#: ' + sendX.getLineNumber() + '\n StackTrace:  ' + sendX.getStackTraceString());
                }   
            }//end else httpRequestBRAIN NOT NULL
        } catch(Exception callOutX) {
            System.debug('(BRAINFACalloutHelper.getHttpResponseFromBRAINFAService) EXCEPTION! \n Type: ' + callOutX.getTypeName() + '\n Message:  ' + callOutX.getMessage() + '\n Line#: ' + callOutX.getLineNumber() + '\n StackTrace:  ' + callOutX.getStackTraceString());
        }
        return httpResponseBRAIN;
    }//end method getHttpResponseFromBRAINFAService
    
    public static Boolean canExtractDataFromHttpResponse(HttpResponse responseBRAIN, String faRequestId) {
        
        try {
            System.debug('(BRAINFACalloutHelper.canExtractDataFromHttpResponse) For faRequestId = ' + faRequestId + ' \n responseBRAIN.getStatusCode() = ' + responseBRAIN.getStatusCode() + ' \n responseBRAIN.getStatus() = ' + responseBRAIN.getStatus());
            if(responseBRAIN.getStatusCode() >= 200) {
	            System.debug('(BRAINFinancialAnalysesCalloutHelper.canExtractDataFromHttpResponse) BEGIN response.getBody() with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                if (responseBRAIN.getStatusCode() > 300) {
                    BRAIN_Automation_Fault__c baFault = buildBaseFaultFromHttpResponse(responseBRAIN);
                    associateFaultToCapDesignByRequestId(baFault, faRequestId);
                }
	            System.debug('(BRAINFinancialAnalysesCalloutHelper.canExtractDataFromHttpResponse) END response.getBody() with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
		        return true;
            } else {
                throw new BadStatusCodeException(responseBRAIN.getStatusCode() + ': ' + responseBRAIN.getStatus());
            }
        } catch(Exception extractX) {
            System.debug('(BRAINFACalloutHelper.canExtractDataFromHttpResponse) EXCEPTION! \n Type: ' + extractX.getTypeName() + '\n Message:  ' + extractX.getMessage() + '\n Line#: ' + extractX.getLineNumber() + '\n StackTrace:  ' + extractX.getStackTraceString());
            //bodyJSON = extractX.getMessage();
	        return false;
        }
    }//end method canExtractDataFromHttpResponse
    
    public static String createApiTransaction (
        HttpResponse httpResp,
        HttpRequest httpReq,
        String 	callingApiName,
        Time 	startTime,
        Time 	endTime,
        String 	errorDetails,
        String faRequestId)
    {            
		List<String> errorList;
        BRAINFAResponseWrap faRespWrap = new BRAINFAResponseWrap();
        
        // If the API Name is not null or blank then proceed
        if (String.isNotBlank(callingApiName)) 
        {
            try 
            {
                List<API_Transaction__c> apiTransactions = new List<API_Transaction__c>();
                
	            System.debug('(BRAINFinancialAnalysesCalloutHelper.extractDataFromHttpResponse) BEGIN create API_Transaction__c with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                // Create API Transaction record
                API_Transaction__c objApiTransaction = new API_Transaction__c();
                objApiTransaction.API_Name__c = callingApiName;
                objApiTransaction.API_Type__c = 'System';
                objApiTransaction.API_Request_JSON__c = String.isNotBlank(httpReq.getBody()) ? httpReq.getBody() : null;
                
                // If the http response body is not null or blank then proceed
                if (String.isNotBlank(httpResp.getBody()))
                {
	                faRespWrap = BRAINFAResponseHelper.parseJSONForFAResponse(httpResp.getBody());
                    if (String.isNotBlank(faRespWrap.errorMessage)) {                        
		                objApiTransaction.Error_Message__c = 'ERROR! Call to BRAIN Financial Analyses resulted in an error.  ' + faRespWrap.errorMessage;
		                objApiTransaction.API_Status__c = 'Error';
                    } else {
		                objApiTransaction.API_Status__c = 'Success';
                    }                    
                    
                    // If the response char length is greater than 131072 them trim & abbreviate it
                    if (httpResp?.getBody()?.length() > 131072) 
                    {
                        httpResp.setBody(httpResp?.getBody()?.remove('\n\t\r').trim());
                        
                        if(httpResp?.getBody()?.length() > 131072) 
                        {
                            objApiTransaction.API_Response_JSON__c = httpResp?.getBody()?.abbreviate(131072);
                        }
                    } else {
                        objApiTransaction.API_Response_JSON__c = httpResp?.getBody();
                    }
                }                
                else if (errorDetails != null && errorDetails != '') // If there are any error details then add that in the API Response field. 
                {
                    objApiTransaction.API_Response_JSON__c = errorDetails;
	                objApiTransaction.API_Status__c = 'Error';
	                objApiTransaction.Error_Message__c = 'ERROR! Call to BRAIN Financial Analyses resulted in an error.  ' + errorDetails;
                }
                
                objApiTransaction.Internal_Message_Code__c = String.isNotBlank(httpResp.getStatus()) ? httpResp.getStatus() : '';
                objApiTransaction.EndPoint__c = String.isNotBlank(httpReq.getEndpoint()) ? httpReq.getEndpoint() : 'There is no end point';

				//spk Trim endpoint to remove any id/pwd by chance...                
                Integer position = objApiTransaction.EndPoint__c.indexOfAny('?');
                objApiTransaction.EndPoint__c = objApiTransaction.EndPoint__c.left(position);
                
                system.debug('(BRAINFACalloutHelper.createApiTransaction) endpoint url: '+ objApiTransaction.EndPoint__c);
                
                objApiTransaction.API_Status_Code__c = httpResp.getStatusCode() != null && httpResp.getStatusCode() != 0 ? String.valueOf(httpResp.getStatusCode()) : '';
                objApiTransaction.Request_Time__c = startTime;
                objApiTransaction.Response_Time__c = endTime;
                
                List<BRAIN_API_Call_Tracker__c> bactList = BRAINFAObjectSOQLManager.queryBACTListByRequestId(faRequestId);
                System.debug('(BRAINFACalloutHelper.createApiTransaction) faRequestId=' + faRequestId + '  AND Call-Tracker=' + bactList?.get(0)?.Id);
                
                objApiTransaction.BRAIN_API_Call_Tracker__c = bactList?.get(0)?.Id;
                
                apiTransactions.add(objApiTransaction);
	            System.debug('(BRAINFinancialAnalysesCalloutHelper.extractDataFromHttpResponse) END create API_Transaction__c with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
				objApiTransaction = null;
                
                // If there is atleast single API Transaction then insert it
                if(apiTransactions?.size() > 0)
                {
                    insert apiTransactions;
                }
                
                System.debug('(BRAINFACalloutHelper.createApiTransaction) API Transaction record inserted Id-->'+apiTransactions[0].id);
                
                for (BRAIN_API_Call_Tracker__c bact : bactList) {
                    bact.API_Transaction__c = apiTransactions[0].id;
                }
                upsert bactList;
                
                String apiTransId = apiTransactions[0].id.to15();

                //clear HEAP
                bactList = null;
                objApiTransaction = null;
				faRespWrap = null;
                apiTransactions = null;
                
                return apiTransId;
            } catch (Exception apiX) {
                /* Note - This exception should be added in the error list after the clarification
                of transaction summary object and error list to be added in transaction summary*/
                //errorList?.add('API Trasansaction Record Create Error: ' + e.getMessage());
                // For now just printing the error incase API transaction record creation fails
    			faRespWrap = null;
	            String debugMsg = 'API Trasansaction Record Create Error: EXCEPTION! \n Type: ' + apiX.getTypeName() + '\n Message:  ' + apiX.getMessage() + '\n Line#: ' + apiX.getLineNumber() + '\n StackTrace:  ' + apiX.getStackTraceString();
                System.debug('(BRAINFACalloutHelper.createApiTransaction) ' + debugMsg);
                return debugMsg;
            } 
        } else {
			faRespWrap = null;
    		String debugMsg = 'The Calling API-Name was not valid.  API Transaction was not recorded.';
            return debugMsg;
        }
    }//end method createApiTransaction
    
    public static String extractDataFromHttpResponse(HttpResponse responseBRAIN, String faRequestId) {
        String bodyJSON = null;
        
        try {
            System.debug('(BRAINFACalloutHelper.extractDataFromHttpResponse) For faRequestId = ' + faRequestId + ' \n responseBRAIN.getStatusCode() = ' + responseBRAIN.getStatusCode() + ' \n responseBRAIN.getStatus() = ' + responseBRAIN.getStatus() + ' \n responseBRAIN.getBody() = ' + responseBRAIN.getBody());
            if(responseBRAIN.getStatusCode() >= 200) {
                bodyJSON = responseBRAIN.getBody();
                if (responseBRAIN.getStatusCode() > 300) {
                    BRAIN_Automation_Fault__c baFault = buildBaseFault(responseBRAIN.getStatus(), responseBRAIN.getBody());
                    associateFaultToCapDesignByRequestId(baFault, faRequestId);
                }
            } else {
                throw new BadStatusCodeException(responseBRAIN.getStatusCode() + ': ' + responseBRAIN.getStatus());
            }
        } catch(Exception extractX) {
            System.debug('(BRAINFACalloutHelper.extractDataFromHttpResponse) EXCEPTION! \n Type: ' + extractX.getTypeName() + '\n Message:  ' + extractX.getMessage() + '\n Line#: ' + extractX.getLineNumber() + '\n StackTrace:  ' + extractX.getStackTraceString());
            //bodyJSON = extractX.getMessage();
        }
        
        return bodyJSON;
    }//end method extractDataFromHttpResponse
    
    public static String createApiTransaction (
        String 	responseStatus,
        Integer responseStatusCode,
        String 	responseBody,
        String 	requestEndpoint,
        String 	requestBody,
        String 	callingApiName,
        Time 	startTime,
        Time 	endTime,
        String 	errorDetails,
        String faRequestId)
    {            
		List<String> errorList;
        BRAINFAResponseWrap faRespWrap = new BRAINFAResponseWrap();
        
        // If the API Name is not null or blank then proceed
        if (String.isNotBlank(callingApiName)) 
        {
            try 
            {
                List<API_Transaction__c> apiTransactions = new List<API_Transaction__c>();
                
                // Create API Transaction record
                API_Transaction__c objApiTransaction = new API_Transaction__c();
                objApiTransaction.API_Name__c = callingApiName;
                objApiTransaction.API_Type__c = 'System';
                objApiTransaction.API_Request_JSON__c = requestBody != null && requestBody != '' ? requestBody : null;

                // If the http response body is not null or blank then proceed
                if (responseBody != null && responseBody != '')
                {
	                faRespWrap = BRAINFAResponseHelper.parseJSONForFAResponse(responseBody);
                    if (String.isNotBlank(faRespWrap.errorMessage)) {                        
		                objApiTransaction.Error_Message__c = 'ERROR! Call to BRAIN Financial Analyses resulted in an error.  ' + faRespWrap.errorMessage;
		                objApiTransaction.API_Status__c = 'Error';
                    } else {
		                objApiTransaction.API_Status__c = 'Success';
                    }
                    String apiTrimResponse = responseBody;
                    
                    // If the response char length is greater than 131072 them trim & abbreviate it
                    if (apiTrimResponse?.length() > 131072) 
                    {
                        apiTrimResponse = apiTrimResponse?.remove('\n\t\r');
                        apiTrimResponse = apiTrimResponse?.trim();
                        
                        if(apiTrimResponse?.length() > 131072) 
                        {
                            objApiTransaction.API_Response_JSON__c = apiTrimResponse?.abbreviate(131072);
                        }
                    } else {
                        objApiTransaction.API_Response_JSON__c = apiTrimResponse;
                    }
                }                
                else if (errorDetails != null && errorDetails != '') // If there are any error details then add that in the API Response field. 
                {
                    objApiTransaction.API_Response_JSON__c = errorDetails;
	                objApiTransaction.API_Status__c = 'Error';
	                objApiTransaction.Error_Message__c = 'ERROR! Call to BRAIN Financial Analyses resulted in an error.  ' + errorDetails;
                }
                
                objApiTransaction.Internal_Message_Code__c = responseStatus != null && responseStatus != '' ? responseStatus : '';
                objApiTransaction.EndPoint__c = requestEndpoint != null && requestEndpoint != '' ? requestEndpoint : 'There is no end point';

				//spk Trim endpoint to remove any id/pwd by chance...                
                Integer position = objApiTransaction.EndPoint__c.indexOfAny('?');
                objApiTransaction.EndPoint__c = objApiTransaction.EndPoint__c.left(position);
                
                system.debug('(BRAINFACalloutHelper.createApiTransaction) endpoint url: '+ objApiTransaction.EndPoint__c);
                
                objApiTransaction.API_Status_Code__c = responseStatusCode != null && responseStatusCode != 0 ? String.valueOf(responseStatusCode) : '';
                objApiTransaction.Request_Time__c = startTime;
                objApiTransaction.Response_Time__c = endTime;
                
                List<BRAIN_API_Call_Tracker__c> bactList = BRAINFAObjectSOQLManager.queryBACTListByRequestId(faRequestId);
                System.debug('(BRAINFACalloutHelper.createApiTransaction) faRequestId=' + faRequestId + '  AND Call-Tracker=' + bactList?.get(0)?.Id);
                
                objApiTransaction.BRAIN_API_Call_Tracker__c = bactList?.get(0)?.Id;
                
                apiTransactions.add(objApiTransaction);

                // If there is atleast single API Transaction then insert it
                if(apiTransactions?.size() > 0)
                {
                    insert apiTransactions;
                }
                
                System.debug('(BRAINFACalloutHelper.createApiTransaction) API Transaction record inserted Id-->'+apiTransactions[0].id);
                
                for (BRAIN_API_Call_Tracker__c bact : bactList) {
                    bact.API_Transaction__c = apiTransactions[0].id;
                }
                upsert bactList;
                
                return apiTransactions[0].id.to15();
            } catch (Exception apiX) {
                /* Note - This exception should be added in the error list after the clarification
                of transaction summary object and error list to be added in transaction summary*/
                //errorList?.add('API Trasansaction Record Create Error: ' + e.getMessage());
                // For now just printing the error incase API transaction record creation fails
                String debugMsg = 'API Trasansaction Record Create Error: EXCEPTION! \n Type: ' + apiX.getTypeName() + '\n Message:  ' + apiX.getMessage() + '\n Line#: ' + apiX.getLineNumber() + '\n StackTrace:  ' + apiX.getStackTraceString();
                System.debug('(BRAINFACalloutHelper.createApiTransaction) ' + debugMsg);
                return debugMsg;
            }
        } else {
            String debugMsg = 'The Calling API-Name was not valid.  API Transaction was not recorded.';
            return debugMsg;
        }
    }//end method createApiTransaction

    public static BRAIN_Automation_Fault__c buildBaseFault(String fMsgIn, String fDescrIn) {
        BRAIN_Automation_Fault__c baFault = new BRAIN_Automation_Fault__c();
        System.debug('(BRAINFACalloutHelper.buildBaseFault) fMsgIn = ' + fMsgIn + ' \n fDescrIn = ' + fDescrIn);
        baFault.Fault_Message__c = fMsgIn;
        baFault.Fault_Description__c = fDescrIn;
        return baFault;
    }//end method buildBaseFault

    public static BRAIN_Automation_Fault__c buildBaseFaultFromHttpResponse(HttpResponse resp) {
        BRAIN_Automation_Fault__c baFault = new BRAIN_Automation_Fault__c();
        System.debug('(BRAINFACalloutHelper.buildBaseFault) resp.getStatus() = ' + resp.getStatus() + ' \n resp.getBody() = ' + resp.getBody());
        baFault.Fault_Message__c = resp.getStatus();
        // If the response char length is greater than 131072 them trim & abbreviate it
        String faultTrimResponse = null;
		//QFCJ-4625-8 BRAIN-Financial-Analysis-Failures
        if (resp.getBody()?.contains('errorMessage')) {
            BRAINFAResponseWrap respWrap = BRAINFAResponseHelper.parseJSONForFAResponse(resp.getBody());
            faultTrimResponse = respWrap.errorMessage;
        } else {
            faultTrimResponse = resp.getBody();
        }
        if (faultTrimResponse.length() > 131072) 
        {
            /*  Section of errorMessage from BRAIN when clusterId is found not to match with networkInvestmentType and productType specified in the BRAIN FA Request json payload
             * 
             *    "analysis unit with ID: 10181285 not valid for network investment PRODUCT\nEnablement Product Type: DSL equal to picked product type: DSL\ "... and ends with for Cluster ID ######
             * 
             */         
            if (faultTrimResponse.contains('analysis unit with ID:') &&
                faultTrimResponse.contains('not valid for network investment') &&
                faultTrimResponse.contains('Enablement Product Type:')) {
                Integer lastOfClusterMsgStartIdx = faultTrimResponse.lastIndexOf('analysis unit with ID:') - 1;
                if (lastOfClusterMsgStartIdx > 0) {
                    faultTrimResponse = faultTrimResponse.substring(lastOfClusterMsgStartIdx);
                } else {
                    faultTrimResponse = faultTrimResponse.substring(lastOfClusterMsgStartIdx+1);
                }                
            }
            faultTrimResponse = faultTrimResponse?.remove('\n\t\r');
            faultTrimResponse = faultTrimResponse?.trim();
            
            if(faultTrimResponse?.length() > 131072) 
            {
                baFault.Fault_Description__c = faultTrimResponse?.abbreviate(131072);
            }
        } else {
            baFault.Fault_Description__c = faultTrimResponse;
        }
        return baFault;
    }//end method buildBaseFaultFromHttpResponse

    public static void associateFaultToCapDesignByRequestId(BRAIN_Automation_Fault__c baFault, String faRequestId) {
        try {
            BRAIN_FA_Request__c faRequest = BRAINFAObjectSOQLManager.queryFARequestById(faRequestId);
            System.debug('(BRAINFACalloutHelper.associateFaultToCapDesignByRequestId) faRequest.cuid__c = ' + faRequest.cuid__c);
            baFault.Submitter_CUID__c = faRequest.cuid__c;
            System.debug('(BRAINFACalloutHelper.associateFaultToCapDesignByRequestId) faRequest.BRAIN_API_Call_Tracker_Master__c = ' + faRequest.BRAIN_API_Call_Tracker_Master__c);
            baFault.Last_Associated_BRAIN_API_Call__c = faRequest.BRAIN_API_Call_Tracker_Master__c;
            System.debug('(BRAINFACalloutHelper.associateFaultToCapDesignByRequestId) faRequest.BRAIN_API_Call_Tracker_Master__r.Capital_Design__c = ' + faRequest.BRAIN_API_Call_Tracker_Master__r.Capital_Design__c);
            baFault.Associated_Capital_Design__c = faRequest.BRAIN_API_Call_Tracker_Master__r.Capital_Design__c;
            System.debug('(BRAINFACalloutHelper.associateFaultToCapDesignByRequestId) faRequest.BRAIN_API_Call_Tracker_Master__r.API_Transaction__c = ' + faRequest.BRAIN_API_Call_Tracker_Master__r.API_Transaction__c);
            baFault.API_Transaction__c = faRequest.BRAIN_API_Call_Tracker_Master__r.API_Transaction__c;
            List<BRAIN_Automation_Fault__c> faultList = new List<BRAIN_Automation_Fault__c>();
            faultList.add(baFault);
            faultList = BRAINFAObjectDMLManager.upsertBRAINAutoFaultList(faultList);
            Capital_Design__c faultCD = [SELECT Id, Name, Last_BRAIN_Automation_Fault__c FROM Capital_Design__c 
                                         WHERE Id = :faRequest.BRAIN_API_Call_Tracker_Master__r.Capital_Design__c LIMIT 1];
            faultCD.Last_BRAIN_Automation_Fault__c = faultList?.get(0)?.Id;
            update faultCD;
        } catch(Exception assocX) {
            System.debug('(BRAINFACalloutHelper.associateFaultToCapDesignByRequestId) EXCEPTION! \n Type: ' + assocX.getTypeName() + '\n Message:  ' + assocX.getMessage() + '\n Line#: ' + assocX.getLineNumber() + '\n StackTrace:  ' + assocX.getStackTraceString());
        }
    }//end method associateFaultToCapDesignByRequestId

    public static void associateFaultToCapDesignByCapDesId(BRAIN_Automation_Fault__c baFault, String capDesId) {
        try {
            List<BRAIN_Automation_Fault__c> faultList = new List<BRAIN_Automation_Fault__c>();
            faultList.add(baFault);
            faultList = BRAINFAObjectDMLManager.upsertBRAINAutoFaultList(faultList);
            Capital_Design__c faultCD = [SELECT Id, Name, Last_BRAIN_Automation_Fault__c FROM Capital_Design__c 
                                         WHERE Id = :capDesId LIMIT 1];
            faultCD.Last_BRAIN_Automation_Fault__c = faultList?.get(0)?.Id;
            update faultCD;
        } catch(Exception assocX) {
            System.debug('(BRAINFACalloutHelper.associateFaultToCapDesignByCapDesId) EXCEPTION! \n Type: ' + assocX.getTypeName() + '\n Message:  ' + assocX.getMessage() + '\n Line#: ' + assocX.getLineNumber() + '\n StackTrace:  ' + assocX.getStackTraceString());
        }
    }//end method associateFaultToCapDesignByCapDesId

    public static void associateFaultToCapDesignByCapDesName(BRAIN_Automation_Fault__c baFault, String capDesName) {
        try {
            List<BRAIN_Automation_Fault__c> faultList = new List<BRAIN_Automation_Fault__c>();
            faultList.add(baFault);
            faultList = BRAINFAObjectDMLManager.upsertBRAINAutoFaultList(faultList);
            Capital_Design__c faultCD = [SELECT Id, Name, Last_BRAIN_Automation_Fault__c FROM Capital_Design__c 
                                         WHERE Name = :capDesName LIMIT 1];
            faultCD.Last_BRAIN_Automation_Fault__c = faultList?.get(0)?.Id;
            update faultCD;
        } catch(Exception assocX) {
            System.debug('(BRAINFACalloutHelper.associateFaultToCapDesignByCapDesName) EXCEPTION! \n Type: ' + assocX.getTypeName() + '\n Message:  ' + assocX.getMessage() + '\n Line#: ' + assocX.getLineNumber() + '\n StackTrace:  ' + assocX.getStackTraceString());
        }
    }//end method associateFaultToCapDesignByCapDesName

    public static void associateFaultToCapDesignByBACTId(BRAIN_Automation_Fault__c baFault, String bactId) {
        try {
            List<BRAIN_Automation_Fault__c> faultList = new List<BRAIN_Automation_Fault__c>();
            faultList.add(baFault);
            faultList = BRAINFAObjectDMLManager.upsertBRAINAutoFaultList(faultList);
            Capital_Design__c faultCD = [SELECT Id, Name, Last_BRAIN_Automation_Fault__c FROM Capital_Design__c 
                                         WHERE Last_Associated_BRAIN_FA_Call__c = :bactId LIMIT 1];
            faultCD.Last_BRAIN_Automation_Fault__c = faultList?.get(0)?.Id;
            update faultCD;
        } catch(Exception assocX) {
            System.debug('(BRAINFACalloutHelper.associateFaultToCapDesignByBACTId) EXCEPTION! \n Type: ' + assocX.getTypeName() + '\n Message:  ' + assocX.getMessage() + '\n Line#: ' + assocX.getLineNumber() + '\n StackTrace:  ' + assocX.getStackTraceString());
        }
    }//end method associateFaultToCapDesignByBACTId
 
}//end class BRAINFACalloutHelper