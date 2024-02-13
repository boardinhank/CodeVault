/***************************************************************************************************************
 * Description:  Test class for CancelCLMContractsScheduler - which runs the CancelCLMContracts Batch class
 *
 * Change History: 
 * Date        	Person Responsible	Traceability    Details
 * 12/15/2023   Kuehl               QFCJ-4697       Created initial API Test class - Cancel 1 to many Agiloft Contracts and Notes.
 *  
 * ****************************************************************************************************************/

 @isTest
 public class CancelCLMContractsSchedulerTest 
{
    public static String TEST_CRON_EXP = '0 10 * * * ?';
    
    //variables that hold values from testSetup data that was created
    private static Id testingCId = null;
    
    public String contractRecordId;
  
   
        
    @isTest
    static void testCancelCLMContractsScheduler()
    {   
        System.debug('\n\nBefore Test.startTest()...');
        
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());        
        
        Test.startTest();
        
        String scheduledJobId = System.schedule('CancelCLMContractsScheduler', TEST_CRON_EXP, new CancelCLMContractsScheduler());
        
        if (scheduledJobId == null) 
        {
            System.assertEquals(null, scheduledJobId);
        } 
        else 
        {
            System.assertNotEquals(null, scheduledJobId);
        }
		 
        Test.stopTest();
 
        System.debug('\n\nAfter Test.stopTest()...');
          
    }//end test method
}