/***************************************************************************************************
 * Name:  NRMAResponseHelper
 * Platform: Salesforce Connected Journey (SFCJ)
 * Helper class for BRAIN/NRMA Approval-Tool interaction between SFCJ and BRAIN API
 * Code Coverage:  TestNRMAResponseHelper -- 88%  01/04/2023
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 01/04/2023  	T2Cabato    Feature(Epic) ESCJ-3932	        Base version
****************************************************************************************************/
public with sharing class NRMAResponseHelper {
    private class ZeroListException extends Exception {}
    private class NullObjectException extends Exception {}
    private class NullResponseJSONException extends Exception {}
    private class FailedResponseException extends Exception {}
    private class ObjectsDoNotMatchException extends Exception {}

    private static final String REQ_ID_LOCATOR_STRING = 'processing nrma request id ';
    
    
    public static  List<NRMA__c> parseResponseJSONByCallType(String callType, List<NRMA__c> nrmaList, String responseJSON) {
        if (callType == 'Request') {
            return parseResponseJSONForNewNRMA(nrmaList, responseJSON);
        } else {
            return parseResponseJSONForNRMAStatus(nrmaList, responseJSON); 
        }
    }//end method parseResponseJSONByCallType
    
    public static List<NRMA__c> parseResponseJSONForNewNRMA(List<NRMA__c> nrmaList, String responseJSON) {
        try {
            System.debug('(NRMAResponseHelper.parseResponseJSONForNewNRMA) responseJSON = ' + responseJSON);
            if (String.isBlank(responseJSON)) {
                throw new NullResponseJSONException('EXCEPTION! The ResponseJSON provided was NULL.  No parsing of New NRMA Request for NRMA__c could be performed.');
            }//end else NULL value for responseJSON or for nwcResponse.Id or for both
            if (responseJSON.startsWith('failed') && !responseJSON.contains('nrma request id')) {                
            	throw new FailedResponseException('EXCEPTION! ' + responseJSON);
            } 
            if (responseJSON.startsWith('failed') && responseJSON.contains('nrma request id')) {                
            	nrmaList = extractNRMARequestIdFromFailedAPIMsg(nrmaList, responseJSON);
            } else {
                NRMARequestsResponseWrap respWrap = NRMARequestsResponseWrap.parse(responseJSON);
                nrmaList = analyzeAndExtractForRequest(nrmaList, respWrap);
            }
        } catch(Exception jsonParseX) {
            System.debug('(NRMAResponseHelper.parseResponseJSONForNewNRMA) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }
        
        return nrmaList;
    }//end parseResponseJSONForNewNRMA

    public static List<NRMA__c> extractNRMARequestIdFromFailedAPIMsg(List<NRMA__c> nrmaList, String messageString) {
        //example: "failed processNRMARequest - processing nrma request id 1620849026641354752 - "
        try {
            System.debug('(NRMAResponseHelper.extractNRMARequestIdFromFailedAPIMsg) messageString = ' + messageString);
            Integer reqIdBgnIdx = messageString.indexOf(REQ_ID_LOCATOR_STRING);
            Integer reqIdEndIdx = messageString.indexOf(' - ', reqIdBgnIdx);
			String extractedNRMAReqId = messageString.substring((reqIdBgnIdx + REQ_ID_LOCATOR_STRING.length()), reqIdEndIdx);
            System.debug('(NRMAResponseHelper.extractNRMARequestIdFromFailedAPIMsg) extractedNRMAReqId = ' + extractedNRMAReqId);
			nrmaList.get(0).NRMA_Request_ID__c = extractedNRMAReqId;
        } catch(Exception msgParseX) {
            System.debug('(NRMAResponseHelper.extractNRMARequestIdFromFailedAPIMsg) EXCEPTION! \n' + msgParseX.getTypeName() + '\n' + msgParseX.getMessage() + '\n' + msgParseX.getLineNumber() + '\n' + msgParseX.getStackTraceString() + '\n Original Message String: \n' + messageString);
            throw msgParseX;
        }
        return nrmaList;
    }//end extractNRMARequestIdFromFailedAPIMsg
    
    public static Boolean doesRequestResponseMatchRequestRecord(List<NRMA__c> nrmaList, NRMARequestsResponseWrap respWrap) {
        return (nrmaList != null && nrmaList?.size() > 0 && nrmaList?.get(0) != null && respWrap != null &&
                respWrap.financialAnalysisID == nrmaList?.get(0).Associated_Brain_ID__c && 
                respWrap.opportunityTitle == nrmaList?.get(0).Opportunity_Title__c);
    }

    public static List<NRMA__c> analyzeAndExtractForRequest(List<NRMA__c> nrmaList, NRMARequestsResponseWrap respWrap) {
        if (NRMAResponseHelper.doesRequestResponseMatchRequestRecord(nrmaList, respWrap))  {
                nrmaList.get(0).NRMA_Request_ID__c = respWrap.id;
            	nrmaList.get(0).CET_Id__c = respWrap.cetId;
                nrmaList.get(0).City__c = respWrap.city;
                nrmaList.get(0).State__c = respWrap.stateCode;
                nrmaList.get(0).Escalated__c = respWrap.escalated;
                nrmaList.get(0).CUID__c = respWrap.submittedByCUID;
                nrmaList.get(0).Email_Address__c = respWrap.contactEmailAddress;
                nrmaList.get(0).Notification_Email_Addresses__c = respWrap.notificationEmails;
                nrmaList.get(0).Notes__c = respWrap.notes;
                nrmaList.get(0).High_Cost_Explanation__c = respWrap.highCostExplanation;
                nrmaList.get(0).Contract_Type__c = respWrap.contractType;
                nrmaList.get(0).Contract_Term_Months__c = respWrap.contractTermMonths;
                nrmaList.get(0).Wire_Center_Treatment__c = respWrap.wireCenterTreatment;
                nrmaList.get(0).Contract_Language__c = respWrap.contractLanguage;
                nrmaList.get(0).Early_Term_Liability__c = respWrap.earlyTermLiability;
                nrmaList.get(0).No_Agreement_Reason__c = respWrap.noAgreementReason;
                nrmaList.get(0).Product__c = respWrap.product;
                nrmaList.get(0).Developer_Name__c = respWrap.developerName;
                nrmaList.get(0).Consultant_Name__c = respWrap.consultantName;
                nrmaList.get(0).Open_Trench_Date__c = respWrap.openTrenchDate.date();
                nrmaList.get(0).Construction_Months__c = respWrap.constructionMonths;
                nrmaList.get(0).Greenfield_SFU_Count__c = respWrap.greenfieldSFUCount;
                nrmaList.get(0).Greenfield_MDU_Count__c = respWrap.greenfieldMDUCount;
                nrmaList.get(0).Brownfield_SFU_Count__c = respWrap.brownfieldSFUCount;
                nrmaList.get(0).Brownfield_MDU_Count__c = respWrap.brownfieldMDUCount;
                nrmaList.get(0).Door_Fee__c = respWrap.doorFeePerUnitUSDAvg;
                nrmaList.get(0).Bounty_Per_Unit__c = respWrap.bountyPerUnitUSDAvg;
                nrmaList.get(0).Service_Revenue_Shares__c = respWrap.serviceRevenueShares;
                nrmaList.get(0).Bulk_Price_Per_Unit_Average__c = respWrap.bulkPricePerUnitUSDAvg;
                nrmaList.get(0).Build_Project_CapEx_Total__c = respWrap.buildProjectCapExUSDTotal;
                nrmaList.get(0).Build_Direct_CapEx_Total__c = respWrap.buildDirectCapExUSDTotal;
                nrmaList.get(0).Build_Shared_CapEx_Total__c = respWrap.buildSharedCapExUSDTotal;
                nrmaList.get(0).Build_OpEx_Total__c = respWrap.buildOpExUSDTotal;
                nrmaList.get(0).Investment_Total__c = respWrap.investmentUSDTotal;
                nrmaList.get(0).Capital_Release_Requested_Amount__c = respWrap.capitalReleaseRequestedUSD;
                nrmaList.get(0).ATC_Total__c = respWrap.atcUSDTotal;
                nrmaList.get(0).Financial_Evaluation_Result_Code__c = respWrap.financialEvaluationResultCode;
                nrmaList.get(0).Financial_Evaluation_Message__c = respWrap.financialEvaluationDisplayMessage;
                nrmaList.get(0).Simple_Payback_Months__c = respWrap.simplePaybackMonths;
                nrmaList.get(0).Beginning_Penetration__c = respWrap.beginningPenetration;
                nrmaList.get(0).Ending_Penetration__c = respWrap.endingPenetration;
                nrmaList.get(0).Submission_Date_From_NRMA__c = respWrap.submissionDate;
                nrmaList.get(0).Finance_Workflow_ID__c = respWrap.financeWorkflowId;
                nrmaList.get(0).Offer_Management_Workflow_ID__c = respWrap.offerManagementWorkflowId;
                /****************************************************************************************************************
                 * The following is a placeholder for when supporting-documents can be appended and sent in the NRMA Request
                 * SupportingDocumeentURL[] supportingDocumentUrls;
                *****************************************************************************************************************/
        } else {
            NRMAResponseHelper.identifyAndLogExceptionsForRequest(nrmaList, respWrap);
        }//else nrmaList is NULL or size is 0 or 1st-element is NULL 
        return nrmaList;
    }//end method analyzeAndExtractForRequest

    public static List<NRMA__c> parseResponseJSONForNRMAStatus(List<NRMA__c> nrmaList, String responseJSON) {        
        try {
            if (String.isNotBlank(responseJSON)) {
                NRMAStatusResponseWrap respWrap = NRMAStatusResponseWrap.parse(responseJSON);
                nrmaList = analyzeAndExtractForStatus(nrmaList, respWrap);
            } else {
                throw new NullResponseJSONException('EXCEPTION! The ResponseJSON provided was NULL.  No parsing of New NRMA Request for NRMA__c could be performed.');
            }//end else NULL value for responseJSON or for nwcResponse.Id or for both
        } catch(Exception jsonParseX) {
            System.debug('(NRMAResponseHelper.parseResponseJSONForNRMAStatus) EXCEPTION! \n' + jsonParseX.getTypeName() + '\n' + jsonParseX.getMessage() + '\n' + jsonParseX.getLineNumber() + '\n' + jsonParseX.getStackTraceString());
            throw jsonParseX;
        }        
        return nrmaList;
    }//end parseResponseJSONForNRMAStatus    

    public static List<NRMA__c> analyzeAndExtractForStatus(List<NRMA__c> nrmaList, NRMAStatusResponseWrap respWrap) {
        if (nrmaList != null && nrmaList?.size() > 0 && nrmaList?.get(0) != null && nrmaList?.get(0).NRMA_Request_ID__c == respWrap.nrmaRequestId && respWrap != null) {
            nrmaList.get(0).Finance_Workflow_ID__c = respWrap.financeWorkflowId;
            nrmaList.get(0).Finance_Workflow_Status__c = respWrap.financeWorkflowStatus;
            nrmaList.get(0).Finance_Current_Phase_Begin_Time__c = respWrap.financeCurrentPhaseBeginTime;
            nrmaList.get(0).Offer_Management_Workflow_ID__c = respWrap.offerManagementWorkflowId;
            nrmaList.get(0).Offer_Management_Workflow_Status__c = respWrap.offerManagementWorkflowStatus;
            nrmaList.get(0).Offer_Management_Current_Phase_BeginTime__c = respWrap.offerManagementCurrentPhaseBeginTime;
        } else {
            NRMAResponseHelper.identifyAndLogExceptionsForStatus(nrmaList, respWrap);
        }//else nrmaList is NULL or size is 0 or 1st-element is NULL or 1st-element nrmaRequestId does not match up to with nrma-api request-id
        return nrmaList;
    }//end method analyzeAndExtractForStatus

    public static void identifyAndLogExceptionsForRequest(List<NRMA__c> nrmaList, NRMARequestsResponseWrap respWrap) {
        try {
            if (nrmaList == null) {
                throw new NullObjectException('EXCEPTION!  The list of NRMA objects was NULL and no details were added to the base JSON.');
            } else if (nrmaList?.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  The list of NRMA objects was EMPTY and no details were added to the base JSON.');
            } else if (nrmaList?.get(0) == null) {
                throw new NullObjectException('EXCEPTION!  The NRMA object provided in the record list was NULL and no details were added to the base JSON.');
            } else if (respWrap == null) {
                throw new NullObjectException('EXCEPTION! The NRMARequestsResponseWrap Object was NULL.  No parsing of New NRMA Request for NRMA__c could be performed.');
            } else {
                throw new ObjectsDoNotMatchException('EXCEPTION!  The NRMA object and the BRAIN-NRMA-API Request object do NOT match based on the following criteria: ' + 
                    '\n NRMA object ("BRAIN-ID": "' + nrmaList?.get(0).Associated_Brain_ID__c + '", "CET-ID": "' + ((String.isNotEmpty(nrmaList?.get(0).Offer_ID__c)) ? nrmaList?.get(0).Offer_ID__c : nrmaList?.get(0).Associated_Capital_Design__c) + '", ' + 
                    '"Property-ID": "' + nrmaList?.get(0).Associated_Property_ID__c + '", "Opportunity-Title": "' +  nrmaList?.get(0).Opportunity_Title__c + '") ' + 
                    '\n NRAM-API Request object ("BRAIN-ID": "' + respWrap.financialAnalysisID + '", "CET-ID": "' + respWrap.cetId + '", '  +
                    '"Property-ID": "' + respWrap.propertyId + '", "Opportunity-Title": "' + respWrap.opportunityTitle + '")');
            }//end else nrmaRequestId of each objects DO NOT match up
        } catch (Exception e) { 
            System.debug('(NRMAResponseHelper.identifyAndLogExceptionsForRequest) EXCEPTION! \n' + e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getLineNumber() + '\n' + e.getStackTraceString());
            throw e;
        }        
    }//end method identifyAndLogExceptionsForRequest

    public static void identifyAndLogExceptionsForStatus(List<NRMA__c> nrmaList, NRMAStatusResponseWrap respWrap) {
        try {
            if (nrmaList == null) {
                throw new NullObjectException('EXCEPTION!  The list of NRMA objects was NULL and no details were added to the base JSON.');
            } else if (nrmaList?.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  The list of NRMA objects was EMPTY and no details were added to the base JSON.');
            } else if (nrmaList?.get(0) == null) {
                throw new NullObjectException('EXCEPTION!  The NRMA object provided in the record list was NULL and no details were added to the base JSON.');
            } else if (respWrap == null) {
                throw new NullObjectException('EXCEPTION! The NRMAStatusResponseWrap Object was NULL.  No parsing of New NRMA Request for NRMA__c could be performed.');
            } else {
                throw new ObjectsDoNotMatchException('EXCEPTION!  The NRMA object Id and the BRAIN-NRMA-API Status object Id do NOT match.');
            }//end else nrmaRequestId of each objects DO NOT match up                        
        } catch (Exception e) { 
            System.debug('(NRMAResponseHelper.identifyAndLogExceptionsForStatus) EXCEPTION! \n' + e.getTypeName() + '\n' + e.getMessage() + '\n' + e.getLineNumber() + '\n' + e.getStackTraceString());
            throw e;
        }        
    }//end method identifyAndLogExceptionsForStatus

    @AuraEnabled
    public static List<NRMA__c> updateNRMAList(List<NRMA__c> nrmaList) {		
        
        try {
            if (nrmaList != null && nrmaList.size() > 0 && NRMA__c.SObjectType.getDescribe().isUpdateable() == true) {
                update nrmaList;
                System.debug('List of NRMA__c records were updated -->' + nrmaList.size());
            } else {
                if (NRMA__c.SObjectType.getDescribe().isUpdateable() == false) {
                    throw new DmlException('No permissions to update.');
                } else {
                    throw new NullObjectException('EXCEPTION!  The List of NRMA__c objects was NULL or was empty.  No update was possible.');       
                }
            }
        } catch(Exception methodX) {
            System.debug('(NRMAResponseHelper.updateNRMAList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
        return nrmaList;
    }//end method updateNRMAList

}//end class NRMAResponseHelper