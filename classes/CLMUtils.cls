/**********************************************
 * CLMUtils - Utility class for Contract Location Management  
 * Change History: 
 * Date        	Dev  	    Traceability		Details
 * 10/28/2021  	Feike       LBOCM-26923		    Base version
 * 02/08/2022	Kuehl		ESCJ-390			Copied FROM SFDC Enterprise.
 * 05/12/2022	Kuehl		ESCJ-1390			New field to pull and push to Agiloft CJ_Stagings table.  Compensation_Needed__c
 * 07/28/2022 	Kuehl		ESCJ-1675			Add new code in for secondary contacts.  Will not always have a 2nd contact.
 * 08/01/2022 	Melugiri	ESCJ-1597			Two New fields to pull and push to Agiloft CJ_Stagings table. Communications_Wiring_Type__c and Communications_Wiring_Quantity_per_WAP__c.
 * 08/02/2022   Kuehl       ESCJ-1679           Refactor code for better Code Coverage during testing.
 * 08/16/2022	Kuehl		ESCJ-1737			Contract Gen-Update Field API Name-Change api field name Communications_Wiring_Quantity_per_WAP__c to Comm_Wiring_Qty_Per_WAP__c  due to a logic bug so that Agiloft receives the correct numerical value.
 * 08/26/2022 	Melugiri	ESCJ-1736			Add New field to pull and push into Agiloft CJ_Stagings table. Third_Prepaid_Marketing_Fee_Payment__c. 
 * 09/19/2022	Kuehl		ESCJ-1830			Add New field to pull Contract Template to Use (Contract_Template_to_Use__c) and push the value to the CJ Stagings field Contract Template To Use (contract_template_to_use).
 * 11/07/2022	Shobith		ESCJ-2006           Added 2 New fields to pull and push into Agiloft CJ_Stagings table. Property_Management_Guest_Services__c, Wired_Business_Replacemnt_Guest_Services__c.
 * 11/30/2022 	Kuehl							Added code to capitablize the True/False data for Agiloft CJ_Stagings fields:  Property_Management_Guest_Services__c, Wired_Business_Replacemnt_Guest_Services__c to be recognized as valid values.
 * 11/30/2022 	Kuehl		            Code Coverage 84%  using CLMUtilsTest
 * 12/02/2022   Kuehl       ESCJ-2081           Add code to handle Portfolios and No Capital Design Offers.
 * 01/05/2023	Kuehl		            Code Coverage 89%  using CLMUtilsTest, CLMUtilsTestPortfolio, CLMUtilsTestCustom, CLMUtilsTestEasyEMA
 * 02/06/2023   Kuehl       ESCJ-2270           Contract Gen - Add ASA GF SOW Attributes to Agiloft:
 *                                                              backboards_required, exterior_cabinets, nema_rated_cabinet, number_of_owner_installed_conduits, responsible_for_media_panel
 *                                                              se_sow_additional_company_tasks_1, se_sow_additional_company_Tasks_2, se_sow_project_scope, size_of_owner_installed_conduits
 * 02/06/2023   Kuehl       ESCJ-2420           Contract Gen - ASA IW SOW Attribute - New field:  responsible_for_in_unit_wap_wiring
 * 02/17/2023	Kuehl		            Code Coverage 82%+  using CLMUtilsTest, CLMUtilsTestPortfolio, CLMUtilsTestCustom, CLMUtilsTestEasyEMA
 * 02/22/2023   Kuehl       ESCJ-2507           Contract Gen - Add ASA GF SOW Owner Task Attributes - New fields:  se_sow_additional_owner_tasks_1, se_sow_additional_owner_tasks_2,
 * 02/23/2023	Kuehl		            Code Coverage 82%+  using CLMUtilsTest, CLMUtilsTestPortfolio, CLMUtilsTestCustom, CLMUtilsTestEasyEMA
 * 03/31/2023   Kuehl       QFCJ-2780           New CJ_Stagings fields: account.LOB__c=cj_lobid, opportunity.OwnerId=cj_opportunity_owner_id
 *                                                                      user.CUID__c=cj_opportunity_owner_cuid, user.Name=cj_opportunity_owner_name, user.Email=cj_opportunity_owner_email
 * 03/31/2023   Kuehl       QFCJ-2611/QFCJ-2872 New CJ_Stagings field:  capD.Entity_Type__c=entity_type
 * 04/03/2023   Kuehl       QFCJ-2761/QFCJ-2872 New CJ_Stagings fields: prop.Property_Contract_Status__c=property_contract_status
 *                                                                      offer.Existing_Agreement_Type__c=existing_agreement_type
 *                                                                      offer.Existing_Agreement_Effective_Date__c=existing_agreement_effective_date
 * 06/08/2023   Kuehl       QFCJ-3925           New CJ_Staging fields:  prepaid_marketing_fee_str, prepaid_marketing_fee_ttl_str, prepaid_marketing_fee_ttl
 *                                              CamelCase Property Name, Street & City using StringUtils()
 * 06/13/2023   Kuehl       QFCJ-3537           Chg primary/secondary signer logic to use Primary and Secondary instead of Authorized.
 * 06/15/2023   Kuehl       QFCJ-3979           Bug, values used in 3925 calculations could be null.  Need to check for nulls and if so, set to 0
 * 07/07/2023   Kuehl       QFCJ-4105           Added Encoding fuction to capture  '&'  properly  Chg & to %26   Example:    EncodingUtil.urlEncode('Dave & Buster', 'UTF-8');  = Dave+%26+Buster
 *                                              &account_name=      acct.Name  i.e Little & Allen Associates
 *                                              &property=          prop.Name  i.e Acreage & Unrec
 * 07/12/2023   Kuehl       QFCJ-4114           New field added to use in Clause verbieage. property object field: property_use__c
 * 
 * 10/04/2023   Kuehl       QFCJ-4400           Added Encoding fuction to capture  '&'  properly  Chg & to %26   Example:    EncodiongUtil.urlEncode('Dave & Buster', 'UTF-8');  = Dave+%26+Buster   
 *                                              &se_sow_project_scope=  capd.SE_SOW_Project_Scope__c  i.e Build Big & Tall
 * 
 * 10/05/2023   Kuehl       QFCJ-3945           Add 4 new fields to be pulled and passed to Agiloft CJ Stagings table...
 *                                              Ramp Period included in Term from Offer.Ramp_Period_included_in_Term__c Picklist(255) -> ramp_period_included_in_term 
 *                                              Billing Contact Name  from Contact.Name String(121) when Role == Billing Contact      -> billing_contact_name 
 *                                              Billing Contact Phone from Contact.Phone Phone(40) when Role == Billing Contact       -> billing_contact_phone
 *                                              Billing Contact Email from Contact.Email email(80) when Role == Billing Contact       -> billing_contact_email
 *                                                  Code Coverage: CLMUtilsTest 78%, CLMUtilsTestPortfolio 89%, CLMUtilsTestCustom 83%, CLMUtilsTestEasyEMA 90%
 * 
 * 10/18/2023   Kuehl       QFCJ-4691           Remove Oppt based data in Porfolio payload.  Use Porfolio obj data instead for OwnerId, Account, etc. 
 *                                              Added CONTRACT_ID_VAR_CONST and payload lines to add '&contract_id=' for ALL contract types.
 * 10/26/2023   Kuehl       QFCJ_4703           Add code to see if we can catch when CJ_Staging_Record_ID__c & CLM_Transmission_Code__c are NOT allowing update to be made due to Field level set security.
 * 
 * 12/6/2023    Kuehl       QFCJ-4770           New CJ_Staging fields:  gratis_units_video_str and gratis_units_data_str
 * 
 * 1/12/2024    Neidecker   QFCJ-4829           Format values or Termination Fee Schedule
***************************************************/

