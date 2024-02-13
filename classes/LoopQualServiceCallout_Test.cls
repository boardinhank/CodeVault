@isTest
public with sharing class LoopQualServiceCallout_Test {
    @testSetup static void setup() {
        // Create Property request record
        String dataSource = 'LFACS';
        String street = '6001 YANKEE HILL RD';
        String city = 'LINCOLN';
        String state = 'NE';
        String results = 'Green';
        String source = 'ALN';
        Decimal latitude = 33.56910000;
        Decimal longitude = -112.08100000;
        List<Property_Request_Record__c> prrRecords = new List<Property_Request_Record__c>();
        
        Property__c pt = new Property__c(Name='Test Property',Latitude__c=39.525689,Longitude__c=-104.980431,Primary_Address_City__c='HIGHLANDS RANCH',Primary_Address_State__c='CO',Primary_Address_Street__c='787 CASSELBERRY WAY',Primary_Address_Zip__c='80126',County_Code__c='USA',State_Code__c='CO');
        insert pt;
        
        Property_Request_Record__c prr = new Property_Request_Record__c();
        prr.GEOES_Latitude_Coordinate__c = latitude;
        prr.GEOES_Longitude_Coordinate__c = longitude;
        prr.GEOES_Inventory_Source__c = dataSource;
        prr.GEOES_results__c = results;
        prr.Data_Source__c = source;
        prr.New_Property_Created__c = pt.Id;
        
        insert prr;
        
		prrRecords.add(prr);
        
        Transaction_Summary__c trs = new Transaction_Summary__c(PRR_Name__c=prr.Name);
        insert trs;
        
        API_Transaction__c apt = new API_Transaction__c();
        apt.Transaction_Summary_Id__c =trs.Id;
        apt.API_Response_JSON__c='{'+
		'  "serviceStatus": "Completed",'+
		'  "version": "1",'+
		'  "trackingId": "2e618c2a-5b68-4389-9759-4f4ef7e72d50",'+
		'  "overallDuration": 1204.1,'+
		'  "result": "Green",'+
		'  "isResponseFromCache": false,'+
		'  "exactMatches": ['+
		'    {'+
		'      "streetAddress": "22 E COLORADO AVE",'+
		'      "streetNrFirst": "22",'+
		'      "streetName": "E COLORADO AVE",'+
		'      "locality": "COLORADO SPRINGS",'+
		'      "stateOrProvince": "CO",'+
		'      "postCode": "80903",'+
		'      "source": "LFACS",'+
		'      "sourceId": "CLSPCOMA10EA7",'+
		'      "geoAddressId": "207629704",'+
		'      "isMdu": false,'+
		'      "isNoBuild": false,'+
		'      "isExactToInput": true,'+
		'      "geoPointDetails": ['+
		'        {'+
		'          "gpsCoordinate": {'+
		'            "source": "Trillium",'+
		'            "latitudeCoordinate": 38.8325,'+
		'            "longitudeCoordinate": -104.824941,'+
		'            "resolutionLevel": "1",'+
		'            "coordinateAccuracy": "A"'+
		'          },'+
		'          "vhCoordinate": {'+
		'            "vCoordinate": 7681.039006478,'+
		'            "hCoordinate": 5813.7770386252'+
		'          }'+
		'        }'+
		'      ],'+
		'      "wireCenter": {'+
		'        "clli8": "CLSPCOMA",'+
		'        "clli8Source": "LFACS",'+
		'        "companyOwnerId": "1"'+
		'      },'+
		'      "attributes": {'+
		'        "cala": "SCO",'+
		'        "legacyProvider": "QWEST COMMUNICATIONS",'+
		'        "rateCenter": {'+
		'          "name": "COLORDOSPG"'+
		'        },'+
		'        "rateZone": "01",'+
		'        "rateZoneLfacs": "01",'+
		'        "taxCode": "CO2002",'+
		'        "tta": "471",'+
		'        "exchangeCode": "COL",'+
		'        "trs": "CO 014S 066W 018"'+
		'      }'+
		'    }'+
		'  ]'+
		'}';
        
        insert apt;
    }

    @isTest
    public static void testBMPLOOPQUAL_SERVICE() {
       LoopQualServiceResponseWrapper resWrapper;
		List<Property_Request_Record__c> prrRecords = getPropertyReqRecords();
        Test.startTest();
            LoopQualServiceCallout objParcelService = new LoopQualServiceCallout(
                String.valueOf(prrRecords[0].Id)
            );
            resWrapper = objParcelService.getBandwidthInfo();
        Test.stopTest();
   
    }
    
    private static List<Property_Request_Record__c> getPropertyReqRecords() {
        return [
            SELECT
                Id,
                GPSLatitude__c,
                GPSLongitude__c,
                ProjectAddress__c,
                ProjectCity__c,
                ProjectState__c,
            	GEOES_Latitude_Coordinate__c,
            	GEOES_Longitude_Coordinate__c,
            	GEOES_Inventory_Source__c,
            	GEOES_results__c,
                Transaction_Summary__c
            FROM Property_Request_Record__c
        ];
    }

    
}