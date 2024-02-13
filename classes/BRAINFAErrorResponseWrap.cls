/***************************************************************************************************
 * Name:  BRAINFAErrorResponseWrap
 * Platform: Salesforce Connected Journey (SFCJ)
 * Manager class for SOQL and DML on objects of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFAErrorResponseWrap
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 02/18/2023  	T2Cabato    ESCJ-2365	        			Base version
****************************************************************************************************/
public with sharing class BRAINFAErrorResponseWrap {

    public String errorCode;
    public String errorMessage;    
    
   /**********************************************************************************************
    Description: Used when parsing the JSON Response-body into BRAINFAErrorResponseWrap
    ***********************************************************************************************/
    public static BRAINFAErrorResponseWrap parse(String responseBodySection) {
        System.debug('(BRAINFAErrorResponseWrap.parse) responseBodySection = \n' + responseBodySection);
        return (BRAINFAErrorResponseWrap) System.JSON.deserialize(responseBodySection, BRAINFAErrorResponseWrap.class);
    }//end method parse

}//end class BRAINFAErrorResponseWrap