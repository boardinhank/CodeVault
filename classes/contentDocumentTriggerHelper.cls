/**
*  use this for delete of attachments. Create/Sync is on contentDocumentLinktriggerhelper. There is no clean way of using one object to create and delete. 
*  On CONTENTDOCUMENT object the LatestPublishedVersionId refers to the CONTENTVERSION object recordId.....
*  On CONTENTVERSION object the FirstPublishLocationId refers to the Parent Record or Related Record so we use that to see if its a capital design relationship
*  
*   HANK  10/23/2003  -  QFCJ-4013   need a way to sync file attachments between instances
* 
*/

public class contentDocumentTriggerHelper {
    
    public static void deleteAttachment(list<contentDocument> deleteAttachments){
        
        set<Id> allDeletedIds = new set<Id>();
        set<Id> allContentVersionIds = new set<Id>();
        list<contentVersion> getConVerRecords = new list<contentVersion>();
        list<SFAINT_Attachment__c> deleteRecords = new list<SFAINT_Attachment__c>();
        list<SFAINT_Attachment__c> deleteJuncObjRecords = new list<SFAINT_Attachment__c>();
        contentVersion getContentVersion = new contentVersion();
        SFAINT_Attachment__c getJunctionRecord = new SFAINT_Attachment__c();
        string capDesignPrefix;
        string capDesIdString;
        
        for(contentDocument deleteAttachment : deleteAttachments){
            // looped to collect all ids to make it bulkified
            system.debug('@@@@@ ContentVersion Record Id used for query: '+deleteAttachment.LatestPublishedVersionId);                       
            allDeletedIds.add(deleteAttachment.LatestPublishedVersionId);
        }
        
        if(allDeletedIds.size() > 0){
            // Lets get all the contentVersion records data. 
            try {
                getConVerRecords = [select id, FirstPublishLocationId, ContentDocumentId from contentversion where Id IN :allDeletedIds];
            } catch(DmlException e) {
                System.debug('Error when making query to get contentVersion Record: ' + e.getMessage());
            }
        }
        
        if(getConVerRecords.size() > 0){
            // If we have data lets loop through it and check for a capital design relationship all CD's start with 'a9I'           
            for(contentVersion getConVerRecord : getConVerRecords){                
                capDesIdString = string.valueOf(getConVerRecord.FirstPublishLocationId);
                capDesignPrefix = capDesIdString.left(3);               
                if(capDesignPrefix == 'a01'){
                    allContentVersionIds.add(getConVerRecord.ContentDocumentId);
                }               
            }            
        }
        
        if(allContentVersionIds.size() > 0){
            // last query to junction object to get ids for deletion
            try {
                deleteRecords = [select id, SFAINT_Attachment_ID__c, SFCJ_Id__c from SFAINT_Attachment__c where Attachment_Id__c IN :allContentVersionIds];
            } catch(DmlException e) {
                System.debug('Error when making query to get junction Object SFAINT_Attachment__c Record: ' + e.getMessage());
            }         
        }
        
        if(deleteRecords.size() > 0){
            // lets loop through records and try to delete them
            for(SFAINT_Attachment__c deleteRecord : deleteRecords){
                // these are future callouts so I need to send them one at a time. 
                try {
                    lmn_SFAINTApiService.deleteFile(deleteRecord.SFAINT_Attachment_ID__c);
                } catch(DmlException e) {
                    System.debug('Error when making callout to delete SFAINT record: ' + e.getMessage());
                }
                // add to a list for deletion
                deleteJuncObjRecords.add(deleteRecord);
            }
        }
        
        if(deleteJuncObjRecords.size() > 0){
            try {
                delete deleteJuncObjRecords;
            } catch(DmlException e) {
                System.debug('Error when trying to delete junction Object Record: ' + e.getMessage());
            }

            List<Capital_Design__c> updateCDRecords = new List<Capital_Design__c>();
            list<SFAINT_Attachment__C> getSFAINTAttachments = new list<SFAINT_Attachment__c>();

            for(SFAINT_Attachment__c deleteRecord : deleteRecords){
        // query all records in junction object so we can update the CD with all attachments successfully synced. 
        getSFAINTAttachments = [select id, Title__c from SFAINT_Attachment__c where SFCJ_Id__c = :deleteRecord.SFCJ_Id__c];

        if(getSFAINTAttachments.size() > 0){
            string results;
            for(SFAINT_Attachment__c getSFAINTAttachment : getSFAINTAttachments){
                if(results == null){
                    results = getSFAINTAttachment.title__c+'\n';
                } else {
                    results = results +getSFAINTAttachment.title__c+'\n';
                }

            }

            if(results != null){
                Capital_design__c updateCapitalDesign = new Capital_design__c();
                updateCapitalDesign.id = deleteRecord.SFCJ_Id__c;
                updateCapitalDesign.Attachments_Synced_to_SFAINT__c = results;
                updateCDRecords.add(updateCapitalDesign);
            }
          } else {
            Capital_design__c updateCapitalDesign = new Capital_design__c();
            updateCapitalDesign.id = deleteRecord.SFCJ_Id__c;
            updateCapitalDesign.Attachments_Synced_to_SFAINT__c = 'No Files Synced';
            updateCDRecords.add(updateCapitalDesign);
          }
        }

        If(updateCDRecords.size() > 0){
            try{
            update updateCDRecords;
        } catch(DmlException e) {
            System.debug('Error when updating the Capital Design Attachments Synced to SFAINT field After Delete: ' + e.getMessage());
        }
        }
            
        }
        
        
    }
    
    
}