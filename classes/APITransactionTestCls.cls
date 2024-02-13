@isTest
public class APITransactionTestCls {
    @testSetup static void testData() {
        List<API_Transaction__c> transList = new List<API_Transaction__c>();

        API_Transaction__c tranReqRes = new API_Transaction__c();
        tranReqRes.API_Request_JSON__c='{"stackOrAmendFlag":null,"serviceAddress":{"timeZone":{"offset":"-7","name":"Pacific Standard Time","isDaylightSavingsTime":true,"ianaName":"America/Los_Angeles"},"success":true}}';
        tranReqRes.API_Response_JSON__c='{"stackOrAmendFlag":null,"serviceAddress":{"timeZone":{"offset":"-7","name":"Pacific Standard Time","isDaylightSavingsTime":true,"ianaName":"America/Los_Angeles"},"success":true}}';
        tranReqRes.hasEndpointParameters__c=false;
        transList.add(tranReqRes);
        
        API_Transaction__c tranReq = new API_Transaction__c();
        tranReq.API_Request_JSON__c='{"stackOrAmendFlag":null,"serviceAddress":{"timeZone":{"offset":"-7","name":"Pacific Standard Time","isDaylightSavingsTime":true,"ianaName":"America/Los_Angeles"},"success":true}}';
        tranReq.hasEndpointParameters__c=true;
        transList.add(tranReq);

        insert transList;
}

@isTest
private static void whenReqResPassed(){
    API_Transaction__c tran = [SELECT Id, API_Request_JSON__c, API_Response_JSON__c
                                        FROM API_Transaction__c
                                        WHERE hasEndpointParameters__c = false
                                        WITH SECURITY_ENFORCED
                                        LIMIT 1];  
    
   APITransactionCls.cls_JsonReqResWrapper wrapObj = APITransactionCls.getApiTransactionList(tran.Id);
    
    System.assertEquals(false,wrapObj.hasEndpointParams, 'true');  
    System.assertEquals(tran.API_Request_JSON__c,wrapObj.jsonReq, 'true');
    System.assertEquals(tran.API_Response_JSON__c,wrapObj.jsonRes, 'true');
}
@isTest
private static void whenResNotPassed(){
    
    API_Transaction__c tran = [SELECT Id, API_Request_JSON__c, API_Response_JSON__c
                                        FROM API_Transaction__c
                                        WHERE hasEndpointParameters__c = true
                                        WITH SECURITY_ENFORCED
                                        LIMIT 1]; 
    
    APITransactionCls.cls_JsonReqResWrapper wrapObj = APITransactionCls.getApiTransactionList(tran.Id);
    
    System.assertEquals('',wrapObj.jsonRes);       
}
}