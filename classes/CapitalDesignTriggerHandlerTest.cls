/*************************************************************************************************
 Purpose: Test class for the CapitalDesignTriggerHandlerTest to test different test scenarios.
===============================================================================================
History:
AUTHOR         DATE           Reference        Description
Ami Parekh    3/03/2022       ESCJ-557         Initial draft
***********************************************************************************************/ 
@isTest
public class CapitalDesignTriggerHandlerTest {
    
    
    @isTest static void testBeforeInsert(){
        Test.startTest();
        new CapitalDesignTriggerHandler().beforeInsert(new List<Capital_Design__c>());
        Test.stopTest();
        
    }
    @isTest static void testAfterInsert(){
        Test.startTest();
        new CapitalDesignTriggerHandler().afterInsert(new List<Capital_Design__c>(), new Map<Id, sObject>());
        Test.stopTest();
        
    }
    @isTest static void testBeforeUpdate(){
       // List<Capital_Design__c> capitalDesigns, Map<Id, sObject> newMap, List<sObject> oldList, Map<Id, sObject> oldMap
        Test.startTest();
       new CapitalDesignTriggerHandler().beforeUpdate(new List<Capital_Design__c>(),  new Map<Id, sObject>(), new List<sObject>(), new Map<Id, sObject>());
        Test.stopTest();
        
    }
    @isTest static void testAfterUpdate(){
        Test.startTest();
        new CapitalDesignTriggerHandler().afterUpdate(new List<Capital_Design__c>(), new Map<Id, Capital_Design__c>(), new List<sObject>(), new Map<Id, sObject>());
        Test.stopTest();
        
    }
   @isTest static void testBeforeDelete(){
Test.startTest();
        new CapitalDesignTriggerHandler().beforeDelete(new List<sObject>(),  new Map<Id, sObject>());
        Test.stopTest();
        
    }
    @isTest static void testAfterDelete(){
        Test.startTest();
        new CapitalDesignTriggerHandler().afterDelete(new List<sObject>(), new Map<Id, sObject>());
        Test.stopTest();
        
    }
    @isTest static void testAfterUnDelete(){
        Test.startTest();
        new CapitalDesignTriggerHandler().afterUnDelete(new List<sObject>(), new Map<Id, sObject>());
        Test.stopTest();
        
    }
    @isTest static void sfcjMarketing(){
        Test.startTest();
        capital_design__c newCD = new capital_design__c(
        	capital_design_type__c = 'Standard',
			nbr_of_Living_Units__c = 1
        	);
        insert newCD;
        capital_design__c getCD = [select id, SFAINT_capital_design_type__c from capital_design__c where Id = :newCD.id];
        System.assertEquals(getCD.SFAINT_Capital_Design_Type__c,'Marketing');
        Test.stopTest();      
    }
    @isTEst static void sfcjNonMarketing(){
                Test.startTest();
        capital_design__c newCD = new capital_design__c(
           capital_design_type__c = 'Non-Marketing',
           nbr_of_Living_Units__c = 1
           	);
        insert newCD;
      capital_design__c getCD = [select id, SFAINT_capital_design_type__c from capital_design__c where Id = :newCD.id];
      System.assertEquals(getCD.SFAINT_Capital_Design_Type__c,'Non-Marketing');     
                Test.stopTest();   
    }
    @isTest static void sfaintMarketing(){
             Test.startTest();
        capital_design__c newCD = new capital_design__c(
			SFAINT_capital_design_type__c = 'Marketing',
			nbr_of_Living_Units__c = 1
                   	);
        insert newCD;
      capital_design__c getCD = [select id, capital_design_type__c from capital_design__c where Id = :newCD.id];
      System.assertEquals(getCD.Capital_Design_Type__c,'Standard');
                Test.stopTest();   
    }
    @isTEst static void sfaintNonMarketing(){
             Test.startTest();
        capital_design__c newCD = new capital_design__c(
        SFAINT_capital_design_type__c = 'Non-Marketing',
		nbr_of_Living_Units__c = 1
                   	);
        insert newCD;
       capital_design__c getCD = [select id, capital_design_type__c from capital_design__c where Id = :newCD.id];
       System.assertEquals(getCD.Capital_Design_Type__c,'Non-Marketing');
                Test.stopTest();   
    }


}