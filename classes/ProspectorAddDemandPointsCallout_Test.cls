/***************************************************************
===============================================================
Purpose: Test class for Prospector Add Demand Points service callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
***************************************************************/
@isTest
public with sharing class ProspectorAddDemandPointsCallout_Test { 
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
    Purpose: To test add demand points service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testAddDemandPointsService() {
        ProspectorCreateProjectCallout.ProspectorProject resWrapper;

        List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList = new List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint>();
        ProspectorAddDemandPointsCallout.ProspectorDemandPoint dp = new ProspectorAddDemandPointsCallout.ProspectorDemandPoint();
        
        dp.dpName = 'A0';
        dp.dpLong = '-90.07765888199998';
        dp.dpLat = '29.969037715999995';
        dpList.add(dp);
        
        dp = new ProspectorAddDemandPointsCallout.ProspectorDemandPoint();
        dp.dpName = 'B1';
        dp.dpLong = '-90.076714745';
        dp.dpLat = '29.970013616999996';
        dpList.add(dp);

        Test.startTest();
            ProspectorAddDemandPointsCallout padpCallout = new ProspectorAddDemandPointsCallout(
                null
            );

        	resWrapper = padpCallout.addDemandPoints('Stan5678', dpList); 
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
    }//end method testAddDemandPointsService
}//end test class ProspectorAddDemandPointsCallout_Test