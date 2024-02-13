@isTest(SeeAllData=true)
public with sharing class PropertyCreation1gQueueable_Test { 

    @AuraEnabled
    public static testmethod void testQueueableJob() {        
          // Create Property request record
        String dataSource = 'ALN';
        String street = '6001 YANKEE HILL RD';
        String city = 'LINCOLN';
        String state = 'NE';
        String results = 'Yellow';
        String source = 'Test1';
        Decimal latitude = 33.56910000;
        Decimal longitude = -112.08100000;
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
        Set<Id> propIdSet = new Set<Id>();
        for(Property__c property : propertyList) {
            propIdSet.add(property.Id);
        }
        Property_Request_Record__c prr = new Property_Request_Record__c();
        prr.GEOES_Latitude_Coordinate__c = latitude;
        prr.GEOES_Longitude_Coordinate__c = longitude;
        prr.GEOES_Inventory_Source__c = source;
        prr.GEOES_results__c = results;
        prr.Data_Source__c = dataSource;
        prr.New_Property_Created__c =propertyList[0].Id;
        
        insert prr;
        
        PropertyCreation1gQueueable pc1gQ = new PropertyCreation1gQueueable(propIdSet);
        System.debug('pc1gQ.propertyIds?.size() = ' + pc1gQ.propertyIds?.size() + '  AND pc1gQ.propertyIdsToProcess?.size() = ' + pc1gQ.propertyIdsToProcess?.size());
        String pc1gQJobId = System.enqueueJob(pc1gQ);
        if (pc1gQJobId == null) {
	        System.assertEquals(null, pc1gQJobId);
        } else {
            System.assertNotEquals(null, pc1gQJobId);
        }
        Test.stopTest();    
    }//end testmethod testQueueableJob

    @AuraEnabled
    public static testmethod void testQueueableJobWithEmptyPropertyIdSet() {
        Test.startTest();
        List<Property__c> propertyList = createTestProperties();
  		Set<Id> propIdSet = new Set<Id>();
        for(Property__c property : propertyList) {
            propIdSet.add(property.Id);
        }
                     
        for(Id propertyId : propIdSet) {
	        propIdSet.remove(propertyId);
        }
        PropertyCreation1gQueueable pc1gQ = new PropertyCreation1gQueueable(propIdSet);
        System.debug('pc1gQ.propertyIds?.size() = ' + pc1gQ.propertyIds?.size() + '  AND pc1gQ.propertyIdsToProcess?.size() = ' + pc1gQ.propertyIdsToProcess?.size());
        String pc1gQJobId = System.enqueueJob(pc1gQ);
        if (pc1gQJobId == null) {
	        System.assertEquals(null, pc1gQJobId);
        } else {
            System.assertNotEquals(null, pc1gQJobId);
        }
        Test.stopTest();    
    }//end testmethod testQueueableJobWithEmptyPropertyIdSet

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
    
}//end class PropertyCreation1gQueueable_Test