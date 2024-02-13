public with sharing class APITransactionCls {
  @AuraEnabled(Cacheable=true)
  public Static cls_JsonReqResWrapper getApiTransactionList(String transId){
    List<API_Transaction__c> transactionList = [SELECT Id,hasEndpointParameters__c,API_Request_JSON__c,API_Response_JSON__c,API_Status__c FROM API_Transaction__c WHERE Id =:transId LIMIT 1];
    cls_JsonReqResWrapper wrapObj = new cls_JsonReqResWrapper();
    wrapObj.jsonReq = transactionList[0].API_Request_JSON__c !=NULL ? transactionList[0].API_Request_JSON__c : '';
    wrapObj.jsonRes = transactionList[0].API_Response_JSON__c !=NULL ? transactionList[0].API_Response_JSON__c : '';
    wrapObj.apistatus = transactionList[0].API_Status__c != NULL ? transactionList[0].API_Status__c : '';
    wrapObj.hasEndpointParams = transactionList[0].hasEndpointParameters__c ;
    return wrapObj;
  }
  public class cls_JsonReqResWrapper{
    @AuraEnabled
    public String jsonReq{get;set;}
    @AuraEnabled
    public String jsonRes{get;set;}
    @AuraEnabled
    public String apistatus{get;set;}
    @AuraEnabled
    public Boolean hasEndpointParams{get;set;}
  }
}