@isTest
public with sharing class ApiTransactionServiceTest { 

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

        System.assertNotEquals(null, httpResponse);
        System.assertNotEquals(null, httpResponse?.getBody());
        System.assertEquals(200, httpResponse.getStatusCode());
        System.assertEquals(1, apiTransactions?.size());
        System.assertEquals(tranSummaries[0].Id, apiTransactions[0]?.Transaction_Summary_Id__c);
    }

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

        System.assertNotEquals(null, httpResponse);
        System.assertNotEquals(null, httpResponse?.getBody());
        System.assertEquals(200, httpResponse.getStatusCode());
        System.assertEquals(1, apiTransactions?.size());
        System.assertEquals(tranSummaries[0].Id, apiTransactions[0]?.Transaction_Summary_Id__c);
    }

    @isTest
    public static void testCalloutUsingServiceAvailabilityService() {
        List<Transaction_Summary__c> tranSummaries = TestDataFactory.createTransactionSummaries(
            null, null, null, null, null, null, 1, true
        );
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

        System.assertEquals(1, apiTransactions?.size());
        System.assertEquals(tranSummaries[0].Id, apiTransactions[0]?.Transaction_Summary_Id__c);
    }

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