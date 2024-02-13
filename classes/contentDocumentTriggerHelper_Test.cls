@isTest
private class contentDocumentTriggerHelper_Test {

    @testSetup
    static void setup(){
        // create capital design to use the ID         
            Capital_Design__c CapDesign = new Capital_Design__c(
                Capital_Design_Stage__c = 'In-Progress',
                SFAINT_Id__C = 'a018M000004wWPyQAM');
            insert CapDesign;
        }

    
    @isTest
    static void deleteAttachmentOne(){
        // get that content and delete it
        capital_Design__c getCapDesId = [select id from capital_design__c limit 1];
        // create a contentDocument and contentVersion
        ContentVersion newFile = new ContentVersion();
        newFile.Title = 'Test Title';
        newFile.PathOnClient = 'Test Title.txt';
        newFile.ContentLocation = 'S';
        newFile.FirstPublishLocationId = getCapDesId.Id;
        newFile.VersionData = blob.valueOf('this is the body');
        insert newFile;
        
        contentVersion getContactVersion = [select id, contentDocumentId from contentVersion where title = 'test Title' limit 1];
		system.debug('@@@@@'+getContactVersion.contentDocumentId);
        contentDocument getContentDocument = [select id from contentDocument where Id = :getContactVersion.contentDocumentId];
        system.debug('@@@@@'+getContentDocument.Id);
        
        SFAINT_Attachment__c newAttachment = new SFAINT_Attachment__c();
        newAttachment.SFCJ_ID__c = 'a018M000004wWPyQAM';
        newAttachment.SFAINT_ID__c = getCapDesId.Id;
        newAttachment.Attachment_ID__c = getContentDocument.Id;
        newAttachment.SFAINT_Attachment_ID__c = 'a018M000004wWPyQAM';
        newAttachment.Title__c = 'Test Title.txt';
        insert newAttachment;
        
        contentDocument deletAttachment = [select id from contentDocument where id = :getContentDocument.Id];
        delete deletAttachment;
        list<contentDocument> deletAttachment1 = [select id from contentDocument where id = :getContentDocument.Id];
        
        System.assertEquals(deletAttachment1.size() , 0);
        
    }
    
        @isTest
    static void deleteAttachmentTwo(){   // need to have more than one attachment in there to get everything covered
        // get that content and delete it
        capital_Design__c getCapDesId = [select id from capital_design__c limit 1];
        // create a contentDocument and contentVersion
        ContentVersion newFile = new ContentVersion();
        newFile.Title = 'Test Title';
        newFile.PathOnClient = 'Test Title.txt';
        newFile.ContentLocation = 'S';
        newFile.FirstPublishLocationId = getCapDesId.Id;
        newFile.VersionData = blob.valueOf('this is the body');
        insert newFile;
        
        contentVersion getContactVersion = [select id, contentDocumentId from contentVersion where title = 'Test Title' limit 1];
		system.debug('@@@@@'+getContactVersion.contentDocumentId);
        contentDocument getContentDocument = [select id from contentDocument where id = :getContactVersion.contentDocumentId];
        system.debug('@@@@@'+getContentDocument.Id);
        
        SFAINT_Attachment__c newAttachment = new SFAINT_Attachment__c();
        newAttachment.SFCJ_ID__c = getCapDesId.Id;
        newAttachment.SFAINT_ID__c = 'a018M000004wWPyQAM';
        newAttachment.Attachment_ID__c = getContentDocument.Id;
        newAttachment.SFAINT_Attachment_ID__c = 'a018M000004wWPyQAM';
        newAttachment.Title__c = 'Test Title.txt';
        insert newAttachment;

        // create a contentDocument and contentVersion
        ContentVersion newFile1 = new ContentVersion();
        newFile1.Title = 'Test Title1';
        newFile1.PathOnClient = 'Test Title1.txt';
        newFile1.ContentLocation = 'S';
        newFile1.FirstPublishLocationId = getCapDesId.Id;
        newFile1.VersionData = blob.valueOf('this is the body 1');
        insert newFile1;
        
        contentVersion getContactVersion1 = [select id, contentDocumentId from contentVersion where title = 'Test Title1' limit 1];
        contentDocument getContentDocument1 = [select id from contentDocument where id = :getContactVersion1.contentDocumentId];
        SFAINT_Attachment__c newAttachment1 = new SFAINT_Attachment__c();
        newAttachment1.SFCJ_ID__c = getCapDesId.Id;
        newAttachment1.SFAINT_ID__c = 'a018M000004wWPyQAM';
        newAttachment1.Attachment_ID__c = getContentDocument1.Id;
        newAttachment1.SFAINT_Attachment_ID__c = 'a018M000004wWPyQAM';
        newAttachment1.Title__c = 'Test Title1.txt';
        insert newAttachment1;

        contentDocument deletAttachment = [select id from contentDocument where id = :getContentDocument.Id];
        delete deletAttachment;
        list<contentDocument> deletAttachment1 = [select id from contentDocument where id = :getContentDocument.Id];
        
        System.assertEquals(deletAttachment1.size() , 0);
        
    }
    
    
}