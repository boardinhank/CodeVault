@IsTest 
private class TestNRMARecordTriggerHelper {    
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
            System.debug('(TestNRMARecordTriggerHelper.setup) AFTER initial insert, testNWCList.get(0).Name = ' + testNWCList.get(0).Name +
                         '\n  AND testNWCList.get(0).Wire_Center_Segmentation__c = ' + testNWCList.get(0).Wire_Center_Segmentation__c);
            testNWCList.get(0).Wire_Center_Segmentation__c = 'WEAK';
            update testNWCList;
        } else {
            System.debug('(TestNRMARecordTriggerHelper.setup) Unable to generate test data for NWC of ' + mockTestNWCCLLI);
        }
        List<Property__c> testPropertyList = TestDataFactory.createProperties(mockTestPptyAddrStreet, mockTestPptyAddrCity, 
                                                                                  mockTestPptyAddrState, mockTestPptyCountyCode, 
                                                                                  mockTestPptyStateCode, mockTestPptyAPN, 
                                                                                  mockTestPptyLat, mockTestPptyLong, 1, True);
        if (testPropertyList != null && testPropertyList.size() > 0) {
            System.debug('(TestNRMARecordTriggerHelper.setup) AFTER initial insert, testPropertyList.get(0).Name = ' + testPropertyList.get(0).Name +
                         '\n  AND testPropertyList.get(0).Id = ' + testPropertyList.get(0).Id);
            testPropertyList.get(0).Name = mockTestPptyName;
            testPropertyList.get(0).Primary_Address_Zip__c = mockTestPptyAddrZip;
            testPropertyList.get(0).Property_Type__c = mockTestPptyType;
            testPropertyList.get(0).Property_Structure__c = mockTestPptyStruct;
            testPropertyList.get(0).Property_Total_Units__c = mockTestPptyTtlUnits;
            testPropertyList.get(0).Network_Wire_Center__c = testNWCList.get(0).Id;                
            update testPropertyList;
        } else {
            System.debug('(TestNRMARecordTriggerHelper.setup) Unable to generate test data for Property of Address: ' + 
                         '\n ' + mockTestPptyAddrStreet + 
                         '\n ' + mockTestPptyAddrCity + 
                         ', ' + mockTestPptyAddrState);
        }
        List<Opportunity> testOpportunityList = TestDataFactory.createOpportunities(mockTestOpptyTitle, mockTestOpptyDevStatus, 
                                                                                            mockTestOpptyStageName, mockTestOpptyCloseDate, 
                                                                                            testPropertyList?.get(0)?.Id, 1, True);
        if (testOpportunityList != null && testOpportunityList.size() > 0) {
            System.debug('(TestNRMARecordTriggerHelper.setup) AFTER initial insert, testOpportunityList.get(0).Name = ' + testOpportunityList.get(0).Name +
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
            System.debug('(TestNRMARecordTriggerHelper.setup) AFTER initial Segment insert, testSegment for Opportunity ' + mockTestOpptyTitle);
        } else {
            System.debug('(TestNRMARecordTriggerHelper.setup) Unable to generate test data for Opportunity of ' + mockTestOpptyTitle);
        }
        List<Offer__c> tempOfferList = TestDataFactory.createOffer(testOpportunityList, 1, True);
        System.debug('(TestNRMARecordTriggerHelper.setup) AFTER initial Offer insert, tempOfferList?.get(0)?.Id = ' + tempOfferList?.get(0)?.Id);
        if (tempOfferList != null && tempOfferList.size() > 0) {
            tempOfferList.get(0).Associated_Capital_Design__c = testingCDId;
            update tempOfferList;
        } else {
            System.debug('(TestNRMARecordTriggerHelper.setup) Unable to generate test data for Offer for Opportunity ' + mockTestOpptyTitle);
        }
        List<Capital_Design__c> tempCDList = TestDataFactory.createCapitalDesignsWithNRMADefaults(testOpportunityList.get(0).Id, tempOfferList.get(0).Id, null, 1, True);
        System.debug('(TestNRMARecordTriggerHelper.setup) AFTER initial CD insert, tempCDList?.get(0)?.Id = ' + ( (tempCDList != null && tempCDList.size() > 0) ? tempCDList.get(0)?.Id : 'null') );
        List<Capital_Design__c> testCDList = NRMARequestHelper.queryCapDesignListById(tempCDList?.get(0)?.Id);
        System.debug('(TestNRMARecordTriggerHelper.setup) QUERY AFTER initial CD insert, testCDList?.get(0)?.Id = ' + ( (testCDList != null && testCDList.size() > 0) ? testCDList.get(0)?.Id : 'null') );
        if (testCDList != null && testCDList.size() > 0) {
            testingCDName = testCDList.get(0).Name;
            testingCDId = testCDList.get(0).Id;
            System.debug('(TestNRMARecordTriggerHelper.setup) AFTER CD update, testingCDId = ' + testingCDId +
                         '\n  AND testingCDName = ' + testingCDName);
        }
        List<NRMA__c> testNRMAList = TestDataFactory.createNRMARequest(testCDList, testPropertyList, 1, True);
        System.debug('(TestNRMARecordTriggerHelper.setup) AFTER NRMA create, testNRMAList?.get(0)?.Id = ' + testNRMAList?.get(0)?.Id);
        testingNRMAId = testNRMAList?.get(0)?.Id;
    }//end @testSetup method setup
    
    @isTest
    private static void testUpdateSupportingDocumentinJSONInsert() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name, URL__c, name__c, Supporting_Document_URLs__c FROM NRMA__c LIMIT 1];
        System.debug('(TestNRMARecordTriggerHelper.testUpdateSupportingDocumentinJSONInsert) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        for (NRMA__c nrma : setupNRMAList) {
            nrma.URL__c = 'something';
            nrma.name__c = 'else';
            nrma.Supporting_Document_URLs__c = '[ { "mockRequestJSON": "mockup1" }, { "mockRequestJSON": "mockup2" } ]';
        }
        update setupNRMAList;
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
        try {
	        NRMARecordTriggerHelper.updateSupportingDocumentinJSON(setupNRMAList, true);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testUpdateSupportingDocumentinJSONInsert)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (setupNRMAList == null) {
            System.assertEquals(null, setupNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
		Test.stopTest();        
    }//end test Method testUpdateSupportingDocumentinJSONInsert
    
    @isTest
    private static void testUpdateSupportingDocumentinJSONEmptySDURL() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name, URL__c, name__c, Supporting_Document_URLs__c FROM NRMA__c LIMIT 1];
        System.debug('(TestNRMARecordTriggerHelper.testUpdateSupportingDocumentinJSONEmptySDURL) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        for (NRMA__c nrma : setupNRMAList) {
            nrma.URL__c = 'something';
            nrma.name__c = 'else';
            nrma.Supporting_Document_URLs__c = '';
        }
        update setupNRMAList;
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
        try {
	        NRMARecordTriggerHelper.updateSupportingDocumentinJSON(setupNRMAList, true);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testUpdateSupportingDocumentinJSONEmptySDURL)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (setupNRMAList == null) {
            System.assertEquals(null, setupNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
		Test.stopTest();        
    }//end test Method testUpdateSupportingDocumentinJSONEmptySDURL

    @isTest
    private static void testUpdateSupportingDocumentinJSONUpdate() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name, URL__c, name__c, Supporting_Document_URLs__c FROM NRMA__c LIMIT 1];
        System.debug('(TestNRMARecordTriggerHelper.testUpdateSupportingDocumentinJSONUpdate) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        for (NRMA__c nrma : setupNRMAList) {
            nrma.URL__c = 'something';
            nrma.name__c = 'else';
            nrma.Supporting_Document_URLs__c = '';
        }
        update setupNRMAList;
        String mockTestResponseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
        try {
	        NRMARecordTriggerHelper.updateSupportingDocumentinJSON(setupNRMAList, false);
        } catch(Exception testX) {
            System.debug('(TestNRMAResponsetHelper.testUpdateSupportingDocumentinJSONUpdate)  EXCEPTION! \n' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (setupNRMAList == null) {
            System.assertEquals(null, setupNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
		Test.stopTest();        
    }//end test Method testUpdateSupportingDocumentinJSONUpdate
    
    @isTest
    private static void testDeleteNRMARecord() {
		Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name, URL__c, name__c, Supporting_Document_URLs__c FROM NRMA__c LIMIT 1];
        System.debug('(TestNRMARecordTriggerHelper.testDeleteNRMARecord) Id = ' + setupNRMAList?.get(0)?.Id);
      	testingNRMAId = setupNRMAList?.get(0)?.Id;
        for (NRMA__c nrma : setupNRMAList) {
            nrma.URL__c = 'something';
            nrma.name__c = 'else';
            nrma.Supporting_Document_URLs__c = '';
        }
        update setupNRMAList;
        delete setupNRMAList;
        if (setupNRMAList == null) {
            System.assertEquals(null, setupNRMAList, NRMA_LIST_NULL_AND_FAILED);
        }
		Test.stopTest();        
    }//end test Method testDeleteNRMARecord

}//end test class TestNRMARecordTriggerHelper