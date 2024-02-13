@isTest
public class AccountHoldStatusUpdateTest {
     @isTest static void testAccountHoldStatus() {
      Account acct = new Account(Name='TestAcct1006');
		insert acct;
       List<List<String>> listofListAcctIds = new List<List<String>>();
        List<String> listAcctIds = new List<String>();
        listAcctIds.add(acct.id);
        listofListAcctIds.add(listAcctIds);        
        // Call the method that invokes a callout
        Test.startTest();
         string apiname ='SolicitVerification';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
        AccountHoldStatusUpdate.updateAccountStatus(listofListAcctIds);
        Test.stopTest(); 
    }  
}