@RestResource(urlMapping='/sfcj/api/attachment/*')
global class lmn_APIAttachment{
    
    @HttpPost
    //title, PathOnClient, ContentLocation, parentId, base64File
    global static void createFile(){
        string title, pathOnClient, contentLocation, firstPublishLocationId;
        string fieldName, fieldValue;
        blob versionData;
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String jsonBody = req.requestBody.toString();
        JSONParser parser = JSON.createParser(jsonBody);
        
        while(parser.nextToken() != null){
            
            if(parser.getCurrentToken() != JSONToken.END_OBJECT){
                fieldName = parser.getCurrentName();
                fieldValue = parser.getText();
                
                if(fieldName == 'title'){
                    title = fieldValue;
                    system.debug('$$$$$ Title: '+title);
                } else if(fieldName == 'pathOnClient'){
                    pathOnClient = fieldValue;
                    system.debug('$$$$$ pathOnClient: '+pathOnClient);
                }
                else if(fieldName == 'contentLocation'){
                    contentLocation = fieldValue;
                    system.debug('$$$$$ contentLocation: '+contentLocation);
                }
                else if(fieldName == 'firstPublishLocationId'){
                    firstPublishLocationId = fieldValue;
                    system.debug('$$$$$ firstPublishLocationId: '+firstPublishLocationId);
                }
                else if(fieldName == 'versionData'){
                    versionData = blob.valueOf(fieldValue);
                    system.debug('$$$$$ versionData: '+versionData);
                }
                
            }
        }
        
        ContentVersion newFile = new ContentVersion();
        newFile.Title = title;
        newFile.PathOnClient = pathOnClient;
        newFile.ContentLocation = contentLocation;
        newFile.FirstPublishLocationId = FirstPublishLocationId;
        newFile.VersionData = VersionData;
        try {
        insert newFile;
        		} catch(DmlException e) {
			System.debug('Error when trying to create new attachment: ' + e.getMessage());
		}
        // need to do lookup of the new record in contentDocument object and send that ID back to SFAINT
        contentdocument CD = [select id from contentDocument where LatestPublishedVersionId = :newFile.id];
        
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(CD.id);
        
    } 
    
    @HttpDelete
    global static void deleteFile(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        string fileId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        try{
        delete [select id, title from contentDocument where id = :fileId];
     		} catch(DmlException e) {
			System.debug('Error when trying to delete attachment: ' + e.getMessage());
		}
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(fileId +' got deleted');
        
    }
    
}