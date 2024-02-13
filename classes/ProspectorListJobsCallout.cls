/***************************************************************
===============================================================
Purpose: Prospector List-Jobs callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/26/2022   ESCJ-653  	  Initial draft
***************************************************************/
public class ProspectorListJobsCallout { 
    public static APITransactionService apiTransactionServiceManager;
    private static Id transactionSummaryId;

    /**********************************************************************************************
    Purpose: Parameterized constructor for passing transactionSummaryId to tie all related transactions together
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public ProspectorListJobsCallout(Id thisTransactionSummaryId) {
        transactionSummaryId = thisTransactionSummaryId;
    }//end method ProspectorListJobsCallout

    /**********************************************************************************************
    Purpose: Method to be called by another apex for getting list of jobs from Prospector
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public ProspectorListJobsWrap listJobs() {
        ProspectorListJobsWrap resWrapper;
        if (String.isNotBlank(ProspectorConstants.MAPSERVICENAME) && String.isNotBlank(ProspectorConstants.USERNAME_DEV)) {
            API_Util__mdt apiUtil = getApiUtils(ProspectorConstants.LIST_JOBS);
            Map<String, String> queryParamMap = createQueryParamMap();
            resWrapper = makeServiceCallout(ProspectorConstants.LIST_JOBS, queryParamMap);
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
    private Map<String, String> createQueryParamMap() {
        Map<String, String> queryParamMap = new Map<String, String>();
        queryParamMap.put(ProspectorConstants.LABEL_MAPSERVICENAME, ProspectorConstants.MAPSERVICENAME);
        queryParamMap.put(ProspectorConstants.LABEL_USERNAME, ProspectorConstants.USERNAME_DEV);
        
        return queryParamMap;
    }//end method createQueryParamMap

    /**********************************************************************************************
    Purpose: To make service callout by calling API Transaction controller class
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private ProspectorListJobsWrap makeServiceCallout(
        String callingApiName,
        Map<String, String> queryParamMap
    ) {
        ProspectorListJobsWrap responseWrap;
        String responseBody = null;
        
        apiTransactionServiceManager = new ApiTransactionService(
                callingApiName,
                null,
                queryParamMap,
                transactionSummaryId
            );
        System.debug('pre serviceCallout');
        HttpResponse httpResponse = apiTransactionServiceManager.serviceCallout(callingApiName,                
                null,
                queryParamMap,
                transactionSummaryId);
        System.debug('post serviceCallout');
        System.debug(httpResponse?.getStatusCode());
        System.debug(httpResponse?.getBody());
        if (httpResponse != null && httpResponse?.getStatusCode() == 200 && httpResponse?.getBody() != null) {
            responseBody = httpResponse?.getBody();
            System.debug('(makeServiceCallout) responseBody = ' + responseBody);
            //Parse the body and store the values in the responseMap variable
            /*  Example of response:
             * {
             *     "status": "success",
             *     "message": null,
             *     "payload": "{235F3538-2A2A-4E65-93FB-4E19BB77F1A0}"
             * }
             */
            JSONParser parser = JSON.createParser(responseBody);
            while (parser.nextToken() != null) {
                // Advance to the start object marker to
                //  find next invoice statement object.
                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                    // Read entire invoice object, including its array of line items.
                    responseWrap = (ProspectorListJobsWrap)parser.readValueAs(ProspectorListJobsWrap.class);
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
    
}//end class ProspectorListJobsCallout