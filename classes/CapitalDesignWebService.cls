public with sharing class CapitalDesignWebService 
{  
	public class BadStatusCodeException 	 extends Exception {}
 	public class InvalidAuthTokenException 	 extends Exception {}
    public class InvalidHttpRequestException extends Exception {}
    
    //private static final String BRAIN_APIGEE_AUTHORIZATION = 'Basic T2lhc2xQU0ZIQno3dDFGcnVjMEZIZDVWakhLVXZyMkU6eERkZkw5aXJqZ3ppYnJ4OQ==';
    //private static final String endPointApigeeForTokenByNamedCredential = 'callout:BRAINApigeeTokenGenerator';
    
    //private static final String apigeeTestBaseURL = 'https://api-test.lumen.com';
    //private static final String apigeeProdBaseURL = 'https://api.lumen.com';
    //private static final String pathForOAuthToken = '/oauth/token';
        
    
    public static String getAccessTokenFromSFAINT() 
    {
        String accessToken = null;
        
        try 
        {            
            String reqBody='grand_type=password' + 
               	'@client_id=3MVG9ooRt4uZ_3TnjX4iecom.sIAoIPGU5PQBNWJVlpG_m3gJxM9A5yLK1QfuHL_cnJfn0EdWYfQa3ELpHV_I' +
                '@client_secret=C43D5732A3E006C105FFDD583036D750013B6D56D1A9BBEC915A96F9B524CA29' +
                '&username=sfcj.salesforce-api-user@team480653.testinator.com' + 
                '&password=u$!Ng$@[3$F0rC3@P!';
                
            
			System.debug('@@reqBody' + reqBody);
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setBody(reqBody);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            //req.setHeader('Accept', '*/*');
            //req.setHeader('Accept-Encoding', 'gzip, deflate, br');            
            //req.setEndpoint('https://lumn--int1.sandbox.my.salesforce.com/');
            req.setEndpoint('https://lumn--int1.sandbox.lightning.force.com/services/oauth2/token');
            
            HttpResponse res = h.send(req);
                        
            if(res.getStatusCode() == 200) 
            {
                String responseBody = res.getBody();
                System.debug('(CapitalDesignWebService.getAccessTokenFromSFAINT) responseBody = ' + responseBody);
                
                accessToken = parseForAccessToken(responseBody);
            } 
            else 
            {
                accessToken = res.toString();
            }//end else statusCode NOT 200
            
            System.debug('(CapitalDesignWebService.getAccessTokenFromSFAINT) accessToken = ' + accessToken);
        } 
        catch(Exception callAuthX) 
        {
            System.debug('(CapitalDesignWebService.getAccessTokenFromSFAINT) EXCEPTION! \n Type: ' + callAuthX.getTypeName() + '\n Message:  ' + callAuthX.getMessage() + '\n Line#: ' + callAuthX.getLineNumber() + '\n StackTrace:  ' + callAuthX.getStackTraceString());
        }
        
        
        
            //deserializeResponse resp1 = (deserializeResponse)JSON.deserialize(res.getBody(), deserializeResponse.class);
            
                       
            
            //String endPointToUse = apigeeURL2Use + pathForOAuthToken;
            //System.debug('(BRAINFACalloutHelper.getAccessTokenFromApigee) endPointToUse = ' + endPointToUse);
            
            //httpRequestApigee.setEndPoint(endPointToUse);
            //httpRequestApigee.setMethod('POST');
            //httpRequestApigee.setHeader('Authorization', BRAIN_APIGEE_AUTHORIZATION);
            //httpRequestApigee.setHeader('Cache-Control', 'no-cache');
            //httpRequestApigee.setHeader('Content-Length', '30');
            //httpRequestApigee.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            //httpRequestApigee.setHeader('Accept', '*/*');
            //httpRequestApigee.setHeader('Accept-Encoding', 'gzip, deflate, br');
            //httpRequestApigee.setHeader('Connection', 'keep-alive');
            //httpRequestApigee.setBody('grant_type=client_credentials');
            
            //Http httpProtocol = new Http();
            //HttpResponse httpResponseApigee = httpProtocol.send(httpRequestApigee);
            
        
        return accessToken;            
    }//end method getAccessTokenFromSFAINT
    
    
    public static String parseForAccessToken(String responseBody) {
        String accessToken = null;
        
        try {
            JSONParser responseJSONParser = JSON.createParser(responseBody);
            
            Integer tokenCtr = 0;
            responseJSONParser.nextToken();
            
            do 
            {
                responseJSONParser.nextValue();
                
                System.debug('(CapitalDesignWebService.getAccessTokenFromSFAINT) thisTokenName[' + tokenCtr + '] = ' + responseJSONParser.getCurrentName() );
                System.debug('(CapitalDesignWebService.getAccessTokenFromSFAINT) thisTokenText[' + tokenCtr + '] = ' + responseJSONParser.getText() );   
                
                switch on responseJSONParser.getCurrentName() 
                {
                    when 'access_token' 
                    {
                        if (responseJSONParser.getCurrentName() != responseJSONParser.getText()) 
                        {
                            accessToken = responseJSONParser.getText();
                        }
                    }//end when 'access_token'
                }//end switch
                
                tokenCtr++;
                
            } 
            while (responseJSONParser.nextToken() != null); //end while nextToken NOT NULL            
        } 
        
        catch(Exception jsonParseX) 
        {
            System.debug('(CapitalDesignWebService.parseForAccessToken) EXCEPTION! \n Type: ' + jsonParseX.getTypeName() + '\n Message:  ' + jsonParseX.getMessage() + '\n Line#: ' + jsonParseX.getLineNumber() + '\n StackTrace:  ' + jsonParseX.getStackTraceString());
        }       
        
        return accessToken;
    }//end method parseForAccessToken


    public static Http http = new Http();
    public static HTTPResponse response;
    public static HttpRequest request;
 
    public class NewCapitalDesignRequestWrapper 
    {
        public String name {get; set;}
        public String phone {get; set;}
    }
    
    
	public static void getCapitalDesign(Id capDId) 
    { 
        request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:SalesforceAccount/services/apexrest/CapitalDesign/' + capDId);
 
        response = http.send(request); 
 
        System.debug(response.getBody());
    }
 
    public static void addCapitalDesign(NewCapitalDesignRequestWrapper newCapD) {
 
        request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('callout:SalesforceAccount/services/apexrest/CapitalDesign');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(JSON.serialize(newCapD));
 
        response = http.send(request); 
 
        System.debug(response.getBody());
    }
 
    public static void deleteCapitalDesign(Id capDId) {
 
        request = new HttpRequest();
        request.setMethod('DELETE');
        request.setEndpoint('callout:SalesforceAccount/services/apexrest/CapitalDesign/' + capDId);
 
        response = http.send(request); 
 
        System.debug(response.getBody());
    } 
}