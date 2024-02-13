/***************************************************************************************************
 * Name:  NRMACalloutController
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for BRAIN/NRMA Approval-Tool interaction between SFCJ and BRAIN API
 * Code Coverage:  TestNRMACalloutController -- 88%  01/04/2023
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 01/04/2023  	T2Cabato    Feature(Epic) ESCJ-3932	        Base version
****************************************************************************************************/
public with sharing class NRMACalloutController implements Queueable, Database.AllowsCallouts {
    private class NullObjectException extends Exception {} 
    private class BlankStringException extends Exception {}
    private class InvalidParameterParsingException extends Exception {}
    public String nrmaRecordId;
    public String nrmaCallType;
	public List<NRMACalloutController.CalloutParams> coParamsList;
    
    public NRMACalloutController(String recordIdIn, String callTypeIn) {
        this.nrmaRecordId = recordIdIn; 
        this.nrmaCallType = callTypeIn;
        //Create list of parameters to be sent to prepareRequestForApprovalTool
        this.coParamsList = new List<NRMACalloutController.CalloutParams>();
        NRMACalloutController.CalloutParams cp = new NRMACalloutController.CalloutParams();
        cp.nrmaRecordId = this.nrmaRecordId;
        cp.nrmaCallType = this.nrmaCallType;
        this.coParamsList.add(cp);
    }//end constructor 
    
    public void execute(QueueableContext ctx) { 
        System.debug('(NRMACalloutController.execute) this.nrmaRecordId = ' + this.nrmaRecordId + '\n this.nrmaCallType = ' + this.nrmaCallType);
        this.automatedCallNRMA(this.coParamsList);
        this.clearState();
    }//end method execute

    public class CalloutParams { 
        @invocableVariable(label='NRMA Record Id' description='The id of the NRMA__c record' required=true)
        public String nrmaRecordId;
        @invocableVariable(label='NRMACallType' description='The Approval-Tool Call Type (Request or Status)' required=true)
        public String nrmaCallType;
    }
    
    @InvocableMethod(label='Callout to BRAIN API NRMA Approval Tool'
                     description='Perform callout to BRAIN API for NRMA Approval Tool, returning the results in the form of JSON'
                     callout=true
                     category='BRAIN API NRMA Approval Tool')
    public static List<String> callNRMA(List<CalloutParams> calloutParams) {
        List<String> returnMessageList = new List<String>();
        String displayCallType = null;
        NRMA__c displayNRMARecord = null;
        try {        
            //Extract parameters into the key variables
            System.debug('(NRMACalloutController.callNRMA) calloutParams.size() = ' + calloutParams.size());
            String recordId = calloutParams.get(0).nrmaRecordId;
            String callType = calloutParams.get(0).nrmaCallType;
            System.debug('(NRMACalloutController.callNRMA) recordId = ' + recordId +
                          '\n callType = ' + callType);
            
            if (String.isBlank(recordId) || String.isBlank(callType) || (callType != 'Request' && callType != 'Status')) {
                throw new InvalidParameterParsingException('EXCEPTION! NRMA Record-Id cannot be NULL or BLANK, and CallType must be either "Request" or "Status".');
            }
            displayCallType = callType;

            //query for the NRMA Request record by its record-id
            List<NRMA__c> nrmaList = NRMARequestHelper.queryNRMARecordListById(recordId);
            displayNRMARecord = nrmaList?.get(0);

            //construct the Body in JSON format of the HttpRequest based on the fields and values of the NRMA Request record by its record-id
            String requestJSON = NRMARequestHelper.constructJSONFromNRMAObj(nrmaList);

            String responseJSON = NRMACalloutHelper.executeCallout(calloutParams, requestJSON, nrmaList?.get(0)?.NRMA_Request_ID__c);
            System.debug('(NRMACalloutController.callNRMA) responseJSON = ' + responseJSON);

            //parse the JSON-body of the HttpResponse based on the specified callType (Request or Status)
            nrmaList = NRMAResponseHelper.parseResponseJSONByCallType(callType, nrmaList, responseJSON);
            displayNRMARecord = nrmaList?.get(0);

            //Update the returned nrmaList
            nrmaList = NRMAResponseHelper.updateNRMAList(nrmaList);
            displayNRMARecord = nrmaList?.get(0);
            returnMessageList.add('The ' + displayCallType + ' Call made to the NRMA-API for the NRMA-Request ' + displayNRMARecord?.Name + (String.isNotEmpty(displayNRMARecord?.NRMA_Request_ID__c) ? ' returned as "SUCCESS" with NRMA-Request-ID ' + displayNRMARecord?.NRMA_Request_ID__c : '' ) + '.  The NRMA record will have updated should any results have returned from the NRMA API Service Callout.');
        } catch(Exception callX) {
            System.debug('(NRMACalloutController.callNRMA) EXCEPTION! \n Type: ' + callX.getTypeName() + '\n Message:  ' + callX.getMessage() + '\n Line#: ' + callX.getLineNumber() + '\n StackTrace:  ' + callX.getStackTraceString());
            returnMessageList = new List<String>();
            returnMessageList.add('The ' + displayCallType + ' Call made to the NRMA-API for the NRMA-Request ' + displayNRMARecord?.Name + ' returned as "FAILURE"' + (String.isNotEmpty(displayNRMARecord?.NRMA_Request_ID__c) ? ' with NRMA-Request-ID ' + displayNRMARecord?.NRMA_Request_ID__c : '' ) + '.  \n\nErrorMessage: ' + callX.getMessage() + '\n StackTrace: ' + callX.getStackTraceString());
        }
        return returnMessageList;
    }//end method callNRMA
    
    public void automatedCallNRMA(List<CalloutParams> calloutParams) {
        try {        
            //Extract parameters into the key variables
            System.debug('(NRMACalloutController.automatedCallNRMA) calloutParams.size() = ' + calloutParams.size());
            String recordId = calloutParams.get(0).nrmaRecordId;
            String callType = calloutParams.get(0).nrmaCallType;
            System.debug('(NRMACalloutController.automatedCallNRMA) recordId = ' + recordId +
                          '\n callType = ' + callType);
            
            if (String.isBlank(recordId) || String.isBlank(callType) || (callType != 'Request' && callType != 'Status')) {
                throw new InvalidParameterParsingException('EXCEPTION! NRMA Record-Id cannot be NULL or BLANK, and CallType must be either "Request" or "Status".');
            } 
            //query for the NRMA Request record by its record-id
            List<NRMA__c> nrmaList = NRMARequestHelper.queryNRMARecordListById(recordId);
            
            //construct the Body in JSON format of the HttpRequest based on the fields and values of the NRMA Request record by its record-id
            String requestJSON = NRMARequestHelper.constructJSONFromNRMAObj(nrmaList);

            String responseJSON = NRMACalloutHelper.executeCallout(calloutParams, requestJSON, nrmaList?.get(0)?.NRMA_Request_ID__c);
            
            //parse the JSON-body of the HttpResponse based on the specified callType (Request or Status)
            nrmaList = NRMAResponseHelper.parseResponseJSONByCallType(callType, nrmaList, responseJSON);

            //Update the returned nrmaList
            nrmaList = NRMAResponseHelper.updateNRMAList(nrmaList);
        } catch(Exception callX) {
            System.debug('(NRMACalloutController.automatedCallNRMA) EXCEPTION! \n Type: ' + callX.getTypeName() + '\n Message:  ' + callX.getMessage() + '\n Line#: ' + callX.getLineNumber() + '\n StackTrace:  ' + callX.getStackTraceString());
        }
    }//end method automatedCallNRMA
    
    public void clearState() {
    	this.nrmaRecordId = null;
    	this.nrmaCallType = null;
    	this.coParamsList = null;
    }//end method clearState

}//end class NRMACalloutController