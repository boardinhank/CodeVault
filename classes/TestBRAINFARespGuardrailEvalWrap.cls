/****************************************************************************************************
 * LAST UPDATED FOR:
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Produt-to-TechType-Mapping
****************************************************************************************************/
@IsTest
public class TestBRAINFARespGuardrailEvalWrap {

    @IsTest
    private static void testParse() {
        Test.startTest();
        String responseJSONTrimmed = null;
        String responseJSON = TestBRAINFAResponseController.queryForResponseJSONFromStaticResource();
        Integer guardrailEvaluationStartIdx = responseJSON.indexOf('"guardrailEvaluation') - 1;
        Integer guardrailEvaluationEndIdx = responseJSON.indexOf('},', guardrailEvaluationStartIdx) + 2;
        responseJSONTrimmed = responseJSON.substring(guardrailEvaluationStartIdx, guardrailEvaluationEndIdx);
        /***  System.debug('For guardrailEvaluation, responseJSONTrimmed = ' + responseJSONTrimmed); ***/
        if (responseJSONTrimmed.indexOf('"guardrailEvaluation":') > -1) {
            responseJSONTrimmed = '{' + responseJSONTrimmed.substringBetween('{', '}') + '}';
            /***  System.debug('For guardrailEvaluation, final responseJSONTrimmed = ' + responseJSONTrimmed); ***/
        } else {
            responseJSONTrimmed = responseJSON;
        }
	    BRAINFARespGuardrailEvalWrap respWrap = BRAINFARespGuardrailEvalWrap.parse(responseJSONTrimmed);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'BRAINFARespGuardrailEvalWrap instance is NULL');
        }
        if (respWrap?.resultCode == null) {
            System.assertEquals(null, respWrap?.resultCode, 'BRAINFARespGuardrailEvalWrap instance has resultCode value that is NULL');
        }
        Test.stopTest();    
    }//end test method testParse
}//end test class TestBRAINFARespGuardrailEvalWrap