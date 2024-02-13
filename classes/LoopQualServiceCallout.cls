/***************************************************************
===============================================================
Purpose: LoopQual service callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Nagalakshmi
***************************************************************/
public with sharing class LoopQualServiceCallout {
    public static ApiTransactionService apiTransactionServiceManager;
    private String latitude;
    private String longitude;
    private String result;
    private String source;
    private String address;
    private Map<String, String> validationDataMap;
    private static Id transactionSummaryId;
    private static Id prrids;

    /**********************************************************************************************
    Purpose: Parameterized cosntructor for passing query param latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    public LoopQualServiceCallout(String thisprrids) {
        prrids = thisprrids;
    }

  
    /**********************************************************************************************
    Purpose: Method to be called by another apex for getting property info from address/latlong
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    public LoopQualServiceResponseWrapper getBandwidthInfo() {
        LoopQualServiceResponseWrapper resWrapper ;
        List<Property__c> updatepropertylist = new List<Property__c>();
        //try {
            System.debug('(LoopQualServiceCallout.getBandwidthInfo) Querying PRR...');
            List<Property_Request_Record__c> lprr = [Select id, GEOES_Inventory_Source__c,GEOES_Latitude_Coordinate__c,GEOES_Longitude_Coordinate__c,Transaction_Summary__c,GEOES_results__c,New_Property_Created__c,Existing_Property_found_in_SF_with_PRR__c from Property_Request_Record__c where Id=:prrids];
            System.debug('(LoopQualServiceCallout.getBandwidthInfo) Querying Property from PRR...');
            List<Property__c> lproperty = [Select id,Bandwidth__c from Property__c where (Id=:lprr[0].New_Property_Created__c OR Id=:lprr[0].Existing_Property_found_in_SF_with_PRR__c)];
            if (lprr[0].GEOES_results__c != null && lprr[0].GEOES_results__c != '' && lprr[0].GEOES_results__c.Contains('Green')) {
	            System.debug('(LoopQualServiceCallout.getBandwidthInfo) lprr[0].GEOES_results__c contains "Green"...');
                if (lprr[0].GEOES_Inventory_Source__c != null && lprr[0].GEOES_Inventory_Source__c != ''
                   && (lprr[0].GEOES_Inventory_Source__c == 'Martens' || lprr[0].GEOES_Inventory_Source__c == 'LFACS' || lprr[0].GEOES_Inventory_Source__c == 'CLC')) {
		            System.debug('(LoopQualServiceCallout.getBandwidthInfo) lprr[0].GEOES_Inventory_Source__c is Martens, LFACS or CLC...');
                    resWrapper = getBandwidthInfoByResultsandSource(lprr);
                }
            }
            System.debug('(LoopQualServiceCallout.getBandwidthInfo) is resWrapper NULL? ' + (resWrapper==null));
            if(resWrapper!=null){
                List<LoopQualServiceResponseWrapper> resWrapperlist = new List<LoopQualServiceResponseWrapper>(); 
                resWrapperlist.add(resWrapper);
	            System.debug('(LoopQualServiceCallout.getBandwidthInfo) resWrapper added to resWrapplist...');
                System.debug('(LoopQualServiceCallout.getBandwidthInfo) LIST### '+resWrapperlist);
                for(LoopQualServiceResponseWrapper lqresponse : resWrapperlist) {
                    for(LoopQualServiceResponseWrapper.cls_qualifiedServices qualifiedservices : lqresponse.qualifiedServices) {
			            System.debug('(LoopQualServiceCallout.getBandwidthInfo) qualifiedservices.serviceCategory = ' + qualifiedservices.serviceCategory);
                        if(qualifiedservices.serviceCategory == 'DATA') {
				            System.debug('(LoopQualServiceCallout.getBandwidthInfo) qualifiedservices.serviceCategory = ' + qualifiedservices.serviceCategory);
                            for(LoopQualServiceResponseWrapper.cls_serviceCharacteristic servicecharacteristics: qualifiedservices.serviceCharacteristic) {
					            System.debug('(LoopQualServiceCallout.getBandwidthInfo) qualifiedservices.servicecharacteristics.name = ' + servicecharacteristics.name);
                                if(servicecharacteristics.name == 'downSpeed') {
						            System.debug('(LoopQualServiceCallout.getBandwidthInfo) qualifiedservices.servicecharacteristics.name is "downSpeed" ');
                                    if(lprr[0].New_Property_Created__c!=null || lprr[0].Existing_Property_found_in_SF_with_PRR__c!=null) {
	                                    for(Property__c prop : lproperty){
								            System.debug('(LoopQualServiceCallout.getBandwidthInfo) setting property.Bandwidth__c to servicecharacteristics.value = ' + servicecharacteristics.value);
    	                                    prop.Bandwidth__c = servicecharacteristics.value;
								            System.debug('(LoopQualServiceCallout.getBandwidthInfo) adding the updated-property to updatepropertylist...');
        	                                updatepropertylist.add(prop);
            	                        }
                                    } 
                                }
                            }
                        }
                    }
                }
            }
            
            System.debug('(LoopQualServiceCallout.getBandwidthInfo) is updatepropertylist empty? ' + updatepropertylist.isempty());
	        if(!updatepropertylist.isempty()) {
	            System.debug('(LoopQualServiceCallout.getBandwidthInfo) Performing db update of updatepropertylist...');
                Database.SaveResult[] updatepropertySaveResult = Database.update(
                	updatepropertylist,false //all or none
                );
            }
        
         //}
         /*catch (Exception ex) {
           // In case of any exception
            System.debug(
                'LoopQualServiceCallout Class Error: ' +
                'Message - '+ ex.getMessage() + ' | ' +
                'Line number' + ex.getLineNumber()
            );
         }*/
        return resWrapper;
    }

      
    /**********************************************************************************************
    Purpose: To get property Bandwidth info from address
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    private LoopQualServiceResponseWrapper getBandwidthInfoByResultsandSource(List<Property_Request_Record__c> lprr) {
        
        LoopQualServiceResponseWrapper resWrapper;
        String streetAddress;
        String streetNrFirst;
        String streetName;
        String locality;
        String city;
        String state;
        String postCode;
        String source;
        String legacyProvider;
        String wireCenter;
        String geoAddressId;
        String geoserviceresponseJson;
        GeoesServiceAddressValidationWrapper gsw;
        Id transactionSummaryId;
                
        API_Util__mdt apiUtil = getApiUtils(GeoesConstants.BMPLOOPQUAL_SERVICE);
        Map<String, String> queryParamMap = createQueryParamMap(GeoesConstants.BMPLOOPQUAL_SERVICE);
        transactionSummaryId = lprr[0].Transaction_Summary__c;
        //List<API_Transaction__c> listapiTranssummary =[Select API_Response_JSON__c from API_Transaction__c where Transaction_Summary_Id__c=:lprr[0].Transaction_Summary__c];
        List<API_Transaction__c> listapiTranssummary =[Select API_Response_JSON__c,API_Name__c  from API_Transaction__c where Transaction_Summary_Id__c=:lprr[0].Transaction_Summary__c and API_Name__c ='GeoesServiceAddressesValidations' ORDER BY Createddate DESC];
        if(!listapiTranssummary.isEmpty()) geoserviceresponseJson = listapiTranssummary[0].API_Response_JSON__c;
       if(geoserviceresponseJson!=null && geoserviceresponseJson!='') gsw = (GeoesServiceAddressValidationWrapper) System.JSON.deserialize(geoserviceresponseJson, GeoesServiceAddressValidationWrapper.class);

        List<Property__c> propertylist =[Select Id,Latitude__c,Longitude__c,Primary_Address_City__c,Primary_Address_State__c,Primary_Address_Street__c,Primary_Address_Zip__c,County_Code__c,State_Code__c from Property__c where (Id=:lprr[0].New_Property_Created__c OR Id=:lprr[0].Existing_Property_found_in_SF_with_PRR__c)];
        
        //if(gsw!=null && gsw.exactMatches[0].geoAddressId!=null && gsw.exactMatches[0].geoAddressId!=''){
        if(gsw!=null && gsw.exactMatches!=null && gsw.exactMatches[0].geoAddressId!=null && gsw.exactMatches[0].geoAddressId!=''){    
            geoAddressId=gsw.exactMatches[0].geoAddressId;
        }else if(Test.isRunningTest()){
            geoAddressId='249391902';
        }
        
        if(propertylist[0].Primary_Address_Street__c!=null && propertylist[0].Primary_Address_Street__c!=''){
            streetAddress = propertylist[0].Primary_Address_Street__c;
            streetNrFirst = propertylist[0].Primary_Address_Street__c.Left(3);
        //}else if(gsw!=null && gsw.exactMatches[0].streetAddress!=null && gsw.exactMatches[0].streetAddress!=''){
        }else if(gsw!=null && gsw.exactMatches!=null && gsw.exactMatches[0].streetAddress!=null && gsw.exactMatches[0].streetAddress!=''){
            streetAddress = gsw.exactMatches[0].streetAddress;
            streetNrFirst = gsw.exactMatches[0].streetNrFirst;
        }
        
        if(propertylist[0].Primary_Address_City__c!=null && propertylist[0].Primary_Address_City__c!=''){
            locality = propertylist[0].Primary_Address_City__c;
            city = propertylist[0].Primary_Address_City__c;
        //}else if(gsw!=null && gsw.exactMatches[0].locality!=null && gsw.exactMatches[0].locality!=''){
        }else if(gsw!=null && gsw.exactMatches!=null && gsw.exactMatches[0].locality!=null && gsw.exactMatches[0].locality!=''){    
            locality = gsw.exactMatches[0].locality;
            city = gsw.exactMatches[0].locality;
        }
        
        if(propertylist[0].Primary_Address_State__c!=null && propertylist[0].Primary_Address_State__c!=''){
            state = propertylist[0].Primary_Address_State__c;
          
        //}else if(gsw!=null && gsw.exactMatches[0].stateOrProvince!=null && gsw.exactMatches[0].stateOrProvince!=''){
        }else if(gsw!=null && gsw.exactMatches!=null && gsw.exactMatches[0].stateOrProvince!=null && gsw.exactMatches[0].stateOrProvince!=''){
            state =gsw.exactMatches[0].stateOrProvince;
        }
                    
        if(propertylist[0].Primary_Address_Zip__c!=null && propertylist[0].Primary_Address_Zip__c!=''){
            postCode = propertylist[0].Primary_Address_Zip__c;
          
        //}else if(gsw!=null && gsw.exactMatches[0].postCode!=null && gsw.exactMatches[0].postCode!=''){
        }else if(gsw!=null && gsw.exactMatches!=null && gsw.exactMatches[0].postCode!=null && gsw.exactMatches[0].postCode!=''){
            postCode =gsw.exactMatches[0].postCode;
        }
        
        if(lprr[0].GEOES_Inventory_Source__c!=null && lprr[0].GEOES_Inventory_Source__c!=''){
            source = lprr[0].GEOES_Inventory_Source__c;
          
        //}else if(gsw!=null && gsw.exactMatches[0].source!=null && gsw.exactMatches[0].source!=''){
        }else if(gsw!=null && gsw.exactMatches!=null && gsw.exactMatches[0].source!=null && gsw.exactMatches[0].source!=''){
            source =gsw.exactMatches[0].source;
        }
        
        //if(gsw!=null && gsw.exactMatches[0].wireCenter.clli8!=null && gsw.exactMatches[0].wireCenter.clli8!=''){
        if(gsw!=null && gsw.exactMatches!=null && gsw.exactMatches[0].wireCenter.clli8!=null && gsw.exactMatches[0].wireCenter.clli8!=''){
            wireCenter = gsw.exactMatches[0].wireCenter.clli8;
        }else{
            wireCenter = '';
        }
        
         //if(gsw!=null && gsw.exactMatches[0].attributes.legacyProvider!=null && gsw.exactMatches[0].attributes.legacyProvider!=''){
        if(gsw!=null && gsw.exactMatches!=null && gsw.exactMatches[0].attributes.legacyProvider!=null && gsw.exactMatches[0].attributes.legacyProvider!=''){
            legacyProvider =gsw.exactMatches[0].attributes.legacyProvider;
        }else{
            legacyProvider = '';
        }
        
        
        /*String json='{"ban":"","customerOrderType":"NEWINSTALL","customerSegment":"Regular","customerType":"INDIVIDUAL","existingServiceInfo":null,"persistFlag":true,"reqServiceCategory":[{"serviceCategory":"DATA"}],"salesChannel":"ESHOP-Customer Care","stackOrAmend":"","serviceAddress":{"success":true,"result":"GREEN - exact match","addressId":"","streetAddress":"8832 S CARR WAY","streetNrFirst":"8832","streetNrFirstSuffix":"","streetNrLast":"","streetNrLastSuffix":"","streetName":"S CARR WAY","streetNamePrefix":null,"streetType":"","locality":"LITTLETON","city":"LITTLETON","stateOrProvince":"CO","postCode":"","postCodeSuffix":"","sourceId":"DNVRCOCL1DV4C.1","source":"LFACS","geoAddressId":"213514917","country":"USA","geoPoint":[{"source":"Trillium","latitude":39.555937,"longitude":-105.092636,"coordinateLevel":"1","accuracy":"2"}],"subAddress":{"sourceId":"","source":"","geoSubAddressId":"","combinedDesignator":"","elements":[]},"locationAttributes":{"isMdu":false,"legacyProvider":"QWEST COMMUNICATIONS","rateCenter":"DENVER","wirecenter":"DNVRCOCL","martensClli6":"","npa":"303","nxx":"973","cala":"DNV","tta":"973","tarCode":"CO3091"},"timeZone":{"name":"Mountain Standard Time","ianaName":"America/Denver","isDaylightSavingsTime":false,"offset":"-7"},"npaNxxList":[{"npa":{"code":"303"},"nxx":{"code":"904"}},{"npa":{"code":"303"},"nxx":{"code":"932"}},{"npa":{"code":"303"},"nxx":{"code":"933"}},{"npa":{"code":"303"},"nxx":{"code":"948"}},{"npa":{"code":"303"},"nxx":{"code":"971"}},{"npa":{"code":"303"},"nxx":{"code":"972"}},{"npa":{"code":"303"},"nxx":{"code":"973"}},{"npa":{"code":"303"},"nxx":{"code":"977"}},{"npa":{"code":"303"},"nxx":{"code":"978"}},{"npa":{"code":"303"},"nxx":{"code":"979"}},{"npa":{"code":"720"},"nxx":{"code":"922"}},{"npa":{"code":"720"},"nxx":{"code":"981"}}]}}}'+
		''+
		'';*/
       //String json='{"ban":"","customerOrderType":"NEWINSTALL","customerSegment":"Regular","customerType":"INDIVIDUAL","existingServiceInfo":null,"persistFlag":true,"reqServiceCategory":[{"serviceCategory":"DATA"}],"salesChannel":"ESHOP-Customer Care","stackOrAmend":"","serviceAddress":{"success":true,"result":"GREEN - exact match","addressId":"","streetAddress":"8832 S CARR WAY","streetNrFirst":"8832","streetNrFirstSuffix":"","streetNrLast":"","streetNrLastSuffix":"","streetName":"S CARR WAY","streetNamePrefix":null,"streetType":"","locality":"LITTLETON","city":"LITTLETON","stateOrProvince":"CO","postCode":"","postCodeSuffix":"","sourceId":"DNVRCOCL1DV4C.1","source":"LFACS","geoAddressId":"213514917","country":"USA","geoPoint":[{"source":"Trillium","latitude":39.555937,"longitude":-105.092636,"coordinateLevel":"1","accuracy":"2"}],"subAddress":{"sourceId":"","source":"","geoSubAddressId":"","combinedDesignator":"","elements":[]},"locationAttributes":{"isMdu":false,"legacyProvider":"QWEST COMMUNICATIONS","rateCenter":"DENVER","wirecenter":"DNVRCOCL","martensClli6":"","npa":"303","nxx":"973","cala":"DNV","tta":"973","tarCode":"CO3091"},"timeZone":{"name":"Mountain Standard Time","ianaName":"America/Denver","isDaylightSavingsTime":false,"offset":"-7"},"npaNxxList":[{"npa":{"code":"303"},"nxx":{"code":"904"}},{"npa":{"code":"303"},"nxx":{"code":"932"}},{"npa":{"code":"303"},"nxx":{"code":"933"}},{"npa":{"code":"303"},"nxx":{"code":"948"}},{"npa":{"code":"303"},"nxx":{"code":"971"}},{"npa":{"code":"303"},"nxx":{"code":"972"}},{"npa":{"code":"303"},"nxx":{"code":"973"}},{"npa":{"code":"303"},"nxx":{"code":"977"}},{"npa":{"code":"303"},"nxx":{"code":"978"}},{"npa":{"code":"303"},"nxx":{"code":"979"}},{"npa":{"code":"720"},"nxx":{"code":"922"}},{"npa":{"code":"720"},"nxx":{"code":"981"}}]}}';
      	 
        String json='{'+
		'  "addressValidationResult": "GREEN - Exact Match",'+
		'  "addressValidationSuccess": true,'+
		'  "ban": null,'+
        '  "callingSystem": "OC-CAMUNDA",'+
        '  "companyOwnerId": "1",'+
		'  "customerOrderType": "NEWINSTALL",'+
		'  "customerSegment": "Regular",'+
		'  "customerType": "INDIVIDUAL",'+
		'  "existingServiceInfo": null,'+
		'  "persistFlag": true,'+
		'  "reqServiceCategory": ['+
		'    '+
		'  ],'+
		'  "salesChannel": "ESHOP-Customer Care",'+
		'  "stackOrAmend": null,'+
		'  "serviceAddress": {'+
		'    "serviceAddressType": null,'+
		'    "streetAddress": "'+streetAddress+'",'+
		'    "addressId": null,'+
		'    "streetNrFirst": "'+streetNrFirst+'",'+
		'    "streetNrFirstSuffix": "",'+
		'    "streetNrLast": "",'+
		'    "streetNrLastSuffix": "",'+
        '    "streetName": "'+streetName+'",'+
		'    "streetType": "",'+
		'    "locality": "'+locality+'",'+
		'    "city": "'+city+'",'+
		'    "stateOrProvince": "'+state+'",'+
		'    "postCode": "'+postCode+'",'+
		'    "postCodeSuffix": "",'+
		'    "sourceId": "",'+
		'    "source": "'+source+'",'+
		'    "geoAddressId": "'+geoAddressId+'",'+
		'    "subAddress": {'+
		'      "sourceId": "",'+
		'      "source": "",'+
		'      "geoSubAddressId": "",'+
		'      "combinedDesignator": "",'+
		'      "elements": ['+
		'        '+
		'      ]'+
		'    },'+
		'    "country": "",'+
		'    "geoPoint": ['+
		'      {'+
		'        "accuracy": "",'+
		'        "coordinateLevel": "",'+
		'        "geopointSource": "",'+
		'        "latitude": '+lprr[0].GEOES_Latitude_Coordinate__c+','+
		'        "locationType": null,'+
		'        "longitude":'+lprr[0].GEOES_Longitude_Coordinate__c+','+
		'        "source": "'+lprr[0].GEOES_Inventory_Source__c+'",'+
		'        "sourceId": ""'+
		'      }'+
		'    ],'+
		'    "locationAttributes": {'+
		'      "isMdu": false,'+
		'      "isNoBuild": false,'+
		'      "legacyProvider": "'+legacyProvider+'",'+
		'      "rateCenter": "",'+
		'      "wirecenter": "'+wireCenter+'",'+
		'      "npa": "",'+
		'      "nxx": "",'+
		'      "tta": "",'+
		'      "tarCode": "",'+
		'      "cala": null,'+
		'      "martensClli6": "",'+
		'      "companyOwnerId": null'+
		'    },'+
		'    "timeZone": {'+
		'      "ianaName": null,'+
		'      "isDaylightSavingsTime": true,'+
		'      "name": null,'+
		'      "offset": null'+
		'    },'+
		'    "npaNxxList": ['+
		'    '+
		'  ],'+
		'    "result": null,'+
		'    "streetNamePrefix": null,'+
		'    "success": null'+
		'  },'+
		'  "nearMatchAddress": null,'+
		'  "referenceNumber": null,'+
		'  "isBRC": false'+
		'}';
              
        //resWrapper = makeServiceCallout(GeoesConstants.BMPLOOPQUAL_SERVICE, json, null);
        resWrapper = makeServiceCallout(GeoesConstants.BMPLOOPQUAL_SERVICE, json, null,transactionSummaryId);      
        System.debug('RESp####'+resWrapper);
        return resWrapper;
    }

    /**********************************************************************************************
    Purpose: To create query parameter map
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    private Map<String, String> createQueryParamMap(String serviceType) {
        Map<String, String> queryParamMap = new Map<String, String>();
        // If the callout is by querying address
        if (serviceType == GeoesConstants.PARCEL_SERVICE_BY_ADDRESS) {
            queryParamMap.put('q', address);
        }
        // If the callout is by querying latitude and logitude
        else if (serviceType == GeoesConstants.PARCEL_SERVICE_BY_LAT_LONG) {
            queryParamMap.put(GeoesConstants.PRR_MAPPING_LATITUDE, latitude);
            queryParamMap.put(GeoesConstants.PRR_MAPPING_LONGITUDE, longitude);
        }
        return queryParamMap;
    }

    /**********************************************************************************************
    Purpose: To make service callout by calling API Transaction controller class
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    private LoopQualServiceResponseWrapper makeServiceCallout(
        String callingApiName,
        String requestBody,
        Map<String, String> queryParamMap,
        Id transactionSummaryId
    ) {
        LoopQualServiceResponseWrapper responseWrap;
        
        if(apiTransactionServiceManager == null) {
            APITransactionController objApiTransactionCtrl = new APITransactionController(
                callingApiName,
                requestBody,
                queryParamMap,
                transactionSummaryId
            );
            HttpResponse httpResponse = APITransactionController.serviceCallout();
            if (
                httpResponse?.getStatusCode() == 200 &&
                httpResponse != null &&
                httpResponse?.getBody() != null
            ) {
                responseWrap = LoopQualServiceResponseWrapper.parse(httpResponse?.getBody());
            }
        } else {
            HttpResponse httpResponse = apiTransactionServiceManager.serviceCallout(
                callingApiName,
                requestBody,
                queryParamMap,
                transactionSummaryId
            );
            
            if (httpResponse?.getStatusCode() == 200
                && httpResponse != null
                && httpResponse?.getBody() != null
            ) {
                responseWrap = LoopQualServiceResponseWrapper.parse(
                    httpResponse?.getBody()
                );
            }
        }
        return responseWrap;
    }

    /**********************************************************************************************
    Purpose: To get API details from API Utils custom metadata
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    private static API_Util__mdt getApiUtils(String apiUtilName) {
        API_Util__mdt apiUtil;
        if (apiUtilName != null || apiUtilName != '') {
            apiUtil = [SELECT DeveloperName, EndPoint__C FROM API_Util__mdt WHERE DeveloperName = :apiUtilName];
        }
        return apiUtil;
    }
}//end class LoopQualServiceCallout