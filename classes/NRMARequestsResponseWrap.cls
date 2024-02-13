/***************************************************************************************************
 * Name:  NRMARequestsResponseWrap
 * Platform: Salesforce Connected Journey (SFCJ)
 * Wrapper class for Response from the NRMA-Requests action as part of the 
 *         BRAIN/NRMA Approval-Tool interaction between SFCJ and BRAIN API
 * Code Coverage:  TestNRMARequestsResponseWrap -- 88%  01/18/2023
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 01/17/2023  	T2Cabato    Feature(Epic) ESCJ-1960	        Base version
****************************************************************************************************/
public class NRMARequestsResponseWrap {

    public String id;
    public String financialAnalysisID;
    public String cetId;
    public String propertyId;
    public String city;
    public String stateCode;
    public String opportunityTitle;
    public Boolean escalated;
    public String submittedByCUID;
    public String contactEmailAddress;
    public String notificationEmails;
    public String notes;
    public String highCostExplanation;
    public String contractType;
    public String contractTermMonths;
    public String otherProviderContractType;
    public String wireCenterTreatment;
    public String contractLanguage;
    public String earlyTermLiability;
    public String noAgreementReason;
    public String product;
    public String developerName;
    public String consultantName;
    public DateTime openTrenchDate;
    public Integer constructionMonths;
    public Integer greenfieldSFUCount;
    public Integer greenfieldMDUCount;
    public Integer brownfieldSFUCount;
    public INteger brownfieldMDUCount;
    public Decimal doorFeePerUnitUSDAvg;
    public Decimal bountyPerUnitUSDAvg;
    public Decimal serviceRevenueShares;
    public Decimal bulkPricePerUnitUSDAvg;
    public Decimal buildProjectCapExUSDTotal;
    public Decimal buildDirectCapExUSDTotal;
    public Decimal buildSharedCapExUSDTotal;
    public Decimal buildOpExUSDTotal;
    public Decimal investmentUSDTotal;
    public Decimal capitalReleaseRequestedUSD;
    public Decimal atcUSDTotal;
    public String financialEvaluationResultCode;
    public String financialEvaluationDisplayMessage;
    public String financeWorkflowId;
    public String offerManagementWorkflowId;
    public Integer simplePaybackMonths;
    public Decimal beginningPenetration;
    public Decimal endingPenetration;
    public SupportingDocumentURL[] supportingDocumentUrls;
    public DateTime submissionDate;

    public class SupportingDocumentURL {
        public String name;
        public String url;
    }//end class SupportingDocumentURL
        
    /**********************************************************************************************
    Description: Used when parsing the JSON Response-body into NRMARequestsResponseWrap
    ***********************************************************************************************/
    public static NRMARequestsResponseWrap parse(String responseBody) {
        System.debug('(NRMARequestsResponseWrap.parse) responseBody = \n' + responseBody);
        /******************************************************************************************
         *   The following block is used to parse by token so that each name/value within the JSON 
         *      can be viewed within the output logs of the Developer Console.  
         *   Please do NOT delete as this will prove useful for any future debugging of 
         *      the NRMA Approval-Tool nrma-requests API response body.
         * 
         * 
         *         JSONParser responseJSONParser = JSON.createParser(responseBody);
         *         Integer tokenCtr = 0;
         *         responseJSONParser.nextToken();
         *         do {
         *             responseJSONParser.nextValue();
         *             System.debug('thisTokenName[' + tokenCtr + '] = ' + responseJSONParser.getCurrentName() );
         *             System.debug('thisTokenText[' + tokenCtr + '] = ' + responseJSONParser.getText() );
         *             tokenCtr++;
         *         } while (responseJSONParser.nextToken() != null); //end while nextToken NOT NULL
         * 
         **********************************************************************************************/
        responseBody = responseBody?.contains('"simplePaybackMonths": "",') ? responseBody?.replace('"simplePaybackMonths": "",', '"simplePaybackMonths": 0,') : responseBody;
        responseBody = responseBody?.contains('"serviceRevenueShares": "",') ? responseBody?.replace('"serviceRevenueShares": "",', '"serviceRevenueShares": 0,') : responseBody;
        return (NRMARequestsResponseWrap) System.JSON.deserialize(responseBody, NRMARequestsResponseWrap.class);
    }
}//end class NRMARequestsResponseWrap