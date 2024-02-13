/***************************************************************************************************
 * Name:  BRAINFARespIncomeStmtWrap
 * Platform: Salesforce Connected Journey (SFCJ)
 * Manager class for SOQL and DML on objects of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFAIncomeStmtWrap
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 02/18/2023  	T2Cabato    ESCJ-2365	        			Base version
****************************************************************************************************/
public with sharing class BRAINFARespIncomeStmtWrap {

    public String currencyCode;
    public Decimal revenue;
    public Decimal netExDirect;
    public Decimal netExShared;
    public Decimal grossMargin;
    public Decimal grossMarginPct;
    public Decimal opEx;
    public Decimal ebitda;
    public Decimal ebitdaPct;
    public Decimal capExDirect;
    public Decimal capExSharedGammaAdjusted;
    public Decimal ebitdaLessCapEx;
    public Decimal ebitdaLessCapExPct;
    public Decimal incomeTax;
    
   /**********************************************************************************************
    Description: Used when parsing the JSON Response-body into BRAINFARespIncomeStmtWrap
    ***********************************************************************************************/
    public static BRAINFARespIncomeStmtWrap parse(String responseBodySection) {
        System.debug('(BRAINFARespIncomeStmtWrap.parse) responseBodySection = \n' + responseBodySection);
        return (BRAINFARespIncomeStmtWrap) System.JSON.deserialize(responseBodySection, BRAINFARespIncomeStmtWrap.class);
    }//end method parse

}//end class BRAINFARespIncomeStmtWrap