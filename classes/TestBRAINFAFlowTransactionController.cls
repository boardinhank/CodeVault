@isTest(SeeAllData=true)
public with sharing class TestBRAINFAFlowTransactionController {

    /* */ 
    @AuraEnabled
    public static testMethod void testCommitFlowTransaction() {
        final string validResult = 'Committed';
        final string testFlowName = 'Offer - Submit to Brain';
        final string testPrevFlowElement = 'Any step';
        List<List<String>> testResultListCollection = new List<List<String>>();
        List<String> testResultList = new List<String>();
        String testResult = null;
        
        Test.startTest();
        List<BRAINFAFlowTransactionController.FlowTransactionParams> flowTransactionParamsList = new List<BRAINFAFlowTransactionController.FlowTransactionParams>();
        BRAINFAFlowTransactionController.FlowTransactionParams ftParams = new BRAINFAFlowTransactionController.FlowTransactionParams();
        ftParams.flowName = testFlowName;
        ftParams.prevFlowElement = testPrevFlowElement;
        flowTransactionParamsList.add(ftParams);
        System.assertNotEquals(null, flowTransactionParamsList.get(0).flowName);
        System.assertNotEquals(null, flowTransactionParamsList.get(0).prevFlowElement);
        
        testResultListCollection = BRAINFAFlowTransactionController.commitFlowTransaction(flowTransactionParamsList);
        if (testResultListCollection.size() >= 1) {
	        testResultList = testResultListCollection.get(0);
            if (testResultList.size() >= 1) {
				testResult = testResultList.get(0);
            }
        }
        System.assertEquals(validResult, testResult);
        
        Test.stopTest();
    }//end testMethod testCommitFlowTransaction
    /* */

    /* */ 
    @AuraEnabled
    public static testMethod void testCommitFlowTransactionWithNullFlowName() {
        final string errorResult = 'ERROR! Method was passed Invalid Parameters';
        final string testFlowName = null;
        final string testPrevFlowElement = 'Any step';
        List<List<String>> testResultListCollection = new List<List<String>>();
        List<String> testResultList = new List<String>();
        String testResult = null;
        
        Test.startTest();
        List<BRAINFAFlowTransactionController.FlowTransactionParams> flowTransactionParamsList = new List<BRAINFAFlowTransactionController.FlowTransactionParams>();
        BRAINFAFlowTransactionController.FlowTransactionParams ftParams = new BRAINFAFlowTransactionController.FlowTransactionParams();
        ftParams.flowName = testFlowName;
        ftParams.prevFlowElement = testPrevFlowElement;
        flowTransactionParamsList.add(ftParams);
        System.assertEquals(null, flowTransactionParamsList.get(0).flowName);
        System.assertNotEquals(null, flowTransactionParamsList.get(0).prevFlowElement);
        
        testResultListCollection = BRAINFAFlowTransactionController.commitFlowTransaction(flowTransactionParamsList);
        if (testResultListCollection.size() >= 1) {
	        testResultList = testResultListCollection.get(0);
            if (testResultList.size() >= 1) {
				testResult = testResultList.get(0);
            }
        }
        System.assertEquals(errorResult, testResult);
        
        Test.stopTest();
    }//end testMethod testCommitFlowTransactionWithNullFlowName
    /* */

    /* */ 
    @AuraEnabled
    public static testMethod void testCommitFlowTransactionWithNullPrevElement() {
        final string errorResult = 'ERROR! Method was passed Invalid Parameters';
        final string testFlowName = 'Offer - Submit to Brain';
        final string testPrevFlowElement = null;
        List<List<String>> testResultListCollection = new List<List<String>>();
        List<String> testResultList = new List<String>();
        String testResult = null;
        
        Test.startTest();
        List<BRAINFAFlowTransactionController.FlowTransactionParams> flowTransactionParamsList = new List<BRAINFAFlowTransactionController.FlowTransactionParams>();
        BRAINFAFlowTransactionController.FlowTransactionParams ftParams = new BRAINFAFlowTransactionController.FlowTransactionParams();
        ftParams.flowName = testFlowName;
        ftParams.prevFlowElement = testPrevFlowElement;
        flowTransactionParamsList.add(ftParams);
        System.assertNotEquals(null, flowTransactionParamsList.get(0).flowName);
        System.assertEquals(null, flowTransactionParamsList.get(0).prevFlowElement);
        
        testResultListCollection = BRAINFAFlowTransactionController.commitFlowTransaction(flowTransactionParamsList);
        if (testResultListCollection.size() >= 1) {
	        testResultList = testResultListCollection.get(0);
            if (testResultList.size() >= 1) {
				testResult = testResultList.get(0);
            }
        }
        System.assertEquals(errorResult, testResult);
        
        Test.stopTest();
    }//end testMethod testCommitFlowTransactionWithNullPrevElement
    /* */
    
}//end TestBRAINFAFlowTransactionController