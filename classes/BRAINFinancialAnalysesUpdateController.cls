/***************************************************************************************************
 * Name:  BRAINFinancialAnalysesUpdateController
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  BRAINFinancialAnalysesUpdateController -- %  11/28/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 11/28/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version
 * 01/27/2023   T2Cabato    Story ESCJ-2365                 Revised per Story
 * 06/13/2023   T2Cabato    QFCJ-3801                       BRAIN-AutoSubmit-Messaging
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
 * 09/28/2023   T2Cabato    QFCJ-4625/26/27/28              BRAIN-Financial-Analysis-Failures
 * 01/19/2024   T2Cabato    QFCJ-4861			            Update NMACapitalDesign with BRAIN results
 * 01/24/2024   T2Cabato    QFCJ-4859                		BRAIN-Offer-Submission-when-CD-fails
****************************************************************************************************/
public with sharing class BRAINFinancialAnalysesUpdateController implements Queueable, Database.AllowsCallouts {
    public class InvalidParameterParsingException extends Exception {}
    public class InvalidHttpResponseException extends Exception {}
    public class UnauthorizedAccessException extends Exception {}
    public class UnhappyStatusCodeHttpResponseException extends Exception {}
    public class NullObjectException extends Exception {}
    public Id capDesignId;
    public Id bacTrackerId;
    public String callSource;
	public List<BRAINFinancialAnalysesUpdateController.UpdateParams> updParamsList;
    
    public BRAINFinancialAnalysesUpdateController(Id capDesignIdIn, Id bacTrackerIdIn, String callSourceIn) {
        this.capDesignId = capDesignIdIn;
        this.bacTrackerId = bacTrackerIdIn;
        this.callSource = callSourceIn;
        //Create list of parameters to be sent to automatedUpdateForBRAINFAResults
        this.updParamsList = new List<BRAINFinancialAnalysesUpdateController.UpdateParams>();
        BRAINFinancialAnalysesUpdateController.UpdateParams up = new BRAINFinancialAnalysesUpdateController.UpdateParams();
        up.capDesignId = this.capDesignId;
        up.bacTrackerId = this.bacTrackerId;
        up.callSource = this.callSource;
        this.updParamsList.add(up);
    }//end constructor 
    
    public void execute(QueueableContext ctx) { 
		List<Boolean> updateSuccessList = automatedUpdateForBRAINFAResults(this.updParamsList);
        if (updateSuccessList!=null && updateSuccessList.size()==1 && updateSuccessList.get(0) && String.isNotBlank(this.callSource) && !this.callSource.equalsIgnoreCase('offer')) {
            String reqCapDesignName = null;
            String reqOfferId = null;
            String reqSubmitterCuid = null;
            List<Offer__c> reqOfferList = BRAINFAObjectSOQLManager.queryForRequestControllerByAssocCDIdForOfferSubmission(this.capDesignId);
            if (reqOfferList != null && reqOfferList.size() == 1 && reqOfferList.get(0).Associated_Capital_Design__c != null) {
                reqCapDesignName = reqOfferList.get(0).Associated_Capital_Design__r.Name != null ? reqOfferList.get(0).Associated_Capital_Design__r.Name : '';
                reqOfferId = reqOfferList.get(0).Id;
                BRAIN_FA_Request__c faReq = BRAINFAObjectSOQLManager.queryForRequestControllerByBACTId(this.bacTrackerId);
                reqSubmitterCuid = faReq != null ? faReq.cuid__c : '';
                BRAINFinancialAnalysesRequestController requestController = new BRAINFinancialAnalysesRequestController(reqCapDesignName, reqOfferId, reqSubmitterCuid, 'Offer');
                if(Test.isRunningTest()) {
                    requestController.execute(null);
                } else {
                    String requestJobId = System.enqueueJob(requestController);
                    System.debug('(BRAINFACentralAutomationController.execute) requestJobId = ' + requestJobId);
                }            
            }//end if reqOfferList is valid
        }//end continue with Offer
        this.clearState();
    }//end method execute

    public class UpdateParams {
        @invocableVariable(label='Capital Design Record Id' description='The Id of the Capital_Design__c record' required=true)
        public Id capDesignId;
        @invocableVariable(label='BRAIN API Calls Tracker Record Id' description='The Id of the BRAIN_API_Call_Tracker__c record' required=true)
        public Id bacTrackerId;
        @invocableVariable(label='Call Source' description='The source from which the Call was being made (Offer, APVOffer, CapitalDesign)' required=true)
        public String callSource;
    }
    
    @InvocableMethod(label='Update for BRAIN Financial Analyses Results'
                     description='Perform update of CD and/or Offer for BRAIN Financial Analyses results'
                     callout=true
                     category='BRAIN API Call Tracker')
    public static List<Boolean> updateForBRAINFAResults(List<UpdateParams> updateParams) {
        Id capDesignId = null;
        Id bacTrackerId = null;
        String callSource = null;
        List<Boolean> returnList = new List<Boolean>();
        
        try {        
            //Extract parameters into the key variables
            System.debug('(BRAINFinancialAnalysesUpdateController.updateForBRAINFAResults) updateParams.size() = ' + updateParams.size());
            capDesignId = updateParams.get(0).capDesignId;
            bacTrackerId = updateParams.get(0).bacTrackerId;
            callSource = updateParams.get(0).callSource;
            
            System.debug('(BRAINFinancialAnalysesUpdateController.updateForBRAINFAResults) capDesignId = ' + capDesignId +
                          '\n bacTrackerId = ' + bacTrackerId + '\n callSource = ' + callSource);
            
            if (String.isBlank(capDesignId) || String.isBlank(bacTrackerId) || String.isBlank(callSource)) {
                throw new InvalidParameterParsingException();
            }
            /**********************************************************************************************
             * QFCJ-4861 NMACapitalDesigns also need updated with BRAIN results 
             **********************************************************************************************/ 
            if (callSource.equalsIgnoreCase('CapitalDesign') || callSource.equalsIgnoreCase('NMACapitalDesign')) {
                List<Capital_Design__c> cdList = new List<Capital_Design__c>();
                try {
                	cdList = BRAINFAObjectDMLManager.updateCDFromBACT(updateParams);
                }  catch(Exception updCDX) {
		            System.debug('(BRAINFinancialAnalysesUpdateController.updateForBRAINFAResults) EXCEPTION! \n Type: ' + updCDX.getTypeName() + '\n Message:  ' + updCDX.getMessage() + '\n Line#: ' + updCDX.getLineNumber() + '\n StackTrace:  ' + updCDX.getStackTraceString());
                    cdList = BRAINFAObjectSOQLManager.queryCapDesignListById(capDesignId);
                }
                /**********************************************************************************************
                 * QFCJ-4861 NMACapitalDesigns will not have Offers associated as they are "Non-Marketing"
                 **********************************************************************************************/ 
                if (callSource.equalsIgnoreCase('CapitalDesign')) { 
                    List<Offer__c> offerList = BRAINFAObjectSOQLManager.queryOfferListByAssocCDIdForBRAINBAU(cdList != null ? cdList.size() > 0 ? cdList.get(0) != null ? cdList.get(0).Id : null : null : null);
                    System.debug('(BRAINFinancialAnalysesUpdateController.updateForBRAINFAResults) offerList == null??? ' + (offerList == null) + '\n  offerList?.size() = ' + offerList?.size());
                    if (offerList != null && offerList.size() > 0) {
                        BRAINFAObjectDMLManager.updateOfferBAUFromBACT(offerList, cdList, updateParams);            
                    }
                }
                returnList = new List<Boolean>();
                returnList.add(true);
                return returnList;
            }
            if ((callSource.equalsIgnoreCase('Offer')) || (callSource.equalsIgnoreCase('APVOffer'))) {
                List<Offer__c> offerList = BRAINFAObjectSOQLManager.queryOfferListByAssocCDIdForOfferCapEval(capDesignId);
                System.debug('(BRAINFinancialAnalysesUpdateController.updateForBRAINFAResults) offerList == null??? ' + (offerList == null) + '\n  offerList?.size() = ' + offerList?.size());
                if (offerList != null && offerList.size() > 0) {
                    try {
                    	offerList = BRAINFAObjectDMLManager.updateOfferCapEvalFromBACT(offerList, updateParams);            
                    }  catch(Exception updCDX) {
                        System.debug('(BRAINFinancialAnalysesUpdateController.updateForBRAINFAResults) EXCEPTION! \n Type: ' + updCDX.getTypeName() + '\n Message:  ' + updCDX.getMessage() + '\n Line#: ' + updCDX.getLineNumber() + '\n StackTrace:  ' + updCDX.getStackTraceString());
                        offerList = BRAINFAObjectSOQLManager.queryOfferListByAssocCDIdForOfferCapEval(capDesignId);
                    }
                }
                returnList = new List<Boolean>();
                returnList.add(true);
                return returnList;
            }            
/**************************************************************************************************************************
 * BEING REPLACED __ 2023/06/08 QFCJ-3938 https://ctl.atlassian.net/browse/QFCJ-3938
            String assocOfferId = (cdList != null ? cdList.get(0) != null ? cdList.get(0).Offer__c : ' ' : ' ');
            System.debug('(BRAINFinancialAnalysesUpdateController.updateForBRAINFAResults) assocOfferId == null??? ' + (assocOfferId == null) + '\n  assocOfferId = ' + assocOfferId);
            if (String.isNotBlank(assocOfferId)) {
                List<Offer__c> offerList = BRAINFAObjectSOQLManager.queryOfferListById(assocOfferId, capDesignId);
                System.debug('(BRAINFinancialAnalysesUpdateController.updateForBRAINFAResults) offerList == null??? ' + (offerList == null) + '\n  offerList?.size() = ' + offerList?.size());
                BRAINFAObjectDMLManager.updateOfferBAUFromBACT(offerList, cdList, updateParams);            
            }
**************************************************************************************************************************/
        } catch(Exception checkParamsX) {
            System.debug('(BRAINFinancialAnalysesUpdateController.updateForBRAINFAResults) EXCEPTION! \n Type: ' + checkParamsX.getTypeName() + '\n Message:  ' + checkParamsX.getMessage() + '\n Line#: ' + checkParamsX.getLineNumber() + '\n StackTrace:  ' + checkParamsX.getStackTraceString());
            returnList = new List<Boolean>();
            returnList.add(false);
        }        
        return returnList;
    }//end method updateForBRAINFAResults
    
    public List<Boolean> automatedUpdateForBRAINFAResults(List<UpdateParams> updateParams) {
        String capDesignId = null;
        String bacTrackerId = null;
        String callSource = null;
        List<Boolean> returnList = new List<Boolean>();
        
        try {        
            if (updateParams == null || updateParams.size() == 0) {
                updateParams = this.updParamsList;
            }
            //Extract parameters into the key variables
            System.debug('(BRAINFinancialAnalysesUpdateController.automatedUpdateForBRAINFAResults) updateParams.size() = ' + updateParams.size());
            capDesignId = updateParams.get(0).capDesignId;
            bacTrackerId = updateParams.get(0).bacTrackerId;
            callSource = updateParams.get(0).callSource;
            
            System.debug('(BRAINFinancialAnalysesUpdateController.automatedUpdateForBRAINFAResults) capDesignId = ' + capDesignId +
                          '\n bacTrackerId = ' + bacTrackerId + '\n callSource = ' + callSource);
            
            if (String.isBlank(capDesignId) || String.isBlank(bacTrackerId) || String.isBlank(callSource)) {
                throw new InvalidParameterParsingException();
            }
            /**********************************************************************************************
             * QFCJ-4861 NMACapitalDesigns also need updated with BRAIN results 
             **********************************************************************************************/ 
            if (callSource.equalsIgnoreCase('CapitalDesign') || callSource.equalsIgnoreCase('NMACapitalDesign')) {
                List<Capital_Design__c> cdList = new List<Capital_Design__c>();
                try {
                	cdList = BRAINFAObjectDMLManager.updateCDFromBACT(updateParams);
                }  catch(Exception updCDX) {
		            System.debug('(BRAINFinancialAnalysesUpdateController.automatedUpdateForBRAINFAResults) EXCEPTION! \n Type: ' + updCDX.getTypeName() + '\n Message:  ' + updCDX.getMessage() + '\n Line#: ' + updCDX.getLineNumber() + '\n StackTrace:  ' + updCDX.getStackTraceString());
                    cdList = BRAINFAObjectSOQLManager.queryCapDesignListById(capDesignId);
                }               
                /**********************************************************************************************
                 * QFCJ-4861 NMACapitalDesigns will not have Offers associated as they are "Non-Marketing"
                 **********************************************************************************************/ 
                if (callSource.equalsIgnoreCase('CapitalDesign')) {
                    List<Offer__c> offerList = BRAINFAObjectSOQLManager.queryOfferListByAssocCDIdForBRAINBAU(capDesignId);
                    System.debug('(BRAINFinancialAnalysesUpdateController.automatedUpdateForBRAINFAResults) offerList == null??? ' + (offerList == null) + '\n  offerList?.size() = ' + offerList?.size());
                    if (offerList != null && offerList.size() > 0) {
                        BRAINFAObjectDMLManager.updateOfferBAUFromBACT(offerList, cdList, updateParams);            
                    }
                }
                returnList = new List<Boolean>();
                returnList.add(true);
                return returnList;
            }
            if (callSource.equalsIgnoreCase('Offer')) {
                List<Offer__c> offerList = BRAINFAObjectSOQLManager.queryOfferListByAssocCDIdForOfferCapEval(capDesignId);
                System.debug('(BRAINFinancialAnalysesUpdateController.automatedUpdateForBRAINFAResults) offerList == null??? ' + (offerList == null) + '\n  offerList?.size() = ' + offerList?.size());
                if (offerList != null && offerList.size() > 0) {
                    try {
                        offerList = BRAINFAObjectDMLManager.updateOfferCapEvalFromBACT(offerList, updateParams);            
                    }  catch(Exception updCDX) {
                        System.debug('(BRAINFinancialAnalysesUpdateController.automatedUpdateForBRAINFAResults) EXCEPTION! \n Type: ' + updCDX.getTypeName() + '\n Message:  ' + updCDX.getMessage() + '\n Line#: ' + updCDX.getLineNumber() + '\n StackTrace:  ' + updCDX.getStackTraceString());
                        offerList = BRAINFAObjectSOQLManager.queryOfferListByAssocCDIdForOfferCapEval(capDesignId);
                    }
                }
                returnList = new List<Boolean>();
                returnList.add(true);
                return returnList;
            }            
/**************************************************************************************************************************
 * BEING REPLACED __ 2023/06/08 QFCJ-3938 https://ctl.atlassian.net/browse/QFCJ-3938
            String assocOfferId = (cdList != null ? cdList.get(0) != null ? cdList.get(0).Offer__c : ' ' : ' ');
            System.debug('(BRAINFinancialAnalysesUpdateController.automatedUpdateForBRAINFAResults) assocOfferId == null??? ' + (assocOfferId == null) + '\n  assocOfferId = ' + assocOfferId);
            if (String.isNotBlank(assocOfferId)) {
                List<Offer__c> offerList = BRAINFAObjectSOQLManager.queryOfferListById(assocOfferId, capDesignId);
                System.debug('(BRAINFinancialAnalysesUpdateController.automatedUpdateForBRAINFAResults) offerList == null??? ' + (offerList == null) + '\n  offerList?.size() = ' + offerList?.size());
                BRAINFAObjectDMLManager.updateOfferBAUFromBACT(offerList, cdList, updateParams);            
            }
**************************************************************************************************************************/
        } catch(Exception checkParamsX) {
            System.debug('(BRAINFinancialAnalysesUpdateController.automatedUpdateForBRAINFAResults) EXCEPTION! \n Type: ' + checkParamsX.getTypeName() + '\n Message:  ' + checkParamsX.getMessage() + '\n Line#: ' + checkParamsX.getLineNumber() + '\n StackTrace:  ' + checkParamsX.getStackTraceString());
            try {
	            BRAIN_Automation_Fault__c excFault = BRAINFACalloutHelper.buildBaseFault(checkParamsX.getMessage(), checkParamsX.getStackTraceString());
                BRAINFACalloutHelper.associateFaultToCapDesignByCapDesId(excFault, capDesignId);
	        } catch(Exception faultX) {
	            System.debug('(BRAINFinancialAnalysesUpdateController.automatedUpdateForBRAINFAResults) EXCEPTION! \n Type: ' + faultX.getTypeName() + '\n Message:  ' + faultX.getMessage() + '\n Line#: ' + faultX.getLineNumber() + '\n StackTrace:  ' + faultX.getStackTraceString());
            }
            returnList = new List<Boolean>();
            returnList.add(false);
        }
        return returnList;        
    }//end method automatedUpdateForBRAINFAResults
    
    public void clearState() {
    	this.capDesignId = null;
    	this.bacTrackerId = null;
        this.callSource = null;
    	this.updParamsList = null;
    }//end method  clearState

}//end class BRAINFinancialAnalysesUpdateController