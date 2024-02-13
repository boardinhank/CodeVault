@IsTest
public class TestNRMARequestsResponseWrap {
    private static final String TESTNRMAREQUESTID = '1225879548856373248';
    private static final String MOCKREQUESTJSON = '{ "mockRequestJSON": "mockup" }';

    @isTest
    private static void testParse() {
        Test.startTest();
        String responseJSON = TestNRMACalloutHelper.queryForResponseJSONFromStaticResource();
	    NRMARequestsResponseWrap respWrap = NRMARequestsResponseWrap.parse(responseJSON);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'NRMARequestsResponseWrap instance is NULL');
        } else {
            System.assertNotEquals(null, respWrap, 'NRMARequestsResponseWrap instance is NOT NULL');
        }
        if (respWrap?.Id == null) {
            System.assertEquals(null, respWrap?.Id, 'NRMARequestsResponseWrap instance has Id value that is NULL');
        } else {
            System.assertNotEquals(null, respWrap?.Id, 'NRMARequestsResponseWrap instance has Id value that is NOT NULL');
        }
        if (respWrap?.Id == testNrmaRequestId) {
            System.assertEquals(testNrmaRequestId, respWrap?.Id, 'NRMARequestsResponseWrap instance Id value equals the TESTNRMAREQUESTID value');
        } else {
            System.assertNotEquals(testNrmaRequestId, respWrap?.Id, 'NRMARequestsResponseWrap instance Id value DOES NOT equal the TESTNRMAREQUESTID value');
        }
        Test.stopTest();    
    }//end test method testParse
}//end test class TestNRMARequestsResponseWrap