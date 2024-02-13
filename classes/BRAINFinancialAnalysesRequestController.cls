/****************************************************************************************************************************
 * Name:  BRAINFinancialAnalysesRequestController
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for Request aspect of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFinancialAnalysesRequestController
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 05/06/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version
 * 06/03/2022   T2Cabato    Feature(Epic) ESCJ-337	        Request-Only version (split off from original)
 * 06/23/2022   T2Cabato    Feature(Epic) ESCJ-337	        Refactored for code coverage when testing without data existing
 * 11/10/2022   T2Cabato    Feature(Epic) ESCJ-1946			Converting to Queueable for ESCJ-1744 Automatic Trigger on CapDes Status Planner Design Complete
 * 01/27/2023   T2Cabato    Story ESCJ-2365                 Revised per Story
 * 06/13/2023   T2Cabato    QFCJ-3801                       BRAIN-AutoSubmit-Messaging
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
******************************************************************************************************************************/
public with sharing class BRAINFinancialAnalysesRequestController implements Queueable, Database.AllowsCallouts {
    private class ZeroListException extends Exception {}
    private class InvalidParameterParsingException extends Exception {}
    private class NullCallAfterBuildException extends Exception {}
    public String reqCapDesignName;
    public String reqOfferId;
    public String reqSubmitterCuid;
    public String reqCallSource;
    public String faRequestId;
    public String requestJSON;
    public List<BRAINFinancialAnalysesRequestController.RequestParams> reqParamsList;
    public List<List<BRAIN_FA_Request__c>> requestListCollection; 
    
    public BRAINFinancialAnalysesRequestController(String capDesignNameIn, String offerIdIn, String submitterCuidIn, String callSourceIn) {
        this.reqCapDesignName = capDesignNameIn;
        this.reqOfferId = offerIdIn;
        this.reqSubmitterCuid = submitterCuidIn;
        this.reqCallSource = callSourceIn;
        //Create list of parameters to be sent to prepareRequestForFinancialAnalyses
        this.reqParamsList = new List<BRAINFinancialAnalysesRequestController.RequestParams>();
        BRAINFinancialAnalysesRequestController.RequestParams rp = new BRAINFinancialAnalysesRequestController.RequestParams();
        rp.capDesignName = this.reqCapDesignName;
        rp.offerId = this.reqOfferId;
        rp.submitterCuid = this.reqSubmitterCuid;
        rp.callSource = this.reqCallSource;
        this.reqParamsList.add(rp);
    }//end  constructor

    public void execute(QueueableContext ctx) { 
        try {
            this.requestListCollection = automatedPrepareRequestForFinancialAnalyses(this.reqParamsList);
            this.faRequestId = this.requestListCollection?.get(0)?.get(0)?.Id;
            this.requestJSON = this.requestListCollection?.get(0)?.get(0)?.Constructed_JSON__c;
            BRAINFinancialAnalysesCalloutController calloutController = new BRAINFinancialAnalysesCalloutController(this.faRequestId, this.requestJSON, this.reqCallSource);
            if(Test.isRunningTest()) {
                calloutController.execute(null);
            } else {
                String callJobId = System.enqueueJob(calloutController);
                System.debug('(BRAINFinancialAnalysesRequestController.execute) callJobId = ' + callJobId);
            }
            this.clearState();
        } catch(Exception mainX) {
            System.debug('(BRAINFinancialAnalysesRequestController.execute) EXCEPTION! \n Type: ' + mainX.getTypeName() + '\n Message:  ' + mainX.getMessage() + '\n Line#: ' + mainX.getLineNumber() + '\n StackTrace:  ' + mainX.getStackTraceString());
            throw mainX;
        }
    }//end method execute
    
    public class RequestParams {
        @invocableVariable(label='Capital Design Name' description='The Name of the Capital_Design__c record' required=true)
        public String capDesignName;
        @invocableVariable(label='Offer Id' description='The Id of the specific Offer for which will be seeking Financial Analyses as associated to the specified Capital_Design__c record' required=false)
        public String offerId;
        @invocableVariable(label='Submitter CUID' description='The CUID of the User who submitted to BRAIN' required=true)
        public String submitterCuid;
        @invocableVariable(label='Call Source' description='The source from which the Call was being made (Offer, APVOffer, CapitalDesign)' required=true)
        public String callSource;
    }
    
    @InvocableMethod(label='Prepare Request for BRAIN Financial Analyses'
                     description='Prepare the request for financial viability'
                     category='BRAIN API Call Tracker')
    public static List<List<BRAIN_FA_Request__c>> prepareRequestForFinancialAnalyses(List<RequestParams> requestParams) {        
        String capDesignName = null;
        String offerId = null;
        String submitterCuid = null;
        String callSource = null;

        try {
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) Starting with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) BEGIN Parsing requestParams with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            //Extract parameters into the key variables
            capDesignName = requestParams.get(0).capDesignName;
            offerId = requestParams.get(0).offerId;
            submitterCuid = requestParams.get(0).submitterCuid;
            callSource = requestParams.get(0).callSource;
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) END Parsing requestParams with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) capDesignName = ' + capDesignName + '\n offerId = ' + offerId + '\n submitterCuid = ' + submitterCuid + '\n callSource = ' + callSource);
            
            if (String.isBlank(capDesignName) || String.isBlank(submitterCuid) || String.isBlank(callSource) || (String.isNotBlank(callSource) && (callSource.equalsIgnoreCase('offer') || callSource.equalsIgnoreCase('apvoffer')) && String.isBlank(offerId))) {
                throw new InvalidParameterParsingException();
            }

            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) BEGIN Building baseFACall with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            //build the base faCall
	        BRAIN_API_Call_Tracker__c faCall = new BRAIN_API_Call_Tracker__c();
            faCall = BRAINFARequestHelper.buildBaseFACall(capDesignName, offerId, submitterCuid, callSource);
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) faCall?.Id = ' + faCall?.Id);
            //set the initial Request Id and Response Id values as null because they have not yet been created
            faCall.BRAIN_FA_Request__c = null;
            faCall.BRAIN_FA_Response__c = null;
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) END Building baseFACall with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) BEGIN Composing FA-Request with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            //compose the faRequest
	        BRAIN_FA_Request__c  faRequest = new BRAIN_FA_Request__c();
            faRequest = BRAINFARequestHelper.composeFARequest(requestParams, faCall);
            requestParams = null;
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) faRequest.Id = ' + (faRequest != null ? faRequest.Id : null));
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) END Composing FA-Request with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) BEGIN Setting requestCallList with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
	        List<BRAIN_FA_Request__c> requestCallList = new List<BRAIN_FA_Request__c>();
            requestCallList.add(faRequest);
            faRequest = null;
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) END Setting requestCallList with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) BEGIN Setting requestListCollection with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) requestCallList is NULL? ' + (requestCallList==null) + '  AND requestCallList?.size() = ' + requestCallList?.size());
	        List<List<BRAIN_FA_Request__c>> requestListCollection = new List<List<BRAIN_FA_Request__c>>();
            requestListCollection.add(requestCallList);
            requestCallList = null;
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) requestListCollection is NULL? ' + (requestListCollection==null) + '  AND requestListCollection?.size() = ' + requestListCollection?.size());
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) END Setting requestListCollection with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            //return the List/Collection of BRAIN_FA_Request__c Lists for Flow
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses)PRIOR to RETURNING >>> ' +
                         '\n requestListCollection?.size() = ' + requestListCollection?.size() +
                         '\n requestListCollection?.get(0)?.get(0)?.Id = ' + requestListCollection?.get(0)?.get(0)?.Id +
                         '\n requestListCollection?.get(0)?.get(0)?.Constructed_JSON__c = ' + requestListCollection?.get(0)?.get(0)?.Constructed_JSON__c);
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) Completing with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            return requestListCollection;
        } catch(Exception mainX) {
            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) EXCEPTION! \n Type: ' + mainX.getTypeName() + '\n Message:  ' + mainX.getMessage() + '\n Line#: ' + mainX.getLineNumber() + '\n StackTrace:  ' + mainX.getStackTraceString());
            try {
	            BRAIN_Automation_Fault__c excFault = BRAINFACalloutHelper.buildBaseFault(mainX.getMessage(), mainX.getStackTraceString());
                BRAINFACalloutHelper.associateFaultToCapDesignByCapDesName(excFault, capDesignName);
	        } catch(Exception faultX) {
	            System.debug('(BRAINFinancialAnalysesRequestController.prepareRequestForFinancialAnalyses) EXCEPTION! \n Type: ' + faultX.getTypeName() + '\n Message:  ' + faultX.getMessage() + '\n Line#: ' + faultX.getLineNumber() + '\n StackTrace:  ' + faultX.getStackTraceString());
            }
            throw mainX;
        }
    }//end method prepareRequestFinancialAnalyses 

    public List<List<BRAIN_FA_Request__c>> automatedPrepareRequestForFinancialAnalyses(List<RequestParams> requestParams) {        
        String capDesignName = null;
        String offerId = null;
        String submitterCuid = null;
        String callSource = null;

        try {
            if (requestParams == null || requestParams.size() == 0) {
                requestParams = this.reqParamsList;
            }
            //Extract parameters into the key variables
            capDesignName = requestParams.get(0).capDesignName;
            offerId = requestParams.get(0).offerId;
            submitterCuid = requestParams.get(0).submitterCuid;
            callSource = requestParams.get(0).callSource;
            System.debug('(BRAINFinancialAnalysesRequestController.automatedPrepareRequestForFinancialAnalyses) capDesignName = ' + capDesignName + '\n offerId = ' + offerId +
                          '\n submitterCuid = ' + submitterCuid + '\n callSource = ' + callSource);
            
            if (String.isBlank(capDesignName) || String.isBlank(submitterCuid) || String.isBlank(callSource) || (String.isNotBlank(callSource) && (callSource.equalsIgnoreCase('offer') || callSource.equalsIgnoreCase('apvoffer')) && String.isBlank(offerId))) {
                throw new InvalidParameterParsingException();
            }
            //build the base faCall
        	BRAIN_API_Call_Tracker__c faCall = new BRAIN_API_Call_Tracker__c();
            faCall = BRAINFARequestHelper.buildBaseFACall(capDesignName, offerId, submitterCuid, callSource);
            System.debug('(BRAINFinancialAnalysesRequestController.automatedPrepareRequestForFinancialAnalyses) faCall?.Id = ' + faCall?.Id);
            //set the initial Request Id and Response Id values as null because they have not yet been created
            faCall.BRAIN_FA_Request__c = null;
            faCall.BRAIN_FA_Response__c = null;
            
            //compose the faRequest
        	BRAIN_FA_Request__c  faRequest = new BRAIN_FA_Request__c();
            faRequest = BRAINFARequestHelper.composeFARequest(requestParams, faCall);
            System.debug('(BRAINFinancialAnalysesRequestController.automatedPrepareRequestForFinancialAnalyses) faRequest.Id = ' + (faRequest != null ? faRequest.Id : null));
            
        	List<BRAIN_FA_Request__c> requestCallList = new List<BRAIN_FA_Request__c>();
            requestCallList.add(faRequest);
        	List<List<BRAIN_FA_Request__c>> requestListCollection = new List<List<BRAIN_FA_Request__c>>();
            requestListCollection.add(requestCallList);
            System.debug('(BRAINFinancialAnalysesRequestController.automatedPrepareRequestForFinancialAnalyses)PRIOR to RETURNING >>> ' +
                         '\n requestListCollection?.size() = ' + requestListCollection?.size() +
                         '\n requestListCollection?.get(0)?.get(0)?.Id = ' + requestListCollection?.get(0)?.get(0)?.Id +
                         '\n requestListCollection?.get(0)?.get(0)?.Constructed_JSON__c = ' + requestListCollection?.get(0)?.get(0)?.Constructed_JSON__c);
            //return the List/Collection of BRAIN_FA_Request__c Lists for Flow
            return requestListCollection;
        } catch(Exception mainX) {
            System.debug('(BRAINFinancialAnalysesRequestController.automatedPrepareRequestForFinancialAnalyses) EXCEPTION! \n Type: ' + mainX.getTypeName() + '\n Message:  ' + mainX.getMessage() + '\n Line#: ' + mainX.getLineNumber() + '\n StackTrace:  ' + mainX.getStackTraceString());
            try {
	            BRAIN_Automation_Fault__c excFault = BRAINFACalloutHelper.buildBaseFault(mainX.getMessage(), mainX.getStackTraceString());
                BRAINFACalloutHelper.associateFaultToCapDesignByCapDesName(excFault, capDesignName);
	        } catch(Exception faultX) {
	            System.debug('(BRAINFinancialAnalysesRequestController.automatedPrepareRequestForFinancialAnalyses) EXCEPTION! \n Type: ' + faultX.getTypeName() + '\n Message:  ' + faultX.getMessage() + '\n Line#: ' + faultX.getLineNumber() + '\n StackTrace:  ' + faultX.getStackTraceString());
            }
            throw mainX;
        }
    }//end method automatedPrepareRequestForFinancialAnalyses

    public void clearState() {
        this.reqCapDesignName = null;
        this.reqOfferId = null;
        this.reqSubmitterCuid = null;
        this.reqCallSource = null;
    	this.faRequestId = null;
    	this.requestJSON = null;
    	this.reqParamsList = null;
        this.requestListCollection = null;
    }//end method clearState
    
}//end class BRAINFinancialAnalysesRequestController