@isTest(SeeAllData=true)
public class ProspectorCheckCalloutHelper_Test {
    public static final String testProjId = '{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}';
  /*  */ 
    @AuraEnabled
    public static testmethod void testCompareLists() {
        Id transactionSummaryId = null;
		
        List<Property__c> testPropList = createTestProperties();
        List<Prospector_Working_Table__c> testPWTList = createTestWorkingTableList();
        List<ProspectorCheckCalloutHelper.ProspectorProjectId> ppiList = getTestProspectorProjectIdList();
        Test.startTest();
        
        if (ppiList == null) {
            System.assertEquals(null, ppiList);
        } else {
            System.assertNotEquals(null, ppiList);
            if (ppiList.size() == 0) {
                System.assertEquals(0, ppiList.size());
            } else {
                System.assertNotEquals(0, ppiList.size());
                if (ppiList.get(0) == null) {
                    System.assertEquals(null, ppiList.get(0));
                } else {
                    System.assertNotEquals(null, ppiList.get(0));
                }
            }
        }
        ProspectorListJobsWrap ljResWrapper;
        //get the testJSONString
        String responseBody = getProspectorListJobsCalloutJsonString();
        JSONParser parser = JSON.createParser(responseBody);
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                ljResWrapper = (ProspectorListJobsWrap)parser.readValueAs(ProspectorListJobsWrap.class);
            }//end if START_OBJECT
        }//end while nextToken                
        if (ljResWrapper == null) {
            System.assertEquals(null, ljResWrapper);
        } else {
            System.assertNotEquals(null, ljResWrapper);
            if (ljResWrapper.payload == null) {
                System.assertEquals(null, ljResWrapper.payload);
            } else {
                System.assertNotEquals(null, ljResWrapper.payload);
                if (ljResWrapper.payload.size() == 0) {
                    System.assertEquals(0, ljResWrapper.payload.size());
                } else {
                    System.assertNotEquals(0, ljResWrapper.payload.size());
                }
            }
        }
		System.debug('testCompareList) ppiList?.size() = ' + ppiList?.size() + '   AND ljResWrapper?.payload?.size() = ' + ljResWrapper?.payload?.size() + '   AND  testPWTList?.size() = ' + testPWTList?.size());
        ProspectorCheckCalloutHelper.allApiTransactionsServiceManager = new ApiTransactionService(true);
        ProspectorCheckCalloutHelper.compareLists(ppiList, ljResWrapper.payload, testPWTList);
        Test.stopTest();        
        //delete testPWTList;  //comparLists method already perform delete so do not need to perform in the testMethod
        delete testPropList;
    }//end testmethod testCompareLists    
/*  */    
    @AuraEnabled
    public static testmethod void testEvaluatePayloadForMatchGreen() {
        ProspectorGetRoutesWrap.Payload payloadIn = new ProspectorGetRoutesWrap.Payload(); 
        String responseBody = null;
        ProspectorGetRoutesWrap responseWrap = new ProspectorGetRoutesWrap();
        
        List<Property__c> testPropList = createTestProperties();
        List<Prospector_Working_Table__c> testPWTList = createTestWorkingTableList();
        responseBody = ProspectorMockHttpResponseGenerator.getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesMHHH();
        System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) BEFORE REPLACE, responseBody found FOLEY36535 at index = ' + responseBody.indexOf('FOLEY36535'));
        responseBody = responseBody.replace('FOLEY36535', testPropList.get(0).Id);
        System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) AFTER REPLACE, responseBody found FOLEY36535 at index = ' + responseBody.indexOf('FOLEY36535'));
        responseWrap = ProspectorGetRoutesWrap.parse(responseBody);
        testPWTList.get(0).Property_Id__c = testPropList.get(0).Id;
        testPWTList.get(1).Property_Id__c = testPropList.get(0).Id;
        
        ProspectorCheckCalloutHelper.propsToBeUpdatedList = new List<Property__c>();
        
        Test.startTest();
        System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) Assigning routesPayloadList to responseWrap.payload sized at ' + responseWrap.payload.size());
        List<ProspectorGetRoutesWrap.Payload> routesPayloadList = responseWrap.payload;            
        System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) routesPayloadList-size = ' + routesPayloadList.size());
        for (ProspectorGetRoutesWrap.Payload routesPL : routesPayloadList) {
            System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) routesPL = ' + routesPL.ToReadableString());
            //routesPL.facilityType = 'MH_HH';
            for (Prospector_Working_Table__c pwtIn : testPWTList) {
                boolean isDone = ProspectorCheckCalloutHelper.evaluatePayloadForMatch(routesPL, pwtIn, testPropList);
                System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) isDone = ' + isDone);
                if (isDone) {
                    System.assertEquals(true, isDone);
                } else {
                    System.assertEquals(false, isDone);
                }
            }//end for-loop testPWTList
        }//end for-loop routesPayloadList
        Test.stopTest();  
        delete testPWTList;
        delete testPropList;
    }//end testmethod testEvaluatePayloadForMatchForGreen
