/***************************************************************
===============================================================
Purpose: Prospector Submit-Job callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/26/2022   ESCJ-653  	  Initial draft
***************************************************************/
public class ProspectorSubmitJobCallout {
    public static APITransactionService apiTransactionServiceManager;
    private static Id transactionSummaryId;

    /**********************************************************************************************
    Purpose: Parameterized constructor for passing query param latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public ProspectorSubmitJobCallout(Id thisTransactionSummaryId) {
        transactionSummaryId = thisTransactionSummaryId;
    }//end method ProspectorSubmitJobCallout

    /**********************************************************************************************
    Purpose: Method to be called by another apex for getting property info from address/latlong
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public ProspectorCreateProjectCallout.ProspectorProject submitJob(String projectId, String colorId) {
        ProspectorCreateProjectCallout.ProspectorProject resWrapper;
        if (String.isNotBlank(ProspectorConstants.MAPSERVICENAME) && String.isNotBlank(ProspectorConstants.USERNAME_DEV)) {
            API_Util__mdt apiUtil = getApiUtils(ProspectorConstants.SUBMIT_JOB);
            Map<String, String> queryParamMap = createQueryParamMap(projectId);
            String requestBody = createRequestBody(colorId);
            resWrapper = makeServiceCallout(ProspectorConstants.SUBMIT_JOB, requestBody, queryParamMap);
        } else {
            System.debug('ProspectorCreateProjectCallout Class Error: No query param present');
        }
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
        queryParamMap.put(ProspectorConstants.LABEL_MAPSERVICENAME, ProspectorConstants.MAPSERVICENAME);
        queryParamMap.put(ProspectorConstants.LABEL_USERNAME, ProspectorConstants.USERNAME_DEV);
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
    private String createRequestBody(String colorId) {
        String rBody = '';
        rBody += '{';//JSONToken.START_OBJECT;
        rBody += ' "mapServiceName": "' + ProspectorConstants.MAPSERVICENAME + '", ';
        rBody += ' "currentUser": "' + ProspectorConstants.USERNAME_DEV + '", ';
        rBody += ' "mapServiceId": "' + ProspectorConstants.MAPSERVICEID + '", ';
        rBody += ' "guidsToSolve": [],';
        rBody += ' "routeOidsToCost": [],';
        rBody += ' "infrastructureLayerNames": [';
        rBody += ' "' + colorId + '_LCR_Capable_MH_HH", ';
        rBody += ' "' + colorId + '_LCR_Capable_SpliceClosure" ';
        rBody += ' ],';
    	rBody += ' "infrastructureLayerQueryDefs": [';
        rBody += ' "", ';
        rBody += ' "" ';
        rBody += ' ],';
        rBody += ' "disableDropLogic": false, ';
        rBody += ' "homeRunRoutes": false, ';
        rBody += ' "userPointBarrierSetName": "", ';
        rBody += ' "userPolylineBarrierSetName": "", ';
        rBody += ' "userPolygonBarrierSetName": "", ';
        rBody += ' "refreshData": false, ';
        rBody += ' "bufferDistance": 1000, ';
        rBody += ' "calculationUnits": "Feet", ';
        rBody += ' "maxRouteLength": "3", ';
        rBody += ' "maxRouteLengthUnits": "Miles", ';
        rBody += ' "maxChainHops": "100" ';          
        rBody += '}';//JSONToken.END_OBJECT;
        System.debug('(createRequestBody) requestBody as JSON = ' + rBody);
        
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
        System.debug('(ProspectorSubmitJobCallout.makeServiceCallout) pre serviceCallout');
        HttpResponse httpResponse = apiTransactionServiceManager.serviceCallout(callingApiName,                
                requestBody,
                queryParamMap,
                transactionSummaryId);
        System.debug('post serviceCallout');
        System.debug('statusCode: ' + httpResponse?.getStatusCode());
        System.debug('body: ' + httpResponse?.getBody());
        if (httpResponse != null && httpResponse?.getStatusCode() == 200 && httpResponse?.getBody() != null) {
            responseBody = httpResponse?.getBody();
            System.debug('(makeServiceCallout) responseBody = ' + responseBody);
            //Parse the body and store the values in the responseMap variable
            /*  Example of response:
             * {
             *     "status": "success",
             *     "message": null,
             *     "payload": true
             * }
             */
            JSONParser parser = JSON.createParser(responseBody);
            while (parser.nextToken() != null) {
                // Advance to the start object marker to
                //  find next invoice statement object.
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    // Read entire invoice object, including its array of line items.
                    responseWrap = (ProspectorCreateProjectCallout.ProspectorProject)parser.readValueAs(ProspectorCreateProjectCallout.ProspectorProject.class);
                    system.debug('(makeServiceCallout) status: ' + responseWrap.status);
                    system.debug('(makeServiceCallout) payload: ' + responseWrap.payload);
                    // For debugging purposes, serialize again to verify what was parsed.
                    String s = JSON.serialize(responseWrap);
                    system.debug('(makeServiceCallout) Serialized project: ' + s);
                }//end if START_OBJECT
            }//end while nextToken                
        } else {
            System.debug('(makeServiceCallout) httpResponse == null? ' + (httpResponse==null));
            System.debug('(makeServiceCallout) httpResponse?.getStatusCode() = ' + httpResponse?.getStatusCode());
            System.debug('(makeServiceCallout) httpResponse?.getBody() = ' + httpResponse?.getBody());
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
    
}//end class ProspectorSubmitJobCallout