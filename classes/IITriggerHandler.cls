//the better trigger handler interface
public interface IITriggerHandler 
{
    void beforeInsert(List<SObject> newItems);
    void beforeUpdate(List<SObject> newItems, Map<Id, SObject> oldItems);
    void beforeDelete(Map<Id, SObject> oldItems);
    void afterInsert(List<SObject> newItems);
    void afterUpdate(List<SObject> newItems, Map<Id, SObject> oldItems);
    void afterDelete(Map<Id, SObject> oldItems);
    void afterUndelete(Map<Id, SObject> oldItems);
    Boolean isDisabled();
}