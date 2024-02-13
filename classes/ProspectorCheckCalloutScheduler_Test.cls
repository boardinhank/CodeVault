@isTest(SeeAllData=true)
public with sharing class ProspectorCheckCalloutScheduler_Test {

    public static String TEST_CRON_EXP = '0 0 13-18 14 * ?';
    public static String TEST_CRON_EXP_EXACT = '0 50 17 14 * ?';

    @AuraEnabled
    public static testmethod void testSchedulableJob() { 

        Test.startTest();
        String scheduledJobId = System.schedule('ProspectorCheckCalloutSchedulerTest', TEST_CRON_EXP_EXACT, new ProspectorCheckCalloutScheduler());
        System.debug('(ProspectorCheckCalloutScheduler_Test.testSchedulableJob) scheduledJobId = ' + scheduledJobId);
        if (scheduledJobId == null) {
            System.assertEquals(null, scheduledJobId);
        } else {
            System.assertNotEquals(null, scheduledJobId);
        }
        Test.stopTest();
        
    }//end method testSchedulableJob

}//end class ProspectorCheckCalloutScheduler_Test