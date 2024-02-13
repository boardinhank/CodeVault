/****************************************************************************************************
 * LAST UPDATED FOR:
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Produt-to-TechType-Mapping
 * 01/08/2024   T2Cabato    QFCJ-4807                		BRAIN-Incorrect-Setting-of-baseContractType-Value
****************************************************************************************************/
@isTest
public class TestBRAINFARequestController {

    //constants to be used in creating test data
    private static final String DEFAULT_EMPTY = ' ';
    private static final Id DEFAULT_NULL_ID = null;
    private static final String BAD_CD_NAME = 'CD-#######';
    private static final String DEFAULT_STATE_NM = 'Colorado';
    private static final String DEFAULT_STATE_CD = 'CO';
    private static String defaultRequestJSON = null;
    
    //variables that hold values from testSetup data that was created
    private static Id testingIWFCDId = null;
    private static String testingIWFCDName = '';
    private static String testingIWFSrcSystemId = '';
    private static Capital_Design__c testingIWFCapDesObj;
    private static Id testingIWFCDIdInvalid = null;
    private static String testingIWFCDNameInvalid = '';
    private static String testingIWFSrcSystemIdInvalid = '';
    private static Capital_Design__c testingIWFCapDesObjInvalid;
    private static Id testingIWFOfferId = null;
    private static String testingIWFOfferName = null;
    private static Id testingIWFBACTId = null;
    private static String testingIWFBACTName = '';
    private static Id testingIWFFARequestId = null;
    private static String testingIWFFARequestName = '';
    private static String testingIWFFARequestJSON = null;
    private static Id testingIWFFAResponseId = null;
    private static String testingIWFFAResponseName = '';
    private static Id testingIWFBACTIdForOffer = null;
    private static String testingIWFBACTNameForOffer = '';
    private static Id testingIWFFARequestIdForOffer = null;
    private static String testingIWFFARequestNameForOffer = '';
    private static String testingIWFFARequestJSONForOffer = null;
    private static Id testingIWFFAResponseIdForOffer = null;
    private static String testingIWFFAResponseNameForOffer = '';
    private static Id testingNMACDId = null;
    private static String testingNMACDName = '';
    private static String testingNMASrcSystemId = '';
    private static Capital_Design__c testingNMACapDesObj;
    private static Id testingBACTIdForNMA = null;
    private static String testingBACTNameForNMA = '';
    private static Id testingFARequestIdForNMA = null;
    private static String testingFARequestNameForNMA = '';
    private static String testingFARequestJSONForNMA = null;
    private static Id testingFAResponseIdForNMA = null;
    private static String testingFAResponseNameForNMA = '';
    private static Id testingCDId = null;
    private static String testingCDName = '';
    private static String testingSrcSystemId = '';
    private static String testingCUID = '';
    private static Id testingOpptyId = null;
    private static String testingOpptyTitle = '';
    private static Id testingOfferId = null;
    private static String testingOfferName = null;
    private static Id testingBACTId = null;
    private static String testingBACTName = '';
    private static Id testingFARequestId = null;
    private static String testingFARequestName = '';
    private static Id testingFAResponseId = null;
    private static String testingFAResponseName = null;
    private static String testingFAResponseJSON = null;
    private static Id testingBACTIdForOffer = null;
    private static String testingBACTNameForOffer = '';
    private static Id testingFARequestIdForOffer = null;
    private static String testingFARequestNameForOffer = '';
    private static Id testingFAResponseIdForOffer = null;
    private static String testingFAResponseNameForOffer = null;
    private static String testingFAResponseJSONForOffer = null;
    private static Id testingHL1EvalId = null;
    private static String testingHL1EvalName = null;
    private static Id testingBCostId = null;
    private static Id testingFinMetricId = null;
    private static String testingFinMetricName = null;
    private static Id testingIncStmtMetricId = null;
    private static String testingIncStmtMetricName = null;
    private static Id testingCFMetricId = null;
    private static String testingCFMetricName = null;
    private static Id testingGREvalId = null;
    private static String testingGREvalName = null;
    private static String testingFARequestJSON = null;
    
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
        final Decimal mockTestPptyTtlUnits = 250;
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
        defaultRequestJSON = BACKUP_REQUEST_JSON;
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
                                                                              mockTestPptyLat, mockTestPptyLong, 26, False);
        if (testPropertyList != null && testPropertyList.size() > 0) {
	        for (Integer p = 0; p < testPropertyList.size(); p++) {
                testPropertyList.get(p).Name = mockTestPptyName;
                testPropertyList.get(p).Primary_Address_Zip__c = mockTestPptyAddrZip;
                testPropertyList.get(p).Property_Type__c = mockTestPptyType;
                testPropertyList.get(p).Property_Structure__c = mockTestPptyStruct;
                testPropertyList.get(p).Property_Total_Units__c = mockTestPptyTtlUnits;
                testPropertyList.get(p).Network_Wire_Center__c = testNWCList.get(0).Id;                
            }
            upsert testPropertyList;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for Property of Address: ' + 
                         '\n ' + mockTestPptyAddrStreet + 
                         '\n ' + mockTestPptyAddrCity + 
                         ', ' + mockTestPptyAddrState);
        }
        for (Property__c property : testPropertyList) {
                System.debug('(TEST***SETUP) AFTER upsert, property.Name = ' + property.Name + '\n  AND property.Id = ' + property.Id);
        }
        List<Opportunity> testOpportunityList = new List<Opportunity>();
        for (Integer p = 0; p < testPropertyList.size(); p++) {
            String tempDevStatus = 'Greenfield';
            if (Math.mod(p,2)==1) {
                tempDevStatus = 'Brownfield';                
            } 
			List<Opportunity> tempOpptyList = TestDataFactory.createOpportunities(mockTestOpptyTitle, tempDevStatus, 
                                                                                    mockTestOpptyStageName, mockTestOpptyCloseDate, 
                                                                                    testPropertyList.get(p).Id, 1, False);
            testOpportunityList.add(tempOpptyList?.get(0));
        }
        upsert testOpportunityList;
        System.debug('(TEST***SETUP) AFTER initial upsert, testOpportunityList is NULL? ' + testOpportunityList==null +
                             '\n  AND testOpportunityList?.size() = ' + testOpportunityList?.size());
        if (testOpportunityList != null && testOpportunityList.size() > 0) {
            for (Integer p = 0; p < testOpportunityList.size(); p++) {
                System.debug('(TEST***SETUP) AFTER initial upsert, testOpportunityList.get('+p+').Name = ' + testOpportunityList.get(p).Name +
                             '\n  AND testOpportunityList.get('+p+').Id = ' + testOpportunityList.get(p).Id);
            }
            List<Segment__c> segmentList = TestdataFactory.createSegment(testOpportunityList, testPropertyList, testPropertyList.size(), False);
            for (Integer s = 0; s < segmentList.size(); s++) {
                segmentList.get(s).Segment_Total_Units__c = mockTestPptyTtlUnits;
                segmentList.get(s).Segment_Use__c = 'Rental';
				segmentList.get(s).Segment_Status__c = 'Active Opportunity';
                segmentList.get(s).Inventory_Reduction__c = 'No';
                segmentList.get(s).Contract_Lifecycle_Status__c = 'In Progress';
				segmentList.get(s).Segment_Inventory_Type__c = 'Unit Inventory Driver';
                if (Math.mod(s,5)==0) {
                    segmentList.get(s).Segment_Structure__c = 'SFH (Single Family Home)';
                } else if (Math.mod(s,5)==1) {
                    segmentList.get(s).Segment_Structure__c = 'Cottage';
                } else if (Math.mod(s,5)==2 || Math.mod(s,5)==3) {
                    segmentList.get(s).Segment_Structure__c = 'Tower';
                } else {
                    segmentList.get(s).Segment_Structure__c = 'Mixed';
                }
            }        
            upsert segmentList;
            System.debug('(TEST***SETUP) AFTER initial Segment upsert, testSegment for Opportunity ' + mockTestOpptyTitle);
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for Segment for Opportunity ' + mockTestOpptyTitle);
        }
        List<CCT_F2_Cost_Estimator__c> f2CostEstList = TestDataFactory.createCCTF2CostEstimator(mockTestBuildingStyle, mockTestFootageBldg, mockTestFootageFlr, 1, True);
        List<CCT_F2_Stub_Estimator__c> f2StubEstList = TestDataFactory.createCCTF2StubEstimator(mockTestMatCost, mockTestSize, 1, True);            
        List<CCT_Cost_Estimator__c> costEstList = TestDataFactory.createCCTCostEstimator(mockTestPptyStateCode, 1, True);
        System.debug('(TEST***SETUP) Ending setting up for Common Shared Data');
        
		/***** Non-Marketing Capital Designs *****/
        System.debug('(TEST***SETUP) Now setting up for "Non-Marketing" Capital Designs');
        List<BRAIN_API_Call_Tracker__c>	tempCallListForNMA = TestDataFactory.createBaseBrainAPICallTracker(1, True);
        System.debug('(TEST***SETUP) AFTER BACT create, tempCallListForNMA?.get(0)?.Id = ' + tempCallListForNMA?.get(0)?.Id);
        CapitalDesignTriggerHandler.TriggerDisabled = true;
    	List<Capital_Design__c> tempNMACDList = TestDataFactory.createNMACapitalDesignsWithBRAINDefaults(tempCallListForNMA?.get(0)?.Id, 1, True);
        CapitalDesignTriggerHandler.TriggerDisabled = false;
        System.debug('(TEST***SETUP) AFTER initial NMA-CD insert, tempNAMCDList?.get(0)?.Id = ' + tempNMACDList?.get(0)?.Id);
        List<Capital_Design__c> testNMACDList = [SELECT Id, Name, 
                                        OwnerId, 
                                        Offer__c, 
                                        Capital_Design_Stage__c,
                                        Primary_Address_State_Name__c,
                                        Property_Address_State__c,
                                        State_Name__c,
                                        BRAIN_API_Call_Tracker_Master__c, 
                                        Brain_ID__c,
                                        CapEx_Direct__c,
     									Cumulative_NPV__c,
                                        Discounted_Payback_months__c,
                                        EBITDA_Margin__c,
                                        Financial_Viability__c,
                                        IRR__c,
                                        Incremental_ATC_To_Meet_Guardrail__c,
                                        Simple_Payback_Months__c,
                                        X1st_Year_of_Positive_EBITDA__c,
                                        X1st_Year_of_Positive_FCF__c,
										Offer__r.Offer_Total_Units__c, 
                                        Offer__r.Offer_Type__c, 
                                        Offer__r.Other_Provider_Contract_Type__c, 
                                        Offer__r.Contract_Term__c,
                                        Offer__r.Data_Bounty_Amount__c, 
                                        Offer__r.Bulk_Data_Speed_Profile_DL_UL__c,
                                        Offer__r.Requested_Bulk_Data_Price__c,
                                        Offer__r.Opportunity__r.Id, 
                                        Offer__r.Contract__r.EndDate,
                                        Offer__r.Revenue_Share_Agent_Commission_Rate__c,
                                        Offer__r.Revenue_Share_MIN_Penetration_Rate__c,
                                        Offer__r.Revenue_Share_MAX_Penetration_Rate__c,
                                        Actual_Build_Out_Months__c,
                                        Core_Switch_Electronics__c,
                                        Transport_Interoffice_Fiber__c,
                                        CO_Electronics__c,
                                        Feeder_F1_Access_and_or_PON__c,
                                        Remote_Electronics__c,
                                        Total_Cottage_Rental_Units__c, 
                                        Total_Tower_Rental_Units__c, 
                                        Total_SFH_Rental_Units__c,
                                        Total_Cottage_Owner_Units__c, 
                                        Total_Tower_Owner_Units__c, 
                                        Total_SFH_Owner_Units__c, 
                                        Service_Delivery__c, 
                                        Distribution_F2__c, 
                                        F2_Footage_ft__c,
                                        Distribution_Structure_Conduit__c,
                                        Electronics_Shelf_UPS_Cost__c,
                                        F4_Inside_Wiring_SFH__c,
                                        Other_MDU_F4__c,
                                        for_SFU_Average_Lot_Size__c, 
                                        Network_Investment__c, 
                                        Technology_Type__c, 
                                        Service_Type__c,                     
                                        MDU_ONT_Drop__c,
                                        Door_Fee__c,
                                        Access_Type__c,
                                        F1_Feeder_Type__c,
                                        Cluster_ID__c,
                                        Cluster_Not_Available__c,
                                        Development_Status__c,
                                        Building_Style__c,
                                        ONT_Model__c,
                                        Occupant_Type__c,
                                        //The InstantWiFi-specific fields are listed together below 
                                        Access_Cost__c,
                                        IP_CapEx_Shared__c,
                                        IP_NetEx_Shared_MRC__c,
                                        Wireless_Access_Points_Cost__c,
                                        BCET_Wire_Center__c,
                                        One_Time_Additional_Expense__c,
                                        Recurring_Additional_Expenses_Monthly__c,
                                        //The NMA-specific fields are listed together below 
                                        Capital_Design_Type__c,
                                        Property_Name__c,
                                        Product__c,
                                        Planned_Build_Out_Years__c,
                                        Wire_Center_CLLI_Code__c,
                                        Latitude_NM__c,
                                        Longitude_NM__c,
                                        Service_Delivery_NM__c,
                                        Max_Downstream_Speed_NM__c,
                                        Total_Cottage_Rental_Units_NM__c, 
                                        Total_Tower_Rental_Units_NM__c, 
                                        Total_SFH_Rental_Units_NM__c,
                                        Total_Cottage_Owner_Units_NM__c, 
                                        Total_Tower_Owner_Units_NM__c, 
                                        Total_SFH_Owner_Units_NM__c
                                   FROM Capital_Design__c
                                  WHERE Capital_Design_Type__c = 'Non-Marketing' LIMIT 1];
        if (testNMACDList != null && testNMACDList.size() > 0) {
	        System.debug('(TEST***SETUP) AFTER initial NMA-CD insert, testNMACDList?.get(0)?.Id = ' + testNMACDList?.get(0)?.Id);
            testingNMACapDesObj = testNMACDList.get(0);
            testingNMACDName = testNMACDList.get(0).Name;
            testingNMACDId = testNMACDList.get(0).Id;
            testingNMASrcSystemId = testNMACDList.get(0).Id;
            System.debug('(TEST***SETUP) AFTER CD update, testingNMACDId = ' + testingNMACDId +
                         '\n  AND testingNMACDName = ' + testingNMACDName +
                         '\n  AND testingNMASrcSystemId = ' + testingNMASrcSystemId +
                         '\n  AND testingNMACapDesObj.Id = ' + testingNMACapDesObj.Id +
                         '\n  AND testingNMACapDesObj.Name = ' + testingNMACapDesObj.Name +
                         '\n  AND testingNMACapDesObj.Capital_Design_Type__c = ' + testingNMACapDesObj.Capital_Design_Type__c);
        }
        System.debug('(TEST***SETUP) testingNMACDName = ' + testingNMACDName);
        if (tempCallListForNMA != null && tempCallListForNMA.size() > 0) {            
	        System.debug('(TEST***SETUP) AFTER BACT create, tempCallListForNMA?.get(0)?.Name = ' + tempCallListForNMA?.get(0)?.Name +
                         '\n  AND tempCallListForNMA?.get(0)?.Id = ' + tempCallListForNMA?.get(0)?.Id);
            testingBACTIdForNMA = tempCallListForNMA.get(0).Id;
            testingBACTNameForNMA = tempCallListForNMA.get(0).Name;
            System.debug('(TEST***SETUP) AFTER BACT create, set testingBACTNameForNMA = ' + testingBACTNameForNMA +
                         '\n  AND testingBACTIdForNMA = ' + testingBACTIdForNMA);
            for (Capital_Design__c cd : testNMACDList) {
                cd.BRAIN_API_Call_Tracker_Master__c = testingBACTIdForNMA;
                cd.Primary_Address_State_Name__c = mockTestPrmryStateName;
            }
	        CapitalDesignTriggerHandler.TriggerDisabled = true;
            update testNMACDList;
	        CapitalDesignTriggerHandler.TriggerDisabled = false;
            for (BRAIN_API_Call_Tracker__c bact : tempCallListForNMA) {
                bact.Capital_Design__c = testingNMACDId;
            }
            update tempCallListForNMA;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_API_Call_Tracker__c for Non-Marketing Capital-Design ' + testingNMACDName);
        }
        List<BRAIN_API_Call_Tracker__c>	testCallListForNMA = [SELECT Id, Name, OwnerId, Offer__c, 
                                                                     Capital_Design__c,
                                                                     Capital_Design__r.Capital_Design_Type__c,
                                                                     BRAIN_FA_Request__c,
                                                                     BRAIN_FA_Request__r.sourceSystemIdType__c,
                                                                     BRAIN_FA_Response__c,
                                                                     API_Transaction__c,
                                                                     CreatedById, LastModifiedById
                                                                FROM BRAIN_API_Call_Tracker__c
                                                               WHERE (Capital_Design__c = :testingNMACDId)
                                                                  OR (Capital_Design__r.Capital_Design_Type__c = 'Non-Marketing'
                                                                 AND BRAIN_FA_Request__r.sourceSystemIdType__c = 'CAPITAL-DESIGN') LIMIT 1];        
        System.debug('(TEST***SETUP) AFTER BACT create, testCallListForNMA is NULL? ' + (testCallListForNMA==null) + 
                         '\n  AND testCallListForNMA?.size() = ' + testCallListForNMA?.size());
        if (testCallListForNMA != null && testCallListForNMA.size() > 0) {
	        System.debug('(TEST***SETUP) AFTER temp-BACT update, retrieved testCallListForNMA?.get(0)?.Name = ' + testCallListForNMA?.get(0)?.Name +
                         '\n  AND testCallListForNMA?.get(0)?.Id = ' + testCallListForNMA?.get(0)?.Id);
        } else {
            System.debug('(TEST***SETUP) Unable to retrieve updated test data for BRAIN_API_Call_Tracker__c for Non-Marketing Capital-Design ' + testingNMACDName);
        }
        List<BRAIN_FA_Request__c> tempReqListForNMA = TestDataFactory.createBrainFARequestForNMA(testNMACDList, 1, True);                                    
        System.debug('(TEST***SETUP) AFTER Request create, tempReqListForNMA.get(0).Id = ' + tempReqListForNMA.get(0).Id);
        List<BRAIN_FA_Request__c> testReqListForNMA = [SELECT Id, Name, sourceSystem__c, cuid__c, financialMetricCurrencyCode__c, 
                                                         financialMetricCurrencyExchangeDate__c, 
                                                         sourceSystemId__c, sourceSystemIdType__c,
                                                         analysisOverride__c, opportunityTitle__c,
                                                         BRAIN_API_Call_Tracker_Master__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.API_Transaction__c, 
                                                         Constructed_JSON__c
                                                   FROM BRAIN_FA_Request__c 
                                                  WHERE Id = :tempReqListForNMA.get(0).Id
                                                     OR sourceSystemId__c = :testingNMACDId
                                                     OR (sourceSystemIdType__c = 'CAPITAL-DESIGN'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Non-Marketing') LIMIT 1];
        if (testReqListForNMA != null && testReqListForNMA.size() > 0) {
            for (BRAIN_FA_Request__c req : testReqListForNMA) {
                testingFARequestIdForNMA = testReqListForNMA.get(0).Id;
                testingFARequestNameForNMA = testReqListForNMA.get(0).Name;
                System.debug('(TEST***SETUP) AFTER Request create, set testingFARequestNameForNMA = ' + testingFARequestNameForNMA +
                             '\n  AND testingFARequestIdForNMA = ' + testingFARequestIdForNMA);
                if (req.sourceSystemId__c == null) {
                    req.sourceSystemId__c = testingNMASrcSystemId;
                }
                if (req.sourceSystemIdType__c == null) {
                    req.sourceSystemIdType__c = 'CAPITAL-DESIGN';
                }
                req.BRAIN_API_Call_Tracker_Master__c = testingBACTIdForNMA;
                req.Constructed_JSON__c = '{ "sourceSystem":"' + req.sourceSystem__c + '", ' + 
                    '"cuid":"' + req.cuid__c + '", ' +
                    '"financialMetricCurrencyCode":"' + req.financialMetricCurrencyCode__c + '", ' + 
                    '"financialMetricCurrencyExchangeDate":null, ' +
                    '"sourceSystemId":"' + req.sourceSystemId__c + '", ' + 
                    '"sourceSystemIdType":"' + req.sourceSystemIdType__c + '", ' +
                    '"analysisOverride":null, ' + 
                    '"hl2Items":[ { "sourceSystemId":"' + req.sourceSystemId__c + '", ' +
                    '"sourceSystemIdType":"' + req.sourceSystemIdType__c + '", ' +
                    '"latitude":' + mockTestPptyLat + ', "longitude":' + mockTestPptyLong + ', ' + 
                    '"wireCenterCLLI":"' + mockTestNWCCLLI + '", "constructionMonths":24, "currencyCode":"USD", "coreElectronicsCost":0.00, "interofficeFiberCost":0.00, ' + 
                    '"coElectronicsCost":9360.00, "f1FeederCost":25414.00, "remoteElectronicsCost":0.00, "hl2ItemOverride":null, "hl3Items":[ { "quantity":' + mockTestPptyTtlUnits + ', ' + 
                    '"constructionType":"MDU", "ctlOn":false, "currencyCode":"USD", "f2Cost":0.00, "f2CostSource":"PROVIDED", "f2Footage":800.00, ' + 
                    '"insideWiringCapEx":54380.5875, "ontType":null, "dropCost":0, "dropCostSource":"PROVIDED", "additionalOpExNrc":18098.70, ' + 
                    '"additionalOpExMrc":0, "occupantType":"CONSUMER", "lotFrontageFeet":0, "maxDownstreamSpeedKbps":1000000, "clusterId":null, ' + 
                    '"fdhCost":0.01, "splitterCost":0.01, "splitterPorts":1, "idfElectronicsCost":0.01, "wirelessAccessPointsCost":0.01, "networkInvestmentType":"NEW DEVELOPMENT", ' + 
                    '"productType":"FTTH", "contractType":"COMPETITIVE LOSS", "contractTermMonths":0, "marketingFees":null, "hl3ItemOverride":null, ' + 
                    '"demographics": [ { "quantity":' + mockTestPptyTtlUnits + ', "rental":true, "incomeLevel":0  } ] } ] } ] }';										
            }
            update testReqListForNMA;
            for (BRAIN_API_Call_Tracker__c bact : testCallListForNMA) {
	            System.debug('(TEST***SETUP) For "Non-Marketing", setting BRAIN_FA_Request__c = ' + testingFARequestIdForNMA + ' for bact.Name = ' + bact.Name + ' AND bact.Id = ' + bact.Id);
                bact.BRAIN_FA_Request__c = testingFARequestIdForNMA;
            }
            update testCallListForNMA;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_FA_Request__c for Non-Marketing Capital-Design ' + testingNMACDName);
        }
        List<BRAIN_FA_Response__c> tempRespListForNMA = TestDataFactory.createBrainFAResponse(testCallListForNMA, testCallListForNMA.size(), True);                                    
        System.debug('(TEST***SETUP) AFTER Response create for "Non-Marketing", tempRespListNM.get(0).Id = ' + tempRespListForNMA.get(0).Id);
        List<BRAIN_FA_Response__c> testRespListForNMA = [SELECT Id, Name, 
                                                         BRAIN_ID__c,
                                                         hl1EvaluationResult__c,
                                                         errorCode__c, errorMessage__c,
                                                         responseDate__c, status__c,
                                                         BRAIN_API_Call_Tracker_Master__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.API_Transaction__c
                                                   FROM BRAIN_FA_Response__c 
                                                  WHERE Id = :tempRespListForNMA.get(0).Id LIMIT 1];
        if (testRespListForNMA != null && testRespListForNMA.size() > 0) {
            testingFAResponseIdForNMA = testRespListForNMA.get(0).Id;
            testingFAResponseNameForNMA = testRespListForNMA.get(0).Name;
            System.debug('(TEST***SETUP) AFTER Response create for "Standard" NOT "Instant Wi-Fi" and "OFFER", set testingFAResponseNameForNMA = ' + testingFAResponseNameForNMA +
                         '\n  AND testingFAResponseIdForNMA = ' + testingFAResponseIdForNMA);
            for (BRAIN_API_Call_Tracker__c bact : testCallListForNMA) {
	            System.debug('(TEST***SETUP) For "Non-Marketing", setting BRAIN_FA_Response__c = ' + testingFAResponseIdForNMA + ' for bact.Name = ' + bact.Name + ' AND bact.Id = ' + bact.Id);
                bact.BRAIN_FA_Response__c = testingFAResponseIdForNMA;
            }
            update testCallListForNMA;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_FA_Response__c for Non-Marketing Capital-Design ' + testingNMACDName);
        }
        System.debug('(TEST***SETUP) Ending setting up for "Non-Marketing" Capital Designs');
        
		/***** Standard Capital Designs *****/
        System.debug('(TEST***SETUP) Now setting up for "Standard" Capital Designs');
        List<BRAIN_API_Call_Tracker__c>	tempCallList = TestDataFactory.createBaseBrainAPICallTracker(testOpportunityList.size(), True);
        System.debug('(TEST***SETUP) AFTER BACT create for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", tempCallList is NULL? ' + tempCallList==null + 
                     				'\n  AND tempCallList?.size() = ' + tempCallList?.size());
        if (tempCallList != null && tempCallList.size() > 0) {
            for (Integer t = 0; t<tempCallList.size(); t++) {
		        System.debug('(TEST***SETUP) AFTER BACT create for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", tempCallList?.get(' + t + ')?.Name = ' + tempCallList?.get(t)?.Name +
                         '\n  AND tempCallList?.get(' + t + ')?.Id = ' + tempCallList?.get(t)?.Id);
            }
        }
        System.debug('(TEST***SETUP) testOpportunityList is NULL? ' + testOpportunityList==null + '\n  AND testOpportunityList?.size() = ' + testOpportunityList?.size());
        List<Offer__c> tempOfferList = TestDataFactory.createOffersForBRAINTests(testOpportunityList, testOpportunityList.size(), True);
        System.debug('(TEST***SETUP) AFTER initial Offer insert for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", tempOfferList is NULL? ' + tempOfferList==null + 
                     				'\n  AND tempOfferList?.size() = ' + tempOfferList?.size());
        CapitalDesignTriggerHandler.TriggerDisabled = true;
        List<Capital_Design__c> tempCDList = TestDataFactory.createCapitalDesignsWithNRMADefaults(testOpportunityList, tempOfferList, tempCallList, testOpportunityList.size(), False);
        upsert tempCDList;
        System.debug('(TEST***SETUP) AFTER initial CD insert for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", tempCDList is NULL? ' + tempCDList==null + '\n AND tempCDList?.size() = ' + tempCDList?.size());
        CapitalDesignTriggerHandler.TriggerDisabled = false;
        List<Capital_Design__c> testCDList = [SELECT Id, Name, OwnerId, 
                                        BRAIN_API_Call_Tracker_Master__c,
                                        Opportunity__r.Property__r.Primary_Address_State__c,
                                        Offer__c,
                                        Offer__r.Offer_Total_Units__c, 
                                        Offer__r.Offer_Type__c,
                                        Offer__r.Offer_Status__c,
                                        Offer__r.Other_Provider_Contract_Type__c, 
                                        Offer__r.Contract_Term__c,
                                        Offer__r.Data_Bounty_Amount__c, 
                                        Offer__r.Bulk_Data_Speed_Profile_DL_UL__c,
                                        Offer__r.Requested_Bulk_Data_Price__c,
                                        Offer__r.Prepaid_Marketing_Fee_Per_Unit__c,
                                        Offer__r.Opportunity__r.Id, 
                                        Offer__r.Opportunity__r.Property__r.Primary_Address_State__c,
                                        Offer__r.Contract__r.EndDate,
                                        Offer__r.Flat_Revenue_Share__c,
                                        Offer__r.Revenue_Share_Agent_Commission_Rate__c,
                                        Offer__r.Revenue_Share_MIN_Penetration_Rate__c,
                                        Offer__r.Revenue_Share_MAX_Penetration_Rate__c,
                                        Actual_Build_Out_Months__c,
                                        Core_Switch_Electronics__c,
                                        Transport_Interoffice_Fiber__c,
                                        CO_Electronics__c,
                                        Feeder_F1_Access_and_or_PON__c,
                                        Remote_Electronics__c,
                                        Total_Cottage_Rental_Units__c, 
                                        Total_Tower_Rental_Units__c, 
                                        Total_SFH_Rental_Units__c,
                                        Total_Cottage_Owner_Units__c, 
                                        Total_Tower_Owner_Units__c, 
                                        Total_SFH_Owner_Units__c, 
                                        Service_Delivery__c, 
                                        Distribution_F2__c, 
                                        F1_Footage_ft__c,
                                        F2_Footage_ft__c,
                                        Distribution_Structure_Conduit__c,
                                        Electronics_Shelf_UPS_Cost__c,
                                        F4_Inside_Wiring_SFH__c,
                                        Other_MDU_F4__c,
                                        OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                        OP_F2_Total_Cost_Combined_Cost__c,
                                        OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                        OP_F3_Total_Cost_Comb_Cost__c,
                                        for_SFU_Average_Lot_Size__c, 
                                        Network_Investment__c, 
                                        Technology_Type__c, 
                                        Service_Type__c,                     
                                        MDU_ONT_Drop__c,
                                        Access_Type__c,
                                        F1_Feeder_Type__c,
                                        Cluster_ID__c,
                                        Cluster_Not_Available__c,
                                        Development_Status__c,
                                        Building_Style__c,
                                        ONT_Model__c,
                                        Occupant_Type__c,
                                        //The InstantWiFi-specific fields are listed together below 
                                        Access_Cost__c,
                                        IP_CapEx_Shared__c,
                                        IP_NetEx_Shared_MRC__c,
                                        Wireless_Access_Points_Cost__c,
                                        BCET_Wire_Center__c,
                                        One_Time_Additional_Expense__c,
                                        Recurring_Additional_Expenses_Monthly__c,
                                        //The NMA-specific fields are listed together below 
                                        Capital_Design_Type__c,
                                        Property_Name__c,
                                        Product__c,
                                        Planned_Build_Out_Years__c,
                                        Wire_Center_CLLI_Code__c,
                                        Latitude_NM__c,
                                        Longitude_NM__c,
                                        Service_Delivery_NM__c,
                                        Max_Downstream_Speed_NM__c,
                                        Total_Cottage_Rental_Units_NM__c, 
                                        Total_Tower_Rental_Units_NM__c, 
                                        Total_SFH_Rental_Units_NM__c,
                                        Total_Cottage_Owner_Units_NM__c, 
                                        Total_Tower_Owner_Units_NM__c, 
                                        Total_SFH_Owner_Units_NM__c                                                                
                                   FROM Capital_Design__c
                                  WHERE Capital_Design_Type__c = 'Standard' AND Technology_Type__c != 'Instant Wi-Fi'];            
        System.debug('(TEST***SETUP) testCDList is NULL? ' + testCDList==null + '\n  AND testCDList?.size() = ' + testCDList?.size());
        if (testCDList != null && testCDList.size() > 0) {
            for (Integer t = 0; t<testCDList.size(); t++) {
                System.debug('(TEST***SETUP) AFTER initial CD insert for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", testCDList.get(' + t + ').Id = ' + testCDList.get(t)?.Id + 
                             '\n  AND testCDList.get(' + t + ')?.Name = ' + testCDList.get(t)?.Name + 
                             '\n  AND testCDList.get(' + t + ')?.Offer__c = ' + testCDList.get(t)?.Offer__c +
                             '\n  AND testCDList.get(' + t + ')?.Technology_Type__c = ' + testCDList.get(t)?.Technology_Type__c +
                             '\n  AND testCDList.get(' + t + ')?.Capital_Design_Type__c = ' + testCDList.get(t)?.Capital_Design_Type__c +
                             '\n  AND testCDList.get(' + t + ')?.Network_Investment__c = ' + testCDList.get(t)?.Network_Investment__c +
                             '\n  AND testCDList.get(' + t + ')?.Development_Status__c = ' + testCDList.get(t)?.Development_Status__c +
                             '\n  AND testCDList.get(' + t + ')?.Opportunity__r.Property__r.Primary_Address_State__c = ' + testCDList.get(t)?.Opportunity__r.Property__r.Primary_Address_State__c);
            }
        }
        if (tempCallList != null && tempCallList.size() > 0) {
            for (Integer t = 0; t<tempCallList.size(); t++) {
		        System.debug('(TEST***SETUP) Following initial CD insert, tempCallList?.get(' + t + ')?.Name = ' + tempCallList?.get(t)?.Name +
                         '\n  AND tempCallList?.get(' + t + ')?.Id = ' + tempCallList?.get(t)?.Id);
            	for (Capital_Design__c cd : testCDList) {
                    if (cd.BRAIN_API_Call_Tracker_Master__c == tempCallList?.get(t)?.Id) {
                        tempCallList.get(t).Capital_Design__c = cd.Id;
                    }
            	}
            }
            update tempCallList;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_API_Call_Tracker__c for "Standard" NOT "Instant WiFi" Capital-Designs');
        }
        List<BRAIN_API_Call_Tracker__c>	testCallList = [SELECT Id, Name, OwnerId, Offer__c, 
                                                                     Capital_Design__c,
                                                                     Capital_Design__r.Capital_Design_Type__c,
                                                                     BRAIN_FA_Request__c,
                                                                     BRAIN_FA_Request__r.sourceSystemIdType__c,
                                                                     BRAIN_FA_Response__c,
                                                                     API_Transaction__c,
                                                                     CreatedById, LastModifiedById
                                                                FROM BRAIN_API_Call_Tracker__c
                                                               WHERE (Capital_Design__r.Capital_Design_Type__c = 'Standard'
                                                                 AND Capital_Design__r.Technology_Type__c != 'Instant Wi-Fi'
                                                                 AND Capital_Design__c != NULL)];        
        System.debug('(TEST***SETUP) AFTER BACT create, testCallList is NULL? ' + (testCallList==null) + '\n  AND testCallList?.size() = ' + testCallList?.size());
        if (testCallList != null && testCallList.size() > 0) {
            for (Integer t = 0; t < testCallList.size(); t++) {
                System.debug('(TEST***SETUP) AFTER temp-BACT update, retrieved testCallList?.get(' + t +')?.Name = ' + testCallList?.get(t)?.Name +
                             '\n  AND testCallList?.get(' + t + ')?.Id = ' + testCallList?.get(t)?.Id);
            }
        } else {
            System.debug('(TEST***SETUP) Unable to retrieve updated test data for BRAIN_API_Call_Tracker__c for "Standard" NOT "Instant WiFi" Capital-Designs');
        }
        if (tempOfferList != null && tempOfferList.size() > 0) {
            for (Integer t = 0; t<tempOfferList.size(); t++) {
                for (Capital_Design__c cd : testCDList) {
                    if (cd.Offer__c == tempOfferList.get(t).Id) {
                        tempOfferList.get(t).Associated_Capital_Design__c = cd.Id;
                        tempOfferList.get(t).BRAIN_API_Call_Tracker_Master__c = cd.BRAIN_API_Call_Tracker_Master__c;
		                System.debug('(TEST***SETUP) Setting Offer-Associated_Capital_Design__c to "' + cd.Id + '" along with Offer-BRAIN_API_Call_Tracker_Master__c to "' + cd.BRAIN_API_Call_Tracker_Master__c + '"  for Offer "' + tempOfferList.get(t).Name + '"');
                    }
                }
		        System.debug('(TEST***SETUP) AFTER looping through testCDList, modify for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", ' +
                     '\n  tempOfferList.get(' + t + ').Name = ' + tempOfferList.get(t).Name +
                     '\n  AND tempOfferList.get(' + t + ').Id = ' + tempOfferList.get(t).Id +
                     '\n  AND tempOfferList.get(' + t + ').Associated_Capital_Design__c = ' + tempOfferList.get(t).Associated_Capital_Design__c +
                     '\n  AND tempOfferList.get(' + t + ').BRAIN_API_Call_Tracker_Master__c = ' + tempOfferList.get(t).BRAIN_API_Call_Tracker_Master__c);
            }
            update tempOfferList;
        }
        List<Offer__c> testOfferList = [SELECT Id, Name, OwnerId, 
                                        		BRAIN_API_Call_Tracker_Master__c, 
                                        		Offer_Total_Units__c, 
                                                Offer_Type__c, Offer_Status__c,                                                
                                                Other_Provider_Contract_Type__c,
                                                Contract_Term__c,
                                                Data_Bounty_Amount_Approved__c, 
                                                Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                                Requested_Bulk_Data_Price_Approved__c,
                                                Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                                Opportunity__r.Id, 
                                                Contract__r.EndDate,
                                                Flat_Revenue_Share_Approved__c,
                                                Revenue_Share_Agent_Commission_Rate__c,
                                                Revenue_Share_MIN_Penetration_Rate__c,
                                                Revenue_Share_MAX_Penetration_Rate__c,
                                                Associated_Capital_Design__c,
                                                Associated_Capital_Design__r.Name,
                                        		Associated_Capital_Design__r.BRAIN_API_Call_Tracker_Master__c,
                                        		Associated_Capital_Design__r.Capital_Design_Type__c,
                                                Associated_Capital_Design__r.Actual_Build_Out_Months__c,
                                                Associated_Capital_Design__r.Core_Switch_Electronics__c,
                                                Associated_Capital_Design__r.Transport_Interoffice_Fiber__c,
                                                Associated_Capital_Design__r.CO_Electronics__c,
                                                Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c,
                                                Associated_Capital_Design__r.Remote_Electronics__c,
                                                Associated_Capital_Design__r.Total_Cottage_Rental_Units__c, 
                                                Associated_Capital_Design__r.Total_Tower_Rental_Units__c, 
                                                Associated_Capital_Design__r.Total_SFH_Rental_Units__c,
                                                Associated_Capital_Design__r.Total_Cottage_Owner_Units__c, 
                                                Associated_Capital_Design__r.Total_Tower_Owner_Units__c, 
                                                Associated_Capital_Design__r.Total_SFH_Owner_Units__c, 
                                                Associated_Capital_Design__r.Service_Delivery__c, 
                                                Associated_Capital_Design__r.Distribution_F2__c, 
                                                Associated_Capital_Design__r.F1_Footage_ft__c,
                                                Associated_Capital_Design__r.F2_Footage_ft__c,
                                                Associated_Capital_Design__r.Distribution_Structure_Conduit__c,
                                           		Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c,
                                                Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c,
                                                Associated_Capital_Design__r.Other_MDU_F4__c, 
                                                Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                                Associated_Capital_Design__r.OP_F2_Total_Cost_Combined_Cost__c,
                                                Associated_Capital_Design__r.OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                                Associated_Capital_Design__r.OP_F3_Total_Cost_Comb_Cost__c,
                                                Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c, 
                                                Associated_Capital_Design__r.Network_Investment__c, 
                                                Associated_Capital_Design__r.Technology_Type__c, 
                                                Associated_Capital_Design__r.Service_Type__c,                     
                                                Associated_Capital_Design__r.MDU_ONT_Drop__c,
                                                Associated_Capital_Design__r.Access_Type__c,
                                                Associated_Capital_Design__r.F1_Feeder_Type__c,
                                                Associated_Capital_Design__r.Cluster_ID__c,
                                                Associated_Capital_Design__r.Cluster_Not_Available__c,
                                                Associated_Capital_Design__r.Development_Status__c,
                                                Associated_Capital_Design__r.Building_Style__c,
                                        		Associated_Capital_Design__r.ONT_Model__c,
                                                Associated_Capital_Design__r.Occupant_Type__c,
                                                Associated_Capital_Design__r.Access_Cost__c,
                                                Associated_Capital_Design__r.IP_CapEx_Shared__c,
                                                Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c,
                                                Associated_Capital_Design__r.Wireless_Access_Points_Cost__c,
                                                Associated_Capital_Design__r.BCET_Wire_Center__c,
                                                Associated_Capital_Design__r.One_Time_Additional_Expense__c,
                                                Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c
	                                        FROM Offer__c];
        System.debug('(TEST***SETUP) AFTER Offer insert for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", testOfferList is NULL? ' + (testOfferList==null) +
                     '\n  AND testOfferList?.size() = ' + testOfferList?.size());
        if (testOfferList != null && testOfferList.size() > 0) {
            for (Integer t = 0; t < testOfferList.size(); t++) {
		        System.debug('(TEST***SETUP) AFTER Offer insert for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", testOfferList.get(' + t + ').Name = ' + testOfferList.get(t).Name +
    			                 '\n  AND testOfferList.get(' + t + ').Id = ' + testOfferList.get(t).Id);
            }
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for Offer for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN" for Opportunity ' + mockTestOpptyTitle);
        }
        List<Offer__c> testOfferSmryList = [SELECT Id, Name, OwnerId, 
                                                Associated_Capital_Design__c,
                                                Associated_Capital_Design__r.Name,
                                                Associated_Capital_Design__r.Capital_Design_Type__c,
                                                Associated_Capital_Design__r.Technology_Type__c,
                                                BRAIN_API_Call_Tracker_Master__c, 
                                                Brain_ID__c,
                                                CapEx_Direct__c,
                                                Cumulative_NPV__c,
                                                Discounted_Payback_months__c,
                                                EBITDA_Margin__c,
                                                Financial_Viability__c,
                                                IRR__c,
                                                Incremental_ATC_To_Meet_Guardrail__c,
                                                Simple_Payback_Months__c,
                                                X1st_Year_of_Positive_EBITDA__c,
                                                X1st_Year_of_Positive_FCF__c
	                                        FROM Offer__c
    	                                   WHERE (Associated_Capital_Design__r.Capital_Design_Type__c = 'Standard' 
                                             AND Associated_Capital_Design__r.Technology_Type__c != 'Instant Wi-Fi'
                                             AND Associated_Capital_Design__c != null
                                             AND BRAIN_API_Call_Tracker_Master__c != null)];
        System.debug('(TEST***SETUP) AFTER Offer insert for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", testOfferSmryList is NULL? ' + (testOfferSmryList==null) +
                     '\n  AND testOfferSmryList?.size() = ' + testOfferSmryList?.size());
        testCDList = [SELECT Id, Name, OwnerId, BRAIN_API_Call_Tracker_Master__c,
                                        Opportunity__r.Property__r.Primary_Address_State__c,
                                        Offer__r.Offer_Total_Units__c, 
                                        Offer__r.Offer_Type__c,
                                        Offer__r.Offer_Status__c,
                                        Offer__r.Other_Provider_Contract_Type__c, 
                                        Offer__r.Contract_Term__c,
                                        Offer__r.Data_Bounty_Amount__c, 
                                        Offer__r.Bulk_Data_Speed_Profile_DL_UL__c,
                                        Offer__r.Requested_Bulk_Data_Price__c,
                                        Offer__r.Prepaid_Marketing_Fee_Per_Unit__c,
                                        Offer__r.Opportunity__r.Id, 
                                        Offer__r.Contract__r.EndDate,
                                        Offer__r.Flat_Revenue_Share__c,
                                        Offer__r.Revenue_Share_Agent_Commission_Rate__c,
                                        Offer__r.Revenue_Share_MIN_Penetration_Rate__c,
                                        Offer__r.Revenue_Share_MAX_Penetration_Rate__c,
                                        Actual_Build_Out_Months__c,
                                        Core_Switch_Electronics__c,
                                        Transport_Interoffice_Fiber__c,
                                        CO_Electronics__c,
                                        Feeder_F1_Access_and_or_PON__c,
                                        Remote_Electronics__c,
                                        Total_Cottage_Rental_Units__c, 
                                        Total_Tower_Rental_Units__c, 
                                        Total_SFH_Rental_Units__c,
                                        Total_Cottage_Owner_Units__c, 
                                        Total_Tower_Owner_Units__c, 
                                        Total_SFH_Owner_Units__c, 
                                        Service_Delivery__c, 
                                        Distribution_F2__c, 
                                        F1_Footage_ft__c,
                                        F2_Footage_ft__c,
                                        Distribution_Structure_Conduit__c,
                                        Electronics_Shelf_UPS_Cost__c,
                                        F4_Inside_Wiring_SFH__c,
                                        Other_MDU_F4__c,
                                        OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                        OP_F2_Total_Cost_Combined_Cost__c,
                                        OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                        OP_F3_Total_Cost_Comb_Cost__c,
                                        for_SFU_Average_Lot_Size__c, 
                                        Network_Investment__c, 
                                        Technology_Type__c, 
                                        Service_Type__c,                     
                                        MDU_ONT_Drop__c,
                                        Access_Type__c,
                                        F1_Feeder_Type__c,
                                        Cluster_ID__c,
                                        Cluster_Not_Available__c,
                                        Development_Status__c,
                                        Building_Style__c,
                                        ONT_Model__c,
                                        Occupant_Type__c,
                                        //The InstantWiFi-specific fields are listed together below 
                                        Access_Cost__c,
                                        IP_CapEx_Shared__c,
                                        IP_NetEx_Shared_MRC__c,
                                        Wireless_Access_Points_Cost__c,
                                        BCET_Wire_Center__c,
                                        One_Time_Additional_Expense__c,
                                        Recurring_Additional_Expenses_Monthly__c,
                                        //The NMA-specific fields are listed together below 
                                        Capital_Design_Type__c,
                                        Property_Name__c,
                                        Product__c,
                                        Planned_Build_Out_Years__c,
                                        Wire_Center_CLLI_Code__c,
                                        Latitude_NM__c,
                                        Longitude_NM__c,
                                        Service_Delivery_NM__c,
                                        Max_Downstream_Speed_NM__c,
                                        Total_Cottage_Rental_Units_NM__c, 
                                        Total_Tower_Rental_Units_NM__c, 
                                        Total_SFH_Rental_Units_NM__c,
                                        Total_Cottage_Owner_Units_NM__c, 
                                        Total_Tower_Owner_Units_NM__c, 
                                        Total_SFH_Owner_Units_NM__c                                                                
                                   FROM Capital_Design__c
                                  WHERE (Capital_Design_Type__c = 'Standard' 
                                    AND Technology_Type__c != 'Instant Wi-Fi')];            
        System.debug('(TEST***SETUP) PRIOR to BACT build-out for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", testCdList is NULL? ' + (testCdList==null) +
                     '\n  AND testCDList?.size() = ' + testCDList?.size());
        List<BRAIN_FA_Request__c> tempReqList = TestDataFactory.createBrainFARequest(testCDList, null, testCDList.size(), True);                                    
        System.debug('(TEST***SETUP) AFTER Request create for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", tempReqList is NULL? ' + tempReqList==null + 
                     			'\n  AND tempReqList?.size() = ' + tempReqList?.size());
        if (tempReqList != null && tempReqList.size() > 0) {
            for (Integer t = 0; t < tempReqList.size(); t++) {
                System.debug('(TEST***SETUP) AFTER Request create for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", set tempReqList.get(' + t + ').Name = ' + tempReqList.get(t).Name +
                             '\n  AND tempReqList.get(' + t + ').Id = ' + tempReqList.get(t).Id);
                for (BRAIN_API_Call_Tracker__c bact : testCallList) {
                    if (tempReqList.get(t).sourceSystemId__c == bact.Capital_Design__c) {
                        tempReqList.get(t).BRAIN_API_Call_Tracker_Master__c = bact.Id;
                    }
                }
            }
            update tempReqList;
        }
        List<BRAIN_FA_Request__c> testReqList = [SELECT Id, Name, sourceSystem__c, cuid__c, financialMetricCurrencyCode__c, 
                                                         financialMetricCurrencyExchangeDate__c, 
                                                         sourceSystemId__c, sourceSystemIdType__c,
                                                         analysisOverride__c, opportunityTitle__c,
                                                         BRAIN_API_Call_Tracker_Master__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Technology_Type__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.API_Transaction__c, 
                                                         Constructed_JSON__c
                                                   FROM BRAIN_FA_Request__c 
                                                  WHERE (sourceSystemIdType__c = 'CAPITAL-DESIGN'
                                                    AND sourceSystemId__c != NULL                                                     
                                                    AND BRAIN_API_Call_Tracker_Master__c != NULL
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__c != NULL
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c != 'Non-Marketing')];
        System.debug('(TEST***SETUP) AFTER Request create for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", testReqList is NULL? ' + (testReqList==null) + 
                     			'\n  AND testReqList?.size() = ' + testReqList?.size());
        if (testReqList != null && testReqList.size() > 0) {
            for (Integer t = 0; t < testReqList.size(); t++) {
                System.debug('(TEST***SETUP) AFTER Request create for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", set testReqList.get(' + t + ').Name = ' + testReqList.get(t).Name +
                             '\n  AND testReqList.get(' + t + ').Id = ' + testReqList.get(t).Id);
                if (testReqList.get(t).sourceSystemId__c == null) {
                    testReqList.get(t).sourceSystemId__c = testOpportunityList.get(t).Id;    
                }
                if (testReqList.get(t).sourceSystemIdType__c == null) {
                    testReqList.get(t).sourceSystemIdType__c = 'OPPORTUNITY';
                }
                testReqList.get(t).opportunityTitle__c = testOpportunityList.get(t).Name;
                testReqList.get(t).Constructed_JSON__c = '{ "sourceSystem":"' + testReqList.get(t).sourceSystem__c + '", ' + 
                    '"cuid":"' + testReqList.get(t).cuid__c + '", ' +
                    '"financialMetricCurrencyCode":"' + testReqList.get(t).financialMetricCurrencyCode__c + '", ' + 
                    '"financialMetricCurrencyExchangeDate":null, ' +
                    '"sourceSystemId":"' + testReqList.get(t).sourceSystemId__c + '", ' + 
                    '"sourceSystemIdType":"' + testReqList.get(t).sourceSystemIdType__c + '", ' +
                    '"analysisOverride":null, "opportunityTitle":"' + testOpportunityList.get(t).Name + '", ' + 
                    '"hl2Items":[ { "sourceSystemId":"' + testReqList.get(t).sourceSystemId__c + '", ' +
                    '"sourceSystemIdType":"' + testReqList.get(t).sourceSystemIdType__c + '", ' +
                    '"latitude":' + mockTestPptyLat + ', "longitude":' + mockTestPptyLong + ', ' + 
                    '"wireCenterCLLI":"' + mockTestNWCCLLI + '", "constructionMonths":24, "currencyCode":"USD", "coreElectronicsCost":0.00, "interofficeFiberCost":0.00, ' + 
                    '"coElectronicsCost":9360.00, "f1FeederCost":25414.00, "remoteElectronicsCost":0.00, "hl2ItemOverride":null, "hl3Items":[ { "quantity":' + mockTestPptyTtlUnits + ', ' + 
                    '"constructionType":"MDU", "ctlOn":false, "currencyCode":"USD", "f2Cost":0.00, "f2CostSource":"PROVIDED", "f2Footage":800.00, ' + 
                    '"insideWiringCapEx":54380.5875, "ontType":null, "dropCost":0, "dropCostSource":"PROVIDED", "additionalOpExNrc":18098.70, ' + 
                    '"additionalOpExMrc":0, "occupantType":"CONSUMER", "lotFrontageFeet":0, "maxDownstreamSpeedKbps":1000000, "clusterId":null, ' + 
                    '"fdhCost":0.01, "splitterCost":0.01, "splitterPorts":1, "idfElectronicsCost":0.01, "wirelessAccessPointsCost":0.01, "networkInvestmentType":"NEW DEVELOPMENT", ' + 
                    '"productType":"FTTH", "contractType":"COMPETITIVE LOSS", "contractTermMonths":0, "marketingFees":null, ' +
                    '"hl3ItemOverride":null, "demographics": [ { "quantity":' + mockTestPptyTtlUnits + ', "rental":true, "incomeLevel":0  } ] } ] } ] }';										
                System.debug('(TEST***SETUP) For testReqList.get(' + t + ').Name = ' + testReqList.get(t).Name +
                             '\n testReqList.get(' + t + ').Constructed_JSON__c = ' + testReqList.get(t).Constructed_JSON__c);
            }
            update testReqList;
            for (Integer t = 0; t < testReqList.size(); t++) {
                for (Integer c = 0; c < testCallList.size(); c++) {
                    if (testReqList.get(t).BRAIN_API_Call_Tracker_Master__c == testCallList.get(c).Id) {
                		testCallList.get(c).BRAIN_FA_Request__c = testReqList.get(t).Id;
                    }
                }
            }
            update testCallList;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_FA_Request__c for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN" for Opportunity ' + mockTestOpptyTitle);
        }
        List<BRAIN_FA_Response__c> tempRespList = TestDataFactory.createBrainFAResponse(testCallList, testCallList.size(), True);                                    
        System.debug('(TEST***SETUP) AFTER Response create for "Standard" NOT "Instant Wi-Fi" and "OFFER", tempRespList is NULL? ' + tempRespList==null + 
                     			'\n  AND tempRespList?.size() = ' + tempRespList?.size());
        List<BRAIN_FA_Response__c> testRespList = [SELECT Id, Name, 
                                                         BRAIN_ID__c,
                                                         hl1EvaluationResult__c,
                                                         errorCode__c, errorMessage__c,
                                                         responseDate__c, status__c,
                                                         BRAIN_API_Call_Tracker_Master__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.API_Transaction__c
                                                   FROM BRAIN_FA_Response__c];
        if (testRespList != null && testRespList.size() > 0) {
            for (Integer t = 0; t < testRespList.size(); t++) {
                System.debug('(TEST***SETUP) AFTER Response create for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN", set testRespList.get(' + t + ').Name = ' + testRespList.get(t).Name +
                             '\n  AND testRespList.get(' + t + ').Id = ' + testRespList.get(t).Id);
                for (Integer c = 0; c < testCallList.size(); c++) {
                    if (testRespList.get(t).BRAIN_API_Call_Tracker_Master__c == testCallList.get(c).Id) {
                		testCallList.get(c).BRAIN_FA_Response__c = testRespList.get(t).Id;
                    }
                }
            }
            update testCallList;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_FA_Response__c for "Standard" NOT "Instant Wi-Fi" and "CAPITAL-DESIGN" for Opportunity ' + mockTestOpptyTitle);
        }
        //for Offer
        System.debug('(TEST***SETUP) Now setting up for Offers');
        List<BRAIN_API_Call_Tracker__c>	tempCallListOffer = TestDataFactory.createBrainAPICallTracker(testCDList, testOfferList, testOfferList.size(), True);
        System.debug('(TEST***SETUP) AFTER BACT create for "Standard" NOT "Instant Wi-Fi" and "OFFER", tempCallListOffer is NULL? ' + tempCallListOffer==null + 
                     				'\n AND tempCallListOffer?.size() = ' + tempCallListOffer?.size());
        if (tempCallListOffer != null && tempCallListOffer.size() > 0) {
            for (Integer t = 0; t<tempCallListOffer.size(); t++) {
		        System.debug('(TEST***SETUP) AFTER BACTforOffer create, tempCallListOffer?.get(' + t + ')?.Name = ' + tempCallListOffer?.get(t)?.Name +
                         '\n  AND tempCallListOffer?.get(' + t + ')?.Id = ' + tempCallListOffer?.get(t)?.Id);
            	for (Offer__c offer : testOfferList) {
                    if (offer.BRAIN_API_Call_Tracker_Master__c == tempCallListOffer?.get(t)?.Id) {
                        tempCallListOffer.get(t).Offer__c = offer.Id;
                    }
            	}
            }
            update tempCallListOffer;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_API_Call_Tracker__c for "Standard" NOT "Instant WiFi" Offer ' + testingOfferName);
        }
        List<BRAIN_API_Call_Tracker__c>	testCallListOffer = [SELECT Id, Name, OwnerId, Offer__c, 
                                                                     Capital_Design__c,
                                                                     Capital_Design__r.Capital_Design_Type__c,
                                                                     BRAIN_FA_Request__c,
                                                                     BRAIN_FA_Request__r.sourceSystemIdType__c,
                                                                     BRAIN_FA_Response__c,
                                                                     API_Transaction__c,
                                                                     CreatedById, LastModifiedById
                                                                FROM BRAIN_API_Call_Tracker__c
                                                               WHERE (Capital_Design__r.Capital_Design_Type__c = 'Standard'
                                                                 AND Capital_Design__r.Technology_Type__c != 'Instant Wi-Fi'
                                                                 AND Offer__c != NULL)];        
        System.debug('(TEST***SETUP) AFTER BACTforOffer update for "Standard" NOT "Instant Wi-Fi" and "OFFER", testCallListOffer is NULL? ' + (testCallListOffer==null) + '\n  AND testCallListOffer?.size() = ' + testCallListOffer?.size());
        if (testCallListOffer != null && testCallListOffer.size() > 0) {
            for (Integer t = 0; t<testCallListOffer.size(); t++) {
		        System.debug('(TEST***SETUP) AFTER BACTforOffer update, testCallListOffer?.get(' + t + ')?.Name = ' + testCallListOffer?.get(t)?.Name +
                         '\n  AND testCallListOffer?.get(' + t + ')?.Id = ' + testCallListOffer?.get(t)?.Id +
                         '\n  AND testCallListOffer?.get(' + t + ')??.Offer__c = '  + testCallListOffer?.get(t)?.Offer__c +
                         '\n  AND testCallListOffer?.get(' + t + ')??.Capital_Design__c = '  + testCallListOffer?.get(t)?.Capital_Design__c);
            }
        } else {
            System.debug('(TEST***SETUP) Unable to retrieve updated test data for BRAIN_API_Call_Tracker__c for "Standard" NOT "Instant WiFi" Offer ' + testingOfferName);
        }
        List<BRAIN_FA_Request__c> tempReqListOffer = TestDataFactory.createBrainFARequest(testCDList, testOfferList, testOfferList.size(), True);                                    
        System.debug('(TEST***SETUP) AFTER Request create for "Standard" NOT "Instant Wi-Fi" and "OFFER", tempReqListOffer is NULL? ' + tempReqListOffer==null + '\n AND tempReqListOffer?.size() = ' + tempReqListOffer.size());
        List<BRAIN_FA_Request__c> testReqListOffer = [SELECT Id, Name, sourceSystem__c, cuid__c, financialMetricCurrencyCode__c, 
                                                         financialMetricCurrencyExchangeDate__c, 
                                                         sourceSystemId__c, sourceSystemIdType__c,
                                                         analysisOverride__c, opportunityTitle__c,
                                                         BRAIN_API_Call_Tracker_Master__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Technology_Type__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.API_Transaction__c, 
                                                         Constructed_JSON__c
                                                   FROM BRAIN_FA_Request__c 
                                                  WHERE (sourceSystemIdType__c = 'OFFER'
                                                    AND sourceSystemId__c != NULL                                                     
                                                    AND BRAIN_API_Call_Tracker_Master__c != NULL
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__c != NULL
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c != 'Non-Marketing')];
        System.debug('(TEST***SETUP) AFTER Request create for "Standard" NOT "Instant Wi-Fi" and "OFFER", testReqListOffer is NULL? ' + (testReqListOffer==null) + 
                     			'\n  AND testReqListOffer?.size() = ' + testReqListOffer?.size());
        if (testReqListOffer != null && testReqListOffer.size() > 0) {
            for (Integer t = 0; t < testReqListOffer.size(); t++) {
                System.debug('(TEST***SETUP) AFTER Request create for "Standard" NOT "Instant Wi-Fi" and "OFFER", set testingFARequestNameForOffer = ' + testReqListOffer.get(t).Name +
                             '\n  AND testingFARequestIdForOffer = ' + testReqListOffer.get(t).Id);
                if (testReqListOffer.get(t).sourceSystemId__c == null) {
                    testReqListOffer.get(t).sourceSystemId__c = testingOfferId;    
                }
                if (testReqListOffer.get(t).sourceSystemIdType__c == null) {
                    testReqListOffer.get(t).sourceSystemIdType__c = 'OPPORTUNITY';
                }
                testReqListOffer.get(t).opportunityTitle__c = testOpportunityList.get(t).Name;
                testReqListOffer.get(t).Constructed_JSON__c = '{ "sourceSystem":"' + testReqListOffer.get(t).sourceSystem__c + '", ' + 
                    '"cuid":"' + testReqListOffer.get(t).cuid__c + '", ' +
                    '"financialMetricCurrencyCode":"' + testReqListOffer.get(t).financialMetricCurrencyCode__c + '", ' + 
                    '"financialMetricCurrencyExchangeDate":null, ' +
                    '"sourceSystemId":"' + testReqListOffer.get(t).sourceSystemId__c + '", ' + 
                    '"sourceSystemIdType":"' + testReqListOffer.get(t).sourceSystemIdType__c + '", ' +
                    '"analysisOverride":null, "opportunityTitle":"' + testOpportunityList.get(t).Name + '", ' + 
                    '"hl2Items":[ { "sourceSystemId":"' + testReqListOffer.get(t).sourceSystemId__c + '", ' +
                    '"sourceSystemIdType":"' + testReqListOffer.get(t).sourceSystemIdType__c + '", ' +
                    '"latitude":' + mockTestPptyLat + ', "longitude":' + mockTestPptyLong + ', ' + 
                    '"wireCenterCLLI":"' + mockTestNWCCLLI + '", "constructionMonths":24, "currencyCode":"USD", "coreElectronicsCost":0.00, "interofficeFiberCost":0.00, ' + 
                    '"coElectronicsCost":9360.00, "f1FeederCost":25414.00, "remoteElectronicsCost":0.00, "hl2ItemOverride":null, "hl3Items":[ { "quantity":' + mockTestPptyTtlUnits + ', ' + 
                    '"constructionType":"MDU", "ctlOn":false, "currencyCode":"USD", "f2Cost":0.00, "f2CostSource":"PROVIDED", "f2Footage":800.00, ' + 
                    '"insideWiringCapEx":54380.5875, "ontType":null, "dropCost":0, "dropCostSource":"PROVIDED", "additionalOpExNrc":18098.70, ' + 
                    '"additionalOpExMrc":0, "occupantType":"CONSUMER", "lotFrontageFeet":0, "maxDownstreamSpeedKbps":1000000, "clusterId":null, ' + 
                    '"fdhCost":0.01, "splitterCost":0.01, "splitterPorts":1, "idfElectronicsCost":0.01, "wirelessAccessPointsCost":0.01, "networkInvestmentType":"NEW DEVELOPMENT", ' + 
                    '"productType":"FTTH", "marketingFees":{  "currencyCode":"USD", "doorFeePerUnit":32.55, ' +
                    '"firstInstallBountyPerUnit":75.00, "serviceRevenueShares":[ {  "minPenetrationRate":0.075, "maxPenetrationRate":0.20, "agentCommissionRate":0.09  } ]  }, ' +
                    '"contractType":"SMA", "contractTermMonths":48, "otherProviderContractType":"NonContracted", "hl3ItemOverride":null, ' + 
                    '"demographics": [ { "quantity":' + mockTestPptyTtlUnits + ', "rental":true, "incomeLevel":0  } ] } ] } ] }';										
                System.debug('(TEST***SETUP) For testReqListOffer.get(' + t + ').Name = ' + testReqListOffer.get(t).Name +
                             '\n testReqListOffer.get(' + t + ').Constructed_JSON__c = ' + testReqListOffer.get(t).Constructed_JSON__c);
        	}
            update testReqListOffer;
            for (Integer t = 0; t < testReqListOffer.size(); t++) {
                for (Integer c = 0; c < testCallListOffer.size(); c++) {
                    if (testReqListOffer.get(t).BRAIN_API_Call_Tracker_Master__c == testCallListOffer.get(c).Id) {
                		testCallListOffer.get(c).BRAIN_FA_Request__c = testReqListOffer.get(t).Id;
                    }
                }
            }
            update testCallListOffer;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_FA_Request__c for "Standard" NOT "Instant Wi-Fi" and "OFFER" for Opportunity ' + mockTestOpptyTitle);
        }
        List<BRAIN_FA_Response__c> tempRespListOffer = TestDataFactory.createBrainFAResponse(testCallListOffer, testCallListOffer.size(), True);                                    
        System.debug('(TEST***SETUP) AFTER Response create for "Standard" NOT "Instant Wi-Fi" and "OFFER", tempRespListOffer is NULL? ' + tempRespListOffer==null + '\n AND tempRespListOffer?.size() = ' + tempRespListOffer?.size());
        List<BRAIN_FA_Response__c> testRespListOffer = [SELECT Id, Name, 
                                                         BRAIN_ID__c,
                                                         hl1EvaluationResult__c,
                                                         errorCode__c, errorMessage__c,
                                                         responseDate__c, status__c,
                                                         BRAIN_API_Call_Tracker_Master__c,
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.API_Transaction__c
                                                   FROM BRAIN_FA_Response__c];
        if (testRespListOffer != null && testRespListOffer.size() > 0) {
            for (Integer t = 0; t < testRespListOffer.size(); t++) {
                for (Integer c = 0; c < testCallListOffer.size(); c++) {
                    if (testRespListOffer.get(t).BRAIN_API_Call_Tracker_Master__c == testCallListOffer.get(c).Id) {
                		testCallListOffer.get(c).BRAIN_FA_Response__c = testRespListOffer.get(t).Id;
                    }
                }
            }
            update testCallListOffer;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_FA_Response__c for "Standard" NOT "Instant Wi-Fi" and "OFFER" for Opportunity ' + mockTestOpptyTitle);
        }
        System.debug('(TEST***SETUP) Prior to querying for Offers-with-AssociatedCD-for-BAU for "Standard" NOT "Instant Wi-Fi" and "OFFER", the testingCDId = ' + testingCDId + '   AND testingOfferId = ' + testingOfferId);
        List<Offer__c> offerCapEvalList = [SELECT Id, Name, OwnerId, 
                                           		BRAIN_API_Call_Tracker_Master__c,
                                           		Offer_Total_Units__c, 
												Offer_Type__c, Offer_Status__c,                                                
                                                Other_Provider_Contract_Type__c,
                                                Contract_Term__c,
                                                Data_Bounty_Amount_Approved__c, 
                                                Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                                Requested_Bulk_Data_Price_Approved__c,
                                                Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                                Opportunity__r.Id, 
                                                Contract__r.EndDate,
                                                Flat_Revenue_Share_Approved__c,
                                                Revenue_Share_Agent_Commission_Rate__c,
                                                Revenue_Share_MIN_Penetration_Rate__c,
                                                Revenue_Share_MAX_Penetration_Rate__c,
                                                Associated_Capital_Design__c,
                                                Associated_Capital_Design__r.Name,
                                                Associated_Capital_Design__r.Actual_Build_Out_Months__c,
                                                Associated_Capital_Design__r.Core_Switch_Electronics__c,
                                                Associated_Capital_Design__r.Transport_Interoffice_Fiber__c,
                                                Associated_Capital_Design__r.CO_Electronics__c,
                                                Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c,
                                                Associated_Capital_Design__r.Remote_Electronics__c,
                                                Associated_Capital_Design__r.Total_Cottage_Rental_Units__c, 
                                                Associated_Capital_Design__r.Total_Tower_Rental_Units__c, 
                                                Associated_Capital_Design__r.Total_SFH_Rental_Units__c,
                                                Associated_Capital_Design__r.Total_Cottage_Owner_Units__c, 
                                                Associated_Capital_Design__r.Total_Tower_Owner_Units__c, 
                                                Associated_Capital_Design__r.Total_SFH_Owner_Units__c, 
                                                Associated_Capital_Design__r.Service_Delivery__c, 
                                                Associated_Capital_Design__r.Distribution_F2__c, 
                                                Associated_Capital_Design__r.F1_Footage_ft__c,
                                                Associated_Capital_Design__r.F2_Footage_ft__c,
                                                Associated_Capital_Design__r.Distribution_Structure_Conduit__c,
                                           		Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c,
                                                Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c,
                                                Associated_Capital_Design__r.Other_MDU_F4__c, 
                                                Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                                Associated_Capital_Design__r.OP_F2_Total_Cost_Combined_Cost__c,
                                                Associated_Capital_Design__r.OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                                Associated_Capital_Design__r.OP_F3_Total_Cost_Comb_Cost__c,
                                                Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c, 
                                                Associated_Capital_Design__r.Network_Investment__c, 
                                                Associated_Capital_Design__r.Technology_Type__c, 
                                                Associated_Capital_Design__r.Service_Type__c,                     
                                                Associated_Capital_Design__r.MDU_ONT_Drop__c,
                                                Associated_Capital_Design__r.Access_Type__c,
                                                Associated_Capital_Design__r.F1_Feeder_Type__c,
                                                Associated_Capital_Design__r.Cluster_ID__c,
                                                Associated_Capital_Design__r.Cluster_Not_Available__c,
                                                Associated_Capital_Design__r.Development_Status__c,
                                                Associated_Capital_Design__r.Building_Style__c,
                                           		Associated_Capital_Design__r.ONT_Model__c,
                                                Associated_Capital_Design__r.Occupant_Type__c,
                                                Associated_Capital_Design__r.Access_Cost__c,
                                                Associated_Capital_Design__r.IP_CapEx_Shared__c,
                                                Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c,
                                                Associated_Capital_Design__r.Wireless_Access_Points_Cost__c,
                                                Associated_Capital_Design__r.BCET_Wire_Center__c,
                                                Associated_Capital_Design__r.One_Time_Additional_Expense__c,
                                                Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c
	                            	       FROM Offer__c
    	                                   WHERE (Associated_Capital_Design__r.Capital_Design_Type__c = 'Standard' 
                                             AND Associated_Capital_Design__r.Technology_Type__c != 'Instant Wi-Fi'
                                             AND Associated_Capital_Design__c != null
                                             AND BRAIN_API_Call_Tracker_Master__c != null)];                                          
        System.debug('(TEST***SETUP) for "Standard" NOT "Instant Wi-Fi" and "OFFER", offerCapEvalList == null??? ' + (offerCapEvalList == null) + '\n  offerCapEvalList?.size() = ' + offerCapEvalList?.size());
        System.debug('(TEST***SETUP) End setting up for Non-IWF Offers');

		/***** Standard Instant Wi-Fi Capital Designs *****/
        System.debug('(TEST***SETUP) Now setting up for "Standard" "Instant Wi-Fi" Capital Designs');
        List<BRAIN_API_Call_Tracker__c>	tempCallListIWF = TestDataFactory.createBaseBrainAPICallTracker(2, True);
        System.debug('(TEST***SETUP) AFTER BACT create for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", tempCallList is NULL? ' + tempCallListIWF==null + ' \n AND tempCallList?.size() = ' + tempCallList?.size());
        List<Offer__c> tempOfferListIWF = TestDataFactory.createOffersForBRAINTests(testOpportunityList, 2, True);
        System.debug('(TEST***SETUP) AFTER initial Offer insert for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", tempOfferListIWF is NULL? ' + tempOfferListIWF==null + 
                     					'\n  AND tempOfferListIIWF?.size() = ' + tempOfferListIWF?.size());
        List<Capital_Design__c> tempCDListIWF = new List<Capital_Design__c>();
        CapitalDesignTriggerHandler.TriggerDisabled = true;
        for (Integer iwf=0; iwf<tempOfferListIWF.size(); iwf++) {
            List<Capital_Design__c> prepCDListIWF = TestDataFactory.createIWFCapitalDesignsWithBRAINDefaults(testOpportunityList?.get(iwf+14)?.Id, tempCallListIWF?.get(iwf)?.Id, 1, True);
            tempCDListIWF.add(prepCDListIWF?.get(0));
        }
        CapitalDesignTriggerHandler.TriggerDisabled = false;
        System.debug('(TEST***SETUP) AFTER initial CD insert for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", tempCDListIWF is NULL? ' + tempCDListIWF==null + 
                                            '\n AND tempCDListIWF?.size() = ' + tempCDListIWF?.size());
        List<Capital_Design__c> testCDListIWF = [SELECT Id, Name, OwnerId, 
                                        BRAIN_API_Call_Tracker_Master__c,
                                        Opportunity__r.Property__r.Primary_Address_State__c,
                                        Offer__r.Offer_Total_Units__c, 
                                        Offer__r.Offer_Type__c,
                                        Offer__r.Offer_Status__c,
                                        Offer__r.Other_Provider_Contract_Type__c, 
                                        Offer__r.Contract_Term__c,
                                        Offer__r.Data_Bounty_Amount__c, 
                                        Offer__r.Bulk_Data_Speed_Profile_DL_UL__c,
                                        Offer__r.Requested_Bulk_Data_Price__c,
                                        Offer__r.Prepaid_Marketing_Fee_Per_Unit__c,
                                        Offer__r.Opportunity__r.Id, 
                                        Offer__r.Contract__r.EndDate,
                                        Offer__r.Flat_Revenue_Share__c,
                                        Offer__r.Revenue_Share_Agent_Commission_Rate__c,
                                        Offer__r.Revenue_Share_MIN_Penetration_Rate__c,
                                        Offer__r.Revenue_Share_MAX_Penetration_Rate__c,
                                        Actual_Build_Out_Months__c,
                                        Core_Switch_Electronics__c,
                                        Transport_Interoffice_Fiber__c,
                                        CO_Electronics__c,
                                        Feeder_F1_Access_and_or_PON__c,
                                        Remote_Electronics__c,
                                        Total_Cottage_Rental_Units__c, 
                                        Total_Tower_Rental_Units__c, 
                                        Total_SFH_Rental_Units__c,
                                        Total_Cottage_Owner_Units__c, 
                                        Total_Tower_Owner_Units__c, 
                                        Total_SFH_Owner_Units__c, 
                                        Service_Delivery__c, 
                                        Distribution_F2__c, 
                                        F1_Footage_ft__c,
                                        F2_Footage_ft__c,
                                        Distribution_Structure_Conduit__c,
                                     	Electronics_Shelf_UPS_Cost__c,
                                        F4_Inside_Wiring_SFH__c,
                                        Other_MDU_F4__c,
                                        OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                        OP_F2_Total_Cost_Combined_Cost__c,
                                        OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                        OP_F3_Total_Cost_Comb_Cost__c,
                                        for_SFU_Average_Lot_Size__c, 
                                        Network_Investment__c, 
                                        Technology_Type__c, 
                                        Service_Type__c,                     
                                        MDU_ONT_Drop__c,
                                        Access_Type__c,
                                        F1_Feeder_Type__c,
                                        Cluster_ID__c,
                                        Cluster_Not_Available__c,
                                        Development_Status__c,
                                        Building_Style__c,
                                        Occupant_Type__c,
                                        //The InstantWiFi-specific fields are listed together below 
                                        Access_Cost__c,
                                        IP_CapEx_Shared__c,
                                        IP_NetEx_Shared_MRC__c,
                                        Wireless_Access_Points_Cost__c,
                                        BCET_Wire_Center__c,
                                        One_Time_Additional_Expense__c,
                                        Recurring_Additional_Expenses_Monthly__c,
                                        //The NMA-specific fields are listed together below 
                                        Capital_Design_Type__c,
                                        Property_Name__c,
                                        Product__c,
                                        Planned_Build_Out_Years__c,
                                        Wire_Center_CLLI_Code__c,
                                        Latitude_NM__c,
                                        Longitude_NM__c,
                                        Service_Delivery_NM__c,
                                        Max_Downstream_Speed_NM__c,
                                        Total_Cottage_Rental_Units_NM__c, 
                                        Total_Tower_Rental_Units_NM__c, 
                                        Total_SFH_Rental_Units_NM__c,
                                        Total_Cottage_Owner_Units_NM__c, 
                                        Total_Tower_Owner_Units_NM__c, 
                                        Total_SFH_Owner_Units_NM__c                                                                
                                   FROM Capital_Design__c
                                  WHERE Capital_Design_Type__c = 'Standard' AND Technology_Type__c = 'Instant Wi-Fi'];
        if (testCDListIWF != null && testCDListIWF.size() > 0) {            
            for (Integer t = 0; t < testCDListIWF.size(); t++) {
                System.debug('(TEST***SETUP) AFTER initial CD insert for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", testCDListIWF.get('+t+').Id = ' + testCDListIWF.get(t)?.Id + 
                             '\n  AND testCDListIWF.get('+t+')?.Name = ' + testCDListIWF.get(t)?.Name + 
                             '\n  AND testCDListIWF.get('+t+')?.Offer__c = ' + testCDListIWF.get(t)?.Offer__c +
                             '\n  AND testCDListIWF.get('+t+')?.Technology_Type__c = ' + testCDListIWF.get(t)?.Technology_Type__c +
                             '\n  AND testCDListIWF.get('+t+')?.Capital_Design_Type__c = ' + testCDListIWF.get(t)?.Capital_Design_Type__c +
                             '\n  AND testCDListIWF.get('+t+')?.Opportunity__r.Property__r.Primary_Address_State__c = ' + testCDListIWF.get(t)?.Opportunity__r.Property__r.Primary_Address_State__c);
            }
        }
        if (tempCallListIWF != null && tempCallListIWF.size() > 0) {
            for (Integer t = 0; t < tempCallListIWF.size(); t++) {
		        System.debug('(TEST***SETUP) AFTER BACT create, tempCallListIWF?.get('+t+')?.Name = ' + tempCallListIWF?.get(t)?.Name +
                         '\n  AND tempCallListIWF?.get('+t+')?.Id = ' + tempCallListIWF?.get(t)?.Id);
                for (Capital_Design__c cd : testCDListIWF) {
                    cd.BRAIN_API_Call_Tracker_Master__c = tempCallListIWF?.get(t).Id;
                    cd.Primary_Address_State_Name__c = mockTestPrmryStateName;
                }
            }
	        CapitalDesignTriggerHandler.TriggerDisabled = true;
            update testCDListIWF;
	        CapitalDesignTriggerHandler.TriggerDisabled = false;
            for (BRAIN_API_Call_Tracker__c bact : tempCallListIWF) {
                bact.Capital_Design__c = testingIWFCDId;
            }
            update tempCallListIWF;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_API_Call_Tracker__c for "Standard" "Instant WiFi" Capital-Designs');
        }
        List<BRAIN_API_Call_Tracker__c>	testCallListIWF = [SELECT Id, Name, OwnerId, Offer__c, 
                                                                     Capital_Design__c,
                                                                     Capital_Design__r.Capital_Design_Type__c,
                                                                     BRAIN_FA_Request__c,
                                                                     BRAIN_FA_Request__r.sourceSystemIdType__c,
                                                                     BRAIN_FA_Response__c,
                                                                     API_Transaction__c,
                                                                     CreatedById, LastModifiedById
                                                                FROM BRAIN_API_Call_Tracker__c
                                                               WHERE (Capital_Design__r.Capital_Design_Type__c = 'Standard'
                                                                 AND Capital_Design__r.Technology_Type__c = 'Instant Wi-Fi'
                                                                 AND Capital_Design__c != NULL)];        
        System.debug('(TEST***SETUP) AFTER BACT create, testCallListIWF is NULL? ' + (testCallListIWF==null) + '\n  AND testCallListIWF?.size() = ' + testCallListIWF?.size());
        if (testCallListIWF != null && testCallListIWF.size() > 0) {
            for (Integer t = 0; t < testCallListIWF.size(); t++) {
		        System.debug('(TEST***SETUP) AFTER temp-BACT update, retrieved testCallListIWF?.get('+t+')?.Name = ' + testCallListIWF?.get(t)?.Name +
                         '\n  AND testCallListIWF?.get('+t+')?.Id = ' + testCallListIWF?.get(t)?.Id);
            }
        } else {
            System.debug('(TEST***SETUP) Unable to retrieve updated test data for BRAIN_API_Call_Tracker__c for "Standard" "Instant WiFi" Capital-Designs');
        }
        if (tempOfferListIWF != null && tempOfferListIWF.size() > 0) {            
            for (Integer t = 0; t < tempOfferListIWF.size(); t++) {
                for (Capital_Design__c cd : testCDListIWF) {
                    if (cd.Offer__c == tempOfferListIWF.get(t).Id) {
                        tempOfferListIWF.get(t).Associated_Capital_Design__c = cd.Id;
                        tempOfferListIWF.get(t).BRAIN_API_Call_Tracker_Master__c = cd.BRAIN_API_Call_Tracker_Master__c;
                    }
                }
            }
            update tempOfferListIWF;
            for (Integer t = 0; t < tempOfferListIWF.size(); t++) {
		        System.debug('(TEST***SETUP) AFTER tempOfferList update for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", ' +
                     '\n  tempOfferListIWF.get('+t+').Name = ' + tempOfferListIWF.get(t).Name +
                     '\n  AND tempOfferListIWF.get('+t+').Id = ' + tempOfferListIWF.get(t).Id +
                     '\n  AND tempOfferListIWF.get('+t+').Associated_Capital_Design__c = ' + tempOfferListIWF.get(t).Associated_Capital_Design__c);
            }
        }
        List<Offer__c> testOfferListIWF = [SELECT Id, Name, OwnerId, 
                                                Associated_Capital_Design__c,
                                                Associated_Capital_Design__r.Name,
                                                Associated_Capital_Design__r.Capital_Design_Type__c,
                                                Associated_Capital_Design__r.Technology_Type__c,
                                                BRAIN_API_Call_Tracker_Master__c, 
                                                Brain_ID__c,
                                                CapEx_Direct__c,
                                                Cumulative_NPV__c,
                                                Discounted_Payback_months__c,
                                                EBITDA_Margin__c,
                                                Financial_Viability__c,
                                                IRR__c,
                                                Incremental_ATC_To_Meet_Guardrail__c,
                                                Simple_Payback_Months__c,
                                                X1st_Year_of_Positive_EBITDA__c,
                                                X1st_Year_of_Positive_FCF__c
	                                        FROM Offer__c
    	                                   WHERE (Associated_Capital_Design__r.Capital_Design_Type__c = 'Standard' 
                                             AND Associated_Capital_Design__r.Technology_Type__c = 'Instant Wi-Fi')];
        System.debug('(TEST***SETUP) AFTER Offer insert for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", testOfferListIWF is NULL? ' + (testOfferListIWF==null) +
                     '\n  AND testOfferListIWF?.size() = ' + testOfferListIWF?.size());
        if (testOfferListIWF != null && testOfferListIWF.size() > 0) {
            for (Integer t = 0; t < testOfferListIWF.size(); t++) {
                System.debug('(TEST***SETUP) AFTER Offer insert for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", testOfferListIWF.get('+t+').Name = ' + testOfferListIWF.get(t).Name +
                         '\n  AND testOfferListIWF.get('+t+').Id = ' + testOfferListIWF.get(t).Id +
                         '\n  AND testOfferListIWF.get('+t+').Associated_Capital_Design__c = ' + testOfferListIWF.get(t).Associated_Capital_Design__c +
                         '\n  AND testOfferListIWF.get('+t+').Associated_Capital_Design__r.Name = ' + testOfferListIWF.get(t).Associated_Capital_Design__r.Name);
            }
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for Offer for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN" for Opportunity ' + mockTestOpptyTitle);
        }
        testCDListIWF = [SELECT Id, Name, OwnerId, 
                         				BRAIN_API_Call_Tracker_Master__c,
                                        Opportunity__r.Property__r.Primary_Address_State__c,
                                        Offer__r.Offer_Total_Units__c, 
                                        Offer__r.Offer_Type__c,
                                        Offer__r.Offer_Status__c,
                                        Offer__r.Other_Provider_Contract_Type__c, 
                                        Offer__r.Contract_Term__c,
                                        Offer__r.Data_Bounty_Amount__c, 
                                        Offer__r.Bulk_Data_Speed_Profile_DL_UL__c,
                                        Offer__r.Requested_Bulk_Data_Price__c,
                                        Offer__r.Prepaid_Marketing_Fee_Per_Unit__c,
                                        Offer__r.Opportunity__r.Id, 
                                        Offer__r.Contract__r.EndDate,
                                        Offer__r.Flat_Revenue_Share__c,
                                        Offer__r.Revenue_Share_Agent_Commission_Rate__c,
                                        Offer__r.Revenue_Share_MIN_Penetration_Rate__c,
                                        Offer__r.Revenue_Share_MAX_Penetration_Rate__c,
                                        Actual_Build_Out_Months__c,
                                        Core_Switch_Electronics__c,
                                        Transport_Interoffice_Fiber__c,
                                        CO_Electronics__c,
                                        Feeder_F1_Access_and_or_PON__c,
                                        Remote_Electronics__c,
                                        Total_Cottage_Rental_Units__c, 
                                        Total_Tower_Rental_Units__c, 
                                        Total_SFH_Rental_Units__c,
                                        Total_Cottage_Owner_Units__c, 
                                        Total_Tower_Owner_Units__c, 
                                        Total_SFH_Owner_Units__c, 
                                        Service_Delivery__c, 
                                        Distribution_F2__c, 
                                        F1_Footage_ft__c,
                                        F2_Footage_ft__c,
                                        Distribution_Structure_Conduit__c,
                                        Electronics_Shelf_UPS_Cost__c,
                                        F4_Inside_Wiring_SFH__c,
                                        Other_MDU_F4__c,
                                        OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                        OP_F2_Total_Cost_Combined_Cost__c,
                                        OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                        OP_F3_Total_Cost_Comb_Cost__c,
                                        for_SFU_Average_Lot_Size__c, 
                                        Network_Investment__c, 
                                        Technology_Type__c, 
                                        Service_Type__c,                     
                                        MDU_ONT_Drop__c,
                                        Access_Type__c,
                                        F1_Feeder_Type__c,
                                        Cluster_ID__c,
                                        Cluster_Not_Available__c,
                                        Development_Status__c,
                                        Building_Style__c,
                                        Occupant_Type__c,
                                        //The InstantWiFi-specific fields are listed together below 
                                        Access_Cost__c,
                                        IP_CapEx_Shared__c,
                                        IP_NetEx_Shared_MRC__c,
                                        Wireless_Access_Points_Cost__c,
                                        BCET_Wire_Center__c,
                                        One_Time_Additional_Expense__c,
                                        Recurring_Additional_Expenses_Monthly__c,
                                        //The NMA-specific fields are listed together below 
                                        Capital_Design_Type__c,
                                        Property_Name__c,
                                        Product__c,
                                        Planned_Build_Out_Years__c,
                                        Wire_Center_CLLI_Code__c,
                                        Latitude_NM__c,
                                        Longitude_NM__c,
                                        Service_Delivery_NM__c,
                                        Max_Downstream_Speed_NM__c,
                                        Total_Cottage_Rental_Units_NM__c, 
                                        Total_Tower_Rental_Units_NM__c, 
                                        Total_SFH_Rental_Units_NM__c,
                                        Total_Cottage_Owner_Units_NM__c, 
                                        Total_Tower_Owner_Units_NM__c, 
                                        Total_SFH_Owner_Units_NM__c                                                                
                                   FROM Capital_Design__c
                                  WHERE (Capital_Design_Type__c = 'Standard' 
                                    AND Technology_Type__c = 'Instant Wi-Fi')];
        if (testCDListIWF != null && testCDListIWF.size() > 0) {
            for(Integer t = 0; t < testCDListIWF.size(); t++) {
		        System.debug('(TEST***SETUP) AFTER Query CD before BACT Create for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", testCDListIWF.get('+t+').Id = ' + testCDListIWF.get(t)?.Id + 
                     	 '\n  AND testCDListIWF.get('+t+')?.Name = ' + testCDListIWF.get(t)?.Name + 
                         '\n  AND testCDListIWF.get('+t+')?.Offer__c = ' + testCDListIWF.get(t)?.Offer__c +
                         '\n  AND testCDListIWF.get('+t+')?.Technology_Type__c = ' + testCDListIWF.get(t)?.Technology_Type__c +
                         '\n  AND testCDListIWF.get('+t+')?.Capital_Design_Type__c = ' + testCDListIWF.get(t)?.Capital_Design_Type__c +
                         '\n  AND testCDListIWF.get('+t+')?.Opportunity__r.Property__r.Primary_Address_State__c = ' + testCDListIWF.get(t)?.Opportunity__r.Property__r.Primary_Address_State__c);
            }
        }
        List<BRAIN_FA_Request__c> tempReqListIWF = TestDataFactory.createBrainFARequest(testCDListIWF, null, testCDListIWF.size(), True);                                    
        System.debug('(TEST***SETUP) AFTER Offer insert for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", tempReqListIWF is NULL? ' + (tempReqListIWF==null) +
                     '\n  AND tempReqListIWF?.size() = ' + tempReqListIWF?.size());
        List<BRAIN_FA_Request__c> testReqListIWF = [SELECT Id, Name, sourceSystem__c, cuid__c, financialMetricCurrencyCode__c, 
                                                         financialMetricCurrencyExchangeDate__c, 
                                                         sourceSystemId__c, sourceSystemIdType__c,
                                                         analysisOverride__c, opportunityTitle__c,
                                                         BRAIN_API_Call_Tracker_Master__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Technology_Type__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.API_Transaction__c, 
                                                         Constructed_JSON__c
                                                   FROM BRAIN_FA_Request__c 
                                                  WHERE (sourceSystemIdType__c = 'CAPITAL-DESIGN'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Technology_Type__c = 'Instant Wi-Fi'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Standard')];
        System.debug('(TEST***SETUP) AFTER Request create for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", testReqListIWF is NULL? ' + (testReqListIWF==null) + 
                     			'\n  AND testReqListIWF?.size() = ' + testReqListIWF?.size());
        if (testReqListIWF != null && testReqListIWF.size() > 0) {
            for (Integer t = 0; t < testReqListIWF.size(); t++) {
                System.debug('(TEST***SETUP) AFTER Request create for "Standard" "Instant Wi-Fi" and "OFFER", set testingIWFFARequestName = ' + testReqListIWF.get(t).Name +
                             '\n  AND testingIWFFARequestId = ' + testReqList.get(t).Id);
                if (testReqListIWF.get(t).sourceSystemId__c == null) {
                    testReqListIWF.get(t).sourceSystemId__c = testOpportunityList.get(t).Id;    
                }
                if (testReqListIWF.get(t).sourceSystemIdType__c == null) {
                    testReqListIWF.get(t).sourceSystemIdType__c = 'OPPORTUNITY';
                }
                testReqListIWF.get(t).opportunityTitle__c = testOpportunityList.get(t).Name;
                testReqListIWF.get(t).Constructed_JSON__c = '{ "sourceSystem":"' + testReqListIWF.get(t).sourceSystem__c + '", ' + 
                    '"cuid":"' + testReqListIWF.get(t).cuid__c + '", ' +
                    '"financialMetricCurrencyCode":"' + testReqListIWF.get(t).financialMetricCurrencyCode__c + '", ' + 
                    '"financialMetricCurrencyExchangeDate":null, ' +
                    '"sourceSystemId":"' + testReqListIWF.get(t).sourceSystemId__c + '", ' + 
                    '"sourceSystemIdType":"' + testReqListIWF.get(t).sourceSystemIdType__c + '", ' +
                    '"analysisOverride":null, "opportunityTitle":"' + testOpportunityList.get(t).Name + '", ' + 
                    '"hl2Items":[ { "sourceSystemId":"' + testReqListIWF.get(t).sourceSystemId__c + '", ' +
                    '"sourceSystemIdType":"' + testReqListIWF.get(t).sourceSystemIdType__c + '", ' +
                    '"latitude":' + mockTestPptyLat + ', "longitude":' + mockTestPptyLong + ', ' + 
                    '"wireCenterCLLI":"' + mockTestNWCCLLI + '", "constructionMonths":24, "currencyCode":"USD", "coreElectronicsCost":0.00, "interofficeFiberCost":0.00, ' + 
                    '"coElectronicsCost":9360.00, "f1FeederCost":25414.00, "remoteElectronicsCost":0.00, "hl2ItemOverride":null, "hl3Items":[ { "quantity":' + mockTestPptyTtlUnits + ', ' + 
                    '"constructionType":"MDU", "ctlOn":false, "currencyCode":"USD", "f2Cost":0.00, "f2CostSource":"PROVIDED", "f2Footage":800.00, ' + 
                    '"insideWiringCapEx":54380.5875, "ontType":null, "dropCost":0, "dropCostSource":"PROVIDED", "additionalOpExNrc":18098.70, ' + 
                    '"additionalOpExMrc":0, "occupantType":"CONSUMER", "lotFrontageFeet":0, "maxDownstreamSpeedKbps":1000000, "clusterId":null, ' + 
                    '"fdhCost":0.01, "splitterCost":0.01, "splitterPorts":1, "idfElectronicsCost":0.01, "wirelessAccessPointsCost":0.01, "networkInvestmentType":"NEW DEVELOPMENT", ' + 
                    '"productType":"FTTH", "contractType":"COMPETITIVE LOSS", "contractTermMonths":0, "marketingFees":null, ' +
                    '"hl3ItemOverride":null, "demographics": [ { "quantity":' + mockTestPptyTtlUnits + ', "rental":true, "incomeLevel":0  } ] } ] } ] }';										
                System.debug('(TEST***SETUP) For testReqListIWF.get(' + t + ').Name = ' + testReqListIWF.get(t).Name +
                             '\n testReqListIWF.get(' + t + ').Constructed_JSON__c = ' + testReqListIWF.get(t).Constructed_JSON__c);
            }
            update testReqListIWF;
            for (Integer t = 0; t < testReqListIWF.size(); t++) {
                for (Integer c = 0; c < testCallListIWF.size(); c++) {
                    if (testReqListIWF.get(t).BRAIN_API_Call_Tracker_Master__c == testCallListIWF.get(c).Id) {
                		testCallListIWF.get(c).BRAIN_FA_Request__c = testReqListIWF.get(t).Id;
                    }
                }
            }
            update testCallListIWF;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_FA_Request__c for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN" for Opportunity ' + mockTestOpptyTitle);
        }
        List<BRAIN_FA_Response__c> tempRespListIWF = TestDataFactory.createBrainFAResponse(testCallListIWF, testCallListIWF.size(), True);                                    
        System.debug('(TEST***SETUP) AFTER Offer insert for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", tempRespListIWF is NULL? ' + (tempRespListIWF==null) +
                     '\n  AND tempRespListIWF?.size() = ' + tempRespListIWF?.size());
        List<BRAIN_FA_Response__c> testRespListIWF = [SELECT Id, Name, 
                                                         BRAIN_ID__c,
                                                         hl1EvaluationResult__c,
                                                         errorCode__c, errorMessage__c,
                                                         responseDate__c, status__c,
                                                         BRAIN_API_Call_Tracker_Master__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.API_Transaction__c
                                                   FROM BRAIN_FA_Response__c];
        if (testRespListIWF != null && testRespListIWF.size() > 0) {
            for (Integer t = 0; t < testRespListIWF.size(); t++) {
                for (Integer c = 0; c < testCallListIWF.size(); c++) {
                    if (testRespListIWF.get(t).BRAIN_API_Call_Tracker_Master__c == testCallListIWF.get(c).Id) {
                		testCallListIWF.get(c).BRAIN_FA_Response__c = testRespListIWF.get(t).Id;
                    }
                }
            }
            update testCallListIWF;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_FA_Response__c for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN" for Opportunity ' + mockTestOpptyTitle);
        }
        
        //for Offer
        System.debug('(TEST***SETUP) Now setting up for Offers for Instant Wi-Fi');
        List<BRAIN_API_Call_Tracker__c>	tempCallListOfferIWF = TestDataFactory.createBrainAPICallTracker(testCDListIWF, testOfferListIWF, testOfferListIWF.size(), True);
        System.debug('(TEST***SETUP) AFTER Offer insert for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", tempCallListOfferIWF is NULL? ' + (tempCallListOfferIWF==null) +
                     '\n  AND tempCallListOfferIWF?.size() = ' + tempCallListOfferIWF?.size());
        if (tempCallListOfferIWF != null && tempCallListOfferIWF.size() > 0) {
            for (Integer t = 0; t < tempCallListOfferIWF.size(); t++) {
                System.debug('(TEST***SETUP) AFTER BACT create, tempCallListOfferIWF?.get(t)?.Name = ' + tempCallListOfferIWF?.get(t)?.Name +
                             '\n  AND tempCallListOfferIWF?.get(t)?.Id = ' + tempCallListOfferIWF?.get(t)?.Id);
                System.debug('(TEST***SETUP) AFTER BACT create, set testingIWFBACTNameForOffer = ' + tempCallListOfferIWF.get(t).Name + '\n  AND testingIWFBACTIdForOffer = ' + tempCallListOfferIWF.get(t).Id);
                for (Offer__c offer : tempOfferListIWF) {
                    offer.Associated_Capital_Design__c = testingIWFCDId;
                    if (tempCallListOfferIWF.get(t).Offer__c == offer.Id) {
	                    offer.BRAIN_API_Call_Tracker_Master__c = tempCallListOfferIWF.get(t).Id;
                    }
                }
            }
            update testOfferListIWF;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_API_Call_Tracker__c for "Standard" "Instant WiFi" Offer ' + testingIWFOfferName);
        }
        List<BRAIN_API_Call_Tracker__c>	testCallListOfferIWF = [SELECT Id, Name, OwnerId, Offer__c, 
                                                                     Capital_Design__c,
                                                                     Capital_Design__r.Capital_Design_Type__c,
                                                                     BRAIN_FA_Request__c,
                                                                     BRAIN_FA_Request__r.sourceSystemIdType__c,
                                                                     BRAIN_FA_Response__c,
                                                                     API_Transaction__c,
                                                                     CreatedById, LastModifiedById
                                                                FROM BRAIN_API_Call_Tracker__c
                                                               WHERE (Capital_Design__r.Capital_Design_Type__c = 'Standard'
                                                                 AND Capital_Design__r.Technology_Type__c = 'Instant Wi-Fi'
                                                                 AND Offer__c != NULL)];
        System.debug('(TEST***SETUP) AFTER BACT create for "Standard" "Instant Wi-Fi" and "OFFER", testCallListOfferIWF is NULL? ' + (testCallListOfferIWF==null) + '\n  AND testCallListOfferIWF?.size() = ' + testCallListOfferIWF?.size());
        if (testCallListOfferIWF != null && testCallListOfferIWF.size() > 0) {
            for (Integer t = 0; t < testCallListOfferIWF.size(); t++) {
		        System.debug('(TEST***SETUP) AFTER temp-BACT update, retrieved testCallListOfferIWF?.get('+t+')?.Name = ' + testCallListOfferIWF?.get(t)?.Name + '\n  AND testCallListOfferIWF?.get('+t+')?.Id = ' + testCallListOfferIWF?.get(t)?.Id);
            }
        } else {
            System.debug('(TEST***SETUP) Unable to retrieve updated test data for BRAIN_API_Call_Tracker__c for "Standard" "Instant WiFi" Offers');
        }
        List<BRAIN_FA_Request__c> tempReqListOfferIWF = TestDataFactory.createBrainFARequest(testCDListIWF, testOfferListIWF, testOfferListIWF.size(), True);                                    
        System.debug('(TEST***SETUP) AFTER Offer insert for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", tempReqListOfferIWF is NULL? ' + (tempReqListOfferIWF==null) +
                     '\n  AND tempReqListOfferIWF?.size() = ' + tempReqListOfferIWF?.size());
        List<BRAIN_FA_Request__c> testReqListOfferIWF = [SELECT Id, Name, sourceSystem__c, cuid__c, financialMetricCurrencyCode__c, 
                                                         financialMetricCurrencyExchangeDate__c, 
                                                         sourceSystemId__c, sourceSystemIdType__c,
                                                         analysisOverride__c, opportunityTitle__c,
                                                         BRAIN_API_Call_Tracker_Master__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.API_Transaction__c, 
                                                         Constructed_JSON__c
                                                   FROM BRAIN_FA_Request__c 
                                                  WHERE (sourceSystemIdType__c = 'OFFER'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Standard'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Technology_Type__c = 'Instant Wi-Fi')];
        System.debug('(TEST***SETUP) AFTER Request create for "Standard" "Instant Wi-Fi" and "OFFER", testReqListOfferIWF is NULL? ' + (testReqListOfferIWF==null) + 
                     			'\n  AND testReqListOfferIWF?.size() = ' + testReqListOfferIWF?.size());
        if (testReqListOfferIWF != null && testReqListOfferIWF.size() > 0) {
            for (Integer t = 0; t < testReqListOfferIWF.size(); t++) {
                System.debug('(TEST***SETUP) AFTER Request create for "Standard" NOT "Instant Wi-Fi" and "OFFER", set testingIWFFARequestNameForOffer = ' + testReqListOfferIWF.get(t).Name +
                             '\n  AND testingIWFFARequestIdForOffer = ' + testReqListOffer.get(t).Id);
                if (testReqListOfferIWF.get(t).sourceSystemId__c == null) {
                    testReqListOfferIWF.get(t).sourceSystemId__c = testCallListOfferIWF.get(t).Id;    
                }
                if (testReqListOfferIWF.get(t).sourceSystemIdType__c == null) {
                    testReqListOfferIWF.get(t).sourceSystemIdType__c = 'OPPORTUNITY';
                }
                testReqListOfferIWF.get(t).opportunityTitle__c = testOpportunityList.get(t).Name;
                testReqListOfferIWF.get(t).BRAIN_API_Call_Tracker_Master__c = testingIWFBACTIdForOffer;
                testReqListOfferIWF.get(t).Constructed_JSON__c = '{ "sourceSystem":"' + testReqListOfferIWF.get(t).sourceSystem__c + '", ' + 
                    '"cuid":"' + testReqListOfferIWF.get(t).cuid__c + '", ' +
                    '"financialMetricCurrencyCode":"' + testReqListOfferIWF.get(t).financialMetricCurrencyCode__c + '", ' + 
                    '"financialMetricCurrencyExchangeDate":null, ' +
                    '"sourceSystemId":"' + testReqListOfferIWF.get(t).sourceSystemId__c + '", ' + 
                    '"sourceSystemIdType":"' + testReqListOfferIWF.get(t).sourceSystemIdType__c + '", ' +
                    '"analysisOverride":null, "opportunityTitle":"' + testOpportunityList.get(t).Name + '", ' + 
                    '"hl2Items":[ { "sourceSystemId":"' + testReqListOfferIWF.get(t).sourceSystemId__c + '", ' +
                    '"sourceSystemIdType":"' + testReqListOfferIWF.get(t).sourceSystemIdType__c + '", ' +
                    '"latitude":' + mockTestPptyLat + ', "longitude":' + mockTestPptyLong + ', ' + 
                    '"wireCenterCLLI":"' + mockTestNWCCLLI + '", "constructionMonths":24, "currencyCode":"USD", "coreElectronicsCost":0.00, "interofficeFiberCost":0.00, ' + 
                    '"coElectronicsCost":9360.00, "f1FeederCost":25414.00, "remoteElectronicsCost":0.00, "hl2ItemOverride":null, "hl3Items":[ { "quantity":' + mockTestPptyTtlUnits + ', ' + 
                    '"constructionType":"MDU", "ctlOn":false, "currencyCode":"USD", "f2Cost":0.00, "f2CostSource":"PROVIDED", "f2Footage":800.00, ' + 
                    '"insideWiringCapEx":54380.5875, "ontType":null, "dropCost":0, "dropCostSource":"PROVIDED", "additionalOpExNrc":18098.70, ' + 
                    '"additionalOpExMrc":0, "occupantType":"CONSUMER", "lotFrontageFeet":0, "maxDownstreamSpeedKbps":1000000, "clusterId":null, ' + 
                    '"fdhCost":0.01, "splitterCost":0.01, "splitterPorts":1, "idfElectronicsCost":0.01, "wirelessAccessPointsCost":0.01, "networkInvestmentType":"NEW DEVELOPMENT", ' + 
                    '"productType":"FTTH", "marketingFees":{  "currencyCode":"USD", "doorFeePerUnit":32.55, ' +
                    '"firstInstallBountyPerUnit":75.00, "serviceRevenueShares":[ {  "minPenetrationRate":0.075, "maxPenetrationRate":0.20, "agentCommissionRate":0.09  } ]  }, ' +
                    '"contractType":"SMA", "contractTermMonths":48, "otherProviderContractType":"NonContracted", "hl3ItemOverride":null, ' + 
                    '"demographics": [ { "quantity":' + mockTestPptyTtlUnits + ', "rental":true, "incomeLevel":0  } ] } ] } ] }';										
                System.debug('(TEST***SETUP) For testReqListOfferIWF.get(' + t + ').Name = ' + testReqListOfferIWF.get(t).Name +
                             '\n testReqListOfferIWF.get(' + t + ').Constructed_JSON__c = ' + testReqListOfferIWF.get(t).Constructed_JSON__c);
        	}
            update testReqListOfferIWF;
            for (Integer t = 0; t < testReqListOfferIWF.size(); t++) {
                for (Integer c = 0; c < testCallListOfferIWF.size(); c++) {
                    if (testReqListOfferIWF.get(t).BRAIN_API_Call_Tracker_Master__c == testCallListOfferIWF.get(c).Id) {
                		testCallListOfferIWF.get(c).BRAIN_FA_Request__c = testReqListOfferIWF.get(t).Id;
                    }
                }
            }
            update testCallListOfferIWF;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_FA_Request__c for "Standard" "Instant Wi-Fi" and "OFFER" for Opportunity ' + mockTestOpptyTitle);
        }
        List<BRAIN_FA_Response__c> tempRespListOfferIWF = TestDataFactory.createBrainFAResponse(testCallListOfferIWF, testCallListOfferIWF.size(), True);                                    
        System.debug('(TEST***SETUP) AFTER Offer insert for "Standard" "Instant Wi-Fi" and "CAPITAL-DESIGN", tempRespListOfferIWF is NULL? ' + (tempRespListOfferIWF==null) +
                     '\n  AND tempRespListOfferIWF?.size() = ' + tempRespListOfferIWF?.size());
        List<BRAIN_FA_Response__c> testRespListOfferIWF = [SELECT Id, Name, 
                                                         BRAIN_ID__c,
                                                         hl1EvaluationResult__c,
                                                         errorCode__c, errorMessage__c,
                                                         responseDate__c, status__c,
                                                         BRAIN_API_Call_Tracker_Master__c,
                                                         BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                                         BRAIN_API_Call_Tracker_Master__r.API_Transaction__c
                                                   FROM BRAIN_FA_Response__c];
        if (testRespListOfferIWF != null && testRespListOfferIWF.size() > 0) {
            for (Integer t = 0; t < testRespListOfferIWF.size(); t++) {
	            System.debug('(TEST***SETUP) AFTER Response create for "Standard" "Instant Wi-Fi" and "OFFER", set testingIWFFAResponseNameForOffer = ' + testRespListOfferIWF.get(t).Name +
                         '\n  AND testingIWFFAResponseIdForOffer = ' + testRespListOfferIWF.get(t).Id);
                for (Integer c = 0; c < testCallListOfferIWF.size(); c++) {
                    if (testRespListOfferIWF.get(t).BRAIN_API_Call_Tracker_Master__c == testCallListOfferIWF.get(c).Id) {
                		testCallListOfferIWF.get(c).BRAIN_FA_Response__c = testRespListOfferIWF.get(t).Id;
                    } 
                }
            }
            update testCallListOfferIWF;
        } else {
            System.debug('(TEST***SETUP) Unable to generate test data for BRAIN_FA_Response__c for "Standard" "Instant Wi-Fi" and "OFFER" for Opportunity ' + mockTestOpptyTitle);
        }
        List<Offer__c> offerCapEvalListIWF = [SELECT Id, Name, OwnerId, Offer_Total_Units__c, 
												Offer_Type__c, Offer_Status__c,                                                
                                                Other_Provider_Contract_Type__c,
                                                Contract_Term__c,
                                                Data_Bounty_Amount_Approved__c, 
                                                Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                                Requested_Bulk_Data_Price_Approved__c,
                                                Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                                Opportunity__r.Id, 
                                                Contract__r.EndDate,
                                                Flat_Revenue_Share_Approved__c,
                                                Revenue_Share_Agent_Commission_Rate__c,
                                                Revenue_Share_MIN_Penetration_Rate__c,
                                                Revenue_Share_MAX_Penetration_Rate__c,
                                                Associated_Capital_Design__c,
                                                Associated_Capital_Design__r.Name,
                                                Associated_Capital_Design__r.Actual_Build_Out_Months__c,
                                                Associated_Capital_Design__r.Core_Switch_Electronics__c,
                                                Associated_Capital_Design__r.Transport_Interoffice_Fiber__c,
                                                Associated_Capital_Design__r.CO_Electronics__c,
                                                Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c,
                                                Associated_Capital_Design__r.Remote_Electronics__c,
                                                Associated_Capital_Design__r.Total_Cottage_Rental_Units__c, 
                                                Associated_Capital_Design__r.Total_Tower_Rental_Units__c, 
                                                Associated_Capital_Design__r.Total_SFH_Rental_Units__c,
                                                Associated_Capital_Design__r.Total_Cottage_Owner_Units__c, 
                                                Associated_Capital_Design__r.Total_Tower_Owner_Units__c, 
                                                Associated_Capital_Design__r.Total_SFH_Owner_Units__c, 
                                                Associated_Capital_Design__r.Service_Delivery__c, 
                                                Associated_Capital_Design__r.Distribution_F2__c, 
                                                Associated_Capital_Design__r.F1_Footage_ft__c,
                                                Associated_Capital_Design__r.F2_Footage_ft__c,
                                                Associated_Capital_Design__r.Distribution_Structure_Conduit__c,
                                           		Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c,
                                                Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c,
                                                Associated_Capital_Design__r.Other_MDU_F4__c, 
                                                Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                                Associated_Capital_Design__r.OP_F2_Total_Cost_Combined_Cost__c,
                                                Associated_Capital_Design__r.OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                                Associated_Capital_Design__r.OP_F3_Total_Cost_Comb_Cost__c,
                                                Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c, 
                                                Associated_Capital_Design__r.Network_Investment__c, 
                                                Associated_Capital_Design__r.Technology_Type__c, 
                                                Associated_Capital_Design__r.Service_Type__c,                     
                                                Associated_Capital_Design__r.MDU_ONT_Drop__c,
                                                Associated_Capital_Design__r.Access_Type__c,
                                                Associated_Capital_Design__r.F1_Feeder_Type__c,
                                                Associated_Capital_Design__r.Cluster_ID__c,
                                                Associated_Capital_Design__r.Cluster_Not_Available__c,
                                                Associated_Capital_Design__r.Development_Status__c,
                                                Associated_Capital_Design__r.Building_Style__c,
                                                Associated_Capital_Design__r.Occupant_Type__c,
                                                Associated_Capital_Design__r.Access_Cost__c,
                                                Associated_Capital_Design__r.IP_CapEx_Shared__c,
                                                Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c,
                                                Associated_Capital_Design__r.Wireless_Access_Points_Cost__c,
                                                Associated_Capital_Design__r.BCET_Wire_Center__c,
                                                Associated_Capital_Design__r.One_Time_Additional_Expense__c,
                                                Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c
	                            			FROM Offer__c 
                                           WHERE (Associated_Capital_Design__r.Capital_Design_Type__c = 'Standard' 
                                             AND Associated_Capital_Design__r.Technology_Type__c = 'Instant Wi-Fi'
                                             AND Associated_Capital_Design__c != null
                                             AND BRAIN_API_Call_Tracker_Master__c != null)];
        System.debug('(TEST***SETUP) for "Standard" "Instant Wi-Fi" and "OFFER", offerCapEvalListIWF == null??? ' + (offerCapEvalListIWF == null) + '\n  offerCapEvalListIWF?.size() = ' + offerCapEvalListIWF?.size());
        System.debug('(TEST***SETUP) End setting up for IWF Offers');
        List<Capital_Design__c> finalCDList = [SELECT Id, Name, Offer__c, Opportunity__c,
                                               		  Technology_Type__c, Capital_Design_Type__c,
                                                      Service_Type__c, Network_Investment__c,
                                               		  Development_Status__c, Building_Style__c,
                                               		  Cluster_not_Available__c, MDU_ONT_Drop__c,
                                               		  OP_F3_Total_Cost_Comb_Cost__c,
                                               		  OP_F2_Total_Cost_Combined_Cost__c,
                                               		  OP_F2_Conduit_Sub_cost_Combined_Cost__c
                                                 FROM Capital_Design__c];
        System.debug('(TEST***SETUP) finalCDList == null??? ' + (finalCDList == null) + '\n finalCDList.size() = ' + finalCDList?.size());
        if (finalCDList != null && finalCDList.size() > 0) {
            for (Integer t = 0; t < finalCDList.size(); t++) {
                System.debug('(TEST***SETUP) finalCDList.get(t) == null??? ' + (finalCDList?.get(t) == null) +
                                    '\n Id = ' + finalCDList?.get(t)?.Id + '  AND Name = ' + finalCDList?.get(t)?.Name +
                                    '  AND TechType = ' + finalCDList?.get(t)?.Technology_Type__c +
                                    '  AND CapDesType = ' + finalCDList?.get(t)?.Capital_Design_Type__c +
                                    '  AND ServiceType = ' + finalCDList?.get(t)?.Service_Type__c +
                                    '  AND NtwkInvestment = ' + finalCDList?.get(t)?.Network_Investment__c + 
                                    '  AND DevStatus = ' + finalCDList?.get(t)?.Development_Status__c + 
                                    '  AND BuildingStyle = ' + finalCDList?.get(t)?.Building_Style__c);
            }//end for-loop thru test-data finalCDList
        }
    }//end @testSetup method setup

    @IsTest
    private static void testRequestFinancialAnalysesForNMA() {
        final string callSource = 'CapitalDesign';
        BRAIN_API_Call_Tracker__c testFACall = new BRAIN_API_Call_Tracker__c();

        Test.startTest();
        List<Capital_Design__c> setupNMACDList = [SELECT Id, Name FROM Capital_Design__c WHERE Capital_Design_Type__c = 'Non-Marketing'];
        System.debug('(TestBRAINFARequestController) setupNMACDList == null??? ' + (setupNMACDList == null) +
                     			'\n setupNMACDList.size() = ' + setupNMACDList?.size());
        if (setupNMACDList != null && setupNMACDList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupNMACDList.get(0) == null??? ' + (setupNMACDList?.get(0) == null) +
                    			'\n Id = ' + setupNMACDList?.get(0)?.Id + 
                    			'\n Name = ' + setupNMACDList?.get(0)?.Name);
        	testingNMACDId = setupNMACDList.get(0).Id;
        	testingNMACDName = setupNMACDList.get(0).Name;
        }
        List<BRAIN_FA_Request__c> setupReqList = [SELECT Id, Name, cuid__c, sourceSystemId__c FROM BRAIN_FA_Request__c
                                                  WHERE sourceSystemIdType__c = 'CAPITAL-DESIGN'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Non-Marketing' LIMIT 1];
        if (setupReqList != null && setupReqList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupReqList.get(0) == null??? ' + (setupReqList?.get(0) == null) +
                    			'\n Id = ' + setupReqList?.get(0)?.Id + 
                    			'\n Name = ' + setupReqList?.get(0)?.Name +
                        		'\n cuid = ' + setupReqList?.get(0)?.cuid__c +
                                '\n sourceSystemId = ' + setupReqList?.get(0)?.sourceSystemId__c);
        	testingCUID = setupReqList?.get(0)?.cuid__c;
            testingNMASrcSystemId = setupReqList?.get(0)?.sourceSystemId__c;
        }
        testingCUID = String.isNotBlank(testingCUID) ? testingCUID.toUpperCase() : 'AA14082';
        List<BRAINFinancialAnalysesRequestController.RequestParams> requestParamsList = new List<BRAINFinancialAnalysesRequestController.RequestParams>();
        BRAINFinancialAnalysesRequestController.RequestParams rp = new BRAINFinancialAnalysesRequestController.RequestParams();
        rp.capDesignName = testingNMACDName;
        rp.submitterCuid = testingCUID;
        rp.callSource = callSource;
        requestParamsList.add(rp);
        
		List<List<BRAIN_FA_Request__c>> faRequestListCollection = new List<List<BRAIN_FA_Request__c>>();
        try {
            faRequestListCollection = BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses(requestParamsList);
            if (faRequestListCollection == null) {
                System.assertEquals(null, faRequestListCollection, 'Collection returned NULL from controller and failed');
            }
            if (faRequestListCollection?.size() == 0) {
                System.assertEquals(0, faRequestListCollection.size(), 'Collection with 0 size returned from controller and failed');
            }
            List<BRAIN_FA_Request__c> faRequestList = new List<BRAIN_FA_Request__c>();
            faRequestList = (faRequestListCollection != null && faRequestListCollection.size() > 0) ? faRequestListCollection.get(0) : null;
            if (faRequestList == null) {
                System.assertEquals(null, faRequestList, 'List was NULL in Collection returned from controller and failed');
            }
            if(faRequestList?.size() == 0) {
                System.assertEquals(0, faRequestList?.size(), 'List with size 0 in Collection returned from controller and failed');
            }
            BRAIN_FA_Request__c testFARequest = (faRequestList != null & faRequestList?.size() > 0) ? faRequestList?.get(0) : null;        
            if(testFARequest == null) {
                System.assertEquals(null, testFARequest, 'Request object was NULL in List in Collection returned from controller and failed');
            }
            String testingNMABACTId = (testFARequest != null) ? testFARequest.BRAIN_API_Call_Tracker_Master__c : null;
            List<BRAIN_API_Call_Tracker__c> testFACallList = [SELECT Id, Name, Offer__c, OwnerId, 
                                                                               Capital_Design__c, Capital_Design__r.Id, 
                                                                               Capital_Design__r.Name, 
                                                                               BRAIN_FA_Request__c, 
                                                                               BRAIN_FA_Request__r.sourceSystemId__c, 
                                                                               BRAIN_FA_Request__r.opportunityTitle__c, 
                                                                               BRAIN_FA_Request__r.Constructed_JSON__c 
                                                                          FROM BRAIN_API_Call_Tracker__c 
                                                               WHERE Capital_Design__r.Capital_Design_Type__c = 'Non-Marketing'
                                                                 AND BRAIN_FA_Request__r.sourceSystemIdType__c = 'CAPITAL-DESIGN' LIMIT 1];        
            if (testFACallList?.size() == 0) {
                BRAIN_FA_Request__c mockTestFARequest = new BRAIN_FA_Request__c();
                mockTestFARequest.sourceSystemId__c = testingNMASrcSystemId; 
                mockTestFARequest.opportunityTitle__c = 'The Linden- Instant Internet- FTTU';
                testFACall.BRAIN_FA_Request__r = mockTestFARequest;
                testFACallList.add(testFACall);
            }
            testFACall = testFACallList?.get(0);
            testFARequest = testFACall?.BRAIN_FA_Request__r;
            System.debug('(testRequestFinancialAnalysesForAgrmt)AFTER QUERY: testFACall.Id = ' + testFACall.Id + '   AND testFACall.Name = ' + testFACall.Name + 
                         '   AND testFACall.Capital_Design__r.Name = ' + testFACall.Capital_Design__r.Name);
            
            if(testFACall.BRAIN_FA_Request__r.opportunityTitle__c == null) {
                System.assertEquals(null, testFACall.BRAIN_FA_Request__r.opportunityTitle__c, 'Opportunity-Title of Request of Call-Tracker was NULL returned from query based on Request from List from Collection and failed');
            }
            if(testFARequest.opportunityTitle__c == null) {
                System.assertEquals(null, testFARequest.opportunityTitle__c, 'Opportunity-Title of Request was NULL returned from query based on Request from List from Collection and failed');
            }            
            if(testFARequest.sourceSystemId__c == null) {
                System.assertEquals(null, testFARequest.sourceSystemId__c, 'SourceSystemId of Request of Call-Tracker was NULL returned from query based on Request from List from Collection and failed');
            }
        } catch(Exception testX) {
            if (testX != null) {
                System.assertNotEquals(null, testX, 'Exception thrown was NOT NULL from controller and passed');
	            System.debug('(TestBRAINFARequestController) EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
            }
        }
        Test.stopTest();
    }//end testMethod testRequestFinancialAnalysesForNMA

    @IsTest
    private static void testBadParamsRequestFinancialAnalysesForNMA() {
        final string callSource = 'CapitalDesign';
        BRAIN_API_Call_Tracker__c testFACall = new BRAIN_API_Call_Tracker__c();

        Test.startTest();
        List<Capital_Design__c> setupNMACDList = [SELECT Id, Name FROM Capital_Design__c WHERE Capital_Design_Type__c = 'Non-Marketing'];
        System.debug('(TestBRAINFARequestController) setupNMACDList == null??? ' + (setupNMACDList == null) +
                     			'\n setupNMACDList.size() = ' + setupNMACDList?.size());
        if (setupNMACDList != null && setupNMACDList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupNMACDList.get(0) == null??? ' + (setupNMACDList?.get(0) == null) +
                    			'\n Id = ' + setupNMACDList?.get(0)?.Id + 
                    			'\n Name = ' + setupNMACDList?.get(0)?.Name);
        	testingNMACDId = setupNMACDList.get(0).Id;
        	testingNMACDName = setupNMACDList.get(0).Name;
        }
        List<BRAIN_FA_Request__c> setupReqList = [SELECT Id, Name, cuid__c, sourceSystemId__c FROM BRAIN_FA_Request__c
                                                  WHERE sourceSystemIdType__c = 'CAPITAL-DESIGN'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Non-Marketing' LIMIT 1];
        if (setupReqList != null && setupReqList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupReqList.get(0) == null??? ' + (setupReqList?.get(0) == null) +
                    			'\n Id = ' + setupReqList?.get(0)?.Id + 
                    			'\n Name = ' + setupReqList?.get(0)?.Name +
                        		'\n cuid = ' + setupReqList?.get(0)?.cuid__c +
                                '\n sourceSystemId = ' + setupReqList?.get(0)?.sourceSystemId__c);
        	testingCUID = setupReqList?.get(0)?.cuid__c;
            testingNMASrcSystemId = setupReqList?.get(0)?.sourceSystemId__c;
        }
        testingCUID = String.isNotBlank(testingCUID) ? testingCUID.toUpperCase() : 'AA14082';
        List<BRAINFinancialAnalysesRequestController.RequestParams> requestParamsList = new List<BRAINFinancialAnalysesRequestController.RequestParams>();
        BRAINFinancialAnalysesRequestController.RequestParams rp = new BRAINFinancialAnalysesRequestController.RequestParams();
        rp.capDesignName = testingNMACDName;
        rp.submitterCuid = testingCUID;
        rp.callSource = callSource;
        requestParamsList.add(rp);
        
		List<List<BRAIN_FA_Request__c>> faRequestListCollection = new List<List<BRAIN_FA_Request__c>>();
        try {
            faRequestListCollection = BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses(requestParamsList);
            if (faRequestListCollection == null) {
                System.assertEquals(null, faRequestListCollection, 'Collection returned NULL from controller and failed');
            }
            if (faRequestListCollection.size() == 0) {
                System.assertEquals(0, faRequestListCollection.size(), 'Collection with 0 size returned from controller and failed');
            }        
        } catch(Exception testX) {
            if (testX != null) {
                System.assertNotEquals(null, testX, 'Exception thrown was NOT NULL from controller and passed');
	            System.debug('(TestBRAINFARequestController) EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
            }
        }
        Test.stopTest();        
    }//end testMethod testBadParamsRequestFinancialAnalysesForNMA

    @IsTest
    private static void testBadCDNameRequestFinancialAnalysesForNMA() {
        final string callSource = 'CapitalDesign';
        BRAIN_API_Call_Tracker__c testFACall = new BRAIN_API_Call_Tracker__c();

        Test.startTest();
        List<Capital_Design__c> setupNMACDList = [SELECT Id, Name FROM Capital_Design__c WHERE Capital_Design_Type__c = 'Non-Marketing'];
        System.debug('(TestBRAINFARequestController) setupNMACDList == null??? ' + (setupNMACDList == null) +
                     			'\n setupNMACDList.size() = ' + setupNMACDList?.size());
        if (setupNMACDList != null && setupNMACDList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupNMACDList.get(0) == null??? ' + (setupNMACDList?.get(0) == null) +
                    			'\n Id = ' + setupNMACDList?.get(0)?.Id + 
                    			'\n Name = ' + setupNMACDList?.get(0)?.Name);
        	testingNMACDId = setupNMACDList.get(0).Id;
        	testingNMACDName = setupNMACDList.get(0).Name;
        }
        List<BRAIN_FA_Request__c> setupReqList = [SELECT Id, Name, cuid__c, sourceSystemId__c FROM BRAIN_FA_Request__c
                                                  WHERE sourceSystemIdType__c = 'CAPITAL-DESIGN'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Non-Marketing' LIMIT 1];
        if (setupReqList != null && setupReqList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupReqList.get(0) == null??? ' + (setupReqList?.get(0) == null) +
                    			'\n Id = ' + setupReqList?.get(0)?.Id + 
                    			'\n Name = ' + setupReqList?.get(0)?.Name +
                        		'\n cuid = ' + setupReqList?.get(0)?.cuid__c +
                                '\n sourceSystemId = ' + setupReqList?.get(0)?.sourceSystemId__c);
        	testingCUID = setupReqList?.get(0)?.cuid__c;
            testingNMASrcSystemId = setupReqList?.get(0)?.sourceSystemId__c;
        }
        testingCUID = String.isNotBlank(testingCUID) ? testingCUID.toUpperCase() : 'AA14082';
        List<BRAINFinancialAnalysesRequestController.RequestParams> requestParamsList = new List<BRAINFinancialAnalysesRequestController.RequestParams>();
        BRAINFinancialAnalysesRequestController.RequestParams rp = new BRAINFinancialAnalysesRequestController.RequestParams();
        rp.capDesignName = null;
        rp.submitterCuid = testingCUID;
        rp.callSource = callSource;
        requestParamsList.add(rp);
        
		List<List<BRAIN_FA_Request__c>> faRequestListCollection = new List<List<BRAIN_FA_Request__c>>();
        try {
            faRequestListCollection = BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses(requestParamsList);
            if (faRequestListCollection == null) {
                System.assertEquals(null, faRequestListCollection, 'Collection returned NULL from controller and failed');
            }
            if (faRequestListCollection.size() == 0) {
                System.assertEquals(0, faRequestListCollection.size(), 'Collection with 0 size returned from controller and failed');
            }
        } catch(Exception testX) {
            if (testX != null) {
                System.assertNotEquals(null, testX, 'Exception thrown was NOT NULL from controller and passed');
	            System.debug('(TestBRAINFARequestController) EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
            }
        }
        Test.stopTest();        
    }//end testMethod testBadCDNameRequestFinancialAnalysesForNMA

    @IsTest
    private static void testBadParamsRequestFinancialAnalysesForBAU() {
        final string callSource = 'CapitalDesign';
        BRAIN_API_Call_Tracker__c testFACall = new BRAIN_API_Call_Tracker__c();

        Test.startTest();
        List<Capital_Design__c> setupCDList = [SELECT Id, Name FROM Capital_Design__c WHERE Capital_Design_Type__c = 'Standard'];
        System.debug('(TestBRAINFARequestController) setupCDList == null??? ' + (setupCDList == null) +
                     			'\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupCDList.get(0) == null??? ' + (setupCDList?.get(0) == null) +
                    			'\n Id = ' + setupCDList?.get(0)?.Id + 
                    			'\n Name = ' + setupCDList?.get(0)?.Name);
        	testingCDId = setupCDList.get(0).Id;
        	testingCDName = setupCDList.get(0).Name;
        }
        List<BRAIN_FA_Request__c> setupReqList = [SELECT Id, Name, cuid__c, sourceSystemId__c FROM BRAIN_FA_Request__c
                                                  WHERE sourceSystemIdType__c = 'CAPITAL-DESIGN'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Standard' LIMIT 1];
        if (setupReqList != null && setupReqList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupReqList.get(0) == null??? ' + (setupReqList?.get(0) == null) +
                    			'\n Id = ' + setupReqList?.get(0)?.Id + 
                    			'\n Name = ' + setupReqList?.get(0)?.Name +
                        		'\n cuid = ' + setupReqList?.get(0)?.cuid__c +
                                '\n sourceSystemId = ' + setupReqList?.get(0)?.sourceSystemId__c);
        	testingCUID = setupReqList?.get(0)?.cuid__c;
            testingSrcSystemId = setupReqList?.get(0)?.sourceSystemId__c;
        }
        testingCUID = String.isNotBlank(testingCUID) ? testingCUID.toUpperCase() : 'AA14082';
        List<BRAINFinancialAnalysesRequestController.RequestParams> requestParamsList = new List<BRAINFinancialAnalysesRequestController.RequestParams>();
        BRAINFinancialAnalysesRequestController.RequestParams rp = new BRAINFinancialAnalysesRequestController.RequestParams();
        rp.capDesignName = testingCDName;
        rp.submitterCuid = testingCUID;
        rp.callSource = callSource;
        requestParamsList.add(rp);
        
		List<List<BRAIN_FA_Request__c>> faRequestListCollection = new List<List<BRAIN_FA_Request__c>>();
        try {
            faRequestListCollection = BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses(requestParamsList);
            if (faRequestListCollection == null) {
                System.assertEquals(null, faRequestListCollection, 'Collection returned NULL from controller and failed');
            }
            if (faRequestListCollection.size() == 0) {
                System.assertEquals(0, faRequestListCollection.size(), 'Collection with 0 size returned from controller and failed');
            }        
        } catch(Exception testX) {
            if (testX != null) {
                System.assertNotEquals(null, testX, 'Exception thrown was NOT NULL from controller and passed');
	            System.debug('(TestBRAINFARequestController) EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
            }
        }
        Test.stopTest();        
    }//end testMethod testBadParamsRequestFinancialAnalysesForBAU

    @IsTest
    private static void testBadCDNameRequestFinancialAnalysesForBAU() {
        final string callSource = 'CapitalDesign';
        BRAIN_API_Call_Tracker__c testFACall = new BRAIN_API_Call_Tracker__c();

        Test.startTest();
        List<Capital_Design__c> setupCDList = [SELECT Id, Name FROM Capital_Design__c WHERE Capital_Design_Type__c = 'Standard'];
        System.debug('(TestBRAINFARequestController) setupCDList == null??? ' + (setupCDList == null) +
                     			'\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupCDList.get(0) == null??? ' + (setupCDList?.get(0) == null) +
                    			'\n Id = ' + setupCDList?.get(0)?.Id + 
                    			'\n Name = ' + setupCDList?.get(0)?.Name);
        	testingCDId = setupCDList.get(0).Id;
        	testingCDName = setupCDList.get(0).Name;
        }
        List<BRAIN_FA_Request__c> setupReqList = [SELECT Id, Name, cuid__c, sourceSystemId__c FROM BRAIN_FA_Request__c
                                                  WHERE sourceSystemIdType__c = 'CAPITAL-DESIGN'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Standard' LIMIT 1];
        if (setupReqList != null && setupReqList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupReqList.get(0) == null??? ' + (setupReqList?.get(0) == null) +
                    			'\n Id = ' + setupReqList?.get(0)?.Id + 
                    			'\n Name = ' + setupReqList?.get(0)?.Name +
                        		'\n cuid = ' + setupReqList?.get(0)?.cuid__c +
                                '\n sourceSystemId = ' + setupReqList?.get(0)?.sourceSystemId__c);
        	testingCUID = setupReqList?.get(0)?.cuid__c;
            testingSrcSystemId = setupReqList?.get(0)?.sourceSystemId__c;
        }
        testingCUID = String.isNotBlank(testingCUID) ? testingCUID.toUpperCase() : 'AA14082';
        List<BRAINFinancialAnalysesRequestController.RequestParams> requestParamsList = new List<BRAINFinancialAnalysesRequestController.RequestParams>();
        BRAINFinancialAnalysesRequestController.RequestParams rp = new BRAINFinancialAnalysesRequestController.RequestParams();
        rp.capDesignName = testingCDName;
        rp.submitterCuid = testingCUID;
        rp.callSource = callSource;
        requestParamsList.add(rp);
        
		List<List<BRAIN_FA_Request__c>> faRequestListCollection = new List<List<BRAIN_FA_Request__c>>();
        try {
            faRequestListCollection = BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses(requestParamsList);
            if (faRequestListCollection == null) {
                System.assertEquals(null, faRequestListCollection, 'Collection returned NULL from controller and failed');
            }
            if (faRequestListCollection.size() == 0) {
                System.assertEquals(0, faRequestListCollection.size(), 'Collection with 0 size returned from controller and failed');
            }
        } catch(Exception testX) {
            if (testX != null) {
                System.assertNotEquals(null, testX, 'Exception thrown was NOT NULL from controller and passed');
	            System.debug('(TestBRAINFARequestController) EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
            }
        }
        Test.stopTest();        
    }//end testMethod testBadCDNameRequestFinancialAnalysesForBAU

    @IsTest
    private static void testRequestFinancialAnalysesForAgrmt() {
        final string callSource = 'Offer';
        BRAIN_API_Call_Tracker__c testFACall = new BRAIN_API_Call_Tracker__c();

        Test.startTest();
        List<Capital_Design__c> setupCDList = [SELECT Id, Name FROM Capital_Design__c WHERE Capital_Design_Type__c = 'Standard'];
        System.debug('(TestBRAINFARequestController) setupCDList == null??? ' + (setupCDList == null) +
                     			'\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupCDList.get(0) == null??? ' + (setupCDList?.get(0) == null) +
                    			'\n Id = ' + setupCDList?.get(0)?.Id + 
                    			'\n Name = ' + setupCDList?.get(0)?.Name);
        	testingCDId = setupCDList.get(0).Id;
        	testingCDName = setupCDList.get(0).Name;
        }
        List<BRAIN_FA_Request__c> setupReqList = [SELECT Id, Name, cuid__c, sourceSystemId__c FROM BRAIN_FA_Request__c
                                                  WHERE sourceSystemIdType__c = 'OFFER'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Standard' LIMIT 1];
        if (setupReqList != null && setupReqList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupReqList.get(0) == null??? ' + (setupReqList?.get(0) == null) +
                    			'\n Id = ' + setupReqList?.get(0)?.Id + 
                    			'\n Name = ' + setupReqList?.get(0)?.Name +
                        		'\n cuid = ' + setupReqList?.get(0)?.cuid__c +
                                '\n sourceSystemId = ' + setupReqList?.get(0)?.sourceSystemId__c);
        	testingCUID = setupReqList?.get(0)?.cuid__c;
            testingSrcSystemId = setupReqList?.get(0)?.sourceSystemId__c;
        }
        testingCUID = String.isNotBlank(testingCUID) ? testingCUID.toUpperCase() : 'AA14082';
        List<BRAINFinancialAnalysesRequestController.RequestParams> requestParamsList = new List<BRAINFinancialAnalysesRequestController.RequestParams>();
        BRAINFinancialAnalysesRequestController.RequestParams rp = new BRAINFinancialAnalysesRequestController.RequestParams();
        rp.capDesignName = testingCDName;
        rp.submitterCuid = testingCUID;
        rp.callSource = callSource;
        requestParamsList.add(rp);
        
		List<List<BRAIN_FA_Request__c>> faRequestListCollection = new List<List<BRAIN_FA_Request__c>>();
        try {
            faRequestListCollection = BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses(requestParamsList);
            if (faRequestListCollection == null) {
                System.assertEquals(null, faRequestListCollection, 'Collection returned NULL from controller and failed');
            }
            if (faRequestListCollection.size() == 0) {
                System.assertEquals(0, faRequestListCollection.size(), 'Collection with 0 size returned from controller and failed');
            }
            List<BRAIN_FA_Request__c> faRequestList = new List<BRAIN_FA_Request__c>();
            faRequestList = (faRequestListCollection != null && faRequestListCollection.size() > 0) ? faRequestListCollection.get(0) : null;
            if (faRequestList == null) {
                System.assertEquals(null, faRequestList, 'List was NULL in Collection returned from controller and failed');
            }
            if(faRequestList?.size() == 0) {
                System.assertEquals(0, faRequestList?.size(), 'List with size 0 in Collection returned from controller and failed');
            }
            BRAIN_FA_Request__c testFARequest = (faRequestList != null & faRequestList?.size() > 0) ? faRequestList?.get(0) : null;        
            if(testFARequest == null) {
                System.assertEquals(null, testFARequest, 'Request object was NULL in List in Collection returned from controller and failed');
            }                            
            String testingBACTId = (testFARequest != null) ? testFARequest.BRAIN_API_Call_Tracker_Master__c : null;
            List<BRAIN_API_Call_Tracker__c> testFACallList = [SELECT Id, Name, Offer__c, OwnerId, 
                                                                               Capital_Design__c, Capital_Design__r.Id, 
                                                                               Capital_Design__r.Name, 
                                                                               BRAIN_FA_Request__c, 
                                                                               BRAIN_FA_Request__r.sourceSystemId__c, 
                                                                               BRAIN_FA_Request__r.opportunityTitle__c, 
                                                                               BRAIN_FA_Request__r.Constructed_JSON__c 
                                                                          FROM BRAIN_API_Call_Tracker__c 
                                                               WHERE Capital_Design__r.Capital_Design_Type__c = 'Standard'
                                                                 AND BRAIN_FA_Request__r.sourceSystemIdType__c = 'OFFER' LIMIT 1];        
            if (testFACallList?.size() == 0) {
                BRAIN_FA_Request__c mockTestFARequest = new BRAIN_FA_Request__c();
                mockTestFARequest.sourceSystemId__c = testingSrcSystemId;
                mockTestFARequest.opportunityTitle__c = 'The Linden- Instant Internet- FTTU';
                testFACall.BRAIN_FA_Request__r = mockTestFARequest;
                testFACallList.add(testFACall);
            }
            testFACall = testFACallList.get(0);
            testFARequest = testFACall.BRAIN_FA_Request__r;
            System.debug('(testRequestFinancialAnalysesForAgrmt)AFTER QUERY: testFACall.Id = ' + testFACall.Id + '   AND testFACall.Name = ' + testFACall.Name + 
                         '   AND testFACall.Capital_Design__r.Name = ' + testFACall.Capital_Design__r.Name);
                                    
            if(testFACall.BRAIN_FA_Request__r.opportunityTitle__c == null) {
                System.assertEquals(null, testFACall.BRAIN_FA_Request__r.opportunityTitle__c, 'Opportunity-Title of Request of Call-Tracker was NULL returned from query based on Request from List from Collection and failed');
            }
            if(testFARequest.opportunityTitle__c == null) {
                System.assertEquals(null, testFARequest.opportunityTitle__c, 'Opportunity-Title of Request was NULL returned from query based on Request from List from Collection and failed');
            }            
            if(testFARequest.sourceSystemId__c == null) {
                System.assertEquals(null, testFARequest.sourceSystemId__c, 'SourceSystemId of Request of Call-Tracker was NULL returned from query based on Request from List from Collection and failed');
            }
        } catch(Exception testX) {
            if (testX != null) {
                System.assertNotEquals(null, testX, 'Exception thrown was NOT NULL from controller and passed');
	            System.debug('(TestBRAINFARequestController) EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
            }
        }
        Test.stopTest();        
    }//end testMethod testRequestFinancialAnalysesForAgrmt

    @IsTest
    private static void testBadParamsRequestFinancialAnalysesForAgrmt() {
        final string callSource = 'Offer';
        BRAIN_API_Call_Tracker__c testFACall = new BRAIN_API_Call_Tracker__c();

        Test.startTest();
        List<Capital_Design__c> setupCDList = [SELECT Id, Name FROM Capital_Design__c WHERE Capital_Design_Type__c = 'Standard'];
        System.debug('(TestBRAINFARequestController) setupCDList == null??? ' + (setupCDList == null) +
                     			'\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupCDList.get(0) == null??? ' + (setupCDList?.get(0) == null) +
                    			'\n Id = ' + setupCDList?.get(0)?.Id + 
                    			'\n Name = ' + setupCDList?.get(0)?.Name);
        	testingCDId = setupCDList.get(0).Id;
        	testingCDName = setupCDList.get(0).Name;
        }
        List<BRAIN_FA_Request__c> setupReqList = [SELECT Id, Name, cuid__c, sourceSystemId__c FROM BRAIN_FA_Request__c
                                                  WHERE sourceSystemIdType__c = 'OFFER'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Standard' LIMIT 1];
        if (setupReqList != null && setupReqList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupReqList.get(0) == null??? ' + (setupReqList?.get(0) == null) +
                    			'\n Id = ' + setupReqList?.get(0)?.Id + 
                    			'\n Name = ' + setupReqList?.get(0)?.Name +
                        		'\n cuid = ' + setupReqList?.get(0)?.cuid__c +
                                '\n sourceSystemId = ' + setupReqList?.get(0)?.sourceSystemId__c);
        	testingCUID = setupReqList?.get(0)?.cuid__c;
            testingSrcSystemId = setupReqList?.get(0)?.sourceSystemId__c;
        }
        testingCUID = String.isNotBlank(testingCUID) ? testingCUID.toUpperCase() : 'AA14082';
        List<BRAINFinancialAnalysesRequestController.RequestParams> requestParamsList = new List<BRAINFinancialAnalysesRequestController.RequestParams>();
        BRAINFinancialAnalysesRequestController.RequestParams rp = new BRAINFinancialAnalysesRequestController.RequestParams();
        rp.capDesignName = DEFAULT_EMPTY;
        rp.submitterCuid = null;
        rp.callSource = callSource;
        requestParamsList.add(rp);
        
		List<List<BRAIN_FA_Request__c>> faRequestListCollection = new List<List<BRAIN_FA_Request__c>>();
        try {
        	faRequestListCollection = BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses(requestParamsList);            
            if (faRequestListCollection == null) {
                System.assertEquals(null, faRequestListCollection, 'Collection returned NULL from controller and failed');
            }
            if (faRequestListCollection?.size() == 0) {
                System.assertEquals(0, faRequestListCollection?.size(), 'Collection with 0 size returned from controller and failed');
            }
        } catch(Exception testX) {
            if (testX != null) {
                System.assertNotEquals(null, testX, 'Exception thrown was NOT NULL from controller and passed');
	            System.debug('(TestBRAINFARequestController) EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
            }
        }
        Test.stopTest();        
    }//end testMethod testBadParamsRequestFinancialAnalysesForAgrmt

    @IsTest
    private static void testConstructor() {
        final string callSource = 'CapitalDesign';
        BRAIN_API_Call_Tracker__c testFACall = new BRAIN_API_Call_Tracker__c();

        Test.startTest();
        List<Capital_Design__c> setupCDList = [SELECT Id, Name FROM Capital_Design__c WHERE Capital_Design_Type__c = 'Standard'];
        System.debug('(TestBRAINFARequestController) setupCDList == null??? ' + (setupCDList == null) +
                     			'\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupCDList.get(0) == null??? ' + (setupCDList?.get(0) == null) +
                    			'\n Id = ' + setupCDList?.get(0)?.Id + 
                    			'\n Name = ' + setupCDList?.get(0)?.Name);
        	testingCDId = setupCDList.get(0).Id;
        	testingCDName = setupCDList.get(0).Name;
        }
        List<BRAIN_FA_Request__c> setupReqList = [SELECT Id, Name, cuid__c, sourceSystemId__c FROM BRAIN_FA_Request__c
                                                  WHERE sourceSystemIdType__c = 'CAPITAL-DESIGN'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Standard' LIMIT 1];
        if (setupReqList != null && setupReqList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupReqList.get(0) == null??? ' + (setupReqList?.get(0) == null) +
                    			'\n Id = ' + setupReqList?.get(0)?.Id + 
                    			'\n Name = ' + setupReqList?.get(0)?.Name +
                        		'\n cuid = ' + setupReqList?.get(0)?.cuid__c +
                                '\n sourceSystemId = ' + setupReqList?.get(0)?.sourceSystemId__c);
        	testingCUID = setupReqList?.get(0)?.cuid__c;
            testingSrcSystemId = setupReqList?.get(0)?.sourceSystemId__c;
        }
        testingCUID = String.isNotBlank(testingCUID) ? testingCUID.toUpperCase() : 'AA14082';
		BRAINFinancialAnalysesRequestController coController = new BRAINFinancialAnalysesRequestController(testingCDName, null, testingCUID, 'CapitalDesign');
        if (coController == null) {
            System.assertEquals(null, coController, 'Controller returned NULL from constructor and failed');
        }
        Test.stopTest();
        
	}//end testConstructor

    @IsTest
    private static void testExecute() {
        final string callSource = 'CapitalDesign';
        BRAIN_API_Call_Tracker__c testFACall = new BRAIN_API_Call_Tracker__c();

        Test.startTest();
        List<Capital_Design__c> setupCDList = [SELECT Id, Name, Opportunity__c,
                                                      Offer__c, Offer__r.Name, Capital_Design_Type__c, Technology_Type__c 
                                                 FROM Capital_Design__c 
                                                WHERE Capital_Design_Type__c = 'Standard' 
                                                  AND Technology_Type__c != 'Instant Wi-Fi'
                                                  AND Development_Status__c = 'Greenfield'
                                                  AND Building_Style__c = 'SFU Retail'];
        System.debug('(TestBRAINFARequestController) setupCDList == null??? ' + (setupCDList == null) + '\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
            for (Integer t = 0; t < setupCDList.size(); t++) {
                System.debug('(TestBRAINFARequestController) setupCDList.get(t) == null??? ' + (setupCDList?.get(t) == null) +
                                    '\n CD.Id = ' + setupCDList?.get(t)?.Id + '\n CD.Name = ' + setupCDList?.get(t)?.Name + 
                             		'\n Offer__c = ' + setupCDList?.get(t)?.Offer__c + '\n Offer.Name = ' + setupCDList?.get(t)?.Offer__r.Name);
                try {
                    BRAINFinancialAnalysesRequestController coController = new BRAINFinancialAnalysesRequestController(setupCDList?.get(t)?.Name, setupCDList?.get(t)?.Offer__c, 'CJAPIUS', callSource);
                    if (coController == null) {
                        System.assertEquals(null, coController, 'Controller returned NULL from constructor and failed');
                    }
                    String coJobId = System.enqueueJob(coController);
                    if (coJobId == null) {
                        System.assertEquals(null, coJobId, 'JobId was NULL for Controller after execute and failed');
                    }
                 } catch(Exception testX) {
                    if (testX != null) {
                        System.assertNotEquals(null, testX, 'Exception thrown was NOT NULL from controller and passed');
                        System.debug('(TestBRAINFARequestController) EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
                    }
                }
	        }//end for-loop thru setupCDList
        }//end if setupCDList is VALID
       Test.stopTest();
        
	}//end testExecute

    @IsTest
    private static void testExecuteNMA() {
        final string callSource = 'CapitalDesign';

        Test.startTest();
        List<Capital_Design__c> setupCDList = [SELECT Id, Name, Opportunity__c,
                                                      Offer__c, Offer__r.Name, Capital_Design_Type__c, Technology_Type__c 
                                                 FROM Capital_Design__c 
                                                WHERE Capital_Design_Type__c = 'Non-Marketing'];
        System.debug('(TestBRAINFARequestHelper.testExecuteNMA) setupCDList == null??? ' + (setupCDList == null) + '\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
            for (Integer t = 0; t < setupCDList.size(); t++) {
                System.debug('(TestBRAINFARequestHelper.testExecuteNMA) Non-Marketing setupCDList.get(t) == null??? ' + (setupCDList?.get(t) == null) +
                                    '\n CD.Id = ' + setupCDList?.get(t)?.Id + '\n CD.Name = ' + setupCDList?.get(t)?.Name + 
                             		'\n Offer__c = ' + setupCDList?.get(t)?.Offer__c + '\n Offer.Name = ' + setupCDList?.get(t)?.Offer__r.Name);
                try {
                    BRAINFinancialAnalysesRequestController coController = new BRAINFinancialAnalysesRequestController(setupCDList?.get(t)?.Name, null, 'CJAPIUS', callSource);
                    if (coController == null) {
                        System.assertEquals(null, coController, 'Controller returned NULL from constructor and failed');
                    }
                    String coJobId = System.enqueueJob(coController);
                    if (coJobId == null) {
                        System.assertEquals(null, coJobId, 'JobId was NULL for Controller after execute and failed');
                    }
                 } catch(Exception testX) {
                    if (testX != null) {
                        System.assertNotEquals(null, testX, 'Exception thrown was NOT NULL from controller and passed');
                        System.debug('(TestBRAINFARequestHelper.testExecuteNMA) EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
                    }
                }
	        }//end for-loop thru setupCDList
        }//end if setupCDList is VALID
        Test.stopTest();
        
	}//end testExecuteNMA

    @IsTest
    public static void testAutomatedPrepareRequestForFANoParams() {
        Test.startTest();
        try {
            BRAINFinancialAnalysesRequestController coController = new BRAINFinancialAnalysesRequestController(null, null, null, null);
            List<List<BRAIN_FA_Request__c>> requestListCollection = coController.automatedPrepareRequestForFinancialAnalyses(null);
        } catch(Exception testX) {
            if (testX != null) {
                System.assertNotEquals(null, testX, 'Exception thrown was NOT NULL from controller and passed');
	            System.debug('(TestBRAINFARequestController.testAutomatedPrepareRequestForFANoParams) EXCEPTION! \n Type: ' + testX.getTypeName() + '\n Message:  ' + testX.getMessage() + '\n Line#: ' + testX.getLineNumber() + '\n StackTrace:  ' + testX.getStackTraceString());
            }
        }
    	Test.stopTest();
        
	}//end testAutomatedPrepareRequestForFANoParams

    @IsTest
    private static void testClearState() {
        final string callSource = 'CapitalDesign';
        BRAIN_API_Call_Tracker__c testFACall = new BRAIN_API_Call_Tracker__c();

        Test.startTest();
        List<Capital_Design__c> setupCDList = [SELECT Id, Name FROM Capital_Design__c WHERE Capital_Design_Type__c = 'Standard'];
        System.debug('(TestBRAINFARequestController) setupCDList == null??? ' + (setupCDList == null) +
                     			'\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupCDList.get(0) == null??? ' + (setupCDList?.get(0) == null) +
                    			'\n Id = ' + setupCDList?.get(0)?.Id + 
                    			'\n Name = ' + setupCDList?.get(0)?.Name);
        	testingCDId = setupCDList.get(0).Id;
        	testingCDName = setupCDList.get(0).Name;
        }
        List<BRAIN_FA_Request__c> setupReqList = [SELECT Id, Name, cuid__c, sourceSystemId__c FROM BRAIN_FA_Request__c
                                                  WHERE sourceSystemIdType__c = 'CAPITAL-DESIGN'
                                                    AND BRAIN_API_Call_Tracker_Master__r.Capital_Design__r.Capital_Design_Type__c = 'Standard' LIMIT 1];
        if (setupReqList != null && setupReqList.size() > 0) {
	        System.debug('(TestBRAINFARequestController) setupReqList.get(0) == null??? ' + (setupReqList?.get(0) == null) +
                    			'\n Id = ' + setupReqList?.get(0)?.Id + 
                    			'\n Name = ' + setupReqList?.get(0)?.Name +
                        		'\n cuid = ' + setupReqList?.get(0)?.cuid__c +
                                '\n sourceSystemId = ' + setupReqList?.get(0)?.sourceSystemId__c);
        	testingCUID = setupReqList?.get(0)?.cuid__c;
            testingSrcSystemId = setupReqList?.get(0)?.sourceSystemId__c;
        }
        testingCUID = String.isNotBlank(testingCUID) ? testingCUID.toUpperCase() : 'AA14082';
		BRAINFinancialAnalysesRequestController coController = new BRAINFinancialAnalysesRequestController(testingCDName, null, testingCUID, callSource);
        if (coController == null) {
            System.assertEquals(null, coController, 'Controller returned NULL from constructor and failed');
        }
        coController.clearState();
    	Test.stopTest();
        
	}//end testClearState

    public static HttpResponse getHttpResponseFromStaticResource() {
        // Setup mockCallout To BRAIN-FinancialAnalyses API
        StaticResourceCalloutMock mockCalloutToBRAINFA = new StaticResourceCalloutMock();
		mockCalloutToBRAINFA.setStaticResource('TestBRAINFAResponseCapDesCD00000250JSON');
		mockCalloutToBRAINFA.setStatusCode(200);
		mockCalloutToBRAINFA.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToBRAINFA);
        String mockAccessToken = testingSrcSystemId;        
        // Call the method that builds the mock of the HttpRequest to BRAIN
        HttpRequest mockHttpRequest = BRAINFACalloutHelper.buildHttpRequestForBRAINFAService(mockAccessToken, testingFARequestJSON);
		// Call the method that builds the mock of the HttpResponse from BRAIN
        HttpResponse mockHttpResponse = BRAINFACalloutHelper.getHttpResponseFromBRAINFAService(mockHttpRequest);
		// Return the mocked HttpResponse from BRAIN
        return mockHttpResponse;        
    }// end getHttpResponseFromStaticResource

    public static String queryForResponseJSONFromStaticResource() {
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
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setStatusCode(200);
        mockHttpResponse.setBody(mockApigeeResponseBody);
		// Return the mocked HttpResponse 
        return mockHttpResponse;        
    }//end method getMockApigeeHttpResponse
}//end test-class TestBRAINFARequestController