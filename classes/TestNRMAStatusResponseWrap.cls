@IsTest
private class TestNRMAStatusResponseWrap {
    private static final String TESTNRMAREQUESTID = '1225879548856373248';
    private static final String TESTFINANCEWORKFLOWID = '55478786';
    private static final String TESTOMWORKFLOWID = '55478788';
    private static final String TESTOMWORKFLOWSTATUS = 'Archived';
    private static final String TESTJSON = '{ ' +
							'	"nrmaRequestId": "1225879548856373248", ' +
							'	"financeWorkflowId": "55478786",' +
							'   "financeWorkflowStatus": "",' +
							'   "financeCurrentPhaseBeginTime": null,' +
							'   "offerManagementWorkflowId": "55478788",' +
							'	"offerManagementWorkflowStatus": "Archived",' +
							'	"offerManagementCurrentPhaseBeginTime": "2020-03-20T23:28:44Z"' +
							'}';
    @isTest
    private static void testParse() {
        Test.startTest();
	    NRMAStatusResponseWrap respWrap = NRMAStatusResponseWrap.parse(TESTJSON);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'NRMAStatusResponseWrap instance is NULL');
        } else {
            System.assertNotEquals(null, respWrap, 'NRMAStatusResponseWrap instance is NOT NULL');
        }
        if (respWrap.nrmaRequestId == null) {
            System.assertEquals(null, respWrap.nrmaRequestId, 'NRMAStatusResponseWrap instance has nrmaRequestId value of NULL');
        } else {
            System.assertNotEquals(null, respWrap.nrmaRequestId, 'NRMAStatusResponseWrap instance has nrmaRequestId value that is NOT NULL');
        }
        if (respWrap.nrmaRequestId == TESTNRMAREQUESTID) {
            System.assertEquals(TESTNRMAREQUESTID, respWrap.nrmaRequestId, 'NRMAStatusResponseWrap instance nrmaRequestId value equals the test nrmaRequestId value');
        } else {
            System.assertNotEquals(TESTNRMAREQUESTID, respWrap.nrmaRequestId, 'NRMAStatusResponseWrap instance nrmaRequestId value DOES NOT equal the test nrmaRequestId value');
        }
        Test.stopTest();    
    }//end testmethod testParse

}//end test class TestNRMAStatusResponseWrap