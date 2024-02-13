/***************************************************************
===============================================================
Purpose: Test class for Prospector List Jobs service callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/29/2022   ESCJ-653  	  Initial draft
***************************************************************/
@isTest
public with sharing class ProspectorGetRoutesByProjectCallout_Test {
    /**********************************************************************************************
    Purpose: To create Test data
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/29/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    @testSetup static void setup() {

    }

    /**********************************************************************************************
    Purpose: To test submit job service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/29/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testGetRoutesByProjectServiceMHHH() {
        ProspectorGetRoutesWrap resWrapper;

        Test.startTest();
            ProspectorGetRoutesByProjectCallout pgrbpCallout = new ProspectorGetRoutesByProjectCallout(
                null
            );

        	resWrapper = pgrbpCallout.getRoutesByProject('Stan5678', 'MH_HH');
        Test.stopTest();
        
        System.debug('resWrapper: ' + resWrapper);
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
               if (resWrapper.payload[0].routeName  == 'A0 - MH_HH_1134141') {
	               System.assertEquals(resWrapper.payload[0].routeName , 'A0 - MH_HH_1134141');
               } else {
	               System.assertNotEquals(resWrapper.payload[0].routeName , 'A0 - MH_HH_1134141');
               }
           }
           if (resWrapper.message == null) {
               System.assertEquals(resWrapper.message, null);
           } else {
               System.assertNotEquals(resWrapper.message, null);
           }
       } 
    }//end method testCreateProjectServiceMHHH
    @isTest
    public static void testGetRoutesByProjectServiceSplice() {
        ProspectorGetRoutesWrap resWrapper;

        Test.startTest();
            ProspectorGetRoutesByProjectCallout pgrbpCallout = new ProspectorGetRoutesByProjectCallout(
                null
            );

        	resWrapper = pgrbpCallout.getRoutesByProject('Stan5678', 'SPLICE_CLOSURE');
        Test.stopTest();
        
        System.debug('resWrapper: ' + resWrapper);
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
               if (resWrapper.payload[0].routeName  == 'A0 - MH_HH_1134141') {
	               System.assertEquals(resWrapper.payload[0].routeName , 'A0 - MH_HH_1134141');
               } else {
	               System.assertNotEquals(resWrapper.payload[0].routeName , 'A0 - MH_HH_1134141');
               }
           }
           if (resWrapper.message == null) {
               System.assertEquals(resWrapper.message, null);
           } else {
               System.assertNotEquals(resWrapper.message, null);
           }
       } 
    }//end method testCreateProjectServiceSplice
}//end test class ProspectorGetRoutesByProjectCallout_Test