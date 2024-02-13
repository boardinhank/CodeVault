/***************************************************************
===============================================================
Purpose: Mock Http Response generator class
Note -  1. Add method like getParcelServiceJsonString() to return
        json response string for the respective service
        2. Add condition in respond() to check the api name and call
        their respective method to get response json body string
===============================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    17/12/2021   ESCJ-364      Initial draft
Navin M    31/01/2022   ESCJ-379      Added mock response for GEOES service
***************************************************************/
@isTest
public class MockHttpResponseGenerator implements HttpCalloutMock {
    private String apiName;
    private static final String PARCEL_SERVICE_BY_LAT_LONG = 'ParcelServiceByLatLong';
    private static final String PARCEL_SERVICE_BY_ADDRESS = 'ParcelServiceByAddress';
	private static final String	SOLOCIT_VERIFICATION='SolicitVerification';
    private static final String	SOLOCIT_VERIFICATIONN='SolicitVerificationn';
    private static final String	SOLOCIT_VERIFICATIONNN='SolicitVerificationnn';
	private static final String	SOLOCIT_VERIFICATIONNNN='SolicitVerificationnnn';
    private static final String ADDRESS_TELCO = 'AddressTelco';
    private static final String LOOP_QUAL_FOR_1G_SERVICE = 'LoopQualFor1GService';
    private static final String GET_INFRASTRUCTURE_LAYERS = 'GetInfrastructureLayers';
    private static final String SERVICE_AVAILIBILITY_ENDPOINT_SERVICE = 'ServiceAvailabilityEndPoint';
    private static final String GEOES_SERVICE_ADDRESSES = 'GeoesServiceAddresses';
    private static final String GEOES_SERVICE_ADDRESSES_VALIDATIONS = 'GeoesServiceAddressesValidations';
    private static final String GEOAM_SERVICE_ADDRESSES = 'GEOAM';
    private static final String BIW_SERVICE_BY_LAT_LONG = 'BIWServiceByLatLong';
    private static final String BMPLOOPQUAL_SERVICE = 'BMPLoopQualService';
    private static final String UNIQUAL_BOUNDARY_SERVICE = 'BoundaryUniqualService';
    private static final String LOOPQUAL_BANDWIDTH_SERVICE = 'LoopQualForBandwidth';

    /**********************************************************************************************
    Purpose: Parameterized cosntructor for passing API Name
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    17/12/2021   ESCJ-364      Initial draft
    ***********************************************************************************************/
    public MockHttpResponseGenerator(String thisApiName) {
        apiName = thisApiName;
    }

