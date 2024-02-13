@isTest
public class AccountStatusUpdateTest {
    
    
    @isTest static void testMethodPositiveScenario() {
      Account acct = new Account(Name='TestAcct1006');
		insert acct;
       List<List<String>> listofListAcctIds = new List<List<String>>();
        List<String> listAcctIds = new List<String>();
        listAcctIds.add(acct.id);
        listofListAcctIds.add(listAcctIds);
        AccountStatusUpdate.updateAccountStatus(listofListAcctIds);
    }

}