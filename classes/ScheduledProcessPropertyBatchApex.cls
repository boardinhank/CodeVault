/*********************************************************************************************************
Purpose: Schedular apex to call the BatchToProcessPropertiesForAddTelco apex to process the properties
======================================================================================================
History:
AUTHOR     DATE         Reference     Description
Deepak     12/15/2021   ESCJ-328      Initial draft
Navin M    31/05/2022   ESCJ-749      Added LQ_Region_Parameter__c field in the SOQL query
HANK        9/25/2023   QFCJ-4622     Added query logic to make this more efficient and prevent API failure
******************************************************************************************************/
public with sharing class ScheduledProcessPropertyBatchApex implements Schedulable{

    public DateTime lastAttempt;
    public Integer hours;
    public Decimal apiCount;
    public String sortBy;
    public Integer howManyRecords;

    /****************************************************************************************************
    Purpose: Implementing the execute method of Schedulable interface to call the addressTelco batch apex
    ======================================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/15/2021   ESCJ-328      Initial draft
    ******************************************************************************************************/
    public void execute(SchedulableContext sc) {
       System.debug('ScheduledProcessPropertyBatchApex execute methos start');
       List<Property__c> propertyList = this.getPropertyList();
       List<List<Property__c>> listOfPropertyList = this.dividePropertiesIntoBatches(propertyList);
       if(listOfPropertyList?.size() > 0){
            for(List<Property__c> properties : listOfPropertyList ){
                Database.executeBatch(new BatchToProcessPropertiesForAddTelco(properties), 1);
            }
       }//close if
      System.debug('ScheduledProcessPropertyBatchApex execute methos finish');
   }//close execute method


    /*****************************************************************************************************
    Purpose: getPropertyList method to return list of properties which needs to procesed by
             addressTelco batch apex
    ======================================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/15/2021   ESCJ-328      Initial draft
    Navin M    31/05/2022   ESCJ-749      Added LQ_Region_Parameter__c field in the SOQL query
    ******************************************************************************************************/
    private List<Property__c> getPropertyList(){

                    // get metadata and setup variables for query
                    BatchConfigSetting__mdt getMetaConfig = [select id, failedCount__c, hourOffset__c, recordsToProcess__c, sortByAscDesc__c from BatchConfigSetting__mdt where developername = 'ScheduledProcessPropertyBatchApex'];
                    hours = integer.valueOf(getMetaConfig.hourOffset__c);
                    lastAttempt = system.now().addhours(-hours);
                    apiCount = getMetaConfig.failedCount__c;
                    sortBy = getMetaConfig.sortByAscDesc__c;
                    howManyRecords = Integer.valueOf(getMetaConfig.recordsToProcess__c);

                    
        System.debug('ScheduledProcessPropertyBatchApex getPropertyList method start');
        List<Property__c> propertyList = [SELECT Id, Latitude__c, Longitude__c, Distribution_Status__c, Initial_Source_Region__c, Gig_Enabled__c, ocnName__c, Network_Wire_Center_Name_Text__c, 
                                                   Transaction_Summary__c, LQ_Region_Parameter__c, apiCount__c, lastAPICallout__c
                                                           FROM Property__c
                                                          WHERE Distribution_Status__c != 'Distributed'
                                                          AND Gig_Enabled__c = null
                                                          AND Initial_Source_Region__c != null
                                                          AND LQ_Region_Parameter__c != null
                                                          AND (lastAPICallout__c > :lastAttempt OR lastAPICallout__c = null)
                                                          AND (apiCount__c < :apiCount OR apiCount__c = null) 
                                                          order by createddate asc limit :howManyRecords];

                                         //AND id='a0A8F0000008n2xUAA'];
        System.debug('ScheduledProcessPropertyBatchApex getPropertyList method propertyList '+propertyList.size());
        System.debug('ScheduledProcessPropertyBatchApex getPropertyList method finish');
        return propertyList;
    }

   /*****************************************************************************************************
    Purpose: Method to divide list of properties into five lists so those can be processed parallely
    ======================================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     12/15/2021   ESCJ-328      Initial draft
    ******************************************************************************************************/
    public List<List<Property__c>>  dividePropertiesIntoBatches(List<Property__c> propertyList){
       System.debug('ScheduledProcessPropertyBatchApex dividePropertiesIntoBatches method start');
       Integer offsetCount = 0 ;
       Integer Count = 0;
       Integer noOfSegements = 0;
       List<List<Property__c>> listOfPropertyList = new List<List<Property__c>>();
       System.debug('Size of propertyList----'+propertyList?.size());
       if(propertyList?.size() > 0) {
           offsetCount = propertyList?.size() / 5 ;
           System.debug('Size of offsetCount----'+offsetCount);
           if(offsetCount > 0){
                // Calculate the no. of records will remain to be added in the list
                Integer remainder = Math.mod(propertyList?.size(), 5);
                List<Property__c> tempPropertyList = new List<Property__c>();
                for(Property__c property : propertyList){

                    tempPropertyList.add(property);
                    Count++ ;
                    if(noOfSegements < 4){
                        if(Count == offsetCount){
                            listOfPropertyList.add(tempPropertyList);
                            tempPropertyList = new List<Property__c>();
                            Count = 0;
                            noOfSegements++;
                        }
                    }
                }
                   // If the remainder is greater than zero then add the list remaining record in the list
                if(remainder > 0){
                    listOfPropertyList.add(tempPropertyList);
                }
            }else{
                listOfPropertyList.add(propertyList);
            }
       }//close if for propertyList check
        System.debug('Size of listOfPropertyList----'+listOfPropertyList?.size());
       System.debug('ScheduledProcessPropertyBatchApex dividePropertiesIntoBatches method finish');
       return listOfPropertyList;
   }//close the method dividePropertiesIntoBatches

}