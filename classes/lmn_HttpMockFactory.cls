/*
 * 
 * Hank		10/31/2023		Created to test lmn_SFCJApiService callouts
 * 
 * 
 * 
 */

 @isTest
 public class lmn_HttpMockFactory implements HttpCalloutMock{
     protected Integer code;
     protected String status;
     protected String body;
     protected Map<String,String> responseHeaders;
     
     public lmn_HttpMockFactory(Integer code, String status, String body, Map<String,String> responseHeaders){
         this.code = code;
         this.status = status;
         this.body = body;
         this.responseHeaders = responseHeaders;
     }
     
     public HttpResponse respond(HttpRequest req){
         HttpResponse res = new HttpResponse();
         for(String key : this.responseHeaders.keySet()){
             res.setheader(key, this.responseHeaders.get(key));
         }
         res.setBody(this.body);
         res.setStatusCode(this.code);
         res.setStatus(this.status);
         return res;
     }
 
 }