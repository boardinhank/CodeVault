/***************************************************************************************************************
* Apex Class : Level3Constants
*
* Description : Support class for defining constants
*
* Where Used?
*
*
* Change History:
* Date			Person Responsible		Traceability	Details		
* 06/05/2012	Aileen Kronvall,
				Brian Clift       		US44037			Created
* 01/05/2014	Sorna					US141652		Added Scenario Manager Constants
* 01/12/2015	Sorna                   US141980        Added Opportunity Header Call Constants
* 01/26/2015	Sorna               	US144525		Add Pre-Screen Credit Check constants
* 02/02/2015	Sorna               	US144526		Added Case Status constants
* 02/20/2015	Sorna               	US144525
										US144239		Added AppSecure Endpoint Url              
* 03/08/2016	Curtis			  		US187751		Removed reference to SM_SERVER					
* 11/07/2016	Curtis 			  		US216907		Removed references to obsolete Sceanrio Order Status values
* 11/14/2016	Feike				  	US212774		Add SM_ManageLocation
* 06/08/2017	Feike				  	US163499		Integrating Level 3 code in CenturyLink Org
* 07/11/2017	Feike				  	US173719		Setting the stage values 1 thru 6 to what they are in mergedev
* 11/20/2017	Suresh		      		US184357		Commenting Weekends
* 12/05/2017  	Jeyavel S			  					Removed Unused constants		
* 03/28/2018	Jeyavel S				US229814		Remove ref's to SSL Cert/password
* 06/17/2020	Vanaja Chillara			LBOCM-11509		CR7757: SFA-SS: User Role change in Pay Load
* 07/17/2020	Surendra   			    LBOCM-13278     CR7757: SFA-SS: User Roles (PreDeployAdmin & PreDeploySuperUser) added to Pay Load for PreDeploy
* 10/16/2020    Prashanth 	            LBOCM-14504		Added two new Quote Viewer and Quote Approver roles 
* 02/11/2022	S Kuehl					ESCJ-390		Copied over from SFDC Enterprise to utilize
* 11/30/2022 	Kuehl					Code Coverage 93% using Level3ConstantsTest
*****************************************************************************************************************/

public class Level3Constants {
    /********************** Email Settings *****************************/
    public static String ACCOUNT_ASSIGNMENT 					{ get { return 'Account_Assignment_Approval_Status'; } }
    public static String ACCOUNT_ASSIGNMENT_ERROR 				{ get { return 'Account_Assignment_Error_Status'; } }
    public static String INTERVAL_START_DATE_NOTIFICATION 		{ get { return 'Interval_Start_Date_Notification'; } }
    public static String INTERVAL_END_DATE_NOTIFICATION			{ get { return 'Interval_End_Date_Notification'; } }
    public static String SALES_OPS_COMPLETE_DATE_NOTIFICATION 	{ get { return 'Sales_Ops_Complete_Date_Notification'; } }
    /********************** End Email Settings *****************************/

    /********************** Reusable controller constants *****************************/

    
    // Constants for Account Assignment
    public static String ACCOUNT_ASSIGNMENT_RESULT_SIZE { get { return 'AccountAssignmentResultSize'; } }


    /**
	* List of REST services constants used in Custom Settings
	*/
    // public static String AUTO_COMPLETE_REST_SERV { get { return 'AutoComplete'; } }
    public static String BAN_REST_SERVICE { get { return 'BANSearch'; } }

    /**
	*       List of Scenario Manger Page Names used in EnvironmentURLS__c custom setting
	*/
    public static String SM_IFRAME_JS { get { return 'SMIFrameJS'; } }
    public static String SM_ADDSCENARIO { get { return 'SMAddScenario'; } }
    public static String SM_EDITSCENARIO { get { return 'SMEditScenario'; } }
    public static String SM_MANAGELOCATION { get { return 'SMManageLocation'; } }

    /** List of constants used for Scenario Manager Opportunity Header call */

    // scenario Manager roles
    public static string SM_ADMIN { get { return 'Role_ScenarioAdmin'; } }
    public static string SM_READER { get { return 'Role_ScenarioReader'; } }
    public static string SM_SUPERUSER { get { return 'Role_SuperUser'; } }
    public static string SM_EDIT { get { return 'Role_ScenarioEditor'; } }
	public static string SM_QUOTEVIEWER { get { return 'Role_QuoteViewer'; } }     //LBOCM-14504
    public static string SM_QUOTEAPPROVER { get { return 'Role_QuoteApprover'; } }  //LBOCM-14504
    public static String SCENARIO_READY_FOR_SUBMIT { get { return 'Ready to Submit'; } }
    public static String SM_PreDeployEdit { get { return 'Role_PreDeployEdit'; } } // LBOCM-11509
	public static String SM_PreDeployAdmin { get { return 'Role_PreDeployAdmin'; } }//LBOCM-13278
    public static String SM_PreDeploySuperUser { get { return 'Role_PreDeploySuperUser'; } }//LBOCM-13278
    /**
	* Approvals Constants
	*/

