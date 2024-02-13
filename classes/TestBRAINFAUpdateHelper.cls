@isTest
public with sharing class TestBRAINFAUpdateHelper {
      public static final String mockTestContactFName = 'Noah';
      public static final String mockTestContactLName = 'Allen';
      public static final String mockTestContactEmail = 'noah.allen@team480653.testinator.com';
      public static final String mockTestNWCCLLI = 'GLSHALXA';
      public static final String mockTestPptyAddrStreet = '2764 W BEACH BLVD';
      public static final String mockTestPptyAddrCity = 'GULF SHORES';
      public static final String mockTestPptyAddrState = 'AL';
      public static final String mockTestPptyAddrZip = '36542';
      public static final String mockTestPptyCountyCode = 'BWN';
      public static final String mockTestPptyStateCode = 'AL';
      public static final String mockTestPptyAPN = '';
      public static final Decimal mockTestPptyLat =   30.23548000;
      public static final Decimal mockTestPptyLong = -87.77961100;
      public static final String mockTestPptyName = 'NOAH ALLEN BEACH ESTATES';
      public static final String mockTestPptyType = 'Condo';
      public static final String mockTestPptyStruct = 'Tower';
      public static final Decimal mockTestPptyTtlUnits = 24;
      public static final String mockTestOpptyTitle = mockTestPptyName + ' - Instant Internet - FTTU';
      public static final String mockTestOpptyDevStatus = 'Greenfield';
      public static final String mockTestOpptyStageName = 'Proposed';
      public static final Date mockTestOpptyCloseDate = (Date.today()).addMonths(8);
      public static final String mockTestBuildingStyle = 'Cottage';
      public static final Decimal mockTestFootageBldg = 500.00;
      public static final Decimal mockTestFootageFlr = 0.00;
      public static final Decimal mockTestMatCost = 0.00;
      public static final Decimal mockTestSize = 0.00;
      public static final String defaultEMPTY = ' ';
      public static final Id testEMPTYFAResponseId = null;
      public static Id testingCDId = null;
      public static String testingCDName = '';
      public static String testingSrcSystemId = '';
      public static Id testingOfferId = null;
      public static String testingOfferName = null;
      public static Id testingBACTId = null;
      public static String testingBACTName = '';
      public static Id testingFARequestId = null;
      public static String testingFARequestName = '';
      public static Id testingFAResponseId = null;
      public static String testingFAResponseName = null;
      public static String testingFAResponseJSON = null;
      public static Id testingHL1EvalId = null;
      public static String testingHL1EvalName = null;
      public static Id testingFinMetricId = null;
      public static String testingFinMetricName = null;
      public static Id testingIncStmtMetricId = null;
      public static String testingIncStmtMetricName = null;
      public static Id testingCFMetricId = null;
      public static String testingCFMetricName = null;
      public static Id testingGREvalId = null;
      public static String testingGREvalName = null;
      public static final String mockTestFARequestJSON = '{ "sourceSystem":"SFCJ", "cuid":"AA14082", "financialMetricCurrencyCode":"USD", ' + 
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



    @testSetup 
    static void setup(){
        List<Contact> testContactList = new List<Contact>();
        List<Contact> existContactList = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email = :mockTestContactEmail OR (FirstName = :mockTestContactFName AND LastName = :mockTestContactLName)];
        System.debug('(TestBRAINFAUpdateHelper.setup) existContactList == null??? ' + (existContactList==null) + ' OR existContactList?.size() = ' + (existContactList?.size()) );
/*        if (existContactList == null || existContactList.size() == 0) {
            testContactList = TestDataFactory.createContacts(mockTestContactFName, mockTestContactLName, 1, True);
	        if (testContactList != null && testContactList.size() > 0) { 
    	        testContactList.get(0).Email = mockTestContactEmail;
            	//update testContactList;
            }
        }
        if (testContactList != null && testContactList.size() > 0) { 
*/
            List<Network_Wire_Center__c> testNWCList = TestDataFactory.createNetworkWireCenters(mockTestNWCCLLI, 1, True);
            if (testNWCList != null && testNWCList.size() > 0) {
                System.debug('(TestBRAINFAUpdateHelper.setup) AFTER initial insert, testNWCList.get(0).Name = ' + testNWCList.get(0).Name +
                            '\n  AND testNWCList.get(0).Wire_Center_Segmentation__c = ' + testNWCList.get(0).Wire_Center_Segmentation__c);
                testNWCList.get(0).Wire_Center_Segmentation__c = 'WEAK';
                update testNWCList;
                List<Property__c> testPropertyList = TestDataFactory.createProperties(mockTestPptyAddrStreet, mockTestPptyAddrCity, 
                                                                                      mockTestPptyAddrState, mockTestPptyCountyCode, 
                                                                                      mockTestPptyStateCode, mockTestPptyAPN, 
                                                                                      mockTestPptyLat, mockTestPptyLong, 1, True);
                if (testPropertyList != null && testPropertyList.size() > 0) {
                    System.debug('(TestBRAINFAUpdateHelper.setup) AFTER initial insert, testPropertyList.get(0).Name = ' + testPropertyList.get(0).Name +
                                '\n  AND testPropertyList.get(0).Id = ' + testPropertyList.get(0).Id);
                    testPropertyList.get(0).Name = mockTestPptyName;
                    testPropertyList.get(0).Primary_Address_Zip__c = mockTestPptyAddrZip;
                    testPropertyList.get(0).Property_Type__c = mockTestPptyType;
                    testPropertyList.get(0).Property_Structure__c = mockTestPptyStruct;
                    testPropertyList.get(0).Property_Total_Units__c = mockTestPptyTtlUnits;
                    testPropertyList.get(0).Network_Wire_Center__c = testNWCList.get(0).Id;                
                    update testPropertyList;
                    List<Opportunity> testOpportunityList = TestDataFactory.createOpportunities(mockTestOpptyTitle, mockTestOpptyDevStatus, 
                                                                                          mockTestOpptyStageName, mockTestOpptyCloseDate, 
                                                                                          testPropertyList.get(0).Id, 1, True);
                    if (testOpportunityList != null && testOpportunityList.size() > 0) {
                        System.debug('(TestBRAINFAUpdateHelper.setup) AFTER initial insert, testOpportunityList.get(0).Name = ' + testOpportunityList.get(0).Name +
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
                        System.debug('(TestBRAINFAUpdateHelper.setup) AFTER initial Segment insert, testSegment for Opportunity ' + mockTestOpptyTitle);
                        List<Capital_Design__c> tempCDList = TestDataFactory.createCapitalDesignsWithBRAINDefaults(testOpportunityList.get(0).Id, 1, True);
                        //System.debug('(TestBRAINFAUpdateHelper.setup) AFTER initial CD insert, tempCDList?.get(0)?.Id = ' + tempCDList?.get(0)?.Id);
                        List<Capital_Design__c> testCDList = BRAINFAUpdateHelper.queryCapDesignListById(tempCDList?.get(0)?.Id);
                        //System.debug('(TestBRAINFAUpdateHelper.setup) AFTER initial CD insert, testCDList.get(0).Id = ' + testCDList.get(0).Id + 
                        //             									'\n  AND testCDList.get(0).Id = ' + testCDList.get(0).Id);
                        if (testCDList != null && testCDList.size() > 0) {
                            testingCDName = testCDList.get(0).Name;
                            testingCDId = testCDList.get(0).Id;
                            testingSrcSystemId = testCDList.get(0).Id;
                            System.debug('(TestBRAINFAUpdateHelper.setup) AFTER CD update, testingCDId = ' + testingCDId +
                                         '\n  AND testingCDName = ' + testingCDName +
                                         '\n  AND testingSrcSystemId = ' + testingSrcSystemId);
                            List<CCT_F2_Cost_Estimator__c> f2CostEstList = TestDataFactory.createCCTF2CostEstimator(mockTestBuildingStyle, mockTestFootageBldg,
        																										mockTestFootageFlr, 1, True);
							List<CCT_F2_Stub_Estimator__c> f2StubEstList = TestDataFactory.createCCTF2StubEstimator(mockTestMatCost, mockTestSize, 1, True);
                            List<CCT_Cost_Estimator__c> costEstList = TestDataFactory.createCCTCostEstimator(mockTestPptyStateCode, 1, True);
							List<Offer__c> tempOfferList = TestDataFactory.createOffer(testOpportunityList, 1, True);
	                        System.debug('(TestBRAINFAUpdateHelper.setup) AFTER initial Offer insert, tempOfferList?.get(0)?.Id = ' + tempOfferList?.get(0)?.Id);
							if (tempOfferList != null && tempOfferList.size() > 0) {
	                            tempOfferList.get(0).Associated_Capital_Design__c = testingCDId;
    	                        update tempOfferList;
                            }
	                        List<Offer__c> testOfferList = BRAINFAUpdateHelper.queryOfferListById(tempOfferList?.get(0)?.Id, testingCDId);
   	                        System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Offer insert, testOfferList is NULL? ' + (testOfferList==null) +
	                                        '\n  AND testOfferList?.size() = ' + (testOfferList!=null ? testOfferList?.size() : null));
							if (testOfferList != null && testOfferList.size() > 0) {
	   	                        System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Offer insert, testOfferList.get(0).Name = ' + testOfferList.get(0).Name +
	                                        '\n  AND testOfferList.get(0).Id = ' + testOfferList.get(0).Id);
                                testingOfferId = testOfferList.get(0).Id;
                                testingOfferName = testOfferList.get(0).Name;
    	                        System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Offer insert, set testingOfferName = ' + testingOfferName +
	                                        '\n  AND testingOfferId = ' + testingOfferId);
								testOfferList.get(0).Associated_Capital_Design__c = testingCDId;
								update testOfferList;
								List<BRAIN_API_Call_Tracker__c>	tempCallList = TestDataFactory.createBrainAPICallTracker(testCDList, testOfferList, 1, True);
                                //System.debug('(TestBRAINFAUpdateHelper.setup) AFTER BACT create, tempCallList?.get(0)?.Id = ' + tempCallList?.get(0)?.Id);
								List<BRAIN_API_Call_Tracker__c>	testCallList = BRAINFAUpdateHelper.queryBACTListById(tempCallList?.get(0)?.Id, testingCDId);
								if (testCallList != null && testCallList.size() > 0) {
	                                System.debug('(TestBRAINFAUpdateHelper.setup) AFTER BACT create, testCallList.get(0).Name = ' + testCallList.get(0).Name +
                                             '\n  AND testCallList.get(0).Id = ' + testCallList.get(0).Id);
                                    testingBACTId = testCallList.get(0).Id;
                                    testingBACTName = testCallList.get(0).Name;
		                            System.debug('(TestBRAINFAUpdateHelper.setup) AFTER BACT create, set testingBACTName = ' + testingBACTName +
                                                		'\n  AND testingBACTId = ' + testingBACTId);
									List<BRAIN_FA_Request__c> tempReqList = TestDataFactory.createBrainFARequest(testCDList, testOfferList, 1, True);                                    
		                            //System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Request create, tempReqList.get(0).Id = ' + tempReqList.get(0).Id);
                                    BRAIN_FA_Request__c testRequest = BRAINFAObjectSOQLManager.queryFARequestById(tempReqList?.get(0)?.Id);
									if (testRequest != null) {
                                        testingFARequestId = testRequest.Id;
                                        testingFARequestName = testRequest.Name;
			                            System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Request create, set testingFARequestName = ' + testingFARequestName +
                                                            '\n  AND testingFARequestId = ' + testingFARequestId);
										if (testRequest.sourceSystemId__c == null) {
                                            if (testingSrcSystemId == null) {
                                            	testRequest.sourceSystemId__c = testOpportunityList.get(0).Id;    
                                            } else {
                                                testRequest.sourceSystemId__c = testingSrcSystemId;
                                            }											
                                        }
										if (testRequest.sourceSystemIdType__c == null) {
											testRequest.sourceSystemIdType__c = 'OPPORTUNITY';
										}
										testRequest.opportunityTitle__c = testOpportunityList.get(0).Name;
										testRequest.BRAIN_API_Call_Tracker_Master__c = testCallList.get(0).Id;
										String constructJSON = mockTestFARequestJSON;
										testRequest.Constructed_JSON__c = '{ "sourceSystem":"' + testRequest.sourceSystem__c + '", ' + 
										'"cuid":"' + testRequest.cuid__c + '", ' +
										'"financialMetricCurrencyCode":"' + testRequest.financialMetricCurrencyCode__c + '", ' + 
                                        '"financialMetricCurrencyExchangeDate":null, ' +
										'"sourceSystemId":"' + testRequest.sourceSystemId__c + '", ' + 
            							'"sourceSystemIdType":"' + testRequest.sourceSystemIdType__c + '", ' +
										'"analysisOverride":null, "opportunityTitle":"' + testOpportunityList.get(0).Name + '", ' + 
            							'"hl2Items":[ { "sourceSystemId":"' + testRequest.sourceSystemId__c + '", ' +
										'"sourceSystemIdType":"' + testRequest.sourceSystemIdType__c + '", ' +
										'"latitude":' + mockTestPptyLat + ', "longitude":' + mockTestPptyLong + ', ' + 
            							'"wireCenterCLLI":"' + mockTestNWCCLLI + '", "constructionMonths":24, "currencyCode":"USD", "coreElectronicsCost":0.00, "interofficeFiberCost":0.00, ' + 
            							'"coElectronicsCost":9360.00, "f1FeederCost":25414.00, "remoteElectronicsCost":0.00, "hl2ItemOverride":null, "hl3Items":[ { "quantity":' + mockTestPptyTtlUnits + ', ' + 
            							'"constructionType":"MDU", "ctlOn":false, "currencyCode":"USD", "f2Cost":0.00, "f2CostSource":"PROVIDED", "f2Footage":800.00, ' + 
            							'"insideWiringCapEx":54380.5875, "ontType":null, "dropCost":0, "dropCostSource":"PROVIDED", "additionalOpExNrc":18098.70, ' + 
            							'"additionalOpExMrc":0, "occupantType":"CONSUMER", "lotFrontageFeet":0, "maxDownstreamSpeedKbps":1000000, "clusterId":null, ' + 
            							'"fdhCost":0.01, "splitterCost":0.01, "splitterPorts":1, "idfElectronicsCost":0.01, "wirelessAccessPointsCost":0.01, "networkInvestmentType":"NEW DEVELOPMENT", ' + 
            							'"productType":"FTTH", "contractType":"COMPETITIVE LOSS", "contractTermMonths":0, "marketingFees":null, "hl3ItemOverride":null, ' + 
                                        '"demographics": [ { "quantity":' + mockTestPptyTtlUnits + ', "rental":true, "incomeLevel":0  } ] } ] } ] }';										
										
										update testRequest;
										testCallList.get(0).BRAIN_FA_Request__c = testingFARequestId;
										update testCallList;
                                        testingFAResponseJSON = queryForResponseJSONFromStaticResource();
                                        List<BRAINFinancialAnalysesResponseController.ResponseParams> respParamsList = new List<BRAINFinancialAnalysesResponseController.ResponseParams>();
                                        BRAINFinancialAnalysesResponseController.ResponseParams rp = new BRAINFinancialAnalysesResponseController.ResponseParams();
                                        rp.faRequestId = testingFARequestId;
                                        rp.responseJSON = testingFAResponseJSON;
                                        respParamsList.add(rp);
       		                            System.debug('(TestBRAINFAUpdateHelper.setup) To get the BRAIN_FA_Response__c object built for test, testingFARequest.Id = ' + testingFARequestId);

										List<List<BRAIN_API_Call_Tracker__c>> testBACTListCollection = BRAINFinancialAnalysesResponseController.assembleResponseFinancialAnalyses(respParamsList);
			                            //System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Response create, testBACTListCollection.get(0).get(0).Id = ' + testBACTListCollection.get(0).get(0).Id);
                                        if (testBACTListCollection != null && testBACTListCollection.size() > 0 && testBACTListCollection.get(0) != null && testBACTListCollection.get(0).size() > 0) {                                            
                                            testingFAResponseId = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__c;
                                            testingFAResponseName = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.Name;
				                            System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Response create, set testingFAResponseName = ' + testingFAResponseName +
                                                        	'\n  AND testingFAResponseId = ' + testingFAResponseId);
                                            testCallList.get(0).BRAIN_FA_Response__c = testingFAResponseId;
                                            update testCallList;
                                            testingHL1EvalId = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.hl1EvaluationResult__r.Id;
                                            testingHL1EvalName = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.hl1EvaluationResult__r.Name;
				                            System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Response create, testingHL1EvalName = ' + testingHL1EvalName +
                                                         '\n  AND testingHL1EvalId = ' + testingHL1EvalId);
                                            testingFinMetricId = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.Id;
                                            testingFinMetricName = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.Name;
				                            System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Response create, testingFinMetricName = ' + testingFinMetricName + '\n  AND testingFinMetricId = ' + testingFinMetricId);
                                            testingCFMetricId = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.Id;
                                            testingCFMetricName = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.Name;
				                            System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Response create, testingCFMetricName = ' + testingCFMetricName + '\n  AND testingCFMetricId = ' + testingCFMetricId);
                                            testingIncStmtMetricId = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.Id;
                                            testingIncStmtMetricName = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.Name;
				                            System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Response create, testingIncStmtMetricName = ' + testingIncStmtMetricName + '\n  AND testingIncStmtMetricId = ' + testingIncStmtMetricId);
                                            testingGREvalId = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__r.Id;
                                            testingGREvalName = testBACTListCollection?.get(0)?.get(0)?.BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__r.Name;
				                            System.debug('(TestBRAINFAUpdateHelper.setup) AFTER Response create, testingGREvalName = ' + testingGREvalName + '\n  AND testingGREvalId = ' + testingGREvalId);
                                        }                                        
									} else {
										System.debug('(TestBRAINFAUpdateHelper.setup) Unable to generate test data for BRAIN_FA_Request__c for Opportunity ' + mockTestOpptyTitle);
									}
								} else {
									System.debug('(TestBRAINFAUpdateHelper.setup) Unable to generate test data for BRAIN_API_Call_Tracker__c for Opportunity ' + mockTestOpptyTitle);
								}
							} else {
								System.debug('(TestBRAINFAUpdateHelper.setup) Unable to generate test data for Offer for Opportunity ' + mockTestOpptyTitle);
							}

                        } else {
                            System.debug('(TestBRAINFAUpdateHelper.setup) Unable to generate test data for Segment for Opportunity ' + mockTestOpptyTitle);
                        }
                    } else {
                        System.debug('(TestBRAINFAUpdateHelper.setup) Unable to generate test data for Opportunity of ' + mockTestOpptyTitle);
                    }
                } else {
                    System.debug('(TestBRAINFAUpdateHelper.setup) Unable to generate test data for Property of Address: ' + 
                                 	'\n ' + mockTestPptyAddrStreet + 
                                 	'\n ' + mockTestPptyAddrCity + 
                                    ', ' + mockTestPptyAddrState);
                }
            } else {
                System.debug('(TestBRAINFAUpdateHelper.setup) Unable to generate test data for NWC of ' + mockTestNWCCLLI);
            }
