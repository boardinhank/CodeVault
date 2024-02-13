/***************************************************************
===============================================================
Purpose: Prospector Daily Scheduler class
==============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 09/06/2022   ESCJ-653  	  Initial draft
***************************************************************/
global with sharing class ProspectorDailyScheduler implements Schedulable {
    global static final String DAILY_2230_CRON_EXP = '0 30 1 * * ? *'; //daily at 01:30

    global void execute(SchedulableContext ctx) { 
        ProspectorCalloutHelper.deleteExistingPWTEntries();
        List<Property__c> propertyList = new List<Property__c>();
        ProspectorCalloutController pcc = new ProspectorCalloutController(propertyList);        
        String pccJobId = System.enqueueJob(pcc);
        System.debug('(ProspectorDailyScheduler.execute) pccJobId = ' + pccJobId);
    }//end execute
    
}//end class ProspectorDailyScheduler