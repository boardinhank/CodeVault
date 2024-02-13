/***************************************************************************************************************
* Apex Class : Level3ConstantsTest
*
* Description : To Test Generic Constants
*
* Where Used?
*
*
* Change History:
* Date          Person Responsible      Traceability        Details
* 11/17/2022 	Kuehl S					ESCJ-1680			Created to match up to Level3Contstants class
*****************************************************************************************************************/

@isTest
public class Level3ConstantsTest {
    
    @isTest
    static void testLevel3Constants()
    {
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());  
        String s1 = Level3Constants.ACCOUNT_ASSIGNMENT;
        String s2 = Level3Constants.ACCOUNT_ASSIGNMENT_ERROR;
        string s3 = Level3Constants.INTERVAL_START_DATE_NOTIFICATION;
        String s4 = Level3Constants.INTERVAL_END_DATE_NOTIFICATION;
        String s5 = Level3Constants.SALES_OPS_COMPLETE_DATE_NOTIFICATION;
        String s6 = Level3Constants.ACCOUNT_ASSIGNMENT_RESULT_SIZE;
        String s7 = Level3Constants.BAN_REST_SERVICE;
        String s8 = Level3Constants.SM_IFRAME_JS;
        String s9 = Level3Constants.SM_ADDSCENARIO;
        String s10 = Level3Constants.SM_EDITSCENARIO;
        String s11 = Level3Constants.SM_MANAGELOCATION;
        string s12 = Level3Constants.SM_ADMIN;
        string s13 = Level3Constants.SM_READER;
        string s14 = Level3Constants.SM_SUPERUSER;
        string s15 = Level3Constants.SM_EDIT;
        String s16 = Level3Constants.SCENARIO_READY_FOR_SUBMIT;
        String s17 = Level3Constants.ERROR_CODE_PENDING_REQUEST;
        String s18 = Level3Constants.ERROR_CODE_OBJECT_DOES_NOT_EXIST;
        String s19 = Level3Constants.ERROR_CODE_CURRENT_NEW_OWNER_SAME;
        String s20 = Level3Constants.ERROR_CODE_APPROVER_UNKNOWN;
        String s22 = Level3Constants.ERROR_CODE_CROSS_CHANNEL;
        String s23 = Level3Constants.ERROR_CODE_CROSS_REGION;
        String s24 = Level3Constants.ERROR_CODE_INELIGIBLE_ACCOUNT_OWNER;
        String s25 = Level3Constants.ERROR_CODE_INACTIVE_ACCOUNT;
        String s26 = Level3Constants.ERROR_CODE_EXEC_APPROVER_UNKNOWN;
        String s28 = Level3Constants.ERROR_CODE_SYSTEM_ERROR;
        String s29 = Level3Constants.ERROR_CODE_UNKNOWN_ERROR;
        String s30 = Level3Constants.ON_HOLD_ACCT_AUTOMATION_RULE;
        String s31 = Level3Constants.STAGE_0;
        String s32 = Level3Constants.STAGE_0_LOST;
        String s33 = Level3Constants.STAGE_1;
        String s34 = Level3Constants.STAGE_2;
        String s35 = Level3Constants.STAGE_3;
        String s36 = Level3Constants.STAGE_4;
        String s37 = Level3Constants.STAGE_5;
        String s38 = Level3Constants.STAGE_6_LOST;
        String s39 = Level3Constants.STAGE_6_WON;
        String s40 = Level3Constants.COMPLETED_STATUS;
        String s41 = Level3Constants.ABORTED_STATUS;
        
        Map<string,time> defHrs = Level3Constants.defaultBusHours;
        Map<String, SObjectField> startTime 		= Level3Constants.startTimes;
        Map<String, SObjectField> endTime 			= Level3Constants.endTimes;
        Map<String, SObjectField> onholdStartTime 	= Level3Constants.onHoldstartTimes;
        Map<String, SObjectField> onholdEndtime 	= Level3Constants.onHoldendTimes;
    }
    
}