    /**********************************************************************************************
    Purpose: Http respond method of HttpCalloutMock interface which will return the mock response
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    17/12/2021   ESCJ-364      Initial draft
    Navin M    31/01/2022   ESCJ-379      Added condition for the GEOES service
    ***********************************************************************************************/
    public HTTPResponse respond(HTTPRequest request) {
        String jsonBody;
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        // If the HttpRequest is not null then proceed further
        if (request != null) {
            //Note - Add condition like below for other services with their mock json string as per requriment
            // In case of Uniqual Parcel Service callout
            if (apiName == PARCEL_SERVICE_BY_LAT_LONG || apiName == PARCEL_SERVICE_BY_ADDRESS) {
                jsonBody = getParcelServiceJsonString();
            } else if (apiName == ADDRESS_TELCO) {
                jsonBody = getAddressTelcoServiceResJsonString();
            } else if (apiName == LOOP_QUAL_FOR_1G_SERVICE) {
                jsonBody = get1GEnabledServiceResJsonString();
            } else if (apiName == GET_INFRASTRUCTURE_LAYERS) {
                jsonBody = getInfrastructureServiceJsonString();
            } else if (apiName == SERVICE_AVAILIBILITY_ENDPOINT_SERVICE) {
                jsonBody = getServiceAvailabilityServiceJsonString();
            } else if (apiName == GEOES_SERVICE_ADDRESSES) {
                jsonBody = getGeoesServiceAddressesJsonString();
            } else if (apiName == GEOES_SERVICE_ADDRESSES_VALIDATIONS) {
                jsonBody = getGeoesServiceAddressesValidationJsonString();
            } else if(apiName == SOLOCIT_VERIFICATION) {
                jsonBody = getSolicitVerificationJsonString();
            } else if (apiName == GEOAM_SERVICE_ADDRESSES) {
                jsonBody = getGEOAMResJsonString();
            }else if(apiName == BMPLOOPQUAL_SERVICE){
                jsonBody = getLoopQualJsonString();
            }else if(apiName == BIW_SERVICE_BY_LAT_LONG){
               jsonBody = getBIWServiceJsonString();
            }else if (apiName == SOLOCIT_VERIFICATIONN) {
                jsonBody = getSolicitVerificationnJsonString();
            }  else if (apiName == SOLOCIT_VERIFICATIONNN) {
                jsonBody = getSolicitVerificationnnJsonString();
            } else if (apiName == SOLOCIT_VERIFICATIONNNN) {
                jsonBody = getSolicitVerificationnnnJsonString();
            } else if(apiName == UNIQUAL_BOUNDARY_SERVICE){
                jsonBody = getMarketingBoundaryServiceJsonString();
            } else if(apiName == LOOPQUAL_BANDWIDTH_SERVICE){
                jsonBody = getLoopQualMaxBandwidthJsonString();
            }

            response.setBody(jsonBody);
            response.setStatusCode(200);
        }
        // If the HttpRequest is null then set the status code as 400 and send nul; response body
        else {
            response.setBody(jsonBody);
            response.setStatusCode(400);
        }
        return response;
    }
    private String getMarketingBoundaryServiceJsonString(){
         String json='{'+
		'  "parcelMarketingBoundary": {'+
		'    "marketingBoundaryName": "Test",'+
		'    "marketingBoundaryId": 0,'+
		'    "parcels": null,'+
		'    "childMarketingBoundaries": null'+
		'  },'+
		'  "requestId": "12c2b2d4-d15d-4b51-8a86-ab4e3cbd2587",'+
		'  "errorMessage": null'+
		'}';
         return json;
     }

    private String getBIWServiceJsonString(){
        String json='{'+
		'"errCode": null,'+
		'"errMessage": null,'+
		'"id": "19",'+
		'"status": "IN SERVICE",'+
		'"reason": null,'+
		'"availabiltyDate": "2022-06-30",'+
		'"bandwidth": "1000",'+
		'"servingWireCenterClli": "WNGRFLXA",'+
		'"servingWireCenterName": "WINTER GARDEN",'+
		'"fiberCableId": "7.20591135116382e+1",'+
		'"fiberLowStrand": "10",'+
		'"fiberHighStrand": null,'+
		'"nDSJobNbr": "N",'+
		'"fWRKSJobNbr": "N",'+
		'"serviceType": "BIWF",'+
		'"digitalVoiceEnabled": false,'+
		'"ndsjobNbr": "N",'+
		'"fwrksjobNbr": "N"'+
		'}';
        return json;
    }
    private String getLoopQualJsonString(){
        String json=		'{"success":true,'+
		'"status":null,'+
		'"referenceNumber":"570478ab-186d-917b-cb0d-42393ca163d3",'+
		'"qualificationResult":"SUCCESS",'+
		'"overallStatusMsg":null,'+
		'"overallStatusCode":null,'+
		'"qualifiedServices":['+
		'{'+
		'"serviceCategory":"DATA",'+
		'"serviceCharacteristic":['+
		'{'+
		'"name":"downSpeed",'+
		'"value":"140",'+
		'"uom":"Mbps"},'+
		'{'+
		'"name":"upSpeed",'+
		'"value":"20",'+
		'"uom":"Mbps"},'+
		'{'+
		'"name":"Technology",'+
		'"value":"V2V-PB",'+
		'"uom":""'+
		'},'+
		'{'+
		'"name":"prismSupported",'+
		'"value":"false",'+
		'"uom":""'+
		'},'+
		'{'+
		'"name":"dhpSupported",'+
		'"value":"true",'+
		'"uom":""}'+
		']'+
		'},'+
		'{'+
		'"serviceCategory": "",'+
		'"ref":""}'+
		'],'+
		'"reasonForUnQualified":""'+
		'}';
        return json;
    }
     
