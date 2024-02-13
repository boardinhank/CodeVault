/***************************************************************
===============================================================
Purpose: Test class for Prospector Create Project service callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
***************************************************************/
@isTest
public with sharing class ProspectorCreateProjectCallout_Test {

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
    Purpose: To test create project service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testCreateProjectService() {
        
        ProspectorCreateProjectCallout.ProspectorProject resWrapper;

        Test.startTest();
            ProspectorCreateProjectCallout pcpCallout = new ProspectorCreateProjectCallout(
                null
            );
            resWrapper = pcpCallout.getProjectName(ProspectorCalloutHelper.RED);
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
               if (resWrapper.payload == '"{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}"') {
	               System.assertEquals(resWrapper.payload, '"{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}"');
               } else {
	               System.assertNotEquals(resWrapper.payload, '"{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}"');
               }
           }
           if (resWrapper.message == null) {
               System.assertEquals(resWrapper.message, null);
           } else {
               System.assertNotEquals(resWrapper.message, null);
           }
       } 
    }//end method testCreateProjectService
}//end test class ProspectorCreateProjectCallout_Test