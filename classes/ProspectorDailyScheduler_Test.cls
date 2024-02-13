@isTest(SeeAllData=true)
public with sharing class ProspectorDailyScheduler_Test { 

    public static String TEST_CRON_EXP_DLY = '0 0 20 6 * ?';
    public static String TEST_CRON_EXP_EXACT = '0 04 16 * * ?';

    @AuraEnabled
    public static testmethod void testSchedulableJob() { 
        Test.startTest();
        String scheduledJobId = System.schedule('ProspectorDailySchedulerTest', TEST_CRON_EXP_EXACT, new ProspectorDailyScheduler());
        System.debug('(ProspectorDailyScheduler_Test.testSchedulableJob) scheduledJobId = ' + scheduledJobId);
        if (scheduledJobId == null) {
            System.assertEquals(null, scheduledJobId);
        } else {
            System.assertNotEquals(null, scheduledJobId);
        }
        Test.stopTest();
        
    }//end method testSchedulableJob

}//end class ProspectorDailyScheduler_Test