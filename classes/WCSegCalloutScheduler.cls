/***************************************************************************************************
 * Name:  WCSegCalloutScheduler
 * Platform: Salesforce Connected Journey (SFCJ)
 * Scheduler class for WireCenter CLLI Segmentation interaction between SFCJ and BRAIN/WC API
 * Code Coverage:  TestWCSegCalloutController -- 100%  07/14/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 07/25/2022  	T2Cabato    Feature(Epic) ESCJ-338	        Base version
 * 11/17/2023   T2Cabato    QFCJ-4712                       Capital Design - Wire Center Segmentation Update Automation 
****************************************************************************************************/
global with sharing class WCSegCalloutScheduler implements Schedulable { 

    global void execute(SchedulableContext ctx) { 
        System.enqueueJob(new WCSegCalloutController());
    }
    
}//end class WCSegCalloutScheduler