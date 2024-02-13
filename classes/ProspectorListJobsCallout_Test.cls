/***************************************************************
===============================================================
Purpose: Test class for Prospector List Jobs service callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
***************************************************************/
@isTest
public with sharing class ProspectorListJobsCallout_Test {
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
    public static void testListJobsService() {
        ProspectorListJobsWrap resWrapper;

        Test.startTest();
            ProspectorListJobsCallout pljCallout = new ProspectorListJobsCallout(
                null
            );

        	resWrapper = pljCallout.listJobs();
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
               if (resWrapper.payload[0].projectId == '{30951238-AA8F-47E5-A3F0-F5B9E6E69272}') {
	               System.assertEquals(resWrapper.payload[0].projectId, '{30951238-AA8F-47E5-A3F0-F5B9E6E69272}');
               } else {
	               System.assertNotEquals(resWrapper.payload[0].projectId, '{30951238-AA8F-47E5-A3F0-F5B9E6E69272}');
               }
           }
           if (resWrapper.message == null) {
               System.assertEquals(resWrapper.message, null);
           } else {
               System.assertNotEquals(resWrapper.message, null);
           }
       } 
    }//end method testListJobsCalloutService
}//end test class ProspectorListJobsCallout_Test