/***************************************************************************************************
 * Name:  BRAINFAFlowTransactionController
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for Response aspect of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  BRAINFAFlowTransactionController -- 88%  05/12/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 06/10/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version
 *
****************************************************************************************************/
global with sharing class BRAINFAFlowTransactionController {
    public class InvalidParameterParsingException extends Exception {}
    
    public class FlowTransactionParams {
        @invocableVariable(label='Name of the Flow from which this action is called' description='The name of the flow from which this action is called.' required=true)
        public String flowName;
        @invocableVariable(label='Previous Flow Element Performed' description='The label of the previous flow element performed for which this action will force the transaction to commit and complete' required=true)
        public String prevFlowElement;
    }

    @InvocableMethod(label='Commit transaction of previous flow step'
                     description='Commit transaction associated to previous flow step for BRAIN Financial Analyses process'
                     category='BRAIN API Call Tracker')
    public static List<List<String>> commitFlowTransaction(List<FlowTransactionParams> flowTransactionParams) {
        List<List<String>> resultListCollection = new List<List<String>>();
        List<String> resultList = new List<String>();
		String flowName = null;
        String prevFlowElement = null;
        
        try {
            flowName = flowTransactionParams.get(0).flowName;
			prevFlowElement = flowTransactionParams.get(0).prevFlowElement;
            
            if (String.isBlank(flowName) || String.isBlank(prevFlowElement)) {
                throw new InvalidParameterParsingException();
            } else {
		        System.debug('(BRAINFAFlowTransactionController.commitFlowTransaction) Committing transaction for flow "' + flowName + '" >> step: "' + prevFlowElement + '"');
                resultList.add('Committed');
                resultListCollection.add(resultList);
            }
        } catch(Exception mainX) {
            System.debug('(BRAINFAFlowTransactionController.commitFlowTransaction) EXCEPTION! \n Type: ' + mainX.getTypeName() + '\n Message:  ' + mainX.getMessage() + '\n Line#: ' + mainX.getLineNumber() + '\n StackTrace:  ' + mainX.getStackTraceString());
            resultList.add('ERROR! Method was passed Invalid Parameters');
            resultListCollection.add(resultList);
        }
        
        return resultListCollection;
    }//end method commitFlowTransaction
}//end class BRAINFAFlowTransactionController