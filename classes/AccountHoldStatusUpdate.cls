/******************************************************************************************************************* 
* @author : Lumen.com
* @Class : AccountHoldStatusUpdate
* @ Descriptions : this being called by Account - Account Hold Status Scheduled flow which is scheduled trigger flow
****************************************************************** 
Author    *          UserStory   *    Date(d/m/y)         *       Description 
Chiranjeevi          ESCJ-2306        13/Feb/2023             All Accounts's wich are On Hold for >= 90 days then the Account Status Updates from On Hold to Rejected.
* *****************************************************************************************************************/    
global class AccountHoldStatusUpdate {
    
   @InvocableMethod(label ='AccontHoldStatusUpdate'
                    description ='Account status update'
                    category='Account')
    webservice static void updateAccountStatus(List<List<String>> ids){
        system.debug('ids-->' + ids);
        List<Account> acctList = new List<Account>();
        Set<String> setAcctIds = new Set<String>();
        setAcctIds.addAll(ids[0]);
        system.debug('setAcctIds-->' + setAcctIds);
        for( String acctid : setAcctIds){
            acctList.add(new Account(id = acctid, Account_status__c  ='Rejected'));
        }
        update acctList;
    }
  
    
}