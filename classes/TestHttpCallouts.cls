/***************************************************************************************************************
 * Description: Test class for TestHttpCallouts
 * *************************************************************************************************************
 * Change History:
 * Date         Person Responsible      Traceability	Details    
 * 10/19/2022   Kuehl                   ESCJ-1968       Used in API Test class
****************************************************************************************************************/
@isTest public class TestHttpCallouts implements HttpCalloutMock 
{
    public static Boolean fakeAuthfail = false;
    public static Boolean fakeServiceFail = false;
    public static Integer simulatedSearchResultSize = 0;
    public static String  serviceResponseBody;
    
    public HttpResponse respond(HttpRequest request) 
    {        
        HttpResponse response = new HttpResponse();
        response.setStatus('OK');
        response.setStatusCode(200);

        if(request.getEndpoint().contains('AgiloftContractCreate'))
        { 
            string jsonResponse = 'TEST... A new CLM contract record is being created. Once complete you will receive an email with a link to the contract record in the CLM Contract System.';
            response.setBody(jsonResponse);
        }
        else if(request.getEndpoint().contains('solicitVerification/tnOptOutCheck'))
        { 
            string jsonResponse =  '{\"emailOptOut\": \"Y\",\"tnOptOut\": \"Y\",\"emailDivestetureOptOut\": \"Y\", \"nameDivestetureOptOut\": \"Y\"}';
            response.setBody(jsonResponse);
        }
		 else if(request.getEndpoint().contains('solicitVerification/nameOptOutCheck'))
        { 
            string jsonResponse =  '{\"emailOptOut\": \"Y\",\"tnOptOut\": \"Y\",\"emailDivestetureOptOut\": \"Y\", \"nameDivestetureOptOut\": \"Y\"}';
            response.setBody(jsonResponse);
        }
        
        
       /* else if(request.getEndpoint().contains('SolicitVerificationn'))
        { 
            string jsonResponse =  '{\"emailOptOut\": \"N\",\"tnOptOut\": \"N\",\"emailDivestetureOptOut\": \"N\", \"nameDivestetureOptOut\": \"N\"}';
            response.setBody(jsonResponse);
        }
        else if(request.getEndpoint().contains('SolicitVerificationnn'))
        { 
            string jsonResponse =  '{\"emailOptOut\": \"Y\",\"tnOptOut\": \"Y\",\"emailDivestetureOptOut\": \"Y\", \"nameDivestetureOptOut\": \"N\"}';
            response.setBody(jsonResponse);
        }
        else if(request.getEndpoint().contains('SolicitVerificationnnn'))
        { 
            string jsonResponse =  '{\"emailOptOut\": \"Y\",\"tnOptOut\": \"Y\",\"emailDivestetureOptOut\": \"N\", \"nameDivestetureOptOut\": \"N\"}';
            response.setBody(jsonResponse);
        }
		*/
        else if(request.getEndpoint().contains('parcel/point') || request.getEndpoint().contains('parcel/address') )
        {             
            string jsonResponse =  '{\"parcels\":[{\"parcelId\":\"1019589032\",\"stateCode\":\"31\",\"countyCode\":\"109\",\"apn\":\"1628100014000\",\"apn2\":\"77063\",\"address\":\"6001 YANKEE HILL RD\",' +
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
            response.setBody(jsonResponse);
        }
        else if(request.getEndpoint().contains('addressesTelcoAttributes'))
        {             
            string jsonResponse =  '{\"serviceStatus\": \"Completed\", \"version\": \"1\", \"trackingId\": \"f7c41d9a-e166-414e-a23c-1600fbc51bda\",\"overallDuration\": 3078.1,   \"result\": \"Found\",   \"wireCenter\": {\"clli8\": \"AURRCOMA_1\", \"clli8Source\": \"GEO\",\"primaryNpa\": {\"code\": \"303\"},'+
            '\"primaryNxx\": {\"code\": \"340\"},\"networkEntites\": [{\"clli11\": \"AURRCOMADS0\"}],\"inRegion\": \"true\",\"location\": {\"address\": {\"streetAddress\":\"1420 IOLA ST\",\"locality\": \"AURORA\",\"stateOrProvince\":\"CO\",\"postCode\": \"80010\",\"country\": {\"iso3AlphaCode\": \"USA\"} }, \"geoPointDetail\": {\"gpsCoordinate\":'+
            '{\"source\": \"LOSDB\",\"latitudeCoordinate\": 39.739192,\"longitudeCoordinate\": -104.864619},\"vhCoordinate\":{\"vCoordinate\": 7495.3137924974, \"hCoordinate\": 5877.5366852698}}},\"lata\": \"656\",\"lataName\": \"DENVER CO\",'+
            '\"region\": \"QL\",\"ocnList\": [{\"ocnCode\": \"5102\",\"ocnName\": \"QWEST CORPORATION - CO\", \"ocnType\": \"RBOC\", \"parentOcnCode\": \"9636\"}]},\"fiberDistanceFeet\": {\"long\": \"666\",\"short\": \"471\"},\"vhCoordinate\": {\"vCoordinate\": 7499.485917529,\"hCoordinate\": 5879.2445698871}}';
            response.setBody(jsonResponse);
        }
        else if(request.getEndpoint().contains('oneGEnabledStatus'))
        {             
            string jsonResponse =  '{\"status\": \"Success\",\"statusMsg\": null,\"wirecenterclli\": \"DNVRCOMA\",\"network\": \"QWEST\",\"requestId\": \"100\",\"messageSrcSystem\": \"BM\",\"gigEnabledStatus\": \"TRUE\"}';
            response.setBody(jsonResponse);
        }
        else if(request.getEndpoint().contains('infrastructureLayers'))
        {             
            string jsonResponse =  '{\"status\":\"success\",\"message\":null,\"payload\":{\"infrastructureLayers\":[\"Green LCR Capable MH HH\",' +
            '\"Green LCR Capable Route\",\"Green LCR Capable SpliceClosure\",\"Green Leased Routes\",\"Green Owned Metro_Laterals\",' +
            '\"Green Route_all routes\",\"Red LCR Capable MH HH\",\"Red LCR Capable Route\",\"Red LCR Capable Splice Closure\",\"Red Leased Routes\",' +
            '\"Red Owned Metro_Laterals\",\"Red Route_all routes\",\"ScratchPadLine\",\"ScratchPadPoint\",\"ScratchPadPolygon\"]}}';
            response.setBody(jsonResponse);
        }
        else if(request.getEndpoint().contains('performUnifiedQual'))
        {             
            string jsonResponse =  '{\"success\":true,\"status\":{\"statusCode\":\"200\",\"reasonCode\":\"\",\"message\":\"Success\"},\"referenceNumber\":\"ORN-9728877146748472\",' +
            '\"qualificationResult\":null,\"serviceAddress\":null,\"qualifiedServices\":null,\"detailQualification\":null,\"unqualifiedMessages\":null,' +
            '\"unifiedQualResponse\":{\"errCode\":\"0\",\"errMessage\":null,\"id\":\"10\",\"status\":\"IN SERVICE\",\"reason\":null,\"availabiltyDate\":\"2019-04-06\",\"bandwidth\":\"1000\",' +
            '\"servingWireCenterClli\":\"AURRCOMA\",\"servingWireCenterName\":\"AURORA\",\"fiberCableId\":\"6.81178364301576e+18\",\"fiberLowStrand\":\"16\",' +
            '\"fiberHighStrand\":\"27\",\"serviceType\":\"GFAST\",\"ndsjobNbr\":\"N.467698\",\"fwrksjobNbr\":\"UNSET00000\",\"routeToBIWF\":true},\"leadDisposition\":\"No\",\"isRooftop\":true}';
            response.setBody(jsonResponse);
        }
        else if(request.getEndpoint().contains('serviceAddresses'))
        {             
            string jsonResponse =  '{\"serviceStatus\":\"Completed\",\"version\":\"1\",\"trackingId\":\"4f8c70a2-1ac1-4d2a-8ab8-864805149390\",\"overallDuration\":11265.7,\"result\":\"Found\",' +
            '\"isResponseFromCache\":false,\"exactMatches\":[{\"streetAddress\":\"22 E MONUMENT ST\",\"streetNrFirst\":\"22\",\"streetName\":\"E MONUMENT ST\",' +
            '\"locality\":\"COLORADO SPRINGS\",\"stateOrProvince\":\"CO\",\"postCode\":\"80903\",\"source\":\"LFACS\",\"sourceId\":\"CLSPCOMA1K58R\",\"geoAddressId\":\"207629804\",' +
            '\"isMdu\":false,\"isNoBuild\":false,\"isExactToInput\":true,\"subAddress\":{\"geoSubAddressId\":\"0\"},\"geoPointDetails\":[{\"gpsCoordinate\":{\"source\":\"Trillium\",' +
            '\"latitudeCoordinate\":38.844081,\"longitudeCoordinate\":-104.823631,\"resolutionLevel\":\"1\",\"coordinateAccuracy\":\"2\"},\"vhCoordinate\":{\"vCoordinate\":7678.5777818747,' +
            '\"hCoordinate\":5814.298108866}}],\"wireCenter\":{\"clli8\":\"CLSPCOMA\",\"clli8Source\":\"LFACS\"},\"attributes\":{\"cala\":\"SCO\",\"legacyProvider\":\"QWEST COMMUNICATIONS\",' +
            '\"rateCenter\":{\"name\":\"COLORDOSPG\"},\"rateZone\":\"01\",\"taxCode\":\"CO2002\",\"tta\":\"471\",\"exchangeCode\":\"COL\",\"trs\":\"CO 014S 066W 007\"}}]}';
            response.setBody(jsonResponse);
        }
        else if(request.getEndpoint().contains('serviceAddressesValidations'))
        {             
            string jsonResponse =  '{\"serviceStatus\":\"Completed\",\"version\":\"1\",\"trackingId\":\"a414bbe0-e946-419f-8e11-f60192cac005\",\"overallDuration\":9736.1,\"result\":\"Yellow\",\"isResponseFromCache\":false,' +
            '\"nearMatches\":[{\"streetAddress\":\"22ECOLORADOAVE\",\"streetNrFirst\":\"22\",\"streetName\":\"ECOLORADOAVE\",\"locality\":\"COLORADOSPRINGS\",\"stateOrProvince\":\"CO\",\"postCode\":\"80903\",' +
            '\"source\":\"LFACS\",\"sourceId\":\"CLSPCOMA10EA7\",\"geoAddressId\":\"207629704\",\"isNoBuild\":false},{\"streetAddress\":\"22EBIJOUST\",\"streetNrFirst\":\"22\",\"streetName\":\"EBIJOUST\",' +
            '\"locality\":\"COLORADOSPRINGS\",\"stateOrProvince\":\"CO\",\"postCode\":\"80903\",\"source\":\"LFACS\",\"sourceId\":\"CLSPCOMA1JM021\",\"geoAddressId\":\"207629660\",\"isNoBuild\":false},' +
            '{\"streetAddress\":\"22EMONUMENTST\",\"streetNrFirst\":\"22\",\"streetName\":\"EMONUMENTST\",\"locality\":\"COLORADOSPRINGS\",\"stateOrProvince\":\"CO\",\"postCode\":\"80903\",' +
            '\"source\":\"LFACS\",\"sourceId\":\"CLSPCOMA1K58R\",\"geoAddressId\":\"207629804\",\"isNoBuild\":false}]}';
            response.setBody(jsonResponse);
        }
		else if(request.getEndpoint().contains('addressmatch/addresses'))
        {             
            string jsonResponse =  '{\"serviceStatus\": \"Completed\", \"version\": \"1\", \"trackingId\": \"f7c41d9a-e166-414e-a23c-1600fbc51bda\",\"overallDuration\": 3078.1,   \"result\": \"Found\",   \"wireCenter\": {\"clli8\": \"AURRCOMA_1\", \"clli8Source\": \"GEO\",\"primaryNpa\": {\"code\": \"303\"},'+
            '\"primaryNxx\": {\"code\": \"340\"},\"networkEntites\": [{\"clli11\": \"AURRCOMADS0\"}],\"inRegion\": \"true\",\"location\": {\"address\": {\"streetAddress\":\"1420 IOLA ST\",\"locality\": \"AURORA\",\"stateOrProvince\":\"CO\",\"postCode\": \"80010\",\"country\": {\"iso3AlphaCode\": \"USA\"} }, \"geoPointDetail\": {\"gpsCoordinate\":'+
            '{\"source\": \"LOSDB\",\"latitudeCoordinate\": 39.739192,\"longitudeCoordinate\": -104.864619},\"vhCoordinate\":{\"vCoordinate\": 7495.3137924974, \"hCoordinate\": 5877.5366852698}}},\"lata\": \"656\",\"lataName\": \"DENVER CO\",'+
            '\"region\": \"QL\",\"ocnList\": [{\"ocnCode\": \"5102\",\"ocnName\": \"QWEST CORPORATION - CO\", \"ocnType\": \"RBOC\", \"parentOcnCode\": \"9636\"}]},\"fiberDistanceFeet\": {\"long\": \"666\",\"short\": \"471\"},\"vhCoordinate\": {\"vCoordinate\": 7499.485917529,\"hCoordinate\": 5879.2445698871}}';
            response.setBody(jsonResponse);
        }       
        else if(request.getEndpoint().contains('biwLatLong'))
        {             
            string jsonResponse =  '{'+
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
            response.setBody(jsonResponse);
        }  
        else if(request.getEndpoint().contains('findAvailableServices'))
        {             
            string jsonResponse =  '{"success":true,'+
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
            response.setBody(jsonResponse);
        }  
                
        /*
		else if(request.getEndpoint().contains('test-emp')) 
        {
            response.setBody('<?xml version="1.0" encoding="UTF-8" standalone="yes"?><level3Response><messages><message><correlationId>EMP-201404042330490630157</correlationId><messageId>EMP-201404042330490630157</messageId><responseTime>58ms</responseTime></message></messages></level3Response>');
            response.setHeader('Content-Length','265');
            response.setHeader('Content-Type','application/xml');
            response.setHeader('Date',DateTime.now().format());
            response.setHeader('Server','Apache-Coyote/1.1');                
        }
        else if(request.getEndpoint().contains('test-edp')) 
        {
            response.setBody('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+
                        '<level3Response>'+
                        '       <document>'+
                        '          <documentHeader>'+
                        '                <documentId>0900459580097a78</documentId>'+
                        '                <documentType>LOACA</documentType>'+
                        '               <documentName>LOACA_customerNumber-1-NR32L</documentName>'+
                        '                <documentFolderSuffix>1-NR32L</documentFolderSuffix>'+
                        '                <documentOrigName>Indirect LOA - 1-NR32L - Access One Inc..pdf</documentOrigName>'+
                        '                <documentRepository>Enterprise</documentRepository>'+
                        '                <documentFormat>pdf</documentFormat>'+
                        '                <documentMimeType>application/pdf</documentMimeType>'+
                        '                <documentVersion>1.0</documentVersion>'+
                        '                <documentURL>http://document-test.level3.com:8080/DCF/Doc_Man?DMW_OBJECTID=0900459580097a78</documentURL>'+
                        '                <documentKeywords>LOACA</documentKeywords>'+
                        '                <documentUsername>l3svc.sfdc</documentUsername>'+
                        '                <documentApplicationKey>APPKEY120526761266843</documentApplicationKey>'+
                        '                <documentCreatedDate>2016-11-29T08:52:18.000Z</documentCreatedDate>'+
                        '               <documentLastUpdatedDate>2016-11-29T08:52:18.000Z</documentLastUpdatedDate>'+
                        '            </documentHeader>'+
                        '            <properties>'+
                        '                <property name="masterAgent" value="null"/>'+
                        '                <property name="agentReferralPartner" value="null"/>'+
                        '                <property name="loaSubmitterPhone" value="(123) 654-9876"/>'+
                        '                <property name="loaSubmitterName" value="john Doe"/>'+
                        '                <property name="loaSubmitterEmail" value="j.d@z.com"/>'+
                        '                <property name="loaSubmitDate" value="2016-11-29 13:32:54"/>'+
                        '                <property name="loaStatus" value="LOA signed"/>'+
                        '                <property name="loaRequestDate" value="null"/>'+
                        '                <property name="loaRequester" value="null"/>'+
                        '                <property name="customerNumber" value="1-NR32L"/>'+
                        '           </properties>'+
                        '        </document>'+
                        '</level3Response>');
        } 
        else if(request.getEndpoint().contains('invokeEslGetPriceSvc'))
        {
            string t = '';
            t += '<ESLPriceResponse xmlns="http://www.centurylink.com/XMLSchema/ESL">';
            t += '<ProcessStatus>SUCCESS</ProcessStatus>';
            t += '<PriceItemResponse>';
            t += '<LineGroupId>1</LineGroupId>';
            t += '<LineId>1</LineId>';
            t += '<LocationReferenceID>3511871</LocationReferenceID>';
            t += '<SourceItemCode>Special Access - CenturyLink Provided</SourceItemCode>';
            t += '<ItemAttributeList>';
            t += '<ItemAttribute>';
            t += '<Name>CARRIER_NM</Name>';
            t += '<Value>OHIO BELL TEL CO - OH</Value>';
            t += '</ItemAttribute>';
            t += '<ItemAttribute>';
            t += '<Name>LL_TRACK_ID</Name>';
            t += '<Value></Value>';
            t += '</ItemAttribute>';
            t += '</ItemAttributeList>';
            t += '<ItemPriceList>';
            t += '<MRCPrice>';
            t += '<ComponentCode>LOOP MRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>200.00</ItemListPrice>';
            t += '<ItemFinalPrice>200.00</ItemFinalPrice>';
            t += '</MRCPrice>';
            t += '<NRCPrice>';
            t += '<ComponentCode>LOOP NRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>75.00</ItemListPrice>';
            t += '<ItemFinalPrice>75.00</ItemFinalPrice>';
            t += '</NRCPrice>';
            t += '</ItemPriceList>';
            t += '<AppliedOMRList/>';
            t += '<PricingMessageList>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>930007</Code>';
            t += '<Message>lol</Message>';
            t += '<AdditionalMessage>lol</AdditionalMessage>';
            t += '</PricingMessage>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>801042</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>801049</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '</PricingMessageList>';
            t += '</PriceItemResponse>';
            t += '<PriceItemResponse>';
            t += '<LineGroupId>DS-1</LineGroupId>';
            t += '<LineId>1</LineId>';
            t += '<LocationReferenceID>3511871</LocationReferenceID>';
            t += '<SourceItemCode>Special Access - CenturyLink Provided</SourceItemCode>';
            t += '<ItemAttributeList>';
            t += '<ItemAttribute>';
            t += '<Name>CARRIER_NM</Name>';
            t += '<Value>OHIO BELL TEL CO - OH</Value>';
            t += '</ItemAttribute>';
            t += '<ItemAttribute>';
            t += '<Name>LL_TRACK_ID</Name>';
            t += '<Value></Value>';
            t += '</ItemAttribute>';
            t += '</ItemAttributeList>';
            t += '<ItemPriceList>';
            t += '<MRCPrice>';
            t += '<ComponentCode>LOOP MRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>200.00</ItemListPrice>';
            t += '<ItemFinalPrice>200.00</ItemFinalPrice>';
            t += '</MRCPrice>';
            t += '<NRCPrice>';
            t += '<ComponentCode>LOOP NRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>75.00</ItemListPrice>';
            t += '<ItemFinalPrice>75.00</ItemFinalPrice>';
            t += '</NRCPrice>';
            t += '</ItemPriceList>';
            t += '<AppliedOMRList/>';
            t += '<PricingMessageList>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>930007</Code>';
            t += '<Message>lol</Message>';
            t += '<AdditionalMessage>lol</AdditionalMessage>';
            t += '</PricingMessage>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>801042</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>801049</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '</PricingMessageList>';
            t += '</PriceItemResponse>';		
            t += '<PriceItemResponse>';
            t += '<LineGroupId>DS-3</LineGroupId>';
            t += '<LineId>2</LineId>';
            t += '<LocationReferenceID>3511871</LocationReferenceID>';
            t += '<SourceItemCode>Special Access - CenturyLink Provided</SourceItemCode>';
            t += '<ItemAttributeList>';
            t += '<ItemAttribute>';
            t += '<Name>CARRIER_NM</Name>';
            t += '<Value>OHIO BELL TEL CO - OH</Value>';
            t += '</ItemAttribute>';
            t += '<ItemAttribute>';
            t += '<Name>LL_TRACK_ID</Name>';
            t += '<Value></Value>';
            t += '</ItemAttribute>';
            t += '</ItemAttributeList>';
            t += '<ItemPriceList>';
            t += '<MRCPrice>';
            t += '<ComponentCode>LOOP MRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>1500.00</ItemListPrice>';
            t += '<ItemFinalPrice>1500.00</ItemFinalPrice>';
            t += '</MRCPrice>';
            t += '<NRCPrice>';
            t += '<ComponentCode>LOOP NRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>75.00</ItemListPrice>';
            t += '<ItemFinalPrice>75.00</ItemFinalPrice>';
            t += '</NRCPrice>';
            t += '</ItemPriceList>';
            t += '<AppliedOMRList/>';
            t += '<PricingMessageList>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>930007</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>801042</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>801049</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '</PricingMessageList>';
            t += '</PriceItemResponse>';
            t += '<PriceItemResponse>';
            t += '<LineGroupId>10M</LineGroupId>';
            t += '<LineId>3</LineId>';
            t += '<LocationReferenceID>3511871</LocationReferenceID>';
            t += '<SourceItemCode>ELA Native Single-CoS High - CenturyLink Provided</SourceItemCode>';
            t += '<ItemAttributeList>';
            t += '<ItemAttribute>';
            t += '<Name>CARRIER_NM</Name>';
            t += '<Value>OHIO BELL TEL CO - OH</Value>';
            t += '</ItemAttribute>';
            t += '<ItemAttribute>';
            t += '<Name>LL_TRACK_ID</Name>';
            t += '<Value></Value>';
            t += '</ItemAttribute>';
            t += '</ItemAttributeList>';
            t += '<ItemPriceList>';
            t += '<MRCPrice>';
            t += '<ComponentCode>LOOP MRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>616.00</ItemListPrice>';
            t += '<ItemFinalPrice>616.00</ItemFinalPrice>';
            t += '</MRCPrice>';
            t += '<NRCPrice>';
            t += '<ComponentCode>LOOP NRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>0.00</ItemListPrice>';
            t += '<ItemFinalPrice>0.00</ItemFinalPrice>';
            t += '</NRCPrice>';
            t += '</ItemPriceList>';
            t += '<AppliedOMRList/>';
            t += '<PricingMessageList>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>64044</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>801042</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>801049</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '</PricingMessageList>';
            t += '</PriceItemResponse>';
            t += '<PriceItemResponse>';
            t += '<LineGroupId>100M</LineGroupId>';
            t += '<LineId>4</LineId>';
            t += '<LocationReferenceID>3511871</LocationReferenceID>';
            t += '<SourceItemCode>ELA Native Single-CoS High - CenturyLink Provided</SourceItemCode>';
            t += '<ItemAttributeList>';
            t += '<ItemAttribute>';
            t += '<Name>CARRIER_NM</Name>';
            t += '<Value>OHIO BELL TEL CO - OH</Value>';
            t += '</ItemAttribute>';
            t += '<ItemAttribute>';
            t += '<Name>LL_TRACK_ID</Name>';
            t += '<Value></Value>';
            t += '</ItemAttribute>';
            t += '</ItemAttributeList>';
            t += '<ItemPriceList>';
            t += '<MRCPrice>';
            t += '<ComponentCode>LOOP MRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>1341.00</ItemListPrice>';
            t += '<ItemFinalPrice>1341.00</ItemFinalPrice>';
            t += '</MRCPrice>';
            t += '<NRCPrice>';
            t += '<ComponentCode>LOOP NRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>0.00</ItemListPrice>';
            t += '<ItemFinalPrice>0.00</ItemFinalPrice>';
            t += '</NRCPrice>';
            t += '</ItemPriceList>';
            t += '<AppliedOMRList/>';
            t += '<PricingMessageList>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>64044</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>801042</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '</PricingMessageList>';
            t += '</PriceItemResponse>';
            t += '<PriceItemResponse>';
            t += '<LineGroupId>1G</LineGroupId>';
            t += '<LineId>5</LineId>';
            t += '<LocationReferenceID>3511871</LocationReferenceID>';
            t += '<SourceItemCode>ELA Native Single-CoS High - CenturyLink Provided</SourceItemCode>';
            t += '<ItemAttributeList>';
            t += '<ItemAttribute>';
            t += '<Name>CARRIER_NM</Name>';
            t += '<Value>OHIO BELL TEL CO - OH</Value>';
            t += '</ItemAttribute>';
            t += '<ItemAttribute>';
            t += '<Name>LL_TRACK_ID</Name>';
            t += '<Value></Value>';
            t += '</ItemAttribute>';
            t += '</ItemAttributeList>';
            t += '<ItemPriceList>';
            t += '<MRCPrice>';
            t += '<ComponentCode>LOOP MRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>2776.00</ItemListPrice>';
            t += '<ItemFinalPrice>2776.00</ItemFinalPrice>';
            t += '</MRCPrice>';
            t += '<NRCPrice>';
            t += '<ComponentCode>LOOP NRC</ComponentCode>';
            t += '<ICBFlag>false</ICBFlag>';
            t += '<ItemListPrice>0.00</ItemListPrice>';
            t += '<ItemFinalPrice>0.00</ItemFinalPrice>';
            t += '</NRCPrice>';
            t += '</ItemPriceList>';
            t += '<AppliedOMRList/>';
            t += '<PricingMessageList>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>64044</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '<PricingMessage>';
            t += '<Status>INFO</Status>';
            t += '<Code>801042</Code>';
            t += '<Message>lol</Message>';
            t += '</PricingMessage>';
            t += '</PricingMessageList>';
            t += '</PriceItemResponse>';
            t += '</ESLPriceResponse>';
            response.setBody(t);
        } 
        else if(request.getEndpoint().contains('invokeEslPreferredProvidersSvcSFDC'))
        {
            CPQ_ESL_REST_PreferredProvider.ESLPreferredVendorRequestWrapper req = (CPQ_ESL_REST_PreferredProvider.ESLPreferredVendorRequestWrapper)JSON.deserialize(request.getBody(), CPQ_ESL_REST_PreferredProvider.ESLPreferredVendorRequestWrapper.class);
            System.debug('***'+req);
            string resp = '{'
                +   '\"ESLPreferredVendorResponseT\": {'
                +   '\"ProcessStatus\": \"SUCCESS\",'
                +   '\"CorrelationId\": \"001F000001I1oLnIAJ\",'
                +   '\"PreferredVendorResponse\": [   {'
                +      '\"LocationRef\":       {'
                +         '\"LocationIdentifier\":          {'
                +            '\"LocationReferenceID\": \"' + req.ESLPreferredVendorRequest.LocationInfo.ExternalLocationRef[0].LocationIdentifier.LocationReferenceID + '\",' //5003312,4462126
                +            '\"LocationSource\": \"SFDC\"'
                +         '},'
                +         '\"ServiceLocation\":          {'
                +            '\"ServiceTN\":             {'
                +               '\"TelephoneNumber\": \"3064585432\",'
                +               '\"NPA\": \"306\",'
                +               '\"NXX\": \"458\",'
                +               '\"Line\": \"5432\"'
                +            '},'
                +            '\"PostalAddress\":             {'
                +               '\"StreetAddress1\": \"294 N HIGHWAY 16\",'
                +               '\"PostalCode\":                {'
                +                  '\"City\": \"DENVER\",'
                +                  '\"State\": \"CO\",'
                +                  '\"Country\": \"USA\",'
                +                  '\"CountryCode\": \"USA\",'
                +                  '\"Zip\": \"80202\"'
                +               '}'
                +            '},'
                +            '\"ParsedAddress\":             {'
                +               '\"SANO\": \"294\",'
                +               '\"SASN\": \"HIGHWAY 16\",'
                +               '\"SASD\": \"N\",'
                +               '\"PostalCode\":                {'
                +                  '\"City\": \"DENVER\",'
                +                  '\"State\": \"CO\",'
                +                  '\"Country\": \"USA\",'
                +                  '\"CountryCode\": \"USA\",'
                +                  '\"Zip\": \"80202\"'
                +               '}'
                +            '},'
                +            '\"Lata\": \"656\",'
                +            '\"CentralOfficeInfo\":             {'
                +               '\"SWCNPA\": \"303\",'
                +               '\"SWCNXX\": \"244\",'
                +               '\"SWCCLLI\": \"DNVRCOCPDS0\",'
                +               '\"LataCode\": \"656\"'
                +            '},'
                +           '\"GeographicCoordinates\":             {'
                +               '\"Latitude\": \"35.4508182\",'
                +               '\"Longitude\": \"-80.99344119999999\"'
                +            '},'
                +            '\"LocationValidationInfo\":             {'
                +               '\"SFAValidationStatus\": \"Validated\",'
                +               '\"VoIPValidationStatus\": \"Not-Validated\",'
                +               '\"CCSSLocationValidation\": true'
                +            '},'
                +            '\"RegionFlag\": \"IR\",'
                +            '\"VendorList\": {\"VendorInfo\": [{\"VendorName\": \"QWEST CORPORATION - CO\"}]}'
                +         '},'
                +         '\"VoIPRateCenterLocRef\":          {'
                +            '\"AddressMatchInfo\": [            {'
                +               '\"HintText\": \"Near match found.  Please select the corrected address and verify the following information:  street name, street type, street direction, or re-enter your address.\",'
                +               '\"RecordType\": \"S\",'
                +               '\"isUSPS\": false,'
                +               '\"ParsedAddress\":                {'
                +                  '\"SANO\": \"294\",'
                +                  '\"SASN\": \"16th\",'
                +                  '\"SATH\": \"St\",'
                +                  '\"PostalCode\":                   {'
                +                     '\"City\": \"Denver\",'
                +                     '\"State\": \"CO\",'
                +                     '\"Zip\": \"80202\"'
                +                  '}'
                +               '},'
                +               '\"GeographicInfo\": {},'
                +               '\"isValidated\": false,'
                +               '\"RateCenterInfo\": {},'
                +               '\"ErrorMessage\":                {'
                +                  '\"Status\": \"ERROR\",'
                +                  '\"Code\": \"H1000\",'
                +                  '\"Message\": \"Near match found.  Please select the corrected address and verify the following information:  street name, street type, street direction, or re-enter your address.\"'
                +               '}'
                +            '}],'
                +            '\"HighLevelMessage\":             {'
                +               '\"Status\": \"ERROR\",'
                +               '\"Code\": \"6002\",'
                +               '\"Message\": \"Sagent Address validation failure\"'
                +            '}'
                +         '}'
                +      '},'
                +      '\"ProductName\": \"IQ+\",'
                +      '\"AccessProtocol\": \"WAVELENGTH\",'
                +      '\"AccessSpeed\":       ['
                +                  '{'
                +            '\"Speed\": \"1\",'
                +             '\"SpeedAltReference\": \"1 Mbps\",'
                +            '\"AccessVendorList\": {\"AccessVendor\": [{\"VendorName\": \"QWEST CORPORATION - CO\"}]}'
                +         '},'
                +          '{'
                +            '\"Speed\": \"2 GbE\",'
                +             '\"SpeedAltReference\": \"2 GbE\",'
                +            '\"AccessVendorList\": {\"AccessVendor\": [{\"VendorName\": \"QWEST CORPORATION - CO\"}]}'
                +         '}'
                +                    
                +               
                +      ']'
                
                +   '}]'                
                
                +'}}'; 
            response.setHeader('Content-Type','application/json');
            response.setBody(resp);
        }
        else if(request.getEndpoint().contains('ApigeeOAuth'))
        {
            response.setBody('{"access_token":"1234","token_type":"Bearer"}');
            response.setHeader('Content-Type', 'application/json');
        }
        else if(request.getEndpoint().contains('contact/Save'))
        {
            string jsonResponse = '{"contactId": "33445566"}';
            response.setBody(jsonResponse);
		}
        else if(request.getEndpoint().contains('capitalApprovalRequestAsync'))
        { 
            string jsonResponse = '{"Request initiated successfully"}';
            response.setBody(jsonResponse);
        }
        
        else if(request.getEndpoint().contains('DECAuthCode'))
        {
            string jsonResponse = '{"authorizationCode": "12454631145"}';
        response.setBody(jsonResponse);
        }
        else if(request.getEndpoint().contains('addOmRequest'))
        {
            string jsonResponse = '{"approvalCode": "2021-123"}';
        	response.setBody(jsonResponse);
        }
        if(request.getEndpoint().contains('banSearch')) 
        {
            //US164756 BillingCustomerNumber with CustomerNumber
            String jsonStr = '{'+
                '"@numFound":"2",'+
                '"@start":"0",'+
                '"customerBillAccountNumber":['+
                '{'+
                '"id":"ORAFIN||HZ_CUST_SITE_USES_ALL||1395205",'+
                '"billAccountNumber":"481168",'+
                '"billAccountName":"Acme Arsena Company, Inc.",'+
                '"financeAccountNumber":"481168-TW",'+
                '"dwSourceSystemCode":"ACCTMGT",'+
                '"sourceBillAccountSourceSystemCode":"ORAFIN",'+
                '"customerClassType":"Customer",'+
                '"customerName":"Acme Arsena Company, Inc.",'+
                '"customerNumber":"1-2UZAC7"'+
                '},'+
                '{'+
                '"id":"ACCTMGT||481168",'+
                '"billAccountNumber":"481168",'+
                '"billAccountName":"Acme Arsena Company, Inc.",'+
                '"financeAccountNumber":"481168-TW",'+
                '"dwSourceSystemCode":"ACCTMGT",'+
                '"sourceBillAccountSourceSystemCode":"ORAFIN",'+
                '"customerClassType":"Customer",'+
                '"customerName":"Acme Arsena Company, Inc.",'+
                '"customerNumber":"1-2UZAC7"'+
                '}'+
                ']'+
                '}';
            response.setBody(jsonStr);
        }
        */

        return response;
    }
    
}