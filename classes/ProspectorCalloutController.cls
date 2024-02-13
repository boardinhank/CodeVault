/***************************************************************
===============================================================
Purpose: Prospector Callout Controller class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/26/2022   ESCJ-653  	  Initial draft
Stan & Ted 10/07/2022   ESCJ-1975     Fix issues preventing PRR processing
***************************************************************/ 
public class ProspectorCalloutController implements Queueable, Database.AllowsCallouts { 
    public String newPropertyId; 
    private List<Property__c> propertyList = new List<Property__c>();
    
    public ProspectorCalloutController(String propertyIdIn) {
    	newPropertyId = propertyIdIn;    
    }
    
    public ProspectorCalloutController(List<Property__c> propertyListIn) {
        System.debug('(ProspectorCalloutController-constructor) propertyListIn?.size() = ' + propertyListIn?.size());
    	propertyList = propertyListIn;
        System.debug('(ProspectorCalloutController-constructor) propertyList?.size() = ' + propertyList?.size());
    }
    
    public void execute(QueueableContext ctx) { 
        System.debug('HEY! Executing ProspectorCalloutController here!  BTW: Beginning with newPropertyId = ' + newPropertyId + '  AND propertyList?.size() = ' + propertyList?.size());
        if (!String.isBlank(newPropertyId)) {
            propertyList = ProspectorCalloutHelper.getPropertyById(newPropertyId);
        } else if (propertyList == null || propertyList.size() == 0) {
            propertyList = ProspectorCalloutHelper.retrieveProperties();            
        } else {
            //do nothing because propertyList was passed in as part of the constructor
        }
        System.debug('ProspectorCalloutController.execute) propertyList?.size() = ' + (propertyList?.size()));
        ProspectorCalloutHelper.allApiTransactionsServiceManager = new ApiTransactionService(true);
       	processPropertyList();
        this.clearState();
        ProspectorCalloutHelper.commitChanges();
    }//end method execute
    /*  */
    public void processPropertyList() {
        String projectIdG = null;
        String projectIdR = null;
        List<Prospector_Working_Table__c> pwtToInsertList = new List<Prospector_Working_Table__c>();
        System.debug('ProspectorCalloutController.processPropertyList) propertyList?.size() = ' + (propertyList?.size()));
        try{
            if (propertyList != null && propertyList.size() > 0) { 
                if (propertyList.size() == 1) {
                    ProspectorCalloutHelper.transactionSummaryId = propertyList.get(0).Transaction_Summary__c;
                } else {
                    ProspectorCalloutHelper.transactionSummaryId = null;
                }
                ProspectorCalloutHelper.allApiTransactionsServiceManager = new ApiTransactionService();
                List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList = ProspectorCalloutHelper.buildDemandPointsFromProperties(propertyList);
                System.debug('ProspectorCalloutController.processPropertyList) dpList?.size() = ' + (dpList?.size()));
                if (dpList != null && dpList.size() > 0) {
                    /*  GREEN  */
                    ProspectorCreateProjectCallout.ProspectorProject projectG = ProspectorCalloutHelper.step1CreateProject(ProspectorCalloutHelper.GREEN);
                    if (projectG != null) {
                        projectIdG = projectG.payload;
                        System.debug('ProspectorCalloutController.processPropertyList) projectIdG = ' + projectIdG);
                        projectG = ProspectorCalloutHelper.step2AddDemandPoints(projectIdG, dpList, ProspectorCalloutHelper.GREEN);
                        projectG = ProspectorCalloutHelper.step3SubmitJob(projectIdG, ProspectorCalloutHelper.GREEN);
        
                        //Last step is to insert GREEN data into Prospector-Working-Table
                        pwtToInsertList.addAll(ProspectorCalloutHelper.step4InsertToPWT(projectIdG, dpList, ProspectorCalloutHelper.GREEN));
                    } else {
                        System.debug('(ProspectorCalloutController.processPropertyList) Prospector CreateProject-callout returned NULL project for GREEN.');
                    }
                    System.debug('ProspectorCalloutController.processPropertyList) AFTER Green, pwtToInsertList?.size() = ' + (pwtToInsertList?.size()));
                    /*  RED */
                    ProspectorCreateProjectCallout.ProspectorProject projectR = ProspectorCalloutHelper.step1CreateProject(ProspectorCalloutHelper.RED);
                    if (projectR != null) {
                        projectIdR = projectR.payload;
                        System.debug('ProspectorCalloutController.processPropertyList) projectIdR = ' + projectIdR);
                        projectR = ProspectorCalloutHelper.step2AddDemandPoints(projectIdR, dpList, ProspectorCalloutHelper.RED);
                        projectR = ProspectorCalloutHelper.step3SubmitJob(projectIdR, ProspectorCalloutHelper.RED);
                        //Last step is to insert RED data into Prospector-Working-Table
                         pwtToInsertList.addAll(ProspectorCalloutHelper.step4InsertToPWT(projectIdR, dpList, ProspectorCalloutHelper.RED));
                    } else {
                        System.debug('(ProspectorCalloutController.processPropertyList) Prospector CreateProject-callout returned NULL project for RED.');
                    }
                    System.debug('ProspectorCalloutController.processPropertyList) AFTER Red, pwtToInsertList?.size() = ' + (pwtToInsertList?.size()));
                    /* */
                    if (pwtToInsertList.size() > 0) {
                        insert pwtToInsertList;
                    }
                    for(Property__c prop : propertyList){
                        prop.Prospector_Green_Project_Id__c = projectIdG;
                        prop.Prospector_Red_Project_Id__c = projectIdR;
                    }
                    update propertyList;
                }
            } else {
                System.debug('(ProspectorCalloutController.processPropertyList) WARNING! There were no properties to process.');
            }
    	}catch(Exception dmlExe){
        	System.debug('ProspectorCalloutController EXCEPTION! \n Type: ' + dmlExe.getTypeName() + '\n Message:  ' + dmlExe.getMessage() + '\n Line#: ' + dmlExe.getLineNumber() + '\n StackTrace:  ' + dmlExe.getStackTraceString());
    	}        
    }//end method processPropertyList
    /* */
    
    private void clearState() {
        this.newPropertyId = null;
        propertyList = null;
    }

}//end class ProspectorCalloutController