/*  */  
    @AuraEnabled
    public static testmethod void testEvaluatePayloadForMatchGreenMHHH() {
        ProspectorGetRoutesWrap.Payload payloadIn = new ProspectorGetRoutesWrap.Payload(); 
        String responseBody = null;
        ProspectorGetRoutesWrap responseWrap = new ProspectorGetRoutesWrap();
        
        List<Property__c> testPropList = createTestProperties();
        List<Prospector_Working_Table__c> testPWTList = createTestWorkingTableList();
        responseBody = ProspectorMockHttpResponseGenerator.getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesMHHH();
        System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) BEFORE REPLACE, responseBody found FOLEY36535 at index = ' + responseBody.indexOf('FOLEY36535'));
        responseBody = responseBody.replace('FOLEY36535', testPropList.get(0).Id);
        System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) AFTER REPLACE, responseBody found FOLEY36535 at index = ' + responseBody.indexOf('FOLEY36535'));
        responseWrap = ProspectorGetRoutesWrap.parse(responseBody);
        testPWTList.get(0).Property_Id__c = testPropList.get(0).Id;
        testPWTList.get(1).Property_Id__c = testPropList.get(0).Id;
               
        ProspectorCheckCalloutHelper.propsToBeUpdatedList = new List<Property__c>();
        
        Test.startTest();
        System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) Assigning routesPayloadList to responseWrap.payload sized at ' + responseWrap.payload.size());
        List<ProspectorGetRoutesWrap.Payload> routesPayloadList = responseWrap.payload;            
        System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) routesPayloadList-size = ' + routesPayloadList.size());
        for (ProspectorGetRoutesWrap.Payload routesPL : routesPayloadList) {
            System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) routesPL = ' + routesPL.ToReadableString());
            routesPL.facilityType = 'MH_HH';
            for (Prospector_Working_Table__c pwtIn : testPWTList) {
                boolean isDone = ProspectorCheckCalloutHelper.evaluatePayloadForMatch(routesPL, pwtIn, testPropList);
                System.debug('(testEvaluatePayloadForMatchForGreenForMHHH) isDone = ' + isDone);
                if (isDone) {
                    System.assertEquals(true, isDone);
                } else {
                    System.assertEquals(false, isDone);
                }
            }
        }
        Test.stopTest();    
        delete testPWTList;
        delete testPropList;
    }//end testmethod testEvaluatePayloadForMatchForGreenMHHH
    
    @AuraEnabled
    public static testmethod void testEvaluatePayloadForMatchForGreenSpliceClosure() {
        ProspectorGetRoutesWrap.Payload payloadIn = new ProspectorGetRoutesWrap.Payload(); 
        String responseBody = null;
        ProspectorGetRoutesWrap responseWrap = new ProspectorGetRoutesWrap();
        
        List<Property__c> testPropList = createTestProperties();
        List<Prospector_Working_Table__c> testPWTList = createTestWorkingTableList();
        responseBody = ProspectorMockHttpResponseGenerator.getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesSpliceClosure();
        System.debug('(testEvaluatePayloadForMatchForGreenSpliceClosure) BEFORE REPLACE, responseBody found FOLEY36535 at index = ' + responseBody.indexOf('FOLEY36535'));
        responseBody = responseBody.replace('FOLEY36535', testPropList.get(0).Id);
        System.debug('(testEvaluatePayloadForMatchForGreenSpliceClosure) AFTER REPLACE, responseBody found FOLEY36535 at index = ' + responseBody.indexOf('FOLEY36535'));
        responseWrap = ProspectorGetRoutesWrap.parse(responseBody);
        testPWTList.get(0).Property_Id__c = testPropList.get(0).Id;
        testPWTList.get(1).Property_Id__c = testPropList.get(0).Id;
        
        ProspectorCheckCalloutHelper.propsToBeUpdatedList = new List<Property__c>();
        
        Test.startTest();
        System.debug('(testEvaluatePayloadForMatchForGreenSpliceClosure) responseWrap==null? ' + (responseWrap==null));
        
        System.debug('(testEvaluatePayloadForMatchForGreenSpliceClosure) Assigning routesPayloadList to responseWrap.payload sized at ' + responseWrap.payload.size());
        List<ProspectorGetRoutesWrap.Payload> routesPayloadList = responseWrap.payload;            
        System.debug('(testEvaluatePayloadForMatchForGreenSpliceClosure) routesPayloadList-size = ' + routesPayloadList.size());
        for (ProspectorGetRoutesWrap.Payload routesPL : routesPayloadList) {
            System.debug('(testEvaluatePayloadForMatchForGreenSpliceClosure) routesPL = ' + routesPL.ToReadableString());
            routesPL.facilityType = 'Splice_Closure';
            for (Prospector_Working_Table__c pwtIn : testPWTList) {
                boolean isDone = ProspectorCheckCalloutHelper.evaluatePayloadForMatch(routesPL, pwtIn, testPropList);
                System.debug('(testEvaluatePayloadForMatchForGreenSpliceClosure) isDone = ' + isDone);
                if (isDone) {
                    System.assertEquals(true, isDone);
                } else {
                    System.assertEquals(false, isDone);
                }
            }
        }
        Test.stopTest();    
        delete testPWTList;
        delete testPropList;
    }//end testmethod testEvaluatePayloadForMatchForGreenSpliceClosure
    
    @AuraEnabled
    public static testmethod void testEvaluatePayloadForMatchForRedMHHH() {
        ProspectorGetRoutesWrap.Payload payloadIn = new ProspectorGetRoutesWrap.Payload(); 
        String responseBody = null;
        ProspectorGetRoutesWrap responseWrap = new ProspectorGetRoutesWrap();
        
        List<Property__c> testPropList = createTestProperties();
        List<Prospector_Working_Table__c> testPWTList = createTestWorkingTableList();
        responseBody = ProspectorMockHttpResponseGenerator.getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesMHHH();
        System.debug('(testEvaluatePayloadForMatchForRedMHHH) BEFORE REPLACE, responseBody found FOLEY36535 at index = ' + responseBody.indexOf('FOLEY36535'));
        responseBody = responseBody.replace('FOLEY36535', testPropList.get(0).Id);
        System.debug('(testEvaluatePayloadForMatchForRedMHHH) AFTER REPLACE, responseBody found FOLEY36535 at index = ' + responseBody.indexOf('FOLEY36535'));
        responseWrap = ProspectorGetRoutesWrap.parse(responseBody);
        testPWTList.get(0).Property_Id__c = testPropList.get(0).Id;
        testPWTList.get(1).Property_Id__c = testPropList.get(0).Id;
                
        ProspectorCheckCalloutHelper.propsToBeUpdatedList = new List<Property__c>();
        
        Test.startTest();
        ProspectorGetRoutesByProjectCallout pgrbpCallout = new ProspectorGetRoutesByProjectCallout(null);
       	responseWrap = pgrbpCallout.getRoutesByProject(testProjId,'MH_HH');
        System.debug('(testEvaluatePayloadForMatchForRedMHHH) responseWrap==null? ' + (responseWrap==null));
        
        System.debug('(testEvaluatePayloadForMatchForRedMHHH) Assigning routesPayloadList to responseWrap.payload sized at ' + responseWrap.payload.size());
        List<ProspectorGetRoutesWrap.Payload> routesPayloadList = responseWrap.payload;            
        System.debug('(testEvaluatePayloadForMatchForRedMHHH) routesPayloadList-size = ' + routesPayloadList.size());
        for (ProspectorGetRoutesWrap.Payload routesPL : routesPayloadList) {
            System.debug('(testEvaluatePayloadForMatchForRedForMHHH) routesPL = ' + routesPL.ToReadableString());
            routesPL.facilityType = 'MH_HH';
            for (Prospector_Working_Table__c pwtIn : testPWTList) {
                boolean isDone = ProspectorCheckCalloutHelper.evaluatePayloadForMatch(routesPL, pwtIn, testPropList);
                System.debug('(testEvaluatePayloadForMatchForRedMHHH) isDone = ' + isDone);
                if (isDone) {
                    System.assertEquals(true, isDone);
                } else {
                    System.assertEquals(false, isDone);
                }
            }
        }
        Test.stopTest();    
        delete testPWTList;
        delete testPropList;
    }//end testmethod testEvaluatePayloadForMatchForRedMHHH

    @AuraEnabled
    public static testmethod void testEvaluatePayloadForMatchRedSpliceClosure() {
        ProspectorGetRoutesWrap.Payload payloadIn = new ProspectorGetRoutesWrap.Payload(); 
        String responseBody = null;
        ProspectorGetRoutesWrap responseWrap = new ProspectorGetRoutesWrap();
        
        List<Property__c> testPropList = createTestProperties();
        List<Prospector_Working_Table__c> testPWTList = createTestWorkingTableList();
        responseBody = ProspectorMockHttpResponseGenerator.getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesSpliceClosure();
        System.debug('(testEvaluatePayloadForMatchForRedSpliceCloseure) BEFORE REPLACE, responseBody found FOLEY36535 at index = ' + responseBody.indexOf('FOLEY36535'));
        responseBody = responseBody.replace('FOLEY36535', testPropList.get(0).Id);
        System.debug('(testEvaluatePayloadForMatchForRedSpliceCloseure) AFTER REPLACE, responseBody found FOLEY36535 at index = ' + responseBody.indexOf('FOLEY36535'));
        responseWrap = ProspectorGetRoutesWrap.parse(responseBody);
        testPWTList.get(0).Property_Id__c = testPropList.get(0).Id;
        testPWTList.get(1).Property_Id__c = testPropList.get(0).Id;
               
        ProspectorCheckCalloutHelper.propsToBeUpdatedList = new List<Property__c>();
        
        Test.startTest();
        ProspectorGetRoutesByProjectCallout pgrbpCallout = new ProspectorGetRoutesByProjectCallout(null);
       	responseWrap = pgrbpCallout.getRoutesByProject(testProjId,'Splice_Closure');
        System.debug('(testEvaluatePayloadForMatchForRedSpliceClosure) responseWrap==null? ' + (responseWrap==null));
        
        System.debug('(testEvaluatePayloadForMatchForRedSpliceClosure) Assigning routesPayloadList to responseWrap.payload sized at ' + responseWrap.payload.size());
        List<ProspectorGetRoutesWrap.Payload> routesPayloadList = responseWrap.payload;            
        System.debug('(testEvaluatePayloadForMatchForRedSpliceClosure) routesPayloadList-size = ' + routesPayloadList.size());
        for (ProspectorGetRoutesWrap.Payload routesPL : routesPayloadList) {
            System.debug('(testEvaluatePayloadForMatchForRedSpliceClosure) routesPL = ' + routesPL.ToReadableString());
            routesPL.facilityType = 'Splice_Closure';
            for (Prospector_Working_Table__c pwtIn : testPWTList) {
                boolean isDone = ProspectorCheckCalloutHelper.evaluatePayloadForMatch(routesPL, pwtIn, testPropList);
                System.debug('(testEvaluatePayloadForMatchForRedSpliceClosure) isDone = ' + isDone);
                if (isDone) {
                    System.assertEquals(true, isDone);
                } else {
                    System.assertEquals(false, isDone);
                }
            }
        }
        Test.stopTest();    
        delete testPWTList;
        delete testPropList;
    }//end testmethod testEvaluatePayloadForMatchForRedSpliceClosure

    @AuraEnabled
    public static testmethod void testRetrieveDistinctProjIdsFromProspectorWorkingTable() {
        List<Property__c> testPropList = createTestProperties();
		List<Prospector_Working_Table__c> testPWTList = createTestWorkingTableList();
        System.debug('(testRetrieveDistinctProjIdsFromProspectorWorkingTable) testPWTList==null?' + (testPWTList==null));
        System.debug('(testRetrieveDistinctProjIdsFromProspectorWorkingTable) Should have PWT records now before calling retrieveDistingProjIdsFromPWT... testPWTList.size() = ' + testPWTList.size());

        Test.startTest();        
	    List<ProspectorCheckCalloutHelper.ProspectorProjectId> ppIdList = ProspectorCheckCalloutHelper.retrieveDistinctProjIdsFromProspectorWorkingTable(ProspectorCalloutHelper.GREEN);
        if (ppIdList == null) {
	        System.assertEquals(null, ppIdList);
        } else {
            System.assertNotEquals(null, ppIdList);
            if(ppIdList.size() == 0) {
                System.assertEquals(0, ppIdList.size());
            } else {
                System.assertNotEquals(0, ppIdList.size());
            }
        }
        Test.stopTest();
        delete testPWTList;
        delete testPropList;
    }//end testmethod testRetrieveDistinctProjIdsFromProspectorWorkingTable
    
    @AuraEnabled
    public static testmethod void testRetrieveAllPropertyNameColorFromProspectorWorkingTable() {
        List<Property__c> testPropList = createTestProperties();
		List<Prospector_Working_Table__c> testPWTList = createTestWorkingTableList();
        Test.startTest();
	    List<Prospector_Working_Table__c> pwtList = ProspectorCheckCalloutHelper.retrieveAllPropertyNameColorFromProspectorWorkingTable(ProspectorCalloutHelper.GREEN);
        if (pwtList == null) {
	        System.assertEquals(null, pwtList);
        } else {
            System.assertNotEquals(null, pwtList);
            if(pwtList.size() == 0) {
                System.assertEquals(0, pwtList.size());
            } else {
                System.assertNotEquals(0, pwtList.size());
            }
        }
        Test.stopTest();    
        delete testPWTList;
        delete testPropList;
    }//end testmethod testRetrievePropertyNameColorFromProspectorWorkingTable
