/***************************************************************************************************************
 * Description: Test class for CLMUtils
 * *************************************************************************************************************
 * Change History:
 * 
 * Date         Person Responsible  Traceability	Details    
 * 1/27/2022    SKuehl              ESCJ-2345       Created initial API Test class to clean up for SonarQube rules.
 * NOTE!!! ANYONE doing TESTING... Be sure to have your User id assigned to Permission Set "APEX Testing Permission Set" and chg to your alias in TestFramework.apxc sql
 * 01/27/2023   Kuehl               ESCJ-2345       Process Cancel Contract - Run button in Agiolft and update general messages notes
 * 02-16-2023   Kuehl                           Code Coverage 76%
 * 05/01/2023   Kuehl               QFCJ-3071       Chg to CLMUtils2.  Need to package test class with it.   Code Coverage 76%
 * 10/31/2023   Kuehl               QFCJ-4713       Removed notes field:  Contract_Request_Status_Notes__c and Replaced it with Contract_Request_Offer_Notes__c  Code Coverage 76%
 *  
 * ****************************************************************************************************************/
 
@isTest
public class CLMUtilsTest2
{   
    private static final String CNTRLR_NULL_AND_FAILED = 'After constructor, CLMUtils2 was NULL and failed';
    private static final String PARMLIST_NULL_NEG_TEST = 'After constructor, CLMUtils2 parameter-list was NULL as expected in this negative test';
	private static final String DEFAULT_EMPTY = ' ';
    
    //variables that hold values from testSetup data that was created
    private static Id testingCId = null;
    
    public String contractRecordId;

    

    @testSetup 
    static void createTestDataFullContract()
    {
        final string authorizedSigner = 'Authorized Signer';

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
        
        TestFramework.createOpptContactRole(contacts[0].Id, oppt, True,  authorizedSigner, new Map<sObjectField, Object>{});
        
        TestFramework.createOpptContactRole(contacts[1].Id, oppt, False, authorizedSigner, new Map<sObjectField, Object>{});
        
        // 7-28-2022 - ESCJ-1675 spk - Added code... Not every contract will have a secondary contact.
        OpportunityContactRole[] opptContRole2 = [SELECT id, ContactId, OpportunityId, IsPrimary,Role FROM OpportunityContactRole 
                                                  WHERE ( (OpportunityId =: oppt.id) AND (Role =: authorizedSigner) AND (IsPrimary =: false) ) WITH SECURITY_ENFORCED LIMIT 1];  // Example:  0068F000001eIcXQAU 
        
         //Use opptContRole1.ContactId to find Primary Contact data.
        
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
        Portfolio__c port	= TestFramework.createPortfolio(new Map<sObjectField, Object>{}); 
        system.debug('port object created?  port.id:  ' + port.id);
                       
        Contract ctrct = TestFramework.createContract(new Map<sObjectField, Object>{Contract.AccountId=>acct.Id, Contract.Opportunity__c=>oppt.Id, Contract.Offer__c=>offr.Id, Contract.CLM_Contract_ID__c=>'3045757'});
          
        Opportunity oppt2 = new Opportunity();
        oppt2 = oppt;
        		
        //oppt2 = TestFramework.updateOpportunity(oppt, new Map<sObjectField, Object>{Opportunity.ContractId=>ctrct.Id, Opportunity.Opportunity_System_Identifier__c=>oppt.Id, Opportunity.Primary_Offer__c=>offr.Id});
        oppt2 = TestFramework.updateOpportunity(oppt, new Map<sObjectField, Object>{Opportunity.ContractId=>ctrct.Id, Opportunity.Primary_Offer__c=>offr.Id});
               									

        Offer__c offr2 = new Offer__c();
        offr2 = offr;
        
        // Update Offer fields:  
        //     Associated_Capital_Design__c=>capd.Id 
        //     Contract__c=>ctrct.Id
        //     Portfolio__c=>port.Id  	(if related to a Portfolio)
        offr2 = TestFramework.updateOffer(offr, new Map<sObjectField, Object>{ Offer__c.Associated_Capital_Design__c=>capd.Id, Offer__c.Contract__c=>ctrct.Id});
      
        
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
                        SandboxUrl__c='https://lumendev.agiloft.com/ewws'
                        );     
                    

