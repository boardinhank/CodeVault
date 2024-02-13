@isTest
public class BIWQualificationServiceCallout_Test {
    
    @testSetup static void setup() {
        // Create Property request record
        String dataSource = 'ALN';
        String street = '6001 YANKEE HILL RD';
        String city = 'LINCOLN';
        String state = 'NE';
        String results = 'Yellow';
        String source = 'Test1';
        Decimal latitude = 33.56910000;
        Decimal longitude = -112.08100000;
        List<Property_Request_Record__c> prrRecords = new List<Property_Request_Record__c>();
        
        Property__c pr = new Property__c();
        pr.Name ='Test Property';
        insert pr;
        
        Property_Request_Record__c prr = new Property_Request_Record__c();
        prr.GEOES_Latitude_Coordinate__c = latitude;
        prr.GEOES_Longitude_Coordinate__c = longitude;
        prr.GEOES_Inventory_Source__c = source;
        prr.GEOES_results__c = results;
        prr.Data_Source__c = dataSource;
        prr.New_Property_Created__c =pr.Id;
        
        insert prr;
        
		prrRecords.add(prr);
    }
    
    @isTest
    public static void testParcelServiceByLatLong() {
        List<Property_Request_Record__c> prrRecords = getPropertyReqRecords();
        BIWQualificationServiceResponseWrapper resWrapper;

        Test.startTest();
            BIWQualificationServiceCallout objParcelService = new BIWQualificationServiceCallout(
                String.valueOf(prrRecords[0]?.GEOES_Latitude_Coordinate__c),
                String.valueOf(prrRecords[0]?.GEOES_Longitude_Coordinate__c),
                prrRecords[0]?.Id
            );
            resWrapper = objParcelService.getPropertyInfo();
        	System.debug('REP###'+resWrapper);
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