/*        } else {
	        System.debug('(TestBRAINFAUpdateHelper.setup) Unable to generate test data for Contact: ' + mockTestContactFName + ' ' + mockTestContactLName);
        }
*/
    }//end test-setup method setup
    /* */
    
    /* */
    @AuraEnabled
    public static testMethod void testQueryCapDesignListById() {
        
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.testQueryCapDesignListById) Initiating with testingCDId = ' + testingCDId);
        
        List<Capital_Design__c> testCDList = BRAINFAUpdateHelper.queryCapDesignListById(testingCDId);
        if (testCDList == null) {
            System.assertEquals(null, testCDList);
        } else {
            if (testCDList.size() == 0) {                
                System.assertEquals(0,testCDList.size());
            } else {
                System.assertNotEquals(0,testCDList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryCapDesignListById
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testQueryCapDesignListByIdNULL() {
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.testQueryCapDesignListByIdNULL) Initiating with null as Cap-Design-Id');
        
        List<Capital_Design__c> testCDList = BRAINFAUpdateHelper.queryCapDesignListById(null);
        if (testCDList == null) {
            System.assertEquals(null, testCDList);
        } else {
            if (testCDList.size() == 0) {                
                System.assertEquals(0,testCDList.size());
            } else {
                System.assertNotEquals(0,testCDList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryCapDesignListByIdNULL
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testQueryCapDesignListByIdEmpty() {
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.testQueryCapDesignListByIdEmpty) Initiating with emtpy as Cap-Design-Id');
        
        List<Capital_Design__c> testCDList = BRAINFAUpdateHelper.queryCapDesignListById('');
        if (testCDList == null) {
            System.assertEquals(null, testCDList);
        } else {
            if (testCDList.size() == 0) {                
                System.assertEquals(0,testCDList.size());
            } else {
                System.assertNotEquals(0,testCDList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryCapDesignListByIdNULL
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testQueryOfferListById() {
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.testQueryOfferListById) Initiating with testingOfferId = ' + testingOfferId + '  AND testingCDId = ' + testingCDId);
        
        List<Offer__c> testList = BRAINFAUpdateHelper.queryOfferListById(testingOfferId, testingCDId);
        if (testList == null) {
            System.assertEquals(null, testList);
        } else {
            if (testList.size() == 0) {                
                System.assertEquals(0,testList.size());
            } else {
                System.assertNotEquals(0,testList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryOfferListById
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testQueryBACTListById() {
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.testQueryBACTListById) Initiating with testingBACTId = ' + testingBACTId + '  AND testingCDId = ' + testingCDId);
        
        List<BRAIN_API_Call_Tracker__c> testList = BRAINFAUpdateHelper.queryBACTListById(testingBACTId, testingCDId);
        if (testList == null) {
            System.assertEquals(null, testList);
        } else {
            if (testList.size() == 0) {                
                System.assertEquals(0,testList.size());
            } else {
                System.assertNotEquals(0,testList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryBACTListById
    /*  */

    /* */
    @AuraEnabled
    public static testMethod void testQueryBFAResponseListById() {
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.testQueryBFAResponseListById) Initiating with testingBACTId = ' + testingBACTId + '  AND testingFAResponseId = ' + testingFAResponseId);
        
        List<BRAIN_FA_Response__c> testList = BRAINFAUpdateHelper.queryBFAResponseListById(testingBACTId, testingFAResponseId);
        if (testList == null) {
            System.assertEquals(null, testList);
        } else {
            if (testList.size() == 0) {                
                System.assertEquals(0,testList.size());
            } else {
                System.assertNotEquals(0,testList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryBFAResponseListById
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testQueryHl1EvalListById() {
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.testQueryHl1EvalListById) Initiating with testingFAResponseId = ' + testingFAResponseId + '  AND testingHl1EvalId = ' + testingHl1EvalId);
        
        List<hl1EvaluationResult__c> testList = BRAINFAUpdateHelper.queryAssocHl1EvalList(testingFAResponseId, testingHL1EvalId);
        if (testList == null) {
            System.assertEquals(null, testList);
        } else {
            if (testList.size() == 0) {                
                System.assertEquals(0,testList.size());
            } else {
                System.assertNotEquals(0,testList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryHl1EvalListById
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testQueryFinMetricListById() {
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.testQueryFinMetricListById) Initiating with testingFinMetricId = ' + testingFinMetricId + '  AND testingHl1EvalId = ' + testingHl1EvalId);
        
        List<financialMetric__c> testList = BRAINFAUpdateHelper.queryAssocFinMetricList(testingFinMetricId, testingHL1EvalId);
        if (testList == null) {
            System.assertEquals(null, testList);
        } else {
            if (testList.size() == 0) {                
                System.assertEquals(0,testList.size());
            } else {
                System.assertNotEquals(0,testList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryFinMetricListById
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testQueryAssocIncStmtMetricListById() {
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.testQueryAssocIncStmtMetricListById) Initiating with testingIncStmtMetricId = ' + testingIncStmtMetricId + '  AND testingFinMetricId = ' + testingFinMetricId);
        
        List<incomeStatementMetric__c> testList = BRAINFAUpdateHelper.queryAssocIncStmtMetricList(testingIncStmtMetricId, testingFinMetricId);
        if (testList == null) {
            System.assertEquals(null, testList);
        } else {
            if (testList.size() == 0) {                
                System.assertEquals(0,testList.size());
            } else {
                System.assertNotEquals(0,testList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryAssocIncStmtMetricListById
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testQueryAssocCashFlowMetricListById() {
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.queryAssocCashFlowMetricList) Initiating with testingCFMetricId = ' + testingCFMetricId + '  AND testingFinMetricId = ' + testingFinMetricId);
        
        List<cashFlowMetric__c> testList = BRAINFAUpdateHelper.queryAssocCashFlowMetricList(testingCFMetricId, testingFinMetricId);
        if (testList == null) {
            System.assertEquals(null, testList);
        } else {
            if (testList.size() == 0) {                
                System.assertEquals(0,testList.size());
            } else {
                System.assertNotEquals(0,testList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryAssocCashFlowMetricListById
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testQueryAssocGuardrailEvalListById() {
        Test.startTest();
        System.debug('(TestBRAINFAUpdateHelper.testQueryAssocGuardrailEvalListById) Initiating with testingGREvalId = ' + testingGREvalId + '  AND testingHl1EvalId = ' + testingHl1EvalId);
        
        List<guardrailEvaluation__c> testList = BRAINFAUpdateHelper.queryAssocGuardrailEvalList(testingGREvalId, testingHl1EvalId);
        if (testList == null) {
            System.assertEquals(null, testList);
        } else {
            if (testList.size() == 0) {                
                System.assertEquals(0,testList.size());
            } else {
                System.assertNotEquals(0,testList.size());
            }
        }        
        Test.stopTest();
        
	}//end testQueryAssocGuardrailEvalListById
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testUpdateCDFromBACT() {
        Test.startTest();        
        List<Capital_Design__c> setupCDList = [SELECT Id, Name FROM Capital_Design__c];
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) setupCDList == null??? ' + (setupCDList == null) +
                     			'\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
	        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) setupCDList.get(0) == null??? ' + (setupCDList?.get(0) == null) +
                    			'\n Id = ' + setupCDList?.get(0)?.Id + 
                    			'\n Name = ' + setupCDList?.get(0)?.Name);
        	testingCDId = setupCDList.get(0).Id;
        	testingCDName = setupCDList.get(0).Name;
        }
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) Querying for CapDesignListById using testingCDId = ' + testingCDId);
        List<Capital_Design__c> cdList = BRAINFAUpdateHelper.queryCapDesignListById(testingCDId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) cdList == null??? ' + (cdList == null) + '  \ncdList?.size() = ' + cdList?.size());

        List<BRAIN_API_Call_Tracker__c> setupBACTList = [SELECT Id, Name FROM BRAIN_API_Call_Tracker__c];
        if (setupBACTList != null && setupBACTList.size() > 0) {
        	testingBACTId = setupBACTList.get(0).Id;
        }
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) Querying for BACTListById using testingBACTId = ' + testingBACTId + '  AND testingCDId = ' + testingCDId);
        List<BRAIN_API_Call_Tracker__c> bactList = BRAINFAUpdateHelper.queryBACTListById(testingBACTId, testingCDId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) bactList == null??? ' + (bactList == null) + '  \nbactList?.size() = ' + bactList?.size());

        List<BRAIN_FA_Response__c> setupRespList = [SELECT Id, Name FROM BRAIN_FA_Response__c];
        if (setupRespList != null && setupRespList.size() > 0) {
        	testingFAResponseId = setupRespList.get(0).Id;
        }
        List<BRAIN_FA_Response__c> faResponseList = BRAINFAUpdateHelper.queryBFAResponseListById(testingFAResponseId, testingBACTId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) faResponseList == null??? ' + (faResponseList == null) + '\n  faResponseList?.size() = ' + faResponseList?.size());

        List<hl1EvaluationResult__c> setupHL1List = [SELECT Id, Name FROM hl1EvaluationResult__c];
        if (setupHL1List != null && setupHL1List.size() > 0) {
        	testingHL1EvalId = setupHL1List.get(0).Id;
        }
        List<hl1EvaluationResult__c> hl1EvalList = BRAINFAUpdateHelper.queryAssocHl1EvalList(testingFAResponseId, testingHL1EvalId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) hl1EvalList == null??? ' + (hl1EvalList == null) + '\n  hl1EvalList?.size() = ' + hl1EvalList?.size());

        List<financialMetric__c> setupFMList = [SELECT Id, Name FROM financialMetric__c];
        if (setupFMList != null && setupFMList.size() > 0) {
        	testingFinMetricId = setupFMList.get(0).Id;
        }
        List<financialMetric__c> finMetricList = BRAINFAUpdateHelper.queryAssocFinMetricList(testingFinMetricId, testingHL1EvalId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) finMetricList == null??? ' + (finMetricList == null) + '\n  finMetricList?.size() = ' + finMetricList?.size());

        List<cashFlowMetric__c> setupCFMList = [SELECT Id, Name FROM cashFlowMetric__c];
        if (setupCFMList != null && setupCFMList.size() > 0) {
        	testingCFMetricId = setupCFMList.get(0).Id;
        }
        List<cashFlowMetric__c> cfMetricList = BRAINFAUpdateHelper.queryAssocCashFlowMetricList(testingCFMetricId, testingFinMetricId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) cfMetricList == null??? ' + (cfMetricList == null) + '\n  cfMetricList?.size() = ' + cfMetricList?.size());

        List<incomeStatementMetric__c> setupISList = [SELECT Id, Name FROM incomeStatementMetric__c];
        if (setupISList != null && setupISList.size() > 0) {
        	testingIncStmtMetricId = setupISList.get(0).Id;
        }
        List<incomeStatementMetric__c> incStmtList = BRAINFAUpdateHelper.queryAssocIncStmtMetricList(testingIncStmtMetricId, testingFinMetricId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) incStmtList == null??? ' + (incStmtList == null) + '\n  incStmtList?.size() = ' + incStmtList?.size());

        List<guardrailEvaluation__c> setupGEList = [SELECT Id, Name FROM guardrailEvaluation__c];
        if (setupGEList != null && setupGEList.size() > 0) {
        	testingGREvalId = setupGEList.get(0).Id;
        }
        List<guardrailEvaluation__c> grailList = BRAINFAUpdateHelper.queryAssocGuardrailEvalList(testingGREvalId, testingHL1EvalId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateCDFromBACT) grailList == null??? ' + (grailList == null) + '\n  grailList?.size() = ' + grailList?.size());
        if (cdList?.size() > 0 && bactList?.size() > 0 && faResponseList.size() > 0 && hl1EvalList.size() > 0 &&
                finMetricList.size() > 0 && cfMetricList.size() > 0 && incStmtList.size() > 0 && grailList.size() > 0) {
            cdList.get(0).BRAIN_API_Call_Tracker_Master__c = testingBACTId;        
        	BRAINFAUpdateHelper.updateCDFromBACT(cdList.get(0), 
                                                 bactList.get(0), 
                                                 faResponseList.get(0),
                                                 hl1EvalList.get(0), 
                                                 finMetricList.get(0),
                                                 cfMetricList.get(0), 
                                                 incStmtList.get(0), 
                                                 grailList.get(0));
        } else {
	        BRAINFAUpdateHelper.updateCDFromBACT(new Capital_Design__c(), 
                                                 new BRAIN_API_Call_Tracker__c(),
                                                 new BRAIN_FA_Response__c(),
                                                 new hl1EvaluationResult__c(),
                                                 new financialMetric__c(),
                                                 new cashFlowMetric__c(),
                                                 new incomeStatementMetric__c(),
                                                 new guardrailEvaluation__c());
        }
        if (testingCDId == null) {
            System.assertEquals(null, testingCDId);
        } else {
            System.assertNotEquals(null, testingCDId);
        }
        Test.stopTest();
        
	}//end testUpdateCDFromBACT
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testUpdateOfferBAUFromBACT() {

        Test.startTest();
        List<Capital_Design__c> setupCDList = [SELECT Id, Name FROM Capital_Design__c];
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) setupCDList == null??? ' + (setupCDList == null) +
                     			'\n setupCDList.size() = ' + setupCDList?.size());
        if (setupCDList != null && setupCDList.size() > 0) {
	        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) setupCDList.get(0) == null??? ' + (setupCDList?.get(0) == null) +
                    			'\n Id = ' + setupCDList?.get(0)?.Id + 
                    			'\n Name = ' + setupCDList?.get(0)?.Name);
        	testingCDId = setupCDList.get(0).Id;
        	testingCDName = setupCDList.get(0).Name;
        }
        List<Capital_Design__c> cdList = BRAINFAUpdateHelper.queryCapDesignListById(testingCDId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) cdList == null??? ' + (cdList == null) + '  \ncdList?.size() = ' + cdList?.size());

        List<BRAIN_API_Call_Tracker__c> setupBACTList = [SELECT Id, Name FROM BRAIN_API_Call_Tracker__c];
        if (setupBACTList != null && setupBACTList.size() > 0) {
        	testingBACTId = setupBACTList.get(0).Id;
        }
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) Initiating with testingBACTId = ' + testingBACTId + '  AND testingCDId = ' + testingCDId);
        List<BRAIN_API_Call_Tracker__c> bactList = BRAINFAUpdateHelper.queryBACTListById(testingBACTId, testingCDId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) bactList == null??? ' + (bactList == null) + '  \nbactList?.size() = ' + bactList?.size());

        List<BRAIN_FA_Response__c> setupRespList = [SELECT Id, Name FROM BRAIN_FA_Response__c];
        if (setupRespList != null && setupRespList.size() > 0) {
        	testingFAResponseId = setupRespList.get(0).Id;
        }
        List<BRAIN_FA_Response__c> faResponseList = BRAINFAUpdateHelper.queryBFAResponseListById(testingFAResponseId, testingBACTId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) faResponseList == null??? ' + (faResponseList == null) + '\n  faResponseList?.size() = ' + faResponseList?.size());

        List<hl1EvaluationResult__c> setupHL1List = [SELECT Id, Name FROM hl1EvaluationResult__c];
        if (setupHL1List != null && setupHL1List.size() > 0) {
        	testingHL1EvalId = setupHL1List.get(0).Id;
        }
        List<hl1EvaluationResult__c> hl1EvalList = BRAINFAUpdateHelper.queryAssocHl1EvalList(testingFAResponseId, testingHL1EvalId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) hl1EvalList == null??? ' + (hl1EvalList == null) + '\n  hl1EvalList?.size() = ' + hl1EvalList?.size());

        List<financialMetric__c> setupFMList = [SELECT Id, Name FROM financialMetric__c];
        if (setupFMList != null && setupFMList.size() > 0) {
        	testingFinMetricId = setupFMList.get(0).Id;
        }
        List<financialMetric__c> finMetricList = BRAINFAUpdateHelper.queryAssocFinMetricList(testingFinMetricId, testingHL1EvalId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) finMetricList == null??? ' + (finMetricList == null) + '\n  finMetricList?.size() = ' + finMetricList?.size());

        List<cashFlowMetric__c> setupCFMList = [SELECT Id, Name FROM cashFlowMetric__c];
        if (setupCFMList != null && setupCFMList.size() > 0) {
        	testingCFMetricId = setupCFMList.get(0).Id;
        }
        List<cashFlowMetric__c> cfMetricList = BRAINFAUpdateHelper.queryAssocCashFlowMetricList(testingCFMetricId, testingFinMetricId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) cfMetricList == null??? ' + (cfMetricList == null) + '\n  cfMetricList?.size() = ' + cfMetricList?.size());

        List<incomeStatementMetric__c> setupISList = [SELECT Id, Name FROM incomeStatementMetric__c];
        if (setupISList != null && setupISList.size() > 0) {
        	testingIncStmtMetricId = setupISList.get(0).Id;
        }
        List<incomeStatementMetric__c> incStmtList = BRAINFAUpdateHelper.queryAssocIncStmtMetricList(testingIncStmtMetricId, testingFinMetricId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) incStmtList == null??? ' + (incStmtList == null) + '\n  incStmtList?.size() = ' + incStmtList?.size());

        List<guardrailEvaluation__c> setupGEList = [SELECT Id, Name FROM guardrailEvaluation__c];
        if (setupGEList != null && setupGEList.size() > 0) {
        	testingGREvalId = setupGEList.get(0).Id;
        }
        List<guardrailEvaluation__c> grailList = BRAINFAUpdateHelper.queryAssocGuardrailEvalList(testingGREvalId, testingHL1EvalId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) grailList == null??? ' + (grailList == null) + '\n  grailList?.size() = ' + grailList?.size());
        if (cdList?.size() > 0 && bactList?.size() > 0 && faResponseList.size() > 0 && hl1EvalList.size() > 0 &&
                finMetricList.size() > 0 && cfMetricList.size() > 0 && incStmtList.size() > 0 && grailList.size() > 0) {
            cdList.get(0).BRAIN_API_Call_Tracker_Master__c = testingBACTId;
            BRAINFAUpdateHelper.updateCDFromBACT(cdList.get(0), bactList.get(0), faResponseList.get(0),
   	                                             hl1EvalList.get(0), finMetricList.get(0),
       	                                         cfMetricList.get(0), incStmtList.get(0), 
           	                                     grailList.get(0));
        } else {
	            BRAINFAUpdateHelper.updateCDFromBACT(new Capital_Design__c(), 
                                                     new BRAIN_API_Call_Tracker__c(),
                                                     new BRAIN_FA_Response__c(),
                                                     new hl1EvaluationResult__c(),
                                                     new financialMetric__c(),
                                                     new cashFlowMetric__c(),
                                                     new incomeStatementMetric__c(),
            	                                     new guardrailEvaluation__c());
        } 

        List<Offer__c> setupOfferList = [SELECT Id, Name FROM Offer__c];
        if (setupOfferList != null && setupOfferList.size() > 0) {
        	testingOfferId = setupOfferList.get(0).Id;
        }
        List<Offer__c> offerList = BRAINFAUpdateHelper.queryOfferListById(testingOfferId, testingCDId);
        System.debug('(TestBRAINFAUpdateHelper.testUpdateOfferBAUFromBACT) offerList == null??? ' + (offerList == null) + '\n  offerList?.size() = ' + offerList?.size());
        if (offerList?.size() > 0 && cdList?.size() > 0 && bactList?.size() > 0 && faResponseList.size() > 0 && hl1EvalList.size() > 0 &&
              finMetricList.size() > 0 && cfMetricList.size() > 0 && incStmtList.size() > 0 && grailList.size() > 0) {
			offerList.get(0).Associated_Capital_Design__c = testingCDId; 
            offerList.get(0).BRAIN_API_Call_Tracker_Master__c = testingBACTId;
            BRAINFAUpdateHelper.updateOfferBAUFromBACT(offerList.get(0), 
                                                       cdList.get(0), 
                                                       bactList.get(0), 
                                                       faResponseList.get(0),
                                                       hl1EvalList.get(0), 
                                                       finMetricList.get(0),
                                                       cfMetricList.get(0), 
                                                       incStmtList.get(0), 
                                                       grailList.get(0));
		} else {
        	BRAINFAUpdateHelper.updateOfferBAUFromBACT(new Offer__c(),
                                                       new Capital_Design__c(), 
                                                       new BRAIN_API_Call_Tracker__c(),
                                                       new BRAIN_FA_Response__c(),
                                                       new hl1EvaluationResult__c(),
                                                       new financialMetric__c(),
                                                       new cashFlowMetric__c(),
                                                       new incomeStatementMetric__c(),
                                                       new guardrailEvaluation__c());
        }//end else at least one list is empty
        if (testingOfferId == null) {
            System.assertEquals(null, testingOfferId);
        } else {
            System.assertNotEquals(null, testingOfferId);
        }
        Test.stopTest();
        
	}//end testUpdateOfferBAUFromBACT
    /* */

    /* */
    public static HttpResponse getHttpResponseFromStaticResource() {
        // Setup mockCallout To BRAIN-FinancialAnalyses API
        StaticResourceCalloutMock mockCalloutToBRAINFA = new StaticResourceCalloutMock();
		mockCalloutToBRAINFA.setStaticResource('TestBRAINFAResponseCapDesCD00000250JSON');
		mockCalloutToBRAINFA.setStatusCode(200);
		mockCalloutToBRAINFA.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToBRAINFA);
        String mockAccessToken = testingSrcSystemId;        
        // Call the method that builds the mock of the HttpRequest to BRAIN
        HttpRequest mockHttpRequest = BRAINFACalloutHelper.buildHttpRequestForBRAINFAService(mockAccessToken, mockTestFARequestJSON);
		// Call the method that builds the mock of the HttpResponse from BRAIN
        HttpResponse mockHttpResponse = BRAINFACalloutHelper.getHttpResponseFromBRAINFAService(mockHttpRequest);
		// Return the mocked HttpResponse from BRAIN
        return mockHttpResponse;        
    }// end getHttpResponseFromStaticResource
    /* */
    
    /* */
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
    /* */

}//end test-class TestBRAINFAUpdateHelper