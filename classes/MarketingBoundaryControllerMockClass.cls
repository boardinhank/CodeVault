@isTest
global class MarketingBoundaryControllerMockClass implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"marketingBoundary": {"totalParcels":186, "boundaryId":"60","bandwidth":"1000","wireCenterClli":"MRDNIDMA","city":"MERIDIAN","state":"ID","zip":"83646"}}');
        response.setStatusCode(200);
        return response; 
    }
   
 }