@RestResource(urlMapping='/v/SFCJAttachment1/')
global class SFCJAttachment{
    
    @HttpPost
    global static string doPost(){
        RestRequest req = RestContext.request;
        string jsonRes = req.requestBody.toString();
        Account a = (account)JSON.deserialize(jsonRes, Account.class);
        try{
            insert a;
            return 'Account Created';
        }
        catch(Exception ex){
            return ex.getMessage();
        }
    }
    
    
    
    /**  @HttpPost
    global static void createAttachment(string fileName, string fileContent, string parentId){
        ContentVersion contentVer = new ContentVersion();
        contentVer.title = fileName;
        contentVer.pathOnClient = fileName;
        contentVer.versionData = blob.valueOf(fileContent);
        contentVer.contentLocation = 'S';        
        insert contentVer;   
        
        contentVersion getContent = [SELECT Id, ContentDocumentId FROM ContentVersion where Id = :contentVer.id];
        ContentDocumentLink contentLink = new ContentDocumentLink();
        contentLink.ContentDocumentId = getContent.ContentDocumentId;
        contentLink.LinkedEntityId = parentId;
        contentLink.ShareType = 'V';
        insert contentLink;
        
    } */
    
}