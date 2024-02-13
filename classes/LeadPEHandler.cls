/* 
****************************************************************** 
* @author  : Sambasiva Techm
 * @Description : Lead Insert and Update - DONT EERS
 * @Date : 10/04/2022
 *  
 * 
****************************************************************** 
Author    *      UserStory   *    Date         *       Description 
Sambasiva	 ESCj-1925        10/4/2022	       Lead Insert and Update - DONT EERS
**/
public class LeadPEHandler implements Queueable, Database.AllowsCallouts {	
    private Lead insldlist;
    private List<Lead> ldlist;
    private String endpoint;
    private String checkconst;
    private LeadPEHandlerWrapper results=null;
    private LeadReqWrapper reqwrapper=null;

    public LeadPEHandler (String constcheck,Lead ldlist){
        this.insldlist=ldlist;
        this.checkconst=constcheck;
        }

   public LeadPEHandler (String constcheck, List<Lead> cnttlist){
        this.ldlist=cnttlist;
        this.checkconst=constcheck;
        }

   public void  execute(QueueableContext qc) {  
       API_Util__mdt MDT_BRAND = API_Util__mdt.getInstance('SolicitVerification');
       Lead ldinsert  = new Lead(id=this.insldlist.id);
       if(this.checkconst.equalsIgnoreCase('insertion')){
               endpoint = MDT_BRAND.Name_Endpoint__c;
               results = getHttpResponse(endpoint,this.insldlist.Company,'Company');
               if(results.NameDivestetureOptOut.equalsIgnoreCase('Y')){
			       ldinsert.Name_Divesteture__c = true;
                   ldinsert.HasOptedOutOfEmail = true;
                   ldinsert.DoNotCall = true;
               }else{
                   if(this.insldlist.Email != null){
                    endpoint = MDT_BRAND.Email_Endpont__c;
                    results = getHttpResponse(endpoint,this.insldlist.Email,'Email');
                    if(results.emailDivestetureOptOut.equalsIgnoreCase('Y')){
					    ldinsert.Email_Divesteture__c = true;
                        ldinsert.HasOptedOutOfEmail = true;
                        ldinsert.DoNotCall = true;
                    }else{
                        if(results.emailOptOut.equalsIgnoreCase('Y')){
                            ldinsert.HasOptedOutOfEmail = true;
                        }
                        if(this.insldlist.phone != null){
                            endpoint = MDT_BRAND.Endpoint__c;
                            results = getHttpResponse(endpoint,this.insldlist.phone,'phone');
                            if(results.tnOptOut.equalsIgnoreCase('Y')){
                                ldinsert.DoNotCall = true;
                            }
                        }
                    } 
                   }else{
                        endpoint = MDT_BRAND.Endpoint__c;
                            results = getHttpResponse(endpoint,this.insldlist.phone,'phone');
                            if(results.tnOptOut.equalsIgnoreCase('Y')){
                                ldinsert.DoNotCall = true;
                            }                      
                   }
               }       
       }
       else{
               endpoint = MDT_BRAND.Name_Endpoint__c;
               results = getHttpResponse(endpoint,this.insldlist.Company,'Company');
               if(results.nameDivestetureOptOut.equalsIgnoreCase('Y')){
			       ldinsert.Name_Divesteture__c = true;
                   ldinsert.HasOptedOutOfEmail = true;
                   ldinsert.DoNotCall = true;
               }else{
                   if(this.insldlist.Email == null){
                    ldinsert.HasOptedOutOfEmail = false;
                    if(this.insldlist.phone != null){
                        endpoint = MDT_BRAND.Endpoint__c;
                        results = getHttpResponse(endpoint,this.insldlist.phone,'phone');
                        if(results.tnOptOut.equalsIgnoreCase('Y')){
                            ldinsert.DoNotCall = true;
                        }else{
                            ldinsert.DoNotCall = false;
                        }
                    }else{
                        ldinsert.DoNotCall = false;
                    }
                }else{
                    endpoint = MDT_BRAND.Email_Endpont__c;
                    results = getHttpResponse(endpoint,this.insldlist.Email,'Email');
                    if(results.emailDivestetureOptOut.equalsIgnoreCase('Y')){
					    ldinsert.Email_Divesteture__c = true;
                        ldinsert.HasOptedOutOfEmail = true;
                        ldinsert.DoNotCall = true;
                    }else{
                        if(results.emailOptOut.equalsIgnoreCase('Y')){
                            ldinsert.HasOptedOutOfEmail = true;
                        }else{
                            ldinsert.HasOptedOutOfEmail = false;
                        }
                        if(this.insldlist.phone != null){
                            endpoint = MDT_BRAND.Endpoint__c;
                            results = getHttpResponse(endpoint,this.insldlist.phone,'phone');
                            if(results.tnOptOut.equalsIgnoreCase('Y')){  
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

    public LeadPEHandlerWrapper getHttpResponse(String endpoint, String eventparamval, String eventparam ){
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
}