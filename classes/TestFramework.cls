/***************************************************************************************************************
 * Description: Test class for TestFramework
 * *************************************************************************************************************
 * Change History:
 * Date          Dev		Traceability        Details
 * 2019-06-02   SArjuna     Validation Error	Added missing method.
 * 2022-08-05	SKuehl      ESCJ-1679           Grabbed a copy of TestFramework from SFDC and modified it for SFCJ for testing.
 * 2023-01-03	SKuehl		ESCJ-1680			Add Code to test Portfolio__c Object.
 * 2023-01-31	SKuehl		ESCJ-2345			Add test data to Create Contract objec for Contract_Request_Status_Notes__c. Clean up code for SonarQube 
 * 02/06/2023   Kuehl       ESCJ-2270           Contract Gen - Add ASA GF SOW Attributes to Agiloft:
 *                                                backboards_required, exterior_cabinets, nema_rated_cabinet, number_of_owner_installed_conduits, responsible_for_media_panel
 *                                                se_sow_additional_company_tasks_1, se_sow_additional_company_Tasks_2, se_sow_project_scope, size_of_owner_installed_conduits
 * 02/06/2023   Kuehl       ESCJ-2420           Contract Gen - ASA IW SOW Attribute - New field:  responsible_for_in_unit_wap_wiring.
 * 02/16/2023   Kuehl       ESCJ-2345           Had to update a 2 fields in Oppt object:  Region__c and Market__c due to pick list chgs by SFCJ admin
 * 02/22/2023   Kuehl       ESCJ-2507           Contract Gen - Add ASA GF SOW Owner Task Attributes - New fields:  se_sow_additional_owner_tasks_1, se_sow_additional_owner_tasks_2,
 * 04/11/2023   Kuehl       QFCJ-2780           New fields: account.lob__c, user.Name
 * 04/11/2023   Kuehl       QFCJ-2611/QFCJ-2872 New field:	capital_design.Entity_Type__c
 * 04/11/2023   Kuehl       QFCJ-2761/QFCJ-2872 New fields: property__c.Property_Contract_Status__c, offer.Existing_Agreement_Type__c, offer.Existing_Agreement_Effective_Date__c
 * 07/12/2023   Kuehl       QFCJ-4114           New field added property__c.Property_Use__c
 * 12-13-2023   Kuehl       QFCJ-4697           New field added Needs_CLM_Record_Cancelled__c in Contract obj
 * 1/12/2024    Neidecker   QFCJ-4829           Format values or Termination Fee Schedule
 * 
 ****************************************************************************************************************/
 
 @isTest

 public class TestFramework
 {
    static final string JUSTICE_LEAGUE_CORPORATION      = 'Justice League Corporation';
    static final string BUSINESS_CONTACT                = 'Business Contact';
    static final string PHONE_407                       = '407-999-1234';
    static final string BRACKLIN_STREET_ADDR            = '9436 Brackin Street';
    static final string FIRST_NEW_ORDER_ONLY            = 'First New Order Only';
    static final string COMPANY_TO_PROVIDE_AND_INSTALL  = 'Company to Provide and Install';

     /*
      * Default is false.
      * This will be set to true if setupDefaultData is triggered already in the instance.
     */   
     
     public static boolean defaultTestData
     {
         get{ return true;}
 
         set;                
     }
 
 
     /*
      * Default is true.
      * The feature can be turned off in case you want to call multiple createXX methods and then perform a single commit.
     */
     public static boolean autoCommit
     {
         get
         {
             return autoCommit = (autoCommit==null?TRUE:autoCommit);
         }
 
         set
         {
             if((autoCommit==null || !autoCommit) && value)
             {
                 commitTestData();    
             }
             
             autoCommit = value;    
         }
     }
     
 
     
     
     // Variables referenced internally in other test data setup methods
     
     static Map<String, Id> profiles;
 
     public static list<SObject> testData = new list<SObject>();
     
     
     // SPK... NOTE!!! ANYONE TESTING:   Be sure to have your User id assigned to Permission Set APEX Testing Permission Set and chg to your alias below...
     
     private static User u =[select id from user where alias='SP.Ku' limit 1];  // Test user.
 
         
     //testdata shouldn't be public. if it is I forgot to change it back
 
     
     
     private static void setsObjectFields(sObject obj, map<sObjectField, Object> addFields)
     {        
         if(addFields == null || addFields.isEmpty()) 
         {
            return;
         }
 
         for(sObjectField fld : addFields.keySet())
         {
             try
             {
                 obj.put(fld,addFields.get(fld));
             }
 
             catch(System.SObjectException ex)
             {
                 string sObjName = ex.getMessage().mid(0,ex.getMessage().indexOf('.'));
             
                 if(sObjName.equalsIgnoreCase(obj.getSObjectType().getDescribe().getName()))
                 {
                     throw ex;
                 }
             }            
         }
     } 
 
 
     private static void commitTestData() 
     {
         try
         {            
             insert testData;
         }
 
         catch(Exception e) 
         {
             system.debug('Exception while CREATING test data : ' + e.getStackTraceString());
             throw e;
         }
         
         finally
         {
             testData.clear();
         }
     }
     
 
     private static void commitTestData2() 
     {
         try
         {            
             update testData;
         }
 
         catch(Exception e) 
         {
             system.debug('Exception while UPDATING test data : ' + e.getStackTraceString());
             throw e;
         }
         
         finally
         {
             testData.clear();
         }
     }
     
 
     public static Id getProfileId(String profileName) 
     {
         if(profiles ==null) 
         {
             profiles=new Map<String, Id>();
         
             for(Profile record:[SELECT Id, Name FROM Profile]) 
             {
                 profiles.put(record.Name, record.Id);
             } 
         }
 
         return profiles.get(profileName);
     }    
 
 
     /*
      * Stages trivial default data that is required by a major sObject or use case or process.
     */
     @testSetup
     public static void setupDefaultData()
     {            
         system.runAs(u) // runAs User (u)  i.e. User Mode
         {
         //To avoid  MIXED_DML_OPERATION error
              
             string env = Level3Utils.detectEnv().toUpperCase();
             env = env.remove('CJ');  // Remove "CJ" from the beginning. spk 10-25-2022
             
             Level3Utils.setGlobalSettings(
                 new Map<String, String> 
                     {
                     'CLMContractSharing_batchSize'=>'100',
                     'SFCJInstance'=>env
                     }
             );
             
             defaultTestData = true;
         }        
     }
 
 
     /*
      * Params : 
      * profileName � Developer Name of the profile
      * addFields � map of sObject field/value that needs to be additionally set when the User is created.
      * Returns :
      * User
     */
     public static User createUser(String profileName, map<SobjectField,Object> addFields) 
     {
         return createUsers(new Map<String, Integer>{profileName=>1}, addFields).get(profileName)[0];
     }
     /*
      * Params : 
      * usersPerProfile � 'key' Developer Name of the profile, 'value' count of users for the profile.
      * addFields - map of sObject field/value that needs to be additionally set when the User is created. 
      * Returns :
      * map of profile (key) with the list of users (value) for that profile 
     */
 
     public static Map<String, User[]> createUsers(Map<String, Integer> usersPerProfile,map<SobjectField,Object> addFields) 
     {
         Map<String, User[]> results=new Map<String, User[]>();
         
         SObject[] cache=new SObject[0];
         SObject[] userSalesOffice = new SObject[0];
 
         for(String profileName: usersPerProfile.keySet()) 
         {
             Id profileId=getProfileId(profileName);
 
             Integer profileLimit=usersPerProfile.get(profileName);
 
             cache=new SObject[0];            
         
             while(cache.size() < profileLimit) 
             {
                string random1; 
                string random2;
                random1 = Level3Utils.randomString(5);
                random2 = 'TEST' + Level3Utils.randomString(5);
             
                Long randomNumber = Math.mod (Math.mod (System.currentTimeMillis(), 1000000) , 989898989);
             
                User usr =new User(
                         FirstName=random1, 
                         LastName=random2, 
                         //Name=random1 + ' ' + random2,
                         ProfileId=profileId,
                         Username='x' + random1 + '@' + random2 + '.com',
                         CommunityNickName='x' + random1,                         
                         IsActive=true, 
                         Email='x' + random1 + '@' + random2 + '.com',
                         EmailEncodingKey='utf-8',                        
                         Alias=random1,
                         LanguageLocaleKey='en_US',
                         LocaleSidKey='en_US',
                         TimeZoneSidKey=UserInfo.getTimeZone().getId(),
                         EmployeeNumber=randomNumber.format(),                        
                         CUID__c='u' + randomNumber
                     );
 
                 setsObjectFields(usr,addFields);
                 
                 cache.add(usr);                                
             }
 
             testData.addAll(cache);
             
             results.put(profileName, cache);
         }
 
         if(autoCommit)
         {
           commitTestData();
 
           system.runAs(u)
           {
             testData.addAll(userSalesOffice);
             commitTestData();
           }
         }
         return results;
     }
 
     /*
      * Params
      * addFields - map of sObject field/value that needs to be additionally set when the Lead is created.
      * Returns :
      * Leads     
     */
 
     public static Lead createLead(map<sObjectField, Object> addFields)
     {
         Lead ld = new Lead(
                             //Company=Level3Utils.randomString(20), 
                             Company=JUSTICE_LEAGUE_CORPORATION,
                             Contact_Type__c=BUSINESS_CONTACT,
                             DoNotCall=true,
                             DONT_Batch_Processed__c=false,
                             EERS_Batch_Processed__c=false,
                             HasOptedOutOfEmail=false,
                             HasOptedOutOfFax=false,
                             IsConverted=false,
                             //IsDeleted=false,
                             IsUnreadByOwner=false,
                             Salutation='Mr.', 
                             FirstName='Bruce', 
                             LastName='Wayne',
             
                             //CreatedById=UserInfo.getUserId(),
                             //LastModifiedById=UserInfo.getUserId(),
                             //Name='Bruce Wayne',
             
                             Phone=PHONE_407, 
                             City='Orlando',
                             Street=BRACKLIN_STREET_ADDR, 
                             State='FL', 
                             Country='US',
                             PostalCode='32825',
                             Property_Address__c=BRACKLIN_STREET_ADDR,
                             Property_Address_City__c='Orlando',
                             Property_Address_Validated__c=false,
                             Property_Address_Zip__c='32825',
                             LeadSource='Other',
                             Lead_Type__c='Self Created',
                             //Lead_Message__c='Ready for Conversion',
                             //Lumen_Property_Score__c=56,
                             Property_Latitude__c=38.7042445273515,
                             Property_Longitude__c=-94.9309477130529,
                             Property_Name__c='SUTTON RIDGE',
                             //Property_Network_Wire_Center__c='ORLDFLER', 
                             Status='open',
                             Requires_Marketing_Review__c=false,
                             email=Level3Utils.randomString(5) + '@' + Level3Utils.randomString(5) + '.com'
                             );
 
         setsObjectFields(ld, addFields);
 
         testData.add(ld);
 
         if(autoCommit) 
         {
             commitTestData();
         }
         
         return ld;
     }
     
     
     /*
      * Params: 
      * howMany - the number of Leads to be created
      * addFields - map of sObject field/value that needs to be additionally set when the record is created.
      * Returns :
      * Case     
     */    
 
     public static Lead[] createLeads(Integer howMany, Map<sObjectField,Object> addFields) {               
         Lead[] results = new Lead[0];
 
         while(results.size() < howMany) 
         {
             Lead l = new Lead( 
                             Company=JUSTICE_LEAGUE_CORPORATION,
                             Contact_Type__c=BUSINESS_CONTACT,
                             DoNotCall=true,
                             DONT_Batch_Processed__c=false,
                             EERS_Batch_Processed__c=false,
                             HasOptedOutOfEmail=false,
                             HasOptedOutOfFax=false,
                             IsConverted=false,
                             //IsDeleted=false,
                             IsUnreadByOwner=false,
                             Salutation='Mr.', 
                             FirstName='Bruce', 
                             LastName='Wayne2',
                             //Name='Bruce Wayne2',
                                         
                             Phone=PHONE_407, 
                             City='Orlando',
                             Street=BRACKLIN_STREET_ADDR, 
                             State='FL', 
                             Country='US',
                             PostalCode='32825',
                             Property_Address__c=BRACKLIN_STREET_ADDR,
                             Property_Address_City__c='Orlando',
                             Property_Address_Validated__c=false,
                             Property_Address_Zip__c='32825',
                             LeadSource='Other',
                             Lead_Type__c='Self Created',
                             //Lead_Message__c='Ready for Conversion',
                             //Lumen_Property_Score__c=56,
                             Property_Latitude__c=38.7042445273515,
                             Property_Longitude__c=-94.9309477130529,
                             Property_Name__c='SUTTON RIDGE',
                             //Property_Network_Wire_Center__c='ORLDFLER', 
                             Status='open',
                             Requires_Marketing_Review__c=false,                
                             email=Level3Utils.randomString(5) + '@' + Level3Utils.randomString(5) + '.com'
                             );
                             
                    setsObjectFields(l, addFields);
             
             results.add(l);
         }
 
         testData.addAll((SObject[])results);
         
         if(autoCommit) 
         {
            commitTestData();
         }
         
         return results;        
     }
 
 
     /*
      * Params : 
      * addFields - map of sObject field/value that needs to be additionally set when the Account is created.
      * Returns : 
      * Account
      * spk ???
     */    
 
     public static Account createAccount(map<sObjectField, Object> addFields) 
     {
         return createAccounts(1, addFields)[0];
     }
 
 
     /*
      * Params : 
      * howMany � the number of accounts that need to be created.
      * addFields - map of sObject field/value that needs to be additionally set when the Account is created.
      * Returns : 
      * Array of Account sObjects
     */    
 
     public static Account[] createAccounts(Integer howMany, map<sObjectField, Object> addFields) 
     {
         Account[] results=new Account[0];
 
         while(results.size() < howMany) 
         {
             Account a = new Account(
                                 Name=JUSTICE_LEAGUE_CORPORATION,
                                 //Account_Number__c='CJ-0000000025',
                                 Account_Status__c='Under Review',
                                  AccountSource='Other',
                                 Active__c='No',
                                 Account_Status_Reason_Code__c='Unable to identify company information',
                 
                                 Account_Verification_Reason__c='TEST',
                                 AccountNumber='TEST',                
                                 
                                 BillingCity='Orlando',
                                 BillingPostalCode='32825',
                                 BillingStreet='101 SuperHero Drive',
                                 BillingCountry='US',                                
                                 BillingState='FL',
                                                 
                                 Customer_Type__c='Prospect',
                 
                                 //Divestiture_Non_Solicit_Customer__c=false,
                                 //Do_Not_Call_Account__c=false,
                                 //DONT_EERS_Batch_Processed__c=false,
                                 //DUNS_Family_Duplication_Alert__c=false,
                                 DupBlockExclude__c='No',
                 
                                 HOA_COA__c='No',
                 
                                 //IsDeleted=false,
                                 
                                 Industry='Entertainment',
                 
                 				 lob__c='900',
                 
                                 //LD_USE_DnB_Optimize__c=false,
                                 
                                 MDM_Record_Source__c='SFCJ',
                                 National_Account_Acceptance__c='Not Reviewed',
                                 //OwnerId=UserInfo.getUserId(),
                                 OwnerId=u.Id,
                 
                                 Phone=PHONE_407,
                                                 
                                 ShippingCity='Orlando',
                                 ShippingPostalCode='32825',
                                 ShippingState='FL',
                                 ShippingStreet='101 SuperHero Drive',                                
                                 ShippingCountry='US',                
                                 Type='Standard'
                             );            
                 
             setsObjectFields(a, addFields);
             
             results.add(a);
         }
 
         testData.addAll((SObject[])results);
 
         if(autoCommit) 
         {
             commitTestData();        
         }
 
         return results;
     }
 
 
 
     /*
      * Params : 
      * accountRecord � parent account to which the contact is associated to.
      * addFields - map of sObject field/value that needs to be additionally set when the Contact is created. 
      * Returns :
      * Contact 
     */
     public static Contact createContact(Account accountRecord, map<sObjectField,Object> addFields) 
     {
         return createContacts(1, new Set<Id> { accountRecord.Id }, addFields)[0];
     }
     
     /*
      * Params : 
      * howMany � the number of contacts that need to be created per account specified by the param accountIds.
      * accountIds � a set of account id�s.
      * addFields - map of sObject field/value that needs to be additionally set when the Contact is created.
      * Returns : 
     */    
     public static Contact[] createContacts(Integer howMany, Set<Id> accountIds, map<sObjectField, Object> addFields) 
     {
         Contact[] results=new Contact[0];
 
         integer totalCreated = 0;        
         
         for(Id accountId: accountIds) 
         {
             while(totalCreated < howMany) 
             {                
                 string r1=Level3Utils.randomString(5);
                 string r2=Level3Utils.randomString(5);
                 
                 Contact c = new Contact(
                                     AccountId=accountId,
                                     Salutation='Ms.', 
                                     FirstName= r1,           
                                     LastName=r2,
                                     Email=r1 + '@' + r2 + '.com',
                                     Contact_Type__c=BUSINESS_CONTACT,
                                     DoNotCall=true,
                                     DONT_Batch_Processed__c=false,
                                     EERS_Batch_Processed__c=false,
                     
                                     et4ae5__HasOptedOutOfMobile__c=false,
                                     et4ae5__Mobile_Country_Code__c='US',
                                     
                                     HasOptedOutOfEmail=true,
                                     //IsDeleted=false,
                                     //IsEmailBounced=false,
                                     MailingStreet='101 Dalmatian Drive',
                                     MailingCity='Orlando',
                                     MailingState='FL',
                                     MailingPostalCode='32825',                                    
                                     MailingCountry='US', 
                                     OtherCountry='US', 
                                     Phone=PHONE_407,
                     
                                     //PhotoUrl='/services/images/photo/0030400000UXrXPAA1',
                                     //Name='C. Ella Deville',
                     
                                     Title='CFO',
                                     Status__c='Active'
                                 );
 
                 setsObjectFields(c,addFields);
                 
                 results.add(c);
                 
                 testData.add(c);
 
                 if(totalCreated==howMany)
                 {
                     totalCreated = 0;
                     break;
                 }
                 else
                 {
                     totalCreated += 1;
                 }
             }
         }
         
         if(autoCommit) 
         {
             commitTestData();
         }
         
         return results;
     }
 
 
 /*
      * Params
      * addFields - map of sObject field/value that needs to be additionally set when the account is created.
      * Returns :
      * Property     
     */
     public static Property__c createProperty(Account parentAccount, map<sObjectField, Object> addFields)
     {
         Property__c prop = new Property__c(
                             APN__c='312219849301710',
                             Bandwidth__c='940',
             
                             //Brownfield_Account_Manager__c='<a href="/lightning/r/User//view" target="_blank"> </a>',
             
                             County_Code__c='095',
                             //CreatedById=UserInfo.getUserId(),
                             //CreatedDate=system.today(), 
             
                             Customer_Handoff_Complete__c='No',  				// picklist entry 
                             Distribution_Status__c='Non Distributable',			// picklist entry
                             Gig_Enabled__c='Yes',								// picklist entry
             
                             //Greenfield_Account_Manager__c='<a href="/lightning/r/User//view" target="_blank"> </a>',
                             //Implementation_Manager__c='<a href="/lightning/r/User//view" target="_blank"> </a>',
                             
                             Initial_Property_Source__c='User',					// picklist entry
                             Initial_Source_Development_Status__c='Brownfield',
                             Initial_Source_Region__c='Out of Region',			// picklist entry
             
                             //IsDeleted=false,
                             //LastModifiedById=UserInfo.getUserId(),
                             //LastModifiedDate=system.today(),
                             Latitude__c=28.5576077229126,
                             //Lead_and_Property_Unique_Identifier__c='Orlando32825',
                             //Lead_Distribution_Identifier__c='Out of Region',
                             
                             Longitude__c=-81.2558431616388,                            
                             LQ_Region_Parameter__c='CTL',						// piclist entry
                             Lumen_Property_Score__c=82.2,
                             Name='SUTTON RIDGE PH 03',
             
                             //National_Account_Property__c='Standard Account Property',
                             
                             //Network_Wire_Center__c='a0004000003SsE5AAK',		//object refernece to Network Wire Center LOOKUP
                             
                             //Network_Wire_Center_Name_Text__c='ORLDFLER',
                             //Network_Wire_Center_Record_ID__c='a0004000003SsE5',
             
                             ocnName__c='CENTURYLINK COMMUNICATIONS LLC - FL',
             
                             //Outside_Sales_Representative__c='<a href="/lightning/r/User//view" target="_blank"> </a>',
                             //OwnerId='0055e000003hS0EAAU',						//object reference to Group Users                            
                             //OwnerId=UserInfo.getUserId(),
                             OwnerId=u.id,
             
                             //Planner__c='<a href="/lightning/r/User/0055e000006GPYm/view" target="_blank">Test P Planner</a>',
                             
                             Primary_Address_City__c='Orlando',
                             Primary_Address_State__c='FL', 						// picklist
                             Primary_Address_Street__c=BRACKLIN_STREET_ADDR,
                             Primary_Address_Zip__c='32825',
                             Process_Builder_Flag__c='Null Trigger',
                             Property_Account__c=parentAccount.Id,
             
                             //Property_Auto_Gen_Number__c='00000232',
                             //Property_Contact__c='0030400000UXrVOAA1',			// Contact object key

                             Property_Contract_Status__c='Expired',
                             Property_Demographic__c='Market Rate',				// Picklist
                             Property_Do_Not_Contact__c='No',        			// Picklist                    
                             Property_Structure__c='Cottage',					// Picklist
                             Property_Total_Units__c=1000,
             
                             Property_Type__c='Single Family Home (SFH)',		// Picklist
                             Property_Use__c='Rental',                          // Picklist  //QFCJ-4114

                             //Property_Unique_ID__c='09531221984930171012',
             
                             Property_Validation_Status__c='Validated',			// Picklist
             
                             //Record_Count__c=1,								// Formula
                             //Sales_Engineer__c='<a href="/lightning/r/User/0055e000006G8PY/view" target="_blank">Test SE Sales-Engineer-User</a>',
                             //Sales_Manager__c='<a href="/lightning/r/User//view" target="_blank"> </a>',
                             //Sales_Support_Administrator__c='<a href="/lightning/r/User//view" target="_blank"> </a>',
                             //Score_Distance_to_Fiber__c=0,
                             //ScoreUse_Distance_To_Fiber__c=0,
                             
                             Source_Company_Name__c=JUSTICE_LEAGUE_CORPORATION,
                             Source_Contact_Email__c='noemail@noemail.noemailprovided',
                             Source_Contact_First_Name__c='Diana', 
                             Source_Contact_Last_Name__c='Prince',
                             Source_Contact_Phone__c='407-888-1265',
                             State_Code__c='12',
             
                             //SystemModstamp=system.today(),
                             //Territory_Manager__c='<a href="/lightning/r/User//view" target="_blank"> </a>',
                                                                         
                                                                         // Contract_Lifecycle_Status__c='In Progress',
                                                                         // Segment_Status__c='Active Opportunity',
                                                                         // Segment_Inventory_Type__c='Unit Inventory Driver',
                                                                         // Inventory_Reduction__c='No',
                                //Total_Active_Unit_Reductions__c=0,		
                             //Total_Units_in_use_with_Active_Opps__c=800,// Formula:  SUM Segment_Total_Units__c WHEN: (Segment Status EQUALS Active Opportunity)                                   AND (Segment Inventory Type EQUALS Unit Inventory Driver) AND (Inventory Reduction NOT EQUAL TO Yes) AND (Contract Lifecycle Status NOT EQUAL TO Contracted)
                               //Total_Contracted_Unit_Reductions__c=0, 	 // Formula:  SUM Segment_Total_Units__c WHEN: (Contract Lifecycle Status EQUALS Contracted)                                AND (Segment Inventory Type EQUALS Unit Inventory Driver) AND (Inventory Reduction EQUALS Yes)
                             //Total_Units_Ready_for_Renewal__c=0,		 // Formula:  SUM Segment_Total_Units__c WHEN: (Contract Lifecycle Status EQUALS Ready for Renewal)                         AND (Segment Inventory Type EQUALS Unit Inventory Driver) AND (Inventory Reduction NOT EQUAL TO Yes)
                             //Total_Units_Under_Contract__c=0,			 // Formula:  SUM Segment_Total_Units__c WHEN: (Contract Lifecycle Status EQUALS Contracted, Auto Renew, Ready for Renewal) AND (Segment Inventory Type EQUALS Unit Inventory Driver) AND (Inventory Reduction NOT EQUAL TO Yes)
                             
                             //Transaction_Summary__c='a0T04000000mhDPEAY',		// Object key
                             
                             Unique_Id__c='09531221984930171012'
             
                             //Units_Available_for_Segments__c=0			// Formula 
                                                                         // IF(
                                                                         // ( Property_Total_Units__c(1000) - Total_Units_Under_Contract__c(0) + Total_Units_Ready_for_Renewal__c(0) + Total_Contracted_Unit_Reductions__c(0) - Total_Units_in_use_with_Active_Opps__c(800))
                                                                         // < 0 , 0 ,
                                                                         // ( Property_Total_Units__c(1000) - Total_Units_Under_Contract__c(0) + Total_Units_Ready_for_Renewal__c(0) + Total_Contracted_Unit_Reductions__c(0) - Total_Units_in_use_with_Active_Opps__c(800)) )
 
                         );
             
         setsObjectFields(prop, addFields);
 
         testData.add(prop);
 
         if(autoCommit) 
         {
             commitTestData();
         }
         
         return prop;
     }
 
 
     /*
      * Params : 
      * parentAccount - Account to which the Opportunity is associated
      * addFields - map of sObject field/value that needs to be additionally set when the Opportunity is created.
      * Returns : 
     */        
     public static Opportunity createOpportunity(Account parentAccount, Property__c parentProp, map<sObjectField, Object> addFields) 
     {
         return createOpportunities(parentAccount, parentProp, 1, addFields)[0];
     }
     
     /*
      * Params : 
      * parentAccount - Account to which the Opportunities are associated
      * howMany - the number of Opportunities to be created
      * addFields - map of sObject field/value that needs to be additionally set when the Opportunity is created.
      * Returns : 
      * Array of Opportunities     
     */    
 
     public static Opportunity[] createOpportunities(Account parentAccount, Property__c parentProp, Integer howMany, map<sObjectField, Object> addFields) 
     {
         Opportunity[] results=new Opportunity[0];
     
         while(results.size() < howMany) 
         {
             Opportunity opp = new Opportunity(
                                     Accountid=parentAccount.Id,	                       // Need for API Testing
                 
                                     //Account_Status__c='Under Review',
                                     //Account_Type__c='Standard',
                                     //Active_Segments__c=1,
                                     //Additional_Units_Available_from_Property__c=0,
                                     //Blank_Property_Use_Segment_Count__c=0,			// This is a Roll-Up Summary (COUNT Segment)
                                                                                         // Segment Use equals   AND Segment Status not equal to Cancelled Segment
                                                                         
                                     Budget_Confirmed__c=false,
                                     Cancelled_Implementation_Records__c=0,
                                     //Cancelled_Segments__c=0,
                                     
                                     //Capital_Design__c='a013C00000AYqqaQAD',           // Need for API Testing  !! Update from???  
                                     CloseDate=system.today(),  
                                     Commit_Cycle_1__c='No Commit',
                                     Commit_Cycle_2__c='No Commit',
 
                                     //ContractId='',                                      // Need for API Testing.  !! Update from Contract Object.
                                     Contract_Record_Exists__c='No',
                                     //Countdown_Field__c=9999,
                                     //CreatedById=UserInfo.getUserId(),
                                     //CreatedDate=system.today(),
                                     //Current_Commit_Cycle__c='October 2022',
                                     //Days_in_Commit_Cycle__c=0,
                                     Development_Status__c='Greenfield',
                                     Development_Status_Lock__c='Locked',
                                     Discovery_Completed__c=false,
                                     //Estimated_PMRR__c=0,
                                     //Fiscal='2022 3',
                                     //FiscalQuarter=3,
                                     //FiscalYear=2022,
                                     //ForecastCategory='Pipeline',
                                     ForecastCategoryName='Pipeline',
                                     //HasOpenActivity=false,
                                     //HasOverdueTask=false,
                                     Implementation_Active_Record_Count__c=0,
                                     //Inventory_Reduction__c='No',
                                     //IsClosed=false,
                                     //IsDeleted=false,
                                     IsPrivate=false,
                                     //IsWon=false,
                                     //LastModifiedById=UserInfo.getUserId(),
                                     //LastModifiedDate=system.today(),
                                     
                                     LeadSource='Advertisement',
                                     Market__c='Florida',
                                     Name='Justice League Corporation-Amazon Apartments',   // Need for API Testing
                                     //National_Account_Opportunity__c='No',
                                     //Opportunity_ID__c='OP-0000109',      
                                     //Opportunity_Inventory_Type__c='Unit Inventory Driver',	// Formula:...  
                                                                                                     //IF(
                                                                                                     //CONTAINS(TEXT(Type), "New Relationship"),"Unit Inventory Driver",
                                                                                                     //IF(
                                                                                                     //CONTAINS(TEXT(Type), "Renewal"), "Unit Inventory Driver",
                                                                                                     //IF(
                                                                                                     //CONTAINS(TEXT(Type), "Units"), "Unit Inventory Driver",
                                                                                                     //IF(
                                                                                                     //CONTAINS(TEXT(Type), "Renewal"), "Unit Inventory Driver",
                                                                                                     //IF(
                                                                                                     //CONTAINS(TEXT(Type), "Assignment"), "Non Inventory",
                                                                                                     //IF(
                                                                                                     //CONTAINS(TEXT(Type), "Terms"), "Non Inventory",
                                                                                                     //IF(
                                                                                                     //CONTAINS(TEXT(Type), "Upgrade"), "Non Inventory",
                                                                                                     //""
                                                                                                     //)))))))
                                  
                                     //Opportunity_System_Identifier__c='00604000006NyvoAAC' // This is the same as the Oppt.Id
                                  
                                     //Opportunity_Total_Units__c=500,						// Formula
                                     //OwnerId=UserInfo.getUserId(),
                                     OwnerId=u.id,
                                     
                                     //Parent_Account__c='No Parent',
 
                                     //Primary_Offer__c='',                                	// Need for API Testing.    !!! Update from Offer__c object
 
                                     //Primary_Offer_Alert__c='Primary Offer Assigned: <a href="/lightning/r/Offer__c/a0404000001SmTr/view" target="_top">OR-0000253</a> | Exclusive Marketing | CTLOn | Approved',
                                     //Primary_Offer_Capital_Design__c='a01040000022jAT',  // Capital Design id?
                                     //Primary_Offer_Service_Delivery__c='Instant Internet',
                                     //Primary_Offer_Technology_Type__c='FTTB',
                                     //Primary_Offer_Type__c='Exclusive Marketing',
                                   
                                     Probability=40,
                                     Property__c=parentProp.Id,                          // Need for API Testing
                 
                                     //Property_Primary_Address__c='9436 Brackin Street Orlando, FL 32825',
                                     //Push_Counter__c=0,
                                     //PushCount=0,
                 
                                     Pushed__c='No',
                 
                                     //Record_Count_del__c=1,
                                     
                                     Region__c='South',
                                     RETIRED_Unit_Inventory_Lock__c='No Offers Created',
                                     ROI_Analysis_Completed__c=false,
                 
                                     //Segment_Alerts__c='<img src="/img/samples/flag_red.gif" alt="red" border="0"/> *Property does not have units available for additional Segment creation* <img src="/img/samples/flag_red.gif" alt="red" border="0"/>',
                 
                                     StageName='Solution Defined', 
                 
                                     //SystemModstamp=system.today(),
                                     //Total_Cottage_Owner_Units__c=0,
                                     //Total_Cottage_Rental_Units__c=500,
                                     //Total_Segment_Units__c=500,
                                     //Total_SFH_Owner_Units__c=0,
                                     //Total_SFH_Rental_Units__c=0,
                                     //Total_Tower_Owner_Units__c=0,
                                     //Total_Tower_Rental_Units__c=0,
                                     
                                     Type='New Relationship',
                 
                                     Unit_Inventory_Lock__c='Locked'
                                     //Weighted_PMRR__c=0
                                     );
 
             setsObjectFields(opp,addFields);
             results.add(opp);
         }
     
         testData.addAll((SObject[])results);
     
         if(autoCommit) 
         {
             commitTestData();  // insert
         }
     
         return results;
     }
 
     /*
      * Params : 
      * parentAccount - Account to which the Opportunity is associated
      * addFields - map of sObject field/value that needs to be additionally set when the Opportunity is created.
      * Returns : 
     */        
     public static Opportunity updateOpportunity(Opportunity oppt, map<sObjectField, Object> addFields) 
     {
         return updateOpportunities(oppt, addFields)[0];
     }
 
     /*
      * Params : 
      * addFields - map of sObject field/value that needs to be additionally set when the Opportunity is updated...
      * Returns : 
     */        
     public static Opportunity[] updateOpportunities(Opportunity oppt, map<sObjectField, Object> addFields) 
     {        
         Opportunity[] results=new Opportunity[0];
     
         Opportunity opp = new Opportunity(Id=oppt.Id, Budget_Confirmed__c=false);
         
         setsObjectFields(opp, addFields);        
         results.add(opp);
     
         testData.addAll((SObject[])results);
     
         if(autoCommit) 
         {
             commitTestData2();  // Update 
         }
     
         return results;
     }
 
 
 /*
      * Params : 
      * contactId - Contact to which the role is associated
      * isPrimary - is the contact role a primary contact role ?
      * role      - role name
      * addFields - map of sObject field/value that needs to be additionally set when the Oppt Contact Role is created.
      * Returns :  OpportunityContactRole      
    */
     
     public static OpportunityContactRole createOpptContactRole(String contactId, Opportunity oppt, Boolean isPrimary, String role, map<sObjectField, Object> addFields) 
     {
         return createOpptContactRoles(contactId, oppt, isPrimary, role, addFields)[0];
     }
     
     /*
      * Params : 
      * primary   - a map of ContactId (key) whose role should be flagged as Primary (value)
      * role      - a map of ContactId (key) to which the role (value) is associated     
      * addFields - map of sObject field/value that needs to be additionally set when the Account Contact Role is created.
      * Returns : 
      * Array of OpportunityContactRole's
     */    
     public static OpportunityContactRole[] createOpptContactRoles(String contId, Opportunity oppt, Boolean primary, String role,  map<sObjectField, Object> addFields) 
     {
         OpportunityContactRole[] results=new OpportunityContactRole[0];
     
         OpportunityContactRole ocRole = new OpportunityContactRole(
                                                     ContactId=contId,                    	// Used in API Testing
                                                     //CreatedById=UserInfo.getUserId(),
                                                     //CreatedDate=system.today(),
                                                     //Do_Not_Contact_Alert__c='',
                                                     //IsDeleted=false,
                                                     IsPrimary=primary,						// Used in API Testing
                                                     OpportunityId=oppt.Id, 				 	// Used in API Testing
                                                     Role=role				               	// Used in API Testing  'Authorized Signer'
                                                     //SystemModstamp=CreatedDate=system.today()
                                                     );
         setsObjectFields(ocRole, addFields);
             
         results.add(ocRole);            
         
 
         testData.addAll((SObject[])results);
 
         if(autoCommit) 
         {
             commitTestData();
         }
         
         return results;
     }
 
     
     
     
     /*
      * Params : 
      * addFields - map of sObject field/value that needs to be additionally set when the Segment__c is created.
      * Returns : 
      * Segment__c     
     */    
 
     public static Segment__c createSegment(map<sObjectField, Object> addFields) 
     {
         return createSegments(1, addFields)[0];
     }
 
     /*
      * Params : 
      * howMany � the number of Segment__c that need to be created.
      * addFields - map of sObject field/value that needs to be additionally set when the Segment__c is created.
      * Returns : 
      * Array of Segment__c sObjects
     */    
 
     public static Segment__c[] createSegments(Integer howMany, map<sObjectField, Object> addFields) 
     {
         Segment__c[] results=new Segment__c[0];
 
         while(results.size() < howMany) 
         {
             Segment__c seg = new Segment__c(
                                     //Additional_Units_Available_from_Property__c=0,
                                     //ConnectionReceivedId='',    
                                     //ConnectionSentId='',
                                     //Contract__c='<a href="/lightning/r/Contract/800040000001TAc/view" target="_parent">CR-00000123</a>',
                                     
                                     Contract_Lifecycle_Status__c='In Progress',
                                     
                                     //CreatedById=UserInfo.getUserId(),
                                     //CreatedDate=system.today(),
                                     // Id                                       //Used in API testing...
                                     
                                     Inventory_Reduction__c='No',
                                     
                                     //IsDeleted=false,
                                     //LastActivityDate='',
                                     //LastModifiedById=UserInfo.getUserId(),
                                     //LastModifiedDate=system.today(),
                                     //LastReferencedDate=system.today(),
                                     //LastViewedDate=system.today(),
                                     
                                     Name='SUTTON RIDGE PH 03 Segment 1',
                                     
                                     // Opportunity__c   					// Passed in...  //Used in API testing...
                                     // Property__c      					// Passed in... 
                                     
                                     Property_ID_Filter__c='TEST',
                                     Segment_Inventory_Type__c='Unit Inventory Driver',
                 
                                     Segment_Status__c='Active Opportunity',
                 
                                     Segment_Structure__c='Cottage',
                 
                                     //Segment_Total_Cottage_Owner_Units__c=0,		// Formula - 
                                     //Segment_Total_Cottage_Rental_Units__c=1000,	// Formula - 
                                     //Segment_Total_SFH_Owner_Units__c=0,			// Formula - 
                                     //Segment_Total_SFH_Rental_Units__c=0,			// Formula - 
                                     //Segment_Total_Tower_Owner_Units__c=0,			// Formula - 
                                     //Segment_Total_Tower_Rental_Units__c=0,		// Formula - 
                                     
                                     //Segment_Total_Units__c=1000, 					// Used in Offer field: Offer_Total_Units__c - Formula.  Used in Offer valdation rule: Units_built_cannot_exceed_offer_units
                                     Segment_Total_Units__c=0,						// Make sure this is set to 0 for validation rule -> Segment_Unit_Maximum  to be successful.
                                     
                                     Segment_Use__c='Rental'                    		//Used in API testing...
                 
                                     //SystemModstamp=system.today()
                                     );            
                 
             setsObjectFields(seg, addFields);
             
             results.add(seg);
         }
 
         testData.addAll((SObject[])results);
 
         if(autoCommit) 
         {
             commitTestData();        
         }
 
         return results;
     }
 
 
 
 
     /*
      * Params : 
      * addFields - map of sObject field/value that needs to be additionally set when the OFfer is created.
      * Returns : 
      * Offer     
     */    
 
     public static Offer__c createOffer(map<sObjectField, Object> addFields) 
     {
         return createOffers(1, addFields)[0];
     }
 
 
     /*
      * Params : 
      * howMany � the number of Offers that need to be created.
      * addFields - map of sObject field/value that needs to be additionally set when the Offer is created.
      * Returns : 
      * Array of Offer sObjects
     */    
     
     public static Offer__c[] createOffers(Integer howMany, map<sObjectField, Object> addFields) 
     {
         Offer__c[] results=new Offer__c[0];
 
         while(results.size() < howMany) 
         {
             Offer__c off = new Offer__c(
                                 Absorption_Table_Needed__c='Yes',  					//Used in API Testing...
 
                                 //Alternate_Planner__c=UserInfo.getUserId(),		// User object
                                 //Alternate_Sales_Engineer__c=UserInfo.getUserId(),	// User object
 
                                 Alternate_Planner__c=u.id, 							// User object
                                 Alternate_Sales_Engineer__c=u.id, 					// User object
 
 
                                 //Alternate_Sales_Engineer_Email__c='raymond.d.capetillo@centurylink.com.invalid',
                                 //Approval_Letter_Message__c='The following represents approved Offer pricing for this opportunity only and must be included in the final provisioning/order entry package. This pricing is not valid for any customer or Offer Name other than that noted above unless otherwise explicitly identified in this letter.',
                                 
                                 Approval_Type__c='Standard',
                                 Approved_in_Portfolio_Only__c='No',
                 
                                 //Assigned_Analyst__c=UserInfo.getUserId(),  			// User Object
                                 Assigned_Analyst__c=u.id,					  			// User Object
                                 Assigned_Analyst_Date__c=system.today(),
                 
                                 //Assigned_Planner__c='<a href="/lightning/r/User/0055e000006GPYm/view" target="_blank">Test P Planner</a>',
                                 
                                 //Assigned_Planner_Dynamic_Email__c='',
                                 
                                 //Assigned_Planner_Email__c='raymond.d.capetillo@centurylink.com.invalid',
                                 //Assigned_Sales_Engineer__c='<=a href="/lightning/r/User/0055e000006G8PY/view" target="_blank">Test SE Sales-Engineer-User</a>',
                                 
                                 //Assigned_Sales_Engineer_Dynamic_Email__c='',
                                 
                                 //Assigned_Sales_Engineer_Email__c='raymond.d.capetillo@centurylink.com.invalid',
 
                                 //Associated_Capital_Design__c='',            		//Used in API Testing...  !!!! Need to update this once I have a capital design created.
                                 
                                 //Bandwidth__c=940,                           		//Used in API Testing...  This is a formula and is Calculated
                                 Billing_Ramp_Period__c=3.0,                   		//Used in API Testing... 
 
 
                                 Brain_ID__c='Delta - BAU results',
                 
                                 //BRAIN_ID_Link_to_BRAIN_UI__c='<a href="https://brain-env1.lumen.com/ui/#/financial-analyses/Delta - BAU results" target="_new">Delta - BAU results</a>',
 
                                 Brain_ID_Offer__c='Delta - Offer results',
                                     
                                 //BRAIN_ID_Offer_Link_to_BRAIN_UI__c='<a href="https://brain-env1.lumen.com/ui/#/financial-analyses/Delta - Offer results" target="_new">Delta - Offer results</a>',
                                 
                                 //Bulk_Data_Speed_Profile_DL_UL__c='',
 
                                 Bulk_Data_Speed_Profile_DL_UL_Approv__c='40M/20M',  //Used in API Testing...  
                                 
                                 //Bulk_Data_Type__c='',
                                 
                                 Bulk_Data_Type_Approved__c='Legacy',                //Used in API Testing...
                                 
                                 //Bulk_Video_Type__c='',
                                 
                                 Bulk_Video_Type_Approved__c='DTV (Entertainment)',   //Used in API Testing... 
                                 
                                 //Bulk_Voice_Type__c='',
 
                                 Bulk_Voice_Type_Approved__c='Digital Home Phone',    //Used in API Testing...
                                 
                                 CapEx_Direct__c=444.3,
                                 CapEx_Direct_Offer__c=444.3,
                                 
                                 //Capital_Design_Required__c='Yes',					// Fed in via parms....
                                 
                                 //Capital_Design_Status__c='Capital_Evaluation_Complete',   //??? Needed?
                                                                 
                                 //Capital_Per_Unit__c=4.4,
                                 //Capital_Per_Unit_Offer__c=4.4,
                                 
                                 Capital_Summation__c=444.6,
                                 Capital_Summation_Offer__c=444.6,
                                 CO_Electronics_Total__c=0.0,
 
                                 Compensation_Needed__c=false,                       //Used in API Testing... 
                                 
                                 Competetive_Justification__c='abcdefghijklmnopqrstuvwxyz',
                 
                                 //ConnectionReceivedId='',
                                 //ConnectionSentId='',
 
                                 Consumer_Privacy_Required__c='No',                 	//Used in API Testing...
                                 
                                 //Contract__c='',                                   //!!! Need to update with contract #
                                 
                                 Contract_Record_Exists__c='Yes',
                                 Contract_Status__c='Contract Requested',
                                 
                                 Contract_Term__c='120',                             //Used in API Testing...
                                 
                                 //Copy_To_Email__c='',
                                 Copy_To_Name__c='hello there...',
                                 Core_Switch_Electronics_Total__c=0.0,
                 
                                 //CreatedById=UserInfo.getUserId(),
                                 //CreatedDate=system.today(),       
                 
                                 //Cumulative_Living_Units_Built_Total__c=295,
 
                                 //Cumulative_Living_Units_Built_Year_1__c=5,		//Used in API Testing...
                                 //Cumulative_Living_Units_Built_Year_2__c=15,       //Used in API Testing...
                                 //Cumulative_Living_Units_Built_Year_3__c=35,       //Used in API Testing...
                                 //Cumulative_Living_Units_Built_Year_4__c=75,       //Used in API Testing...
                                 //Cumulative_Living_Units_Built_Year_5__c=155,      //Used in API Testing...
                                 //Cumulative_Living_Units_Built_Year_6__c=295,      //Used in API Testing..
                                 //Cumulative_Living_Units_Built_Year_7__c=295,      //Used in API Testing...
                                 //Cumulative_Living_Units_Built_Year_8__c=295,      //Used in API Testing...
                                 //Cumulative_Living_Units_Built_Year_9__c=295,      //Used in API Testing...
                                 //Cumulative_Living_Units_Built_Year_10__c=295,     //Used in API Testing...
                                 
                                 Cumulative_NPV__c=444.8,
                                 Cumulative_NPV_Offer__c=444.8,
                                 Data_Bounty_Amount__c=25,
                                 Data_Bounty_Amount_Approved__c=25,                 	//Used in API Testing...  
                                 Data_Bounty_Type__c=FIRST_NEW_ORDER_ONLY,                    
                                 Data_Bounty_Type_Approved__c=FIRST_NEW_ORDER_ONLY,	//Used in API Testing... 
 
                                 Data_Penetration_LOSS__c=0,
                                 Data_Penetration_WIN__c=0,
                 
                                 //Days_Post_Expiration__c=88,
                                 //Days_until_Expiration__c=139,
 
                                 //Development_Status__c='Greenfield',                	//Used in API Testing...  This is a Formula calculation
                                 
                                 Direct_Approval_Approved_Rejected__c='Needs Evaluation',
                                 //Direct_Approver__c='',
                 
                                 //Director_Field_Sales__c='Connie Porter',
                                 
                                 Discounted_Payback_months__c=444.4,
                                 Discounted_Payback_months_Offer__c=444.4,
                                 Distribution_F2_Total__c=0,
                                 Distribution_Structure_Conduit_Total__c=0,
 
                                 DTV_Installation__c='No',                               //Used in API Testing...
                                 
                                 EBITDA_Margin__c=444.1,
                                 EBITDA_Margin_Offer__c=444.1,
                                 Electronic_Vendor__c='Test Vendor',
                                 Ending_MRC__c=444.7,
                                 Ending_MRC_Offer__c=444.7,
                                 Escalation_Status__c='N/A',
                 
                                 //Estimated_PMRR__c=8850,
 
                                 ETL_Months_0_12_Year_1__c=105.99,                  		//Used in API Testing... 
                                 ETL_Months_13_24_Year_2__c=95.99,                  		//Used in API Testing...  
                                 ETL_Months_25_36_Year_3__c=85.99,                  		//Used in API Testing...  
                                 ETL_Months_37_48_Year_4__c=75.99,                  		//Used in API Testing...  
                                 ETL_Months_49_60_Year_5__c=65.99,                  		//Used in API Testing...  
                                 ETL_Months_61_72_Year_6__c=55.99,                  		//Used in API Testing...  
                                 ETL_Months_73_84_Year_7__c=45.99,                  		//Used in API Testing...  
                                 ETL_Months_85_96_Year_8__c=35.99,                  		//Used in API Testing...  
                                 ETL_Months_97_108_Year_9__c=25.99,                 		//Used in API Testing...  
                                 ETL_Months_109_120_Year_10__c=15.99,               		//Used in API Testing...  
                                 
                                 ETL_Position_Requested__c='No',
                                 Expense_Summation__c=444.12,
                                 Expense_Summation_Offer__c=444.12,
                 
                                 //Expiration_Boolean__c=false,

                                 Existing_Agreement_Type__c='Marketing Agreement',
                                 Existing_Agreement_Effective_Date__c=system.today(),
                                 
                                 F4_Inside_Wire_SFH_Total__c=0,
                                 Feeder_F1_Access_and_or_PON_Total__c=0,
                                 Feeder_Structure_Conduit_Total__c=0,
                                 Financial_Analysis_Transmission__c='Success',
                                 Financial_Viability__c='GREEN',
                                 Financial_Viability_Offer__c='GREEN',
                 
                                 //First_Occupancy_Allowance_Days__c=3,
 
                                 //First_Occupancy_Date__c='2022-06-03',               	//Used in API Testing... 
 
                                 //First_Prepaid_Marketing_Fee_Payment__c=0,           	//Used in API Testing... 
 
                                 Flat_Revenue_Share__c=7,                                
                                 Flat_Revenue_Share_Approved__c=7,                   	//Used in API Testing...
 
                                 //Forecast_Table_Lookup_Value__c='2022 Exclusive MarketingCTLOnNew Relationship',
                                 
                                 Gratis_Location_Data__c='Office and Recreation Area',
                                 Gratis_Location_Video__c='TEST',
                                 Gratis_Requested__c='Yes',
                                 Gratis_Requested_Approved__c='Yes',                		//Used in API Testing... 
                                 Gratis_Units_Approved_Data__c=3,                   		//Used in API Testing...  
                                 Gratis_Units_Approved_Video__c=1,                  		//Used in API Testing...  
                                 Gratis_Units_Data__c=3,
                                 Gratis_Units_Video__c=1,
 
                                 Guaranteed_Minimum_HSI_Bulk_Speed__c='No',             	//Used in API Testing... 
 
                                 HSI_Speed_Upgrade_First_Tier_MRC__c=22.00,              //Used in API Testing... 
                                 HSI_Speed_Upgrade_First_Tier_Speed__c=200,              //Used in API Testing...  
                                 HSI_Speed_Upgrade_Second_Tier_MRC__c=33.00,             //Used in API Testing...  
                                 HSI_Speed_Upgrade_Second_Tier_Speed__c=500,             //Used in API Testing...  
                                 HSI_Speed_Upgrade_Third_Tier_MRC__c=44.00,              //Used in API Testing... 
                                 HSI_Speed_Upgrade_Third_Tier_Speed__c=940,              //Used in API Testing... 
                                 
                                 Incremental_ATC_To_Meet_Guardrail__c=444.5,
                                 Incremental_ATC_To_Meet_Guardrail_Offe__c=444.5,
                                 IRR__c=444.2,
                                 IRR_Offer__c=444.2,
                 
                                 //IsDeleted=false,
                                 //LastActivityDate='',
                                 //LastModifiedById=UserInfo.getUserId(),
                                 //LastModifiedDate=system.today(),              
                                 //LastReferencedDate=system.today(),              
                                 //LastViewedDate=system.today(),              
                                 
                                 Legacy_Territory__c='CTL',                   	//Used in API Testing...  
 
                                 //Manual_Complete__c='Standard',
                                 
                                 MDU_ONT_Drop_Total__c=0,
                                 Modification_Count_Pricing__c=0,
                                 Modification_Count_Support__c=0,
                                 Modification_Notes__c='TEST',
                                 Modification_Notes_Support__c='TEST',
                                 //Modification_Status__c='',

                                 Months_0_12_Year_1__c=123456.78,                   //Used in API Testing...  QFCJ-4829
                                 Months_13_24_Year_2__c=100.00,                  	//Used in API Testing...  QFCJ-4829
                                 Months_25_36_Year_3__c=80,                  		//Used in API Testing...  QFCJ-4829
                                 Months_37_48_Year_4__c=70.90,                  	//Used in API Testing...  QFCJ-4829
                                 Months_49_60_Year_5__c=60.74,                		//Used in API Testing...  QFCJ-4829
                                 Months_61_72_Year_6__c=50.63,                		//Used in API Testing...  QFCJ-4829
                                 Months_73_84_Year_7__c=40.52,                		//Used in API Testing...  QFCJ-4829
                                 Months_85_96_Year_8__c=30.41,                  	//Used in API Testing...  QFCJ-4829
                                 Months_97_108_Year_9__c=NULL,       	          	//Used in API Testing...  QFCJ-4829
                                 Months_109_120_Year_10__c=0,		               	//Used in API Testing...  QFCJ-4829

                                 //MRR_Calculation_Year__c=2022,					// Formula
                                 
                                 MRR_Flow_Output__c='30',
                 
                                 //MRR_Key__c=30,								// Formula
                                 
                                 NA_1st_Year_of_Positive_EBITDA__c=0,                
                                 
                                 //Name='OR-000025' + results.size(),   			// Required   //Used in API Testing...
 
                                 Network_Investment__c='New Development',
                                 NRMA_ID__c='Delta BAU NRMA',
                                 NRMA_ID_Offer__c='Delta NRMA',
 
                                 OFAC_Language_Needed__c='No',                  //Used in API Testing...
                                 
                                 //Offer_Cancel_Date__c=system.today(),
                                 
                                 Offer_Escalation_Approval__c='No',					// Picklist
                                 Offer_Escalation_Approval_Date__c=system.today(),
                 
                                 Offer_Escalation_Management_Notes__c='TEST',
                                 Offer_Escalation_Notes__c='TEST',
                                 Offer_Escalation_Reason__c='In Contract Redlines',	// Picklist
                                 Offer_Escalation_Submit_Date__c=system.today(),
 
                                 Offer_Expiration_Date__c=system.today(),        	//Used in API Testing...  DATE only... No TIme  YYYY-MM-DD
 
                                 Offer_Initial_Submit_Date__c=system.today(),
                                 Offer_Pricing_Approval_Date__c=system.today(),
                                 Offer_Refresh_Count__c=0.0,
                                 Offer_Refresh_Engineer_Approved__c=system.today(),
                                 Offer_Refresh_Initial_Submit__c=system.today(),
                                 Offer_Refresh_Planner_Approved__c=system.today(),
                                 Offer_Refresh_Pricing_Approved__c=system.today(),
                 
                                 Offer_Refresh_Required__c='No',
                                 Offer_Refresh_Status__c='None',
                 
                                 Offer_Rejection_Date__c=system.today(),
                                 Offer_SM_Approval_Date__c=system.today(),
                 
                                 //Offer_Status__c='Approved',  // Fed in via parm....
                 
                                 Offer_Status_PATH__c='Approved',
                 
                                 //Offer_Total_Approved_Investment__c=444.6,
                                 //Offer_Total_Investment__c=444.6,
                                 //Offer_Total_Requested_Investment__c=2020444.6,
 
                                 //Offer_Total_Units__c=101,                    //Used in API Testing...  // Formula - Opportunity__r.Opportunity_Total_Units__c
                                 
                                 Offer_Type__c='Exclusive Marketing',         //Used in API Testing...
 
                                 One_Time_Charge__c=1325.00,                      //Used in API Testing...
 
                                 //Opportunity__c='00604000006NyvoAAC',      // Pass in Oppt id.
 
                                 //Opportunity_Prior_Close_Date__c=system.today(),
                                 
                                 Other_MDU_F4_Total__c=0,
 
                                 Owner_Contribution_Days_Payment_Due__c=10,   	//Used in API Testing...
 
                                 Owner_Contribution_Payment__c=5000,            	//Used in API Testing...
 
                                 // OwnerId=UserInfo.getUserId(),				//Object Group User
 
                                 Payment_Schedule__c='2 years',
                                 Payment_Schedule_Approved__c='2 years',
                                 Penetration_Commitment_Data__c=40,
                                 Penetration_Commitment_Video__c=5,
                                 Penetration_Commitment_Voice__c=15,
                                 Person_Approving_Rejecting_Escalation__c='TEST',
 
                                 //Planner_at_Creation__c=UserInfo.getUserId(),	// object User
 
                                 //Planner_Email__c='raymond.d.capetillo@centurylink.com.invalid',
                                 
                                 //Portfolio__c='',								//Object Portfolio
                                 Portfolio_Notes__c='TEST',
                 
                                 //Portfolio_Status__c='',
                                 //Portfolio_Weight__c='',
 
                                 Prepaid_Marketing_Fee_Per_Unit__c=30000.00,
                                 Prepaid_Marketing_Fee_Per_Unit_Approve__c=30000,                    //Used in API Testing...  
                                 
                                 Prepaid_Marketing_Fee_Type__c='Flat Fee - One Time',
                                 Prepaid_Marketing_Fee_Type_Approved__c='Flat Fee - One Time',     //Used in API Testing...  
                                 
                                 //Prepaid_Marketing_Total_Amount__c=20000,
                                 //Prepaid_Marketing_Total_Amount_Approve__c=0,
                                 
                                 Pricing_Strategy__c='TEST',
                 
                                 //Primary_Offer__c='Yes',
                                 //Primary_Selection_Visibility__c='Primary Selection',
                                 
                                 Process_Builder_Flag__c='Yes',
                 
                                 //Property__c='<a href="/lightning/r/Opportunity__r.Property__c/a0A04000003PkIwEAK/view" target="_blank">SUTTON RIDGE PH 03</a>',
                                 
                                 Property_Manager__c='No',                  		//Used in API Testing... 
                                 
                                 //Property_Primary_Address_State__c='FL',
                                 
                                 //Qualifies_for_Direct_Approval__c='No',		// Fed in via parms...
 
                                 Ramp_Period_Type__c='Standard Ramp',       		//Used in API Testing...  
                                 
                                 //Record_Count__c=1,
                                 
                                 Red_Deal_Status__c='Management review',
 
                                 //Refresh_Capital_Design__c='',               	//Used in API Testing...  // Object Capital Design__c
                                 
                                 Rejection_Reason__c='NE - Not Economic',
                 
                                 //Related_Opportunity_Probablility__c=40,
                                 //Related_Opportunity_Stage__c='Solution Defined',
                                 //Related_Opportunity_Type__c='New Relationship',
                                 //Remaining_Business_Days_in_Month__c=18,
                     
                                 Remote_Electronics_Total__c=0,
                                 Requested_Bulk_Data_Price__c=0,
 
                                 Requested_Bulk_Data_Price_Approved__c=40,       //Used in API Testing... 
                                 
                                 Requested_Bulk_Video_Price__c=0,
                                 
                                 Requested_Bulk_Video_Price_Approved__c=25,      //Used in API Testing... 
                                 
                                 Requested_Bulk_Voice_Price__c=0,
                                 
                                 Requested_Bulk_Voice_Price_Approved__c=15,      //Used in API Testing...  
                                 
                                 Response_Requested_Date__c=system.today(),		// DATE only YYYY-MM-DD
                                 Revenue_Base__c='Embedded',
 
                                 Revenue_Base_Approved__c='Embedded',           //Used in API Testing... 
                                 
                                 Revenue_Share_Agent_Commission_Rate__c=0,
                                 Revenue_Share_MAX_Penetration_Rate__c=0,
                                 Revenue_Share_MIN_Penetration_Rate__c=0,
                                 
                                 Revenue_Share_Type__c='Flat',
                                 Revenue_Share_Type_Approved__c='Flat',      //Used in API Testing...
 
                                 Review_Type__c='Standard',
                 
                                 //Sales_Accepted_By__c='',
                                 Sales_Accepted_Date__c=system.today(),
 
                                 //Sales_Engineer_at_Creation__c=UserInfo.getUserId(),		// Object:  User
 
                                 //Sales_Engineer_Email__c='raymond.d.capetillo@centurylink.com.invalid',
                                 
                                 Sales_Manager_Offer_Approval__c='No',
                                 Sales_Manager_Offer_Comments__c='TEST',
                                 Scope_of_Work__c='If you build it, they will come',
 
                                 //Second_Prepaid_Marketing_Fee_Payment__c=0,   //Used in API Testing...
 
                                 Service_Delivery__c='CTLOn',                 //Used in API Testing...
                                 
                                 SF_ONT_Drop_Total__c=0,
                                 //showSubmitToBRAIN__c=false,
                                 Simple_Payback_Months__c=444.1,
                                 Simple_Payback_Months_Offer__c=444.1,
                                 //Submit_for_Approval_Message__c='',
                                 
                                 //Technology_Diagram__c='',
                                 //Technology_Type__c='FTTU',
                                 //Termination_Fee_Applies__c='',
                                 Tier_1__c=1,
                                 Tier_2__c=2,
                                 Tier_3__c=3,
                                 Tier_4__c=4,
                                 Tier_5__c=5,
                                 Tier_6__c=6,
                                 
                                 Tier_1_Approved__c=1,                       //Used in API Testing... 
                                 Tier_2_Approved__c=2,                       //Used in API Testing... 
                                 Tier_3_Approved__c=3,                       //Used in API Testing... 
                                 Tier_4_Approved__c=4,                       //Used in API Testing... 
                                 Tier_5_Approved__c=5,                       //Used in API Testing... 
                                 Tier_6_Approved__c=6,                       //Used in API Testing... 
                                 
                                 Tier_Value_1__c=1,
                                 Tier_Value_2__c=5,
                                 Tier_Value_3__c=10,
                                 Tier_Value_4__c=15,
                                 Tier_Value_5__c=20,
                                 Tier_Value_6__c=25,
                                 
                                 Tier_Value_1_Approved__c=1,                //Used in API Testing... 
                                 Tier_Value_2_Approved__c=5,                //Used in API Testing... 
                                 Tier_Value_3_Approved__c=10,                //Used in API Testing... 
                                 Tier_Value_4_Approved__c=15,                //Used in API Testing... 
                                 Tier_Value_5_Approved__c=20,                //Used in API Testing... 
                                 Tier_Value_6_Approved__c=25,                //Used in API Testing... 
                                 
                                 Transport_Interoffice_Fiber_Total__c=0,
                                 Unit_Penetration_LOSS__c=0,
                                 Unit_Penetration_WIN__c=0,
                                 
                                 Units_Built_Year_1__c=5,                    //Used in API Testing... 
                                 Units_Built_Year_2__c=10,                   //Used in API Testing... 
                                 Units_Built_Year_3__c=15,                   //Used in API Testing... 
                                 Units_Built_Year_4__c=20,                   //Used in API Testing... 
                                 Units_Built_Year_5__c=25,                   //Used in API Testing... 
                                 Units_Built_Year_6__c=30,                 	//Used in API Testing... 
                                 Units_Built_Year_7__c=35,                  	//Used in API Testing... 
                                 Units_Built_Year_8__c=40,                  	//Used in API Testing... 
                                 Units_Built_Year_9__c=45,                  	//Used in API Testing... 
                                 Units_Built_Year_10__c=50,                 	//Used in API Testing... 
                                 //Units_Built_Total__c=275,					// Formula - Units_Built_Year_1__c + Units_Built_Year_2__c + Units_Built_Year_3__c + Units_Built_Year_4__c + Units_Built_Year_5__c + Units_Built_Year_6__c + Units_Built_Year_7__c + Units_Built_Year_8__c + Units_Built_Year_9__c + Units_Built_Year_10__c
 
                 
                                 Video_Penetration_LOSS__c=0,
                                 Video_Penetration_WIN__c=0,
                                 Voice_Bounty_Amount__c=0,
 
                                 Voice_Bounty_Amount_Approved__c=12,     	//Used in API Testing... 
                                 
                                 //Voice_Bounty_Type__c='',
                                 
                                 Voice_Bounty_Type_Approved__c=FIRST_NEW_ORDER_ONLY,       //Used in API Testing...  
                                 
                                 Voice_Penetration_LOSS__c=0,
                                 Voice_Penetration_WIN__c=0,
                 
                                 X1st_Year_of_Positive_EBITDA__c=444.9,
                                 X1st_Year_of_Positive_EBITDA_Offer__c=444.9,
                                 X1st_Year_of_Positive_FCF__c=444.11,
                                 X1st_Year_of_Positive_FCF_Offer__c=444.11
                                 );            
                 
             setsObjectFields(off, addFields);
             
             results.add(off);
         }
 
         testData.addAll((SObject[])results);
 
         if(autoCommit) 
         {
             commitTestData();        
         }
 
         return results;
     }
 
 
     
     /*
      * Params : 
      * addFields - map of sObject field/value that needs to be additionally set when the OFfer is created.
      * Returns : 
      * Offer     
     */    
 
     public static Offer__c updateOffer(Offer__c offr, map<sObjectField, Object> addFields) 
     {
         return updateOffers(offr, addFields)[0];
     }
     
     
     /*
      * Params : 
      * addFields - map of sObject field/value that needs to be additionally set when the OFfer is updated..
      * Returns : 
      * Offer     
     */    
     static Offer__c[] updateOffers(Offer__c ofr, map<sObjectField, Object> addFields) 
     {
         Offer__c[] results=new Offer__c[0];
 
         Offer__c off = new Offer__c(Id=ofr.Id, Alternate_Planner__c=u.id);            
                 
         setsObjectFields(off, addFields);            
         results.add(off);
     
         testData.addAll((SObject[])results);
 
         if(autoCommit) 
         {
             commitTestData2();       // Update
         }
 
         return results;
     }
 
 
     /*
      * Params : 
      * addFields - map of sObject field/value that needs to be additionally set when the CapDesign is created.
      * Returns : 
      * CapDesign
     */    
                  
     public static Capital_design__c createCapDesign(map<sObjectField, Object> addFields) 
     {
         return createCapDesigns(1, addFields)[0];         
     }
 
     /*
      * Params : 
      * howMany � the number of Offers that need to be created.
      * addFields - map of sObject field/value that needs to be additionally set when the CapDesign is created.
      * Returns : 
      * Array of CapDesign sObjects
     */    
 
     public static Capital_design__c[] createCapDesigns(Integer howMany, map<sObjectField, Object> addFields) 
     {
         Capital_design__c[] results=new Capital_design__c[0];
 
         while(results.size() < howMany) 
         {
             Capital_design__c capD = new Capital_design__c(
                                             //Access_Type__c='',
                                             
                                             Actual_Build_Out_Months__c=0,
                                             Aerial_12f__c=0,
                 
                                             //Alarm_Due_Date__c=0,
                                             
                                             Alerts_and_Messages__c='TEST',
                                             Are_there_IDF__c='No',
                                             ATC_Viability__c='Green',
                                             Backbone_Bore_1_25_c_3_in_4_c_864f__c=0,          
                                             Blended_Cost_from_FW__c=0,                        
                                             Bore_1_25_c_12f__c=0,
                                             Bore_1_25_c_96f__c=0,
                 
                                             //BRAIN_API_Call_Tracker_Master__c='',
                                             
                                             Brain_ID__c='Delta - BAU results',
                 
                                             //BRAIN_ID_Link_to_BRAIN_UI__c='<a href="https://brain-env1.lumen.com/ui/#/financial-analyses/Alpha - BAU results" target="_new">Alpha - BAU results</a>',
                                             
                                             Building_Style__c='Cottage CTL-ON',
                 
                                             //Bulk_Data_Speed_Profile_DL_UL__c='',
                                             //Bulk_Data_Type__c='',
                                             //Bulk_Video_Type__c='',
                                             //Bulk_Voice_Type__c='',
                                             
                                             Buried_w_Conduit_12f__c=50,
                                             Calculated_Expense__c=0,
                                             CALIX__c='Test',
                                             CapEx_Direct__c=444.3,
                                             CapEx_Total_Initial_Capital__c=0,
                                             Capital_Design_Stage__c='Capital Evaluation Complete',
                                             Capital_Design_Type__c='Standard',
                                             Capital_Summation__c=444.6,
                                             Cluster_ID__c='TEST',
                                             CO_Electronics__c=0,
                 
                                             //CO_Electronics_for_Cards_Only__c='',
                                             
                                             Cobble_Bore_1_25_c_864f__c=0,
                                             Cobble_Bore_1_25_c_96f__c=0,
                                             Cobble_Bore_1_25_c_in_4_c_864f__c=0,
                                             Comments__c='TEST',
 
                                             Communications_Wiring_Quantity_per_WAP__c=0,        // Used in API Testing... 
                 
                                             //Communications_Wiring_Type__c='None',               // Used in API Testing...
                                             
                                             Competitive_Justification__c='We are cool',
                                             
                                             //ConnectionReceivedId='',
                                             
                                             //ConnectionSentId='',
                                             Contact_Name__c='Joseph Doe',
                                             //Contact_Phone__c='555-999-5522',
                                             Core_Electronic_Cost__c=0,
                                             Core_Switch_Electronics__c=0,
                                             Costing_Change_Alert__c='TEST MESSAGE',
 
                                             //CreatedById=UserInfo.getUserId(),
                                             //CreatedDate=system.today(),      
                                             
                                             CTL_to_install_F4__c=false,
                                             Cumulative_Living_Units_Built__c=0,
                                             Cumulative_NPV__c=444.8,
                                             Cumulative_SF_Homes__c=0,
                                             Data_Bounty__c=0,
                                             Data_Penetration_LOSS__c=0,
                                             Data_Penetration_WIN__c=0,
 
                                             //Design_ID__c='CD-00000238',                 // Used in API Testing, This is AutoNumbered
 
                                             Developer__c='TEST',
                 
                                             //Developer_Type__c='',
                                             //Development_Name__c='<a href="/lightning/r/Property__c/a0A04000003PkIwEAK/view" target="_blank">SUTTON RIDGE PH 03</a>',
                                             //Development_Status__c='Greenfield',
                                             
                                             Direct_Buried_12f__c=50,
                                             Discounted_Payback_months__c=444.4,
                                             Distribution_F2__c=0,
                                             Distribution_Structure_Conduit__c=0,
                                             Does_project_require_a_Pole_move__c=false,
                                             Does_project_require_a_Road_move__c=false,
                                             Door_Fee__c=0,
                                             EBITDA_Margin__c=444.1,
                 
                                             //Edge_Planner__c='<a href="/lightning/r/User/0055e000006GPYm/view" target="_blank">Test P Planner</a>',
                                             //Edge_Planner_Dynamic_Email__c='',
                                             //Electronic_Vendor__c='',
                                             
                                             Ending_MRC__c=444.7,
 
                                             Endpoint_Type_building_architecture__c='MDF to Living Unit',      // Used in API Testing
                                             Entity_Type__c ='Q Fiber, LLC',
                                             //Exchange__c='',
                                             
                                             Existing_FDH__c=false,
                                             Existing_Feeder_Footage_Utilized__c=0,
                
                                             //Existing_Phases_are_Copper__c='',
                                             
                                             Expense_Input_Spread__c=0,
                                             Expense_Summation__c=444.12,
                                             F1_Aerial_10M_144f__c=0,
                                             F1_Bridge_Crossing_Cost__c=0,
                                             F1_Bridge_Crossing_of_nbr_25_ft_width__c=0,
                                             F1_Canal_Crossing_Cost__c=0,
                                             F1_Canal_Crossing_nbr_of_25_ft_width__c=0,
                 
                                             //F1_Cost_CobbleBore_1_25_c_in_4_c_864f__c=0,
                                             //F1_Cost_for_Aerial_10M_144f__c=0,
                                             //F1_Cost_for_Blended_Cost_from_FW__c=0,
                                             //F1_Cost_for_Cobble_Bore_1_25_c_864f__c=0,
                                             //F1_Cost_for_Custom_without_conduit__c=0,
                                             //F1_Cost_for_Direct_Buried_96f__c=0,
                                             //F1_Cost_for_Lateral_Bore_1_25_c_864f__c=0,
                                             //F1_Cost_for_Overpull_1_25_c_864f__c=0,
                                             //F1_Cost_for_Plow_2_c_48f__c=0,
                                             //F1_Cost_for_Rock_Bore_1_25_c_864f__c=0,
                                             //F1_Cost_for_RockBore1_25_c_in_4_c_864__c=0,
                                             //F1_Cost_for_Use_Existing_Spare__c=0,
                                             //F1_Cost_for_Use_Vacant_12f__c=0,
                                             
                                             F1_Cost_ft_for_Aerial_10M_144f__c=15,
                                             F1_Cost_ft_for_Blended_Cost_from_FW__c=13.41,
                                             F1_Cost_ft_for_Cobble_Bore_1_25_c_864f__c=44,
                                             F1_Cost_ft_for_Custom_without_conduit__c=0,
                                             F1_Cost_ft_for_Direct_Buried_96f__c=8.5,
                                             F1_Cost_ft_for_Lateral_Bore_1_25_c_864f__c=28,
                                             F1_Cost_ft_for_Overpull_1_25_c_864f__c=9.5,
                                             F1_Cost_ft_for_Plow_2_c_48f__c=8.06,
                                             F1_Cost_ft_for_Rock_Bore_1_25_c_864f__c=85.5,
                                             F1_Cost_ft_for_Use_Existing_Spare__c=0.22,
                                             F1_Cost_ft_for_Use_Vacant_12f__c=1.14,
                                             F1_Cost_ft_forCobbleBore1_25_c_in4_c_864__c=47,
                                             F1_Cost_ft_RockBore_1_25_c_in_4_c_864f__c=99,
                 
                                             //F1_CostBackboneBore_1_25_c_3_i_4_c864f__c=0,
                                             
                                             F1_Custom_without_conduit__c=0,
                                             F1_Direct_Buried_96f__c=0,
                 
                                             //F1_Feeder_Type__c='',
                                             //F1_Fiber_And_Conduit_Sub_Total__c=0,
                                             
                                             F1_Fiber_Conduit_Sub_Total_for_Cost__c=0,
                                             F1_Fiber_Conduit_Sub_Total_for_Cost_ft__c=0,
                                             F1_Fiber_Conduit_Sub_Total_for_Footage__c=0,
                 
                                             //F1_Footage_Cobble_Bore_1_25_c_in_4_c_864__c=0,
                                             //F1_Footage_for_Aerial_10M_144f__c=0,
                                             //F1_Footage_for_Blended_Cost_from_FW__c=0,
                                             //F1_Footage_for_Cobble_Bore_1_25_c_864f__c=0,
                                             //F1_Footage_for_Custom_without_conduit__c=0,
                                             //F1_Footage_for_Direct_Buried_96f__c=0,
                                             //F1_Footage_for_Lateral_Bore_1_25_c_864f__c=0,
                                             //F1_Footage_for_Overpull_1_25_c_864f__c=0,
                                             //F1_Footage_for_Plow_2_c_48f__c=0,
                                             //F1_Footage_for_Rock_Bore_1_25_c_864f__c=0,
                                             //F1_Footage_for_RockBore1_25_c_in_4_c_864__c=0,
                                             //F1_Footage_for_Use_Existing_Spare__c=0,
                                             //F1_Footage_for_Use_Vacant_12f__c=0,
                                             
                                             F1_Footage_ft__c=2500,
                                             F1_Highway_Crossing_Cost__c=0,
                                             F1_Highway_Crossing_nbr_of_12_ft_lane__c=0,
                                             F1_Joint_Trench_Custom_with_conduit__c=0,
                                             F1_Mobilization_Cost__c=0,
                                             F1_nbr_of_Handhole__c=0,
                                             F1_nbr_of_Pole__c=0,
                                             F1_nbr_of_Utility_Crossing__c=0,
                                             F1_Pole_Anchor_and_Guy_Cost__c=0,
                                             F1_Pole_Make_ready_Cost__c=0,
                                             F1_Pothole_Restoration_Cost__c=0,
                                             F1_Railroad_Crossing_Cost__c=0,
                                             F1_Railroad_crossing_nbr_of_8_ft_track__c=0,
                                             F1_Related_Cost_Sub_Total__c=5000,
                                             F1_Roadway_Crossing_Cost__c=0,
                                             F1_Roadway_Crossing_nbr_of_12_ft_lane__c=0,
                                             F1_Splicing_Testing_Cost__c=0,
                                             F1Cost_ft_JointTrench_Custom_withconduit__c=0,
                                             F1Cost_ftBackbonBore_1_25_c_3_in4_c864f__c=34,
                 
                                             //F1CostforTrench_Custom_with_conduit__c=0,
                                             //F1FootageBackbonBore_1_25_c_3_in4_c864f__c=0,
                                             //F1FootageTrench_Custom_with_conduit__c=0,
                                             
                                             F2_Aerial_10M_144f__c=0,
                
                                             //F2_Cost_for_Aerial_10M_144f__c=0,
                                             //F2_Cost_for_Bore_1_25_c_96f__c=0,
                                             //F2_Cost_for_Cobble_Bore_1_25_c_96f__c=0,
                                             //F2_Cost_for_Custom_without_conduit__c=0,
                                             //F2_Cost_for_Direct_Buried_96f__c=0,
                                             //F2_Cost_for_Place_Conduit_4_c__c=0,
                                             //F2_Cost_for_Pull_Fiber_96f__c=0,
                                             //F2_Cost_for_Rock_Bore_1_25_c_96f__c=0,
                                             //F2_Cost_for_Trench_4_c_96f__c=0,
                                             
                                             F2_Cost_ft_for_Aerial_10M_144f__c=15,
                                             F2_Cost_ft_for_Bore_1_25_c_96f__c=22.685,
                                             F2_Cost_ft_for_Cobble_Bore_1_25_c_96f__c=40.02,
                                             F2_Cost_ft_for_Custom_without_conduit__c=0,
                                             F2_Cost_ft_for_Direct_Buried_96f__c=6.8425,
                                             F2_Cost_ft_for_Place_Conduit_4_c__c=3.666,
                                             F2_Cost_ft_for_Pull_Fiber_96f__c=1.898,
                                             F2_Cost_ft_for_Rock_Bore_1_25_c_96f__c=82.247,
                                             F2_Cost_ft_for_Trench_4_c_96f__c=9.62,
                 
                                             //F2_Cost_Joint_Trench_Custom_withconduit__c=0,
                                             //F2_CostPlaceConduitPull_Fiber_4_c96f__c=0,
                                             
                                             F2_Custom_without_conduit__c=0,
                                             F2_Direct_Buried_96f__c=0,
                                             F2_FDH_size__c='64',
                 
                                             //F2_Fiber_Conduit_Placement_Sub_Total__c=0,
                                             
                                             F2_Footage_Aerial_10M_144f__c=0,
                                             F2_Footage_Bore_1_25_c_96f__c=0,
                                             F2_Footage_Cobble_Bore_1_25_c_96f__c=0,
                                             F2_Footage_Custom_without_conduit__c=0,
                                             F2_Footage_Direct_Buried_96f__c=0,
                                             F2_Footage_ft__c=0,
                                             F2_Footage_Place_Conduit_4_c__c=0,
                                             F2_Footage_PlaceConduitFiber_4_c_96f__c=0,
                                             F2_Footage_Pull_Fiber_96f__c=0,
                                             F2_Footage_Rock_Bore_1_25_c_96f__c=0,
                                             F2_Footage_Trench_4_c_96f__c=0,
                                             F2_Joint_Trench_Custom_with_conduit__c=0,
                                             F2_Mobilization_Cost__c=0,
                                             F2_nbr_of_Handhole__c=0,
                                             F2_nbr_of_IDF_locations__c=0,
                                             F2_nbr_of_Ped__c=0,
                                             F2_Pole_Anchor_and_Guy_Cost__c=0,
                                             F2_Pole_Make_Ready_Cost__c=0,
                                             F2_Pothole_Restoration_Cost__c=0,
                                             F2_Related_Cost_Sub_Total__c=8107.73282,
                 
                                             F2_Sub_Total_of_Cost__c=0,
                                             F2_Sub_Total_of_Cost_ft__c=0,
                                             F2_Sub_Total_of_Footage__c=0,
                                             F2Cost_ft_JointTrench_Custom_withconduit__c=0,
                                             F2Cost_ft_PlaceConduit_PullFiber_4_c_96f__c=5.564,
                                             F2FootageJointTrench_Custom_withconduit__c=0,
                                             F3_Avg_Drop_Length_ft__c='50',
                 
                                             //F3_Cost_for_Aerial_12f__c=0,
                                             //F3_Cost_for_Bore_1_25_c_12f__c=0,
                                             //F3_Cost_for_Buried_w_Conduit_12f__c=0,
                                             //F3_Cost_for_Direct_Buried_12f__c=0,
                                             //F3_Cost_for_Joint_Trench_Custom__c=0,
                                             //F3_Cost_for_Pull_Fiber_12f__c=0,
                                             //F3_cost_ft_direct_buried_12f__c=2.86,	
                                             //F3_Cost_ft_for_Aerial_12f__c=1.885,
                                             //F3_Cost_ft_for_Bore_1_25_c_12f__c=14.352,
                                             //F3_Cost_ft_for_Buried_w_Conduit_12f__c=6.266,
                                             //F3_Cost_ft_for_Joint_Trench_Custom__c=0,
                                             //F3_Cost_ft_for_Pull_Fiber_12f__c=1.989,
                                             
                                             F3_Fiber_Type__c='Buried',
                 
                                             //F3_Footage_For_Aerial_12f__c=0,
                                             //F3_Footage_For_Bore_1_25_c_12f__c=0,
                                             //F3_Footage_For_Buried_w_Conduit_12f__c=0,
                                             //F3_Footage_for_Direct_Buried_12f__c=0,
                                             //F3_Footage_For_Joint_Trench_Custom__c=0,
                                             //F3_Footage_For_Pull_Fiber_12f__c=0,
                                             //F3_Footage_for_Sub_total__c=0,
                                             
                                             F3_related_cost_for_slack_box_cost__c=0,
                                             F3_Related_cost_Sub_Total__c=0,
                                             F3_Slack_Box_Cost__c=0,
                 
                                             //F3_Sub_total__c=0,
                                             
                                             F3_Sub_total_For_cost__c=0,
                                             F3_Sub_total_for_Cost_ft__c=0,
                                             F4_Fiber_Type__c='No Drop',
                                             F4_Inside_Wiring_SFH__c=0,
                                             Feeder_F1_Access_and_or_PON__c=0,
                                             Feeder_Structure_Conduit__c=0,
                                             Financial_Viability__c='GREEN',
                                             Fireworks_Project__c='Test',
                 
                                             //First_Occupancy_Allowance_Days__c=0,
                                             //First_Occupancy_Date__c='',
                                             
                                             Footage_of_New_Feeder_Fiber_Built__c=0,
                                             for_MDU_nbr_of_Buildings__c=4,
                                             for_Midrise_Highrise_nbof_average_Floors__c=0,
                                             for_Retail_Take_rate__c=0,
                                             for_SFU_Average_Lot_Size__c='40',
                 
                                             //Gratis_Location_Data__c='Office and Recreation Area',
                                             //Gratis_Location_Video__c='',
                                             //Gratis_Requested__c='Yes',
                                             //Gratis_Units_Data__c=2,
                                             //Gratis_Units_Video__c=0,
 
                                             //Id='a01040000022jATAAY',
 
                                             Incremental_ATC_To_Meet_Guardrail__c=444.5,
                 
                                             //Initial_CO_Deployment_Fiber_Technology__c='',
                                             //Inside_Wiring__c='',
                                             
                                             Interoffice_Fiber_Cost__c=0.00,
                                             IRR__c=444.2,
                 
                                             //IsDeleted=false,
                                             
                                             Joint_Trench_Custom__c=0,
                 
                                             //Last_Associated_BRAIN_FA_Call__c='',
                                             //LastActivityDate='',
 
                                             //LastModifiedById=system.today(),
                                             //LastModifiedDate=system.today(),
                                             //LastReferencedDate=system.today(),
                                             //LastViewedDate=system.today(),
                                             
                                             Lateral_Bore_1_25_c_864f__c=0,
                 
                                             //Latitude__c=28.55761,
                                             //Longitude__c=-81.25584316,
                                             //Market__c='Central Florida',
                                             //Market_Condition__c='Normal Market Pace',
                 
                                             MDU_ONT_Drop__c=0,
                                             Media_Panel__c='Not needed',
 
                                             //Name='CD-00000237',                   // AutoNumbered
                                            
                                             nbr_of_Living_Units__c=500,
                                             Network_Investment__c='New Development',
                 
                                             //Network_Wire_Center__c='',
                                             
                                             NI_Engineer__c='test',
                 
                                             //No_GPON_No_Integrated_Switch__c='',
                                             
                                             NRMA_ID__c='Delta BAU NRMA',
                 
                                             NuF1_CostBackboneBore_1_25_c_3_i_4_c864f__c=0,
                                             NuF1_Footage_CobbleBore1_25_c_in_4_c_864__c=0,
                                             NuF1_Footage_for_Cobble_Bore_1_25_c_864f__c=0,
                                             NuF1_Footage_for_Custom_without_conduit__c=0,
                                             NuF1_Footage_for_Lateral_Bore1_25_c_864f__c=0,
                                             NuF1_Footage_for_RockBore1_25_cin4_c_864__c=0,
                                             NuF1FootageBackbonBore1_25_c_3_in4_c864f__c=0,
                                             NuF2_CostJoint_Trench_Custom_withconduit__c=0,
                                             NuF2_Fiber_Conduit_Placement_Sub_Total__c=0,
                                             Num_F1_Cost_for_Aerial_10M_144f__c=0,
                                             Num_F1_Cost_for_Blended_Cost_from_FW_c__c=0,
                                             Num_F1_Cost_for_Cobble_Bore_1_25_c_864f__c=0,
                                             Num_F1_Cost_for_Custom_without_conduit__c=0,
                                             Num_F1_Cost_for_Direct_Buried_96f__c=0,
                                             Num_F1_Cost_for_Lateral_Bore_1_25_c_864f__c=0,
                                             Num_F1_Cost_for_Overpull_1_25_c_864f__c=0,
                                             Num_F1_Cost_for_Plow_2_c_48f__c=0,
                                             Num_F1_Cost_for_Rock_Bore_1_25_c_864f__c=0,
                                             Num_F1_Cost_for_Use_Existing_Spare__c=0,
                                             Num_F1_Cost_for_Use_Vacant_12f__c=0,
                                             Num_F1_Fiber_And_Conduit_Sub_Total__c=0,
                                             Num_F1_Footage_for_Aerial_10M_144f__c=0,
                                             Num_F1_Footage_for_Blended_Cost_from_FW__c=0,
                                             Num_F1_Footage_for_Direct_Buried_96f__c=0,
                                             Num_F1_Footage_for_Overpull_1_25_c_864f__c=0,
                                             Num_F1_Footage_for_Plow_2_c_48f__c=0,
                                             Num_F1_Footage_for_Rock_Bore_1_25_c_864f__c=0,
                                             Num_F1_Footage_for_Use_Existing_Spare__c=0,
                                             Num_F1_Footage_for_Use_Vacant_12f__c=0,
                                             Num_F1CostforTrench_Custom_with_conduit__c=0,
                                             Num_F1FootageTrench_Custom_with_conduit__c=0,
                                             Num_F2_Cost_for_Aerial_10M_144f__c=0,
                                             Num_F2_Cost_for_Bore_1_25_c_96f__c=0,
                                             Num_F2_Cost_for_Cobble_Bore_1_25_c_96f__c=0,
                                             Num_F2_Cost_for_Custom_without_conduit__c=0,
                                             Num_F2_Cost_for_Direct_Buried_96f__c=0,
                                             Num_F2_Cost_for_Place_Conduit_4_c__c=0,
                                             Num_F2_Cost_for_Pull_Fiber_96f__c=0,
                                             Num_F2_Cost_for_Rock_Bore_1_25_c_96f__c=0,
                                             Num_F2_Cost_for_Trench_4_c_96f__c=0,
                                             Num_F2_CostPlaceConduitPull_Fiber_4_c96f__c=0,
                                             Num_F3_Cost_for_Aerial_12f__c=0,
                                             Num_F3_Cost_for_Bore_1_25_c_12f__c=0,
                                             Num_F3_Cost_for_Buried_w_Conduit_12f__c=0,
                                             Num_F3_Cost_for_Direct_Buried_12f__c=0,
                                             Num_F3_Cost_for_Joint_Trench_Custom__c=0,
                                             Num_F3_Cost_for_Pull_Fiber_12f__c=0,
                                             Num_F3_Footage_For_Aerial_12f__c=0,
                                             Num_F3_Footage_For_Bore_1_25_c_12f__c=0,
                                             Num_F3_Footage_For_Buried_w_Conduit_12f__c=0,
                                             Num_F3_Footage_for_Direct_Buried_12f__c=0,
                                             Num_F3_Footage_For_Joint_Trench_Custom__c=0,
                                             Num_F3_Footage_For_Pull_Fiber_12f__c=0,
                                             Num_F3_Footage_for_Subtotal__c=0,
                                             Num_F3_Sub_total__c=0,
                                             NumF1_Cost_CobbleBore_1_25_c_in_4_c_864f__c=0,
                                             NumF1_Cost_for_RockBore1_25_c_in_4_c_864__c=0,
                                             Occupant_Type__c='CONSUMER',
 
                                             //Offer__c='a0404000001SmTrAAK',                        // Used in API Testing    UPDATE THIS from OFFER object #. 
                                             
                                             OLT_non_shared_direct_Sub_cost__c=0.00,
                                             OLT_shared_Sub_cost__c=0.00,
                 
                                             //ONT_Location__c='',
                 
                                             ONT_Model__c='Calix-716GE-outdoor-FTTB',
                 
                                             OP_F1_Conduit_Sub_Cost_Comb_Cost__c=5000,
                                             OP_F1_Conduit_Sub_Cost_Cost_ft__c=2,
                                             OP_F1_Conduit_Sub_Cost_Cost_LU__c=10.00,
                                             OP_F1_Conduit_Sub_Cost_Unit__c=2500,
                 
                                             OP_F1_Fiber_Sub_Cost_Comb_Cost__c=28525,
                                             OP_F1_Fiber_Sub_Cost_Cost_ft__c=11.41,
                                             OP_F1_Fiber_Sub_Cost_Cost_LU__c=57.05,
                 
                                             OP_F1_Handhole_Sub_Cost_Comb_Cost__c=1236.5,
                                             OP_F1_Handhole_Sub_Cost_Cost_LU__c=2.473,
                                             OP_F1_Handhole_Sub_Cost_installation__c=650,
                                             OP_F1_Handhole_Sub_Cost_Material__c=510,
                                             OP_F1_Handhole_Sub_Cost_Overhead__c=76.5,
                                             OP_F1_Handhole_Sub_Cost_Unit__c=1,
                 
                                             OP_F1_Major_Cross_Sub_Cost_Comb_Cost__c=0,
                                             OP_F1_Pole_Anchor_Sub_Cost_Comb_Cost__c=0,
                                             OP_F1_Pole_Make_Ready_Sub_Cst_Comb_Cst__c=0,
                                             OP_F1_Pothole_Rest_Sub_Cost_Comb_Cost__c=0,
                                             OP_F1_Splicing_Sub_Cost_Comb_Cost__c=0,
                                             OP_F1_Total_Cost_Comb_Cost__c=39761.5,
                                             OP_F1_Total_Cost_Cost_ft__c=15.9046,
                                             OP_F1_Total_Cost_Cost_LU__c=79.523,
                 
                                             OP_F2_Conduit_Sub_cost_Combined_Cost__c=2800,
                                             OP_F2_Conduit_Sub_cost_Cost_ft__c=2,
                                             OP_F2_Conduit_Sub_cost_Cost_LU__c=5.6,                
                                             OP_F2_Conduit_Sub_cost_Unit__c=1400,
                 
                                             OP_F2_FDH_Sub_cost_Comb_Cost__c=14719.55,
                                             OP_F2_FDH_Sub_cost_Cost_LU__c=29.4391,
                                             OP_F2_FDH_Sub_cost_Installation__c=2050,
                                             OP_F2_FDH_Sub_cost_Material__c=11017,
                                             OP_F2_FDH_Sub_cost_Overhead__c=1652.55,
                                             OP_F2_FDH_Sub_cost_Sub_unit__c=144,
                                             OP_F2_FDH_Sub_cost_Unit__c=1,
                 
                                             OP_F2_Handhole_Sub_cost_Combined_Cost__c=1236.5,
                                             OP_F2_Handhole_Sub_cost_Cost_LU__c=2.473,
                                             OP_F2_Handhole_Sub_cost_Installation__c=650,
                                             OP_F2_Handhole_Sub_cost_Material__c=510,
                                             OP_F2_Handhole_Sub_cost_Overhead__c=76.5,
                                             OP_F2_Handhole_Sub_cost_Unit__c=1,
                 
                                             OP_F2_Horizontal_Fiber_Sub_cost_Cost_ft__c=7.387,
                                             OP_F2_Horizontal_Fiber_Sub_cost_Cost_LU__c=20.6836,
                                             OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c=10341.8,
                 
                                             OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c=1534.95,
                                             OP_F2_Ped_MST_AP_Sub_cost_Cost_LU__c=3.0699,
                                             OP_F2_Ped_MST_AP_Sub_cost_Installation__c=600,
                                             OP_F2_Ped_MST_AP_Sub_cost_Material__c=813,
                                             OP_F2_Ped_MST_AP_Sub_cost_Overhead__c=121.95,
                                             OP_F2_Ped_MST_AP_Sub_cost_Unit__c=3,
                 
                                             OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c=0,
                                             OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c=0,
                 
                                             OP_F2_Splicing_Sub_cost_Combined_Cost__c=4275,
                                             OP_F2_Splicing_Sub_cost_Cost_LU__c=8.55,
                                             OP_F2_Splicing_Sub_cost_Installation__c=4275,
                                             OP_F2_Splicing_Sub_cost_Overhead__c=0,
                                             OP_F2_Splicing_Sub_cost_Unit__c=150,
                 
                                             OP_F2_Splitter_Sub_cost_Combined_Cost__c=16998.3,
                                             OP_F2_Splitter_Sub_cost_Cost_LU__c=33.9966,
                                             OP_F2_Splitter_Sub_cost_Installation__c=2805,
                                             OP_F2_Splitter_Sub_cost_Material__c=12342,
                                             OP_F2_Splitter_Sub_cost_Overhead__c=1851.3,
                                             OP_F2_Splitter_Sub_cost_Sub_Unit__c=0,
                                             OP_F2_Splitter_Sub_cost_Unit__c=17,
                 
                                             OP_F2_Total_Cost_Combined_Cost__c=60013.83282,
                                             OP_F2_Total_Cost_Cost_LU__c=120.02766564,
                 
                                             OP_F2_Vertical_Fiber_Stub_Sub_cst_Inst__c=0,
                                             OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c=0,
                 
                                             OP_F2Mobi_engtime_prmt_flag_SBcst_CstLU__c=16.21546564,
                                             OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c=8107.73282,
                 
                                             OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c=0,
                 
                                             OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c=25495.98282,
                                             OP_F2SBcst_w_oF2Cond_FDH_Spltr_Cost_ft__c=18.2114163,
                                             OP_F2SBcst_w_oF2Cond_FDH_Spltr_Cost_LU__c=50.99196564,
                 
                                             OP_F2Vertical_Fiber_Stub_Sub_cst_Cst_LU__c=0,
                                             OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c=0,
                                             OP_F2VerticalFiber_Stub_Sub_cst_Material__c=0,
                                             OP_F2VerticalFiber_Stub_Sub_cst_Overhead__c=0,
                                             OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c=0,
                 
                                             OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c=0,
                                             OP_F3_Fiber_Drop_Sub_Cost_LU__c=0,
                 
                                             OP_F3_Fiber_Stub_Sub_Cost_Comb_Cost__c=4024.688,
                                             OP_F3_Fiber_Stub_Sub_Cost_Installation__c=2418,
                                             OP_F3_Fiber_Stub_Sub_Cost_LU__c=8.049376,
                                             OP_F3_Fiber_Stub_Sub_Cost_Material__c=1397.12,
                                             OP_F3_Fiber_Stub_Sub_Cost_Overhead__c=209.568,
                                             OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c=12,
                                             OP_F3_Fiber_Stub_Sub_Cost_Unit__c=4,
                 
                                             OP_F3_Slack_Box_Sub_Cost_Comb_Cost__c=0,
                                             OP_F3_Slack_Box_Sub_Cost_LU__c=0,
                 
                                             OP_F3_Total_Cost_Comb_Cost__c=4024.688,
                                             OP_F3_Total_Cost_LU__c=8.049376,
                 
                                             OP_F4_Total_Cost_Comb_Cost__c=0,
                                             OP_F4_Total_Cost_LU__c=0,
                 
                                             OP_ISP_Total_cost_Combined_Cost__c=36500,
                                             OP_ISP_Total_cost_Cost_LU__c=73,
                 
                                             OP_Media_Panel_Total_Cost_Comb_Cost__c=0,
                                             OP_Media_Panel_Total_Cost_Installation__c=0,
                                             OP_Media_Panel_Total_Cost_LU__c=0,
                                             OP_Media_Panel_Total_Cost_Material__c=0,
                                             OP_Media_Panel_Total_Cost_Overhead__c=0,
                                             OP_Media_Panel_Total_Cost_Unit__c=0,
                 
                                             OP_Mob_Sub_Cost_Comb_Cost__c=5000,
                 
                                             OP_OLT_Non_Shared_Sub_Cost_Comb_Cost__c=0,
                                             OP_OLT_Non_Shared_Sub_Cost_Cost_LU__c=0,
                                             OP_OLT_Shared_Sub_Cost_CombCost__c=36500,
                                             OP_OLT_Shared_Sub_Cost_Cost_LU__c=73,
                 
                                             OP_ONT_Total_Cost_Comb_Cost__c=68080.16,
                                             OP_ONT_Total_Cost_Installation__c=24980,
                                             OP_ONT_Total_Cost_LU__c=136.16032,
                                             OP_ONT_Total_Cost_Material__c=37478.4,
                                             OP_ONT_Total_Cost_Overhead__c=5621.76,
                                             OP_ONT_Total_Cost_Sub_Unit__c=125,
                                             OP_ONT_Total_Cost_Unit__c=128,
                 
                                             OP_Res_Gateway_Total_Cost_Comb_Cost__c=0,
                                             OP_Res_Gateway_Total_Cost_Installation__c=0,
                                             OP_Res_Gateway_Total_Cost_LU__c=0,
                                             OP_Res_Gateway_Total_Cost_Material__c=0,
                                             OP_Res_Gateway_Total_Cost_Overhead__c=0,
                                             OP_Res_Gateway_Total_Cost_Unit__c=500,
                 
                                             OP_Total_Cost_Comb_Cost__c=208380.18082,
                                             OP_Total_Cost_LU__c=416.76036164,
                 
                                             OP_UPS_Shelf_Total_Cost_Comb_Cost__c=0,
                                             OP_UPS_Shelf_Total_Cost_Installation__c=0,
                                             OP_UPS_Shelf_Total_Cost_LU__c=0,
                                             OP_UPS_Shelf_Total_Cost_Material__c=0,
                                             OP_UPS_Shelf_Total_Cost_Overhead__c=0,
                                             OP_UPS_Shelf_Total_Cost_Sub_Unit__c=0,
                                             OP_UPS_Shelf_Total_Cost_Unit__c=5,
                 
                                             //Open_Trench_Date__c='',
 
                                             //Opportunity__c='00604000006NyvoAAC',
 
                                             Opt_ISP_Total_Cost_Comb_Cost__c=0,
                                             Opt_OLT_Shared_Sub_Cost_Comb_Cost__c=0,
                                             Other_AC_Power_CAT_6_Expense__c=0,
                                             Other_MDU_F4__c=0,
                                             Overpull_1_25_c_864f__c=0,
                 
                                             //OwnerId=UserInfo.getUserId(),
                 
                                             Place_Conduit_4_c__c=0,
                                             Place_Conduit_and_Pull_Fiber_4_c_96f__c=0,
                                             Planned_Build_Out_Years__c=0,
                 
                                                //Planning_Adjustment__c='No Adjustment',
                                                
                                             Plow_2_c_48f__c=0,
                                             Population_Density__c='Rural',
                 
                                             //Primary_Descriptor_of_CO_Area__c='',
                                             //Project_Start_Year__c='',
                                             //Project_Title__c='SUTTON RIDGE PH 03',
                                             
                                             Project_Type__c='Greenfield',
                 
                                             //Property_Address_City__c='Orlando',
                                             //Property_Address_State__c='CO',  		//?? FL
                                             //Property_Address_Zip__c='32825',
                                             //Property_Street_Address__c=BRACKLIN_STREET_ADDR,
                                                                                       
                                             Pull_Fiber_12f__c=0,
                                             Pull_Fiber_96f__c=0,
                 
                                             //Region__c='West',
                                             
                                             Remote_Electronics__c=0,
                 
                                             //Remote_Electronics_for_Cards_Only__c='',
                                             //Requested_Bulk_Data_Price__c=0,
                                             //Requested_Bulk_Video_Price__c=0,
                                             //Requested_Bulk_Voice_Price__c=0,
 
                                             Responsible_for_Cable_Home_Wiring__c=COMPANY_TO_PROVIDE_AND_INSTALL,    // Used in API Testing...
                                             Responsible_for_Communications_Wiring__c='Company',
                                             Responsible_for_Home_Run_Wiring__c=COMPANY_TO_PROVIDE_AND_INSTALL,      // Used in API Testing...
                                             
                                             Rock_Bore_1_25_c_864f__c=0,
                                             Rock_Bore_1_25_c_96f__c=0,
                                             Rock_Bore_1_25_c_in_4_c_864f__c=0,
                 
                                             //Sales_Engineer__c='<a href="/lightning/r/User/0055e000006G8PY/view" target="_blank">Test SE Sales-Engineer-User</a>',
                                             //Sales_Engineer_Dynamic_Email__c='',
                                             //Service_Delivery__c='Instant Internet',
                                             
                                             Service_Type__c='CTL_ON',
                                             Show_FDH_Size__c=false,
                 
                                             //showSubmitToBRAIN__c=false,
                                             
                                             Simple_Payback_Months__c=444.1,
                                             Single_Family_Units_Input__c=0,
                                             State__c='FL',
                 
                                             //State_Cost_for_Capital_Design__c='',					// object:  StatesCostforCapitalDesign__c
                                             State_Name__c='CO',
                                             //SystemModstamp=system.today(),
 
                                             Technology_Diagram__c='FTTB',                           // Used in API Testing...
                                             Technology_Type__c='FTTB',                              // Used in API Testing...
                                             Telecom_Cable_Quantity_Per_Living_Unit__c=0,          // Used in API Testing...	
                                             
                                             Telecommunication_Cable_Types__c='CAT6 (or better)',  // Used in API Testing...
                                             
                                             Text_Capital_Design_Name__c='CD-00000079',
                                             
                                             //Total_Cottage_Owner_Units__c=0,
                                             //Total_Cottage_Rental_Units__c=500,
                                             //Total_Living_Units_in_Project__c=0,
                                             //Total_MDU__c=0,
                                             //Total_SFH_Owner_Units__c=0,
                                             //Total_SFH_Rental_Units__c=0,
                                             //Total_Single_Family_Homes__c=0,
                                             //Total_Tower_Owner_Units__c=0,
                                             //Total_Tower_Rental_Units__c=0,
                                             
                                             Transport_Interoffice_Fiber__c=0,
                                             Trench_4_c_96f__c=0,
                                             Tx_F2CostJointTrench_Custom_withconduit__c='',
                
                                             //Unit_Penetration_LOSS__c=0,
                                             //Unit_Penetration_WIN__c=0,
                                             Use_Existing_Spare__c=0,
                                             Use_Vacant_12f__c=0,
                                             //video_Market__c='',
                                             //Video_Penetration_LOSS__c=0,
                                             //Video_Penetration_WIN__c=0,
                                             //Voice_Bounty_Amount__c=5,
                                             //Voice_Penetration_LOSS__c=0,
                                             //Voice_Penetration_WIN__c=0,
                                             
                                             VP_Operations_Area__c='Test',
                                             
                                             //Wire_Center__c='ORLDFLER',

                                             Backboards_required__c='No',                                       // ESCJ-2270
                                             Exterior_Cabinets__c='No',                                         // ESCJ-2270
                                             NEMA_Rated_Cabinet__c='No',                                        // ESCJ-2270
                                             Number_of_Owner_Installed_Conduits__c='one (1)',                   // ESCJ-2270
                                             Responsible_for_Media_Panel__c=COMPANY_TO_PROVIDE_AND_INSTALL,     // ESCJ-2270
                                             SE_SOW_Additional_Company_Tasks_1__c='test',                       // ESCJ-2270
                                             SE_SOW_Additional_Company_Tasks_2__c='test2',                      // ESCJ-2270
                                             SE_SOW_Additional_Owner_Tasks_1__c='test3',                        // ESCJ-2507
                                             SE_SOW_Additional_Owner_Tasks_2__c='test4',                        // ESCJ-2507
                                             SE_SOW_Project_Scope__c='abcdefghi',                               // ESCJ-2270
                                             Size_of_Owner_Installed_Conduits__c='4 inch',                      // ESCJ-2270
                                             Responsible_for_In_unit_WAP_Wiring__c='Company',                   // ESCJ-2420

                                             X1st_Year_of_Positive_EBITDA__c=444.9,
                                             X1st_Year_of_Positive_FCF__c=444.11
                                             );            
                 
             setsObjectFields(capD, addFields);
             
             results.add(capD);
         }
 
         testData.addAll((SObject[])results);
 
         if(autoCommit) 
         {
             commitTestData();        
         }
 
         return results;
     }
 
     
     /*
      * Params : 
      * Portfolio can have a Related_Account__c. 					So Account needs to be created before hand.
      * Portfolio can have a Lead_Capital_Design_Shared__c Assoc.	So Capital Design need to be created after Portfolio.
      * Portfolio has a Contract Lookup.  							So Contract needs to be created before hand.
      * Portfolio can hook to Offer.									Offer can be updated to use Portfolio #
      * addFields - map of sObject field/value that needs to be additionally set when the Porfolio__c is created. 
      * Returns :
      * Portfolio__c
     */
     public static Portfolio__c createPortfolio(map<sObjectField,Object> addFields) 
     {
         return createPortfolios(1, addFields)[0];
     }
 
     /*
      * Params : 
      * Portfolio can have a Related_Account__c. 					So Account needs to be created before hand.
      * Portfolio can have a Lead_Capital_Design_Shared__c Assoc.	So Capital Design need to be created after Portfolio.
      * Portfolio has a Contract Lookup.  							So Contract needs to be created before hand.
      * Portfolio can hook to Offer.									Offer can be updated to use Portfolio #
      * howMany � the number of portfolios that need to be created per account specified by the param accountIds.     
      * addFields - map of sObject field/value that needs to be additionally set when the Portfolio__c is created.
      * Returns : 
     */    
     
     public static Portfolio__c[] createPortfolios(Integer howMany, map<sObjectField,Object> addFields) 
     {
         
         Portfolio__c[] results=new Portfolio__c[0];
         
         while(results.size() < howMany) 
         {
             Portfolio__c port = new Portfolio__c(
                    Capital_Design_Needed_Record_Count__c=0,				
                 // Contract__c='',
                 Contracted_Offer_Count__c=0,
                 //CreatedById=UserInfo.getUserId(),
                 //Executive_Presentation_Required__c='No',  // Not writeable.
                 
                 Expired_Offer_Count__c=0,
                 
                 //LastModifiedById=UserInfo.getUserId(),
                 
                 // Lead_Capital_Design_Shared__c='',
                 
                 //Name='PF-0000013',			// Fed in via Parms....
                 Offers_In_Won_Lost_Opportunities__c=0,
                 OwnerId=u.Id,				
                 
                 //Portfolio_Assigned_Analyst__c='',
                 //Portfolio_Assigned_Analyst_Date__c='',
                 
                 Portfolio_Brain_ID__c='',
                 Portfolio_Contract_Requested__c='No',
                 Portfolio_Contract_Terms__c='12',
                 Portfolio_Documentation_Required__c='No',
                 Portfolio_Modification_Count_Pricing__c=0,
                 Portfolio_Modification_Count_Support__c=0,	                
                 Portfolio_Modification_Notes_Pricing__c='',
                 Portfolio_Modification_Notes_Support__c='',
                 Portfolio_Modification_Status__c='Additional Documentation Required',
                 Portfolio_Name__c='Scott P.Kuehl Portfolio' + system.today(),
                 Portfolio_Offer_Weight__c=0.00,
                 //Portfolio_Per_Unit_Cost__c=0.00,
                 //*Portfolio_Sales_Accepted_By__c='',
                 //Portfolio_Sales_Accepted_Date__c='',
                 Portfolio_Status__c='Open',
                 Portfolio_Strategy__c='Collective Wins',
                 
                 Portfolio_Total_Approved_Investment__c=0.00,
                 Portfolio_Total_Capital_Expense__c=0.00,
                 Portfolio_Total_Investment__c=0.00,
                 Portfolio_Total_Requested_Investment__c=0.00,
                 Portfolio_Total_Units__c=0,
                 Portfolio_Type__c='Standard Portfolio',
                 //PowerPoint_Required__c='No',
                 //Related_Account__c='',
                 Shared_Capital_Design__c='No'
                 //SystemModstamp=system.today()				           
                  );
 
             setsObjectFields(port, addFields);
 
             results.add(port); 
         }
 
         testData.addAll((SObject[])results);
          
         if(autoCommit) 
         { 
             commitTestData();
         }
         
         return results;
     }               
     
     
     
     
     
 
     
     /*
      * Params : 
      * accountRecord � parent account to which the contract is associated to.
      * addFields - map of sObject field/value that needs to be additionally set when the Contract is created. 
      * Returns :
      * Contract_
     */
     public static Contract createContract(map<sObjectField,Object> addFields) 
     {
         return createContracts(1, addFields)[0];
     }
 
     /*
      * Params : 
      * howMany � the number of contacts that need to be created per account specified by the param accountIds.
      * accountIds � a set of account id�s.
      * addFields - map of sObject field/value that needs to be additionally set when the Contract is created.
      * Returns : 
     */    
 
     public static Contract[] createContracts(Integer howMany, map<sObjectField,Object> addFields) 
     {
         
         Contract[] results=new Contract[0];
         
         while(results.size() < howMany) 
         {
             Contract con = new Contract(
                                     //AccountId=0010400001CAc3fAAD,
                                     //ActivatedById='',
                                     //ActivatedDate='',
                                     
                                     Addl_Information_Required_Date__c=system.today(),
                                     Address_for_Notices__c=BRACKLIN_STREET_ADDR,
                                     Address_Form_Bulk_Order_Form_Received__c=false,
                                     
                                     //Assigned_Contract_Admin__c='',
                                     
                                     Auto_Renew__c=false,
                                     Auto_Renew_Period_months__c=0,
                 
                                     //BillingAddress='',
                                     
                                     BillingCity='',
                                     BillingCountry='',
                 
                                     //BillingGeocodeAccuracy='',
                                     
                                     BillingLatitude=0,
                                     BillingLongitude=0,
                                     BillingPostalCode='',
                                     BillingState='FL',
                                     BillingStreet='',
                                     City_for_Notices__c='Orlando',
                                     CJ_Staging_Record_ID__c=282,
                 
                                     //CLM_Contract_ID__c='',
                 
                                     //CLM_Contract_Link__c='',
                                     
                                     CLM_Transmission_Code__c=200,
                 
                                     //CLM_Transmission_Message__c='CLM Record Creation Successfully',
                                     //CompanySignedDate=system.today(),
                                     //CompanySignedId='',
                                     
                                     Contract_Approval_Process_Start_Date__c=system.today(),
                                     Contract_Executed_Date__c=system.today(),
                                     Contract_Lifecycle_Status__c='Cancelled',
                 
                                     //Contract_Message__c='You cannot generate a standard contract because this contract request has been cancelled.',
                                     //Contract_Request_Age__c=99999,
                                     
                 			         Contract_Request_Cancelled_Date__c=system.today(),
                                     Contract_Request_Date__c=system.today(),
                 
                                     //Contract_Request_ID__c=CR-00000119,
                                     
                                     Contract_Request_In_Progress__c=system.today(),
                                     Contract_Request_Offer_Notes__c='Testing',
                                     Contract_Request_Status_Notes__c='Test Notes la la la',
                                     Contract_Status__c='Contract Request Cancelled',
                                     Contract_Status_Compact__c='Requested',
                                     Contract_Status_Last_Modified__c=system.today(),
                 
                                     //Contract_Template_to_Use__c='ASA-GF',
                                     
                                     Contract_Transmitted_Date__c=system.today(),
                 
                                     //ContractNumber=CR-00000219,
                                     
                                     ContractTerm=120,
                                     
                                     //Copy_To_Email__c='abc.com',
                                     
                                     Copy_To_Name__c='abc',
                 
                                     //CreatedById=User.getId(),
                                     //CreatedDate=system.today(),                                    
                                     //CustomerSignedDate=system.today(),
                                     
                                     //CustomerSignedId='',
                                     
                                     CustomerSignedTitle='',
                 
                                     //Days_for_Approval_Process__c=0,
                                     //Days_in_Redline__c=0,
                                     //Days_in_Redline_Process_Bus__c=0,
                                     //Days_to_Execute_Bus__c=0,
                                     //Days_to_Start_Contract_Req_Review_Bus__c=0,
                                     //Days_to_Transmit_Bus__c=0,
                                     //Days_Total_Contract_Request_Bus__c=0,
                                     
                                     Deposit_Forms_Accepted__c=false,
                                     Description='abcdefgh',
                 
                                     //Development_Status__c='Greenfield',
                 
                                     //Email_Address_for_Notices__c='',
                 
                                     //EndDate='',
                                     
                                     External_Queue_Priority__c=system.today(),
                                     Gratis_Form_Processed__c=false,
                 
                                     //Id=800040000001NY1AAM,  // created when object is created..
                                     
                                     Internal_Queue_Priority__c=system.today(),
                 
                                     //IsDeleted=false,                                    
                                     //LastActivityDate='',
                                     //LastApprovedDate='',
                                     //LastModifiedById=User.getId(),
                                     //LastModifiedDate=system.today(), 
                                     //LastReferencedDate=system.today(), 
                                     //LastViewedDate=system.today(), 
                                     
                                     Name='asdasdfadsf',
                 					 Needs_CLM_Record_Cancelled__c=false,
                 
                                     //Next_Auto_Renew_Date__c=system.today(),
                                     //Offer__c=a0404000001SmTrAAK,  			// Passed in...                                    
                                     //Offer_Type__c='Exclusive Marketing',
                                     //Opportunity__c=00604000006NyvoAAC,  		// Passed in...
                                     //Opportunity_Owner__c='<a href="/lightning/r/User/0055e000003hS0E/view" target="_Top">Raymond Capetillo</a>',
                                     //Opportunity_Property_Name__c='<a href="https://connectedlumn--cjdev1.lightning.force.com/lightning/r/a0A04000003PkIw/view" target="_blank">SUTTON RIDGE PH 03</a>',
                                     
                                     //OwnerExpirationNotice='',         
                                                                
                                     Person_Designated_for_Notices__c='',
                 
                                     //Pricebook2Id='',
                                     
                                     //Portfolio__c='',
                                     
                                     Pricing_Offered__c='',
                 
                                     //Property_Address_City__c='Orlando',
                                     //Property_Address_State__c='FL',
                                     //Property_Address_Street__c=BRACKLIN_STREET_ADDR,
                                     //Property_Address_Zip__c='32825',
                                     //Property_Lookup__c='',
                                     
                                     Ready_for_Signature__c=false,                                    
                                     Redline_External_Start_Date__c=system.today(),
                                     Redline_Internal_Start_Date__c=system.today(),
                                     Redline_Version__c=0,
                                     Redline_Version_Returned__c=false,
                 
                                     //Related_Offer__c='<a href="/lightning/r/Offer__c/a0404000001SmTr/view" target="_blank">OR-0000253</a>',
                                     
                                     Request_Contract_Cancellation__c=false,                                    
                 
                                     //ShippingAddress='',
                                     
                                     ShippingCity='',
                                     ShippingCountry='',
                 
                                     //ShippingGeocodeAccuracy='',
                                     
                                     ShippingLatitude=0,
                                     ShippingLongitude=0,
                                     ShippingPostalCode='',
                                     ShippingState='FL',
                                     ShippingStreet='',
                                     Special_Contract_Template__c='',
                                     SpecialTerms='',
                                     SSA_Assigned__c=system.today(),
                                     SSA_Job_Complete__c=false,
                 
                                     //StartDate='',
                                     //State_for_Notices__c='',
                                     
                                     Status='Draft',
                 
                                     //StatusCode='Draft',
                                     //SystemModstamp=system.today(),
                                     //Telephone_for_Notices__c='',
                                     //Total_Units__c=101,
                                     
                                     W9_Processed__c=false,
                                     ZipCode_for_Notices__c=''
                                     );
 
             setsObjectFields(con, addFields);
 
             results.add(con);
         }
 
         testData.addAll((SObject[])results);
          
         if(autoCommit) 
         { 
             commitTestData();
         }
         
         return results;
     }
 
 
 
 
     
     
     
     
     
 
     /*
      * Params : 
      * productId - Opportunity Product Id
      * pricebookId - pricebook Id
      * addFields - map of sObject field/value that needs to be additionally set when the pricebookentry is created.
      * Returns : 
      * PriceBookEntry
     */    
     public static PricebookEntry createPricebookEntry(id productId,id pricebookId,map<sObjectField,Object> addFields)
     {
         PriceBookEntry pbe = new PricebookEntry(Product2Id = productId,Pricebook2Id = pricebookId,IsActive = true, UnitPrice=50.0);
     
         setsObjectFields(pbe,addFields);
     
         testData.add(pbe);
     
         if(autoCommit) 
         {
             commitTestData();
         }
 
         return pbe;
     }
     
     /*
      * Params : 
      * accountRecord � parent account to which the Service_Location__c is associated to.
      * addFields - map of sObject field/value that needs to be additionally set when the record is created. 
      * Returns :
      * Service_Location__c 
     */
     public static Service_Location__c createServiceLocation(Account accountRecord,map<sObjectField,Object> addFields)
     {
         return createServiceLocations(accountRecord, 1,addFields)[0];
     }
     
     public static Service_Location__c[] createServiceLocations(Account accountRecord, Integer howMany,map<sObjectField,Object> addFields) 
     {
         Service_Location__c[] results=new Service_Location__c[0];
     
         while(results.size() < howMany) 
         {
             Service_Location__c lServLoc = new Service_Location__c(
                                                     Location_Address__c='' + Math.mod(DateTime.now().getTime(), 100000) + ' Nash St',  
                                                     Customer_Billing_Address_City__c='New Haven', 
                                                     Customer_Billing_Address_State__c='CT', 
                                                     Customer_Billing_Address_Zip__c='06511',                                                                                                        
                                                     Name = 'Arm Pit of New England'                                                    
                                                     );
                             
             setsObjectFields(lServLoc,addFields);
             
             results.add(lServLoc);
         }
 
         testData.addAll((SObject[])results);
         
         if(autoCommit) 
         {
            commitTestData();
         }
         
         return results;
     }
     
     
     /*
      * Params:
      * addFields - map of sObject field/value that needs to be additionally set when the record is created.
      * Returns :
      * Task
     */
     public static Task createTaskStandard(map<sObjectField,Object> addFields)
     {
         Task task = new Task ();
     
         setsObjectFields(task,addFields);
     
         testData.add(task);
     
         if(autoCommit) 
         {
            commitTestData();
         }
     
         return task;
     }
         
     
     /*
      * Params: 
      * act - Account to which the Case is associated
      * con - Contact to which the Case is associated
      * recordtypeName - Name of the recordtype for Case creation
      * addFields - map of sObject field/value that needs to be additionally set when the record is created.
      * Returns :
      * Case
     */
     public static Case createCase(Account act, contact con, string recordtypeName,map<sObjectField,Object> addFields) 
     {
         return createCases(1, act, con, recordTypeName, addFields)[0];
     }
     
      /*
      * Params: 
      * howMany - the number of Cases to be created
      * act - Account to which the Case is associated
      * con - Contact to which the Case is associated
      * recordtypeName - Name of the recordtype for Case creation
      * addFields - map of sObject field/value that needs to be additionally set when the record is created.
      * Returns :
      * Case
     */    
     public static Case[] createCases(Integer howMany, Account act, contact con, string recordtypeName, map<sObjectField,Object> addFields)
     {        
         Case[] results = new Case[0];
          
         while(results.size() < howMany) 
         {
             Case c = new Case(
                         AccountId = act.Id, 
                         Origin = 'Portal',                 		
                         Subject=Level3Utils.randomString(5));
             
             if (con <> null) 
             {
                c.ContactId = con.Id;
             }
             
             setsObjectFields(c,addFields);
                         
             results.add(c);
         }
 
         
         testData.addAll((SObject[])results);
         
        
         if(autoCommit) 
         {
            commitTestData();
         }
         
         return results;        
     }
 }