    /**********************************************************************************************
    Purpose: To get the mock response json string for parcel service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    17/12/2021   ESCJ-364      Initial draft
    ***********************************************************************************************/
    private String getParcelServiceJsonString() {
        return '{\"parcels\":[{\"parcelId\":\"1019589032\",\"stateCode\":\"31\",\"countyCode\":\"109\",\"apn\":\"1628100014000\",\"apn2\":\"77063\",\"address\":\"6001 YANKEE HILL RD\",' +
        '\"city\":\"LINCOLN\",\"state\":\"NE\",\"zipCode\":\"68516\",\"zipPlusFour\":\"\",\"standardAddress\":\"6001 YANKEE HILL RD\",\"standardCity\":\"LINCOLN\",\"standardZipCode\":\"68516\",' +
        '\"standardZipPlusFour\":\"9419\",\"fipsCode\":\"31109\",\"unformattedApn\":\"1628100014000\",\"apnSequenceNumber\":\"1\",\"formattedApn\":\"16-28-100-014-000\",' +
        '\"originalApn\":\"16-28-100-014-000\",\"accountNumber\":\"1155924\",\"thomasBrosMapNumber\":\"\",\"mapRef1\":\"\",\"mapRef2\":\"\",\"censusTract\":\"0037201014\",\"blockNumber\":\"\",' +
        '\"lotNumber\":\"103\",\"range\":\"07\",\"township\":\"09\",\"section\":\"28\",\"quarterSection\":\"\",\"landUse\":\"100\",\"mobileHomeIndicator\":\"\",\"zoning\":\"AGR\",' +
        '\"propertyIndicator\":\"10\",\"subdivisionTractNumber\":\"\",\"subdivisionPlatBook\":\"\",\"subdivisionPlatPage\":\"\",\"subdivisionName\":\"GRANTPRECINCT\",\"ownerCorporateIndicator\":\"\",' +
        '\"owner1LastName\":\"CANADAY\",\"owner1FirstName\":\"HEATHERMARIE\",\"owner2LastName\":\"\",\"owner2FirstName\":\"\",\"mailHouseNumberPrefix\":\"\",\"mailHouseNumber\":\"6001\",' +
        '\"mailHouseNumber2\":\"\",\"mailHouseNumberSuffix\":\"\",\"mailDirection\":\"\",\"mailStreetName\":\"YANKEE HILL\",\"mailMode\":\"RD\",\"mailQuadrant\":\"\",\"mailUnitNumber\":\"\",' +
        '\"mailCity\":\"LINCOLN\",\"mailState\":\"NE\",\"mailZipCode\":\"685169419\",\"mailCarrierCode\":\"R009\",\"mailingOptOutCode\":\"\",\"totalValue\":\"865500\",\"landValue\":\"250000\",' +
        '\"improvementValue\":\"615500\",\"totalValueCalculatedIndicator\":\"A\",\"landValueCalculatedIndicator\":\"A\",\"assessedTotalValue\":\"865500\",\"assessedLandValue\":\"250000\",' +
        '\"assessedImprovementValue\":\"615500\",\"marketTotalValue\":\"865500\",\"marketLandValue\":\"250000\",\"marketImprovementValue\":\"615500\",\"appraisedTotalValue\":\"0\",' +
        '\"appraisedLandValue\":\"0\",\"appraisedImprovementValue\":\"0\",\"taxAmount\":\"14131.52\",\"taxYear\":\"2019\",\"assessedYear\":\"2019\",\"taxCodeArea\":\"0005\",\"documentNumber\":\"37809\",' +
        '\"bookAndPage\":\"\",\"frontFootage\":\"0\",\"depthFootage\":\"0\",\"acres\":\"20.14\",\"landSquareFootage\":\"877298\",\"lotArea\":\"\",\"universalBuildingSquareFeet\":\"4514\",' +
        '\"buildingSquareFeetIndicator\":\"L\",\"buildingSquareFeet\":\"5452\",\"livingSquareFeet\":\"4514\",\"groundFloorSquareFeet\":\"2488\",\"grossSquareFeet\":\"0\",\"adjustedGrossSquareFeet\":\"0\",' +
        '\"basementSquareFeet\":\"2309\",\"parkingSquareFeet\":\"529\",\"yearBuilt\":\"1981\",\"effectiveYearBuilt\":\"0\",\"bedrooms\":\"3\",\"totalRooms\":\"0\",\"totalBathsCalculated\":\"4\",' +
        '\"totalBaths\":\"4\",\"fullBaths\":\"3\",\"halfBaths\":\"1\",\"quarterBaths\":\"0\",\"threeQuarterBaths\":\"0\",\"bathFixtures\":\"11\",\"airConditioning\":\"001\",\"basementFinish\":\"FFI\",' +
        '\"buildingCode\":\"\",\"buildingImprovementCode\":\"\",\"condition\":\"VGO\",\"constructionType\":\"\",\"exteriorWalls\":\"FSD\",\"fireplaceIndicator\":\"Y\",\"fireplaceNumber\":\"2\",' +
        '\"fireplaceType\":\"0U0\",\"foundation\":\"001\",\"frame\":\"\",\"floor\":\"\",\"garage\":\"450\",\"heating\":\"WA0\",\"parkingSpaces\":\"2\",\"parkingType\":\"450\",\"pool\":\"Y\",' +
        '\"poolCode\":\"0V0\",\"quality\":\"QGO\",\"roofCover\":\"015\",\"roofType\":\"G00\",\"storiesCode\":\"015\",\"storiesNumber\":\"1.5\",\"view\":\"\",\"locationInfluence\":\"\",\"numberOfUnits\":\"1\",' +
        '\"unitsNumber\":\"0\",\"energyUse\":\"\",\"fuel\":\"\",\"sewer\":\"\",\"water\":\"\",\"legalDescription1\":\"S28,T9,R7,6THPRINCIPALMERIDIAN,LOT103NW\",\"legalDescription2\":\"\",\"legalDescription3\":\"\",' +
        '\"latitude\":\"40.72445911093\",\"longitude\":\"-96.6389346791281\"}],\"totalParcels\":1,\"requestId\":\"493b1839-f46c-446f-977e-aff6a14904ab\",\"errorMessage\":null}';
    }

