/**
 *      1/30/2024       HANK        QFCJ-4879        moved a debug statement causing a list index out of bounds error
 * 
 */

@RestResource(urlMapping='/ApiTransactionService/*')
global with sharing class ApiTransactionService {
    public List<API_Transaction__c> apiTransactions;
    private String endPoint;
    private String reqBody;
    private Integer timeOut;
    private String resBody;
    private String httpMethodName;
    private Map<String, Object> restReqMap;
    private String callingApiName;
    private API_Util__mdt apiUtils;
    private List<String> errorList;
    private String errorDetails;
    private HttpRequest httpReqForApiTransaction;
    private Map<String, String> queryParamsMap;
    private Id transactionSummaryId;
    private Boolean disableDml;
    public String facilityTypeForProspector;

    private String bearerAccessToken {
        get {
            if(bearerAccessToken == null) {
                bearerAccessToken = getBearerAccessToken();
            }
            return bearerAccessToken;
        }
        set;
    }

    public static Map<String, API_Util__mdt> apiUtilMetadataMap {
        get {
            if(apiUtilMetadataMap == null) {
                apiUtilMetadataMap = new Map<String, API_Util__mdt>();
                List<API_Util__mdt> apiUtilMetadata = [
                    SELECT
                        DeveloperName,
                        EndPoint__C,
                        NumOfRetires__c,
                        Timeout__c,
                        HttpMethod__c,
                        Prospector_Service__c,
                        Auth_Type__c
                    FROM API_Util__mdt
                ];
                for(API_Util__mdt metadata : apiUtilMetadata) {
                    apiUtilMetadataMap.put(
                        metadata.DeveloperName,
                        metadata
                    );
                }
            }
            return apiUtilMetadataMap;
        }
        set;
    }

    public ApiTransactionService() {
        this.apiTransactions = new List<API_Transaction__c>();
        errorList = new List<String>();
    }
    public ApiTransactionService(Boolean disableDml) {
        this.apiTransactions = new List<API_Transaction__c>();
        errorList = new List<String>();
        this.disableDml = disableDml;
    }

    public ApiTransactionService(
        String thisCallingApiName,
        String thisReqBody,
        Map<String, String> thisQueryParamsMap,
        Id thisTransactionSummaryId
    ) {
        this.apiTransactions = new List<API_Transaction__c>();
        callingApiName = thisCallingApiName;
        reqBody = thisReqBody;
        queryParamsMap = thisQueryParamsMap;
        errorList = new List<String>();
        transactionSummaryId = thisTransactionSummaryId;
    }

    public HttpResponse serviceCallout(
        String callingApiName,
        String requestBody,
        Map<String, String> queryParamsMap,
        String transactionSummaryId
    ) {
        Time startTime, endTime;
        HttpRequestResponseWrapper requestResponse;
        Boolean isBearerTokenCallout = false;

        try {
            this.callingApiName = callingApiName;
            prepareCalloutData(
                callingApiName,
                queryParamsMap
            );
            startTime = DateTime.now().Time(); 
            
            requestResponse = makeCallout(false);
            /* In case of unsuccessful callout add the details in the error list so that it can be
            sent back in case of callout from web*/
            if (requestResponse.response?.getStatusCode() != 200) {
                errorList?.add(
                    'Callout Error - ' +
                    'Status: ' + requestResponse.response?.getStatus() + ',' +
                    'Status code: ' + requestResponse.response?.getStatusCode() + ',' +
                    'Body: ' + requestResponse.response?.getBody()
                );
            }
        } catch (Exception e) {
            // Incase of any exception add the error msg in the error list
            errorList?.add('Exception: Message - '+e.getMessage()+' | Line number - '+e.getLineNumber());
        }
        endTime =  DateTime.now().Time();

        // If there is any error in the error list
        if (errorList?.size() > 0) {
            errorDetails = getErrorStringFromList();
        }

        if(requestResponse == null || requestResponse.response == null) {
            createApiTransaction(
                null,
                null,
                'no response',
                httpReqForApiTransaction?.getEndpoint(),
                httpReqForApiTransaction?.getBody(),
                callingApiName,
                startTime,
                endTime,
                errorDetails,
                transactionSummaryId
            );
            return null;
        } else {
            // Create API Transaction records
            createApiTransaction(
                requestResponse.response?.getStatus(),
                requestResponse.response?.getStatusCode(),
                requestResponse.response?.getBody(),
                httpReqForApiTransaction?.getEndpoint(),
                httpReqForApiTransaction?.getBody(),
                callingApiName,
                startTime,
                endTime,
                errorDetails,
                transactionSummaryId
            );
        }
        return requestResponse.response;
    }

    private String buildRequestBody(Map<String, object> restReqMap){
        return restReqMap?.get('body')?.toString();
    }

    private void prepareCalloutData(
        String callingApiName,
        Map<String, String> queryParamsMap //should be Map<String, Object>....
    ) {
        String queryParams = '';
        // Get API Details from API Utils custom metadata
        apiUtils = apiUtilMetadataMap.get(callingApiName);
        if (apiUtils != null) {
            System.debug('(ApiTransactionService.makeCallout) apiUtils?.Endpoint__c = ' + apiUtils?.Endpoint__c);
            String hexaEndPoint = apiUtils?.Endpoint__c;
            System.debug('(ApiTransactionService.makeCallout) Initially, hexaEndPoint="' + hexaEndPoint + '"');
            hexaEndPoint = hexaEndPoint.replace('{', '%7B');
            hexaEndPoint = hexaEndPoint.replace('}', '%7D');
            System.debug('(ApiTransactionService.makeCallout) AFTER %-replaces, hexaEndPoint="' + hexaEndPoint + '"');
            // If there is atleast one url query param
            if (queryParamsMap?.size() > 0) {
                for (String paramName : queryParamsMap?.keySet()) {
                    // If the param is not 'projectId' for prospector services
		            System.debug('(ApiTransactionService.makeCallout) paramName = ' + paramName);
                    if (paramName != 'projectId') {
                        // Create a query string in the format: 'param1=value1&param2=value2'
                        queryParams += paramName + '=' + queryParamsMap?.get(paramName)?.replaceAll(' ', '+').replaceAll(' ', '+') + '&'; //can you spot the difference? vs code can! yay bad data ;)
                        queryParams =  queryParams.replace('#', '%23');      // QFCJ-4879 - Added line
                    }
                    // If the param is 'projectId'
                    else {
                        // Then replace the placeholder 'projectId' with its actiual value in the endpoint
                        System.debug('(ApiTransactionService.makeCallout) apiUtils.Prospector_Service__c = ' + apiUtils.Prospector_Service__c);
                        if(apiUtils.Prospector_Service__c) {
                            String projectIdParam = queryParamsMap?.get(paramName).replace('{','');
                            projectIdParam = projectIdParam.replace('}','');
	                        System.debug('(ApiTransactionService.makeCallout) AFTER braces-replace, projectIdParam = ' + projectIdParam);
                            hexaEndPoint = hexaEndPoint.replace(paramName, projectIdParam);
	                        System.debug('(ApiTransactionService.makeCallout) AFTER paramName/projectIdParam replace, hexaEndPoint = ' + hexaEndPoint);
                        } else {
	                        hexaEndPoint = hexaEndPoint.replace(paramName, queryParamsMap?.get(paramName));
                        }
                    }
                }
                queryParams = queryParams?.removeEndIgnoreCase('&')?.trim();
                System.debug('(ApiTransactionService.makeCallout) BEFORE appending to hexaEndPoint="' + hexaEndPoint + '", queryParams = ' + queryParams);
                // Add query param string in the end of the endpoint
                 hexaEndPoint = hexaEndPoint + queryParams;
            }
            System.debug('(ApiTransactionService.makeCallout) Finally, hexaEndPoint="' + hexaEndPoint + '"');
            endPoint = hexaEndPoint;
            timeOut = (Integer)apiUtils?.Timeout__c;
            httpMethodName = apiUtils?.HttpMethod__c;
            // if callout from web then create requestbody from RestRequest Map
            if (reqBody == null) {
                reqBody = buildRequestBody(restReqMap);
            }
        } else {
            errorList.add('API Utils Error: No API found');
        }
        System.debug(
            'callingApiName -->'+callingApiName+
            '\n endPoint -->'+endPoint+
            '\n timeOut -->'+timeOut+
            '\n httpMethodName -->'+httpMethodName+
            '\n reqBody -->'+reqBody
        );
    }

    private HttpRequestResponseWrapper makeCallout(Boolean isBearerTokenCallout) {
        Http objHTTP = new Http();
        HttpRequest objRequest = new HttpRequest();
        HttpResponse objResponse;

       // If the API callout uses oAuth2 Authorization and It is a prospector service
        // Added new ProspectorAuthToken in custom meta dat as new token was exceeding length BY AC32424
        API_Util__mdt prospectorToken = API_Util__mdt.getInstance('ProspectorAuthToken');
        if(apiUtils.Prospector_Service__c && apiUtils.Auth_Type__c == 'Oauth2'){
            objRequest.setHeader(
                'authToken',
                prospectorToken.EndPoint__c
            );
        }
		
        // If the API callout uses bearer token Authorization & it is not a bearer token callout to avoid recurssion
        else if (!isBearerTokenCallout && apiUtils.Auth_Type__c == 'BearerToken') {
            if (this.bearerAccessToken != null && this.bearerAccessToken != '') {
                objRequest.setHeader('Authorization', 'Bearer '+this.bearerAccessToken);
            }
        }
        if (isBearerTokenCallout && apiUtils.Auth_Type__c == 'BearerToken') {
            // Incase of bearer token callout
            objRequest.setEndpoint('callout:TokenGenerator');
            objRequest.setMethod('POST');
            objRequest.setbody('grant_type=client_credentials');
        } else {
            // Incase of other service callouts
            objRequest.setEndpoint(endPoint);
            objRequest.setHeader('Content-Type', 'application/json');
            objRequest.setMethod(httpMethodName);
            if (httpMethodName != 'GET') {
                objRequest.setBody(reqBody);
            }
            objRequest.setTimeout(timeOut);
        }
		System.debug('(ApiTransactionService.makeCallout)AFTER setting Request values, ' +
                     '\n  objRequest.getEndpoint() = ' + objRequest.getEndpoint() + 
                     '\n  objRequest.getHeader() = ' + objRequest.getHeader('Content-Type') +
                     '\n  objRequest.getMethod() = ' + objRequest.getMethod() +
                     '\n  objRequest.getBody() = ' + objRequest.getBody());
        httpReqForApiTransaction = objRequest; // to be used while creating API Transaction record
        // In case of non test context make the actual callout
        if (!Test.isRunningTest()) {
            objResponse = objHTTP.send(objRequest);
        }
        // In case of test context make get the response from MockHttpResponseGenerator
        else {
            if(apiUtils.Prospector_Service__c) {
                System.debug('(ApiTransactionService.makeCallout) facilityTypeForProspector = ' + facilityTypeForProspector);                
                ProspectorMockHttpResponseGenerator mock = new ProspectorMockHttpResponseGenerator(callingApiName, facilityTypeForProspector);
                objResponse = mock.respond(objRequest);
            } else {
	            MockHttpResponseGenerator mock = new MockHttpResponseGenerator(callingApiName);
    	        objResponse = mock.respond(objRequest);
            }
        }
        return new HttpRequestResponseWrapper(
            objRequest,
            objResponse
        );
    }

    private void createApiTransaction(
        String responseStatus,
        Integer responseStatusCode,
        String responseBody,
        String requestEndpoint,
        String requestBody,
        String callingApiName,
        Time startTime,
        Time endTime,
        String errorDetails,
        String transactionSummaryId
    ) {
        // If the API Name is not null or blank then proceed
        if (callingApiName != null && callingApiName != '') {
            try {
                // Create API Transaction record
                API_Transaction__c objApiTransaction = new API_Transaction__c();
                objApiTransaction.API_Name__c = callingApiName;
                objApiTransaction.API_Request_JSON__c = requestBody != null && requestBody != '' ? requestBody : null;

                // If the http response body is not null or blank then proceed
                if(responseBody != null && responseBody != ''){
                    String apiTrimResponse = responseBody;
                    // If the response char length is greater than 131072 them trim & abbreviate it
                    if (apiTrimResponse?.length() > 131072) {
                        apiTrimResponse = apiTrimResponse?.remove('\n\t\r');
                        apiTrimResponse = apiTrimResponse?.trim();
                        if(apiTrimResponse?.length() > 131072) {
                            objApiTransaction.API_Response_JSON__c = apiTrimResponse?.abbreviate(131072);
                        }
                    } else {
                        objApiTransaction.API_Response_JSON__c = apiTrimResponse;
                    }
                }
                // If there are any error details then add that in the API Response field
                // Note - This might be added in the transaction summary record after clarifications
                else if (errorDetails != null && errorDetails != '') {
                    objApiTransaction.API_Response_JSON__c = errorDetails;
                }
                objApiTransaction.Internal_Message_Code__c = responseStatus != null && responseStatus != '' ? responseStatus : '';
                objApiTransaction.EndPoint__c = requestEndpoint != null && requestEndpoint != '' ? requestEndpoint : 'There is no end point';
                objApiTransaction.API_Status_Code__c = responseStatusCode != null && responseStatusCode != 0 ? String.valueOf(responseStatusCode) : '';
                objApiTransaction.Request_Time__c = startTime;
                objApiTransaction.Response_Time__c = endTime;
                system.debug('transactionSummaryId : '+transactionSummaryId);
                objApiTransaction.Transaction_Summary_Id__c = transactionSummaryId;
                apiTransactions.add(objApiTransaction);

                // // If there is atleast single API Transaction then insert it - WHY? EXTRA DML IS BAD
                // if(this.disableDml && apiTransactions?.size() > 0) {
                //     insert apiTransactions;
                // }
                
            } catch (Exception e) {
                /* Note - This exception should be added in the error list after the clarification
                of transaction summary object and error list to be added in transaction summary*/
                //errorList?.add('API Trasansaction Record Create Error: ' + e.getMessage());
                // For now just printing the error incase API transaction record creation fails
                System.debug(
                    'API Trasansaction Record Create Error: ' + e.getMessage() + ' | ' +
                    'Line number - '+e.getLineNumber()
                );
            }
        }
    }

    public String getBearerAccessToken() {
        HttpResponse objResponse = bearerTokenCallout();
        if (objResponse != null && objResponse.getBody() != null) {
            String tokenResponseBody = objResponse.getBody();
            String tempString = tokenResponseBody.replaceAll('\\\\', '');
            Map<String,Object> jsonParsed = (Map<String,Object>) json.deserializeUntyped(tempString);
            return (String)jsonParsed.get('access_token');
        }
        errorList.add('Access token Error: Null access token');
        return null;
    }

    public HttpResponse bearerTokenCallout() {
        HttpResponse objResponse;
        Boolean isBearerTokenCallout = true;
        try {
            objResponse = makeCallout(isBearerTokenCallout).response;
        } catch (Exception e) {
            // Incase of any exception add the error msg in the error list
            errorList?.add('Exception: Message - '+e.getMessage()+' | Line number - '+e.getLineNumber());
        }
        return objResponse;
    }

    private String getErrorStringFromList() {
        return String.join(this.errorList, '\n');
    }

    public void save() {
        if(apiTransactions == null && apiTransactions.isEmpty()) {
            return;
        }
        insert apiTransactions;

        // ist<API_Transaction__c> reversedTransactions = new List<API_Transaction__c>();
        // for(API_Transaction__c apiTransaction : reversedTransactions) {
        //     reversedTransactions.add(apiTransaction);
        // }
        // insert reversedTransactions;
    }

    public class HttpRequestResponseWrapper {
        public HttpRequest request;
        public HttpResponse response;
        public HttpRequestResponseWrapper(
            HttpRequest request,
            HttpResponse response
        ) {
            this.request = request;
            this.response = response;
        }
    }
}