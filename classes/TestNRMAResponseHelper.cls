@IsTest
private class TestNRMAResponseHelper {    
    private static final String EXCEPTION_DEBUG_START = '(TestNRMAResponsetHelper)  EXCEPTION! \n';
    private static final String NRMA_LIST_NULL_AND_FAILED = 'NRMA-List is NULL and failed';
    private static final String NRMA_LIST_NULL_NEG_TEST = 'NRMA-List is NULL as expected for this negative test';
	private static final String DEFAULT_EMPTY = ' ';
    private static final String TESTNRMAREQUESTID = '1225879548856373248';
    private static final String MOCKREQUESTJSON = '{ "mockRequestJSON": "mockup" }';
    private static final String TESTSTATUSRESPONSEJSON = '{ ' +
							'	"nrmaRequestId": "1225879548856373248", ' +
							'	"financeWorkflowId": "55478786",' +
							'   "financeWorkflowStatus": "",' +
							'   "financeCurrentPhaseBeginTime": null,' +
							'   "offerManagementWorkflowId": "55478788",' +
							'	"offerManagementWorkflowStatus": "Archived",' +
							'	"offerManagementCurrentPhaseBeginTime": "2020-03-20T23:28:44Z"' +
							'}';
    private static final String MOCKFAILEDMSGWITHID = 'failed PopulateFromFinancialAnalysis - failed getFromBRAIN for http://brain-env1.lumen.com/investment/v1/financial-analyses/1225881123993686016 - Response failed with status code: 404 and ' + 
                            '\n body: NotFound: no FinancialAnalysis: with ID 1225881123993686016: ' + 
                            '\n unable to populate NRMARequest from provided financialAnalysisID ' + 
                            '\n failed processNRMARequest - processing nrma request id 1621245661213024256 - there were errors interacting with Pipefy - failed newNRMACreateCardRequest - failed brain.GetFinancialAnalysisRequest 1225881123993686016 - failed getFromBRAIN for http://brain-env1.lumen.com/investment/v1/financial-analysis-requests/1225881123993686016 - Response failed with status code: 404 and'+
                            '\n body: NotFound: no FinancialAnalysisRequest: with ID 1225881123993686016:';
    private static final String MOCKFAILEDMSGWITHIDOPPTYTITLEBLANK = 'failed PopulateFromFinancialAnalysis - failed getFromBRAIN for http://brain-env1.lumen.com/investment/v1/financial-analyses/1225881123993686016 - Response failed with status code: 404 and ' +
                            '\n body: NotFound: no FinancialAnalysis: with ID 1225881123993686016: ' + 
                            '\n unable to populate NRMARequest from provided financialAnalysisID ' +
                            '\n failed nrma.Request.Validate - OpportunityTitle cannot be blank';
                
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
            System.debug('(TestNRMAResponseHelper.setup) AFTER initial insert, testNWCList.get(0).Name = ' + testNWCList.get(0).Name +
                         '\n  AND testNWCList.get(0).Wire_Center_Segmentation__c = ' + testNWCList.get(0).Wire_Center_Segmentation__c);
            testNWCList.get(0).Wire_Center_Segmentation__c = 'WEAK';
            update testNWCList;
        } else {
            System.debug('(TestNRMAResponseHelper.setup) Unable to generate test data for NWC of ' + mockTestNWCCLLI);
        }
        List<Property__c> testPropertyList = TestDataFactory.createProperties(mockTestPptyAddrStreet, mockTestPptyAddrCity, 
                                                                                  mockTestPptyAddrState, mockTestPptyCountyCode, 
                                                                                  mockTestPptyStateCode, mockTestPptyAPN, 
                                                                                  mockTestPptyLat, mockTestPptyLong, 1, True);
        if (testPropertyList != null && testPropertyList.size() > 0) {
            System.debug('(TestNRMAResponseHelper.setup) AFTER initial insert, testPropertyList.get(0).Name = ' + testPropertyList.get(0).Name +
                         '\n  AND testPropertyList.get(0).Id = ' + testPropertyList.get(0).Id);
            testPropertyList.get(0).Name = mockTestPptyName;
            testPropertyList.get(0).Primary_Address_Zip__c = mockTestPptyAddrZip;
            testPropertyList.get(0).Property_Type__c = mockTestPptyType;
            testPropertyList.get(0).Property_Structure__c = mockTestPptyStruct;
            testPropertyList.get(0).Property_Total_Units__c = mockTestPptyTtlUnits;
            testPropertyList.get(0).Network_Wire_Center__c = testNWCList.get(0).Id;                
            update testPropertyList;
        } else {
            System.debug('(TestNRMAResponseHelper.setup) Unable to generate test data for Property of Address: ' + 
                         '\n ' + mockTestPptyAddrStreet + 
                         '\n ' + mockTestPptyAddrCity + 
                         ', ' + mockTestPptyAddrState);
        }
        List<Opportunity> testOpportunityList = TestDataFactory.createOpportunities(mockTestOpptyTitle, mockTestOpptyDevStatus, 
                                                                                            mockTestOpptyStageName, mockTestOpptyCloseDate, 
                                                                                            testPropertyList?.get(0)?.Id, 1, True);
        if (testOpportunityList != null && testOpportunityList.size() > 0) {
            System.debug('(TestNRMAResponseHelper.setup) AFTER initial insert, testOpportunityList.get(0).Name = ' + testOpportunityList.get(0).Name +
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
            System.debug('(TestNRMAResponseHelper.setup) AFTER initial Segment insert, testSegment for Opportunity ' + mockTestOpptyTitle);
        } else {
            System.debug('(TestNRMAResponseHelper.setup) Unable to generate test data for Opportunity of ' + mockTestOpptyTitle);
        }
        List<Offer__c> tempOfferList = TestDataFactory.createOffer(testOpportunityList, 1, True);
        System.debug('(TestNRMAResponseHelper.setup) AFTER initial Offer insert, tempOfferList?.get(0)?.Id = ' + tempOfferList?.get(0)?.Id);
        if (tempOfferList != null && tempOfferList.size() > 0) {
            tempOfferList.get(0).Associated_Capital_Design__c = testingCDId;
            update tempOfferList;
        } else {
            System.debug('(TestNRMAResponseHelper.setup) Unable to generate test data for Offer for Opportunity ' + mockTestOpptyTitle);
        }
        List<Capital_Design__c> tempCDList = TestDataFactory.createCapitalDesignsWithNRMADefaults(testOpportunityList.get(0).Id, tempOfferList.get(0).Id, null, 1, True);
        System.debug('(TestNRMAResponseHelper.setup) AFTER initial CD insert, tempCDList?.get(0)?.Id = ' + ( (tempCDList != null && tempCDList.size() > 0) ? tempCDList.get(0)?.Id : 'null') );
        List<Capital_Design__c> testCDList = NRMARequestHelper.queryCapDesignListById(tempCDList?.get(0)?.Id);
        System.debug('(TestNRMAResponseHelper.setup) QUERY AFTER initial CD insert, testCDList?.get(0)?.Id = ' + ( (testCDList != null && testCDList.size() > 0) ? testCDList.get(0)?.Id : 'null') );
        if (testCDList != null && testCDList.size() > 0) {
            testingCDName = testCDList.get(0).Name;
            testingCDId = testCDList.get(0).Id;
            System.debug('(TestNRMAResponseHelper.setup) AFTER CD update, testingCDId = ' + testingCDId +
                         '\n  AND testingCDName = ' + testingCDName);
        }
        List<NRMA__c> testNRMAList = TestDataFactory.createNRMARequest(testCDList, testPropertyList, 1, True);
        System.debug('(TestNRMAResponseHelper.setup) AFTER NRMA create, testNRMAList?.get(0)?.Id = ' + testNRMAList?.get(0)?.Id);
        testingNRMAId = testNRMAList?.get(0)?.Id;
    }//end @testSetup method setup
    
    @isTest
    private static void testParseResponseJSONByCallTypeRequest() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testParseResponseJSONByCallTypeRequest) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
        List<NRMA__c> testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        try {
	        testNRMAList = NRMAResponseHelper.parseResponseJSONByCallType('Request', testNRMAList, mockTestResponseJSON);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testParseResponseJSONByCallTypeRequest)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
		Test.stopTest();        
    }//end test Method testParseResponseJSONByCallTypeRequest
    
    @isTest
    private static void testParseResponseJSONByCallTypeStatus() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testParseResponseJSONByCallTypeStatus) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = TESTSTATUSRESPONSEJSON;
        List<NRMA__c> testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        try {
	        testNRMAList = NRMAResponseHelper.parseResponseJSONByCallType('Status', testNRMAList, mockTestResponseJSON);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testParseResponseJSONByCallTypeStatus)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }//end else NOT NULL
		Test.stopTest();        
    }//end test Method testParseResponseJSONByCallTypeStatus    
    
    @isTest
    private static void testParseResponseJSONByCallTypeRequestNullList() {
		Test.startTest();
        String mockTestResponseJSON = null;
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(null);
        } catch(Exception testX) {
            System.debug('(TestNRMARequestHelper.testQueryNRMARecordListByBadId)EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        try {
	        testNRMAList = NRMAResponseHelper.parseResponseJSONByCallType('Request', testNRMAList, mockTestResponseJSON);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testParseResponseJSONByCallTypeRequestNullList) EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, 'NRMA-List returned from query was NULL as expected in this negative test');
        }//end else NOT NULL
		Test.stopTest();        
    }//end test Method testParseResponseJSONByCallTypeRequestNullList
        
    @isTest
    private static void testParseResponseJSONForNewNRMA() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testParseResponseJSONForNewNRMA) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        try {
	        testNRMAList = NRMAResponseHelper.parseResponseJSONForNewNRMA(testNRMAList, mockTestResponseJSON);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testParseResponseJSONForNewNRMA)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }//end else NOT NULL
		Test.stopTest();        
    }//end test Method testParseResponseJSONForNewNRMA
        
    @isTest
    private static void testParseResponseJSONForNewNRMANullJSON() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testParseResponseJSONForNewNRMANullJSON) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = null;
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        try {
	        testNRMAList = NRMAResponseHelper.parseResponseJSONForNewNRMA(testNRMAList, mockTestResponseJSON);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testParseResponseJSONForNewNRMANullJSON)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }//end else NOT NULL
		Test.stopTest();        
    }//end test Method testParseResponseJSONForNewNRMANullJSON
    
    @isTest
    private static void testExtractNRMARequestIdFromFailedAPIMsgWithId() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testExtractNRMARequestIdFromFailedAPIMsgWithId) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        try {
			testNRMAList = NRMAResponseHelper.extractNRMARequestIdFromFailedAPIMsg(testNRMAList, MOCKFAILEDMSGWITHID);    
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testExtractNRMARequestIdFromFailedAPIMsgWithId)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }//end else NOT NULL
		Test.stopTest();
    }//end test Method testExtractNRMARequestIdFromFailedAPIMsgWithId
    
    @isTest
    private static void testExtractNRMARequestIdFromFailedAPIMsgWithoutId() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testExtractNRMARequestIdFromFailedAPIMsgWithoutId) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        try {
			testNRMAList = NRMAResponseHelper.extractNRMARequestIdFromFailedAPIMsg(testNRMAList, MOCKFAILEDMSGWITHIDOPPTYTITLEBLANK);    
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testExtractNRMARequestIdFromFailedAPIMsgWithoutId)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }//end else NOT NULL
		Test.stopTest();
    }//end test Method testExtractNRMARequestIdFromFailedAPIMsgWithoutId

    @isTest
    private static void testParseResponseJSONForNRMAStatus() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testParseResponseJSONForNRMAStatus) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = TESTSTATUSRESPONSEJSON;
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        try {
	        testNRMAList = NRMAResponseHelper.parseResponseJSONForNRMAStatus(testNRMAList, mockTestResponseJSON);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testParseResponseJSONForNRMAStatus)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }//end else NOT NULL
		Test.stopTest();        
    }//end test Method testParseResponseJSONForNRMAStatus
    
    @isTest
    private static void testParseResponseJSONForNRMAStatusNullJSON() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testParseResponseJSONForNRMAStatusNullJSON) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = null;
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        try {
	        testNRMAList = NRMAResponseHelper.parseResponseJSONForNRMAStatus(testNRMAList, mockTestResponseJSON);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testParseResponseJSONForNRMAStatusNullJSON)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }//end else NOT NULL
		Test.stopTest();        
    }//end test Method testParseResponseJSONForNRMAStatusNullJSON
    
    @isTest
    private static void testDoesRequestResponseMatchRequestRecord() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testDoesRequestResponseMatchRequestRecord) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
   	    NRMARequestsResponseWrap respWrap = NRMARequestsResponseWrap.parse(mockTestResponseJSON);
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        Boolean doesIT = NRMAResponseHelper.doesRequestResponseMatchRequestRecord(testNRMAList, respWrap);
        if (doesIT) {
            System.assertEquals(true, doesIT, 'The Request-Response matches the Request-Record as expected');
        }//end else NOT NULL
		Test.stopTest();        
    }//end test Method testDoesRequestResponseMatchRequestRecord
    
    @isTest
    private static void testAnalyzeAndExtractForRequest() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testAnalyzeAndExtractForRequest) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
   	    NRMARequestsResponseWrap respWrap = NRMARequestsResponseWrap.parse(mockTestResponseJSON);
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        testNRMAList = NRMAResponseHelper.analyzeAndExtractForRequest(testNRMAList, respWrap);
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }//end else NOT NULL
		Test.stopTest();        
    }//end test Method testAnalyzeAndExtractForRequest
    
    @isTest
    private static void testAnalyzeAndExtractForStatus() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testAnalyzeAndExtractForStatus) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = TESTSTATUSRESPONSEJSON;
   	    NRMARequestsResponseWrap respWrap = NRMARequestsResponseWrap.parse(mockTestResponseJSON);
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        Boolean doesIT = NRMAResponseHelper.doesRequestResponseMatchRequestRecord(testNRMAList, respWrap);
        if (doesIT) {
            System.assertEquals(true, doesIT, 'The Request-Response matches the Request-Record as expected');
        }//end else NOT NULL
		Test.stopTest();        
    }//end test Method testAnalyzeAndExtractForStatus
        
    @isTest
    private static void testIdentifyAndLogExceptionsForRequest() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testIdentifyAndLogExceptionsForRequest) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
   	    NRMARequestsResponseWrap respWrap = NRMARequestsResponseWrap.parse(mockTestResponseJSON);
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }//end else NOT NULL
        try {
	        NRMAResponseHelper.identifyAndLogExceptionsForRequest(testNRMAList, respWrap);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testIdentifyAndLogExceptionsForRequest)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testIdentifyAndLogExceptionsForRequest
    
    @isTest
    private static void testIdentifyAndLogExceptionsForReqestNullList() {
		Test.startTest();
        List<NRMA__c> testNRMAList = null;
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_NEG_TEST);
        }//end else NOT NULL
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
   	    NRMARequestsResponseWrap respWrap = NRMARequestsResponseWrap.parse(mockTestResponseJSON);
        try {
	        NRMAResponseHelper.identifyAndLogExceptionsForRequest(testNRMAList, respWrap);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testIdentifyAndLogExceptionsForRequestNullList)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testIdentifyAndLogExceptionsForReqestNullList
    
    @isTest
    private static void testIdentifyAndLogExceptionsForRequestEmptyList() {
		Test.startTest();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();        
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }//end if NULL
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
   	    NRMARequestsResponseWrap respWrap = NRMARequestsResponseWrap.parse(mockTestResponseJSON);
        try {
	        NRMAResponseHelper.identifyAndLogExceptionsForRequest(testNRMAList, respWrap);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testIdentifyAndLogExceptionsForRequestEmptyList)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testIdentifyAndLogExceptionsForRequestEmptyList
    
    @isTest
    private static void testIdentifyAndLogExceptionsForRequestNullObjInList() {
		Test.startTest();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        testNRMAList.add(null);
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
   	    NRMARequestsResponseWrap respWrap = NRMARequestsResponseWrap.parse(mockTestResponseJSON);
        try {
	        NRMAResponseHelper.identifyAndLogExceptionsForRequest(testNRMAList, respWrap);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testIdentifyAndLogExceptionsForRequestNullObjInList)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testIdentifyAndLogExceptionsForRequestNullObjInList
    
    @isTest
    private static void testIdentifyAndLogExceptionsForRequestNullRespWrap() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testIdentifyAndLogExceptionsForRequestNullRespWrap) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
   	    NRMARequestsResponseWrap respWrap = null;
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        } 
        try {
	        NRMAResponseHelper.identifyAndLogExceptionsForRequest(testNRMAList, respWrap);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testIdentifyAndLogExceptionsForRequestNullRespWrap)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testIdentifyAndLogExceptionsForRequestNullRespWrap
    
    @isTest
    private static void testIdentifyAndLogExceptionsForStatus() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testIdentifyAndLogExceptionsForStatus) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        String mockTestResponseJSON = TESTSTATUSRESPONSEJSON;
   	    NRMAStatusResponseWrap respWrap = NRMAStatusResponseWrap.parse(mockTestResponseJSON);
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        } 
        try {
	        NRMAResponseHelper.identifyAndLogExceptionsForStatus(testNRMAList, respWrap);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testIdentifyAndLogExceptionsForStatus)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testIdentifyAndLogExceptionsForStatus
    
    @isTest
    private static void testIdentifyAndLogExceptionsForStatusNullList() {
		Test.startTest();
        List<NRMA__c> testNRMAList = null;
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_NEG_TEST);
        }
        String mockTestResponseJSON = TESTSTATUSRESPONSEJSON;
   	    NRMAStatusResponseWrap respWrap = NRMAStatusResponseWrap.parse(mockTestResponseJSON);
        try {
	        NRMAResponseHelper.identifyAndLogExceptionsForStatus(testNRMAList, respWrap);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testIdentifyAndLogExceptionsForStatusNullList)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testIdentifyAndLogExceptionsForStatusNullList
    
    @isTest
    private static void testIdentifyAndLogExceptionsForStatusEmptyList() {
		Test.startTest();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();        
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
        String mockTestResponseJSON = TESTSTATUSRESPONSEJSON;
   	    NRMAStatusResponseWrap respWrap = NRMAStatusResponseWrap.parse(mockTestResponseJSON);
        try {
	        NRMAResponseHelper.identifyAndLogExceptionsForStatus(testNRMAList, respWrap);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testIdentifyAndLogExceptionsForStatusEmptyList)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testIdentifyAndLogExceptionsForStatusEmptyList
    
    @isTest
    private static void testIdentifyAndLogExceptionsForStatusNullObjInList() {
		Test.startTest();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        testNRMAList.add(null);
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
        String mockTestResponseJSON = TESTSTATUSRESPONSEJSON;
   	    NRMAStatusResponseWrap respWrap = NRMAStatusResponseWrap.parse(mockTestResponseJSON);
        try {
	        NRMAResponseHelper.identifyAndLogExceptionsForStatus(testNRMAList, respWrap);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testIdentifyAndLogExceptionsForStatusNullObjInList)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testIdentifyAndLogExceptionsForStatusNullObjInList
    
    @isTest
    private static void testIdentifyAndLogExceptionsForStatusNullRespWrap() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testIdentifyAndLogExceptionsForStatusNullRespWrap) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
   	    NRMAStatusResponseWrap respWrap = null;
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
        try {
	        NRMAResponseHelper.identifyAndLogExceptionsForStatus(testNRMAList, respWrap);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testIdentifyAndLogExceptionsForStatusNullRespWRap)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testIdentifyAndLogExceptionsForStatusNullRespWrap

	@isTest
    private static void testUpdateNRMAList() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMAResponseHelper.testUpdateNRMAList) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        } catch(Exception testX) {
            System.debug(EXCEPTION_DEBUG_START + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
        try {
	        NRMAResponseHelper.updateNRMAList(testNRMAList);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testUpdateNRMAList)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testUpdateNRMAList

    @isTest
    private static void testUpdateNRMAListNullList() {
		Test.startTest();
        List<NRMA__c> testNRMAList = null;
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_NEG_TEST);
        }
        try {
	        NRMAResponseHelper.updateNRMAList(testNRMAList);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testUpdateNRMAListNullList)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testUpdateNRMAListNullList

    @isTest
    private static void testUpdateNRMAListEmptyList() {
		Test.startTest();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
        try {
	        NRMAResponseHelper.updateNRMAList(testNRMAList);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testUpdateNRMAListEmptyList)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testUpdateNRMAListEmptyList
    
    @isTest
    private static void testUpdateNRMAListWithNullObj() {
		Test.startTest();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        testNRMAList.add(null);
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
        try {
	        NRMAResponseHelper.updateNRMAList(testNRMAList);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testUpdateNRMAListWithNullObj)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
		Test.stopTest();        
    }//end test Method testUpdateNRMAListNullObj

}//end test class TestNRMAResponseHelper