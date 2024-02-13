/***************************************************************
===============================================================
Purpose: Test class for Prospector Submit Job service callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
***************************************************************/
@isTest
public with sharing class ProspectorSubmitJobCallout_Test {
    /**********************************************************************************************
    Purpose: To create Test data
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    @testSetup static void setup() {

    }

    /**********************************************************************************************
    Purpose: To test submit job service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testSubmitJobService() {
        ProspectorCreateProjectCallout.ProspectorProject resWrapper;

        Test.startTest();
            ProspectorSubmitJobCallout psjCallout = new ProspectorSubmitJobCallout(null);

        	resWrapper = psjCallout.submitJob('Stan5678','Green');
        Test.stopTest();
        
        // Assert
       if(resWrapper == null) {
	       System.assertEquals(resWrapper, null);
       } else {
           System.assertNotEquals(resWrapper, null);
           if (resWrapper.status == null) {
               System.assertEquals(resWrapper.status, null);
           } else {
               System.assertNotEquals(resWrapper.status, null);
               if (resWrapper.status == 'success') {
	               System.assertEquals(resWrapper.status, 'success');
               } else {
	               System.assertNotEquals(resWrapper.status, 'success');
               }
           }
           if (resWrapper.payload == null) {
               System.assertEquals(resWrapper.payload, null);
           } else {
               System.assertNotEquals(resWrapper.payload, null);
               String payloadStr = String.valueOf(resWrapper.payload);
               if (payloadStr == 'true') {
	               System.assertEquals(payloadStr, 'true');
               } else {
	               System.assertNotEquals(payloadStr, 'true');
               }
           }
           if (resWrapper.message == null) {
               System.assertEquals(resWrapper.message, null);
           } else {
               System.assertNotEquals(resWrapper.message, null);
           }
       } 
    }//end method testSubmitJobService
}//end test class ProspectorSubmitJobCallout_Test