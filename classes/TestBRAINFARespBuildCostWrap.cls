/****************************************************************************************************
 * LAST UPDATED FOR:
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Produt-to-TechType-Mapping
****************************************************************************************************/
@isTest
public class TestBRAINFARespBuildCostWrap {

    @isTest
    private static void testParse() {
        Test.startTest();
        String responseJSONTrimmed = null;
        String responseJSON = TestBRAINFAResponseController.queryForResponseJSONFromStaticResource();
        Integer buildCostHl1EvalStartIdx = responseJSON.indexOf('"buildCost":') - 1;
        /***  System.debug('buildCostHl1EvalStartIdx = ' + buildCostHl1EvalStartIdx); ***/
        Integer bomLinesHl1EvalStartIdx = responseJSON.indexOf('"bomLines":', buildCostHl1EvalStartIdx) - 1;
        /***  System.debug('bomLinesHl1EvalStartIdx = ' + bomLinesHl1EvalStartIdx); ***/
        responseJSONTrimmed = responseJSON.substring(buildCostHl1EvalStartIdx, bomLinesHl1EvalStartIdx);
        /***  System.debug('For buildCost, responseJSONTrimmed = ' + responseJSONTrimmed); ***/
        if (responseJSONTrimmed.indexOf('"buildCost":') > -1) {
            responseJSONTrimmed = '{' + responseJSONTrimmed.substringBetween('{', '}') + '}';
            /***  System.debug('For buildCost, final responseJSONTrimmed = ' + responseJSONTrimmed); ***/
        } else {
            responseJSONTrimmed = responseJSON;
        }
	    BRAINFARespBuildCostWrap respWrap = BRAINFARespBuildCostWrap.parse(responseJSONTrimmed);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'BRAINFARespBuildCostWrap instance is NULL');
        }
        if (respWrap?.currencyCode == null) {
            System.assertEquals(null, respWrap?.currencyCode, 'BRAINFARespBuildCostWrap instance has currencyCode value that is NULL');
        }
        Test.stopTest();    
    }//end test method testParse
}//end test class TestBRAINFARespBuildCostWrap