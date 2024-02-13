/****************************************************************
* CLMUtils2 - API processing to Cancel a Contract in Agiloft
* Change History: 
* Date        	Person Responsible		Traceability    Details
* 01/13/2023    Kuehl                   ESCJ-2345       Process Cancel Contract - Run button in Agiolft and update general messages notes
* 02/15/2023	Kuehl					       		        Code Coverage 76%  using CLMUtilsTest2
* 04/27/2023    Kuehl                   QFCJ-3071       Bug - returning Error msg incorrectly when there are NOTES to be updated.  Added and removed some code.
* 04/28/2023	Kuehl					       		        Code Coverage 76%  using CLMUtilsTest2
* 10/31/2023    Kuehl                   QFCJ-4713       Removed notes field:  Contract_Request_Status_Notes__c and Replaced it with Contract_Request_Offer_Notes__c
*
******************************************************************/

global with sharing class CLMUtils2
{   
    static string strAgiloftLoginId 		    = Agiloft_Settings__c.getValues('AgiloftLoginId') 				!= null? Agiloft_Settings__c.getValues('AgiloftLoginId').Value__c: null;
    static string strAgiloftLoginPassword 	    = Agiloft_Settings__c.getValues('AgiloftLoginPassword') 		!= null? Agiloft_Settings__c.getValues('AgiloftLoginPassword').Value__c: null;
    static string strAgiloftTestOrgActive 	    = Agiloft_Settings__c.getValues('AgiloftTestOrgActive') 		!= null? Agiloft_Settings__c.getValues('AgiloftTestOrgActive').Value__c: null;
	static string strAgiloftKB				    = Agiloft_Settings__c.getValues('AgiloftKB') 					!= null? Agiloft_Settings__c.getValues('AgiloftKB').Value__c: null;
    static string strAgiloftSuccessMsg 		    = Agiloft_Settings__c.getValues('AgiloftSuccessMessage') 		!= null? Agiloft_Settings__c.getValues('AgiloftSuccessMessage').Value__c: null;
    static string strAgiloftCancelSuccessMsg	= Agiloft_Settings__c.getValues('AgiloftCancelSuccessMessage') 	!= null? Agiloft_Settings__c.getValues('AgiloftCancelSuccessMessage').Value__c: null;
    static string strAgiloftWarningMsg 		    = Agiloft_Settings__c.getValues('AgiloftWarningMessage') 		!= null? Agiloft_Settings__c.getValues('AgiloftWarningMessage').Value__c: null;
   
    static final string MANAGER_APPROVED_CONST              = 'Manager Approved';
    static final string USER_ID_VAR_CONST                   = 'user_id=';    
    static final string ACCOUNT_ID_VAR_CONST                = '&account_id=';
    static final string CONTRACT_REQUEST_ID_VAR_CONST       = '&contract_request_id=';
    static final string CONTRACT_TEMPLATE_TO_USE_VAR_CONST  = '&contract_template_to_use=';
    static final string ACCOUNT_NAME_VAR_CONST              = '&account_name=';
    static final string AGILOFT_CONTRACT                    = ' Agiloft Contract: ';
    
    static List<API_Transaction__c> apiTransactions = new List<API_Transaction__c>();
    
    public String contractRecordId;
    
    public List<CLMUtils2.CalloutParams> coParamsList;

    
    public CLMUtils2(String recordIdIn) //Constructor - Invoke this code when an object is created from the class blueprint - "setup" or Prework to go fwd.
    {                
       	this.contractRecordId = recordIdIn; 

        this.coParamsList 			= new List<CLMUtils2.CalloutParams>();

        CLMUtils2.CalloutParams cp 	= new CLMUtils2.CalloutParams();

        cp.contractRecordId = this.contractRecordId;
        
        this.coParamsList.add(cp);
    }//end constructor 
    
    
    public class CalloutParams 
    { 
        @invocableVariable(label='Contract Record Id' description='The id of the Contract record' required=true)
        public String contractRecordId;    
    }
    

    @InvocableMethod(label='Cancel Agiloft Contract w/ Contract ID' 
                     description='Send Cancel/Update API call to Agiloft' 
                     callout=true 
                     category='Contract')
    
    public static List<String> cancelAgiloftContract(List<CalloutParams> calloutParams)
    {       
        List<String> returnMessageList = new List<String>();
        
        string callingApiName 		= 'AgiloftContractCancel';
        string callingApiName2 		= 'AgiloftContractUpdate';
        string strAgiloftFinalMsg   = '';
        string agiloftPayload       = '';
        
        String recordId = calloutParams.get(0).contractRecordId;                                           
        
        /***********************************        IMPORTANT NOTE      ******************************************* */
        // Agiloft only has 1 Test environment so we can have only 1 sandbox pointing to it.
        // The custom setting "AgiloftSettings.AgiloftTestOrgActive" indicates whether the Sandbox is active for testing with Agiloft.  
        // After a refresh the "AgiloftSettings.AgiloftTestOrgActive" = 'NO'. You have to actively change this custom setting to 'Yes' to activate it for the 
        // sandbox.  
        //   !!! Make sure that when you activate it in one Sandbox, that you de-activate it ( set it to 'No') in the sandbox WHERE it was previously active. !!!!
        /************************************************************************************************************ */
     
        validateBaseData(recordId);  // Check basic data for good info before continuing..
       
        // Get base DB data to use for continued processing and conditionals...

        // FYI, id is aka ContractID - Example: 8008F000000Do02QAC (Contract # 00000217) OR 8008F000000DoETQA0 (Contract # 00000218) - AccountId example: 0018F000001vtb8QAA   
         
        system.debug ('recordId is:  ' +  recordId);   
        
        // QFCJ-4713 - Removed notes field:  Contract_Request_Status_Notes__c and Replaced it with Contract_Request_Offer_Notes__c
        Contract cntrct	= [SELECT id, CLM_Contract_ID__c, Contract_Request_Offer_Notes__c  FROM Contract WHERE id =: recordId WITH SECURITY_ENFORCED LIMIT 1];

        if ( (cntrct.Id != null)  && (cntrct.CLM_Contract_ID__c != null) )  // IF we have a contract id and a CLM_Contract_ID__c #.  
        {      
            system.debug ('Canceling Contract  CLM_Contract_ID__c:  ' +  cntrct.CLM_Contract_ID__c);

    	    agiloftPayload      = buildCancelContractButtonPayload(cntrct);
            strAgiloftFinalMsg  = buildSendPayload(callingApiName, recordId, agiloftPayload);  
            
            system.debug ('strAgiloftFinalMsg - Canceling Contract - Ready to update General Notes...' +  strAgiloftFinalMsg);
            
            if (strAgiloftFinalMsg == null)  // Do Not Process 2nd APi call for "message" updates
            {
            	system.debug ('Contract was NOT Canceled...');              	
                returnMessageList = new List<String>();
            	returnMessageList.add('System Error: No return msg from API.. Please contact IT for support...');
                return  returnMessageList;
            }
            
            if (strAgiloftFinalMsg.contains('Error'))  // Do Not Process 2nd APi call for "message" updates
            {
                returnMessageList = new List<String>();
                returnMessageList.add(strAgiloftFinalMsg);  
                return returnMessageList;
            }
            
            if (cntrct.Contract_Request_Offer_Notes__c != null) // Do we have messages to process?   // QFCJ-4713 - Removed notes field:  Contract_Request_Status_Notes__c and Replaced it with Contract_Request_Offer_Notes__c
            {
                system.debug ('Canceled Contract - Adding messages to General Notes box:  ' +  cntrct.Contract_Request_Offer_Notes__c); // QFCJ-4713 - Removed notes field:  Contract_Request_Status_Notes__c and Replaced it with Contract_Request_Offer_Notes__c

                agiloftPayload      = buildCancelContractMessagesPayload(cntrct);
                strAgiloftFinalMsg  = buildSendPayload(callingApiName2, recordId, agiloftPayload);         
                returnMessageList.add(strAgiloftFinalMsg);
            }                
        }
        else
        {
            system.debug ('Contract was NOT Canceled...');                         
            returnMessageList = new List<String>();
            returnMessageList.add('Error:  Contract was NOT Canceled.  No matching criteria...');            
        }        
                 
        // Wrap up DB transactions...  Need to do these last so you don't get callout errors and also perform DB transactions with minimal locks.
        if ( Schema.sObjectType.API_Transaction__c.isCreateable() )   
        {            
            insert apiTransactions;
        }                   

        return returnMessageList;
    }

    
    public static string validateBaseData(id recordId)
     {
    	if ( (Level3utils.detectEnv().toUpperCase() <> 'PROD') && (string.isBlank(strAgiloftTestOrgActive) || strAgiloftTestOrgActive == 'No' )) 
        {
            return 'Error: This Salesforce instance currently does not support Agiloft testing';        
        } 

        if(String.isBlank(strAgiloftLoginId)||String.isBlank(strAgiloftLoginPassword))
        {
        	return 'Error: No Login Id or Password available, please contact Salesforce Support';
        }

        if (recordId.getSObjectType().getDescribe().getName() != 'Contract') 
        {
            return 'Error: Invalid object type passed in.  Should be Contract Obj, please contact Salesforce Support';
        }
        
        return 'Good To Go...';
     }
        
    

    public static string buildCancelContractButtonPayload(SObject contract)  // ESCJ-2345 - spk - 1-13-2023 - Process Cancel Contract button
    {   
        string payloadString        = '';
        string finalPayloadString   = '';
                
        // Assign SObjects to use the data coming in.        
        Contract cntrct = (Contract) contract;
       
        payloadString = payloadString + '&id='+ cntrct.CLM_Contract_ID__c;
                
        finalPayloadString = payloadString.replaceAll('null', '');  // Cut out all null values;  set variables FROM &abc123=null&def456=null  to be:   &abc123=&def456=
  
        system.debug ('buildCancelContractButtonPayload():  finalPayloadString:  ' +  finalPayloadString);
        
        return finalPayloadString;
    }
    

    public static string buildCancelContractMessagesPayload(SObject contract)  // ESCJ-2345 - spk - 1-13-2023 - Process Cancel Contract  general messages
    {   
        string payloadString        = '';
        string finalPayloadString   = '';
        
        // Assign SObjects to use the data coming in.        
        Contract cntrct = (Contract) contract;
                
        string notes = cntrct.Contract_Request_Offer_Notes__c;  // QFCJ-4713 removed cntrct.Contract_Request_Status_Notes__c;   Replaced with Contract_Request_Offer_Notes__c
        notes 		 = notes.replace(' ', '%20');  // Need to add spaces the hard way..  Call does not know how to handle otherwise and you get a 400 error.
                
        payloadString = payloadString + '&id='              + cntrct.CLM_Contract_ID__c;
        payloadString = payloadString + '&ongoing_notes='   + notes;
                
        finalPayloadString = payloadString.replaceAll('null', '');  // Cut out all null values;  set variables FROM &abc123=null&def456=null  to be:   &abc123=&def456=

        system.debug ('buildCancelContractMessagesPayload():  finalPayloadString:  ' +  finalPayloadString);
        
        return finalPayloadString;
    }


    public static string buildSendPayload(string callingApiName, id recordId, string agiloftPayload)
    {   
        string encodedQry;		
        string endpoint;
        
        WebServiceUtilsAgiloft utils = new WebServiceUtilsAgiloft(callingApiName);
        
        endpoint = utils.endPoint;
        
        system.debug('endPoint is: ' + endpoint);
     
        if (callingApiName.contains('ContractCancel'))
        {
            endPoint = endPoint + '/EWActionButton?';            
            encodedQry = '%24KB='+ strAgiloftKB + '&%24login=' + strAgiloftLoginId +'&%24password='+ strAgiloftLoginPassword +'&%24lang=en&%24table=contract&name=cj_cancel_contract_api' + agiloftPayload;
      		system.debug('EWActionButton:  encodedQry=:  ' + encodedQry);
        }
        else if (callingApiName.contains('ContractUpdate'))
        {
            endPoint = endPoint + '/EWUpdate?';            
            encodedQry = '$KB='+ strAgiloftKB + '&$table=contract&$login=' + strAgiloftLoginId +'&$password='+ strAgiloftLoginPassword + '&$lang=en' + agiloftPayload;
            system.debug('EWUpdate:  encodedQry=:  ' + encodedQry);
        }
        else if (callingApiName.contains('ContractRead'))
        {
            endPoint = endPoint + '/EWRead?';
            encodedQry = '$KB='+ strAgiloftKB + '&$table=contract&$login=' + strAgiloftLoginId +'&$password='+ strAgiloftLoginPassword + '&$lang=en' + agiloftPayload;            
       		system.debug('EWRead:  encodedQry=:  ' + encodedQry);
        }
        else 
        {
            return 'Error:  System Error, No callingApiName match...';
        }        
        
        utils.setEndpoint(endpoint);
        
        system.debug('encodedQry BEFORE Append is:  ' + encodedQry);
        
        utils.appendQueryParam(encodedQry);
                
		system.debug('getRqstEndpoint AFTER append:  ' +  utils.getRequest().getEndpoint());
                
        string response = trySendAPICall(utils, callingApiName, recordId);

        return response;
    }   


    public static string trySendAPICall(WebServiceUtilsAgiloft utils, string callingApiName, id recordId )
    {
    	Time startTime = DateTime.now().Time();
    	Time endTime;	 
        
        try
        {
            system.debug ('Calling utils.send(false)...  ');
            
            Boolean isContractAPISuccessful = utils.send(false);
            
            endTime = DateTime.now().Time();
            
            system.debug ('isContractAPISuccessful?:  ' + isContractAPISuccessful);            
            system.debug ('getStatus:  '       			+ utils.getResponse().getStatus() );   
            system.debug ('api response:  ' 			+ utils.getResponse() );
                        
            if (isContractAPISuccessful && utils.statusCode < 300)
            {
                system.debug('Success... Before createApiTransaction()...');
                
                createApiTransaction(utils, callingApiName, startTime, endTime, null);  // Create API Transaction record for history and reports
                
                System.debug('SUCCESS!!  CLMUtils2.buildSendPayload: ' + utils.getResponse().getBody() + AGILOFT_CONTRACT + recordId);

                if (callingApiName.contains('AgiloftContractCancel'))    // If Cancel trx
                {
                    return strAgiloftCancelSuccessMsg;    
                }                
                else 
                {
                    return '';  // no need to add strAgiloftCancelSuccessMsg for "notes" update.  QFCJ-3071
                }
            }
            else            
            {                        
                system.debug('Error... Before ApiTransaction()...');
                                                
                createApiTransaction(utils, callingApiName, startTime, endTime, null); // Create API Transaction record for history and reports
                
                System.debug('ERROR...  CLMUtils2.buildSendPayload: Body: ' + utils.getResponse().getBody() + AGILOFT_CONTRACT + recordId);
                
                return 'Error: ' + utils.getResponse(); 
            }            
        }
        catch(Exception e)
        {	             
            system.debug('Exception...  Before createApiTransaction()...  Cause: ' + e.getCause() + ' Message: ' + e.getMessage() );
            
            createApiTransaction(utils, callingApiName, startTime, endTime, null);		// Create API Transaction record for history and reports
            
            System.debug('ERROR...  CLMUtils2.buildSendPayload: Body: ' + utils.getResponse().getBody() + AGILOFT_CONTRACT + recordId);
            
            return 'Error: An error occurred during Contract Processing. Please contact Salesforce Production Support.';
        }                
    }        


    public static void createApiTransaction(WebServiceUtilsAgiloft utils, string callingApiName, Time startTime, Time endTime, string transactionSummaryId) 
    {            
        string 	responseStatus;
        Integer responseStatusCode;
        string 	responseBody;
        string 	requestEndpoint;
        string 	requestBody;
        string  errorDetails;
        
        requestEndpoint     = utils.getRequest().getEndpoint();
        requestBody         = utils.getRequest().getBody();
                
        responseStatus      = utils.getResponse().getStatus();
        responseStatusCode  = utils.getResponse().getStatusCode();
        responseBody        = utils.getResponse().getBody();        
        
        errorDetails        = utils.errorMsg;
        
        system.debug('callingApiName:  '  			+  callingApiName);
        system.debug('getRqstMethod:  ' 			+  utils.getRequest().getMethod());
        system.debug('getRqstHeaderHost:  ' 		+  utils.getRequest().getHeader('Host'));
        system.debug('getRqstHeaderContent-Type:  ' +  utils.getRequest().getHeader('Content-Type'));
        system.debug('getRqstEndpoint:  ' 			+  utils.getRequest().getEndpoint());
        system.debug('getRqstBody:  '     			+  utils.getRequest().getBody());
        
        system.debug('getResponseStatus:  '			+  utils.getResponse().getStatus() );
        system.debug('getResponseStatusCode:  ' 	+  utils.getResponse().getStatusCode() );
        system.debug('getResponseHeaderKeys:  ' 	+  utils.getResponse().getHeaderKeys() );
        system.debug('getResponseBody:  ' 			+  utils.getResponse().getBody() );                
        
        system.debug('utils.errorMsg:  '  			+  utils.errorMsg);
        
        
        API_Transaction__c objApiTransaction = new API_Transaction__c();   // Create API Transaction record
        
        objApiTransaction.API_Name__c = callingApiName;
               
        // There is NO Request Body for EWActionButton OR EWUpdate OR EWRead calls so will use requestEndpoint instead for historical info...
        //objApiTransaction.API_Request_JSON__c = requestBody != null && requestBody != '' ? requestBody : null;
        
        objApiTransaction.API_Request_JSON__c = requestEndpoint != null && requestEndpoint != '' ? requestEndpoint : null;

        // If the http response body is not null or blank then proceed
        if (responseBody != null && responseBody != '') 
        {
            string apiTrimResponse;

            apiTrimResponse = checkTrimApiResponse(responseBody);
            
            objApiTransaction.API_Response_JSON__c = apiTrimResponse;                
        }                
        else if (errorDetails != null && errorDetails != '') // If there are any error details then add that in the API Response field. 
        {
            objApiTransaction.API_Response_JSON__c = errorDetails;
        }            

        objApiTransaction.Internal_Message_Code__c = responseStatus != null && responseStatus != '' ? responseStatus : '';
        objApiTransaction.EndPoint__c = requestEndpoint != null && requestEndpoint != '' ? requestEndpoint : 'There is no end point';

        //spk Trim endpoint to remove any id/pwd by chance...                
        Integer position = objApiTransaction.EndPoint__c.indexOfAny('?');
        objApiTransaction.EndPoint__c = objApiTransaction.EndPoint__c.left(position);
        
        system.debug('endpoint url: '+ objApiTransaction.EndPoint__c);
        
        objApiTransaction.API_Status_Code__c = responseStatusCode != null && responseStatusCode != 0 ? String.valueOf(responseStatusCode) : '';
        objApiTransaction.Request_Time__c   = startTime;        
        objApiTransaction.Response_Time__c  = endTime;        
        objApiTransaction.Transaction_Summary_Id__c = transactionSummaryId;
        
        apiTransactions.add(objApiTransaction);                
    }


    public static string checkTrimApiResponse( string responseBody) 
    {
        string apiTrimResponse;
        apiTrimResponse = responseBody;
                
        if (apiTrimResponse?.length() > 131072) // If the response char length is greater than 131072 them trim & abbreviate it
        {
            apiTrimResponse = apiTrimResponse?.remove('\n\t\r');
            apiTrimResponse = apiTrimResponse?.trim();
            
            if (apiTrimResponse?.length() > 131072) 
            {
                apiTrimResponse = apiTrimResponse?.abbreviate(131072);
            }
        }

        return apiTrimResponse;
    }        
}