/***************************************************************
===============================================================
Purpose: Generic API callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    25/11/2021   NA            Initial draft
Deepak K   14/12/2021   ESCJ-328      Added transaction summary id in the parameter of
                                      createApiTransaction method and constructor
***************************************************************/
@RestResource(urlMapping='/APITransactionController/*')
global without sharing class APITransactionController {
    private static String endPoint;
    private static String reqBody;
    private static Integer timeOut;
    private static String resBody;
    private static String httpMethodName;
    private static Map<String, Object> restReqMap;
    private static String callingApiName;
    private static API_Util__mdt apiUtils;
    private static List<String> errorList;
    private static String errorDetails;
    private static HttpRequest httpReqForApiTransaction;
    private static Map<String, String> queryParamsMap;
    private static Id transactionSummaryId;

    /**********************************************************************************************
    Purpose: Parameterized cosntructor to be used when callout is done from another apex class.
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    Deepak K    14/12/2021  ESCJ-328    Added transaction summary id in the parameter
    ***********************************************************************************************/
    public APITransactionController(
        String thisCallingApiName,
        String thisReqBody,
        Map<String, String> thisQueryParamsMap,
        Id thisTransactionSummaryId
    ) {
        callingApiName = thisCallingApiName;
        reqBody = thisReqBody;
        queryParamsMap = thisQueryParamsMap;
        errorList = new List<String>();
        transactionSummaryId = thisTransactionSummaryId;
    }

    /**********************************************************************************************
    Purpose: Http Post Method exposed as Apex web service
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    Deepak K    14/12/2021  ESCJ-328    Added transaction summary id in the parameter while calling
                                        createApiTransaction method
    ***********************************************************************************************/
    @HttpPost
    global static String apiTransactionController() {
        HttpResponse response;
        String webResponseString;
        RestRequest restReq = RestContext.request;
        queryParamsMap = new Map<String, String>();
        errorList = new List<String>();

        // Deserializing the request bpody received from the web into map
        restReqMap = (Map<String, Object>) JSON.deserializeUntyped(restReq?.requestBody?.toString());
        // Get API Details from API Utils custom metadata
        apiUtils = getApiUtils(restReqMap?.get('serviceInfo')?.toString());
        callingApiName = apiUtils?.DeveloperName;

        //If there are url query params present
        if (
            restReqMap?.get('params')?.toString() != null &&
            restReqMap?.get('params')?.toString() != ''
        ) {
            Map<String, Object> paramFromReqMap = (Map<String, Object>) restReqMap?.get('params');
            for (String paramName : paramFromReqMap?.keySet()) {
                queryParamsMap?.put(paramName, paramFromReqMap?.get(paramName).toString());
            }
        }
        // If API utils for the given Api name exist then proceed further
        if (apiUtils != null) {
            // Initiate callout
            response = serviceCallout();
        } else {
            errorList.add('API Utils Error: No API found');
            // If there is any error in the error list
            if (errorList?.size() > 0) {
                errorDetails = getErrorStringFromList();
            }
            // Create API Transaction records
            createApiTransaction(null, null, null, null, null, callingApiName, null, null, errorDetails, null);
        }
        // Incase of successful callout return response body
        if (response != null && response?.getBody() != null && response?.getStatusCode() == 200 && errorDetails == null) {
            webResponseString = response?.getBody();
        }
        // Incase of any errors return error details
        else {
            webResponseString = errorDetails;
        }
        return webResponseString;
    }

    /**********************************************************************************************
    Purpose: Method called from another class & @httpPost annoted method to make callout
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    Deepak K    14/12/2021  ESCJ-328    Added transaction summary id in the parameter while calling
                                        createApiTransaction method
    ***********************************************************************************************/
    public static HttpResponse serviceCallout () {
        Time startTime, endTime;
        HttpResponse objResponse;
        Boolean isBearerTokenCallout = false;

        try {
            prepareCalloutData();
            startTime = DateTime.now().Time();
            objResponse = makeCallout(false);
            /* In case of unsuccessful callout add the details in the error list so that it can be
            sent back in case of callout from web*/
            if (objResponse?.getStatusCode() != 200) {
                errorList?.add(
                    'Callout Error - ' +
                    'Status: ' + objResponse?.getStatus() + ',' +
                    'Status code: ' + objResponse?.getStatusCode() + ',' +
                    'Body: ' + objResponse?.getBody()
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
        // Create API Transaction records
        createApiTransaction(
            objResponse?.getStatus(),
            objResponse?.getStatusCode(),
            objResponse?.getBody(),
            httpReqForApiTransaction?.getEndpoint(),
            httpReqForApiTransaction?.getBody(),
            callingApiName,
            startTime,
            endTime,
            errorDetails,
            transactionSummaryId
        );

        return objResponse;
    }

    /**********************************************************************************************
    Purpose: To create request body from the request map
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    ***********************************************************************************************/
    private static String buildRequestBody(Map<String, object> restReqMap){
        return restReqMap?.get('body')?.toString();
    }

    /**********************************************************************************************
    Purpose: To prepare data for callout
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    ***********************************************************************************************/
    private static void prepareCalloutData (){
        String queryParams = '';
        // Get API Details from API Utils custom metadata
        apiUtils = getApiUtils(callingApiName);
        if (apiUtils != null) {
            String hexaEndPoint = apiUtils?.Endpoint__c;
            hexaEndPoint = hexaEndPoint.replace('{', '%7B');
            hexaEndPoint = hexaEndPoint.replace('}', '%7D');
            // If there is atleast one url query param
            if (queryParamsMap?.size() > 0) {
                for (String paramName : queryParamsMap?.keySet()) {
                    // If the param is not 'projectId' for prospector services
                    if (paramName != 'projectId') {
                        // Create a query string in the format: 'param1=value1&param2=value2'
                        queryParams += paramName + '=' + queryParamsMap?.get(paramName)?.replaceAll(' ', '+') + '&';
                    }
                    // If the param is 'projectId'
                    else {
                        // Then replace the placeholder 'projectId' with its actiual value in the endpoint
                        hexaEndPoint = hexaEndPoint.replace(paramName, queryParamsMap?.get(paramName));
                    }
                }
                queryParams = queryParams?.removeEndIgnoreCase('&')?.trim();
                // Add query param string in the end of the endpoint
                hexaEndPoint = hexaEndPoint + queryParams;
            }
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
            ' endPoint -->'+endPoint+
            'timeOut -->'+timeOut+
            'httpMethodName -->'+httpMethodName+
            'reqBody -->'+reqBody
        );
    }

    /**********************************************************************************************
    Purpose: To make HTTP Callout
    Note - The bearer token callout logic to be removed after confirming with akhil that all the
    service will follow oauth2 authentication protocol
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    ***********************************************************************************************/
    private static HttpResponse makeCallout(Boolean isBearerTokenCallout) {
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
            String accessToken = getBearerAccessToken();
            if (accessToken != null && accessToken != '') {
                objRequest.setHeader('Authorization', 'Bearer '+accessToken);
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
        httpReqForApiTransaction = objRequest; // to be used while creating API Transaction record
        // In case of non test context make the actual callout
        if (!Test.isRunningTest()) {
            objResponse = objHTTP.send(objRequest);
        }
        // In case of test context make get the response from MockHttpResponseGenerator
        else {
            MockHttpResponseGenerator mock = new MockHttpResponseGenerator(callingApiName);
            objResponse = mock.respond(objRequest);
        }
        return objResponse;
    }

    /**********************************************************************************************
    Purpose: To get API details from API Utils custom metadata
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    ***********************************************************************************************/
    private static API_Util__mdt getApiUtils(String apiUtilName) {
        API_Util__mdt apiUtil;
        if (apiUtilName != null || apiUtilName != '') {
            apiUtil = [
                SELECT
                    DeveloperName,
                    EndPoint__C,
                    NumOfRetires__c,
                    Timeout__c,
                    HttpMethod__c,
                    Prospector_Service__c,
                    Auth_Type__c
                FROM API_Util__mdt
                WHERE
                    DeveloperName = :apiUtilName
            ];
        }
        return apiUtil;
    }

    /**********************************************************************************************
    Purpose: To create API Transaction record
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    Deepak K    14/12/2021  ESCJ-328    Added transaction summary id in the parameter
    ***********************************************************************************************/
    private static void createApiTransaction(
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
                List<API_Transaction__c> apiTransactions = new List<API_Transaction__c>();
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

                // If there is atleast single API Transaction then insert it
                if(apiTransactions?.size() > 0){
                    insert apiTransactions;
                }
                System.debug('API Transaction record inserted Id-->'+apiTransactions[0].id);
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

    /**********************************************************************************************
    Purpose: To get Bearer Access Token
    Note - The bearer token callout logic to be removed after confirming with akhil that all the
    service will follow oauth2 authentication protocol
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    ***********************************************************************************************/
    private static String getBearerAccessToken(){
        string accessToken;
        String tokenResponseBody;

        HttpResponse objResponse = bearerTokenCallout();
        if (objResponse != null && objResponse.getBody() != null) {
            tokenResponseBody = objResponse.getBody();
            String tempString = tokenResponseBody.replaceAll('\\\\', '');
            Map<String,Object> jsonParsed = (Map<String,Object>) json.deserializeUntyped(tempString);
            accessToken = (String)jsonParsed.get('access_token');
        } else {
            errorList.add('Access token Error: Null access token');
        }

        return accessToken;
    }

    /**********************************************************************************************
    Purpose: To make callout for bearer access token
    Note - The bearer token callout logic to be removed after confirming with akhil that all the
    service will follow oauth2 authentication protocol
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    ***********************************************************************************************/
    public static HttpResponse bearerTokenCallout () {
        HttpResponse objResponse;
        Boolean isBearerTokenCallout = true;
        try {
            objResponse = makeCallout(isBearerTokenCallout);
        } catch (Exception e) {
            // Incase of any exception add the error msg in the error list
            errorList?.add('Exception: Message - '+e.getMessage()+' | Line number - '+e.getLineNumber());
        }
        return objResponse;
    }

    /**********************************************************************************************
    Purpose: To Create string of error details from the list of errors
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     25/11/2021  NA          Initial draft
    ***********************************************************************************************/
    private static String getErrorStringFromList() {
        return String.join(errorList, '\n');
    }
}