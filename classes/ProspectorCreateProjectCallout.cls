/***************************************************************
===============================================================
Purpose: Prospector Create-Project callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
***************************************************************/
public class ProspectorCreateProjectCallout {
//    public static ProspectorAPITransactionHelper apiTransactionServiceManager;
	public static APITransactionService apiTransactionServiceManager;
    private static Id transactionSummaryId;

    /**********************************************************************************************
    Purpose: Parameterized constructor for passing query param latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public ProspectorCreateProjectCallout(Id thisTransactionSummaryId) {
        transactionSummaryId = thisTransactionSummaryId;
        //apiTransactionServiceManager = new APITransactionService();
    }//end method ProspectorCreateProjectCallout

    /**********************************************************************************************
    Purpose: Method to be called by another apex for getting property info from address/latlong
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public ProspectorProject getProjectName(String colorIn) {
        ProspectorProject resWrapper;
        if (String.isNotBlank(ProspectorConstants.MAPSERVICENAME) && String.isNotBlank(ProspectorConstants.USERNAME_DEV)) {
            API_Util__mdt apiUtil = getApiUtils(ProspectorConstants.CREATE_PROJECT);
            Map<String, String> queryParamMap = createQueryParamMap();
            String requestBody = createRequestBody(colorIn);
            resWrapper = makeServiceCallout(ProspectorConstants.CREATE_PROJECT, requestBody, queryParamMap);
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
    Purpose: To create request body
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private String createRequestBody(String colorIn) {
		String projectNameInput = colorIn + DateTime.now().getTime();
        String rBody = '';
        rBody += '{';//JSONToken.START_OBJECT;
        rBody += ' "projectName": "' + projectNameInput + '", ';
        rBody += ' "currentUser": "' + ProspectorConstants.MAPSERVICENAME + '", ';
        rBody += ' "mapServiceId": "' + ProspectorConstants.MAPSERVICEID + '" ';
        rBody += '}';//JSONToken.END_OBJECT;
        System.debug('(ProspectorCreateProjectCallout.createRequestBody) requestBody as JSON = ' + rBody);
        
        return rBody;
    }//end method createRequestBody

    /**********************************************************************************************
    Purpose: To make service callout by calling API Transaction controller class
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/25/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private ProspectorProject makeServiceCallout(
        String callingApiName,
        String requestBody,
        Map<String, String> queryParamMap
    ) {
        ProspectorProject responseWrap;
        String responseBody = null;
        
        apiTransactionServiceManager = new ApiTransactionService(
            callingApiName,
            requestBody,
            queryParamMap,
            transactionSummaryId
        );
        System.debug('(ProspectorCreateProjectCallout.makeServiceCallout) pre apiTransactionServiceManager.serviceCallout');
        if(apiTransactionServiceManager != null) {
            HttpResponse httpResponse = apiTransactionServiceManager.serviceCallout(callingApiName,                
                    requestBody,
                    queryParamMap,
                    transactionSummaryId);
            System.debug('(ProspectorCreateProjectCallout.makeServiceCallout) post apiTransactionServiceManager.serviceCallout');
            System.debug('(ProspectorCreateProjectCallout.makeServiceCallout) httpResponse = ' + httpResponse);
            System.debug('(ProspectorCreateProjectCallout.makeServiceCallout) httpResponse?.getStatusCode() = ' + httpResponse?.getStatusCode());
            System.debug('(ProspectorCreateProjectCallout.makeServiceCallout) httpResponse?.getBody() = ' + httpResponse?.getBody());
            if (httpResponse != null && httpResponse?.getStatusCode() == 200 && httpResponse?.getBody() != null) {
                responseBody = httpResponse?.getBody();
                System.debug('(ProspectorCreateProjectCallout.makeServiceCallout)  responseBody = ' + responseBody);
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
                        responseWrap = (ProspectorProject)parser.readValueAs(ProspectorProject.class);
                        system.debug('(ProspectorCreateProjectCallout.makeServiceCallout)  status: ' + responseWrap.status);
                        system.debug('(ProspectorCreateProjectCallout.makeServiceCallout)  payload: ' + responseWrap.payload);
                        // For debugging purposes, serialize again to verify what was parsed.
                        String s = JSON.serialize(responseWrap);
                        system.debug('(ProspectorCreateProjectCallout.makeServiceCallout)  Serialized project: ' + s);
                    }//end if START_OBJECT
                }//end while nextToken                
            } else {
                System.debug('(ProspectorCreateProjectCallout.makeServiceCallout) httpResponse == null? ' + (httpResponse==null));
                System.debug('(ProspectorCreateProjectCallout.makeServiceCallout) httpResponse?.getStatusCode() = ' + httpResponse?.getStatusCode());
                System.debug('(ProspectorCreateProjectCallout.makeServiceCallout) httpResponse?.getBody() = ' + httpResponse?.getBody());
            }
        }//end if apiTransactionManager NOT NULL
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
    
    /*public ProspectorAPITransactionHelper getApiTransactionServiceManager() {
    	return apiTransactionServiceManager;    
    }*/
    public ApiTransactionService getApiTransactionServiceManager() {
    	return apiTransactionServiceManager;    
    }
    
    public class ProspectorProject {
        public String status;
        public String message;
        public String payload;
/*
        public override String toString() {
            return 'ProspectorProject:' +
                         '\n status=' + status + 
                         '\n message=' + message +
                         '\n payload=' + payload;
        }
*/
    }//end class ProspectorProject
    
}//end class ProspectorCreateProjectCallout