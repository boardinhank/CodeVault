@isTest
public class callParcelServiceControllerTest {

//ALN 
static testMethod void testcallService(){
    List<Property_Request_Record__c> prrRecordList = new List<Property_Request_Record__c>();
    String street = '6001 YANKEE HILL RD';
    String city = 'LINCOLN';
    String state = 'NE';
    Decimal latitude = 33.56905158;
    Decimal longitude = -112.08098859;
    List<Property_Request_Record__c> prrALNRecords = TestDataFactory.createPropertyReqRecords(
        'ALN', street, city, state, latitude, longitude, 1, false
    );
    prrALNRecords[0].Match_Found_In_System__c='No';
    
    prrRecordList.addAll(prrALNRecords);
    PropertyReqRecordTriggerHandler.triggerDisabled=true;
    
    System.debug(prrRecordList);
    System.debug(prrRecordList[0].Match_Found_In_System__c);
    
    List<Property_Request_Record__c> prrDodgeRecords = TestDataFactory.createPropertyReqRecords(
                'Dodge', street, city, state, latitude, longitude, 1, false
            );
    prrDodgeRecords[0].Match_Found_In_System__c='No';
         prrRecordList.addAll(prrDodgeRecords);
    
    insert prrRecordList;
      
    
    Lead testld = new Lead(Firstname='Test',LastName='Lead',Company='TestLead',Property_Latitude__c=33.56905158, Property_Longitude__c=-112.08098859,Requires_Marketing_Review__c=True);
    insert testld;
    
    List<Property_Request_Record__c> updateALNRecords =[Select Id,Data_Source__c from Property_Request_Record__c where Data_Source__c='ALN'];
    Lead updatelead = [Select id,Firstname,LastName,Company,Property_Latitude__c,Property_Longitude__c,Requires_Marketing_Review__c,Property_Request_Record__c from lead LIMIT 1];
    updatelead.Property_Request_Record__c=updateALNRecords[0].Id;
    update updatelead;
    
        
     callParcelServiceController.callService(String.valueOf(updatelead.Id));  
}
    
static testMethod void testDodgecallService(){
    List<Property_Request_Record__c> prrRecordList = new List<Property_Request_Record__c>();
    String street = '6001 YANKEE HILL RD';
    String city = 'LINCOLN';
    String state = 'NE';
    Decimal latitude = 33.56905158;
    Decimal longitude = -112.08098859;
    
    PropertyReqRecordTriggerHandler.triggerDisabled=true;
      
    List<Property_Request_Record__c> prrDodgeRecords = TestDataFactory.createPropertyReqRecords(
                'Dodge', street, city, state, latitude, longitude, 1, false
            );
    prrDodgeRecords[0].Match_Found_In_System__c='No';
         prrRecordList.addAll(prrDodgeRecords);
    
    insert prrRecordList;
    
    Lead testld = new Lead(Firstname='Test1',LastName='Lead1',Company='TestLead1',Property_Latitude__c=33.56905158, Property_Longitude__c=-112.08098859,Requires_Marketing_Review__c=True);
    insert testld;
    
    List<Property_Request_Record__c> updateDodgeRecords =[Select Id,Data_Source__c from Property_Request_Record__c where Data_Source__c='Dodge'];
    Lead updatelead1 = [Select id,Firstname,LastName,Company,Property_Latitude__c,Property_Longitude__c,Requires_Marketing_Review__c,Property_Request_Record__c from lead LIMIT 1];
    updatelead1.Property_Request_Record__c=updateDodgeRecords[0].Id;
    update updatelead1;
    
        
     callParcelServiceController.callService(String.valueOf(updatelead1.Id));  
}
}