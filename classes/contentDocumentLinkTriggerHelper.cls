/**
* Using the contentDocumentLink record to keep it simple these are only created if a record is related to the file
* 
* 
* HANK		10/17/2023		QFCJ-4013 - Created class for SF to SF file creation since out of the box its not working
* 
*/

public class contentDocumentLinkTriggerHelper {
    
    public static void attachmentSync(list<contentDocumentLink> newAttachments){

        set<Id> relatedCDIds = new set<Id>();
        set<Id> contentVersionIds = new set<Id>();
        List<ContentDocumentLink> relatedToCapDes = new List<ContentDocumentLink>();
        list<capital_design__c> getRelatedCapDes = new list<capital_design__c>();
        list<contentVersion> getRelatedContVer = new list<contentVersion>();
        map<Id,capital_design__C> mapIdToCapDes = new map<Id,capital_design__C>();
        map<Id,contentVersion> mapIdToContVer = new map<Id,contentVersion>();
        list<syncRecord> attachmentsToSync = new list<syncRecord>();
        
        for(contentDocumentLink newAttachment : newAttachments){
            syncRecord syncData = new syncRecord();
            string capDesIdString = string.valueOf(newAttachment.LinkedEntityid);
            string capDesignPrefix = capDesIdString.left(3);
            
            // check if the attachment was added on the CD record
            if(capDesignPrefix == 'a01'){              
                // add to a list to do more checks to see if attachment should be synced to SFAINT
                system.debug('@@@@@ Created on capital design record: '+newAttachment.LinkedEntityId);
                    relatedToCapDes.add(newAttachment);
                    relatedCDIds.add(newAttachment.LinkedEntityId);
                    contentVersionIds.add(newAttachment.ContentDocumentId);
            }
        }
            if(relatedToCapDes.size() > 0){
                // get related Capital Design Data
                try {
                getRelatedCapDes = [select Id, Capital_design_Id__c, SFAINT_ID__c from capital_design__C where Id IN :relatedCDIds AND SFAINT_ID__c != null];
            } catch(DmlException e) {
                System.debug('Error when trying to query for related capital design records: ' + e.getMessage());
            }
             try {
                string SFAINTApiUsernameId = system.label.SFAINTApiUsernameId;
                getRelatedContVer = [SELECT Id, Title, VersionData, FileExtension, ContentDocumentId, ContentSize FROM ContentVersion 
                                          WHERE IsLatest = TRUE and FileExtension != 'snote' and FileExtension != null
                                                 and ContentDocumentId IN :contentVersionIds and OwnerId != :SFAINTApiUsernameId];        
            } catch(DmlException e) {
                System.debug('Error when trying to query for related content version records: ' + e.getMessage());
            } 
            }

            if(getRelatedCapDes.size() > 0){
                for(capital_design__C relatedCapDes : getRelatedCapDes){
                    mapIdToCapDes.put(relatedCapDes.Id,relatedCapDes);
                }
            }

            if(getRelatedContVer.size() > 0){
                for(contentVersion relatedContVer : getRelatedContVer){
                    system.debug('@@@@@ Content Size: '+relatedContVer.ContentSize);
                    if(relatedContVer.ContentSize < decimal.valueOf(system.label.SFAINTApiContentSizeLimit)){
                    mapIdToContVer.put(relatedContVer.ContentDocumentId,relatedContVer);
                } else {
                    system.debug('@@@@@ Content size is to large to sync to SFAINT limit is: '+system.label.SFAINTApiContentSizeLimit);
                }
                }
            }

            if(mapIdToCapDes.size() > 0 && mapIdToContVer.size() > 0){
                for(contentDocumentLink newAttachment : newAttachments){
                    // need to skip doing this if no matching records are in the map. 
                    if(mapIdToCapDes.get(newAttachment.LinkedEntityId) != null && mapIdToContVer.get(newAttachment.ContentDocumentId) != null){
                    syncRecord syncData = new syncRecord();
                    syncData.Title = mapIdToContVer.get(newAttachment.ContentDocumentId).title;
                    syncData.Base64File = EncodingUtil.base64Encode(mapIdToContVer.get(newAttachment.ContentDocumentId).VersionData);
                    syncData.SFCJID = newAttachment.LinkedEntityId;
                    syncData.SFAINTId = mapIdToCapDes.get(newAttachment.LinkedEntityId).SFAINT_ID__c;
                    syncData.fileExtension = mapIdToContVer.get(newAttachment.ContentDocumentId).FileExtension;
                    syncData.attachmentId = newAttachment.ContentDocumentId;
                    attachmentsToSync.add(syncData);

                    }
                }
            } else {
                system.debug('@@@@@ Capital Design Map or Content Version Map is empty so we cannot sync the attachment to SFAINT');
            }

            if(attachmentsToSync.size() > 0){
                for(syncRecord syncAttachment : attachmentsToSync){
                    if(!Test.isRunningTest()){
                    try {
                       lmn_SFAINTApiService.sendFile(syncAttachment.Title, syncAttachment.base64File, syncAttachment.SFAINTId, syncAttachment.fileExtension, syncAttachment.SFCJId, syncAttachment.attachmentId);
                    } catch(DmlException e) {
                        System.debug('Error when trying to sync Attachment to SFAINT: ' + e.getMessage());
                    }
                  }
                }
            }

    }    
    
    public class syncRecord {
        public string attachmentId {get; set;}       // contentDocumentLink.ContentDocumentId
        public string SFCJID {get; set;}    // contentDocumentLink.LinkedEntityId
        public string SFAINTID {get; set;}     
        public string title {get; set;} //  contentDocument.title
        public string base64File {get; set;}    // ContentDocument.
        public string fileExtension {get; set;}
        
    }
    
}