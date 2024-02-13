@isTest
public class AzureUserRoleSyncTest {
    public static final String TEST_ROLE = 'SFCJ-Legal';
    public static final String TEST_ID = 'f94fbd53-c13d-4d53-9879-1f71a8361b40';
    @isTest
    static void mock_test() {
        Test.setMock(HttpCalloutMock.class, new AzureUserRoleSyncMock());
        Profile p = [
            SELECT 
                Id 
            FROM Profile 
            WHERE Name = 'Standard User'
        ]; 
        User u = new User(
            UserName = '4r658756fdgffgrstandarduser@testorg.com',
            Alias = '🔌standt',
            Email = '4r658756fdgffgrstandarduser@testorg.com', 
            Azure_ObjectID__c = TEST_ID,
            Azure_Role__c = 'SFCJ-Developer',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey = 'America/New_York'
        );
        insert u;
        AzureUserRoleSync.UserContextWrapper wrapper = new AzureUserRoleSync.UserContextWrapper();
        wrapper.userId = u.Id;
        Test.startTest();
            AzureUserRoleSync.syncRoles(
                new List<AzureUserRoleSync.UserContextWrapper>{
                    wrapper
                }
            );
        Test.stopTest(); 
        User expectedUser = [
            SELECT 
                Azure_Role__c
            FROM User
            WHERE Id = :u.Id         
        ];
        System.assertEquals(
            TEST_ROLE, 
            expectedUser.Azure_Role__c, 
            'The expected role is wrong'
        );
    }
    @isTest
    static void mock_test_async() {
        Test.setMock(HttpCalloutMock.class, new AzureUserRoleSyncMock());
        Profile p = [
            SELECT 
                Id 
            FROM Profile 
            WHERE Name = 'Standard User'
        ]; 
        User u = new User(
            UserName = '4r658756fdgffgrstandarduser@testorg.com',
            Alias = '🔌standt',
            Email = '4r658756fdgffgrstandarduser@testorg.com', 
            Azure_ObjectID__c = TEST_ID,
            Azure_Role__c = 'SFCJ-Developer',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Testing', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US',
            ProfileId = p.Id, 
            TimeZoneSidKey = 'America/New_York'
        );
        insert u;
        AzureUserRoleSync.UserContextWrapper wrapper = new AzureUserRoleSync.UserContextWrapper();
        wrapper.userId = u.Id;
        wrapper.isAsync = true;
        Test.startTest();
            AzureUserRoleSync.syncRoles(
                new List<AzureUserRoleSync.UserContextWrapper>{
                    wrapper
                }
            );
        Test.stopTest(); 
        User expectedUser = [
            SELECT 
                Azure_Role__c
            FROM User
            WHERE Id = :u.Id         
        ];
        System.assertEquals(
            TEST_ROLE, 
            expectedUser.Azure_Role__c, 
            'The expected role is wrong'
        );
    }
}