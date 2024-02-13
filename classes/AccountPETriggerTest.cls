/***************************************************************
AUTHOR     DATE         Reference     Description (TestClass)
Ross F   01/30/2023     FSDP-101433    Test class for Platform Event Trigger, Platform Event Utility and Account Trigger updates for platform events
***************************************************************/
@isTest
public with sharing class AccountPETriggerTest {
    
    @isTest
    public static void updateAccountTest() {

        Test.setMock(HttpCalloutMock.class, new PlatformEventMock());
        
        Account tAcct = new Account(Name='Test Account Name', Account_Status__c='Under Review');
        insert tAcct;

        tAcct = [Select Id, Name, Account_Status__c, Account_Number__c From Account Limit 1][0];
        System.debug('acct num: '+ tAcct.Account_Number__c);
        Account_MDM__e acctEvent = new Account_MDM__e(Account_Number__c=tAcct.Account_Number__c, 
                                                Website__c='abc.com');

        Test.startTest();
            Database.SaveResult sr = EventBus.publish(acctEvent);
        Test.stopTest();

        Account acct = [Select Id, Website From Account Limit 1][0];
        Assert.areEqual('abc.com', acct.Website, 'We expect the fields to be updated after Platform Event trigger sync');
    }

    private class PlatformEventMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            HTTPResponse res = new HTTPResponse();
            API_Util__mdt MDT_BRAND = API_Util__mdt.getInstance('SolicitVerification');
            String externalEndpoint = MDT_BRAND.Name_Endpoint__c;
            String body = '';
            if(req.getEndpoint().contains(externalEndpoint)){
                body = '{\"emailOptOut\": \"Y\",\"tnOptOut\": \"Y\",\"emailDivestetureOptOut\": \"Y\", \"nameDivestetureOptOut\": \"Y\"}';
                res.setBody(body);
            }else{
                body = '{\"payload\": {\"Id\": \"0013j000039RbKMAA0\",\"ReplayId\": \"94686126\",\"ChangeEventHeader\": {\"entityName\": \"Account\",\"recordIds\": [\"0013j000039RbKMAA0\"],\"changeType\": \"UPDATE\", \"changedFields\": [\"Name\",\"LastModifiedDate\",\"LastModifiedById\",\"MCJourney_Fiber_Account_Info_Changed__c\"],\"changeOrigin\": \"com/salesforce/api/soap/56.0;client=SfdcInternalAPI/\",'+
                '\"transactionKey\": \"0000f10b-2c64-9328-1dd9-d97162069ef5\",\"sequenceNumber\": 1,\"commitTimestamp\": 1669129582000,\"commitUser\": \"0057A000005IC2aQAG\",\"commitNumber\": 10996783054564},\"rowidObject\": \"1840004\",\"Account_Number__c\": \"CJ-0000000138\",\"Name__c\": \"Backes Development LLC TEST 602\",\"Account_Verification_Reason__c\": \"null\",\"underReviewDt\": \"2022-12-22T15:50:41Z\",'+
                '\"createDt\": \"2022-12-22T15:50:41Z\",\"Customer_Type__c\": \"null\","Record_Type__c\": \"null\",\"Phone__c\": \"612-369-7750\",\"Account_Status__c\": \"Under Review\",\"Account_Status_Reason_Code__c\": \"null\",      \"customLastUpdateDate\": \"2022-12-22T15:50:41Z\", \"EventType\": {\"item\": [{\"type\": \"Update\",\"victimCustNbrs\": []}]}}}';    
                res.setBody(body);
            }            
            res.setStatusCode(200);
            return res;
        }
    }
}