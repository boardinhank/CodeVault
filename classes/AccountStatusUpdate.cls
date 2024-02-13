/******************************************************************************************************************* 
* @author : Lumen.com
* @Class : AccountStatusUpdate
* @ Descriptions : this being called by Account - Account Status Scheduled Updates flow which is scheduled trigger flow
****************************************************************** 
Author    *          UserStory   *    Date(d/m/y)         *       Description 
Ganesh Sirpuram       ESCJ-647        08/06/2022              All Opportunities with Opportunity Close Date <= 90 days from today AND related Opportunity stage = Solution Defined OR Proposed OR Contracting and Account Status = New are processed to update Account Status from New to Under Review
* *****************************************************************************************************************/
global class AccountStatusUpdate {
    
    @InvocableMethod(label ='Accontstatusupdate'
                    description ='Account status update'
                    category='Account')
    webservice static void updateAccountStatus(List<List<String>> ids){
        system.debug('ids-->' + ids);
        List<Account> acctList = new List<Account>();
        Set<String> setAcctIds = new Set<String>();
        setAcctIds.addAll(ids[0]);
        system.debug('setAcctIds-->' + setAcctIds);
        for( String acctid : setAcctIds){
            acctList.add(new Account(id = acctid, Account_status__c  ='Under Review'));
        }
        update acctList;
    }
    
    
    
   /* webservice static void updateAccountStatus(List<Opportunity> ids){
        
        List<Account> acctList = new List<Account>();
        for( Opportunity oppo : ids){
            acctList.add(new Account(id = oppo.AccountId, Account_status__c  ='Under Review'));
        }
        update acctList;
    }*/

}