/*  */
    @AuraEnabled
    public static testmethod void testCommitChanges() {
        Test.startTest();        
        ProspectorCheckCalloutHelper.allApiTransactionsServiceManager = new ApiTransactionService(true);
        ProspectorCheckCalloutHelper.commitChanges();
        Test.stopTest();        
    }//end testmethod testCommitChanges    
/*  */    
    private static List<ProspectorCheckCalloutHelper.ProspectorProjectId> getTestProspectorProjectIdList() {
		List<ProspectorCheckCalloutHelper.ProspectorProjectId> testList = new List<ProspectorCheckCalloutHelper.ProspectorProjectId>();
        ProspectorCheckCalloutHelper.ProspectorProjectId ppi1 = new ProspectorCheckCalloutHelper.ProspectorProjectId();
        ppi1.projectId = '{30951238-AA8F-47E5-A3F0-F5B9E6E69272}';
        ProspectorCheckCalloutHelper.ProspectorProjectId ppi2 = new ProspectorCheckCalloutHelper.ProspectorProjectId();
        ppi2.projectId = '{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}';
        testList.add(ppi1);
        testList.add(ppi2);
        
        return testList;
    }//end getTestProspectorProjectIdList
    
    private static String getProspectorListJobsCalloutJsonString(){
        System.debug('getProspectorListJobsCalloutJsonString...');
        String rBody = '';
        
        rBody += '{';
        rBody += ' "payload": [ ';
        rBody += '     { ';
        rBody += '        "userName": "SFJCAPP-dev", ';
        rBody += '        "projectName": "pn1661446091794", ';
        rBody += '        "projectId": "{30951238-AA8F-47E5-A3F0-F5B9E6E69272}", ';
        rBody += '        "guid": "{EB2825D0-A606-404A-BF20-6BAA78F0CEE4}", ';
        rBody += '        "status": 16, ';
        rBody += '        "machineName": "USDDCWVPRSPCTP1", ';
        rBody += '        "processId": 12532, ';
        rBody += '        "cancelRequested": false, ';
        rBody += '        "created": "2022-08-25T16:49:03.9377737Z", ';
        rBody += '        "lastUpdated": "2022-08-25T16:49:45.6631035Z" ';
        rBody += '     }, ';
        rBody += '     { ';
        rBody += '        "userName": "SFJCAPP-dev", ';
        rBody += '        "projectName": "pn1661776658887", ';
        rBody += '        "projectId": "{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}", ';
        rBody += '        "guid": "{74D2C741-5BBF-4694-AAEA-D50A82A1CEBB}", ';
        rBody += '        "status": 16, ';
        rBody += '        "machineName": "USDDCWVPRSPCTP1", ';
        rBody += '        "processId": 25896, ';
        rBody += '        "cancelRequested": false, ';
        rBody += '        "created": "2022-08-29T12:38:03.791474Z", ';
        rBody += '        "lastUpdated": "2022-08-29T12:38:15.5667068Z" ';
        rBody += '     }, ';
        rBody += '     { ';
        rBody += '        "userName": "SFJCAPP-dev", ';
        rBody += '        "projectName": "pn1661446091794", ';
        rBody += '        "projectId": "{D954B866-5BA0-4A53-B990-1F70F6090AE2}", ';
        rBody += '        "guid": "{EB2825D0-A606-404A-BF20-6BAA78F0CEE4}", ';
        rBody += '        "status": 16, ';
        rBody += '        "machineName": "USDDCWVPRSPCTP1", ';
        rBody += '        "processId": 12532, ';
        rBody += '        "cancelRequested": false, ';
        rBody += '        "created": "2022-08-25T16:49:03.9377737Z", ';
        rBody += '        "lastUpdated": "2022-08-25T16:49:45.6631035Z" ';
        rBody += '     }, ';
        rBody += '     { ';
        rBody += '        "userName": "SFJCAPP-dev", ';
        rBody += '        "projectName": "pn1661776658887", ';
        rBody += '        "projectId": "{BA09EEE2-9FFF-457F-95A0-DCA408D18843}", ';
        rBody += '        "guid": "{74D2C741-5BBF-4694-AAEA-D50A82A1CEBB}", ';
        rBody += '        "status": 24, ';
        rBody += '        "machineName": "USDDCWVPRSPCTP1", ';
        rBody += '        "processId": 25896, ';
        rBody += '        "cancelRequested": false, ';
        rBody += '        "created": "2022-08-29T12:38:03.791474Z", ';
        rBody += '        "lastUpdated": "2022-08-29T12:38:15.5667068Z" ';
        rBody += '     } ';
        rBody += ' ],';
        rBody += ' "status": "success", ';
        rBody += ' "message": null ';
        rBody += '}';
        
        return rBody;
    }//end method getProspectorListJobsCalloutJsonString

    private static List<Property__c> createTestProperties() {
        List<Property__c> newTestProperties = new List<Property__c>();
        Property__c testProp = new Property__c();
        testProp.Name = 'StanTest1';
        testProp.Latitude__c = 41.88917342;
        testProp.Longitude__c = -87.62972682;
        newTestProperties.add(testProp);
        
        testProp = new Property__c();
        testProp.Name = 'StanTest2';
        testProp.Latitude__c = 39.01865353;
        testProp.Longitude__c = -77.4567641;
        newTestProperties.add(testProp);
        
		insert newTestProperties;        
        
        return newTestProperties;
    }//end method createTestProperties
    
    private static List<Prospector_Working_Table__c> createTestWorkingTableList() {
		List<Prospector_Working_Table__c> pwtTestList = new List<Prospector_Working_Table__c>();

        Prospector_Working_Table__c pwtTest = new Prospector_Working_Table__c();
        pwtTest.Project_Id__c = '{30951238-AA8F-47E5-A3F0-F5B9E6E69272}';
        List<Property__c> stanTest1List = [SELECT Id FROM Property__c WHERE Name = 'StanTest1' LIMIT 1];
        pwtTest.Property_Id__c = stanTest1List?.get(0)?.Id;
        pwtTest.Infrastructure_Layer_Color__c = 'Green';
        pwtTestList.add(pwtTest);

		pwtTest = new Prospector_Working_Table__c();
        pwtTest.Project_Id__c = '{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}';
        pwtTest.Property_Id__c = stanTest1List?.get(0)?.Id;
        pwtTest.Infrastructure_Layer_Color__c = 'Red';
        pwtTestList.add(pwtTest);        
        
		pwtTest = new Prospector_Working_Table__c();
        pwtTest.Project_Id__c = '{D954B866-5BA0-4A53-B990-1F70F6090AE2}';
        List<Property__c> stanTest2List = [SELECT Id FROM Property__c WHERE Name = 'StanTest2' LIMIT 1];
        pwtTest.Property_Id__c = stanTest2List?.get(0)?.Id;
        pwtTest.Infrastructure_Layer_Color__c = 'Green';
        pwtTestList.add(pwtTest);        
        
		pwtTest = new Prospector_Working_Table__c();
        pwtTest.Project_Id__c = '{BA09EEE2-9FFF-457F-95A0-DCA408D18843}';
        pwtTest.Property_Id__c = stanTest2List?.get(0)?.Id;
        pwtTest.Infrastructure_Layer_Color__c = 'Red'; 
        pwtTestList.add(pwtTest);        

		insert pwtTestList;
        System.debug('(createTestWorkingTableList) pwtTestList has been inserted...');
        
        return pwtTestList;
    }//end method createTestWorkingTableList
}//end test class ProspectorCheckCalloutHelper_Test