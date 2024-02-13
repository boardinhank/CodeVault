/***************************************************************************************************
 * Name:  NRMARequestHelper
 * Platform: Salesforce Connected Journey (SFCJ)
 * Helper class for Request portion of BRAIN/NRMA Approval-Tool interaction between SFCJ and BRAIN API
 * Code Coverage:  TestNRMARequestHelper -- 88%  01/04/2023
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 01/04/2023  	T2Cabato    Feature(Epic) ESCJ-3932	        Base version
****************************************************************************************************/
public with sharing class NRMARequestHelper {
    public class ZeroListException extends Exception {}
    public class NullCallAfterBuildException extends Exception {}
    public class NullObjectException extends Exception {}

    @AuraEnabled
    public static List<NRMA__c> queryNRMARecordListById(Id recordId) {
        List<NRMA__c> nrmaList = new List<NRMA__c>();
        try {
            nrmaList = [SELECT  Id, Name, 
                                Approval_Results_Source__c,
                                Associated_Brain_ID__c,
                                ATC_Total__c,
                                Beginning_Penetration__c,
                                Bounty_Per_Unit__c,
                                Brownfield_MDU_Count__c,
                                Brownfield_SFU_Count__c,
                                Build_Direct_CapEx_Total__c,
                                Build_OpEx_Total__c,
                                Build_Project_CapEx_Total__c,
                                Build_Shared_CapEx_Total__c,
                                Bulk_Price_Per_Unit_Average__c,
                                Associated_Capital_Design__c,
                                Capital_Release_Requested_Amount__c,
                        		CET_Id__c,
                                City__c,
                                Construction_Months__c,
                                Consultant_Name__c,
                                Email_Address__c,
                                Contract_Language__c,
                                Contract_Term_Months__c,
                                Contract_Type__c,
                                CreatedById,
                                Developer_Name__c,
                                Door_Fee__c,
                                Early_Term_Liability__c,
                                Ending_Penetration__c,
                                Escalated__c,
                                Finance_Current_Phase_Begin_Time__c,
                                Finance_Workflow_Completed_Time__c,
                                Finance_Workflow_ID__c,
                                Finance_Workflow_Status__c,
                                Financial_Evaluation_Message__c,
                                Financial_Evaluation_Result_Code__c,
                                Greenfield_MDU_Count__c,
                                Greenfield_SFU_Count__c,
                                High_Cost_Explanation__c,
                                Investment_Total__c,
                                LastModifiedById,
                                Name__c,
                                No_Agreement_Reason__c,
                                Notes__c,
                                Notification_Email_Addresses__c,
                                Approval_Date__c,
                                Approval_ID__c,
                                NRMA_Request_ID__c,
                                NRMA_Status__c,
                                Offer_ID__c,
                                Offer_Management_Current_Phase_BeginTime__c,
                                Offer_Management_Workflow_Completed_Time__c,
                                Offer_Management_Workflow_ID__c,
                                Offer_Management_Workflow_Status__c,
                                Open_Trench_Date__c,
                                Opportunity__c,
                                Opportunity_Title__c,
                        		Other_Provider_Contract_Type__c,
                                OwnerId,
                                Product__c,
                                Associated_Property_ID__c,
                                Provided_Time__c,
                                RecordTypeId,
                                Result_Notes__c,
                                Results__c,
                                Service_Revenue_Shares__c,
                                showApprovalToolResults__c,
                                showApprovalToolStatus__c,
                                Simple_Payback_Months__c,
                                State__c,
                                Submission_Date_From_NRMA__c,
                                CUID__c,
                                Supporting_Document_URLs__c,
                                URL__c,
                                Wire_Center_Treatment__c
                          FROM  NRMA__c
                         WHERE  Id = :recordId WITH SECURITY_ENFORCED LIMIT 1];
            if(nrmaList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of NRMA objects with Id "' + recordId + '" returned 0 records.');
            }
	        return nrmaList;
        } catch(Exception queryX) {
            System.debug('(NRMARequestHelper.queryNRMARecordListById) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryNRMARecordListById
    
    @AuraEnabled
    public static List<Capital_Design__c> queryCapDesignListById(String capitalDesignId) {
        List<Capital_Design__c> capDesignList = new List<Capital_Design__c>();
        try {
            capDesignList = [SELECT Id, Name, OwnerId, Offer__c, Capital_Design_Stage__c,
                                        BRAIN_API_Call_Tracker_Master__c, 
                                        Brain_ID__c,
                                        CapEx_Direct__c,
     									Cumulative_NPV__c,
                                        Discounted_Payback_months__c,
                                        EBITDA_Margin__c,
                                        Financial_Viability__c,
                                        IRR__c,
                                        Incremental_ATC_To_Meet_Guardrail__c,
                                        Simple_Payback_Months__c,
                                        X1st_Year_of_Positive_EBITDA__c,
                                        X1st_Year_of_Positive_FCF__c,
										Offer__r.Offer_Total_Units__c, 
                                        Offer__r.Offer_Type__c, Offer__r.Contract_Term__c,
                                        Offer__r.Data_Bounty_Amount_Approved__c, 
                                        Offer__r.Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                        Offer__r.Requested_Bulk_Data_Price_Approved__c,
                                        Offer__r.Opportunity__r.Id, 
                                        Offer__r.Contract__r.EndDate,
                                        Offer__r.Revenue_Share_Agent_Commission_Rate__c,
                                        Offer__r.Revenue_Share_MIN_Penetration_Rate__c,
                                        Offer__r.Revenue_Share_MAX_Penetration_Rate__c,
                                        Actual_Build_Out_Months__c,
                                        Core_Switch_Electronics__c,
                                        Transport_Interoffice_Fiber__c,
                                        CO_Electronics__c,
                                        Feeder_F1_Access_and_or_PON__c,
                                        Remote_Electronics__c,
                                        Total_Cottage_Rental_Units__c, 
                                        Total_Tower_Rental_Units__c, 
                                        Total_SFH_Rental_Units__c,
                                        Total_Cottage_Owner_Units__c, 
                                        Total_Tower_Owner_Units__c, 
                                        Total_SFH_Owner_Units__c, 
                                        Service_Delivery__c, 
                                        Distribution_F2__c, 
                                        F2_Footage_ft__c,
                                        Distribution_Structure_Conduit__c,
                                        F4_Inside_Wiring_SFH__c,
                                        Other_MDU_F4__c,
                                        for_SFU_Average_Lot_Size__c, 
                                        Network_Investment__c, 
                                        Technology_Type__c, 
                                        Service_Type__c,                     
                                        MDU_ONT_Drop__c,
                                        Door_Fee__c,
                                        Access_Type__c,
                                        F1_Feeder_Type__c,
                                        Cluster_ID__c,
                                        Occupant_Type__c,
                                        //The NMA-specific fields are listed together below 
                                        Capital_Design_Type__c,
                                        Property_Name__c,
                                        Product__c,
                                        Planned_Build_Out_Years__c,
                                        Wire_Center_CLLI_Code__c,
                                        Latitude_NM__c,
                                        Longitude_NM__c,
                                        Service_Delivery_NM__c,
                                        Max_Downstream_Speed_NM__c,
                                        Total_Cottage_Rental_Units_NM__c, 
                                        Total_Tower_Rental_Units_NM__c, 
                                        Total_SFH_Rental_Units_NM__c,
                                        Total_Cottage_Owner_Units_NM__c, 
                                        Total_Tower_Owner_Units_NM__c, 
                                        Total_SFH_Owner_Units_NM__c                  
                                   FROM Capital_Design__c
                                  WHERE Id = :capitalDesignId WITH SECURITY_ENFORCED LIMIT 1];
            if(capDesignList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Capital-Design objects with Id "' + capitalDesignId + '" returned 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(NRMARequestHelper.queryCapDesignListById) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        
        return capDesignList;
    }//end method queryCapDesignListById

    public static String constructJSONFromNRMAObj(List<NRMA__c> nrmaList) {
        List<String> jsonList = new List<String>(); 
        String constructedJSON = null;
        
        try {
            if (nrmaList == null) {
                throw new NullObjectException('EXCEPTION!  The list of NRMA objects was NULL and no details were added to the base JSON.');
            } 
            if (nrmaList?.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  The list of NRMA objects was EMPTY and no details were added to the base JSON.');
            }
            if (nrmaList?.get(0) == null) {
                throw new NullObjectException('EXCEPTION!  The NRMA object provided in the record list was NULL and no details were added to the base JSON.');
            }            
            jsonList.add('{ "id": null');
			jsonList = constructJSONInitialSection(nrmaList, jsonList);
			jsonList = constructJSONRequiredSection(nrmaList, jsonList);
			jsonList = constructJSONTextualSection(nrmaList, jsonList);            
            jsonList = constructJSONContractSection(nrmaList, jsonList);
            
            jsonList.add( (String.isEmpty(nrmaList?.get(0).Wire_Center_Treatment__c) ? '' : ', "wireCenterTreatment": "' + nrmaList?.get(0).Wire_Center_Treatment__c + '"') );
            jsonList.add( (String.isEmpty(nrmaList?.get(0).Product__c) ? '' : ', "product": "' + nrmaList?.get(0).Product__c + '"') );

            jsonList = constructJSONOpenTrenchDate(nrmaList, jsonList);
            jsonList = constructJSONCountSection(nrmaList, jsonList);
			jsonList = constructJSONDecimalSection(nrmaList, jsonList);
            
            jsonList.add( (String.isEmpty(nrmaList?.get(0).Financial_Evaluation_Result_Code__c) ? '' : ', "financialEvaluationResultCode": "' + nrmaList?.get(0).Financial_Evaluation_Result_Code__c + '"') );
            jsonList.add( (String.isEmpty(nrmaList?.get(0).Financial_Evaluation_Message__c) ? '' : ', "financialEvaluationDisplayMessage": "' + nrmaList?.get(0).Financial_Evaluation_Message__c + '"') );
            jsonList.add( (String.isEmpty(nrmaList?.get(0).Supporting_Document_URLs__c) ? '' : ', "supportingDocumentUrls": ' + nrmaList?.get(0).Supporting_Document_URLs__c + '"') );

            jsonList.add(' }');

            constructedJSON = String.join(jsonList, '');
            String jsonFormattedForOutput = constructedJSON.replaceAll(', ', ',\n ');
            System.debug('(NRMARequestHelper.constructJSONFromNRMAObj) jsonFormattedForOutput: \n' + jsonFormattedForOutput);
			return constructedJSON;        
        } catch(Exception constructX) {
            constructedJSON = '{ }';
            System.debug('(NRMARequestHelper.constructJSONFromNRMAObj) EXCEPTION! \n Type: ' + constructX.getTypeName() + '\n Message:  ' + constructX.getMessage() + '\n Line#: ' + constructX.getLineNumber() + '\n StackTrace:  ' + constructX.getStackTraceString());           
            throw constructX;
        }
    }//end method constructJSONFromNRMAObj

    private static List<String> constructJSONInitialSection(List<NRMA__c> nrmaList, List<String> jsonList) {
        jsonList.add(', "financialAnalysisID": "' + nrmaList?.get(0).Associated_Brain_ID__c + '"');
        jsonList.add(', "cetId": ' + ((String.isNotEmpty(nrmaList?.get(0).CET_Id__c)) ? '"' + nrmaList?.get(0).CET_Id__c + '"' : (String.isNotEmpty(nrmaList?.get(0).Offer_ID__c)) ? '"' + nrmaList?.get(0).Offer_ID__c + '"' : (String.isNotEmpty(nrmaList?.get(0).Associated_Capital_Design__c)) ? '"' + nrmaList?.get(0).Associated_Capital_Design__c + '"' : 'null'));
        jsonList.add( (String.isEmpty(nrmaList?.get(0).Associated_Property_ID__c) ? '' : ', "propertyId": "' + nrmaList?.get(0).Associated_Property_ID__c + '"') );
        jsonList.add( (String.isEmpty(nrmaList?.get(0).City__c) ? '' : ', "city": "' + nrmaList?.get(0).City__c + '"') );
        jsonList.add( (String.isEmpty(nrmaList?.get(0).State__c) ? '' : ', "stateCode": "' + nrmaList?.get(0).State__c + '"') );
        jsonList.add( (String.isEmpty(nrmaList?.get(0).Opportunity_Title__c) ? '' : ', "opportunityTitle": "' + nrmaList?.get(0).Opportunity_Title__c + '"') );
        return jsonList;
    }//end method constructJSONInitialSection

    private static List<String> constructJSONContractSection(List<NRMA__c> nrmaList, List<String> jsonList) {
        jsonList.add( (String.isEmpty(nrmaList?.get(0).Contract_Type__c) ? '' : ', "contractType": "' + nrmaList?.get(0).Contract_Type__c + '"') );
        jsonList.add( (String.isEmpty(nrmaList?.get(0).Contract_Term_Months__c) ? '' : ', "contractTermMonths": "' + nrmaList?.get(0).Contract_Term_Months__c + '"') );
        jsonList.add( (String.isEmpty(nrmaList?.get(0).Other_Provider_Contract_Type__c) ? '' : ', "otherProviderContractType": "' + nrmaList?.get(0).Other_Provider_Contract_Type__c + '"') );
        jsonList.add( (String.isEmpty(nrmaList?.get(0).No_Agreement_Reason__c) ? '' : ', "noAgreementReason": ' +  '"' + nrmaList?.get(0).No_Agreement_Reason__c + '"') );
        return jsonList;
    }//end method constructJSONContractSection
    
    private static List<String> constructJSONTextualSection(List<NRMA__c> nrmaList, List<String> jsonList) {
        jsonList.add( (String.isEmpty(nrmaList?.get(0).Notes__c) ? '' : ', "notes": "' + nrmaList?.get(0).Notes__c + '"') );
        jsonList.add( (String.isEmpty(nrmaList?.get(0).High_Cost_Explanation__c) ? '' : ', "highCostExplanation": "' + nrmaList?.get(0).High_Cost_Explanation__c + '"') );
        return jsonList;
    }//end method constructJSONTextualSection

    private static List<String> constructJSONRequiredSection(List<NRMA__c> nrmaList, List<String> jsonList) {
        jsonList.add(', "escalated": ' + nrmaList?.get(0).Escalated__c);
        jsonList.add(', "submittedByCUID": ' + (String.isNotEmpty(nrmaList?.get(0).CUID__c) ? '"' + nrmaList?.get(0).CUID__c + '"' : 'null') );
        jsonList.add(', "contactEmailAddress": ' + (String.isNotEmpty(nrmaList?.get(0).Email_Address__c) ? '"' + nrmaList?.get(0).Email_Address__c + '"' : 'null') );
        jsonList.add( (String.isEmpty(nrmaList?.get(0).Notification_Email_Addresses__c) ? '' : ', "notificationEmails": "' + nrmaList?.get(0).Notification_Email_Addresses__c + '"') );
        jsonList.add(', "contractLanguage": ' + (String.isNotEmpty(nrmaList?.get(0).Contract_Language__c) ? '"' + nrmaList?.get(0).Contract_Language__c + '"' : 'null') );
        jsonList.add(', "earlyTermLiability": ' + (String.isNotEmpty(nrmaList?.get(0).Early_Term_Liability__c) ? '"' + nrmaList?.get(0).Early_Term_Liability__c + '"' : 'null') );
        jsonList.add(', "developerName": ' + (String.isNotEmpty(nrmaList?.get(0).Developer_Name__c) ? '"' + nrmaList?.get(0).Developer_Name__c + '"' : 'null') );
        jsonList.add( (String.isEmpty(nrmaList?.get(0).Consultant_Name__c) ? '' : ', "consultantName": "' + nrmaList?.get(0).Consultant_Name__c + '"') );
        return jsonList;
    }//end method constructJSONRequiredSection
    
    private static List<String> constructJSONCountSection(List<NRMA__c> nrmaList, List<String> jsonList) {
        jsonList.add( (nrmaList?.get(0).Construction_Months__c == null ? '' : ', "constructionMonths": ' + (nrmaList?.get(0).Construction_Months__c.round()).intValue() + '') );
        jsonList.add( (nrmaList?.get(0).Greenfield_SFU_Count__c == null ? '' : ', "greenfieldSFUCount": ' + nrmaList?.get(0).Greenfield_SFU_Count__c + '') );
        jsonList.add( (nrmaList?.get(0).Greenfield_MDU_Count__c == null ? '' : ', "greenfieldMDUCount": ' + nrmaList?.get(0).Greenfield_MDU_Count__c + '') );
        jsonList.add( (nrmaList?.get(0).Brownfield_SFU_Count__c == null ? '' : ', "brownfieldSFUCount": ' + nrmaList?.get(0).Brownfield_SFU_Count__c + '') );
        jsonList.add( (nrmaList?.get(0).Brownfield_MDU_Count__c == null ? '' : ', "brownfieldMDUCount": ' + nrmaList?.get(0).Brownfield_MDU_Count__c + '') );
        return jsonList;
    }//end method constructJSONDateAndCountSection

    private static List<String> constructJSONOpenTrenchDate(List<NRMA__c> nrmaList, List<String> jsonList) {
        /***********************************************************************************************************************
         * 
         *
         *         if (nrmaList?.get(0).Open_Trench_Date__c != null) {
         *             String convertedString = null;
         *             Integer cDay = nrmaList?.get(0).Open_Trench_Date__c.day();
         *             Integer cMonth = nrmaList?.get(0).Open_Trench_Date__c.month();
         *             Integer cYear = nrmaList?.get(0).Open_Trench_Date__c.year();
         *             DateTime cDT = DateTime.newInstance(cYear, cMonth, cDay);
         *             convertedString = cDT.format('yyyy-MM-dd hh:mm:ss X');
         *             System.debug('(NRMARequestHelper.convertDateToDateTimeString) convertedString using format = ' + convertedString);
         *             convertedString = convertedString.replaceFirst(' ', 'T');
         *             convertedString = convertedString.replace(' -', 'Z');
         *             convertedString += ':00';
         *             System.debug('(NRMARequestHelper.convertDateToDateTimeString) convertedString post-replace = ' + convertedString);
         *             jsonList.add('');
         *          }
         *************************************************************************************************************************/
		return jsonList;
    }//end method constructJSONOpenTrenchDate
    
    private static List<String> constructJSONDecimalSection(List<NRMA__c> nrmaList, List<String> jsonList) {
        jsonList.add( (nrmaList?.get(0).Door_Fee__c == null ? '' : ', "doorFeePerUnitUSDAvg": ' + nrmaList?.get(0).Door_Fee__c + '') );
        jsonList.add( (nrmaList?.get(0).Bounty_Per_Unit__c == null ? '' : ', "bountyPerUnitUSDAvg": ' + nrmaList?.get(0).Bounty_Per_Unit__c + '') );
        jsonList.add( (nrmaList?.get(0).Service_Revenue_Shares__c == null ? '' : ', "serviceRevenueShares": "' + nrmaList?.get(0).Service_Revenue_Shares__c + '"') );
        jsonList.add( (nrmaList?.get(0).Bulk_Price_Per_Unit_Average__c == null ? '' : ', "buikPricePerUnitUSDAvg": ' + nrmaList?.get(0).Bulk_Price_Per_Unit_Average__c + '') );
        jsonList.add( (nrmaList?.get(0).Build_Project_CapEx_Total__c == null ? '' : ', "buildProjectCapExUSDTotal": ' + nrmaList?.get(0).Build_Project_CapEx_Total__c + '') );
        jsonList.add( (nrmaList?.get(0).Build_Direct_CapEx_Total__c == null ? '' : ', "buildDirectCapExUSDTotal": ' + nrmaList?.get(0).Build_Direct_CapEx_Total__c + '') );
        jsonList.add( (nrmaList?.get(0).Build_Shared_CapEx_Total__c == null ? '' : ', "buildSharedCapExUSDTotal": ' + nrmaList?.get(0).Build_Shared_CapEx_Total__c + '') );
        jsonList.add( (nrmaList?.get(0).Build_OpEx_Total__c == null ? '' : ', "buildOpExUSDTotal": ' + nrmaList?.get(0).Build_OpEx_Total__c + '') );
        jsonList.add( (nrmaList?.get(0).Investment_Total__c == null ? '' : ', "investmentUSDTotal": ' + nrmaList?.get(0).Investment_Total__c + '') );
        jsonList.add( (nrmaList?.get(0).Capital_Release_Requested_Amount__c == null ? '' : ', "capitalReleaseRequestedUSD": ' + nrmaList?.get(0).Capital_Release_Requested_Amount__c + '') );
        jsonList.add( (nrmaList?.get(0).ATC_Total__c == null ? '' : ', "atcUSDTotal": ' + nrmaList?.get(0).ATC_Total__c + '') );
        jsonList.add( (nrmaList?.get(0).Simple_Payback_Months__c == null ? '' : ', "simplePaybackMonths": "' + nrmaList?.get(0).Simple_Payback_Months__c + '"') );
        jsonList.add( (nrmaList?.get(0).Beginning_Penetration__c == null ? '' : ', "beginningPenetration": ' + nrmaList?.get(0).Beginning_Penetration__c + '') );
        jsonList.add( (nrmaList?.get(0).Ending_Penetration__c == null ? '' : ', "endingPenetration": ' + nrmaList?.get(0).Ending_Penetration__c + '') );
		return jsonList;
    }//end method constructJSONDecimalSection
}//end class NRMARequestHelper