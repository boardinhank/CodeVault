@isTest
public class lmn_APIProperyService_test {
    
         @testSetup
     static void setup(){
         property__c newProperty = new property__c();
         newProperty.name = 'New Prop Name';
         newProperty.apn__c = null;
         newProperty.state_code__c = null;
         newProperty.county_code__c = null;
         newProperty.unique_id__c = null;
         newProperty.Longitude__c = -104.840398;
         newProperty.Latitude__c = 38.79295;
         
         insert newProperty;   
         
         property__c newProperty1 = new property__c();
         newProperty1.name = 'New Prop Name';
         newProperty1.apn__c = null;
         newProperty1.state_code__c = null;
         newProperty1.county_code__c = null;
         newProperty1.unique_id__c = null;
         newProperty1.Longitude__c = -104.840398;
         newProperty1.Latitude__c = 38.79295;
         newProperty1.unique_id__c = '041743610500208';
         
         insert newProperty1; 
         
         property__c newProperty2 = new property__c();
         newProperty2.name = 'New Prop Name';
         newProperty2.apn__c = null;
         newProperty2.state_code__c = null;
         newProperty2.county_code__c = null;
         newProperty2.unique_id__c = null;
         newProperty2.Longitude__c = null;
         newProperty2.Latitude__c = null;
         newProperty2.unique_id__c = null;
         newProperty2.Primary_Address_Street__c = '3912 e westbrook';
         newProperty2.Primary_Address_City__c = 'my city';
         newProperty2.Primary_Address_State__c = 'az';
         
         insert newProperty2; 
     }
    
    @isTest
    static void propertyTestLatLong(){
        list<property__c> getProperties = [select id, name, longitude__c, Latitude__c, county_code__c, state_code__c, apn__c, createddate from property__c where
                                  		unique_id__c = null and longitude__c != null and latitude__c != null];
        lmn_APIProperyService.createCallout(getProperties, 'latLong', 'test');  
    }
    
    @isTest
    static void propertyTestAddress(){
        list<property__c> getProperties1 = [select id, name, longitude__c, Latitude__c, county_code__c, state_code__c, apn__c, createddate, Primary_Address_Street__c,
                                              Primary_Address_City__c, Primary_Address_State__c from property__c where Primary_Address_State__c = 'az'];
        system.debug('@@@@@ Address: '+getProperties1);
        lmn_APIProperyService.createCallout(getProperties1, 'address', 'test');  
    }
    
    @isTest
    static void propertyCommit(){
        list<property__c> getProperties = [select id, name, longitude__c, Latitude__c, county_code__c, state_code__c, apn__c, createddate from property__c where
                                  		unique_id__c = null and longitude__c != null and latitude__c != null];
        lmn_APIProperyService.createCallout(getProperties, 'latLong', 'commit');  
    }
    
    

}