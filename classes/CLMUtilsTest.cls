/***************************************************************************************************************
 * Description: Test class for CLMUtils
 * *************************************************************************************************************
 * Change History:
 * 
 * Date        	Dev  	    Traceability		Details
 * 7/22/2022    SKuehl      ESCJ-1642           Created initial API Test class
 * NOTE!!! ANYONE doing TESTING... Be sure to have your User id assigned to Permission Set "APEX Testing Permission Set" and chg to your alias in TestFramework.apxc sql
 * 
 * 1-4-2023     SKuehl      ESCJ-2081           Add code to process Full contract type...
 *											    1) Full Agiloft Contract with Cap Design data	offr.Capital_Design_Required__c == 'Yes'    // Build Full Contract WITH Cap Design data...	
 * 01/13/2023   Kuehl       ESCJ-2345           Updated Code for SonarQube
 * 04/11/2023   Kuehl       QFCJ-2780           New CJ_Stagings fields: account.LOB__c=cj_lobid, opportunity.OwnerId=cj_opportunity_owner_id
 *                                                                      user.CUID__c=cj_opportunity_owner_cuid, user.Name=cj_opportunity_owner_name, user.Email=cj_opportunity_owner_email
 * 04/11/2023   Kuehl       QFCJ-2611/QFCJ-2872 New CJ_Stagings field:  capD.Entity_Type__c=entity_type
 * 04/11/2023   Kuehl       QFCJ-2761/QFCJ-2872 New CJ_Stagings fields: prop.Property_Contract_Status__c=property_contract_status
 *                                                                      offer.Existing_Agreement_Type__c=existing_agreement_type
 *                                                                      offer.Existing_Agreement_Effective_Date__c=existing_agreement_effective_date
 * 06/08/2023   Kuehl       QFCJ-3925           Had to adjust for new changes in system since last time.  Validation rules, data, etc.
 * 06/13/2023   Kuehl       QFCJ-3537           Chg primary/secondary signer logic to use Primary and Secondary instead of Authorized.
 * 06/15/2023   Kuehl       QFCJ-3979           Bug, values used in 3925 calculations could be null.  Need to check for nulls and if so, set to 0
 * 07/07/2023   Kuehl       QFCJ-4105           Added Encoding fuction to capture  '&'  properly  Chg & to %26   Example:    EncodingUtil.urlEncode('Dave & Buster', 'UTF-8');  = Dave+%26+Buster
 * 07/12/2023   Kuehl       QFCJ-4114           New field added to use in Clause verbieage. property object field: property_use__c
 * 10/04/2023   Kuehl       QFCJ-4400           Added Encoding fuction to capture  '&'  properly  Chg & to %26   Example:    EncodiongUtil.urlEncode('Dave & Buster', 'UTF-8');  = Dave+%26+Buster   
 *                                              &se_sow_project_scope=  capd.SE_SOW_Project_Scope__c  i.e Build Big & Tall
 * 10/05/2023   Kuehl       QFCJ-3945           Add 4 new fields to be pulled and passed to Agiloft CJ Stagings table...
 *                                              Ramp Period included in Term from Offer.Ramp_Period_included_in_Term__c Picklist(255) -> ramp_period_included_in_term 
 *                                              Billing Contact Name  from Contact.Name String(121) when Role == Billing Contact      -> billing_contact_name 
 *                                              Billing Contact Phone from Contact.Phone Phone(40) when Role == Billing Contact       -> billing_contact_phone
 *                                              Billing Contact Email from Contact.Email email(80) when Role == Billing Contact       -> billing_contact_email
 * 10/18/2023   Kuehl       QFCJ-4691           Remove Oppt based data in Porfolio payload.  Use Porfolio obj data instead for OwnerId, Account, etc.
 *                                              Added CONTRACT_ID_VAR_CONST and payload lines to add '&contract_id=' for ALL contract types.
 * 10/26/2023   Kuehl       QFCJ_4703           Add code to see if we can catch when CJ_Staging_Record_ID__c & CLM_Transmission_Code__c are NOT allowing update to be made due to Field level set security.
 * 
 * 12/6/2023    Kuehl       QFCJ-4770           New CJ_Staging fields:  gratis_units_video_str and gratis_units_data_str
 * 
 * 1/12/2024    Neidecker   QFCJ-4829           Format values or Termination Fee Schedule
****************************************************************************************************************/

@isTest
public class CLMUtilsTest
{    
    @testSetup static void createTestDataFullContract()
    {
        string primarySigner = 'Primary Signer';

		TestFramework.setupDefaultData();   // FYI:  runAs() happens in here
		
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());  

