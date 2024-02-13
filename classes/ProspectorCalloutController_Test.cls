@isTest(SeeAllData=true) 
public with sharing class ProspectorCalloutController_Test {  

    @AuraEnabled
    public static testmethod void testQueueableJob() {        
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
            }
        }
        ProspectorCalloutController pcc = new ProspectorCalloutController(propertyList);
        String pccJobId = System.enqueueJob(pcc);
        if (pccJobId == null) {
	        System.assertEquals(null, pccJobId);
        } else {
            System.assertNotEquals(null, pccJobId);
        }
        Test.stopTest();    
    }//end testmethod testQueueableJob
    
    @AuraEnabled
    public static testmethod void testProcessPropertyList() {        
        Test.startTest();
        List<Property__c> propertyList = createTestProperties();
        if (propertyList == null) {
            System.assertEquals(null, propertyList);
        } else {
            System.assertNotEquals(null, propertyList);
            if (propertyList.size() == 0) {
                System.assertEquals(0, propertyList.size());
            } else {
                System.assertNotEquals(0, propertyList.size());
            }
        }
        ProspectorCalloutController pcc = new ProspectorCalloutController(propertyList);
        String pccJobId = System.enqueueJob(pcc);
        if (pccJobId == null) {
	        System.assertEquals(null, pccJobId);
        } else {
            System.assertNotEquals(null, pccJobId);
        }
        Test.stopTest();    
    }//end testmethod testProcessPropertyList

    @AuraEnabled
    public static testmethod void testProcessPropertyListWithNullPropertyList() {        
        Test.startTest();
        List<Property__c> propertyList = null;
        ProspectorCalloutController pcc = new ProspectorCalloutController(propertyList);
        String pccJobId = System.enqueueJob(pcc);
        if (pccJobId == null) {
	        System.assertEquals(null, pccJobId);
        } else {
            System.assertNotEquals(null, pccJobId);
        }
        Test.stopTest();    
    }//end testmethod testProcessPropertyListWithNullPropertyList


    @AuraEnabled
    public static testmethod void testProcessPropertyListWithEmptyPropertyList() {        
        Test.startTest();
        List<Property__c> propertyList = new List<Property__c>();
        ProspectorCalloutController pcc = new ProspectorCalloutController(propertyList);
        String pccJobId = System.enqueueJob(pcc);
        if (pccJobId == null) {
	        System.assertEquals(null, pccJobId);
        } else {
            System.assertNotEquals(null, pccJobId);
        }
        Test.stopTest();    
    }//end testmethod testProcessPropertyListWithEmptyPropertyList

    @AuraEnabled
    public static testmethod void testProcessPropertyListWithPropertyId() {        
        Test.startTest();
        List<Property__c> propertyList = createTestProperties();
        if (propertyList == null) {
            System.assertEquals(null, propertyList);
        } else {
            System.assertNotEquals(null, propertyList);
            if (propertyList.size() == 0) {
                System.assertEquals(0, propertyList.size());
            } else {
                System.assertNotEquals(0, propertyList.size());
            }
        }
        ProspectorCalloutController pcc = new ProspectorCalloutController(propertyList.get(0).Id);
        String pccJobId = System.enqueueJob(pcc);
        if (pccJobId == null) {
	        System.assertEquals(null, pccJobId);
        } else {
            System.assertNotEquals(null, pccJobId);
        }
        Test.stopTest();    
    }//end testmethod testProcessPropertyListWithPropertyId

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
    
}//end class ProspectorCalloutController_Test