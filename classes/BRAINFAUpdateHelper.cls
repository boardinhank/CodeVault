/*************************************************************************************************** 
 * Name:  BRAINFAUpdateHelper
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for Updating CapDesign and/or Offer with results returned from call to 
 * 				BRAIN Financial Analyses
 * Code Coverage:  TestBRAINFAUpdateHelper
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 11/28/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version derived from BRAINFAUpdateHelper
****************************************************************************************************/
public class BRAINFAUpdateHelper {
    public class ZeroListException extends Exception {}
    public class NullCallAfterBuildException extends Exception {}
    public class NullObjectException extends Exception {}
    
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
                                        Total_SFH_Owner_Units_NM__c                                    FROM Capital_Design__c
                                   WHERE Id = :capitalDesignId LIMIT 1];
            if(capDesignList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Capital-Design objects with Id "' + capitalDesignId + '" returned 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAUpdateHelper.queryCapDesignListById) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        
        return capDesignList;
    }//end method queryCapDesignListById

    @AuraEnabled
    public static List<Offer__c> queryOfferListById(String offerId, String capitalDesignId) {
        List<Offer__c> offerList = new List<Offer__c>();
        try {
            offerList =  [SELECT Id, Name, OwnerId, Associated_Capital_Design__c,
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
                                         X1st_Year_of_Positive_FCF__c
                                    FROM Offer__c
                                   WHERE Id = :offerId
                                     AND Associated_Capital_Design__c = :capitalDesignId LIMIT 1];
            if(offerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of Offer objects with Id "' + capitalDesignId + '" returned 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAUpdateHelper.queryOfferListById) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        
        return offerList;
    }//end method queryOfferListById

    @AuraEnabled
    public static List<BRAIN_API_Call_Tracker__c> queryBACTListById(String bacTrackerId, String capDesignId) {
        List<BRAIN_API_Call_Tracker__c> bacTrackerList = new List<BRAIN_API_Call_Tracker__c>();
        try {
            bacTrackerList = [SELECT Id, Name, OwnerId, Offer__c, 
                              			 Capital_Design__c,
                              			 BRAIN_FA_Request__c,
                                         BRAIN_FA_Response__c,
                                         CreatedById, LastModifiedById
                                    FROM BRAIN_API_Call_Tracker__c
                                   WHERE Id = :bacTrackerId 
                                     AND Capital_Design__c = :capDesignId LIMIT 1];
            if(bacTrackerList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of BRAIN_API_Call_Tracker__c objects with Id "' + bacTrackerId + '" returned 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAUpdateHelper.queryBACTListById) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        
        return bacTrackerList;
    }//end method queryBACTListById

    @AuraEnabled
    public static List<BRAIN_FA_Response__c> queryBFAResponseListById(String bfaResponseId, String bacTrackerId) {
        List<BRAIN_FA_Response__c> responseList = new List<BRAIN_FA_Response__c>();
        try {
            responseList = [SELECT Id, Name, OwnerId, BRAIN_ID__c,
                                         BRAIN_API_Call_Tracker_Master__c,
                                         hl1EvaluationResult__c,
                            			 errorCode__c, errorMessage__c,
                                         responseDate__c, status__c,
                                         CreatedById, LastModifiedById
                                    FROM BRAIN_FA_Response__c
                                   WHERE Id = :bfaResponseId 
                            		 AND BRAIN_API_Call_Tracker_Master__c = :bacTrackerId LIMIT 1];
            if(responseList.size() == 0) {
                throw new ZeroListException('EXCEPTION!  Query for a list of BRAIN_FA_Response__c objects with Id "' + bfaResponseId + '" returned 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAUpdateHelper.queryBFAResponseListById) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        
        return responseList;
    }//end method queryBFAResponseListById

    @AuraEnabled
    public static List<hl1EvaluationResult__c> queryAssocHl1EvalList(String faResponseId, String hl1EvalResId) {
        List<hl1EvaluationResult__c> hl1EvalResList = new List<hl1EvaluationResult__c>();
        
        try {            
			hl1EvalResList = [SELECT Id, Name, 
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
                throw new ZeroListException('EXCEPTION!  Query of hl1EvaluationResult objects with Id of ' + hl1EvalResId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAResponseHelper.queryAssocHl1EvalList) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        return hl1EvalResList;
    }//end method queryAssocHl1EvalList
    
    @AuraEnabled
    public static List<financialMetric__c> queryAssocFinMetricList(String finMetricId, String hl1EvalResId) {
        List<financialMetric__c> finMetricList = new List<financialMetric__c>();
        
        try {            
			finMetricList = [SELECT Id, Name,
                                         hl1EvaluationResultMaster__c,
                                         incomeStatementMetric__c,
                                         cashFlowMetric__c
                                   FROM financialMetric__c
                                  WHERE Id = :finMetricId
                                    AND hl1EvaluationResultMaster__c = :hl1EvalResId LIMIT 1];
            if(finMetricList == null || finMetricList.size() == 0) {                
                throw new ZeroListException('EXCEPTION!  Query of financialMetric objects with hl1EvaluationResultMaster-Id of ' + hl1EvalResId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAResponseHelper.queryAssocFinMetricList) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        return finMetricList;
    }//end method queryAssocFinMetricList
    
    @AuraEnabled
    public static List<incomeStatementMetric__c> queryAssocIncStmtMetricList(String incStmtMetricId, String finMetricId) {
        List<incomeStatementMetric__c> incomeStmtMetricList = new List<incomeStatementMetric__c>();
        
        try {            
			incomeStmtMetricList = [SELECT Id, Name,
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
                throw new ZeroListException('EXCEPTION!  Query of incomeStatementMetric objects with Id of ' + incStmtMetricId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAResponseHelper.queryAssocIncStmtMetricList) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        return incomeStmtMetricList;
    }//end method queryAssocIncStmtMetricList
    
    @AuraEnabled
    public static List<cashFlowMetric__c> queryAssocCashFlowMetricList(String cfMetricId, String finMetricId) {
        List<cashFlowMetric__c> cashFlowMetricList = new List<cashFlowMetric__c>();
        
        try {            
			cashFlowMetricList = [SELECT Id, Name,
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
                throw new ZeroListException('EXCEPTION!  Query of cashFlowMetric objects with Id of ' + cfMetricId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAResponseHelper.queryAssocCashFlowMetricList) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        return cashFlowMetricList;
    }//end method queryAssocCashFlowMetricList
    
    @AuraEnabled
    public static List<guardrailEvaluation__c> queryAssocGuardrailEvalList(String grEvalId, String hl1EvalResId) {
        List<guardrailEvaluation__c> guardrailEvalList = new List<guardrailEvaluation__c>();
        
        try {            
			guardrailEvalList = [SELECT Id, Name, 
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
                throw new ZeroListException('EXCEPTION!  Query of guardrailEvaluation objects with hl1EvaluationResultMaster-Id of ' + hl1EvalResId + ' resulted in 0 records.');
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAResponseHelper.queryAssocGuardrailEvalList) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        return guardrailEvalList;
    }//end method queryAssocGuardrailEvalList    

    @AuraEnabled
    public static void updateCDFromBACT(Capital_Design__c cdToUpdate, BRAIN_API_Call_Tracker__c updatingBACT, 
                                        BRAIN_FA_Response__c updatingBFAResponse, hl1EvaluationResult__c updatingHL1Eval,
                                        financialMetric__c updatingFinMetric, cashFlowMetric__c updatingCFM,
										incomeStatementMetric__c updatingISM, guardrailEvaluation__c updatingGRE) {
		
        try {
            if (updatingBACT != null && updatingBFAResponse != null && 
	                updatingBACT.BRAIN_FA_Response__c == updatingBFAResponse.Id &&
    	            updatingBACT.Id == updatingBFAResponse.BRAIN_API_Call_Tracker_Master__c) {
                        
                if (cdToUpdate.BRAIN_API_Call_Tracker_Master__c == updatingBACT.Id) {
                    cdToUpdate.BRAIN_ID__c = updatingBFAResponse.BRAIN_ID__c;
                    cdToUpdate.CapEx_Direct__c = updatingISM.capExDirect__c;
                    cdToUpdate.Cumulative_NPV__c = updatingCFM.netPresentValue__c;
                    cdToUpdate.Discounted_Payback_months__c = updatingCFM.discountedPaybackPeriodMonths__c;
                    cdToUpdate.EBITDA_Margin__c = updatingISM.ebitdaPct__c;
					cdToUpdate.Ending_MRC__c = updatingHL1Eval.endingMRC__c;
                    cdToUpdate.Financial_Viability__c = updatingGRE.resultCode__c;
                    cdToUpdate.IRR__c = updatingCFM.internalRateOfReturn__c;
                    cdToUpdate.Incremental_ATC_To_Meet_Guardrail__c = updatingGRE.incrementalATCToMeetGuardrail__c;
                    cdToUpdate.Simple_Payback_Months__c = updatingCFM.simplePaybackPeriodMonths__c;
                    cdToUpdate.X1st_Year_of_Positive_EBITDA__c = updatingHL1Eval.firstYrOfPositiveEBITDA__c;
                    cdToUpdate.X1st_Year_of_Positive_FCF__c = updatingHL1Eval.firstYrOfPositiveCashFlow__c;
					update cdToUpdate;
                }
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAUpdateHelper.updateCDFromBACT) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        
    }//end method updateCDFromBACT

    @AuraEnabled
    public static void updateOfferBAUFromBACT(Offer__c offerToUpdate, Capital_Design__c assocCD, BRAIN_API_Call_Tracker__c updatingBACT, 
                                        BRAIN_FA_Response__c updatingBFAResponse, hl1EvaluationResult__c updatingHL1Eval,
                                        financialMetric__c updatingFinMetric, cashFlowMetric__c updatingCFM,
										incomeStatementMetric__c updatingISM, guardrailEvaluation__c updatingGRE) {
		
        try {
            if (updatingBACT != null && updatingBFAResponse != null && 
	                updatingBACT.BRAIN_FA_Response__c == updatingBFAResponse.Id &&
    	            updatingBACT.Id == updatingBFAResponse.BRAIN_API_Call_Tracker_Master__c) {
                        
                if (offerToUpdate.Associated_Capital_Design__c == assocCD.Id && 
                    assocCD.BRAIN_API_Call_Tracker_Master__c == updatingBACT.Id) {
                    offerToUpdate.BRAIN_ID__c = updatingBFAResponse.BRAIN_ID__c;
                    offerToUpdate.CapEx_Direct__c = updatingISM.capExDirect__c;
                    offerToUpdate.Cumulative_NPV__c = updatingCFM.netPresentValue__c;
                    offerToUpdate.Discounted_Payback_months__c = updatingCFM.discountedPaybackPeriodMonths__c;
                    offerToUpdate.EBITDA_Margin__c = updatingISM.ebitdaPct__c;
					offerToUpdate.Ending_MRC__c = updatingHL1Eval.endingMRC__c;
                    offerToUpdate.Financial_Viability__c = updatingGRE.resultCode__c;
                    offerToUpdate.IRR__c = updatingCFM.internalRateOfReturn__c;
                    offerToUpdate.Incremental_ATC_To_Meet_Guardrail__c = updatingGRE.incrementalATCToMeetGuardrail__c;
                    offerToUpdate.Simple_Payback_Months__c = updatingCFM.simplePaybackPeriodMonths__c;
                    offerToUpdate.X1st_Year_of_Positive_EBITDA__c = updatingHL1Eval.firstYrOfPositiveEBITDA__c;
                    offerToUpdate.X1st_Year_of_Positive_FCF__c = updatingHL1Eval.firstYrOfPositiveCashFlow__c;
					update offerToUpdate;
                }
            }
        } catch(Exception queryX) {
            System.debug('(BRAINFAUpdateHelper.updateOfferBAUFromBACT) EXCEPTION! \n Type: ' + queryX.getTypeName() + '\n Message:  ' + queryX.getMessage() + '\n Line#: ' + queryX.getLineNumber() + '\n StackTrace:  ' + queryX.getStackTraceString());
        }
        
    }//end method updateOfferBAUFromBACT

}//end class BRAINFAUpdateHelper