        /*THE Process:
            1) Create Lead
            2) Convert Lead which creates account, contact and property
            3) Create opportunity
			4) Create segment
            5) Create offer
            6) Submit offer for capital evaluation
            7) Engineer creates capital design
            8) Planner updates and completes capital evaluation
            9) Account Manager submits offer for approval
            10) Sales Support approves offer
            11) Pricing support approves offer (POM)
            12) Seller can request a contract IF the offer is approved AND there are no open contract requests in the opportunity.

            Objects:
                Lead
                Acct
				Contact
				Property
				Opportunity
                Segment
                Offer                
                Cap Design
				Portfolio
                Contract				
        */            
        
        //Lead ld              		= TestFramework.createLead(new Map<sObjectField, Object>{});      // This is NOT Technically needed for testing Agiloft API.        		  										
        // Has 2 triggers:
        // 		LeadPEUpdate
        // 		LeadPEUpdateTrigger
        
        //Account acct                = TestFramework.createAccount(new Map<sObjectField, Object>{Account.Account_Number__c=>'CJ-0000000999'});
        Account acct                = TestFramework.createAccount(new Map<sObjectField, Object>{});
        // Has 2 triggers:
        //   	AccountTrigger
        //   	DNB_AccountTrigger
        
        Contact[] contacts 			= TestFramework.createContacts(3, new Set<Id>{acct.Id},new Map<SObjectField, Object>{});
        // Has 3 triggers:
        // 		captureContact
        //		captureContactInfo
        // 		ContactPEUpdate1
  
        
        Property__c prop            = TestFramework.createProperty(acct, new Map<sObjectField, Object>{});
        // Has 1 Trigger:  PropertyTrigger
        
		Opportunity oppt            = TestFramework.createOpportunity(acct, prop, new Map<sObjectField, Object>{ });              
        
        TestFramework.createOpptContactRole(contacts[0].Id, oppt, True, primarySigner, new Map<sObjectField, Object>{});
        
        TestFramework.createOpptContactRole(contacts[1].Id, oppt, False, primarySigner, new Map<sObjectField, Object>{});
        
        // 7-28-2022 - ESCJ-1675 spk - Added code... Not every contract will have a secondary contact.
        OpportunityContactRole[] opptContRole2 = [SELECT id, ContactId, OpportunityId, IsPrimary,Role FROM OpportunityContactRole 
                                                  WHERE ( (OpportunityId =: oppt.id) AND (Role =: primarySigner) ) WITH SECURITY_ENFORCED LIMIT 1];  // Example:  0068F000001eIcXQAU 
        
         //Use opptContRole1.ContactId to find Primary Contact data.
        //Contact cont1 = [SELECT id, Name, Title FROM Contact WHERE  id =: opptContRole1.ContactId  WITH SECURITY_ENFORCED LIMIT 1]; // Example:  0038F000007kx8mQAA
        
        Contact cont2; // 7-28-2022 - ESCJ-1675 spk - Added if.. Not every contract will have a secondary contact.
        
        if ( opptContRole2.size() > 0 ) 
        {
            //Use opptContRole2.ContactId to find Secondary Contact data.
            cont2 = [SELECT id, Name, Title FROM Contact  WHERE id =: opptContRole2[0].ContactId WITH SECURITY_ENFORCED LIMIT 1]; // Example:  0038F000007kx8mQAA
        }   
                
  		TestFramework.createSegment(new Map<sObjectField, Object>{ Segment__c.Opportunity__c=>oppt.Id, Segment__c.Property__c=>prop.Id });
        
                
        //SPK !!!! NOTE: Offer validation rule -> No_Offer_Creation_w_null_Property_Use Could fail if you do not run this as a System Admin.
        //I created a Custom Permission: Bypass_Permission
		//I enabled that Custom Permission "Bypass_Permission under the System admin role.
		//I added 1 line to the Validation Rule at the bottom:     && $Permission.Bypass_Permission = False
		//Caveats. System Admin role will always bypass that Validation Rule. Which might not be what we want. But normal SFCJ folks should have a diff role and work just fine.
        
        // FYI:  Offer has a lookup for Portfolio.  
        
		// 1) Full Agiloft Contract - offr.Capital_Design_Required__c = Yes
		// 	  Build Full Contract WITH Cap Design data...
        Offer__c offr    = TestFramework.createOffer(new Map<sObjectField, Object>{ Offer__C.Opportunity__c=>oppt.Id, Offer__c.Capital_Design_Required__c=>'Yes', Offer__c.Qualifies_for_Direct_Approval__c=>'No', Offer__c.Offer_Status__c=>'Manager Approved'});
        
        Capital_Design__c capd  = TestFramework.createCapDesign(new Map<sObjectField, Object>{Capital_Design__c.Opportunity__c=>oppt.Id, Capital_Design__c.Offer__c=>offr.Id});
      	 // Has 1 Trigger:  CapitalDesignTrigger
      	 
