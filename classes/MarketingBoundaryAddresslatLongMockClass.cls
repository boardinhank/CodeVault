@isTest
global  class MarketingBoundaryAddresslatLongMockClass implements HttpCalloutMock {
global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
       	response.setBody('{"parcelMarketingBoundary": {"marketingBoundaryId":"15"}}');
        response.setStatusCode(200);
        return response; 
    }
}