/****************************************************************
* CancelCLMContracts - API processing to Cancel Contract(s) in Agiloft 
* Change History: 
* Date        	Person Responsible		Traceability    Details
* 12/11/2023    Kuehl                   QFCJ-4697       Cancel 1 to many Agiloft Contracts and Notes.
*
******************************************************************/

public without sharing class CancelCLMContracts implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful
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
    static final string CONTENT_TYPE_CONST                  = 'Content-Type';
    static final string AGILOFT_CONTRACT                    = ' Agiloft Contract: ';
    static final string CONTRACT_STATUS                     = 'Contract Request Cancelled';
    
    static List<API_Transaction__c> apiTransactions = new List<API_Transaction__c>();
        
    public String contractRecordId;
    
    public virtual class BaseException extends Exception {}
    public class ErrorException extends BaseException {}
    


    public Database.QueryLocator start(Database.BatchableContext bc) 
    {   
        return Database.getQueryLocator ('SELECT Id, CLM_Contract_ID__c, Needs_CLM_Record_Cancelled__c, Contract_Request_Offer_Notes__c FROM Contract WHERE Needs_CLM_Record_Cancelled__c = TRUE AND Contract_Status__c = :CONTRACT_STATUS ');
    }

    public void execute(Database.BatchableContext bc, List<Contract> contractList) 
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
        integer statusCode;
        integer recNbr = 0;
        integer recsProcessed = 0;
        integer contractRecsPulled = 0;

        try 
        {
            valid = validateBaseData();  // Check basic data for good info before continuing..
            
            if (valid.contains('Error'))
        	{
                throw new ErrorException('\n\nNot able to validate Base Data... ' + valid);
            }
        }
        catch (BaseException e) 
        {  
            System.debug(e.getMessage());
        }
        
        System.debug ('\n\nContract count to process:  ' + contractList.size());
        
        System.debug ('\n\nGet API_Util_mdt data...');

        // Get details up front.
        API_Util__mdt apiUtil = [select MasterLabel, HttpMethod__c, EndPoint__c, TimeOut__c, Accept__c, Content_Type__c, Headers__c from API_Util__mdt where MasterLabel = :callingApiName WITH SECURITY_ENFORCED];

        name           = apiUtil.MasterLabel;
        method         = apiUtil.HttpMethod__c;
        endPoint       = Level3Utils.getUrl(apiUtil.EndPoint__c);
        timeOut        = integer.valueOf(apiUtil.TimeOut__c);            
        accept         = apiUtil.Accept__c;
        contentType    = apiUtil.Content_Type__c;

        System.debug ('\n\nGot API_Util_mdt data...  name:  ' + name + ', method:  ' + method + ', endPoint:  ' + endPoint + ', timeout:  ' + timeOut + ', accept:  ' + accept + ', ContentType:  ' + ContentType);

        contractRecsPulled = contractList.size();

        System.debug('contract Recs Pulled to process:  ' + contractRecsPulled);

		for (contract cntrct: contractList) 
        {           
            recNbr++;
            System.debug ('\n\nRecord Number:  ' + recnbr);
            System.debug ('\n\nContract ID:  '   + cntrct.Id);
            
	        if ( (cntrct.Id != null)  && (cntrct.CLM_Contract_ID__c != null) )  // IF we have a contract id and a CLM_Contract_ID__c #.  
	        {      
                System.debug ('\n\nCanceling Contract CLM_Contract_ID__c:  ' +  cntrct.CLM_Contract_ID__c);
    
                agiloftPayload = buildCancelContractButtonPayload(cntrct);

                System.debug ('\n\nCalling buildSendCancelPayload for contract #: ' +  cntrct.CLM_Contract_ID__c);
               
                statusCode = 999;

                statusCode =  buildSendCancelPayload(endPoint, timeOut, method, accept, contentType, cntrct.Id, agiloftPayload);  
                
                System.debug ('\n\nAfter buildSendCancelPayload for Contract #: ' +  cntrct.CLM_Contract_ID__c + ' - StatusCode:  ' + statusCode);   
                
               
                if (statusCode < 300)
                {
                    System.debug ('\n\nNeeds_CLM_Record_Cancelled__c is:  ' + cntrct.Needs_CLM_Record_Cancelled__c);

                    cntrct.Needs_CLM_Record_Cancelled__c = false;  // set value to False if good callout.

                    recsProcessed++;

                    System.debug ('\n\nNeeds_CLM_Record_Cancelled__c is now set to:  ' + cntrct.Needs_CLM_Record_Cancelled__c);
                }

                System.debug ('\n\nAfter buildSendCancelPayload for Contract #: ' +  cntrct.CLM_Contract_ID__c);   
                

                if ((statusCode < 300) && cntrct.Contract_Request_Offer_Notes__c != null) // Do we have messages to process?   // QFCJ-4713 - Removed notes field:  Contract_Request_Status_Notes__c and Replaced it with Contract_Request_Offer_Notes__c
                {
                    System.debug ('\n\nAdding message to General Notes box:  ' +  cntrct.Contract_Request_Offer_Notes__c); // QFCJ-4713 - Removed notes field:  Contract_Request_Status_Notes__c and Replaced it with Contract_Request_Offer_Notes__c
    
                    agiloftPayload = buildCancelContractMessagesPayload(cntrct);
                    
                    System.debug ('\n\nCalling buildSendUpdatePayload for Contract #: ' +  cntrct.CLM_Contract_ID__c);

                    buildSendUpdatePayload(endPoint, timeOut, method, accept, contentType, cntrct.Id, agiloftPayload);        

                    System.debug ('\n\nAfter buildSendUpdatePayload for Contract #: ' +  cntrct.CLM_Contract_ID__c);                     
                }                
            }
            else
            {
                System.debug ('\n\nContract was NOT Canceled...');                                      
            }        
        }


        System.debug ('\n\nUpdating ' + recnbr + ' Contract(s) - Needs_CLM_Record_Cancelled__c flag...\n\n');            
        
        update contractList;  // update Contract Recs w/ flag update.
        
        
        // Wrap up DB transactions...  Need to do these last so you don't get callout errors and also perform DB transactions with minimal locks.
         if ( Schema.sObjectType.API_Transaction__c.isCreateable() )   
         {            
             System.debug ('\n\nDB Call:  insert apiTransactions...');
 
             insert apiTransactions;
         }
         else 
         {
            System.debug ('\n\nNOT able to perform DB Call:  insert apiTransactions...\n\n');
         }

        // select data to get email address...
        User usr = [select id, Name, email FROM user WHERE Name = 'Connected Journey Administrator' WITH SECURITY_ENFORCED LIMIT 1];
                
        System.debug('\n\nUser Info:  Name:  ' + usr.Name + '  Email addr:  ' + usr.email);
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        
        message.toAddresses = new String[] { usr.email };
        message.subject 	= 'CancelCLMContract batch job statistics...';
        string bodyTxt 		= '\nDear Admin,  \n\nThe CancelCLMContract batch job has processed... \n\n   Total Contracts pulled:  ' + contractRecsPulled + '  \n   Total Contracts processed:  ' + recsProcessed + '  \n\nThank you!';
        message.plainTextBody = bodyTxt;
        
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) 
        {
            System.debug('\n\nThe email was sent successfully.');
        } 
        else 
        {
            System.debug('\n\nThe email failed to send: ' + results[0].errors[0].message);
        }               
    }


    public void finish(Database.BatchableContext bc) 
    {
        
    }


    
    public static string validateBaseData()
     {
    	if ( (Level3utils.detectEnv().toUpperCase() <> 'PROD') && (string.isBlank(strAgiloftTestOrgActive) || strAgiloftTestOrgActive == 'No' )) 
        {            
            return 'Error: This Salesforce instance currently does not support Agiloft testing';                    
        } 

        if(String.isBlank(strAgiloftLoginId) || String.isBlank(strAgiloftLoginPassword))
        {
        	return 'Error: No Login Id or Password available, please contact Salesforce Support';
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
  
        System.debug ('\n\nbuildCancelContractButtonPayload():  finalPayloadString:  ' +  finalPayloadString);
        
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

        System.debug ('\n\nbuildCancelContractMessagesPayload():  finalPayloadString:  ' +  finalPayloadString);
        
        return finalPayloadString;
    }

    
    public static integer buildSendCancelPayload(string endPoint, integer timeOut, string method, string accept, string contentType, id recordId, string agiloftPayload)
    {           
        string  encodedQry;		
        string  finalEndPoint;
        
        Http h = new Http();
        
        System.debug('\n\nbuildSendPayload():  endPoint:  ' + endPoint + '  recordId:  ' + recordId + '  agiloftPayload:  ' + agiloftPayload);
                  
        encodedQry = '%24KB='+ strAgiloftKB + '&%24login=' + strAgiloftLoginId +'&%24password='+ strAgiloftLoginPassword +'&%24lang=en&%24table=contract&name=cj_cancel_contract_api' + agiloftPayload;
      	
        System.debug('\n\nEWActionButton:  encodedQry=:  ' + encodedQry);
        
        finalEndPoint = endPoint + '/EWActionButton?' + encodedQry;
        
        System.debug('\n\nfinalEndPoint:  ' + finalEndPoint);
        
        HttpRequest req = new HttpRequest();
               
        req.setHeader('Accept', accept);
        req.setHeader(CONTENT_TYPE_CONST, contentType);
        req.setMethod(method);
        req.setTimeout(timeOut);
        req.setEndpoint(finalEndPoint); 
               
        HttpResponse res;
        
        Time startTime = DateTime.now().Time();
    	Time endTime;	 
        
        try 
        {
            System.debug ('\n\nCalling http request...  ');

            res = h.send(req);
        
            endTime = DateTime.now().Time();
            
            System.debug('\n\ngetStatusCode:  '     + res.getStatusCode() );   
            System.debug('\n\ngetStatus:  '       	+ res.getStatus() );   
            System.debug('\n\ngetResponse body:  ' 	+ res.getbody() );
                        
            if (res.getStatusCode() < 300)             
            {
                System.debug('\n\nSuccessfull call to Agiloft...');
                
                createApiTransaction(req, res, callingApiName, startTime, endTime);  // Create API Transaction record for history and reports
                            
                return res.getStatusCode();
            }
            else            
            {                        
                System.debug('\n\nUN-Successfull Agiloft call...');
                                                
                createApiTransaction(req, res, callingApiName, startTime, endTime);  // Create API Transaction record for history and reports
                
                System.debug('\n\nERROR...  cancelCLMContracts.buildSendUpdatePayload: Body: ' + res.getBody() + AGILOFT_CONTRACT + recordId);         
            }            
        }
        catch(Exception e)
        {	             
            System.debug('\n\nException ERROR... Cause: ' + e.getCause() + ' Message: ' + e.getMessage() );
            
            createApiTransaction(req, res, callingApiName, startTime, endTime);  // Create API Transaction record for history and reports
  
            System.debug('\n\nSEVERE ERROR...  cancelCLMContracts.buildSendCancelPayload: Body: ' + res.getBody() + AGILOFT_CONTRACT + recordId);            
        }      

         return res.getStatusCode();
    }   

    
    public static void  buildSendUpdatePayload(string endPoint, integer timeOut, string method, string accept, string contentType, id recordId, string agiloftPayload)
    {   
        string encodedQry;		
        string finalEndPoint;

        Http h = new Http();
        
        System.debug('\n\nbuildSendPayload() - endPoint:  ' + endPoint + '  recordId:  ' + recordId + '  agiloftPayload:  ' + agiloftPayload);
     
        encodedQry = '$KB='+ strAgiloftKB + '&$table=contract&$login=' + strAgiloftLoginId +'&$password='+ strAgiloftLoginPassword + '&$lang=en' + agiloftPayload;
        
        System.debug('\n\nEWUpdate:  encodedQry=:  ' + encodedQry);
        
        finalEndPoint = endPoint + '/EWUpdate?' + encodedQry;
        
        System.debug('\n\nfinalEndPoint:  ' + finalEndPoint);
             
        HttpRequest req = new HttpRequest();
                     
        req.setHeader('Accept', accept);
        req.setHeader(CONTENT_TYPE_CONST, contentType);
        req.setMethod(method);
        req.setTimeout(timeOut);
        req.setEndpoint(finalEndPoint); 
                
        HttpResponse res;
        
        Time startTime = DateTime.now().Time();
    	Time endTime;	 
        
        try 
        {
            System.debug ('\n\nCalling http request...  \n');

            res = h.send(req);
        
            endTime = DateTime.now().Time();
            
           	System.debug ('\n\ngetStatusCode:  '       			+ res.getStatusCode() );   
            System.debug ('\n\ngetStatus:  '       				+ res.getStatus() );   
            System.debug ('\n\ngetResponse body:  ' 			+ res.getbody() );
                        
            if (res.getStatusCode() < 300)             
            {
                System.debug('\n\nSuccessfull call to Agiloft...');
             
                createApiTransaction(req, res, callingApiName2, startTime, endTime);  // Create API Transaction record for history and reports
            }
            else            
            {                        
                System.debug('\n\nUN-Successfull Agiloft call... ');
                                                
                createApiTransaction(req, res,  callingApiName2, startTime, endTime);  // Create API Transaction record for history and reports

                System.debug('\n\nERROR...  cancelCLMContracts.buildSendUpdatePayload: Body: ' + res.getBody() + AGILOFT_CONTRACT + recordId);                
            }
        }
        catch(Exception e)
        {	             
            System.debug('\n\nException ERROR...  Before createApiTransaction()...  Cause: ' + e.getCause() + ' Message: ' + e.getMessage() );
            
            createApiTransaction(req, res,  callingApiName2, startTime, endTime);  // Create API Transaction record for history and reports
            
            System.debug('\n\nSEVERE ERROR...  cancelCLMContracts.buildSendUpdatePayload: ' + res.getBody() + AGILOFT_CONTRACT + recordId);
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
        
        System.debug('\n\nCreating ApiTransaction()...'); 

        System.debug('\n\ncallingApiName:  '  			+  callingApiName);
        System.debug('\n\ngetRqstMethod:  ' 			+  req.getMethod());
        System.debug('\n\ngetRqstHeaderHost:  ' 		+  req.getHeader('Host'));
        System.debug('\n\ngetRqstHeaderContent-Type:  ' +  req.getHeader(CONTENT_TYPE_CONST));
        System.debug('\n\ngetRqstEndpoint:  ' 			+  req.getEndpoint());
        System.debug('\n\ngetRqstBody:  '     			+  req.getBody());
        
        System.debug('\n\ngetResponseStatus:  '			+  res.getStatus() );
        System.debug('\n\ngetResponseStatusCode:  ' 	+  res.getStatusCode() );
        System.debug('\n\ngetResponseHeaderKeys:  ' 	+  res.getHeaderKeys() );
        System.debug('\n\ngetResponseBody:  ' 			+  res.getBody() );                
        
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
        
        System.debug('\n\nendpoint url: '+ objApiTransaction.EndPoint__c);
        
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