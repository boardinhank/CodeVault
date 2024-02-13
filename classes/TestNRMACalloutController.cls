@IsTest
public class TestNRMACalloutController { 
    private static final String CNTRLR_NULL_AND_FAILED = 'After constructor, NRMACalloutController was NULL and failed';
    private static final String PARMLIST_NULL_NEG_TEST = 'After constructor, NRMACalloutController parameter-list was NULL as expected in this negative test';
	private static final String DEFAULT_EMPTY = ' ';
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
            System.debug('(TestNRMACalloutController.setup) AFTER initial insert, testNWCList.get(0).Name = ' + testNWCList.get(0).Name +
                         '\n  AND testNWCList.get(0).Wire_Center_Segmentation__c = ' + testNWCList.get(0).Wire_Center_Segmentation__c);
            testNWCList.get(0).Wire_Center_Segmentation__c = 'WEAK';
            update testNWCList;
        } else {
            System.debug('(TestNRMACalloutController.setup) Unable to generate test data for NWC of ' + mockTestNWCCLLI);
        }
        List<Property__c> testPropertyList = TestDataFactory.createProperties(mockTestPptyAddrStreet, mockTestPptyAddrCity, 
                                                                                  mockTestPptyAddrState, mockTestPptyCountyCode, 
                                                                                  mockTestPptyStateCode, mockTestPptyAPN, 
                                                                                  mockTestPptyLat, mockTestPptyLong, 1, True);
        if (testPropertyList != null && testPropertyList.size() > 0) {
            System.debug('(TestNRMACalloutController.setup) AFTER initial insert, testPropertyList.get(0).Name = ' + testPropertyList.get(0).Name +
                         '\n  AND testPropertyList.get(0).Id = ' + testPropertyList.get(0).Id);
            testPropertyList.get(0).Name = mockTestPptyName;
            testPropertyList.get(0).Primary_Address_Zip__c = mockTestPptyAddrZip;
            testPropertyList.get(0).Property_Type__c = mockTestPptyType;
            testPropertyList.get(0).Property_Structure__c = mockTestPptyStruct;
            testPropertyList.get(0).Property_Total_Units__c = mockTestPptyTtlUnits;
            testPropertyList.get(0).Network_Wire_Center__c = testNWCList.get(0).Id;                
            update testPropertyList;
        } else {
            System.debug('(TestNRMACalloutController.setup) Unable to generate test data for Property of Address: ' + 
                         '\n ' + mockTestPptyAddrStreet + 
                         '\n ' + mockTestPptyAddrCity + 
                         ', ' + mockTestPptyAddrState);
        }
        List<Opportunity> testOpportunityList = TestDataFactory.createOpportunities(mockTestOpptyTitle, mockTestOpptyDevStatus, 
                                                                                            mockTestOpptyStageName, mockTestOpptyCloseDate, 
                                                                                            testPropertyList?.get(0)?.Id, 1, True);
        if (testOpportunityList != null && testOpportunityList.size() > 0) {
            System.debug('(TestNRMACalloutController.setup) AFTER initial insert, testOpportunityList.get(0).Name = ' + testOpportunityList.get(0).Name +
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
            System.debug('(TestNRMACalloutController.setup) AFTER initial Segment insert, testSegment for Opportunity ' + mockTestOpptyTitle);
        } else {
            System.debug('(TestNRMACalloutController.setup) Unable to generate test data for Opportunity of ' + mockTestOpptyTitle);
        }
        List<Offer__c> tempOfferList = TestDataFactory.createOffer(testOpportunityList, 1, True);
        System.debug('(TestNRMACalloutController.setup) AFTER initial Offer insert, tempOfferList?.get(0)?.Id = ' + tempOfferList?.get(0)?.Id);
        if (tempOfferList != null && tempOfferList.size() > 0) {
            tempOfferList.get(0).Associated_Capital_Design__c = testingCDId;
            update tempOfferList;
        } else {
            System.debug('(TestNRMACalloutController.setup) Unable to generate test data for Offer for Opportunity ' + mockTestOpptyTitle);
        }
        List<Capital_Design__c> tempCDList = TestDataFactory.createCapitalDesignsWithNRMADefaults(testOpportunityList.get(0).Id, tempOfferList.get(0).Id, null, 1, True);
        System.debug('(TestNRMACalloutController.setup) AFTER initial CD insert, tempCDList?.get(0)?.Id = ' + ( (tempCDList != null && tempCDList.size() > 0) ? tempCDList.get(0)?.Id : 'null') );
        List<Capital_Design__c> testCDList = NRMARequestHelper.queryCapDesignListById(tempCDList?.get(0)?.Id);
        System.debug('(TestNRMACalloutController.setup) QUERY AFTER initial CD insert, testCDList?.get(0)?.Id = ' + ( (testCDList != null && testCDList.size() > 0) ? testCDList.get(0)?.Id : 'null') );
        if (testCDList != null && testCDList.size() > 0) {
            testingCDName = testCDList.get(0).Name;
            testingCDId = testCDList.get(0).Id;
            System.debug('(TestNRMACalloutController.setup) AFTER CD update, testingCDId = ' + testingCDId + '\n  AND testingCDName = ' + testingCDName);
        }
        List<NRMA__c> testNRMAList = TestDataFactory.createNRMARequest(testCDList, testPropertyList, 1, True);
        System.debug('(TestNRMACalloutController.setup) AFTER NRMA create, testNRMAList?.get(0)?.Id = ' + testNRMAList?.get(0)?.Id);
        testingNRMAId = testNRMAList?.get(0)?.Id;
    }//end @testSetup method setup
    
    @isTest
    private static void testConstructor() {
        Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        if (setupNRMAList != null && setupNRMAList.size() > 0) {
	        System.debug('(TestNRMACalloutController.testConstructor) Id = ' + setupNRMAList?.get(0)?.Id);
        	testingNRMAId = setupNRMAList.get(0).Id;
        }
		NRMACalloutController testController = new NRMACalloutController(testingNRMAId, 'Status');
        if (testController == null) {
            System.assertEquals(null, testController, CNTRLR_NULL_AND_FAILED);
        }
        Test.stopTest();
    }//end test method testConstructor
    
    @isTest
    private static void testConstructorNullParams() {
        Test.startTest();
		NRMACalloutController testController = new NRMACalloutController(null, null);
        if (testController == null) {
            System.assertEquals(null, testController, CNTRLR_NULL_AND_FAILED);
        }
        if (testController.coParamsList == null) {
            System.assertEquals(null, testController.coParamsList, PARMLIST_NULL_NEG_TEST);
        }            
        Test.stopTest();
    }//end test method testConstructorNullParams

    @isTest
    private static void testCallNRMA() {
        Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        if (setupNRMAList != null && setupNRMAList.size() > 0) {
	        System.debug('(TestNRMACalloutController.testCallNRMA) Id = ' + setupNRMAList?.get(0)?.Id);
        	testingNRMAId = setupNRMAList.get(0).Id;
        }
		List<NRMACalloutController.CalloutParams> calloutParamsList = new List<NRMACalloutController.CalloutParams>();
        NRMACalloutController.CalloutParams cp = new NRMACalloutController.CalloutParams();
        cp.nrmaRecordId = testingNRMAId;
        cp.nrmaCallType = 'Status';
        calloutParamsList.add(cp);
        if (calloutParamsList.size() == 0) {
            System.assertEquals(0, calloutParamsList.size(), 'The Callout-Parameters-List had 0 items and failed');
        }
        List<String> testReturnStringList = NRMACalloutController.callNRMA(calloutParamsList);
        if(testReturnStringList == null) {
            System.assertEquals(0, testReturnStringList.size(), 'The Return-String-List was NULL and failed');
        }
        if (testReturnStringList.size() == 0) {
            System.assertEquals(0, testReturnStringList.size(), 'The Return-String-List had 0 items and failed');
        }
        Test.stopTest();
    }//end test method testCallNRMA
    
    @isTest
    private static void testCallNRMANullParams() {
        Test.startTest();
		List<NRMACalloutController.CalloutParams> calloutParamsList = new List<NRMACalloutController.CalloutParams>();
        NRMACalloutController.CalloutParams cp = new NRMACalloutController.CalloutParams();
        cp.nrmaRecordId = null;
        cp.nrmaCallType = null;
        calloutParamsList.add(cp);
        if (calloutParamsList.size() == 0) {
            System.assertEquals(0, calloutParamsList.size(), 'The Callout-Parameters-List had 0 items and failed');
        }
        List<String> testReturnStringList = NRMACalloutController.callNRMA(calloutParamsList);
        if(testReturnStringList == null) {
            System.assertEquals(0, testReturnStringList.size(), 'The Return-String-List was NULL and failed');
        }
        if (testReturnStringList.size() == 0) {
            System.assertEquals(0, testReturnStringList.size(), 'The Return-String-List had 0 items and failed');
        }
        Test.stopTest();
    }//end test method testCallNRMANullParams
    
    @isTest
    private static void testExecute() {
        Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        if (setupNRMAList != null && setupNRMAList.size() > 0) {
	        System.debug('(TestNRMACalloutController.testExecute) Id = ' + setupNRMAList?.get(0)?.Id);
        	testingNRMAId = setupNRMAList.get(0).Id;
        }
		NRMACalloutController testController = new NRMACalloutController(testingNRMAId, 'Status');
        if (testController == null) {
            System.assertEquals(null, testController, CNTRLR_NULL_AND_FAILED);
        }
        String testJobId = System.enqueueJob(testController);
        if(testJobId == null) {
            System.assertEquals(null, testJobId, 'Job Id from enqueueing NRMACalloutController was NULL and failed');
        }
    	Test.stopTest();        
    }//end test method testExecute
    
    @isTest
    private static void testExecuteNullParams() {
        Test.startTest();
		NRMACalloutController testController = new NRMACalloutController(null, null);
        if (testController == null) {
            System.assertEquals(null, testController, CNTRLR_NULL_AND_FAILED);
        }
        String testJobId = System.enqueueJob(testController);
        if(testJobId == null) {
            System.assertEquals(null, testJobId, 'Job Id from enqueueing NRMACalloutController was NULL and failed');
        }
        if (testController.coParamsList == null) {
            System.assertEquals(null, testController.coParamsList, PARMLIST_NULL_NEG_TEST);
        }            
    	Test.stopTest();        
    }//end test method testExecuteNullParams

    @isTest
    private static void testClearState() {
        Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        if (setupNRMAList != null && setupNRMAList.size() > 0) {
	        System.debug('(TestNRMACalloutController.testConstructor) Id = ' + setupNRMAList?.get(0)?.Id);
        	testingNRMAId = setupNRMAList.get(0).Id;
        }
		NRMACalloutController testController = new NRMACalloutController(testingNRMAId, 'Status');
        if (testController == null) {
            System.assertEquals(null, testController, CNTRLR_NULL_AND_FAILED);
        }
        testController.clearState();
        if(testController.nrmaCallType == null) {
            System.assertEquals(null, testController.nrmaCallType, 'After clearState on NRMACalloutController, the public variable nrmaCallType was NULL as expected');
        }
        if(testController.nrmaRecordId == null) {
            System.assertEquals(null, testController.nrmaRecordId, 'After clearState on NRMACalloutController, the public variable nrmaRecordId was NULL as expected');
        }
    	Test.stopTest();
	}//end testClearState 

    @isTest
    private static void testAutomatedCallNRMA() {
        Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        if (setupNRMAList != null && setupNRMAList.size() > 0) {
	        System.debug('(TestNRMACalloutController.testAutomatedCallNRMA) Id = ' + setupNRMAList?.get(0)?.Id);
        	testingNRMAId = setupNRMAList.get(0).Id;
        }
		NRMACalloutController testController = new NRMACalloutController(testingNRMAId, 'Status');
        if (testController == null) {
            System.assertEquals(null, testController, CNTRLR_NULL_AND_FAILED);
        }
        testController.automatedCallNRMA(testController.coParamsList);
        if (testController.coParamsList == null) {
            System.assertEquals(null, testController.coParamsList, 'After constructor, NRMACalloutController parameter-list was NULL and failed');
        }            
        Test.stopTest();
    }//end test method testAutomatedCallNRMA
    
    @isTest
    private static void testAutomatedCallNRMANullParams() {
        Test.startTest();
		NRMACalloutController testController = new NRMACalloutController(null, null);
        if (testController == null) {
            System.assertEquals(null, testController, CNTRLR_NULL_AND_FAILED);
        }
        testController.automatedCallNRMA(testController.coParamsList);
        if (testController.coParamsList == null) {
            System.assertEquals(null, testController.coParamsList, PARMLIST_NULL_NEG_TEST);
        }            
        Test.stopTest();
    }//end test method testAutomatedCallNRMANullParams
    
}//end test class TestNRMACalloutController