/***************************************************************
===============================================================
Purpose: Test class for GeoesServiceAddressValidationWrapper class
Instantiating all the variables for the code coverage
===============================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    31/01/2022   ESCJ-379      Initial draft
***************************************************************/
@isTest
public with sharing class GeoesServiceAddressWrapper_Test {

    @isTest
    static void instantiateGeoesServiceAddressValidationWrapper() {
        GeoesServiceAddressValidationWrapper geoesWrapper = new GeoesServiceAddressValidationWrapper();
        geoesWrapper.result = null;
        geoesWrapper.overallDuration = null;
        geoesWrapper.trackingId = null;
        geoesWrapper.isResponseFromCache = null;
        geoesWrapper.version = null;
        geoesWrapper.exactMatches = null;
        geoesWrapper.nearMatches = null;
        geoesWrapper.serviceStatus = null;
    }

    @isTest
    static void instantiateWireCenter() {
        GeoesServiceAddressValidationWrapper.WireCenter wireCenter = new GeoesServiceAddressValidationWrapper.WireCenter();
        wireCenter.clli8 = null;
        wireCenter.clli8Source = null;
    }

    @isTest
    static void instantiateVhCoordinate() {
        GeoesServiceAddressValidationWrapper.VhCoordinate vhCoordinate = new GeoesServiceAddressValidationWrapper.VhCoordinate();
        vhCoordinate.vCoordinate = null;
        vhCoordinate.hCoordinate = null;
    }

    @isTest
    static void instantiateRateCenter() {
        GeoesServiceAddressValidationWrapper.RateCenter rateCenter = new GeoesServiceAddressValidationWrapper.RateCenter();
        rateCenter.name = null;
    }

    @isTest
    static void instantiateGpsCoordinate() {
        GeoesServiceAddressValidationWrapper.GpsCoordinate gpsCoordinate = new GeoesServiceAddressValidationWrapper.GpsCoordinate();
        gpsCoordinate.resolutionLevel = null;
        gpsCoordinate.coordinateAccuracy = null;
        gpsCoordinate.longitudeCoordinate = null;
        gpsCoordinate.latitudeCoordinate = null;
        gpsCoordinate.source = null;
    }

    @isTest
    static void instantiateGeoPointDetails() {
        GeoesServiceAddressValidationWrapper.GeoPointDetails geoPointDetails = new GeoesServiceAddressValidationWrapper.GeoPointDetails();
        geoPointDetails.gpsCoordinate = null;
        geoPointDetails.vhCoordinate = null;
    }

    @isTest
    static void instantiateExactMatches() {
        GeoesServiceAddressValidationWrapper.ExactMatch exactMatch = new GeoesServiceAddressValidationWrapper.ExactMatch();
        exactMatch.geoPointDetails = null;
        exactMatch.isExactToInput = null;
        exactMatch.wireCenter = null;
        exactMatch.isNoBuild = null;
        exactMatch.postCode = null;
        exactMatch.source = null;
        exactMatch.stateOrProvince = null;
        exactMatch.sourceId = null;
        exactMatch.locality = null;
        exactMatch.geoAddressId = null;
        exactMatch.streetName = null;
        exactMatch.isMdu = null;
        exactMatch.streetNrFirst = null;
        exactMatch.attributes = null;
        exactMatch.streetAddress = null;
    }

    @isTest
    static void instantiateAttributes() {
        GeoesServiceAddressValidationWrapper.Attributes attributes = new GeoesServiceAddressValidationWrapper.Attributes();
        attributes.cala = null;
        attributes.taxCode = null;
        attributes.rateZoneLfacs = null;
        attributes.tta = null;
        attributes.rateZone = null;
        attributes.exchangeCode = null;
        attributes.rateCenter = null;
        attributes.trs = null;
        attributes.legacyProvider = null;
    }

    @isTest
    static void instantiateSubAddress() {
        GeoesServiceAddressValidationWrapper.SubAddress subAddress = new GeoesServiceAddressValidationWrapper.SubAddress();
        subAddress.combinedDesignator = null;
        subAddress.elements = null;
        subAddress.geoSubAddressId = null;
    }

    @isTest
    static void instantiateNearMatches() {
        GeoesServiceAddressValidationWrapper.NearMatch nearMatch = new GeoesServiceAddressValidationWrapper.NearMatch();
        nearMatch.postCode = null;
        nearMatch.locality = null;
        nearMatch.stateOrProvince = null;
        nearMatch.streetName = null;
        nearMatch.source = null;
        nearMatch.streetNrFirst = null;
        nearMatch.sourceId = null;
        nearMatch.streetAddress = null;
        nearMatch.geoAddressId = null;
        nearMatch.subAddress = null;
        nearMatch.isNoBuild = null;
    }

    @isTest
    static void instantiateElements() {
        GeoesServiceAddressValidationWrapper.Elements elements = new GeoesServiceAddressValidationWrapper.Elements();
        elements.designator = null;
        elements.value = null;
    }
}