/**
 * 
 * HANK		QFCJ-4013		created logic to sync / send attachments to SFAINT
 * 
 */

@isTEst
private class contentDocumentLinkTriggerHelper_Test {
    
    @testSetup
    static void setup(){
    
            Capital_Design__c CapDesign = new Capital_Design__c(
                Capital_Design_Stage__c = 'In-Progress',
                SFAINT_Id__C = 'a018M000004wWPyQAM');
            insert CapDesign;
        }
    
    
    @isTest 
    static void createAttachment(){
        
         capital_design__c getCapDesId = [select id, SFAINT_ID__c from capital_design__c limit 1];
		// Create contentDocument so that the contentVer and contentDocumentLink is created. 
		// {"Title":+title+,"PathOnClient":"simple","ContentLocation":"S","FirstPublishLocationId":+parentId+,"VersionData":+base64File}'
		contentVersion newFile = new contentVersion();
        newFile.Title = 'test title';
        newFile.PathOnClient = 'test title.txt';
        newFile.contentLocation = 'S';
        newFile.FirstPublishLocationId = getCapDesId.id;
        newFile.VersionData = blob.valueOf('some junk here');        
        insert newFile;
        
        list<contentVersion> createAttachment = [select id from contentVersion];       
        System.assertEquals(createAttachment.size() , 1);
        
    }
    
}