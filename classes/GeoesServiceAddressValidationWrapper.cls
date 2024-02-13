/***************************************************************
===============================================================
Purpose: Wrapper class for the GEOES Service Address Validation
         API Response
===============================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    31/01/2022   ESCJ-379      Initial draft
***************************************************************/
public with sharing class GeoesServiceAddressValidationWrapper {
    public String result{get;set;}
    public Decimal overallDuration{get;set;}
    public String trackingId{get;set;}
    public Boolean isResponseFromCache{get;set;}
    public String version{get;set;}
    public list<ExactMatch> exactMatches{get;set;}
    public list<NearMatch> nearMatches{get;set;}
    public String serviceStatus{get;set;}

    public class WireCenter{
        public String clli8Source{get;set;}
        public String clli8{get;set;}
    }

    public class VhCoordinate{
        public Decimal vCoordinate{get;set;}
        public Decimal hCoordinate{get;set;}
    }

    public class RateCenter{
        public String name{get;set;}
    }

    public class GpsCoordinate{
        public String resolutionLevel{get;set;}
        public String coordinateAccuracy{get;set;}
        public Decimal longitudeCoordinate{get;set;}
        public Decimal latitudeCoordinate{get;set;}
        public String source{get;set;}
    }

    public class GeoPointDetails{
        public GpsCoordinate gpsCoordinate{get;set;}
        public VhCoordinate vhCoordinate{get;set;}
    }

    public class ExactMatch{
        public list<GeoPointDetails> geoPointDetails{get;set;}
        public Boolean isExactToInput{get;set;}
        public WireCenter wireCenter{get;set;}
        public Boolean isNoBuild{get;set;}
        public String postCode{get;set;}
        public String source{get;set;}
        public String stateOrProvince{get;set;}
        public String sourceId{get;set;}
        public String locality{get;set;}
        public String geoAddressId{get;set;}
        public String streetName{get;set;}
        public Boolean isMdu{get;set;}
        public String streetNrFirst{get;set;}
        public Attributes attributes{get;set;}
        public String streetAddress{get;set;}
    }

    public class Attributes{
        public String cala{get;set;}
        public String taxCode{get;set;}
        public String rateZoneLfacs{get;set;}
        public String tta{get;set;}
        public String rateZone{get;set;}
        public String exchangeCode{get;set;}
        public RateCenter rateCenter{get;set;}
        public String trs{get;set;}
        public String legacyProvider{get;set;}
    }

    public class SubAddress{
        public String combinedDesignator{get;set;}
        public list<Elements> elements{get;set;}
        public String geoSubAddressId{get;set;}
    }

    public class NearMatch{
        public String postCode{get;set;}
        public String locality{get;set;}
        public String stateOrProvince{get;set;}
        public String streetName{get;set;}
        public String source{get;set;}
        public String streetNrFirst{get;set;}
        public String sourceId{get;set;}
        public String streetAddress{get;set;}
        public String geoAddressId{get;set;}
        public SubAddress subAddress{get;set;}
        public Boolean isNoBuild{get;set;}
    }

    public class Elements{
        public String designator{get;set;}
        public String value{get;set;}
    }

    /**********************************************************************************************
    Purpose: To parse jsonBody String into GeoesServiceAddressValidationWrapper
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    public static GeoesServiceAddressValidationWrapper parse(String jsonBody) {
        return (GeoesServiceAddressValidationWrapper) System.JSON.deserialize(
            jsonBody,
            GeoesServiceAddressValidationWrapper.class
        );
    }
}