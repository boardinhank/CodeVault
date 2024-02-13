/***************************************************************
AUTHOR     DATE         Reference     Description (TestClass)
Ross F     10/17/2022   FSDP-101433   Utility class for sending Account_MDM__e platform event for MDM sync
***************************************************************/
public class PlatformEventsUtility {
    
    public static Set<String> platformIntUsrIds{
        get{
            if(platformIntUsrIds == null){
                platformIntUsrIds = new Set<String>();
                List<User> piUsrs = [Select Id From User Where Name='Platform Integration User'];
                for(User usr : piUsrs){
                    platformIntUsrIds.add(usr.Id);
                }
        	}
            return platformIntUsrIds;
        }
        set;
    }
    
     @Future
    public static void publishCustomerPlatformEventFuture(String accountIdWithFieldsJSON, boolean eventActionIsInsert){
        publishCustomerPlatformEvent(accountIdWithFieldsJSON,eventActionIsInsert);
    }
    
    //sync call
    public static void publishCustomerPlatformEventSync(String accountIdWithFieldsJSON, boolean eventActionIsInsert){
        publishCustomerPlatformEvent(accountIdWithFieldsJSON,eventActionIsInsert);
    }
  
    public static void publishCustomerPlatformEvent(String accountIdWithFieldsJSON, boolean eventActionIsInsert){
        //This function will publish event for accounts passed in parameter.
        
        Set<String> allFieldsSet = new Set<String>();
        Map<String, Set<EventResource__mdt>> eResourceFieldsMap = new Map<String, Set<EventResource__mdt>>();
        
        Map<String, Object> accountIdWithFieldsMap = (Map<String, Object>) System.JSON.deserializeUntyped(accountIdWithFieldsJSON);

        //get all eventResource
        for(EventResource__mdt eResourceRef:[select MasterLabel, Trigger_Field_API_Name__c,Synced_Field_API_Name__c from EventResource__mdt where Event__c = 'Account' and sObject__c = 'Account' order by Label desc]){
            
            if(!eResourceFieldsMap.containsKey(eResourceRef.Trigger_Field_API_Name__c)){
                eResourceFieldsMap.put(eResourceRef.Trigger_Field_API_Name__c,new Set<EventResource__mdt>{eResourceRef});
            }else{
                eResourceFieldsMap.get(eResourceRef.Trigger_Field_API_Name__c).add(eResourceRef);
            }
            allFieldsSet.add(eResourceRef.Synced_Field_API_Name__c); 
        }

        //SOQL to get all related field values from Account id set.
        String fieldset = '';
        Set<String> idSet = new Set<String>();
        idSet.addAll(accountIdWithFieldsMap.keyset());
        
        for(String s:allFieldsSet){ //using for loop as we cannot assign all values from large Set to string directly.
            if(String.isNoTBlank(fieldset)) fieldset = fieldset+','; 
            fieldset = fieldset+s;
        }
        fieldset = fieldset.removeEnd(',');

        String accountQueryString = 'Select Id, '+fieldSet+' from Account where id IN :idSet Limit 49999';
        //SOQL ends
		System.debug('Acct Query: '+ accountQueryString);
        //create new fieldsmap = event_resource.Name,acc.get(fieldValue); (String,Object).
        List<Account_MDM__e> cEvents = new List<Account_MDM__e>();
        Map<String,Object> fieldsPayloadMap = new Map<String,Object>();
        Set<String> changedFieldsPayloadSet = new Set<String>();
        List<Object> triggerFieldsSet = new List<Object>();
        for(Account accRef:database.query(accountQueryString)){
    
            for(String triggerFieldAPIName:eResourceFieldsMap.keyset()){ //for each trigger-field in metadata //FSAPP-6696
                for(EventResource__mdt eventResourceRef:eResourceFieldsMap.get(triggerFieldAPIName)){ //for each trigger Field add all sync fields.//new change
                    System.debug('Putting trigger field in metadata: '+eventResourceRef.Synced_Field_API_name__c);
                    fieldsPayloadMap.put(eventResourceRef.Synced_Field_API_Name__c,getObjectValue(eventResourceRef.Synced_Field_API_Name__c, accRef));
                }
            }
            
            //Build the Customer__e event //add other fields like recordtypeInfo in SOQL.
            cEvents.add(new Account_MDM__e (Changed_Field_Values__c = JSON.serialize(fieldsPayloadMap)));
            system.debug('#Changed_Field_Values#'+JSON.serialize(fieldsPayloadMap));
        }
        if(!cEvents.isEmpty()){
            List<Database.SaveResult> results = EventBus.publish(cEvents); 
            Integer i=0; 
            for (Database.SaveResult result: results){
                if (result.isSuccess()){
                    System.debug('Publish Event' + cEvents[i].Changed_Field_Values__c);
                }else{
                    System.debug('Publish failed '+ result.getErrors()[0].getMessage());
                }
             i++;          
            }
        }
    }
    
