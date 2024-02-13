/***************************************************************************************************
 * Name:  BRAINFACentralAutomationController
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for Automation of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFACentralAutomationController -- %  11/11/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 11/10/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version
 * 01/27/2023   T2Cabato    Story ESCJ-2365                 Revised per Story
 * 06/13/2023   T2Cabato    QFCJ-3801                       BRAIN-AutoSubmit-Messaging
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Product-to-TechType-Mapping
****************************************************************************************************/
public class BRAINFACentralAutomationController implements Queueable, Database.AllowsCallouts {
    public class NotValidToContinueException extends Exception {}

    public String reqCapDesignName;
    public String reqOfferId;
    public String reqSubmitterCuid;
    public String reqCallSource;
    public String faRequestId;
    public String requestJSON;
    public String responseJSON;
	public List<List<BRAIN_API_Call_Tracker__c>> trackerCallListCollection;    
	public List<BRAINFACentralAutomationController.InitialAutomationParams> initParamsList;

    public BRAINFACentralAutomationController(String capDesignNameIn, String offerIdIn, String submitterCuidIn, String callSourceIn) {
        this.reqCapDesignName = capDesignNameIn;
        this.reqOfferId = offerIdIn;
        this.reqSubmitterCuid = submitterCuidIn;
        this.reqCallSource = callSourceIn;
        //Create list of parameters to be sent to 
        this.initParamsList = new List<BRAINFACentralAutomationController.InitialAutomationParams>();
        BRAINFACentralAutomationController.InitialAutomationParams iap = new BRAINFACentralAutomationController.InitialAutomationParams();
        iap.capDesignName = this.reqCapDesignName;
        iap.offerId = this.reqOfferId;
        iap.submitterCuid = this.reqSubmitterCuid;
        iap.callSource = this.reqCallSource;
        this.initParamsList.add(iap);
    }//end  constructor
    
    public void execute(QueueableContext ctx) { 
        try {
			asyncRunBRAINFAProcess(this.initParamsList);
        } catch(Exception mainX) {
            System.debug('(BRAINFACentralAutomationController.execute) EXCEPTION! \n Type: ' + mainX.getTypeName() + '\n Message:  ' + mainX.getMessage() + '\n Line#: ' + mainX.getLineNumber() + '\n StackTrace:  ' + mainX.getStackTraceString());
            if(!Test.isRunningTest()) {
	            throw mainX;
            }
        }
    }//end method execute
    
    public void asyncRunBRAINFAProcess(List<InitialAutomationParams> automationParams) { 
        String capDesignName = automationParams.get(0).capDesignName;
        String offerId = automationParams.get(0).offerId;
        String submitterCuid = automationParams.get(0).submitterCuid;
        String callSource = automationParams.get(0).callSource;
        System.debug('(BRAINFACentralAutomationController.runBRAINFAProcess) capDesignName = ' + capDesignName + '\n offerId = ' + offerId +
                          '\n submitterCuid = ' + submitterCuid + '\n callSource = ' + callSource);
        try {
            String checkValidResult = BRAINFARequestHelper.checkValidToContinue(capDesignName);
            if (checkValidResult.startsWith('VALID')) {
                BRAINFinancialAnalysesRequestController requestController = new BRAINFinancialAnalysesRequestController(capDesignName, offerId, submitterCuid, callSource);
                if(Test.isRunningTest()) {
                    requestController.execute(null);
                } else {
                    String requestJobId = System.enqueueJob(requestController);
                    System.debug('(BRAINFACentralAutomationController.execute) requestJobId = ' + requestJobId);
                }
		        this.clearState();
            } else {
                throw new NotValidToContinueException('EXCEPTION!  Unable to continue as validation check for Capital Design named "' + capDesignName + '" returned as: ' + checkValidResult);
            }
        } catch(Exception mainX) {
            System.debug('(BRAINFACentralAutomationController.asyncRunBRAINFAProcess) EXCEPTION! \n Type: ' + mainX.getTypeName() + '\n Message:  ' + mainX.getMessage() + '\n Line#: ' + mainX.getLineNumber() + '\n StackTrace:  ' + mainX.getStackTraceString());
            try {
	            BRAIN_Automation_Fault__c excFault = BRAINFACalloutHelper.buildBaseFault(mainX.getMessage(), mainX.getStackTraceString());
                BRAINFACalloutHelper.associateFaultToCapDesignByCapDesName(excFault, this.reqCapDesignName);
	        } catch(Exception faultX) {
	            System.debug('(BRAINFACentralAutomationController.asyncRunBRAINFAProcess) EXCEPTION! \n Type: ' + faultX.getTypeName() + '\n Message:  ' + faultX.getMessage() + '\n Line#: ' + faultX.getLineNumber() + '\n StackTrace:  ' + faultX.getStackTraceString());
            }
            throw mainX;
        }
    }//end method asyncRunBRAINFAProcess       