    /**********************************************************************************************
    Purpose: To get the mock response json string for addressTelco service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     20/12/2021   ESCJ-363      Initial draft
    ***********************************************************************************************/
    private String getAddressTelcoServiceResJsonString(){
        return '{\"serviceStatus\": \"Completed\", \"version\": \"1\", \"trackingId\": \"f7c41d9a-e166-414e-a23c-1600fbc51bda\",\"overallDuration\": 3078.1,   \"result\": \"Found\",   \"wireCenter\": {\"clli8\": \"AURRCOMA_1\", \"clli8Source\": \"GEO\",\"primaryNpa\": {\"code\": \"303\"},'+
            '\"primaryNxx\": {\"code\": \"340\"},\"networkEntites\": [{\"clli11\": \"AURRCOMADS0\"}],\"inRegion\": \"true\",\"location\": {\"address\": {\"streetAddress\":\"1420 IOLA ST\",\"locality\": \"AURORA\",\"stateOrProvince\":\"CO\",\"postCode\": \"80010\",\"country\": {\"iso3AlphaCode\": \"USA\"} }, \"geoPointDetail\": {\"gpsCoordinate\":'+
            '{\"source\": \"LOSDB\",\"latitudeCoordinate\": 39.739192,\"longitudeCoordinate\": -104.864619},\"vhCoordinate\":{\"vCoordinate\": 7495.3137924974, \"hCoordinate\": 5877.5366852698}}},\"lata\": \"656\",\"lataName\": \"DENVER CO\",'+
            '\"region\": \"QL\",\"ocnList\": [{\"ocnCode\": \"5102\",\"ocnName\": \"QWEST CORPORATION - CO\", \"ocnType\": \"RBOC\", \"parentOcnCode\": \"9636\"}]},\"fiberDistanceFeet\": {\"long\": \"666\",\"short\": \"471\"},\"vhCoordinate\": {\"vCoordinate\": 7499.485917529,\"hCoordinate\": 5879.2445698871}}';
    }

