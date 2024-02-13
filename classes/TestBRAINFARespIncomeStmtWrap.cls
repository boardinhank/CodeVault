/****************************************************************************************************
 * LAST UPDATED FOR:
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Produt-to-TechType-Mapping
****************************************************************************************************/
@isTest
public class TestBRAINFARespIncomeStmtWrap {

    @isTest
    private static void testParse() {
        Test.startTest();
        String responseJSONTrimmed = null;
        String responseJSON = TestBRAINFAResponseController.queryForResponseJSONFromStaticResource();
        Integer incomeStatementMetricStartIdx = responseJSON.indexOf('"incomeStatementMetric') - 1;
        Integer incomeStatementMetricEndIdx = responseJSON.indexOf('},', incomeStatementMetricStartIdx) + 2;
        responseJSONTrimmed = responseJSON.substring(incomeStatementMetricStartIdx, incomeStatementMetricEndIdx);
        System.debug('For incomeStatementMetric, responseJSONTrimmed = ' + responseJSONTrimmed);
        if (responseJSONTrimmed.indexOf('"incomeStatementMetric":') > -1) {
            responseJSONTrimmed = '{' + responseJSONTrimmed.substringBetween('{', '}') + '}';
            System.debug('For incomeStatementMetric, final responseJSONTrimmed = ' + responseJSONTrimmed);
        } else {
            responseJSONTrimmed = responseJSON;
        }
	    BRAINFARespIncomeStmtWrap respWrap = BRAINFARespIncomeStmtWrap.parse(responseJSONTrimmed);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'BRAINFARespIncomeStmtWrap instance is NULL');
        }
        if (respWrap?.currencyCode == null) {
            System.assertEquals(null, respWrap?.currencyCode, 'BRAINFARespIncomeStmtWrap instance has currencyCode value that is NULL');
        }
        Test.stopTest();    
    }//end test method testParse
}//end test class TestBRAINFARespIncomeStmtWrap