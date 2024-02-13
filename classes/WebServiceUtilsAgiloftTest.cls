/***************************************************************************************************************
 * Description: Test class for WebServiceUtilsAgiloft
 * *************************************************************************************************************
 * Change History:
 * 
 * Date         Person Responsible      Traceability	Details    
 * 11/18/2022	Kuehl, S                ESCJ-1680       Created WebServiceUtilsAgiloftTest class
 * 01-17-2023   Kuehl                   ESCJ-2345       Cleaned up code for Sonar Cube edits and add test function for ContractUpdate
****************************************************************************************************************/

@isTest
public class WebServiceUtilsAgiloftTest 
{       
    @isTest
    static void testWebServiceUtilHeadersContractCreate() 
    {   
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());  
        
        string pwd                      = '&$password=';
        string lang                     = '&$lang=en';
        string tableLogin               = '&$table=contract&$login=';
        string callingApiName 			= 'AgiloftContractCreate';
        string agiloftPayload           = '';
        string strAgiloftLoginId		= 'abc';
        string strAgiloftLoginPassword	= 'def';
        string strAgiloftKB				= 'KBABC';
        Time startTime;
        Time endTime;	
        string auth = '';
        boolean cacheR = false;
                        
        WebServiceUtilsAgiloft utils = new WebServiceUtilsAgiloft(callingApiName);

        string encodedQry;
        string endpoint = utils.endPoint;
             
        // ESCJ-2345 spk 1-17-2023 - Add final Endpoint as needed for flexibility.
        if (callingApiName.contains('ContractCreate'))
        {
            endPoint = endPoint + '/EWCreate?';
            encodedQry = '&$login=' + strAgiloftLoginId + pwd + strAgiloftLoginPassword +'&$KB='+ strAgiloftKB + '&$lang=en&$table=cj_staging';
        }
        else if (callingApiName.contains('ContractCancel'))
        {
            endPoint = endPoint + '/EWActionButton?';            
            encodedQry = '%24$KB='+ strAgiloftKB + '&%24$login=' + strAgiloftLoginId +'&%24$password='+ strAgiloftLoginPassword +'&%24lang=en&%24table=contract&name=cancel_contract';
        }
        else if (callingApiName.contains('ContractUdate'))
        {
            endPoint = endPoint + '/EWUpdate?';
            encodedQry = '&$KB='+ strAgiloftKB + tableLogin + strAgiloftLoginId + pwd + strAgiloftLoginPassword + lang;            
        }
        else if (callingApiName.contains('ContractRead'))
        {
            endPoint = endPoint + '/EWRead?';
            encodedQry = '&$KB='+ strAgiloftKB + tableLogin + strAgiloftLoginId + pwd + strAgiloftLoginPassword +lang;            
        }
                
        utils.setEndpoint(endpoint);        
        utils.addHeader('TestName', 'TestValue');               
        utils.getHeader('TestName');
        utils.getHeaders();
        auth = utils.authentication;
        cacheR = utils.cacheResponse;
                        
        system.debug('encodedQry=' + encodedQry);
        
        utils.appendQueryParam(encodedQry);
        
        utils.setBody(agiloftPayload);  // Add Contract data fields to payload    
        
        startTime = DateTime.now().Time();
           
        Boolean isContractApiSuccessful;
        
        try
        {                           
            isContractApiSuccessful = utils.send(false);
            
            endTime = DateTime.now().Time();
           
            if (isContractApiSuccessful) 
            {                
                	utils.getRequest();
                	utils.getResponse();                
            }
        }
         catch(Exception e)
        {	   
           // Create API Transaction record for history and reports
           utils.getRequest();
           utils.getResponse();
        }                            