global with sharing class CLMUtils
{   
    static string strAgiloftLoginId 		    = Agiloft_Settings__c.getValues('AgiloftLoginId') 				!= null? Agiloft_Settings__c.getValues('AgiloftLoginId').Value__c: null;
    static string strAgiloftLoginPassword 	    = Agiloft_Settings__c.getValues('AgiloftLoginPassword') 		!= null? Agiloft_Settings__c.getValues('AgiloftLoginPassword').Value__c: null;
    static string strAgiloftTestOrgActive 	    = Agiloft_Settings__c.getValues('AgiloftTestOrgActive') 		!= null? Agiloft_Settings__c.getValues('AgiloftTestOrgActive').Value__c: null;
	static string strAgiloftKB				    = Agiloft_Settings__c.getValues('AgiloftKB') 					!= null? Agiloft_Settings__c.getValues('AgiloftKB').Value__c: null;
    static string strAgiloftSuccessMsg 		    = Agiloft_Settings__c.getValues('AgiloftSuccessMessage') 		!= null? Agiloft_Settings__c.getValues('AgiloftSuccessMessage').Value__c: null;    
    static string strAgiloftWarningMsg 		    = Agiloft_Settings__c.getValues('AgiloftWarningMessage') 		!= null? Agiloft_Settings__c.getValues('AgiloftWarningMessage').Value__c: null;
    static final string MANAGER_APPROVED_CONST              = 'Manager Approved';
    static final string USER_ID_VAR_CONST                   = 'user_id=';    
    static final string ACCOUNT_ID_VAR_CONST                = '&account_id=';
    static final string CONTRACT_ID_VAR_CONST               = '&contract_id=';
    static final string CONTRACT_REQUEST_ID_VAR_CONST       = '&contract_request_id=';
    static final string CONTRACT_TEMPLATE_TO_USE_VAR_CONST  = '&contract_template_to_use=';
    static final string ACCOUNT_NAME_VAR_CONST              = '&account_name=';  
    static final string AGILOFT_CONTRACT                    = ' Agiloft Contract: ';
    static final string OFFER_NAME_VAR_CONST                = '&offer_name=';
    
    //qfcj-2780
    static final string LOBID_CONST                         = '&cj_lobid=';
    static final string OPPT_OWNER_ID_CONST                 = '&cj_opportunity_owner_id=';
    static final string OPPT_OWNER_CUID_CONST               = '&cj_opportunity_owner_cuid=';
    static final string OPPT_OWNER_NAME_CONST               = '&cj_opportunity_owner_name=';
    static final string OPPT_OWNER_EMAIL_CONST              = '&cj_opportunity_owner_email=';
           

    Webservice static string classicCreateAgiloftContract(id recordId) // This webservice method is here for the classic javascript button "CLM generate contract"
    {
        return createAgiloftContract(recordId);
    }

    @TestVisible
    @AuraEnabled
        
    public static string createAgiloftContract(id recordId) 
    {    	
        string callingApiName 		= 'AgiloftContractCreate';
        string strAgiloftFinalMsg   = '';
        string agiloftPayload       = '';        
            
        /***********************************        IMPORTANT NOTE      ******************************************* */
        // Agiloft only has 1 Test environment so we can have only 1 sandbox pointing to it.
        // The custom setting "AgiloftSettings.AgiloftTestOrgActive" indicates whether the Sandbox is active for testing with Agiloft.  
        // After a refresh the "AgiloftSettings.AgiloftTestOrgActive" = 'NO'. You have to actively change this custom setting to 'Yes' to activate it for the 
        // sandbox.  
        //   !!! Make sure that when you activate it in one Sandbox, that you de-activate it ( set it to 'No') in the sandbox WHERE it was previously active. !!!!
        /************************************************************************************************************ */
        validateBaseData(recordId);  // Check basic data for good info before continuing..
       
        // FYI, id is aka ContractID - Example: 8008F000000Do02QAC (Contract # 00000217) OR 8008F000000DoETQA0 (Contract # 00000218) - AccountId example: 0018F000001vtb8QAA        
        Contract cntrct	= [SELECT id,
                           		AccountId,
                           		Opportunity__c,
                           		OwnerId,
                           		Contract_Executed_Date__c,
                           		Telephone_for_Notices__c,
                           		Email_Address_for_Notices__c,
                           		Person_Designated_for_Notices__c,
                           		Address_for_Notices__c,
                           		City_for_Notices__c,
                           		State_for_Notices__c,
                           		ZipCode_for_Notices__c,
                           		ContractNumber,
                           		CJ_Staging_Record_ID__c,
                           		Address_Form_Bulk_Order_Form_Received__c,
                           		W9_Processed__c,
                           		Deposit_Forms_Accepted__c,
                           		Gratis_Form_Processed__c,
                           		SSA_Job_Complete__c,
                           		Contract_Lifecycle_Status__c,
                           		Copy_to_Name__c,
                           		Copy_to_Email__c,
                           		Contract_Template_to_Use__c,
                           		Portfolio__c,	 	//ESCJ-2081
                           		Related_Offer__c, 	//ESCJ-2081
                                Property_Lookup__c  //QFCJ-2671
                           FROM Contract WHERE id =: recordId WITH SECURITY_ENFORCED LIMIT 1];

        //ESCJ-2081
        Portfolio__c port;
        
        Account     portacct;
        User        portusr;
        
        Opportunity oppt;
        Account     acct;
        User        usr;
        Offer__c    offr;
        
        // Use cntrct.Portfolio__c to lookup Portfolio if != null   
        if (cntrct.Portfolio__c != null)
        {
			port = [SELECT id, Name, Related_Account__c, portfolio_name__c, ownerId FROM Portfolio__c WHERE id =: cntrct.Portfolio__c WITH SECURITY_ENFORCED LIMIT 1];  // Example:  a07DP00000MFz4lYAD
        }        
            
        if ( port != null) // pull Portfolio related data and then process below    //QFCJ-4691
        {            
            portacct = [SELECT id, LOB__c, Name FROM Account WHERE id =: port.Related_Account__c  WITH SECURITY_ENFORCED LIMIT 1]; // Example:  0018F000001vtb8QAA

            portusr  = [SELECT id, CUID__c, Name, Email FROM User WHERE id =: port.OwnerId  WITH SECURITY_ENFORCED LIMIT 1]; // Example:  0055e000004ywR2AAI
        }
        else  // pull other standard data.
        {
            // Use cntrct.Opportunity__c to lookup Oppt data. id Example: 0068F000001eIcXQAU   Property__c Example: a0A8F00000094c1UAA
            oppt = [SELECT id, AccountId, Name, Property__c, Capital_Design__c, ContractId, Primary_Offer__c, OwnerId FROM Opportunity  WHERE id =: cntrct.Opportunity__c WITH SECURITY_ENFORCED LIMIT 1];  // Example:  0068F000001eIcXQAU

            // Use oppt.AccountId to find account data
            acct = [SELECT id, LOB__c, Name, HOA_COA__c, BillingStreet, BillingCity, BillingState, BillingPostalCode FROM Account WHERE id =: oppt.AccountId  WITH SECURITY_ENFORCED LIMIT 1]; // Example:  0018F000001vtb8QAA

            // ESCJ-2780
            // user oppt.OwnerId key to lookup related User Info
            usr = [SELECT id, CUID__c, Name, Email FROM User WHERE id =: oppt.OwnerId  WITH SECURITY_ENFORCED LIMIT 1]; // Example:  0055e000004ywR2AAI

            // Use  oppt.Primary_Offer__c to find Offer data.
            offr = [SELECT id,
                            Capital_Design_Required__c,			//ESCJ-2081
                            Qualifies_for_Direct_Approval__c,	//ESCJ-2081
                            Offer_Status__c, 					//ESCJ-2081
                            Associated_Capital_Design__c,
                            Refresh_Capital_Design__c,
                            Service_Delivery__c,
                            Offer_Expiration_Date__c,
                            Contract_Term__c,
                            First_Occupancy_Date__c,
                            Billing_Ramp_Period__c,
                            Owner_Contribution_Payment__c,
                            Owner_Contribution_Days_Payment_Due__c,
                            Offer_Total_Units__c,
                            Offer_Type__c,
                            Name,
                            Development_Status__c,
                            Absorption_Table_Needed__c,
                            Revenue_Share_Type_Approved__c,
                            Property_Management_Guest_Services__c,  //CHANGE FOR ESCJ-2006
                            Wired_Business_Replacemnt_Guest_Services__c,
                            
                            Tier_1_Approved__c, Tier_2_Approved__c, Tier_3_Approved__c, Tier_4_Approved__c, Tier_5_Approved__c, Tier_6_Approved__c,
                            
                            Tier_Value_1_Approved__c, Tier_Value_2_Approved__c, Tier_Value_3_Approved__c, Tier_Value_4_Approved__c, Tier_Value_5_Approved__c, Tier_Value_6_Approved__c,
                            
                            Flat_Revenue_Share_Approved__c,
                            
                            Units_Built_Year_1__c, Units_Built_Year_2__c, Units_Built_Year_3__c, Units_Built_Year_4__c, Units_Built_Year_5__c,
                            Units_Built_Year_6__c, Units_Built_Year_7__c, Units_Built_Year_8__c, Units_Built_Year_9__c, Units_Built_Year_10__c,
                            
                            Cumulative_Living_Units_Built_Year_1__c,
                            Cumulative_Living_Units_Built_Year_2__c,
                            Cumulative_Living_Units_Built_Year_3__c,
                            Cumulative_Living_Units_Built_Year_4__c,
                            Cumulative_Living_Units_Built_Year_5__c,
                            Cumulative_Living_Units_Built_Year_6__c,
                            Cumulative_Living_Units_Built_Year_7__c,
                            Cumulative_Living_Units_Built_Year_8__c,
                            Cumulative_Living_Units_Built_Year_9__c,
                            Cumulative_Living_Units_Built_Year_10__c, 
                            
                            Months_0_12_Year_1__c,  Months_13_24_Year_2__c, Months_25_36_Year_3__c, Months_37_48_Year_4__c, Months_49_60_Year_5__c,
                            Months_61_72_Year_6__c, Months_73_84_Year_7__c, Months_85_96_Year_8__c, Months_97_108_Year_9__c, Months_109_120_Year_10__c,
                            
                            ETL_Position_Requested__c,
                            ETL_Months_0_12_Year_1__c,
                            ETL_Months_13_24_Year_2__c,
                            ETL_Months_25_36_Year_3__c,
                            ETL_Months_37_48_Year_4__c,
                            ETL_Months_49_60_Year_5__c,
                            ETL_Months_61_72_Year_6__c,
                            ETL_Months_73_84_Year_7__c,
                            ETL_Months_85_96_Year_8__c,
                            ETL_Months_97_108_Year_9__c,
                            ETL_Months_109_120_Year_10__c,
                            
                            OFAC_Language_Needed__c,
                            
                            First_Prepaid_Marketing_Fee_Payment__c,
                            Second_Prepaid_Marketing_Fee_Payment__c,
                            Third_Prepaid_Marketing_Fee_Payment__c,
                            
                            Property_Manager__c,
                            One_Time_Charge__c,
                            
                            HSI_Speed_Upgrade_First_Tier_MRC__c,
                            HSI_Speed_Upgrade_Second_Tier_MRC__c,
                            HSI_Speed_Upgrade_Third_Tier_MRC__c,
                            HSI_Speed_Upgrade_First_Tier_Speed__c,
                            HSI_Speed_Upgrade_Second_Tier_Speed__c,
                            HSI_Speed_Upgrade_Third_Tier_Speed__c,
                            
                            Guaranteed_Minimum_HSI_Bulk_Speed__c,
                            DTV_Installation__c,
                            Consumer_Privacy_Required__c,
                            Legacy_Territory__c,
                            Ramp_Period_included_in_Term__c, // QFJC-3945
                            Ramp_Period_Type__c,
                            
                            Gratis_Requested_Approved__c,
                            Gratis_Units_Approved_Data__c,
                            Gratis_Units_Approved_Video__c,
                            
                            Bandwidth__c,
                            Data_Bounty_Amount_Approved__c,
                            Data_Bounty_Type_Approved__c,
                            
                            Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                            Prepaid_Marketing_Fee_Type_Approved__c,
                            Revenue_Base_Approved__c,
                            
                            Voice_Bounty_Amount_Approved__c,
                            Voice_Bounty_Type_Approved__c,
                            
                            Requested_Bulk_Data_Price_Approved__c,
                            Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                            Bulk_Data_Type_Approved__c,
                            
                            Requested_Bulk_Video_Price_Approved__c,
                            Bulk_Video_Type_Approved__c,
                            
                            Requested_Bulk_Voice_Price_Approved__c,
                            Bulk_Voice_Type_Approved__c,
                            Compensation_Needed__c,                                
                            Existing_Agreement_Type__c,                 //QFCJ-2761/QFCJ-2872
                            Existing_Agreement_Effective_Date__c        //QFCJ-2761/QFCJ-2872
                       FROM Offer__c WHERE id =: oppt.Primary_Offer__c WITH SECURITY_ENFORCED LIMIT 1]; 	//Example:  a048F000000nCCdQAM  //  WITH SECURITY_ENFORCED ?
        }

        // ESCJ-2081 - CHECK data for type of Contract processing needed...
        if (port != null)  // check to see if DB query pulled back data...  ESCJ-2081
        {	
            if ((port.Name != null))  // Have a Portfolio contract scenerio.  PF-0000013 
        	{                
	            system.debug ('Have a port.Name  scenario:  ' + port.Name);
    	        agiloftPayload      = buildPortfolioPayload(cntrct, portacct, port, portusr);
                strAgiloftFinalMsg  = buildSendPayload(callingApiName, recordId, agiloftPayload);  
        	}
        }
        else if ((offr.Capital_Design_Required__c == 'No') && (offr.Offer_Status__c == MANAGER_APPROVED_CONST))  // Easy EMA/SMA - Direct Approval.  Build Full Contract WITHOUT Cap Design data... ESCJ-2081                
        {
            system.debug ('Have a Capital_Design_Required__c = No AND Offer_Status__c == Manager Approved  scenario:  Full Contract build WITHOUT Cap Design data... ' + offr.Capital_Design_Required__c + ' AND ' + offr.Offer_Status__c);
            agiloftPayload      = buildFullPayload(oppt, cntrct, acct, offr, usr);     
            strAgiloftFinalMsg  = buildSendPayload(callingApiName, recordId, agiloftPayload);  
        }
        else if (offr.Capital_Design_Required__c == 'Yes')  //  Build Full Contract WITH Cap Design data...
        {
            system.debug ('Have a Capital_Design_Required__c = Yes  scenario:  Full Contract build WITH Cap Design data... ' + offr.Capital_Design_Required__c);
            agiloftPayload      = buildFullPayload(oppt, cntrct, acct, offr, usr);            
            strAgiloftFinalMsg  = buildSendPayload(callingApiName, recordId, agiloftPayload);  
        }
        else if ((offr.Capital_Design_Required__c == 'No') && (offr.Qualifies_for_Direct_Approval__c == 'No'))  // NO Easy EMA/SMA. CUSTOM Contract - ESCJ-2081  NOTE:  Check this last per Ray.  Per Flow data. We can have a NO and NO and Manager Approval data.
        {   
            system.debug ('Have a Capital_Design_Required__c = No AND Qualifies_for_Direct_Approval__c = No  scenario:  ' + offr.Capital_Design_Required__c + ' AND ' + offr.Qualifies_for_Direct_Approval__c);     
            agiloftPayload      = buildCustomPayload(cntrct, acct, offr, oppt, usr);
      		strAgiloftFinalMsg  = buildSendPayload(callingApiName, recordId, agiloftPayload);  
        }  
        else
        {
            system.debug ('NO Contract Built...');  
            return 'Error:  Contract was Not Generated.  No matching criteria for:  1) Portfolio or 2) Easy EMA/SMA (Direct Approval) or 3) NO easy EMA/SMA or 4) Capital Design Required...';
        }        

        return strAgiloftFinalMsg;        
    }
    
     // ESCJ-2081 - Process Portfolio scenario
     public static string validateBaseData(id recordId)
     {
    	if ( (Level3utils.detectEnv().toUpperCase() <> 'PROD') && (string.isBlank(strAgiloftTestOrgActive) || strAgiloftTestOrgActive == 'No' )) 
        {
            return 'Error: This Salesforce instance currently does not support Agiloft testing';        
        } 

        if(String.isBlank(strAgiloftLoginId)||String.isBlank(strAgiloftLoginPassword))
        {
        	return 'Error: No Login Id or Password available, please contact Salesforce Support';
        }

        if (recordId.getSObjectType().getDescribe().getName() != 'Contract') 
        {
            return 'Error: Invalid object type passed in.  Should be Contract Obj, please contact Salesforce Support';
        }
        
        return 'Good To Go...';
     }
        
    public static string buildPortfolioPayload(SObject contract, SObject portaccount, SObject portfolio, SObject portuser) // ESCJ-2081 - Process Portfolio scenario
    {
        string payloadString        = USER_ID_VAR_CONST + UserInfo.getUserId();          
        string finalPayloadString   = '';
        
        // Assign SObjects to use the data coming in.
        Contract cntrct 	= (Contract) 	 contract;
        Account acct 		= (Account) 	 portaccount;
        Portfolio__c port 	= (Portfolio__c) portfolio;        
        User usr            = (User)         portuser;

        payloadString = payloadString + ACCOUNT_ID_VAR_CONST                + cntrct.AccountId;
        payloadString = payloadString + CONTRACT_ID_VAR_CONST               + cntrct.id;
        payloadString = payloadString + CONTRACT_REQUEST_ID_VAR_CONST       + cntrct.ContractNumber;
        payloadString = payloadString + CONTRACT_TEMPLATE_TO_USE_VAR_CONST  + cntrct.Contract_Template_to_Use__c;

        if (String.isNotBlank(port.Name))
        {
            payloadString = payloadString + '&portfolio_name='              + EncodingUtil.urlEncode(port.Name, 'UTF-8'); // 7-7-2023 QFCJ-4105 - Added Encoding fuction to capture  &  properly
        }
        else 
        {
            payloadString = payloadString + '&portfolio_name='              + port.Name;
        }
        
        if (String.isNotBlank(acct.Name))
        {
            payloadString = payloadString + ACCOUNT_NAME_VAR_CONST		    + EncodingUtil.urlEncode(acct.Name, 'UTF-8');     
        }
        else
        {
            payloadString = payloadString + ACCOUNT_NAME_VAR_CONST		    + acct.Name;
        }

        // QFCJ-2780
        payloadString = payloadString + LOBID_CONST                         + acct.LOB__c;    
        payloadString = payloadString + OPPT_OWNER_ID_CONST                 + port.OwnerId; // QFCJ-??? Use Port object info NOT Oppt obj
        payloadString = payloadString + OPPT_OWNER_CUID_CONST               + usr.CUID__c;
        payloadString = payloadString + OPPT_OWNER_NAME_CONST               + usr.Name;
        payloadString = payloadString + OPPT_OWNER_EMAIL_CONST              + usr.Email;
        

        finalPayloadString = payloadString.replaceAll('null', '');  // Cut out all null values;  set variables FROM &abc123=null&def456=null  to be:   &abc123=&def456=

        return finalPayloadString;
    }

    public static string buildCustomPayload(SObject contract, SObject account, SObject offer, SObject opportunity, SObject user)  // ESCJ-2081 - Process Custom scenario
    {   
        string payloadString        = USER_ID_VAR_CONST + UserInfo.getUserId();      
        string finalPayloadString   = '';
                
        // Assign SObjects to use the data coming in.        
        Contract 	cntrct 		= (Contract) contract;
        Account 	acct 		= (Account) account;
        Offer__c 	offr		= (Offer__c) offer;
        Opportunity oppt        = (Opportunity) opportunity;
        User usr                = (User) user;
         
        payloadString = payloadString + ACCOUNT_ID_VAR_CONST                + cntrct.AccountId;
        payloadString = payloadString + CONTRACT_ID_VAR_CONST               + cntrct.id;
        payloadString = payloadString + CONTRACT_REQUEST_ID_VAR_CONST       + cntrct.ContractNumber;
        payloadString = payloadString + CONTRACT_TEMPLATE_TO_USE_VAR_CONST  + cntrct.Contract_Template_to_Use__c;

        if (String.isNotBlank(acct.Name))
        {
            payloadString = payloadString + ACCOUNT_NAME_VAR_CONST		    + EncodingUtil.urlEncode(acct.Name, 'UTF-8');    // QFCJ-4105 Little & Allen Associates        
        }
        else
        {
            payloadString = payloadString + ACCOUNT_NAME_VAR_CONST		    + acct.Name;
        }
        
        if (String.isNotBlank(offr.Name))
        {
            payloadString = payloadString + OFFER_NAME_VAR_CONST            + EncodingUtil.urlEncode(offr.Name, 'UTF-8');    // 7-7-2023 QFCJ-4105  - Added Encoding fuction to capture  &  properly
        }
        else 
        {
            payloadString = payloadString +  OFFER_NAME_VAR_CONST            + offr.Name;   
        }

        // QFCJ-2780
        payloadString = payloadString + LOBID_CONST                         + acct.LOB__c;    
        payloadString = payloadString + OPPT_OWNER_ID_CONST                 + oppt.OwnerId;
        payloadString = payloadString + OPPT_OWNER_CUID_CONST               + usr.CUID__c;
        payloadString = payloadString + OPPT_OWNER_NAME_CONST               + usr.Name;
        payloadString = payloadString + OPPT_OWNER_EMAIL_CONST              + usr.Email;
        
        finalPayloadString = payloadString.replaceAll('null', '');  // Cut out all null values;  set variables FROM &abc123=null&def456=null  to be:   &abc123=&def456=

        return finalPayloadString;
    }
    	
    public static string buildFullPayload(SObject opportunity, SObject contract, SObject account, SObject offer, SObject user)  // ESCJ-2081 - Process Full payload scenario
	{        
    	string finalPayload1 		= '';
        string finalPayload2 		= '';
        string finalPayloadString   = '';        
        
        // Assign SObjects to use the data coming in.        
        Opportunity	oppt	= (Opportunity) opportunity;
        Contract 	cntrct 	= (Contract) 	contract;
        Account 	acct 	= (Account)		account;
        Offer__c	offr	= (Offer__c) 	offer;
        User        usr     = (User)        user;
        
     	system.debug ('We have a Contract Payload...' );     
        
        // Look at Opportunity Contact Role and get the contactID to use to lookup the Primary contact 
        //OpportunityContactRole opptContRole1 = [SELECT id, ContactId, OpportunityId, IsPrimary, Role FROM OpportunityContactRole                                             
        //                                        WHERE ( (OpportunityId =: oppt.id) AND (Role =: 'Authorized Signer') AND (IsPrimary =: true) ) WITH SECURITY_ENFORCED LIMIT 1];  // Example:  0068F000001eIcXQAU 
        
        // QFCJ 3537 - Chgd processing condition on this...
        OpportunityContactRole opptContRole1 = [SELECT id, ContactId, OpportunityId, Role FROM OpportunityContactRole                                             
                                                WHERE ( (OpportunityId =: oppt.id) AND (Role =: 'Primary Signer') ) WITH SECURITY_ENFORCED LIMIT 1];  // Example:  0068F000001eIcXQAU
                                             
        
        system.debug ('opptContRole1:  ' + opptContRole1);
        
        
        // 7-28-2022 - ESCJ-1675 spk - Added code... Not every contract will have a secondary contact.
        //OpportunityContactRole[] opptContRole2 = [SELECT id, ContactId, OpportunityId, IsPrimary,Role FROM OpportunityContactRole 
        //                                         WHERE ( (OpportunityId =: oppt.id) AND (Role =: 'Authorized Signer') AND (IsPrimary =: false) ) WITH SECURITY_ENFORCED LIMIT 1];  // Example:  0068F000001eIcXQAU 
        
        // QFCJ 3537 - Chgd processing condition on this...
        OpportunityContactRole[] opptContRole2 = [SELECT id, ContactId, OpportunityId, Role FROM OpportunityContactRole 
                                                  WHERE ( (OpportunityId =: oppt.id) AND (Role =: 'Secondary Signer') ) WITH SECURITY_ENFORCED LIMIT 1];  // Example:  0068F000001eIcXQAU
        
        system.debug ('opptContRole2:  ' + opptContRole2);


        // QFCJ-3945 - Get Billing fields
        OpportunityContactRole[] opptContRole3 = [SELECT id, ContactId, OpportunityId, Role FROM OpportunityContactRole 
                                                  WHERE ( (OpportunityId =: oppt.id) AND (Role =: 'Billing Contact') ) WITH SECURITY_ENFORCED LIMIT 1];  // Example:  0068F000001eIcXQAU

        system.debug ('opptContRole3:  ' + opptContRole3);
        
        //Use opptContRole1.ContactId to find Primary Contact data.
        Contact cont1 = [SELECT id, Name, Title FROM Contact WHERE  id =: opptContRole1.ContactId  WITH SECURITY_ENFORCED LIMIT 1]; // Example:  0038F000007kx8mQAA
        
        Contact cont2; // 7-28-2022 - ESCJ-1675 spk - Added if.. Not every contract will have a secondary contact.
        
        if ( opptContRole2.size() > 0 ) 
        {
            //Use opptContRole2.ContactId to find Secondary Contact data.
            cont2 = [SELECT id, Name, Title FROM Contact  WHERE id =: opptContRole2[0].ContactId WITH SECURITY_ENFORCED LIMIT 1]; // Example:  0038F000007kx8mQAA
        }   
        
        Contact cont3; // QFCJ-3945 - New billing fields.

        //QFCJ-3945 - New billing fields
        if ( opptContRole3.size() > 0 ) 
        {
            //Use opptContRole2.ContactId to find Secondary Contact data.
            cont3 = [SELECT id, Name, Email, Phone  FROM Contact  WHERE id =: opptContRole3[0].ContactId WITH SECURITY_ENFORCED LIMIT 1]; // Example:  0038F000007kx8mQAA
        }   
                

        Capital_design__c capd;
                
   		if ((offr.Capital_Design_Required__c == 'No') && (offr.Offer_Status__c == MANAGER_APPROVED_CONST))  // ESCJ-2081 - Check for Easy EMA/SMA - No Capital Design data needed.  Direct Approval.
        {
            system.debug ('We have a Capital_Design_Required__c = No  AND  offr.Offer_Status__c = Manager Approved  Scenario:  ' + offr.Capital_Design_Required__c + ' ' + offr.Offer_Status__c);
            system.debug ('Do Not Process Cap Design object Data... ');                 
        }
        else  // Process Cap Design info like previously.
        { 
            system.debug ('Full Contract Data needed.. Process Cap Design object Data... ');     
            
            string capDesignKey;
            
            if (offr.Refresh_Capital_Design__c != null) 
            {
                capDesignKey = offr.Refresh_Capital_Design__c;
            } 
            else 
            {
                capDesignKey = offr.Associated_Capital_Design__c;            
            }
            
            system.debug ('offr.Refresh_Capital_Design__c is:     ' + offr.Refresh_Capital_Design__c); 
            system.debug ('offr.Associated_Capital_Design__c is:  ' + offr.Associated_Capital_Design__c); 
            system.debug ('capDeisgnKey is:  ' + capDesignKey); 
            
            // Use offr.Associated_Capital_Design__c to find Cap Design data
            capd = [SELECT id,
                    offer__c,
                    Design_id__c,
                    Technology_Type__c,
                    Responsible_for_Cable_Home_Wiring__c,
                    Responsible_for_Home_Run_Wiring__c,
                    Telecommunication_Cable_Types__c,
                    Telecom_Cable_Quantity_Per_Living_Unit__c,
                    Endpoint_Type_building_architecture__c,
                    Technology_Diagram__c,
                    //Communications_Wiring_Qty_per_WAP__c,
                    Comm_Wiring_Qty_Per_WAP__c,
                    Communications_Wiring_Type__c, 
                    Backboards_required__c,                 // ESCJ-2270
                    Exterior_Cabinets__c,                   // ESCJ-2270
                    NEMA_Rated_Cabinet__c,                  // ESCJ-2270
                    Number_of_Owner_Installed_Conduits__c,  // ESCJ-2270
                    Responsible_for_Media_Panel__c,         // ESCJ-2270
                    SE_SOW_Additional_Company_Tasks_1__c,   // ESCJ-2270
                    SE_SOW_Additional_Company_Tasks_2__c,   // ESCJ-2270
                    SE_SOW_Additional_Owner_Tasks_1__c,     // ESCJ-2507
                    SE_SOW_Additional_Owner_Tasks_2__c,     // ESCJ-2507                    
                    SE_SOW_Project_Scope__c,                // ESCJ-2270
                    Size_of_Owner_Installed_Conduits__c,    // ESCJ-2270
                    Responsible_for_In_unit_WAP_Wiring__c,  // ESCJ-2420
                    Entity_Type__c                          //QFCJ-2611/QFCJ-2872
                    FROM Capital_Design__c WHERE id =: capDesignKey WITH SECURITY_ENFORCED LIMIT 1];	// Example:  a018F0000012PsZQAU            
        }                                                                                           
                
        // Use oppt.Property__c to find Property Data 
        // QFCJ-4114 - Pick off new field property_use__c
        Property__c prop = [SELECT  id, Name, Property_Account__c, Primary_Address_State__c, Property_Structure__c, Property_Type__c, Primary_Address_Street__c, Primary_Address_City__c, Primary_Address_Zip__c, property_contract_status__c, property_use__c
                            FROM Property__c WHERE id =: oppt.Property__c WITH SECURITY_ENFORCED LIMIT 1]; //Example:  a0A8F00000094c1UAA
                
        // Use  oppt.id to find Segment Data 
        Segment__c seg = [SELECT id, Opportunity__c, Segment_Use__c FROM Segment__c WHERE Opportunity__c =: oppt.id WITH SECURITY_ENFORCED LIMIT 1];   //Example:  0068F000001eIcXQAU
                
        finalPayload1 = buildContractPayloadPart1(cntrct, acct, capd, offr, oppt, usr);

        finalPayload2 = buildContractPayloadPart2(cont1, cont2, cont3, offr, prop, seg);
        
        finalPayload1 = finalPayload1.replaceAll('null', '');  // Cut out all null values;  set variables FROM &abc123=null&def456=null  to be:   &abc123=&def456=
        finalPayload2 = finalPayload2.replaceAll('null', '');  // Cut out all null values;  set variables FROM &abc123=null&def456=null  to be:   &abc123=&def456=

        finalPayloadString = finalPayload1 + finalPayload2;
        
        return finalPayloadString;
	}
        

    public static string buildContractPayloadPart1(SObject contract, SObject account, SObject capdesgn, SObject offer, SObject opportunity, SObject user) 
    {   
    	string payloadString        = USER_ID_VAR_CONST + UserInfo.getUserId();
        string temp                 = '';             
        string temp2                = '';        
        
        // Assign SObjects to use the data coming in.
        Contract cntrct 		= (Contract) contract;
        Account acct 			= (Account) account;
        Capital_design__c capd 	= (Capital_design__c) capdesgn;
        Offer__c	offr		= (Offer__c) offer;
        Opportunity oppt        = (Opportunity) opportunity;
        User usr                = (User) user;

        // QFCJ-2780
        payloadString = payloadString + LOBID_CONST             + acct.LOB__c;    
        payloadString = payloadString + OPPT_OWNER_ID_CONST     + oppt.OwnerId;
        payloadString = payloadString + OPPT_OWNER_CUID_CONST   + usr.CUID__c;
        payloadString = payloadString + OPPT_OWNER_NAME_CONST   + usr.Name;
        payloadString = payloadString + OPPT_OWNER_EMAIL_CONST  + usr.Email;


        temp = string.valueof(cntrct.Contract_Executed_Date__c);
        
        if (temp !=null) 
        {
            temp2 = temp.left(10);
            payloadString = payloadString + '&contract_executed_date=' 				+ temp2;
        } 
        else 
        {
            payloadString = payloadString + '&contract_executed_date=' 			    + cntrct.Contract_Executed_Date__c;
        }

        payloadString = payloadString + '&telephone_for_notices=' 					+ cntrct.Telephone_for_Notices__c;
        payloadString = payloadString + '&email_address_for_notices='				+ cntrct.Email_Address_for_Notices__c;
        payloadString = payloadString + '&person_designated_for_notices=' 			+ cntrct.Person_Designated_for_Notices__c;
         
        temp = String.isNotBlank(cntrct.Address_for_Notices__c) ? EncodingUtil.urlEncode(cntrct.Address_for_Notices__c, 'UTF-8') : cntrct.Address_for_Notices__c; // QFCJ-4105
        payloadString = payloadString + '&address_for_notices=' 					+ temp;
        
        temp = String.isNotBlank(cntrct.City_for_Notices__c) ? EncodingUtil.urlEncode(cntrct.City_for_Notices__c, 'UTF-8') : cntrct.City_for_Notices__c; // QFCJ-4105
        payloadString = payloadString + '&city_for_notices=' 					    + temp;
        
        temp = String.isNotBlank(cntrct.State_for_Notices__c) ? EncodingUtil.urlEncode(cntrct.State_for_Notices__c, 'UTF-8') : cntrct.State_for_Notices__c; // QFCJ-4105
        payloadString = payloadString + '&state_for_notices=' 					    + temp;
                
        payloadString = payloadString + '&zipcode_for_notices=' 					+ cntrct.ZipCode_for_Notices__c;
        payloadString = payloadString + CONTRACT_REQUEST_ID_VAR_CONST 			    + cntrct.ContractNumber;
        payloadString = payloadString + '&contract_lifecycle_status=' 				+ cntrct.Contract_Lifecycle_Status__c;
        payloadString = payloadString + '&copy_to_email=' 							+ cntrct.Copy_to_Email__c;
        
        temp = String.isNotBlank(cntrct.Copy_to_Name__c) ? EncodingUtil.urlEncode(cntrct.Copy_to_Name__c, 'UTF-8') : cntrct.Copy_to_Name__c; // QFCJ-4105
        payloadString = payloadString + '&copy_to_name=' 						    + temp;
        
        payloadString = payloadString + CONTRACT_TEMPLATE_TO_USE_VAR_CONST		    + cntrct.Contract_Template_to_Use__c;
        payloadString = payloadString + CONTRACT_ID_VAR_CONST                       + cntrct.id;
                  
        // spk 3-8-2022 Modify the SFCJ boolean values: "true or false" to "True or False" in Agiloft so it will match the boolean in the CJ_Staging table.
        payloadString = payloadString + '&address_form_bulk_order_form_received=' 	+ (string.ValueOf(cntrct.Address_Form_Bulk_Order_Form_Received__c)).capitalize();
        payloadString = payloadString + '&w9_processed=' 							+ (string.ValueOf(cntrct.W9_Processed__c)).capitalize();
        payloadString = payloadString + '&deposit_forms_accepted=' 					+ (string.ValueOf(cntrct.Deposit_Forms_Accepted__c)).capitalize();
        payloadString = payloadString + '&gratis_form_processed=' 					+ (string.ValueOf(cntrct.Gratis_Form_Processed__c)).capitalize();
        payloadString = payloadString + '&ssa_job_complete=' 						+ (string.ValueOf(cntrct.SSA_Job_Complete__c)).capitalize();
        
        payloadString = payloadString + ACCOUNT_ID_VAR_CONST					 	+ acct.id;

        temp = String.isNotBlank(acct.Name) ? EncodingUtil.urlEncode(acct.Name, 'UTF-8') : acct.Name;  // QFCJ-4105
        payloadString = payloadString + ACCOUNT_NAME_VAR_CONST			 	 	    + temp;
        
        payloadString = payloadString + '&hoa_or_coa=' 								+ acct.HOA_COA__c;

        temp = String.isNotBlank(acct.BillingStreet) ? EncodingUtil.urlEncode(acct.BillingStreet, 'UTF-8') : acct.BillingStreet; // QFCJ-4105
        payloadString = payloadString + '&account_billing_address='		            + temp;
        

        temp = String.isNotBlank(acct.BillingCity) ? EncodingUtil.urlEncode(acct.BillingCity, 'UTF-8') : acct.BillingCity; // QFCJ-4105
        payloadString = payloadString + '&account_billing_address_city=' 		    + temp;
        
        temp = String.isNotBlank(acct.BillingState) ? EncodingUtil.urlEncode(acct.BillingState, 'UTF-8') : acct.BillingState; // QFCJ-4105
        payloadString = payloadString + '&account_billing_address_state=' 		    + temp;

        payloadString = payloadString + '&account_billing_address_zip_code='		+ acct.BillingPostalCode;
                

        if ((offr.Capital_Design_Required__c == 'No')  &&  (offr.Offer_Status__c == MANAGER_APPROVED_CONST))  // Easy EMA/SMA - No Capital Design data needed. ESCJ-2081
        {
      		system.debug ('Have a Capital_Design_Required__c = No  AND  Offer_Status__c == Manager Approved  scenario:  ' + offr.Capital_Design_Required__c + ' AND ' + offr.Offer_Status__c);     
            system.debug ('Do Not Process Cap Design object Payload Data... ');     // Bypass Cap Design object data -  Not needed for Direct Approval
        }
        else
        {
            system.debug ('In Build Payload Logic... BUILD Cap Design object Payload Data... ');     
     
            payloadString = payloadString + '&technology_type=' 						+ capd.Technology_Type__c;
            payloadString = payloadString + '&responsible_for_cable_home_wiring=' 		+ capd.Responsible_for_Cable_Home_Wiring__c;
            payloadString = payloadString + '&responsible_for_home_run_wiring=' 		+ capd.Responsible_for_Home_Run_Wiring__c;
            payloadString = payloadString + '&telecommunication_cable_types=' 			+ capd.Telecommunication_Cable_Types__c;
            payloadString = payloadString + '&telecom_cable_quantity_per_living_unit=' 	+ capd.Telecom_Cable_Quantity_Per_Living_Unit__c;
            payloadString = payloadString + '&endpoint_type=' 							+ capd.Endpoint_Type_building_architecture__c;
            payloadString = payloadString + '&technology_diagram=' 						+ capd.Technology_Diagram__c;
            payloadString = payloadString + '&communications_wiring_type=' 				+ capd.Communications_Wiring_Type__c;
            payloadString = payloadString + '&communications_wiring_qty_per_wap=' 		+ capd.Comm_Wiring_Qty_Per_WAP__c;

            payloadString = payloadString + '&backboards_required='              		+ capd.Backboards_required__c;                 // ESCJ-2270
            payloadString = payloadString + '&exterior_cabinets=' 		                + capd.Exterior_Cabinets__c;                   // ESCJ-2270
            payloadString = payloadString + '&nema_rated_cabinet=' 		                + capd.NEMA_Rated_Cabinet__c;                  // ESCJ-2270
            payloadString = payloadString + '&number_of_owner_installed_conduits=' 		+ capd.Number_of_Owner_Installed_Conduits__c;  // ESCJ-2270
            payloadString = payloadString + '&responsible_for_media_panel=' 		    + capd.Responsible_for_Media_Panel__c;         // ESCJ-2270
            payloadString = payloadString + '&se_sow_additional_company_tasks_1=' 		+ capd.SE_SOW_Additional_Company_Tasks_1__c;   // ESCJ-2270
            payloadString = payloadString + '&se_sow_additional_company_tasks_2=' 		+ capd.SE_SOW_Additional_Company_Tasks_2__c;   // ESCJ-2270
            payloadString = payloadString + '&se_sow_additional_owner_tasks_1=' 		+ capd.SE_SOW_Additional_Owner_Tasks_1__c;     // ESCJ-2507
            payloadString = payloadString + '&se_sow_additional_owner_tasks_2=' 		+ capd.SE_SOW_Additional_Owner_Tasks_2__c;     // ESCJ-2507
            temp = String.isNotBlank(capd.SE_SOW_Project_Scope__c) ? EncodingUtil.urlEncode(capd.SE_SOW_Project_Scope__c, 'UTF-8') : capd.SE_SOW_Project_Scope__c;  // ESCJ-2270 // QFCJ-4400
            payloadString = payloadString + '&se_sow_project_scope=' 		            + temp;                                        // ESCJ-2270 / QFCJ-4400
            payloadString = payloadString + '&size_of_owner_installed_conduits=' 		+ capd.Size_of_Owner_Installed_Conduits__c;    // ESCJ-2270
            payloadString = payloadString + '&responsible_for_in_unit_wap_wiring=' 		+ capd.Responsible_for_In_unit_WAP_Wiring__c;  // ESCJ-2420
            payloadString = payloadString + '&entity_type='                     		+ capd.Entity_Type__c;                         // QFCJ-2611/QFCJ-2872
        }
        
        return payloadString;
    }

    
    public static string buildContractPayloadPart2(SObject contact1, SObject contact2, SObject contact3, SObject offer, SObject property, SObject segmnt) 
    {   
        string payloadString		= '';  
        string finalPayloadString   = '';
    	string temp                 = '';             
        string temp2                = '';        
        
        // Assign SObjects to use the data coming in.
        Contact cont1 			= (Contact) contact1;
        Contact cont2 			= (Contact) contact2;
        Contact cont3 			= (Contact) contact3;        
        Offer__c offr			= (Offer__c) offer;
        Property__c prop		= (Property__c) property;
        Segment__c seg			= (Segment__c) segmnt;

        temp = String.isNotBlank(cont1.Name) ? EncodingUtil.urlEncode(cont1.Name, 'UTF-8') : cont1.Name; // QFCJ-4105
        payloadString = payloadString + '&name_of_signer=' 						    + temp;
                
        temp = String.isNotBlank(cont1.Title) ? EncodingUtil.urlEncode(cont1.Title, 'UTF-8') : cont1.Title; // QFCJ-4105
        payloadString = payloadString + '&title_of_signer=' 					    + temp;
        
        // 7-28-2022 - ESCJ-1675 spk Added if.. Not every contract will have a secondary contact.
        if ( cont2 != null)
        {               
            temp = String.isNotBlank(cont2.Name) ? EncodingUtil.urlEncode(cont2.Name, 'UTF-8') : cont2.Name; // QFCJ-4105
            payloadString = payloadString + '&name_of_2nd_signer=' 				    + temp;
                
            temp = String.isNotBlank(cont2.Title) ? EncodingUtil.urlEncode(cont2.Title, 'UTF-8') : cont2.Title; // QFCJ-4105
            payloadString = payloadString + '&title_of_2nd_signer=' 			    + temp;            
        }

        //QFCJ-3945 - Billing data 
        if ( cont3 != null)
        {               
            temp = String.isNotBlank(cont3.Name) ? EncodingUtil.urlEncode(cont3.Name, 'UTF-8') : cont3.Name;
            payloadString = payloadString + '&billing_contact_name='			    + temp;
                
            temp = String.isNotBlank(cont3.Email) ? EncodingUtil.urlEncode(cont3.Email, 'UTF-8') : cont3.Email;
            payloadString = payloadString + '&billing_contact_email=' 			    + temp;            

            temp = String.isNotBlank(cont3.Phone) ? EncodingUtil.urlEncode(cont3.Phone, 'UTF-8') : cont3.Phone;
            payloadString = payloadString + '&billing_contact_phone=' 			    + temp;            
        }
                
        payloadString = payloadString + '&service_delivery=' 						+ offr.Service_Delivery__c;
                
        temp = string.valueof(offr.Offer_Expiration_Date__c);
        
        if (temp !=null)
        {
            System.Debug ('Offer Expiration Date0:  '+ offr.Offer_Expiration_Date__c);
            System.Debug ('Offer Expiration Date1:  '+ temp);
            temp2 = temp.left(10);
            payloadString = payloadString + '&offer_expiration_date=' 				+ temp2;
            System.Debug ('Offer Expiration Date2:  '+ temp2);                
        }
        else 
        {
            payloadString = payloadString + '&offer_expiration_date=' 				+ offr.Offer_Expiration_Date__c;
        }
                    
        payloadString = payloadString + '&contract_term_months=' 					+ offr.Contract_Term__c;
                            
        temp = string.valueof(offr.First_Occupancy_Date__c);
        
        if (temp !=null)
        {                
            temp2 = temp.left(10);
            payloadString = payloadString + '&first_occupancy_date=' 				+ temp2;            
        }
        else
        {
            payloadString = payloadString + '&first_occupancy_date=' 				+ offr.First_Occupancy_Date__c;                    
        }
        
        payloadString = payloadString + '&billing_ramp_period_months=' 				+ offr.Billing_Ramp_Period__c;
        payloadString = payloadString + '&owner_contribution_payment=' 				+ offr.Owner_Contribution_Payment__c;
        payloadString = payloadString + '&owner_contribution_days_payment_due=' 	+ offr.Owner_Contribution_Days_Payment_Due__c;
        payloadString = payloadString + '&offer_total_units=' 						+ offr.Offer_Total_Units__c;  // Formula(Number) in SFCJ
        payloadString = payloadString + '&offer_type=' 								+ offr.Offer_Type__c;
        payloadString = payloadString +  OFFER_NAME_VAR_CONST   					+ offr.Name;
        payloadString = payloadString + '&development_status=' 						+ offr.Development_Status__c;
        payloadString = payloadString + '&absorption_table_needed='					+ offr.Absorption_Table_Needed__c;
        payloadString = payloadString + '&revenue_share_type=' 						+ offr.Revenue_Share_Type_Approved__c;
                                
        payloadString = payloadString + '&wired_business_replacemnt_guest_services=' + (string.ValueOf(offr.Wired_Business_Replacemnt_Guest_Services__c)).capitalize();

        payloadString = payloadString + '&property_management_guest_services='		+ (string.ValueOf(offr.Property_Management_Guest_Services__c)).capitalize();
                
        payloadString = payloadString + '&tier_1_percentage=' 						+ offr.Tier_1_Approved__c;
        payloadString = payloadString + '&tier_2_percentage=' 						+ offr.Tier_2_Approved__c;
        payloadString = payloadString + '&tier_3_percentage=' 						+ offr.Tier_3_Approved__c;
        payloadString = payloadString + '&tier_4_percentage=' 						+ offr.Tier_4_Approved__c;
        payloadString = payloadString + '&tier_5_percentage=' 						+ offr.Tier_5_Approved__c;
        payloadString = payloadString + '&tier_6_percentage=' 						+ offr.Tier_6_Approved__c;
        
        payloadString = payloadString + '&tier_value_1='		 					+ offr.Tier_Value_1_Approved__c;
        payloadString = payloadString + '&tier_value_2=' 							+ offr.Tier_Value_2_Approved__c;
        payloadString = payloadString + '&tier_value_3=' 							+ offr.Tier_Value_3_Approved__c;
        payloadString = payloadString + '&tier_value_4=' 							+ offr.Tier_Value_4_Approved__c;
        payloadString = payloadString + '&tier_value_5=' 							+ offr.Tier_Value_5_Approved__c;
        payloadString = payloadString + '&tier_value_6=' 							+ offr.Tier_Value_6_Approved__c;
            
        payloadString = payloadString + '&flat_revenue_share_percentage=' 			+ offr.Flat_Revenue_Share_Approved__c;
        
        payloadString = payloadString + '&cumulative_units_built_year_1=' 			+ offr.Units_Built_Year_1__c;
        payloadString = payloadString + '&cumulative_units_built_year_2=' 			+ offr.Units_Built_Year_2__c;
        payloadString = payloadString + '&cumulative_units_built_year_3=' 			+ offr.Units_Built_Year_3__c;
        payloadString = payloadString + '&cumulative_units_built_year_4=' 			+ offr.Units_Built_Year_4__c;
        payloadString = payloadString + '&cumulative_units_built_year_5=' 			+ offr.Units_Built_Year_5__c;
        payloadString = payloadString + '&cumulative_units_built_year_6=' 			+ offr.Units_Built_Year_6__c;
        payloadString = payloadString + '&cumulative_units_built_year_7=' 			+ offr.Units_Built_Year_7__c;
        payloadString = payloadString + '&cumulative_units_built_year_8=' 			+ offr.Units_Built_Year_8__c;
        payloadString = payloadString + '&cumulative_units_built_year_9=' 			+ offr.Units_Built_Year_9__c;
        payloadString = payloadString + '&cumulative_units_built_year_10=' 			+ offr.Units_Built_Year_10__c;
                    
        payloadString = payloadString + '&cumulative_living_units_built_year_1=' 	+ offr.Cumulative_Living_Units_Built_Year_1__c;
        payloadString = payloadString + '&cumulative_living_units_built_year_2=' 	+ offr.Cumulative_Living_Units_Built_Year_2__c;
        payloadString = payloadString + '&cumulative_living_units_built_year_3=' 	+ offr.Cumulative_Living_Units_Built_Year_3__c;
        payloadString = payloadString + '&cumulative_living_units_built_year_4=' 	+ offr.Cumulative_Living_Units_Built_Year_4__c;
        payloadString = payloadString + '&cumulative_living_units_built_year_5=' 	+ offr.Cumulative_Living_Units_Built_Year_5__c;
        payloadString = payloadString + '&cumulative_living_units_built_year_6=' 	+ offr.Cumulative_Living_Units_Built_Year_6__c;
        payloadString = payloadString + '&cumulative_living_units_built_year_7=' 	+ offr.Cumulative_Living_Units_Built_Year_7__c;
        payloadString = payloadString + '&cumulative_living_units_built_year_8=' 	+ offr.Cumulative_Living_Units_Built_Year_8__c;
        payloadString = payloadString + '&cumulative_living_units_built_year_9=' 	+ offr.Cumulative_Living_Units_Built_Year_9__c;
        payloadString = payloadString + '&cumulative_living_units_built_year_10='	+ offr.Cumulative_Living_Units_Built_Year_10__c;            
        
        payloadString = payloadString + '&months_0_to_12_year_1=' 					+ offr.Months_0_12_Year_1__c;
        payloadString = payloadString + '&months_13_to_24_year_2='	 				+ offr.Months_13_24_Year_2__c;
        payloadString = payloadString + '&months_25_to_36_year_3='	 				+ offr.Months_25_36_Year_3__c;
        payloadString = payloadString + '&months_37_to_48_year_4=' 					+ offr.Months_37_48_Year_4__c;
        payloadString = payloadString + '&months_49_to_60_year_5=' 					+ offr.Months_49_60_Year_5__c;
        payloadString = payloadString + '&months_61_to_72_year_6=' 					+ offr.Months_61_72_Year_6__c;
        payloadString = payloadString + '&months_73_to_84_year_7=' 					+ offr.Months_73_84_Year_7__c;
        payloadString = payloadString + '&months_85_to_96_year_8=' 					+ offr.Months_85_96_Year_8__c;
        payloadString = payloadString + '&months_97_to_108_year_9='	 				+ offr.Months_97_108_Year_9__c;
        payloadString = payloadString + '&months_109_to_120_year_10=' 				+ offr.Months_109_120_Year_10__c;
       
        // Changes for QFCJ-4829
        payloadString = payloadString + '&months_0_to_12_year_1_str=' 				+ formatTerminationFeeScheduleValues(offr.Months_0_12_Year_1__c);
        payloadString = payloadString + '&months_13_to_24_year_2_str='	 			+ formatTerminationFeeScheduleValues(offr.Months_13_24_Year_2__c);
        payloadString = payloadString + '&months_25_to_36_year_3_str='	 			+ formatTerminationFeeScheduleValues(offr.Months_25_36_Year_3__c);
        payloadString = payloadString + '&months_37_to_48_year_4_str=' 				+ formatTerminationFeeScheduleValues(offr.Months_37_48_Year_4__c);
        payloadString = payloadString + '&months_49_to_60_year_5_str=' 				+ formatTerminationFeeScheduleValues(offr.Months_49_60_Year_5__c);
        payloadString = payloadString + '&months_61_to_72_year_6_str=' 				+ formatTerminationFeeScheduleValues(offr.Months_61_72_Year_6__c);
        payloadString = payloadString + '&months_73_to_84_year_7_str=' 				+ formatTerminationFeeScheduleValues(offr.Months_73_84_Year_7__c);
        payloadString = payloadString + '&months_85_to_96_year_8_str=' 				+ formatTerminationFeeScheduleValues(offr.Months_85_96_Year_8__c);
        payloadString = payloadString + '&months_97_to_108_year_9_str='	 			+ formatTerminationFeeScheduleValues(offr.Months_97_108_Year_9__c);
        payloadString = payloadString + '&months_109_to_120_year_10_str=' 			+ formatTerminationFeeScheduleValues(offr.Months_109_120_Year_10__c);
        // End changes for QFCJ-4829
        
        payloadString = payloadString + '&etl_position_requested=' 					+ offr.ETL_Position_Requested__c;
        payloadString = payloadString + '&etl_months_0_to_12_year_1=' 				+ offr.ETL_Months_0_12_Year_1__c;
        payloadString = payloadString + '&etl_months_13_to_24_year_2=' 				+ offr.ETL_Months_13_24_Year_2__c;
        payloadString = payloadString + '&etl_months_25_to_36_year_3=' 				+ offr.ETL_Months_25_36_Year_3__c;
        payloadString = payloadString + '&etl_months_37_to_48_year_4=' 				+ offr.ETL_Months_37_48_Year_4__c;
        payloadString = payloadString + '&etl_months_49_to_60_year_5=' 				+ offr.ETL_Months_49_60_Year_5__c;
        payloadString = payloadString + '&etl_months_61_to_72_year_6=' 				+ offr.ETL_Months_61_72_Year_6__c;
        payloadString = payloadString + '&etl_months_73_to_84_year_7=' 				+ offr.ETL_Months_73_84_Year_7__c;
        payloadString = payloadString + '&etl_months_85_to_96_year_8=' 				+ offr.ETL_Months_85_96_Year_8__c;
        payloadString = payloadString + '&etl_months_97_to_108_year_9='		 		+ offr.ETL_Months_97_108_Year_9__c;
        payloadString = payloadString + '&etl_months_109_to_120_year_10='			+ offr.ETL_Months_109_120_Year_10__c;
        
        payloadString = payloadString + '&ofac_language_needed='					+ offr.OFAC_Language_Needed__c;
        payloadString = payloadString + '&first_prepaid_marketing_fee_payment='		+ offr.First_Prepaid_Marketing_Fee_Payment__c;
        payloadString = payloadString + '&second_prepaid_marketing_fee_payment=' 	+ offr.Second_Prepaid_Marketing_Fee_Payment__c;
        payloadString = payloadString + '&third_prepaid_marketing_fee_payment=' 	+ offr.Third_Prepaid_Marketing_Fee_Payment__c;
        payloadString = payloadString + '&property_manager=' 						+ offr.Property_Manager__c;
        payloadString = payloadString + '&one_time_charge=' 						+ offr.One_Time_Charge__c;
        
        payloadString = payloadString + '&hsi_speed_upgrade_first_tier_mrc='	 	+ offr.HSI_Speed_Upgrade_First_Tier_MRC__c;
        payloadString = payloadString + '&hsi_speed_upgrade_second_tier_mrc=' 		+ offr.HSI_Speed_Upgrade_Second_Tier_MRC__c;
        payloadString = payloadString + '&hsi_speed_upgrade_third_tier_mrc=' 		+ offr.HSI_Speed_Upgrade_Third_Tier_MRC__c;
        payloadString = payloadString + '&hsi_speed_upgrade_first_tier_speed=' 		+ offr.HSI_Speed_Upgrade_First_Tier_Speed__c;
        payloadString = payloadString + '&hsi_speed_upgrade_second_tier_speed=' 	+ offr.HSI_Speed_Upgrade_Second_Tier_Speed__c;
        payloadString = payloadString + '&hsi_speed_upgrade_third_tier_speed=' 		+ offr.HSI_Speed_Upgrade_Third_Tier_Speed__c;           	 
        payloadString = payloadString + '&guaranteed_minimum_hsi_bulk_speed=' 		+ offr.Guaranteed_Minimum_HSI_Bulk_Speed__c;
                    
        payloadString = payloadString + '&dtv_installation=' 						+ offr.DTV_Installation__c;
        payloadString = payloadString + '&consumer_privacy_required=' 				+ offr.Consumer_Privacy_Required__c;
        payloadString = payloadString + '&legacy_territory=' 						+ offr.Legacy_Territory__c;    
        payloadString = payloadString + '&ramp_period_included_in_term=' 			+ offr.Ramp_Period_included_in_Term__c;      // QFCJ-3945
        payloadString = payloadString + '&ramp_period_type=' 						+ offr.Ramp_Period_Type__c;
        payloadString = payloadString + '&gratis_units_video=' 						+ offr.Gratis_Units_Approved_Video__c;            
        payloadString = payloadString + '&gratis_yes_or_no=' 						+ offr.Gratis_Requested_Approved__c;
        payloadString = payloadString + '&gratis_units_data=' 						+ offr.Gratis_Units_Approved_Data__c;
        
        //QFCJ-4770 - add two new fields - gratis_units_video_str & gratis_units_data_str
        if (offr.Gratis_Units_Approved_Video__c != NULL)     // Number(18, 0)
        {
            payloadString = payloadString + '&gratis_units_video_str=' 				+ StringUtils.convertIntToWords(offr.Gratis_Units_Approved_Video__c.intValue());    
        }

        if (offr.Gratis_Units_Approved_Data__c != NULL)      // Number(18, 0) 
        {
            payloadString = payloadString + '&gratis_units_data_str=' 				+ StringUtils.convertIntToWords(offr.Gratis_Units_Approved_Data__c.intValue()); 
        }
        
        payloadString = payloadString + '&bandwidth=' 								+ offr.Bandwidth__c;
        payloadString = payloadString + '&bulk_data_price=' 						+ offr.Requested_Bulk_Data_Price_Approved__c;
        payloadString = payloadString + '&data_bounty_amount=' 						+ offr.Data_Bounty_Amount_Approved__c;
        payloadString = payloadString + '&data_bounty_type=' 						+ offr.Data_Bounty_Type_Approved__c;


        //QFCJ-3979 - If null, set to 0 before used in functions below.
        if (offr.Prepaid_Marketing_Fee_Per_Unit_Approve__c == NULL)     // currency(16, 2)
        {
            offr.Prepaid_Marketing_Fee_Per_Unit_Approve__c = 0;
        }

        payloadString = payloadString + '&prepaid_marketing_fee=' 					+ offr.Prepaid_Marketing_Fee_Per_Unit_Approve__c;
        payloadString = payloadString + '&prepaid_marketing_fee_type=' 				+ offr.Prepaid_Marketing_Fee_Type_Approved__c;
        
        //QFCJ-3925 - Chgs for Contract Gen - Numbers to CamelCase Words.
        payloadString = payloadString + '&prepaid_marketing_fee_str=' 				+ StringUtils.convertIntToWords(offr.Prepaid_Marketing_Fee_Per_Unit_Approve__c.intValue());
        payloadString = payloadString + '&prepaid_marketing_fee_ttl='               + (offr.Prepaid_Marketing_Fee_Per_Unit_Approve__c * offr.Offer_Total_Units__c);
        payloadString = payloadString + '&prepaid_marketing_fee_ttl_str=' 		    + StringUtils.convertIntToWords((offr.Prepaid_Marketing_Fee_Per_Unit_Approve__c * offr.Offer_Total_Units__c).intValue());

        payloadString = payloadString + '&revenue_base=' 							+ offr.Revenue_Base_Approved__c;
        payloadString = payloadString + '&voice_bounty_amount=' 					+ offr.Voice_Bounty_Amount_Approved__c;
        payloadString = payloadString + '&voice_bounty_type=' 						+ offr.Voice_Bounty_Type_Approved__c;            
                
        payloadString = payloadString + '&bulk_data_speed_profile_dl_ul=' 			+ offr.Bulk_Data_Speed_Profile_DL_UL_Approv__c;
        payloadString = payloadString + '&bulk_data_price=' 						+ offr.Requested_Bulk_Data_Price_Approved__c;
        payloadString = payloadString + '&bulk_data_type='		 					+ offr.Bulk_Data_Type_Approved__c;
        payloadString = payloadString + '&bulk_video_price=' 						+ offr.Requested_Bulk_Video_Price_Approved__c;
        payloadString = payloadString + '&bulk_video_type=' 						+ offr.Bulk_Video_Type_Approved__c;
        payloadString = payloadString + '&bulk_voice_price=' 						+ offr.Requested_Bulk_Voice_Price_Approved__c;
        payloadString = payloadString + '&bulk_voice_type=' 						+ offr.Bulk_Voice_Type_Approved__c;
        payloadString = payloadString + '&existing_agreement_type=' 				+ offr.Existing_Agreement_Type__c;                  //QFCJ-2761/QFCJ-2872
        payloadString = payloadString + '&existing_agreement_effective_date=' 		+ offr.Existing_Agreement_Effective_Date__c;        //QFCJ-2761/QFCJ-2872
                    
        payloadString = payloadString + '&compensation_needed=' 					+ (string.ValueOf(offr.Compensation_Needed__c)).capitalize();
                       
        temp = NULL;

        // QFCJ-3925 - CamelCase Name using StringUtils()  Example:  Acreage & Unrec
        if (String.isNotBlank(prop.Name))
        {
            temp = StringUtils.toProperCase(prop.Name);
            temp = EncodingUtil.urlEncode(temp,'UTF-8');  //QFCJ-4105
        }
        payloadString = payloadString + '&property=' 						        + temp;
        
        payloadString = payloadString + '&property_structure=' 						+ prop.Property_Structure__c;
        payloadString = payloadString + '&property_type='			 				+ prop.Property_Type__c;
        payloadString = payloadString + '&property_use='			 				+ prop.Property_Use__c;  // QFCJ-4114 


        temp = NULL;

        // QFCJ-3925 - CamelCase Street & City using StringUtils()
        if (String.isNotBlank(prop.Primary_Address_Street__c))
        {
            temp = StringUtils.toProperCase(prop.Primary_Address_Street__c);
            temp = EncodingUtil.urlEncode(temp,'UTF-8');  //QFCJ-4105
        }
        payloadString = payloadString + '&primary_address_street=' 			        + temp;
        

        temp = NULL;

        // QFCJ-3925 - CamelCase Street & City using StringUtils()
        if (String.isNotBlank(prop.Primary_Address_City__c))
        {
            temp = StringUtils.toProperCase(prop.Primary_Address_City__c);
            temp = EncodingUtil.urlEncode(temp,'UTF-8');  //QFCJ-4105
        }
        payloadString = payloadString + '&primary_address_city=' 				    + temp;
        
        payloadString = payloadString + '&primary_address_state=' 					+ prop.Primary_Address_State__c;
        payloadString = payloadString + '&primary_address_zip=' 					+ prop.Primary_Address_Zip__c;
        payloadString = payloadString + '&property_contract_status=' 				+ prop.property_contract_status__c;             // QFCJ-2761/QFCJ-2872
                
        payloadString = payloadString + '&segment_use=' 							+ seg.Segment_Use__c;
        
        finalPayloadString = payloadString.replaceAll('null', '');  // Cut out all null values;  set variables FROM &abc123=null&def456=null  to be:   &abc123=&def456=

        return finalPayloadString;
    }


    public static string  buildSendPayload(string callingApiName, id recordId, string agiloftPayload)
    {   
        WebServiceUtilsAgiloft utils = new WebServiceUtilsAgiloft(callingApiName);
        string encodedQry;		
        string endpoint = utils.endPoint;
             
        endPoint = endPoint + '/EWCreate?';            
        encodedQry = '&$login=' + strAgiloftLoginId +'&$password='+ strAgiloftLoginPassword +'&$KB='+ strAgiloftKB + '&$lang=en&$table=cj_staging';         
        
        utils.setBody(agiloftPayload);  // Add Contract data fields to payload for create
        
        system.debug ('Payload:  ' + agiloftPayload);        
        
        utils.setEndpoint(endpoint);
        
        system.debug('encodedQry=' + encodedQry);
        
        utils.appendQueryParam(encodedQry);
        
        string response = trySendAPICall(utils, callingApiName, recordId);

        return response;
    }
    
    // QFCJ-4829
    public static string formatTerminationFeeScheduleValues(Decimal value){
        String formattedValue;
        
        if (value == NULL || value == 0){
            formattedValue = 'N/A'; 
        } else {
            formattedValue = '$' + value.format();
            if (!formattedValue.contains('.')) {
                formattedValue = formattedValue + '.00';
            } else {
                Integer dPos = formattedValue.indexOf('.');
                if (formattedValue.length() - dPos < 3) { 
                    formattedValue = formattedValue + '0'; 
                }   
            }
        }
        
        System.debug ('formatTerminationFeeScheduleValues - value: ' + value + ', formattedValue: ' + formattedValue);  
        
        return formattedValue;
    }

    public static string trySendAPICall(WebServiceUtilsAgiloft utils, string callingApiName, id recordId )
    {
    	Time startTime = DateTime.now().Time();
    	Time endTime;	 
        
        try
        {
            system.debug ('Calling utils.send(false)...  ');
            
            Boolean isContractAPISuccessful = utils.send(false);
            
            endTime = DateTime.now().Time();
            
            system.debug ('isContractAPISuccessful?:  ' + isContractAPISuccessful);            
            system.debug ('api statusCode:  '           + utils.statusCode);            
            
            if (isContractAPISuccessful && (utils.statusCode < 300) )
            {
                system.debug('Success... Before createApiTransaction()...');
                
                createApiTransaction(utils, callingApiName, startTime, endTime, null);  // Create API Transaction record for history and reports
                
                System.debug('SUCCESS!!  CLMUtils.buildSendPayload: ' + utils.getResponse().getBody() + AGILOFT_CONTRACT + recordId);


                // Update Contract object with response's recordID                
                Contract cntrct2 = [SELECT Id,  CJ_Staging_Record_ID__c, CLM_Transmission_Code__c FROM Contract WHERE Id =: recordId WITH SECURITY_ENFORCED]; 

                string cjStagingRecId 	= utils.getResponse().getBody();
                
                cjStagingRecID 			= cjStagingRecID.remove('\n\t\r');
                
                string invalidNumbers 	= '[^0-9]';  
                
                cjStagingRecID 		    = cjStagingRecID.replaceAll( invalidNumbers, '');  // cut out all NON numeric.   Example:  EWREST_id='2';  Will be:  2

                cntrct2.CJ_Staging_Record_ID__c     = integer.valueof(cjStagingRecId);
                
                cntrct2.CLM_Transmission_Code__c    = utils.statusCode;
                
                if ( Schema.sObjectType.Contract.fields.CJ_Staging_Record_ID__c.isUpdateable() && Schema.sObjectType.Contract.fields.CLM_Transmission_Code__c.isUpdateable() ) 
                {
                    system.debug('Performing update cntrct2:  ' + 'CJ_Staging_Record_ID__c:  ' + cntrct2.CJ_Staging_Record_ID__c + ' CLM_Transmission_Code__c:  ' + cntrct2.CLM_Transmission_Code__c);

                    update cntrct2;

                    system.debug('After update cntrct2:  ' + 'CJ_Staging_Record_ID__c:  ' + cntrct2.CJ_Staging_Record_ID__c + ' CLM_Transmission_Code__c:  ' + cntrct2.CLM_Transmission_Code__c);
                }
                else  // QFCJ-4703
                {
                    system.debug('CJ_Staging_Record_ID__c & CLM_Transmission_Code__c are NOT allowing update to be made due to Field Level Set security check.  i.e. .isUpdateable()');
                    
                    return strAgiloftWarningMsg + 'CJ_Staging_Record_ID__c & CLM_Transmission_Code__c are NOT allowing update to be made due to Field Level Set security check.  i.e. .isUpdateable()';
                }
                
                return strAgiloftSuccessMsg;           
            }
            else            
            {                        
                system.debug('Error... Before ApiTransaction()...');
                                
                createApiTransaction(utils, callingApiName, startTime, endTime, null); // Create API Transaction record for history and reports
                
                System.debug('ERROR...CLMUtils.buildSendPayload: Body: ' + utils.getResponse().getBody() + AGILOFT_CONTRACT + recordId);
                
                return 'Error: ' + utils.getResponse(); 
            }            
        }
        catch(Exception e)
        {	             
            system.debug('Exception...  Before createApiTransaction()...  Cause: ' + e.getCause() + ' Message: ' + e.getMessage() );
            
            createApiTransaction(utils, callingApiName, startTime, endTime, null);		// Create API Transaction record for history and reports
            
            System.debug('ERROR...  CLMUtils.buildSendPayload: Body: ' + utils.getResponse().getBody() + AGILOFT_CONTRACT + recordId);
            
            return 'Error: An error occurred during Contract Processing. Please contact Salesforce Production Support.';
        }        
        
    }        


    public static void createApiTransaction(WebServiceUtilsAgiloft utils, string callingApiName, Time startTime, Time endTime, string transactionSummaryId) 
    {            
        string 	responseStatus;
        Integer responseStatusCode;
        string 	responseBody;
        string 	requestEndpoint;
        string 	requestBody;
        string  errorDetails;
        
        requestEndpoint     = utils.getRequest().getEndpoint();
        requestBody         = utils.getRequest().getBody();
                
        responseStatus      = utils.getResponse().getStatus();
        responseStatusCode  = utils.getResponse().getStatusCode();
        responseBody        = utils.getResponse().getBody();        
        
        errorDetails        = utils.errorMsg;
                
        List<API_Transaction__c> apiTransactions = new List<API_Transaction__c>();
            
        system.debug('callingApiName:  '  			+  callingApiName);
        system.debug('getRqstMethod:  ' 			+  utils.getRequest().getMethod());
        system.debug('getRqstHeaderHost:  ' 		+  utils.getRequest().getHeader('Host'));
        system.debug('getRqstHeaderContent-Type:  ' +  utils.getRequest().getHeader('Content-Type'));
        system.debug('getRqstEndpoint:  ' 			+  utils.getRequest().getEndpoint());
        system.debug('getRqstBody:  '     			+  utils.getRequest().getBody());
        
        system.debug('getResponseStatus:  '			+  utils.getResponse().getStatus() );
        system.debug('getResponseStatusCode:  ' 	+  utils.getResponse().getStatusCode() );
        system.debug('getResponseHeaderKeys:  ' 	+  utils.getResponse().getHeaderKeys() );
        system.debug('getResponseBody:  ' 			+  utils.getResponse().getBody() );                
        
        system.debug('utils.errorMsg:  '  			+  utils.errorMsg);
        
        
        API_Transaction__c objApiTransaction = new API_Transaction__c();   // Create API Transaction record
        
        objApiTransaction.API_Name__c = callingApiName;
               
        objApiTransaction.API_Request_JSON__c = requestBody != null && requestBody != '' ? requestBody : null;
        
        // If the http response body is not null or blank then proceed
        if (responseBody != null && responseBody != '') 
        {
            string apiTrimResponse;

            apiTrimResponse = checkTrimApiResponse(responseBody);
            
            objApiTransaction.API_Response_JSON__c = apiTrimResponse;                
        }                
        else if (errorDetails != null && errorDetails != '') // If there are any error details then add that in the API Response field. 
        {
            objApiTransaction.API_Response_JSON__c = errorDetails;
        }            

        objApiTransaction.Internal_Message_Code__c = responseStatus != null && responseStatus != '' ? responseStatus : '';
        objApiTransaction.EndPoint__c = requestEndpoint != null && requestEndpoint != '' ? requestEndpoint : 'There is no end point';

        //spk Trim endpoint to remove any id/pwd by chance...                
        Integer position = objApiTransaction.EndPoint__c.indexOfAny('?');
        objApiTransaction.EndPoint__c = objApiTransaction.EndPoint__c.left(position);
        
        system.debug('endpoint url: '+ objApiTransaction.EndPoint__c);
        
        objApiTransaction.API_Status_Code__c = responseStatusCode != null && responseStatusCode != 0 ? String.valueOf(responseStatusCode) : '';
        objApiTransaction.Request_Time__c   = startTime;        
        objApiTransaction.Response_Time__c  = endTime;        
        objApiTransaction.Transaction_Summary_Id__c = transactionSummaryId;
        
        apiTransactions.add(objApiTransaction);
        
        if ( (apiTransactions?.size() > 0) && (Schema.sObjectType.API_Transaction__c.isCreateable()) )    // If there is at least a single API Transaction then insert it
        {
            insert apiTransactions;
            System.debug('API Transaction record inserted Id-->' + apiTransactions[0].id);
        }                               
    }


    public static string checkTrimApiResponse( string responseBody) 
    {
        string apiTrimResponse;
        apiTrimResponse = responseBody;
                
        if (apiTrimResponse?.length() > 131072) // If the response char length is greater than 131072 them trim & abbreviate it
        {
            apiTrimResponse = apiTrimResponse?.remove('\n\t\r');
            apiTrimResponse = apiTrimResponse?.trim();
            
            if (apiTrimResponse?.length() > 131072) 
            {
                apiTrimResponse = apiTrimResponse?.abbreviate(131072);
            }
        }

        return apiTrimResponse;
    }
}