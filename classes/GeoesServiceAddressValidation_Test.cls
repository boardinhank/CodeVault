/***************************************************************
===============================================================
Purpose: Test class for GEOES Service Address Validation callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    31/01/2022   ESCJ-379      Initial draft
***************************************************************/
@isTest
public with sharing class GeoesServiceAddressValidation_Test {

    /**********************************************************************************************
    Purpose: To test GEOES service callout using GeoAddressId
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testMatchingAdrressUsingGeoAddressId() {
        String geoAddressId = '207629804';
        Test.startTest();
            GeoesServiceAddressValidationCallout.GeoesServiceResponse geosServiceResponse = GeoesServiceAddressValidationCallout.getMatchingAddresses(geoAddressId, null,null,null);
        Test.stopTest();
        List<GeoesServiceAddressValidationCallout.ServiceAddress> matchingAddresses = (List<GeoesServiceAddressValidationCallout.ServiceAddress>)geosServiceResponse.data;
        System.assertEquals(1, matchingAddresses?.size());
        System.assertEquals(geoAddressId, matchingAddresses[0]?.geoAddressId);
        System.assertEquals('Exact Match', matchingAddresses[0]?.matchType);
    }

    /**********************************************************************************************
    Purpose: To test GEOES service callout using Address info
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    @isTest
    public static void testMatchingAdrressUsingAddress() {
        Map<String, String> addressInfoMap = new Map<String, String>{
            GeoesConstants.addressLine1_FieldName      => '22 E',
            GeoesConstants.locality_FieldName          => 'COLORADO SPRINGS',
            GeoesConstants.stateOrProvince_FieldName   => 'CO',
            GeoesConstants.postCode_FieldName          => '80903',
            GeoesConstants.country_FieldName           => 'USA'
        };
        Test.startTest();
            GeoesServiceAddressValidationCallout.GeoesServiceResponse geosServiceResponse = GeoesServiceAddressValidationCallout.getMatchingAddresses(null, addressInfoMap,null,null);
        Test.stopTest();
        List<GeoesServiceAddressValidationCallout.ServiceAddress> matchingAddresses = (List<GeoesServiceAddressValidationCallout.ServiceAddress>)geosServiceResponse.data;
        System.assertEquals(3, matchingAddresses?.size());
        System.assertEquals('Near Match', matchingAddresses[0]?.matchType);
    }

      /**********************************************************************************************
    Purpose: To test GEOES service callout using GeoAddressId
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Naga       26-06-2023      QFCJ-2156      
    ***********************************************************************************************/
    @isTest
    public static void testMatchingAdrressUsingLatLong() {
        String lat = '38.79295000';
        String longt ='-104.84039800';
        Test.startTest();
            GeoesServiceAddressValidationCallout.GeoesServiceResponse geosServiceResponse = GeoesServiceAddressValidationCallout.getMatchingAddresses(null, null,lat,longt);
        Test.stopTest();
        List<GeoesServiceAddressValidationCallout.ServiceAddress> matchingAddresses = (List<GeoesServiceAddressValidationCallout.ServiceAddress>)geosServiceResponse.data;
        //System.assertEquals('Exact Match', matchingAddresses[0]?.matchType);
    }
}