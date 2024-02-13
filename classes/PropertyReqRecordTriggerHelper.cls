public with sharing class PropertyReqRecordTriggerHelper {
    public static void createTransactionSummary(
        List<Property_Request_Record__c> newPropertyReqRecords
    ) {
        createTransactionSummary(
            newPropertyReqRecords, 
            false
        );
    }

    public static void createTransactionSummary(
        List<Property_Request_Record__c> newPropertyReqRecords,
        Boolean disableDml
    ) {
        Map<Id, Transaction_Summary__c> transactionSummariesByPrr = new Map<Id, Transaction_Summary__c>();
        Map<Id, Property_Request_Record__c> newPropertyReqRecordsMap = new Map<Id, Property_Request_Record__c>(
            newPropertyReqRecords
        );
        for(Property_Request_Record__c prr : newPropertyReqRecords) {
            GeoesParcelService.AddressValidationWrapper wrapper = new GeoesParcelService.AddressValidationWrapper(
                prr
            );
            if(prr.Transaction_Summary__c != null) {
                continue;
            }
            Transaction_Summary__c transactionSummary = new Transaction_Summary__c();
            transactionSummary.PRR_Data_Source__c = prr.Data_Source__c;
            transactionSummary.PRR_Name__c = prr.Name;

            transactionSummary.PRR_Latitude__c = wrapper.latitude;
            transactionSummary.PRR_Longitude__c = wrapper.longitude;
            transactionSummary.PRR_Address__c = wrapper.address;
            transactionSummary.PRR_City__c = wrapper.city;
            transactionSummary.PRR_State__c = wrapper.state;

            transactionSummariesByPrr.put(prr.Id, transactionSummary);
        }

        List<Transaction_Summary__c> transactionSummariesToInsert = transactionSummariesByPrr.values();
        if(transactionSummariesToInsert.isEmpty()) {
            return;
        }
        Database.SaveResult[] tranactionSummarySaveResult = Database.insert(
            transactionSummariesToInsert, 
            false //all or none
        );

        List<Property_Request_Record__c> prrsToUpdate = new List<Property_Request_Record__c>();
        for(Id prrId : transactionSummariesByPrr.keySet()) {
            Transaction_Summary__c transactionSummary = transactionSummariesByPrr.get(prrId);
            if(transactionSummary == null || transactionSummary.Id == null) {
                continue;
            }
            if(disableDml) {
                Property_Request_Record__c prr = newPropertyReqRecordsMap.get(prrId);
                prr.Transaction_Summary__c = transactionSummary.Id;
                continue;
            }
            prrsToUpdate.add(
                new Property_Request_Record__c(
                    Id = prrId,
                    Transaction_Summary__c = transactionSummary.Id
                )
            );
        }
    
        if(prrsToUpdate.isEmpty() || disableDml) {
            return;
        }
        
        // ESCJ-747 - If the PRR is created from the site then invoke the flow to update the PRRs
        // PRR is updated inside flow in this particular scenario because 'Property Site Guest User' doesn't have Edit access on PRR
        if(UserInfo.getName() == 'Property Referral Site Guest User'){ //changes made ESCJ-2007
            System.debug('Inside if loop flow initiate');
            //Create flow parameter
            Map<String, Object> params = new Map<String, Object>();
            params.put('PrrToUpdate',prrsToUpdate);
            
            //create instance of Interview
            Flow.Interview.Link_PRR_Created_From_Site_With_Transaction_Summary linkPrrWithTranSummary = new Flow.Interview.Link_PRR_Created_From_Site_With_Transaction_Summary(params);
            
            //Invoke start method
            linkPrrWithTranSummary.start();
        } else {
            Database.SaveResult[] prrSaveResult = Database.update(
                prrsToUpdate, 
                false //all or none
            );
        }   
    }

    public static void createLeadfromPrr(List<Property_Request_Record__c> newPropertyReqRecords){
        
        List<Lead> insertleadList = new List<Lead>();
        
        for(Property_Request_Record__c prr:newPropertyReqRecords){
            if(prr.Data_Source__c!='User' && prr.Match_Found_In_System__c=='No'){
                Lead newLead = new Lead(Firstname=prr.User_Contact_First_Name__c,Lastname=prr.User_Contact_Last_Name__c,Company=prr.User_Company_Name__c,Status='Open',Property_Request_Record__c=prr.Id,Requires_Marketing_Review__c=true);
            	insertleadList.add(newLead);
            }
        }
        
        if(!insertleadList.isEmpty()){
            Database.SaveResult[] leadSaveResult = Database.insert(
                insertleadList, 
                false //all or none
            );
        }
        
    }

    public static void processPrrFromManualLead(
        List<Property_Request_Record__c> updatedPropertyReqRecords, 
        Map<Id, Property_Request_Record__c> oldPropertyReqRecordsMap
    ) {
        List<Property_Request_Record__c> prrsToProcess = new List<Property_Request_Record__c>();
        for(Property_Request_Record__c prr : updatedPropertyReqRecords) {
            if(prr.Id == null) {
                continue;
            }
           
            Property_Request_Record__c oldPrr = oldPropertyReqRecordsMap.get(prr.Id);
            if(prr.isProcessed__c == false
                && prr.Data_Source__c == GeoesConstants.PROPERTY_REQUEST_RECORD_USER
                && (
                    prr.User_Latitude__c != null && prr?.User_Longitude__c != null
                    || prr.User_Property_Address__c != null 
                    || prr.User_Property_City__c != null 
                    || prr.User_Property_State__c != null
                ) && (
                    prr.User_Latitude__c != oldPrr?.User_Latitude__c
                    || prr.User_Longitude__c != oldPrr?.User_Longitude__c
                    || prr.User_Property_Address__c != oldPrr?.User_Property_Address__c
                    || prr.User_Property_City__c != oldPrr?.User_Property_City__c
                    || prr.User_Property_State__c != oldPrr?.User_Property_State__c
                    || prr.Transaction_Summary__c != oldPrr?.Transaction_Summary__c
                )
            ) {
                //System.assert(false, 'Updating the Lead');
                prrsToProcess.add(prr);
            }
        }
        if(prrsToProcess.isEmpty()) {
            return;
        }
        processPrrs(
            new Map<Id, Property_Request_Record__c>(
                prrsToProcess
            ).keySet()
        );
    }

    public static void processPrrs( 
        Set<Id> prrIds
    ) {
        CreatePropertyFromPrrQueueable cpfpQ = new CreatePropertyFromPrrQueueable(
            prrIds,
            true //chain
        );
        String cpfpQJobId = System.enqueueJob(cpfpQ);
        System.debug('(PropertyReqRecordTriggerHelper.processPrrs) CreatePropertyFromPrrQueueable for PRRs: ' + prrIds + ' was queued as JOB#' + cpfpQJobId);
    }
    
    public static void callBIWQualficatioService(List<Property_Request_Record__c> listPropertyReqRecords){
        Set<Id> prid = new set<Id>();
        for(Property_Request_Record__c prr : listPropertyReqRecords) {
        	prid.add(prr.Id);
        }
         //callBIWService(prid);

    }

      /*@future(callout=true)
    // Commenting the below BIWService
      @future(callout=true)
public static void callBIWService(Set<Id> prrId){
        BIWQualificationServiceResponseWrapper biwServiceResponse;
        LoopQualServiceResponseWrapper loopqualServiceResponse;
        Set<Id> prrids = new Set<Id>();
        List<Property_Request_Record__c> listPropertyReqRecords = [Select Id,GEOES_Longitude_Coordinate__c,GEOES_Latitude_Coordinate__c,GEOES_results__c,GEOES_Inventory_Source__c from Property_Request_Record__c where Id=:prrId];
        for(Property_Request_Record__c prr : listPropertyReqRecords) {
            if(prr!=null && (prr.GEOES_results__c!=null && prr.GEOES_results__c!='Green') && (prr.GEOES_Inventory_Source__c!='LFACS' && prr.GEOES_Inventory_Source__c!='Martens' && prr.GEOES_Inventory_Source__c!='CLC')){
                //call BIWServicecallout
                 biwServiceResponse = new BIWQualificationServiceCallout(
                    String.valueOf(prr.GEOES_Latitude_Coordinate__c),
                    String.valueOf(prr.GEOES_Longitude_Coordinate__c),
                    String.valueOf(prr.Id)
                 ).getPropertyInfo();
            }else if(prr!=null && (prr.GEOES_results__c!=null && prr.GEOES_results__c=='Green') && (prr.GEOES_Inventory_Source__c=='LFACS' || prr.GEOES_Inventory_Source__c=='Martens' || prr.GEOES_Inventory_Source__c=='CLC')){
                System.debug('Here@@@');
                loopqualServiceResponse = new LoopQualServiceCallout(String.valueOf(prr.id)).getBandwidthInfo();
            }
        }
    }*/
}