/***************************************************************************************************
 * Name:  BRAINFARespBuildCostWrap
 * Platform: Salesforce Connected Journey (SFCJ)
 * Manager class for SOQL and DML on objects of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFABuildCostWrap
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 02/18/2023  	T2Cabato    ESCJ-2365	        			Base version
****************************************************************************************************/
public with sharing class BRAINFARespBuildCostWrap {

    public Integer siteCount;
    public String currencyCode;
    public Decimal projectCapEx;
    public Decimal directCapEx;
    public Decimal sharedCapEx;
    public Decimal opExNRC;
    public Decimal opExMRC;
    public Decimal netExSharedMRC;    
    
   /**********************************************************************************************
    Description: Used when parsing the JSON Response-body into BRAINFARespBuildCostWrap
    ***********************************************************************************************/
    public static BRAINFARespBuildCostWrap parse(String responseBodySection) {
        System.debug('(BRAINFARespBuildCostWrap.parse) responseBodySection = \n' + responseBodySection);
        return (BRAINFARespBuildCostWrap) System.JSON.deserialize(responseBodySection, BRAINFARespBuildCostWrap.class);
    }//end method parse

}//end class BRAINFARespBuildCostWrap