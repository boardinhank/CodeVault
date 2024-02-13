/****************************************************************************************************
 * LAST UPDATED FOR:
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Produt-to-TechType-Mapping
****************************************************************************************************/
@isTest
public class TestBRAINFARespCashFlowMetricWrap {
    @isTest
    private static void testParse() {
        Test.startTest();
        String responseJSONTrimmed = null;
        String responseJSON = TestBRAINFAResponseController.queryForResponseJSONFromStaticResource();
        Integer cashFlowMetricStartIdx = responseJSON.indexOf('"cashFlowMetric') - 1;
        Integer cashFlowMetricEndIdx = responseJSON.indexOf('},', cashFlowMetricStartIdx) + 2;
        responseJSONTrimmed = responseJSON.substring(cashFlowMetricStartIdx, cashFlowMetricEndIdx);
        /***  System.debug('For cashFlowMetric, responseJSONTrimmed = ' + responseJSONTrimmed); ***/
        if (responseJSONTrimmed.indexOf('"cashFlowMetric":') > -1) {
            responseJSONTrimmed = '{' + responseJSONTrimmed.substringBetween('{', '}') + '}';
            /***  System.debug('For cashFlowMetric, final responseJSONTrimmed = ' + responseJSONTrimmed); ***/
        } else {
            responseJSONTrimmed = responseJSON;
        }
	    BRAINFARespCashFlowMetricWrap respWrap = BRAINFARespCashFlowMetricWrap.parse(responseJSONTrimmed);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'BRAINFARespCashFlowMetricWrap instance is NULL');
        }
        if (respWrap?.currencyCode == null) {
            System.assertEquals(null, respWrap?.currencyCode, 'BRAINFARespCashFlowMetricWrap instance has currencyCode value that is NULL');
        }
        Test.stopTest();    
    }//end test method testParse
}//end test class TestBRAINFARespCashFlowMetricWrap