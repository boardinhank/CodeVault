@IsTest
public class TestNRMARequestHelper {
	private static final String DEFAULT_EMPTY = ' ';
    private static final String CONST_JSON_NULL_NEG_TEST = 'Constructed-JSON returned was NULL as expected in this negative-test';
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
            System.debug('(TestNRMARequestHelper.setup) AFTER initial insert, testNWCList.get(0).Name = ' + testNWCList.get(0).Name +
                         '\n  AND testNWCList.get(0).Wire_Center_Segmentation__c = ' + testNWCList.get(0).Wire_Center_Segmentation__c);
            testNWCList.get(0).Wire_Center_Segmentation__c = 'WEAK';
            update testNWCList;
        } else {
            System.debug('(TestNRMARequestHelper.setup) Unable to generate test data for NWC of ' + mockTestNWCCLLI);
        }
        List<Property__c> testPropertyList = TestDataFactory.createProperties(mockTestPptyAddrStreet, mockTestPptyAddrCity, 
                                                                                  mockTestPptyAddrState, mockTestPptyCountyCode, 
                                                                                  mockTestPptyStateCode, mockTestPptyAPN, 
                                                                                  mockTestPptyLat, mockTestPptyLong, 1, True);
        if (testPropertyList != null && testPropertyList.size() > 0) {
            System.debug('(TestNRMARequestHelper.setup) AFTER initial insert, testPropertyList.get(0).Name = ' + testPropertyList.get(0).Name +
                         '\n  AND testPropertyList.get(0).Id = ' + testPropertyList.get(0).Id);
            testPropertyList.get(0).Name = mockTestPptyName;
            testPropertyList.get(0).Primary_Address_Zip__c = mockTestPptyAddrZip;
            testPropertyList.get(0).Property_Type__c = mockTestPptyType;
            testPropertyList.get(0).Property_Structure__c = mockTestPptyStruct;
            testPropertyList.get(0).Property_Total_Units__c = mockTestPptyTtlUnits;
            testPropertyList.get(0).Network_Wire_Center__c = testNWCList.get(0).Id;                
            update testPropertyList;
        } else {
            System.debug('(TestNRMARequestHelper.setup) Unable to generate test data for Property of Address: ' + 
                         '\n ' + mockTestPptyAddrStreet + 
                         '\n ' + mockTestPptyAddrCity + 
                         ', ' + mockTestPptyAddrState);
        }
        List<Opportunity> testOpportunityList = TestDataFactory.createOpportunities(mockTestOpptyTitle, mockTestOpptyDevStatus, 
                                                                                            mockTestOpptyStageName, mockTestOpptyCloseDate, 
                                                                                            testPropertyList?.get(0)?.Id, 1, True);
        if (testOpportunityList != null && testOpportunityList.size() > 0) {
            System.debug('(TestNRMARequestHelper.setup) AFTER initial insert, testOpportunityList.get(0).Name = ' + testOpportunityList.get(0).Name +
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
            System.debug('(TestNRMARequestHelper.setup) AFTER initial Segment insert, testSegment for Opportunity ' + mockTestOpptyTitle);
        } else {
            System.debug('(TestNRMARequestHelper.setup) Unable to generate test data for Opportunity of ' + mockTestOpptyTitle);
        }
        List<Offer__c> tempOfferList = TestDataFactory.createOffer(testOpportunityList, 1, True);
        System.debug('(TestNRMARequestHelper.setup) AFTER initial Offer insert, tempOfferList?.get(0)?.Id = ' + tempOfferList?.get(0)?.Id);
        if (tempOfferList != null && tempOfferList.size() > 0) {
            tempOfferList.get(0).Associated_Capital_Design__c = testingCDId;
            update tempOfferList;
        } else {
            System.debug('(TestNRMARequestHelper.setup) Unable to generate test data for Offer for Opportunity ' + mockTestOpptyTitle);
        }
        List<Capital_Design__c> tempCDList = TestDataFactory.createCapitalDesignsWithNRMADefaults(testOpportunityList.get(0).Id, tempOfferList.get(0).Id, null, 1, True);
        System.debug('(TestNRMARequestHelper.setup) AFTER initial CD insert, tempCDList?.get(0)?.Id = ' + ( (tempCDList != null && tempCDList.size() > 0) ? tempCDList.get(0)?.Id : 'null') );
        List<Capital_Design__c> testCDList = NRMARequestHelper.queryCapDesignListById(tempCDList?.get(0)?.Id);
        System.debug('(TestNRMARequestHelper.setup) QUERY AFTER initial CD insert, testCDList?.get(0)?.Id = ' + ( (testCDList != null && testCDList.size() > 0) ? testCDList.get(0)?.Id : 'null') );
        if (testCDList != null && testCDList.size() > 0) {
            testingCDName = testCDList.get(0).Name;
            testingCDId = testCDList.get(0).Id;
            System.debug('(TestNRMARequestHelper.setup) AFTER CD update, testingCDId = ' + testingCDId +
                         '\n  AND testingCDName = ' + testingCDName);
        }
        List<NRMA__c> testNRMAList = TestDataFactory.createNRMARequest(testCDList, testPropertyList, 1, True);
        System.debug('(TestNRMARequestHelper.setup) AFTER NRMA create, testNRMAList?.get(0)?.Id = ' + testNRMAList?.get(0)?.Id);
        testingNRMAId = testNRMAList?.get(0)?.Id; 
    }//end @testSetup method setup

	@isTest    
    private static void testQueryNRMARecordListById() {
        Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMARequestHelper.testQueryNRMARecordListById) setupNRMAList == null??? ' + (setupNRMAList == null) +
                     			'\n setupNRMAList.size() = ' + setupNRMAList?.size());
        if (setupNRMAList != null && setupNRMAList.size() > 0) {
	        System.debug('(TestNRMARequestHelper.testQueryNRMARecordListById) setupNRMAList.get(0) == null??? ' + (setupNRMAList?.get(0) == null) +
                    			'\n Id = ' + setupNRMAList?.get(0)?.Id);
        	testingNRMAId = setupNRMAList.get(0).Id;
        }
        List<NRMA__c> testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, 'NRMA-List returned from query was NULL and failed');
        }
        Test.stopTest();
    }//end test method testQueryNRMARecordListById

	@isTest    
    private static void testQueryNRMARecordListByIdNull() {
        Test.startTest();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(null);
        } catch(Exception testX) {
            System.debug('(TestNRMARequestHelper.testQueryNRMARecordListByIdNull)  EXCEPTION! \n: ' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, 'NRMA-List returned from query was NULL as expected in this negative-test');
        }
        Test.stopTest();
    }//end test method testQueryNRMARecordListByIdNull

	@isTest    
    private static void testQueryNRMARecordListByIdBadId() {
        Test.startTest();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        try {
            testNRMAList = NRMARequestHelper.queryNRMARecordListById(null);
        } catch(Exception testX) {
            System.debug('(TestNRMARequestHelper.testQueryNRMARecordListByBadId)    EXCEPTION! \n: ' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, 'NRMA-List returned from query was NULL as expected in this negative-test');
        }
        Test.stopTest();
    }//end test method testQueryNRMARecordListByIdBadId
    
    @isTest
    private static void testConstructJSONFromNRMAObj() {
        Test.startTest();
        List<NRMA__c> setupNRMAList = [SELECT Id, Name FROM NRMA__c];
        System.debug('(TestNRMARequestHelper.testConstructJSONFromNRMAObj) setupNRMAList == null??? ' + (setupNRMAList == null) +
                     			'\n setupNRMAList.size() = ' + setupNRMAList?.size());
        if (setupNRMAList != null && setupNRMAList.size() > 0) {
	        System.debug('(TestNRMARequestHelper.testConstructJSONFromNRMAObj) setupNRMAList.get(0) == null??? ' + (setupNRMAList?.get(0) == null) +
                    			'\n Id = ' + setupNRMAList?.get(0)?.Id);
        	testingNRMAId = setupNRMAList.get(0).Id;
        }
        List<NRMA__c> testNRMAList = NRMARequestHelper.queryNRMARecordListById(testingNRMAId);
        if (testNRMAList == null) {
            System.assertEquals(null, testNRMAList, 'NRMA-List returned from query was NULL and failed');
        }
        if(testNRMAList?.size() == 0) {
            System.assertEquals(0, testNRMAList?.size(), 'NRMA-List returned from query had 0 records and failed');
        }
        String testConstructedJSON = NRMARequestHelper.constructJSONFromNRMAObj(testNRMAList);
        if(testConstructedJSON == null) {
            System.assertEquals(null, testConstructedJSON, 'Constructed-JSON returned was NULL and failed');
        }
        Test.stopTest();
    }//end test method testConstructJSONFromNRMAObj
    
    @isTest
    private static void testConstructJSONFromNRMAObjEmptyList() {
        Test.startTest();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        String testConstructedJSON = null;
        try {
	        testConstructedJSON = NRMARequestHelper.constructJSONFromNRMAObj(testNRMAList);
        } catch(Exception testX) {
            System.debug('(TestNRMARequestHelper.testConstructJSONFromNRMAObjEmptyList)    EXCEPTION! \n: ' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if(testConstructedJSON == null) {
            System.assertEquals(null, testConstructedJSON, CONST_JSON_NULL_NEG_TEST);
        }
        Test.stopTest();
    }//end test method testConstructJSONFromNRMAObjEmptyList
    
    @isTest
    private static void testConstructJSONFromNRMAObjNullObjInList() {
        Test.startTest();
        List<NRMA__c> testNRMAList = new List<NRMA__c>();
        NRMA__c testNR = null;
        testNRMAList.add(testNR);
        String testConstructedJSON = null;
        try {
	        testConstructedJSON = NRMARequestHelper.constructJSONFromNRMAObj(testNRMAList);
        } catch(Exception testX) {
            System.debug('(TestNRMARequestHelper.testConstructJSONFromNRMAObjNullObjInList)    EXCEPTION! \n: ' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if(testConstructedJSON == null) {
            System.assertEquals(null, testConstructedJSON, CONST_JSON_NULL_NEG_TEST);
        }
        Test.stopTest();
    }//end test method testConstructJSONFromNRMAObjNullObjInList
    
    @isTest
    private static void testConstructJSONFromNRMAObjNullList() {
        Test.startTest();  
        List<NRMA__c> testNRMAList = null;
        String testConstructedJSON = null;
        try {
	        testConstructedJSON = NRMARequestHelper.constructJSONFromNRMAObj(testNRMAList);
        } catch(Exception testX) {
            System.debug('(TestNRMARequestHelper.testConstructJSONFromNRMAObjNullList)    EXCEPTION! \n: ' + testX.getTypeName() + '\n' + testX.getMessage() + '\n' + testX.getLineNumber() + '\n' + testX.getStackTraceString());
        }
        if(testConstructedJSON == null) {
            System.assertEquals(null, testConstructedJSON, CONST_JSON_NULL_NEG_TEST);
        }
        Test.stopTest();
    }//end test method testConstructJSONFromNRMAObjNullList

}//end test class TestNRMARequestHelper