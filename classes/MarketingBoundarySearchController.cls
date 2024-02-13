public class MarketingBoundarySearchController {
 @AuraEnabled
    public static List<String> searchBoundry(string boundaryID) {
        
        List<String> responseData = new List<String>();
        API_Util__mdt apiUtil = API_Util__mdt.getInstance('UniqualServiceDelivery');
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse;        
            httpRequest.setMethod('GET');
            httpRequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
            httpRequest.setTimeout(60000);
        if(!String.isBlank(boundaryId)){
            
            httpRequest.setEndpoint(apiUtil.EndPoint__c+'id'+'='+boundaryId); 
            
            httpResponse = http.send(httpRequest);
            
            ResponseParser response = (ResponseParser) System.JSON.deserialize(httpResponse.getBody(), ResponseParser.class);
            
            string boundryname=response.marketingBoundary.boundaryName;
            string id=response.marketingBoundary.boundaryId;
            string totalparcels=response.marketingBoundary.totalParcels;
            string bandwidth=response.marketingBoundary.bandwidth;
            string wirecenterclli=response.marketingBoundary.wireCenterClli;
            string rescity=response.marketingBoundary.city;
            string resstate=response.marketingBoundary.state;
            string reszip=response.marketingBoundary.zip;
            
            responseData.add(boundryname);
             responseData.add(id);
             responseData.add(totalparcels);
            responseData.add(wirecenterclli);
             responseData.add(bandwidth);
             
             responseData.add(rescity);
             responseData.add(resstate);
            responseData.add(reszip);
           
        }
        return responseData;
        }
    @AuraEnabled
    public static List<String> searchBoundrywithName(string boundaryName) {
        List<String> responseData = new List<String>();
        //string boundarynameRec = boundaryName.toUppercase();
        API_Util__mdt apiUtil = API_Util__mdt.getInstance('UniqualServiceDelivery');
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse;        
            httpRequest.setMethod('GET');
            httpRequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
            httpRequest.setTimeout(60000);
            httpRequest.setEndpoint(apiUtil.EndPoint__c+'name'+'='+boundaryName.replaceAll(' ','%20'));  
            
            httpResponse = http.send(httpRequest);
            
            
            ResponseParser response = (ResponseParser) System.JSON.deserialize(httpResponse.getBody(), ResponseParser.class);
            string boundryname=response.marketingBoundary.boundaryName;
            string id=response.marketingBoundary.boundaryId;
            string totalparcels=response.marketingBoundary.totalParcels;
            string bandwidth=response.marketingBoundary.bandwidth;
            string wirecenterclli=response.marketingBoundary.wireCenterClli;
            string rescity=response.marketingBoundary.city;
            string resstate=response.marketingBoundary.state;
            string reszip=response.marketingBoundary.zip;
            
            responseData.add(boundryname);
             responseData.add(id);
             responseData.add(totalparcels);
            responseData.add(wirecenterclli);
             responseData.add(bandwidth);
             
             responseData.add(rescity);
             responseData.add(resstate);
            responseData.add(reszip);
           
        return responseData;
    }
    @AuraEnabled
    public static List<String> searchBoundrywithAddress(string boundaryAddress) {
        List<String> responseData = new List<String>();
        API_Util__mdt apiUtil = API_Util__mdt.getInstance('ParcelServiceByAddress');
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse;        
            httpRequest.setMethod('GET');
            httpRequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
            httpRequest.setTimeout(60000);
            httpRequest.setEndpoint(apiUtil.EndPoint__c+'q='+EncodingUtil.urlEncode(boundaryAddress, 'UTF-8')+'&includeMarketBoundaries='+true+'&limitResponse='+false);
            
            httpResponse = http.send(httpRequest);
            
            ResponseParser response = (ResponseParser) System.JSON.deserialize(httpResponse.getBody(), ResponseParser.class);
            string id=response.parcelMarketingBoundary.marketingBoundaryId;
           
        if(!Test.isRunningTest()){
            responseData = searchBoundry(id);
        }
        
         return responseData;
    }
     @AuraEnabled
    public static List<String> searchBoundrywithLatLong(string latitudeval,string longituteVal) {
        List<String> responseData = new List<String>();
        
        API_Util__mdt apiUtil = API_Util__mdt.getInstance('ParcelServiceByLatLong');
        
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse;        
            httpRequest.setMethod('GET');
            httpRequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
            httpRequest.setTimeout(60000);
            httpRequest.setEndpoint(apiUtil.EndPoint__c+'latitude'+'='+latitudeval+'&longitude='+longituteVal+'&includeMarketBoundaries='+true+'&limitResponse='+false);
            
            httpResponse = http.send(httpRequest);
            
            
            ResponseParser response = (ResponseParser) System.JSON.deserialize(httpResponse.getBody(), ResponseParser.class);
            string id=response.parcelMarketingBoundary.marketingBoundaryId;
           
          if(!Test.isRunningTest()){
            responseData = searchBoundry(id);
          }
        
         return responseData;
    }
    public class ResponseParser{
        public marketingBoundary marketingBoundary;
        public parcelMarketingBoundary parcelMarketingBoundary;
        
        public ResponseParser parse(String json){
            return (ResponseParser) System.JSON.deserialize(json, ResponseParser.class);
        }
    }
    public class marketingBoundary{
        public String totalParcels;
        public String boundaryId;
        public String boundaryName;
        public String developerName;
        public String bandwidth;
        public String wireCenterClli;
        public String city;
        public String state;
        public String zip;
       
    }
    public class parcelMarketingBoundary{
         public string marketingBoundaryId;
    }
    
    
@AuraEnabled
public static void saveBoundaryInfo(List<string> boundaryInfoList,Id recordId) { 
     Property__c propertyObj = new Property__c();
    propertyObj.Id = recordId;
    if(boundaryInfoList[0] != ''){
    propertyObj.Boundary_Name_Res__c = boundaryInfoList[0];
    }else{
        propertyObj.Boundary_Name_Res__c = null;
    }
    if(boundaryInfoList[1] != ''){
        propertyObj.Boundary_ID_Res__c = Decimal.valueOf(boundaryInfoList[1]);
    }else{
            propertyObj.Boundary_ID_Res__c = null;
        }
      if(boundaryInfoList[2] != ''){
          propertyObj.Number_of_tax_parcels_inside_of_boundary__c = Decimal.valueOf( boundaryInfoList[2]);
      }else{
          propertyObj.Number_of_tax_parcels_inside_of_boundary__c = null;
      }
    if(boundaryInfoList[3] != ''){
        propertyObj.Wire_center_CLLI_code__c = boundaryInfoList[3];
    }else{
            propertyObj.Wire_center_CLLI_code__c = null;
        }
    if(boundaryInfoList[4] != ''){
        propertyObj.Max_Bandwidth__c =Decimal.valueOf(boundaryInfoList[4]);
    }else{
            propertyObj.Max_Bandwidth__c = null;
        }
    if(boundaryInfoList[5] != ''){
        propertyObj.City_Res__c = boundaryInfoList[5];
    }else{
        propertyObj.City_Res__c = null;
    }
    if(boundaryInfoList[6] != ''){
        propertyObj.State_Res__c = boundaryInfoList[6];
    }else{
        propertyObj.State_Res__c = null;
    }
    if(boundaryInfoList[7] != ''){
        propertyObj.Zip_Res__c =Decimal.valueOf(boundaryInfoList[7]);
    }else{
        propertyObj.Zip_Res__c = null;
    }
    upsert propertyObj;
    }   
    @AuraEnabled
    public static List<Property__c> fetchBoundaryInfo(Id recordId){
        List<Property__c> boundaryInfoList = [SELECT Id,Boundary_Name_Res__c,Boundary_ID_Res__c,Number_of_tax_parcels_inside_of_boundary__c,
                                             Wire_center_CLLI_code__c,Max_Bandwidth__c,City_Res__c,State_Res__c,Zip_Res__c from Property__c where Id =: recordId];
        if(boundaryInfoList!= null || !boundaryInfoList.isEmpty()){
           
        return boundaryInfoList;
        }
        else{
            return null;
        }
        
    }
            
}