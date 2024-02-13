@isTest
public class NRMARecordTriggerHelper_Test {
   
    @isTest static void testinsertSupportingDocumentinJSON(){
        List<NRMA__c>  listofNRMArecords =  new List<NRMA__c>();
        NRMA__c testrecord = new NRMA__c(Name__c='Test123',URL__c='www.test.com',Supporting_Document_URLs__c='');
        insert testrecord;
        NRMARecordTriggerHandler.triggerDisabled=false;
      }  
    
    @isTest static void testupdateSupportingDocumentinJSON(){
        
		 NRMA__c testrecord = new NRMA__c(Name__c='Test123',URL__c='www.test.com',Supporting_Document_URLs__c='');
        insert testrecord;
        NRMARecordTriggerHandler.triggerDisabled=false;
        
        List<NRMA__c>  listofNRMArecords =[Select Id,URL__c,name__c,Supporting_Document_URLs__c from NRMA__C where Id=:testrecord.Id];
        listofNRMArecords[0].Name__c = 'Test1234';
        listofNRMArecords[0].URL__c ='www.test123.com';
        listofNRMArecords[0].Supporting_Document_URLs__c='[{"url":"www.Test456","name":"Test456"},{"url":"www.Test123","name":"Test123"}]';
        
        Test.startTest();
        	update listofNRMArecords[0];
        Test.stopTest();
    	
      }   
    
      @isTest static void testdeleteSupportingDocumentinJSON(){
        List<NRMA__c>  listofNRMArecords =  new List<NRMA__c>();
        NRMA__c testrecord = new NRMA__c(Name__c='Test123',URL__c='www.test.com',Supporting_Document_URLs__c='');
        insert testrecord;
        NRMARecordTriggerHandler.triggerDisabled=false;
        List<NRMA__c>  deletlistofNRMArecords =[Select Id,URL__c,name__c,Supporting_Document_URLs__c from NRMA__C where Id=:testrecord.Id];
                
        Test.startTest();
        	delete deletlistofNRMArecords;
        Test.stopTest();
    
     }  
   
}