/***************************************************************
===============================================================
Purpose: Batch Apex to process property records and
         make addressTelco callout
===============================================================
History:

AUTHOR     DATE         Reference     Description
Deepak    12/08/2021    ESCJ-328      Initial draft
Navin M    22/02/2022   ESCJ-426      Added logic to update the transaction summary record in finish method
Navin M    31/05/2022   ESCJ-749      Populated LQ Region Parameter field on Property using value from Telco response
***************************************************************/
public without sharing class BatchToProcessPropertiesForAddTelco implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    private static String expand = 'wireCenterLocation,ocnList,fiberDistance,meetPoints';
    public List<Property__c> propertiesToBeUpdated = new List<Property__c>();
    private List<Property__c> propertiesToProcess;
    Boolean isWrappedByQueueable;

    /**********************************************************************************************
    Purpose: Parameterized cosntructor to pass list of property to be processed
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/08/2021   ESCJ-328      Initial draft
    ***********************************************************************************************/
    public BatchToProcessPropertiesForAddTelco(List<Property__c> propertiesToProcess){
        system.debug(' constructor called ');
       this.propertiesToProcess = propertiesToProcess;
        this.isWrappedByQueueable = false;
   }
    public BatchToProcessPropertiesForAddTelco(Boolean isWrappedByQueueable) {
        this.isWrappedByQueueable = isWrappedByQueueable;
    }

    public List<SObject> start(Database.BatchableContext BC) {
        system.debug(' start method called ');
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
        System.debug(' AddressTelco execute method started : ');
        try{
            System.debug(' AddressTelco propertyList : '+propertyList.size());
            for(Property__c property : propertyList){
                processingProperty = property;
                System.debug(' AddressTelco property id processing started : '+property.Id);
                HttpResponse serviceResponse = this.makeAddressTelcoCallOut(property);
                Map<String, Object> mappedRes = this.processResponse(serviceResponse, property);
                String clli8 = (String) mappedRes.get('clli8');
                boolean isServiceResponseGood = (Boolean) mappedRes.get('isServiceResponseGood');
                if(isServiceResponseGood){
                    this.mappNetworkWireCenterWithProperty(property, clli8);
                    this.propertiesToBeUpdated.add(property); // add property to list so that we can update this in finish method
                }
                System.debug(' AddressTelco property id processing finished : '+property.Id);
            }
        }// close the try block
        catch(Exception e){
            System.debug('Exception : '+e.getMessage()+'  while processing the property for addressTelcoService : '+processingProperty.Id);
        }
        System.debug(' AddressTelco execute method finished : ');
    }//close execute method

    /**********************************************************************************************
    Purpose: Implementing finish method of Database.Batchable which has logic to update properties,
    transaction summary and execute BatchToProcessPropertiesFor1GService
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/08/2021   ESCJ-328      Initial draft
    Navin M    22/02/2022   ESCJ-426      Added logic to update the transaction summary record
    ***********************************************************************************************/
    public void finish(Database.BatchableContext BC) {
        system.debug(' AddressTelco finish method start : ');
        if(this.propertiesToBeUpdated.size() > 0){
            DATABASE.UPDATE(this.propertiesToBeUpdated);

            /***************** Begin of ESCJ-426+ : Navin M 22/02/22 ***********************/
            Map<Id, Transaction_Summary__c> transactionSummariesToUpdate = updateTransactionSummary(this.propertiesToBeUpdated);
            if(transactionSummariesToUpdate?.size() > 0){
                DATABASE.UPDATE(transactionSummariesToUpdate.values() , FALSE);
            }
            /***************** End of ESCJ-426+ : Navin M 22/02/22 ***********************/
            if(this.isWrappedByQueueable) {
                return;
            }
            this.call1GigServiceBatchApex(this.propertiesToBeUpdated);
        }
        system.debug(' AddressTelco finish method finish : ');
    }

    /**********************************************************************************************
    Purpose: Make callout to addressTelcoAttribute service and return the response
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/08/2021   ESCJ-328      Initial draft
    ***********************************************************************************************/
    private HttpResponse makeAddressTelcoCallOut(Property__c property){
        System.debug('AddressTelco make makeAddressTelcoCallOut start:');
        Map<String, String> queryParams = new Map<String, String>();
        Double latitude = property.Latitude__c;
        Double longitude = property.Longitude__c;
        System.debug('AddressTelco make makeAddressTelcoCallOut latitude :'+latitude+' longitude : '+longitude);
        if(latitude == null || longitude == null){
            System.debug(' Error Either latitude or longitude is empty');
            return null;
        }
        queryParams.put('latitude', String.valueOf(latitude)); //39.723035
        queryParams.put('longitude', String.valueOf(longitude));//-104.881587
        queryParams.put('expand', expand);
        String transactionSummaryId = property.Transaction_Summary__c;
        APITransactionController apiTransaction = new APITransactionController('AddressTelco', null, queryParams, transactionSummaryId);
        HttpResponse serviceResponse = APITransactionController.serviceCallout();
        System.debug('AddressTelco make makeAddressTelcoCallOut finish:');
        return serviceResponse;
    }

    /**********************************************************************************************
    Purpose: deserialize the addressTelcoAttribute service response and update Property__c record
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/08/2021   ESCJ-328      Initial draft
    Navin M    31/05/2022   ESCJ-749      Populated LQ Region Parameter field on Property using value from Telco response
    ***********************************************************************************************/
    private Map<String, Object> processResponse(HttpResponse serviceResponse, Property__c property){
         Map<String, Object> mapToReturn = new Map<String, Object>();
         Boolean isServiceResponseGood = false;
         System.debug('AddressTelco processResponse start:');
         if(serviceResponse != null && serviceResponse.getStatusCode() == 200 && serviceResponse.getBody() !=null){
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(serviceResponse?.getBody());
            Map<String, Object> wireCenterMap = (Map<String, Object>) responseMap?.get('wireCenter');

            String clli8 = (String) wireCenterMap.get('clli8');
            mapToReturn.put('clli8', clli8);
            String inRegion = (String) wireCenterMap.get('inRegion');
            if('true'.equalsIgnoreCase(inRegion)){
                property.Initial_Source_Region__c = 'In Region';
            }else{
                property.Initial_Source_Region__c = 'Out of Region';
            }
            List<Object> ocnList = (List<Object>) wireCenterMap.get('ocnList');
            if(null != ocnList && ocnList.size() > 0){
                Map<String, Object> ocnObj = (Map<String, Object>) ocnList.get(0);
                String ocnName = (String) ocnObj.get('ocnName');
                property.ocnName__c = ocnName;
            }
            // Retrieving region value from the Httpresponse
            String region = (String) wireCenterMap.get('region');
            if (region != null && String.isNotBlank(region)) {
                // If the region is QL use 'Qwest, or if region is CL use CTL else null as the LQ parameter
                property.LQ_Region_Parameter__c = region == 'QL' ? 'Qwest' : region == 'CL' ? 'CTL' : null;
            }
            isServiceResponseGood = true;
            System.debug('AddressTelco clli8 : '+clli8+' inRegion : '+inRegion+' ocnName__c : '+property.ocnName__c+' LQ_Region_Parameter__c : '+property.LQ_Region_Parameter__c);
         }
         mapToReturn.put('isServiceResponseGood', isServiceResponseGood);
         System.debug('AddressTelco processResponse finish:');
        return mapToReturn;
    }

    /**********************************************************************************************
    Purpose: Map wirecenter to a Property__c record and if no wirecenter found then create one and relate
             property to it
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/08/2021   ESCJ-328      Initial draft
    ***********************************************************************************************/
    private void mappNetworkWireCenterWithProperty(Property__c property,String clli8){
         System.debug('AddressTelco mappNetworkWireCenterWithProperty start :');
        List<Network_Wire_Center__c> networkWireCenter = [SELECT Id, Name FROM Network_Wire_Center__c WHERE Name = :clli8];
        if(networkWireCenter.size() > 0){
            Network_Wire_Center__c wireCenter = networkWireCenter[0];
            System.debug('AddressTelco exsiting wirecenter : '+wireCenter.Name + '  wirecenter id : '+wireCenter.Id);
            property.Network_Wire_Center__c = wireCenter.Id;
        }else{
            System.debug('AddressTelco no wirecenter found with the clli8 : '+clli8);
            Network_Wire_Center__c newWireCenter = new Network_Wire_Center__c();
            newWireCenter.Name = clli8;
            newWireCenter.Created_by_Telco_Attribute_Call__c = true;
            insert newWireCenter;
            System.debug('AddressTelco new wirecenterCreated with id : '+newWireCenter.Id);
            property.Network_Wire_Center__c = newWireCenter.Id;
        }
         System.debug('AddressTelco mappNetworkWireCenterWithProperty finish :');
    }

    /**********************************************************************************************
    Purpose: Call oneGigService bathc apex to process the properties
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/15/2021   ESCJ-328      Initial draft
    Navin M    31/05/2022   ESCJ-749      Added LQ_Region_Parameter__c field in the SOQL query
    ***********************************************************************************************/
    private void call1GigServiceBatchApex(List<Property__c> propertiesToBeUpdatedFor1G){
        //call the batch apex for the 1gig service
        system.debug(' AddressTelco finish method updated : '+propertiesToBeUpdatedFor1G.size() + ' Records ');
        List<Id> IDs = new List<Id>();
        for(Property__c property : propertiesToBeUpdatedFor1G){
            IDs.add(property.Id);
        }
        
        system.debug(' AddressTelco  method updated ids : '+IDs );
        List<Property__c> propertiesToBeProcessedFor1G = [SELECT Id, Network_Wire_Center_Name_Text__c, ocnName__c, Property_Auto_Gen_Number__c,
                                                    Transaction_Summary__c, Gig_Enabled__c, LQ_Region_Parameter__c
                                                    FROM Property__c WHERE Id in :IDs];
        system.debug(' AddressTelco  method updated propertiesToBeProcessedFor1G : '+propertiesToBeProcessedFor1G);
        Database.executeBatch(new BatchToProcessPropertiesFor1GService(propertiesToBeProcessedFor1G), 1);
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
                transSummary.Last_Step__c = 'AddressTelco';
                tranSummaries.put(transSummary.Id , transSummary);
            }
        }
        return tranSummaries;
    }
}