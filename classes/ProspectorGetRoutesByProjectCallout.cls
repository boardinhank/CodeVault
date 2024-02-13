/***************************************************************
===============================================================
Purpose: Prospector Get-Routes-By-Project callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/26/2022   ESCJ-653  	  Initial draft
***************************************************************/
public class ProspectorGetRoutesByProjectCallout {
    public static APITransactionService apiTransactionServiceManager;
    private static Id transactionSummaryId;

    /**********************************************************************************************
    Purpose: Parameterized constructor for passing query param latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public ProspectorGetRoutesByProjectCallout(Id thisTransactionSummaryId) {
        transactionSummaryId = thisTransactionSummaryId;
    }//end method ProspectorGetRoutesByProjectCallout

    /**********************************************************************************************
    Purpose: Method to be called by another apex for getting property info from address/latlong
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public ProspectorGetRoutesWrap getRoutesByProject(String projectId, String facilityType) {
        ProspectorGetRoutesWrap resWrapper;
        if (String.isNotBlank(ProspectorConstants.MAPSERVICENAME)) {
            API_Util__mdt apiUtil = getApiUtils(ProspectorConstants.GET_ROUTES_BY_PROJECT);
            Map<String, String> queryParamMap = createQueryParamMap(projectId);
            resWrapper = makeServiceCallout(ProspectorConstants.GET_ROUTES_BY_PROJECT, facilityType, queryParamMap);
        } else {
            System.debug('ProspectorGetRoutesByProjectCallout Class Error: No query param present');
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
        queryParamMap.put(ProspectorConstants.LABEL_PROJECTID, projectId);
        
        return queryParamMap;
    }//end method createQueryParamMap

    /**********************************************************************************************
    Purpose: To make service callout by calling API Transaction controller class
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private ProspectorGetRoutesWrap makeServiceCallout(
        String callingApiName,
        String facilityType,
        Map<String, String> queryParamMap
    ) {
        ProspectorGetRoutesWrap responseWrap;
        String responseBody = null;
        
        apiTransactionServiceManager = new ApiTransactionService(
                callingApiName,
                null,
                queryParamMap,
                transactionSummaryId
            );
        apiTransactionServiceManager.facilityTypeForProspector = facilityType;
        System.debug('pre serviceCallout');
        HttpResponse httpResponse = apiTransactionServiceManager.serviceCallout(callingApiName,                
                null,
                queryParamMap,
                transactionSummaryId);
        System.debug('post serviceCallout');
        System.debug('statusCode: ' + httpResponse?.getStatusCode());
        System.debug('body: ' + httpResponse?.getBody());
        if (httpResponse != null && httpResponse?.getStatusCode() == 200 && httpResponse?.getBody() != null) {
            responseBody = httpResponse?.getBody();
            System.debug('(makeServiceCallout) responseBody = ' + responseBody);
            responseWrap = ProspectorGetRoutesWrap.parse(responseBody); 
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
    
}//end class ProspectorGetRoutesByProjectCallout