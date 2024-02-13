/*********************************************************************************
==================================================================================
Purpose: Test class to have test coverage for ScheduledProcessPropertyBatchApex.
==================================================================================
History:

AUTHOR     DATE         Reference     Description
Deepak K   21/12/2021   ESCJ-363      Initial draft
**********************************************************************************/
@isTest
public class ScheduledProcessPropertyBatchApexTest {
    
    /*********************************************************************************
    ==================================================================================
    Purpose: Test method to have test data setup.
    ==================================================================================
    History:
    
    AUTHOR     DATE         Reference     Description
    Deepak K   21/12/2021   ESCJ-363      Initial draft
    **********************************************************************************/
    @testSetup static void testDataSetup(){
        TestDataFactory.createProperties(null, null, null, null, null, null, 39.723035, -104.881587, 1, true);
    }
    
    /*********************************************************************************
    ==================================================================================
    Purpose: Test method to test scheduler is getting scheduled or not and once it's 
			 executing then we are getting required results.
    ==================================================================================
    History:
    
    AUTHOR     DATE         Reference     Description
    Deepak K   21/12/2021   ESCJ-363      Initial draft
    **********************************************************************************/
    @isTest static void cronSchedularTest(){
        ScheduledProcessPropertyBatchApex scheduler = new ScheduledProcessPropertyBatchApex();
        Test.startTest();
        String cronEx ='0 0 2 * * ? *';
        id schedulerId = System.schedule('processPropertySchedular',cronEx,scheduler);
        List<Property__c> preRunPropertyList = [SELECT Id, Latitude__c, Longitude__c FROM Property__c where Initial_Source_Region__c = 'Out of Region'];
        System.assertEquals(0, preRunPropertyList.size());  
        Test.stopTest();
        List<CronTrigger> cronTriggerList = [SELECT Id, CronExpression FROM CronTrigger WHERE Id =: schedulerId];
        System.assertEquals(cronTriggerList[0]?.CronExpression, cronEx);    
    }
    
    /*********************************************************************************
    ==================================================================================
    Purpose: Test method to test dividePropertiesIntoBatches to increase class test 
			 coverage.
    ==================================================================================
    History:
    
    AUTHOR     DATE         Reference     Description
    Deepak K   21/12/2021   ESCJ-363      Initial draft
    **********************************************************************************/
    @isTest static void dividePropertiesIntoBatchesTest(){
        List<Property__c> propertyList = TestDataFactory.createProperties(null, null, null, null, null, null, 39.723035, -104.881587, 6, false);
        ScheduledProcessPropertyBatchApex schedular = new ScheduledProcessPropertyBatchApex();
        List<List<Property__c>> propertyListOfList = schedular.dividePropertiesIntoBatches(propertyList);
        System.assertEquals(5, propertyListOfList.size());
    }
}