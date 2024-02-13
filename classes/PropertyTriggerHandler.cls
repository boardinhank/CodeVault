public with sharing class PropertyTriggerHandler implements IITriggerHandler{
    public static Boolean triggerDisabled = false;

    public Boolean isDisabled() {
        return triggerDisabled;
    }

    public void afterInsert(List<sObject> newList) { }
    public void beforeUpdate(List<sObject> newList, Map<Id, SObject> OldMap) { }
    public void afterUpdate(List<sObject> newList, Map<Id, SObject> OldMap) { }
    public void beforeInsert(List<sObject> newList) { }
    public void beforeDelete(Map<Id, sObject> oldMap) { }
    public void afterDelete(Map<Id, sObject> oldMap) { }
    public void afterUnDelete(Map<Id, sObject> newMap) { }
}