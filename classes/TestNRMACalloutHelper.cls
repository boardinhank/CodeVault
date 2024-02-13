@IsTest
public class TestNRMACalloutHelper {
    private static final String HTTPREQ_NULL_AND_FAILED = 'HttpRequest was NULL and failed';
    private static final String HTTPREQEP_NULL_AND_FAILED = 'HttpRequest-Endpoint was NULL and failed';
    private static final String HTTPREQMTHD_NULL_AND_FAILED = 'HttpRequest-Method was NULL and failed';
    private static final String CONTENT_TYPE = 'Content-Type';
    private static final String APP_JSON = 'application/json';
	private static final String DEFAULT_EMPTY = ' '; 
    private static final String TESTNRMAREQUESTID = '1225879548856373248';
    private static final String MOCKREQUESTJSON = '{ "mockRequestJSON": "mockup" }';
    //variables that hold values from testSetup data that was created
    private static Id testingNRMAId = null;
    private static Id testingCDId = null;
    private static String testingCDName = '';
    private static Id testingOfferId = null;
    private static String testingOfferName = null;
    
    @testSetup 
    private static void setup(){
        final String mockTestNWCCLLI = 'GLSHALXA';
        final String mockTestPptyAddrStreet = '2764 W BEACH BLVD';
        final String mockTestPptyAddrCity = 'GULF SHORES';
        final String mockTestPptyAddrState = 'AL';
        final String mockTestPptyAddrZip = '36542';
        final String mockTestPptyCountyCode = 'BWN';
        final String mockTestPptyStateCode = 'AL';
        final String mockTestPptyAPN = '';
        final Decimal mockTestPptyLat =   30.23548000;
        final Decimal mockTestPptyLong = -87.77961100;
        final String mockTestPptyName = 'NOAH ALLEN BEACH ESTATES';
        final String mockTestPptyType = 'Single Family Home (SFH)';
        final String mockTestPptyStruct = 'SFH (Single Family Home)';
        final Decimal mockTestPptyTtlUnits = 12;
        final String mockTestOpptyTitle = mockTestPptyName + ' - Instant Internet - FTTU';
        final String mockTestOpptyDevStatus = 'Greenfield';
        final String mockTestOpptyStageName = 'Proposed';
        final Date mockTestOpptyCloseDate = (Date.today()).addMonths(8);
        List<Network_Wire_Center__c> testNWCList = TestDataFactory.createNetworkWireCenters(mockTestNWCCLLI, 1, True);
        if (testNWCList != null && testNWCList.size() > 0) {
            System.debug('(TestNRMACalloutHelper.setup) AFTER initial insert, testNWCList.get(0).Name = ' + testNWCList.get(0).Name +
                         '\n  AND testNWCList.get(0).Wire_Center_Segmentation__c = ' + testNWCList.get(0).Wire_Center_Segmentation__c);
            testNWCList.get(0).Wire_Center_Segmentation__c = 'WEAK';
            update testNWCList;
        } else {
            System.debug('(TestNRMACalloutHelper.setup) Unable to generate test data for NWC of ' + mockTestNWCCLLI);
        }
        List<Property__c> testPropertyList = TestDataFactory.createProperties(mockTestPptyAddrStreet, mockTestPptyAddrCity, 
                                                                                  mockTestPptyAddrState, mockTestPptyCountyCode, 
                                                                                  mockTestPptyStateCode, mockTestPptyAPN, 
                                                                                  mockTestPptyLat, mockTestPptyLong, 1, True);
        if (testPropertyList != null && testPropertyList.size() > 0) {
            System.debug('(TestNRMACalloutHelper.setup) AFTER initial insert, testPropertyList.get(0).Name = ' + testPropertyList.get(0).Name +
                         '\n  AND testPropertyList.get(0).Id = ' + testPropertyList.get(0).Id);
            testPropertyList.get(0).Name = mockTestPptyName;
            testPropertyList.get(0).Primary_Address_Zip__c = mockTestPptyAddrZip;
            testPropertyList.get(0).Property_Type__c = mockTestPptyType;
            testPropertyList.get(0).Property_Structure__c = mockTestPptyStruct;
            testPropertyList.get(0).Property_Total_Units__c = mockTestPptyTtlUnits;
            testPropertyList.get(0).Network_Wire_Center__c = testNWCList.get(0).Id;                
            update testPropertyList;
        } else {
            System.debug('(TestNRMACalloutHelper.setup) Unable to generate test data for Property of Address: ' + 
                         '\n ' + mockTestPptyAddrStreet + 
                         '\n ' + mockTestPptyAddrCity + 
                         ', ' + mockTestPptyAddrState);
        }
        List<Opportunity> testOpportunityList = TestDataFactory.createOpportunities(mockTestOpptyTitle, mockTestOpptyDevStatus, 
                                                                                            mockTestOpptyStageName, mockTestOpptyCloseDate, 
                                                                                            testPropertyList?.get(0)?.Id, 1, True);
        if (testOpportunityList != null && testOpportunityList.size() > 0) {
            System.debug('(TestNRMACalloutHelper.setup) AFTER initial insert, testOpportunityList.get(0).Name = ' + testOpportunityList.get(0).Name +
                         '\n  AND testOpportunityList.get(0).Id = ' + testOpportunityList.get(0).Id);
            Segment__c testSegment = new Segment__c (
                        Segment_Total_Units__c = 0,//mockTestPptyTtlUnits,
                        Segment_Structure__c = mockTestPptyStruct,
                        Property__c = testPropertyList.get(0).Id,
                        Segment_Status__c = 'Active Opportunity',
                        Opportunity__c = testOpportunityList.get(0).Id,
                        Segment_Inventory_Type__c = 'Unit Inventory Driver',
                        Segment_Use__c = 'Rental');
            insert testSegment;
            System.debug('(TestNRMACalloutHelper.setup) AFTER initial Segment insert, testSegment for Opportunity ' + mockTestOpptyTitle);
        } else {
            System.debug('(TestNRMACalloutHelper.setup) Unable to generate test data for Opportunity of ' + mockTestOpptyTitle);
        }
        List<Offer__c> tempOfferList = TestDataFactory.createOffer(testOpportunityList, 1, True);
        System.debug('(TestNRMACalloutHelper.setup) AFTER initial Offer insert, tempOfferList?.get(0)?.Id = ' + tempOfferList?.get(0)?.Id);
        if (tempOfferList != null && tempOfferList.size() > 0) {
            tempOfferList.get(0).Associated_Capital_Design__c = testingCDId;
            update tempOfferList;
        } else {
            System.debug('(TestNRMACalloutHelper.setup) Unable to generate test data for Offer for Opportunity ' + mockTestOpptyTitle);
        }
        List<Capital_Design__c> tempCDList = TestDataFactory.createCapitalDesignsWithNRMADefaults(testOpportunityList.get(0).Id, tempOfferList.get(0).Id, null, 1, True);
        System.debug('(TestNRMACalloutHelper.setup) AFTER initial CD insert, tempCDList?.get(0)?.Id = ' + ( (tempCDList != null && tempCDList.size() > 0) ? tempCDList.get(0)?.Id : 'null') );
        List<Capital_Design__c> testCDList = NRMARequestHelper.queryCapDesignListById(tempCDList?.get(0)?.Id);
        System.debug('(TestNRMACalloutHelper.setup) QUERY AFTER initial CD insert, testCDList?.get(0)?.Id = ' + ( (testCDList != null && testCDList.size() > 0) ? testCDList.get(0)?.Id : 'null') );
        if (testCDList != null && testCDList.size() > 0) {
            testingCDName = testCDList.get(0).Name;
            testingCDId = testCDList.get(0).Id;
            System.debug('(TestNRMACalloutHelper.setup) AFTER CD update, testingCDId = ' + testingCDId + '\n  AND testingCDName = ' + testingCDName);
        }
        List<NRMA__c> testNRMAList = TestDataFactory.createNRMARequest(testCDList, testPropertyList, 1, True);
        System.debug('(TestNRMACalloutHelper.setup) AFTER NRMA create, testNRMAList?.get(0)?.Id = ' + testNRMAList?.get(0)?.Id);
        testingNRMAId = testNRMAList?.get(0)?.Id;
    }//end @testSetup method setup
    
