/*********************************************************************************
==================================================================================
Purpose: Test class for batch apex Class BatchToProcessPropertiesFor1GService.
==================================================================================
History:

AUTHOR     DATE         Reference     Description
Deepak K   21/12/2021   ESCJ-363      Initial draft
**********************************************************************************/
@isTest
public class BatchToProcessPropertiesFor1GServiceTest { 
    
    /*********************************************************************************
    ==================================================================================
    Purpose: Test method to test oneGigServiceBatchApex
    ==================================================================================
    History:
    
    AUTHOR     DATE         Reference     Description
    Deepak K   21/12/2021   ESCJ-363      Initial draft
    **********************************************************************************/   
    @isTest static void oneGigServiceBatchApex(){
        List<Property__c> propertyList = createPropertyList();
        Test.startTest();
        BatchToProcessPropertiesForAddTelco batchable = new BatchToProcessPropertiesForAddTelco(propertyList);
        Database.executeBatch(batchable, 1);
        Test.stopTest();
        List<Property__c> afterRunPropertyList = [SELECT Gig_Enabled__c FROM Property__c];
        if (afterRunPropertyList[0].Gig_Enabled__c == 'Yes') {
	        System.assertEquals('Yes', afterRunPropertyList[0].Gig_Enabled__c);
        } else {
            System.assertNotEquals('Yes', afterRunPropertyList[0].Gig_Enabled__c);
        }
    }
    
    @isTest static void testQueueableTrue(){
        Map<String, Object> mapToReturn = new Map<String, Object>();
        List<Property__c> propertyList = createPropertyList();
        Test.startTest();
        BatchToProcessPropertiesFor1GService test1gBatch = new BatchToProcessPropertiesFor1GService(true);
        test1gBatch.execute(null, propertyList);
    	Test.stopTest();
        List<Property__c> afterRunPropertyList = [SELECT Gig_Enabled__c FROM Property__c];
        if (afterRunPropertyList[0].Gig_Enabled__c == 'Yes') {
	        System.assertEquals('Yes', afterRunPropertyList[0].Gig_Enabled__c);
        } else {
            System.assertNotEquals('Yes', afterRunPropertyList[0].Gig_Enabled__c);
        }
    }

    private static List<Property__c> createPropertyList(){   
        List<Transaction_Summary__c> transactionSummaries = TestDataFactory.createTransactionSummaries('ALN', '6001 YANKEE HILL RD', 'LINCOLN', 'NE', 39.723035, -104.881587, 1, true); 
        List<Property__c> propertyList = TestDataFactory.createProperties(null, null, null, null, null, null, 39.723035, -104.881587, 1, false);
        propertyList[0].Transaction_Summary__c = transactionSummaries[0].id;
        INSERT propertyList;
        return propertyList;
    }

}