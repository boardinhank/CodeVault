/****************************************************************
* CLMUtils3 - API processing to Cancel a Contract in Agiloft 
* Change History: 
* Date        	Person Responsible		Traceability    Details
* 11/08/2023    Kuehl                   QFCJ-4697       Cancel 1 to many Agiloft Contracts and Notes.
*
******************************************************************/

global with sharing class CLMUtils3
{   
    static string strAgiloftLoginId 		    = Agiloft_Settings__c.getValues('AgiloftLoginId') 				!= null? Agiloft_Settings__c.getValues('AgiloftLoginId').Value__c: null;
    static string strAgiloftLoginPassword 	    = Agiloft_Settings__c.getValues('AgiloftLoginPassword') 		!= null? Agiloft_Settings__c.getValues('AgiloftLoginPassword').Value__c: null;
    static string strAgiloftTestOrgActive 	    = Agiloft_Settings__c.getValues('AgiloftTestOrgActive') 		!= null? Agiloft_Settings__c.getValues('AgiloftTestOrgActive').Value__c: null;
	static string strAgiloftKB				    = Agiloft_Settings__c.getValues('AgiloftKB') 					!= null? Agiloft_Settings__c.getValues('AgiloftKB').Value__c: null;
    static string strAgiloftSuccessMsg 		    = Agiloft_Settings__c.getValues('AgiloftSuccessMessage') 		!= null? Agiloft_Settings__c.getValues('AgiloftSuccessMessage').Value__c: null;
    static string strAgiloftCancelSuccessMsg	= Agiloft_Settings__c.getValues('AgiloftCancelSuccessMessage') 	!= null? Agiloft_Settings__c.getValues('AgiloftCancelSuccessMessage').Value__c: null;
    static string strAgiloftWarningMsg 		    = Agiloft_Settings__c.getValues('AgiloftWarningMessage') 		!= null? Agiloft_Settings__c.getValues('AgiloftWarningMessage').Value__c: null;
    static string callingApiName 				= 'AgiloftContractCancel';
    static string callingApiName2 				= 'AgiloftContractUpdate';
    
    static final string MANAGER_APPROVED_CONST              = 'Manager Approved';
    static final string USER_ID_VAR_CONST                   = 'user_id=';    
    static final string ACCOUNT_ID_VAR_CONST                = '&account_id=';
    static final string CONTRACT_REQUEST_ID_VAR_CONST       = '&contract_request_id=';
    static final string CONTRACT_TEMPLATE_TO_USE_VAR_CONST  = '&contract_template_to_use=';
    static final string ACCOUNT_NAME_VAR_CONST              = '&account_name=';
    static final string AGILOFT_CONTRACT                    = ' Agiloft Contract: ';
    
    static List<API_Transaction__c> apiTransactions = new List<API_Transaction__c>();
    
    static List<ID> updatedIdsList = new List<ID>();

    public String contractRecordId;
    
    public virtual class BaseException extends Exception {}
    public class ErrorException extends BaseException {}
    
    @InvocableMethod(label='Cancel Agiloft Contract w/ Contract ID' description='Send Cancel/Update API call to Agiloft' callout=true category='Contract')
    
    public static List<String> cancelAgiloftContract(List<ID> ids)
    {           
        string agiloftPayload = '';
       
        /***********************************        IMPORTANT NOTE      ******************************************* */
        // Agiloft only has 1 Test environment so we can have only 1 sandbox pointing to it.
        // The custom setting "AgiloftSettings.AgiloftTestOrgActive" indicates whether the Sandbox is active for testing with Agiloft.  
        // After a refresh the "AgiloftSettings.AgiloftTestOrgActive" = 'NO'. You have to actively change this custom setting to 'Yes' to activate it for the 
        // sandbox.  
        //   !!! Make sure that when you activate it in one Sandbox, that you de-activate it ( set it to 'No') in the sandbox WHERE it was previously active. !!!!
        /************************************************************************************************************ */
             
        string  valid;        
        string  name;
        string  method;
        string  endPoint;
        integer timeOut;
        string  accept;
        string  contentType;

        try 
        {
            valid = validateBaseData(ids);  // Check basic data for good info before continuing..
            
            if (valid.contains('Error'))
        	{
                throw new ErrorException('Not able to validate Base Data... ' + valid);                    
            }
        }
        catch (BaseException e) 
        {  
            // This catches the Exception
            System.debug(e.getMessage());
        }

        
        List<Contract> cntrctList = [SELECT id, CLM_Contract_ID__c, Contract_Request_Offer_Notes__c  FROM Contract WHERE Id in :ids WITH SECURITY_ENFORCED];
                
        integer recNbr = 0;
        
        System.debug ('Contract count to process:  ' + cntrctList.size());
        
        if (cntrctList.size() > 0)
            {
                System.debug ('Get API_Util_mdt data...');

                // Get details up front.
                API_Util__mdt apiUtil = [select MasterLabel, HttpMethod__c, EndPoint__c, TimeOut__c, Accept__c, Content_Type__c, Headers__c from API_Util__mdt where MasterLabel = :callingApiName WITH SECURITY_ENFORCED];
       
                name           = apiUtil.MasterLabel;
                method         = apiUtil.HttpMethod__c;
                endPoint       = Level3Utils.getUrl(apiUtil.EndPoint__c);
                timeOut        = integer.valueOf(apiUtil.TimeOut__c);            
                accept         = apiUtil.Accept__c;
                contentType    = apiUtil.Content_Type__c;

                System.debug ('Got API_Util_mdt data...  name:  ' + name + ', method:  ' + method + ', endPoint:  ' + endPoint + ', timeout:  ' + timeOut + ', accept:  ' + accept + ', ContentType:  ' + ContentType);

            }

        
		for (contract cntrct: cntrctList) 
        {           
            recNbr++;
            System.debug ('Record Number:  ' + recnbr);
            System.debug ('Contract ID:  '   + cntrct.Id);
            
	        if ( (cntrct.Id != null)  && (cntrct.CLM_Contract_ID__c != null) )  // IF we have a contract id and a CLM_Contract_ID__c #.  
	        {      
                System.debug ('Canceling Contract CLM_Contract_ID__c:  ' +  cntrct.CLM_Contract_ID__c);
    
                agiloftPayload = buildCancelContractButtonPayload(cntrct);

                System.debug ('Calling buildSendCancelPayload for contract #: ' +  cntrct.CLM_Contract_ID__c);
               
                buildSendCancelPayload(endPoint, timeOut, method, accept, contentType, cntrct.Id, agiloftPayload);  
                
                System.debug ('After buildSendCancelPayload for Contract #: ' +  cntrct.CLM_Contract_ID__c);   
                

                if (cntrct.Contract_Request_Offer_Notes__c != null) // Do we have messages to process?   // QFCJ-4713 - Removed notes field:  Contract_Request_Status_Notes__c and Replaced it with Contract_Request_Offer_Notes__c
                {
                    System.debug ('Adding message to General Notes box:  ' +  cntrct.Contract_Request_Offer_Notes__c); // QFCJ-4713 - Removed notes field:  Contract_Request_Status_Notes__c and Replaced it with Contract_Request_Offer_Notes__c
    
                    agiloftPayload = buildCancelContractMessagesPayload(cntrct);
                    
                    System.debug ('Calling buildSendUpdatePayload for Contract #: ' +  cntrct.CLM_Contract_ID__c);

                    buildSendUpdatePayload(endPoint, timeOut, method, accept, contentType, cntrct.Id, agiloftPayload);        

                    System.debug ('After buildSendUpdatePayload for Contract #: ' +  cntrct.CLM_Contract_ID__c);                     
                }                
            }
            else
            {
                System.debug ('Contract was NOT Canceled...');                                      
            }        
        }
                 
        // Wrap up DB transactions...  Need to do these last so you don't get callout errors and also perform DB transactions with minimal locks.
        if ( Schema.sObjectType.API_Transaction__c.isCreateable() )   
        {            
            System.debug ('DB Call:  insert apiTransactions...');

            insert apiTransactions;
        }                   

        return updatedIdsList;
    }

    
    public static string validateBaseData(List<id> ids)
     {
    	if ( (Level3utils.detectEnv().toUpperCase() <> 'PROD') && (string.isBlank(strAgiloftTestOrgActive) || strAgiloftTestOrgActive == 'No' )) 
        {            
            return 'Error: This Salesforce instance currently does not support Agiloft testing';        
        } 

        if(String.isBlank(strAgiloftLoginId) || String.isBlank(strAgiloftLoginPassword))
        {
        	return 'Error: No Login Id or Password available, please contact Salesforce Support';
        }

        id recordId = ids.get(0);
         
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
  
        System.debug ('buildCancelContractButtonPayload():  finalPayloadString:  ' +  finalPayloadString);
        
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

        System.debug ('buildCancelContractMessagesPayload():  finalPayloadString:  ' +  finalPayloadString);
        
        return finalPayloadString;
    }


    @future(callout=true)
    public static void buildSendCancelPayload(string endPoint, integer timeOut, string method, string accept, string contentType, id recordId, string agiloftPayload)
    {           
        string  encodedQry;		
        string  finalEndPoint;
        
        Http h = new Http();
        
        System.debug('buildSendPayload():  endPoint:  ' + endPoint + '  recordId:  ' + recordId + '  agiloftPayload:  ' + agiloftPayload);
                  
        encodedQry = '%24KB='+ strAgiloftKB + '&%24login=' + strAgiloftLoginId +'&%24password='+ strAgiloftLoginPassword +'&%24lang=en&%24table=contract&name=cj_cancel_contract_api' + agiloftPayload;
      	
        System.debug('EWActionButton:  encodedQry=:  ' + encodedQry);
        
        finalEndPoint = endPoint + '/EWActionButton?' + encodedQry;
        
        System.debug('finalEndPoint:  ' + finalEndPoint);
        
        HttpRequest req = new HttpRequest();
               
        req.setHeader('Accept', accept);
        req.setHeader('Content-Type', contentType);
        req.setMethod(method);
        req.setTimeout(timeOut);
        req.setEndpoint(finalEndPoint); 
               
        HttpResponse res;
        
        Time startTime = DateTime.now().Time();
    	Time endTime;	 
        
        try 
        {
            System.debug ('Calling http request...  ');

            res = h.send(req);
        
            endTime = DateTime.now().Time();
            
            System.debug('getStatusCode:  '     + res.getStatusCode() );   
            System.debug('getStatus:  '       	+ res.getStatus() );   
            System.debug('getResponse body:  ' 	+ res.getbody() );
                        
            if (res.getStatusCode() < 300)             
            {
                System.debug('Successfull call to Agiloft...  Creating ApiTransaction()...');

                System.debug('Adding recordId to updatedIdsList:  ' + recordId);

                updatedIdsList.add(recordId);

                System.debug('updatedIdsList size is now:  ' + updatedIdsList.size());
                
                createApiTransaction(req, res, callingApiName, startTime, endTime);  // Create API Transaction record for history and reports
                
                System.debug('SUCCESS!!  CLMUtils3.buildSendCancelPayload: ' + res.getBody() + AGILOFT_CONTRACT + recordId);
            }
            else            
            {                        
                System.debug('UN-Successfull Agiloft call... Creating ApiTransaction()...');
                                                
                createApiTransaction(req, res, callingApiName, startTime, endTime);  // Create API Transaction record for history and reports

                System.debug('ERROR...  CLMUtils3.buildSendCancelPayload: Body: ' + res.getBody() + AGILOFT_CONTRACT + recordId);
                
            }            
        }
        catch(Exception e)
        {	             
            System.debug('Exception ERROR...  Before createApiTransaction()...  Cause: ' + e.getCause() + ' Message: ' + e.getMessage() );
            
            createApiTransaction(req, res, callingApiName, startTime, endTime);  // Create API Transaction record for history and reports
  
            System.debug('SEVERE ERROR...  CLMUtils3.buildSendCancelPayload: Body: ' + res.getBody() + AGILOFT_CONTRACT + recordId);            
        }                  
    }   


    @future(callout=true)
    public static void  buildSendUpdatePayload(string endPoint, integer timeOut, string method, string accept, string contentType, id recordId, string agiloftPayload)
    {   
        string encodedQry;		
        string finalEndPoint;

        Http h = new Http();
        
        System.debug('buildSendPayload() - endPoint:  ' + endPoint + '  recordId:  ' + recordId + '  agiloftPayload:  ' + agiloftPayload);
     
        encodedQry = '$KB='+ strAgiloftKB + '&$table=contract&$login=' + strAgiloftLoginId +'&$password='+ strAgiloftLoginPassword + '&$lang=en' + agiloftPayload;
        
        System.debug('EWUpdate:  encodedQry=:  ' + encodedQry);
        
        finalEndPoint = endPoint + '/EWUpdate?' + encodedQry;
        
        System.debug('finalEndPoint:  ' + finalEndPoint);
             
        HttpRequest req = new HttpRequest();
                     
        req.setHeader('Accept', accept);
        req.setHeader('Content-Type', contentType);
        req.setMethod(method);
        req.setTimeout(timeOut);
        req.setEndpoint(finalEndPoint); 
                
        HttpResponse res;
        
        Time startTime = DateTime.now().Time();
    	Time endTime;	 
        
        try 
        {
            System.debug ('Calling http request...  ');

            res = h.send(req);
        
            endTime = DateTime.now().Time();
            
           	System.debug ('getStatusCode:  '       			+ res.getStatusCode() );   
            System.debug ('getStatus:  '       				+ res.getStatus() );   
            System.debug ('getResponse body:  ' 			+ res.getbody() );
                        
            if (res.getStatusCode() < 300)             
            {
                System.debug('Successfull call to Agiloft...  Creating ApiTransaction()...');
             
                createApiTransaction(req, res, callingApiName2, startTime, endTime);  // Create API Transaction record for history and reports
                
                System.debug('SUCCESS!!  CLMUtils3.buildSendUpdatePayload: ' + res.getBody() + AGILOFT_CONTRACT + recordId);

            }
            else            
            {                        
                System.debug('UN-Successfull Agiloft call... Creating ApiTransaction()...');
                                                
                createApiTransaction(req, res,  callingApiName2, startTime, endTime);  // Create API Transaction record for history and reports

                System.debug('ERROR...  CLMUtils3.buildSendUpdatePayload: Body: ' + res.getBody() + AGILOFT_CONTRACT + recordId);
                
            }
        }
        catch(Exception e)
        {	             
            System.debug('Exception ERROR...  Before createApiTransaction()...  Cause: ' + e.getCause() + ' Message: ' + e.getMessage() );
            
            createApiTransaction(req, res,  callingApiName2, startTime, endTime);  // Create API Transaction record for history and reports
            
            System.debug('SEVERE ERROR...  CLMUtils3.buildSendUpdatePayload: Body: ' + res.getBody() + AGILOFT_CONTRACT + recordId);
        }             
    }   


    public static void createApiTransaction(HttpRequest req, HttpResponse res, string callingApiName, Time startTime, Time endTime) 
    {            
        string 	requestEndpoint;
        string 	requestBody;
        
        string 	responseStatus;
        Integer responseStatusCode;
        string 	responseBody;
        
        string  errorDetails;
        
        requestEndpoint     = req.getEndpoint();
        requestBody         = req.getBody();
                
        responseStatus      = res.getStatus();
        responseStatusCode  = res.getStatusCode();
        responseBody        = res.getBody();
        
        System.debug('callingApiName:  '  			+  callingApiName);
        System.debug('getRqstMethod:  ' 			+  req.getMethod());
        System.debug('getRqstHeaderHost:  ' 		+  req.getHeader('Host'));
        System.debug('getRqstHeaderContent-Type:  ' +  req.getHeader('Content-Type'));
        System.debug('getRqstEndpoint:  ' 			+  req.getEndpoint());
        System.debug('getRqstBody:  '     			+  req.getBody());
        
        System.debug('getResponseStatus:  '			+  res.getStatus() );
        System.debug('getResponseStatusCode:  ' 	+  res.getStatusCode() );
        System.debug('getResponseHeaderKeys:  ' 	+  res.getHeaderKeys() );
        System.debug('getResponseBody:  ' 			+  res.getBody() );                
        
        API_Transaction__c objApiTransaction = new API_Transaction__c();   // Create API Transaction record
        
        objApiTransaction.API_Name__c = callingApiName;
               
        // There is NO Request Body for EWActionButton OR EWUpdate calls so will use requestEndpoint instead for historical info...
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
        
        System.debug('endpoint url: '+ objApiTransaction.EndPoint__c);
        
        objApiTransaction.API_Status_Code__c = responseStatusCode != null && responseStatusCode != 0 ? String.valueOf(responseStatusCode) : '';
        objApiTransaction.Request_Time__c   = startTime;        
        objApiTransaction.Response_Time__c  = endTime;                
        
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