    @isTest     
    private static void testParseForAccessToken() {        
        Test.startTest();
        HttpResponse mockApigeeResponse = TestNRMACalloutHelper.getMockApigeeHttpResponse();
        String testAccessToken = NRMACalloutHelper.parseForAccessToken(mockApigeeResponse.getBody());
        if(testAccessToken == null) {
            System.assertEquals(null, testAccessToken, 'AccessToken was NULL and failed');
        }
        Test.stopTest();
    }//end test method testParseForAccessToken
    
    @isTest     
    private static void testParseForAccessTokenNullBody() {
        Test.startTest();
        String testAccessToken = NRMACalloutHelper.parseForAccessToken(null);
        if(testAccessToken == null) {
            System.assertEquals(null, testAccessToken, 'AccessToken was NULL as expected in this negative test');
        }
        Test.stopTest();
    }//end test method testParseForAccessTokenNullBody

    @isTest     
    private static void testExecuteCallout() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMACalloutHelper.testExecuteCallout) setupNRMAList == null??? ' + (setupNRMAList == null) +
                     			'\n setupNRMAList.size() = ' + setupNRMAList?.size());
        if (setupNRMAList != null && setupNRMAList.size() > 0) {
	        System.debug('(TestNRMACalloutHelper.testExecuteCallout) setupNRMAList.get(0) == null??? ' + (setupNRMAList?.get(0) == null) +
                    			'\n Id = ' + setupNRMAList?.get(0)?.Id);
        	testingNRMAId = setupNRMAList.get(0).Id;
        }
		List<NRMACalloutController.CalloutParams> calloutParamsList = new List<NRMACalloutController.CalloutParams>();
        NRMACalloutController.CalloutParams cp = new NRMACalloutController.CalloutParams();
        cp.nrmaRecordId = testingNRMAId;
        cp.nrmaCallType = 'Status';
        calloutParamsList.add(cp);
        String responseJSON = NRMACalloutHelper.executeCallout(calloutParamsList, MOCKREQUESTJSON, TESTNRMAREQUESTID);
        if (responseJSON == null) {
            System.assertEquals(null, responseJSON, 'The responseJSON returned from method executeCallout was NULL and failed');
        }
		Test.stopTest();        
    }//end test method testBuildHttpRequestByCallTypeRequests

    @isTest     
    private static void testMakeServiceCallout() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMACalloutHelper.testExecuteCallout) setupNRMAList == null??? ' + (setupNRMAList == null) +
                     			'\n setupNRMAList.size() = ' + setupNRMAList?.size());
        if (setupNRMAList != null && setupNRMAList.size() > 0) {
	        System.debug('(TestNRMACalloutHelper.testExecuteCallout) setupNRMAList.get(0) == null??? ' + (setupNRMAList?.get(0) == null) +
                    			'\n Id = ' + setupNRMAList?.get(0)?.Id);
        	testingNRMAId = setupNRMAList.get(0).Id;
        }
		List<NRMACalloutController.CalloutParams> calloutParamsList = new List<NRMACalloutController.CalloutParams>();
        NRMACalloutController.CalloutParams cp = new NRMACalloutController.CalloutParams();
        cp.nrmaRecordId = testingNRMAId;
        cp.nrmaCallType = 'Status';
        calloutParamsList.add(cp);
        HttpResponse httpResponseNRMA = NRMACalloutHelper.makeServiceCallout(calloutParamsList, MOCKREQUESTJSON, TESTNRMAREQUESTID);
        if (httpResponseNRMA == null) {
            System.assertEquals(null, httpResponseNRMA, 'HttpResponse returned from method makeServiceCallout was NULL and failed');
        }
        if (httpResponseNRMA?.getBody() == null) {
            System.assertEquals(null, httpResponseNRMA?.getBody(), 'HttpResponse-Body was NULL and failed');
        }
		Test.stopTest();        
    }//end test method testBuildHttpRequestByCallTypeRequests

    @isTest     
    private static void testBuildHttpRequestByCallTypeRequests() {
		Test.startTest();
        HttpRequest httpRequestNRMA = NRMACalloutHelper.buildHttpRequestByCallType('Request', MOCKREQUESTJSON, TESTNRMAREQUESTID);
        if (httpRequestNRMA == null) {
            System.assertEquals(null, httpRequestNRMA, HTTPREQ_NULL_AND_FAILED);
        }
        if (httpRequestNRMA?.getBody() == null) {
            System.assertEquals(null, httpRequestNRMA?.getBody(), 'HttpRequest-Body was NULL and failed');
        }
        if (httpRequestNRMA?.getEndpoint() == null) {
            System.assertEquals(null, httpRequestNRMA?.getEndpoint(), HTTPREQEP_NULL_AND_FAILED);
        }
        if (httpRequestNRMA?.getMethod() == null) {
            System.assertEquals(null, httpRequestNRMA?.getMethod(), HTTPREQMTHD_NULL_AND_FAILED);                        
        }
		Test.stopTest();        
    }//end test method testBuildHttpRequestByCallTypeRequests
    
    @isTest     
    private static void testBuildHttpRequestByCallTypeStatus() {
		Test.startTest();
        HttpRequest httpRequestNRMA = NRMACalloutHelper.buildHttpRequestByCallType('Status', MOCKREQUESTJSON, TESTNRMAREQUESTID);
        if (httpRequestNRMA == null) {
            System.assertEquals(null, httpRequestNRMA, HTTPREQ_NULL_AND_FAILED);
        }
        if (httpRequestNRMA?.getBody() == null) {
            System.assertEquals(null, httpRequestNRMA?.getBody(), 'HttpRequest-Body was NULL as expected (should be NULL for Status)');
        }
        if (httpRequestNRMA?.getEndpoint() == null) {
            System.assertEquals(null, httpRequestNRMA?.getEndpoint(), HTTPREQEP_NULL_AND_FAILED);
        }
        if (httpRequestNRMA?.getMethod() == null) {
            System.assertEquals(null, httpRequestNRMA?.getMethod(), HTTPREQMTHD_NULL_AND_FAILED);                        
        }
		Test.stopTest();        
    }//end test method testBuildHttpRequestByCallTypeStatus
    
    @isTest     
    private static void testBuildHttpRequestForNRMARequestService() {
		Test.startTest();
        String mockTestRequestJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
        HttpRequest httpRequestNRMA = NRMACalloutHelper.buildHttpRequestForNRMARequestService(mockTestRequestJSON);
        if (httpRequestNRMA == null) {
            System.assertEquals(null, httpRequestNRMA, HTTPREQ_NULL_AND_FAILED);
        }
        if (httpRequestNRMA?.getBody() == null) {
            System.assertEquals(null, httpRequestNRMA?.getBody(), 'HttpRequest-Body was NULL and failed');
        }
        if (httpRequestNRMA?.getEndpoint() == null) {
            System.assertEquals(null, httpRequestNRMA?.getEndpoint(), HTTPREQEP_NULL_AND_FAILED);
        }
        if (httpRequestNRMA?.getMethod() == null) {
            System.assertEquals(null, httpRequestNRMA?.getMethod(), HTTPREQMTHD_NULL_AND_FAILED);                        
        }
		Test.stopTest();        
    }//end test method testBuildHttpRequestForNRMARequestService
    
    @isTest     
    private static void testBuildHttpRequestForNRMAStatusService() {
		Test.startTest();
        HttpRequest httpRequestNRMA = NRMACalloutHelper.buildHttpRequestForNRMAStatusService(testingNRMAId);
        if (httpRequestNRMA == null) {
            System.assertEquals(null, httpRequestNRMA, HTTPREQ_NULL_AND_FAILED);
        }
        if (httpRequestNRMA?.getBody() == null) {
            System.assertEquals(null, httpRequestNRMA?.getBody(), 'HttpRequest-Body was NULL as expected (should be NULL for Status)');
        }
        if (httpRequestNRMA?.getEndpoint() == null) {
            System.assertEquals(null, httpRequestNRMA?.getEndpoint(), HTTPREQEP_NULL_AND_FAILED);
        }
        if (httpRequestNRMA?.getMethod() == null) {
            System.assertEquals(null, httpRequestNRMA?.getMethod(), HTTPREQMTHD_NULL_AND_FAILED);                        
        }
		Test.stopTest();        
    }//end test method testBuildHttpRequestForNRMAStatusService
    
    @isTest     
    private static  void testGetHttpResponseFromNRMA() {
		Test.startTest();
        HttpRequest httpRequestNRMA = new HttpRequest();        
        httpRequestNRMA.setHeader(CONTENT_TYPE, APP_JSON);
        httpRequestNRMA.setBody(MOCKREQUESTJSON);
        httpRequestNRMA.setMethod('POST');
        HttpResponse httpResponseNRMA = NRMACalloutHelper.getHttpResponseFromNRMA(httpRequestNRMA);
        if(httpResponseNRMA == null) {
	        System.assertEquals(null, httpResponseNRMA, 'HttpResponse was NULL and failed');            
        }
        if(httpResponseNRMA?.getBody() == null) {
            System.assertEquals(null, httpResponseNRMA?.getBody(), 'HttpResponse-Body was NULL and failed');
        }
		Test.stopTest();        
    }//end testMethod testGetHttpResponseFromNRMA
    
    @isTest     
    private static  void testGetHttpResponseFromNRMAWithNullRequest() {
		Test.startTest();
        HttpRequest httpRequestNRMA = null;
        HttpResponse httpResponseNRMA = null;
        try {        
        	httpResponseNRMA = NRMACalloutHelper.getHttpResponseFromNRMA(httpRequestNRMA);
        } catch(Exception testX) {
            System.debug('(TestNRMACalloutHelper.testGetHttpResponseFromNRMAWithNullRequest)  EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
        }
        if(httpResponseNRMA == null) {
	        System.assertEquals(null, httpResponseNRMA, 'HttpResponse was NULL as expected in this negative test');
        }
		Test.stopTest();        
    }//end testMethod testGetHttpResponseFromNRMAWithNullRequest
    
    @isTest     
    private static  void testExtractDataFromHttpResponse() {
		Test.startTest();
        HttpResponse httpResponseNRMA = TestNRMACalloutHelper.getHttpResponseFromStaticResource();
        String responseJSON = NRMACalloutHelper.extractDataFromHttpResponse(httpResponseNRMA);
        if (responseJSON == null) {
	        System.assertEquals(null, responseJSON, 'Response-JSON extracted from HttpResponse was NULL and failed');
        }            
		Test.stopTest();        
    }//end testMethod testExtractDataFromHttpResponse
    
    @isTest     
    private static void testExtractDataFromHttpResponseBadStatusCode() {
		Test.startTest();
        HttpResponse httpResponseNRMA = TestNRMACalloutHelper.getHttpResponseFromStaticResource();
        httpResponseNRMA.setStatusCode(500);
        httpResponseNRMA.setBody('{ "errorMessage": "Testing for BAD STATUS CODE" }');
        String responseJSON = NRMACalloutHelper.extractDataFromHttpResponse(httpResponseNRMA);
        if (responseJSON == null) {
	        System.assertEquals(null, responseJSON, 'Response-JSON extracted from HttpResponse was NULL and failed');
        }            
		Test.stopTest();        
    }//end testMethod testExtractDataFromHttpResponseBadStatusCode
    
    @isTest     
    private static  void testLogApiTransaction() {
        String detailsMsg = 'No errors at this time.';

        Test.startTest();
        NRMACalloutHelper.logApiTransaction(new HttpRequest(), new HttpResponse(), detailsMsg);
        System.assertNotEquals(null, detailsMsg, 'detailsMsg is NOT NULL as expected');
		Test.stopTest();        
    }//end test method testLogApiTransaction
    
    @isTest     
    private static  void testTrimString() {
		Test.startTest();
        String origString = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();        
        System.debug('(TestNRMACalloutHelper.testTrimString) String.isBlank(origString)? ' + String.isBlank(origString) + ', thus origString?.length() = ' + origString?.length());
        String trimmedString = NRMACalloutHelper.trimString(origString);
        System.debug('(TestNRMACalloutHelper.testTrimString) String.isBlank(trimmedString)? ' + String.isBlank(trimmedString) + ', thus trimmedString?.length() = ' + trimmedString?.length());
        if(trimmedString?.length() == origString?.length()) {
            System.assertEquals(origString, trimmedString, 'The original String length (' + origString?.length() + ') was less than 131072 so was not trimmed as expected');
        }
		Test.stopTest();        
    }//end testMethod testTrimString    
    
    @isTest     
    private static  void testTrimStringWithLongerString() {
		Test.startTest();
        String origString = TestNRMACalloutHelper.queryForLongResponseJSONFromStaticResource();        
        System.debug('(TestNRMACalloutHelper.testTrimStringWithLongerString) String.isBlank(origString)? ' + String.isBlank(origString) + ', thus origString?.length() = ' + origString?.length());
        String trimmedString = NRMACalloutHelper.trimString(origString);
        System.debug('(TestNRMACalloutHelper.testTrimStringWithLongerString) String.isBlank(trimmedString)? ' + String.isBlank(trimmedString) + ', thus trimmedString?.length() = ' + trimmedString?.length());
        if(trimmedString?.length() < origString?.length()) {
            System.assertNotEquals(origString, trimmedString, 'The original String length (' + origString?.length() + ') was more than 131072 so was trimmed as expected');
        }
		Test.stopTest();        
    }//end testMethod testTrimStringWithLongerString

    public static HttpResponse getHttpResponseFromStaticResource() {
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader(CONTENT_TYPE, APP_JSON);
        mockHttpResponse.setStatusCode(200);
        mockHttpResponse.setBody(queryForResponseJSONFromStaticResource());
		// Return the mocked HttpResponse 
        return mockHttpResponse;        
    }// end getHttpResponseFromStaticResource

    public static String queryForResponseJSONFromStaticResource() {
		String srName = 'TestNRMARequestsResponseJSON';
    	String srResponseJSON = null;
        // Setup 
        StaticResource testResponseSR = null;
        try {
	        testResponseSR = [SELECT Id, Name, Body FROM StaticResource WHERE Name = :srName LIMIT 1];
        } catch (Exception srX) {
            System.debug('EXCEPTION!  Error querying for StaticResource ("' + srName + '")');
        }
        if (testResponseSR != null && testResponseSR.Body != null) {
			srResponseJSON = testResponseSR.Body.ToString();
        } else {
            srResponseJSON = null;
        }
		// Return the body of the queried StaticResource
        return srResponseJSON;        
    }// end queryForResponseJSONFromStaticResource

    public static String queryForLongResponseJSONFromStaticResource() {
		String srName = 'TestBRAINFAResponseCapDesCD00000250JSON';
    	String srResponseJSON = null;
        // Setup 
        StaticResource testResponseSR = null;
        try {
	        testResponseSR = [SELECT Id, Name, Body FROM StaticResource WHERE Name = :srName LIMIT 1];
        } catch (Exception srX) {
            System.debug('EXCEPTION!  Error querying for StaticResource ("' + srName + '")');
        }
        if (testResponseSR != null && testResponseSR.Body != null) {
			srResponseJSON = testResponseSR.Body.ToString();
        } else {
            srResponseJSON = null;
        }
		// Return the body of the queried StaticResource
        return srResponseJSON;        
    }// end queryForLongResponseJSONFromStaticResource

    public static HttpResponse getMockApigeeHttpResponse() {
    	String mockApigeeResponseBody = '{ "refresh_token_expires_in": "0", ' + 
    		'"api_product_list": "[BRAIN - Broadband Reinvestment Artificial Intelligence Network]", ' +
            '"api_product_list_json": [ "BRAIN - Broadband Reinvestment Artificial Intelligence Network" ], ' +
    		'"organization_name": "ext", ' + 
            '"developer.email": "matt.holden@lumen.com", ' + 
            '"token_type": "Bearer", ' +
            '"issued_at": "1656008376489", ' + 
    		'"client_id": "whatchamacallit", ' +
		    '"access_token": "supercalifragilistic", ' +
            '"application_name": "expialidocious", ' +
            '"scope": "Party like it`s ", ' +
            '"expires_in": "1999", ' + 
            '"refresh_count": "0", ' +
            '"status": "approved" }';
        
        HttpResponse mockHttpResponse = new HttpResponse();  
        mockHttpResponse.setHeader(CONTENT_TYPE, APP_JSON);
        mockHttpResponse.setStatusCode(200);
        mockHttpResponse.setBody(mockApigeeResponseBody);
		// Return the mocked HttpResponse 
        return mockHttpResponse;        
    }//end method getMockApigeeHttpResponse
}//end test class TestNRMACalloutHelper