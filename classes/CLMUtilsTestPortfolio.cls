/***************************************************************************************************************
 * Description: Test class for CLMUtils
 * *************************************************************************************************************
 * Change History:
 * 
 * Date         Person Responsible  Traceability	Details    
 * 7/22/2022    SKuehl              ESCJ-1642       Created initial API Test class
 * NOTE!!! ANYONE doing TESTING... Be sure to have your User id assigned to Permission Set "APEX Testing Permission Set" and chg to your alias in TestFramework.apxc sql
 * 
 * 1-4-2023     SKuehl              ESCJ-2081       Add code to process Portfolio contract type...
 *													2) Portfolio Agiloft Contract w/ limited data	(port.Name != null)  // Have a Portfolio contract scenerio.  PF-0000013 	
 * 06/13/2023   Kuehl               QFCJ-3537           Chg primary/secondary signer logic to use Primary and Secondary instead of Authorized.
 * 06/15/2023   Kuehl               QFCJ-3979           Bug, values used in 3925 calculations could be null.  Need to check for nulls and if so, set to 0
 ****************************************************************************************************************/

@isTest
public class CLMUtilsTestPortfolio
{    
    @testSetup static void createTestDataPortfolioContract()
    {
		TestFramework.setupDefaultData();

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
        
        Account acct                = TestFramework.createAccount(new Map<sObjectField, Object>{Account.Account_Number__c=>'CJ-0000000999'});
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
        
        OpportunityContactRole ocr  = TestFramework.createOpptContactRole(contacts[0].Id, oppt, True,  'Primary Signer', new Map<sObjectField, Object>{});
        
        OpportunityContactRole ocr2 = TestFramework.createOpptContactRole(contacts[1].Id, oppt, False, 'Secondary Signer', new Map<sObjectField, Object>{});
                
        Segment__c seg              = TestFramework.createSegment(new Map<sObjectField, Object>{ Segment__c.Opportunity__c=>oppt.Id, Segment__c.Property__c=>prop.Id });
        
                
        //SPK !!!! NOTE: Offer validation rule -> No_Offer_Creation_w_null_Property_Use Could fail if you do not run this as a System Admin.
        //I created a Custom Permission: Bypass_Permission
		//I enabled that Custom Permission "Bypass_Permission under the System admin role.
		//I added 1 line to the Validation Rule at the bottom:     && $Permission.Bypass_Permission = False
		//Caveats. System Admin role will always bypass that Validation Rule. Which might not be what we want. But normal SFCJ folks should have a diff role and work just fine.
        
        // FYI:  Offer has a lookup for Portfolio.  
        
		// 1) Full Agiloft Contract - offr.Capital_Design_Required__c == 'Yes'    
		// 	  Build Full Contract WITH Cap Design data...
        Offer__c offr    = TestFramework.createOffer(new Map<sObjectField, Object>{ Offer__C.Opportunity__c=>oppt.Id, Offer__c.Capital_Design_Required__c=>'Yes', Offer__c.Qualifies_for_Direct_Approval__c=>'No', Offer__c.Offer_Status__c=>'Manager Approved' });
                
        Capital_Design__c capd  = TestFramework.createCapDesign(new Map<sObjectField, Object>{Capital_Design__c.Opportunity__c=>oppt.Id, Capital_Design__c.Offer__c=>offr.Id});
      	 // Has 1 Trigger:  CapitalDesignTrigger
      	 
        //ESCJ-2081 - 1-3-2023 - spk
        // FYI:  Related fields....
        //    Portfolio can have a Related_Account__c. 					So Account needs to be created before hand. 			(Can be blank)
        //    Portfolio can have a Lead_Capital_Design_Shared__c Assoc.	So Capital Design need to be created after Portfolio. 	(Can be blank)
        //    Portfolio has a Contract Lookup.  						So Contract needs to be created before hand.			(Can be blank)
        //    Portfolio can hook to Offer.								Offer can be updated to use Portfolio #					(Can be blank)
        
        
        //Create Portfolio w/o Name  means NO Portfolio in testing
        // 2) Portfolio Agiloft Contract w/ limited data	(port.Name != null)    // Have a Portfolio contract scenerio.  PF-0000013 
        Portfolio__c port	= TestFramework.createPortfolio(new Map<sObjectField, Object>{Portfolio__C.Name=>'PF-0000013', Portfolio__C.Related_Account__c=>acct.Id }); 
                
        Contract ctrct   	= TestFramework.createContract(new Map<sObjectField, Object>{Contract.AccountId=>acct.Id, Contract.Opportunity__c=>oppt.Id, Contract.Offer__c=>offr.Id, Contract.Portfolio__c=>port.Id});
          
        Opportunity oppt2 = new Opportunity();
        oppt2 = oppt;
        		
        oppt2 						= TestFramework.updateOpportunity(oppt, new Map<sObjectField, Object>{Opportunity.ContractId=>ctrct.Id, Opportunity.Opportunity_System_Identifier__c=>oppt.Id, Opportunity.Primary_Offer__c=>offr.Id});
               									

        Offer__c offr2 = new Offer__c();
        offr2 = offr;
        
        // Update Offer fields:  
        //     Associated_Capital_Design__c=>capd.Id 
        //     Contract__c=>ctrct.Id
        //     Portfolio__c=>port.Id  	(if related to a Portfolio)
        offr2 						= TestFramework.updateOffer(offr, new Map<sObjectField, Object>{ Offer__c.Associated_Capital_Design__c=>capd.Id, Offer__c.Contract__c=>ctrct.Id});
      
        
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
    private static void testAgiloftPortfolioContractCreate()   // Create Portfolio Contract
    {
        system.debug('In testAgiloftPortfolioContractCreate function...');
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());        
                        
        Contract c = [SELECT Id FROM Contract limit 1];
        
        system.debug('Contract ID:  ' + c.Id);

        Test.startTest();
            
        string agiloftResult = CLMUtils.createAgiloftContract(c.id);
                            
        System.assertNotEquals(null, agiloftResult, 'agiloftResult should not be null');
            
        Test.stopTest();
    }     
        
}