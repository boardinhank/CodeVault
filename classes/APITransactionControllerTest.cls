/***************************************************************
===============================================================
Purpose:Test Class for APITransactionController
===============================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    14/12/2021   ESCJ-327      Initial draft
***************************************************************/
@isTest
public with sharing class APITransactionControllerTest {

    /**********************************************************************************************
    Purpose: To test generic callout class using parcel service
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testCalloutUsingParcelService() {
        List<Transaction_Summary__c> tranSummaries = TestDataFactory.createTransactionSummaries(
            null, null, null, null, null, null, 1, true
        );
        String parcelServiceApiName = 'ParcelServiceByLatLong';
        Map<String, String> queryParamMap = new Map<String, String>{
            'latitude' => '40.72445911093',
            'longitude' => '-96.6389346791281'
        };
        Test.startTest();
            APITransactionController objApiTransactionCtrl = new APITransactionController(
                parcelServiceApiName,
                null,
                queryParamMap,
                tranSummaries[0].Id
            );
            HttpResponse httpResponse = APITransactionController.serviceCallout();
        Test.stopTest();

        List<API_Transaction__c> apiTransactions = getApiTransactions(parcelServiceApiName);

        System.assertNotEquals(null, httpResponse);
        System.assertNotEquals(null, httpResponse?.getBody());
        System.assertEquals(200, httpResponse.getStatusCode());
        System.assertEquals(1, apiTransactions?.size());
        System.assertEquals(tranSummaries[0].Id, apiTransactions[0]?.Transaction_Summary_Id__c);
    }

    /**********************************************************************************************
    Purpose: To test generic callout class using GetInfrastructureLayers prospector service.
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testCalloutUsingInfrastructureService() {
        List<Transaction_Summary__c> tranSummaries = TestDataFactory.createTransactionSummaries(
            null, null, null, null, null, null, 1, true
        );
        String getInfraStructureLayersService = 'GetInfrastructureLayers';
        Map<String, String> queryParamMap = new Map<String, String>{
            'mapServiceName' => 'Telecom'
        };
        Test.startTest();
            APITransactionController objApiTransactionCtrl = new APITransactionController(
                getInfraStructureLayersService,
                null,
                queryParamMap,
                tranSummaries[0].Id
            );
            HttpResponse httpResponse = APITransactionController.serviceCallout();
        Test.stopTest();

        List<API_Transaction__c> apiTransactions = getApiTransactions(getInfraStructureLayersService);

        System.assertNotEquals(null, httpResponse);
        System.assertNotEquals(null, httpResponse?.getBody());
        System.assertEquals(200, httpResponse.getStatusCode());
        System.assertEquals(1, apiTransactions?.size());
        System.assertEquals(tranSummaries[0].Id, apiTransactions[0]?.Transaction_Summary_Id__c);
    }

    /**********************************************************************************************
    Purpose: To test generic callout class using ServiceAvailabilityEndPoint service which uses
             bearer token
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testCalloutUsingServiceAvailabilityService() {
        List<Transaction_Summary__c> tranSummaries = TestDataFactory.createTransactionSummaries(
            null, null, null, null, null, null, 1, true
        );
        String serviceAvailabilityEndpointService = 'ServiceAvailabilityEndPoint';
        String reqBody = '{\"serviceAddress\":{\"geoPoint\":[{\"longitude\":-104.8411069,\"latitude\":39.7377106}],' +
        '\"addressLine\":\"1340 Scranton Street, Aurora, CO 80011, USA\"},\"salesChannel\":\"PARTNER\",\"referenceNumber\":\"1631875401068eaf\",\"attemptedGoogle\":\"Yes\"}';

        Test.startTest();
            APITransactionController objApiTransactionCtrl = new APITransactionController(
                serviceAvailabilityEndpointService,
                reqBody,
                null,
                tranSummaries[0].Id
            );
            HttpResponse httpResponse = APITransactionController.serviceCallout();
        Test.stopTest();

        List<API_Transaction__c> apiTransactions = getApiTransactions(serviceAvailabilityEndpointService);

        System.assertNotEquals(null, httpResponse);
        System.assertNotEquals(null, httpResponse?.getBody());
        System.assertEquals(200, httpResponse.getStatusCode());
        System.assertEquals(1, apiTransactions?.size());
        System.assertEquals(tranSummaries[0].Id, apiTransactions[0]?.Transaction_Summary_Id__c);
    }

    /**********************************************************************************************
    Purpose: To test parcel service callout using address
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testApexRestService() {
        String getInfraStructureLayersService = 'GetInfrastructureLayers';
        String json = '{\"serviceInfo\" : \"GetInfrastructureLayers\", \"params\":{\"mapServiceName\":\"Telecom\"}}';
        RestRequest request = new RestRequest();
        request.requestUri ='/services/apexrest/APITransactionController';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(json);

        RestContext.request = request;
        Test.startTest();
            String response = APITransactionController.apiTransactionController();
        Test.stopTest();
        List<API_Transaction__c> apiTransactions = getApiTransactions(getInfraStructureLayersService);

        System.assertNotEquals(null, response);
        System.assertEquals(1, apiTransactions?.size());
    }

    /**********************************************************************************************
    Purpose: To get the Api transactions created for given API Name
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    private static List<API_Transaction__c> getApiTransactions(String apiName) {
        return [
            SELECT
                Id,
                API_Name__c,
                Transaction_Summary_Id__c
            FROM API_Transaction__c
            WHERE
                API_Name__c = :apiName
        ];
    }
}