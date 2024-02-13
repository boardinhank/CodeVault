@isTest
public with sharing class LoopQualServiceCalloutQueueable_Test {
    private static String testingPropertyId = null;
    private static String testingPRRId = null;
    private static String testingPRRName = null;
    @testSetup static void setup() {
        // Create Property request record
        String dataSource = 'Martens';
        String street = '2764 WEST BEACH';//1640 CAMPUS CIR';//'1842 S WESTWOOD';//'6001 YANKEE HILL RD';
        String city = 'GULF SHORES';//'MESA';//'LINCOLN';
        String state = 'AL';//'AZ';//'NE';
        String results = 'Green';
        String source = 'ALN';
        Decimal latitude = 30.45146993;
        Decimal longitude = -84.30758472;
        List<Property_Request_Record__c> prrRecords = new List<Property_Request_Record__c>();

        Property__c pt = new Property__c(Name='Test Property',Latitude__c=30.45146993,Longitude__c=-84.30758472,Primary_Address_City__c='GULF SHORES',Primary_Address_State__c='AL',Primary_Address_Street__c='2764 WEST BEACH',Primary_Address_Zip__c='32304',County_Code__c='USA',State_Code__c='AL');
        insert pt;
        
        testingPropertyId = pt.Id;

        Property_Request_Record__c prr = new Property_Request_Record__c();
        prr.GEOES_Latitude_Coordinate__c = latitude;
        prr.GEOES_Longitude_Coordinate__c = longitude;
        prr.GEOES_Inventory_Source__c = dataSource;
        prr.GEOES_results__c = results;
        prr.Data_Source__c = source;
        prr.ProjectAddress__c = street;
        prr.ProjectCity__c = city;
        prr.ProjectState__c = state;
        prr.New_Property_Created__c = pt.Id;

        insert prr;
        List<Property_Request_Record__c> tempPRRList = getPropertyReqRecords();
        System.debug('(LQServiceCalloutQ.setup) tempPRRList is NULL? ' + (tempPRRList==null) + '  AND tempPRR?.size() =' + tempPRRList?.size() + '  AND tempPRRList.get(0) is NULL? ' + (tempPRRList.get(0)==null));
        if (tempPRRList != null && tempPRRList.size() > 0 && tempPRRList.get(0) != null) {
            testingPRRId = tempPRRList.get(0).Id;
            testingPRRName = tempPRRList.get(0).Name;
            System.debug('(LQServiceCalloutQ.setup) testingPRRId = ' + testingPRRId + ' \n testingPRRName = ' + testingPRRName);
            prr = tempPRRList.get(0);
        }
		prrRecords.add(prr);

        System.debug('(LQServiceCalloutQ.setup) prr.Id = ' + prr.Id + ' \n prr.Name = ' + prr.Name);
        Transaction_Summary__c trs = new Transaction_Summary__c(PRR_Name__c=prr.Name);
        insert trs;

        API_Transaction__c apt = new API_Transaction__c();
        apt.Transaction_Summary_Id__c =trs.Id;
        /*
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
        */
         apt.API_Response_JSON__c='{' +
		'  "serviceStatus": "Completed",' +
		'  "version": "1",' +
		'  "trackingId": "6c9d588c-adc1-432f-a502-f484551c2115",' +
  		'  "overallDuration": 453.1,' +
  		'  "result": "Green",' +
		'  "isResponseFromCache": false,' +
		'  "exactMatches": [' +
		'    {' +
		'      "streetAddress": "2764 WEST BEACH BLVD",' +
		'      "streetNrFirst": "2764",' +
		'      "streetName": "WEST BEACH",' +
		'      "streetType": "BLVD",' +
		'      "locality": "GULF SHORES",' +
		'      "stateOrProvince": "AL",' +
		'      "postCode": "36542",' +
		'      "postCodeSuffix": "6011",' +
		'      "source": "Martens",' +
		'      "sourceId": "25507920081122014336",' +
		'      "geoAddressId": "230119145",' +
		'      "isMdu": false,' +
		'      "isNoBuild": false,' +
		'      "isExactToInput": true,' +
		'      "isFiberInd": false,' +
		'      "geoPointDetails": [' +
		'        {' +
		'          "gpsCoordinate": {' +
		'            "source": "Martens",' +
		'            "latitudeCoordinate": 30.234699,' +
		'            "longitudeCoordinate": -87.779758,' +
		'            "sourceDetail": "Live Martens"' +
		'          },' +
		'          "vhCoordinate": {' +
		'            "vCoordinate": 8231.7015579702,' +
		'            "hCoordinate": 2276.5698425897' +
		'          }' +
		'        },' +
		'        {' +
		'          "gpsCoordinate": {' +
		'            "source": "Trillium",' +
		'            "latitudeCoordinate": 30.234818,' +
		'            "longitudeCoordinate": -87.7791,' +
		'            "resolutionLevel": "2"' +
		'          },' +
		'          "vhCoordinate": {' +
		'            "vCoordinate": 8231.6212791914,' +
		'            "hCoordinate": 2276.4709323596' +
		'          }' +
		'        }' +
		'      ],' +
		'      "wireCenter": {' +
		'        "clli8": "GLSHALXB",' +
		'        "clli8Source": "GEO",' +
		'        "martensClli6": "WBCHAL",' +
		'        "companyOwnerId": "4"' +
		'      },' +
		'      "attributes": {' +
		'        "legacyProvider": "CENTURYLINK",' +
		'        "rateCenter": {' +
		'          "name": "GULFSHORES"' +
		'        },' +
		'        "residentialDeliveryPoint": "Y"' +
		'      }' +
		'    }' +
		'  ]' +
		'}';
             
    insert apt;
    }

    @isTest
    public static void testBMPLOOPQUAL_SERVICE_PRR() {
		List<Property_Request_Record__c> prrRecords = getPropertyReqRecords();
        Test.startTest();
        System.debug('(LQServiceCalloutQ.testBMPLOOPQUAL_SERVICE_PRR) prrRecords is NULL? ' + (prrRecords==null) + ' \n prrRecords?.size() = ' + prrRecords?.size() + ' \n prrRecords?.get(0) is NULL? ' + (prrRecords?.size()>0 && prrRecords?.get(0)==null));
        LoopQualServiceCalloutQueueable objParcelServiceQ = new LoopQualServiceCalloutQueueable(String.valueOf(prrRecords[0].Id));

    	String psJobId = System.enqueueJob(objParcelServiceQ);
        if (psJobId == null) {
            System.assertEquals(null, psJobId, 'JobId was NULL for LoopQualServiceCalloutQueueable after execute and failed');
        }
        Test.stopTest();   
    }//end test-method testBMPLOOPQUAL_SERVICE_PRR
    
    @isTest
    public static void testBMPLOOPQUAL_SERVICE_PRR_Type() {
		List<Property_Request_Record__c> prrRecords = getPropertyReqRecords();
        Test.startTest();
        System.debug('(LQServiceCalloutQ.testBMPLOOPQUAL_SERVICE_PRR_Type) prrRecords is NULL? ' + (prrRecords==null) + ' \n prrRecords?.size() = ' + prrRecords?.size() + ' \n prrRecords?.get(0) is NULL? ' + (prrRecords?.size()>0 && prrRecords?.get(0)==null));
        LoopQualServiceCalloutQueueable objParcelServiceQ = new LoopQualServiceCalloutQueueable('PRR', String.valueOf(prrRecords[0].Id));

    	String psJobId = System.enqueueJob(objParcelServiceQ);
        if (psJobId == null) {
            System.assertEquals(null, psJobId, 'JobId was NULL for LoopQualServiceCalloutQueueable after execute and failed');
        }
        Test.stopTest();   
    }//end test-method testBMPLOOPQUAL_SERVICE_PRR_Type
    
    
    @isTest
    public static void testBMPLOOPQUAL_SERVICE_Property() {
        Test.startTest();
        System.debug('(LQServiceCalloutQ.testBMPLOOPQUAL_SERVICE_Property)');
        LoopQualServiceCalloutQueueable objParcelServiceQ = new LoopQualServiceCalloutQueueable('PROP', testingPropertyId);

    	String psJobId = System.enqueueJob(objParcelServiceQ);
        if (psJobId == null) {
            System.assertEquals(null, psJobId, 'JobId was NULL for LoopQualServiceCalloutQueueable after execute and failed');
        }
        Test.stopTest();   
    }//end test-method testBMPLOOPQUAL_SERVICE_Property
        
    @isTest
    public static void testBMPLOOPQUAL_SERVICE_Property_Type() {
        Test.startTest();
        System.debug('(LQServiceCalloutQ.testBMPLOOPQUAL_SERVICE_Property)');
        LoopQualServiceCalloutQueueable objParcelServiceQ = new LoopQualServiceCalloutQueueable('PROPERTY', testingPropertyId);

    	String psJobId = System.enqueueJob(objParcelServiceQ);
        if (psJobId == null) {
            System.assertEquals(null, psJobId, 'JobId was NULL for LoopQualServiceCalloutQueueable after execute and failed');
        }
        Test.stopTest();   
    }//end test-method testBMPLOOPQUAL_SERVICE_Property
        
/*
    @isTest
    public static void testBMPLOOPQUAL_SERVICEbyPoint() {
		List<Property_Request_Record__c> prrRecords = getPropertyReqRecords();
        Test.startTest();
        LoopQualServiceCalloutQueueable objParcelServiceQ = new LoopQualServiceCalloutQueueable(String.valueOf(prrRecords[0].Id), String.valueOf(prrRecords[0].GEOES_Latitude_Coordinate__c), String.valueOf(prrRecords[0].GEOES_Longitude_Coordinate__c));
        String psJobId = System.enqueueJob(objParcelServiceQ);
        if (psJobId == null) {
            System.assertEquals(null, psJobId, 'JobId was NULL for LoopQualServiceCalloutQueueable using Point after execute and failed');
        }
        Test.stopTest();   
    }//end test-method testBMPLOOPQUAL_SERVICEbyPoint

    @isTest
    public static void testBMPLOOPQUAL_SERVICEbyAddress() {
		List<Property_Request_Record__c> prrRecords = getPropertyReqRecords();
        Test.startTest();
        String qAddress = prrRecords[0].ProjectAddress__c +'+'+prrRecords[0].ProjectCity__c+'+'+prrRecords[0].ProjectState__c;
        LoopQualServiceCalloutQueueable objParcelServiceQ = new LoopQualServiceCalloutQueueable(String.valueOf(prrRecords[0].Id), qAddress);
        String psJobId = System.enqueueJob(objParcelServiceQ);
        if (psJobId == null) {
            System.assertEquals(null, psJobId, 'JobId was NULL for LoopQualServiceCalloutQueueable using Address after execute and failed');
        }
        Test.stopTest();   
    }//end test-method testBMPLOOPQUAL_SERVICEbyAddress

    @IsTest
    public static void testClearState() {
		List<Property_Request_Record__c> prrRecords = getPropertyReqRecords();
        Test.startTest();
        String qAddress = prrRecords[0].ProjectAddress__c +'+'+prrRecords[0].ProjectCity__c+'+'+prrRecords[0].ProjectState__c;
        LoopQualServiceCalloutQueueable objParcelServiceQ = new LoopQualServiceCalloutQueueable(String.valueOf(prrRecords[0].Id), String.valueOf(prrRecords[0].GEOES_Latitude_Coordinate__c), String.valueOf(prrRecords[0].GEOES_Longitude_Coordinate__c), qAddress);
        if (objParcelServiceQ == null) {
            System.assertEquals(null, objParcelServiceQ);
        } else {
            System.assertNotEquals(null, objParcelServiceQ);
	        objParcelServiceQ.clearState();
            if (objParcelServiceQ.latitude == null) {
	            System.assertEquals(null, objParcelServiceQ.latitude);
            }
            if (objParcelServiceQ.longitude == null) {
	            System.assertEquals(null, objParcelServiceQ.longitude);
            }
            if (objParcelServiceQ.address == null) {
	            System.assertEquals(null, objParcelServiceQ.address);
            }
        }
    	Test.stopTest();        
	}//end testClearState
*/
    private static List<Property_Request_Record__c> getPropertyReqRecords() {
        return [
            SELECT
                Id, Name,
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

}//end test-class LoopQualServiceCalloutQueueable_Test