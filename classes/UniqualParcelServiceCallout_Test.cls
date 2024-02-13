/***************************************************************
===============================================================
Purpose: Test class for UNIQUAL Parcel service callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    14/12/2021   ESCJ-327      Initial draft
***************************************************************/
@isTest  
public with sharing class UniqualParcelServiceCallout_Test {

    /**********************************************************************************************
    Purpose: To create Test data
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    @testSetup static void setup() {
        // Create Property request record
        String dataSource = 'ALN';
        String street = '6001 YANKEE HILL RD';
        String city = 'LINCOLN';
        String state = 'NE';
        Decimal latitude = 40.72445911093;
        Decimal longitude = -96.6389346791281;
        List<Property_Request_Record__c> prrRecords = TestDataFactory.createPropertyReqRecords(
            dataSource, street, city, state, latitude, longitude, 1, true
        );

    }

    /**********************************************************************************************
    Purpose: To test parcel service callout using latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testParcelServiceByLatLong() {
        List<Property_Request_Record__c> prrRecords = getPropertyReqRecords();
        UniqualParcelServiceResponseWrap resWrapper;

        Test.startTest();
            UniqualParcelServiceCallout objParcelService = new UniqualParcelServiceCallout(
                String.valueOf(prrRecords[0]?.GPSLatitude__c),
                String.valueOf(prrRecords[0]?.GPSLongitude__c),
                prrRecords[0]?.Transaction_Summary__c
            );
            resWrapper = objParcelService.getPropertyInfo();
        Test.stopTest();

        List<UniqualParcelServiceResponseWrap.Parcels> parcels = resWrapper?.parcels;
        Map<String,Object> parcelMap = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(parcels[0]));
        List<API_Transaction__c> apiTransactions = getApiTransactions(prrRecords[0]?.Transaction_Summary__c);

        // Assert
        System.assertEquals(1, parcels?.size());
        System.assertEquals(String.valueOf(prrRecords[0]?.GPSLatitude__c), parcelMap.get('latitude'));
        System.assertEquals(String.valueOf(prrRecords[0]?.GPSLongitude__c), parcelMap.get('longitude'));
        System.assertEquals(1, apiTransactions?.size());
        System.assertEquals('ParcelServiceByLatLong', apiTransactions[0]?.API_Name__c);
    }

    /**********************************************************************************************
    Purpose: To test parcel service callout using address
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testParcelServiceByAddress() {
        List<Property_Request_Record__c> prrRecords = getPropertyReqRecords();
        String fullAddress = prrRecords[0]?.ProjectAddress__c + ' ' +
                             prrRecords[0]?.ProjectCity__c + ' ' +
                             prrRecords[0]?.ProjectState__c;
        UniqualParcelServiceResponseWrap resWrapper;

        Test.startTest();
            UniqualParcelServiceCallout objParcelService = new UniqualParcelServiceCallout(
                fullAddress,
                prrRecords[0]?.Transaction_Summary__c
            );
            resWrapper = objParcelService.getPropertyInfo();
        Test.stopTest();

        List<UniqualParcelServiceResponseWrap.Parcels> parcels = resWrapper?.parcels;
        Map<String,Object> parcelMap = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(parcels[0]));
        List<API_Transaction__c> apiTransactions = getApiTransactions(prrRecords[0]?.Transaction_Summary__c);

        // Assert
        System.assertEquals(1, parcels?.size());
        System.assertEquals(prrRecords[0]?.ProjectAddress__c, parcelMap.get('address'));
        System.assertEquals(prrRecords[0]?.ProjectCity__c, parcelMap.get('city'));
        System.assertEquals(prrRecords[0]?.ProjectState__c, parcelMap.get('state'));
        System.assertEquals(1, apiTransactions?.size());
        System.assertEquals('ParcelServiceByAddress', apiTransactions[0]?.API_Name__c);
    }

    @isTest
    public static void testParcelServiceByAddressNegativeScenario() {
        List<Property_Request_Record__c> prrRecords = getPropertyReqRecords();
        String fullAddress = '';
        UniqualParcelServiceResponseWrap resWrapper;

        Test.startTest();
            UniqualParcelServiceCallout objParcelService = new UniqualParcelServiceCallout(
                fullAddress,
                null
            );
            resWrapper = objParcelService.getPropertyInfo();
        Test.stopTest();
        // Assert
        System.assertEquals(null, resWrapper.parcels);
    }

    /**********************************************************************************************
    Purpose: To get property reuest records
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    private static List<Property_Request_Record__c> getPropertyReqRecords() {
        return [
            SELECT
                Id,
                GPSLatitude__c,
                GPSLongitude__c,
                ProjectAddress__c,
                ProjectCity__c,
                ProjectState__c,
                Transaction_Summary__c
            FROM Property_Request_Record__c
        ];
    }

    /**********************************************************************************************
    Purpose: To get API transaction records for given transaction summary
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    private static List<API_Transaction__c> getApiTransactions(Id transactionSummaryId) {
        return [
            SELECT
                Id,
                API_Name__c
            FROM API_Transaction__c
            WHERE
                Transaction_Summary_Id__c =:transactionSummaryId
        ];
    }
}