/***************************************************************************************************
 * Name:  BRAINFAScheduler
 * Platform: Salesforce Connected Journey (SFCJ)
 * Scheduler class for BRAIN Financial Analyses interaction between SFCJ and BRAIN FA API
 * Code Coverage:  TestBRAINFAScheduler -- 100%  07/16/2023
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
 *
****************************************************************************************************/
global with sharing class BRAINFAScheduler implements Schedulable { 
	private final String callSource = 'CapitalDesign';
    private final String submitterCuid = 'CJAPIUS';
    
    global void execute(SchedulableContext ctx) {
        List<Capital_Design__c> queuedCDList = [SELECT Id, Name, QueuedForBRAINFARun__c FROM Capital_Design__c 
                                                 WHERE QueuedForBRAINFARun__c = TRUE AND Capital_Design_Stage__c = 'Planner Design Complete' LIMIT 50];
        System.debug('(BRAINFAScheduler.execute) queuedCDList is NULL? ' + (queuedCDList==null) + '  AND queuedCDList?.size() = ' + queuedCDList?.size());
        if (queuedCDList != null && queuedCDList.size() > 0) {            
            for (Capital_Design__c cd : queuedCDList) {
		        System.debug('(BRAINFAScheduler.execute) Enqueueing job for Capital-Design ' + cd.Name);
	            System.enqueueJob(new BRAINFACentralAutomationController(cd.Name, null, submitterCuid, callSource));
            }
        }
    }//end method execute
    
}//end class BRAINFAScheduler