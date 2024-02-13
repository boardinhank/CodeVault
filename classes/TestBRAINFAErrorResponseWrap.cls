/****************************************************************************************************
 * LAST UPDATED FOR:
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Produt-to-TechType-Mapping
****************************************************************************************************/
@IsTest
public class TestBRAINFAErrorResponseWrap {

    @isTest
    private static void testParseFullJSON() {
        Test.startTest();
        String responseJSONTrimmed = null;
        String responseJSON = TestBRAINFAResponseController.queryForResponseJSONFromStaticResource();
        /*** System.debug('(testParseFullJSON) responseJSON:\n' + responseJSON); ***/
        Integer errorCodeStartIdx = responseJSON.indexOf('"errorCode') - 1;
        /*** System.debug('(testParseFullJSON) errorCodeStartIdx = ' + errorCodeStartIdx); ***/
        if (errorCodeStartIdx > 0) {
            Integer errorMessageStartIdx = responseJSON.indexOf('"errorMessage', errorCodeStartIdx) - 1;
    	    /*** System.debug('(testParseFullJSON) errorMessageStartIdx = ' + errorMessageStartIdx); ***/
            Integer errorMessageEndIdx = responseJSON.indexOf('",', errorMessageStartIdx) + 1;            
	        /*** System.debug('(testParseFullJSON) errorMessageEndIdx = ' + errorMessageEndIdx); ***/
            if (errorMessageEndIdx == 0) {
                errorMessageEndIdx = responseJSON.indexOf('}', errorMessageStartIdx) - 1;            
		        /*** System.debug('(testParseFullJSON) After-ZERO errorMessageEndIdx = ' + errorMessageEndIdx); ***/
            }
            responseJSONTrimmed = '{ ' + responseJSON.substring(errorCodeStartIdx, errorMessageEndIdx) + ' }';
        } else {
            responseJSONTrimmed = responseJSON;
        }
        /*** System.debug('(testParseFullJSON) responseJSONTrimmed:\n' + responseJSONTrimmed); ***/
	    BRAINFAErrorResponseWrap respWrap = BRAINFAErrorResponseWrap.parse(responseJSONTrimmed);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'BRAINFAErrorResponseWrap instance is NULL');
        }
        if (respWrap?.errorCode == null) {
            System.assertEquals(null, respWrap?.errorCode, 'BRAINFAErrorResponseWrap instance has errorCode value that is NULL');
        }
        Test.stopTest();    
    }//end test method testParseFullJSON

    @isTest
    private static void testParseErrorJSON() {
        Test.startTest();
        String responseJSONTrimmed = null;
        String responseJSON = TestBRAINFAErrorResponseWrap.buildErrorJSON();
        System.debug('(testParseErrorJSON) responseJSON:\n' + responseJSON);
        Integer errorCodeStartIdx = responseJSON.indexOf('"errorCode') - 1;
        System.debug('(testParseErrorJSON) errorCodeStartIdx = ' + errorCodeStartIdx);
        if (errorCodeStartIdx > 0) {
            Integer errorMessageStartIdx = responseJSON.indexOf('"errorMessage', errorCodeStartIdx) - 1;
    	    System.debug('(testParseErrorJSON) errorMessageStartIdx = ' + errorMessageStartIdx);
            Integer errorMessageEndIdx = responseJSON.indexOf('",', errorMessageStartIdx) + 1;            
	        System.debug('(testParseErrorJSON) errorMessageEndIdx = ' + errorMessageEndIdx);
            if (errorMessageEndIdx == 0) {
                errorMessageEndIdx = responseJSON.indexOf('}', errorMessageStartIdx) - 1;            
		        System.debug('(testParseErrorJSON) After-ZERO errorMessageEndIdx = ' + errorMessageEndIdx);
            }
            responseJSONTrimmed = '{ ' + responseJSON.substring(errorCodeStartIdx, errorMessageEndIdx) + ' }';
        } else {
            responseJSONTrimmed = responseJSON;
        }
        System.debug('(testParseErrorJSON) responseJSONTrimmed:\n' + responseJSONTrimmed);
	    BRAINFAErrorResponseWrap respWrap = BRAINFAErrorResponseWrap.parse(responseJSONTrimmed);
        if (respWrap == null) {
	        System.assertEquals(null, respWrap, 'BRAINFAErrorResponseWrap instance is NULL');
        }
        if (respWrap?.errorCode == null) {
            System.assertEquals(null, respWrap?.errorCode, 'BRAINFAErrorResponseWrap instance has errorCode value that is NULL');
        }
        Test.stopTest();    
    }//end test method testParseErrorJSON
    
    private static String buildErrorJSON() {
        List<String> errorJSONList = new List<String>();
        errorJSONList.add('{');
    	errorJSONList.add('\n"id": "1628781322967113728",');
    	errorJSONList.add('\n"requestId": "",');
    	errorJSONList.add('\n"status": "FAIL",');
    	errorJSONList.add('\n"responseDate": "2023-02-23T15:38:23.357446175Z",');
    	errorJSONList.add('\n"applicationVersion": "",');
    	errorJSONList.add('\n"salesRateScenarioId": 0,');
    	errorJSONList.add('\n"survivalScenarioId": 0,');
    	errorJSONList.add('\n"conversionScenarioId": 0,');
    	errorJSONList.add('\n"costScenarioId": 0,');
    	errorJSONList.add('\n"forecastScenario": "Standalone",');
    	errorJSONList.add('\n"incremental": false,');
    	errorJSONList.add('\n"hl1SimulationResult": null,');
    	errorJSONList.add('\n"hl2SimulationResults": null,');
    	errorJSONList.add('\n"hl1EvaluationResult": null,');
    	errorJSONList.add('\n"hl2EvaluationResults": null,');
    	errorJSONList.add('\n"deprecationWarnings": [');
    	errorJSONList.add('\n{');
    	errorJSONList.add('\n"id": "RequireClusterID",');
    	errorJSONList.add('\n"description": "ClusterID for all hl3Items will be required.",');
    	errorJSONList.add('\n"endOfLifeDate": "2022-10-01T00:00:00Z"');
    	errorJSONList.add('\n}');
    	errorJSONList.add('\n],');
    	errorJSONList.add('\n"errorCode": "NotFound",');
    	errorJSONList.add('\n"errorMessage": "no WireCenterGPONStrategy: with CLLICode DNVRCOOP:"');
    	errorJSONList.add('\n}');
        return String.join(errorJSONList, '');
    }
}//end test class TestBRAINFAErrorResponseWrap