    // Error Codes
    public static String ERROR_CODE_PENDING_REQUEST { get { return 'AE-01'; } }
    public static String ERROR_CODE_OBJECT_DOES_NOT_EXIST { get { return 'AE-02'; } }
    public static String ERROR_CODE_CURRENT_NEW_OWNER_SAME { get { return 'AE-03'; } }
    public static String ERROR_CODE_APPROVER_UNKNOWN { get { return 'AE-04'; } }
    public static String ERROR_CODE_CROSS_CHANNEL { get { return 'AE-06'; } }
    public static String ERROR_CODE_CROSS_REGION { get { return 'AE-07'; } }
    public static String ERROR_CODE_INELIGIBLE_ACCOUNT_OWNER { get { return 'AE-08'; } }
    public static String ERROR_CODE_INACTIVE_ACCOUNT { get { return 'AE-09'; } }
    public static String ERROR_CODE_EXEC_APPROVER_UNKNOWN { get { return 'AE-10'; } }
    public static String ERROR_CODE_SYSTEM_ERROR { get { return 'AE-98'; } }
    public static String ERROR_CODE_UNKNOWN_ERROR { get { return 'AE-99'; } }


    /**
	* Timebomb Constants
	*/
    public static String ON_HOLD_ACCT_AUTOMATION_RULE { get { return 'On Hold Acct Automation'; } }

    /**
	* Opportunity Constants
	*/
    public static String STAGE_0 { get { return 'Marketing Qualified'; } }
    public static String STAGE_0_LOST { get { return 'Marketing Rejected/Closed'; } }
    public static String STAGE_1 { get { return 'Identified'; } }
    public static String STAGE_2 { get { return 'Qualified'; } }
    public static String STAGE_3 { get { return 'Solution Defined'; } }
    public static String STAGE_4 { get { return 'Proposed'; } }
    public static String STAGE_5 { get { return 'Agreement'; } }
    public static String STAGE_6_LOST { get { return 'Lost'; } }
    public static String STAGE_6_WON { get { return 'Won'; } }

    /**
	*  Campaign Status Constants
	*/
    public static String COMPLETED_STATUS { get { return 'Completed'; } }
    public static String ABORTED_STATUS { get { return 'Aborted'; } }

    //Used in Level3Utils.getBusinessHours()
    public static Map<string,time> defaultBusHours 
    { 
        get { 
    		return new Map<string, time> 
            {
        	'Start' => Time.newInstance(0, 0, 0, 0),
        	'End' => Time.newInstance(23, 59, 0, 0)
      		};
		} 
    }
    
    
    public static Map<String, SObjectField> startTimes 
	{ 
		get 
		{ 
        	return new Map<String, SObjectField> 
			{
                'Sunday'    => BusinessHours.SundayStartTime, //US184357
                'Monday'    => BusinessHours.MondayStartTime,
                'Tuesday'   => BusinessHours.TuesdayStartTime,
                'Wednesday' => BusinessHours.WednesdayStartTime,
                'Thursday'  => BusinessHours.ThursdayStartTime,
                'Friday'    => BusinessHours.FridayStartTime,
                'Saturday'  => BusinessHours.SaturdayStartTime //US184357
			};
    	}
	}


	public static Map<String, SObjectField> endTimes 
	{ 
		get 
		{
        	return new Map<String, SObjectField> 
			{
                'Sunday'    => BusinessHours.SundayEndTime, //US184357
                'Monday'    => BusinessHours.MondayEndTime,
                'Tuesday'   => BusinessHours.TuesdayEndTime,
                'Wednesday' => BusinessHours.WednesdayEndTime,
                'Thursday'  => BusinessHours.ThursdayEndTime,
                'Friday'    => BusinessHours.FridayEndTime,
                'Saturday'  => BusinessHours.SaturdayEndTime //US184357
            };
    	} 
	}

    public static Map<String, SObjectField> onHoldstartTimes 
	{ 
		get 
		{ 
        	return new Map<String, SObjectField> 
			{
                //'Sunday'    => BusinessHours.SundayStartTime, //US184357
                'Monday'    => BusinessHours.MondayStartTime,
                'Tuesday'   => BusinessHours.TuesdayStartTime,
                'Wednesday' => BusinessHours.WednesdayStartTime,
                'Thursday'  => BusinessHours.ThursdayStartTime,
                'Friday'    => BusinessHours.FridayStartTime
                //'Saturday'  => BusinessHours.SaturdayStartTime //US184357
           };
    	}
	}
    
	public static Map<String, SObjectField> onHoldendTimes 
	{ 
		get 
		{
        	return new Map<String, SObjectField> 
			{
                //'Sunday'    => BusinessHours.SundayEndTime, //US184357
                'Monday'    => BusinessHours.MondayEndTime,
                'Tuesday'   => BusinessHours.TuesdayEndTime,
                'Wednesday' => BusinessHours.WednesdayEndTime,
                'Thursday'  => BusinessHours.ThursdayEndTime,
                'Friday'    => BusinessHours.FridayEndTime
                //'Saturday'  => BusinessHours.SaturdayEndTime //US184357
            };
    	} 
	}
    
   
}