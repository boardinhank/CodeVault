/***************************************************************************************************
 * Name:  BRAINFAObjectDMLManager
 * Platform: Salesforce Connected Journey (SFCJ)
 * Manager class for SOQL and DML on objects of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFAObjectDMLManager
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 01/31/2023  	T2Cabato    ESCJ-2365	        			Base version derived from BRAINFAObjectDMLManager
 * 06/13/2023   T2Cabato    QFCJ-3801                       BRAIN-AutoSubmit-Messaging
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
 * 08/24/2023   T2Cabato    QFCJ-4264                       BRAIN-Run-as-NEW-DEVELOPMENT-when-ClusterNotAvailable-is-TRUE
 * 09/28/2023   T2Cabato    QFCJ-4625/26/27/28              BRAIN-Financial-Analysis-Failures
 * 01/24/2024   T2Cabato    QFCJ-4859                		BRAIN-Offer-Submission-when-CD-fails
****************************************************************************************************/
public with sharing class BRAINFAObjectDMLManager { 
    private class DmlException extends Exception {}
    private class NullObjectException extends Exception {}
    private class MismatchException extends Exception {}
    private static final String NO_PERMXNS_UPSERT = 'No permissions to create or update.';

    @AuraEnabled
    public static List<Offer__c> upsertOfferList(List<Offer__c> offerList) {
        
        try {
            if (Offer__c.SObjectType.getDescribe().isCreateable() == false && Offer__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (offerList == null || offerList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of Offer__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert offerList;
            System.debug('List of Offer__c records were upserted -->' + offerList.size());
	        return offerList;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertOfferList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
    }//end method upsertOfferList

    @AuraEnabled
    public static List<Capital_Design__c> upsertCapDesignList(List<Capital_Design__c> cdList) {
        
        try {
            if (Capital_Design__c.SObjectType.getDescribe().isCreateable() == false && Capital_Design__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (cdList == null || cdList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of Capital_Design__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert cdList;
            System.debug('List of Capital_Design__c records were upserted -->' + cdList.size());
	        return cdList;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertCapDesignList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
    }//end method upsertCapDesignList
    
    @AuraEnabled
    public static List<BRAIN_Automation_Fault__c> upsertBRAINAutoFaultList(List<BRAIN_Automation_Fault__c> faultList) {
        
        try {
            if (BRAIN_Automation_Fault__c.SObjectType.getDescribe().isCreateable() == false && BRAIN_Automation_Fault__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (faultList == null || faultList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of BRAIN_Automation_Fault__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert faultList;
            System.debug('List of BRAIN_Automation_Fault__c records were upserted -->' + faultList.size());
	        return faultList;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertBRAINAutoFaultList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
    }//end method upsertBRAINAutoFaultList
    
    @AuraEnabled
    public static List<BRAIN_API_CALL_TRACKER__c> upsertFACallList(List<BRAIN_API_CALL_TRACKER__c> callList) {
        
        try {
            if (BRAIN_API_CALL_TRACKER__c.SObjectType.getDescribe().isCreateable() == false && BRAIN_API_CALL_TRACKER__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (callList == null || callList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of BRAIN_API_CALL_TRACKER__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert callList;
            System.debug('List of BRAIN_API_CALL_TRACKER__c records were upserted -->' + callList.size());
	        return callList;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertFACallList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
    }//end method upsertFACallList
    
    @AuraEnabled
    public static List<BRAIN_FA_Request__c> upsertFARequestList(List<BRAIN_FA_Request__c> reqList) {
        
        try {
            if (BRAIN_FA_Request__c.SObjectType.getDescribe().isCreateable() == false && BRAIN_FA_Request__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (reqList == null || reqList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of BRAIN_FA_Request__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert reqList;
            System.debug('List of BRAIN_FA_Request__c records were upserted -->' + reqList.size());
	        return reqList;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertFARequestList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
    }//end method upsertFARequestList
    
    @AuraEnabled
    public static List<hl2Item__c> upsertHL2ItemList(List<hl2Item__c> hl2List) {
        
        try {
            if (hl2Item__c.SObjectType.getDescribe().isCreateable() == false && hl2Item__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (hl2List == null || hl2List?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of hl2Item__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert hl2List;
            System.debug('List of hl2Item__c records were upserted -->' + hl2List.size());
	        return hl2List;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertHL2ItemList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
    }//end method upsertHL2ItemList
    
    @AuraEnabled
    public static List<hl3Item__c> upsertHL3ItemList(List<hl3Item__c> hl3List) {
        
        try {
            if (hl3Item__c.SObjectType.getDescribe().isCreateable() == false && hl3Item__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (hl3List == null || hl3List?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of hl3Item__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert hl3List;
            System.debug('List of hl3Item__c records were upserted -->' + hl3List.size());
	        return hl3List;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertHL3ItemList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
    }//end method upsertHL3ItemList
    
    @AuraEnabled
    public static hl3ItemOverride__c upsertHL3ItemOverride(hl3ItemOverride__c hl3Override) {
        
        try {
            if (hl3ItemOverride__c.SObjectType.getDescribe().isCreateable() == false && hl3ItemOverride__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (hl3Override == null)
            {
                throw new NullObjectException('EXCEPTION!  The hl3ItemOverride__c object was NULL.  No create or update was possible.');       
            }
            upsert hl3Override;
            System.debug('The hl3ItemOverride__c record was upserted -->' + hl3Override.Id);
	        return hl3Override;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertHL3ItemOverrideList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
    }//end method upsertHL3ItemOverride
    
    @AuraEnabled
    public static MarketingFee__c upsertMarketingFee(MarketingFee__c marketingFeeAgrmt) {
        
        try {
            if (MarketingFee__c.SObjectType.getDescribe().isCreateable() == false && MarketingFee__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (marketingFeeAgrmt == null)
            {
                throw new NullObjectException('EXCEPTION!  The MarketingFee__c object was NULL.  No create or update was possible.');       
            }
            upsert marketingFeeAgrmt;
            System.debug('The MarketingFee__c record was upserted -->' + marketingFeeAgrmt.Id);
	        return marketingFeeAgrmt;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertMarketingAgreement) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
    }//end method upsertMarketingAgreement

    @AuraEnabled
    public static ServiceRevenueShare__c upsertServiceRevenueShare(ServiceRevenueShare__c serviceRevenueSharesAgrmt) {
        
        try {
            if (ServiceRevenueShare__c.SObjectType.getDescribe().isCreateable() == false && ServiceRevenueShare__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (serviceRevenueSharesAgrmt == null)
            {
                throw new NullObjectException('EXCEPTION!  The ServiceRevenueShare__c object was NULL.  No create or update was possible.');       
            }
            upsert serviceRevenueSharesAgrmt;
            System.debug('The ServiceRevenueShare__c record was upserted -->' + serviceRevenueSharesAgrmt.Id);
	        return serviceRevenueSharesAgrmt;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertServiceRevenueShare) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
    }//end method upsertServiceRevenueShare

    @AuraEnabled
    public static List<demographic__c> upsertDemographicList(List<demographic__c> demList) {
        
        try {
            if (demographic__c.SObjectType.getDescribe().isCreateable() == false && demographic__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (demList == null || demList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of demographic__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert demList;
            System.debug('List of demographic__c records were upserted -->' + demList.size());
	        return demList;
        } catch(Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertDemographicList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX        
        
    }//end method upsertDemographicList

    @AuraEnabled
    public static List<BRAIN_FA_Response__c> upsertFAResponseList(List<BRAIN_FA_Response__c> faResponseList){
        
        try {            
            if (BRAIN_FA_Response__c.SObjectType.getDescribe().isCreateable() == false && BRAIN_FA_Response__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (faResponseList == null || faResponseList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of BRAIN_FA_Response__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert faResponseList;
            System.debug('List of BRAIN_FA_Response__c records were upserted -->' + faResponseList.size());
	        return faResponseList;
        } catch (Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertFAResponseList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX

    }//end method upsertFAResponseList
    
    @AuraEnabled
    public static List<hl1EvaluationResult__c> upsertHL1EvalResultList(List<hl1EvaluationResult__c> respHL1EvalResultList){
        
        try {            
            if (hl1EvaluationResult__c.SObjectType.getDescribe().isCreateable() == false && hl1EvaluationResult__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (respHL1EvalResultList == null || respHL1EvalResultList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of hl1EvaluationResult__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert respHL1EvalResultList;
            System.debug('List of hl1EvaluationResult__c records were upserted -->' + respHL1EvalResultList.size());
	        return respHL1EvalResultList;
        } catch (Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertHL1EvalResultList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX

    }//end method upsertHL1EvalResultList
    
    @AuraEnabled
    public static List<buildCost__c> upsertBuildCostList(List<buildCost__c> respBuildCostList){
        
        try {            
            if (buildCost__c.SObjectType.getDescribe().isCreateable() == false && buildCost__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (respBuildCostList == null || respBuildCostList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of buildCost__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert respBuildCostList;
            System.debug('List of buildCost__c records were upserted -->' + respBuildCostList.size());
	        return respBuildCostList;
        } catch (Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertBuildCostList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX

    }//end method upsertBuildCostList
    
    @AuraEnabled
    public static List<cashFlowPeriod__c> upsertCashFlowPeriodList(List<cashFlowPeriod__c> respCashFlowPeriodList){
        
        try {            
            if (cashFlowPeriod__c.SObjectType.getDescribe().isCreateable() == false && cashFlowPeriod__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (respCashFlowPeriodList == null || respCashFlowPeriodList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of cashFlowPeriod__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert respCashFlowPeriodList;
            System.debug('List of cashFlowPeriod__c records were upserted -->' + respCashFlowPeriodList.size());
	        return respCashFlowPeriodList;
        } catch (Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertCashFlowPeriodList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX

    }//end method upsertCashFlowPeriodList
    
    @AuraEnabled
    public static List<financialMetric__c> upsertFinMetricList(List<financialMetric__c> respFinMetricList){
        
        try {            
            if (financialMetric__c.SObjectType.getDescribe().isCreateable() == false && financialMetric__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (respFinMetricList == null || respFinMetricList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of financialMetric__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert respFinMetricList;
            System.debug('List of financialMetric__c records were upserted -->' + respFinMetricList.size());
	        return respFinMetricList;
        } catch (Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertFinMetricList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX

    }//end method upsertFinMetricList
    
    @AuraEnabled
    public static List<cashFlowMetric__c> upsertCashFlowMetricList(List<cashFlowMetric__c> respCashFlowMetricList){
        
        try {            
            if (cashFlowMetric__c.SObjectType.getDescribe().isCreateable() == false && cashFlowMetric__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (respCashFlowMetricList == null || respCashFlowMetricList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of cashFlowMetric__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert respCashFlowMetricList;
            System.debug('List of cashFlowMetric__c records were upserted -->' + respCashFlowMetricList.size());
	        return respCashFlowMetricList;
        } catch (Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertCashFlowMetricList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX

    }//end method upsertCashFlowMetricList
    
    @AuraEnabled
    public static List<incomeStatementMetric__c> upsertIncStmtList(List<incomeStatementMetric__c> respIncMetricList){
        
        try {            
            if (incomeStatementMetric__c.SObjectType.getDescribe().isCreateable() == false && incomeStatementMetric__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (respIncMetricList == null || respIncMetricList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of incomeStatementMetric__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert respIncMetricList;
            System.debug('List of incomeStatementMetric__c records were upserted -->' + respIncMetricList.size());
	        return respIncMetricList;
        } catch (Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertIncStmtList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX

    }//end method upsertIncStmtList
    
    @AuraEnabled
    public static List<guardrailEvaluation__c> upsertGuardrailEvalList(List<guardrailEvaluation__c> respGrailEvalList){
        
        try {            
            if (guardrailEvaluation__c.SObjectType.getDescribe().isCreateable() == false && guardrailEvaluation__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException(NO_PERMXNS_UPSERT);
            }
            if (respGrailEvalList == null || respGrailEvalList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of guardrailEvaluation__c objects was NULL or was empty.  No create or update was possible.');       
            }
            upsert respGrailEvalList;
            System.debug('List of guardrailEvaluation__c records were upserted -->' + respGrailEvalList.size());
	        return respGrailEvalList;
        } catch (Exception methodX) {
            System.debug('(BRAINFAObjectDMLManager.upsertGuardrailEvalList) EXCEPTION! \n' + methodX.getTypeName() + '\n' + methodX.getMessage() + '\n' + methodX.getLineNumber() + '\n' + methodX.getStackTraceString());
            throw methodX;
        }//end catch methodX

    }//end method upsertGuardrailEvalList

    @AuraEnabled
    public static List<Capital_Design__c> updateCDFromBACT(List<BRAINFinancialAnalysesUpdateController.UpdateParams> updateParams) {
		
        try {
            if (Capital_Design__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException('No permissions to update.');
            }            

            Id capDesignId = updateParams.get(0).capDesignId;
            Id bacTrackerId = updateParams.get(0).bacTrackerId;            
            System.debug('(updateCDFromBACT) updateParams == null? ' + (updateParams == null) + '  AND updateParams?.size() = ' + updateParams?.size() + '  AND updateParams?.get(0)?.capDesignId = ' + updateParams?.get(0)?.capDesignId + '   AND updateParams?.get(0)?.bacTrackerId = ' + updateParams?.get(0)?.bacTrackerId); 
            List<Capital_Design__c> cdList = BRAINFAObjectSOQLManager.queryCapDesignListById(capDesignId);
            System.debug('(updateCDFromBACT) cdList == null? ' + (cdList == null) + '  AND cdList?.size() = ' + cdList?.size() + '  AND cdList?.get(0)?.Id = ' + cdList?.get(0)?.Id + '   AND cdList?.get(0)?.BRAIN_API_Call_Tracker_Master__c = ' + cdList?.get(0)?.BRAIN_API_Call_Tracker_Master__c); 
            //check if valid cdList to be able to continue with updates
            if (cdList == null || cdList.size() == 0 || cdList.get(0) == null) {
                throw new NullObjectException('EXCEPTION!  The Capital_Design__c object was NULL.  No update was possible.');       
            }
			//no exception thrown, so continue with updates
            List<BRAIN_API_Call_Tracker__c> bactList = BRAINFAObjectSOQLManager.queryBACTListById(bacTrackerId, capDesignId);
            System.debug('(updateCDFromBACT) bactList == null? ' + (bactList == null) + '  AND bactList?.size() = ' + bactList?.size() + '  AND bactList?.get(0)?.Id = ' + bactList?.get(0)?.Id + '  AND bactList?.get(0)?.Capital_Design__c = ' + bactList?.get(0)?.Capital_Design__c + '   AND bactList?.get(0)?.BRAIN_FA_Response__c = ' + bactList?.get(0)?.BRAIN_FA_Response__c); 
            List<BRAIN_FA_Response__c> faResponseList = BRAINFAObjectSOQLManager.queryBFAResponseListById(bactList.get(0).BRAIN_FA_Response__c, bacTrackerId);
            System.debug('(updateCDFromBACT) faResponseList == null? ' + (faResponseList == null) + '  AND faResponseList?.size() = ' + faResponseList?.size() + '  AND faResponseList?.get(0)?.Id = ' + faResponseList?.get(0)?.Id + '   AND faResponseList?.get(0)?.hl1EvaluationResult__c = ' + faResponseList?.get(0)?.hl1EvaluationResult__c); 
            //check if valid bactList and valid faResponseList to be able to continue with updates
            if (bactList?.get(0) == null || faResponseList?.get(0) == null || 
	                bactList?.get(0).BRAIN_FA_Response__c != faResponseList?.get(0).Id ||
    	            bactList?.get(0).Id != faResponseList?.get(0).BRAIN_API_Call_Tracker_Master__c) {
            	throw new NullObjectException('EXCEPTION! The BRAIN_API_Call_Tracker__c object or BRAIN_FA_Request__c object was NULL or DID NOT Match.');
            }
            System.debug('(updateCDFromBACT) cdList?.get(0)?.BRAIN_API_Call_Tracker_Master__c = ' + cdList?.get(0)?.BRAIN_API_Call_Tracker_Master__c + '   AND bactList?.get(0)?.Id = ' + bactList?.get(0)?.Id + '   AND (cdList?.get(0)?.BRAIN_API_Call_Tracker_Master__c == bactList?.get(0).Id)? ' + (cdList?.get(0)?.BRAIN_API_Call_Tracker_Master__c == bactList?.get(0).Id)); 
            //check if cdList bactId matches to bactList.id
            if (cdList?.get(0).BRAIN_API_Call_Tracker_Master__c != bactList?.get(0).Id) {
                throw new MismatchException('EXCEPTION! The BRAIN_API_Call_Tracker__c object does not match what is associated to the Capital_Design__c object to be updated.');
            }
            String assocHl1EvalResId = (faResponseList != null ? faResponseList.get(0) != null ? faResponseList.get(0).hl1EvaluationResult__c : ' ' : ' ');
            System.debug('(updateCDFromBACT) assocHl1EvalResId = ' + assocHl1EvalResId); 
            //check if errorMessage is null or "null" AND if hl1EvalResId is NOT BLANK
            if ((faResponseList?.get(0)?.errorMessage__c == null || faResponseList?.get(0)?.errorMessage__c.equalsIgnoreCase('null')) && !String.isBlank(assocHl1EvalResId)) {
                List<hl1EvaluationResult__c> hl1EvalList = BRAINFAObjectSOQLManager.queryAssocHl1EvalList(faResponseList.get(0).Id, assocHl1EvalResId);
                System.debug('(updateCDFromBACT) hl1EvalList == null? ' + (hl1EvalList == null) + '  AND hl1EvalList?.size() = ' + hl1EvalList?.size() + '  AND hl1EvalList?.get(0)?.Id = ' + hl1EvalList?.get(0)?.Id + '   AND hl1EvalList?.get(0)?.financialMetric__c = ' + hl1EvalList?.get(0)?.financialMetric__c); 
                String assocFinMetricId = (hl1EvalList != null ? hl1EvalList.get(0) != null ? hl1EvalList.get(0).financialMetric__c : ' ' : ' ');
                List<financialMetric__c> finMetricList = BRAINFAObjectSOQLManager.queryAssocFinMetricList(assocFinMetricId, assocHl1EvalResId);
                String assocCFMetricId = (finMetricList != null ? finMetricList.get(0) != null ? finMetricList.get(0).cashFlowMetric__c : ' ' : ' ');
                List<cashFlowMetric__c> cfMetricList = BRAINFAObjectSOQLManager.queryAssocCashFlowMetricList(assocCFMetricId, assocFinMetricId);
                String assocISMetricId = (finMetricList != null ? finMetricList.get(0) != null ? finMetricList.get(0).incomeStatementMetric__c : ' ' : ' ');
                List<incomeStatementMetric__c> incStmtList = BRAINFAObjectSOQLManager.queryAssocIncStmtMetricList(assocISMetricId, assocFinMetricId);
                String assocGREvalId = (hl1EvalList != null ? hl1EvalList.get(0) != null ? hl1EvalList.get(0).guardrailEvaluation__c : ' ' : ' ');
                List<guardrailEvaluation__c> grailList = BRAINFAObjectSOQLManager.queryAssocGuardrailEvalList(assocGREvalId, assocHl1EvalResId);
                cdList.get(0).BRAIN_ID__c = faResponseList?.get(0).BRAIN_ID__c;
                cdList.get(0).CapEx_Direct__c = incStmtList.get(0).capExDirect__c;
                cdList.get(0).Cumulative_NPV__c = cfMetricList.get(0).netPresentValue__c;
                cdList.get(0).Discounted_Payback_months__c = cfMetricList.get(0).discountedPaybackPeriodMonths__c;
                cdList.get(0).EBITDA_Margin__c = incStmtList.get(0).ebitdaPct__c;
                cdList.get(0).Ending_MRC__c = hl1EvalList.get(0).endingMRC__c;
                cdList.get(0).Financial_Viability__c = grailList.get(0).resultCode__c;
                cdList.get(0).IRR__c = cfMetricList.get(0).internalRateOfReturn__c;
                cdList.get(0).Incremental_ATC_To_Meet_Guardrail__c = grailList.get(0).incrementalATCToMeetGuardrail__c;
                cdList.get(0).Simple_Payback_Months__c = cfMetricList.get(0).simplePaybackPeriodMonths__c;
                cdList.get(0).X1st_Year_of_Positive_EBITDA__c = hl1EvalList.get(0).firstYrOfPositiveEBITDA__c;
                cdList.get(0).X1st_Year_of_Positive_FCF__c = hl1EvalList.get(0).firstYrOfPositiveCashFlow__c;
                cdList.get(0).Capital_Design_Stage__c = 'Capital Evaluation Complete';
                cdList.get(0).QueuedForBRAINFARun__c = false;
            }//end if NO Error returned from BRAIN API Call 
            update cdList;
            System.debug('(BRAINFAObjectDMLManager.updateCDFromBACT) Updated Outcome-Summary of Capital-Design ' + cdList.get(0).Name + ' (Id: ' + cdList.get(0).Id + ')');
            return cdList;
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectDMLManager.updateCDFromBACT) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }        
    }//end method updateCDFromBACT

    @AuraEnabled
    public static void updateOfferBAUFromBACT(List<Offer__c> offersToUpdateList, List<Capital_Design__c> assocCDList, List<BRAINFinancialAnalysesUpdateController.UpdateParams> updateParams) {
		
        try {
			Id capDesignId = updateParams.get(0).capDesignId;
            Id bacTrackerId = updateParams.get(0).bacTrackerId;            
            String callSource = updateParams.get(0).callSource;
            List<BRAIN_API_Call_Tracker__c> bactList = BRAINFAObjectSOQLManager.queryBACTListById(bacTrackerId, capDesignId);
            List<BRAIN_FA_Response__c> faResponseList = BRAINFAObjectSOQLManager.queryBFAResponseListById(bactList.get(0).BRAIN_FA_Response__c, bacTrackerId);
            if (Offer__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException('No permissions to update.');
            }
            if (offersToUpdateList == null || offersToUpdateList.size() == 0 || offersToUpdateList.get(0) == null) {
                throw new NullObjectException('EXCEPTION!  The Offer__c object was NULL.  No update was possible.');       
            }
            if (bactList == null || bactList.size() == 0 || bactList.get(0) == null) {
                throw new NullObjectException('EXCEPTION!  The BRAIN_API_Call_Tracker__c object was NULL.  No update was possible.');
            }
            if (faResponseList == null || faResponseList.size() == 0 || faResponseList.get(0) == null) {
                throw new NullObjectException('EXCEPTION!  The BRAIN_FA_Request__c object was NULL.  No update was possible.');
            }
            if (bactList?.get(0).BRAIN_FA_Response__c != faResponseList?.get(0).Id ||
    	            bactList?.get(0).Id != faResponseList?.get(0).BRAIN_API_Call_Tracker_Master__c) {
            	throw new NullObjectException('EXCEPTION! The BRAIN_API_Call_Tracker__c object and BRAIN_FA_Request__c object DID NOT Match. \n BACT-Id=' + bactList?.get(0).Id + ' WHILE BRAIN-Req.Master-BACT-Id=' + faResponseList?.get(0).BRAIN_API_Call_Tracker_Master__c + '\n BRAIN-Req.Id=' + faResponseList?.get(0).Id + '  WHILE BACT.Req-Id=' + bactList?.get(0).BRAIN_FA_Response__c);
            }
            if (offersToUpdateList.get(0).Associated_Capital_Design__c != assocCDList.get(0).Id || 
                    assocCDList.get(0).BRAIN_API_Call_Tracker_Master__c != bactList?.get(0).Id) {
                throw new MismatchException('EXCEPTION! The BRAIN_API_Call_Tracker__c object does not match what is associated to the Capital_Design__c object and the Capital_Design__c object does not match to the associated Capital_Design__c object on the Offer__c object to be updated.');
            }
            if (offersToUpdateList.get(0).Associated_Capital_Design__c == assocCDList.get(0).Id && 
                    !assocCDList.get(0).Capital_Design_Stage__c.equalsIgnoreCase('Capital Evaluation Complete') &&
               		!offersToUpdateList.get(0).Capital_Design_Status__c.equalsIgnoreCase('Capital_Evaluation_Complete')) {
                throw new MismatchException('EXCEPTION! The Associated Capital_Design__c of this Offer is in Capital_Design_Stage__c "' + assocCDList.get(0).Capital_Design_Stage__c + '", which is not "Capital Evaluation Complete" stage required to update the Offer Capital Evaluation from BRAIN results.  No update was possible.');
            }
            for (integer oCtr = 0; oCtr < offersToUpdateList.size(); oCtr++) {
	            if (faResponseList?.get(0)?.errorMessage__c == null || faResponseList?.get(0)?.errorMessage__c.equalsIgnoreCase('null')) {
                    String assocHl1EvalResId = (faResponseList != null ? faResponseList.get(0) != null ? faResponseList.get(0).hl1EvaluationResult__c : ' ' : ' ');
                    List<hl1EvaluationResult__c> hl1EvalList = BRAINFAObjectSOQLManager.queryAssocHl1EvalList(faResponseList.get(0).Id, assocHl1EvalResId);
                    String assocFinMetricId = (hl1EvalList != null ? hl1EvalList.get(0) != null ? hl1EvalList.get(0).financialMetric__c : ' ' : ' ');
                    List<financialMetric__c> finMetricList = BRAINFAObjectSOQLManager.queryAssocFinMetricList(assocFinMetricId, assocHl1EvalResId);
                    String assocCFMetricId = (finMetricList != null ? finMetricList.get(0) != null ? finMetricList.get(0).cashFlowMetric__c : ' ' : ' ');
                    List<cashFlowMetric__c> cfMetricList = BRAINFAObjectSOQLManager.queryAssocCashFlowMetricList(assocCFMetricId, assocFinMetricId);
                    String assocISMetricId = (finMetricList != null ? finMetricList.get(0) != null ? finMetricList.get(0).incomeStatementMetric__c : ' ' : ' ');
                    List<incomeStatementMetric__c> incStmtList = BRAINFAObjectSOQLManager.queryAssocIncStmtMetricList(assocISMetricId, assocFinMetricId);
                    String assocGREvalId = (hl1EvalList != null ? hl1EvalList.get(0) != null ? hl1EvalList.get(0).guardrailEvaluation__c : ' ' : ' ');
                    List<guardrailEvaluation__c> grailList = BRAINFAObjectSOQLManager.queryAssocGuardrailEvalList(assocGREvalId, assocHl1EvalResId);
                    offersToUpdateList.get(oCtr).BRAIN_ID__c = faResponseList?.get(0).BRAIN_ID__c;
                    offersToUpdateList.get(oCtr).CapEx_Direct__c = incStmtList.get(0).capExDirect__c;
                    offersToUpdateList.get(oCtr).Cumulative_NPV__c = cfMetricList.get(0).netPresentValue__c;
                    offersToUpdateList.get(oCtr).Discounted_Payback_months__c = cfMetricList.get(0).discountedPaybackPeriodMonths__c;
                    offersToUpdateList.get(oCtr).EBITDA_Margin__c = incStmtList.get(0).ebitdaPct__c;
                    offersToUpdateList.get(oCtr).Ending_MRC__c = hl1EvalList.get(0).endingMRC__c;
                    offersToUpdateList.get(oCtr).Financial_Viability__c = grailList.get(0).resultCode__c;
                    offersToUpdateList.get(oCtr).IRR__c = cfMetricList.get(0).internalRateOfReturn__c;
                    offersToUpdateList.get(oCtr).Incremental_ATC_To_Meet_Guardrail__c = grailList.get(0).incrementalATCToMeetGuardrail__c;
                    offersToUpdateList.get(oCtr).Simple_Payback_Months__c = cfMetricList.get(0).simplePaybackPeriodMonths__c;
                    offersToUpdateList.get(oCtr).X1st_Year_of_Positive_EBITDA__c = hl1EvalList.get(0).firstYrOfPositiveEBITDA__c;
                    offersToUpdateList.get(oCtr).X1st_Year_of_Positive_FCF__c = hl1EvalList.get(0).firstYrOfPositiveCashFlow__c;
                    offersToUpdateList.get(oCtr).Capital_Summation__c = assocCDList.get(0).Capital_Summation__c;
                    offersToUpdateList.get(oCtr).Expense_Summation__c = assocCDList.get(0).Expense_Summation__c;
                    offersToUpdateList.get(oCtr).Offer_Status__c = 'Capital Complete';
                }//end if NO Error returned from BRAIN API Call 
            }//end for-loop thru offersToUpdateList
            update offersToUpdateList;
            System.debug('(BRAINFAObjectDMLManager.updateOfferBAUFromBACT) Updated BAU of Capital Evaluation on ' + offersToUpdateList.size() + ' Offers!');
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectDMLManager.updateOfferBAUFromBACT) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
        }        
    }//end method updateOfferBAUFromBACT

    @AuraEnabled
    public static List<Offer__c> updateOfferCapEvalFromBACT(List<Offer__c> offersToUpdateList, List<BRAINFinancialAnalysesUpdateController.UpdateParams> updateParams) {
		
        try {
			Id capDesignId = updateParams.get(0).capDesignId;
            Id bacTrackerId = updateParams.get(0).bacTrackerId;
            String callSource = updateParams.get(0).callSource;
            List<BRAIN_API_Call_Tracker__c> bactList = BRAINFAObjectSOQLManager.queryBACTListById(bacTrackerId, capDesignId);
            List<BRAIN_FA_Response__c> faResponseList = BRAINFAObjectSOQLManager.queryBFAResponseListById(bactList.get(0).BRAIN_FA_Response__c, bacTrackerId);
            if (Offer__c.SObjectType.getDescribe().isUpdateable() == false) {
                throw new DmlException('No permissions to update.');
            }
            if (offersToUpdateList == null || offersToUpdateList.size() == 0 || offersToUpdateList.get(0) == null) {
                throw new NullObjectException('EXCEPTION!  The Offer__c object was NULL.  No update was possible.');       
            }
            if (bactList == null || bactList.size() == 0 || bactList.get(0) == null) {
                throw new NullObjectException('EXCEPTION!  The BRAIN_API_Call_Tracker__c object was NULL.  No update was possible.');
            }
            if (faResponseList == null || faResponseList.size() == 0 || faResponseList.get(0) == null) {
                throw new NullObjectException('EXCEPTION!  The BRAIN_FA_Request__c object was NULL.  No update was possible.');
            }
            if (bactList?.get(0).BRAIN_FA_Response__c != faResponseList?.get(0).Id ||
    	            bactList?.get(0).Id != faResponseList?.get(0).BRAIN_API_Call_Tracker_Master__c) {
            	throw new NullObjectException('EXCEPTION! The BRAIN_API_Call_Tracker__c object and BRAIN_FA_Request__c object DID NOT Match. \n BACT-Id=' + bactList?.get(0).Id + ' WHILE BRAIN-Req.Master-BACT-Id=' + faResponseList?.get(0).BRAIN_API_Call_Tracker_Master__c + '\n BRAIN-Req.Id=' + faResponseList?.get(0).Id + '  WHILE BACT.Req-Id=' + bactList?.get(0).BRAIN_FA_Response__c);
            }
            for (integer oCtr = 0; oCtr < offersToUpdateList.size(); oCtr++) {
	            if (faResponseList?.get(0)?.errorMessage__c == null || faResponseList?.get(0)?.errorMessage__c.equalsIgnoreCase('null')) {
                    String assocHl1EvalResId = (faResponseList != null ? faResponseList.get(0) != null ? faResponseList.get(0).hl1EvaluationResult__c : ' ' : ' ');
                    List<hl1EvaluationResult__c> hl1EvalList = BRAINFAObjectSOQLManager.queryAssocHl1EvalList(faResponseList.get(0).Id, assocHl1EvalResId);
                    String assocFinMetricId = (hl1EvalList != null ? hl1EvalList.get(0) != null ? hl1EvalList.get(0).financialMetric__c : ' ' : ' ');
                    List<financialMetric__c> finMetricList = BRAINFAObjectSOQLManager.queryAssocFinMetricList(assocFinMetricId, assocHl1EvalResId);
                    String assocCFMetricId = (finMetricList != null ? finMetricList.get(0) != null ? finMetricList.get(0).cashFlowMetric__c : ' ' : ' ');
                    List<cashFlowMetric__c> cfMetricList = BRAINFAObjectSOQLManager.queryAssocCashFlowMetricList(assocCFMetricId, assocFinMetricId);
                    String assocISMetricId = (finMetricList != null ? finMetricList.get(0) != null ? finMetricList.get(0).incomeStatementMetric__c : ' ' : ' ');
                    List<incomeStatementMetric__c> incStmtList = BRAINFAObjectSOQLManager.queryAssocIncStmtMetricList(assocISMetricId, assocFinMetricId);
                    String assocGREvalId = (hl1EvalList != null ? hl1EvalList.get(0) != null ? hl1EvalList.get(0).guardrailEvaluation__c : ' ' : ' ');
                    List<guardrailEvaluation__c> grailList = BRAINFAObjectSOQLManager.queryAssocGuardrailEvalList(assocGREvalId, assocHl1EvalResId);
	                System.debug('(BRAINFAObjectDMLManager.updateOfferCapEvalFromBACT) Capital Evaluation for Offer ' + offersToUpdateList.get(oCtr).Name + ' (' + offersToUpdateList.get(oCtr).Id + ')has following values: ' +
                                        '\n BRAIN_ID__c = ' + faResponseList?.get(0).BRAIN_ID__c +
                                        '\n capExDirect__c = ' + incStmtList.get(0).capExDirect__c +
                                        '\n netPresentValue__c = ' + cfMetricList.get(0).netPresentValue__c +
                                        '\n discountedPaybackPeriodMonths__c = ' + cfMetricList.get(0).discountedPaybackPeriodMonths__c +
                                        '\n ebitdaPct__c = ' + incStmtList.get(0).ebitdaPct__c +
                                        '\n endingMRC__c = ' + hl1EvalList.get(0).endingMRC__c +
                                        '\n resultCode__c = ' + grailList.get(0).resultCode__c +
                                        '\n internalRateOfReturn__c = ' + cfMetricList.get(0).internalRateOfReturn__c +
                                        '\n incrementalATCToMeetGuardrail__c = ' + grailList.get(0).incrementalATCToMeetGuardrail__c +
                                        '\n simplePaybackPeriodMonths__c = ' + cfMetricList.get(0).simplePaybackPeriodMonths__c +
                                        '\n firstYrOfPositiveEBITDA__c = ' + hl1EvalList.get(0).firstYrOfPositiveEBITDA__c +
                                        '\n firstYrOfPositiveCashFlow__c = ' + hl1EvalList.get(0).firstYrOfPositiveCashFlow__c);
                    offersToUpdateList.get(oCtr).BRAIN_ID_Offer__c = faResponseList?.get(0).BRAIN_ID__c;
                    offersToUpdateList.get(oCtr).CapEx_Direct_Offer__c = incStmtList.get(0).capExDirect__c;
                    offersToUpdateList.get(oCtr).Cumulative_NPV_Offer__c = cfMetricList.get(0).netPresentValue__c;
                    offersToUpdateList.get(oCtr).Discounted_Payback_months_Offer__c = cfMetricList.get(0).discountedPaybackPeriodMonths__c;
                    offersToUpdateList.get(oCtr).EBITDA_Margin_Offer__c = incStmtList.get(0).ebitdaPct__c;
                    offersToUpdateList.get(oCtr).Ending_MRC_Offer__c = hl1EvalList.get(0).endingMRC__c;
                    offersToUpdateList.get(oCtr).Financial_Viability_Offer__c = grailList.get(0).resultCode__c;
                    offersToUpdateList.get(oCtr).IRR_Offer__c = cfMetricList.get(0).internalRateOfReturn__c;
                    offersToUpdateList.get(oCtr).Incremental_ATC_To_Meet_Guardrail_Offe__c = grailList.get(0).incrementalATCToMeetGuardrail__c;
                    offersToUpdateList.get(oCtr).Simple_Payback_Months_Offer__c = cfMetricList.get(0).simplePaybackPeriodMonths__c;
                    offersToUpdateList.get(oCtr).X1st_Year_of_Positive_EBITDA_Offer__c = hl1EvalList.get(0).firstYrOfPositiveEBITDA__c;
                    offersToUpdateList.get(oCtr).X1st_Year_of_Positive_FCF_Offer__c = hl1EvalList.get(0).firstYrOfPositiveCashFlow__c;
                    offersToUpdateList.get(oCtr).Capital_Summation_Offer__c = offersToUpdateList.get(oCtr).Capital_Summation__c;
                    offersToUpdateList.get(oCtr).Expense_Summation_Offer__c = offersToUpdateList.get(oCtr).Expense_Summation__c;
                    if (callSource.equalsIgnoreCase('OFFER')) {
                        offersToUpdateList.get(oCtr).Offer_Status__c = 'Capital Complete';
                    }
                }//end if NO Error returned from BRAIN API Call 
            }//end for-loop thru offersToUpdateList
            update offersToUpdateList;
            System.debug('(BRAINFAObjectDMLManager.updateOfferCapEvalFromBACT) Updated Offer Capital Evaluation on ' + offersToUpdateList.size() + ' Offers!');
            return offersToUpdateList;
        } catch(Exception queryX) {
            System.debug('(BRAINFAObjectDMLManager.updateOfferCapEvalFromBACT) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }        
    }//end method updateOfferCapEvalFromBACT
}//end class BRAINFAObjectDMLManager