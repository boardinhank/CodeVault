public class BIWQualificationServiceCallout {
    public static ApiTransactionService apiTransactionServiceManager;
    private String latitude;
    private String longitude;
    private String prrId;
    private List<Transaction_Summary__c> lstr = new List<Transaction_Summary__c>();
    private Id transactionSummaryId;
        
    /**********************************************************************************************
    Purpose: Parameterized cosntructor for passing query param latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    public BIWQualificationServiceCallout(String thisLatitude, String thisLongitude, String thisprrId) {
        latitude = thisLatitude;
        longitude = thisLongitude;
        prrId = thisprrId;
    }

    
    /**********************************************************************************************
    Purpose: Method to be called by another apex for getting property Maxbandwidth from lat/long
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    public BIWQualificationServiceResponseWrapper getPropertyInfo() {
        BIWQualificationServiceResponseWrapper resWrapper;
       List<Property__c> updatepropertylist = new List<Property__c>();
            // If latitude and longitude is not null and blank
            if (latitude != null && latitude != '' && longitude != null && longitude != '') {
                //List<Property_Request_Record__c> lprr = [Select id,Name, New_Property_Created__c,Existing_Property_found_in_SF_with_PRR__c from Property_Request_Record__c where Id=:prrId];
                List<Property_Request_Record__c> lprr = [Select id,Name, New_Property_Created__c,Existing_Property_found_in_SF_with_PRR__c,Transaction_Summary__c from Property_Request_Record__c where Id=:prrId];
                 transactionSummaryId = lprr[0].Transaction_Summary__c;
                resWrapper = getPropertyInfoByLatLong();
                 resWrapper = getPropertyInfoByLatLong();
                if(resWrapper!=null){
                    
                    if(lprr[0].New_Property_Created__c!=null || lprr[0].Existing_Property_found_in_SF_with_PRR__c!=null){
                        List<Property__c> lproperty = [Select id,Bandwidth__c from Property__c where (Id=:lprr[0].New_Property_Created__c OR Id=:lprr[0].Existing_Property_found_in_SF_with_PRR__c)];
                        for(Property__c prop:lproperty){
                            prop.Bandwidth__c = resWrapper.bandwidth;
                            updatepropertylist.add(prop);
                        }
                    }
                    
                }
            } 
            
        if(!updatepropertylist.isempty()){
             Database.SaveResult[] updatepropertySaveResult = Database.update(
             updatepropertylist,false //all or none
        );
        }
        
        
           
        return resWrapper;
    }

    /**********************************************************************************************
    Purpose: To get property info from latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    private BIWQualificationServiceResponseWrapper getPropertyInfoByLatLong() {
        BIWQualificationServiceResponseWrapper resWrapper;
        API_Util__mdt apiUtil = getApiUtils(GeoesConstants.BIW_SERVICE_BY_LAT_LONG);
        Map<String, String> queryParamMap = createQueryParamMap(GeoesConstants.BIW_SERVICE_BY_LAT_LONG);
        resWrapper = makeServiceCallout(GeoesConstants.BIW_SERVICE_BY_LAT_LONG, null, queryParamMap,transactionSummaryId);
                
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
        
        // If the callout is by querying latitude and logitude
        if (serviceType == GeoesConstants.BIW_SERVICE_BY_LAT_LONG) {
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
    private BIWQualificationServiceResponseWrapper makeServiceCallout(
        String callingApiName,
        String requestBody,
        Map<String, String> queryParamMap,
        Id transactionSummaryId
    ) {
        BIWQualificationServiceResponseWrapper responseWrap;
        
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
                responseWrap = BIWQualificationServiceResponseWrapper.parse(httpResponse?.getBody());
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
                responseWrap = BIWQualificationServiceResponseWrapper.parse(
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
}