/**********************************************************************************************
===============================================================================================
Purpose: CreatePropertyController class is to handle the Web to 
lead form requests and validate/create the PRR record  
===============================================================================================
History:

AUTHOR     	   DATE         Reference     						Description
Deepak Kumar   29/11/2021   ESCJ-318 (Web to lead form)         Initial draft
Deepak Kumar   12/27/2021   ESCJ-344                            Updating Data_Source__c field 
Ted Cabato     10/10/2022   ESCJ-1975                           Modified to create Lead instead of PRR 
***********************************************************************************************/
public class CreatePropertyController {
    private String errorMsg = 'We apologize but we encountered an error saving the lead. Please review the form and confirm all required fields have been completed and resubmit the form.';
    private String errorMsgForMissingAdd = 'Please enter either a property address (street + city + state + zip) or property lattitude/longitude.';
    private String errorMsgForMissEmailPhone = 'Please enter either a contact phone number or contact email address.';
    private ApexPages.StandardController controller;
    private Lead web2Lead {get;set;}
   // private final Lead web2Lead;
    
    public CreatePropertyController(ApexPages.StandardController controller){
        this.controller = controller;
        this.web2Lead = (Lead) controller.getRecord();
        this.web2Lead.Lead_Type__c = 'Hand Raised';  //Hand raise change requested by deepak and lakshmi.
        
    }
    @future(callout = true)
    public static void callout(String leadId){
        System.debug(leadId);
        SyncLeadPEHandler.dontEersCheck('insertion', leadId);

    }
    
    public PageReference saveAndRedirectToSuccess() {
        if(String.isBlank(this.web2Lead.Phone) && String.isBlank(this.web2Lead.Email)){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.errorMsgForMissEmailPhone));
            return null;
        }
       
        boolean isCompleteAddress = !String.isBlank(this.web2Lead.Property_Address_Street__c) && !String.isBlank(this.web2Lead.Property_Address_City__c) && 
            !String.isBlank(this.web2Lead.Property_Address_State__c) && !String.isBlank(this.web2Lead.Property_Address_Zip__c);
        if( !isCompleteAddress){
            if(!(this.web2Lead.Property_Latitude__c != null && this.web2Lead.Property_Longitude__c != null)){
                   ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.errorMsgForMissingAdd));
            	   return null;
               }
         }
        
        this.web2Lead.Referrer_Full_Name__c = this.web2Lead.Submitter_First_Name__c +' '+ this.web2Lead.Submitter_Last_Name__c;  
        this.web2Lead.Referrer_EMail_Address__c = this.web2Lead.Submitter_Email__c;

       if(this.web2Lead.Referral__c == 'yes'){
            this.web2Lead.leadSource = 'Employee Referral';
        } else {
            this.web2Lead.leadSource = 'Internal Referral';
        }
        
      controller.save();
      String leadId = controller.getId();
        
     if(!Test.isRunningTest()) callout(leadId);
      //PageReference successPage = new PageReference('/'+leadId);
      PageReference successPage = new PageReference('/PRSubmitSuccess');
      successPage.getParameters().put('confirmationNo', controller.getId());
      successPage.setRedirect(true);
      return successPage;
      
    }
}