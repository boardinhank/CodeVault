/***************************************************************
===============================================================
Purpose: Batch Apex to process property records and
         make LoopQual 1GiG service callout
===============================================================
History:

AUTHOR     DATE         Reference     Description
Deepak     12/08/2021   ESCJ-328      Initial draft
Navin M    22/02/2022   ESCJ-426      Added logic to update the transaction summary record in finish method
Navin M    31/05/2022   ESCJ-749      Added logic to use 'LQ Region Parameter' field instead of company name of property for creating 'network' url query parameter
***************************************************************/
public without sharing class BatchToProcessPropertiesFor1GService implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    private static String appName = 'sfcjapp';
    private static String OneGServiceName = 'LoopQualFor1GService';
    private List<Property__c> propertiesToBeUpdated = new List<Property__c>();
    private List<Property__c> propertiesToProcess;
    Boolean isWrappedByQueueable;

    /**********************************************************************************************
    Purpose: Parameterized cosntructor to pass list of property to be processed
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/08/2021   ESCJ-328      Initial draft
    ***********************************************************************************************/
    public BatchToProcessPropertiesFor1GService(List<Property__c> propertiesToProcessIn){
        this.propertiesToProcess = propertiesToProcessIn;
        this.isWrappedByQueueable = false;
    }

    public BatchToProcessPropertiesFor1GService(Boolean isWrappedByQueueable) {
        this.isWrappedByQueueable = isWrappedByQueueable;
    }

    public List<SObject> start(Database.BatchableContext BC) {
        return  this.propertiesToProcess;
    }

    /**********************************************************************************************
    Purpose: Implementing execute method of Database.Batchable which has logic to process the
             property object
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/08/2021   ESCJ-328      Initial draft
    ***********************************************************************************************/
    public void execute(Database.BatchableContext BC, List<Property__c> propertyList) {
        Property__c processingProperty = new Property__c();
        System.debug(' 1GigService execute method started : ');
        try{
            System.debug('1GigService propertyList : '+propertyList.size());
            for(Property__c property : propertyList){
                processingProperty = property;
                System.debug('1GigService property id : '+property.Id);//+ ' Transaction_Summary__c '+property.Transaction_Summary__c
                HttpResponse serviceResponse = this.make1GigServiceCallOut(property);
                if (serviceResponse != null && serviceResponse?.getBody() != null && serviceResponse?.getBody() != '') {
                    Map<String, Object> mappedRes = this.processResponse(serviceResponse, property);
                    this.propertiesToBeUpdated.add(property);
                }
            }
        }
        catch(Exception e){
            System.debug('Exception : '+e.getMessage()+'  while processing the property for 1GigService : '+processingProperty.Id);
        }
        System.debug(' 1GigService execute method finished : ');
    }//close execute method

    /**********************************************************************************************
    Purpose: Implementing finish method of Database.Batchable which has logic to update properties,
    transaction summary
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/08/2021   ESCJ-328      Initial draft
    Navin M    22/02/2022   ESCJ-426      Added logic to update the transaction summary record
    ***********************************************************************************************/
    public void finish(Database.BatchableContext BC) {
        System.debug(' 1GigService finish method start : ');
        if(this.propertiesToBeUpdated.size() > 0){
            DATABASE.UPDATE(this.propertiesToBeUpdated);
            System.debug(' 1GigService finish method updated : '+ this.propertiesToBeUpdated + ' Records ');

            /***************** Begin of ESCJ-426+ : Navin M 22/02/22 ***********************/
            Map<Id, Transaction_Summary__c> transactionSummariesToUpdate = updateTransactionSummary(this.propertiesToBeUpdated);
            if(transactionSummariesToUpdate?.size() > 0){
                DATABASE.UPDATE(transactionSummariesToUpdate.values() , FALSE);
            }
            /***************** End of ESCJ-426+ : Navin M 22/02/22 ***********************/
        }
        System.debug(' 1GigService finish method finished : ');
    }

    /**********************************************************************************************
    Purpose: Make callout to 1GigEnabled service and return the response
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/08/2021   ESCJ-328      Initial draft
    Navin M    31/05/2022   ESCJ-749      Added logic to use 'LQ Region Parameter' field instead of company name of property for creating 'network' url query parameter
    ***********************************************************************************************/
    private HttpResponse make1GigServiceCallOut(Property__c property){
        System.debug(' 1GigService make1GigServiceCallOut method start : ');
        HttpResponse serviceResponse;
        if(Test.isRunningTest()) {
            serviceResponse = buildTestResponse();
        } else {
            // String companyName = property.ocnName__c;
            // String network = '';
            // if(String.isNotBlank(companyName)){
            //     if(companyName.toLowerCase().indexOf('qwest') > -1){
            //         network = 'qwest';
            //     }else if(companyName.toLowerCase().indexOf('ctl') > -1){
            //         network = 'ctl';
            //     }
            // }        
            // Getting the regio paremter value from property
            String regionParameter = property.LQ_Region_Parameter__c;
            // If region paremter is not null/blank i.e It has either Qwest or CTL value then proceed further
            if (regionParameter != null && String.isNotBlank(regionParameter)) {
                String network = regionParameter.toLowerCase();
    
                Map<String, String> queryParams = new Map<String, String>();
                queryParams.put('wirecenter_clli', property.Network_Wire_Center_Name_Text__c);
                queryParams.put('network', network);
                queryParams.put('requestId', property.Property_Auto_Gen_Number__c);
                queryParams.put('messageSrcSystem', appName);
                String transactionSummaryId = property.Transaction_Summary__c;
                system.debug(' 1GigService transactionSummaryId : '+ transactionSummaryId);
                APITransactionController apiTransaction = new APITransactionController(OneGServiceName, null, queryParams, transactionSummaryId);
                serviceResponse = APITransactionController.serviceCallout();
                System.debug(' 1GigService make1GigServiceCallOut method finish : ');
            }
		}//end else        

        return serviceResponse;
    }

    /**********************************************************************************************
    Purpose: deserialize the 1GigEnabled service response and update Property__c record
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/08/2021   ESCJ-328      Initial draft
    ***********************************************************************************************/
    private Map<String, Object> processResponse(HttpResponse serviceResponse, Property__c property){
        System.debug(' 1GigService processResponse method start : ');
         Map<String, Object> mapToReturn = new Map<String, Object>();
         if(serviceResponse != null && serviceResponse.getStatusCode() == 200 && serviceResponse.getBody() !=null){
             Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(serviceResponse?.getBody());
             String gigEnabledStatus = (String) responseMap.get('gigEnabledStatus');
             System.debug('1GigService gigEnabledStatus : ' + gigEnabledStatus);
             property.Gig_Enabled__c = 'No';
             if('true'.equalsIgnoreCase(gigEnabledStatus)){
                 System.debug('1GigService gigEnabledStatus inside yes : ');
                 property.Gig_Enabled__c = 'Yes';
             }
         }
         System.debug(' 1GigService processResponse method finish : ');
        return mapToReturn;
    }

    /**********************************************************************************************
    Purpose: To update the transaction summaries
    ===============================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     22/02/2022  ESCJ-426    Initial draft
    ***********************************************************************************************/
    private Map<Id, Transaction_Summary__c> updateTransactionSummary(List<Property__c> propertiesUpdated) {
        Map<Id, Transaction_Summary__c> tranSummaries = new Map<Id, Transaction_Summary__c>();
        for (Property__c property : propertiesUpdated) {
            if (property?.Transaction_Summary__c != null) {
                Transaction_Summary__c transSummary = new Transaction_Summary__c();
                transSummary.Id = property.Transaction_Summary__c;
                transSummary.Last_Step__c = OneGServiceName;
                tranSummaries.put(transSummary.Id , transSummary);
            }
        }
        return tranSummaries;
    }

    private HttpResponse buildTestResponse() {
        String respBody = '{ "status": "Success", "statusMsg": null, "wirecenterclli": "HGLYAZQC", "network": "QWEST", "requestId": "00025028", "messageSrcSystem": "sfcjapp", "gigEnabledStatus": "TRUE" }';
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setStatusCode(200);
        mockHttpResponse.setBody(respBody);        
        return mockHttpResponse;
    }//end method buildTestResponse
}