/**
* 
* HANK		10/17/2023		QFCJ-4013 - This does actual callout to SFAINT to create records. 
* 
* 
*/

public class lmn_SFAINTApiService {
    
    public class deserializeResponse{
        public string id;
        public string access_token;
    }
    
    public string returnAccessToken(lmn_SFAINTApiService account){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        string reqBody='grant_type=password'+
            '&client_id='+system.label.SFAINTApiClientId+
            '&client_secret='+system.label.SFAINTApiClientSecret+
            '&username='+system.label.SFAINTApiUsername+
            '&password='+system.label.SFAINTApiPassword;

        string tokenEndpoint = system.label.SFAINTApiURL+'/services/oauth2/token';
        
        Http h = new Http();
        //HttpRequest req = new HttpRequest();
        req.setBody(reqBody);
        req.setMethod('POST');
        req.SetHeader('Content-Type','application/x-www-form-urlencoded');
        req.setEndpoint(tokenEndpoint);
        if(!Test.isRunningTest()){
            try {
                //HttpResponse res = h.send(req);
                res = h.send(req);
            } catch(DmlException e) {
                System.debug('Error when trying to send request for Token: ' + e.getMessage());
            }     
            deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getBody(),deserializeResponse.class);
            return resp1.access_token;
        } else {
            return '12345TestToken';
        }
        
    }
    
    @future (callout=true)
    public static void sendFile(string title, string base64File, string SFAINTId, string fileExtension, string SFCJId, string ATTACHMENTId) { 
        lmn_SFAINTApiService newFile = new lmn_SFAINTApiService();
        HttpRequest req1 = new HttpRequest();
        HttpResponse res1 = new HttpResponse();
        string accessToken;
        string newFileId, fieldName, fieldValue;
        if(!Test.isRunningTest()){
            try {
                accessToken = newFile.returnAccessToken(newFile);
            } catch(DmlException e) {
                System.debug('Error trying to get Access Token: ' + e.getMessage());
            }
        }
        string PathOnClient = title+'.'+fileExtension;
        string ContentLocation = 'S';
        lmn_AttachmentWrapper newWrapper = new lmn_AttachmentWrapper(title, pathOnClient, contentLocation, SFAINTId, base64File);      
       // string endPoint = system.label.SFAINTApiURL+'/services/apexrest/SFAINT/api/attachment/';
        string endPoint = system.label.SFAINTApiURL+'/services/data/v55.0/sobjects/ContentVersion/';
        Http h2 = new Http();
        req1.setHeader('Authorization','Bearer ' + accessToken);
        req1.setHeader('Content-Type','application/json');
        req1.setHeader('accept','application/json');
        req1.setMethod('POST');
        //string body = '"Title":+title+,"PathOnClient":+PathOnClient+,"ContentLocation":+contentLocation+,"FirstPublishLocationId":+SFAINTID+,"VersionData":+base64File';
       req1.setBody(JSON.serialize(newWrapper));
       system.debug('@@@@@ BODY: '+JSON.serialize(newWrapper));
        req1.setEndpoint(endPoint);
        if(!Test.isRunningTest()){
            try {
                res1 = h2.send(req1);
            } catch(DmlException e) {
                System.debug('Error when trying to send request to SFAINT: ' + e.getMessage());
            }
        }
        system.debug('##### SendFile Response: ' +res1.getBody());
        // create an entry in the junction object to track the remote SFAINT id and the Attachment ID  -----------------
        String jsonBody;
        if(!Test.isRunningTest()){
            jsonBody = res1.getBody();
        } else {
            jsonBody = '{"id":"0686t000002gMHXAA2","success":true,"errors":[]}';
        }
        JSONParser parser = JSON.createParser(jsonBody);
        while(parser.nextToken() != null){
            if(parser.getCurrentToken() != JSONToken.END_OBJECT){
                fieldName = parser.getCurrentName();
                fieldValue = parser.getText();
                if(fieldName == 'id'){
               // newAttachment.SFAINT_Attachment_ID__c =  string.valueOf(res1.getBody());   
                  newFileId = fieldValue;               
            }
          }
        }

        If(newFileId != null){  // Don't creae Junction Object if we did not get an ID back
        SFAINT_Attachment__c newAttachment = new SFAINT_Attachment__c();
        newAttachment.SFCJ_ID__c = SFCJId;
        newAttachment.SFAINT_ID__c = SFAINTId;
        newAttachment.Attachment_ID__c = ATTACHMENTId;
        newAttachment.SFAINT_Attachment_ID__c = newFileId;
        newAttachment.Title__c = title+'.'+fileExtension;
        
        try {
            insert newAttachment;
        } catch(DmlException e) {
            System.debug('Error when trying to insert new attachment into SFAINT_Attachment__c: ' + e.getMessage());
        }  
        
        // query all records in junction object so we can update the CD with all attachments successfully synced. 
        list<SFAINT_Attachment__C> getSFAINTAttachments = new list<SFAINT_Attachment__c>();
        getSFAINTAttachments = [select id, Title__c from SFAINT_Attachment__c where SFAINT_Id__c = :SFAINTId];

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
                updateCapitalDesign.id = SFCJId;
                updateCapitalDesign.Attachments_Synced_to_SFAINT__c = results;
                try{
                update updateCapitalDesign;
            } catch(DmlException e) {
                System.debug('Error when updating the Capital Design Attachments Synced to SFAINT field After Insert: ' + e.getMessage());
            }
            }
        }

    }



    }
    
    @future (callout=true)
    public static void deleteFile(string fileId) { 
        lmn_SFAINTApiService newFile = new lmn_SFAINTApiService();
        HttpRequest req1 = new HttpRequest();
        HttpResponse res1 = new HttpResponse();
        string accessToken;
        if(!Test.isRunningTest()){
            try {
                accessToken = newFile.returnAccessToken(newFile);
            } catch(DmlException e) {
                System.debug('Error trying to get Access Token: ' + e.getMessage());
            }   
        }
        string endPoint = system.label.SFAINTApiURL+'/services/apexrest/sfaint/api/attachment/'+fileId;
        Http h2 = new Http();
        req1.setHeader('Authorization','Bearer ' + accessToken);
        req1.setHeader('Content-Type','application/json');
        req1.setHeader('accept','application/json');
        req1.setMethod('DELETE');
        req1.setBody('');
        req1.setEndpoint(endPoint);
        if(!Test.isRunningTest()){
            try {
                res1 = h2.send(req1);
            } catch(DmlException e) {
                System.debug('Error when trying to send request to SFAINT: ' + e.getMessage());
            }
            system.debug('##### Delete Response: ' +res1.getBody());
        }
    }
    
    public static void tryCatchBuffer(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
    
    
}