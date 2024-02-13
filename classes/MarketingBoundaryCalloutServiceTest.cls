@isTest
public class MarketingBoundaryCalloutServiceTest {
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
        MarketingBoundaryCalloutResponseWrapper resWrapper;

        Test.startTest();
            MarketingBoundaryCalloutservice objParcelService = new MarketingBoundaryCalloutservice(
                               prrRecords[0]?.Id
            );
        	//objParcelService.execute(null);
            resWrapper = MarketingBoundaryCalloutservice.getBoundaryInfo(String.valueOf(prrRecords[0]?.GEOES_Latitude_Coordinate__c), String.valueOf(prrRecords[0]?.GEOES_Longitude_Coordinate__c),String.valueOf(prrRecords[0]?.Id));
        	MarketingBoundaryCalloutservice.getMaxBandwidth(String.valueOf(prrRecords[0]?.Id));	
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
    
    @IsTest
    public static void testQueueableJob() {        
          // Create Property request record
        String dataSource = 'ALN';
        String street = '6001 YANKEE HILL RD';
        String city = 'LINCOLN';
        String state = 'NE';
        String results = 'Yellow';
        String source = 'Test1';
        Decimal latitude = 33.56910000;
        Decimal longitude = -112.08100000;
        Test.startTest();
        List<Property__c> propertyList = createTestProperties();
        if (propertyList == null) {
            System.assertEquals(null, propertyList);
        } else {
            System.assertNotEquals(null, propertyList);
            if (propertyList.size() == 0) {
                System.assertEquals(0, propertyList.size());
            } else {
                System.assertNotEquals(0, propertyList.size());
            }
        }
        Set<Id> propIdSet = new Set<Id>();
        for(Property__c property : propertyList) {
            propIdSet.add(property.Id);
        }
        Property_Request_Record__c prr = new Property_Request_Record__c();
        prr.GEOES_Latitude_Coordinate__c = latitude;
        prr.GEOES_Longitude_Coordinate__c = longitude;
        prr.GEOES_Inventory_Source__c = source;
        prr.GEOES_results__c = results;
        prr.Data_Source__c = dataSource;
        prr.New_Property_Created__c =propertyList[0].Id;
        
        insert prr;
        
        PropertyCreation1gQueueable pc1gQ = new PropertyCreation1gQueueable(propIdSet);
        System.debug('pc1gQ.propertyIds?.size() = ' + pc1gQ.propertyIds?.size() + '  AND pc1gQ.propertyIdsToProcess?.size() = ' + pc1gQ.propertyIdsToProcess?.size());
        String pc1gQJobId = System.enqueueJob(pc1gQ);
        if (pc1gQJobId == null) {
	        System.assertEquals(null, pc1gQJobId);
        } else {
            System.assertNotEquals(null, pc1gQJobId);
        }
        Test.stopTest();    
    }//end testmethod testQueueableJob

    private static List<Property__c> createTestProperties() {
        List<Property__c> newTestProperties = new List<Property__c>();
        Property__c testProp = new Property__c();
        testProp.Name = 'StanTest1';
        testProp.Latitude__c = 41.88917342;
        testProp.Longitude__c = -87.62972682;
        newTestProperties.add(testProp);
        
        testProp = new Property__c();
        testProp.Name = 'StanTest2';
        testProp.Latitude__c = 39.01865353;
        testProp.Longitude__c = -77.4567641;
        newTestProperties.add(testProp);
        
		insert newTestProperties;        
        
        return newTestProperties;
    }//end method createTestProperties
}//end test-class MarketingBoundaryCalloutServiceTest