        Agiloft_Settings__c[] asList = new Agiloft_Settings__c[0];

        asList.add(new Agiloft_Settings__c(Name='AgiloftLoginId',           	Value__c='cj_api_dev'));
        asList.add(new Agiloft_Settings__c(Name='AgiloftLoginPassword',     	Value__c='YQmSYqhUwbgsYa8'));
        asList.add(new Agiloft_Settings__c(Name='AgiloftTestOrgActive',     	Value__c='Yes'));
        asList.add(new Agiloft_Settings__c(Name='AgiloftKB',                	Value__c='LumenDev'));
        asList.add(new Agiloft_Settings__c(Name='AgiloftSuccessMessage',    	Value__c='A new CLM contract record is being created. Once complete you will receive an email with a link to the contract record in the CLM Contract System'));
        asList.add(new Agiloft_Settings__c(Name='AgiloftWarningMessage',    	Value__c=''));
		asList.add(new Agiloft_Settings__c(Name='AgiloftCancelSuccessMessage',	Value__c='The CLM contract record is being canceled. Once complete you will receive an email with a link to the contract record in the CLM Contract System.'));
        
        insert asList;

        system.debug('After insert asList...');
	}

        

    @isTest
    private static void testConstructor() 
    {
        system.debug('In testConstructor function...');
        
        Test.startTest();
                        
        List<Contract> cList = [SELECT Id FROM Contract limit 1];

        if (cList != null && cList.size() > 0) 
        {
	        System.debug('(TestCLMUtils2.testConstructor) Id = ' + cList?.get(0)?.Id);
        	testingCId = cList.get(0).Id;
        }

		CLMUtils2 testCLMUtils2 = new CLMUtils2(testingCId);

        if (testCLMUtils2 == null) 
        {
            System.assertEquals(null, testCLMUtils2, CNTRLR_NULL_AND_FAILED);
        }

        Test.stopTest();

    }//end test method testConstructor
    

    
    @isTest
    private static void testConstructorNullParams() 
    {
        system.debug('In testConstructorNullParms function...');
       
        Test.startTest();
		
        CLMUtils2 testCLMUtils2 = new CLMUtils2(null);
        
        if (testCLMUtils2 == null) {
            System.assertEquals(null, testCLMUtils2, CNTRLR_NULL_AND_FAILED);
        }
        
        if (testCLMUtils2.coParamsList == null) {
            System.assertEquals(null, testCLMUtils2.coParamsList, PARMLIST_NULL_NEG_TEST);
        }            
        
        Test.stopTest();

    }//end test method testConstructorNullParams

    
    @isTest    
    private static void testAgiloftFullContractCancel()   // Cancel FULL Contract
    {
        system.debug('In testAgiloftFullContractCancel function...');
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());        
                                
        List<Contract> cList = [SELECT Id FROM Contract limit 1];
        
        
        if (cList != null && cList.size() > 0) 
        {
            System.debug('(TestCLMUtils2.testAgiloftFullContractCancel) Id = ' + cList?.get(0)?.Id);
        	testingCId = cList.get(0).Id;
        }

		List<CLMUtils2.CalloutParams> calloutParamsList = new List<CLMUtils2.CalloutParams>();
                
        CLMUtils2.CalloutParams cp 	= new CLMUtils2.CalloutParams();
        
        cp.contractRecordId = testingCId;
        
        calloutParamsList.add(cp);
        
        if (calloutParamsList.size() == 0) 
        {
            System.assertEquals(0, calloutParamsList.size(), 'The Callout-Parameters-List had 0 items and failed');
        }
        
        Test.startTest();
        
        List<String> testReturnStringList = CLMUtils2.cancelAgiloftContract(calloutParamsList);

        
        System.debug((testReturnStringList!=null && testReturnStringList.size() > 0 && testReturnStringList.get(0) != null) ? testReturnStringList.get(0) : 'No message returned.');
                 
        
        if(testReturnStringList == null) 
        {
            System.assertEquals(0, testReturnStringList.size(), 'The Return-String-List was NULL and failed');
        }

        if (testReturnStringList.size() == 0) 
        {
            System.assertEquals(0, testReturnStringList.size(), 'The Return-String-List had 0 items and failed');
        }
                    
        Test.stopTest();
    }        
}