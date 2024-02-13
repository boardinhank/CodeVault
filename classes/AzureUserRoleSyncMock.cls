@isTest
global class AzureUserRoleSyncMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('ConsistencyLevel', 'Eventual');
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody(
            JSON.serialize(
                new Map<String, Object>{
                    'value' => new List<Object>{
                        new Map<String, Object>{
                            'displayName' => AzureUserRoleSyncTest.TEST_ROLE,
                            'id' => AzureUserRoleSyncTest.TEST_ID
                        }
                    }
                }
            )
        );
        return response;     
    }
}