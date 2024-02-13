/***************************************************************
===============================================================
Purpose: Prospector Add-Demand-Points callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/26/2022   ESCJ-653  	  Initial draft
***************************************************************/
public class ProspectorAddDemandPointsCallout {
    public static APITransactionService apiTransactionServiceManager;
    private static Id transactionSummaryId;

    /**********************************************************************************************
    Purpose: Parameterized constructor for passing query param latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public ProspectorAddDemandPointsCallout(Id thisTransactionSummaryId) {
        transactionSummaryId = thisTransactionSummaryId;
    }//end method ProspectorAddDemandPointsCallout

    /**********************************************************************************************
    Purpose: Method to be called by another apex for getting property info from address/latlong
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public ProspectorCreateProjectCallout.ProspectorProject addDemandPoints(String projectId, List<ProspectorDemandPoint> dpList) { 
        ProspectorCreateProjectCallout.ProspectorProject resWrapper;
    	API_Util__mdt apiUtil = getApiUtils(ProspectorConstants.ADD_DEMAND_POINTS);
        Map<String, String> queryParamMap = createQueryParamMap(projectId);
        String requestBody = createRequestBody(projectId, dpList);
        resWrapper = makeServiceCallout(ProspectorConstants.ADD_DEMAND_POINTS, requestBody, queryParamMap);  
        return resWrapper;
    }//end method getProjectName
    
    /**********************************************************************************************
    Purpose: To create query parameter map
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private Map<String, String> createQueryParamMap(String projectId) {
        Map<String, String> queryParamMap = new Map<String, String>();
        queryParamMap.put(ProspectorConstants.LABEL_PROJECTID, projectId);
        
        return queryParamMap;
    }//end method createQueryParamMap

    /**********************************************************************************************
    Purpose: To create request body
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private String createRequestBody(String projectId, List<ProspectorDemandPoint> dpList) {
        String rBody = '';
        rBody += '{\n';//JSONToken.START_OBJECT;
        rBody += '\n "mapServiceName": "' + ProspectorConstants.MAPSERVICENAME + '", ';
        rBody += '\n "currentUser": "' + ProspectorConstants.USERNAME_DEV + '", ';
        rBody += '\n "mapServiceId": "' + ProspectorConstants.MAPSERVICEID + '", ';
        rBody += '\n "locations": [\n ';
        integer dpCtr = 0;
        for (ProspectorDemandPoint dp: dpList) {
            rBody += '{\n ';
			rBody += '\n"Name": "' + dp.dpName + '", ';
			rBody += '\n"Username": "' + ProspectorConstants.USERNAME_DEV + '", ';
			rBody += '\n"ProjectName": "' + ProspectorConstants.PROJECTNAME_DEV + '", ';
			rBody += '\n"X": "' + dp.dpLong + '", ';
			rBody += '\n"Y": "' + dp.dpLat + '", ';
			rBody += '\n"wkid": "' + ProspectorConstants.WKID + '" ';
            rBody += '\n }';
            if(++dpCtr < dpList.size()) { rBody += ', '; }
        }
        rBody += '\n ] ';
        rBody += '\n}';//JSONToken.END_OBJECT;
        System.debug('(ProspectorAddDemandPointsCallout.createRequestBody) requestBody as JSON = ' + rBody);
        
        return rBody;
    }//end method createRequestBody

    /**********************************************************************************************
    Purpose: To make service callout by calling API Transaction controller class
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private ProspectorCreateProjectCallout.ProspectorProject makeServiceCallout(
        String callingApiName,
        String requestBody,
        Map<String, String> queryParamMap
    ) {
        ProspectorCreateProjectCallout.ProspectorProject responseWrap;
        String responseBody = null;
        
        apiTransactionServiceManager = new ApiTransactionService(
            callingApiName,
            requestBody,
            queryParamMap,
            transactionSummaryId
        );
        System.debug('(ProspectorAddDemandPointsCallout.makeServiceCallout) pre apiTransactionServiceManager.serviceCallout');
        HttpResponse httpResponse = apiTransactionServiceManager.serviceCallout(callingApiName,                
                requestBody,
                queryParamMap,
                transactionSummaryId);
        System.debug('(ProspectorAddDemandPointsCallout.makeServiceCallout) post apiTransactionServiceManager.serviceCallout');
        System.debug(httpResponse?.getStatusCode());
        System.debug(httpResponse?.getBody());
        if (httpResponse != null && httpResponse?.getStatusCode() == 200 && httpResponse?.getBody() != null) {
            responseBody = httpResponse?.getBody();
            System.debug('(ProspectorAddDemandPointsCallout.makeServiceCallout) responseBody = ' + responseBody);
            //Parse the body and store the values in the responseMap variable
            /*  Example of response:
             * {
             *     "payload": true,
             *     "status": "success",
             *     "message": null
			 * }
             */
            JSONParser parser = JSON.createParser(responseBody);
            while (parser.nextToken() != null) {
                // Advance to the start object marker to
                //  find next invoice statement object.
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    // Read entire invoice object, including its array of line items.
                    responseWrap = (ProspectorCreateProjectCallout.ProspectorProject)parser.readValueAs(ProspectorCreateProjectCallout.ProspectorProject.class);
                    system.debug('(ProspectorAddDemandPointsCallout.makeServiceCallout) status: ' + responseWrap.status);
                    system.debug('(ProspectorAddDemandPointsCallout.makeServiceCallout) payload: ' + responseWrap.payload);
                    // For debugging purposes, serialize again to verify what was parsed.
                    String s = JSON.serialize(responseWrap);
                    system.debug('(ProspectorAddDemandPointsCallout.makeServiceCallout) Serialized project: ' + s);
                }//end if START_OBJECT
            }//end while nextToken                
        } else {
            System.debug('(ProspectorAddDemandPointsCallout.makeServiceCallout) httpResponse == null? ' + (httpResponse==null));
            System.debug('(ProspectorAddDemandPointsCallout.makeServiceCallout) httpResponse?.getStatusCode() = ' + httpResponse?.getStatusCode());
            System.debug('(ProspectorAddDemandPointsCallout.makeServiceCallout) httpResponse?.getBody() = ' + httpResponse?.getBody());
        }
        return responseWrap;
    }//end method makeServiceCallout

    /**********************************************************************************************
    Purpose: To get API details from API Utils custom metadata
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private static API_Util__mdt getApiUtils(String apiUtilName) {
        API_Util__mdt apiUtil;
        if (apiUtilName != null || apiUtilName != '') {
            apiUtil = [SELECT DeveloperName, EndPoint__C FROM API_Util__mdt WHERE DeveloperName = :apiUtilName];
        }
        return apiUtil;
    }//end method getApiUtils    
    
    public ApiTransactionService getApiTransactionServiceManager() {
    	return apiTransactionServiceManager;    
    }
        
    public class ProspectorDemandPoint {
        public String dpName;
        public String dpTransactionSummaryId;
        public String dpLong;
        public String dpLat;
    }
    
}//end class ProspectorAddDemandPointsCallout