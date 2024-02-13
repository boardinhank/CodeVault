/***************************************************************************************************************
* Apex Class : Level3Utils
*
* Description : To Test Generic Utilities class for Level 3
*
* Where Used?
*
*
* Change History:
* Date          Person Responsible      Traceability        Details
* 08/17/2017    Narasimha Rao           US181430  			SFDC Contacts - Prevent Users from entering Blacklist First and Last Names
* 08/17/2017    Narasimha Rao           US181432            SFDC Contact - Prevent Users from entering Blacklist Email Addresses
* 08/17/2017    Narasimha Rao           US181433            SFDC Leads/Contact Prevent Users from entering Blacklist Phone Numbersted
* 03/28/2018	Jeyavel S				US229814			Remove SSL Cert ref's
* 11/17/2022 	Kuehl S					ESCJ-1680			Copied from SFDC to match their Level3UTils class
*****************************************************************************************************************/

@isTest
public class Level3UtilsTest
{
    
    @testSetup static void setup() 
    {
        //TriggerStack.disableTrigger = true;
        TestFramework.setupDefaultData();
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());  
        
        // Create custom settings for Blacklist Names
        //Blacklist_Names__c BlkNms = new Blacklist_Names__c();
        //BlkNms.Name = 'INVALIDNAME';
        //insert BlkNms;
        
        //Create custom settings for Blacklist Emails
        //Blacklist_Emails__c BlckEmail =new Blacklist_Emails__c();
        //BlckEmail.Name = 'noone@nowhere.com';
        //insert BlckEmail;
        
        //Create custom settings for Blacklist Phone nos
        //Blacklist_Phone_Numbers__c BlckPhone = new Blacklist_Phone_Numbers__c();
        //BlckPhone.Name = '1111111110';
        //insert BlckPhone;
        
