@isTest
public with sharing class GeoesParcelServiceTest{

    @testSetup static void setup() {

        List<Property_Request_Record__c> prrRecordList = new List<Property_Request_Record__c>();
        String street = '6001 YANKEE HILL RD';
        String city = 'LINCOLN';
        String state = 'NE';
        Decimal latitude = 40.72445911093;
        Decimal longitude = -96.6389346791281;
        List<Property_Request_Record__c> prrALNRecords = TestDataFactory.createPropertyReqRecords(
            'ALN', street, city, state, latitude, longitude, 1, false
        );
        prrALNRecords[0].ManagerFirstName__c = 'CFName';
        prrALNRecords[0].ManagerLastName__c = 'CLName';
        prrRecordList.addAll(prrALNRecords);
        
        List<Property_Request_Record__c> prrDodgeRecords = TestDataFactory.createPropertyReqRecords(
            'Dodge', street, city, state, latitude, longitude, 2, false
        );
        prrDodgeRecords[0].Owner_Contact_Name__c = 'CFName CLName';
        prrDodgeRecords[1].Owner_Contact_Name__c = 'CFName CLName';
        prrDodgeRecords[1].isProcessed__c = true;
        prrRecordList.addAll(prrDodgeRecords);

        List<Property_Request_Record__c> prrUserRecords = TestDataFactory.createPropertyReqRecords(
            'User', street, city, state, latitude, longitude, 1, false
        );
        prrUserRecords[0].User_Contact_First_Name__c = 'CFName';
        prrUserRecords[0].User_Contact_Last_Name__c = 'CLName';
        prrRecordList.addAll(prrUserRecords);

        List<Property_Request_Record__c> prrCSRecords = TestDataFactory.createPropertyReqRecords(
            'Customer Success', street, city, state, latitude, longitude, 1, false
        );
        prrCSRecords[0].User_Contact_First_Name__c = 'CSFName';
        prrCSRecords[0].User_Contact_Last_Name__c = 'CSLName';
        prrCSRecords[0].CS_SBS_Tech_Module__c = 'Yes';
        prrCSRecords[0].CS_HH_Field__c = 0;
        prrCSRecords[0].CS_FOD_Field__c = null;
        prrCSRecords[0].CS_Property_Type__c = 'MDU';
        prrCSRecords[0].CS_Legacy_CDG_ID__c = '';
        prrCSRecords[0].CS_External_Source_ID__c = '';
        prrCSRecords[0].User_Property_Structure__c = 'Tower';
        prrRecordList.addAll(prrCSRecords);

        INSERT prrRecordList;
    }

    @isTest
    public static void instantiateObjects() {
        Set<Id> prrIds = null;
        Boolean disableDml = false;
        GeoesParcelService service = new GeoesParcelService(prrIds);
        List<Property_Request_Record__c> prrRecordList = getPrrRecordList('ALN');
        GeoesParcelService service_one = new GeoesParcelService(prrRecordList);
        GeoesParcelService service_two = new GeoesParcelService(prrIds,disableDml);
        List<Property_Request_Record__c> prrRecordDodgeList = getPrrRecordList('Dodge');
        GeoesParcelService service_three = new GeoesParcelService(prrRecordDodgeList,disableDml);
        GeoesParcelService.AddressValidationWrapper adrressValidationWrapper= new GeoesParcelService.AddressValidationWrapper(prrRecordDodgeList[0]);
        System.assertNotEquals(null, adrressValidationWrapper.contactName);
        System.assertNotEquals(null, adrressValidationWrapper.contactFirstName);
        System.assertNotEquals(null, adrressValidationWrapper.contactLastName);
    }
    @isTest
    public static void instantiateValidInventoryResources() {
        GeoesParcelService.VALID_INVENTORY_SOURCES = null;
        System.assertEquals(4, GeoesParcelService.VALID_INVENTORY_SOURCES.size());
    }

    @isTest
    public static void instantiateSkipGeoesResources() {
        GeoesParcelService.SKIP_GEOES_SOURCES = null;
        System.assertEquals(1, GeoesParcelService.SKIP_GEOES_SOURCES.size());
    }
   
    private static List<Property_Request_Record__c>  getPrrRecordList(String dataSource){
        return [
            SELECT 
                Id,Name,
            	Region__c,
            	Market__c,
                Data_Source__c,
                GPSLatitude__c,
                GPSLongitude__c,
                GEO_LATITUDE__c,
                GEO_LONGITUDE__c,
                User_Latitude__c,
                User_Longitude__c,
                ManagerFirstName__c,
                ManagerLastName__c,
                Owner_Contact_Name__c,
                User_Contact_First_Name__c,
                User_Contact_Last_Name__c,
                ProjectAddress__c,
                ProjectCity__c,
                ProjectState__c,
                STREET__c,
                CITY__c,
                STATE__c,
                ProjectZIP__c,
                County__c,
                User_Property_Address__c,
                User_Property_City__c,
                User_Property_State__c,
                User_Property_Zip_Code__c,
                User_Property_Structure__c,
            	User_Property_Type__c,
            	User_Number_of_Living_Units__c,
            	Property_Age_In_Years__c,
            	Preferred_Contact_Method__c,
            	User_First_Occupancy_Date__c,
            	User_Construction_Start_Date__c,
            	User_Construction_Completion_Date__c,
                Transaction_Summary__c,
                Match_Found_In_System__c,
                isProcessed__c,
                COUNTRY__c,
                ZIP_CODE__c,
                COUNTY_1__c,
                GEOES_results__c,
                BEST_PROP_ADDR__c,
                BEST_PROP_CITY__c,
                BEST_PROP_STATE__c,
                BEST_PROP_ZIP__c,
                BEST_PROP_NM__c,
                Duplicate_Property_Found__c,
                GEOES_Inventory_Source__c,
                GEOES_Legacy_Provider__c,
                Development_Status__c,
                New_Property_Created__c,
                GEOES_Latitude_Coordinate__c,
                GEOES_Longitude_Coordinate__c,
                Existing_Property_found_in_SF_with_PRR__c,
            	CS_SBS_Tech_Module__c,CS_HH_Field__c,CS_FOD_Field__c,CS_Property_Type__c,CS_Legacy_CDG_ID__c,CS_External_Source_ID__c
            FROM Property_Request_Record__c
            WHERE 
            	Data_Source__c=:dataSource
            LIMIT 1
        ];
    }
}