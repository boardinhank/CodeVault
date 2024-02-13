/***************************************************************************************************
 * Name:  WCSegCalloutController
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for WireCenter CLLI Segmentation interaction between SFCJ and BRAIN/WC API
 * Code Coverage:  TestWCSegCalloutController -- 100%  07/14/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 07/13/2022  	T2Cabato    Feature(Epic) ESCJ-338	        Base version
 * 07/25/2022   T2Cabato	Feature(Epic) ESCJ-338	        Queueable version
 * 11/17/2023   T2Cabato    QFCJ-4712                       Capital Design - Wire Center Segmentation Update Automation 
 * 12/08/2023	T2Cabato	QFCJ-4712						Revision for Too many queries error
****************************************************************************************************/
global with sharing class WCSegCalloutController implements Queueable, Database.AllowsCallouts { 
    public class NullObjectException extends Exception {}
    public class InvalidParameterParsingException extends Exception {}
	public List<WCSegCalloutController.CalloutParams> coParamsList;

    public WCSegCalloutController() {
        //Create list of parameters to be sent to prepareRequestForFinancialAnalyses
        this.coParamsList = new List<WCSegCalloutController.CalloutParams>();
        WCSegCalloutController.CalloutParams cp = new WCSegCalloutController.CalloutParams();
        cp.wcSegRequestCLLI = '*';//Use * for ALL NWCs
        this.coParamsList.add(cp);		
    }//end constructor
    
    public WCSegCalloutController(String wcSegRequestCLLIIn) {
        //Create list of parameters to be sent to prepareRequestForFinancialAnalyses
        this.coParamsList = new List<WCSegCalloutController.CalloutParams>();
        WCSegCalloutController.CalloutParams cp = new WCSegCalloutController.CalloutParams();
        cp.wcSegRequestCLLI = wcSegRequestCLLIIn;
        this.coParamsList.add(cp);		
    }//end constructor
    
    public void execute(QueueableContext ctx) {
        //Create list of parameters to be sent to callWCSegmentation
        List<WCSegCalloutController.CalloutParams> calloutParamsList = new List<WCSegCalloutController.CalloutParams>();
        WCSegCalloutController.CalloutParams cp = new WCSegCalloutController.CalloutParams();
        cp.wcSegRequestCLLI = '*';
        calloutParamsList.add(cp);
        //Asynchronous Call to get WCSegmentation using params-list
        asyncCallWCSegmentation(calloutParamsList);        
        this.clearState();        
    }//end method execute

    public class CalloutParams {
        @invocableVariable(label='WCSegRequest CLLI' description='The WireCenter CLLI of the WCSeg_Request__c record.  Using * means all CLLI codes will be processed.' required=true)
        public String wcSegRequestCLLI;
    }
    
    @InvocableMethod(label='Callout to WireCenter-CLLI-Segmentation API'
                     description='Perform callout to WireCenter-CLLI-Segmentation API, updating existing Network_Wire_Center__c.Network_Wire_Center_Segmentation__c values from returned API values.'
                     callout=true
                     category='WireCenter Segmentation API')
    public static List<List<Network_Wire_Center__c>> callWCSegmentation(List<WCSegCalloutController.CalloutParams> calloutParams) {
        List<List<Network_Wire_Center__c>> nwcWithUpdatesListCollection = new List<List<Network_Wire_Center__c>>();
        List<BRAIN_WCSeg_Response__c> nwcRespList = new List<BRAIN_WCSeg_Response__c>();
        List<Network_Wire_Center__c> curNWCList = new List<Network_Wire_Center__c>();
        List<String> curNamesList = new List<String>();
        List<Network_Wire_Center__c> nwcWithUpdatesList = new List<Network_Wire_Center__c>();		     
        String wcSegRequestCLLI = null;
    	String accessToken = null;
        String wcSegResponseJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Http httpProtocol = new Http();
        Transaction_Summary__c wcSegAPITransSummary = new Transaction_Summary__c();
    	Time startTime;
      	Time endTime;	
        String callingApiName = 'WirecenterSegmentation';
        
        try {        
            System.debug('(WCSegCalloutController.callWCSegmentation) Starting with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

            //Extract parameters into the key variables
            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Parsing calloutParams with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            System.debug('(WCSegCalloutController.callWCSegmentation) calloutParams.size() = ' + calloutParams.size());
            wcSegRequestCLLI = calloutParams.get(0).wcSegRequestCLLI;

            System.debug('(WCSegCalloutController.callWCSegmentation) wcSegRequestCLLI = ' + wcSegRequestCLLI);            
            if (String.isBlank(wcSegRequestCLLI)) {
                throw new InvalidParameterParsingException();
            } else {
	            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Building HttpRequest for accessToken with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                accessToken = WCSegCalloutHelper.getAccessTokenFromApigee();
	            System.debug('(WCSegCalloutController.callWCSegmentation) END Building HttpRequest for accessToken with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
	            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Building HttpRequest for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                httpRequestWCSeg = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(accessToken, wcSegRequestCLLI);
	            System.debug('(WCSegCalloutController.callWCSegmentation) END Building HttpRequest for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
	            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Getting HttpResponse for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, wcSegRequestCLLI);
	            System.debug('(WCSegCalloutController.callWCSegmentation) END Getting HttpResponse for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                
                if (httpResponseWCSeg != null) {                        
                    // Create API Transaction Summary record for history and reports
                    System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN creating APITransactionSummary with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    wcSegAPITransSummary = WCSegCalloutHelper.createAPITransSummary(wcSegRequestCLLI);
                    System.debug('(WCSegCalloutController.callWCSegmentation) END creating APITransactionSummary with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    // Create API Transaction record for history and reports
                    startTime = DateTime.now().Time();
                    endTime = DateTime.now().Time();
		            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN creating APITransaction with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    WCSegCalloutHelper.ApiTransactionParams atParams = new WCSegCalloutHelper.ApiTransactionParams();
                    atParams.responseStatus = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatus() : null);
                    atParams.responseStatusCode = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatusCode() : 0);
                    atParams.responseBody = (httpResponseWCSeg != null ? httpResponseWCSeg.getBody() : null);
                    atParams.requestEndpoint = (httpRequestWCSeg != null ? httpRequestWCSeg.getEndpoint() : null);
                    atParams.requestBody = (httpRequestWCSeg != null ? httpRequestWCSeg.getBody() : null);
                    atParams.callingApiName = callingApiName;
                    atParams.startTime = startTime;
                    atParams.endTime = endTime;
                    atParams.errorDetails = null;
                    atParams.wcSegAPITransSummaryId = wcSegAPITransSummary.Id;
                    API_Transaction__c wcSegAPITrans = WCSegCalloutHelper.createApiTransaction(atParams);
		            System.debug('(WCSegCalloutController.callWCSegmentation) END creating APITransaction with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    
                    System.debug('(WCSegCalloutController.callWCSegmentation) httpResponseWCSeg.getStatusCode() = ' + httpResponseWCSeg.getStatusCode());
		            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Extracting data from HttpResponse for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    wcSegResponseJSON = WCSegCalloutHelper.extractDataFromHttpResponse(httpResponseWCSeg, wcSegAPITrans);
		            System.debug('(WCSegCalloutController.callWCSegmentation) END Extracting data from HttpResponse for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    //System.debug('(WCSegCalloutController.callWCSegmentation) wcSegResponseJSON = ' + wcSegResponseJSON);
		            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Query All Wirecenter CLLI-Codes with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    curNWCList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
		            System.debug('(WCSegCalloutController.callWCSegmentation) END Query All Wirecenter CLLI-Codes with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    System.debug('(WCSegCalloutController.callWCSegmentation) curNWCList.size() = ' + curNWCList.size());
		            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Query Names of All Wirecenter CLLI-Codes with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    curNamesList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(curNWCList);
		            System.debug('(WCSegCalloutController.callWCSegmentation) END Query Names of All Wirecenter CLLI-Codes with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    System.debug('(WCSegCalloutController.callWCSegmentation) curNamesList.size() = ' + curNamesList.size());
		            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Build Base WCSegResponse from JSON for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    nwcRespList = WCSegCalloutHelper.buildBaseWCSegResponse(wcSegResponseJSON, curNWCList, curNamesList);
		            System.debug('(WCSegCalloutController.callWCSegmentation) END Build Base WCSegResponse from JSON for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    System.debug('(WCSegCalloutController.callWCSegmentation) AFTER BUILD, nwcRespList.size() = ' + nwcRespList.size());
                    
		            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Insert Base WCSegResponse records with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    nwcRespList = WCSegCalloutHelper.insertBaseWCSegResponseList(nwcRespList);
		            System.debug('(WCSegCalloutController.callWCSegmentation) END Insert Base WCSegResponse records with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    System.debug('(WCSegCalloutController.callWCSegmentation) AFTER INSERT, nwcRespList.size() = ' + nwcRespList.size());
		            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Check NWCs for Updates with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    nwcWithUpdatesList = WCSegCalloutHelper.checkNWCForUpdates(curNamesList, curNWCList, nwcRespList);
		            System.debug('(WCSegCalloutController.callWCSegmentation) END Check NWCs for Updates with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
		            System.debug('(WCSegCalloutController.callWCSegmentation) BEGIN Update of NWCs with new WCSegmentation values with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    WCSegCalloutHelper.updateWCSegmentation(nwcWithUpdatesList);                
		            System.debug('(WCSegCalloutController.callWCSegmentation) END Update of NWCs with new WCSegmentation values with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                } else {
                    throw new NullObjectException('EXCEPTION!  The HttpResponse was NULL from the API callout for Wire-Center-Segmentation.  No data available to process.');
                }//end else httpResponseWCSeg is NULL
            }//end else valid requestParams
        } catch(Exception checkParamsX) {
            System.debug('(WCSegCalloutController.callWCSegmentation) EXCEPTION! \n Type: ' + checkParamsX.getTypeName() + '\n Message:  ' + checkParamsX.getMessage() + '\n Line#: ' + checkParamsX.getLineNumber() + '\n StackTrace:  ' + checkParamsX.getStackTraceString());
        } finally {
            System.debug('(WCSegCalloutController.callWCSegmentation) Returning in nwcWithUpdatesList, there were ' + nwcWithUpdatesList.size() + ' Network-Wire-Center records updated out of ' + curNWCList.size() + ' initial Network-Wire-Center records examined.');
        }
        return nwcWithUpdatesListCollection;
    }
    
    public void asyncCallWCSegmentation(List<WCSegCalloutController.CalloutParams> calloutParams) {
        List<BRAIN_WCSeg_Response__c> nwcRespList = new List<BRAIN_WCSeg_Response__c>();
        List<Network_Wire_Center__c> curNWCList = new List<Network_Wire_Center__c>();
        List<String> curNamesList = new List<String>();
        List<Network_Wire_Center__c> nwcWithUpdatesList = new List<Network_Wire_Center__c>();		     
        String wcSegRequestCLLI = null;
    	String accessToken = null;
        String wcSegResponseJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Http httpProtocol = new Http();
        Transaction_Summary__c wcSegAPITransSummary = new Transaction_Summary__c();
    	Time startTime;
      	Time endTime;	
        String callingApiName = 'WirecenterSegmentation';
        
        try {        
            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) Starting with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

            //Extract parameters into the key variables
            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Parsing calloutParams with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) calloutParams.size() = ' + calloutParams.size());
            wcSegRequestCLLI = calloutParams.get(0).wcSegRequestCLLI;
            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) wcSegRequestCLLI = ' + wcSegRequestCLLI);            
            if (String.isBlank(wcSegRequestCLLI)) {
                throw new InvalidParameterParsingException();
            } else {
	            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Building HttpRequest for accessToken with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                accessToken = WCSegCalloutHelper.getAccessTokenFromApigee();
	            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END Building HttpRequest for accessToken with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
	            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Building HttpRequest for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                httpRequestWCSeg = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(accessToken, wcSegRequestCLLI);
	            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END Building HttpRequest for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
	            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Getting HttpResponse for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, wcSegRequestCLLI);
	            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END Getting HttpResponse for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                
                if (httpResponseWCSeg != null) {                        
                    // Create API Transaction Summary record for history and reports
                    System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN creating APITransactionSummary with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    wcSegAPITransSummary = WCSegCalloutHelper.createAPITransSummary(wcSegRequestCLLI);
                    System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END creating APITransactionSummary with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    // Create API Transaction record for history and reports
                    startTime = DateTime.now().Time();
                    endTime = DateTime.now().Time();
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN creating APITransaction with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    WCSegCalloutHelper.ApiTransactionParams atParams = new WCSegCalloutHelper.ApiTransactionParams();
                    atParams.responseStatus = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatus() : null);
                    atParams.responseStatusCode = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatusCode() : 0);
                    atParams.responseBody = (httpResponseWCSeg != null ? httpResponseWCSeg.getBody() : null);
                    atParams.requestEndpoint = (httpRequestWCSeg != null ? httpRequestWCSeg.getEndpoint() : null);
                    atParams.requestBody = (httpRequestWCSeg != null ? httpRequestWCSeg.getBody() : null);
                    atParams.callingApiName = callingApiName;
                    atParams.startTime = startTime;
                    atParams.endTime = endTime;
                    atParams.errorDetails = null;
                    atParams.wcSegAPITransSummaryId = wcSegAPITransSummary.Id;
                    API_Transaction__c wcSegAPITrans = WCSegCalloutHelper.createApiTransaction(atParams);
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END creating APITransaction with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());

                    System.debug('(WCSegCalloutController.asyncCallWCSegmentation) httpResponseWCSeg.getStatusCode() = ' + httpResponseWCSeg.getStatusCode());
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Extracting data from HttpResponse for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    wcSegResponseJSON = WCSegCalloutHelper.extractDataFromHttpResponse(httpResponseWCSeg, wcSegAPITrans);
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END Extracting data from HttpResponse for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    //System.debug('(WCSegCalloutController.asyncCallWCSegmentation) wcSegResponseJSON = ' + wcSegResponseJSON);
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Query All Wirecenter CLLI-Codes with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    curNWCList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END Query All Wirecenter CLLI-Codes with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    System.debug('(WCSegCalloutController.asyncCallWCSegmentation) curNWCList.size() = ' + curNWCList.size());
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Query Names of All Wirecenter CLLI-Codes with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    curNamesList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(curNWCList);
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END Query Names of All Wirecenter CLLI-Codes with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    System.debug('(WCSegCalloutController.asyncCallWCSegmentation) curNamesList.size() = ' + curNamesList.size());
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Build Base WCSegResponse from JSON for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    nwcRespList = WCSegCalloutHelper.buildBaseWCSegResponse(wcSegResponseJSON, curNWCList, curNamesList);
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END Build Base WCSegResponse from JSON for SearchWCSeg with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    System.debug('(WCSegCalloutController.asyncCallWCSegmentation) AFTER BUILD, nwcRespList.size() = ' + nwcRespList.size());
                    
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Insert Base WCSegResponse records with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    nwcRespList = WCSegCalloutHelper.insertBaseWCSegResponseList(nwcRespList);
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END Insert Base WCSegResponse records with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    System.debug('(WCSegCalloutController.asyncCallWCSegmentation) AFTER INSERT, nwcRespList.size() = ' + nwcRespList.size());
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Check NWCs for Updates with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    nwcWithUpdatesList = WCSegCalloutHelper.checkNWCForUpdates(curNamesList, curNWCList, nwcRespList);
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END Check NWCs for Updates with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) BEGIN Update of NWCs with new WCSegmentation values with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                    WCSegCalloutHelper.updateWCSegmentation(nwcWithUpdatesList);                
		            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) END Update of NWCs with new WCSegmentation values with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
                } else {
                    throw new NullObjectException('EXCEPTION!  The HttpResponse was NULL from the API callout for Wire-Center-Segmentation.  No data available to process.');
                }//end else httpResponseWCSeg is NULL
            }//end else valid requestParams
        } catch(Exception checkParamsX) {
            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) EXCEPTION! \n Type: ' + checkParamsX.getTypeName() + '\n Message:  ' + checkParamsX.getMessage() + '\n Line#: ' + checkParamsX.getLineNumber() + '\n StackTrace:  ' + checkParamsX.getStackTraceString());
        } finally {
            System.debug('(WCSegCalloutController.asyncCallWCSegmentation) Returning in nwcWithUpdatesList, there were ' + nwcWithUpdatesList.size() + ' Network-Wire-Center records updated out of ' + curNWCList.size() + ' initial Network-Wire-Center records examined.');
        }
        
    }//end method asyncCallWCSegmentation
    
    public void clearState() {
        System.debug('(WCSegCalloutController.clearState) BEGIN ClearState with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
    	this.coParamsList = null;
        System.debug('(WCSegCalloutController.clearState) END ClearState with Limits.getHeapSize() = ' + Limits.getHeapSize() + '  AND Limits.getLimitHeapSize() = ' + Limits.getLimitHeapSize());
    }//end method clearState
    
}//end class WCSegCalloutController