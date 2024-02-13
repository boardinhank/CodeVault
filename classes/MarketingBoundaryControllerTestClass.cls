@isTest 
private class MarketingBoundaryControllerTestClass {
    static testMethod void testCallout() {
        Test.setMock(HttpCalloutMock.class, new MarketingBoundaryControllerMockClass());  
        Map<String, string> parms = new Map<String, string>();
        parms.put('Boundary_Address','1224 W 11TH AVE spokane wa');
        MarketingBoundaryController.searchBoundry(parms);
    }
    static testMethod void testCallout2() {
        Test.setMock(HttpCalloutMock.class, new MarketingBoundaryControllerMockClass());  
        Map<String, string> parms = new Map<String, string>();
        parms.put('Boundary_Latitude','47.645369');
        parms.put('Boundary_Longitude','-117.430351');
        MarketingBoundaryController.searchBoundry(parms);
    }
    static testMethod void testCallout3() {
        Test.setMock(HttpCalloutMock.class, new MarketingBoundaryControllerMockClass());  
        Map<String, string> parms = new Map<String, string>();
        parms.put('Boundary_Name','MERIDIAN 20TEST 201');
        MarketingBoundaryController.searchBoundry(parms);
    }
    static testMethod void testCallout4() {
        Test.setMock(HttpCalloutMock.class, new MarketingBoundaryControllerMockClass());  
        Map<String, string> parms = new Map<String, string>();
        parms.put('Boundary_ID','60');
        MarketingBoundaryController.searchBoundry(parms);
    } 
}