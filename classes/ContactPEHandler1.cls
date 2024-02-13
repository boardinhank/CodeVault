public class ContactPEHandler1 implements Queueable, Database.AllowsCallouts {

    private Contact inscntlist;
    private List<Contact> cntlist;
    private String endpoint;
    private String checkconst;
    private ContactPEHandlerWrapper results=null;
    private ContactReqWrapper reqwrapper=null;

    public ContactPEHandler1 (String constcheck,contact cntlist){
        this.inscntlist=cntlist;
        this.checkconst=constcheck;
        }

   public ContactPEHandler1 (String constcheck, List<Contact> cnttlist){
        this.cntlist=cnttlist;
        this.checkconst=constcheck;
        }


    public void  execute(QueueableContext qc) {  
       	system.debug('am in IntegrationConPhoneUpdate ');
     	API_Util__mdt MDT_BRAND = API_Util__mdt.getInstance('SolicitVerification');
            Contact cntinsert  = new Contact(id=this.inscntlist.id);
            if(this.checkconst.equalsIgnoreCase('insertion')){
                if(this.inscntlist.Email != null){
                    endpoint = MDT_BRAND.Email_Endpont__c;
                    results = getHttpResponse(endpoint,this.inscntlist.Email,'Email');
                    if(results.emailDivestetureOptOut.equalsIgnoreCase('Y')){
                        cntinsert.HasOptedOutOfEmail = true;
                        cntinsert.DoNotCall = true;
                    }else{
                        if(results.emailOptOut.equalsIgnoreCase('Y')){
                            cntinsert.HasOptedOutOfEmail = true;
                        }
                        if(this.inscntlist.phone != null){
                            endpoint = MDT_BRAND.Endpoint__c;
                            results = getHttpResponse(endpoint,this.inscntlist.phone,'phone');
                            if(results.tnOptOut.equalsIgnoreCase('Y')){
                                cntinsert.DoNotCall = true;
                            }
                        }
                    } 
                }else{

                    if(this.inscntlist.phone != null){
                        endpoint = MDT_BRAND.Endpoint__c;
                        results = getHttpResponse(endpoint,this.inscntlist.phone,'phone');
                        if(results.tnOptOut.equalsIgnoreCase('Y')){
                            cntinsert.DoNotCall = true;
                        }
                    }

                }
            }else{
                if(this.inscntlist.Email == null){
                    cntinsert.HasOptedOutOfEmail = false;
                    if(this.inscntlist.phone != null){
                        endpoint = MDT_BRAND.Endpoint__c;
                        results = getHttpResponse(endpoint,this.inscntlist.phone,'phone');
                        if(results.tnOptOut.equalsIgnoreCase('Y')){
                            cntinsert.DoNotCall = true;
                        }else{
                            cntinsert.DoNotCall = false;
                        }
                    }else{
                        cntinsert.DoNotCall = false;
                    }
                }else{
                    endpoint = MDT_BRAND.Email_Endpont__c;
                    results = getHttpResponse(endpoint,this.inscntlist.Email,'Email');
                    if(results.emailDivestetureOptOut.equalsIgnoreCase('Y')){
                        cntinsert.HasOptedOutOfEmail = true;
                        cntinsert.DoNotCall = true;
                    }else{
                        if(results.emailOptOut.equalsIgnoreCase('Y')){
                            cntinsert.HasOptedOutOfEmail = true;
                        }else{
                            cntinsert.HasOptedOutOfEmail = false;
                        }
                        if(this.inscntlist.phone != null){
                            endpoint = MDT_BRAND.Endpoint__c;
                            results = getHttpResponse(endpoint,this.inscntlist.phone,'phone');
                            if(results.tnOptOut.equalsIgnoreCase('Y')){  
                                cntinsert.DoNotCall = true;
                            }else{  
                                cntinsert.DoNotCall = false;
                            }
                        }else{
                            cntinsert.DoNotCall = false;
                        }
                    }

                }

            }
        
            update cntinsert;
    }

    public ContactPEHandlerWrapper getHttpResponse(String endpoint, String eventparamval, String eventparam ){
     //Construct HTTP request and response
    //Http request method,Endpoint and setBody
    reqwrapper=new ContactReqWrapper();
    HttpRequest req = new HttpRequest();
    req.setHeader('Content-Type','application/json;charset=UTF-8');       
    req.setMethod('POST');
    reqwrapper.phone=eventparamval; 
	reqwrapper.email=eventparamval;         
    req.setBody(JSON.serialize(reqwrapper) );
        system.debug('JSON.serialize(reqwrapper)'+JSON.serialize(reqwrapper));
    req.setEndpoint(endpoint);
    Http http = new Http();
     //Http response method
    HTTPResponse res = http.send(req);
    // If the request is successful, parse the JSON response.
  	 if (res.getStatusCode() == 200) {
    // Deserialize the JSON string into collections of primitive data types.
        results = ContactPEHandlerWrapper.parse(res.getBody());

        }else {
      system.debug('response'+res.getStatusCode());     
    }
        return results;
   }
}