public with sharing class PropertyReqRecordTriggerHandler implements IITriggerHandler{
    public static Boolean triggerDisabled = false;

    public Boolean isDisabled() {
        return triggerDisabled;
    }

    public static void afterInsert(
        List<Property_Request_Record__c> newPropertyReqRecords
    ) {
        if(newPropertyReqRecords.isEmpty()) {
            return;
        }
        PropertyReqRecordTriggerHelper.createTransactionSummary(
            newPropertyReqRecords
        );
        PropertyReqRecordTriggerHelper.createLeadfromPrr(newPropertyReqRecords);
        /*PropertyReqRecordTriggerHelper.callBIWQualficatioService(
            newPropertyReqRecords
        );*/
    }

    public static void beforeUpdate(
        List<Property_Request_Record__c> newPropertyReqRecords,
        Map<Id, SObject> newPropertyReqRecordsMap
    ) {
        if(newPropertyReqRecords.isEmpty()) {
            return;
        }
        PropertyReqRecordTriggerHelper.createTransactionSummary(
            newPropertyReqRecords,
            true //disableDml
        );
    }

    public static void afterUpdate(
        List<Property_Request_Record__c> updatedPropertyReqRecords,
        Map<Id, SObject> oldPropertyReqRecordsMap
    ) {
        if(updatedPropertyReqRecords.isEmpty()) {
            return;
        }
        PropertyReqRecordTriggerHelper.processPrrFromManualLead(
            updatedPropertyReqRecords, 
            (Map<Id, Property_Request_Record__c>)oldPropertyReqRecordsMap
        );
        /*PropertyReqRecordTriggerHelper.callBIWQualficatioService(
            updatedPropertyReqRecords
        );*/
    }

    public void beforeInsert(List<sObject> newList) { }
    public void beforeDelete(Map<Id, sObject> oldMap) { }
    public void afterDelete(Map<Id, sObject> oldMap) { }
    public void afterUnDelete(Map<Id, sObject> newMap) { }
}