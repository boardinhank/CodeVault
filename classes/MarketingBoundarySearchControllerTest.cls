@isTest
public  class MarketingBoundarySearchControllerTest {
  	
   @isTest
   static void testBoundarySearch(){
       
        string boundaryId = '60';
        string boundaryName = 'SPOKANE PARENT BOUNDARY';
            	
       List<Property_Request_Record__c> prrRecordList = new List<Property_Request_Record__c>();
        String street = '6001 YANKEE HILL RD';
        String city = 'LINCOLN';
        String state = 'NE';
        Decimal latitude = 40.72445911093;
        Decimal longitude = -96.6389346791281;
       insert prrRecordList;
         List<Property__c> properties = TestDataFactory.createProperties(
        	'6001 YANKEE HILL RD', 
            'LINCOLN', 
            'NE',
            '109',
            '31',
            '1628100014000',
        	40.72445911093, 
            -96.6389346791281,
            2, 
            False    
    	);
        properties[0].Unique_ID__c = '109162810001400031';
        insert properties;
       List<string> boundaryInfoLists =  new List<String>{'MERIDIAN TEST 1','60','188','Meridian','1000','Meridian','ID','83646'};
       
       properties[0].Boundary_Name_Res__c = 'MERIDIAN TEST 1';
       properties[0].Boundary_ID_Res__c = 60;
       properties[0].Number_of_tax_parcels_inside_of_boundary__c = 188;
       properties[0].Wire_center_CLLI_code__c = 'Meridian';
       properties[0].Max_Bandwidth__c = 1000;
       properties[0].City_Res__c = 'MERIDIAN';
       properties[0].State_Res__c = 'ID';
       properties[0].Zip_Res__c = 83646;
       properties[0].Id = properties[0].Id;
       
       update properties[0];
       Test.startTest();
         Test.setMock(HttpCalloutMock.class, new MarketingBoundaryControllerMockClass());
         List<string>  listId = MarketingBoundarySearchController.searchBoundry(boundaryId);
         MarketingBoundarySearchController.searchBoundrywithName(boundaryName);
         List<Property__c> boundaryInfoList = MarketingBoundarySearchController.fetchBoundaryInfo(properties[0].Id);
         MarketingBoundarySearchController.saveBoundaryInfo(boundaryInfoLists, properties[1].Id);
         system.assertEquals(1, boundaryInfoList.size());
       Test.stopTest();
       
    }
    @isTest
    public static void testBoundarySearchAddressLatLong(){
        string boundaryAddress ='1224 W 11TH AVE spokane wa';
        string boundaryLat = '47.645369';
        string boundaryLong ='117.43035';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MarketingBoundaryAddresslatLongMockClass());
         List<string> boundaryIdList = MarketingBoundarySearchController.searchBoundrywithAddress(boundaryAddress);        
         MarketingBoundarySearchController.searchBoundrywithLatLong(boundaryLat, boundaryLong);
        
        Test.stopTest();
    }
   
   
}