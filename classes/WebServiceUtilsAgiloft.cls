/*******************************************************************************************************
 * Change History:
 * Date         Person Responsible          Traceability            Details 
 * 02/19/2016   Curtis A                    US185460                Revision of old RESTUtils class to make all WS calls uniform
 * 02/09/2017	Sreeram V					US236240				Updated to set CallbackURLs in the EMP Publish message, from Request Header metadata
 * 06/08/2017	Feike						US163499				Integrating Level 3 code in CenturyLink Org
 * 09/11/2019	Jeyavel												update to Service_Callout__mdt and away from xml
 * 10/19/2021   Feike                       LBOCM-26923             Check if Header info is blank before building mapHeaders
 * 02/09/2022	Copied from WebServiceUtils class in SFDC Enterprise PROD Environment
 * 11/30/2022	Kuehl						Code Coverage:  84%  using WebServiceUtilsAgiloftTest 
 * 01-17-2023   Kuehl                       ESCJ-2345               Cleaned up code for SonarQube edits.
 ********************************************************************************************************/
 
 public with sharing virtual class WebServiceUtilsAgiloft
 { 	
     public string           name				{get; private set;}
     public string           method				{get; private set;}
     public string           endPoint			{get; private set;}
     public integer          timeOut			{get; private set;}
     public boolean          cacheResponse		{get; private set;}
     public string           authentication		{get; private set;}  
     
     public integer          statusCode			{get; set;}
     public string           errorMsg			{get; set;}
     private map<string,RequestHeader> mapHeaders{get; set;}
     private HttpRequest     httpRequest		{get; set;}
     private HttpResponse    httpResponse		{get; set;}     
     
     private string          body;
     private string          qryParam;
     private string          accept;
     private string          contentType;
     private string          host;
     private boolean         callOut = true;
         
         
     public WebServiceUtilsAgiloft(string name)
     {        
         API_Util__mdt request = [select MasterLabel, HttpMethod__c, EndPoint__c, TimeOut__c, Accept__c, Content_Type__c, Headers__c from API_Util__mdt where MasterLabel = :name WITH SECURITY_ENFORCED];
         
         System.debug('request data:  ' + request);
         
         try
         {             
             this.mapHeaders     = new map<string, RequestHeader>();
             this.name           = request.MasterLabel;
             this.method         = request.HttpMethod__c;
             this.endPoint       = Level3Utils.getUrl(request.EndPoint__c);
             
             System.debug('request.EndPoint__c:  ' 	+ request.EndPoint__c);			
             System.debug('endPoint:  ' 			+ this.endPoint);
             
             this.timeOut        = integer.valueOf(request.TimeOut__c);            
             this.accept         = request.Accept__c;
             this.contentType    = request.Content_Type__c;
             
             
             if( !('SOAP'.equalsIgnoreCase(this.method)) )
             {
                 generateRequest();
             }
         }
         catch(Exception ex)
         {
             this.errorMsg = ex.getStackTraceString();
             this.statusCode=400;
         }
     }
 
      
     private void generateRequest()
     {        
		this.httpRequest = new HttpRequest();
         
        try
        {
        	httpRequest.setMethod(this.method);
            httpRequest.setTimeout(this.timeOut);
 
            if (!String.isBlank(this.accept)) 
            {
            	httpRequest.setHeader('Accept', this.accept);
            }
             
            if (!String.isBlank(this.contentType)) 
            {
               httpRequest.setHeader('Content-Type', this.contentType);
            }             
             
            if(string.isBlank(this.endPoint))
            {                
                CalloutException e = new CalloutException();
                e.setMessage('End Point URL not defined!');
                throw e;
            }
            else
            {
                httpRequest.setEndpoint(string.isBlank(this.qryParam)?this.endPoint:this.endPoint+this.qryParam);
            }
                         
            setBody(this.body);			                        
		}
         
        catch(exception ex)
        {
            system.debug('Issue generating Request-->'+ex.getStackTraceString());
            statusCode = 400;
            errorMsg = ex.getMessage();
            httpRequest = null;
        }
     }
         
      
     public void addHeader(string name, string value)
     {
         if(mapHeaders.containsKey(name))
         {
             mapHeaders.get(name).value = value;
         }
         else
         {
             mapHeaders.put(name,new RequestHeader(name,value,null,null,null));
         }
             
         if(this.httpRequest != null)
         {
             this.httpRequest.setHeader(name,value);    
         }
     }
         
 
     public string getHeader(string name)
     {
         return mapHeaders.get(name).value;
     }
         
 
     public map<string,string> getHeaders()
     {
         map<string,string> headers = new map<string,string>();
 
         for(RequestHeader header : this.mapHeaders.values())
         {
              headers.put(header.name,header.value);
         }
         return headers;
     }
         
 
     public HttpRequest getRequest()
     {
         return httpRequest;
     }
              
     
     public HttpResponse getResponse()
     {
         return httpResponse;
     }
         
 
     public void appendQueryParam(string qryParam)
     {
         this.qryParam = qryParam;
 
         if (this.httpRequest != null) 
         {
             this.httpRequest.setEndPoint(this.endPoint + this.qryParam);            
         }
     }
       
     
     public void setBody(string  body)
     {
         if(string.isNotBlank(body) && this.httpRequest != null)
         {
             this.body = body;
             this.httpRequest.setBody(this.body);
         }
     }
     
     
     public void setEndpoint(string endpoint)
     {
         if(string.isNotBlank(endpoint) && this.httpRequest != null)
         {
             this.endPoint = endpoint;
             this.httpRequest.setEndPoint(this.endPoint);
         }
     }
     
          
     public boolean send(boolean retry)
     {
         if(!callOut)
         {
             statusCode = -1;
             return false;
         }
 
         if(retry)
         {            
             callOut = false;
             generateRequest();
         }
         
         boolean isGood = (statusCode==null||statusCode==0||statusCode == 200 || statusCode == 201);
         
         if(isGood)
         {
             httpResponse = new Http().send(httpRequest);
             
             statusCode = httpResponse.getStatusCode();
             
             boolean isGood2 = (statusCode == 200 || statusCode == 201);
                                     
             if(!isGood2)
             {
                 errorMsg = '[Status '+statusCode.format()+': '+httpResponse.getStatus()+']:\n\n'+httpResponse.getBody();                
             }
         }
         
         System.debug('WebServiceUtilsAgiloft statuscode and response: ' + '[Status '+statusCode.format()+': '+httpResponse.getStatus()+']:\n\n'+httpResponse.getBody());
         
         return isGood;
     }
     

     public class RequestHeader
     {
         public string name  {get; set;}
         public string encode{get; set;}
         public string mac   {get; set;}
         public string macIn {get; set;}       	
         public string value {get; set;}
         
         public RequestHeader(string name, string value, string encode, string mac, string macIn)
         {
             this.name = name;
             this.encode = encode;
             this.mac= mac;
             this.macIn=macIn;
             this.value = value;
         }
 
     } 
  
 }