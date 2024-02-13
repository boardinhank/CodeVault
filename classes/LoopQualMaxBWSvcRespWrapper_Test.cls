@IsTest
public class LoopQualMaxBWSvcRespWrapper_Test {
    private static String responseJSON = '{}';
    @isTest
    private static void testParse() {
        Test.startTest();
	    LoopQualMaxBandwidthServiceRespWrapper respWrap = LoopQualMaxBandwidthServiceRespWrapper.parse(responseJSON);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'LoopQualMaxBandwidthServiceRespWrapper instance is NULL');
        } else {
            System.assertNotEquals(null, respWrap, 'LoopQualMaxBandwidthServiceRespWrapper instance is NOT NULL');
        }
        if (respWrap?.maxQualifiedSpeeds == null) {
            System.assertEquals(null, respWrap?.maxQualifiedSpeeds, 'LoopQualMaxBandwidthServiceRespWrapper instance has maxQualifiedSpeeds value that is NULL');
        } else {
            System.assertNotEquals(null, respWrap?.maxQualifiedSpeeds, 'LoopQualMaxBandwidthServiceRespWrapper instance has maxQualifiedSpeeds value that is NOT NULL');
        }
        Test.stopTest();    
    }//end test method testParse
}//end test-class