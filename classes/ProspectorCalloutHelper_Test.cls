@isTest(SeeAllData=true) 
public with sharing class ProspectorCalloutHelper_Test {
    public static final String testProjId = '{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}';
/*    
    @AuraEnabled
    public static testmethod void testServiceCallout() {
        Test.startTest();
        HttpResponse resp = ProspectorCalloutHelper.serviceCallout();
        if (resp == null) {
            System.assertEquals(null, resp);
        } else {
            System.assertNotEquals(null, resp);
            if (resp.getStatusCode() == 200) { 
                System.assertEquals(200, resp.getStatusCode());
            } else if (resp.getStatusCode() == 400) {
                System.assertEquals(400, resp.getStatusCode());
        	} else if (resp.getStatusCode() == 401) {
                System.assertEquals(401, resp.getStatusCode());
            } else if (resp.getStatusCode() == 500) {
                System.assertEquals(500, resp.getStatusCode());
            } else {
                System.assertNotEquals(200, resp.getStatusCode());
                System.assertNotEquals(400, resp.getStatusCode());
                System.assertNotEquals(401, resp.getStatusCode());
                System.assertNotEquals(500, resp.getStatusCode());
            }
        }
        Test.stopTest();
        
    }//end method testServiceCallout
*/
    @AuraEnabled
    public static testmethod void testDeleteExistingPWTEntries() {

        Test.startTest();
        ProspectorCalloutHelper.deleteExistingPWTEntries();
        List<Prospector_Working_Table__c> pwtList = [select id from Prospector_Working_Table__c];
        if (pwtList == null) {
            System.assertEquals(null, pwtList);
        } else {
            System.assertNotEquals(null, pwtList);
            if (pwtList.size() == 0) {
                System.assertEquals(0, pwtList.size());
            } else {
                System.assertNotEquals(0, pwtList.size());
            }
        }
        Test.stopTest();
        
    }//end method testDeleteExistingPWTEntries

    @AuraEnabled
    public static testmethod void testCheckNewPropertyHasLatAndLong() {

        Test.startTest();
        List<Property__c> propertyList = ProspectorCalloutHelper.retrieveProperties();
        if (propertyList == null) {
            System.assertEquals(null, propertyList);
        } else {
            System.assertNotEquals(null, propertyList);
            if (propertyList.size() == 0) {
                System.assertEquals(0, propertyList.size());
            } else {
                System.assertNotEquals(0, propertyList.size());
                if (propertyList.get(0) == null) {
                    System.assertEquals(null, propertyList.get(0));
                } else {
                    System.assertNotEquals(null, propertyList.get(0));
			        ProspectorCalloutHelper.checkNewPropertyHasLatAndLong(propertyList.get(0));
                }
            }
        }
        Test.stopTest();
        
    }//end method testCheckNewPropertyHasLatAndLong

    @AuraEnabled
    public static testmethod void testRetrieveProperties() {
		List<Property__c> propertyList = new List<Property__c>(); 
        Test.startTest();
        propertyList = ProspectorCalloutHelper.retrieveProperties();
        if (propertyList == null) {
            System.assertEquals(null, propertyList);
        } else {
            System.assertNotEquals(null, propertyList);
            if (propertyList.size() == 0) {
                System.assertEquals(0, propertyList.size());
            } else {
                System.assertNotEquals(0, propertyList.size());
                if (propertyList.get(0) == null) {
                    System.assertEquals(null, propertyList.get(0));
                } else {
                    System.assertNotEquals(null, propertyList.get(0));
                }
            }
        }
        Test.stopTest();
        
    }//end method testRetrieveProperties

    @AuraEnabled
    public static testmethod void testGetPropertyById() {
		List<Property__c> propertyList = new List<Property__c>(); 
        Test.startTest();
        propertyList = ProspectorCalloutHelper.getPropertyById(null);
        if (propertyList == null) {
            System.assertEquals(null, propertyList);
        } else {
            System.assertNotEquals(null, propertyList);
            if (propertyList.size() == 0) {
                System.assertEquals(0, propertyList.size());
            } else {
                System.assertNotEquals(0, propertyList.size());
                if (propertyList.get(0) == null) {
                    System.assertEquals(null, propertyList.get(0));
                } else {
                    System.assertNotEquals(null, propertyList.get(0));
                }
            }
        }
        Test.stopTest();
        
    }//end method testGetPropertyById

    @AuraEnabled
    public static testmethod void testInsertProspectorWorkingTable() {
    	List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList = new List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint>();
		String projectId = testProjId;
        String colorIn = null;
        String transactionSummaryId = null;

        Test.startTest();
        colorIn = ProspectorCalloutHelper.GREEN;
        List<Property__c> propertyList = ProspectorCalloutHelper.retrieveProperties();
        dpList = ProspectorCalloutHelper.buildDemandPointsFromProperties(propertyList);
        ProspectorCalloutHelper.prepareInsertProspectorWorkingTable(projectId, colorIn, dpList);
        List<Prospector_Working_Table__c> pwtGreenList = [select id from Prospector_Working_Table__c WHERE Infrastructure_Layer_Color__c = 'Green'];
        if (pwtGreenList == null) {
            System.assertEquals(null, pwtGreenList);
        } else {
            System.assertNotEquals(null, pwtGreenList);
            if (pwtGreenList.size() == 0) {
                System.assertEquals(0, pwtGreenList.size());
            } else {
                System.assertNotEquals(0, pwtGreenList.size());
            }
        }
        colorIn = ProspectorCalloutHelper.RED;
        ProspectorCalloutHelper.prepareInsertProspectorWorkingTable(projectId, colorIn, dpList);
        List<Prospector_Working_Table__c> pwtRedList = [select id from Prospector_Working_Table__c WHERE Infrastructure_Layer_Color__c = 'Red'];
        if (pwtRedList == null) {
            System.assertEquals(null, pwtRedList);
        } else {
            System.assertNotEquals(null, pwtRedList);
            if (pwtRedList.size() == 0) {
                System.assertEquals(0, pwtRedList.size());
            } else {
                System.assertNotEquals(0, pwtRedList.size());
            }
        }
        Test.stopTest();
        
    }//end method testInsertProspectorWorkingTable

    @AuraEnabled
    public static testmethod void testBuildDemandPointsFromProperties() {
        List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList = new List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint>();

        Test.startTest();
        List<Property__c> propertyList = ProspectorCalloutHelper.retrieveProperties();
        dpList = ProspectorCalloutHelper.buildDemandPointsFromProperties(propertyList);
        if (dpList == null) {
            System.assertEquals(null, dpList);
        } else {
            System.assertNotEquals(null, dpList);
            if (dpList.size() == 0) {
                System.assertEquals(0, dpList.size());
            } else {
                System.assertNotEquals(0, dpList.size());
                if (dpList.get(0) == null) {
                    System.assertEquals(null, dpList.get(0));
                } else {
                    System.assertNotEquals(null, dpList.get(0));
                }
            }
        }
        Test.stopTest();
        
    }//end method testBuildDemandPointsFromProperties

    @AuraEnabled
    public static testmethod void testStep1CreateProject() {
        List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList = new List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint>();
		String projectId = null;
        String colorIn = null;
        String transactionSummaryId = null;

        Test.startTest();
        ProspectorCalloutHelper.allApiTransactionsServiceManager = new ApiTransactionService(true);
        ProspectorCreateProjectCallout.ProspectorProject projectG = ProspectorCalloutHelper.step1CreateProject(ProspectorCalloutHelper.GREEN);
        if (projectG == null) {
            System.assertEquals(null, projectG);
        } else {
            System.assertNotEquals(null, projectG);
        }
        ProspectorCreateProjectCallout.ProspectorProject projectR = ProspectorCalloutHelper.step1CreateProject(ProspectorCalloutHelper.RED);
        if (projectR == null) {
            System.assertEquals(null, projectR);
        } else {
            System.assertNotEquals(null, projectR);
        }
        Test.stopTest();
        
    }//end method testStep1CreateProject

    @AuraEnabled
    public static testmethod void testStep2AddDemandPoints() {
        List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList = new List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint>();
		String projectId = null;
        String colorIn = null;
        String transactionSummaryId = null;

        Test.startTest();
        ProspectorCalloutHelper.allApiTransactionsServiceManager = new ApiTransactionService(true);
        ProspectorCreateProjectCallout.ProspectorProject projectG = ProspectorCalloutHelper.step1CreateProject(ProspectorCalloutHelper.GREEN);
        if (projectG != null) {
	        projectId = projectG.payload;
        } else {
            projectId = testProjId;
        }
        projectG = ProspectorCalloutHelper.step2AddDemandPoints(projectId, dpList, ProspectorCalloutHelper.GREEN);
        if (projectG == null) {
            System.assertEquals(null, projectG);
        } else {
            System.assertNotEquals(null, projectG);
        }
        ProspectorCreateProjectCallout.ProspectorProject projectR = ProspectorCalloutHelper.step1CreateProject(ProspectorCalloutHelper.RED);
        if (projectR != null) {
	        projectId = projectR.payload;
        } else {
            projectId = testProjId;
        }
        projectR = ProspectorCalloutHelper.step2AddDemandPoints(projectId, dpList, ProspectorCalloutHelper.RED);
        if (projectR == null) {
            System.assertEquals(null, projectR);
        } else {
            System.assertNotEquals(null, projectR);
        }
        Test.stopTest();
        
    }//end method testStep2AddDemandPoints

    @AuraEnabled
    public static testmethod void testStep3SubmitJob() {
        List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList = new List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint>();
		String projectId = null;
        String colorIn = null;
        String transactionSummaryId = null;

        Test.startTest();
        ProspectorCalloutHelper.allApiTransactionsServiceManager = new ApiTransactionService(true);
        ProspectorCreateProjectCallout.ProspectorProject projectG = ProspectorCalloutHelper.step1CreateProject(ProspectorCalloutHelper.GREEN);
        if (projectG != null) {
	        projectId = projectG.payload;
        } else {
            projectId = testProjId;
        }
        projectG = ProspectorCalloutHelper.step3SubmitJob(projectId, ProspectorCalloutHelper.GREEN);
        if (projectG == null) {
            System.assertEquals(null, projectG);
        } else {
            System.assertNotEquals(null, projectG);
        }
        ProspectorCreateProjectCallout.ProspectorProject projectR = ProspectorCalloutHelper.step1CreateProject(ProspectorCalloutHelper.RED);
        if (projectR != null) {
	        projectId = projectR.payload;
        } else {
            projectId = testProjId;
        }
        projectR = ProspectorCalloutHelper.step3SubmitJob(projectId, ProspectorCalloutHelper.RED);
        if (projectR == null) {
            System.assertEquals(null, projectR);
        } else {
            System.assertNotEquals(null, projectR);
        }
        Test.stopTest();
        
    }//end method testStep3SubmitJob

    @AuraEnabled
    public static testmethod void testStep4InsertToPWT() {
        List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList = new List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint>();
		String projectId = null;
        String colorIn = null;
        String transactionSummaryId = null;
        
        Test.startTest();
        ProspectorCalloutHelper.allApiTransactionsServiceManager = new ApiTransactionService(true);
        ProspectorCreateProjectCallout.ProspectorProject projectG = ProspectorCalloutHelper.step1CreateProject(ProspectorCalloutHelper.GREEN);
        if (projectG != null) {
	        projectId = projectG.payload;
        } else {
            projectId = testProjId;
        }
        List<Prospector_Working_Table__c> pwtGreenList = ProspectorCalloutHelper.step4InsertToPWT(projectId, dpList, ProspectorCalloutHelper.GREEN);        
        if (pwtGreenList == null) {
            System.assertEquals(null, pwtGreenList);
        } else {
            System.assertNotEquals(null, pwtGreenList);
            if (pwtGreenList.size() == 0) {
                System.assertEquals(0, pwtGreenList.size());
            } else {
                System.assertNotEquals(0, pwtGreenList.size());
            }
        }
        ProspectorCreateProjectCallout.ProspectorProject projectR = ProspectorCalloutHelper.step1CreateProject(ProspectorCalloutHelper.RED);
        if (projectR != null) {
	        projectId = projectR.payload;
        } else {
            projectId = testProjId;
        }
        List<Prospector_Working_Table__c> pwtRedList = ProspectorCalloutHelper.step4InsertToPWT(projectId, dpList, ProspectorCalloutHelper.RED);
        if (pwtRedList == null) {
            System.assertEquals(null, pwtRedList);
        } else {
            System.assertNotEquals(null, pwtRedList);
            if (pwtRedList.size() == 0) {
                System.assertEquals(0, pwtRedList.size());
            } else {
                System.assertNotEquals(0, pwtRedList.size());
            }
        }
        Test.stopTest();
        
    }//end method testStep4InsertToPWT

    
}//end test class ProspectorCalloutHelper_Test