/**************************************************************************************************************
===============================================================
Purpose: LoopQual service callout Queueable class
===============================================================
History:

AUTHOR     			DATE        Reference       Description
Naga Lakshmi									Gets Bandwidth available at that point/address
Ted Cabato			06/14/2023	QFCJ-3955       Reinstitute Property Bandwidth into PRR-Property process, converted to Queueable
****************************************************************************************************************/
global with sharing class LoopQualServiceCalloutQueueable implements Queueable, Database.AllowsCallouts {
    public static ApiTransactionService apiTransactionServiceManager;
    public String typeIn;
    public String propIn;
    public Id prrId;
    //public String latitude;
    //public String longitude;
    public String address;
    public String result;
    //public String source;    
    public List<Property_Request_Record__c> prrList;
    private Map<String, String> validationDataMap;
    private Id transactionSummaryIdProp;

    /**********************************************************************************************
    Purpose: Parameterized cosntructor for passing query param latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    // Check with Ted to verify only MarketingBoundaryCalloutservice calls this class.  If so,
    // this constructor can be removed
    public LoopQualServiceCalloutQueueable(String prrIdIn) {
        this.typeIn = 'PRR';
        this.prrId = prrIdIn;
        this.prrList = [SELECT //Id, Name,
                        ProjectAddress__c,
                        ProjectCity__c,
                        ProjectState__c,
                        //GEOES_Inventory_Source__c,
                        //GEOES_Latitude_Coordinate__c,
                        //GEOES_Longitude_Coordinate__c,
                        GEOES_results__c,
                        //Gig_Enabled__c,
                        //Maximum_Available_Speed__c,
                        //Transaction_Summary__c,
                        New_Property_Created__c,
                        Existing_Property_found_in_SF_with_PRR__c
                   FROM Property_Request_Record__c 
                  WHERE Id = :prrIdIn LIMIT 1];
        //this.latitude = String.valueOf(this.prrList[0].GEOES_Latitude_Coordinate__c);
        //this.longitude = String.valueOf(this.prrList[0].GEOES_Longitude_Coordinate__c);
        this.address = this.prrList[0].ProjectAddress__c +'+'+this.prrList[0].ProjectCity__c+'+'+this.prrList[0].ProjectState__c;
        System.debug('(LoopQualServiceCalloutQueueable~prrIdIn) qAddress = ' + this.address);
        this.result = this.prrList[0].GEOES_results__c;
        //this.source = this.prrList[0].GEOES_Inventory_Source__c;
    }

    public LoopQualServiceCalloutQueueable(String typeIn, String objIdIn) {
        System.debug('(LoopQualServiceCalloutQueueable(typeIn, objIdIn) (' + typeIn + ', ' + objIdIn + ')');
        
        this.typeIn = typeIn;
        
        if (this.typeIn == 'PRR'){
            this.prrId = objIdIn;
            this.prrList = [SELECT
                            ProjectAddress__c,
                            ProjectCity__c,
                            ProjectState__c,
                            GEOES_results__c,
                            New_Property_Created__c,
                            Existing_Property_found_in_SF_with_PRR__c
                            FROM Property_Request_Record__c 
                            WHERE Id = :prrId LIMIT 1];
            this.address = this.prrList[0].ProjectAddress__c +'+'+this.prrList[0].ProjectCity__c+'+'+this.prrList[0].ProjectState__c;
            this.result = this.prrList[0].GEOES_results__c;
            System.debug('(LoopQualServiceCalloutQueueable~prrIdIn) qAddress = ' + this.address);
        } else {
            this.propIn = objIdIn;
            this.result = 'Green';
        }
    }
    
    public void execute(QueueableContext ctx) { 
        if (this.typeIn == 'PRR'){
            System.debug('(LoopQualServiceCalloutQueueable.execute) Querying PRR...');
            this.getBandwidthInfo(this.prrList);
        } else if (this.typeIn == 'PROPERTY'){
            System.debug('(LoopQualServiceCalloutQueueable.execute) Querying Property...');
            this.getBandwidthInfoWithProperty(this.propIn);
        } else {
            System.debug('(LoopQualServiceCalloutQueueable.execute) Querying Property(Default)...');
            this.getBandwidthInfoWithProperty(this.propIn);
        }
    }
  
    /**********************************************************************************************
    Purpose: Method to be called by another apex for getting property info from address/latlong
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    public void getBandwidthInfo(List<Property_Request_Record__c> prrList) {
        List<Property__c> propsToUpdList = new List<Property__c>();

        try {
            System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) Querying Property from PRR with Id="' + this.prrList[0].Id + '" (Address="' + this.address + '")...');
            List<Property__c> propertyList = [Select id, Name, Bandwidth__c, Max_Bandwidth__c, Max_Bandwidth_Available__c, Transaction_Summary__c from Property__c where (Id=:this.prrList[0].New_Property_Created__c OR Id=:this.prrList[0].Existing_Property_found_in_SF_with_PRR__c)];
                
            propsToUpdList = processPropertyList(propertyList);
            
            System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) PRR with Id="' + this.prrList[0].Id + '" (Address="' + this.address + '"), is propsToUpdList empty? ' + propsToUpdList.isempty());
	        if (!propsToUpdList.isEmpty()) {
	            System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) PRR with Id="' + this.prrList[0].Id + '" (Address="' + this.address + '"), Performing db update of propsToUpdList...');
                Database.SaveResult[] updatepropertySaveResult = Database.update(propsToUpdList, false); //FALSE means all or none
            }
        
        } catch (Exception methodX) {
           	System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) PRR with Id="' + this.prrList[0].Id + '" (Address="' + this.address + '"), EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
        }
    }//end method getBandwidthInfo

    public void getBandwidthInfoWithProperty(String propIdIn) {
        List<Property__c> propsToUpdList = new List<Property__c>();
        
        try {
            System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfoWithProperty) Querying Property with Id="' + propIdIn);
            List<Property__c> propertyList = [Select id, Name, Bandwidth__c, Max_Bandwidth__c, Max_Bandwidth_Available__c, Transaction_Summary__c from Property__c where Id=:propIdIn];
            
            propsToUpdList = processPropertyList(propertyList);
            
            System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfoWithProperty) Property with Id="' + propIdIn + '", is propsToUpdList empty? ' + propsToUpdList.isempty());
            if (!propsToUpdList.isEmpty()) {
                System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfoWithProperty) Property with Id="' + propIdIn + '", Performing db update of propsToUpdList...');
                Database.SaveResult[] updatepropertySaveResult = Database.update(propsToUpdList, false); //FALSE means all or none
            }
            
        } catch (Exception methodX) {
            System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfoWithProperty) Property with Id="' + propIdIn + '", EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
        }
    }//end method getBandwidthInfoWithProperty

    public List<Property__c> processPropertyList(List<Property__c> propertyList) {
        List<Property__c> propsToUpdList = new List<Property__c>();
        Boolean foundDATA = false;
        LoopQualMaxBandwidthServiceRespWrapper resWrapper;
        
        for (Property__c prop : propertyList) {
            System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) For Property=' + prop.Name +', Address="' + this.address + '", Property Id="' + prop.Id + ', setting foundDATA to FALSE...');
            this.transactionSummaryIdProp = prop.Transaction_Summary__c;
            foundDATA = false;
            prop.Bandwidth__c = null;
            if (String.isNotEmpty(this.result) && this.result.Contains('Green')) {
                System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) Property with Id="' + prop.Id + '" (Address="' + this.address + '"), this.result contains "Green"...');
                resWrapper = getBandwidthInfoByResultsandSource(prop.Id);
                System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) Property with Id="' + prop.Id + '" (Address="' + this.address + '"), is resWrapper NULL? ' + (resWrapper==null));
                Decimal maxBandwidth = 0.0;
                
                if (resWrapper!=null) {
                    foundDATA = true;
                    List<LoopQualMaxBandwidthServiceRespWrapper> resWrapperlist = new List<LoopQualMaxBandwidthServiceRespWrapper>(); 
                    resWrapperlist.add(resWrapper);
                    System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) Property with Id="' + prop.Id + '" (Address="' + this.address + '"), resWrapper added to resWrapplist...');
                    System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) Property with Id="' + prop.Id + '" (Address="' + this.address + '"), LIST### '+resWrapperlist);
                    
                    if ((resWrapper.maxQualifiedSpeeds != null) && (resWrapper.maxQualifiedSpeeds.ipSpeeds != null)){
                        for (LoopQualMaxBandwidthServiceRespWrapper.lq_ipSpeeds ipSpeeds : resWrapper.maxQualifiedSpeeds.ipSpeeds) {
                            if (Decimal.valueOf(ipSpeeds.downspeed) > maxBandwidth) {
                                maxBandwidth = Decimal.valueOf(ipSpeeds.downspeed);
                            }
                        }
                        
                        maxBandwidth = maxBandwidth / 1000;                            
                        
                        if (maxBandwidth > 3000) { prop.Max_Bandwidth__c = 8000; prop.Max_Bandwidth_Available__c = '8000';
                        } else if (maxBandwidth > 1000 && maxBandwidth <= 3000) { prop.Max_Bandwidth__c = 3000; prop.Max_Bandwidth_Available__c = '3000';
                      	} else if (maxBandwidth > 100 && maxBandwidth <= 1000) { prop.Max_Bandwidth__c = 1000; prop.Max_Bandwidth_Available__c = '1000';
                    	} else if (maxBandwidth > 50 && maxBandwidth <= 100) { prop.Max_Bandwidth__c = 100; prop.Max_Bandwidth_Available__c = '100';
                    	} else if (maxBandwidth > 40 && maxBandwidth <= 50) { prop.Max_Bandwidth__c = 50; prop.Max_Bandwidth_Available__c = '50';
                        } else if (maxBandwidth > 25 && maxBandwidth <= 40) { prop.Max_Bandwidth__c = 40; prop.Max_Bandwidth_Available__c = '40';
                        } else if (maxBandwidth > 20 && maxBandwidth <= 25) { prop.Max_Bandwidth__c = 25; prop.Max_Bandwidth_Available__c = '25';
                        } else if (maxBandwidth > 12 && maxBandwidth <= 20) { prop.Max_Bandwidth__c = 20; prop.Max_Bandwidth_Available__c = '20';
                        } else if (maxBandwidth > 10 && maxBandwidth <= 12) { prop.Max_Bandwidth__c = 12; prop.Max_Bandwidth_Available__c = '12';
                        } else if (maxBandwidth > 7 && maxBandwidth <= 10) { prop.Max_Bandwidth__c = 10; prop.Max_Bandwidth_Available__c = '10';
                        } else if (maxBandwidth > 5 && maxBandwidth <= 7) { prop.Max_Bandwidth__c = 7; prop.Max_Bandwidth_Available__c = '7';
                        } else if (maxBandwidth > 3 && maxBandwidth <= 5) { prop.Max_Bandwidth__c = 5; prop.Max_Bandwidth_Available__c = '5';
                        } else if (maxBandwidth > 1.5 && maxBandwidth <= 3) { prop.Max_Bandwidth__c = 3; prop.Max_Bandwidth_Available__c = '3';
                        } else if (maxBandwidth > 0 && maxBandwidth <= 1.5) { prop.Max_Bandwidth__c = 1.5; prop.Max_Bandwidth_Available__c = '1.5';
            	        } else { prop.Max_Bandwidth__c = 0; prop.Max_Bandwidth_Available__c = null;
                        }
                    }
                    
                    if (!propsToUpdList.contains(prop)) {
                        System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) Property with Id="' + prop.Id + '" (maxBandwidth="' + prop.Max_Bandwidth__c + '"), adding the updated-property to propsToUpdList...');
                        propsToUpdList.add(prop);
                    }
                    
                }//end if resWrapper NOT NULL
                System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) Ending Property with Id="' + prop.Id + '" (Address="' + this.address + '")...');
                
                if (!foundDATA) {  //If Exhausted all inventory-sources and did not find DATA
                    System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) For Property=' + prop.Name +', Property with Id="' + prop.Id + '" (Address="' + this.address + '"), No DATA Available to populate Property.Bandwidth');
                    prop.Bandwidth__c = 'No DATA Available';
                    if (!propsToUpdList.contains(prop)) {
                        System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfo) For Property=' + prop.Name +', Property with Id="' + prop.Id + '" (Address="' + this.address + '"), adding the updated-property to propsToUpdList...');
                        propsToUpdList.add(prop);
                    }
                }//end if NOT foundDATA
            }//end if GEOES-results is NOT EMPTY and it also contains Green for exact-match
        }//end for-loop thru propertyList
        
        return propsToUpdList;
    }
    
    /**********************************************************************************************
    Purpose: To get property Bandwidth info from address
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    private LoopQualMaxBandwidthServiceRespWrapper getBandwidthInfoByResultsandSource(Id propId) {
        LoopQualMaxBandwidthServiceRespWrapper resWrapper;
        String requestId;
        String streetNrFirst;
        String streetName = '';
        String city;
        String state;
        String network = 'CTL';
        String isCache = 'N';
        String messageSrcSystem = 'sfcjapp';
        String geoserviceresponseJson;
        GeoesServiceAddressValidationWrapper gsw;
        Id transactionSummaryId;

       	System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfoByResultsandSource) Initiating Property with Id="' + propId + '" (Address="' + this.address + '")...');
        API_Util__mdt apiUtil = this.getApiUtils(GeoesConstants.LOOPQUAL_BANDWIDTH_SERVICE);
        transactionSummaryId = this.transactionSummaryIdProp;

        List<API_Transaction__c> listapiTranssummary =[SELECT API_Response_JSON__c, API_Name__c 
                                                         FROM API_Transaction__c 
                                                        WHERE Transaction_Summary_Id__c = :this.transactionSummaryIdProp 
                                                          AND API_Name__c ='GeoesServiceAddressesValidations' 
                                                        ORDER BY Createddate DESC];

        if (!listapiTranssummary.isEmpty()) geoserviceresponseJson = listapiTranssummary[0].API_Response_JSON__c;
        
        if (String.isNotEmpty(geoserviceresponseJson)) gsw = (GeoesServiceAddressValidationWrapper) System.JSON.deserialize(geoserviceresponseJson, GeoesServiceAddressValidationWrapper.class);

        List<Property__c> propertylist =[SELECT Primary_Address_City__c, Primary_Address_State__c, Primary_Address_Street__c, 
                                                Property_Auto_Gen_Number__c, LQ_Region_Parameter__c 
                                           FROM Property__c 
                                          WHERE Id=:propId 
                                        ];

        if (String.isNotEmpty(propertylist[0].Primary_Address_Street__c)) {
            System.debug('Prop Address: ' + propertylist[0].Primary_Address_Street__c);

            String[] addressParts = propertylist[0].Primary_Address_Street__c.split(' ');            
            streetNrFirst = addressParts[0];
            
            /*
             * There are instances of the address in the Property not being correct.
             * E 3131 CAMELBACK RD instead of 3131 E CAMELBACK RD
             * OLD BETHEL RD instead of 6261 OLD BETHEL RD
             * If the 1st part of the address isn't numeric, then pull address from
             * geoes response.
             */
            if (streetNrFirst.isNumeric()){
                for (Integer x = 1; x < addressParts.size(); x++){               
                    streetName = streetName + addressParts[x] + ' ';               	            
                }
                streetName = streetName.trim();
                System.debug('Prop StreetNbr: ' + streetNrFirst);
                System.debug('Prop StreetName: ' + streetName);
            } else {
                if (gsw!=null && gsw.exactMatches!=null && String.isNotEmpty(gsw.exactMatches[0].streetNrFirst)) {
                    streetNrFirst = gsw.exactMatches[0].streetNrFirst;
                }
                
                if (gsw!=null && gsw.exactMatches!=null && String.isNotEmpty(gsw.exactMatches[0].streetName)) {
                    streetName = gsw.exactMatches[0].streetName;
                }
                System.debug('GSW StreetNbr: ' + streetNrFirst);
                System.debug('GSW StreetName: ' + streetName);
            }
        } else {
            if (gsw!=null && gsw.exactMatches!=null && String.isNotEmpty(gsw.exactMatches[0].streetNrFirst)) {
                streetNrFirst = gsw.exactMatches[0].streetNrFirst;
            }
            
            if (gsw!=null && gsw.exactMatches!=null && String.isNotEmpty(gsw.exactMatches[0].streetName)) {
                streetName = gsw.exactMatches[0].streetName;
            }
            System.debug('GSW StreetNbr: ' + streetNrFirst);
            System.debug('GSW StreetName: ' + streetName);
        }
        
        if (String.isNotEmpty(propertylist[0].Primary_Address_City__c)) {
            city = propertylist[0].Primary_Address_City__c;
        } else if (gsw!=null && gsw.exactMatches!=null && String.isNotEmpty(gsw.exactMatches[0].locality)) {    
            city = gsw.exactMatches[0].locality;
        }
        
        if (String.isNotEmpty(propertylist[0].Primary_Address_State__c)) {
            state = propertylist[0].Primary_Address_State__c;          
        } else if (gsw!=null && gsw.exactMatches!=null && String.isNotEmpty(gsw.exactMatches[0].stateOrProvince)) {
            state =gsw.exactMatches[0].stateOrProvince;
        }
        
        if (String.isNotEmpty(propertylist[0].Property_Auto_Gen_Number__c)) {
            requestId = propertylist[0].Property_Auto_Gen_Number__c;          
        } else {
            requestId = EncodingUtil.ConvertTohex(Crypto.GenerateAESKey(128));
        }
        
        if (String.isNotEmpty(propertylist[0].LQ_Region_Parameter__c)) {
            network = propertylist[0].LQ_Region_Parameter__c.toUpperCase();          
        } else {
            network = 'CTL';
        }
        
        String json='{'+
            '  "requestId": "' + requestId + '",'+
            '  "houseNumber": "' + streetNrFirst + '",'+
            '  "streetName": "' + streetName + '",'+
            '  "city": "' + city + '",'+
            '  "state": "' + state + '",'+
            '  "network": "' + network + '",'+
            '  "isCache": "' + isCache + '",'+
            '  "messageSrcSystem": "' + messageSrcSystem + '"'+
            '}';
		/*
        String json='{'+
            '  "requestId": "t12346",' +
            '  "houseNumber": "3080",' +
            '  "streetName": "VINELAND RD",' +
            '  "city": "KISSIMMEE",' +
            '  "state": "FL",' +
            '  "network": "CTL",' +
            '  "isCache": "N",' +
            '  "messageSrcSystem": "BLUEMARBLE"' +
            '}';
        */  
       	System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfoByResultsandSource) json: \n' + json);
       	System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfoByResultsandSource) Property with Id="' + propId + '" (Address="' + this.address + '")...');
        resWrapper = makeServiceCallout(GeoesConstants.LOOPQUAL_BANDWIDTH_SERVICE, json, null, transactionSummaryId);
       	System.debug('(LoopQualServiceCalloutQueueable.getBandwidthInfoByResultsandSource) Finalizing Property with Id="' + propId + '" (Address="' + this.address + '") returned resWrapper = \n' + resWrapper);
        return resWrapper;
    }//end method getBandwidthInfoByResultsandSource

    /**********************************************************************************************
    Purpose: To make service callout by calling API Transaction controller class
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    private LoopQualMaxBandwidthServiceRespWrapper makeServiceCallout(
        String callingApiName,
        String requestBody,
        Map<String, String> queryParamMap,
        Id transactionSummaryId
    ) {
        LoopQualMaxBandwidthServiceRespWrapper responseWrap;
        
        if (apiTransactionServiceManager == null) {
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
                responseWrap = LoopQualMaxBandwidthServiceRespWrapper.parse(httpResponse?.getBody());
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
                responseWrap = LoopQualMaxBandwidthServiceRespWrapper.parse(
                    httpResponse?.getBody()
                );
            }
        }
        return responseWrap;
    }//end method makeServiceCallout

    /**********************************************************************************************
    Purpose: To get API details from API Utils custom metadata
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    private API_Util__mdt getApiUtils(String apiUtilName) {
        API_Util__mdt apiUtil;
        if (String.isNotEmpty(apiUtilName)) {
            apiUtil = [SELECT DeveloperName, EndPoint__C FROM API_Util__mdt WHERE DeveloperName = :apiUtilName];
        }
        return apiUtil;
    }//end method getApiUtils
}//end class LoopQualServiceCalloutQueueable