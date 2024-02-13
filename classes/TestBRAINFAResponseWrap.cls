/****************************************************************************************************
 * LAST UPDATED FOR:
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Produt-to-TechType-Mapping
****************************************************************************************************/
@IsTest
public class TestBRAINFAResponseWrap {

    @isTest
    private static void testParse() {
        Test.startTest();
        String responseJSONTrimmed = null;
        String responseJSON = TestBRAINFAResponseController.queryForResponseJSONFromStaticResource();
        Integer hl1SimulationResultStartIdx = responseJSON.indexOf('"hl1SimulationResult') - 1;
        if (hl1SimulationResultStartIdx > 0) {
            String segment1ResponseJSON = responseJSON.substring(0, hl1SimulationResultStartIdx);
            Integer errorCodeStartIdx = responseJSON.indexOf('"errorCode', hl1SimulationResultStartIdx) - 1;
            String segment2ResponseJSON = responseJSON.substring(errorCodeStartIdx);
            responseJSONTrimmed = segment1ResponseJSON + segment2ResponseJSON;
        } else {
            responseJSONTrimmed = responseJSON;
        }
	    BRAINFAResponseWrap respWrap = BRAINFAResponseWrap.parse(responseJSONTrimmed);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'BRAINFAResponseWrap instance is NULL');
        }
        if (respWrap?.Id == null) {
            System.assertEquals(null, respWrap?.Id, 'BRAINFAResponseWrap instance has Id value that is NULL');
        }
        Test.stopTest();    
    }//end test method testParse
}//end test class TestBRAINFAResponseWrap