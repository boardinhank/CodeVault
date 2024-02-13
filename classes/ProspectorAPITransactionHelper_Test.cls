@isTest(SeeAllData=true)
public with sharing class ProspectorAPITransactionHelper_Test {
    public static final String testProjId = '{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}';

/*  */
    @isTest
    public static void testApiTransactionListSaveZeroList() {
        Test.startTest();
        ProspectorAPITransactionHelper.apiTransactionList = null;
        System.debug('(testApiTransactionListSaveZeroList) ProspectorAPITransactionHelper.apiTransactionList isNull? ' + (ProspectorAPITransactionHelper.apiTransactionList == null));
        ProspectorAPITransactionHelper.save();
        Test.stopTest();
    }//end testApiTransactionListSaveZeroList
/*  */

/*  */  
    @isTest
    public static void testApexRestService() {
        String testApiName = 'CreateProject';
        String reqBody = '{ "serviceInfo": "' + testApiName + '", "params": { "' + 
            ProspectorConstants.LABEL_MAPSERVICENAME + '": "' + ProspectorConstants.MAPSERVICENAME + '", "' + 
            ProspectorConstants.LABEL_USERNAME + '": "' + ProspectorConstants.USERNAME_DEV + '" } }';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/ProspectorAPITransactionHelper';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueof(reqBody);

        RestContext.request = request;
        Test.startTest();
        String callingApiName = ProspectorConstants.CREATE_PROJECT;
        Map<String, String> queryParamMap = new Map<String, String>();
        queryParamMap.put(ProspectorConstants.LABEL_MAPSERVICENAME, ProspectorConstants.MAPSERVICENAME);
        queryParamMap.put(ProspectorConstants.LABEL_USERNAME, ProspectorConstants.USERNAME_DEV);
        Id transactionSummaryId = null;
       	ProspectorAPITransactionHelper apiHelper = new ProspectorAPITransactionHelper(
                callingApiName,
                null,
                reqBody,
                queryParamMap,
                transactionSummaryId
        );
//        HttpResponse httpResponse = ProspectorAPITransactionHelper.serviceCallout();
//		String responseBody = httpResponse.getBody();
        String webResponseString = ProspectorAPITransactionHelper.apiTransactionController();
        Test.stopTest();

//        System.assertNotEquals(null, responseBody);
        System.assertNotEquals(null, webResponseString);
    }//end testMethod testApexRestService
/*  */
    
/*  */
    @isTest
    public static void testApexRestServiceNullReqBody() {
        String testApiName = 'CreateProject';
        String reqBody = '{ "serviceInfo": "' + testApiName + '", "params": { "' + 
            ProspectorConstants.LABEL_MAPSERVICENAME + '": "' + ProspectorConstants.MAPSERVICENAME + '", "' + 
            ProspectorConstants.LABEL_USERNAME + '": "' + ProspectorConstants.USERNAME_DEV + '" } }';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/ProspectorAPITransactionHelper';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueof(reqBody);

        RestContext.request = request;
        Test.startTest();
        String callingApiName = ProspectorConstants.CREATE_PROJECT;
        Map<String, String> queryParamMap = new Map<String, String>();
        queryParamMap.put(ProspectorConstants.LABEL_MAPSERVICENAME, ProspectorConstants.MAPSERVICENAME);
        queryParamMap.put(ProspectorConstants.LABEL_USERNAME, ProspectorConstants.USERNAME_DEV);
        Id transactionSummaryId = null;
       	ProspectorAPITransactionHelper apiHelper = new ProspectorAPITransactionHelper(
                callingApiName,
                null,
                null,
                queryParamMap,
                transactionSummaryId
        );
        String webResponseString = ProspectorAPITransactionHelper.apiTransactionController();
        Test.stopTest();

        System.assertNotEquals(null, webResponseString);
    }//end testMethod testApexRestServiceNullReqBody
/*  */
    
/*  */
    @isTest
    public static void testApexRestServiceStatusCodeNot200() {
        String testApiName = 'CreateProject';
        String reqBody = '{ "serviceInfo": "' + testApiName + '", "params": { "' + 
            ProspectorConstants.LABEL_MAPSERVICENAME + '": "' + ProspectorConstants.MAPSERVICENAME + '", "' + 
            ProspectorConstants.LABEL_USERNAME + '": "' + ProspectorConstants.USERNAME_DEV + '" } }';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/ProspectorAPITransactionHelper';
        request.httpMethod = 'PUT';
        request.requestBody = Blob.valueof(reqBody);

        RestContext.request = request;
        Test.startTest();
        String callingApiName = ProspectorConstants.CREATE_PROJECT;
        Map<String, String> queryParamMap = new Map<String, String>();
        queryParamMap.put(ProspectorConstants.LABEL_MAPSERVICENAME, ProspectorConstants.MAPSERVICENAME);
        queryParamMap.put(ProspectorConstants.LABEL_USERNAME, ProspectorConstants.USERNAME_DEV);
        Id transactionSummaryId = null;
        String rBody = getProspectorCreateProjectCalloutRequestBodyJsonStringNoProjectName();
       	ProspectorAPITransactionHelper apiHelper = new ProspectorAPITransactionHelper(
                callingApiName,
                null,
                rBody,
                queryParamMap,
                transactionSummaryId
        );
        HttpResponse httpResponse = ProspectorAPITransactionHelper.serviceCallout();
		String responseBody = httpResponse.getBody();
//        String webResponseString = ProspectorAPITransactionHelper.apiTransactionController();
        Test.stopTest();

        System.assertNotEquals(null, responseBody);
    }//end testMethod testApexRestServiceStatusCodeNot200
/*  */

/*  */
    @isTest
    public static void testAPITransactionHelperWithProjectId() {
        ProspectorCreateProjectCallout.ProspectorProject resWrapper;

        Test.startTest();
        String callingApiName = ProspectorConstants.SUBMIT_JOB;
        Map<String, String> queryParamMap = new Map<String, String>();
        queryParamMap.put(ProspectorConstants.LABEL_MAPSERVICENAME, ProspectorConstants.MAPSERVICENAME);
        queryParamMap.put(ProspectorConstants.LABEL_USERNAME, ProspectorConstants.USERNAME_DEV);
        queryParamMap.put(ProspectorConstants.LABEL_PROJECTID, testProjId);
        Id transactionSummaryId = null;
        String rBody = getProspectorSubmitJobCalloutRequestBodyJsonString('Green');
       	ProspectorAPITransactionHelper apiHelper = new ProspectorAPITransactionHelper(
                callingApiName,
                null,
                rBody,
                queryParamMap,
                transactionSummaryId
        );
        HttpResponse httpResponse = ProspectorAPITransactionHelper.serviceCallout();
		String responseBody = httpResponse.getBody();
        Test.stopTest();
        
    }//end method testAPITransactionHelperWithProjectId
/*  */
    
/*  */
    @AuraEnabled 
    @isTest
    public static void testApiTransactionLongResponseBody() {
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String responseJSON = null;
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        Http httpProtocol = new Http();
        Time startTime;
      	Time endTime;	
        String callingApiName = 'CreateProject';
        String errorMsg = 'No errors at this time.';

        Test.startTest();
        String testResponseJSON = getProspectorCalloutLongResponse();
        System.debug('(testApiTransactionLongResponseBody) testResponseJSON: \n' + testResponseJSON);

        httpRequest.setEndpoint('https://apimarketplace.lumen.com/');
        httpRequest.setBody('{ "endpoint":"https://apimarketplace.lumen.com/" }');
        httpResponse.setStatus('SUCCESS');
        httpResponse.setStatusCode(200);
        httpResponse.setBody(' { "message":"Welcome to Lumen API Marketplace" } ');
        startTime = DateTime.now().Time();
        endTime = DateTime.now().Time();
        //system.debug('Success... Before createApiTransaction...');
        // Create API Transaction record for history and reports
        ProspectorAPITransactionHelper.createApiTransaction(
            httpResponse.getStatus(),
            httpResponse.getStatusCode(),
            testResponseJSON,
            httpRequest.getEndpoint(),
            httpRequest.getBody(),
            callingApiName,
            startTime,
            endTime,
            errorMsg, // errorDetails,
            null);    // thisTransactionSummaryId                            
        System.assertNotEquals(null, httpResponse);
        Test.stopTest();
    }//end testApiTransactionLongResponseBody
/*  */

/*  */
    @isTest
    public static void testApiTransactionListSave() { 
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String responseJSON = null;
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse = new HttpResponse();
        Http httpProtocol = new Http();
        Time startTime;
      	Time endTime;	
        String callingApiName = 'CreateProject';
        String errorMsg = 'No errors at this time.';

        Test.startTest();
        String testResponseJSON = getProspectorCalloutLongResponse();
        System.debug('(testApiTransactionLongResponseBody) testResponseJSON: \n' + testResponseJSON);

        httpRequest.setEndpoint('https://apimarketplace.lumen.com/');
        httpRequest.setBody('{ "endpoint":"https://apimarketplace.lumen.com/" }');
        httpResponse.setStatus('SUCCESS');
        httpResponse.setStatusCode(200);
        httpResponse.setBody(' { "message":"Welcome to Lumen API Marketplace" } ');
        startTime = DateTime.now().Time();
        endTime = DateTime.now().Time();
        //system.debug('Success... Before createApiTransaction...');
        // Create API Transaction record for history and reports
        ProspectorAPITransactionHelper.createApiTransaction(
            httpResponse.getStatus(),
            httpResponse.getStatusCode(),
            testResponseJSON,
            httpRequest.getEndpoint(),
            httpRequest.getBody(),
            callingApiName,
            startTime,
            endTime,
            errorMsg, // errorDetails,
            null);    // thisTransactionSummaryId
        if (ProspectorAPITransactionHelper.apiTransactionList == null) {
	        System.assertEquals(null, ProspectorAPITransactionHelper.apiTransactionList);            
        } else {
            System.assertNotEquals(null, ProspectorAPITransactionHelper.apiTransactionList);            
            if (ProspectorAPITransactionHelper.apiTransactionList.size() == 0) {
                System.assertEquals(0, ProspectorAPITransactionHelper.apiTransactionList.size());            
            } else {
                System.assertNotEquals(0, ProspectorAPITransactionHelper.apiTransactionList.size());            
            }
        }
        ProspectorAPITransactionHelper.save();
        Test.stopTest();
    }//end testApiTransactionListSave
/*  */

    @AuraEnabled
    @isTest
    public static void testGetBearerAccessToken() {
        Test.startTest();
        String callingApiName = ProspectorConstants.SUBMIT_JOB;
        Map<String, String> queryParamMap = new Map<String, String>();
        queryParamMap.put(ProspectorConstants.LABEL_MAPSERVICENAME, ProspectorConstants.MAPSERVICENAME);
        queryParamMap.put(ProspectorConstants.LABEL_USERNAME, ProspectorConstants.USERNAME_DEV);
        queryParamMap.put(ProspectorConstants.LABEL_PROJECTID, testProjId);
        Id transactionSummaryId = null;
        String rBody = getProspectorSubmitJobCalloutRequestBodyJsonString('Green');
       	ProspectorAPITransactionHelper apiHelper = new ProspectorAPITransactionHelper(
                callingApiName,
                null,
                rBody,
                queryParamMap,
                transactionSummaryId
        );
        String baToken = ProspectorAPITransactionHelper.getBearerAccessToken();
        if (baToken == null) {
            System.assertEquals(null, baToken);
        } else {
            System.assertNotEquals(null, baToken);
        }
        Test.stopTest();
    }//end testApiTransactionLongResponseBody
/*  */

    @AuraEnabled
    @isTest
    public static void testBearerTokenCallout() {
        HttpResponse httpResponse = new HttpResponse();

        Test.startTest();
        String callingApiName = ProspectorConstants.SUBMIT_JOB;
        Map<String, String> queryParamMap = new Map<String, String>();
        queryParamMap.put(ProspectorConstants.LABEL_MAPSERVICENAME, ProspectorConstants.MAPSERVICENAME);
        queryParamMap.put(ProspectorConstants.LABEL_USERNAME, ProspectorConstants.USERNAME_DEV);
        queryParamMap.put(ProspectorConstants.LABEL_PROJECTID, testProjId);
        Id transactionSummaryId = null;
        String rBody = getProspectorSubmitJobCalloutRequestBodyJsonString('Green');
       	ProspectorAPITransactionHelper apiHelper = new ProspectorAPITransactionHelper(
                callingApiName,
                null,
                rBody,
                queryParamMap,
                transactionSummaryId
        );
        httpResponse = ProspectorAPITransactionHelper.bearerTokenCallout();
        if (httpResponse == null) {
            System.assertEquals(null, httpResponse);
        } else {
            System.assertNotEquals(null, httpResponse);
        }
        Test.stopTest();
    }//end testApiTransactionLongResponseBody
/*  */

    private static String getProspectorCreateProjectCalloutRequestBodyJsonString(){
        System.debug('getProspectorCreateProjectCalloutJsonString...');
		String projectNameInput = 'pn' + DateTime.now().getTime();
        String rBody = '';
        rBody += '{';//JSONToken.START_OBJECT;
        rBody += ' "projectName": "' + projectNameInput + '", ';
        rBody += ' "currentUser": "' + ProspectorConstants.MAPSERVICENAME + '", ';
        rBody += ' "mapServiceId": "' + ProspectorConstants.MAPSERVICEID + '" ';
        rBody += '}';//JSONToken.END_OBJECT;
        System.debug('(getProspectorCreateProjectCalloutRequestBodyJsonString) requestBody as JSON = ' + rBody);
                
        return rBody;
    }
    
    private static String getProspectorCreateProjectCalloutRequestBodyJsonStringNoProjectName(){
        System.debug('getProspectorCreateProjectCalloutJsonString...');
		String projectNameInput = 'pn' + DateTime.now().getTime();
        String rBody = '';
        rBody += '{';//JSONToken.START_OBJECT;
        rBody += ' "currentUser": "' + ProspectorConstants.MAPSERVICENAME + '", ';
        rBody += ' "mapServiceId": "' + ProspectorConstants.MAPSERVICEID + '" ';
        rBody += '}';//JSONToken.END_OBJECT;
        System.debug('(getProspectorCreateProjectCalloutRequestBodyJsonString) requestBody as JSON = ' + rBody);
                
        return rBody;
    }

    private static String getProspectorSubmitJobCalloutRequestBodyJsonString(String colorId) {
        String rBody = '';
        rBody += '{';//JSONToken.START_OBJECT;
        rBody += ' "mapServiceName": "' + ProspectorConstants.MAPSERVICENAME + '", ';
        rBody += ' "currentUser": "' + ProspectorConstants.USERNAME_DEV + '", ';
        rBody += ' "mapServiceId": "' + ProspectorConstants.MAPSERVICEID + '", ';
        rBody += ' "guidsToSolve": [],';
        rBody += ' "routeOidsToCost": [],';
        rBody += ' "infrastructureLayerNames": [';
        rBody += ' "' + colorId + '_LCR_Capable_MH_HH", ';
        rBody += ' "' + colorId + '_LCR_Capable_SpliceClosure" ';
        rBody += ' ],';
    	rBody += ' "infrastructureLayerQueryDefs": [';
        rBody += ' "", ';
        rBody += ' "" ';
        rBody += ' ],';
        rBody += ' "disableDropLogic": false, ';
        rBody += ' "homeRunRoutes": false, ';
        rBody += ' "userPointBarrierSetName": "", ';
        rBody += ' "userPolylineBarrierSetName": "", ';
        rBody += ' "userPolygonBarrierSetName": "", ';
        rBody += ' "refreshData": false, ';
        rBody += ' "bufferDistance": 1000, ';
        rBody += ' "calculationUnits": "Feet", ';
        rBody += ' "maxRouteLength": "3", ';
        rBody += ' "maxRouteLengthUnits": "Miles", ';
        rBody += ' "maxChainHops": "100" ';          
        rBody += '}';//JSONToken.END_OBJECT;
        System.debug('(getProspectorSubmitJobCalloutRequestBodyJsonString) requestBody as JSON = ' + rBody);
        
        return rBody;
    }//end method getProspectorSubmitJobCalloutRequestBodyJsonString
    
    private static String getProspectorCalloutLongResponse(){
        return TestBRAINFACalloutHelper.queryForResponseJSONFromStaticResource();
    }
/*  */
}//end test class ProspectorAPITransactionHelper_Test