        System.assertNotEquals(true, isContractApiSuccessful, 'Successfull Trx');
    }

        
    @isTest
    static void testWebServiceUtilHeadersContractCancel() 
    {   
        Test.setMock(HttpCalloutMock.class, new TestHttpCallouts());  
        
        string pwd                      = '&$password=';
        string lang                     = '&$lang=en';
        string tableLogin               = '&$table=contract&$login=';
        string callingApiName 			= 'AgiloftContractCancel';        
        string agiloftPayload           = '';
        string strAgiloftLoginId		= 'abc';
        string strAgiloftLoginPassword	= 'def';
        string strAgiloftKB				= 'KBABC';
        Time startTime;
        Time endTime;	
        string auth = '';
        boolean cacheR = false;
                        
        WebServiceUtilsAgiloft utils = new WebServiceUtilsAgiloft(callingApiName);
        
        string encodedQry;
        string endpoint = utils.endPoint;
     
        // ESCJ-2345 spk 1-17-2023 - Add final Endpoint as needed for flexibility.
        if (callingApiName.contains('ContractCreate'))
        {
            endPoint = endPoint + '/EWCreate?';            
            encodedQry = '&$login=' + strAgiloftLoginId + pwd + strAgiloftLoginPassword +'&$KB='+ strAgiloftKB + '&$lang=en&$table=cj_staging';         
            utils.setBody(agiloftPayload);  // Add Contract data fields to payload for create
            system.debug ('Payload:  ' + agiloftPayload);        
        }
        else if (callingApiName.contains('ContractCancel'))
        {
            endPoint = endPoint + '/EWActionButton?';            
            encodedQry = '%24KB='+ strAgiloftKB + '&%24login=' + strAgiloftLoginId +'&%24password='+ strAgiloftLoginPassword +'&%24lang=en&%24table=contract&name=cancel_contract' + agiloftPayload;
        }
        else if (callingApiName.contains('ContractUdate'))
        {
            endPoint = endPoint + '/EWUpdate?';            
            encodedQry = '&$KB='+ strAgiloftKB + tableLogin + strAgiloftLoginId + pwd + strAgiloftLoginPassword + lang + agiloftPayload;
        }
        else if (callingApiName.contains('ContractRead'))
        {
            endPoint = endPoint + '/EWRead?';
            encodedQry = '&$KB='+ strAgiloftKB + tableLogin + strAgiloftLoginId + pwd + strAgiloftLoginPassword + lang + agiloftPayload;            
        }
        
        utils.setEndpoint(endpoint);

        utils.addHeader('TestName', 'TestValue');               
        utils.getHeader('TestName');
        utils.getHeaders();

        auth    = utils.authentication;
        cacheR  = utils.cacheResponse;
                        
        system.debug('encodedQry=' + encodedQry);
        
        utils.appendQueryParam(encodedQry);
        
        startTime = DateTime.now().Time();
           
        Boolean isContractApiSuccessful;
            
        try
        {                           
            isContractApiSuccessful = utils.send(false);
            
            endTime = DateTime.now().Time();
           
            if (isContractApiSuccessful) 
            {                
               	utils.getRequest();
               	utils.getResponse();                
            }
        }
         catch(Exception e)
        {	   
           // Create API Transaction record for history and reports
           utils.getRequest();
           utils.getResponse();
        }                            
        
        System.assertNotEquals(true, isContractApiSuccessful, 'Successful Trx');
    }
        

    @isTest
    public static void testCalloutUsingParcelService() 
    {
        List<Transaction_Summary__c> tranSummaries = TestDataFactory.createTransactionSummaries(null, null, null, null, null, null, 1, true);
        
        String parcelServiceApiName = 'ParcelServiceByLatLong';
        Map<String, String> queryParamMap = new Map<String, String>
        {
            'latitude' => '40.72445911093',
            'longitude' => '-96.6389346791281'
        };
            
        Test.startTest();
            ApiTransactionService apiService = new ApiTransactionService();
            HttpResponse httpResponse =  apiService.serviceCallout(
                parcelServiceApiName,
                null,
                queryParamMap,
                tranSummaries[0].Id
            );
            apiService.save();
        Test.stopTest();

        List<API_Transaction__c> apiTransactions = getApiTransactions(parcelServiceApiName);

        System.assertNotEquals(null, httpResponse, 'We have a Parcel response');
        System.assertNotEquals(null, httpResponse?.getBody(), 'We have a body response');
        System.assertEquals(200, httpResponse.getStatusCode(), 'We have a good status code');
        System.assertEquals(1, apiTransactions?.size(), 'We have a trx');
        System.assertEquals(tranSummaries[0].Id, apiTransactions[0]?.Transaction_Summary_Id__c, 'We have a ID');
    }

    @isTest
    public static void testCalloutUsingInfrastructureService() 
    {
        List<Transaction_Summary__c> tranSummaries = TestDataFactory.createTransactionSummaries(null, null, null, null, null, null, 1, true);
        String getInfraStructureLayersService = 'GetInfrastructureLayers';
        Map<String, String> queryParamMap = new Map<String, String>
        {
            'mapServiceName' => 'Telecom'
        };
        
        Test.startTest();
            ApiTransactionService apiService = new ApiTransactionService();
            HttpResponse httpResponse = apiService.serviceCallout(
                getInfraStructureLayersService,
                null,
                queryParamMap,
                tranSummaries[0].Id
            );
            apiService.save();
        Test.stopTest();

        List<API_Transaction__c> apiTransactions = getApiTransactions(getInfraStructureLayersService);

        System.assertNotEquals(null, httpResponse, 'We have a response');
        System.assertNotEquals(null, httpResponse?.getBody(), 'We have a response');
        System.assertEquals(200, httpResponse.getStatusCode(), 'We have a good status code');
        System.assertEquals(1, apiTransactions?.size(), 'We have a trx');
        System.assertEquals(tranSummaries[0].Id, apiTransactions[0]?.Transaction_Summary_Id__c, 'We have a ID');
    }

    @isTest
    public static void testCalloutUsingServiceAvailabilityService() 
    {
        List<Transaction_Summary__c> tranSummaries = TestDataFactory.createTransactionSummaries(null, null, null, null, null, null, 1, true);
        String serviceAvailabilityEndpointService = 'ServiceAvailabilityEndPoint';

        String reqBody = '{\"serviceAddress\":{\"geoPoint\":[{\"longitude\":-104.8411069,\"latitude\":39.7377106}],' +
        '\"addressLine\":\"1340 Scranton Street, Aurora, CO 80011, USA\"},\"salesChannel\":\"PARTNER\",\"referenceNumber\":\"1631875401068eaf\",\"attemptedGoogle\":\"Yes\"}';

        Test.startTest();
            ApiTransactionService apiService = new ApiTransactionService();
            HttpResponse httpResponse = apiService.serviceCallout(
                serviceAvailabilityEndpointService,
                reqBody,
                null,
                tranSummaries[0].Id
            );
            apiService.save();
        Test.stopTest();

        List<API_Transaction__c> apiTransactions = getApiTransactions(serviceAvailabilityEndpointService);

        System.assertEquals(1, apiTransactions?.size(), 'we have 1 trx');
        System.assertEquals(tranSummaries[0].Id, apiTransactions[0]?.Transaction_Summary_Id__c, 'we have an id');
    }

    private static List<API_Transaction__c> getApiTransactions(String apiName) 
    {
        return [
            SELECT
                Id,
                API_Name__c,
                Transaction_Summary_Id__c
            FROM API_Transaction__c
            WHERE
                API_Name__c = :apiName 
            WITH SECURITY_ENFORCED
            ];
    }
}