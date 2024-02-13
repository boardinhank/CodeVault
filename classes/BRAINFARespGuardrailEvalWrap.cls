/***************************************************************************************************
 * Name:  BRAINFARespGuardrailEvalWrap
 * Platform: Salesforce Connected Journey (SFCJ)
 * Manager class for SOQL and DML on objects of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFAGuardrailEvalWrap
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 02/18/2023  	T2Cabato    ESCJ-2365	        			Base version
****************************************************************************************************/
public with sharing class BRAINFARespGuardrailEvalWrap {

    public String resultCode;
    public String displayMessage;
    public Integer simplePaybackPeriodThresholdMonths;
    public String currencyCode;
    public Decimal incrementalATCToMeetGuardrail;
    
   /**********************************************************************************************
    Description: Used when parsing the JSON Response-body into NRMAStatusResponseWrap
    ***********************************************************************************************/
    public static BRAINFARespGuardrailEvalWrap parse(String responseBodySection) {
        System.debug('(BRAINFARespGuardrailEvalWrap.parse) responseBodySection = \n' + responseBodySection);
        return (BRAINFARespGuardrailEvalWrap) System.JSON.deserialize(responseBodySection, BRAINFARespGuardrailEvalWrap.class);
    }//end method parse

}//end class BRAINFARespGuardrailEvalWrap