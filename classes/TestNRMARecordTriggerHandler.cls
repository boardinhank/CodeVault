@isTest
public class TestNRMARecordTriggerHandler {
    
    
    @isTest static void testBeforeInsert(){
        Test.startTest();
        new NRMARecordTriggerHandler().beforeInsert(new List<NRMA__c>());
        Test.stopTest();
        
    }
    @isTest static void testAfterInsert(){
        Test.startTest();
        new NRMARecordTriggerHandler().afterInsert(new List<NRMA__c>());
        Test.stopTest();
        
    }
    @isTest static void testBeforeUpdate(){
        Test.startTest();
       new NRMARecordTriggerHandler().beforeUpdate(new List<NRMA__c>(),  new Map<Id, sObject>());
        Test.stopTest();
        
    }
    @isTest static void testAfterUpdate(){
        Test.startTest();
        new NRMARecordTriggerHandler().afterUpdate(new List<NRMA__c>(), new Map<Id, NRMA__c>());
        Test.stopTest();
        
    }
   @isTest static void testBeforeDelete(){
		Test.startTest();
        new NRMARecordTriggerHandler().beforeDelete(new Map<Id, NRMA__c>());
        Test.stopTest();
        
    }
    @isTest static void testAfterDelete(){
        Test.startTest();
        new NRMARecordTriggerHandler().afterDelete(new Map<Id, NRMA__c>());
        Test.stopTest();
        
    }
    @isTest static void testAfterUnDelete(){
        Test.startTest();
        new NRMARecordTriggerHandler().afterUnDelete(new Map<Id, NRMA__c>());
        Test.stopTest();
        
    }

}//end test-class TestNRMARecordTriggerHandler