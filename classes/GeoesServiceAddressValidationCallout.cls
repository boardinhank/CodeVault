/***************************************************************
===============================================================
Purpose: To make callout to GEOES Service Addresses and Service
Addresses Validations Api for getting matching addresses
===============================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    31/01/2022   ESCJ-379      Initial draft
***************************************************************/
public with sharing class GeoesServiceAddressValidationCallout {
    private static final String GEOES_SERVICE_ADDRESSES_API = 'GeoesServiceAddresses';
    private static final String GEOES_SERVICE_ADDRESSES_VALIDATIONS_API = 'GeoesServiceAddressesValidations';
    private static final String GEOES_SERVICE_ADDRESSES_LATLONG_API = 'GeoesServiceAddressesusingLatLong';
    public static ApiTransactionService apiTransactionServiceManager;
    /**********************************************************************************************
    Purpose: To be called from LWC to get the matching address using geoAddressId/Address info
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    
    @AuraEnabled
    public static GeoesServiceResponse getMatchingAddresses(
        String geoAddressId,
        Map<String, String> addressInfoMap,String propLatitude, String propLongitude
    ) {
        return getMatchingAddresses(
            geoAddressId,
            addressInfoMap,
            propLatitude,
            propLongitude,
            null
        );
    }
    
    public static GeoesServiceResponse getMatchingAddresses(
        String geoAddressId,
        Map<String, String> addressInfoMap,String propLatitude, String propLongitude,
        Id transactionSummaryId
    ) {
        GeoesServiceResponse geoesServiceResponse;
        GeoesServiceAddressValidationWrapper responseWrapper;
        List<ServiceAddress> matchingServiceAddresses;
        //try {
            // If Geo Address Id is present then use it
            if (geoAddressId != null && geoAddressId?.trim() != '') {
                responseWrapper = getAdrressUsingGeoAddressId(geoAddressId, transactionSummaryId);
            }
            // If Address info is present then use it
            else if (addressInfoMap != null && addressInfoMap?.size() > 0) {
                responseWrapper = getAdrressUsingAddressInfo(addressInfoMap, transactionSummaryId);
            }
            // If Lat&Long is present then use it
            else if(propLatitude!=null && propLongitude!=null){
                responseWrapper = getAdrressUsingGeoLatLong(propLatitude,propLongitude,transactionSummaryId);
            }
            if (responseWrapper != null) {
                // Get list of service addresses from the api response
                matchingServiceAddresses = getServiceAddressesFromResponseWrapper(responseWrapper);
                // If atleast on matching address is present
                if (matchingServiceAddresses?.size() > 0) {
                    geoesServiceResponse = new GeoesServiceResponse(
                        true, 
                        '', 
                        matchingServiceAddresses,
                        responseWrapper
                    );
                } else {
                    geoesServiceResponse = new GeoesServiceResponse(
                        false,
                        'No Matching Address',
                        matchingServiceAddresses,
                        responseWrapper
                    );
                }
            } else {
                geoesServiceResponse = new GeoesServiceResponse(
                    false,
                    'No Api Response',
                    matchingServiceAddresses,
                    responseWrapper
                );
            }
        // } catch (Exception ex) {
        //     // In case of any exception
        //     System.debug(
        //         'GeoesServiceAddressValidationCallout Class Error: ' +
        //         'Message - '+ ex.getMessage() + ' | ' +
        //         'Line number' + ex.getLineNumber()
        //     );
        //     geoesServiceResponse = new GeoesServiceResponse(false, ex.getMessage(), null);
        // }

        return geoesServiceResponse;
    }

    /**********************************************************************************************
    Purpose: To get the matching address using geoAddressId
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    private static GeoesServiceAddressValidationWrapper getAdrressUsingGeoAddressId(
        String geoAddressId,
        Id transactionSummaryId
    ) {
        GeoesServiceAddressValidationWrapper resWrapper;
        Map<String, String> queryParamMap = createQueryParamMap(GEOES_SERVICE_ADDRESSES_API, geoAddressId,null,null,null);
        resWrapper = makeServiceCallout(GEOES_SERVICE_ADDRESSES_API, queryParamMap, transactionSummaryId);
        return resWrapper;
    }

    /**********************************************************************************************
    Purpose: To get the matching address using Address Info
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    private static GeoesServiceAddressValidationWrapper getAdrressUsingAddressInfo(
        Map<String, String> addressInfoMap,
        Id transactionSummaryId
    ) {
        GeoesServiceAddressValidationWrapper resWrapper;
        Map<String, String> queryParamMap = createQueryParamMap(GEOES_SERVICE_ADDRESSES_VALIDATIONS_API, null, addressInfoMap,null,null);
        resWrapper = makeServiceCallout(GEOES_SERVICE_ADDRESSES_VALIDATIONS_API, queryParamMap, transactionSummaryId);
        return resWrapper;
    }

     /**********************************************************************************************
    Purpose: To get the matching address using Latitude&Longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi   6/26/2023          QFCJ-2156     Initial draft
    ***********************************************************************************************/
    private static GeoesServiceAddressValidationWrapper getAdrressUsingGeoLatLong(
        String propLatitude, String propLongitude,
        Id transactionSummaryId
    ) {
        GeoesServiceAddressValidationWrapper resWrapper;
        Map<String, String> queryParamMap = createQueryParamMap(GEOES_SERVICE_ADDRESSES_LATLONG_API, null, null,propLatitude,propLongitude);
        resWrapper = makeServiceCallout(GEOES_SERVICE_ADDRESSES_LATLONG_API, queryParamMap, transactionSummaryId);
        return resWrapper;
    }

    /**********************************************************************************************
    Purpose: To create query param map
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    private static Map<String, String> createQueryParamMap(String apiName, String geoAddressId, Map<String, String> addressInfoMap,String propLatitude, String propLongitude) {
        Map<String, String> queryParamMap = new Map<String, String>();
        
        // If the API name is GeoesServiceAddresses
        if (apiName == GEOES_SERVICE_ADDRESSES_API) {
            queryParamMap.put(GeoesConstants.geoAddressId_FieldName, geoAddressId);
            queryParamMap.put(GeoesConstants.searchAllSources_FieldName, 'true');
            queryParamMap.put(GeoesConstants.liveData_FieldName, 'true');
            queryParamMap.put(GeoesConstants.expand_FieldName, GeoesConstants.expand_FieldValue);
        	queryParamMap.put(GeoesConstants.sources_FieldName, GeoesConstants.sources_FieldValue);
        }
        // If the API name is GeoesServiceAddressesValidation
        else if (apiName == GEOES_SERVICE_ADDRESSES_VALIDATIONS_API) {
            String addressLine1 = addressInfoMap?.get(GeoesConstants.addressLine1_FieldName)?.trim() == null ? ' ' : addressInfoMap?.get(GeoesConstants.addressLine1_FieldName)?.trim();
            String locality = addressInfoMap?.get(GeoesConstants.locality_FieldName)?.trim() == null ? ' ' : addressInfoMap?.get(GeoesConstants.locality_FieldName)?.trim();
            String stateOrProvince = addressInfoMap?.get(GeoesConstants.stateOrProvince_FieldName)?.trim() == null ? ' ' : addressInfoMap?.get(GeoesConstants.stateOrProvince_FieldName)?.trim();
            String postCode = addressInfoMap?.get(GeoesConstants.postCode_FieldName)?.trim() == null ? ' ' : addressInfoMap?.get(GeoesConstants.postCode_FieldName)?.trim();
            //String country = addressInfoMap?.get(GeoesConstants.country_FieldName)?.trim() == null ? ' ' : addressInfoMap?.get(GeoesConstants.country_FieldName)?.trim();
            String country ='USA';

            queryParamMap.put(GeoesConstants.addressLine1_FieldName, addressLine1);
            queryParamMap.put(GeoesConstants.locality_FieldName, locality);
            queryParamMap.put(GeoesConstants.stateOrProvince_FieldName, stateOrProvince);
            queryParamMap.put(GeoesConstants.postCode_FieldName, postCode);
            queryParamMap.put(GeoesConstants.country_FieldName, country);
            queryParamMap.put(GeoesConstants.expand_FieldName, GeoesConstants.expand_FieldValue);
        	queryParamMap.put(GeoesConstants.sources_FieldName, GeoesConstants.sources_FieldValue);
        }
        // If the API name is GeoesServiceAddressesusingLatLong
        else if(apiName == GEOES_SERVICE_ADDRESSES_LATLONG_API){
            queryParamMap.put('latitude', propLatitude);
            queryParamMap.put('longitude', propLongitude);
            queryParamMap.put('sources','all');
            queryParamMap.put('subclientid','temp');
       }
        return queryParamMap;
    }

    /**********************************************************************************************
    Purpose: To make callout using generic api callout class
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    private static GeoesServiceAddressValidationWrapper makeServiceCallout(
        String callingApiName,
        Map<String, String> queryParamMap,
        Id transactionSummaryId
    ) {
        GeoesServiceAddressValidationWrapper responseWrap;
        
        if(apiTransactionServiceManager == null) {
            APITransactionController objApiTransactionCtrl = new APITransactionController(
                callingApiName,
                null,
                queryParamMap,
                null
            );
            HttpResponse httpResponse = APITransactionController.serviceCallout();
            if (
                httpResponse?.getStatusCode() == 200 &&
                httpResponse != null &&
                httpResponse?.getBody() != null
            ) {
                responseWrap = GeoesServiceAddressValidationWrapper.parse(httpResponse?.getBody());
            }
        } else {
            HttpResponse httpResponse = apiTransactionServiceManager.serviceCallout(
                callingApiName,
                JSON.serialize(queryParamMap),
                queryParamMap,
                transactionSummaryId
            );
            
            if (httpResponse?.getStatusCode() == 200
                && httpResponse != null
                && httpResponse?.getBody() != null
            ) {
                responseWrap = GeoesServiceAddressValidationWrapper.parse(
                    httpResponse?.getBody()
                );
            }
        }
        return responseWrap;
    }

    /**********************************************************************************************
    Purpose: To get list of matching service addresses from the api response
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    private static List<ServiceAddress> getServiceAddressesFromResponseWrapper(
        GeoesServiceAddressValidationWrapper responseWrapper
    ) {
        List<ServiceAddress> matchingServiceAddresses = new List<ServiceAddress>();

        // Get the list of exact match addrress
        List<GeoesServiceAddressValidationWrapper.ExactMatch> exactMatchAddresses = responseWrapper?.exactMatches;
        // If there is atleast one exact match address
        if (exactMatchAddresses?.size() > 0) {
            for (GeoesServiceAddressValidationWrapper.ExactMatch exactMatchAddress : exactMatchAddresses) {
                ServiceAddress objServiceAddress = new ServiceAddress();
                objServiceAddress.geoAddressId = exactMatchAddress?.geoAddressId;
                objServiceAddress.streetAddress = exactMatchAddress?.streetAddress;
                objServiceAddress.locality = exactMatchAddress?.locality;
                objServiceAddress.stateOrProvince = exactMatchAddress?.stateOrProvince;
                objServiceAddress.postCode = exactMatchAddress?.postCode;
                objServiceAddress.source = exactMatchAddress?.source;
                if(exactMatchAddress?.attributes!=null) objServiceAddress.legacyProvider = exactMatchAddress?.attributes.legacyProvider;
                objServiceAddress.fullAddress = (
                    exactMatchAddress?.streetAddress + ',' +
                    exactMatchAddress?.locality + ',' +
                    exactMatchAddress?.stateOrProvince + ' ' +
                    exactMatchAddress?.postCode
                )?.remove('null').trim();
                List<GeoesServiceAddressValidationWrapper.GeoPointDetails> geoPointDetails = exactMatchAddress?.geoPointDetails;
                if (geoPointDetails?.size() > 0) {
                    objServiceAddress.latitudeCoordinate = geoPointDetails[0]?.gpsCoordinate?.latitudeCoordinate;
                    objServiceAddress.longitudeCoordinate = geoPointDetails[0]?.gpsCoordinate?.longitudeCoordinate;
                }
                objServiceAddress.matchType = GeoesConstants.EXACT_MATCHTYPE;
                matchingServiceAddresses.add(objServiceAddress);
            }
        }

        // Get the list of near match addrress
        List<GeoesServiceAddressValidationWrapper.NearMatch> nearMatchAddresses = responseWrapper?.nearMatches;
        // If there is atleast one near match address
        if (nearMatchAddresses?.size() > 0) {
            for (GeoesServiceAddressValidationWrapper.NearMatch nearMatchAddress : nearMatchAddresses) {
                ServiceAddress objServiceAddress = new ServiceAddress();
                objServiceAddress.geoAddressId = nearMatchAddress?.geoAddressId;
                objServiceAddress.streetAddress = nearMatchAddress?.streetAddress;
                objServiceAddress.locality = nearMatchAddress?.locality;
                objServiceAddress.stateOrProvince = nearMatchAddress?.stateOrProvince;
                objServiceAddress.postCode = nearMatchAddress?.postCode;
                objServiceAddress.source = nearMatchAddress?.source;
                objServiceAddress.fullAddress = (
                    nearMatchAddress?.streetAddress + ',' +
                    nearMatchAddress?.locality + ',' +
                    nearMatchAddress?.stateOrProvince + ' ' +
                    nearMatchAddress?.postCode
                )?.remove('null').trim();
                objServiceAddress.matchType = GeoesConstants.NEAR_MATCHTYPE;
                matchingServiceAddresses.add(objServiceAddress);
            }
        }

        return matchingServiceAddresses;
    }

    /**********************************************************************************************
    Purpose: Wrapper class for the Service Address info
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    public Class ServiceAddress {
        @AuraEnabled public String geoAddressId{get;set;}
        @AuraEnabled public String streetAddress{get;set;}
        @AuraEnabled public String locality{get;set;}
        @AuraEnabled public String stateOrProvince{get;set;}
        @AuraEnabled public String postCode{get;set;}
        @AuraEnabled public String fullAddress{get;set;}
        @AuraEnabled public Decimal longitudeCoordinate{get;set;}
        @AuraEnabled public Decimal latitudeCoordinate{get;set;}
        @AuraEnabled public String matchType{get;set;}
        @AuraEnabled public String source{get;set;}
        @AuraEnabled public String legacyProvider{get;set;}
    }

    /**********************************************************************************************
    Purpose: Wrapper class of General response to be returned to LWC
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    public class GeoesServiceResponse {
        @AuraEnabled
        public Boolean isSuccess;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Object data;
        public GeoesServiceAddressValidationWrapper wrapper;
        public GeoesServiceResponse(Boolean isSuccess, String message, Object data) {
            this.isSuccess = isSuccess;
            this.message = message;
            this.data = data;
        }
        public GeoesServiceResponse(
            Boolean isSuccess, 
            String message, 
            Object data, 
            GeoesServiceAddressValidationWrapper wrapper
        ) {
            this.isSuccess = isSuccess;
            this.message = message;
            this.wrapper = wrapper;
            this.data = data;
        }
    }
}