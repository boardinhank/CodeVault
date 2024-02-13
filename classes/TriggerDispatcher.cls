/*
@Author : Ganesh Sirpuram
@CreatedDate : 16th Feb 2022
@Description : Trigger Dispatcher.
*/
public class TriggerDispatcher {
    public static void run(IITriggerHandler handler) {
        if(handler.isDisabled()) {
            return;
        }
        switch on Trigger.operationType {
            when BEFORE_INSERT {
                handler.beforeInsert(Trigger.new);
            }
            when BEFORE_UPDATE {
                handler.beforeUpdate(Trigger.new, Trigger.oldMap);
            }
            when BEFORE_DELETE {
                handler.beforeDelete(Trigger.oldMap);
            }
            when AFTER_INSERT {
                handler.afterInsert(Trigger.new);
            }
            when AFTER_UPDATE {
                handler.afterUpdate(Trigger.new, Trigger.oldMap);
            }
            when AFTER_DELETE {
                handler.afterDelete(Trigger.oldMap);
            }
            when AFTER_UNDELETE {
                handler.afterUndelete(Trigger.oldMap);
            }
        }
    }
/*
@Description : It will invoke the appropriate methods on the handler depending on the trigger context.
@Parameters : ITriggerHandler handler
*/
    public static void run(ITriggerHandler handler, String triggerName, String profileIdOrUserId){
        
        System.debug('Trigger Name :: '+ triggerName);
        System.debug('Profile Id Or User Id :: '+ profileIdOrUserId);
         
        //Check if the trigger is disabled
        if (handler.IsDisabled()){
            return;
        }
         
        //Get the trigger active information from custom settings by trigger name
         Boolean isDisabled = false;
        if(String.isNotBlank(profileIdOrUserId))
         isDisabled = TriggerSettings__c.getInstance(profileIdOrUserId).Disabled__c;
        else
         isDisabled = TriggerSettings__c.getOrgDefaults()?.Disabled__c;
        
        if(!isDisabled){
            //Check trigger context from trigger operation type
            switch on Trigger.operationType {
                 
                when BEFORE_INSERT {
                    //Invoke before insert trigger handler
                    handler.beforeInsert(trigger.new);
                }
                when AFTER_INSERT {
                    //Invoke after insert trigger handler
                    handler.afterInsert(trigger.new, trigger.newMap);
                }
                when BEFORE_UPDATE {
                    //Invoke before update trigger handler
                    handler.beforeUpdate(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
                }
                when AFTER_UPDATE {
                    //Invoke after update trigger handler
                    handler.afterUpdate(trigger.new, trigger.newMap, trigger.old, trigger.oldMap);
                }
                when BEFORE_DELETE {
                    //Invoke before delete trigger handler
                    handler.beforeDelete(trigger.old, trigger.oldMap);
                }
                when AFTER_DELETE {
                    //Invoke after delete trigger handler
                    handler.afterDelete(trigger.old, trigger.oldMap);
                }
                when AFTER_UNDELETE {
                    //Invoke after undelete trigger handler
                    handler.afterUnDelete(trigger.new, trigger.newMap);
                }
            }
        }
    }
}