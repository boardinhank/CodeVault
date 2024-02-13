/***************************************************************************************************
 * Name:  BRAINFARespCashFlowPeriodsWrap
 * Platform: Salesforce Connected Journey (SFCJ)
 * Manager class for SOQL and DML on objects of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFACashFlowPeriodsWrap
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 02/18/2023  	T2Cabato    ESCJ-2365	        			Base version
****************************************************************************************************/
public with sharing class BRAINFARespCashFlowPeriodsWrap {
	public List<CashFlowPeriod> cashFlowPeriods; 
    
    public class CashFlowPeriod {
        public Decimal revenue;
        public Decimal opEx;
        public Decimal capExDirect;
        public Decimal capExSharedGammaAdjusted;
        public Decimal incomeTax;
        public Integer contractMonth;
    }//end class CashFlowPeriod
    
    /**********************************************************************************************
    Description: Used when parsing the JSON Response-body into BRAINFARespCashFlowPeriodWrap
    ***********************************************************************************************/
    public static BRAINFARespCashFlowPeriodsWrap parse(String responseBodySection) {
        System.debug('(BRAINFARespCashFlowPeriodsWrap.parse) responseBodySection = \n' + responseBodySection);
        return (BRAINFARespCashFlowPeriodsWrap) System.JSON.deserialize(responseBodySection, BRAINFARespCashFlowPeriodsWrap.class);
    }//end method parse

}//end class BRAINFARespCashFlowPeriodsWrap