/***************************************************************************************************
 * Name:  NRMAStatusResponseWrap
 * Platform: Salesforce Connected Journey (SFCJ)
 * Wrapper class for Response from the NRMA-Requests-Status action as part of the 
 *         BRAIN/NRMA Approval-Tool interaction between SFCJ and BRAIN API
 * Code Coverage:  TestNRMAStatusResponseWrap -- 88%  01/18/2023
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 01/17/2023  	T2Cabato    Feature(Epic) ESCJ-1960	        Base version
****************************************************************************************************/
public class NRMAStatusResponseWrap {

    public String nrmaRequestId;
    public String financeWorkflowId;
    public String financeWorkflowStatus;
    public DateTime financeCurrentPhaseBeginTime;
    public String offerManagementWorkflowId;
    public String offerManagementWorkflowStatus;
    public DateTime offerManagementCurrentPhaseBeginTime;
        
    /**********************************************************************************************
    Description: Used when parsing the JSON Response-body into NRMAStatusResponseWrap
    ***********************************************************************************************/
    public static NRMAStatusResponseWrap parse(String responseBody) {
        System.debug('(NRMAStatusResponseWrap.parse) responseBody = \n' + responseBody);
        return (NRMAStatusResponseWrap) System.JSON.deserialize(responseBody, NRMAStatusResponseWrap.class);
    }  
}//end class NRMAStatusResponseWrap