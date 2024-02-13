public class SyncLeadPEHandler {
    
  	public static String endpoint;
    public static LeadPEHandlerWrapper results=null;
    public static LeadReqWrapper reqwrapper=null;    	
    
    @Auraenabled
    public static void dontEersCheck(String checkconst,String leadId) {
        system.debug('lead id '+leadid);
        API_Util__mdt MDT_BRAND = API_Util__mdt.getInstance('SolicitVerification');
        Lead insldlist = [Select id,email,phone,company from Lead where ID =: leadId ];
        Lead ldinsert  = new Lead(id=insldlist.id);
        if(checkconst.equalsIgnoreCase('insertion')){
            endpoint = MDT_BRAND.Name_Endpoint__c;
            results = getHttpResponse(endpoint,insldlist.Company,'Company');
            if(results.NameDivestetureOptOut.equalsIgnoreCase('Y')){
                ldinsert.HasOptedOutOfEmail = true;
                ldinsert.DoNotCall = true;
            }else{
                if(insldlist.Email != null){
                    endpoint = MDT_BRAND.Email_Endpont__c;
                    results = getHttpResponse(endpoint,insldlist.Email,'Email');
                    if(results.emailDivestetureOptOut.equalsIgnoreCase('Y')){
                        ldinsert.HasOptedOutOfEmail = true;
                        ldinsert.DoNotCall = true;
                    }else{
                        if(results.emailOptOut.equalsIgnoreCase('Y')){
                            ldinsert.HasOptedOutOfEmail = true;
                        }
                        if(insldlist.phone != null){
                            endpoint = MDT_BRAND.Endpoint__c;

                            results = getHttpResponse(endpoint,insldlist.phone.replaceAll('[^a-zA-Z0-9\\s+]', '').deleteWhitespace(),'phone');

                            if(results.tnOptOut.equalsIgnoreCase('Y')){
                                ldinsert.DoNotCall = true;
                            }
                        }
                    } 
                }else{
                    endpoint = MDT_BRAND.Endpoint__c;

                    results = getHttpResponse(endpoint,insldlist.phone.replaceAll('[^a-zA-Z0-9\\s+]', '').deleteWhitespace(),'phone');

                    if(results.tnOptOut.equalsIgnoreCase('Y')){
                        ldinsert.DoNotCall = true;
                    }                      
                }
            }       
        }
        else{
            endpoint = MDT_BRAND.Name_Endpoint__c;
            results = getHttpResponse(endpoint,insldlist.Company,'Company');
            if(results !=null && results.nameDivestetureOptOut.equalsIgnoreCase('Y')){
                ldinsert.HasOptedOutOfEmail = true;
                ldinsert.DoNotCall = true;
            }else{
                if(insldlist.Email == null){
                    ldinsert.HasOptedOutOfEmail = false;
                    if(insldlist.phone != null){
                        endpoint = MDT_BRAND.Endpoint__c;

                        results = getHttpResponse(endpoint,insldlist.phone.replaceAll('[^a-zA-Z0-9\\s+]', '').deleteWhitespace(),'phone');

                        if(results !=null && results.tnOptOut.equalsIgnoreCase('Y')){
                            ldinsert.DoNotCall = true;
                        }else{
                            ldinsert.DoNotCall = false;
                        }
                    }else{
                        ldinsert.DoNotCall = false;
                    }
                }else{
                    endpoint = MDT_BRAND.Email_Endpont__c;
                    results = getHttpResponse(endpoint,insldlist.Email,'Email');
                    if(results !=null && results.emailDivestetureOptOut.equalsIgnoreCase('Y')){
                        ldinsert.HasOptedOutOfEmail = true;
                        ldinsert.DoNotCall = true;
                    }else{
                        if(results !=null && results.emailOptOut.equalsIgnoreCase('Y')){
                            ldinsert.HasOptedOutOfEmail = true;
                        }else{
                            ldinsert.HasOptedOutOfEmail = false;
                        }
                        if(insldlist.phone != null){
                            endpoint = MDT_BRAND.Endpoint__c;

                            results = getHttpResponse(endpoint,insldlist.phone.replaceAll('[^a-zA-Z0-9\\s+]', '').deleteWhitespace(),'phone');

                            if(results !=null && results.tnOptOut.equalsIgnoreCase('Y')){  
                                ldinsert.DoNotCall = true;
                            }else{  
                                ldinsert.DoNotCall = false;
                            }
                        }else{
                            ldinsert.DoNotCall = false;
                        }
                    }
                    
                }
                
            }               
            
        }    
        update ldinsert;
    }
    
    
    public static LeadPEHandlerWrapper getHttpResponse(String endpoint, String eventparamval, String eventparam ){
        //Construct HTTP request and response
        //Http request method,Endpoint and setBody
        reqwrapper=new LeadReqWrapper();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','application/json;charset=UTF-8');       
        req.setMethod('POST');
        reqwrapper.phone=eventparamval;
        reqwrapper.email=eventparamval;
        reqwrapper.name=eventparamval;         
        req.setBody(JSON.serialize(reqwrapper) );
        system.debug('JSON.serialize(reqwrapper)'+JSON.serialize(reqwrapper));
        req.setEndpoint(endpoint);
        Http http = new Http();
        //Http response method
        HTTPResponse res = http.send(req);
        // If the request is successful, parse the JSON response.
        if (res.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            results = LeadPEHandlerWrapper.parse(res.getBody());
        }else {
            system.debug('response'+res.getStatusCode());     
        }
        return results;
    }

    @Auraenabled
    public static void disableDuplicateRules(){
        Database.DMLOptions dml = new Database.DMLOptions(); 
        dml.DuplicateRuleHeader.allowSave = true;
    }
}