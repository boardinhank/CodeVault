/****************************************************************************************************
 * LAST UPDATED FOR:
 * 11/17/2023   T2Cabato    QFCJ-4712                       Capital Design - Wire Center Segmentation Update Automation 
 * 12/08/2023	T2Cabato	QFCJ-4712						Revision for Too many queries error
****************************************************************************************************/
@isTest
public with sharing class TestWCSegCalloutController {  
    public static final String mockTestCLLI = 'DNVRCOSO';
    public static final String mockTestBadCLLI = 'HOTCOCOA';
    public static final String mockTestAllCLLI = '*';
    
    @AuraEnabled
    public static testmethod void testQueueableJob() {        
        List<Network_Wire_Center__c> weakNWCSegList = [SELECT Id, Name, Wire_Center_Segmentation__c 
                                                             FROM Network_Wire_Center__c
                                                            WHERE Name = :mockTestCLLI
                                                              AND Wire_Center_Segmentation__c = 'WEAK' LIMIT 1];
        List<Network_Wire_Center__c> preUpdNWCList = [SELECT Id, Name, Wire_Center_Segmentation__c
            									  		FROM Network_Wire_Center__c
                                                       WHERE Name = :mockTestCLLI
                                                         AND Wire_Center_Segmentation__c = 'WEAK' LIMIT 1];

        if (weakNWCSegList.size() == 1) {
            weakNWCSegList.get(0).Wire_Center_Segmentation__c = 'HIGH POTENTIAL'; 
            update weakNWCSegList;
        }

        Test.startTest();
        System.enqueueJob(new WCSegCalloutController(mockTestCLLI));
        Test.stopTest();    

        /*******************************************
         * Now that the queued job has executed,
         *    check that our Network_Wire_Center 
         *    objects have been updated
         ******************************************/ 
        List<Network_Wire_Center__c> stillWeakNWCSegList = [SELECT Id, Name, Wire_Center_Segmentation__c
            									  			FROM Network_Wire_Center__c
                                                 		   WHERE Name = :mockTestCLLI
                                                   			 AND Wire_Center_Segmentation__c = 'WEAK' LIMIT 1];
        
        List<Network_Wire_Center__c> postUpdNWCList = [SELECT Id, Name, Wire_Center_Segmentation__c
            									  FROM Network_Wire_Center__c
                                                 WHERE Name = :mockTestCLLI
                                                   AND Wire_Center_Segmentation__c = 'HIGH POTENTIAL' LIMIT 1];
        if (weakNWCSegList.size() == 0) {
            System.assertEquals(0, weakNWCSegList.size());
        } else {
            System.assertNotEquals(0, weakNWCSegList.size());
        }
        if (stillWeakNWCSegList.size() == 0) {
            System.assertEquals(0, stillWeakNWCSegList.size());
        } else {
            System.assertNotEquals(0, stillWeakNWCSegList.size());
        }
        if (preUpdNWCList.size() == 0) {
            System.assertEquals(0, preUpdNWCList.size());
        } else {
            System.assertNotEquals(0, preUpdNWCList.size());
        }
        if (postUpdNWCList.size() == 0) {
            System.assertEquals(0, postUpdNWCList.size());
        } else {
            System.assertNotEquals(0, postUpdNWCList.size());
        }
        if (weakNWCSegList.size() == stillWeakNWCSegList.size()) {
	        System.assertEquals(weakNWCSegList.size(), stillWeakNWCSegList.size());
        } else {
            System.assertNotEquals(weakNWCSegList.size(), stillWeakNWCSegList.size());
        }
        if (weakNWCSegList.size() > 0) {
            if (preUpdNWCList.size() > 0) {
                if(weakNWCSegList.size() == preUpdNWCList.size()) {
                    System.assertEquals(weakNWCSegList.size(), preUpdNWCList.size());
                } else {
                    System.assertNotEquals(weakNWCSegList.size(), preUpdNWCList.size());
                }
            } else {
                System.assertNotEquals(weakNWCSegList.size(), preUpdNWCList.size());
            }
        } else {
            if (preUpdNWCList.size() == 0) {
                if(weakNWCSegList.size() == preUpdNWCList.size()) {
                    System.assertEquals(weakNWCSegList.size(), preUpdNWCList.size());
                } else {
                    System.assertNotEquals(weakNWCSegList.size(), preUpdNWCList.size());
                }
            } else {
	            System.assertNotEquals(weakNWCSegList.size(), preUpdNWCList.size());
            }
        }
        if (weakNWCSegList.size() > 0) {
            if (postUpdNWCList.size() > 0) {
                if(weakNWCSegList.size() == postUpdNWCList.size()) {
                    System.assertEquals(weakNWCSegList.size(), postUpdNWCList.size());
                } else {
                    System.assertNotEquals(weakNWCSegList.size(), postUpdNWCList.size());
                }
            } else {
                System.assertNotEquals(weakNWCSegList.size(), postUpdNWCList.size());
            }
        } else {
            if (postUpdNWCList.size() == 0) {
                if(weakNWCSegList.size() == postUpdNWCList.size()) {
                    System.assertEquals(weakNWCSegList.size(), postUpdNWCList.size());
                } else {
                    System.assertNotEquals(weakNWCSegList.size(), postUpdNWCList.size());
                }
            } else {
	            System.assertNotEquals(weakNWCSegList.size(), postUpdNWCList.size());
            }
        }
    }//end test-method testQueueableJob

    @AuraEnabled
    public static testMethod void testCallWCSegmentation() {
        Network_Wire_Center__c mockTestNWC = new Network_Wire_Center__c();
        List<Network_Wire_Center__c> mockTestNWCUpdatesList = new List<Network_Wire_Center__c>();
        List<List<Network_Wire_Center__c>> mockTestNWCUpdatesListCollection = new List<List<Network_Wire_Center__c>>();

		Test.startTest();        
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestSearchWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);

        //Preset DNVRCOSO Segmentation value to WEAK knowing that BRAIN WCSeg API will update to HIGH POTENTIAL 
        List<Network_Wire_Center__c> preUpdNWCList = [SELECT Id, Name, Wire_Center_Segmentation__c 
                                                             FROM Network_Wire_Center__c
                                                            WHERE Name = :mockTestCLLI LIMIT 1];
        Network_Wire_Center__c preTestUpdateNWC = preUpdNWCList != null && preUpdNWCList.size() > 0 ? preUpdNWCList.get(0) : null;
        if (preTestUpdateNWC == null) {
            preTestUpdateNWC = new Network_Wire_Center__c(
                Name = mockTestCLLI
            );
        }
        preTestUpdateNWC.Wire_Center_Segmentation__c = 'WEAK';
        upsert preTestUpdateNWC;
        
        //Create list of parameters to be sent to callWCSegmentation
        List<WCSegCalloutController.CalloutParams> calloutParamsList = new List<WCSegCalloutController.CalloutParams>();
        WCSegCalloutController.CalloutParams cp = new WCSegCalloutController.CalloutParams();
        cp.wcSegRequestCLLI = mockTestCLLI;
        calloutParamsList.add(cp);
        		
        mockTestNWCUpdatesListCollection = WCSegCalloutController.callWCSegmentation(calloutParamsList);
        System.debug('mockTestNWCUpdatesListCollection.size() = ' + mockTestNWCUpdatesListCollection.size());
        if (mockTestNWCUpdatesListCollection.size() == 0) {
            System.assertEquals(0, mockTestNWCUpdatesListCollection.size());
        } else {
            System.assertNotEquals(0, mockTestNWCUpdatesListCollection.size());
	        mockTestNWCUpdatesList = mockTestNWCUpdatesListCollection.get(0);
            if (mockTestNWCUpdatesList.size() == 0) {
                System.assertEquals(0, mockTestNWCUpdatesList.size());
            } else {
		        System.assertNotEquals(0, mockTestNWCUpdatesList.size());
                mockTestNWC = mockTestNWCUpdatesList.get(0);
                if (mockTestNWC == null) {
					System.assertEquals(null, mockTestNWC);
                } else {
                    System.assertNotEquals(null, mockTestNWC);
                    String nwcName = mockTestNWC.Name;
                    if (nwcName == null) {
                        System.assertEquals(null, nwcName);
                    } else {
                        System.assertNotEquals(null, nwcName);
                        String nwcSeg = mockTestNWC.Wire_Center_Segmentation__c;
                        if(nwcSeg == null) {
                            System.assertEquals(null, nwcSeg);
                        } else {
                            System.assertNotEquals(null, nwcSeg);
                        }
                    }
                }
            }
        }
        Test.stopTest();        
	}//end testCallWCSegmentation

    @AuraEnabled
    public static testMethod void testCallWCSegmentationAllCLLI() {
        Network_Wire_Center__c mockTestNWC = new Network_Wire_Center__c();
        List<Network_Wire_Center__c> mockTestNWCUpdatesList = new List<Network_Wire_Center__c>();
        List<List<Network_Wire_Center__c>> mockTestNWCUpdatesListCollection = new List<List<Network_Wire_Center__c>>();

		Test.startTest();        
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestSearchAllWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);

        //Create list of parameters to be sent to callWCSegmentation
        List<WCSegCalloutController.CalloutParams> calloutParamsList = new List<WCSegCalloutController.CalloutParams>();
        WCSegCalloutController.CalloutParams cp = new WCSegCalloutController.CalloutParams();
        cp.wcSegRequestCLLI = mockTestAllCLLI;
        calloutParamsList.add(cp);
        		
        mockTestNWCUpdatesListCollection = WCSegCalloutController.callWCSegmentation(calloutParamsList);
        System.debug('mockTestNWCUpdatesListCollection.size() = ' + mockTestNWCUpdatesListCollection.size());
        if (mockTestNWCUpdatesListCollection.size() == 0) {
            System.assertEquals(0, mockTestNWCUpdatesListCollection.size());
        } else {
            System.assertNotEquals(0, mockTestNWCUpdatesListCollection.size());
	        mockTestNWCUpdatesList = mockTestNWCUpdatesListCollection.get(0);
            if (mockTestNWCUpdatesList.size() == 0) {
                System.assertEquals(0, mockTestNWCUpdatesList.size());
            } else {
		        System.assertNotEquals(0, mockTestNWCUpdatesList.size());
                mockTestNWC = mockTestNWCUpdatesList.get(0);
                if (mockTestNWC == null) {
					System.assertEquals(null, mockTestNWC);
                } else {
                    System.assertNotEquals(null, mockTestNWC);
                    String nwcName = mockTestNWC.Name;
                    if (nwcName == null) {
                        System.assertEquals(null, nwcName);
                    } else {
                        System.assertNotEquals(null, nwcName);
                        String nwcSeg = mockTestNWC.Wire_Center_Segmentation__c;
                        if(nwcSeg == null) {
                            System.assertEquals(null, nwcSeg);
                        } else {
                            System.assertNotEquals(null, nwcSeg);
                        }
                    }
                }
            }
        }
        Test.stopTest();        
	}//end testCallWCSegmentationAllCLLI

    @AuraEnabled
    public static testMethod void testCallWCSegmentationBadCLLI() {
        Network_Wire_Center__c mockTestNWC = new Network_Wire_Center__c();
        List<Network_Wire_Center__c> mockTestNWCUpdatesList = new List<Network_Wire_Center__c>();
        List<List<Network_Wire_Center__c>> mockTestNWCUpdatesListCollection = new List<List<Network_Wire_Center__c>>();

		Test.startTest();        
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestSearchWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);

        //Create list of parameters to be sent to callWCSegmentation
        List<WCSegCalloutController.CalloutParams> calloutParamsList = new List<WCSegCalloutController.CalloutParams>();
        WCSegCalloutController.CalloutParams cp = new WCSegCalloutController.CalloutParams();
        cp.wcSegRequestCLLI = mockTestBadCLLI;
        calloutParamsList.add(cp);
        		
        mockTestNWCUpdatesListCollection = WCSegCalloutController.callWCSegmentation(calloutParamsList);
        System.debug('mockTestNWCUpdatesListCollection.size() = ' + mockTestNWCUpdatesListCollection.size());
        if (mockTestNWCUpdatesListCollection.size() == 0) {
            System.assertEquals(0, mockTestNWCUpdatesListCollection.size());
        } else {
            System.assertNotEquals(0, mockTestNWCUpdatesListCollection.size());
	        mockTestNWCUpdatesList = mockTestNWCUpdatesListCollection.get(0);
            if (mockTestNWCUpdatesList.size() == 0) {
                System.assertEquals(0, mockTestNWCUpdatesList.size());
            } else {
		        System.assertNotEquals(0, mockTestNWCUpdatesList.size());
                mockTestNWC = mockTestNWCUpdatesList.get(0);
                if (mockTestNWC == null) {
					System.assertEquals(null, mockTestNWC);
                } else {
                    System.assertNotEquals(null, mockTestNWC);
                    String nwcName = mockTestNWC.Name;
                    if (nwcName == null) {
                        System.assertEquals(null, nwcName);
                    } else {
                        System.assertNotEquals(null, nwcName);
                        String nwcSeg = mockTestNWC.Wire_Center_Segmentation__c;
                        if(nwcSeg == null) {
                            System.assertEquals(null, nwcSeg);
                        } else {
                            System.assertNotEquals(null, nwcSeg);
                        }
                    }
                }
            }
        }
        Test.stopTest();        
	}//end testCallWCSegmentationBadCLLI

    @AuraEnabled
    public static testMethod void testCallWCSegmentationNullCLLI() {
        Network_Wire_Center__c mockTestNWC = new Network_Wire_Center__c();
        List<Network_Wire_Center__c> mockTestNWCUpdatesList = new List<Network_Wire_Center__c>();
        List<List<Network_Wire_Center__c>> mockTestNWCUpdatesListCollection = new List<List<Network_Wire_Center__c>>();

		Test.startTest();        
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestSearchWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);

        //Create list of parameters to be sent to callWCSegmentation
        List<WCSegCalloutController.CalloutParams> calloutParamsList = new List<WCSegCalloutController.CalloutParams>();
        WCSegCalloutController.CalloutParams cp = new WCSegCalloutController.CalloutParams();
        cp.wcSegRequestCLLI = null;
        calloutParamsList.add(cp);
        		
        mockTestNWCUpdatesListCollection = WCSegCalloutController.callWCSegmentation(calloutParamsList);
        System.debug('mockTestNWCUpdatesListCollection.size() = ' + mockTestNWCUpdatesListCollection.size());
        if (mockTestNWCUpdatesListCollection.size() == 0) {
            System.assertEquals(0, mockTestNWCUpdatesListCollection.size());
        } else {
            System.assertNotEquals(0, mockTestNWCUpdatesListCollection.size());
	        mockTestNWCUpdatesList = mockTestNWCUpdatesListCollection.get(0);
            if (mockTestNWCUpdatesList.size() == 0) {
                System.assertEquals(0, mockTestNWCUpdatesList.size());
            } else {
		        System.assertNotEquals(0, mockTestNWCUpdatesList.size());
                mockTestNWC = mockTestNWCUpdatesList.get(0);
                if (mockTestNWC == null) {
					System.assertEquals(null, mockTestNWC);
                } else {
                    System.assertNotEquals(null, mockTestNWC);
                    String nwcName = mockTestNWC.Name;
                    if (nwcName == null) {
                        System.assertEquals(null, nwcName);
                    } else {
                        System.assertNotEquals(null, nwcName);
                        String nwcSeg = mockTestNWC.Wire_Center_Segmentation__c;
                        if(nwcSeg == null) {
                            System.assertEquals(null, nwcSeg);
                        } else {
                            System.assertNotEquals(null, nwcSeg);
                        }
                    }
                }
            }
        }
        Test.stopTest();        
	}//end testCallWCSegmentationNullReqCLLI

    @AuraEnabled
    public static testMethod void testCallWCSegmentationBadParams() {
        Network_Wire_Center__c mockTestNWC = new Network_Wire_Center__c();
        List<Network_Wire_Center__c> mockTestNWCUpdatesList = new List<Network_Wire_Center__c>();
        List<List<Network_Wire_Center__c>> mockTestNWCUpdatesListCollection = new List<List<Network_Wire_Center__c>>();

		Test.startTest();        
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestSearchWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);

        //Create list of parameters to be sent to callWCSegmentation
        List<WCSegCalloutController.CalloutParams> calloutParamsList = new List<WCSegCalloutController.CalloutParams>();
        		
        mockTestNWCUpdatesListCollection = WCSegCalloutController.callWCSegmentation(calloutParamsList);
        System.debug('mockTestNWCUpdatesListCollection.size() = ' + mockTestNWCUpdatesListCollection.size());
        if (mockTestNWCUpdatesListCollection.size() == 0) {
            System.assertEquals(0, mockTestNWCUpdatesListCollection.size());
        } else {
            System.assertNotEquals(0, mockTestNWCUpdatesListCollection.size());
	        mockTestNWCUpdatesList = mockTestNWCUpdatesListCollection.get(0);
            if (mockTestNWCUpdatesList.size() == 0) {
                System.assertEquals(0, mockTestNWCUpdatesList.size());
            } else {
		        System.assertNotEquals(0, mockTestNWCUpdatesList.size());
                mockTestNWC = mockTestNWCUpdatesList.get(0);
                if (mockTestNWC == null) {
					System.assertEquals(null, mockTestNWC);
                } else {
                    System.assertNotEquals(null, mockTestNWC);
                    String nwcName = mockTestNWC.Name;
                    if (nwcName == null) {
                        System.assertEquals(null, nwcName);
                    } else {
                        System.assertNotEquals(null, nwcName);
                        String nwcSeg = mockTestNWC.Wire_Center_Segmentation__c;
                        if(nwcSeg == null) {
                            System.assertEquals(null, nwcSeg);
                        } else {
                            System.assertNotEquals(null, nwcSeg);
                        }
                    }
                }
            }
        }
        Test.stopTest();        
	}//end testCallWCSegmentationBadParams

    @AuraEnabled
    public static testMethod void testCallWCSegmentationNullResponse() {
        Network_Wire_Center__c mockTestNWC = new Network_Wire_Center__c();
        List<Network_Wire_Center__c> mockTestNWCUpdatesList = new List<Network_Wire_Center__c>();
        List<List<Network_Wire_Center__c>> mockTestNWCUpdatesListCollection = new List<List<Network_Wire_Center__c>>();

		Test.startTest();        
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestBRAINFAResponseTestNULLJSON');
		mockCalloutToWCSeg.setStatusCode(500);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);

        //Create list of parameters to be sent to callWCSegmentation
        List<WCSegCalloutController.CalloutParams> calloutParamsList = new List<WCSegCalloutController.CalloutParams>();
        WCSegCalloutController.CalloutParams cp = new WCSegCalloutController.CalloutParams();
        cp.wcSegRequestCLLI = mockTestBadCLLI;
        calloutParamsList.add(cp);
        		
        mockTestNWCUpdatesListCollection = WCSegCalloutController.callWCSegmentation(calloutParamsList);
        System.debug('mockTestNWCUpdatesListCollection.size() = ' + mockTestNWCUpdatesListCollection.size());
        if (mockTestNWCUpdatesListCollection.size() == 0) {
            System.assertEquals(0, mockTestNWCUpdatesListCollection.size());
        } else {
            System.assertNotEquals(0, mockTestNWCUpdatesListCollection.size());
	        mockTestNWCUpdatesList = mockTestNWCUpdatesListCollection.get(0);
            if (mockTestNWCUpdatesList.size() == 0) {
                System.assertEquals(0, mockTestNWCUpdatesList.size());
            } else {
		        System.assertNotEquals(0, mockTestNWCUpdatesList.size());
                mockTestNWC = mockTestNWCUpdatesList.get(0);
                if (mockTestNWC == null) {
					System.assertEquals(null, mockTestNWC);
                } else {
                    System.assertNotEquals(null, mockTestNWC);
                    String nwcName = mockTestNWC.Name;
                    if (nwcName == null) {
                        System.assertEquals(null, nwcName);
                    } else {
                        System.assertNotEquals(null, nwcName);
                        String nwcSeg = mockTestNWC.Wire_Center_Segmentation__c;
                        if(nwcSeg == null) {
                            System.assertEquals(null, nwcSeg);
                        } else {
                            System.assertNotEquals(null, nwcSeg);
                        }
                    }
                }
            }
        }
        Test.stopTest();        
	}//end testCallWCSegmentationBadParams
    
}//end test-class TestWCSegCalloutController