        //ESCJ-2081 - 1-3-2023 - spk
        // FYI:  Related fields....
        //    Portfolio can have a Related_Account__c. 					So Account needs to be created before hand. 			(Can be blank)
        //    Portfolio can have a Lead_Capital_Design_Shared__c Assoc.	So Capital Design need to be created after Portfolio. 	(Can be blank)
        //    Portfolio has a Contract Lookup.  						So Contract needs to be created before hand.			(Can be blank)
        //    Portfolio can hook to Offer.								Offer can be updated to use Portfolio #					(Can be blank)
        
        
        //Create Portfolio w/o Name  means NO Portfolio in testing
        Portfolio__c port	= TestFramework.createPortfolio(new Map<sObjectField, Object>{}); 
        system.debug('port object created?  port.id:  ' + port.id);
                       
        //Contract ctrct = TestFramework.createContract(new Map<sObjectField, Object>{Contract.AccountId=>acct.Id, Contract.Opportunity__c=>oppt.Id, Contract.Offer__c=>offr.Id, Contract.Contract_Request_Status_Notes__c=>'TEST', Contract.Property_Lookup__c=>prop.id});
          Contract ctrct = TestFramework.createContract(new Map<sObjectField, Object>{
            Contract.AccountId=>acct.Id,                        Contract.Opportunity__c=>oppt.Id, 
            Contract.Offer__c=>offr.Id,                         Contract.Contract_Status__c=>'Contract Requested', 
            Contract.Contract_Request_Status_Notes__c=>'TEST',  Contract.Property_Lookup__c=>prop.id});  
        Opportunity oppt2 = new Opportunity();
        oppt2 = oppt;
        		
        //oppt2 = TestFramework.updateOpportunity(oppt, new Map<sObjectField, Object>{Opportunity.ContractId=>ctrct.Id, Opportunity.Opportunity_System_Identifier__c=>oppt.Id, Opportunity.Primary_Offer__c=>offr.Id});
        oppt2 = TestFramework.updateOpportunity(oppt, new Map<sObjectField, Object>{Opportunity.ContractId=>ctrct.Id, Opportunity.Primary_Offer__c=>offr.Id});
     									

        Offer__c offr2 = new Offer__c();
        offr2 = offr;
        
        // Update Offer fields:  
        //     	Associated_Capital_Design__c=>capd.Id 
        //      Refresh_Capital_Design__c=>capd.Id
        //     	Contract__c=>ctrct.Id
        //     	Portfolio__c=>port.Id  	(if related to a Portfolio)
        offr2 = TestFramework.updateOffer(offr, new Map<sObjectField, Object>{ Offer__c.Associated_Capital_Design__c=>capd.Id, Offer__c.Refresh_Capital_Design__c=>capd.Id, Offer__c.Contract__c=>ctrct.Id});
      
        
        system.debug('Before insert new EnvironmentURLs__c...');

        
        string env = Level3Utils.detectEnv().toUpperCase();
        env = env.remove('CJ');  // Remove "CJ" from the beginning. spk 10-25-2022
        system.debug('env:  ' + env);
                
        string sandboxName;
        sandboxName = env.left(env.length()-1);
        system.debug('sandboxName :  ' + sandboxName);
        
        insert new EnvironmentURLs__c(
                        Name='AgiloftContract'+'_' + env, 	//AgiloftContract_DEV3 
                        SandboxName__c=sandboxname,			// DEV
                        PageName__c='AgiloftContract',
                        SandboxUrl__c='https://lumendev.agiloft.com/ewws/EWCreate?'
                        );     
                    

        Agiloft_Settings__c[] asList = new Agiloft_Settings__c[0];

        asList.add(new Agiloft_Settings__c(Name='AgiloftLoginId',           Value__c='cj_api_dev'));
        asList.add(new Agiloft_Settings__c(Name='AgiloftLoginPassword',     Value__c='YQmSYqhUwbgsYa8'));
        asList.add(new Agiloft_Settings__c(Name='AgiloftTestOrgActive',     Value__c='Yes'));
        asList.add(new Agiloft_Settings__c(Name='AgiloftKB',                Value__c='LumenDev'));
        asList.add(new Agiloft_Settings__c(Name='AgiloftSuccessMessage',    Value__c='A new CLM contract record is being created. Once complete you will receive an email with a link to the contract record in the CLM Contract System'));
        asList.add(new Agiloft_Settings__c(Name='AgiloftWarningMessage',    Value__c=''));
        
        insert asList;

        system.debug('After insert asList...');
	}

    
    @isTest    
    private static void testAgiloftFullContractCreate()   // Create FULL Contract
    {
        system.debug('In testAgiloftFullContractCreate function...');
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());        
                        
        Contract c = [SELECT Id FROM Contract limit 1];
        
        system.debug('Contract ID:  ' + c.Id);

        Test.startTest();
            
        string agiloftResult = CLMUtils.createAgiloftContract(c.id);
                            
        System.assertNotEquals(null, agiloftResult, 'agiloftResult should not be null');
            
        Test.stopTest();
    }             
}