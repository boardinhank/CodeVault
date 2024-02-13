@isTest
public class CreatePropertyControllerTest {
   
  /**   @isTest public static void testSaveAndRedirectToSuccess(){
       	SObject sObj =  createSObject(false, false);
        
        ApexPages.StandardController sd = new ApexPages.StandardController(sObj);
        CreatePropertyController controller = new CreatePropertyController(sd);
        // PageReference pr = controller.saveAndRedirectToSuccess();
        // System.assertEquals(pr.getUrl().contains('PRSubmitSuccess'), true);
    } **/
    
    @isTest static void withPhoneNoEmail(){
        
        lead newLead = new lead(
            firstname = 'test',
       		lastname = 'test',
            company = 'test',
            email = 'test@email.com',
            property_name__c = 'test',
            phone = '2223334444',
            Referral__c = 'Yes'
        
        );
        insert newLead;
        
        ApexPages.StandardController sd = new ApexPages.StandardController(newLead);
        CreatePropertyController controller = new CreatePropertyController(sd);
        PageReference pr = controller.saveAndRedirectToSuccess();
    }
    
        @isTest static void withEmailNoPhone(){
        
        lead newLead = new lead(
            firstname = 'test',
       		lastname = 'test',
            company = 'test',
            email = 'test@email.com',
            property_name__c = 'test',
            Referral__c = 'Yes'
        
        );
        insert newLead;
        
        ApexPages.StandardController sd = new ApexPages.StandardController(newLead);
        CreatePropertyController controller = new CreatePropertyController(sd);
        PageReference pr = controller.saveAndRedirectToSuccess();
    }
    
         @isTest static void withoutEmailAndPhone(){
        
        lead newLead = new lead(
            firstname = 'test',
       		lastname = 'test',
            company = 'test',
            property_name__c = 'test',
            Referral__c = 'No'
        
        );
        insert newLead;
        
        ApexPages.StandardController sd = new ApexPages.StandardController(newLead);
        CreatePropertyController controller = new CreatePropertyController(sd);
        PageReference pr = controller.saveAndRedirectToSuccess();
    }
    
       @isTest static void withAddress(){
        
        lead newLead = new lead(
       		lastname = 'test',
            company = 'test',
            email = 'test@email.com',
            property_name__c = 'test',
            Property_Address_Street__c = '1234 address',
            Property_Address_City__c = 'city',
            Property_Address_State__c = 'AZ',
            Property_Address_Zip__c = '84123'

        );
        insert newLead;
        
        ApexPages.StandardController sd = new ApexPages.StandardController(newLead);
        CreatePropertyController controller = new CreatePropertyController(sd);
        PageReference pr = controller.saveAndRedirectToSuccess();
    }
    
           @isTest static void withoutAddress(){
        
        lead newLead = new lead(
            firstname = 'test',
       		lastname = 'test',
            company = 'test',
            email = 'test@email.com',
            property_name__c = 'test',
            Property_Latitude__c = -77.0364,
            Property_Longitude__c = 38.8951

        );
        insert newLead;
        
        ApexPages.StandardController sd = new ApexPages.StandardController(newLead);
        CreatePropertyController controller = new CreatePropertyController(sd);
        PageReference pr = controller.saveAndRedirectToSuccess();
    }
    
    
        @isTest static void refferalLead(){
        
        lead newLead = new lead(
            firstname = 'test',
       		lastname = 'test',
            company = 'test',
            email = 'test@email.com',
            property_name__c = 'test',
            Referrer_Full_Name__c = 'test',
            Referrer_EMail_Address__c = 'test@email.com',
            Submitter_First_Name__c = 'test',
            Submitter_Last_Name__c = 'test'

        );
        insert newLead;
        
        ApexPages.StandardController sd = new ApexPages.StandardController(newLead);
        CreatePropertyController controller = new CreatePropertyController(sd);
        PageReference pr = controller.saveAndRedirectToSuccess();
    }   
        
  /**  @isTest public static void testForPhoneNoAndEmail(){
        
        SObject sObj =  createSObject(true, false);
        ApexPages.StandardController sd = new ApexPages.StandardController(sObj);
        CreatePropertyController controller = new CreatePropertyController(sd);
        PageReference pr = controller.saveAndRedirectToSuccess();
        string leadid = (string)sObj.get('Id');
        ApexPages.currentPage().getParameters().put('id',leadid);
        System.assert(isErrorFound());
        
    }
    
    @isTest public static void testWhenAddressIsMissing(){
        SObject sObj =  createSObject(false, true);
        ApexPages.StandardController sd = new ApexPages.StandardController(sObj);
        CreatePropertyController controller = new CreatePropertyController(sd);
        string leadid = (string)sObj.get('Id');
        ApexPages.currentPage().getParameters().put('id',leadid);
        PageReference pr = controller.saveAndRedirectToSuccess();
        System.assert(isErrorFound());
    }
    
	
    public static SObject createSObject(boolean phoneAndEMailMiss, boolean addressIsMissing){
        SObject sObj = Schema.getGlobalDescribe().get('Lead').newSObject() ;

        if(!phoneAndEMailMiss){
      		  sObj.put('Phone', '8658246200');
      		  sObj.put('Email', 'test@bc.com');
        }
       
        if(!addressIsMissing){

            sObj.put('Property_Address_Street__c', '1036 MARAPI ST NW');
            sObj.put('Property_Address_City__c', 'ALBUQUERQUE');
            sObj.put('Property_Address_State__c', 'NM');
            sObj.put('Property_Address_Zip__c', '87120');
        }
        
        if(addressIsMissing){
            sObj.put('Property_Longitude__c', 87120);
        }
        sObj.put('LastName', 'Test LeadEERS');
        sObj.put('Company', 'Test CompanyEERS');
        //insert sObj;
        return sObj;
    }
    
    public static boolean isErrorFound(){
        boolean isErrorFound = false;
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assertNotEquals(0, pageMessages.size());
        for(ApexPages.Message message : pageMessages) {
            if(message.getSeverity() == ApexPages.severity.ERROR) {
                isErrorFound = true;        
            }
        }
        return isErrorFound;
    } **/
   
}