    /**********************************************************************************************
    Purpose: To get the mock response json string for 1GEnabled service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak     20/12/2021   ESCJ-363      Initial draft
    ***********************************************************************************************/
    private String get1GEnabledServiceResJsonString(){
        return '{\"status\": \"Success\",\"statusMsg\": null,\"wirecenterclli\": \"DNVRCOMA\",\"network\": \"QWEST\",\"requestId\": \"100\",\"messageSrcSystem\": \"BM\",\"gigEnabledStatus\": \"TRUE\"}';
    }

    /**********************************************************************************************
    Purpose: To get the mock response json string for Get Infrastructure Layers service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    17/12/2021   ESCJ-364      Initial draft
    ***********************************************************************************************/
    private String getInfrastructureServiceJsonString() {
        return '{\"status\":\"success\",\"message\":null,\"payload\":{\"infrastructureLayers\":[\"Green LCR Capable MH HH\",' +
        '\"Green LCR Capable Route\",\"Green LCR Capable SpliceClosure\",\"Green Leased Routes\",\"Green Owned Metro_Laterals\",' +
        '\"Green Route_all routes\",\"Red LCR Capable MH HH\",\"Red LCR Capable Route\",\"Red LCR Capable Splice Closure\",\"Red Leased Routes\",' +
        '\"Red Owned Metro_Laterals\",\"Red Route_all routes\",\"ScratchPadLine\",\"ScratchPadPoint\",\"ScratchPadPolygon\"]}}';
    }

    /**********************************************************************************************
    Purpose: To get the mock response json string for Service Availability Endpoint service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    17/12/2021   ESCJ-364      Initial draft
    ***********************************************************************************************/
    private String getServiceAvailabilityServiceJsonString() {
        return '{\"success\":true,\"status\":{\"statusCode\":\"200\",\"reasonCode\":\"\",\"message\":\"Success\"},\"referenceNumber\":\"ORN-9728877146748472\",' +
        '\"qualificationResult\":null,\"serviceAddress\":null,\"qualifiedServices\":null,\"detailQualification\":null,\"unqualifiedMessages\":null,' +
        '\"unifiedQualResponse\":{\"errCode\":\"0\",\"errMessage\":null,\"id\":\"10\",\"status\":\"IN SERVICE\",\"reason\":null,\"availabiltyDate\":\"2019-04-06\",\"bandwidth\":\"1000\",' +
        '\"servingWireCenterClli\":\"AURRCOMA\",\"servingWireCenterName\":\"AURORA\",\"fiberCableId\":\"6.81178364301576e+18\",\"fiberLowStrand\":\"16\",' +
        '\"fiberHighStrand\":\"27\",\"serviceType\":\"GFAST\",\"ndsjobNbr\":\"N.467698\",\"fwrksjobNbr\":\"UNSET00000\",\"routeToBIWF\":true},\"leadDisposition\":\"No\",\"isRooftop\":true}';
    }

