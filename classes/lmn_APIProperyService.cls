/**
* 		Created:  HANK     12/20/23    needed a way to make callouts on properties missing data to see if the data exists now. 
* 
*      MODE: Used to run the method in a debug only (test) to see what the results would be. If things look good
*            then you would run it in a (commit) mode so that the properties are updated.
*
*      list<property__c> getProperties = [select id, name, longitude__c, Latitude__c, county_code__c, state_code__c, apn__c, Primary_Address_Street__c,
*                                           Primary_Address_City__c, Primary_Address_State__c, createddate from property__c where
*                                  		       unique_id__c = null and longitude__c != null and latitude__c != null and distribution_status__c != 'Non Distributable' AND
*                                                 distribution_status__c != 'Redistributed' AND distribution_status__c != 'Distributed' order by createddate desc limit 10];
* 
*      lmn_APIProperyService.createCallout(getProperties, 'address', 'test');  
* 
*/

public with sharing class lmn_APIProperyService {
    
    public static void createCallout(list<property__c> listOfProperties, string calloutType, string mode) {
        
        list<string> listOfUniqueIds = new list<string>();
        set<property__c> setOfPropertiesToUpdate = new set<property__c>();
        set<property__c> setOfDuplicateProperties = new set<property__c>();
        list<property__c> listOfPropertiesToCheck = new list<property__c>();
        map<string,property__c> mapPropertiesToUpdate = new map<string,property__c>();
        map<string,property__c> mapPropertiesToCheck = new map<string,property__c>();
        
        string propertyId, fieldName, fieldValue, parcelId, stateCode, countyCode, apn, uniqueId, endPoint, jsonBody;
        decimal latitude, longitude;
        
        for(property__c property : listOfProperties){    
            
            if(calloutType == 'latLong'){
                endPoint = 'callout:Uniqual_ServiceDelivery_OAuth/Uniqual/ServiceDelivery/Location/api/parcel/point?latitude='+property.Latitude__c+'&longitude='+property.Longitude__c;
            }
            if(calloutType == 'address'){
                // callout:Uniqual_ServiceDelivery_OAuth/Uniqual/ServiceDelivery/Location/api/parcel/address?q=US-192+&+S+Narcoossee+Rd+ST.+CLOUD+FL
                string url = property.Primary_Address_Street__c+'+'+property.Primary_Address_City__c+'+'+property.Primary_Address_State__c;                
                endPoint = 'callout:Uniqual_ServiceDelivery_OAuth/Uniqual/ServiceDelivery/Location/api/parcel/address?q='+EncodingUtil.urlEncode(url, 'UTF-8');                
            }
            
            if(endpoint != null){
                system.debug('%%%% endpoint: '+endpoint);
                HttpRequest req = new HttpRequest();
                req.setEndpoint(endPoint);
                req.setMethod('GET');
                Http http = new Http();
                if(!Test.isRunningTest()){
                    try {
                        HTTPResponse res = http.send(req);
                        jsonBody = res.getBody();
                    } catch(DmlException e) {
                        System.debug('Error trying to make callout to parcel service: ' + e.getMessage());
                    }
                } else {
                    jsonBody = '{"parcelId":"1344855693","stateCode":"08","countyCode":"041","apn":"7436105002","success":true,"errors":[]}';
                }
                System.debug(jsonBody);
                JSONParser parser = JSON.createParser(jsonBody);
                string label = null;
                double version = null;   
                
                while (parser.nextToken() != null) {                   
                    if(parser.getCurrentToken() != JSONToken.END_OBJECT){
                        fieldName = parser.getCurrentName();
                        fieldValue = parser.getText();
                        if(fieldName == 'parcelId' && fieldValue != null){
                            parcelId = fieldValue;
                            //system.debug('parcelId: '+parcelId);
                        }
                        if(fieldName == 'stateCode' && fieldValue != null){
                            stateCode = fieldValue;
                            //system.debug('stateCode: '+stateCode);
                        }
                        if(fieldName == 'countyCode' && fieldValue != null){
                            countyCode = fieldValue;
                            //system.debug('countyCode: '+countyCode);
                        }
                        if(fieldName == 'apn' && fieldValue != null){
                            apn = fieldValue;
                            //system.debug('apn: '+apn);
                        }      
                        if(fieldName != 'apn' && fieldValue != null){
                            string NoMatch = fieldValue;
                            system.debug('NoMatchField: '+fieldName);
                            system.debug('NoMatch: '+NoMatch);
                        }   
                    }
                }
                
                if(apn != null){
                    // need these to index the maps so we can get data 
                    uniqueId = countyCode+apn+stateCode;
                    listOfUniqueIds.add(uniqueId);
                    
                    //Create a property record to be updated
                    property__c updateProperty = new property__c();
                    updateProperty.Id = property.Id;
                    updateProperty.apn__c = apn;
                    updateProperty.County_Code__c = countyCode;
                    updateProperty.State_Code__c = stateCode;
                    updateProperty.Unique_Id__c = uniqueId;
                    
                    if(apn != null && stateCode != null && countyCode != null){
                        mapPropertiesToUpdate.put(uniqueId,updateProperty);
                    } else {
                        // need to tag it with something to prevent it from coming back into the job
                    }
                    
                }  
            }  
        }
        
        if(listOfUniqueIds.size() > 0){
            listOfPropertiesToCheck = [select id, unique_id__c from property__c where unique_id__c IN : listOfUniqueIds];
            
            if(listOfPropertiesToCheck.size() > 0){
                for(property__c checkProperty : listOfPropertiesToCheck){
                    mapPropertiesToCheck.put(checkProperty.unique_id__c, checkProperty);
                }
            }
        }
        
        if(mapPropertiesToCheck.size() > 0){
            for(String key : mapPropertiesToUpdate.keyset()) {
                
                if(mapPropertiesToCheck.containskey(key)){
                    mapPropertiesToUpdate.get(key).unique_id__c = null;
                    mapPropertiesToUpdate.get(key).distribution_status__c = 'Non Distributable';
                    mapPropertiesToUpdate.get(key).Duplicate_Review_Status__c = 'Potential Duplicate';
                    setOfDuplicateProperties.add(mapPropertiesToUpdate.get(key));
                    system.debug('***** Duplicate found: '+mapPropertiesToUpdate.get(key));
                } else {
                    setOfPropertiesToUpdate.add(mapPropertiesToUpdate.get(key));
                    system.debug('##### Update Property: '+mapPropertiesToUpdate.get(key));
                }                    
            }
            
        } else {
                 for(String key : mapPropertiesToUpdate.keyset()) {
                    setOfPropertiesToUpdate.add(mapPropertiesToUpdate.get(key));
                    system.debug('##### Update Property: '+mapPropertiesToUpdate.get(key));
                 }
        }
        
        if(mode == 'test'){
            system.debug('&&&& setOfPropertiesToUpdate: '+setOfPropertiesToUpdate);
            system.debug('&&&& setOfDuplicateProperties: '+setOfDuplicateProperties);
        }
        if(mode == 'commit'){
            try {
                list<property__c> listOfPropertiesToUpdate = new list<property__c>(setOfPropertiesToUpdate);
                update listOfPropertiesToUpdate;
            } catch(DmlException e) {
                System.debug('Error trying to commit propertyUpdate: ' + e.getMessage());
            }
            try {
                list<property__c> listOfDuplicateProperties = new list<property__c>(setOfDuplicateProperties);
                update listOfDuplicateProperties;
            } catch(DmlException e) {
                System.debug('Error trying to commit duplicatePropertyUpdate: ' + e.getMessage());
            }
            
        }
        
    }   // -----  end createCallout 
    
}