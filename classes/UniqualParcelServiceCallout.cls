/***************************************************************
===============================================================
Purpose: UNIQUAL Parcel service callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    14/12/2021   ESCJ-327      Initial draft
***************************************************************/
public with sharing class UniqualParcelServiceCallout {
    public static ApiTransactionService apiTransactionServiceManager;
    private String latitude;
    private String longitude;
    private String address;
    private Map<String, String> validationDataMap;
    private static Id transactionSummaryId;

    /**********************************************************************************************
    Purpose: Parameterized cosntructor for passing query param latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    public UniqualParcelServiceCallout(String thisLatitude, String thisLongitude, Id thisTransactionSummaryId) {
        latitude = thisLatitude;
        longitude = thisLongitude;
        transactionSummaryId = thisTransactionSummaryId;
    }

    /**********************************************************************************************
    Purpose: Parameterized cosntructor for passing query param address
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    public UniqualParcelServiceCallout(String thisAdrress, Id thisTransactionSummaryId) {
        address = thisAdrress;
        transactionSummaryId = thisTransactionSummaryId;
    }

    /**********************************************************************************************
    Purpose: Method to be called by another apex for getting property info from address/latlong
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    public UniqualParcelServiceResponseWrap getPropertyInfo() {
        UniqualParcelServiceResponseWrap resWrapper;
        System.debug('(UniqualParcelServiceCallout.getPropertyInfo) String.isNotBlank(latitude) = ' + String.isNotBlank(latitude) + ', latitude = ' + latitude);
        System.debug('(UniqualParcelServiceCallout.getPropertyInfo) String.isNotBlank(longitude) = ' + String.isNotBlank(longitude) + ', latitude = ' + latitude);
        System.debug('(UniqualParcelServiceCallout.getPropertyInfo) String.isNotBlank(address) = ' + String.isNotBlank(address) + ', address = ' + address);
        //try {        
            // If latitude and longitude is not null and blank            
            if (String.isNotBlank(latitude) && String.isNotBlank(longitude)) {
                resWrapper = getPropertyInfoByLatLong();
            }
            // If address is not null and blank
            else if (String.isNotBlank(address)) {
                resWrapper = getPropertyInfoByAddress();
            } else {
                System.debug('UniqualParcelServiceCallout Class Error: No query param present (lat/long and address are all NULL or BLANK).  Returning empty wrapper.');
                resWrapper = new UniqualParcelServiceResponseWrap();
            }
        // } catch (Exception ex) {
        //     // In case of any exception
        //     System.debug(
        //         'UniqualParcelServiceCallout Class Error: ' +
        //         'Message - '+ ex.getMessage() + ' | ' +
        //         'Line number' + ex.getLineNumber()
        //     );
        // }
        return resWrapper;
    }

    /**********************************************************************************************
    Purpose: To get property info from latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    private UniqualParcelServiceResponseWrap getPropertyInfoByLatLong() {
        UniqualParcelServiceResponseWrap resWrapper;
        API_Util__mdt apiUtil = getApiUtils(GeoesConstants.PARCEL_SERVICE_BY_LAT_LONG);
        Map<String, String> queryParamMap = createQueryParamMap(GeoesConstants.PARCEL_SERVICE_BY_LAT_LONG);
        resWrapper = makeServiceCallout(GeoesConstants.PARCEL_SERVICE_BY_LAT_LONG, null, queryParamMap);

        return resWrapper;
    }

    /**********************************************************************************************
    Purpose: To get property info from address
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    private UniqualParcelServiceResponseWrap getPropertyInfoByAddress() {
        UniqualParcelServiceResponseWrap resWrapper;
        API_Util__mdt apiUtil = getApiUtils(GeoesConstants.PARCEL_SERVICE_BY_ADDRESS);
        Map<String, String> queryParamMap = createQueryParamMap(GeoesConstants.PARCEL_SERVICE_BY_ADDRESS);
        resWrapper = makeServiceCallout(GeoesConstants.PARCEL_SERVICE_BY_ADDRESS, null, queryParamMap);

        return resWrapper;
    }

    /**********************************************************************************************
    Purpose: To create query parameter map
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    14/12/2021   ESCJ-327      Initial draft
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
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    private UniqualParcelServiceResponseWrap makeServiceCallout(
        String callingApiName,
        String requestBody,
        Map<String, String> queryParamMap
    ) {
        UniqualParcelServiceResponseWrap responseWrap;
        
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
                responseWrap = UniqualParcelServiceResponseWrap.parse(httpResponse?.getBody());
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
                responseWrap = UniqualParcelServiceResponseWrap.parse(
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
    Navin M    14/12/2021   ESCJ-327      Initial draft
    ***********************************************************************************************/
    private static API_Util__mdt getApiUtils(String apiUtilName) {
        API_Util__mdt apiUtil;
        if (apiUtilName != null || apiUtilName != '') {
            apiUtil = [SELECT DeveloperName, EndPoint__C FROM API_Util__mdt WHERE DeveloperName = :apiUtilName];
        }
        return apiUtil;
    }
}