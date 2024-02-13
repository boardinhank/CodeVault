@isTest(SeeAllData=true)
public with sharing class ProspectorCheckCalloutController_Test {
    
    @AuraEnabled
    public static testmethod void testQueueableJob() {       

        Test.startTest();
        System.enqueueJob(new ProspectorCheckCalloutController());
        Test.stopTest();    
    }//end testmethod testQueueableJob

    @AuraEnabled
    public static testmethod void testProcessWorkingTable() {        
        List<Property__c> testPropList = createTestProperties();
        List<Prospector_Working_Table__c> testPWTList = createTestWorkingTableList();
        List<ProspectorCheckCalloutHelper.ProspectorProjectId> ppiList = getTestProspectorProjectIdList();

        Test.startTest();
        ProspectorCheckCalloutHelper.allApiTransactionsServiceManager = new ApiTransactionService(true);
	    ProspectorCheckCalloutController.processWorkingTable();
        Test.stopTest();    
    }//end testmethod testQueueableJob

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
}//end class ProspectorCheckCalloutController_Test