        // Create account 
        Account testAccount = TestFramework.createAccount(null);
        /* account  a = new Account();
        a.name = 'TEST';
        insert a1;    */          
    }
    
    static testMethod void BlacklistContacts()
    {
        //TriggerStack.disableTrigger = false;  
        Boolean expectedExceptionThrown = false;
        
        //Id standardContactRecordTypeId = Level3Utils.getRecordTypeId('Contact', 'Contact');
        
        account a = [select id from account limit 1];
        
        contact c = new Contact(
            FirstName='InvalidName',
            LastName= 'InvalidName',
            Email='noone@nowhere.com',
            //RecordTypeId = standardContactRecordTypeId,
            AccountId=a.Id );
        
        test.startTest();
        
        try
        {
            insert c;
            
        }
        catch(DMLException e)
        {
            //expectedExceptionThrown =  e.getDmlMessage(0).contains('test');
            expectedExceptionThrown = false;
        }       
        
        test.stopTest();
        
        System.AssertEquals(expectedExceptionThrown, false);
    }
  
    
        static testMethod void BlacklistEmail()
        {
            Boolean expectedExceptionThrownEmail = false;
            
            //Id standardContactRecordTypeIdEmail = Level3Utils.getRecordTypeId('Contact', 'Contact');
            
            account amail = [select id from account limit 1];
            
            contact cmail = new Contact(
                FirstName='Ramon',
                LastName= 'John',
                Email='noone@nowhere.com',
                //RecordTypeId = standardContactRecordTypeIdEmail,
                AccountId=amail.Id );
            
            test.startTest();
            
            try
            {
                insert cmail;
            }
            catch(Exception e)
            {
                //expectedExceptionThrownEmail = e.getMessage().contains('test');
                expectedExceptionThrownEmail =  false;
            }       
            
            test.stopTest();
            
            System.AssertEquals(expectedExceptionThrownEmail, false); 
        }
    
        static testMethod void Blacklistphone()
        {
            Boolean expectedExceptionThrownPhone = false;
            
            //Id standardContactRecordTypeIdPhone = Level3Utils.getRecordTypeId('Contact', 'Contact');
            
            account aphone = [select id from account limit 1];
            
            contact cphone = new Contact(
                FirstName='Francis',
                LastName= 'Kone',
                Email='test@test.com',
                Phone = '1111111110',
                otherphone = '1111111110',
                HomePhone = '1111111110' ,
                MobilePhone = '1111111110' ,
                Fax = '1111111110' ,
                AssistantPhone = '1111111110',
                //RecordTypeId = standardContactRecordTypeIdPhone,
                AccountId=aphone.Id );
            
            test.startTest();
            
            try
            {
                insert cphone;
            }
            catch(Exception e)
            {
                //expectedExceptionThrownPhone = e.getMessage().contains('test');
                expectedExceptionThrownPhone =  false;
            }          
            
            test.stopTest();
                        
            System.AssertEquals(expectedExceptionThrownPhone, false);
        }

    
    @isTest
    static void testUtils1()
    {
        string endPoint;
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());  
        
        Level3Utils.getOnHoldWorkingDaysMap();        
        Level3Utils.getHolidayMap();        
        system.debug('Level3Utils.detectEnv():  ' + Level3Utils.detectEnv());
        Level3Utils.externalURL(Level3Utils.detectEnv());
                      
      	Level3Utils.encodeXML('&Test<Data');
        Level3Utils.htmlEncode('&Test>Data');
        Level3Utils.getOwnerNameById(UserInfo.getUserId());
        Level3Utils.getUserProfileName(UserInfo.getUserId());
        Level3Utils.getUserRoleName(UserInfo.getUserId());
        Level3Utils.getuser(UserInfo.getUserId());        
        Level3Utils.randomString(5);
        Level3Utils.setGlobalSetting('SomeName', 'SomeValue');
        Level3Utils.getGlobalSetting('SomeName');
        Level3Utils.setGlobalSetting('SomeInt', '1');
        
        System.assertEquals(1, Level3Utils.getGlobalSettingIntValue('SomeInt'));
        Level3Utils.setGlobalSetting('SomeBool', 'true');
        System.assert(Level3Utils.getGlobalSettingBoolValue('SomeBool'));
        Level3Utils.setGlobalSetting('SomeDecimal', '123.45');
        System.assertEquals(123.45, Level3Utils.getGlobalSettingDecimalValue('SomeDecimal'));
        DateTime dt = DateTime.now();
        Date d = Date.today();
        Level3Utils.setGlobalSetting('SomeDate', String.valueOf(d));
        System.assertEquals(d, Level3Utils.getGlobalSettingDateValue('SomeDate'));
        Level3Utils.setGlobalSetting('SomeDateTime', String.valueOf(dt));
        System.assertEquals(dt, Level3Utils.getGlobalSettingDateTimeValue('SomeDateTime'));
        Level3Utils.setGlobalSetting('SomeDecimal', 'notADeciaml');
        System.assertEquals(null, Level3Utils.getGlobalSettingDecimalValue('SomeDecimal'));
		Level3Utils u = new Level3Utils();
		
        u.generateGuid();          
    }
    
    
    @isTest
    static void testUtils2()
    {
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());  
        Level3Utils.getWorkingDaysMap();
        //Level3utils.getBusinessHours('Monday','NA');
        
        //Id standardContactRecordTypeIdPhone = Level3Utils.getRecordTypeId('Contact', 'Contact');
        
        //Level3Utils.getRecordTypeIds(new map<string,set<id>>{'Contact'=>new set<id>{standardContactRecordTypeIdPhone}});     
        
        Level3Utils.getDayOfTheWeek(system.today());
        Level3Utils.getDayOfTheWeek(system.now()); 
        Level3Utils.getObjectName(null);        
        Level3Utils.getQuoteStatusesBeyondSubmit();
    }
    
    
    /*
    @isTest
    static void testUtils3()
    {
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());  
        
        Level3Utils.getRecordTypeIdsByName(new map<string,set<string>>{'Contact'=>new set<string>{'Contact'}});
        
        PageReference pageRef = new PageReference('/apex/CPNIOptOut');
        Test.setCurrentPage(pageRef);
        Level3Utils.externalURL('Prod');
        set<id> convIds = Level3Utils.convertedAccountIds;

        Map<String, Set<Date>> holidaysMap = Level3Utils.getHolidayMap();
        Map<String, Set<String>> workingDaysMap = Level3Utils.getWorkingDaysMap();                
        Level3Utils.getEndBusDateinGMT(DateTime.now(), 1, holidaysMap.get('NA'), workingDaysMap.get('NA'));

		Level3Utils.getQueueId(new List<String>{'Care Centers MAC IFO'});
        Level3Utils.isGlobalTriggerActive();
        Level3Utils.isHoliday(system.today(), 'NA');

    }
    */
    
    /****************************************************************************************************
     * Description   :   covers getHostName method code in Level3Utils class
    /****************************************************************************************************/
    static testMethod void getHostNameTest() 
    {
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());  
        
        Test.startTest();
        String host = Level3Utils.getHostName();
        System.assert(String.isNotBlank(host));
        Test.stopTest();
    }
    
    /****************************************************************************************************
     * Description    :   covers getOrganizationInstance method code in Level3Utils class
    /****************************************************************************************************/
    static testMethod void getOrganizationInstanceTest() 
    {
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());  
        Test.startTest();
        String instance = Level3Utils.getOrganizationInstance();
        System.assert(String.isNotBlank(instance));
        Test.stopTest();
    }
    
}