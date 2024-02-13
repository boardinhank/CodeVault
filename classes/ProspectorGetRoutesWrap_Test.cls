@isTest(SeeAllData=true)
public class ProspectorGetRoutesWrap_Test {

    @AuraEnabled
    public static testmethod void testProspectorGetRoutesWrapParse() {
        String testJSON = ProspectorMockHttpResponseGenerator.getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesMHHH();
        Test.startTest();
	    ProspectorGetRoutesWrap pgrWrap = ProspectorGetRoutesWrap.parse(testJSON);
        if (pgrWrap == null) {
	        System.assertEquals(null, pgrWrap);
        } else {
            System.assertNotEquals(null, pgrWrap);
            if (pgrWrap.status == null) {
                System.assertEquals(null, pgrWrap.status);
            } else {
                System.assertNotEquals(null, pgrWrap.status);
                System.debug('(testProspectorGetRoutesWrapParse)pgrWrap.payload = ' + pgrWrap.payload.get(0).ToReadableString());
            }
        }
        Test.stopTest();    
    }//end testmethod testProspectorGetRoutesWrapParse

}//end test class ProspectorGetRoutesWrap_Test