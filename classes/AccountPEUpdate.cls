/***************************************************************
AUTHOR     DATE         Reference     Description
Sravya S   27/09/2022   ESCJ-1926    Call DONT/EERS realtime when a new account is created or an existing account is updated.
***************************************************************/

public class AccountPEUpdate {
    public static final String insertfun='insertion';
    public static final String updatefun='updation';
    
    public static void AccountPEHelperInsert(Map<Id,Account> newaccMap){
        for(Account acc:newaccMap.values()){
            System.enqueueJob(new AccountPEHandler(insertfun,acc));           
        }
    }
    public static void AccountPEHelperUpdate(Map<Id,Account> newaccMap, Map<Id,Account> oldaccMap){
        for(Account acc:newaccMap.values()){
            Account oldAccount = oldaccMap.get(acc.id);
            if (oldAccount != null && (oldAccount.phone != acc.Phone || oldAccount.name != acc.Name)) {
                System.enqueueJob(new AccountPEHandler(updatefun,acc));
            }
        }
    }
}