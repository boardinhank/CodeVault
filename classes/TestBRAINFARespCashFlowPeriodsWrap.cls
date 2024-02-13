/****************************************************************************************************
 * LAST UPDATED FOR:
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Produt-to-TechType-Mapping
****************************************************************************************************/
@isTest
public class TestBRAINFARespCashFlowPeriodsWrap {
    @isTest
    private static void testParse() {
        Test.startTest();
        String responseJSONTrimmed = null;
        String responseJSON = TestBRAINFAResponseController.queryForResponseJSONFromStaticResource();
        List<cashFlowPeriod__c> respCashFlowPeriods = new List<cashFlowPeriod__c>();
        Integer cashFlowPeriodsHl1EvalStartIdx = responseJSON.indexOf('"cashFlowPeriods') - 1;
        Integer cashFlowPeriodsHl1EvalEndIdx = responseJSON.indexOf('],', cashFlowPeriodsHl1EvalStartIdx) + 1;
        responseJSONTrimmed = responseJSON.substring(cashFlowPeriodsHl1EvalStartIdx, cashFlowPeriodsHl1EvalEndIdx);
        /***  System.debug('For cashFlowPeriods, responseJSONTrimmed = ' + responseJSONTrimmed); ***/
        if (responseJSONTrimmed.indexOf('"cashFlowPeriods":') > -1) {
            responseJSONTrimmed = '{ ' + responseJSONTrimmed + ' }';
            /***  System.debug('For cashFlowPeriods, final responseJSONTrimmed = ' + responseJSONTrimmed); ***/
        } else {
            responseJSONTrimmed = responseJSON;
        }
	    BRAINFARespCashFlowPeriodsWrap respWrap = BRAINFARespCashFlowPeriodsWrap.parse(responseJSONTrimmed);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'BRAINFARespCashFlowPeriodsWrap instance is NULL');
        }
        if (respWrap?.cashFlowPeriods?.get(0)?.contractMonth == null) {
            System.assertEquals(null, respWrap?.cashFlowPeriods?.get(0)?.contractMonth, 'BRAINFARespCashFlowPeriodsWrap instance has contractMonth value that is NULL');
        }
        Test.stopTest();    
    }//end test method testParse
}//end test class TestBRAINFARespCashFlowPeriodsWrap