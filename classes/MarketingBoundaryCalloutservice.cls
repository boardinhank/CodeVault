/**
 *      1/30/2024       HANK        QFCJ-4879        moved some logic inside of existing IF to prevent error for list out of bounds
 * 
 */

global class MarketingBoundaryCalloutservice implements Queueable, Database.AllowsCallouts {

	
    public static ApiTransactionService apiTransactionServiceManager;
    public String latitude;
    public String longitude;
    public Id prrId;
    public List<Transaction_Summary__c> lstr = new List<Transaction_Summary__c>();
    public static Id transactionSummaryId;
        
    /**********************************************************************************************
    Purpose: Parameterized constructor for passing query param latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    public MarketingBoundaryCalloutservice(Id thisprrId) {
       this.prrId = thisprrId;
    }

    public void execute(QueueableContext ctx) { 
        System.debug('(MarketingBoundaryCalloutService.execute~Before-finish-getBoundaryInfo) this.prrId: ' + this.prrId);
        List<Property_Request_Record__c> lprr = [Select id,Name,GEOES_Latitude_Coordinate__c,GEOES_Longitude_Coordinate__c, New_Property_Created__c,Existing_Property_found_in_SF_with_PRR__c,Transaction_Summary__c from Property_Request_Record__c where 	(New_Property_Created__c=:this.prrId OR Existing_Property_found_in_SF_with_PRR__c=:this.prrId)];
        if(lprr[0].Id!=null) {        // QFCJ-4879 
        MarketingBoundaryCalloutservice.getBoundaryInfo(String.valueOf(lprr[0].GEOES_Latitude_Coordinate__c),String.valueOf(lprr[0].GEOES_Longitude_Coordinate__c),lprr[0].Id);
            System.debug('(MarketingBoundaryCalloutService.execute~After-finish-getBoundaryInfo) lprr[0].Id!=null? ' + (lprr[0].Id!=null));   
            System.debug('(MarketingBoundaryCalloutService.execute~After-finish-getBoundaryInfo) Constructing instance of MarketingBoundaryCalloutservice with lprr[0].Id = ' + lprr[0].Id);
            getMaxBandwidth(lprr[0].Id);
        }
     }
	 
    /**********************************************************************************************
    Purpose: Method to be called by another apex for getting property Maxbandwidth from lat/long
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    public static MarketingBoundaryCalloutResponseWrapper getBoundaryInfo(String latitude,String longitude,String prrId) {
        MarketingBoundaryCalloutResponseWrapper resWrapper;
       List<Property__c> updatepropertylist = new List<Property__c>();
       List<Property_Request_Record__c> updatepropertyreqlist = new List<Property_Request_Record__c>();

       Map<Id,Property__c> mapPropertyvalues = new Map<Id,Property__c>();
       Map<Id,Property_Request_Record__c> mapPropertyreqvalues = new Map<Id,Property_Request_Record__c>();

            // If latitude and longitude is not null and blank
            if (latitude != null && latitude != '' && longitude != null && longitude != '') {
                //List<Property_Request_Record__c> lprr = [Select id,Name, New_Property_Created__c,Existing_Property_found_in_SF_with_PRR__c from Property_Request_Record__c where Id=:prrId];
                List<Property_Request_Record__c> lprr = [Select id,Name,Duplicate_Property_Found__c, New_Property_Created__c,Existing_Property_found_in_SF_with_PRR__c,Transaction_Summary__c from Property_Request_Record__c where Id=:prrId];
                transactionSummaryId = lprr[0].Transaction_Summary__c;
                resWrapper = getBoundaryInfoByLatLong(transactionSummaryId,latitude,longitude);
                 system.debug('RESP$$$$'+resWrapper);
                
               if(resWrapper!=null){
                    
                    if(lprr[0].New_Property_Created__c!=null || lprr[0].Existing_Property_found_in_SF_with_PRR__c!=null){
                        List<Property__c> lproperty = [Select id,Boundary_ID_Res__c,Boundary_Name_Res__c from Property__c where (Id=:lprr[0].New_Property_Created__c OR Id=:lprr[0].Existing_Property_found_in_SF_with_PRR__c)];
                        Map<Id,Property__c> mapproperties = new Map<Id,Property__c>([Select id,Boundary_ID_Res__c,Boundary_Name_Res__c from Property__c]);
                        for(Property__c prop:lproperty){
                            if(resWrapper.parcelMarketingBoundary!=null){
                               // MarketingBoundaryCalloutResponseWrapper.parcelMarketingBoundary boundaries = MarketingBoundaryCalloutResponseWrapper.parcelMarketingBoundary.get(0);
                                
                                    if(resWrapper.parcelMarketingBoundary.marketingBoundaryId!=null) prop.Boundary_ID_Res__c = resWrapper.parcelMarketingBoundary.marketingBoundaryId;
                                	if(resWrapper.parcelMarketingBoundary.marketingBoundaryName!=null) prop.Boundary_Name_Res__c = resWrapper.parcelMarketingBoundary.marketingBoundaryName;
                                	updatepropertylist.add(prop);
                                
                            }
                        }
                        for(Property__c prop:mapproperties.values()){
                            if((prop.Boundary_ID_Res__c!=null && resWrapper.parcelMarketingBoundary.marketingBoundaryId!=null && prop.Boundary_ID_Res__c == resWrapper.parcelMarketingBoundary.marketingBoundaryId) && (prop.Boundary_Name_Res__c!=null && resWrapper.parcelMarketingBoundary.marketingBoundaryName!=null && prop.Boundary_Name_Res__c!='' && prop.Boundary_Name_Res__c == resWrapper.parcelMarketingBoundary.marketingBoundaryName)){
                                lprr[0].Duplicate_Property_Found__c ='Yes';
                                updatepropertyreqlist.add(lprr[0]);
                            }
                        } 
                    }
                 }
              }
               if(!updatepropertylist.isempty()){
                mapPropertyvalues.putall(updatepropertylist);
             Database.SaveResult[] updatepropertySaveResult = Database.update(
             mapPropertyvalues.values(),false //all or none
        );
        }
        
        if(!updatepropertyreqlist.isempty()){
            mapPropertyreqvalues.putAll(updatepropertyreqlist);
             Database.SaveResult[] updatepropertyreqSaveResult = Database.update(
             mapPropertyreqvalues.values(),false //all or none
        );
        }     
        return resWrapper;
    }

    public static void getMaxBandwidth(String prrId){
        System.debug('(MarketingBoundaryCalloutService.getMaxBandwidth) prrId = ' + prrId);
        LoopQualServiceCalloutQueueable bandwidthQueueable = new LoopQualServiceCalloutQueueable('PRR', prrId);
        if(Test.isRunningTest()) {
            bandwidthQueueable.execute(null);
        } else {
            System.debug('(MarketingBoundaryCalloutService.execute~After-finish-getBoundaryInfo) enqueueing LoopQualCalloutQueueable');
            System.enqueueJob(bandwidthQueueable);
        }
    }
    
    /**********************************************************************************************
    Purpose: To get property info from latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    private static MarketingBoundaryCalloutResponseWrapper getBoundaryInfoByLatLong(Id transactionSummaryId,String latitude,String longitude) {
        MarketingBoundaryCalloutResponseWrapper resWrapper;
        API_Util__mdt apiUtil = getApiUtils(GeoesConstants.UNIQUAL_BOUNDARY_SERVICE);
        String includeMarketBoundaries = 'true';
        String limitResponse = 'true';
        Map<String, String> queryParamMap = createQueryParamMap(GeoesConstants.UNIQUAL_BOUNDARY_SERVICE,latitude,longitude,includeMarketBoundaries,limitResponse);
        system.debug('MAP###'+queryParamMap);
        resWrapper = makeServiceCallout(GeoesConstants.UNIQUAL_BOUNDARY_SERVICE, null, queryParamMap,transactionSummaryId);
                
        return resWrapper;
    }


    /**********************************************************************************************
    Purpose: To create query parameter map
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    private static Map<String, String> createQueryParamMap(String serviceType,String latitude,String longitude,String includeMarketBoundaries,String limitResponse) {
        Map<String, String> queryParamMap = new Map<String, String>();
        
        // If the callout is by querying latitude and logitude
        if (serviceType == GeoesConstants.UNIQUAL_BOUNDARY_SERVICE) {
            queryParamMap.put(GeoesConstants.PRR_MAPPING_LATITUDE, latitude);
            queryParamMap.put(GeoesConstants.PRR_MAPPING_LONGITUDE, longitude);
            queryparamMap.put(GeoesConstants.INCLUDE_MARKET_BOUNDARIES,includeMarketBoundaries);
            queryparamMap.put(GeoesConstants.LIMIT_RESPONSE,limitResponse);
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
    private static MarketingBoundaryCalloutResponseWrapper makeServiceCallout(
        String callingApiName,
        String requestBody,
        Map<String, String> queryParamMap,
        Id transactionSummaryId
    ) {
        MarketingBoundaryCalloutResponseWrapper responseWrap;
        
        if(apiTransactionServiceManager == null) {
              APITransactionController objApiTransactionCtrl = new APITransactionController(
                callingApiName,
                requestBody,
                queryParamMap,
                //null
                transactionSummaryId
            );
            
            
            HttpResponse httpResponse = APITransactionController.serviceCallout();
            if (
                httpResponse?.getStatusCode() == 200 &&
                httpResponse != null &&
                httpResponse?.getBody() != null
            ) {
                responseWrap = MarketingBoundaryCalloutResponseWrapper.parse(httpResponse?.getBody());
            }
        } else {
            HttpResponse httpResponse = apiTransactionServiceManager.serviceCallout(
                callingApiName,
                requestBody,
                queryParamMap,
                //null
                transactionSummaryId
            );
            
            if (httpResponse?.getStatusCode() == 200
                && httpResponse != null
                && httpResponse?.getBody() != null
            ) {
                responseWrap = MarketingBoundaryCalloutResponseWrapper.parse(
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
            apiUtil = [SELECT DeveloperName, EndPoint__C,BoundaryDetail__c FROM API_Util__mdt WHERE DeveloperName = :apiUtilName];
        }
        return apiUtil;
    }
}