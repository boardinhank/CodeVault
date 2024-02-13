/**************************************************************************************************************
===============================================================
Purpose: LoopQual Max Bandwidth Service callout class
===============================================================
History:

AUTHOR     			DATE        Reference       Description
Naga Lakshmi									Gets Bandwidth available at that point/address
Ted Cabato			06/14/2023	QFCJ-3955       Reinstitute Property Bandwidth into PRR-Property process, converted to Queueable
****************************************************************************************************************/
global with sharing class LoopQualMaxBandwidthService  {
    public static ApiTransactionService apiTransactionServiceManager;
    public String requestId;
    public String houseNumber;
    public String streetName;
    public String unit;
    public String floor;
    public String building;
    public String city;
    public String state;
    public String network;
    public String isCache;
    public String messageSrcSystem;

    public LoopQualMaxBandwidthService(String requestId, String houseNumber, String streetName, String unit, 
                                             String floor, String building, String city, String state, String network, 
                                             String isCache, String messageSrcSystem) {
        this.requestId = requestId;
        this.houseNumber = houseNumber;
        this.streetName = streetName;
        this.unit = unit;
        this.floor = floor;
        this.building = building;
        this.city = city;
        this.state = state;
        this.network = network;
        this.isCache = isCache;
        this.messageSrcSystem = messageSrcSystem;
    }

    /**********************************************************************************************
    Purpose: To get property Bandwidth info from address
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Nagalakshmi
    ***********************************************************************************************/
    public Decimal getMaxBandwidthInfo( ) {
        LoopQualMaxBandwidthServiceRespWrapper resWrapper;

        String lqserviceresponseJson;
        Id transactionSummaryId;

       	System.debug('(LoopQualServiceCalloutQueueable.getMaxBandwidthInfo())');
        API_Util__mdt apiUtil = this.getApiUtils(GeoesConstants.LOOPQUAL_BANDWIDTH_SERVICE);

        List<API_Transaction__c> listapiTranssummary =[Select API_Response_JSON__c,API_Name__c  from API_Transaction__c where Transaction_Summary_Id__c=:transactionSummaryId and API_Name__c ='LoopQualForBandwidth' ORDER BY Createddate DESC];

        if (!listapiTranssummary.isEmpty()) lqserviceresponseJson = listapiTranssummary[0].API_Response_JSON__c;

        String json='{'+
            '  "requestId": "' + this.requestId + '",'+
            '  "houseNumber": "' + this.houseNumber + '",'+
            '  "streetName": "' + this.streetName + '",'+
            '  "unit": "' + this.unit + '",'+
            '  "floor": "' + this.floor + '",'+
            '  "building": "' + this.building + '",'+
            '  "city": "' + this.city + '",'+
            '  "state": "' + this.state + '",'+
            '  "network": "' + this.network + '",'+
            '  "isCache": "' + this.isCache + '",'+
            '  "messageSrcSystem": "' + this.messageSrcSystem + '"'+
            '}';
              
       	System.debug('(LoopQualServiceCalloutQueueable.getMaxBandwidthInfo)' + json);
        resWrapper = makeServiceCallout(GeoesConstants.LOOPQUAL_BANDWIDTH_SERVICE, json, null, transactionSummaryId);

		Decimal maxBandwidth = 0.0;
        Decimal maxBandwidthConverted = 0;
        
        if ((resWrapper != null) && (resWrapper.maxQualifiedSpeeds != null)) {
            
            for (LoopQualMaxBandwidthServiceRespWrapper.lq_ipSpeeds ipSpeeds : resWrapper.maxQualifiedSpeeds.ipSpeeds) {
                if (Decimal.valueOf(ipSpeeds.downspeed) > maxBandwidth) {
                    maxBandwidth = Decimal.valueOf(ipSpeeds.downspeed);
                }
            }
            
            System.debug('maxBandwidth: ' + maxBandwidth);
            maxBandwidth = maxBandwidth / 1000;
            
            if (maxBandwidth >= 1000) {
                maxBandwidthConverted = 1000;
            } else if (maxBandwidth >= 100 && maxBandwidth < 1000) {
                maxBandwidthConverted = 100;
            } else if (maxBandwidth >= 50 && maxBandwidth < 100) {
                maxBandwidthConverted = 50;
            } else if (maxBandwidth >= 40 && maxBandwidth < 50) {
                maxBandwidthConverted = 40;
            } else if (maxBandwidth >= 25 && maxBandwidth < 40) {
                maxBandwidthConverted = 25;
            } else if (maxBandwidth >= 20 && maxBandwidth < 25) {
                maxBandwidthConverted = 20;
            } else if (maxBandwidth >= 12 && maxBandwidth < 20) {
                maxBandwidthConverted = 12;
            } else if (maxBandwidth >= 10 && maxBandwidth < 12) {
                maxBandwidthConverted = 10;
            } else if (maxBandwidth >= 7 && maxBandwidth < 10) {
                maxBandwidthConverted = 7;
            } else if (maxBandwidth >= 5 && maxBandwidth < 7) {
                maxBandwidthConverted = 5;
            } else if (maxBandwidth >= 3 && maxBandwidth < 5) {
                maxBandwidthConverted = 3;
            } else if (maxBandwidth >= 1.5 && maxBandwidth < 3) {
                maxBandwidthConverted = 1.5;
                //} else if (maxBandwidth >= 0 && maxBandwidth < 1.5) {
                //    maxBandwidthConverted = 0;
                //} else {
                //    maxBandwidthConverted = 0;
            } 
            System.debug('maxBandwidthConverted: ' + maxBandwidthConverted);
        }
        return maxBandwidthConverted;
    }//end method getMaxBandwidthInfo

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

        System.debug('apiTransactionServiceManager: ' + apiTransactionServiceManager);
        System.debug('callingApiName: ' + callingApiName);
        System.debug('requestBody: ' + requestBody);
        System.debug('queryParamMap: ' + queryParamMap);
        System.debug('transactionSummaryId: ' + transactionSummaryId);
        
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
        System.debug('responseWrap: ' + responseWrap);
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
}//end class LoopQualMaxBandwidthServiceCalloutQueueable