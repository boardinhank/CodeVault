/***************************************************************
AUTHOR     DATE         Reference     Description
Sravya S   27/09/2022   ESCJ-1926    Call DONT/EERS realtime when a new account is created or an existing account is updated.
***************************************************************/

public class AccountPEHandler implements Queueable, Database.AllowsCallouts {	
    private Account insacclist;
    private List<Account> accclist;
    private String endpoint;
    private String checkconst;
    private AccountPEHandlerWrapper results=null;
    private AccountReqWrapper reqwrapper=null;

    public AccountPEHandler (String constcheck,Account accclist){
        this.insacclist=accclist;
        this.checkconst=constcheck;
        }

   public AccountPEHandler (String constcheck, List<Account> acccclist){
        this.accclist=acccclist;
        this.checkconst=constcheck;
        }

   public void  execute(QueueableContext qc) {  
       API_Util__mdt MDT_BRAND = API_Util__mdt.getInstance('SolicitVerification');
       Account accinsert  = new Account(id=this.insacclist.id);
       if(this.checkconst.equalsIgnoreCase('insertion')){
               endpoint = MDT_BRAND.Name_Endpoint__c;
               results = getHttpResponse(endpoint,this.insacclist.Name,'Name');
               if(results.NameDivestetureOptOut.equalsIgnoreCase('Y')){
                   accinsert.Divestiture_Non_Solicit_Customer__c = true;
                   accinsert.Do_Not_Call_Account__c = true;
               }else{
                   if(this.insacclist.phone != null){
                       endpoint = MDT_BRAND.Endpoint__c;
                       results = getHttpResponse(endpoint,this.insacclist.phone,'phone');
                       if(results.tnOptOut.equalsIgnoreCase('Y')){
                           accinsert.Do_Not_Call_Account__c = true;
                       }
                   }
               } 
           }else{
               endpoint = MDT_BRAND.Name_Endpoint__c;
               results = getHttpResponse(endpoint,this.insacclist.Name,'Name');
               if(results.nameDivestetureOptOut.equalsIgnoreCase('Y')){
                   accinsert.Divestiture_Non_Solicit_Customer__c = true;
                   accinsert.Do_Not_Call_Account__c = true;
               }else{
                   accinsert.Divestiture_Non_Solicit_Customer__c = false;
                   if(this.insacclist.phone != null){
                       endpoint = MDT_BRAND.Endpoint__c;
                       results = getHttpResponse(endpoint,this.insacclist.phone,'phone');
                       if(results.tnOptOut.equalsIgnoreCase('Y')){  
                           accinsert.Do_Not_Call_Account__c = true;
                       }else{  
                           accinsert.Do_Not_Call_Account__c = false;
                       }
                   }else{
                       accinsert.Do_Not_Call_Account__c = false;
                   }
               }               
           }             
       update accinsert;
   }

    public AccountPEHandlerWrapper getHttpResponse(String endpoint, String eventparamval, String eventparam ){
     //Construct HTTP request and response
    //Http request method,Endpoint and setBody
    reqwrapper=new AccountReqWrapper();
    HttpRequest req = new HttpRequest();
    req.setHeader('Content-Type','application/json;charset=UTF-8');       
    req.setMethod('POST');
    reqwrapper.phone=eventparamval; 
	reqwrapper.Name=eventparamval;         
    req.setBody(JSON.serialize(reqwrapper) );
    system.debug('JSON.serialize(reqwrapper)'+JSON.serialize(reqwrapper));
    req.setEndpoint(endpoint);
    Http http = new Http();
     //Http response method
    HTTPResponse res = http.send(req);
    // If the request is successful, parse the JSON response.
  	 if (res.getStatusCode() == 200) {
    // Deserialize the JSON string into collections of primitive data types.
        results = AccountPEHandlerWrapper.parse(res.getBody());
        }else {
      system.debug('response'+res.getStatusCode());     
    }
        return results;
   }
}