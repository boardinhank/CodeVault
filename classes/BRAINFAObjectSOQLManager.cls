/***************************************************************************************************
 * Name:  BRAINFAObjectSOQLManager
 * Platform: Salesforce Connected Journey (SFCJ)
 * Manager class for SOQL and DML on objects of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFAObjectSOQLManager
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 01/31/2023  	T2Cabato    ESCJ-2365	        			Base version derived from BRAINFAObjectSOQLManager
 * 06/13/2023   T2Cabato    QFCJ-3801                       BRAIN-AutoSubmit-Messaging
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
 * 08/02/2023   T2Cabato    QFCJ-4286                       BRAIN-Drop-Cost-Fix                   
 * 08/15/2023   T2Cabato    QFCJ-4282                       BRAIN-ONT-Model-Mapping
 * 08/15/2023   T2Cabato    QFCJ-4297                       BRAIN-UPS-Shelf-to-idfElectronics-for-BRAIN
 * 08/15/2023   T2Cabato    QFCJ-4309                       BRAIN-ContractType-and-OtherProviderContractType-Mapping
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Product-to-TechType-Mapping
 * 09/28/2023   T2Cabato    QFCJ-4625/26/27/28              BRAIN-Financial-Analysis-Failures
 * 11/06/2023   T2Cabato    QFCJ-4706                       BRAIN-Error-for-F1-and-F2-Footage-value-being-ZERO
 * 01/08/2024   T2Cabato    QFCJ-4807                		BRAIN-Incorrect-Setting-of-baseContractType-Value
****************************************************************************************************/
public with sharing class BRAINFAObjectSOQLManager { 
    private class ZeroListException extends Exception {}
    private class NullObjectException extends Exception {}
    private class NonMarketingOpptyException extends Exception {}
    private static final String RETURNED_0_RECS = ' returned 0 records.';

    @AuraEnabled
    public static List<Capital_Design__c> queryBaseCallCapDesignListByName(String capitalDesignName) {
        try {
            System.debug('(BRAINFAObjectSOQLManager.queryBaseCallCapDesignListByName) capitalDesignName = ' + capitalDesignName);
            List<Capital_Design__c> baseCapDesignList = [SELECT Id, Name, OwnerId, Opportunity__c,
                                                                 Capital_Design_Type__c, BRAIN_ID__c,
                                                                 BRAIN_API_Call_Tracker_Master__c, 
                                                                 Last_Associated_BRAIN_FA_Call__c,
                                    							 Last_BRAIN_Automation_Fault__c
	                                                        FROM Capital_Design__c
    	                                                   WHERE Name = :capitalDesignName LIMIT 1];
            if(baseCapDesignList?.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Capital-Design objects named "' + capitalDesignName + '"' + RETURNED_0_RECS);
            }
            return baseCapDesignList;
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryBaseCallCapDesignListByName) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryBaseCallCapDesignListByName

    @AuraEnabled
    public static List<Capital_Design__c> queryBaseCallCapDesignListById(String capitalDesignId) {
        try {
            List<Capital_Design__c> baseCapDesignList = [SELECT Id, Name, OwnerId, Opportunity__c,
                                                                 Capital_Design_Type__c, BRAIN_ID__c,
                                                                 BRAIN_API_Call_Tracker_Master__c, 
                                                                 Last_Associated_BRAIN_FA_Call__c,
								                                 Last_BRAIN_Automation_Fault__c
                                                            FROM Capital_Design__c
                                                           WHERE Id = :capitalDesignId LIMIT 1];
            if(baseCapDesignList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Capital-Design objects with Id "' + capitalDesignId + '"' + RETURNED_0_RECS);
            }
            return baseCapDesignList;
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryBaseCallCapDesignListById) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }        
    }//end method queryBaseCallCapDesignListById

    @AuraEnabled
    public static List<Opportunity> queryAssociatedOpptyList(String opportunityId) {
        try {
            List<Opportunity> associatedOpptyList = [SELECT  id,
                                                           Name, 
                                                           OwnerId,
                                                           Sole_Provider__c,                                   
                                                           Property__r.Id, 
                                                           Property__r.Name, 
                                                           Property__r.Latitude__c,
                                                           Property__r.Longitude__c,
                                                           Property__r.Max_Bandwidth_Available__c,
                                                           Property__r.Network_Wire_Center_Name_Text__c
                                                      FROM Opportunity WHERE Id = :opportunityId LIMIT 1];            
            if(associatedOpptyList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Associated Opportunities for Opportunity with Id "' + opportunityId + '"' + RETURNED_0_RECS);
            }//end if associatedOpptyList.size is 0
            return associatedOpptyList;
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryAssociatedOpptyList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryAssociatedOpptyList 

    @AuraEnabled
    public static List<Offer__c> queryBaseCallOfferList(String capitalDesignName, String offerId) {
        try {
            List<Offer__c> offerList =     [SELECT Id, Name, OwnerId, Offer_Status__c, Associated_Capital_Design__r.Id
                               FROM Offer__c WHERE Id = :offerId AND Associated_Capital_Design__r.Name = :capitalDesignName LIMIT 1];
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offers with Id "' + offerId + '" AND associated to Capital-Design named "' + capitalDesignName + '"' + RETURNED_0_RECS);
            }
            return offerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryBaseCallOfferList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Offer__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryBaseCallOfferList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryBaseCallOfferList
    
    @AuraEnabled
    public static List<Offer__c> queryOfferListById(String offerId) {
        try {
            List<Offer__c> offerList = [SELECT Id, Name, OwnerId, Offer_Total_Units__c, 
                                    Offer_Type__c, Offer_Status__c,                                    
                                    Other_Provider_Contract_Type__c,
                                    Contract_Term__c,
                                    Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Id, 
                                    Opportunity__r.Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Sole_Provider__c,     
                                    Bulk_Data_Type__c,
                                    Data_Bounty_Amount__c, 
                                    Bulk_Data_Speed_Profile_DL_UL__c,
                                    Requested_Bulk_Data_Price__c,
                                    Prepaid_Marketing_Fee_Per_Unit__c,
                                    Flat_Revenue_Share__c,
				                    Bulk_Data_Type_Approved__c,
                                    Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                    Data_Bounty_Amount_Approved__c, 
                                    Requested_Bulk_Data_Price_Approved__c,
                                    Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                    Flat_Revenue_Share_Approved__c,
                                    Contract__r.EndDate,
                                    Revenue_Share_Agent_Commission_Rate__c,
                                    Revenue_Share_MIN_Penetration_Rate__c,
                                    Revenue_Share_MAX_Penetration_Rate__c,
                                    Capital_Summation__c, 
                                    Expense_Summation__c,
                                    Capital_Summation_Offer__c, 
                                    Expense_Summation_Offer__c,
                                    Brain_ID__c,
                                    Brain_ID_Offer__c,
                                    BRAIN_API_Call_Tracker_Master__c,
                                    Associated_Capital_Design__c,
                                    Associated_Capital_Design__r.Name,
                                    Associated_Capital_Design__r.OwnerId,
                                    Associated_Capital_Design__r.Capital_Design_Stage__c,
                                    Associated_Capital_Design__r.Capital_Design_Type__c,
                                    Associated_Capital_Design__r.Actual_Build_Out_Months__c,
                         			Associated_Capital_Design__r.Core_Switch_Electronics__c,
                         			Associated_Capital_Design__r.Transport_Interoffice_Fiber__c,
                                    Associated_Capital_Design__r.CO_Electronics__c,
                                    Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c,
                         			Associated_Capital_Design__r.Remote_Electronics__c,
                                    Associated_Capital_Design__r.Total_Cottage_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Rental_Units__c,
                                    Associated_Capital_Design__r.Total_Cottage_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Owner_Units__c, 
                                    Associated_Capital_Design__r.Service_Delivery__c, 
                         			Associated_Capital_Design__r.Distribution_F2__c, 
									Associated_Capital_Design__r.F1_Footage_ft__c,
                                    Associated_Capital_Design__r.F2_Footage_ft__c,
                         			Associated_Capital_Design__r.Distribution_Structure_Conduit__c,
                                    Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c,
                         			Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c,
                         			Associated_Capital_Design__r.Other_MDU_F4__c, 
                                    Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Total_Cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.Capital_Summation__c, 
                                    Associated_Capital_Design__r.Expense_Summation__c,
                                    Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c, 
                                    Associated_Capital_Design__r.Network_Investment__c, 
                                    Associated_Capital_Design__r.Technology_Type__c, 
                                    Associated_Capital_Design__r.Service_Type__c,                     
                         			Associated_Capital_Design__r.MDU_ONT_Drop__c,
                         			Associated_Capital_Design__r.Access_Type__c,
                         			Associated_Capital_Design__r.F1_Feeder_Type__c,
                                    Associated_Capital_Design__r.Cluster_ID__c,
                                    Associated_Capital_Design__r.Cluster_Not_Available__c,
                                    Associated_Capital_Design__r.Number_of_missing_units__c,
                                    Associated_Capital_Design__r.Development_Status__c,
                                    Associated_Capital_Design__r.Building_Style__c,
                                    Associated_Capital_Design__r.ONT_Model__c,
                         			Associated_Capital_Design__r.Occupant_Type__c,
                                    Associated_Capital_Design__r.Access_Cost__c,
                                    Associated_Capital_Design__r.IP_CapEx_Shared__c,
                                    Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c,
                                    Associated_Capital_Design__r.Wireless_Access_Points_Cost__c,
                                    Associated_Capital_Design__r.BCET_Wire_Center__c,
                                    Associated_Capital_Design__r.One_Time_Additional_Expense__c,
                                    Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c,
                                    Associated_Capital_Design__r.BRAIN_API_Call_Tracker_Master__c, 
                                    Associated_Capital_Design__r.Last_Associated_BRAIN_FA_Call__c,
                                    Associated_Capital_Design__r.Brain_ID__c,
                                    Associated_Capital_Design__r.Last_BRAIN_Automation_Fault__c,
                                    Associated_Capital_Design__r.QueuedForBRAINFARun__c
                            FROM Offer__c WHERE Id = :offerId LIMIT 1];
            
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offers with Id "' + offerId + '"' + RETURNED_0_RECS);
            }
	        return offerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListById) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Offer__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListById) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryOfferListById
        
    @AuraEnabled
    public static List<Offer__c> queryOfferListByIdForAssociatedCD(String offerId, String capitalDesignName) {
        try {
            List<Offer__c> offerList = [SELECT Id, Name, OwnerId, Offer_Total_Units__c, 
                                    Offer_Type__c, Offer_Status__c,                                    
                                    Other_Provider_Contract_Type__c,
                                    Contract_Term__c,
                                    Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Id, 
                                    Opportunity__r.Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Sole_Provider__c,     
                                    Bulk_Data_Type__c,
                                    Data_Bounty_Amount__c, 
                                    Bulk_Data_Speed_Profile_DL_UL__c,
                                    Requested_Bulk_Data_Price__c,
                                    Prepaid_Marketing_Fee_Per_Unit__c,
                                    Flat_Revenue_Share__c,
				                    Bulk_Data_Type_Approved__c,
                                    Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                    Data_Bounty_Amount_Approved__c, 
                                    Requested_Bulk_Data_Price_Approved__c,
                                    Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                    Flat_Revenue_Share_Approved__c,
                                    Contract__r.EndDate,
                                    Revenue_Share_Agent_Commission_Rate__c,
                                    Revenue_Share_MIN_Penetration_Rate__c,
                                    Revenue_Share_MAX_Penetration_Rate__c,
                                    Capital_Summation__c, 
                                    Expense_Summation__c,
                                    Capital_Summation_Offer__c, 
                                    Expense_Summation_Offer__c,
                                    Brain_ID__c,
                                    Brain_ID_Offer__c,
                                    BRAIN_API_Call_Tracker_Master__c,
                                    Associated_Capital_Design__c,
                                    Associated_Capital_Design__r.Name,
                                    Associated_Capital_Design__r.OwnerId,
                                    Associated_Capital_Design__r.Capital_Design_Stage__c,
                                    Associated_Capital_Design__r.Capital_Design_Type__c,
                                    Associated_Capital_Design__r.Actual_Build_Out_Months__c,
                         			Associated_Capital_Design__r.Core_Switch_Electronics__c,
                         			Associated_Capital_Design__r.Transport_Interoffice_Fiber__c,
                                    Associated_Capital_Design__r.CO_Electronics__c,
                                    Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c,
                         			Associated_Capital_Design__r.Remote_Electronics__c,
                                    Associated_Capital_Design__r.Total_Cottage_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Rental_Units__c,
                                    Associated_Capital_Design__r.Total_Cottage_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Owner_Units__c, 
                                    Associated_Capital_Design__r.Service_Delivery__c, 
                         			Associated_Capital_Design__r.Distribution_F2__c, 
									Associated_Capital_Design__r.F1_Footage_ft__c,
                                    Associated_Capital_Design__r.F2_Footage_ft__c,
                         			Associated_Capital_Design__r.Distribution_Structure_Conduit__c,
                                    Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c,
                         			Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c,
                         			Associated_Capital_Design__r.Other_MDU_F4__c, 
                                    Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Total_Cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.Capital_Summation__c, 
                                    Associated_Capital_Design__r.Expense_Summation__c,
                                    Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c, 
                                    Associated_Capital_Design__r.Network_Investment__c, 
                                    Associated_Capital_Design__r.Technology_Type__c, 
                                    Associated_Capital_Design__r.Service_Type__c,                     
                         			Associated_Capital_Design__r.MDU_ONT_Drop__c,
                         			Associated_Capital_Design__r.Access_Type__c,
                         			Associated_Capital_Design__r.F1_Feeder_Type__c,
                                    Associated_Capital_Design__r.Cluster_ID__c,
                                    Associated_Capital_Design__r.Cluster_Not_Available__c,
                                    Associated_Capital_Design__r.Number_of_missing_units__c,
                                    Associated_Capital_Design__r.Development_Status__c,
                                    Associated_Capital_Design__r.Building_Style__c,
                                    Associated_Capital_Design__r.ONT_Model__c,
                         			Associated_Capital_Design__r.Occupant_Type__c,
                                    Associated_Capital_Design__r.Access_Cost__c,
                                    Associated_Capital_Design__r.IP_CapEx_Shared__c,
                                    Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c,
                                    Associated_Capital_Design__r.Wireless_Access_Points_Cost__c,
                                    Associated_Capital_Design__r.BCET_Wire_Center__c,
                                    Associated_Capital_Design__r.One_Time_Additional_Expense__c,
                                    Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c,
                                    Associated_Capital_Design__r.BRAIN_API_Call_Tracker_Master__c, 
                                    Associated_Capital_Design__r.Last_Associated_BRAIN_FA_Call__c,
                                    Associated_Capital_Design__r.Brain_ID__c,
                                    Associated_Capital_Design__r.Last_BRAIN_Automation_Fault__c,
                                    Associated_Capital_Design__r.QueuedForBRAINFARun__c
                            FROM Offer__c WHERE Id = :offerId AND Associated_Capital_Design__r.Name = :capitalDesignName LIMIT 1];
            
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offers with Id "' + offerId + '" for associated to Capital-Design named "' + capitalDesignName + '"' + RETURNED_0_RECS);
            }
	        return offerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListByIdForAssociatedCD) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Offer__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListByIdForAssociatedCD) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryOfferListByIdForAssociatedCD
        
    @AuraEnabled
    public static List<Offer__c> queryOfferListForBRAINFAApprovedDetailsById(String offerId) {
        try {
            List<Offer__c> offerList = [SELECT Id, Name, OwnerId, Offer_Total_Units__c, 
                                    Offer_Type__c, Offer_Status__c,                                    
                                    Other_Provider_Contract_Type__c,
                                    Contract_Term__c,
                                    Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Id, 
                                    Opportunity__r.Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Sole_Provider__c,     
                                    Bulk_Data_Type__c,
                                    Data_Bounty_Amount__c, 
                                    Bulk_Data_Speed_Profile_DL_UL__c,
                                    Requested_Bulk_Data_Price__c,
                                    Prepaid_Marketing_Fee_Per_Unit__c,
                                    Flat_Revenue_Share__c,
				                    Bulk_Data_Type_Approved__c,
                                    Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                    Data_Bounty_Amount_Approved__c, 
                                    Requested_Bulk_Data_Price_Approved__c,
                                    Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                    Flat_Revenue_Share_Approved__c,
                                    Contract__r.EndDate,
                                    Revenue_Share_Agent_Commission_Rate__c,
                                    Revenue_Share_MIN_Penetration_Rate__c,
                                    Revenue_Share_MAX_Penetration_Rate__c,
                                    Capital_Summation__c, 
                                    Expense_Summation__c,
                                    Capital_Summation_Offer__c, 
                                    Expense_Summation_Offer__c,
                                    Brain_ID__c,
                                    Brain_ID_Offer__c,
                                    BRAIN_API_Call_Tracker_Master__c,
                                    Associated_Capital_Design__c,
                                    Associated_Capital_Design__r.Name,
                                    Associated_Capital_Design__r.OwnerId,
                                    Associated_Capital_Design__r.Capital_Design_Stage__c,
                                    Associated_Capital_Design__r.Capital_Design_Type__c,
                                    Associated_Capital_Design__r.Actual_Build_Out_Months__c,
                         			Associated_Capital_Design__r.Core_Switch_Electronics__c,
                         			Associated_Capital_Design__r.Transport_Interoffice_Fiber__c,
                                    Associated_Capital_Design__r.CO_Electronics__c,
                                    Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c,
                         			Associated_Capital_Design__r.Remote_Electronics__c,
                                    Associated_Capital_Design__r.Total_Cottage_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Rental_Units__c,
                                    Associated_Capital_Design__r.Total_Cottage_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Owner_Units__c, 
                                    Associated_Capital_Design__r.Service_Delivery__c, 
                         			Associated_Capital_Design__r.Distribution_F2__c, 
									Associated_Capital_Design__r.F1_Footage_ft__c,
                                    Associated_Capital_Design__r.F2_Footage_ft__c,
                         			Associated_Capital_Design__r.Distribution_Structure_Conduit__c,
                                    Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c,
                         			Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c,
                         			Associated_Capital_Design__r.Other_MDU_F4__c, 
                                    Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c, 
                                    Associated_Capital_Design__r.Network_Investment__c, 
                                    Associated_Capital_Design__r.Technology_Type__c, 
                                    Associated_Capital_Design__r.Service_Type__c,                     
                         			Associated_Capital_Design__r.MDU_ONT_Drop__c,
                                    Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Total_Cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.Capital_Summation__c, 
                                    Associated_Capital_Design__r.Expense_Summation__c,
                         			Associated_Capital_Design__r.Access_Type__c,
                         			Associated_Capital_Design__r.F1_Feeder_Type__c,
                                    Associated_Capital_Design__r.Cluster_ID__c,
                                    Associated_Capital_Design__r.Cluster_Not_Available__c,
                                    Associated_Capital_Design__r.Number_of_missing_units__c,
                                    Associated_Capital_Design__r.Development_Status__c,
                                    Associated_Capital_Design__r.Building_Style__c,
                                    Associated_Capital_Design__r.ONT_Model__c,
                         			Associated_Capital_Design__r.Occupant_Type__c,
                                    Associated_Capital_Design__r.Access_Cost__c,
                                    Associated_Capital_Design__r.IP_CapEx_Shared__c,
                                    Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c,
                                    Associated_Capital_Design__r.Wireless_Access_Points_Cost__c,
                                    Associated_Capital_Design__r.BCET_Wire_Center__c,
                                    Associated_Capital_Design__r.One_Time_Additional_Expense__c,
                                    Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c,
                                    Associated_Capital_Design__r.BRAIN_API_Call_Tracker_Master__c, 
                                    Associated_Capital_Design__r.Last_Associated_BRAIN_FA_Call__c,
                                    Associated_Capital_Design__r.Brain_ID__c,
                                    Associated_Capital_Design__r.Last_BRAIN_Automation_Fault__c,
                                    Associated_Capital_Design__r.QueuedForBRAINFARun__c
                            FROM Offer__c WHERE Id = :offerId LIMIT 1];
            
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offers For BRAIN-FA Approved Details with Id "' + offerId + '"' + RETURNED_0_RECS);
            }
	        return offerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListForBRAINFAOfferDetailsById) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Offer__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListForBRAINFAApprovedDetailsById) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryOfferListForBRAINFAApprovedDetailsById
        
    @AuraEnabled
    public static List<Offer__c> queryOfferListForBRAINFAApprovedDetailsByIdForAssociatedCD(String offerId, String capitalDesignName) {
        try {
            List<Offer__c> offerList = [SELECT Id, Name, OwnerId, Offer_Total_Units__c, 
                                    Offer_Type__c, Offer_Status__c,                                    
                                    Other_Provider_Contract_Type__c,
                                    Contract_Term__c,
                                    Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Id, 
                                    Opportunity__r.Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Sole_Provider__c,     
                                    Bulk_Data_Type__c,
                                    Data_Bounty_Amount__c, 
                                    Bulk_Data_Speed_Profile_DL_UL__c,
                                    Requested_Bulk_Data_Price__c,
                                    Prepaid_Marketing_Fee_Per_Unit__c,
                                    Flat_Revenue_Share__c,
				                    Bulk_Data_Type_Approved__c,
                                    Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                    Data_Bounty_Amount_Approved__c, 
                                    Requested_Bulk_Data_Price_Approved__c,
                                    Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                    Flat_Revenue_Share_Approved__c,
                                    Contract__r.EndDate,
                                    Revenue_Share_Agent_Commission_Rate__c,
                                    Revenue_Share_MIN_Penetration_Rate__c,
                                    Revenue_Share_MAX_Penetration_Rate__c,
                                    Capital_Summation__c, 
                                    Expense_Summation__c,
                                    Capital_Summation_Offer__c, 
                                    Expense_Summation_Offer__c,
                                    Brain_ID__c,
                                    Brain_ID_Offer__c,
                                    BRAIN_API_Call_Tracker_Master__c,
                                    Associated_Capital_Design__c,
                                    Associated_Capital_Design__r.Name,
                                    Associated_Capital_Design__r.OwnerId,
                                    Associated_Capital_Design__r.Capital_Design_Stage__c,
                                    Associated_Capital_Design__r.Capital_Design_Type__c,
                                    Associated_Capital_Design__r.Actual_Build_Out_Months__c,
                         			Associated_Capital_Design__r.Core_Switch_Electronics__c,
                         			Associated_Capital_Design__r.Transport_Interoffice_Fiber__c,
                                    Associated_Capital_Design__r.CO_Electronics__c,
                                    Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c,
                         			Associated_Capital_Design__r.Remote_Electronics__c,
                                    Associated_Capital_Design__r.Total_Cottage_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Rental_Units__c,
                                    Associated_Capital_Design__r.Total_Cottage_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Owner_Units__c, 
                                    Associated_Capital_Design__r.Service_Delivery__c, 
                         			Associated_Capital_Design__r.Distribution_F2__c, 
									Associated_Capital_Design__r.F1_Footage_ft__c,
                                    Associated_Capital_Design__r.F2_Footage_ft__c,
                         			Associated_Capital_Design__r.Distribution_Structure_Conduit__c,
                                    Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c,
                         			Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c,
                         			Associated_Capital_Design__r.Other_MDU_F4__c, 
                                    Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Total_Cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.Capital_Summation__c, 
                                    Associated_Capital_Design__r.Expense_Summation__c,
                                    Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c, 
                                    Associated_Capital_Design__r.Network_Investment__c, 
                                    Associated_Capital_Design__r.Technology_Type__c, 
                                    Associated_Capital_Design__r.Service_Type__c,                     
                         			Associated_Capital_Design__r.MDU_ONT_Drop__c,
                         			Associated_Capital_Design__r.Access_Type__c,
                         			Associated_Capital_Design__r.F1_Feeder_Type__c,
                                    Associated_Capital_Design__r.Cluster_ID__c,
                                    Associated_Capital_Design__r.Cluster_Not_Available__c,
                                    Associated_Capital_Design__r.Number_of_missing_units__c,
                                    Associated_Capital_Design__r.Development_Status__c,
                                    Associated_Capital_Design__r.Building_Style__c,
                                    Associated_Capital_Design__r.ONT_Model__c,
                         			Associated_Capital_Design__r.Occupant_Type__c,
                                    Associated_Capital_Design__r.Access_Cost__c,
                                    Associated_Capital_Design__r.IP_CapEx_Shared__c,
                                    Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c,
                                    Associated_Capital_Design__r.Wireless_Access_Points_Cost__c,
                                    Associated_Capital_Design__r.BCET_Wire_Center__c,
                                    Associated_Capital_Design__r.One_Time_Additional_Expense__c,
                                    Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c,
                                    Associated_Capital_Design__r.BRAIN_API_Call_Tracker_Master__c, 
                                    Associated_Capital_Design__r.Last_Associated_BRAIN_FA_Call__c,
                                    Associated_Capital_Design__r.Brain_ID__c,
                                    Associated_Capital_Design__r.Last_BRAIN_Automation_Fault__c,
                                    Associated_Capital_Design__r.QueuedForBRAINFARun__c
                            FROM Offer__c WHERE Id = :offerId AND Associated_Capital_Design__r.Name = :capitalDesignName LIMIT 1];
            
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offers For BRAIN-FA Approved Details with Id "' + offerId + '" for associated to Capital-Design named "' + capitalDesignName + '"' + RETURNED_0_RECS);
            }
	        return offerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListForBRAINFAApprovedDetailsByIdForAssociatedCD) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Offer__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListForBRAINFAApprovedDetailsByIdForAssociatedCD) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryOfferListForBRAINFAApprovedDetailsByIdForAssociatedCD
        
    @AuraEnabled
    public static List<Offer__c> queryOfferListByAssocCDIdForBRAINBAU(String capitalDesignId) {
        try {
            List<Offer__c> offerList = [SELECT Id, Name, OwnerId, Offer_Total_Units__c, 
                                    Offer_Type__c, Offer_Status__c,                                    
                                    Other_Provider_Contract_Type__c,
                                    Contract_Term__c,
                                    Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Id, 
                                    Opportunity__r.Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Sole_Provider__c,     
                                    Bulk_Data_Type__c,
                                    Data_Bounty_Amount__c, 
                                    Bulk_Data_Speed_Profile_DL_UL__c,
                                    Requested_Bulk_Data_Price__c,
                                    Prepaid_Marketing_Fee_Per_Unit__c,
                                    Flat_Revenue_Share__c,
				                    Bulk_Data_Type_Approved__c,
                                    Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                    Data_Bounty_Amount_Approved__c, 
                                    Requested_Bulk_Data_Price_Approved__c,
                                    Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                    Flat_Revenue_Share_Approved__c,
                                    Contract__r.EndDate,
                                    Revenue_Share_Agent_Commission_Rate__c,
                                    Revenue_Share_MIN_Penetration_Rate__c,
                                    Revenue_Share_MAX_Penetration_Rate__c,
                                    Capital_Summation__c, 
                                    Expense_Summation__c,
                                    Capital_Summation_Offer__c, 
                                    Expense_Summation_Offer__c,
                                    Brain_ID__c,
                                    Brain_ID_Offer__c,
                                    BRAIN_API_Call_Tracker_Master__c,
                                    CapEx_Direct__c,
                                    Cumulative_NPV__c,
                                    Discounted_Payback_months__c,
                                    EBITDA_Margin__c,
                                    Ending_MRC__c,
                                    Financial_Viability__c,
                                    IRR__c,
                                    Incremental_ATC_To_Meet_Guardrail__c,
                                    Simple_Payback_Months__c,
                                    X1st_Year_of_Positive_EBITDA__c,
                                    X1st_Year_of_Positive_FCF__c,
                                    Associated_Capital_Design__c,
                                    Associated_Capital_Design__r.Name,
                                    Associated_Capital_Design__r.OwnerId,
                                    Associated_Capital_Design__r.Capital_Design_Stage__c,
                                    Associated_Capital_Design__r.Capital_Design_Type__c,
                                    Associated_Capital_Design__r.Actual_Build_Out_Months__c,
                         			Associated_Capital_Design__r.Core_Switch_Electronics__c,
                         			Associated_Capital_Design__r.Transport_Interoffice_Fiber__c,
                                    Associated_Capital_Design__r.CO_Electronics__c,
                                    Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c,
                         			Associated_Capital_Design__r.Remote_Electronics__c,
                                    Associated_Capital_Design__r.Total_Cottage_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Rental_Units__c,
                                    Associated_Capital_Design__r.Total_Cottage_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Owner_Units__c, 
                                    Associated_Capital_Design__r.Service_Delivery__c, 
                         			Associated_Capital_Design__r.Distribution_F2__c, 
									Associated_Capital_Design__r.F1_Footage_ft__c,
                                    Associated_Capital_Design__r.F2_Footage_ft__c,
                         			Associated_Capital_Design__r.Distribution_Structure_Conduit__c,
                                    Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c,
                         			Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c,
                         			Associated_Capital_Design__r.Other_MDU_F4__c, 
                                    Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Total_Cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.Capital_Summation__c, 
                                    Associated_Capital_Design__r.Expense_Summation__c,
                                    Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c, 
                                    Associated_Capital_Design__r.Network_Investment__c, 
                                    Associated_Capital_Design__r.Technology_Type__c, 
                                    Associated_Capital_Design__r.Service_Type__c,                     
                         			Associated_Capital_Design__r.MDU_ONT_Drop__c,
                         			Associated_Capital_Design__r.Access_Type__c,
                         			Associated_Capital_Design__r.F1_Feeder_Type__c,
                                    Associated_Capital_Design__r.Cluster_ID__c,
                                    Associated_Capital_Design__r.Cluster_Not_Available__c,
                                    Associated_Capital_Design__r.Number_of_missing_units__c,
                                    Associated_Capital_Design__r.Development_Status__c,
                                    Associated_Capital_Design__r.Building_Style__c,
                                    Associated_Capital_Design__r.ONT_Model__c,
                         			Associated_Capital_Design__r.Occupant_Type__c,
                                    Associated_Capital_Design__r.Access_Cost__c,
                                    Associated_Capital_Design__r.IP_CapEx_Shared__c,
                                    Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c,
                                    Associated_Capital_Design__r.Wireless_Access_Points_Cost__c,
                                    Associated_Capital_Design__r.BCET_Wire_Center__c,
                                    Associated_Capital_Design__r.One_Time_Additional_Expense__c,
                                    Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c,
                                    Associated_Capital_Design__r.BRAIN_API_Call_Tracker_Master__c, 
                                    Associated_Capital_Design__r.Last_Associated_BRAIN_FA_Call__c,
                                    Associated_Capital_Design__r.Brain_ID__c,
                                    Associated_Capital_Design__r.Last_BRAIN_Automation_Fault__c,
                                    Associated_Capital_Design__r.QueuedForBRAINFARun__c
                            FROM Offer__c WHERE Associated_Capital_Design__c = :capitalDesignId 
                                            AND Offer_Status__c != 'Approved'
                                            AND Offer_Status__c != 'Cancelled' LIMIT 100];
            
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offers with Associated Capital Design "' + capitalDesignId + '" RETURNED_0_RECS');
            }
	        return offerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListByAssocCDIdForBRAINBAU) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Offer__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListByAssocCDIdForBRAINBAU) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryOfferListByAssocCDIdForBRAINBAU
        
    @AuraEnabled
    public static List<Offer__c> queryOfferListByAssocCDIdForOfferCapEval(String capitalDesignId) {
        try {
            List<Offer__c> offerList = [SELECT Id, Name, Offer_Status__c,
                                    Offer_Type__c, 
                                    Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Id, 
                                    Opportunity__r.Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Sole_Provider__c,     
                                    Associated_Capital_Design__c,
                                    Associated_Capital_Design__r.Name,
                                    Associated_Capital_Design__r.OwnerId,
                                    Associated_Capital_Design__r.Capital_Design_Stage__c,
                                    Associated_Capital_Design__r.Capital_Design_Type__c,
                                    Associated_Capital_Design__r.Capital_Summation__c, 
                                    Associated_Capital_Design__r.Expense_Summation__c,
                                    Associated_Capital_Design__r.Brain_ID__c,
                                    Associated_Capital_Design__r.BRAIN_API_Call_Tracker_Master__c, 
                                    Associated_Capital_Design__r.Last_Associated_BRAIN_FA_Call__c,
                                    Associated_Capital_Design__r.Last_BRAIN_Automation_Fault__c,
                                    Brain_ID__c,
                					Brain_ID_Offer__c,
                                    BRAIN_API_Call_Tracker_Master__c,
                                    Capital_Summation__c, 
                                    Expense_Summation__c,
                                    Capital_Summation_Offer__c, 
                                    Expense_Summation_Offer__c,
                                    CapEx_Direct_Offer__c,
                                    Cumulative_NPV_Offer__c,
                                    Discounted_Payback_months_Offer__c,
                                    EBITDA_Margin_Offer__c,
                                    Ending_MRC_Offer__c,
                                    Financial_Viability_Offer__c,
                                    IRR_Offer__c,
                                    Incremental_ATC_To_Meet_Guardrail_Offe__c,
                                    Simple_Payback_Months_Offer__c,
                                    X1st_Year_of_Positive_EBITDA_Offer__c,
                                    X1st_Year_of_Positive_FCF_Offer__c
                            FROM Offer__c WHERE Associated_Capital_Design__c = :capitalDesignId LIMIT 1];
            
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offers with Associated Capital Design "' + capitalDesignId + '" RETURNED_0_RECS');
            }
	        return offerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListByAssocCDIdForOfferCapEval) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Offer__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListByAssocCDIdForOfferCapEval) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryOfferListByAssocCDIdForOfferCapEval
    
    @AuraEnabled
    public static List<Offer__c> queryForRequestControllerByAssocCDIdForOfferSubmission(String capitalDesignId) {
        try {
            List<Offer__c> offerList =  [SELECT Id, Name, Offer_Status__c,
			                                    Offer_Type__c, 
                                                Alternate_Sales_Engineer__c, 
                                                Opportunity__r.Id, 
                                                Opportunity__r.Alternate_Sales_Engineer__c, 
			                                    Opportunity__r.Sole_Provider__c,     
                                                Brain_ID__c,
                                                Brain_ID_Offer__c,
                                                BRAIN_API_Call_Tracker_Master__c,
                                                Associated_Capital_Design__c,
                                                Associated_Capital_Design__r.Name,
                                         		Associated_Capital_Design__r.OwnerId,
			                                    Associated_Capital_Design__r.Capital_Design_Type__c,
                                                Associated_Capital_Design__r.BRAIN_ID__c, 
                                                Associated_Capital_Design__r.BRAIN_API_Call_Tracker_Master__c, 
                                                Associated_Capital_Design__r.Last_Associated_BRAIN_FA_Call__c,
		                                        Associated_Capital_Design__r.Last_BRAIN_Automation_Fault__c
                            			   FROM Offer__c WHERE Associated_Capital_Design__c = :capitalDesignId LIMIT 1];
            
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offers with Associated Capital Design "' + capitalDesignId + '" RETURNED_0_RECS');
            }
	        return offerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryForRequestControllerByAssocCDIdForOfferSubmission) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Offer__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForRequestControllerByAssocCDIdForOfferSubmission) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryForRequestControllerByAssocCDIdForOfferSubmission

    @AuraEnabled
    public static BRAIN_FA_Request__c queryForRequestControllerByBACTId(String bactId) {
        try {
            BRAIN_FA_Request__c faRequest = [SELECT Id, Name, cuid__c, 
                                 BRAIN_API_Call_Tracker_Master__c, 
                                 BRAIN_API_Call_Tracker_Master__r.Capital_Design__c
                           FROM BRAIN_FA_Request__c WHERE BRAIN_API_Call_Tracker_Master__c = :bactId LIMIT 1];
            if (faRequest == null) {
                throw new NullObjectException('EXCEPTION! Query for BRAIN_FA_Request__c object records with BACT-Id ' + bactId + ' returned NULL');
            }
            return faRequest;
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForRequestControllerByBACTId) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryForRequestControllerByBACTId
    
    @AuraEnabled
    public static List<Offer__c> queryOfferList(String capitalDesignName) {
        try {
            List<Offer__c> offerList = [SELECT Id, Name, OwnerId, Offer_Total_Units__c, 
                                    Offer_Type__c, Offer_Status__c,                                    
                                    Other_Provider_Contract_Type__c,
                                    Contract_Term__c,
                                    Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Id, 
                                    Opportunity__r.Alternate_Sales_Engineer__c, 
                                    Opportunity__r.Sole_Provider__c,     
                                    Bulk_Data_Type__c,
                                    Data_Bounty_Amount__c, 
                                    Bulk_Data_Speed_Profile_DL_UL__c,
                                    Requested_Bulk_Data_Price__c,
                                    Prepaid_Marketing_Fee_Per_Unit__c,
                                    Flat_Revenue_Share__c,
				                    Bulk_Data_Type_Approved__c,
                                    Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                    Data_Bounty_Amount_Approved__c, 
                                    Requested_Bulk_Data_Price_Approved__c,
                                    Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                    Flat_Revenue_Share_Approved__c,
                                    Contract__r.EndDate,
                                    Revenue_Share_Agent_Commission_Rate__c,
                                    Revenue_Share_MIN_Penetration_Rate__c,
                                    Revenue_Share_MAX_Penetration_Rate__c,
                                    Capital_Summation__c, 
                                    Expense_Summation__c,
                                    Capital_Summation_Offer__c, 
                                    Expense_Summation_Offer__c,
                                    Brain_ID__c,
                                    Brain_ID_Offer__c,
                                    BRAIN_API_Call_Tracker_Master__c,
                                    Associated_Capital_Design__c,
                                    Associated_Capital_Design__r.Name,
                                    Associated_Capital_Design__r.OwnerId,
                                    Associated_Capital_Design__r.Capital_Design_Stage__c,
                                    Associated_Capital_Design__r.Capital_Design_Type__c,
                                    Associated_Capital_Design__r.Actual_Build_Out_Months__c,
                         			Associated_Capital_Design__r.Core_Switch_Electronics__c,
                         			Associated_Capital_Design__r.Transport_Interoffice_Fiber__c,
                                    Associated_Capital_Design__r.CO_Electronics__c,
                                    Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c,
                         			Associated_Capital_Design__r.Remote_Electronics__c,
                                    Associated_Capital_Design__r.Total_Cottage_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Rental_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Rental_Units__c,
                                    Associated_Capital_Design__r.Total_Cottage_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_Tower_Owner_Units__c, 
                                    Associated_Capital_Design__r.Total_SFH_Owner_Units__c, 
                                    Associated_Capital_Design__r.Service_Delivery__c, 
                         			Associated_Capital_Design__r.Distribution_F2__c, 
									Associated_Capital_Design__r.F1_Footage_ft__c,
                                    Associated_Capital_Design__r.F2_Footage_ft__c,
                         			Associated_Capital_Design__r.Distribution_Structure_Conduit__c,
                                    Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c,
                         			Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c,
                         			Associated_Capital_Design__r.Other_MDU_F4__c, 
                                    Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Total_Cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.OP_F3_Total_Cost_Comb_Cost__c,
                                    Associated_Capital_Design__r.Capital_Summation__c, 
                                    Associated_Capital_Design__r.Expense_Summation__c,
                                    Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c, 
                                    Associated_Capital_Design__r.Network_Investment__c, 
                                    Associated_Capital_Design__r.Technology_Type__c, 
                                    Associated_Capital_Design__r.Service_Type__c,                     
                         			Associated_Capital_Design__r.MDU_ONT_Drop__c,
                         			Associated_Capital_Design__r.Access_Type__c,
                         			Associated_Capital_Design__r.F1_Feeder_Type__c,
                                    Associated_Capital_Design__r.Cluster_ID__c,
                                    Associated_Capital_Design__r.Cluster_Not_Available__c,
                                    Associated_Capital_Design__r.Number_of_missing_units__c,
                                    Associated_Capital_Design__r.Development_Status__c,
                                    Associated_Capital_Design__r.Building_Style__c,
                                    Associated_Capital_Design__r.ONT_Model__c,
                         			Associated_Capital_Design__r.Occupant_Type__c,
                                    Associated_Capital_Design__r.Access_Cost__c,
                                    Associated_Capital_Design__r.IP_CapEx_Shared__c,
                                    Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c,
                                    Associated_Capital_Design__r.Wireless_Access_Points_Cost__c,
                                    Associated_Capital_Design__r.BCET_Wire_Center__c,
                                    Associated_Capital_Design__r.One_Time_Additional_Expense__c,
                                    Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c,
                                    Associated_Capital_Design__r.BRAIN_API_Call_Tracker_Master__c, 
                                    Associated_Capital_Design__r.Last_Associated_BRAIN_FA_Call__c,
                                    Associated_Capital_Design__r.Brain_ID__c,
                                    Associated_Capital_Design__r.Last_BRAIN_Automation_Fault__c,
                                    Associated_Capital_Design__r.QueuedForBRAINFARun__c
                            FROM Offer__c WHERE Associated_Capital_Design__r.Name = :capitalDesignName LIMIT 1];
            
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offers associated to Capital-Design named "' + capitalDesignName + '"' + RETURNED_0_RECS);
            }
	        return offerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryOfferList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Offer__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryOfferList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryOfferList

    @AuraEnabled
    public static List<Capital_Design__c> queryCapDesignList(String capitalDesignName) {
        try {
            List<Capital_Design__c> capDesignList = [SELECT Id, Name, OwnerId, 
	                                            Capital_Design_Stage__c,
    	                                        Capital_Design_Type__c,
                                    			Alternate_Sales_Engineer__c, 
			                                    Opportunity__r.Id, 
			                                    Opportunity__r.Alternate_Sales_Engineer__c, 
			                                    Opportunity__r.Sole_Provider__c,     
                                                Offer__r.Offer_Total_Units__c, 
                                                Offer__r.Offer_Type__c,
                                                Offer__r.Offer_Status__c,
                                                Offer__r.Opportunity__r.Id, 
			                                    Offer__r.Opportunity__r.Alternate_Sales_Engineer__c, 
			                                    Offer__r.Opportunity__r.Sole_Provider__c,     
                                                Offer__r.Contract__r.EndDate,
                                                Offer__r.Other_Provider_Contract_Type__c, 
                                                Offer__r.Contract_Term__c,
                                                Offer__r.Bulk_Data_Type__c,
                                                Offer__r.Bulk_Data_Speed_Profile_DL_UL__c,
                                                Offer__r.Data_Bounty_Amount__c, 
                                                Offer__r.Requested_Bulk_Data_Price__c,
                                                Offer__r.Prepaid_Marketing_Fee_Per_Unit__c,                                                     
                                                Offer__r.Bulk_Data_Type_Approved__c,
                                                Offer__r.Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                                Offer__r.Data_Bounty_Amount_Approved__c, 
                                                Offer__r.Requested_Bulk_Data_Price_Approved__c,
                                                Offer__r.Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                                Offer__r.Flat_Revenue_Share_Approved__c,
                                                Offer__r.Revenue_Share_Agent_Commission_Rate__c,
                                                Offer__r.Revenue_Share_MIN_Penetration_Rate__c,
                                                Offer__r.Revenue_Share_MAX_Penetration_Rate__c,
                                                Offer__r.Capital_Summation__c, 
                                                Offer__r.Expense_Summation__c,
                                                Offer__r.Capital_Summation_Offer__c, 
                                                Offer__r.Expense_Summation_Offer__c,
                                                Offer__r.Brain_ID__c,
                                                Offer__r.Brain_ID_Offer__c,
                                                Offer__r.BRAIN_API_Call_Tracker_Master__c,
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
                                                F1_Footage_ft__c,
                                                F2_Footage_ft__c,
                                                Distribution_Structure_Conduit__c,
                                                Electronics_Shelf_UPS_Cost__c,
                                                F4_Inside_Wiring_SFH__c,
                                                Other_MDU_F4__c,
                                                OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                                OP_F2_Total_Cost_Combined_Cost__c,
                                                OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                                OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c,
                                                OP_F3_Total_Cost_Comb_Cost__c,
                                    			Capital_Summation__c, 
                                    			Expense_Summation__c,
                                                for_SFU_Average_Lot_Size__c, 
                                                Network_Investment__c, 
                                                Technology_Type__c, 
                                                Service_Type__c,                     
                                                MDU_ONT_Drop__c,
                                                Access_Type__c,
                                                F1_Feeder_Type__c,
                                                Cluster_ID__c,
                                                Cluster_Not_Available__c,
                                                Number_of_missing_units__c,
                                                Development_Status__c,
                                                Building_Style__c,
                                                ONT_Model__c,
                                                Occupant_Type__c,
                                                //The InstantWiFi-specific fields are listed together below 
                                                Access_Cost__c,
                                                IP_CapEx_Shared__c,
                                                IP_NetEx_Shared_MRC__c,
                                                Wireless_Access_Points_Cost__c,
                                                BCET_Wire_Center__c,
                                                One_Time_Additional_Expense__c,
                                                Recurring_Additional_Expenses_Monthly__c,
                                                //The NMA-specific fields are listed together below 
                                                Property_Name__c,
                                                Product__c,
                                                Planned_Build_Out_Years__c,
                                                Wire_Center_CLLI_Code__c,
                                                Latitude_NM__c,
                                                Longitude_NM__c,
                                                Service_Delivery_NM__c,
                                                Development_Status_NM__c,
                                                Max_Downstream_Speed_NM__c,
                                                Total_Cottage_Rental_Units_NM__c, 
                                                Total_Tower_Rental_Units_NM__c, 
                                                Total_SFH_Rental_Units_NM__c,
                                                Total_Cottage_Owner_Units_NM__c, 
                                                Total_Tower_Owner_Units_NM__c, 
                                                Total_SFH_Owner_Units_NM__c,
                                                BRAIN_API_Call_Tracker_Master__c, 
                                                Last_Associated_BRAIN_FA_Call__c,
                                                Brain_ID__c,
                                                Last_BRAIN_Automation_Fault__c,
                                        		QueuedForBRAINFARun__c
			                            FROM Capital_Design__c WHERE Name = :capitalDesignName LIMIT 1];
            
			if(capDesignList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of Capital-Design objects named "' + capitalDesignName + '"' + RETURNED_0_RECS);
            }
	        return capDesignList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryCapDesignList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Capital_Design__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryCapDesignList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryCapDesignList
    
    @AuraEnabled
    public static List<Capital_Design__c> queryCapDesignListById(String capitalDesignId) {
        try {
            List<Capital_Design__c> capDesignList = [SELECT Id, Name, 
                                                OwnerId, 
                                                Offer__c, 
                                                Capital_Design_Stage__c,
                                                Capital_Design_Type__c,
                                                Alternate_Sales_Engineer__c, 
                                                Opportunity__r.Id, 
                                                Opportunity__r.Alternate_Sales_Engineer__c, 
			                                    Opportunity__r.Sole_Provider__c,     
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
                                                Offer__r.Offer_Type__c, 
                                                Offer__r.Offer_Status__c,
                                                Offer__r.Other_Provider_Contract_Type__c, 
                                                Offer__r.Contract_Term__c,
                                                Offer__r.Opportunity__r.Id, 
			                                    Offer__r.Opportunity__r.Alternate_Sales_Engineer__c, 
			                                    Offer__r.Opportunity__r.Sole_Provider__c,     
                                                Offer__r.Contract__r.EndDate,
                                                Offer__r.Bulk_Data_Type__c,
                                                Offer__r.Bulk_Data_Speed_Profile_DL_UL__c,
                                                Offer__r.Data_Bounty_Amount__c, 
                                                Offer__r.Requested_Bulk_Data_Price__c,
                                                Offer__r.Prepaid_Marketing_Fee_Per_Unit__c,                                                     
                                                Offer__r.Bulk_Data_Type_Approved__c,
                                                Offer__r.Bulk_Data_Speed_Profile_DL_UL_Approv__c,
                                                Offer__r.Data_Bounty_Amount_Approved__c, 
                                                Offer__r.Requested_Bulk_Data_Price_Approved__c,
                                                Offer__r.Prepaid_Marketing_Fee_Per_Unit_Approve__c,
                                                Offer__r.Flat_Revenue_Share_Approved__c,
                                                Offer__r.Revenue_Share_Agent_Commission_Rate__c,
                                                Offer__r.Revenue_Share_MIN_Penetration_Rate__c,
                                                Offer__r.Revenue_Share_MAX_Penetration_Rate__c,
                                                Offer__r.Capital_Summation__c, 
                                                Offer__r.Expense_Summation__c,
                                                Offer__r.Capital_Summation_Offer__c, 
                                                Offer__r.Expense_Summation_Offer__c,
                                                Offer__r.Brain_ID__c,
                                                Offer__r.Brain_ID_Offer__c,
                                                Offer__r.BRAIN_API_Call_Tracker_Master__c,
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
                                                F1_Footage_ft__c,
                                                F2_Footage_ft__c,
                                                Distribution_Structure_Conduit__c,
                                                Electronics_Shelf_UPS_Cost__c,
                                                F4_Inside_Wiring_SFH__c,
                                                Other_MDU_F4__c,
                                                OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                                OP_F2_Total_Cost_Combined_Cost__c,
                                                OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                                OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c,
                                                OP_F3_Total_Cost_Comb_Cost__c,
                                                Capital_Summation__c, 
                                                Expense_Summation__c,
                                                for_SFU_Average_Lot_Size__c, 
                                                Network_Investment__c, 
                                                Technology_Type__c, 
                                                Service_Type__c,                     
                                                MDU_ONT_Drop__c,
                                                Access_Type__c,
                                                F1_Feeder_Type__c,
                                                Cluster_ID__c,
                                                Cluster_Not_Available__c,
                                                Number_of_missing_units__c,
                                                Development_Status__c,
                                                Building_Style__c,
                                                ONT_Model__c,
                                                Occupant_Type__c,
                                                //The InstantWiFi-specific fields are listed together below 
                                                Access_Cost__c,
                                                IP_CapEx_Shared__c,
                                                IP_NetEx_Shared_MRC__c,
                                                Wireless_Access_Points_Cost__c,
                                                BCET_Wire_Center__c,
                                                One_Time_Additional_Expense__c,
                                                Recurring_Additional_Expenses_Monthly__c,
                                                //The NMA-specific fields are listed together below 
                                                Property_Name__c,
                                                Product__c,
                                                Planned_Build_Out_Years__c,
                                                Wire_Center_CLLI_Code__c,
                                                Latitude_NM__c,
                                                Longitude_NM__c,
                                                Service_Delivery_NM__c,
                                                Development_Status_NM__c,
                                                Max_Downstream_Speed_NM__c,
                                                Total_Cottage_Rental_Units_NM__c, 
                                                Total_Tower_Rental_Units_NM__c, 
                                                Total_SFH_Rental_Units_NM__c,
                                                Total_Cottage_Owner_Units_NM__c, 
                                                Total_Tower_Owner_Units_NM__c, 
                                                Total_SFH_Owner_Units_NM__c,
                                                BRAIN_API_Call_Tracker_Master__c, 
                                                Last_Associated_BRAIN_FA_Call__c,
                                                Brain_ID__c,
                                                Last_BRAIN_Automation_Fault__c,
                                                QueuedForBRAINFARun__c
                                           FROM Capital_Design__c
                                          WHERE Id = :capitalDesignId LIMIT 1];
            if(capDesignList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Capital-Design objects with Id "' + capitalDesignId + '"' + RETURNED_0_RECS);
            }
            return capDesignList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryCapDesignListById) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Capital_Design__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryCapDesignListById) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryCapDesignListById
    
    @AuraEnabled
    public static List<Capital_Design__c> queryNMACapDesignListById(String capitalDesignId) {
        try {
            List<Capital_Design__c> capDesignList = [SELECT Id, Name, 
                                                OwnerId, 
                                                Capital_Design_Stage__c,
                                                Capital_Design_Type__c,
                                                Alternate_Sales_Engineer__c, 
                                                Opportunity__r.Id, 
                                                Opportunity__r.Alternate_Sales_Engineer__c, 
			                                    Opportunity__r.Sole_Provider__c,     
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
                                                F1_Footage_ft__c,
                                                F2_Footage_ft__c,
                                                Distribution_Structure_Conduit__c,
                                                Electronics_Shelf_UPS_Cost__c,
                                                F4_Inside_Wiring_SFH__c,
                                                Other_MDU_F4__c,
                                                OP_Res_Gateway_Total_Cost_Comb_Cost__c,
                                                OP_F2_Total_Cost_Combined_Cost__c,
                                                OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                                                OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c,
                                                OP_F3_Total_Cost_Comb_Cost__c,
                                    			Capital_Summation__c, 
                                    			Expense_Summation__c,
                                                for_SFU_Average_Lot_Size__c, 
                                                Network_Investment__c, 
                                                Technology_Type__c, 
                                                Service_Type__c,                     
                                                MDU_ONT_Drop__c,
                                                Access_Type__c,
                                                F1_Feeder_Type__c,
                                                Cluster_ID__c,
                                                Cluster_Not_Available__c,
                                                Number_of_missing_units__c,
                                                Development_Status__c,
                                                Building_Style__c,
                                                ONT_Model__c,
                                                Occupant_Type__c,
                                                //The InstantWiFi-specific fields are listed together below 
                                                Access_Cost__c,
                                                IP_CapEx_Shared__c,
                                                IP_NetEx_Shared_MRC__c,
                                                Wireless_Access_Points_Cost__c,
                                                BCET_Wire_Center__c,
                                                One_Time_Additional_Expense__c,
                                                Recurring_Additional_Expenses_Monthly__c,
                                                //The NMA-specific fields are listed together below 
                                                Property_Name__c,
                                                Product__c,
                                                Planned_Build_Out_Years__c,
                                                Wire_Center_CLLI_Code__c,
                                                Latitude_NM__c,
                                                Longitude_NM__c,
                                                Service_Delivery_NM__c,
                                                Development_Status_NM__c,
                                                Max_Downstream_Speed_NM__c,
                                                Total_Cottage_Rental_Units_NM__c, 
                                                Total_Tower_Rental_Units_NM__c, 
                                                Total_SFH_Rental_Units_NM__c,
                                                Total_Cottage_Owner_Units_NM__c, 
                                                Total_Tower_Owner_Units_NM__c, 
                                                Total_SFH_Owner_Units_NM__c,
                                                BRAIN_API_Call_Tracker_Master__c, 
                                                Last_Associated_BRAIN_FA_Call__c,
                                                Brain_ID__c,
                                                Last_BRAIN_Automation_Fault__c,
                                                QueuedForBRAINFARun__c
                                           FROM Capital_Design__c
                                          WHERE Id = :capitalDesignId LIMIT 1];
            if(capDesignList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Non-Marketing Capital-Design objects with Id "' + capitalDesignId + '"' + RETURNED_0_RECS);
            }
            return capDesignList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryNMACapDesignListById) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Capital_Design__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryNMACapDesignListById) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryNMACapDesignListById

    @AuraEnabled
    public static BRAIN_FA_Request__c queryFARequestById(String faRequestId) {
        try {
            BRAIN_FA_Request__c faRequest = [SELECT Id, Name, sourceSystem__c, cuid__c, financialMetricCurrencyCode__c, 
                                 financialMetricCurrencyExchangeDate__c, 
                                 sourceSystemId__c, sourceSystemIdType__c,
                                 analysisOverride__c, opportunityTitle__c,
                                 BRAIN_API_Call_Tracker_Master__c, 
                                 BRAIN_API_Call_Tracker_Master__r.Capital_Design__c, 
                                 BRAIN_API_Call_Tracker_Master__r.API_Transaction__c, 
                                 Constructed_JSON__c
                           FROM BRAIN_FA_Request__c WHERE id = :faRequestId LIMIT 1];
            if (faRequest == null) {
                throw new NullObjectException('EXCEPTION! Query for BRAIN_FA_Request__c object records with Id ' + faRequestId + ' returned NULL');
            }
            return faRequest;
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryFARequestById) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryFARequestById

    @AuraEnabled
    public static List<hl2Item__c> queryHl2ItemsList(String hl2ItemId) {
        try {
            List<hl2Item__c> hl2ItemList = [SELECT Id, Name, sourceSystemId__c,
                           			sourceSystemIdType__c,
                           			latitude__c,
                           			longitude__c,
                           			wireCenterCLLI__c,
                           			constructionMonths__c,
                           			currencyCode__c,
                           			coreElectronicsCost__c,
                           			interofficeFiberCost__c,
                           			coElectronicsCost__c,
                           			f1FeederCost__c,
									f1FeederFootage__c,
                           			remoteElectronicsCost__c,
                                    accessCost__c,
                                    ipCapExShared__c,
                                    ipNetExSharedMRC__c,
                           			hl2ItemOverride__c,
                           			hl3Items__c,
                                    BRAIN_FA_Request_Master__c
                            FROM hl2Item__c WHERE Id = :hl2ItemId LIMIT 1];
            if(hl2ItemList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of hl2Item objects with Id "' + hl2ItemId + '"' + RETURNED_0_RECS);
            }
	        return hl2ItemList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryHl2ItemsList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<hl2Item__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryHl2ItemsList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryHl2ItemsList

    @AuraEnabled
    public static List<hl3Item__c> queryHl3ItemsList(String hl3ItemId) {
        try {
			List<hl3Item__c> hl3ItemList = [SELECT Id, Name, quantity__c,
                                   constructionType__c,
                                   ctlOn__c,
                                   currencyCode__c,
                                   f2Cost__c,
                                   f2CostSource__c,
                                   f2Footage__c,
                                   insideWiringCapEx__c,
                                   ontType__c,
                                   dropCost__c,
                                   dropCostSource__c,
                                   additionalOpExNrc__c,
                                   additionalOpExMrc__c,
                                   occupantType__c,
                                   lotFrontageFeet__c,
                                   maxDownstreamSpeedKbps__c,
                                   clusterId__c,
                                   bulkDownstreamKbps__c,
                                   bulkRevenueMrcPerUnit__c,
                                   baseMarketingFees__c,
                                   marketingFees__c,
                                   baseBulkDownstreamKbps__c,
                                   baseBulkRevenueMrcPerUnit__c,
                                   baseContractType__c,
                                   baseContractEndDate__c,
                                   fdhCost__c,
                                   splitterCost__c,
                                   splitterPorts__c,
                                   idfElectronicsCost__c,
                                   wirelessAccessPointsCost__c,
                                   networkInvestmentType__c,
                                   productType__c,
                                   contractType__c,
                                   otherProviderContractType__c,
                                   contractTermMonths__c,
                                   hl3ItemOverride__c,
                                   demographics__c,
                                   hl2ItemMaster__c
                            FROM hl3Item__c WHERE Id = :hl3ItemId LIMIT 1];
            if(hl3ItemList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of hl3Item objects with Id "' + hl3ItemId + '"' + RETURNED_0_RECS);
            }
            return hl3ItemList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryHl3ItemsList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<hl3Item__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryHl3ItemsList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryHl3ItemsList

    @AuraEnabled
    public static List<hl2Item__c> queryHl2ItemsListByFARequest(String faRequestId) {
        try {
            List<hl2Item__c> hl2ItemList = [SELECT Id, Name, sourceSystemId__c,
                           			sourceSystemIdType__c,
                           			latitude__c,
                           			longitude__c,
                           			wireCenterCLLI__c,
                           			constructionMonths__c,
                           			currencyCode__c,
                           			coreElectronicsCost__c,
                           			interofficeFiberCost__c,
                           			coElectronicsCost__c,
                           			f1FeederCost__c,
									f1FeederFootage__c,
                           			remoteElectronicsCost__c,
                                    accessCost__c,
                                    ipCapExShared__c,
                                    ipNetExSharedMRC__c,
                           			hl2ItemOverride__c,
                           			hl3Items__c,
                                    BRAIN_FA_Request_Master__c
                            FROM hl2Item__c WHERE BRAIN_FA_Request_Master__c = :faRequestId LIMIT 10];
            if(hl2ItemList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of hl2Item objects with BRAIN_FA_Request_Master__c "' + faRequestId + '"' + RETURNED_0_RECS);
            }
	        return hl2ItemList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryHl2ItemsListByFARequest) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<hl2Item__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryHl2ItemsListByFARequest) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryHl2ItemsListByFARequest

    @AuraEnabled
    public static List<hl3Item__c> queryHl3ItemsListByHl2Item(String hl2ItemId) {
        try {
			List<hl3Item__c> hl3ItemList = [SELECT Id, Name, quantity__c,
                                   constructionType__c,
                                   ctlOn__c,
                                   currencyCode__c,
                                   f2Cost__c,
                                   f2CostSource__c,
                                   f2Footage__c,
                                   insideWiringCapEx__c,
                                   ontType__c,
                                   dropCost__c,
                                   dropCostSource__c,
                                   additionalOpExNrc__c,
                                   additionalOpExMrc__c,
                                   occupantType__c,
                                   lotFrontageFeet__c,
                                   maxDownstreamSpeedKbps__c,
                                   clusterId__c,
                                   bulkDownstreamKbps__c,
                                   bulkRevenueMrcPerUnit__c,
                                   baseMarketingFees__c,
                                   marketingFees__c,
                                   baseBulkDownstreamKbps__c,
                                   baseBulkRevenueMrcPerUnit__c,
                                   baseContractType__c,
                                   baseContractEndDate__c,
                                   fdhCost__c,
                                   splitterCost__c,
                                   splitterPorts__c,
                                   idfElectronicsCost__c,
                                   wirelessAccessPointsCost__c,
                                   networkInvestmentType__c,
                                   productType__c,
                                   contractType__c,
                                   otherProviderContractType__c,
                                   contractTermMonths__c,
                                   hl3ItemOverride__c,
                                   demographics__c,
                                   hl2ItemMaster__c
                            FROM hl3Item__c WHERE hl2ItemMaster__c = :hl2ItemId LIMIT 1];
            if(hl3ItemList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of hl3Item objects with hl2ItemMaster__c "' + hl2ItemId + '"' + RETURNED_0_RECS);
            }
            return hl3ItemList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryHl3ItemsListByHl2Item) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<hl3Item__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryHl3ItemsListByHl2Item) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryHl3ItemsListByHl2Item

    @AuraEnabled
    public static List<hl3ItemOverride__c> queryHl3ItemOverridesList(String hl3ItemOverrideId) {
        try {
            List<hl3ItemOverride__c> hl3ItemOverridesList = [SELECT Id, Name, ontCost__c,
                                   ontCostSource__c,
                                   hl3ItemMaster__c
                            FROM hl3ItemOverride__c WHERE Id = :hl3ItemOverrideId LIMIT 1];
            if(hl3ItemOverridesList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of hl3ItemOverride objects with Id "' + hl3ItemOverrideId + '"' + RETURNED_0_RECS);
            }
            return hl3ItemOverridesList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryHl3ItemOverridesList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<hl3ItemOverride__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryHl3ItemOverridesList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryHl3ItemOverridesList

    @AuraEnabled
    public static List<hl3ItemOverride__c> queryHl3ItemOverridesListByHl3Item(String hl3ItemId) {
        try {
            List<hl3ItemOverride__c> hl3ItemOverridesList = [SELECT Id, Name, ontCost__c,
                                   ontCostSource__c,
                                   hl3ItemMaster__c
                            FROM hl3ItemOverride__c WHERE hl3ItemMaster__c = :hl3ItemId LIMIT 10];
            if(hl3ItemOverridesList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of hl3ItemOverride objects with hl3ItemMaster__c "' + hl3ItemId + '"' + RETURNED_0_RECS);
            }
            return hl3ItemOverridesList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryHl3ItemOverridesListByHl3Item) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<hl3ItemOverride__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryHl3ItemOverridesListByHl3Item) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryHl3ItemOverridesListByHl3Item

    @AuraEnabled
    public static List<marketingFee__c> queryMarketingFeesList(String marketingFeeId) {
        try {
            List<marketingFee__c> marketingFeesList = [SELECT Id, Name, currencyCode__c, 
                                 		doorFeePerUnit__c,
                                 		firstInstallBountyPerUnit__c,
		                           		serviceRevenueShares__c
                            	   FROM marketingFee__c WHERE Id = :marketingFeeId LIMIT 1];
            if(marketingFeesList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of marketingFee objects with Id "' + marketingFeeId + '"' + RETURNED_0_RECS);
            }
            return marketingFeesList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryMarketingFeesList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<marketingFee__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryMarketingFeesList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryMarketingFeesList

    @AuraEnabled
    public static List<serviceRevenueShare__c> queryServiceRevenueSharesList(String serviceRevenueSharesId) {
        try {
            List<ServiceRevenueShare__c> serviceRevenueSharesList = [SELECT Id, Name, 
                                        		minPenetrationRate__c,
                                        		maxPenetrationRate__c,
                                        		agentCommissionRate__c
				                          FROM ServiceRevenueShare__c WHERE Id = :serviceRevenueSharesId LIMIT 1];
            if(serviceRevenueSharesList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of serviceRevenueShare objects with Id "' + serviceRevenueSharesId + '"' + RETURNED_0_RECS);
            }
            return serviceRevenueSharesList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryServiceRevenueSharesList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<ServiceRevenueShare__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryServiceRevenueSharesList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryServiceRevenueSharesList

    @AuraEnabled
    public static List<demographic__c> queryDemographicsList(String demographicId) {
        try {
            List<demographic__c> demographicsList = [SELECT Id, Name, 
                                	   quantity__c,
                                	   rental__c,
                                	   incomeLevel__c,
                                       hl3ItemMaster__c
	                              FROM demographic__c WHERE Id = :demographicId LIMIT 1];
            if(demographicsList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of demographic objects with Id "' + demographicId + '"' + RETURNED_0_RECS);
            }
            return demographicsList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryDemographicsList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<demographic__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryDemographicsList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryDemographicsList

    @AuraEnabled
    public static List<demographic__c> queryDemographicsListByHl3ItemsId(String hl3ItemsId) {
        try {
            List<demographic__c> demographicsList = [SELECT Id, Name, 
                                	   quantity__c,
                                	   rental__c,
                                	   incomeLevel__c,
                                       hl3ItemMaster__c
	                              FROM demographic__c WHERE hl3ItemMaster__c = :hl3ItemsId LIMIT 8];
            if(demographicsList.size() == 0) {				
                throw new ZeroListException('EXCEPTION!  Query for a list of demographic objects with hl3ItemMaster__c "' + hl3ItemsId + '"' + RETURNED_0_RECS);
            }
            return demographicsList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryDemographicsListByHl3ItemsId) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<demographic__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryDemographicsListByHl3ItemsId) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryDemographicsListByHl3ItemsId

    @AuraEnabled
    public static List<Offer__c> queryOfferListForCapEvalByOfferAndCDIds(String offerId, String capitalDesignId) {
        try {
            List<Offer__c> offerList =  [SELECT Id, Name, OwnerId, Offer_Status__c,
	                                     Offer_Type__c, 
                                         Alternate_Sales_Engineer__c, 
                                         Opportunity__r.Id, 
                                         Opportunity__r.Alternate_Sales_Engineer__c, 
	                                     Opportunity__r.Sole_Provider__c,     
                                         Associated_Capital_Design__c,
                                         Associated_Capital_Design__r.Name,
                                         BRAIN_API_Call_Tracker_Master__c,
                                         Brain_ID__c,
                                         Brain_ID_Offer__c,
                                         Capital_Summation__c, 
                                         Expense_Summation__c,
                                         Capital_Summation_Offer__c, 
                                         Expense_Summation_Offer__c,
                                         CapEx_Direct__c,
                                 		 Cumulative_NPV__c,
                                         Discounted_Payback_months__c,
                                         EBITDA_Margin__c,
                                         Financial_Viability__c,
                                         IRR__c,
                                         Incremental_ATC_To_Meet_Guardrail__c,
                                         Simple_Payback_Months__c,
                                         X1st_Year_of_Positive_EBITDA__c,
                                         X1st_Year_of_Positive_FCF__c
                                    FROM Offer__c
                                   WHERE Id = :offerId
                                     AND Associated_Capital_Design__c = :capitalDesignId LIMIT 1];
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offer objects with Id "' + capitalDesignId + '"' + RETURNED_0_RECS);
            }
            return offerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListForCapEvalByOfferAndCDIds) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<Offer__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryOfferListForCapEvalByOfferAndCDIds) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryOfferListForCapEvalByOfferAndCDIds

    @AuraEnabled
    public static List<BRAIN_API_Call_Tracker__c> queryBACTListById(String bacTrackerId, String capDesignId) {
        try {
            List<BRAIN_API_Call_Tracker__c> bacTrackerList = [SELECT Id, Name, OwnerId, Offer__c, 
                              			 Capital_Design__c,
                              			 BRAIN_FA_Request__c,
                                         BRAIN_FA_Response__c,
                                         API_Transaction__c,
                                         CreatedById, LastModifiedById
                                    FROM BRAIN_API_Call_Tracker__c
                                   WHERE Id = :bacTrackerId 
                                     AND Capital_Design__c = :capDesignId LIMIT 1];
            if(bacTrackerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of BRAIN_API_Call_Tracker__c objects with Id "' + bacTrackerId + '"' + RETURNED_0_RECS);
            }
            return bacTrackerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryBACTListById) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<BRAIN_API_Call_Tracker__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryBACTListById) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryBACTListById

    @AuraEnabled
    public static List<BRAIN_API_Call_Tracker__c> queryBACTListByRequestId(String faRequestId) {
        try {
            List<BRAIN_API_Call_Tracker__c> bacTrackerList = [SELECT Id, Name, OwnerId, Offer__c, 
                              			 Capital_Design__c,
                              			 BRAIN_FA_Request__c,
                                         BRAIN_FA_Response__c,
                                         API_Transaction__c,
                                         CreatedById, LastModifiedById
                                    FROM BRAIN_API_Call_Tracker__c
                                   WHERE BRAIN_FA_Request__c = :faRequestId LIMIT 1];
            if(bacTrackerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of BRAIN_API_Call_Tracker__c objects with FARequestId "' + faRequestId + '"' + RETURNED_0_RECS);
            }
            return bacTrackerList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryBACTListById) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            List<BRAIN_API_Call_Tracker__c> callTrackerList = new List<BRAIN_API_Call_Tracker__c>(); 
            BRAIN_API_Call_Tracker__c ctFiller = new BRAIN_API_Call_Tracker__c();
            if (!String.isBlank(faRequestId)) { ctFiller.BRAIN_FA_Request__c = faRequestId; }
            callTrackerList.add(ctFiller);
            return callTrackerList;
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryBACTListById) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryBACTListByRequestId

    @AuraEnabled
    public static List<BRAIN_FA_Response__c> queryBFAResponseListById(String bfaResponseId, String bacTrackerId) {
        try {
            List<BRAIN_FA_Response__c> responseList = [SELECT Id, Name, OwnerId, BRAIN_ID__c,
                                         BRAIN_API_Call_Tracker_Master__c,
                                         hl1EvaluationResult__c,
                            			 errorCode__c, errorMessage__c,
                                         responseDate__c, status__c,
                                         CreatedById, LastModifiedById
                                    FROM BRAIN_FA_Response__c
                                   WHERE Id = :bfaResponseId 
                            		 AND BRAIN_API_Call_Tracker_Master__c = :bacTrackerId LIMIT 1];
            if(responseList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of BRAIN_FA_Response__c objects with Id "' + bfaResponseId + '"' + RETURNED_0_RECS);
            }
            return responseList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryBFAResponseListById) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<BRAIN_FA_Response__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryBFAResponseListById) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryBFAResponseListById

    @AuraEnabled    
    public static List<hl1EvaluationResult__c> queryHl1EvalResultByResponseId(String faResponseId) {
        try {            
			List<hl1EvaluationResult__c> hl1EvalResList = [SELECT Id, Name, 
                                           BRAIN_FA_Response_Master__c,
                                           firstYrOfPositiveCashFlow__c,
                                           firstYrOfPositiveEBITDA__c,
                                           totalOpExCashFlowPeriods__c,
                                           totalRevenueCashFlowPeriods__c,
                                           endingMRC__c,
                                           buildCost__c,
                                           cashFlowPeriod__c,
                                           financialMetric__c,
                                           financialMetric__r.incomeStatementMetric__c,
                                           financialMetric__r.cashFlowMetric__c,
                                           guardrailEvaluation__c
                                    FROM hl1EvaluationResult__c
                                   WHERE BRAIN_FA_Response_Master__c = :faResponseId LIMIT 1];
            if(hl1EvalResList == null || hl1EvalResList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of hl1EvaluationResult objects with BRAIN_FA_Response_Master-Id of ' + faResponseId + ' resulted in 0 records.');
            }
            return hl1EvalResList;
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryHl1EvalResultByResponseId) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryHl1EvalResultByResponseId
    
    @AuraEnabled    
    public static List<buildCost__c> queryBuildCostByHl1EvalResId(String hl1EvalResId) {
        
        try {            
			List<buildCost__c> buildCostList = 
                			[SELECT Id,  Name, 
                                         hl1EvaluationResultMaster__c,
                                         siteCount__c,
                                         projectCapEx__c,
                                         directCapEx__c,
                                         sharedCapEx__c,
                                         opExNRC__c,
                                         opExMRC__c,
                                         netExSharedMRC__c
                                    FROM buildCost__c
                                   WHERE hl1EvaluationResultMaster__c = :hl1EvalResId LIMIT 1];
            if(buildCostList == null || buildCostList.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  Query of buildCost objects with hl1EvaluationResultMaster-Id of ' + hl1EvalResId + RETURNED_0_RECS);
            }
	        return buildCostList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryBuildCostByHl1EvalResId) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<buildCost__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryBuildCostByHl1EvalResId) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryBuildCostByHl1EvalResId
    
    @AuraEnabled    
    public static List<cashFlowPeriod__c> queryCashFlowPeriodsByHl1EvalResId(String hl1EvalResId) {
        try {            
			List<cashFlowPeriod__c> cashFlowPeriodList = 
                					[SELECT Id, Name,
                                               contractMonth__c,
                                               currency__c,
                                               revenue__c,
                                               netExDirect__c,
                                               netExShared__c,
                                               opEx__c,
                                               capExDirect__c,
                                               capExSharedGammaAdjusted__c,
                                               incomeTax__c,
                                               hl1EvaluationResultMaster__c
                                          FROM cashFlowPeriod__c
                                         WHERE hl1EvaluationResultMaster__c = :hl1EvalResId LIMIT 1];
            
            if(cashFlowPeriodList == null || cashFlowPeriodList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of cashFlowPeriod objects with hl1EvaluationResultMaster-Id of ' + hl1EvalResId + ' resulted in 0 records.');
            }
	        return cashFlowPeriodList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryCashFlowPeriodsByHl1EvalResId) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<cashFlowPeriod__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryCashFlowPeriodsByHl1EvalResId) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryCashFlowPeriodsByHl1EvalResId
    
    @AuraEnabled
    public static List<financialMetric__c> queryFinMetricByHl1EvalResId(String hl1EvalResId) {
        try {            
			List<financialMetric__c> finMetricList = [SELECT Id, Name,
                                         hl1EvaluationResultMaster__c,
                                         incomeStatementMetric__c,
                                         cashFlowMetric__c
                                   FROM financialMetric__c
                                  WHERE hl1EvaluationResultMaster__c = :hl1EvalResId LIMIT 1];
            if(finMetricList == null || finMetricList.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  Query of financialMetric objects with hl1EvaluationResultMaster-Id of ' + hl1EvalResId + RETURNED_0_RECS);
            }
            return finMetricList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryFinMetricByHl1EvalResId) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<financialMetric__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryFinMetricByHl1EvalResId) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryFinMetricByHl1EvalResId
    
    @AuraEnabled
    public static List<incomeStatementMetric__c> queryIncStmtMetricByFinMetricId(String finMetricId) {
        try {            
			List<incomeStatementMetric__c> incomeStmtMetricList = 
                					[SELECT Id, Name,
                                              financialMetricMaster__c,
                                              currency__c,
                                              revenue__c,
                                              netExDirect__c,
                                              netExShared__c,
                                              grossMargin__c,
                                              grossMarginPct__c,
                                              opEx__c,
                                              ebitda__c,
                                              ebitdaPct__c,
                                              capExDirect__c,
                                              capExSharedGammaAdjusted__c,
                                              ebitdaLessCapEx__c,
                                              ebitdaLessCapExPct__c,
                                              incomeTax__c
                                        FROM incomeStatementMetric__c
                                       WHERE financialMetricMaster__c = :finMetricId LIMIT 1];
            if(incomeStmtMetricList == null || incomeStmtMetricList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of incomeStatementMetric objects with financialMetricMaster-Id of ' + finMetricId + RETURNED_0_RECS);
            }
            return incomeStmtMetricList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryIncStmtMetricByFinMetricId) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<incomeStatementMetric__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryIncStmtMetricByFinMetricId) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }        
    }//end method queryIncStmtMetricByFinMetricId
    
    @AuraEnabled
    public static List<cashFlowMetric__c> queryCashFlowMetricByFinMetricId(String finMetricId) {
        try {            
			List<cashFlowMetric__c> cashFlowMetricList = 
                					[SELECT Id, Name,
                                              financialMetricMaster__c,
                                              currency__c, 
                                              netPresentValue__c,
                                              discountedPaybackPeriodMonths__c,
                                              simplePaybackPeriodMonths__c,
                                              internalRateOfReturn__c,
                                              averageContractTermMonths__c
                                         FROM cashFlowMetric__c
                                        WHERE financialMetricMaster__c = :finMetricId LIMIT 1];
            if(cashFlowMetricList == null || cashFlowMetricList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of cashFlowMetric objects with financialMetricMaster-Id of ' + finMetricId + RETURNED_0_RECS);
            }
            return cashFlowMetricList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryCashFlowMetricByFinMetricId) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<cashFlowMetric__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryCashFlowMetricByFinMetricId) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryCashFlowMetricByFinMetricId
    
    @AuraEnabled    
    public static List<guardrailEvaluation__c> queryGuardrailEvalByHl1EvalResId(String hl1EvalResId) {
        
        try {            
			List<guardrailEvaluation__c> guardrailEvalList = [SELECT Id, Name, 
                                             hl1EvaluationResultMaster__c,
                                             resultCode__c,
                                             displayMessage__c,
                                             simplePaybackPeriodThresholdMonths__c,
                                             currencyCode__c,
                                             incrementalATCToMeetGuardrail__c
                                        FROM guardrailEvaluation__c
                                       WHERE hl1EvaluationResultMaster__c = :hl1EvalResId LIMIT 1];
            if(guardrailEvalList == null || guardrailEvalList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of guardrailEvaluation objects with hl1EvaluationResultMaster-Id of ' + hl1EvalResId + RETURNED_0_RECS);
            }
            return guardrailEvalList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryGuardrailEvalByHl1EvalResId) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<guardrailEvaluation__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryGuardrailEvalByHl1EvalResId) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryGuardrailEvalByHl1EvalResId

    @AuraEnabled
    public static List<hl1EvaluationResult__c> queryAssocHl1EvalList(String faResponseId, String hl1EvalResId) {
        try {            
			List<hl1EvaluationResult__c> hl1EvalResList = [SELECT Id, Name, 
                                          BRAIN_FA_Response_Master__c,
                                          firstYrOfPositiveCashFlow__c,
                                          firstYrOfPositiveEBITDA__c,
                                          totalOpExCashFlowPeriods__c,
                                          totalRevenueCashFlowPeriods__c,
                                          endingMRC__c,
                                          buildCost__c,
                                          cashFlowPeriod__c,
                                          financialMetric__c,
                                          financialMetric__r.incomeStatementMetric__c,
                                          financialMetric__r.cashFlowMetric__c,
                                          guardrailEvaluation__c
                                    FROM hl1EvaluationResult__c
                                   WHERE Id = :hl1EvalResId
                                     AND BRAIN_FA_Response_Master__c = :faResponseId LIMIT 1];
            if(hl1EvalResList == null || hl1EvalResList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of hl1EvaluationResult objects with Id of ' + hl1EvalResId + RETURNED_0_RECS);
            }
            return hl1EvalResList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryAssocHl1EvalList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<hl1EvaluationResult__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryAssocHl1EvalList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryAssocHl1EvalList
    
    @AuraEnabled    
    public static List<buildCost__c> queryAssocBuildCostList(String hl1EvalResId, String buildCostId) {
        
        try {            
			List<buildCost__c> buildCostList = 
                			[SELECT Id,  Name, 
                                         hl1EvaluationResultMaster__c,
                                         siteCount__c,
                                         projectCapEx__c,
                                         directCapEx__c,
                                         sharedCapEx__c,
                                         opExNRC__c,
                                         opExMRC__c,
                                         netExSharedMRC__c
                                    FROM buildCost__c
                                   WHERE Id = :buildCostId
                                     AND hl1EvaluationResultMaster__c = :hl1EvalResId LIMIT 1];
            if(buildCostList == null || buildCostList.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  Query of buildCost objects with buildCost-Id of ' + buildCostId + '  AND hl1EvaluationResultMaster-Id of ' + hl1EvalResId + RETURNED_0_RECS);
            }
	        return buildCostList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryAssocBuildCostList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<buildCost__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryAssocBuildCostList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryAssocBuildCostList
    
    @AuraEnabled
    public static List<financialMetric__c> queryAssocFinMetricList(String finMetricId, String hl1EvalResId) {
        try {            
            /***/
            System.debug('(queryAssocFinMetricList) finMetricId = ' + finMetricId + '  AND hl1EvalResId = ' + hl1EvalResId); 
            /***/
			List<financialMetric__c> finMetricList = [SELECT Id, Name,
                                         hl1EvaluationResultMaster__c,
                                         incomeStatementMetric__c,
                                         cashFlowMetric__c
                                   FROM financialMetric__c
                                  WHERE Id = :finMetricId
                                    AND hl1EvaluationResultMaster__c = :hl1EvalResId LIMIT 1];
            if(finMetricList == null || finMetricList.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  Query of financialMetric objects with hl1EvaluationResultMaster-Id of ' + hl1EvalResId + RETURNED_0_RECS);
            }
            return finMetricList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryAssocFinMetricList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<financialMetric__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryAssocFinMetricList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryAssocFinMetricList
    
    @AuraEnabled
    public static List<incomeStatementMetric__c> queryAssocIncStmtMetricList(String incStmtMetricId, String finMetricId) {
        try {            
			List<incomeStatementMetric__c> incomeStmtMetricList = [SELECT Id, Name,
                                              financialMetricMaster__c,
                                              currency__c,
                                              revenue__c,
                                              netExDirect__c,
                                              netExShared__c,
                                              grossMargin__c,
                                              grossMarginPct__c,
                                              opEx__c,
                                              ebitda__c,
                                              ebitdaPct__c,
                                              capExDirect__c,
                                              capExSharedGammaAdjusted__c,
                                              ebitdaLessCapEx__c,
                                              ebitdaLessCapExPct__c,
                                              incomeTax__c
                                        FROM incomeStatementMetric__c
                                       WHERE Id = :incStmtMetricId
                                         AND financialMetricMaster__c = :finMetricId LIMIT 1];
            if(incomeStmtMetricList == null || incomeStmtMetricList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of incomeStatementMetric objects with Id of ' + incStmtMetricId + RETURNED_0_RECS);
            }
            return incomeStmtMetricList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryAssocIncStmtMetricList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<incomeStatementMetric__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryAssocIncStmtMetricList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }        
    }//end method queryAssocIncStmtMetricList
    
    @AuraEnabled
    public static List<cashFlowMetric__c> queryAssocCashFlowMetricList(String cfMetricId, String finMetricId) {
        try {            
			List<cashFlowMetric__c> cashFlowMetricList = [SELECT Id, Name,
                                              financialMetricMaster__c,
                                              currency__c, 
                                              netPresentValue__c,
                                              discountedPaybackPeriodMonths__c,
                                              simplePaybackPeriodMonths__c,
                                              internalRateOfReturn__c,
                                              averageContractTermMonths__c
                                         FROM cashFlowMetric__c
                                        WHERE Id = :cfMetricId
                                          AND financialMetricMaster__c = :finMetricId LIMIT 1];
            if(cashFlowMetricList == null || cashFlowMetricList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of cashFlowMetric objects with Id of ' + cfMetricId + RETURNED_0_RECS);
            }
            return cashFlowMetricList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryAssocCashFlowMetricList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<cashFlowMetric__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryAssocCashFlowMetricList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryAssocCashFlowMetricList
    
    @AuraEnabled
    public static List<guardrailEvaluation__c> queryAssocGuardrailEvalList(String grEvalId, String hl1EvalResId) {
        try {            
			List<guardrailEvaluation__c> guardrailEvalList = [SELECT Id, Name, 
                                             hl1EvaluationResultMaster__c,
                                             resultCode__c,
                                             displayMessage__c,
                                             simplePaybackPeriodThresholdMonths__c,
                                             currencyCode__c,
                                             incrementalATCToMeetGuardrail__c
                                        FROM guardrailEvaluation__c
                                       WHERE Id = :grEvalId
                                         AND hl1EvaluationResultMaster__c = :hl1EvalResId LIMIT 1];
            if(guardrailEvalList == null || guardrailEvalList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of guardrailEvaluation objects with hl1EvaluationResultMaster-Id of ' + hl1EvalResId + RETURNED_0_RECS);
            }
            return guardrailEvalList;
        } catch(ZeroListException zeroX) {            
            System.debug('(BRAINFAObjectSOQLManager.queryAssocGuardrailEvalList) EXCEPTION! \n' + zeroX.getTypeName() + '\n' + zeroX.getMessage() + '\n' + zeroX.getLineNumber() + '\n' + zeroX.getStackTraceString());
            return new List<guardrailEvaluation__c>();
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryAssocGuardrailEvalList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }        
    }//end method queryAssocGuardrailEvalList    

    @AuraEnabled
    public static BRAIN_FA_Response__c queryForFinalFAResponse(String faResponseId) {
        List<BRAIN_FA_Response__c> finalFAResponseList = new List<BRAIN_FA_Response__c>();
        BRAIN_FA_Response__c finalFAResponse = new BRAIN_FA_Response__c();
        
        try {            
			finalFAResponseList = [SELECT Id, Name, 
                                           applicationVersion__c,
                                           baseFinancialAnalysisId__c,
                                           BRAIN_API_Call_Tracker_Master__c,
                                           BRAIN_ID__c,
                                           conversionScenarioId__c,
                                           costScenarioId__c,
                                           errorCode__c,
                                           errorMessage__c,
                                           forecastScenario__c,
                                           incremental__c,
                                           investmentFinancialAnalysisId__c,
                                           Request_ID__c,
                                           responseDate__c,
                                           salesRateScenarioId__c,
                                           status__c,
                                           survivalScenarioId__c,
                                           hl1EvaluationResult__c
                                   	 FROM BRAIN_FA_Response__c
                                    WHERE Id = :faResponseId LIMIT 1];
            
            finalFAResponse = (finalFAResponseList!=null && finalFAResponseList.size()>0) ? finalFAResponseList.get(0) : new BRAIN_FA_Response__c();
            if(finalFAResponseList == null || finalFAResponseList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of BRAIN_FA_Response objects with Id of ' + faResponseId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForFinalFAResponse) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
        }
        return finalFAResponse;
    }//end method queryForFinalFAResponse

    @AuraEnabled    
    public static hl1EvaluationResult__c queryForFinalHl1EvalResult(String faResponseId, String compHl1EvalResId) {
        List<hl1EvaluationResult__c> finalHl1EvalResList = new List<hl1EvaluationResult__c>();
        hl1EvaluationResult__c finalHl1EvalResult = new hl1EvaluationResult__c();
        
        try {            
			finalHl1EvalResList = [SELECT Id, Name, 
                                           BRAIN_FA_Response_Master__c,
                                           firstYrOfPositiveCashFlow__c,
                                           firstYrOfPositiveEBITDA__c,
                                           totalOpExCashFlowPeriods__c,
                                           totalRevenueCashFlowPeriods__c,
                                           endingMRC__c,
                                           buildCost__c,
                                           cashFlowPeriod__c,
                                           financialMetric__c,
                                           financialMetric__r.incomeStatementMetric__c,
                                           financialMetric__r.cashFlowMetric__c,
                                           guardrailEvaluation__c
                                    FROM hl1EvaluationResult__c
                                   WHERE BRAIN_FA_Response_Master__c = :faResponseId 
                                      OR Id = :compHl1EvalResId LIMIT 1];
            finalHl1EvalResult = (finalHl1EvalResList!=null && finalHl1EvalResList.size()>0) ? finalHl1EvalResList.get(0) : new hl1EvaluationResult__c();
            if(finalHl1EvalResList == null || finalHl1EvalResList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of hl1EvaluationResult objects with Id of ' + compHl1EvalResId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForFinalHl1EvalResult) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
        }
        return finalHl1EvalResult;
    }//end method queryForFinalHl1EvalResult
    
    @AuraEnabled    
    public static buildCost__c queryForFinalBuildCost(String hl1EvalResId, String compHl1EvalResId, String faHl1EvalResId) {
        List<buildCost__c> finalBuildCostList = new List<buildCost__c>();
        buildCost__c finalBuildCost = new buildCost__c();
        
        try {            
			finalBuildCostList = [SELECT Id, Name, 
                                          hl1EvaluationResultMaster__c,
                                          siteCount__c,
                                          projectCapEx__c,
                                          directCapEx__c,
                                          sharedCapEx__c,
                                          opExNRC__c,
                                          opExMRC__c,
                                          netExSharedMRC__c
                                    FROM buildCost__c
                                   WHERE hl1EvaluationResultMaster__c = :hl1EvalResId 
                                     OR hl1EvaluationResultMaster__c = :compHl1EvalResId
                                     OR hl1EvaluationResultMaster__c = :faHl1EvalResId LIMIT 1];
            
            finalBuildCost = (finalBuildCostList!=null && finalBuildCostList.size()>0) ? finalBuildCostList.get(0) : new buildCost__c();
            if(finalBuildCostList == null || finalBuildCostList.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  Query of buildCost objects with hl1EvaluationResultMaster-Id of ' + compHl1EvalResId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForFinalBuildCost) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
        }
        return finalBuildCost;
    }//end method queryForFinalBuildCost
    
    @AuraEnabled    
    public static List<cashFlowPeriod__c> queryForFinalCashFlowPeriodList(String hl1EvalResId, String compHl1EvalResId, String faHl1EvalResId) {
        List<cashFlowPeriod__c> finalCashFlowPeriodList = new List<cashFlowPeriod__c>();
        
        try {            
			finalCashFlowPeriodList = [SELECT Id, Name,
                                               contractMonth__c,
                                               currency__c,
                                               revenue__c,
                                               netExDirect__c,
                                               netExShared__c,
                                               opEx__c,
                                               capExDirect__c,
                                               capExSharedGammaAdjusted__c,
                                               incomeTax__c,
                                               hl1EvaluationResultMaster__c
                                          FROM cashFlowPeriod__c
                                         WHERE hl1EvaluationResultMaster__c = :hl1EvalResId 
                                            OR hl1EvaluationResultMaster__c = :compHl1EvalResId
                                            OR hl1EvaluationResultMaster__c = :faHl1EvalResId LIMIT 1];
            
            if(finalCashFlowPeriodList == null || finalCashFlowPeriodList.size() == 0) {
                finalCashFlowPeriodList = new List<cashFlowPeriod__c>();
                throw new ZeroListException('EXCEPTION!  Query of cashFlowPeriod objects with hl1EvaluationResultMaster-Id of ' + compHl1EvalResId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForFinalCashFlowPeriodList) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
        }
        return finalCashFlowPeriodList;
    }//end method queryForFinalCashFlowPeriodList
    
    @AuraEnabled    
    public static financialMetric__c queryForFinalFinMetric(String hl1EvalResId, String compHl1EvalResId, String faHl1EvalResId) {
        List<financialMetric__c> finalFinMetricList = new List<financialMetric__c>();
        financialMetric__c finalFinMetric = new financialMetric__c();
        
        try {            
			finalFinMetricList = [SELECT Id, Name,
                                          hl1EvaluationResultMaster__c,
                                          incomeStatementMetric__c,
                                          cashFlowMetric__c
                                   FROM financialMetric__c
                                  WHERE hl1EvaluationResultMaster__c = :hl1EvalResId 
                                     OR hl1EvaluationResultMaster__c = :compHl1EvalResId
                                     OR hl1EvaluationResultMaster__c = :faHl1EvalResId LIMIT 1];
            
            finalFinMetric = (finalFinMetricList!=null && finalFinMetricList.size()>0) ? finalFinMetricList.get(0) : new financialMetric__c();
            if(finalFinMetricList == null || finalFinMetricList.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  Query of financialMetric objects with hl1EvaluationResultMaster-Id of ' + compHl1EvalResId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForFinalFinMetric) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
        }
        return finalFinMetric;
    }//end method queryForFinalFinMetric
    
    @AuraEnabled    
    public static incomeStatementMetric__c queryForFinalIncStmtMetric(String finMetricId) {
        List<incomeStatementMetric__c> finalIncStmtMetricList = new List<incomeStatementMetric__c>();
        incomeStatementMetric__c finalIncStmtMetric = new incomeStatementMetric__c();
        
        try {            
			finalIncStmtMetricList = [SELECT Id, Name,
                                              financialMetricMaster__c,
                                              currency__c,
                                              revenue__c,
                                              netExDirect__c,
                                              netExShared__c,
                                              grossMargin__c,
                                              grossMarginPct__c,
                                              opEx__c,
                                              ebitda__c,
                                              ebitdaPct__c,
                                              capExDirect__c,
                                              capExSharedGammaAdjusted__c,
                                              ebitdaLessCapEx__c,
                                              ebitdaLessCapExPct__c,
                                              incomeTax__c
                                        FROM incomeStatementMetric__c
                                       WHERE financialMetricMaster__c = :finMetricId LIMIT 1];
            
            
            finalIncStmtMetric = (finalIncStmtMetricList!=null && finalIncStmtMetricList.size()>0) ? finalIncStmtMetricList.get(0) : new incomeStatementMetric__c();
            if(finalIncStmtMetricList == null || finalIncStmtMetricList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of incomeStatementMetric objects with Id of ' + finMetricId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForFinalIncStmtMetric) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
        }
        return finalIncStmtMetric;
    }//end method queryForFinalIncStmtMetric
    
    @AuraEnabled    
    public static cashFlowMetric__c queryForFinalCashFlowMetric(String finMetricId) {
        List<cashFlowMetric__c> finalCashFlowMetricList = new List<cashFlowMetric__c>();
        cashFlowMetric__c finalCashFlowMetric = new cashFlowMetric__c();
        
        try {            
			finalCashFlowMetricList = [SELECT Id, Name,
                                               financialMetricMaster__c,
                                               currency__c, 
                                               netPresentValue__c,
                                               discountedPaybackPeriodMonths__c,
                                               simplePaybackPeriodMonths__c,
                                               internalRateOfReturn__c,
                                               averageContractTermMonths__c
                                         FROM cashFlowMetric__c
                                        WHERE financialMetricMaster__c = :finMetricId LIMIT 1];
            
            finalCashFlowMetric = (finalCashFlowMetricList!=null && finalCashFlowMetricList.size()>0) ? finalCashFlowMetricList.get(0) : new cashFlowMetric__c();
            if(finalCashFlowMetricList == null || finalCashFlowMetricList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of cashFlowMetric objects with Id of ' + finMetricId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForFinalCashFlowMetric) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
        }
        return finalCashFlowMetric;
    }//end method queryForFinalCashFlowMetric
    
    @AuraEnabled    
    public static guardrailEvaluation__c queryForFinalGuardrailEval(String hl1EvalResId, String compHl1EvalResId, String faHl1EvalResId) {
        List<guardrailEvaluation__c> finalGuardrailEvalList = new List<guardrailEvaluation__c>();
        guardrailEvaluation__c finalGuardrailEval = new guardrailEvaluation__c();
        
        try {            
			finalGuardrailEvalList = [SELECT Id, Name, 
                                              hl1EvaluationResultMaster__c,
                                              resultCode__c,
                                              displayMessage__c,
                                              simplePaybackPeriodThresholdMonths__c,
                                              currencyCode__c,
                                              incrementalATCToMeetGuardrail__c
                                        FROM guardrailEvaluation__c
                                       WHERE hl1EvaluationResultMaster__c = :hl1EvalResId 
                                          OR hl1EvaluationResultMaster__c = :compHl1EvalResId
                                          OR hl1EvaluationResultMaster__c = :faHl1EvalResId LIMIT 1];
            
            finalGuardrailEval = (finalGuardrailEvalList!=null && finalGuardrailEvalList.size()>0) ? finalGuardrailEvalList.get(0) : new guardrailEvaluation__c();
            if(finalGuardrailEvalList == null || finalGuardrailEvalList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query of guardrailEvaluation objects with hl1EvaluationResultMaster-Id of ' + compHl1EvalResId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForFinalGuardrailEval) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
        }
        return finalGuardrailEval;
    }//end method queryForFinalGuardrailEval    
    
    @AuraEnabled    
    public static List<BRAIN_API_Call_Tracker__c> queryForFinalTracker(String faCallId) {
        List<BRAIN_API_Call_Tracker__c> finalTrackerList = new List<BRAIN_API_Call_Tracker__c>();
        
        try {            
			finalTrackerList = [SELECT Id, Name, OwnerId,
                                			Offer__c, Offer__r.Id, Offer__r.Name, Offer__r.Offer_Status__c,
                                            Offer__r.Capital_Summation__c, 
                                            Offer__r.Expense_Summation__c,
                                            Offer__r.Capital_Summation_Offer__c, 
                                            Offer__r.Expense_Summation_Offer__c,
                                            Capital_Design__c, Capital_Design__r.Id, Capital_Design__r.Name, 
                                            Capital_Design__r.Capital_Summation__c, Capital_Design__r.Expense_Summation__c,
                                            Capital_Design__r.Network_Investment__c,
                                            BRAIN_FA_Request__c, BRAIN_FA_Request__r.Id, BRAIN_FA_Request__r.Name,
                                            BRAIN_FA_Request__r.sourceSystemId__c, 
                                            BRAIN_FA_Request__r.opportunityTitle__c, 
                                            BRAIN_FA_Request__r.Constructed_JSON__c, 
                                            BRAIN_FA_Response__c, BRAIN_FA_Response__r.Id, BRAIN_FA_Response__r.Name,
                                            BRAIN_FA_Response__r.applicationVersion__c,
                                            BRAIN_FA_Response__r.baseFinancialAnalysisId__c,
                                            BRAIN_FA_Response__r.BRAIN_API_Call_Tracker_Master__c,
                                            BRAIN_FA_Response__r.BRAIN_ID__c,
                                            BRAIN_FA_Response__r.conversionScenarioId__c,
                                            BRAIN_FA_Response__r.costScenarioId__c,
                                            BRAIN_FA_Response__r.errorCode__c,
                                            BRAIN_FA_Response__r.errorMessage__c,
                                            BRAIN_FA_Response__r.forecastScenario__c,
                                            BRAIN_FA_Response__r.incremental__c,
                                            BRAIN_FA_Response__r.investmentFinancialAnalysisId__c,
                                            BRAIN_FA_Response__r.Request_ID__c,
                                            BRAIN_FA_Response__r.responseDate__c,
                                            BRAIN_FA_Response__r.salesRateScenarioId__c,
                                            BRAIN_FA_Response__r.status__c,
                                            BRAIN_FA_Response__r.survivalScenarioId__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.Id,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.Name,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.BRAIN_FA_Response_Master__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.firstYrOfPositiveCashFlow__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.firstYrOfPositiveEBITDA__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.totalOpExCashFlowPeriods__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.totalRevenueCashFlowPeriods__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.endingMRC__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.cashFlowPeriod__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__r.Id,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__r.Name,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__r.hl1EvaluationResultMaster__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__r.siteCount__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__r.projectCapEx__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__r.directCapEx__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__r.sharedCapEx__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__r.opExNRC__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__r.opExMRC__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.buildCost__r.netExSharedMRC__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.Id,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.Name,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.Id,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.Name,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.financialMetricMaster__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.currency__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.revenue__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.netExDirect__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.netExShared__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.grossMargin__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.grossMarginPct__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.opEx__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.ebitda__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.ebitdaPct__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.capExDirect__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.capExSharedGammaAdjusted__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.ebitdaLessCapEx__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.ebitdaLessCapExPct__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.incomeStatementMetric__r.incomeTax__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.Id,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.Name,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.financialMetricMaster__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.currency__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.netPresentValue__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.discountedPaybackPeriodMonths__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.simplePaybackPeriodMonths__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.internalRateOfReturn__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.financialMetric__r.cashFlowMetric__r.averageContractTermMonths__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__r.Id,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__r.Name,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__r.hl1EvaluationResultMaster__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__r.resultCode__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__r.displayMessage__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__r.simplePaybackPeriodThresholdMonths__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__r.currencyCode__c,
                                            BRAIN_FA_Response__r.hl1EvaluationResult__r.guardrailEvaluation__r.incrementalATCToMeetGuardrail__c
                                       FROM BRAIN_API_Call_Tracker__c 
                                      WHERE id = :faCallId LIMIT 1];   
            if(finalTrackerList == null || finalTrackerList.size() == 0) {
                finalTrackerList = new List<BRAIN_API_Call_Tracker__c>();
                throw new ZeroListException('EXCEPTION!  Query of BRAIN_AP_Call_Tracker objects with Id of ' + faCallId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectSOQLManager.queryForFinalTracker) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
        }
        return finalTrackerList;
    }//end method queryForFinalTracker
}//end class BRAINFAObjectSOQLManager