/***************************************************************************************************
 * Name:  BRAINFAResponseWrap
 * Platform: Salesforce Connected Journey (SFCJ)
 * Manager class for SOQL and DML on objects of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFAResponseWrap
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 02/18/2023  	T2Cabato    ESCJ-2365	        			Base version
****************************************************************************************************/
public with sharing class BRAINFAResponseWrap {

    public String id;
    public String requestId;
    public String status;
    public String responseDate;
    public String applicationVersion;
	public String salesRateScenarioId;
    public String survivalScenarioId;
	public String conversionScenarioId;
    public String costScenarioId;
    public String forecastScenario;
    public Boolean incremental;
    public String errorCode;
    public String errorMessage;    
    
   /**********************************************************************************************
    Description: Used when parsing the JSON Response-body into BRAINFAResponseWrap
    ***********************************************************************************************/
    public static BRAINFAResponseWrap parse(String responseBodySection) {
        System.debug('(BRAINFAResponseWrap.parse) responseBodySection = \n' + responseBodySection);
        return (BRAINFAResponseWrap) System.JSON.deserialize(responseBodySection, BRAINFAResponseWrap.class);
    }//end method parse

}//end class BRAINFAResponseWrap