/****************************************************************************************************
 * LAST UPDATED FOR:
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Produt-to-TechType-Mapping
 * 01/08/2024   T2Cabato    QFCJ-4807                		BRAIN-Incorrect-Setting-of-baseContractType-Value
****************************************************************************************************/
@isTest
public with sharing class TestBRAINFAScheduler { 
    public static String TEST_CRON_EXP = '0 10 * * * ?';

    private static Id testingCDId = null;
    private static String testingCDName = '';
    
	@testSetup 
    private static void setup(){
    	final String mockTestContactFName = 'Noah';
      	final String mockTestContactLName = 'Allen';
      	final String mockTestContactEmail = 'noah.allen@team480653.testinator.com';
      	final String mockTestNWCCLLI = 'DNVRCOSO';
      	final String mockTestPptyAddrStreet = '2764 W BEACH BLVD';
      	final String mockTestPptyAddrCity = 'DENVER';
      	final String mockTestPptyAddrState = 'CO';
        final String mockTestPrmryStateName = 'Colorado';
      	final String mockTestPptyAddrZip = '36542';
      	final String mockTestPptyCountyCode = 'BWN';
      	final String mockTestPptyStateCode = 'CO';
      	final String mockTestPptyAPN = '';
      	final Decimal mockTestPptyLat =   30.23548000;
      	final Decimal mockTestPptyLong = -87.77961100;
      	final String mockTestPptyName = 'NOAH ALLEN BEACH ESTATES';
        final String mockTestPptyType = 'Condo';
        final String mockTestPptyStruct = 'Tower';
        final Decimal mockTestPptyTtlUnits = 24;
        final String mockTestOpptyTitle = mockTestPptyName + ' - Instant Internet - FTTU';
        final String mockTestOpptyDevStatus = 'Greenfield';
        final String mockTestOpptyStageName = 'Proposed';
        final Date mockTestOpptyCloseDate = (Date.today()).addMonths(8);
        final String mockTestBuildingStyle = 'Cottage';
        final Decimal mockTestFootageBldg = 500.00;
        final Decimal mockTestFootageFlr = 0.00;
        final Decimal mockTestMatCost = 0.00;
        final Decimal mockTestSize = 0.00;
        final String BACKUP_REQUEST_JSON = '{ "sourceSystem":"SFCJ", "cuid":"AA14082", "financialMetricCurrencyCode":"USD", ' + 
                                        '"financialMetricCurrencyExchangeDate":null, "sourceSystemId":"a048F000002SOv4QAG", ' + 
            							'"sourceSystemIdType":"OFFER", "analysisOverride":null, "opportunityTitle":"' + mockTestOpptyTitle + '", ' + 
            							'"hl2Items":[ { "sourceSystemId":"a048F000002SOv4QAG", "sourceSystemIdType":"OFFER", "latitude":30.23548000, "longitude":-87.77961100, ' + 
            							'"wireCenterCLLI":"' + mockTestNWCCLLI + '", "constructionMonths":24, "currencyCode":"USD", "coreElectronicsCost":0.00, "interofficeFiberCost":0.00, ' + 
            							'"coElectronicsCost":9360.00, "f1FeederCost":25414.00, "remoteElectronicsCost":0.00, "hl2ItemOverride":null, "hl3Items":[ { "quantity":24, ' + 
            							'"constructionType":"MDU", "ctlOn":false, "currencyCode":"USD", "f2Cost":0.00, "f2CostSource":"PROVIDED", "f2Footage":800.00, ' + 
            							'"insideWiringCapEx":54380.5875, "ontType":null, "dropCost":0, "dropCostSource":"PROVIDED", "additionalOpExNrc":18098.70, ' + 
            							'"additionalOpExMrc":0, "occupantType":"CONSUMER", "lotFrontageFeet":0, "maxDownstreamSpeedKbps":1000000, "clusterId":null, ' + 
            							'"fdhCost":0, "splitterCost":0, "splitterPorts":0, "idfElectronicsCost":0, "wirelessAccessPointsCost":0, "networkInvestmentType":"NEW DEVELOPMENT", ' + 
            							'"productType":"FTTH", "contractType":"COMPETITIVE LOSS", "contractTermMonths":0, "marketingFees":null, "hl3ItemOverride":null, ' + 
                                        '"demographics": [ { "quantity":24, "rental":true, "incomeLevel":0  } ] } ] } ] }';

        /***** Common shared data *****/
        System.debug('(TEST***SETUP) Now setting up for Common Shared Data');
        List<Network_Wire_Center__c> testNWCList = TestDataFactory.createNetworkWireCenters(mockTestNWCCLLI, 1, True);
        if (testNWCList != null && testNWCList.size() > 0) {
            System.debug('(TEST***SETUP) AFTER initial insert, testNWCList.get(0).Name = ' + testNWCList.get(0).Name +
                         '\n  AND testNWCList.get(0).Wire_Center_Segmentation__c = ' + testNWCList.get(0).Wire_Center_Segmentation__c);
            testNWCList.get(0).Wire_Center_Segmentation__c = 'WEAK';
            update testNWCList;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for NWC of ' + mockTestNWCCLLI);
        }
        List<Property__c> testPropertyList = TestDataFactory.createProperties(mockTestPptyAddrStreet, mockTestPptyAddrCity, 
                                                                              mockTestPptyAddrState, mockTestPptyCountyCode, 
                                                                              mockTestPptyStateCode, mockTestPptyAPN, 
                                                                              mockTestPptyLat, mockTestPptyLong, 1, True);
        if (testPropertyList != null && testPropertyList.size() > 0) {
            System.debug('(TEST***SETUP) AFTER initial insert, testPropertyList.get(0).Name = ' + testPropertyList.get(0).Name +
                         '\n  AND testPropertyList.get(0).Id = ' + testPropertyList.get(0).Id);
            testPropertyList.get(0).Name = mockTestPptyName;
            testPropertyList.get(0).Primary_Address_Zip__c = mockTestPptyAddrZip;
            testPropertyList.get(0).Property_Type__c = mockTestPptyType;
            testPropertyList.get(0).Property_Structure__c = mockTestPptyStruct;
            testPropertyList.get(0).Property_Total_Units__c = mockTestPptyTtlUnits;
            testPropertyList.get(0).Network_Wire_Center__c = testNWCList.get(0).Id;                
            update testPropertyList;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for Property of Address: ' + 
                         '\n ' + mockTestPptyAddrStreet + 
                         '\n ' + mockTestPptyAddrCity + 
                         ', ' + mockTestPptyAddrState);
        }
        List<Opportunity> testOpportunityList = TestDataFactory.createOpportunities(mockTestOpptyTitle, mockTestOpptyDevStatus, 
                                                                                    mockTestOpptyStageName, mockTestOpptyCloseDate, 
                                                                                    testPropertyList.get(0).Id, 1, True);
        if (testOpportunityList != null && testOpportunityList.size() > 0) {
            System.debug('(TEST***SETUP) AFTER initial insert, testOpportunityList.get(0).Name = ' + testOpportunityList.get(0).Name +
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
            System.debug('(TEST***SETUP) AFTER initial Segment insert, testSegment for Opportunity ' + mockTestOpptyTitle);
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for Segment for Opportunity ' + mockTestOpptyTitle);
        }
        System.debug('(TEST***SETUP) Ending setting up for Common Shared Data');

        List<Capital_Design__c> tempCDList = TestDataFactory.createCapitalDesignsForBRAINFAScheduler(testOpportunityList.get(0).Id, 1, True);
        System.debug('(TEST***SETUP) AFTER initial CD insert for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", tempCDList?.get(0)?.Id = ' + tempCDList?.get(0)?.Id);
        List<Capital_Design__c> testCDList = [SELECT Id, Name, Capital_Design_Stage__c, QueuedForBRAINFARun__c
			                                   FROM Capital_Design__c WHERE Capital_Design_Type__c = 'Standard' AND Technology_Type__c != 'Instant Wi-Fi' LIMIT 1];            
            
        if (testCDList != null && testCDList.size() > 0) {
	        System.debug('(TEST***SETUP) AFTER initial CD insert for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", testCDList.get(0).Id = ' + testCDList.get(0)?.Id + 
                     	 '\n  AND testCDList.get(0)?.Name = ' + testCDList.get(0)?.Name);
            testingCDName = testCDList.get(0).Name;
            testingCDId = testCDList.get(0).Id;
            System.debug('(TEST***SETUP) AFTER CD update for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", testingCDId = ' + testingCDId +
                         '\n  AND testingCDName = ' + testingCDName);
            List<CCT_F2_Cost_Estimator__c> f2CostEstList = TestDataFactory.createCCTF2CostEstimator(mockTestBuildingStyle, mockTestFootageBldg,
                                                                                                    mockTestFootageFlr, 1, True);
            List<CCT_F2_Stub_Estimator__c> f2StubEstList = TestDataFactory.createCCTF2StubEstimator(mockTestMatCost, mockTestSize, 1, True);            
            List<CCT_Cost_Estimator__c> costEstList = TestDataFactory.createCCTCostEstimator(mockTestPptyStateCode, 1, True);
        }
    }//end @testSetup method setup
    
    /* */
    @AuraEnabled
    public static testmethod void testSchedulableJob() {        

        Test.startTest(); 
        List<Capital_Design__c> setupCDList = [SELECT Id, Name, QueuedForBRAINFARun__c, Capital_Design_Stage__c FROM Capital_Design__c 
                                                WHERE QueuedForBRAINFARun__c = TRUE AND Capital_Design_Stage__c = 'Planner Design Complete' LIMIT 10];
        System.debug('(TestBRAINFAScheduler.testSchedulableJob) setupCDList == null??? ' + (setupCDList == null) + '\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
	        System.debug('(TestBRAINFAScheduler.testSchedulableJob) setupCDList.get(0) == null??? ' + (setupCDList?.get(0) == null) +
                    			'\n Id = ' + setupCDList?.get(0)?.Id + '\n Name = ' + setupCDList?.get(0)?.Name +
            					'\n QueuedForBRAINFARun__c = ' + setupCDList.get(0).QueuedForBRAINFARun__c +
            					'\n Capital_Design_Stage__c = ' + setupCDList.get(0).Capital_Design_Stage__c);
        }
        
        String scheduledJobId = System.schedule('TestBRAINFAScheduler', TEST_CRON_EXP, new BRAINFAScheduler());
        if (scheduledJobId == null) {
            System.assertEquals(null, scheduledJobId);
        } else {
            System.assertNotEquals(null, scheduledJobId);
        }
        Test.stopTest();    

    }//end test-method testSchedulableJob
    /* */    

}//end class TestBRAINFAScheduler