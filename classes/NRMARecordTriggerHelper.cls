public with sharing class NRMARecordTriggerHelper {

    //ESCJ - 2443 -- Update Name and URL as JSON format in Supporting Document URL 
    public static void updateSupportingDocumentinJSON(List<NRMA__c> nrmaRecs,Boolean isInsert){
        List<NRMA__c> listofNRMArecords = new List<NRMA__c>();
        Set<Id> nrmaIds = new Set<Id>();
        String supplieddocumentjsonstr;
        NRMARecordTriggerHandler.triggerDisabled=true;
        for(NRMA__c newnrmarec:nrmaRecs){
            nrmaIds.add(newnrmarec.Id);
        }
        List<NRMA__c> listofnrma = [Select Id,URL__c,name__c,Supporting_Document_URLs__c from NRMA__C where Id=:nrmaIds];
        List<NRMARequestsResponseWrap.SupportingDocumentURL> nrmareqlist = new List<NRMARequestsResponseWrap.SupportingDocumentURL>();
       
        for(NRMA__c nrmaRecord:listofnrma){
          
            if(isInsert == true && nrmaRecord.URL__c!=null && nrmaRecord.Name__c!=null && nrmaRecord.Supporting_Document_URLs__c==''){
                NRMARequestsResponseWrap.SupportingDocumentURL newnrmareq = new NRMARequestsResponseWrap.SupportingDocumentURL();
                newnrmareq.name = nrmaRecord.Name__c;
                newnrmareq.url = nrmaRecord.URL__c;
                nrmareqlist.add(newnrmareq);
                nrmaRecord.Supporting_Document_URLs__c = JSON.serialize(nrmareqlist,true);
            }else if(isInsert == false && nrmaRecord.URL__c!=null && nrmaRecord.Name__c!=null){
                    if(nrmaRecord.Supporting_Document_URLs__c!='' && nrmaRecord.Supporting_Document_URLs__c!=null) supplieddocumentjsonstr = nrmaRecord.Supporting_Document_URLs__c;
                    NRMARequestsResponseWrap.SupportingDocumentURL nrmareq = new NRMARequestsResponseWrap.SupportingDocumentURL();
                    nrmareq.name = nrmaRecord.Name__c;
                    nrmareq.url = nrmaRecord.URL__c;
                    nrmareqlist.add(nrmareq);
                    system.debug('LIST###1'+nrmareqlist);
                    System.debug('SDVAL###'+supplieddocumentjsonstr);
                    
                if(nrmaRecord.Supporting_Document_URLs__c!='' && nrmaRecord.Supporting_Document_URLs__c!=null){
                    
                    List<NRMARequestsResponseWrap.SupportingDocumentURL>  nrmaresp = (List<NRMARequestsResponseWrap.SupportingDocumentURL>)JSON.deserialize(nrmaRecord.Supporting_Document_URLs__c, List<NRMARequestsResponseWrap.SupportingDocumentURL>.class);
                    system.debug('RESp###'+nrmaresp);
                    system.debug('LIST###2'+nrmareqlist);
                    for(NRMARequestsResponseWrap.SupportingDocumentURL nrmadocURL:nrmaresp){
                        NRMARequestsResponseWrap.SupportingDocumentURL nrmareq1 = new NRMARequestsResponseWrap.SupportingDocumentURL();
                        nrmareq1.name = nrmadocURL.name;
                        nrmareq1.url = nrmadocURL.url;
                        nrmareqlist.add(nrmareq1);
                    }
                   
                    System.debug('NRMALIST##'+nrmareqlist);
                    supplieddocumentjsonstr = JSON.serialize(nrmareqlist,true);
                }else{
                    supplieddocumentjsonstr = JSON.serialize(nrmareqlist,true);
                } 
                 nrmaRecord.Supporting_Document_URLs__c = supplieddocumentjsonstr;
             }
                System.debug('JSON##'+nrmaRecord.Supporting_Document_URLs__c);
                nrmaRecord.Name__c='';
                nrmaRecord.URL__c='';
                listofNRMArecords.add(nrmaRecord);
           }
       if(!listofNRMArecords.isEmpty()){
           update listofNRMArecords;
        }
    }
}