    //returns accountId with triggerFields map
    public static Map<String,Set<String>> getAccountIdWithTriggerFields(map<id,sObject> oldRecordsMap,map<id,sObject> newRecordsMap,boolean eventActionIsInsert){
        Set<String> allTriggerFieldSet = new Set<String>();
        Map<String,Set<String>> accountIdWithFieldsMap = new Map<String,Set<String>>(); //Id with changed triggerField's Set
        eventActionIsInsert = eventActionIsInsert == null?true:eventActionIsInsert;
        //get all eventResource
        for(EventResource__mdt eResourceRef:[select Trigger_Field_API_Name__c,Synced_Field_API_Name__c from EventResource__mdt where Event__c = 'Account' and sObject__c = 'Account' order by Label desc]){
            allTriggerFieldSet.add(eResourceRef.Trigger_Field_API_Name__c);
        }
                
        for(Account accountRef: (List<Account>)newRecordsMap.values()){   
            Set<String> triggerFieldsSet = new set<String>(); 
           
            if(!platformIntUsrIds.contains(accountRef.LastModifiedById)){
                accountIdWithFieldsMap.put(accountRef.Id,triggerFieldsSet);
            }
        }
        return accountIdWithFieldsMap;
    }
    
    /*
     * Helper method for Account Trigger
     */
    public static void callPublishCustomerPlatformEvent(map<id,Account> oldRecordsMap,map<id,Account> newRecordsMap,boolean eventActionIsInsert){
        
        //if(triggerStack.peekNpush('Account', 'callPublishCustomerPlatformEvent', false)) return;
        Map<String,Set<String>> accountIdWithFieldsMap = new Map<String,Set<String>>(); //Id with changed triggerField's Set
        Map<String,Set<String>> accountIdWithNonCUIFieldsMap = new Map<String,Set<String>>(); 
        Map<String,EventResource__mdt> allTriggerFieldsMap = new Map<String,EventResource__mdt>();
        boolean isCUIdisabled = false;
       
        system.debug('##disabled?#'+isCUIdisabled);
        accountIdWithFieldsMap = PlatformEventsUtility.getAccountIdWithTriggerFields(oldRecordsMap,newRecordsMap,eventActionIsInsert);
        System.Debug('accountIdWithFieldsMap : ' + accountIdWithFieldsMap.keySet());
        System.Debug('accountIdWithFieldsMap vals : ' + accountIdWithFieldsMap.values());

        //if(isCUIdisabled && !accountIdWithFieldsMap.isEmpty()){
        if(System.isFuture() || System.isBatch() || System.isScheduled() || System.isQueueable()){ //Publish event in sync.
            PlatformEventsUtility.publishCustomerPlatformEventSync(JSON.serialize(accountIdWithFieldsMap),eventActionIsInsert); //serialize and call sync method
        }else{
            PlatformEventsUtility.publishCustomerPlatformEventFuture(JSON.serialize(accountIdWithFieldsMap),eventActionIsInsert); //serialize and call future method
        }
        return;
        
    }
    
    /*
     * Params : 
     * sourcePath - string tha represent the path to the field (e.g. Acccount.Name)
     * targetObject - Sobject from where the value will be extracted
     * getValue - return the value of a SObject associated to a path notation.
     * Returns :
     * Object - retunr the content of the field related to the path
    */
    public static Object getObjectValue(String sourcePath,SObject targetObject){
        try{
            Object value = null;
            List<String> fieldNodes = sourcePath.split('\\.');
            string nodeName = fieldNodes.remove(0);            
            if(fieldNodes.isEmpty()){
                value = targetObject.get(nodeName);
            } else{
                String remaingPath = String.join(fieldNodes,'.' );
                SObject innerObject = targetObject.getSObject(nodeName);
                if(innerObject == null){
                    return null;
                }
                value = getObjectValue(remaingPath, innerObject);
            }
            return value;
        }
        catch(Exception e){
            return null;
        }
    }
    
    //till here utility functions
}