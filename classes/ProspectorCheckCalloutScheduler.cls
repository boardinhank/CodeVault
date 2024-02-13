/***************************************************************
===============================================================
Purpose: Prospector Check Callout Scheduler class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 09/06/2022   ESCJ-653  	  Initial draft
***************************************************************/
global with sharing class ProspectorCheckCalloutScheduler implements Schedulable {
 
    global static final String HRLY_ON_5M_CRON_EXP = '0 5 2-21 * * ? 2022'; //hourly on the 5th minute
    global static final String HRLY_ON_15M_CRON_EXP = '0 15 2-21 * * ? 2022'; //hourly on the 15th minute
    global static final String HRLY_ON_25M_CRON_EXP = '0 25 2-21 * * ? 2022'; //hourly on the 25th minute
    global static final String HRLY_ON_35M_CRON_EXP = '0 35 2-21 * * ? 2022'; //hourly on the 35th minute
    global static final String HRLY_ON_45M_CRON_EXP = '0 45 2-21 * * ? 2022'; //hourly on the 45th minute
    global static final String HRLY_ON_55M_CRON_EXP = '0 55 2-21 * * ? 2022'; //hourly on the 55th minute

    global void execute(SchedulableContext ctx) {
        System.enqueueJob(new ProspectorCheckCalloutController());    	    
    }//end execute
    
}//end class ProspectorCheckCalloutScheduler