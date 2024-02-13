/***************************************************************
===============================================================
Purpose: Response wrapper class for UNIQUAL Parcel service
===============================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    31/11/2021   ESCJ-265      Initial draft
***************************************************************/
public with sharing class UniqualParcelServiceResponseWrap {
    public list<Parcels> parcels{get;set;}
    public String requestId{get;set;}
    public String errorMessage{get;set;}
    public Integer totalParcels{get;set;}

    public class Parcels {
        public String taxAmount{get;set;}
        public String taxYear{get;set;}
        public String appraisedImprovementValue{get;set;}
        public String assessedYear{get;set;}
        public String appraisedLandValue{get;set;}
        public String taxCodeArea{get;set;}
        public String appraisedTotalValue{get;set;}
        public String documentNumber{get;set;}
        public String marketImprovementValue{get;set;}
        public String bookAndPage{get;set;}
        public String marketLandValue{get;set;}
        public String frontFootage{get;set;}
        public String marketTotalValue{get;set;}
        public String depthFootage{get;set;}
        public String assessedImprovementValue{get;set;}
        public String acres{get;set;}
        public String assessedLandValue{get;set;}
        public String landSquareFootage{get;set;}
        public String assessedTotalValue{get;set;}
        public String lotArea{get;set;}
        public String landValueCalculatedIndicator{get;set;}
        public String universalBuildingSquareFeet{get;set;}
        public String totalValueCalculatedIndicator{get;set;}
        public String buildingSquareFeetIndicator{get;set;}
        public String improvementValue{get;set;}
        public String buildingSquareFeet{get;set;}
        public String landValue{get;set;}
        public String livingSquareFeet{get;set;}
        public String totalValue{get;set;}
        public String groundFloorSquareFeet{get;set;}
        public String mailingOptOutCode{get;set;}
        public String grossSquareFeet{get;set;}
        public String mailCarrierCode{get;set;}
        public String adjustedGrossSquareFeet{get;set;}
        public String mailZipCode{get;set;}
        public String basementSquareFeet{get;set;}
        public String mailState{get;set;}
        public String parkingSquareFeet{get;set;}
        public String mailCity{get;set;}
        public String yearBuilt{get;set;}
        public String mailUnitNumber{get;set;}
        public String effectiveYearBuilt{get;set;}
        public String mailQuadrant{get;set;}
        public String bedrooms{get;set;}
        public String mailMode{get;set;}
        public String totalRooms{get;set;}
        public String mailStreetName{get;set;}
        public String totalBathsCalculated{get;set;}
        public String mailDirection{get;set;}
        public String totalBaths{get;set;}
        public String mailHouseNumberSuffix{get;set;}
        public String fullBaths{get;set;}
        public String mailHouseNumber2{get;set;}
        public String halfBaths{get;set;}
        public String mailHouseNumber{get;set;}
        public String quarterBaths{get;set;}
        public String mailHouseNumberPrefix{get;set;}
        public String threeQuarterBaths{get;set;}
        public String owner2FirstName{get;set;}
        public String bathFixtures{get;set;}
        public String owner2LastName{get;set;}
        public String airConditioning{get;set;}
        public String owner1FirstName{get;set;}
        public String basementFinish{get;set;}
        public String owner1LastName{get;set;}
        public String buildingCode{get;set;}
        public String ownerCorporateIndicator{get;set;}
        public String buildingImprovementCode{get;set;}
        public String subdivisionName{get;set;}
        public String condition{get;set;}
        public String subdivisionPlatPage{get;set;}
        public String constructionType{get;set;}
        public String subdivisionPlatBook{get;set;}
        public String exteriorWalls{get;set;}
        public String subdivisionTractNumber{get;set;}
        public String fireplaceIndicator{get;set;}
        public String propertyIndicator{get;set;}
        public String fireplaceNumber{get;set;}
        public String zoning{get;set;}
        public String fireplaceType{get;set;}
        public String mobileHomeIndicator{get;set;}
        public String foundation{get;set;}
        public String landUse{get;set;}
        public String frame{get;set;}
        public String quarterSection{get;set;}
        public String floor{get;set;}
        public String section{get;set;}
        public String garage{get;set;}
        public String township{get;set;}
        public String heating{get;set;}
        public String range{get;set;}
        public String parkingSpaces{get;set;}
        public String lotNumber{get;set;}
        public String parkingType{get;set;}
        public String blockNumber{get;set;}
        public String pool{get;set;}
        public String censusTract{get;set;}
        public String poolCode{get;set;}
        public String mapRef2{get;set;}
        public String quality{get;set;}
        public String mapRef1{get;set;}
        public String roofCover{get;set;}
        public String thomasBrosMapNumber{get;set;}
        public String roofType{get;set;}
        public String accountNumber{get;set;}
        public String storiesCode{get;set;}
        public String originalApn{get;set;}
        public String storiesNumber{get;set;}
        public String formattedApn{get;set;}
        public String view{get;set;}
        public String apnSequenceNumber{get;set;}
        public String locationInfluence{get;set;}
        public String unformattedApn{get;set;}
        public String numberOfUnits{get;set;}
        public String fipsCode{get;set;}
        public String unitsNumber{get;set;}
        public String standardZipPlusFour{get;set;}
        public String energyUse{get;set;}
        public String standardZipCode{get;set;}
        public String fuel{get;set;}
        public String standardCity{get;set;}
        public String sewer{get;set;}
        public String standardAddress{get;set;}
        public String water{get;set;}
        public String zipPlusFour{get;set;}
        public String legalDescription1{get;set;}
        public String zipCode{get;set;}
        public String legalDescription2{get;set;}
        public String state{get;set;}
        public String legalDescription3{get;set;}
        public String city{get;set;}
        public String latitude{get;set;}
        public String address{get;set;}
        public String longitude{get;set;}
        public String apn2{get;set;}
        public String countyCode{get;set;}
        public String stateCode{get;set;}
        public String apn{get;set;}
        public String parcelId{get;set;}
    }

    /**********************************************************************************************
    Purpose: To parse jsonBody String into UniqualParcelServiceResponseWrap
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/11/2021   ESCJ-265      Initial draft
    ***********************************************************************************************/
    public static UniqualParcelServiceResponseWrap parse(String jsonBody) {
        return (UniqualParcelServiceResponseWrap) System.JSON.deserialize(
            jsonBody,
            UniqualParcelServiceResponseWrap.class
        );
    }
}