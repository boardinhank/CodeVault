/***************************************************************************************************
 * Name:  BRAINFinancialAnalysesCalloutController
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFinancialAnalysesCalloutController -- 88%  05/12/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 05/06/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version
 * 06/03/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Callout-Only version (split off from original)
 * 11/10/2022   T2Cabato    Feature(Epic) ESCJ-1946			Converting to Queueable for ESCJ-1744 Automatic Trigger on CapDes Status Planner Design Complete
 * 01/27/2023   T2Cabato    Story ESCJ-2365                 Revised per Story
 * 06/13/2023   T2Cabato    QFCJ-3801                       BRAIN-AutoSubmit-Messaging
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
 * 08/02/2023   T2Cabato    QFCJ-4286                       BRAIN-Drop-Cost-Fix
 * 08/15/2023   T2Cabato    QFCJ-4282                       BRAIN-ONT-Model-Mapping
 * 08/15/2023   T2Cabato    QFCJ-4297                       BRAIN-UPS-Shelf-to-idfElectronics-for-BRAIN
 * 08/15/2023   T2Cabato    QFCJ-4309                       BRAIN-ContractType-and-OtherProviderContractType-Mapping
 * 08/18/2023   T2Cabato    QFCJ-4397                       Heap-Size-Too-Large on manual Submit to BRAIN
****************************************************************************************************/
public with sharing class BRAINFinancialAnalysesCalloutController implements Queueable, Database.AllowsCallouts {
    public class InvalidParameterParsingException extends Exception {}
    public class InvalidHttpResponseException extends Exception {}
    public class UnauthorizedAccessException extends Exception {}
    public class UnhappyStatusCodeHttpResponseException extends Exception {}
    public String coRequestId;
    public String coRequestJSON;
    public String coResponseJSON;
    public String coCallSource;
	public List<BRAINFinancialAnalysesCalloutController.CalloutParams> coParamsList;
    //public List<List<String>> coResponseListCollection;
    
    public BRAINFinancialAnalysesCalloutController(String faRequestIdIn, String requestJSONIn, String callSourceIn) {
        this.coRequestId = faRequestIdIn;
        this.coRequestJSON = requestJSONIn;
        this.coCallSource = callSourceIn;
        //Create list of parameters to be sent to prepareRequestForFinancialAnalyses
        this.coParamsList = new List<BRAINFinancialAnalysesCalloutController.CalloutParams>();
        BRAINFinancialAnalysesCalloutController.CalloutParams cp = new BRAINFinancialAnalysesCalloutController.CalloutParams();
        cp.faRequestId = this.coRequestId;
        cp.requestJSON = this.coRequestJSON;
        cp.callSource = this.coCallSource;
        this.coParamsList.add(cp);
    }//end  constructor 
    
    public void execute(QueueableContext ctx) { 
		/*this.coResponseListCollection*/List<List<String>> coResponseListCollection = automatedCallBRAINFinancialAnalyses(this.coParamsList);
        this.coResponseJSON = /*this.*/coResponseListCollection?.get(0)?.get(0);
        System.debug('(BRAINFinancialAnalysesCalloutController.execute) this.coRequestId = ' + this.coRequestId + '\n this.coResponseJSON = ' + this.coResponseJSON);
        BRAINFinancialAnalysesResponseController responseController = new BRAINFinancialAnalysesResponseController(this.coRequestId, this.coResponseJSON, this.coCallSource);
        if(Test.isRunningTest()) {
	        responseController.execute(null);
        } else {
            String responseJobId = System.enqueueJob(responseController);
            System.debug('(BRAINFinancialAnalysesCalloutController.execute) responseJobId = ' + responseJobId);
        }
        this.clearState();
    }//end method execute

    public class CalloutParams {
        @invocableVariable(label='FARequest Id' description='The id of the BRAIN_FA_Request__c record' required=true)
        public String faRequestId;
        @invocableVariable(label='FARequest JSON' description='The Constructed JSON of the BRAIN_FA_Request__c record' required=true)
        public String requestJSON;
        @invocableVariable(label='Call Source' description='The source from which the Call was being made (Offer, APVOffer, CapitalDesign)' required=true)
        public String callSource;
    }
    
    @InvocableMethod(label='Callout to BRAIN Financial Analyses'
                     description='Perform callout to BRAIN for financial viability, returning the results in the form of JSON'
                     callout=true
                     category='BRAIN API Call Tracker')
    public static List<List<String>> callBRAINFinancialAnalyses(List<CalloutParams> calloutParams) {
        List<String> responseList = new List<String>();
        List<List<String>> responseListCollection = new List<List<String>>();
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String callSource = null;
        HttpRequest httpRequestBRAIN = new HttpRequest();
        HttpResponse httpResponseBRAIN = new HttpResponse();
        Time startTime;
      	Time endTime;	
        String callingApiName = 'BRAINFinancialAnalyses';
        String errorMsg = null;
        
        try {        
            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) Starting with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

            //Extract parameters into the key variables
            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) BEGIN Parsing calloutParams with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) calloutParams.size() = ' + calloutParams.size());
            faRequestId = calloutParams.get(0).faRequestId;
            requestJSON = calloutParams.get(0).requestJSON;
            callSource = calloutParams.get(0).callSource;
            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) END Parsing calloutParams with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) faRequestId = ' + faRequestId + '\n requestJSON = ' + requestJSON + '\n callSource = ' + callSource);
            
            if (String.isBlank(faRequestId) || String.isBlank(requestJSON) || String.isBlank(callSource)) {
                throw new InvalidParameterParsingException();
            } else {
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) BEGIN Building HttpRequest for accessToken with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                accessToken = BRAINFACalloutHelper.getAccessTokenFromApigee();
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) END Building HttpRequest for accessToken with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) BEGIN Building HttpRequest for BRAIN-FA with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
		        httpRequestBRAIN = BRAINFACalloutHelper.buildHttpRequestForBRAINFAService(accessToken, requestJSON);
                accessToken = null;
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) END Building HttpRequest for BRAIN-FA with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

                System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) BEGIN Getting HttpResponseFromBRAINFAService with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
		        httpResponseBRAIN = BRAINFACalloutHelper.getHttpResponseFromBRAINFAService(httpRequestBRAIN);
                System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) httpResponseBRAIN.getStatusCode() = ' + httpResponseBRAIN.getStatusCode());
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) END Getting HttpResponseFromBRAINFAService with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

                // Create API Transaction record for history and reports
                startTime = DateTime.now().Time();
                endTime = DateTime.now().Time();
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) BEGIN Creating APITransaction with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                BRAINFACalloutHelper.createApiTransaction(
                    httpResponseBRAIN, // HttpResponse
                    httpRequestBRAIN, // HttpRequest
                    callingApiName,
                    startTime,
                    endTime,
                    errorMsg, // errorDetails,
                    faRequestId); // BRAIN_FA_Request__r.Id                                            
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) END Creating APITransaction with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

                callingApiName = null;
                startTime = null;
                endTime = null;
                errorMsg = null;
				httpRequestBRAIN = null;                

	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) BEGIN Extracting Data from HttpResponse with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                Boolean canExtract = BRAINFACalloutHelper.canExtractDataFromHttpResponse(httpResponseBRAIN, faRequestId);
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) END Extracting Data from HttpResponse with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                //System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) httpResponseBRAIN.getBody() = ' + httpResponseBRAIN.getBody());   
            }//end else valid requestParams
        } catch(Exception checkParamsX) {
            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) EXCEPTION! \n Type: ' + checkParamsX.getTypeName() + '\n Message:  ' + checkParamsX.getMessage() + '\n Line#: ' + checkParamsX.getLineNumber() + '\n StackTrace:  ' + checkParamsX.getStackTraceString());
            try {
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) BEGIN Building BRAIN_Automation_Fault__c with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
	            BRAIN_Automation_Fault__c excFault = BRAINFACalloutHelper.buildBaseFault(checkParamsX.getMessage(), checkParamsX.getStackTraceString());
                BRAINFACalloutHelper.associateFaultToCapDesignByRequestId(excFault, faRequestId);
                excFault = null;                
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) END Building BRAIN_Automation_Fault__c with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
	        } catch(Exception faultX) {
	            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) EXCEPTION! \n Type: ' + faultX.getTypeName() + '\n Message:  ' + faultX.getMessage() + '\n Line#: ' + faultX.getLineNumber() + '\n StackTrace:  ' + faultX.getStackTraceString());
            }
        } finally {
            //System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) Returning in responseList, httpResponseBRAIN.getBody() = ' + httpResponseBRAIN.getBody());
            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) BEGIN Setting responseList for Return with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            responseList.add(httpResponseBRAIN?.getBody());
            httpResponseBRAIN = null;
            httpRequestBRAIN = null;
            callingApiName = null;
            startTime = null;
            endTime = null;
            errorMsg = null;
            faRequestId = null;
            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) END Setting responseList for Return with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) BEGIN Setting responseListCollection for Return with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            responseListCollection.add(responseList);
            responseList = null;
            System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) END Setting responseListCollection for Return with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
        }//end finally
        
        System.debug('(BRAINFinancialAnalysesCalloutController.callBRAINFinancialAnalyses) PRIOR TO Returning responseListCollection, Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
        return responseListCollection;
    }//end method callBRAINFinancialAnalyses
    
    public List<List<String>> automatedCallBRAINFinancialAnalyses(List<CalloutParams> calloutParams) {
        List<String> responseList = new List<String>();
        List<List<String>> responseListCollection = new List<List<String>>();
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String responseJSON = null;
        String callSource = null;
        HttpRequest httpRequestBRAIN = new HttpRequest();
        HttpResponse httpResponseBRAIN = new HttpResponse();
        Time startTime;
      	Time endTime;	
        String callingApiName = 'BRAINFinancialAnalyses';
        String errorMsg = null;
        
        try {        
            if (calloutParams == null || calloutParams.size() == 0) {
                calloutParams = this.coParamsList;
            }
            //Extract parameters into the key variables
            System.debug('(BRAINFinancialAnalysesCalloutController.automatedCallBRAINFinancialAnalyses) calloutParams.size() = ' + calloutParams.size());
            faRequestId = calloutParams.get(0).faRequestId;
            requestJSON = calloutParams.get(0).requestJSON;
            callSource = calloutParams.get(0).callSource;
            System.debug('(BRAINFinancialAnalysesCalloutController.automatedCallBRAINFinancialAnalyses) faRequestId = ' + faRequestId +
                          '\n requestJSON = ' + requestJSON + '\n callSource = ' + callSource);
            
            if (String.isBlank(faRequestId) || String.isBlank(requestJSON) || String.isBlank(callSource)) {
                throw new InvalidParameterParsingException();
            }
            accessToken = BRAINFACalloutHelper.getAccessTokenFromApigee();
            httpRequestBRAIN = BRAINFACalloutHelper.buildHttpRequestForBRAINFAService(accessToken, requestJSON);
            httpResponseBRAIN = BRAINFACalloutHelper.getHttpResponseFromBRAINFAService(httpRequestBRAIN);

            // Create API Transaction record for history and reports
            startTime = DateTime.now().Time();
            endTime = DateTime.now().Time();
            BRAINFACalloutHelper.createApiTransaction(
                    httpResponseBRAIN, // HttpResponse
                    httpRequestBRAIN, // HttpRequest
                    callingApiName,
                    startTime,
                    endTime,
                    errorMsg, // errorDetails,
                    faRequestId); // BRAIN_FA_Request__r.Id
            
            System.debug('(BRAINFinancialAnalysesCalloutController.automatedCallBRAINFinancialAnalyses) httpResponseBRAIN.getStatusCode() = ' + httpResponseBRAIN.getStatusCode());
            Boolean canExtract = BRAINFACalloutHelper.canExtractDataFromHttpResponse(httpResponseBRAIN, faRequestId);
            System.debug('(BRAINFinancialAnalysesCalloutController.automatedCallBRAINFinancialAnalyses) responseJSON = ' + httpResponseBRAIN.getBody());                                
        } catch(Exception checkParamsX) {
            System.debug('(BRAINFinancialAnalysesCalloutController.automatedCallBRAINFinancialAnalyses) EXCEPTION! \n Type: ' + checkParamsX.getTypeName() + '\n Message:  ' + checkParamsX.getMessage() + '\n Line#: ' + checkParamsX.getLineNumber() + '\n StackTrace:  ' + checkParamsX.getStackTraceString());
            try {
	            BRAIN_Automation_Fault__c excFault = BRAINFACalloutHelper.buildBaseFault(checkParamsX.getMessage(), checkParamsX.getStackTraceString());
                BRAINFACalloutHelper.associateFaultToCapDesignByRequestId(excFault, faRequestId);
	        } catch(Exception faultX) {
	            System.debug('(BRAINFinancialAnalysesCalloutController.automatedCallBRAINFinancialAnalyses) EXCEPTION! \n Type: ' + faultX.getTypeName() + '\n Message:  ' + faultX.getMessage() + '\n Line#: ' + faultX.getLineNumber() + '\n StackTrace:  ' + faultX.getStackTraceString());
            }
        } finally {
            System.debug('(BRAINFinancialAnalysesCalloutController.automatedCallBRAINFinancialAnalyses) Returning in responseList, httpResponseBRAIN.getBody() = ' + httpResponseBRAIN.getBody());
            responseList.add(httpResponseBRAIN!=null && String.isNotBlank(httpResponseBRAIN.getBody()) ? httpResponseBRAIN.getBody() : '');
            responseListCollection.add(responseList);
            responseList = null;
            responseJSON = null;
            callingApiName = null;
            startTime = null;
            endTime = null;
            errorMsg = null;
            faRequestId = null;
            httpResponseBRAIN = null;
            httpRequestBRAIN = null;
        }
        
        return responseListCollection;
    }//end method automatedCallBRAINFinancialAnalyses
    
    public void clearState() {
        System.debug('(BRAINFinancialAnalysesCalloutController.clearState) BEGIN ClearState with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
    	this.coRequestId = null;
    	this.coRequestJSON = null;
        this.coResponseJSON = null;
        this.coCallSource = null;
    	this.coParamsList = null;
        //this.coResponseListCollection = null;
        System.debug('(BRAINFinancialAnalysesCalloutController.clearState) END ClearState with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
    }//end method clearState

}//end class BRAINFinancialAnalysesCalloutController