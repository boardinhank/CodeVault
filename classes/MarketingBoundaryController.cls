public class MarketingBoundaryController {
    @AuraEnabled 
    public static void searchBoundry(Map<String, string> parms) {
        System.debug('parms'+parms);
        string boundaryId;
        string boundaryName;
        string boundaryAddress;
        string marketingPolygon;
        string boundaryLatitude;
        string boundaryLongitude;
        API_Util__mdt apiUtil = API_Util__mdt.getInstance('UniqualServiceDelivery');
        System.debug('apiUtil'+apiUtil);
        Http http = new Http();
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResponse;        
        httpRequest.setMethod('GET');
        httpRequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
        httpRequest.setTimeout(60000);
        
        if(parms.containsKey('Boundary_ID')){
            boundaryId = parms.get('Boundary_ID');
            System.debug('endpoint Boundary_Id__c -->'+apiUtil.Boundary_Id__c);
            httpRequest.setEndpoint(apiUtil.Boundary_Id__c+'='+boundaryId); 
            System.debug('endpoint1--->'+httpRequest.getEndpoint());
            httpResponse = http.send(httpRequest);
            System.debug('response1--->'+httpResponse.getBody());
            ResponseParser response = (ResponseParser) System.JSON.deserialize(httpResponse.getBody(), ResponseParser.class);
            // Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());
            // System.debug('responseMap--->'+response.marketingBoundary.boundaryName);
            string boundryname=response.marketingBoundary.boundaryName;
            string id=response.marketingBoundary.boundaryId;
            string totalparcels=response.marketingBoundary.totalParcels;
            string developername=response.marketingBoundary.developerName;
            string bandwidth=response.marketingBoundary.bandwidth;
            string wirecenterclli=response.marketingBoundary.wireCenterClli;
            string cityy=response.marketingBoundary.city;
            string statee=response.marketingBoundary.state;
            string zipp=response.marketingBoundary.zip;
            
            System.debug('boundryname--->'+boundryname); 
            System.debug('totalparcels--->'+totalparcels); 
            System.debug('developername--->'+developername); 
            System.debug('bandwidth--->'+bandwidth);
            System.debug('boundaryId--->'+boundaryId);
            System.debug('wirecenterclli--->'+wirecenterclli);
            System.debug('cityy--->'+cityy);
            System.debug('statee--->'+statee);
            System.debug('zipp--->'+zipp);
            
        }else if(parms.containsKey('Boundary_Name')){
            boundaryName = parms.get('Boundary_Name');
            //string boundryNameFormatted = boundryName.replaceAll('+','%');
            System.debug('boundaryName'+boundaryName);
            System.debug('endpoint Boundary_Name__c -->'+apiUtil.Boundary_Name__c);
            httpRequest.setEndpoint(apiUtil.Boundary_Name__c+'='+boundaryName.replaceAll(' ','%')); 
            System.debug('endpoint2--->'+httpRequest.getEndpoint());
            httpResponse = http.send(httpRequest);
            System.debug('response2--->'+httpResponse.getBody());
            
            ResponseParser response = (ResponseParser) System.JSON.deserialize(httpResponse.getBody(), ResponseParser.class);
            // Map<String,Object> responseMap = (Map<String,Object>)JSON.deserializeUntyped(httpResponse.getBody());
            System.debug('responseMap--->'+response.marketingBoundary.boundaryName);
            string boundryname=response.marketingBoundary.boundaryName;
            string id=response.marketingBoundary.boundaryId;
            string totalparcels=response.marketingBoundary.totalParcels;
            string developername=response.marketingBoundary.developerName;
            string bandwidth=response.marketingBoundary.bandwidth;
            
            //object parcelsList = responseMap.get('marketingBoundary');
            System.debug('boundryname--->'+boundryname); 
            System.debug('totalparcels--->'+totalparcels); 
            System.debug('developername--->'+developername); 
            System.debug('bandwidth--->'+bandwidth);
            System.debug('boundaryId--->'+boundaryId);
            
        }else if(parms.containsKey('Boundary_Latitude') && parms.containsKey('Boundary_Longitude')){
            boundaryLatitude = parms.get('Boundary_Latitude');
            boundaryLongitude = parms.get('Boundary_Longitude');
            System.debug('endpoint Parcel_Latitude__c -->'+apiUtil.Parcel_Latitude__c);
            httpRequest.setEndpoint(apiUtil.Parcel_Latitude__c+'='+boundaryLatitude+'&longitude='+boundaryLongitude+'&includeMarketBoundaries='+true+'&limitResponse='+false); 
            System.debug('endpoint4--->'+httpRequest.getEndpoint());
            httpResponse = http.send(httpRequest);
            System.debug('response4--->'+httpResponse.getBody());   
            
        }else if(parms.containsKey('Boundary_Address') || parms.containsKey('Marketing_Polygon')){
            System.debug('endpoint Marketing_Polygon__c -->'+apiUtil.Marketing_Polygon__c);
            if(parms.get('Boundary_Address')!=null && parms.get('Boundary_Address')!=''){
                boundaryAddress = parms.get('Boundary_Address');   
                httpRequest.setEndpoint(apiUtil.Marketing_Polygon__c+'q='+EncodingUtil.urlEncode(BoundaryAddress, 'UTF-8')+'&includeMarketBoundaries='+true+'&limitResponse='+false); 
            }else if(parms.get('Marketing_Polygon')!=null && parms.get('Marketing_Polygon')!=''){
                marketingPolygon = parms.get('Marketing_Polygon');
                httpRequest.setEndpoint(apiUtil.Marketing_Polygon__c+'q='+EncodingUtil.urlEncode(marketingPolygon, 'UTF-8')+'&includeMarketBoundaries='+true+'&limitResponse='+false); 
            }
            System.debug('endpoint3--->'+httpRequest.getEndpoint());
            httpResponse = http.send(httpRequest);
            System.debug('response3--->'+httpResponse.getBody());
        } 
    }
    public class ResponseParser{
        public marketingBoundary marketingBoundary;
        
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
}