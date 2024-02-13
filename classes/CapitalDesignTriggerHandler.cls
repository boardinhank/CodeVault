/**********************************************************************************************
Purpose: Handler class for CapitalDesignTrigger
===============================================================================================
History:
AUTHOR         DATE           Reference        Description
Ami Parekh    3/03/2022       ESCJ-557         Initial draft
***********************************************************************************************/ 
public with sharing class CapitalDesignTriggerHandler implements ITriggerHandler {

    public static Boolean TriggerDisabled = false;
    public static boolean newCD = false;
    public static boolean updatedCD = false;
    public static boolean isRecursive = FALSE; 
    /**********************************************************************************************
    Purpose: To be called by triggerdispatcher to check if its disabled or not
    ===============================================================================================
    History:
 	AUTHOR         DATE           Reference        Description
	Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
    public Boolean isDisabled(){
        return TriggerDisabled;
    }

    /**********************************************************************************************
    Purpose: To perform BEFORE INSERT operations
    ===============================================================================================
    History:
    AUTHOR           DATE         Reference         Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
    public void beforeInsert(List<sObject> newList) {
        // QFCJ-4487 trying to get values to sync properly between SFCJ and SFAINT (Standard in SFCJ = Marketing in SFAINT)
        List<Capital_Design__c> newCapitalDesigns = newList;
        CapitalDesignTriggerHelper.syncCapitalDesignFieldsOnCreate(newCapitalDesigns);
        newCD = true;
    }
    
    /**********************************************************************************************
    Purpose: To perform AFTER INSERT operations
    ===============================================================================================
    History:
    AUTHOR           DATE         Reference         Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
    public void afterInsert(List<sObject> newList , Map<Id, sObject> newMap) {
         
    }
    
    /*****************************************************************************************************
    Purpose: To perform BEFORE UPDATE operations
    ======================================================================================================
    History:
    AUTHOR           DATE         Reference         Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
												   //This is Calling for the Consumer Cost Calculations
    *****************************************************************************************************/
    //This is calling for the Consumer Cost Calculations
    public void beforeUpdate(List<Capital_Design__c> newCapitalDesigns, Map<Id, sObject> newMap, 
                             List<sObject> oldList, Map<Id, sObject> oldMap) {

        Map<Id,Capital_Design__c> oldCapitalDesignMap = new Map<Id,Capital_Design__c>();
        for(Id key : oldMap.keyset()){
            Id capitalDesignId = oldMap.get(key).id;
            Capital_Design__c oldCapitalDesign = (Capital_Design__c) oldMap.get(key);
            oldCapitalDesignMap.put(capitalDesignId, oldCapitalDesign);
        }
       if(newCD == false && updatedCD == false){ // Lets go through this once
        CapitalDesignTriggerHelper.syncCapitalDesignFieldsOnUpdate(newCapitalDesigns, oldCapitalDesignMap);
        updatedCD = true;
       }

        CapitalDesignTriggerHelper.doCapitalCalculations(newCapitalDesigns);
        CapitalDesignTriggerHelperOutputSec.populateOutPutSection(newCapitalDesigns);  
                //CapitalDesignTriggerHelper.validateCapitalDesignFieldsOnUpdate(newCapitalDesigns, oldCapitalDesignMap);
         //CapitalDesignF2OutputCalculation.doF2OutputCalculations(capitalDesigns[0]);                         
    }
     
    /**********************************************************************************************
    Purpose: To perform AFTER UPDATE operations
    ===============================================================================================
    History:
    AUTHOR           DATE         Reference         Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
				  24/03/2022      ESCJ-614         For fixing bug of SubCost of F2 is not getting
												   updated
    ***********************************************************************************************/
    public void afterUpdate(List<sObject> newList, Map<Id, sObject> capitalDesignsMap,  
                            List<sObject> oldList, Map<Id, sObject> oldMap) {

 
 List< Capital_Design__c> cdlist=[select id, Capital_Design_Stage__c from Capital_Design__c where id=:capitalDesignsMap.KeySet()];   
         if(cdlist.size() > 0){
       if(oldMap.get(cdlist[0].id).get('Comments__c') != capitalDesignsMap.get(cdlist[0].id).get('Comments__c')){
              CapitalDesignTriggerHelper.CreateNote(newList);
       }
       }
 
       
       if(!CheckRecursive.firstcall) {
       CheckRecursive.firstcall = true;
             CapitalDesignTriggerHelper.getF2CostandCostft((Map<Id, Capital_Design__c>)capitalDesignsMap);
       }     
    }
    
    /**********************************************************************************************
    Purpose: To perform BEFORE DELETE operations
    ===============================================================================================
    History:
    AUTHOR           DATE         Reference         Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
    public void beforeDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
         
    }
    
    /**********************************************************************************************
    Purpose: To perform AFTER DELETE operations
    ===============================================================================================
    History:
    AUTHOR           DATE         Reference         Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
    public void afterDelete(List<sObject> oldList , Map<Id, sObject> oldMap) {
         
    }
     
    /**********************************************************************************************
    Purpose: To perform AFTER UNDELETE operations
    ===============================================================================================
    History:
    AUTHOR           DATE          Reference         Description
    Ami Parekh     3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/ 
    public void afterUnDelete(List<sObject> newList, Map<Id, sObject> newMap) {
         
    }
}