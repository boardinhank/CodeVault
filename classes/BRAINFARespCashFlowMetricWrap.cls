/***************************************************************************************************
 * Name:  BRAINFARespCashFlowMetricWrap
 * Platform: Salesforce Connected Journey (SFCJ)
 * Manager class for SOQL and DML on objects of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFACashFlowMetricWrap
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 02/18/2023  	T2Cabato    ESCJ-2365	        			Base version
****************************************************************************************************/
public with sharing class BRAINFARespCashFlowMetricWrap {

    public String currencyCode;
    public Decimal netPresentValue;
    public Decimal discountPaybackPeriodMonths;
    public Decimal simplePaybackPeriodMonths;
    public Decimal internalRateOfReturn;
    public Decimal averageContractTermMonths;
    
   /**********************************************************************************************
    Description: Used when parsing the JSON Response-body into BRAINFARespCashFlowMetricWrap
    ***********************************************************************************************/
    public static BRAINFARespCashFlowMetricWrap parse(String responseBodySection) {
        System.debug('(BRAINFARespCashFlowMetricWrap.parse) responseBodySection = \n' + responseBodySection);
        return (BRAINFARespCashFlowMetricWrap) System.JSON.deserialize(responseBodySection, BRAINFARespCashFlowMetricWrap.class);
    }//end method parse

}//end class BRAINFARespCashFlowMetricWrap