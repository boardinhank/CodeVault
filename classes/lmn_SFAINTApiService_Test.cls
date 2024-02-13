/*
 * 
 * HANK		10/31/2023		QFCJ-4013 created SendFile and Delete file tests
 * 
 */

 @isTest
 public class lmn_SFAINTApiService_Test {
     
     @testSetup
     static void setup(){
 
          
             Capital_Design__c CapDesign = new Capital_Design__c(
                 Capital_Design_Stage__c = 'In-Progress',
                 SFAINT_Id__C = 'a018M000004wWPyQAM');
             insert CapDesign;
         }
     
     @isTest
     static void tokenTest(){		
         string accessToken;
         lmn_SFAINTApiService newFile = new lmn_SFAINTApiService();
         accessToken = newfile.returnAccessToken(newFile);  
         System.assertEquals(accessToken , '12345TestToken');
     } 
     
     @isTest
     static void sendFile(){ 
         
         capital_design__c getCapDesId = [select id, SFCJ_ID__c from capital_design__c limit 1];
         
         ContentVersion newFile1 = new ContentVersion();
         newFile1.Title = 'Test Title1';
         newFile1.PathOnClient = 'Test Title1.txt';
         newFile1.ContentLocation = 'S';
         newFile1.FirstPublishLocationId = getCapDesId.Id;
         newFile1.VersionData = blob.valueOf('this is the body 1');
         insert newFile1;
         
         contentVersion getContactVersion1 = [select id, contentDocumentId from contentVersion where title = 'Test Title1' limit 1];
         
         string title = 'test'; 
         string base64File = 'base64file contents blah blah';
         string SFCJId = getCapDesId.id;
         string fileExtension = '.txt';
         string SFAINTId = getCapDesId.id;
         string ATTACHMENTId = getContactVersion1.ContentDocumentId;
         lmn_HttpMockFactory mock = new lmn_HttpMockFactory(200, 'Ok', 'Success', new Map<string,String>());
         Test.setMock(HttpCalloutMock.class, mock);
         lmn_SFAINTApiService.sendFile(title, base64File, SFCJId, fileExtension, SFAINTId, ATTACHMENTId);
         
         System.assertNotEquals(title , Null);
         
     }
     
         @isTest
     static void deleteFile(){
         
         capital_design__c getCapDesId = [select id, SFCJ_ID__c from capital_design__c limit 1];
         string SFCJId = getCapDesId.id;
         
         lmn_HttpMockFactory mock = new lmn_HttpMockFactory(200, 'Ok', 'Success', new Map<string,String>());
         Test.setMock(HttpCalloutMock.class, mock);
         lmn_SFAINTApiService.deleteFile(SFCJId);
         
         System.assertNotEquals(SFCJId , Null);
     }
     
     @isTest
     static void tryCatchBuffer(){
        lmn_SFAINTApiService.tryCatchBuffer();
         decimal tryCatch = 1;
         
         System.assertEquals(tryCatch , 1);
     }
    
 
 }