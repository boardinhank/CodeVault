public class contentVersionHandler {
    
    public static void insertContentVersion() {
        set<id> attachemtntIds = new set<id>();
        List<attachment> attlist= new  List<attachment>();
        List<ContentDocument> cdList=new List<ContentDocument>();
        set<id> contentdocids=new set<id>();
        for(ContentVersion cvRec:[Select id,Title,PathOnClient,ContentLocation,ContentDocumentId,ContentModifiedById,FileExtension,FileType,FirstPublishLocationId,VersionData from ContentVersion where id IN:Trigger.new]){
            //System.debug('object id from class--'+cvRec.FirstPublishLocationId.getSObjectType().getDescribe().getName());
            if(cvRec.FirstPublishLocationId != null && cvRec.FirstPublishLocationId.getSObjectType().getDescribe().getName() == 'Capital_Design__c'){
                contentdocids.add(cvRec.ContentDocumentId);
                Attachment att = new Attachment();
                Blob bval=cvRec.versiondata;           
                att.Body = bval;
                if(cvRec.FileType != null){
                    //att.ContentType = (String)(cvRec.FileType=='PDF'?'application/pdf':cvRec.FileType=='txt'? 'text/plain':cvRec.FileType=='xlsx'?'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':cvRec.FileType=='pptx'?'application/vnd.ms-powerpoint':cvRec.FileType=='docx'?'application/msword':cvRec.FileType=='zip'?'application/zip':cvRec.FileType=='jpg'?'image/png':'text/csv');   
                    att.ContentType = (String)(cvRec.FileExtension=='PDF'?'application/pdf':cvRec.FileExtension=='txt'? 'text/plain':cvRec.FileExtension=='xlsx'?'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':cvRec.FileExtension=='pptx'?'application/vnd.ms-powerpoint':cvRec.FileExtension=='docx'?'application/msword':cvRec.FileExtension=='zip'?'application/zip':cvRec.FileExtension=='jpg'?'image/png':'text/csv');   
                }
                att.ParentId =cvRec.FirstPublishLocationId;
                att.Name =cvRec.PathOnClient;
                attlist.add(att);
            }
        }
        if(attlist.size()>0){
            try{
                Database.UpsertResult[] srList = Database.upsert(attlist, false);
                for (Database.UpsertResult sr : srList) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted Attachemnt ' + sr.getId());
                        attachemtntIds.add(sr.getId());
                    }
                    else {              
                        for(Database.Error err : sr.getErrors()) {                 
                            System.debug('Error: '+err.getStatusCode() + ' Message: ' + err.getMessage() +' Fields: '+err.getFields());
                        }
                    }
                }
            }Catch(Exception e){
                system.debug('Error:'+e.getMessage() + ' Stack: '+e.getStackTraceString());
            }
            if(attachemtntIds.size()>0){
                List<PartnerNetworkRecordConnection> listToAdd = new List<PartnerNetworkRecordConnection>();
                List<PartnerNetworkConnection> prtNetCon = [Select Id from PartnerNetworkConnection where ConnectionName = 'Lumen' AND ConnectionStatus = 'Accepted' LIMIT 1];
                System.debug('prtNetCon--'+prtNetCon);
                for(Attachment att : [select id,ParentId from Attachment WHERE id in :attachemtntIds]){  
                    if(att.ParentId.getSObjectType().getDescribe().getName() == 'Capital_Design__c' && prtNetCon.size() > 0){              
                        PartnerNetworkRecordConnection pConRec = new PartnerNetworkRecordConnection();
                        pConRec.LocalRecordId = att.id;
                        pConRec.ConnectionId = prtNetCon[0]?.Id;//'04P040000008OJ3EAM';
                        pConRec.ParentRecordId = att.ParentId;   
                        listToAdd.add(pConRec);                                                        
                    }// end of if
                }// end of for 
                if(listToAdd.size() > 0){
                    try{
                        upsert listToAdd; 
                    }catch(Exception e){
                        System.debug('Error:'+e.getStackTraceString()+e.getMessage());
                    }
                    
                }
            }
        }
    }
}