    public class InitialAutomationParams {
        @invocableVariable(label='Capital Design Name' description='The Name of the Capital_Design__c record' required=true)
        public String capDesignName;
        @invocableVariable(label='Offer Id' description='The Id of the specific Offer for which will be seeking Financial Analyses as associated to the specified Capital_Design__c record' required=false)
        public String offerId;
        @invocableVariable(label='Submitter CUID' description='The CUID of the User who submitted to BRAIN' required=true)
        public String submitterCuid;
        @invocableVariable(label='Call Source' description='The source from which the Call was being made (Offer, APVOffer, CapitalDesign)' required=true)
        public String callSource;
    }
    
    @InvocableMethod(label='Central Automation for BRAIN Financial Analyses'
                     description='Initiate the automation to send to BRAIN for financial viability'
                     category='BRAIN API Call Tracker')
    public static void runBRAINFAProcess(List<InitialAutomationParams> automationParams) {
        String capDesignName, offerId, submitterCuid, callSource = null;
        try {
            capDesignName = automationParams.get(0).capDesignName;
            offerId = automationParams.get(0).offerId;
            submitterCuid = automationParams.get(0).submitterCuid;
            callSource = automationParams.get(0).callSource;
            System.debug('(BRAINFACentralAutomationController.runBRAINFAProcess) capDesignName = ' + capDesignName + '\n offerId = ' + offerId +
                              '\n submitterCuid = ' + submitterCuid + '\n callSource = ' + callSource);
            BRAINFACentralAutomationController caController = new BRAINFACentralAutomationController(capDesignName, offerId, submitterCuid, callSource);
	        String autoJobId = System.enqueueJob(caController);
    	    System.debug('(BRAINFACentralAutomationController.execute) autoJobId = ' + autoJobId);
        } catch (Exception runX) {
            System.debug('(BRAINFACentralAutomationController.runBRAINFAProcess) EXCEPTION! \n Type: ' + runX.getTypeName() + '\n Message:  ' + runX.getMessage() + '\n Line#: ' + runX.getLineNumber() + '\n StackTrace:  ' + runX.getStackTraceString());
            try {
	            BRAIN_Automation_Fault__c excFault = BRAINFACalloutHelper.buildBaseFault(runX.getMessage(), runX.getStackTraceString());
                BRAINFACalloutHelper.associateFaultToCapDesignByCapDesName(excFault, capDesignName);
	        } catch(Exception faultX) {
	            System.debug('(BRAINFACentralAutomationController.runBRAINFAProcess) EXCEPTION! \n Type: ' + faultX.getTypeName() + '\n Message:  ' + faultX.getMessage() + '\n Line#: ' + faultX.getLineNumber() + '\n StackTrace:  ' + faultX.getStackTraceString());
            }
            throw runX;
        }
    }//end runBRAINFAProcess
        
    public void clearState() {
        this.reqCapDesignName = null;
        this.reqOfferId = null;
        this.reqSubmitterCuid = null;
        this.reqCallSource = null;
    	this.faRequestId = null;
    	this.requestJSON = null;
    	this.responseJSON = null;  
        this.trackerCallListCollection = null;
    }//end method clearState
    
}//end class BRAINFACentralAutomationController