public class NRMARecordTriggerHandler implements IITriggerHandler{
	 public static Boolean triggerDisabled = false;

    public Boolean isDisabled() {
        return triggerDisabled;
    }

    public void afterInsert(
        List<NRMA__C> newNRMARecords
    ) {
        if(newNRMARecords.isEmpty()) {
            return;
        }
        NRMARecordTriggerHelper.updateSupportingDocumentinJSON(
            newNRMARecords,true
        );
   
    }  
    
    public void beforeUpdate(
        List<NRMA__C> newNRMARecords,
        Map<Id, SObject> newNRMARecordsMap
    ) {
        if(newNRMARecords.isEmpty()) {
            return;
        }
        
    }

    public void afterUpdate(
        List<NRMA__C> updatedNRMARecords,
        Map<Id, SObject> oldNRMARecordsMap
    ) {
        if(updatedNRMARecords.isEmpty()) {
            return;
        }
        NRMARecordTriggerHelper.updateSupportingDocumentinJSON(
            updatedNRMARecords,false
        );
       
    }

    public void beforeInsert(List<sObject> newList) { }
    public void beforeDelete(Map<Id, sObject> oldMap) { }
    public void afterDelete(Map<Id, sObject> oldMap) { }
    public void afterUnDelete(Map<Id, sObject> newMap) { }
}