    /**********************************************************************************************
    Purpose: To get the mock response json string for GEOES service Adresses service
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    private String getGeoesServiceAddressesJsonString() {
        return '{\"serviceStatus\":\"Completed\",\"version\":\"1\",\"trackingId\":\"4f8c70a2-1ac1-4d2a-8ab8-864805149390\",\"overallDuration\":11265.7,\"result\":\"Found\",' +
        '\"isResponseFromCache\":false,\"exactMatches\":[{\"streetAddress\":\"22 E MONUMENT ST\",\"streetNrFirst\":\"22\",\"streetName\":\"E MONUMENT ST\",' +
        '\"locality\":\"COLORADO SPRINGS\",\"stateOrProvince\":\"CO\",\"postCode\":\"80903\",\"source\":\"LFACS\",\"sourceId\":\"CLSPCOMA1K58R\",\"geoAddressId\":\"207629804\",' +
        '\"isMdu\":false,\"isNoBuild\":false,\"isExactToInput\":true,\"subAddress\":{\"geoSubAddressId\":\"0\"},\"geoPointDetails\":[{\"gpsCoordinate\":{\"source\":\"Trillium\",' +
        '\"latitudeCoordinate\":38.844081,\"longitudeCoordinate\":-104.823631,\"resolutionLevel\":\"1\",\"coordinateAccuracy\":\"2\"},\"vhCoordinate\":{\"vCoordinate\":7678.5777818747,' +
        '\"hCoordinate\":5814.298108866}}],\"wireCenter\":{\"clli8\":\"CLSPCOMA\",\"clli8Source\":\"LFACS\"},\"attributes\":{\"cala\":\"SCO\",\"legacyProvider\":\"QWEST COMMUNICATIONS\",' +
        '\"rateCenter\":{\"name\":\"COLORDOSPG\"},\"rateZone\":\"01\",\"taxCode\":\"CO2002\",\"tta\":\"471\",\"exchangeCode\":\"COL\",\"trs\":\"CO 014S 066W 007\"}}]}';
    }

    // public static final String TEST_GREEN_ADDRESS = '22 E MONUMENT ST';
    // public static final String TEST_GREEN_CITY = 'COLORADO SPRINGS';
    // public static final String TEST_GREEN_STATE = 'CO';

    // private String getGeoesServiceAddressesValidationJsonString() {
    //     return JSON.serialize(
    //         new Map<String, Object>{
    //             'serviceStatus' => 'Completed',
    //             'version' => '1',
    //             'trackingId' => '4f8c70a2-1ac1-4d2a-8ab8-864805149390',
    //             'overallDuration' => 11265.7,
    //             'result' => 'Green',
    //             'isResponseFromCache' => false,
    //             'exactMatches' => new List<Map<String, Object>>{
    //                 new Map<String, Object>{
    //                     'streetAddress' => TEST_GREEN_ADDRESS,
    //                     'streetNrFirst' => '22',
    //                     'streetName' => 'E MONUMENT ST',
    //                     'locality' => TEST_GREEN_CITY,
    //                     'stateOrProvince' => TEST_GREEN_STATE,
    //                     'postCode' => '80903',
    //                     'source' => 'LFACS',
    //                     'sourceId' => 'CLSPCOMA1K58R',
    //                     'geoAddressId' => '207629804',
    //                     'isMdu' => false,
    //                     'isNoBuild' => false,
    //                     'isExactToInput' => true,
    //                     'subAddress' => new Map<String, Object>{
    //                         'geoSubAddressId' => '0'
    //                     },
    //                     'geoPointDetails' => new List<Map<String, Object>>{
    //                         new Map<String, Object>{
    //                             'gpsCoordinate' => new Map<String, Object>{
    //                                 'source' => 'Trillium',
    //                                 'latitudeCoordinate' => 38.844081,
    //                                 'longitudeCoordinate' => -104.823631,
    //                                 'resolutionLevel' => '1',
    //                                 'coordinateAccuracy' => '2'
    //                             },
    //                             'vhCoordinate' => new Map<String, Object>{
    //                                 'vCoordinate' => 7678.5777818747,
    //                                 'hCoordinate' => 5814.298108866
    //                             }
    //                         }
    //                     },
    //                     'wireCenter' => new Map<String, Object>{
    //                         'clli8' => 'CLSPCOMA',
    //                         'clli8Source' => 'LFACS'
    //                     },
    //                     'attributes' => new Map<String, Object>{
    //                         'cala' => 'SCO',
    //                         'legacyProvider' => 'QWEST COMMUNICATIONS',
    //                         'rateCenter' => new Map<String, Object>{
    //                             'name' => 'COLORDOSPG'
    //                         },
    //                         'rateZone' => '01',
    //                         'taxCode' => 'CO2002',
    //                         'tta' => '471',
    //                         'exchangeCode' => 'COL',
    //                         'trs' => 'CO 014S 066W 007'
    //                     }
    //                 }
    //             },
    //             'nearMatches' => new List<Map<String, Object>>{
    //                 new Map<String, Object>{
    //                     'streetAddress' => TEST_GREEN_ADDRESS,
    //                     'streetNrFirst' => '22',
    //                     'streetName' => 'E MONUMENT ST',
    //                     'locality' => TEST_GREEN_CITY,
    //                     'stateOrProvince' => TEST_GREEN_STATE,
    //                     'postCode' => '80903',
    //                     'source' => 'LFACS',
    //                     'sourceId' => 'CLSPCOMA1K58R',
    //                     'geoAddressId' => '207629804',
    //                     'isMdu' => false,
    //                     'isNoBuild' => false
    //                 }
    //             }
    //         }
    //     );
    // }

    /**********************************************************************************************
    Purpose: To get the mock response json string for GEOES Service Adressses validation service
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    private String getGeoesServiceAddressesValidationJsonString() {
        return '{\"serviceStatus\":\"Completed\",\"version\":\"1\",\"trackingId\":\"a414bbe0-e946-419f-8e11-f60192cac005\",\"overallDuration\":9736.1,\"result\":\"Yellow\",\"isResponseFromCache\":false,' +
        '\"nearMatches\":[{\"streetAddress\":\"22ECOLORADOAVE\",\"streetNrFirst\":\"22\",\"streetName\":\"ECOLORADOAVE\",\"locality\":\"COLORADOSPRINGS\",\"stateOrProvince\":\"CO\",\"postCode\":\"80903\",' +
        '\"source\":\"LFACS\",\"sourceId\":\"CLSPCOMA10EA7\",\"geoAddressId\":\"207629704\",\"isNoBuild\":false},{\"streetAddress\":\"22EBIJOUST\",\"streetNrFirst\":\"22\",\"streetName\":\"EBIJOUST\",' +
        '\"locality\":\"COLORADOSPRINGS\",\"stateOrProvince\":\"CO\",\"postCode\":\"80903\",\"source\":\"LFACS\",\"sourceId\":\"CLSPCOMA1JM021\",\"geoAddressId\":\"207629660\",\"isNoBuild\":false},' +
        '{\"streetAddress\":\"22EMONUMENTST\",\"streetNrFirst\":\"22\",\"streetName\":\"EMONUMENTST\",\"locality\":\"COLORADOSPRINGS\",\"stateOrProvince\":\"CO\",\"postCode\":\"80903\",' +
        '\"source\":\"LFACS\",\"sourceId\":\"CLSPCOMA1K58R\",\"geoAddressId\":\"207629804\",\"isNoBuild\":false}]}';
    }

    /**********************************************************************************************
    Purpose: To get the mock response json string for GEOAM service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    AMI     24/01/2022      ESCJ-425      Initial draft
    ***********************************************************************************************/
    private String getGEOAMResJsonString(){
        return '{\"serviceStatus\": \"Completed\", \"version\": \"1\", \"trackingId\": \"f7c41d9a-e166-414e-a23c-1600fbc51bda\",\"overallDuration\": 3078.1,   \"result\": \"Found\",   \"wireCenter\": {\"clli8\": \"AURRCOMA_1\", \"clli8Source\": \"GEO\",\"primaryNpa\": {\"code\": \"303\"},'+
            '\"primaryNxx\": {\"code\": \"340\"},\"networkEntites\": [{\"clli11\": \"AURRCOMADS0\"}],\"inRegion\": \"true\",\"location\": {\"address\": {\"streetAddress\":\"1420 IOLA ST\",\"locality\": \"AURORA\",\"stateOrProvince\":\"CO\",\"postCode\": \"80010\",\"country\": {\"iso3AlphaCode\": \"USA\"} }, \"geoPointDetail\": {\"gpsCoordinate\":'+
            '{\"source\": \"LOSDB\",\"latitudeCoordinate\": 39.739192,\"longitudeCoordinate\": -104.864619},\"vhCoordinate\":{\"vCoordinate\": 7495.3137924974, \"hCoordinate\": 5877.5366852698}}},\"lata\": \"656\",\"lataName\": \"DENVER CO\",'+
            '\"region\": \"QL\",\"ocnList\": [{\"ocnCode\": \"5102\",\"ocnName\": \"QWEST CORPORATION - CO\", \"ocnType\": \"RBOC\", \"parentOcnCode\": \"9636\"}]},\"fiberDistanceFeet\": {\"long\": \"666\",\"short\": \"471\"},\"vhCoordinate\": {\"vCoordinate\": 7499.485917529,\"hCoordinate\": 5879.2445698871}}';
    }
    private String getSolicitVerificationJsonString(){
        return  '{\"emailOptOut\": \"Y\",\"tnOptOut\": \"Y\",\"emailDivestetureOptOut\": \"Y\", \"nameDivestetureOptOut\": \"Y\"}';
    }
     private String getSolicitVerificationnJsonString(){
        return  '{\"emailOptOut\": \"N\",\"tnOptOut\": \"N\",\"emailDivestetureOptOut\": \"N\", \"nameDivestetureOptOut\": \"N\"}';
    }
     private String getSolicitVerificationnnJsonString(){
        return  '{\"emailOptOut\": \"Y\",\"tnOptOut\": \"Y\",\"emailDivestetureOptOut\": \"Y\", \"nameDivestetureOptOut\": \"N\"}';
    }
    private String getSolicitVerificationnnnJsonString(){
        return  '{\"emailOptOut\": \"Y\",\"tnOptOut\": \"Y\",\"emailDivestetureOptOut\": \"N\", \"nameDivestetureOptOut\": \"N\"}';
    }
    private String getLoopQualMaxBandwidthJsonString(){
        return  '{' +
				'\"maxQualifiedSpeeds\": {' +
				'    \"ipSpeeds\": [' +
				'        {' +
				'            \"niiCode\": \"FTTN-ETH-A2P\",' +
				'            \"upSpeed\": \"750\",' +
				'            \"downspeed\": \"1500\"' +
				'        },' +
				'        {' +
				'            \"niiCode\": \"FTTN-ETH-V2-PB\",' +
				'            \"upSpeed\": \"10000\",' +
				'            \"downspeed\": \"800\"' +
				'        },' +
				'        {' +
				'            \"niiCode\": \"FTTN-ETH-V2\",' +
				'            \"upSpeed\": \"3000\",' +
				'            \"downspeed\": \"400\"' +
				'        }' +
				'    ]' +
				'}' +
				'}';
    }
}