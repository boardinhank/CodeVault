/***************************************************************************************************
 * Name:  BRAINFARequestHelper
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for Request aspect of BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  TestBRAINFARequestHelper
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 06/23/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version derived from BRAINFARequestHelper
 * 01/27/2023   T2Cabato    Story ESCJ-2365                 Revised per Story
 * 07/05/2023   T2Cabato    QFCJ-4047                       BRAIN-Offer-Auto-Trigger-on-AutoSubmit
 * 08/02/2023   T2Cabato    QFCJ-4286                       BRAIN-Drop-Cost-Fix
 * 08/15/2023   T2Cabato    QFCJ-4282                       BRAIN-ONT-Model-Mapping
 * 08/15/2023   T2Cabato    QFCJ-4297                       BRAIN-UPS-Shelf-to-idfElectronics-for-BRAIN
 * 08/15/2023   T2Cabato    QFCJ-4309                       BRAIN-ContractType-and-OtherProviderContractType-Mapping
 * 08/24/2023   T2Cabato    QFCJ-4264                       BRAIN-Run-as-NEW-DEVELOPMENT-when-ClusterNotAvailable-is-TRUE
 * 08/30/2023   T2Cabato    QFCJ-4470                       BRAIN-Run-as-NEW-DEVELOPMENT-when-ClusterNotAvailable-is-TRUE-ALSO-for-NMA
 * 09/14/2023   T2Cabato    QFCJ-4512                       BRAIN-Correct-IW-BRAIN-mapping
 * 09/14/2023   T2Cabato    QFCJ-4514                       BRAIN-Set-Drop-Cost-Source
 * 09/18/2023   T2Cabato    QFCJ-4541                       BRAIN-NMA-Produt-to-TechType-Mapping
 * 09/28/2023   T2Cabato    QFCJ-4625/26/27/28              BRAIN-Financial-Analysis-Failures
 * 11/06/2023   T2Cabato    QFCJ-4706                       BRAIN-Error-for-F1-and-F2-Footage-value-being-ZERO
 * 12/10/2023   T2Cabato    QFCJ-4710                       BRAIN-Network-Investment-Cluster-ID-Mismatch-Errors
 * 12/19/2023   T2Cabato    QFCJ-4706-Reopen                Merge of QFCJ-4706 BRAIN-Code and QFCJ-4710 BRAIN-Code   
 * 01/08/2024   T2Cabato    QFCJ-4807                		BRAIN-Incorrect-Setting-of-baseContractType-Value
****************************************************************************************************/
public with sharing class BRAINFARequestHelper {
    private class NotValidToContinueException extends Exception {}
    private class ZeroListException extends Exception {}
    private class NullCallAfterBuildException extends Exception {}
    private class NullObjectException extends Exception {}
    private class InvalidNumericPicklistStringException extends Exception {}
    private static final String NON_MARKETING = 'Non-Marketing';
    private static final String CTL_ON = 'CTL_ON';
    private static final String CTLON = 'CTL ON';
    private static final String INSTANT_INTERNET = 'Instant Internet';
    private static final String FTTIDF_CAT5 = 'FTTIDF-Cat5';
    private static final String FTTIDF_GFAST = 'FTTIDF-G.Fast';
    private static final String INSTANT_WIFI = 'Instant Wi-Fi';
    
    @AuraEnabled
    public static String checkValidToContinue(String capitalDesignName) {
        try {
            List<Capital_Design__c> checkCDList = BRAINFAObjectSOQLManager.queryCapDesignList(capitalDesignName);
            if (checkCDList == null || checkCDList?.size() == 0)
            {
                throw new NullObjectException('EXCEPTION!  The List of Capital_Design__c objects was NULL or was empty for Capital-Design named "' + capitalDesignName + '"');       
            }
            if (checkCDList.get(0).Technology_Type__c != 'Instant Wi-Fi') {
                return 'VALID';
            }
            if (checkCDList.get(0).Access_Cost__c == null) {
                return 'INVALID!  When Technology-Type is "Instant Wi-Fi", the value of Access Cost" cannot be NULL, as it is currently unpopulated for Capital-Design named "' + capitalDesignName + '"';
            }
            if (checkCDList.get(0).BCET_Wire_Center__c == null) {
                return 'INVALID!  When Technology-Type is "Instant Wi-Fi", the value of "BCET Wire Center" cannot be NULL, as it is currently unpopulated for Capital-Design named "' + capitalDesignName + '"';
            }
            if (checkCDList.get(0).IP_CapEx_Shared__c == null) {
                return 'INVALID!  When Technology-Type is "Instant Wi-Fi", the value of "IP CapEx Shared" cannot be NULL, as it is currently unpopulated for Capital-Design named "' + capitalDesignName + '"';
            }
            if (checkCDList.get(0).IP_NetEx_Shared_MRC__c == null) {
                return 'INVALID!  When Technology-Type is "Instant Wi-Fi", the value of "IP NetEx Shared MRC" cannot be NULL, as it is currently unpopulated for Capital-Design named "' + capitalDesignName + '"';
            }
            if (checkCDList.get(0).One_Time_Additional_Expense__c == null) {
                return 'INVALID!  When Technology-Type is "Instant Wi-Fi", the value of "One Time Additional Expense" cannot be NULL, as it is currently unpopulated for Capital-Design named "' + capitalDesignName + '"';
            }
            if (checkCDList.get(0).Recurring_Additional_Expenses_Monthly__c == null) {
                return 'INVALID!  When Technology-Type is "Instant Wi-Fi", the value of "Recurring Additional Expenses Monthly" cannot be NULL, as it is currently unpopulated for Capital-Design named "' + capitalDesignName + '"';
            }
            if (checkCDList.get(0).Wireless_Access_Points_Cost__c == null) {
                return 'INVALID!  When Technology-Type is "Instant Wi-Fi", the value of "Wireless Access Points Cost" cannot be NULL, as it is currently unpopulated for Capital-Design named "' + capitalDesignName + '"';
            }
            return 'VALID';
        } catch(Exception  checkX) {
            System.debug('(BRAINFARequestHelper.checkValidToContinue) EXCEPTION! \n' + checkX.getTypeName() + '\n' + checkX.getMessage() + '\n' + checkX.getLineNumber() + '\n' + checkX.getStackTraceString());
            throw checkX;
        }//end catch
    }//end method checkValidToContinue

	@AuraEnabled
    public static BRAIN_API_Call_Tracker__c buildBaseFACall(String capitalDesignName, String offerId, String submitterCuid, String callSource) {
		List<Offer__c> callOfferList = new List<Offer__c>();
        List<BRAIN_API_Call_Tracker__c> faCallList = new List<BRAIN_API_Call_Tracker__c>();
    	BRAIN_API_Call_Tracker__c faCall = new BRAIN_API_Call_Tracker__c();
        List<Capital_Design__c> requestingCDList = new List<Capital_Design__c>();

        try {
            System.debug('(BRAINFARequestHelper.buildBaseFACall) capitalDesignName = ' + capitalDesignName + '  AND callSource = ' + callSource + '  AND with specified Offer-Id = ' + offerId);
            requestingCDList = BRAINFAObjectSOQLManager.queryBaseCallCapDesignListByName(capitalDesignName);
            if(requestingCDList != null && requestingCDList?.size() > 0 && requestingCDList?.get(0) != null) {
                if ((callSource.equalsIgnoreCase('offer') || callSource.equalsIgnoreCase('APVOFFER')) && String.isNotBlank(offerId)) {
                    callOfferList = BRAINFAObjectSOQLManager.queryBaseCallOfferList(capitalDesignName, offerId);
                }
                
		        System.debug('(BRAINFARequestHelper.buildBaseFACall) callOfferList is NULL? ' + (callOfferList == null) + '  AND callOfferList.size() = ' + callOfferList?.size());                
                if(callOfferList != null && callOfferList?.size() > 0) {
                    for(Offer__c offer: callOfferList) {
                        faCall.Offer__c = offer.Id;
                        faCall.OwnerId = offer.OwnerId;
                        faCall.Capital_Design__c = offer.Associated_Capital_Design__c;
                        faCallList.add(faCall);
                    }
                    faCallList = BRAINFAObjectDMLManager.upsertFACallList(faCallList);
                    System.debug('(BRAINFARequestHelper.buildBaseFACall) faCallList is NULL? ' + (faCallList==null) + ' \n faCallList?.size() = ' + faCallList?.size() + ' \n faCallList.get(0).Id = ' + ((faCallList!=null && faCallList.size()>=0 && faCallList.get(0)!=null) ? faCallList.get(0).Id : null));
                    faCall = [SELECT Id, Name, Offer__c, OwnerId, Capital_Design__c, Capital_Design__r.Name, BRAIN_FA_Request__c FROM BRAIN_API_Call_Tracker__c WHERE id = :faCallList.get(0).Id WITH SECURITY_ENFORCED];
                    for(Offer__c offer: callOfferList) {
                        offer.BRAIN_API_Call_Tracker_Master__c = faCallList?.get(0)?.Id;
                    }
                    update callOfferList;
                    
                    requestingCDList.get(0).Last_Associated_BRAIN_FA_Call__c = faCall?.Id;
                    requestingCDList.get(0).BRAIN_API_Call_Tracker_Master__c = faCall?.Id;
		            if(Test.isRunningTest()) {
                        try {
						    CapitalDesignTriggerHandler.TriggerDisabled = true;
                            requestingCDList = BRAINFAObjectDMLManager.upsertCapDesignList(requestingCDList);  
						    CapitalDesignTriggerHandler.TriggerDisabled = false;
                        } catch (Exception dmlX) {
                            System.debug('(BRAINFARequestHelper.buildBaseFACall) EXCEPTION! \n' + dmlX.getTypeName() + '\n' + dmlX.getMessage() + '\n' + dmlX.getLineNumber() + '\n' + dmlX.getStackTraceString());
                        }
                    } else {
					    CapitalDesignTriggerHandler.TriggerDisabled = true;
	                    requestingCDList = BRAINFAObjectDMLManager.upsertCapDesignList(requestingCDList);  
					    CapitalDesignTriggerHandler.TriggerDisabled = false;
                    }
                    List<Capital_Design__c> checkCDList = BRAINFAObjectSOQLManager.queryBaseCallCapDesignListById(requestingCDList?.get(0)?.Id);
                    Capital_Design__c checkCD = (checkCDList?.size()>=1 ? checkCDList?.get(0) : new Capital_Design__c());
                    System.debug('(BRAINFARequestHelper.buildBaseFACall)AFTER BRAINFAObjectSOQLManager.query: checkCD.Id = ' + checkCD?.Id + 
                                 '\n checkCD.Name = ' + checkCD?.Name +
                                 '\n checkCD.BRAIN_API_Call_Tracker_Master__c = ' + checkCD?.BRAIN_API_Call_Tracker_Master__c +
                                 '\n checkCD.Last_Associated_BRAIN_FA_Call__c = ' + checkCD?.Last_Associated_BRAIN_FA_Call__c);
                    return faCall;
                }//end if callOfferList!=null && callOfferList size > 0

                System.debug('(BRAINFARequestHelper.buildBaseFACall)No Offers associated to Capital-Design "' + capitalDesignName + '" AND with specified Offer-Id "' + offerId + '"');
                //since callOfferList was either NULL or callOfferList size was NOT > 0, then the method has not yet returned faCall, thus continue
                faCall = new BRAIN_API_Call_Tracker__c();
                faCall.OwnerId = requestingCDList?.get(0).OwnerId;
                faCall.Capital_Design__c = requestingCDList?.get(0).Id;
                faCallList = new List<BRAIN_API_CALL_TRACKER__c>();
                faCallList.add(faCall);
                faCallList = BRAINFAObjectDMLManager.upsertFACallList(faCallList);
                faCall = faCallList.get(0);
                requestingCDList.get(0).Last_Associated_BRAIN_FA_Call__c = faCallList?.get(0).Id;
                requestingCDList.get(0).BRAIN_API_Call_Tracker_Master__c = faCallList?.get(0).Id;
                if(Test.isRunningTest()) {
                    try {
                        requestingCDList = BRAINFAObjectDMLManager.upsertCapDesignList(requestingCDList);  
                    } catch (Exception dmlX) {
                        System.debug('(BRAINFARequestHelper.buildBaseFACall) EXCEPTION! \n' + dmlX.getTypeName() + '\n' + dmlX.getMessage() + '\n' + dmlX.getLineNumber() + '\n' + dmlX.getStackTraceString());
                    }
                } else {
                    requestingCDList = BRAINFAObjectDMLManager.upsertCapDesignList(requestingCDList);  
                }
                return faCall;
            }//end if requestingCDList was NOT NULL and list size > 0 and first item in list was NOT NULL

            System.debug('(BRAINFARequestHelper.buildBaseFACall)No Capital-Designs found with Name: ' + capitalDesignName);
            //since requestingCDList size was NULL or NOT > 0 or first item in list was NULL, 
            //	then the method has not yet returned faCall, thus continue
            faCall = new BRAIN_API_Call_Tracker__c();
            faCallList = new List<BRAIN_API_CALL_TRACKER__c>();
            faCallList.add(faCall);
            faCallList = BRAINFAObjectDMLManager.upsertFACallList(faCallList);
            faCall = faCallList.get(0);
	        return faCall;
        } catch(Exception  buildBaseCallX) {
            System.debug('(BRAINFARequestHelper.buildBaseFACall) EXCEPTION! \n' + buildBaseCallX.getTypeName() + '\n' + buildBaseCallX.getMessage() + '\n' + buildBaseCallX.getLineNumber() + '\n' + buildBaseCallX.getStackTraceString());
            throw buildBaseCallX;
        }//end catch
    }//end method buildBaseFACall

    @AuraEnabled
    public static BRAIN_FA_Request__c composeFARequest(List<BRAINFinancialAnalysesRequestController.RequestParams> requestParams, BRAIN_API_Call_Tracker__c faCallMaster) {
        List<BRAIN_API_Call_Tracker__c> faCallMasterList = new List<BRAIN_API_Call_Tracker__c>();
        List<BRAIN_FA_Request__c> faReqList = new List<BRAIN_FA_Request__c>();
        BRAIN_FA_Request__c faRequest = new BRAIN_FA_Request__c();
        String capitalDesignId = null;

        try {
                /*********************************************
                 * For agreements, need to add the following additional data to the Request
                 *     Agreement Type is contractType/baseContractType (see below) in BRAIN Request mapped to Offer_Type__c in object Offer__c
                 *     Term is contractTermMonths in BRAIN Request mapped to Contract_Term__c in object Offer__c
                 *     Door Fee is doorFeePerUnit in BRAIN Request mapped to Door_Fee__c in object Capital_Design__c
                 *     Bounty (Owner Occupied greenfield only) (aka, First Install Bounty) is firstInstallBountyPerUnit in BRAIN Request mapped to Data_Bounty_Amount_Approved__c in Offer__c
                 *     Revenue Share (if Rental Marketing Agreement) is serviceRevenueShare object under marketingFeeAgrmts/baseMarketingFeeAgrmts (see below) in BRAIN Request
                 *         Revenue Share (3 elements for Sole Provider, EMA and SMA): 
                 *              1) Min Penetration Percentage is minPenetrationRate in BRAIN Request mapped to ???
                 *              2) Max Penetration Percentage is maxPenetrationRate in BRAIN Request mapped to ???
                 *              3) Agent Commission Percentage is agentCommissionRate in BRAIN Request mapped to ???
                 *     Bulk Speed (Bulk Only) (aka, Bulk Downstream Speed) is bulkDownstreamKbps/baseBulkDownstreamKbps (see below) in BRAIN Request mapped to Bulk_Data_Speed_Profile_DL_UL_Approv__c in Offer__c
                 *     Bulk Price (Bulk Only) (aka, Bulk Monthly Revenue Per Unit) is bulkRevenueMrcPerUnit/baseBulkRevenueMrcPerUnit (see below) in BRAIN Request mapped to Requested_Bulk_Data_Price_Approved__c in Offer__c
                 *     Cluster ID (if brownfield) is clusterId in BRAIN Request mapped to ???
                 *     Contract End Date  (if Sole Provider,EMA, SMA or Bulk) is baseContractEndDate (see below) in BRAIN Request mapped to EndDate in Contract
                 * 
                 * To help explain regular vs base -- base if for an existing contract while regular is for new/future "wants" to be analyzed 
                 *    That being the definition of base, then if a customer was currently under an EMA,
                 *    that existing contract would be placed in the baseContractType while a newly desired contract would be placed in contractType
                 * 
                 * Additionally, when we model Brownfields, if you select a Network Investment Type of "Product" or "Speed", 
                 *     then the BRAIN user Interface opens up the Base Case and Investment Case fields
                 * 
                 * 
                 * ******************************************/
            String capitalDesignName = requestParams?.get(0)?.capDesignName;
            String offerId = requestParams?.get(0)?.offerId;
            String submitterCuid = requestParams?.get(0)?.submitterCuid;
            String callSource = requestParams?.get(0)?.callSource;
            List<Capital_Design__c> capDesignList = BRAINFAObjectSOQLManager.queryBaseCallCapDesignListByName(capitalDesignName);
            System.debug('(composeFARequest) capDesignList is NULL? ' + (capDesignList==null) + ' \n capDesignList.size() = ' + capDesignList.size() + 
                        			' \n capDesignList?.get(0) is NULL? ' + (capDesignList!=null && capDesignList.size()>0 && capDesignList?.get(0)==null) + 
                         			' \n capDesignList.get(0).Id = ' + (capDesignList!=null && capDesignList.size()>0 && capDesignList?.get(0)!=null ? capDesignList?.get(0)?.Id : null) +
                         			' \n capDesignList.get(0).Opportunity__c = ' + (capDesignList!=null && capDesignList.size()>0 && capDesignList?.get(0)!=null ? capDesignList?.get(0)?.Opportunity__c : null) +
                         			' \n capDesignList.get(0).Capital_Design_Type__c = ' + (capDesignList!=null && capDesignList.size()>0 && capDesignList?.get(0)!=null ? capDesignList?.get(0)?.Capital_Design_Type__c : null) +
                        			' \n capDesignList.get(0).Capital_Design_Type__c.equalsIgnoreCase("Non-Marketing")? ' + (capDesignList!=null && capDesignList.size()>0 && capDesignList?.get(0)!=null && capDesignList.get(0).Capital_Design_Type__c.equalsIgnoreCase('Non-Marketing')));
            if (capDesignList != null && capDesignList.size() > 0 && capDesignList.get(0) != null && capDesignList.get(0).Id != null && capDesignList.get(0).Capital_Design_Type__c?.equalsIgnoreCase(NON_MARKETING)) {
                capitalDesignId = capDesignList.get(0).Id;
                capDesignList = BRAINFAObjectSOQLManager.queryNMACapDesignListById(capitalDesignId);
                faRequest = composeFromCapDesignData(capDesignList?.get(0), null, callSource);
                if (faRequest == null) {
                    faRequest = new BRAIN_FA_Request__c();
                }
                faRequest.BRAIN_API_Call_Tracker_Master__c = (faCallMaster != null ? faCallMaster?.Id : null);
                faRequest.cuid__c = submitterCuid;
                faRequest.Constructed_JSON__c = constructJSONFromRequestObj(faRequest, callSource);                    

                faReqList.add(faRequest);
                //upsert method throws exception if DML error or list is NULL, so no need to test for NULL afterward
                faReqList = BRAINFAObjectDMLManager.upsertFARequestList(faReqList);
                
                //associate the newly inserted faRequest as child to faCallMaster by faRequest.Id
                faCallMaster.BRAIN_FA_Request__c = faReqList?.get(0)?.Id;
                faCallMasterList.add(faCallMaster);
                //upsert method throws exception if DML error or list is NULL, so no need to test for NULL afterward
                faCallMasterList = BRAINFAObjectDMLManager.upsertFACallList(faCallMasterList);
                    
                //query method throws exception if SOQL error or retrieved object is NULL, so no need to test for NULL afterward
                faRequest = BRAINFAObjectSOQLManager.queryFARequestById(faReqList?.get(0)?.Id);
                /*************************************************************************
                 *    System.debug('AFTER BRAINFAObjectSOQLManager.query: faRequest.Id = ' + faRequest.Id + 
                 *                 '\n faRequest.Name = ' + faRequest.Name +
                 *                 '\n faRequest.BRAIN_API_Call_Tracker_Master__c = ' + faRequest.BRAIN_API_Call_Tracker_Master__c +
                 *                 '\n faRequest.Constructed_JSON__c = ' + faRequest.Constructed_JSON__c);
				 *************************************************************************/
		        return faRequest;
            }//end if cap-design list is NOT NULL and size > 0 and first item in list is NOT NULL and type was Non-Marketing
            
            //since capitalDesignList NOT NULL and size > 0 and first item in list is NOT NULL and type was Non-Marketing, 
            //	then the method has not yet returned faRequest, thus continue
            
            List<Opportunity> associatedOpptyList = BRAINFAObjectSOQLManager.queryAssociatedOpptyList(capDesignList.get(0).Opportunity__c);
            if (associatedOpptyList?.size() == 0) {
                throw new ZeroListException('No Opportunities were associated to Capital Design named ' + capitalDesignName);
            }//end list size is 0,, ZeroListException thrown
            
            //since associatedOpptyList NOT NULL and size == 0, then the method has not yet returned faRequest, thus continue
            List<Offer__c> offerList = new List<Offer__c>();
			System.debug('(BRAINFARequestHelper.composeFARequest) callSource = ' + callSource + '   AND Capital_Design_Type__c = ' + ((capDesignList != null && capDesignList.size() > 0 && capDesignList.get(0) != null) ? capDesignList.get(0).Capital_Design_Type__c : null));
            if (callSource.equalsIgnoreCase('APVOFFER') && capDesignList != null && capDesignList.size() > 0 && capDesignList.get(0) != null && capDesignList.get(0).Id != null && !capDesignList.get(0).Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {    
	            offerList = BRAINFAObjectSOQLManager.queryOfferListForBRAINFAApprovedDetailsByIdForAssociatedCD(offerId, capitalDesignName);                
	            System.debug('(BRAINFARequestHelper.composeFARequestForAgrmt) APVOFFER - offerList.size() = ' + offerList.size());
                faRequest = composeFromOfferDataApproved(offerList?.get(0), associatedOpptyList?.get(0), callSource);
                if (faRequest == null) {
                    faRequest = new BRAIN_FA_Request__c();
                }
                faRequest.BRAIN_API_Call_Tracker_Master__c = (faCallMaster != null ? faCallMaster?.Id : null);
                faRequest.cuid__c = submitterCuid;
                String tempJSON = '';
                try {
                	tempJSON = constructJSONFromRequestObj(faRequest, callSource);
                } catch (Exception jsonX) {
					System.debug('(BRAINFARequestHelper.composeFARequest) EXCEPTION! \n' + jsonX.getTypeName() + '\n' + jsonX.getMessage() + '\n' + jsonX.getLineNumber() + '\n' + jsonX.getStackTraceString());
                }
                faRequest.Constructed_JSON__c = tempJSON;
                
                faReqList.add(faRequest);
                //upsert method throws exception if DML error or list is NULL, so no need to test for NULL afterward
                faReqList = BRAINFAObjectDMLManager.upsertFARequestList(faReqList);
                
                //associate the newly inserted faRequest as child to faCallMaster by faRequest.Id
                faCallMaster.BRAIN_FA_Request__c = faReqList?.get(0)?.Id;
                faCallMasterList.add(faCallMaster);
                //upsert method throws exception if DML error or list is NULL, so no need to test for NULL afterward
                faCallMasterList = BRAINFAObjectDMLManager.upsertFACallList(faCallMasterList);
                
                //query method throws exception if SOQL error or retrieved object is NULL, so no need to test for NULL afterward
                faRequest = BRAINFAObjectSOQLManager.queryFARequestById(faReqList?.get(0)?.Id);
                return faRequest;
            }
            if (callSource.equalsIgnoreCase('OFFER') && capDesignList != null && capDesignList.size() > 0 && capDesignList.get(0) != null && capDesignList.get(0).Id != null && !capDesignList.get(0).Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {    
				offerList = BRAINFAObjectSOQLManager.queryOfferListByIdForAssociatedCD(offerId, capitalDesignName);                
	            System.debug('(BRAINFARequestHelper.composeFARequestForAgrmt) OFFER - offerList.size() = ' + offerList.size());
                faRequest = composeFromOfferDataRequested(offerList?.get(0), associatedOpptyList?.get(0), callSource);
                if (faRequest == null) {
                    faRequest = new BRAIN_FA_Request__c();
                }
                faRequest.BRAIN_API_Call_Tracker_Master__c = (faCallMaster != null ? faCallMaster?.Id : null);
                faRequest.cuid__c = submitterCuid;
                String tempJSON = '';
                try {
                	tempJSON = constructJSONFromRequestObj(faRequest, callSource);
                } catch (Exception jsonX) {
					System.debug('(BRAINFARequestHelper.composeFARequest) EXCEPTION! \n' + jsonX.getTypeName() + '\n' + jsonX.getMessage() + '\n' + jsonX.getLineNumber() + '\n' + jsonX.getStackTraceString());
                }
                faRequest.Constructed_JSON__c = tempJSON;
                
                faReqList.add(faRequest);
                //upsert method throws exception if DML error or list is NULL, so no need to test for NULL afterward
                faReqList = BRAINFAObjectDMLManager.upsertFARequestList(faReqList);
                
                //associate the newly inserted faRequest as child to faCallMaster by faRequest.Id
                faCallMaster.BRAIN_FA_Request__c = faReqList?.get(0)?.Id;
                faCallMasterList.add(faCallMaster);
                //upsert method throws exception if DML error or list is NULL, so no need to test for NULL afterward
                faCallMasterList = BRAINFAObjectDMLManager.upsertFACallList(faCallMasterList);
                
                //query method throws exception if SOQL error or retrieved object is NULL, so no need to test for NULL afterward
                faRequest = BRAINFAObjectSOQLManager.queryFARequestById(faReqList?.get(0)?.Id);
                return faRequest;
            }
            if (capDesignList != null && capDesignList.size() > 0) {
                capitalDesignId = capDesignList.get(0).Id;
                capDesignList = BRAINFAObjectSOQLManager.queryCapDesignListById(capitalDesignId);
                System.debug('(BRAINFARequestHelper.composeFARequest) associatedOpptyList?.size() = ' + associatedOpptyList?.size() + '  AND capDesignList?.size() = ' + capDesignList?.size());
                faRequest = composeFromCapDesignData(capDesignList?.get(0), associatedOpptyList?.get(0), callSource);
                if (faRequest == null) {
                    faRequest = new BRAIN_FA_Request__c();
                }
                faRequest.BRAIN_API_Call_Tracker_Master__c = (faCallMaster != null ? faCallMaster?.Id : null);
                faRequest.cuid__c = submitterCuid;
                String tempJSON = '';
                try {
                    tempJSON = constructJSONFromRequestObj(faRequest, callSource);
                } catch (Exception jsonX) {
                    System.debug('(BRAINFARequestHelper.composeFARequest) EXCEPTION! \n' + jsonX.getTypeName() + '\n' + jsonX.getMessage() + '\n' + jsonX.getLineNumber() + '\n' + jsonX.getStackTraceString());
                }
                faRequest.Constructed_JSON__c = tempJSON;
                faReqList.add(faRequest);
    
                //upsert method throws exception if DML error or list is NULL, so no need to test for NULL afterward
                try {
                    faReqList = BRAINFAObjectDMLManager.upsertFARequestList(faReqList);
                } catch (Exception dmlX) {
                    System.debug('(BRAINFARequestHelper.composeFARequest) EXCEPTION! \n' + dmlX.getTypeName() + '\n' + dmlX.getMessage() + '\n' + dmlX.getLineNumber() + '\n' + dmlX.getStackTraceString());
                }
                //associate the newly inserted faRequest as child to faCallMaster by faRequest.Id
                faCallMaster.BRAIN_FA_Request__c = faReqList?.get(0)?.Id;
                faCallMasterList.add(faCallMaster);
                //upsert method throws exception if DML error or list is NULL, so no need to test for NULL afterward
                try {
	                faCallMasterList = BRAINFAObjectDMLManager.upsertFACallList(faCallMasterList);
                } catch (Exception dmlX) {
                    System.debug('(BRAINFARequestHelper.composeFARequest) EXCEPTION! \n' + dmlX.getTypeName() + '\n' + dmlX.getMessage() + '\n' + dmlX.getLineNumber() + '\n' + dmlX.getStackTraceString());
                }
                
                //query method throws exception if SOQL error or retrieved object is NULL, so no need to test for NULL afterward
                faRequest = BRAINFAObjectSOQLManager.queryFARequestById(faReqList?.get(0)?.Id);
                return faRequest;
            }
            faRequest = new BRAIN_FA_Request__c();
            faRequest.BRAIN_API_Call_Tracker_Master__c = (faCallMaster != null ? faCallMaster.Id : null);
            faRequest.cuid__c = submitterCuid;
            String tempJSON = '';
            try {
                tempJSON = constructJSONFromRequestObj(faRequest, callSource);
            } catch (Exception jsonX) {
                System.debug('(BRAINFARequestHelper.composeFARequest) EXCEPTION! \n' + jsonX.getTypeName() + '\n' + jsonX.getMessage() + '\n' + jsonX.getLineNumber() + '\n' + jsonX.getStackTraceString());
            }
            faRequest.Constructed_JSON__c = tempJSON;

            faReqList.add(faRequest);
            //upsert method throws exception if DML error or list is NULL, so no need to test for NULL afterward
            try {
            	faReqList = BRAINFAObjectDMLManager.upsertFARequestList(faReqList);
            } catch (Exception dmlX) {
                System.debug('(BRAINFARequestHelper.composeFARequest) EXCEPTION! \n' + dmlX.getTypeName() + '\n' + dmlX.getMessage() + '\n' + dmlX.getLineNumber() + '\n' + dmlX.getStackTraceString());
            }
            
            //associate the newly inserted faRequest as child to faCallMaster by faRequest.Id
            faCallMaster.BRAIN_FA_Request__c = faReqList?.get(0)?.Id;
            faCallMasterList.add(faCallMaster);
            //upsert method throws exception if DML error or list is NULL, so no need to test for NULL afterward
            try { 
                faCallMasterList = BRAINFAObjectDMLManager.upsertFACallList(faCallMasterList);
            } catch (Exception dmlX) {
                System.debug('(BRAINFARequestHelper.composeFARequest) EXCEPTION! \n' + dmlX.getTypeName() + '\n' + dmlX.getMessage() + '\n' + dmlX.getLineNumber() + '\n' + dmlX.getStackTraceString());
            }
            
            //query method throws exception if SOQL error or retrieved object is NULL, so no need to test for NULL afterward
            faRequest = BRAINFAObjectSOQLManager.queryFARequestById(faReqList?.get(0)?.Id);
            return faRequest;
        } catch(Exception composeReqX) {
            System.debug('(BRAINFARequestHelper.composeFARequest) EXCEPTION! \n' + composeReqX.getTypeName() + '\n' + composeReqX.getMessage() + '\n' + composeReqX.getLineNumber() + '\n' + composeReqX.getStackTraceString());
            throw composeReqX;
        }
    }//end method composeFARequest
    
    public static String constructJSONFromRequestObj(BRAIN_FA_Request__c faRequest, String callSource) {
        List<String> constructedJSONList = new List<String>();
        
        try {
            if(faRequest == null) {                
                throw new NullObjectException('EXCEPTION!  The BRAIN_FA_Request object was NULL and no details were added to the base JSON.');
            }
            constructedJSONList.add(' { ');
            constructedJSONList.add(' "sourceSystem":"' + faRequest.sourceSystem__c + '",');
            constructedJSONList.add(' "cuid":"' + faRequest.cuid__c + '",');
            constructedJSONList.add(' "financialMetricCurrencyCode":"' + faRequest.financialMetricCurrencyCode__c + '",');
            constructedJSONList.add(' "financialMetricCurrencyExchangeDate":' + faRequest.financialMetricCurrencyExchangeDate__c + ',');
            constructedJSONList.add(' "sourceSystemId":"' + faRequest.sourceSystemId__c + '",');
            constructedJSONList.add(' "sourceSystemIdType":"' + faRequest.sourceSystemIdType__c + '",');
            constructedJSONList.add(' "analysisOverride":' + faRequest.analysisOverride__c + ',');
            constructedJSONList.add(' "opportunityTitle":"' + faRequest.opportunityTitle__c + '",');

			constructedJSONList = constructJSONForHL2Items(constructedJSONList, faRequest, callSource);
            constructedJSONList.add(' }');//closing request
            return String.join(constructedJSONList, '');        
        } catch(Exception constructX) {
            System.debug('(BRAINFARequestHelper.constructJSONFromRequestObj) EXCEPTION! \n' + constructX.getTypeName() + '\n' + constructX.getMessage() + '\n' + constructX.getLineNumber() + '\n' + constructX.getStackTraceString());
            throw constructX;
        }
    }//end method constructJSONFromRequestObj

    private static List<String> constructJSONForHL2Items(List<String> constructedJSONList, BRAIN_FA_Request__c faRequest, String callSource) {
        //Starting hl2Items section                
        constructedJSONList.add(' "hl2Items":[ {');
        hl2Item__c hl2Item = new hl2Item__c();
        /**** System.debug('(ConstructJSON)for faRequest.sourceSystemId = ' + faRequest.sourceSystemId__c + ' of type = ' + faRequest.sourceSystemIdType__c + ', faRequest.hl2Items__c = ' + faRequest.hl2Items__c); ***/
        
        hl2Item.Id = faRequest.hl2Items__c;
        if (faRequest.hl2Items__c != null) {
            hl2Item.Id = faRequest.hl2Items__c;
            hl2Item = BRAINFAObjectSOQLManager.queryHl2ItemsList(hl2Item.Id).get(0);
        }
        hl2Item = BRAINFAObjectSOQLManager.queryHl2ItemsList(hl2Item?.Id)!=null && BRAINFAObjectSOQLManager.queryHl2ItemsList(hl2Item?.Id).size()>0 ? BRAINFAObjectSOQLManager.queryHl2ItemsList(hl2Item?.Id).get(0) : new hl2Item__c();
        hl3Item__c hl3Item = new hl3Item__c();
        if (hl2Item.hl3Items__c != null) {
            hl3Item.Id = hl2Item.hl3Items__c;
            hl3Item = BRAINFAObjectSOQLManager.queryHl3ItemsList(hl3Item.Id).get(0);
        }
        hl3Item = BRAINFAObjectSOQLManager.queryHl3ItemsList(hl3Item?.Id)!=null && BRAINFAObjectSOQLManager.queryHl3ItemsList(hl3Item?.Id).size()>0 ? BRAINFAObjectSOQLManager.queryHl3ItemsList(hl3Item?.Id).get(0) : new hl3Item__c();
        constructedJSONList.add(' "sourceSystemId":"' + hl2Item.sourceSystemId__c + '",');
        constructedJSONList.add(' "sourceSystemIdType":"' + hl2Item.sourceSystemIdType__c + '",');
        constructedJSONList.add(' "latitude":' + hl2Item.latitude__c + ',');
        constructedJSONList.add(' "longitude":' + hl2Item.longitude__c + ',');
        constructedJSONList.add(' "wireCenterCLLI":"' + hl2Item.wireCenterCLLI__c + '",');
        constructedJSONList.add(' "constructionMonths":' + hl2Item.constructionMonths__c + ',');
        constructedJSONList.add(' "currencyCode":"' + hl2Item.currencyCode__c + '",');
        constructedJSONList.add(' "coreElectronicsCost":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl2Item.coreElectronicsCost__c != null && hl2Item.coreElectronicsCost__c > 0 ? hl2Item.coreElectronicsCost__c + ',' : 'null,'));
        constructedJSONList.add(' "interofficeFiberCost":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl2Item.interofficeFiberCost__c != null && hl2Item.interofficeFiberCost__c > 0 ? hl2Item.interofficeFiberCost__c + ',' : 'null,'));
        constructedJSONList.add(' "coElectronicsCost":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl2Item.coElectronicsCost__c != null && hl2Item.coElectronicsCost__c > 0 ? hl2Item.coElectronicsCost__c + ',' : 'null,'));
        constructedJSONList.add(' "f1FeederCost":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl2Item.f1FeederCost__c != null && hl2Item.f1FeederCost__c > 0 ? hl2Item.f1FeederCost__c + ',' : 'null,'));
        constructedJSONList.add(' "f1FeederFootage":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl2Item.f1FeederFootage__c != null && hl2Item.f1FeederFootage__c > 0 ? hl2Item.f1FeederFootage__c + ',' : 'null,'));
        constructedJSONList.add(' "remoteElectronicsCost":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl2Item.remoteElectronicsCost__c != null && hl2Item.remoteElectronicsCost__c > 0 ? hl2Item.remoteElectronicsCost__c + ',' : 'null,'));
        constructedJSONList.add(' "accessCost":' + hl2Item.accessCost__c + ',');
        constructedJSONList.add(' "ipCapExShared":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl2Item.ipCapExShared__c != null && hl2Item.ipCapExShared__c > 0 ? hl2Item.ipCapExShared__c + ',' : 'null,'));
        constructedJSONList.add(' "ipNetExSharedMRC":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl2Item.ipNetExSharedMRC__c != null && hl2Item.ipNetExSharedMRC__c > 0 ? hl2Item.ipNetExSharedMRC__c + ',' : 'null,'));
        constructedJSONList.add(' "hl2ItemOverride":' + hl2Item.hl2ItemOverride__c + ',');

		constructedJSONList = constructJSONForHL3Items(constructedJSONList, faRequest, callSource);

        constructedJSONList.add(' }');//closing hl2Item
        constructedJSONList.add(' ]');//closing hl2Items
		return constructedJSONList;
    }//end method constructJSONForHL2Items

    private static List<String> constructJSONForHL3Items(List<String> constructedJSONList, BRAIN_FA_Request__c faRequest, String callSource) {
        hl2Item__c hl2Item = new hl2Item__c();
        if (faRequest.hl2Items__c != null) {
            hl2Item.Id = faRequest.hl2Items__c;
            hl2Item = BRAINFAObjectSOQLManager.queryHl2ItemsList(hl2Item.Id).get(0);
        }
        //Starting hl3Items section                
        constructedJSONList.add(' "hl3Items":[ {');
        /**** System.debug('(ConstructJSON)for faRequest.sourceSystemId = ' + faRequest.sourceSystemId__c + ' of type = ' + faRequest.sourceSystemIdType__c + ', hl2Item.hl3Items__c = ' + hl2Item.hl3Items__c); ****/
        hl3Item__c hl3Item = new hl3Item__c();
        if (hl2Item.hl3Items__c != null) {
            hl3Item.Id = hl2Item.hl3Items__c;
            hl3Item = BRAINFAObjectSOQLManager.queryHl3ItemsList(hl3Item.Id).get(0);
        }
        constructedJSONList.add(' "clusterId":' + (hl3Item.clusterId__c != null ? '"' + hl3item.clusterId__c + '",' : 'null,'));
        constructedJSONList.add(' "quantity":' + (hl3Item.clusterId__c == null ? hl3Item.quantity__c + ',' : 'null,'));
        constructedJSONList.add(' "constructionType":' + (hl3Item.clusterId__c == null ? '"' + hl3Item.constructionType__c + '",' : 'null,'));
        constructedJSONList.add(' "ctlOn":' + hl3Item.ctlOn__c + ',');
        constructedJSONList.add(' "currencyCode":"' + hl3Item.currencyCode__c + '",');
        constructedJSONList.add(' "f2Cost":' + (!String.isBlank(hl3Item.f2CostSource__c) ? hl3Item.f2Cost__c + ',' : 'null,'));
        constructedJSONList.add(' "f2CostSource":' + (!String.isBlank(hl3Item.f2CostSource__c) ? '"' + hl3Item.f2CostSource__c + '",' : 'null,'));
        constructedJSONList.add(' "f2Footage":' + (!String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') ? (hl3Item.f2Footage__c != null && hl3Item.f2Footage__c > 0 ? hl3Item.f2Footage__c  + ',' : 'null,') : 'null,'));
        constructedJSONList.add(' "insideWiringCapEx":' + (!String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') ? (hl3Item.insideWiringCapEx__c != null && hl3Item.insideWiringCapEx__c > 0 ? hl3Item.insideWiringCapEx__c + ',' : 'null,') : 'null,'));
        constructedJSONList.add(' "ontType":' + (hl3Item.ontType__c != null ? '"' + hl3item.ontType__c + '",' : 'null,'));
        constructedJSONList.add(' "dropCost":' + (!String.isBlank(hl3Item.dropCostSource__c) ? hl3Item.dropCost__c + ',' : 'null,'));
        constructedJSONList.add(' "dropCostSource":' + (!String.isBlank(hl3Item.dropCostSource__c) ? '"' + hl3Item.dropCostSource__c + '",' : 'null,'));
        constructedJSONList.add(' "additionalOpExNrc":' + (hl3Item.additionalOpExNrc__c != null && hl3Item.additionalOpExNrc__c > 0 ? hl3Item.additionalOpExNrc__c + ',' : 'null,'));
        constructedJSONList.add(' "additionalOpExMrc":' + (hl3Item.additionalOpExMrc__c != null && hl3Item.additionalOpExMrc__c > 0 ? hl3Item.additionalOpExMrc__c + ',' : 'null,'));
        constructedJSONList.add(' "occupantType":' + (hl3Item.clusterId__c == null ? '"' + hl3Item.occupantType__c + '",' : 'null,'));
        constructedJSONList.add(' "lotFrontageFeet":' + (hl3Item.clusterId__c == null ? hl3Item.lotFrontageFeet__c + ',' : 'null,'));
        constructedJSONList.add(' "maxDownstreamSpeedKbps":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl3Item.maxDownstreamSpeedKbps__c != null && hl3Item.maxDownstreamSpeedKbps__c > 0 ? hl3Item.maxDownstreamSpeedKbps__c + ',' : 'null,'));
       					//Starting isForAgrm sub-section
        if (callSource.equalsIgnoreCase('Offer') || callSource.equalsIgnoreCase('APVOffer')) {
			constructedJSONList = constructJSONOfferSection(constructedJSONList, faRequest, hl3Item);
        } else {
	        constructedJSONList.add(' "baseContractType":' + (hl3Item.baseContractType__c != null ? '"' + hl3Item.baseContractType__c + '",' : 'null,'));
        }
        constructedJSONList.add(' "fdhCost":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl3Item.fdhCost__c != null && hl3Item.fdhCost__c > 0 ? hl3Item.fdhCost__c + ',' : 'null,'));
        constructedJSONList.add(' "splitterCost":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl3Item.splitterCost__c != null && hl3Item.splitterCost__c > 0 ? hl3Item.splitterCost__c + ',' : 'null,'));
        constructedJSONList.add(' "splitterPorts":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl3Item.splitterPorts__c != null && hl3Item.splitterPorts__c > 0 ? hl3Item.splitterPorts__c + ',' : 'null,'));
        constructedJSONList.add(' "idfElectronicsCost":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl3Item.idfElectronicsCost__c != null && hl3Item.idfElectronicsCost__c > 0 ? hl3Item.idfElectronicsCost__c + ',' : 'null,'));
        constructedJSONList.add(' "wirelessAccessPointsCost":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') && hl3Item.wirelessAccessPointsCost__c != null && hl3Item.wirelessAccessPointsCost__c > 0 ? hl3Item.wirelessAccessPointsCost__c + ',' : 'null,'));
        constructedJSONList.add(' "networkInvestmentType":"' + hl3Item.networkInvestmentType__c + '",');
        constructedJSONList.add(' "productType":' + (hl3Item != null && !String.isBlank(hl3Item.networkInvestmentType__c) && !String.isBlank(hl3Item.productType__c) && !hl3Item.productType__c.equalsIgnoreCase('null') ? '"' + hl3Item.productType__c + '",' : 'null,'));
        constructedJSONList.add(' "contractType":' + (hl3Item.contractType__c != null ? '"' + hl3Item.contractType__c + '",' : '"NONE",'));
        constructedJSONList.add(' "contractTermMonths":' + hl3Item.contractTermMonths__c + ',');
		constructedJSONList.add(' "otherProviderContractType":' + (hl3Item.otherProviderContractType__c != null ? '"' + hl3Item.otherProviderContractType__c + '",' : 'null,'));                 
               /**********************************************************************  
                * BRAIN expects this to be NULL unless specifically overridden, but not sure when that applies,
                * so setting it to null until that logic can be determined and applied in SFCJ
                *
                *   constructedJSONList.add(' "hl3ItemOverride": {';
                *   constructedJSONList.add(' "ontCostSource":"' + hl3ItemOverride.ontCostSource__c + '",';
                *        OP_ONT_Total_Cost_Comb_Cost__c is being replaced with: MDU_ONT_Drop__c
                *   hl3ItemOverride.ontCost__c = sourceOffer.Associated_Capital_Design__r.OP_ONT_Total_Cost_Comb_Cost__c;
                *   constructedJSONList.add(' "ontCost":' + hl3ItemOverride.ontCost__c + ' ';
                *   constructedJSONList.add(' },';
                *************************************************************************/
        constructedJSONList.add(' "hl3ItemOverride":null,');
                /**********************************************************************************************
                 *   The following is not defined correctly, but was an idea about how it might be implemented.
                 *   hl3ItemOverride MUST be set to NULL at all times until a new solution has been implemented
                 * 
                 *   System.debug('(ConstructJSON) ontCostSource__c = ' + hl3ItemOverride.ontCostSource__c);
                 *   if (hl3ItemOverride.ontCostSource__c == null || hl3ItemOverride.ontCost__c == 0) {
                 * 	 	constructedJSONList.add(' "hl3ItemOverride":null,';
                 *   } else {
                 *   	constructedJSONList.add(' "hl3ItemOverride": {';
                 *      constructedJSONList.add(' "ontCostSource":"' + hl3ItemOverride.ontCostSource__c + '",';
                 *      constructedJSONList.add(' "ontCost":' + hl3ItemOverride.ontCost__c + ' ';
                 *      constructedJSONList.add(' },';
                 *   }
				 **********************************************************************************************/

        constructedJSONList = constructJSONForDemographics(constructedJSONList, faRequest, hl3Item);
        constructedJSONList.add(' }');//closing hl3Item
        constructedJSONList.add(' ]');//closing hl3Items
		return constructedJSONList;
    }//end method constructJSONForHL3Items
    
    private static List<String> constructJSONOfferSection(List<String> constructedJSONList, BRAIN_FA_Request__c faRequest, hl3Item__c hl3Item) {
        constructedJSONList.add(' "clusterId":' + (hl3Item.clusterId__c != null ? '"' + hl3item.clusterId__c + '",' : 'null,'));
        if (!hl3Item.networkInvestmentType__c.equalsIgnoreCase('NEW DEVELOPMENT')) {
            String existingContractOnlyJSON = '';
            if (String.isBlank(hl3Item.baseContractType__c) || hl3Item.baseContractType__c.equalsIgnoreCase('NONE')) {
                existingContractOnlyJSON += ' "baseBulkDownstreamKbps":null,';
                existingContractOnlyJSON += ' "baseBulkRevenueMrcPerUnit":null,';
                existingContractOnlyJSON += ' "baseContractType":' + (hl3Item.baseContractType__c.equalsIgnoreCase('NONE') ? '"NONE",' : 'null,');
                existingContractOnlyJSON += ' "baseContractEndDate":null,';
                existingContractOnlyJSON += ' "baseMarketingFees":null,';
            } else {
                existingContractOnlyJSON += ' "baseBulkDownstreamKbps":' + (hl3Item.baseBulkDownstreamKbps__c != null ? hl3Item.baseBulkDownstreamKbps__c + ',' : 'null,');
                existingContractOnlyJSON += ' "baseBulkRevenueMrcPerUnit":' + hl3Item.baseBulkRevenueMrcPerUnit__c + ',';
                existingContractOnlyJSON += ' "baseContractType":' + (hl3Item.baseContractType__c != null ? '"' + hl3Item.baseContractType__c + '",' : 'null,');
                existingContractOnlyJSON += ' "baseContractEndDate":' + (hl3Item.baseContractEndDate__c != null ? '"' + hl3Item.baseContractEndDate__c + '",' : '"9999-12-31T23:59:59Z",');
                System.debug('(ConstructJSON)for faRequest.sourceSystemId = ' + faRequest.sourceSystemId__c + ' of type = ' + faRequest.sourceSystemIdType__c + ', hl3Item.baseMarketingFees__c = ' + hl3Item.baseMarketingFees__c);
                marketingFee__c baseMarketingFeeAgrmt = new marketingFee__c();
                if (hl3Item.baseMarketingFees__c != null) {
                    baseMarketingFeeAgrmt.Id = hl3Item.baseMarketingFees__c;
                    baseMarketingFeeAgrmt = BRAINFAObjectSOQLManager.queryMarketingFeesList(baseMarketingFeeAgrmt.Id).get(0);
                }
                existingContractOnlyJSON += ' "baseMarketingFees":{ ';
                existingContractOnlyJSON += ' "currencyCode":"' + baseMarketingFeeAgrmt.currencyCode__c + '",';
                existingContractOnlyJSON += ' "doorFeePerUnit":' + baseMarketingFeeAgrmt.doorFeePerUnit__c + ',';
                existingContractOnlyJSON += ' "firstInstallBountyPerUnit":' + baseMarketingFeeAgrmt.firstInstallBountyPerUnit__c + ',';
                /***** System.debug('(ConstructJSON)for faRequest.sourceSystemId = ' + faRequest.sourceSystemId__c + ' of type = ' + faRequest.sourceSystemIdType__c + ', baseMarketingFeeAgrmt.serviceRevenueShares__c = ' + baseMarketingFeeAgrmt.serviceRevenueShares__c); ****/
                serviceRevenueShare__c baseServiceRevenueSharesAgrmt = new serviceRevenueShare__c();
                if (baseMarketingFeeAgrmt.serviceRevenueShares__c != null) {
                    baseServiceRevenueSharesAgrmt.Id = baseMarketingFeeAgrmt.serviceRevenueShares__c;
                    baseServiceRevenueSharesAgrmt = BRAINFAObjectSOQLManager.queryServiceRevenueSharesList(baseServiceRevenueSharesAgrmt.Id).get(0);
                }
                existingContractOnlyJSON += ' "serviceRevenueShares":[ { ';
                existingContractOnlyJSON += ' "minPenetrationRate":' + baseServiceRevenueSharesAgrmt.minPenetrationRate__c + ',';
                existingContractOnlyJSON += ' "maxPenetrationRate":' + baseServiceRevenueSharesAgrmt.maxPenetrationRate__c + ',';                            
                existingContractOnlyJSON += ' "agentCommissionRate":' + baseServiceRevenueSharesAgrmt.agentCommissionRate__c + ' ';
                existingContractOnlyJSON += ' } ] ';//this closes serviceRevenueSharesAgrmt for baseMarketingFeeAgrmts
                existingContractOnlyJSON += ' }, ';//this closes baseMarketingFeeAgrmts
            }
            constructedJSONList.add(existingContractOnlyJSON);
        }
            /******************************************************************************************
            else {
                String unusedJSON = '';
                unusedJSON += ' "baseBulkDownstreamKbps":' + hl3Item.baseBulkDownstreamKbps__c + ',';
                unusedJSON += ' "baseBulkRevenueMrcPerUnit":' + hl3Item.baseBulkRevenueMrcPerUnit__c + ',';
                unusedJSON += ((hl3Item.baseContractType__c != null) ? ' "baseContractType":"' + hl3Item.baseContractType__c + '",' : ' "baseContractType":"NONE",');
                unusedJSON += ' "baseContractEndDate":' + hl3Item.baseContractEndDate__c + ',';
                unusedJSON += ' "baseMarketingFees":{ ';
                unusedJSON += ' "currencyCode":"USD",';
                unusedJSON += ' "doorFeePerUnit":0.0,';
                unusedJSON += ' "firstInstallBountyPerUnit":0.0,';
                unusedJSON += ' "serviceRevenueShares":[ { ';
                unusedJSON += ' "minPenetrationRate":0.0,';
                unusedJSON += ' "maxPenetrationRate":0.0,';                            
                unusedJSON += ' "agentCommissionRate":0.0';
                unusedJSON += ' } ] ';//this closes serviceRevenueSharesAgrmt for baseMarketingFeeAgrmts
                unusedJSON += ' }, ';//this closes baseMarketingFeeAgrmts
                constructedJSONList.add(''); // not going to add the unusedJSON which was only "STUFFED" here to balance code coverage
            }
			************************************************************************************************/
        /**** System.debug('(ConstructJSON)for faRequest.sourceSystemId = ' + faRequest.sourceSystemId__c + ' of type = ' + faRequest.sourceSystemIdType__c + ', hl3Item.marketingFees__c = ' + hl3Item.marketingFees__c); ****/
        constructedJSONList.add(' "bulkDownstreamKbps":' + hl3Item.bulkDownstreamKbps__c + ',');
        constructedJSONList.add(' "bulkRevenueMrcPerUnit":' + hl3Item.bulkRevenueMrcPerUnit__c + ',');
        marketingFee__c marketingFeeAgrmt = new marketingFee__c();
        if (hl3Item.marketingFees__c != null) {
            String marketingFeeAgrmtId = hl3Item.marketingFees__c;
            try {
	            marketingFeeAgrmt = BRAINFAObjectSOQLManager.queryMarketingFeesList(marketingFeeAgrmtId).get(0);
                constructedJSONList.add(' "marketingFees":{ ');
                constructedJSONList.add(' "currencyCode":"' + marketingFeeAgrmt.currencyCode__c + '",');
                constructedJSONList.add(' "doorFeePerUnit":' + marketingFeeAgrmt.doorFeePerUnit__c + ',');
                constructedJSONList.add(' "firstInstallBountyPerUnit":' + marketingFeeAgrmt.firstInstallBountyPerUnit__c + ',');
                /***** System.debug('(ConstructJSON)for faRequest.sourceSystemId = ' + faRequest.sourceSystemId__c + ' of type = ' + faRequest.sourceSystemIdType__c + ', marketingFeeAgrmt.serviceRevenueShares__c = ' + marketingFeeAgrmt.serviceRevenueShares__c); ****/
                serviceRevenueShare__c serviceRevenueSharesAgrmt = new serviceRevenueShare__c();
                if (marketingFeeAgrmt.serviceRevenueShares__c != null) {
                    serviceRevenueSharesAgrmt.Id = marketingFeeAgrmt.serviceRevenueShares__c;
                    serviceRevenueSharesAgrmt = BRAINFAObjectSOQLManager.queryServiceRevenueSharesList(serviceRevenueSharesAgrmt.Id).get(0);
                }
                constructedJSONList.add(' "serviceRevenueShares":[ { ');
                constructedJSONList.add(' "minPenetrationRate":' + serviceRevenueSharesAgrmt.minPenetrationRate__c + ',');
                constructedJSONList.add(' "maxPenetrationRate":' + serviceRevenueSharesAgrmt.maxPenetrationRate__c + ',');
                constructedJSONList.add(' "agentCommissionRate":' + serviceRevenueSharesAgrmt.agentCommissionRate__c + ' ');
                constructedJSONList.add(' } ] ');//this closes serviceRevenueSharesAgrmt for marketingFeeAgrmts
                constructedJSONList.add(' }, ');//this closes marketingFeeAgrmts
            } catch (Exception feesX) {
                System.debug('(BRAINFARequestHelper.constructJSONOfferSection) EXCEPTION! \n' + feesX.getTypeName() + '\n' + feesX.getMessage() + '\n' + feesX.getLineNumber() + '\n' + feesX.getStackTraceString());
            }
        }
		return constructedJSONList;        
    }//end method constructJSONOfferSection
    
    private static List<String> constructJSONForDemographics(List<String> constructedJSONList, BRAIN_FA_Request__c faRequest, hl3Item__c hl3Item) {
        //Starting demographics section                
        System.debug('(ConstructJSONForDemographics)for faRequest.sourceSystemId = ' + faRequest.sourceSystemId__c + ' of type = ' + faRequest.sourceSystemIdType__c + ', demographics-hl3ItemMaster = ' + hl3Item.Id);
        if (hl3Item.clusterId__c == null) {
            List<demographic__c> demographicsList = new List<demographic__c>();
            if (hl3Item.Id != null) {
                demographicsList = BRAINFAObjectSOQLManager.queryDemographicsListByHl3ItemsId(String.valueOf(hl3Item.Id));
		        System.debug('(ConstructJSONForDemographics) For hl3Item.Id = ' + hl3Item.Id + ', returned demographicsList.size() = ' + demographicsList.size());
                constructedJSONList.add(' "demographics": [ ');
                for (Integer g = 0; g < demographicsList.size(); g++) {
			        System.debug('(ConstructJSONForDemographics) On record ' + (g+1) + ' of demographicsList sized at ' + demographicsList.size() + ' records, which contains: ' +
                                '\n quantity = ' + demographicsList.get(g).quantity__c + 
                                '\n rental = ' + demographicsList.get(g).rental__c + 
                                '\n incomeLevel = ' + demographicsList.get(g).incomeLevel__c);
                    if (g > 0) constructedJSONList.add(',');
                    constructedJSONList.add(' {');
                    constructedJSONList.add(' "quantity":' + demographicsList.get(g).quantity__c + ',');
                    constructedJSONList.add(' "rental":' + demographicsList.get(g).rental__c + ',');
                    constructedJSONList.add(' "incomeLevel":' + demographicsList.get(g).incomeLevel__c + ' ');
                    constructedJSONList.add(' }');//closing demographic
                }
                constructedJSONList.add(' ]');//closing demographics
            }
        } else {
            constructedJSONList.add(' "demographics": null');            
        }
		return constructedJSONList;
    }//end method constructJSONForDemographics
    
    public static BRAIN_FA_Request__c composeFromOfferDataRequested(Offer__c sourceOffer, Opportunity associatedOppty, String callSource) {
        BRAIN_FA_Request__c faRequest = new BRAIN_FA_Request__c();
        MarketingFee__c marketingFeeAgrmt = new MarketingFee__c();
        MarketingFee__c baseMarketingFeeAgrmt = new MarketingFee__c();
        ServiceRevenueShare__c serviceRevenueSharesAgrmt = new ServiceRevenueShare__c();
        ServiceRevenueShare__c baseServiceRevenueSharesAgrmt = new ServiceRevenueShare__c();
        
        try {        
            sourceOffer.Opportunity__c = associatedOppty.Id;
            
            faRequest = new BRAIN_FA_Request__c();
            
            faRequest.sourceSystem__c = 'SFCJ';
            faRequest.financialMetricCurrencyCode__c = 'USD';
            faRequest.financialMetricCurrencyExchangeDate__c = null;

            faRequest.sourceSystemId__c = sourceOffer.Id;
            faRequest.sourceSystemIdType__c = callSource.toUpperCase();
            faRequest.analysisOverride__c = null;
            faRequest.opportunityTitle__c = associatedOppty.Name;
                
            List<hl2Item__c> hl2ItemsList = new List<hl2Item__c>();
            hl2Item__c hl2Item = new hl2Item__c();
            hl2Item.sourceSystemId__c = sourceOffer.Id;

            hl2Item.sourceSystemIdType__c = callSource.toUpperCase();

            hl2Item.latitude__c = associatedOppty.Property__r.Latitude__c;

            hl2Item.longitude__c = associatedOppty.Property__r.Longitude__c;
            
            if (sourceOffer.Associated_Capital_Design__r.Technology_Type__c.equalsIgnoreCase(INSTANT_WIFI)) {
                hl2Item.wireCenterCLLI__c = sourceOffer.Associated_Capital_Design__r.BCET_Wire_Center__c;
            } else {
            	hl2Item.wireCenterCLLI__c = associatedOppty.Property__r.Network_Wire_Center_Name_Text__c;
            }
            
            hl2Item.constructionMonths__c = (sourceOffer.Associated_Capital_Design__r.Actual_Build_Out_Months__c == null ? 0 : Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Actual_Build_Out_Months__c));

            hl2Item.currencyCode__c = 'USD';
            hl2Item.coreElectronicsCost__c = (sourceOffer.Associated_Capital_Design__r.Core_Switch_Electronics__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Core_Switch_Electronics__c);
            hl2Item.interofficeFiberCost__c = (sourceOffer.Associated_Capital_Design__r.Transport_Interoffice_Fiber__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Transport_Interoffice_Fiber__c);
            hl2Item.coElectronicsCost__c = (sourceOffer.Associated_Capital_Design__r.CO_Electronics__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.CO_Electronics__c);
            hl2Item.f1FeederCost__c = (sourceOffer.Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c);            
			hl2Item.f1FeederFootage__c = (sourceOffer.Associated_Capital_Design__r.F1_Footage_ft__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.F1_Footage_ft__c);
            hl2Item.remoteElectronicsCost__c = (sourceOffer.Associated_Capital_Design__r.Remote_Electronics__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Remote_Electronics__c);
            
            //Related to Instant-WiFi
            hl2Item.accessCost__c = (sourceOffer.Associated_Capital_Design__r.Access_Cost__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Access_Cost__c);
            hl2Item.ipCapExShared__c = (sourceOffer.Associated_Capital_Design__r.IP_CapEx_Shared__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.IP_CapEx_Shared__c);
            hl2Item.ipNetExSharedMRC__c = (sourceOffer.Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c);

            HL2ItemOverride__c hl2ItemOverride = null;
            hl2Item.hl2ItemOverride__c = null;
            
            List<hl3Item__c> hl3ItemsList = new List<hl3Item__c>();
            hl3Item__c hl3Item = new hl3Item__c();
            
            hl3Item.quantity__c = Integer.valueOf(
                (sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c) + 
                (sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c) +
                (sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c) + 
                (sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c) +
                (sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c) + 
                (sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c) 
            );
            
            hl3Item.constructionType__c = ((sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c) + 
                                           (sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c) +
                                           (sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c) + 
                                           (sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c) > 0) ? 'MDU' :((sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c) + (sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c) > 0) ? 'SFU' : null;
               /*********************************************************************
                *  Explanation of above (above used for improved code coverage %)
                *  
                * if ((sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c) + 
                * 		(sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c) +
                * 		(sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c) + 
                * 		(sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c) > 0) {
                * 	hl3Item.constructionType__c = 'MDU';
                * } else if (sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c + sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c > 0) {
                * 	hl3Item.constructionType__c = 'SFU';
                * } else {
                * 	hl3Item.constructionType__c = null;
                * }
                ***********************************************************************/
                
            hl3Item.ctlOn__c = (sourceOffer.Associated_Capital_Design__r.Service_Delivery__c == CTL_ON || 
                                    sourceOffer.Associated_Capital_Design__r.Service_Delivery__c == INSTANT_INTERNET)                                    ;                
               /*********************************************************************
                *  Explanation of above (above used for improved code coverage %)
                *  
                * if (sourceOffer.Associated_Capital_Design__r.Service_Delivery__c == CTLON || 
                * 		sourceOffer.Associated_Capital_Design__r.Service_Delivery__c == INSTANT_INTERNET) {
                * 	hl3Item.ctlOn__c = true;
                * } else {
                * 	hl3Item.ctlOn__c = false;
                * }
                ***********************************************************************/
                
                
            hl3Item.currencyCode__c = 'USD';
            
            hl3Item.f2Footage__c = (sourceOffer.Associated_Capital_Design__r.F2_Footage_ft__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.F2_Footage_ft__c);            
            
            hl3Item.insideWiringCapEx__c = (sourceOffer.Associated_Capital_Design__r.Distribution_Structure_Conduit__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Distribution_Structure_Conduit__c); 
            
            //QFCJ-4282
            hl3Item.ontType__c = mapONTModelToBrainONT(sourceOffer.Associated_Capital_Design__r.ONT_Model__c);

            //QFCJ-4286
			hl3Item = buildDistrF2AndDropCostForHL3Item(hl3Item, sourceOffer.Associated_Capital_Design__c);            

            /*******************************************************************************  
             * Section is being replaced due to ESCJ-1912 Map CCT to Cap & Exp Spread
             *  OP_Res_Gateway_Total_Cost_Comb_Cost__c and Other_AC_Power_CAT_6_Expense__c are being replaced with:
             *      Other_MDU_F4__c
            *******************************************************************************/
            
            Integer totSRUnits = sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c) : 0;
            Integer totSOUnits = sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c) : 0;
            Integer totalSFUs = totSRUnits + totSOUnits;
            
            Integer totCRUnits = sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c) : 0;
            Integer totTRUnits = sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c) : 0;
            Integer totCOUnits = sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c) : 0;
            Integer totTOUnits = sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c) : 0;
            Integer totMRUnits = totCRUnits + totTRUnits;
            Integer totMOUnits = totCOUnits + totTOUnits;
            Integer totalMDUs = totMRUnits + totMOUnits;
                
            //QFCJ-4188 BRAIN double counting of the Gateway costs
            Decimal totalOtherAndMDUF4 = (sourceOffer.Associated_Capital_Design__r.Other_MDU_F4__c == null ? 0.0 : sourceOffer.Associated_Capital_Design__r.Other_MDU_F4__c);
            Decimal resGatewayCosts = (sourceOffer.Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c == null ? 0.0 : sourceOffer.Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c);
            Decimal adjustedOtherAndMDUF4 = totalOtherAndMDUF4 - resGatewayCosts;

            //QFCJ-4512 Correct IW BRAIN Mapping combined with QFCJ-4188
            if (sourceOffer.Associated_Capital_Design__r.Technology_Type__c.equalsIgnoreCase(INSTANT_WIFI)) {
                hl3Item.additionalOpExMrc__c = sourceOffer.Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c;
                hl3Item.additionalOpExNrc__c = sourceOffer.Associated_Capital_Design__r.One_Time_Additional_Expense__c + adjustedOtherAndMDUF4;
            } else {
	            hl3Item.additionalOpExMrc__c = 0;
                if (totalSFUs > 0) {
					//QFCJ-4514 Drop-Cost-Source
                    if (String.isBlank(hl3Item.productType__c) || String.isBlank(hl3Item.dropCostSource__c) || (!String.isBlank(hl3Item.productType__c) && hl3Item.productType__c.equalsIgnoreCase('FTTH') && !String.isBlank(hl3Item.dropCostSource__c) && hl3Item.dropCostSource__c.equalsIgnoreCase('STANDARD'))) {
	                    hl3Item.additionalOpExNrc__c = 0;
                    } else {
	                    hl3Item.additionalOpExNrc__c = (sourceOffer.Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c == null ? 0.00 : 
                                                    sourceOffer.Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c) + adjustedOtherAndMDUF4;
                    }
                } else {
                    hl3Item.additionalOpExNrc__c = adjustedOtherAndMDUF4;
                }
            }
            
            hl3Item.occupantType__c = sourceOffer.Associated_Capital_Design__r.Occupant_Type__c;
            hl3Item.lotFrontageFeet__c = Decimal.valueOf((sourceOffer.Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c != null ? sourceOffer.Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c.isNumeric() ? sourceOffer.Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c : '0' : '0'));
            hl3Item.maxDownstreamSpeedKbps__c = Decimal.valueOf((associatedOppty.Property__r.Max_Bandwidth_Available__c != null ? associatedOppty.Property__r.Max_Bandwidth_Available__c.isNumeric() ? associatedOppty.Property__r.Max_Bandwidth_Available__c : '0' : '0')) * 1000;
            
            //QFCJ-4007 Enabling BROWNFIELD being sent to BRAIN with QFCJ-4088 Implement ClusterId
            //        AND QFCJ-4264 Cluster Not Available
            /* if (sourceOffer.Associated_Capital_Design__r.Cluster_not_Available__c != null && sourceOffer.Associated_Capital_Design__r.Cluster_not_Available__c) {
	            hl3Item.clusterId__c = null;                
            } else {
	            hl3Item.clusterId__c = sourceOffer.Associated_Capital_Design__r.Cluster_ID__c;
            } */
            hl3Item.clusterId__c = sourceOffer.Associated_Capital_Design__r.Cluster_ID__c;
            
               /*********************************************
                * For agreements, need to add the following additional data to the Request
                *     Agreement Type is contractType/baseContractType (see below) in BRAIN Request mapped to Offer_Type__c in object Offer__c
                *     Term is contractTermMonths in BRAIN Request mapped to Contract_Term__c in object Offer__c
                *     Door Fee is doorFeePerUnit in BRAIN Request mapped to Door_Fee__c in object Capital_Design__c
                *     Bounty (Owner Occupied greenfield only) (aka, First Install Bounty) is firstInstallBountyPerUnit in BRAIN Request mapped to Data_Bounty_Amount_Approved__c in Offer__c
                *     Revenue Share (if Rental Marketing Agreement) is serviceRevenueShare object under marketingFeeAgrmts/baseMarketingFeeAgrmts (see below) in BRAIN Request
                *         Revenue Share (3 elements for Sole Provider, EMA and SMA): 
                *              1) Min Penetration Percentage is minPenetrationRate in BRAIN Request mapped to ???
                *              2) Max Penetration Percentage is maxPenetrationRate in BRAIN Request mapped to ???
                *              3) Agent Commission Percentage is agentCommissionRate in BRAIN Request mapped to ???
                *     Bulk Speed (Bulk Only) (aka, Bulk Downstream Speed) is bulkDownstreamKbps/baseBulkDownstreamKbps (see below) in BRAIN Request mapped to Bulk_Data_Speed_Profile_DL_UL_Approv__c in Offer__c
                *     Bulk Price (Bulk Only) (aka, Bulk Monthly Revenue Per Unit) is bulkRevenueMrcPerUnit/baseBulkRevenueMrcPerUnit (see below) in BRAIN Request mapped to Requested_Bulk_Data_Price_Approved__c in Offer__c
                *     Cluster ID (if brownfield) is clusterId in BRAIN Request mapped to ???
                *     Contract End Date  (if Sole Provider,EMA, SMA or Bulk) is baseContractEndDate (see below) in BRAIN Request mapped to EndDate in Contract
                * 
                * To help explain regular vs base -- base if for an existing contract while regular is for new/future "wants" to be analyzed 
                *    That being the definition of base, then if a customer was currently under an EMA,
                *    that existing contract would be placed in the baseContractType while a newly desired contract would be placed in contractType
                * 
                * Additionally, when we model Brownfields, if you select a Network Investment Type of "Product" or "Speed", 
                *     then the BRAIN user Interface opens up the Base Case and Investment Case fields
                * 
                * 
                * ******************************************/
            hl3Item.baseMarketingFees__c = null;
            baseMarketingFeeAgrmt = new MarketingFee__c();
            baseServiceRevenueSharesAgrmt = new ServiceRevenueShare__c();
            
            //The following were associated to Agreements
            if (String.isBlank(sourceOffer.Bulk_Data_Type__c)) {
                hl3Item.bulkDownstreamKbps__c = null;            
                hl3Item.baseBulkDownstreamKbps__c = null;
                hl3Item.baseBulkRevenueMrcPerUnit__c = null;
                hl3Item.bulkRevenueMrcPerUnit__c = null;
            } else {
                try {
                    String extractedBulkSpeed = extractNumericValueFromPicklistString(sourceOffer.Bulk_Data_Speed_Profile_DL_UL__c);
                    System.debug('(BRAINFARequestHelper.composeFromOfferDataRequested) extractedBulkSpeed = ' + extractedBulkSpeed);
                    Integer convBulkSpeed = (Integer.valueOf( extractedBulkSpeed != null ? extractedBulkSpeed : '0'));
                    System.debug('(BRAINFARequestHelper.composeFromOfferDataRequested) convBulkSpeed = ' + convBulkSpeed);
                    hl3Item.bulkDownstreamKbps__c = convBulkSpeed * 1000;            
                    hl3Item.baseBulkDownstreamKbps__c = convBulkSpeed * 1000;
                } catch (Exception bulkSpeedX) {
                    System.debug('(BRAINFARequestHelper.composeFromOfferDataRequested) EXCEPTION! \n' + bulkSpeedX.getTypeName() + '\n' + bulkSpeedX.getMessage() + '\n' + bulkSpeedX.getLineNumber() + '\n' + bulkSpeedX.getStackTraceString());
                    hl3Item.bulkDownstreamKbps__c = null;            
                    hl3Item.baseBulkDownstreamKbps__c = null;
                }
                
                hl3Item.baseBulkRevenueMrcPerUnit__c = sourceOffer.Requested_Bulk_Data_Price__c;
                hl3Item.bulkRevenueMrcPerUnit__c = sourceOffer.Requested_Bulk_Data_Price__c;
            }
            
            //QFCJ-4309 and QFCJ-4264 and QFCJ-4807
            System.debug('(BRAINFARequestHelper.composeFromOfferDataRequested) sourceOffer.Associated_Capital_Design__r.Network_Investment__c  = ' + sourceOffer.Associated_Capital_Design__r.Network_Investment__c +
                        			'\n  AND sourceOffer.Offer_Type__c = ' + sourceOffer.Offer_Type__c);
            /***************************************************************************************************************************
             * if (sourceOffer.Associated_Capital_Design__r.Development_Status__c !=null && sourceOffer.Associated_Capital_Design__r.Development_Status__c.equalsIgnoreCase('brownfield') && 
             *                       sourceOffer.Associated_Capital_Design__r.Cluster_not_Available__c != null && sourceOffer.Associated_Capital_Design__r.Cluster_not_Available__c) {
             *    String legacyBaseCT = null;
             *    ContractTypeMap baseCTMap = mapContractTypeWithOtherProviderContractType(legacyBaseCT);
             *    hl3Item.baseContractType__c = baseCTMap.contractType;
             * } else {
             ************************************************************************************************************* 
             * QFCJ-4807 for Offers specifically, baseContractType is getting set to NONE for brownfield to avoid probable fall-out from using Offer_Type__c
             * 	-- note that legacyBaseCTIn of "COMPETITIVE LOSS" or "NONE" is mapped via the method to "NONE"
             * 
             *  String legacyBaseCTIn = (sourceOffer.Associated_Capital_Design__r.Network_Investment__c != null && sourceOffer.Associated_Capital_Design__r.Network_Investment__c.equalsIgnoreCase('NEW DEVELOPMENT')) ? null : (sourceOffer.Associated_Capital_Design__r.Network_Investment__c.equalsIgnoreCase('PRODUCT')) ? 'COMPETITIVE LOSS' : sourceOffer.Offer_Type__c != null ? sourceOffer.Offer_Type__c.toUpperCase() : 'NONE';
             ***************************************************************************************************************************/ 
                String legacyBaseCTIn = (sourceOffer.Associated_Capital_Design__r.Network_Investment__c != null && sourceOffer.Associated_Capital_Design__r.Network_Investment__c.equalsIgnoreCase('NEW DEVELOPMENT')) ? null : (sourceOffer.Associated_Capital_Design__r.Network_Investment__c.equalsIgnoreCase('PRODUCT')) ? 'COMPETITIVE LOSS' : 'NONE';
                System.debug('(BRAINFARequestHelper.composeFromOfferDataRequested) legacyBaseCTIn = ' + legacyBaseCTIn);
                ContractTypeMap baseCTMap = mapContractTypeWithOtherProviderContractType(legacyBaseCTIn);
                hl3Item.baseContractType__c = baseCTMap.contractType;
            /************************************************************************************************************************** 
             * }
             **************************************************************************************************************************/             
                   /*********************************************************************
                    * REPLACED BY QFCJ-4309
                    * 
                    * hl3Item.baseContractType__c = sourceOffer.Associated_Capital_Design__r.Network_Investment__c !=null && sourceOffer.Associated_Capital_Design__r.Network_Investment__c.equalsIgnoreCase('NEW DEVELOPMENT') ? null : sourceOffer.Associated_Capital_Design__r.Network_Investment__c == 'PRODUCT' ? 'COMPETITIVE LOSS' : sourceOffer.Contract_Type__c != null ? sourceOffer.Contract_Type__c.toUpperCase() : 'NONE';
                    * 
                    * 
                    *    Explanation of above (above used for improved code coverage %)
                    * 
                    * 
                    * if (associatedOpptyList.get(0).Sole_Provider__c == 'Yes') {
                    * 	hl3Item.baseContractType__c = 'SOLE PROVIDER';
                    * } else if (sourceOffer.Offer_Type__c == 'Exclusive Marketing') {
                    * 	hl3Item.baseContractType__c = 'EMA';
                    * } else if (sourceOffer.Offer_Type__c == 'Shared Marketing') {
                    * 	hl3Item.baseContractType__c = 'SMA';
                    * } else if (sourceOffer.Offer_Type__c == 'Bulk Agreement') {
                    * 	hl3Item.baseContractType__c = 'BULK';
                    * } else if (sourceOffer.Offer_Type__c == 'Building Entry Agreement') {
                    * 	hl3Item.baseContractType__c = 'COMPETITIVE LOSS';
                    * } else {
                    * 	hl3Item.baseContractType__c = 'NONE';
                    * }
                    ***********************************************************************/
                                        
            hl3Item.baseContractEndDate__c = sourceOffer.Contract__r.EndDate;
            baseMarketingFeeAgrmt = new MarketingFee__c();
            baseMarketingFeeAgrmt.currencyCode__c = 'USD';
            baseMarketingFeeAgrmt.doorFeePerUnit__c = sourceOffer.Prepaid_Marketing_Fee_Per_Unit__c;
            baseMarketingFeeAgrmt.firstInstallBountyPerUnit__c = sourceOffer.Data_Bounty_Amount__c;
            baseServiceRevenueSharesAgrmt = new ServiceRevenueShare__c();
            if (sourceOffer.Flat_Revenue_Share__c != null && sourceOffer.Flat_Revenue_Share__c > 0) {
                baseServiceRevenueSharesAgrmt.minPenetrationRate__c = 0;
                baseServiceRevenueSharesAgrmt.maxPenetrationRate__c = 1;
                baseServiceRevenueSharesAgrmt.agentCommissionRate__c = (sourceOffer.Flat_Revenue_Share__c / 100);
            } else {
                baseServiceRevenueSharesAgrmt.minPenetrationRate__c = null;
                baseServiceRevenueSharesAgrmt.maxPenetrationRate__c = null;
                baseServiceRevenueSharesAgrmt.agentCommissionRate__c = null;
            }            
            hl3Item.marketingFees__c = null;
            marketingFeeAgrmt = new MarketingFee__c();
            marketingFeeAgrmt.currencyCode__c = 'USD';
            marketingFeeAgrmt.doorFeePerUnit__c = sourceOffer.Prepaid_Marketing_Fee_Per_Unit__c;
            marketingFeeAgrmt.firstInstallBountyPerUnit__c = sourceOffer.Data_Bounty_Amount__c;
            if (sourceOffer.Flat_Revenue_Share__c != null && sourceOffer.Flat_Revenue_Share__c > 0) {
                serviceRevenueSharesAgrmt.minPenetrationRate__c = 0;
                serviceRevenueSharesAgrmt.maxPenetrationRate__c = 1;
                serviceRevenueSharesAgrmt.agentCommissionRate__c = (sourceOffer.Flat_Revenue_Share__c / 100);
            } else {
                serviceRevenueSharesAgrmt.minPenetrationRate__c = null;
                serviceRevenueSharesAgrmt.maxPenetrationRate__c = null;
                serviceRevenueSharesAgrmt.agentCommissionRate__c = null;
            }

            //The following were new to BRAIN release
            hl3Item.fdhCost__c = 0.00;
            hl3Item.splitterCost__c = 0.00;
            hl3Item.splitterPorts__c = 0;
            hl3Item.idfElectronicsCost__c = sourceOffer.Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c;
            //end new to BRAIN release

            //Related to Instant-WiFi
            hl3Item.wirelessAccessPointsCost__c = (sourceOffer.Associated_Capital_Design__r.Wireless_Access_Points_Cost__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Wireless_Access_Points_Cost__c);
            
			/***** This is being replaced per QFCJ-2522 "Modification of APEX Code assembly of BRAIN API Financial Analysis REQUEST payload for Additional Contract Types"  **************************************************************************
			 *             
			 * hl3Item.contractType__c = associatedOppty.Sole_Provider__c == 'Yes' ? 'SOLE PROVIDER' : 
             *                           (sourceOffer.Offer_Type__c == 'Exclusive Marketing') ? 'EMA' :
             *                           (sourceOffer.Offer_Type__c == 'Shared Marketing') ? 'SMA' :                            
             *                           (sourceOffer.Offer_Type__c ==  'Bulk Agreement') ? 'BULK' :
             *                           (sourceOffer.Offer_Type__c == 'Building Entry Agreement') ? 'COMPETITIVE LOSS' : 'NONE';
			 *
			 *
			 *  For the specific details regarding logical change, see below:
			 * 
			 * 
				The logic for the fields sent is as follows.  
				If contract type is specified below, need to send the option specified.  If not, send Offer type as contractType: 
                
                IF Offer Type = None                
                THEN Other Provider Contract Type option = Marketing Agreement (Need to send contractType COMPETETIVE LOSS for this option) AND Non-Contracted
                
                IF Offer Type = EMA                 
                THEN Other Provider Contract Type Options = Non-Contracted and No Competition (Need to send contractType as SOLE PROVIDER for this option) 
                
                IF Offer Type = SMA                
                THEN Other Provider Contract Type Option = Marketing Agreement
                
                IF Offer Type = Bulk                
                THEN Other Provider Contract Type Option = No Competition 
                
                IF Offer Type = BEA                
                THEN Other Provider Contract Type = Non-Contracted 
              ***********************************************************************************************************************************************/
            System.debug('(BRAINFARequestHelper.*OfferRequested*) sourceOffer.Offer_Type__c = ' + sourceOffer.Offer_Type__c);
            /**********************************************************************************************
             * UPDATED with QFCJ-4309
             * 
             * hl3Item.contractType__c = sourceOffer.Offer_Type__c != null ? (sourceOffer.Offer_Type__c.equalsIgnoreCase('Exclusive Marketing')) ? 'SOLE PROVIDER' :
             *                           (sourceOffer.Offer_Type__c.equalsIgnoreCase('Shared Marketing')) ? 'SMA' :                            
             *                           (sourceOffer.Offer_Type__c.equalsIgnoreCase('Bulk Agreement')) ? 'BULK' :
             *                           (sourceOffer.Offer_Type__c.equalsIgnoreCase('Building Entry Agreement')) ? 'COMPETITIVE LOSS' : 
             *                           (sourceOffer.Offer_Type__c.equalsIgnoreCase('None')) ? 'COMPETITIVE LOSS' : 'NONE' : 'NONE';
             * hl3Item.otherProviderContractType__c = sourceOffer.Other_Provider_Contract_Type__c;    
			**********************************************************************************************/            
            String legacyConTypeIn = null;
            System.debug('(BRAINFARequestHelper.*OfferRequested*) sourceOffer.Associated_Capital_Design__r.Capital_Design_Type__c = ' + sourceOffer.Associated_Capital_Design__r.Capital_Design_Type__c);
            legacyConTypeIn = associatedOppty.Sole_Provider__c == 'Yes' ? 'SOLE PROVIDER' : 
			  	  (sourceOffer.Offer_Type__c == 'Exclusive Marketing') ? 'EMA' :
			      (sourceOffer.Offer_Type__c == 'Shared Marketing') ? 'SMA' :
			      (sourceOffer.Offer_Type__c ==  'Bulk Agreement') ? 'BULK' :
			      (sourceOffer.Offer_Type__c == 'Building Entry Agreement') ? 'COMPETITIVE LOSS' : 'NONE';
            ContractTypeMap ctMap = mapContractTypeWithOtherProviderContractType(legacyConTypeIn);
            hl3Item.contractType__c = ctMap.contractType;
            hl3Item.otherProviderContractType__c = ctMap.otherProviderContractType;
            System.debug('(BRAINFARequestHelper.*OfferRequested*) hl3Item.contractType__c = ' + hl3Item.contractType__c);
            System.debug('(BRAINFARequestHelper.*OfferRequested*) sourceOffer.Other_Provider_Contract_Type__c = ' + sourceOffer.Other_Provider_Contract_Type__c);
            
            hl3Item.contractTermMonths__c = Decimal.valueOf((sourceOffer.Contract_Term__c != null ? sourceOffer.Contract_Term__c.isNumeric() ? sourceOffer.Contract_Term__c : '0' : '0'));
            
            String cdTechType = sourceOffer.Associated_Capital_Design__r.Technology_Type__c;
            String cdSvcType = sourceOffer.Associated_Capital_Design__r.Service_Type__c;
            String techTypeSpecified = ( (totalSFUs > 0) ? ((cdTechType == 'CO-IP' || cdTechType == 'FTTN' || cdTechType == 'DSL') ? 'DSL' : cdTechType) : 
            						((cdTechType == 'CO-IP' || cdTechType == 'FTTN' || cdTechType == 'DSL' || ( (cdTechType == FTTIDF_GFAST || cdTechType == FTTIDF_CAT5) && ((cdSvcType != null) && (cdSvcType != CTLON))) ) ? 'DSL' : cdTechType) );
            System.debug('(OfferRequested) techTypeSpecified = ' + techTypeSpecified);

            Hl3ItemOverride__c hl3ItemOverride = new Hl3ItemOverride__c();
               /**********************************************************************  
                * BRAIN expects this to be NULL unless specifically overridden, but not sure when that applies,
                * so setting it to null until that logic can be determined and applied in SFCJ
                *        OP_ONT_Total_Cost_Comb_Cost__c is being replaced with: MDU_ONT_Drop__c
                *   hl3ItemOverride.ontCost__c = sourceOffer.Associated_Capital_Design__r.OP_ONT_Total_Cost_Comb_Cost__c;
                * 
                * ontCostSource: (one of PROVIDED, STANDARD)
                *    Tells BRAIN what value to use for ONT cost. 
                * 		PROVIDED uses the provided ONT cost, 
                * 		STANDARD has BRAIN calculate the value for ONT Cost based on site attributes. 
                *    This is required for fiber products (which require an ONT to deliver the service) and 
                * 		should be left null for copper products (for which an ONT is not used).
                *************************************************************************/
            if (techTypeSpecified == 'DSL') {
	            hl3ItemOverride.ontCostSource__c = null;
                hl3ItemOverride.ontCost__c = null;
            } else {
	            hl3ItemOverride.ontCostSource__c = sourceOffer.Associated_Capital_Design__r.Service_Type__c == 'Retail' ? 'STANDARD' : 'PROVIDED';
                hl3ItemOverride.ontCost__c = sourceOffer.Associated_Capital_Design__r.Service_Type__c == 'Retail' ? null : (sourceOffer.Associated_Capital_Design__r.MDU_ONT_Drop__c != null && sourceOffer.Associated_Capital_Design__r.MDU_ONT_Drop__c != 0) ? sourceOffer.Associated_Capital_Design__r.MDU_ONT_Drop__c : 0;
            }            
                                
            //add child object hl2Item
            hl2ItemsList.add(hl2Item);            
            hl2ItemsList = BRAINFAObjectDMLManager.upsertHL2ItemList(hl2ItemsList);
                
            //set hl2ItemId as hl2ItemMaster__c
            hl3Item.hl2ItemMaster__c = hl2ItemsList?.get(0)?.Id;
            
            //Add this partially-defined hl3Item to list of hl3Items
            hl3ItemsList.add(hl3Item);
            
            //update hl3Item with its subobjects' ids
            hl3ItemsList = BRAINFAObjectDMLManager.upsertHL3ItemList(hl3ItemsList);
            System.debug('(BRAINFARequestHelper.composeFromCapDesignData) AFTER UPSERT HL3ItemList, hl3ItemsList?.get(0)?.Id = ' + hl3ItemsList?.get(0)?.Id);

            List<demographic__c> demographicsList = new List<demographic__c>();
            demographic__c demographic = null;
            
            //Using totCRUnits and totTRUnits defined above, build Demographic for MDU Rental
            demographic = new demographic__c();
            demographic.quantity__c =  totCRUnits + totTRUnits;
            demographic.rental__c = true;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined MDU-Rental demographic to list of demographics if # of units > 0
            if (totCRUnits + totTRUnits > 0) {
                demographicsList.add(demographic);
            }
            
            //Using totSRUnitsdefined above, build Demographic for SFU Rental
            demographic = new demographic__c();
            demographic.quantity__c =  totSRUnits;
            demographic.rental__c = true;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined SFU-Rental demographic to list of demographics if # of units > 0
            if (totSRUnits > 0) {
                demographicsList.add(demographic);
            }
            
            //Using totCOUnits and totTOUnits defined above, build Demographic for MDU Owner-Occupied
            demographic = new demographic__c();
            demographic.quantity__c =  totCOUnits + totTOUnits;
            demographic.rental__c = false;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined MDU-OO demographic to list of demographics if # of units > 0
            if (totCOUnits + totTOUnits > 0) {
                demographicsList.add(demographic);
            }
            
            //Using totSOUnits defined above, build Demographic for SFU Owner-Occupied
            demographic = new demographic__c();
            demographic.quantity__c =  totSOUnits;
            demographic.rental__c = false;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined SFU-OO demographic to list of demographics if # of units > 0
            if (totSOUnits > 0) {
                demographicsList.add(demographic);
            }
                /**********************************************************************
                *   Explanation of above (above used for improved code coverage %)
                * 
                * 
                *             if (sourceCD.Total_Cottage_Rental_Units__c + sourceCD.Total_Tower_Rental_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_Cottage_Rental_Units__c + sourceCD.Total_Tower_Rental_Units__c);
                *                 demographic.rental__c = true;
                *             } else if (sourceCD.Total_Cottage_Owner_Units__c + sourceCD.Total_Tower_Owner_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_Cottage_Owner_Units__c + sourceCD.Total_Tower_Owner_Units__c);
                *                 demographic.rental__c = false;
                *             } else if (sourceCD.Total_SFH_Rental_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_SFH_Rental_Units__c);
                *                 demographic.rental__c = true;
                *             } else if (sourceCD.Total_SFH_Owner_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_SFH_Owner_Units__c);
                *                 demographic.rental__c = false;
                *             } else {
                *                 demographic.quantity__c = 0;
                *                 demographic.rental__c = false;            
                *             }
                *************************************************************************/                
            //add child object demographicList
            demographicsList = BRAINFAObjectDMLManager.upsertDemographicList(demographicsList);                    
            
            //Set demographicsList as hl3Item > demographics  
            hl3ItemsList.get(0).demographics__c = demographicsList.get(0).Id;
            
            //set hl3ItemId as hl3ItemMaster__c
            hl3ItemOverride.hl3ItemMaster__c = hl3ItemsList?.get(0)?.Id;
            
            //add child object hl3ItemOverride
            hl3ItemOverride = BRAINFAObjectDMLManager.upsertHL3ItemOverride(hl3ItemOverride);
            
            //Set hl3ItemOverride as hl3Item > hl3ItemOverride
            hl3ItemsList.get(0).hl3ItemOverride__c = hl3ItemOverride?.Id;
            
            //set hl3ItemId as hl3ItemMaster__c
            marketingFeeAgrmt.hl3ItemMaster__c = hl3ItemsList?.get(0)?.Id;
            
            //add child object marketingFeeAgrmts of hl3Items
            marketingFeeAgrmt = BRAINFAObjectDMLManager.upsertMarketingFee(marketingFeeAgrmt);                    
            
            //add child object serviceRevenueSharesAgrmt of marketingFeeAgrmts
            serviceRevenueSharesAgrmt.marketingFeeMaster__c = marketingFeeAgrmt.Id;
            
            serviceRevenueSharesAgrmt = BRAINFAObjectDMLManager.upsertServiceRevenueShare(serviceRevenueSharesAgrmt);
            
            marketingFeeAgrmt.serviceRevenueShares__c = serviceRevenueSharesAgrmt.Id;
            
            marketingFeeAgrmt = BRAINFAObjectDMLManager.upsertMarketingFee(marketingFeeAgrmt);                    
            
            //Set marketingFeeAgrmtsList as hl3Item > marketingFeeAgrmts  
            hl3Item.marketingFees__c = marketingFeeAgrmt.Id;
            
            if ((sourceOffer.Associated_Capital_Design__r.Network_Investment__c == null ? 'NONE' : sourceOffer.Associated_Capital_Design__r.Network_Investment__c.toUpperCase()) == 'NEW DEVELOPMENT') {
                //Set baseMarketingFeeAgrmtsList as hl3Item > baseMarketingFeeAgrmts  
                hl3Item.baseMarketingFees__c = null;
            } else {
                //set hl3ItemId as hl3ItemMaster__c
                baseMarketingFeeAgrmt.hl3ItemMaster__c = hl3ItemsList?.get(0)?.Id;
                
                //add child object baseMarketingFeeAgrmts of hl3Items
                baseMarketingFeeAgrmt = BRAINFAObjectDMLManager.upsertMarketingFee(baseMarketingFeeAgrmt);
                
                //add child object baseServiceRevenueSharesAgrmt of baseMarketingFeeAgrmts
                baseServiceRevenueSharesAgrmt.marketingFeeMaster__c = baseMarketingFeeAgrmt.Id;
                
                baseServiceRevenueSharesAgrmt = BRAINFAObjectDMLManager.upsertServiceRevenueShare(baseServiceRevenueSharesAgrmt);
                
                baseMarketingFeeAgrmt.serviceRevenueShares__c = baseServiceRevenueSharesAgrmt.Id;
                
                baseMarketingFeeAgrmt = BRAINFAObjectDMLManager.upsertMarketingFee(baseMarketingFeeAgrmt);
                
                //Set baseMarketingFeeAgrmtsList as hl3Item > baseMarketingFeeAgrmts  
                hl3Item.baseMarketingFees__c = baseMarketingFeeAgrmt.Id;
            }                        
            
            //update hl3Item with its subobjects' ids
            hl3ItemsList = BRAINFAObjectDMLManager.upsertHL3ItemList(hl3ItemsList);
            
            //Convert list of hl3Items to Array and set as hl2Item > hl3Items
            hl2ItemsList.get(0).hl3Items__c = hl3ItemsList?.get(0)?.Id;
            
            //update hl2Item with its subobject's ids
            hl2ItemsList = BRAINFAObjectDMLManager.upsertHL2ItemList(hl2ItemsList);
            
            //Convert list of hl2Items to Array and set as faRequest > hl2Items
            faRequest.hl2Items__c = hl2ItemsList?.get(0)?.Id;
                
        } catch(Exception  composeReqX) {
            System.debug('(BRAINFARequestHelper.composeFromOfferDataRequested) EXCEPTION! \n' + composeReqX.getTypeName() + '\n' + composeReqX.getMessage() + '\n' + composeReqX.getLineNumber() + '\n' + composeReqX.getStackTraceString());
            faRequest = null;
        }
        return faRequest;
    }//end method composeFromOfferDataRequested
    
    public static BRAIN_FA_Request__c composeFromOfferDataApproved(Offer__c sourceOffer, Opportunity associatedOppty, String callSource) {
        BRAIN_FA_Request__c faRequest = new BRAIN_FA_Request__c();
        MarketingFee__c marketingFeeAgrmt = new MarketingFee__c();
        MarketingFee__c baseMarketingFeeAgrmt = new MarketingFee__c();
        ServiceRevenueShare__c serviceRevenueSharesAgrmt = new ServiceRevenueShare__c();
        ServiceRevenueShare__c baseServiceRevenueSharesAgrmt = new ServiceRevenueShare__c();
        
        try {        
            sourceOffer.Opportunity__c = associatedOppty.Id;
            
            faRequest = new BRAIN_FA_Request__c();
            
            faRequest.sourceSystem__c = 'SFCJ';
            faRequest.financialMetricCurrencyCode__c = 'USD';
            faRequest.financialMetricCurrencyExchangeDate__c = null;

            faRequest.sourceSystemId__c = sourceOffer.Id;
            faRequest.sourceSystemIdType__c = callSource.toUpperCase();
            faRequest.analysisOverride__c = null;
            faRequest.opportunityTitle__c = associatedOppty.Name;
                
            List<hl2Item__c> hl2ItemsList = new List<hl2Item__c>();
            hl2Item__c hl2Item = new hl2Item__c();
            hl2Item.sourceSystemId__c = sourceOffer.Id;

            hl2Item.sourceSystemIdType__c = callSource.toUpperCase();

            hl2Item.latitude__c = associatedOppty.Property__r.Latitude__c;

            hl2Item.longitude__c = associatedOppty.Property__r.Longitude__c;
            
            if (sourceOffer.Associated_Capital_Design__r.Technology_Type__c.equalsIgnoreCase(INSTANT_WIFI)) {
                hl2Item.wireCenterCLLI__c = sourceOffer.Associated_Capital_Design__r.BCET_Wire_Center__c;
            } else {
            	hl2Item.wireCenterCLLI__c = associatedOppty.Property__r.Network_Wire_Center_Name_Text__c;
            }
            
            hl2Item.constructionMonths__c = (sourceOffer.Associated_Capital_Design__r.Actual_Build_Out_Months__c == null ? 0 : Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Actual_Build_Out_Months__c));

            hl2Item.currencyCode__c = 'USD';
            hl2Item.coreElectronicsCost__c = (sourceOffer.Associated_Capital_Design__r.Core_Switch_Electronics__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Core_Switch_Electronics__c);
            hl2Item.interofficeFiberCost__c = (sourceOffer.Associated_Capital_Design__r.Transport_Interoffice_Fiber__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Transport_Interoffice_Fiber__c);
            hl2Item.coElectronicsCost__c = (sourceOffer.Associated_Capital_Design__r.CO_Electronics__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.CO_Electronics__c);
            hl2Item.f1FeederCost__c = (sourceOffer.Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Feeder_F1_Access_and_or_PON__c);           
			hl2Item.f1FeederFootage__c = (sourceOffer.Associated_Capital_Design__r.F1_Footage_ft__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.F1_Footage_ft__c);			
            hl2Item.remoteElectronicsCost__c = (sourceOffer.Associated_Capital_Design__r.Remote_Electronics__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Remote_Electronics__c);
            
            //Related to Instant-WiFi
            hl2Item.accessCost__c = (sourceOffer.Associated_Capital_Design__r.Access_Cost__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Access_Cost__c);
            hl2Item.ipCapExShared__c = (sourceOffer.Associated_Capital_Design__r.IP_CapEx_Shared__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.IP_CapEx_Shared__c);
            hl2Item.ipNetExSharedMRC__c = (sourceOffer.Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.IP_NetEx_Shared_MRC__c);

            HL2ItemOverride__c hl2ItemOverride = null;
            hl2Item.hl2ItemOverride__c = null;
            
            List<hl3Item__c> hl3ItemsList = new List<hl3Item__c>();
            hl3Item__c hl3Item = new hl3Item__c();
            
            hl3Item.quantity__c = Integer.valueOf(
                (sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c) + 
                (sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c) +
                (sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c) + 
                (sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c) +
                (sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c) + 
                (sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c) 
            );
            
            hl3Item.constructionType__c = ((sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c) + 
                                           (sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c) +
                                           (sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c) + 
                                           (sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c) > 0) ? 'MDU' :((sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c) + (sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c) > 0) ? 'SFU' : null;
               /*********************************************************************
                *  Explanation of above (above used for improved code coverage %)
                *  
                * if ((sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c) + 
                * 		(sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c) +
                * 		(sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c) + 
                * 		(sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c) > 0) {
                * 	hl3Item.constructionType__c = 'MDU';
                * } else if (sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c + sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c > 0) {
                * 	hl3Item.constructionType__c = 'SFU';
                * } else {
                * 	hl3Item.constructionType__c = null;
                * }
                ***********************************************************************/
                
            hl3Item.ctlOn__c = (sourceOffer.Associated_Capital_Design__r.Service_Delivery__c == CTL_ON || 
                                    sourceOffer.Associated_Capital_Design__r.Service_Delivery__c == INSTANT_INTERNET)                                    ;                
               /*********************************************************************
                *  Explanation of above (above used for improved code coverage %)
                *  
                * if (sourceOffer.Associated_Capital_Design__r.Service_Delivery__c == CTLON || 
                * 		sourceOffer.Associated_Capital_Design__r.Service_Delivery__c == INSTANT_INTERNET) {
                * 	hl3Item.ctlOn__c = true;
                * } else {
                * 	hl3Item.ctlOn__c = false;
                * }
                ***********************************************************************/
                
                
            hl3Item.currencyCode__c = 'USD';
            
            hl3Item.f2Footage__c = (sourceOffer.Associated_Capital_Design__r.F2_Footage_ft__c == null ? 0 : sourceOffer.Associated_Capital_Design__r.F2_Footage_ft__c);            
            
                /*  Section is being replaced due to ESCJ-1912 Map CCT to Cap & Exp Spread
                 *  OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c and OP_F4_Total_Cost_Comb_Cost__c and OP_Media_Panel_Total_Cost_Comb_Cost__c are being replaced with:
                 *      Distribution_Structure_Conduit__c
            hl3Item.insideWiringCapEx__c = (sourceOffer.Associated_Capital_Design__r.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c) + 
                (sourceOffer.Associated_Capital_Design__r.OP_F4_Total_Cost_Comb_Cost__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.OP_F4_Total_Cost_Comb_Cost__c)  +  
                (sourceOffer.Associated_Capital_Design__r.OP_Media_Panel_Total_Cost_Comb_Cost__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.OP_Media_Panel_Total_Cost_Comb_Cost__c);
            *******************************************************************************/
            hl3Item.insideWiringCapEx__c = (sourceOffer.Associated_Capital_Design__r.Distribution_Structure_Conduit__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Distribution_Structure_Conduit__c); 
            
            //QFCJ-4282
            hl3Item.ontType__c = mapONTModelToBrainONT(sourceOffer.Associated_Capital_Design__r.ONT_Model__c);
            
            //QFCJ-4286
			hl3Item = buildDistrF2AndDropCostForHL3Item(hl3Item, sourceOffer.Associated_Capital_Design__c);            
            
                /*  Section is being replaced due to ESCJ-1912 Map CCT to Cap & Exp Spread
                 *  OP_Res_Gateway_Total_Cost_Comb_Cost__c and Other_AC_Power_CAT_6_Expense__c are being replaced with:
                 *      Other_MDU_F4__c
            *******************************************************************************/
                
            Integer totSRUnits = sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_SFH_Rental_Units__c) : 0;
            Integer totSOUnits = sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_SFH_Owner_Units__c) : 0;
            Integer totalSFUs = totSRUnits + totSOUnits;
            
            Integer totCRUnits = sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_Cottage_Rental_Units__c) : 0;
            Integer totTRUnits = sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_Tower_Rental_Units__c) : 0;
            Integer totCOUnits = sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_Cottage_Owner_Units__c) : 0;
            Integer totTOUnits = sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c != null ? Integer.valueOf(sourceOffer.Associated_Capital_Design__r.Total_Tower_Owner_Units__c) : 0;
            Integer totMRUnits = totCRUnits + totTRUnits;
            Integer totMOUnits = totCOUnits + totTOUnits;
            Integer totalMDUs = totMRUnits + totMOUnits;
                
            //QFCJ-4188 BRAIN double counting of the Gateway costs
            Decimal totalOtherAndMDUF4 = (sourceOffer.Associated_Capital_Design__r.Other_MDU_F4__c == null ? 0.0 : sourceOffer.Associated_Capital_Design__r.Other_MDU_F4__c);
            Decimal resGatewayCosts = (sourceOffer.Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c == null ? 0.0 : sourceOffer.Associated_Capital_Design__r.OP_Res_Gateway_Total_Cost_Comb_Cost__c);
            Decimal adjustedOtherAndMDUF4 = totalOtherAndMDUF4 - resGatewayCosts;

            //QFCJ-4512 Correct IW BRAIN Mapping combined with QFCJ-4188
            if (sourceOffer.Associated_Capital_Design__r.Technology_Type__c.equalsIgnoreCase(INSTANT_WIFI)) {
                hl3Item.additionalOpExMrc__c = sourceOffer.Associated_Capital_Design__r.Recurring_Additional_Expenses_Monthly__c;
                hl3Item.additionalOpExNrc__c = sourceOffer.Associated_Capital_Design__r.One_Time_Additional_Expense__c + adjustedOtherAndMDUF4;
            } else {
	            hl3Item.additionalOpExMrc__c = 0;
                if (totalSFUs > 0) {
					//QFCJ-4514 Drop-Cost-Source
                    if (String.isBlank(hl3Item.productType__c) || String.isBlank(hl3Item.dropCostSource__c) || (!String.isBlank(hl3Item.productType__c) && hl3Item.productType__c.equalsIgnoreCase('FTTH') && !String.isBlank(hl3Item.dropCostSource__c) && hl3Item.dropCostSource__c.equalsIgnoreCase('STANDARD'))) {
	                    hl3Item.additionalOpExNrc__c = 0;
                    } else {
	                    hl3Item.additionalOpExNrc__c = (sourceOffer.Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c == null ? 0.00 : 
    	                                                sourceOffer.Associated_Capital_Design__r.F4_Inside_Wiring_SFH__c) + adjustedOtherAndMDUF4;
                    }
                } else {
                    hl3Item.additionalOpExNrc__c = adjustedOtherAndMDUF4;
                }
            }

            hl3Item.occupantType__c = sourceOffer.Associated_Capital_Design__r.Occupant_Type__c;
            hl3Item.lotFrontageFeet__c = Decimal.valueOf((sourceOffer.Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c != null ? sourceOffer.Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c.isNumeric() ? sourceOffer.Associated_Capital_Design__r.for_SFU_Average_Lot_Size__c : '0' : '0'));
            hl3Item.maxDownstreamSpeedKbps__c = Decimal.valueOf((associatedOppty.Property__r.Max_Bandwidth_Available__c != null ? associatedOppty.Property__r.Max_Bandwidth_Available__c.isNumeric() ? associatedOppty.Property__r.Max_Bandwidth_Available__c : '0' : '0')) * 1000;
            
            //QFCJ-4007 Enabling BROWNFIELD being sent to BRAIN with QFCJ-4088 Implement ClusterId
            //        AND QFCJ-4264 Cluster Not Available
            /* if (sourceOffer.Associated_Capital_Design__r.Cluster_not_Available__c != null && sourceOffer.Associated_Capital_Design__r.Cluster_not_Available__c) {
	            hl3Item.clusterId__c = null;                
            } else {
	            hl3Item.clusterId__c = sourceOffer.Associated_Capital_Design__r.Cluster_ID__c;
            } */
            hl3Item.clusterId__c = sourceOffer.Associated_Capital_Design__r.Cluster_ID__c;
            
               /*********************************************
                * For agreements, need to add the following additional data to the Request
                *     Agreement Type is contractType/baseContractType (see below) in BRAIN Request mapped to Offer_Type__c in object Offer__c
                *     Term is contractTermMonths in BRAIN Request mapped to Contract_Term__c in object Offer__c
                *     Door Fee is doorFeePerUnit in BRAIN Request mapped to Door_Fee__c in object Capital_Design__c
                *     Bounty (Owner Occupied greenfield only) (aka, First Install Bounty) is firstInstallBountyPerUnit in BRAIN Request mapped to Data_Bounty_Amount_Approved__c in Offer__c
                *     Revenue Share (if Rental Marketing Agreement) is serviceRevenueShare object under marketingFeeAgrmts/baseMarketingFeeAgrmts (see below) in BRAIN Request
                *         Revenue Share (3 elements for Sole Provider, EMA and SMA): 
                *              1) Min Penetration Percentage is minPenetrationRate in BRAIN Request mapped to ???
                *              2) Max Penetration Percentage is maxPenetrationRate in BRAIN Request mapped to ???
                *              3) Agent Commission Percentage is agentCommissionRate in BRAIN Request mapped to ???
                *     Bulk Speed (Bulk Only) (aka, Bulk Downstream Speed) is bulkDownstreamKbps/baseBulkDownstreamKbps (see below) in BRAIN Request mapped to Bulk_Data_Speed_Profile_DL_UL_Approv__c in Offer__c
                *     Bulk Price (Bulk Only) (aka, Bulk Monthly Revenue Per Unit) is bulkRevenueMrcPerUnit/baseBulkRevenueMrcPerUnit (see below) in BRAIN Request mapped to Requested_Bulk_Data_Price_Approved__c in Offer__c
                *     Cluster ID (if brownfield) is clusterId in BRAIN Request mapped to ???
                *     Contract End Date  (if Sole Provider,EMA, SMA or Bulk) is baseContractEndDate (see below) in BRAIN Request mapped to EndDate in Contract
                * 
                * To help explain regular vs base -- base if for an existing contract while regular is for new/future "wants" to be analyzed 
                *    That being the definition of base, then if a customer was currently under an EMA,
                *    that existing contract would be placed in the baseContractType while a newly desired contract would be placed in contractType
                * 
                * Additionally, when we model Brownfields, if you select a Network Investment Type of "Product" or "Speed", 
                *     then the BRAIN user Interface opens up the Base Case and Investment Case fields
                * 
                * 
                * ******************************************/
            hl3Item.baseMarketingFees__c = null;
            baseMarketingFeeAgrmt = new MarketingFee__c();
            baseServiceRevenueSharesAgrmt = new ServiceRevenueShare__c();
            
            //The following were associated to Agreements
            if (String.isBlank(sourceOffer.Bulk_Data_Type_Approved__c)) {
                hl3Item.bulkDownstreamKbps__c = null;            
                hl3Item.baseBulkDownstreamKbps__c = null;
                hl3Item.baseBulkRevenueMrcPerUnit__c = null;
                hl3Item.bulkRevenueMrcPerUnit__c = null;
            } else {
                try {
                    String extractedBulkSpeed = extractNumericValueFromPicklistString(sourceOffer.Bulk_Data_Speed_Profile_DL_UL_Approv__c);
                    System.debug('(BRAINFARequestHelper.composeFromOfferDataApproved) extractedBulkSpeed = ' + extractedBulkSpeed);
                    Integer convBulkSpeed = (Integer.valueOf( extractedBulkSpeed != null ? extractedBulkSpeed : '0'));
                    System.debug('(BRAINFARequestHelper.composeFromOfferDataApproved) convBulkSpeed = ' + convBulkSpeed);
                    hl3Item.bulkDownstreamKbps__c = convBulkSpeed * 1000;            
                    hl3Item.baseBulkDownstreamKbps__c = convBulkSpeed * 1000;
                } catch (Exception bulkSpeedX) {
                    System.debug('(BRAINFARequestHelper.composeFromOfferDataApproved) EXCEPTION! \n' + bulkSpeedX.getTypeName() + '\n' + bulkSpeedX.getMessage() + '\n' + bulkSpeedX.getLineNumber() + '\n' + bulkSpeedX.getStackTraceString());
                    hl3Item.bulkDownstreamKbps__c = null;            
                    hl3Item.baseBulkDownstreamKbps__c = null;
                }
                
                hl3Item.baseBulkRevenueMrcPerUnit__c = sourceOffer.Requested_Bulk_Data_Price_Approved__c;
                hl3Item.bulkRevenueMrcPerUnit__c = sourceOffer.Requested_Bulk_Data_Price_Approved__c;
            }
            
            //QFCJ-4309 and QFCJ-4264 and QFCJ-4807
            System.debug('(BRAINFARequestHelper.composeFromOfferDataApproved) sourceOffer.Associated_Capital_Design__r.Network_Investment__c  = ' + sourceOffer.Associated_Capital_Design__r.Network_Investment__c +
                        			'\n  AND sourceOffer.Offer_Type__c = ' + sourceOffer.Offer_Type__c);
            /***************************************************************************************************************************
             * if (sourceOffer.Associated_Capital_Design__r.Development_Status__c !=null && sourceOffer.Associated_Capital_Design__r.Development_Status__c.equalsIgnoreCase('brownfield') && 
             *                       sourceOffer.Associated_Capital_Design__r.Cluster_not_Available__c != null && sourceOffer.Associated_Capital_Design__r.Cluster_not_Available__c) {
             *    String legacyBaseCT = null;
             *    ContractTypeMap baseCTMap = mapContractTypeWithOtherProviderContractType(legacyBaseCT);
             *    hl3Item.baseContractType__c = baseCTMap.contractType;
             * } else {
             ************************************************************************************************************* 
             * QFCJ-4807 for Offers specifically, baseContractType is getting set to NONE for brownfield to avoid probable fall-out from using Offer_Type__c
             * 	-- note that legacyBaseCTIn of "COMPETITIVE LOSS" or "NONE" is mapped via the method to "NONE"
             * 
             *  String legacyBaseCTIn = (sourceOffer.Associated_Capital_Design__r.Network_Investment__c != null && sourceOffer.Associated_Capital_Design__r.Network_Investment__c.equalsIgnoreCase('NEW DEVELOPMENT')) ? null : (sourceOffer.Associated_Capital_Design__r.Network_Investment__c.equalsIgnoreCase('PRODUCT')) ? 'COMPETITIVE LOSS' : sourceOffer.Offer_Type__c != null ? sourceOffer.Offer_Type__c.toUpperCase() : 'NONE';
             ***************************************************************************************************************************/ 
                String legacyBaseCTIn = (sourceOffer.Associated_Capital_Design__r.Network_Investment__c != null && sourceOffer.Associated_Capital_Design__r.Network_Investment__c.equalsIgnoreCase('NEW DEVELOPMENT')) ? null : (sourceOffer.Associated_Capital_Design__r.Network_Investment__c.equalsIgnoreCase('PRODUCT')) ? 'COMPETITIVE LOSS' : 'NONE';
                System.debug('(BRAINFARequestHelper.composeFromOfferDataApproved) legacyBaseCTIn = ' + legacyBaseCTIn);
                ContractTypeMap baseCTMap = mapContractTypeWithOtherProviderContractType(legacyBaseCTIn);
                hl3Item.baseContractType__c = baseCTMap.contractType;
            /************************************************************************************************************************** 
             * }
             **************************************************************************************************************************/             


                   /*********************************************************************
                    * REPLACED BY QFCJ-4309
                    * 
                    * hl3Item.baseContractType__c = sourceOffer.Associated_Capital_Design__r.Network_Investment__c !=null && sourceOffer.Associated_Capital_Design__r.Network_Investment__c.equalsIgnoreCase('NEW DEVELOPMENT') ? null : sourceOffer.Associated_Capital_Design__r.Network_Investment__c == 'PRODUCT' ? 'COMPETITIVE LOSS' : sourceOffer.Contract_Type__c != null ? sourceOffer.Contract_Type__c.toUpperCase() : 'NONE';
                    * 
                    * 
                    *    Explanation of above (above used for improved code coverage %)
                    * 
                    * 
                    * if (associatedOpptyList.get(0).Sole_Provider__c == 'Yes') {
                    * 	hl3Item.baseContractType__c = 'SOLE PROVIDER';
                    * } else if (sourceOffer.Offer_Type__c == 'Exclusive Marketing') {
                    * 	hl3Item.baseContractType__c = 'EMA';
                    * } else if (sourceOffer.Offer_Type__c == 'Shared Marketing') {
                    * 	hl3Item.baseContractType__c = 'SMA';
                    * } else if (sourceOffer.Offer_Type__c == 'Bulk Agreement') {
                    * 	hl3Item.baseContractType__c = 'BULK';
                    * } else if (sourceOffer.Offer_Type__c == 'Building Entry Agreement') {
                    * 	hl3Item.baseContractType__c = 'COMPETITIVE LOSS';
                    * } else {
                    * 	hl3Item.baseContractType__c = 'NONE';
                    * }
                    ***********************************************************************/
                                        
            hl3Item.baseContractEndDate__c = sourceOffer.Contract__r.EndDate;
            baseMarketingFeeAgrmt = new MarketingFee__c();
            baseMarketingFeeAgrmt.currencyCode__c = 'USD';
            baseMarketingFeeAgrmt.doorFeePerUnit__c = sourceOffer.Prepaid_Marketing_Fee_Per_Unit_Approve__c;
            baseMarketingFeeAgrmt.firstInstallBountyPerUnit__c = sourceOffer.Data_Bounty_Amount_Approved__c;
            baseServiceRevenueSharesAgrmt = new ServiceRevenueShare__c();
            if (sourceOffer.Flat_Revenue_Share_Approved__c != null && sourceOffer.Flat_Revenue_Share_Approved__c > 0) {
                baseServiceRevenueSharesAgrmt.minPenetrationRate__c = 0;
                baseServiceRevenueSharesAgrmt.maxPenetrationRate__c = 1;
                baseServiceRevenueSharesAgrmt.agentCommissionRate__c = (sourceOffer.Flat_Revenue_Share_Approved__c / 100);
            } else {
                baseServiceRevenueSharesAgrmt.minPenetrationRate__c = null;
                baseServiceRevenueSharesAgrmt.maxPenetrationRate__c = null;
                baseServiceRevenueSharesAgrmt.agentCommissionRate__c = null;
            }            
            hl3Item.marketingFees__c = null;
            marketingFeeAgrmt = new MarketingFee__c();
            marketingFeeAgrmt.currencyCode__c = 'USD';
            marketingFeeAgrmt.doorFeePerUnit__c = sourceOffer.Prepaid_Marketing_Fee_Per_Unit_Approve__c;
            marketingFeeAgrmt.firstInstallBountyPerUnit__c = sourceOffer.Data_Bounty_Amount_Approved__c;
            if (sourceOffer.Flat_Revenue_Share_Approved__c != null && sourceOffer.Flat_Revenue_Share_Approved__c > 0) {
                serviceRevenueSharesAgrmt.minPenetrationRate__c = 0;
                serviceRevenueSharesAgrmt.maxPenetrationRate__c = 1;
                serviceRevenueSharesAgrmt.agentCommissionRate__c = (sourceOffer.Flat_Revenue_Share_Approved__c / 100);
            } else {
                serviceRevenueSharesAgrmt.minPenetrationRate__c = null;
                serviceRevenueSharesAgrmt.maxPenetrationRate__c = null;
                serviceRevenueSharesAgrmt.agentCommissionRate__c = null;
            }
                
            //The following were new to BRAIN release
            hl3Item.fdhCost__c = 0.00;
            hl3Item.splitterCost__c = 0.00;
            hl3Item.splitterPorts__c = 0;
            hl3Item.idfElectronicsCost__c = sourceOffer.Associated_Capital_Design__r.Electronics_Shelf_UPS_Cost__c;
            //end new to BRAIN release

            //Related to Instant-WiFi
            hl3Item.wirelessAccessPointsCost__c = (sourceOffer.Associated_Capital_Design__r.Wireless_Access_Points_Cost__c == null ? 0.00 : sourceOffer.Associated_Capital_Design__r.Wireless_Access_Points_Cost__c);
            
			/***** This is being replaced per QFCJ-2522 "Modification of APEX Code assembly of BRAIN API Financial Analysis REQUEST payload for Additional Contract Types"  **************************************************************************
			 *             
			 * hl3Item.contractType__c = associatedOppty.Sole_Provider__c == 'Yes' ? 'SOLE PROVIDER' : 
             *                           (sourceOffer.Offer_Type__c == 'Exclusive Marketing') ? 'EMA' :
             *                           (sourceOffer.Offer_Type__c == 'Shared Marketing') ? 'SMA' :                            
             *                           (sourceOffer.Offer_Type__c ==  'Bulk Agreement') ? 'BULK' :
             *                           (sourceOffer.Offer_Type__c == 'Building Entry Agreement') ? 'COMPETITIVE LOSS' : 'NONE';
			 *
			 *
			 *  For the specific details regarding logical change, see below:
			 * 
			 * 
				The logic for the fields sent is as follows.  
				If contract type is specified below, need to send the option specified.  If not, send Offer type as contractType: 
                
                IF Offer Type = None                
                THEN Other Provider Contract Type option = Marketing Agreement (Need to send contractType COMPETETIVE LOSS for this option) AND Non-Contracted
                
                IF Offer Type = EMA                 
                THEN Other Provider Contract Type Options = Non-Contracted and No Competition (Need to send contractType as SOLE PROVIDER for this option) 
                
                IF Offer Type = SMA                
                THEN Other Provider Contract Type Option = Marketing Agreement
                
                IF Offer Type = Bulk                
                THEN Other Provider Contract Type Option = No Competition 
                
                IF Offer Type = BEA                
                THEN Other Provider Contract Type = Non-Contracted 
              ***********************************************************************************************************************************************/
            System.debug('(BRAINFARequestHelper.*OfferApproved*) sourceOffer.Offer_Type__c = ' + sourceOffer.Offer_Type__c);
            /**********************************************************************************************
             * UPDATED with QFCJ-4309
             * 
             * hl3Item.contractType__c =   sourceOffer.Offer_Type__c != null ? (sourceOffer.Offer_Type__c.equalsIgnoreCase('Exclusive Marketing')) ? 'SOLE PROVIDER' :
             *                           (sourceOffer.Offer_Type__c.equalsIgnoreCase('Shared Marketing')) ? 'SMA' :                            
             *                           (sourceOffer.Offer_Type__c.equalsIgnoreCase('Bulk Agreement')) ? 'BULK' :
             *                           (sourceOffer.Offer_Type__c.equalsIgnoreCase('Building Entry Agreement')) ? 'COMPETITIVE LOSS' : 
             *                           (sourceOffer.Offer_Type__c.equalsIgnoreCase('None')) ? 'COMPETITIVE LOSS' : 'NONE' : 'NONE';
			 * hl3Item.otherProviderContractType__c = sourceOffer.Other_Provider_Contract_Type__c;    
            **********************************************************************************************/            
            String legacyConTypeIn = null;
            System.debug('(BRAINFARequestHelper.*OfferApproved*) sourceOffer.Associated_Capital_Design__r.Capital_Design_Type__c = ' + sourceOffer.Associated_Capital_Design__r.Capital_Design_Type__c);
			legacyConTypeIn = associatedOppty.Sole_Provider__c == 'Yes' ? 'SOLE PROVIDER' : 
			  	  (sourceOffer.Offer_Type__c == 'Exclusive Marketing') ? 'EMA' :
			      (sourceOffer.Offer_Type__c == 'Shared Marketing') ? 'SMA' :
			      (sourceOffer.Offer_Type__c ==  'Bulk Agreement') ? 'BULK' :
			      (sourceOffer.Offer_Type__c == 'Building Entry Agreement') ? 'COMPETITIVE LOSS' : 'NONE';
            ContractTypeMap ctMap = mapContractTypeWithOtherProviderContractType(legacyConTypeIn);
            hl3Item.contractType__c = ctMap.contractType;
            hl3Item.otherProviderContractType__c = ctMap.otherProviderContractType;
            System.debug('(BRAINFARequestHelper.*OfferApproved*) hl3Item.contractType__c = ' + hl3Item.contractType__c);
            System.debug('(BRAINFARequestHelper.*OfferApproved*) sourceOffer.Other_Provider_Contract_Type__c = ' + sourceOffer.Other_Provider_Contract_Type__c);

            hl3Item.contractTermMonths__c = Decimal.valueOf((sourceOffer.Contract_Term__c != null ? sourceOffer.Contract_Term__c.isNumeric() ? sourceOffer.Contract_Term__c : '0' : '0'));
            
            String cdTechType = sourceOffer.Associated_Capital_Design__r.Technology_Type__c;
            String cdSvcType = sourceOffer.Associated_Capital_Design__r.Service_Type__c;
            String techTypeSpecified = ( (totalSFUs > 0) ? ((cdTechType == 'CO-IP' || cdTechType == 'FTTN' || cdTechType == 'DSL') ? 'DSL' : cdTechType) : 
            						((cdTechType == 'CO-IP' || cdTechType == 'FTTN' || cdTechType == 'DSL' || ( (cdTechType == FTTIDF_GFAST || cdTechType == FTTIDF_CAT5) && ((cdSvcType != null) && (cdSvcType != CTLON))) ) ? 'DSL' : cdTechType) );
            System.debug('(OfferApproved) techTypeSpecified = ' + techTypeSpecified);

            Hl3ItemOverride__c hl3ItemOverride = new Hl3ItemOverride__c();
               /**********************************************************************  
                * BRAIN expects this to be NULL unless specifically overridden, but not sure when that applies,
                * so setting it to null until that logic can be determined and applied in SFCJ
                *        OP_ONT_Total_Cost_Comb_Cost__c is being replaced with: MDU_ONT_Drop__c
                *   hl3ItemOverride.ontCost__c = sourceOffer.Associated_Capital_Design__r.OP_ONT_Total_Cost_Comb_Cost__c;
                * 
                * ontCostSource: (one of PROVIDED, STANDARD)
                *    Tells BRAIN what value to use for ONT cost. 
                * 		PROVIDED uses the provided ONT cost, 
                * 		STANDARD has BRAIN calculate the value for ONT Cost based on site attributes. 
                *    This is required for fiber products (which require an ONT to deliver the service) and 
                * 		should be left null for copper products (for which an ONT is not used).
                *************************************************************************/
            if (techTypeSpecified == 'DSL') {
	            hl3ItemOverride.ontCostSource__c = null;
                hl3ItemOverride.ontCost__c = null;
            } else {
	            hl3ItemOverride.ontCostSource__c = sourceOffer.Associated_Capital_Design__r.Service_Type__c == 'Retail' ? 'STANDARD' : 'PROVIDED';
                hl3ItemOverride.ontCost__c = sourceOffer.Associated_Capital_Design__r.Service_Type__c == 'Retail' ? null : (sourceOffer.Associated_Capital_Design__r.MDU_ONT_Drop__c != null && sourceOffer.Associated_Capital_Design__r.MDU_ONT_Drop__c != 0) ? sourceOffer.Associated_Capital_Design__r.MDU_ONT_Drop__c : 0;
            }            
                                
            //add child object hl2Item
            hl2ItemsList.add(hl2Item);            
            hl2ItemsList = BRAINFAObjectDMLManager.upsertHL2ItemList(hl2ItemsList);
            
            //set hl2ItemId as hl2ItemMaster__c of hl3Item
            hl3Item.hl2ItemMaster__c = hl2ItemsList?.get(0)?.Id;
            
            //Add this partially-defined hl3Item to list of hl3Items
            hl3ItemsList.add(hl3Item);
                
            //update hl3Item with its subobjects' ids
            hl3ItemsList = BRAINFAObjectDMLManager.upsertHL3ItemList(hl3ItemsList);
            System.debug('(BRAINFARequestHelper.composeFromCapDesignData) AFTER UPSERT HL3ItemList, hl3ItemsList?.get(0)?.Id = ' + hl3ItemsList?.get(0)?.Id);

            List<demographic__c> demographicsList = new List<demographic__c>();
            demographic__c demographic = null;
            
            //Using totCRUnits and totTRUnits defined above, build Demographic for MDU Rental
            demographic = new demographic__c();
            demographic.quantity__c =  totCRUnits + totTRUnits;
            demographic.rental__c = true;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined MDU-Rental demographic to list of demographics if # of units > 0
            if (totCRUnits + totTRUnits > 0) {
                demographicsList.add(demographic);
            }
            
            //Using totSRUnitsdefined above, build Demographic for SFU Rental
            demographic = new demographic__c();
            demographic.quantity__c =  totSRUnits;
            demographic.rental__c = true;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined SFU-Rental demographic to list of demographics if # of units > 0
            if (totSRUnits > 0) {
                demographicsList.add(demographic);
            }
            
            //Using totCOUnits and totTOUnits defined above, build Demographic for MDU Owner-Occupied
            demographic = new demographic__c();
            demographic.quantity__c =  totCOUnits + totTOUnits;
            demographic.rental__c = false;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined MDU-OO demographic to list of demographics if # of units > 0
            if (totCOUnits + totTOUnits > 0) {
                demographicsList.add(demographic);
            }
            
            //Using totSOUnits defined above, build Demographic for SFU Owner-Occupied
            demographic = new demographic__c();
            demographic.quantity__c =  totSOUnits;
            demographic.rental__c = false;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined SFU-OO demographic to list of demographics if # of units > 0
            if (totSOUnits > 0) {
                demographicsList.add(demographic);
            }
                /**********************************************************************
                *   Explanation of above (above used for improved code coverage %)
                * 
                * 
                *             if (sourceCD.Total_Cottage_Rental_Units__c + sourceCD.Total_Tower_Rental_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_Cottage_Rental_Units__c + sourceCD.Total_Tower_Rental_Units__c);
                *                 demographic.rental__c = true;
                *             } else if (sourceCD.Total_Cottage_Owner_Units__c + sourceCD.Total_Tower_Owner_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_Cottage_Owner_Units__c + sourceCD.Total_Tower_Owner_Units__c);
                *                 demographic.rental__c = false;
                *             } else if (sourceCD.Total_SFH_Rental_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_SFH_Rental_Units__c);
                *                 demographic.rental__c = true;
                *             } else if (sourceCD.Total_SFH_Owner_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_SFH_Owner_Units__c);
                *                 demographic.rental__c = false;
                *             } else {
                *                 demographic.quantity__c = 0;
                *                 demographic.rental__c = false;            
                *             }
                *************************************************************************/                
            //add child object demographicList
            demographicsList = BRAINFAObjectDMLManager.upsertDemographicList(demographicsList);                    
            
            //Set demographicsList as hl3Item > demographics  
            hl3ItemsList.get(0).demographics__c = demographicsList.get(0).Id;
            
            //set hl3ItemId as hl3ItemMaster__c
            hl3ItemOverride.hl3ItemMaster__c = hl3ItemsList?.get(0)?.Id;
            
            //add child object hl3ItemOverride
            hl3ItemOverride = BRAINFAObjectDMLManager.upsertHL3ItemOverride(hl3ItemOverride);
            
            //Set hl3ItemOverride as hl3Item > hl3ItemOverride
            hl3ItemsList.get(0).hl3ItemOverride__c = hl3ItemOverride?.Id;
            
            //set hl3ItemId as hl3ItemMaster__c
            marketingFeeAgrmt.hl3ItemMaster__c = hl3ItemsList?.get(0)?.Id;
            
            //add child object marketingFeeAgrmts of hl3Items
            marketingFeeAgrmt = BRAINFAObjectDMLManager.upsertMarketingFee(marketingFeeAgrmt);                    
            
            //add child object serviceRevenueSharesAgrmt of marketingFeeAgrmts
            serviceRevenueSharesAgrmt.marketingFeeMaster__c = marketingFeeAgrmt.Id;
            
            serviceRevenueSharesAgrmt = BRAINFAObjectDMLManager.upsertServiceRevenueShare(serviceRevenueSharesAgrmt);
            
            marketingFeeAgrmt.serviceRevenueShares__c = serviceRevenueSharesAgrmt.Id;
            
            marketingFeeAgrmt = BRAINFAObjectDMLManager.upsertMarketingFee(marketingFeeAgrmt);                    
            
            //Set marketingFeeAgrmtsList as hl3Item > marketingFeeAgrmts  
            hl3Item.marketingFees__c = marketingFeeAgrmt.Id;
            
            if ((sourceOffer.Associated_Capital_Design__r.Network_Investment__c == null ? 'NONE' : sourceOffer.Associated_Capital_Design__r.Network_Investment__c.toUpperCase()) == 'NEW DEVELOPMENT') {
                //Set baseMarketingFeeAgrmtsList as hl3Item > baseMarketingFeeAgrmts  
                hl3Item.baseMarketingFees__c = null;
            } else {
                //set hl3ItemId as hl3ItemMaster__c
                baseMarketingFeeAgrmt.hl3ItemMaster__c = hl3ItemsList?.get(0)?.Id;
                
                //add child object baseMarketingFeeAgrmts of hl3Items
                baseMarketingFeeAgrmt = BRAINFAObjectDMLManager.upsertMarketingFee(baseMarketingFeeAgrmt);
                
                //add child object baseServiceRevenueSharesAgrmt of baseMarketingFeeAgrmts
                baseServiceRevenueSharesAgrmt.marketingFeeMaster__c = baseMarketingFeeAgrmt.Id;
                
                baseServiceRevenueSharesAgrmt = BRAINFAObjectDMLManager.upsertServiceRevenueShare(baseServiceRevenueSharesAgrmt);
                
                baseMarketingFeeAgrmt.serviceRevenueShares__c = baseServiceRevenueSharesAgrmt.Id;
                
                baseMarketingFeeAgrmt = BRAINFAObjectDMLManager.upsertMarketingFee(baseMarketingFeeAgrmt);
                
                //Set baseMarketingFeeAgrmtsList as hl3Item > baseMarketingFeeAgrmts  
                hl3Item.baseMarketingFees__c = baseMarketingFeeAgrmt.Id;
            }                        
            
            //update hl3Item with its subobjects' ids
            hl3ItemsList = BRAINFAObjectDMLManager.upsertHL3ItemList(hl3ItemsList);
            
            //Convert list of hl3Items to Array and set as hl2Item > hl3Items
            hl2ItemsList.get(0).hl3Items__c = hl3ItemsList?.get(0)?.Id;
            
            //update hl2Item with its subobject's ids
            hl2ItemsList = BRAINFAObjectDMLManager.upsertHL2ItemList(hl2ItemsList);
            
            //Convert list of hl2Items to Array and set as faRequest > hl2Items
            faRequest.hl2Items__c = hl2ItemsList?.get(0)?.Id;
                
        } catch(Exception  composeReqX) {
            System.debug('(BRAINFARequestHelper.composeFromOfferDataApproved) EXCEPTION! \n' + composeReqX.getTypeName() + '\n' + composeReqX.getMessage() + '\n' + composeReqX.getLineNumber() + '\n' + composeReqX.getStackTraceString());
            faRequest = null;
        }
        return faRequest;
    }//end method composeFromOfferDataApproved
    
    public static BRAIN_FA_Request__c composeFromCapDesignData(Capital_Design__c sourceCD, Opportunity associatedOppty, String callSource) {
        BRAIN_FA_Request__c faRequest = new BRAIN_FA_Request__c();

        try {        
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
	            sourceCD.Opportunity__c = null;
            } else {
                sourceCD.Opportunity__c = associatedOppty.Id;
            }
            
            faRequest = new BRAIN_FA_Request__c();
            //associate the faCall as Master/parent to the faRequest being composed by using faCall.Id as BRAIN_API_Call_Tracker_Master__c
            
            faRequest.sourceSystem__c = 'SFCJ';
            faRequest.financialMetricCurrencyCode__c = 'USD';
            faRequest.financialMetricCurrencyExchangeDate__c = null;
            faRequest.sourceSystemId__c = sourceCD.Id;
            faRequest.sourceSystemIdType__c = 'CAPITAL-DESIGN';
            faRequest.analysisOverride__c = null;
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
                faRequest.opportunityTitle__c = sourceCD.Property_Name__c;
            } else {
	            faRequest.opportunityTitle__c = associatedOppty.Name;
            }
                
            List<hl2Item__c> hl2ItemsList = new List<hl2Item__c>();
            hl2Item__c hl2Item = new hl2Item__c();
            hl2Item.sourceSystemId__c = sourceCD.Id;
            hl2Item.sourceSystemIdType__c = 'CAPITAL-DESIGN';
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
                hl2Item.latitude__c = sourceCD.Latitude_NM__c;
                hl2Item.longitude__c = sourceCD.Longitude_NM__c;
                
                hl2Item.wireCenterCLLI__c = sourceCD.Wire_Center_CLLI_Code__c;
                hl2Item.constructionMonths__c = (sourceCD.Planned_Build_Out_Years__c == null ? 0 : Integer.valueOf(sourceCD.Planned_Build_Out_Years__c * 12));
            } else {                
                hl2Item.latitude__c = associatedOppty.Property__r.Latitude__c;
                hl2Item.longitude__c = associatedOppty.Property__r.Longitude__c;
                if (sourceCD.Technology_Type__c == 'Instant Wi-Fi') {
	                hl2Item.wireCenterCLLI__c = sourceCD.BCET_Wire_Center__c;
                } else {
	                hl2Item.wireCenterCLLI__c = associatedOppty.Property__r.Network_Wire_Center_Name_Text__c;
                }
                hl2Item.constructionMonths__c = (sourceCD.Actual_Build_Out_Months__c == null ? 0 : Integer.valueOf(sourceCD.Actual_Build_Out_Months__c));
            }
            hl2Item.currencyCode__c = 'USD';
            hl2Item.coreElectronicsCost__c = (sourceCD.Core_Switch_Electronics__c == null ? 0.00 : sourceCD.Core_Switch_Electronics__c);
            hl2Item.interofficeFiberCost__c = (sourceCD.Transport_Interoffice_Fiber__c == null ? 0.00 : sourceCD.Transport_Interoffice_Fiber__c);
            hl2Item.coElectronicsCost__c = (sourceCD.CO_Electronics__c == null ? 0.00 : sourceCD.CO_Electronics__c);
            hl2Item.f1FeederCost__c = (sourceCD.Feeder_F1_Access_and_or_PON__c == null ? 0.00 : sourceCD.Feeder_F1_Access_and_or_PON__c); 
			hl2Item.f1FeederFootage__c = (sourceCD.F1_Footage_ft__c == null ? 0 : sourceCD.F1_Footage_ft__c);
            hl2Item.remoteElectronicsCost__c = (sourceCD.Remote_Electronics__c == null ? 0.00 : sourceCD.Remote_Electronics__c);
            
            //Related to Instant-WiFi
            hl2Item.accessCost__c = (sourceCD.Access_Cost__c == null ? 0.00 : sourceCD.Access_Cost__c);
            hl2Item.ipCapExShared__c = (sourceCD.IP_CapEx_Shared__c == null ? 0.00 : sourceCD.IP_CapEx_Shared__c);
            hl2Item.ipNetExSharedMRC__c = (sourceCD.IP_NetEx_Shared_MRC__c == null ? 0.00 : sourceCD.IP_NetEx_Shared_MRC__c);
            
            HL2ItemOverride__c hl2ItemOverride = null;
            hl2Item.hl2ItemOverride__c = null;
            
            List<hl3Item__c> hl3ItemsList = new List<hl3Item__c>();
            hl3Item__c hl3Item = new hl3Item__c();
            
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
                hl3Item.quantity__c = Integer.valueOf(
                    (sourceCD.Total_Cottage_Rental_Units_NM__c == null ? 0 : sourceCD.Total_Cottage_Rental_Units_NM__c) + 
                    (sourceCD.Total_Cottage_Owner_Units_NM__c == null ? 0 : sourceCD.Total_Cottage_Owner_Units_NM__c) +
                    (sourceCD.Total_Tower_Rental_Units_NM__c == null ? 0 : sourceCD.Total_Tower_Rental_Units_NM__c) + 
                    (sourceCD.Total_Tower_Owner_Units_NM__c == null ? 0 : sourceCD.Total_Tower_Owner_Units_NM__c) +
                    (sourceCD.Total_SFH_Owner_Units_NM__c == null ? 0 : sourceCD.Total_SFH_Owner_Units_NM__c) + 
                    (sourceCD.Total_SFH_Rental_Units_NM__c == null ? 0 : sourceCD.Total_SFH_Rental_Units_NM__c) 
                );
            } else {                
                hl3Item.quantity__c = Integer.valueOf(
                    (sourceCD.Total_Cottage_Rental_Units__c == null ? 0 : sourceCD.Total_Cottage_Rental_Units__c) + 
                    (sourceCD.Total_Cottage_Owner_Units__c == null ? 0 : sourceCD.Total_Cottage_Owner_Units__c) +
                    (sourceCD.Total_Tower_Rental_Units__c == null ? 0 : sourceCD.Total_Tower_Rental_Units__c) + 
                    (sourceCD.Total_Tower_Owner_Units__c == null ? 0 : sourceCD.Total_Tower_Owner_Units__c) +
                    (sourceCD.Total_SFH_Owner_Units__c == null ? 0 : sourceCD.Total_SFH_Owner_Units__c) + 
                    (sourceCD.Total_SFH_Rental_Units__c == null ? 0 : sourceCD.Total_SFH_Rental_Units__c) 
                );
            }
            
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
	            hl3Item.constructionType__c = ((sourceCD.Total_Cottage_Rental_Units_NM__c == null ? 0 : sourceCD.Total_Cottage_Rental_Units_NM__c) + 
    	                                       (sourceCD.Total_Cottage_Owner_Units_NM__c == null ? 0 : sourceCD.Total_Cottage_Owner_Units_NM__c) +
        	                                   (sourceCD.Total_Tower_Rental_Units_NM__c == null ? 0 : sourceCD.Total_Tower_Rental_Units_NM__c) + 
            	                               (sourceCD.Total_Tower_Owner_Units_NM__c == null ? 0 : sourceCD.Total_Tower_Owner_Units_NM__c) > 0) ? 'MDU' :((sourceCD.Total_SFH_Owner_Units_NM__c == null ? 0 : sourceCD.Total_SFH_Owner_Units_NM__c) + (sourceCD.Total_SFH_Rental_Units_NM__c == null ? 0 : sourceCD.Total_SFH_Rental_Units_NM__c) > 0) ? 'SFU' : null;
            } else {                
	            hl3Item.constructionType__c = ((sourceCD.Total_Cottage_Rental_Units__c == null ? 0 : sourceCD.Total_Cottage_Rental_Units__c) + 
    	                                       (sourceCD.Total_Cottage_Owner_Units__c == null ? 0 : sourceCD.Total_Cottage_Owner_Units__c) +
        	                                   (sourceCD.Total_Tower_Rental_Units__c == null ? 0 : sourceCD.Total_Tower_Rental_Units__c) + 
            	                               (sourceCD.Total_Tower_Owner_Units__c == null ? 0 : sourceCD.Total_Tower_Owner_Units__c) > 0) ? 'MDU' :((sourceCD.Total_SFH_Owner_Units__c == null ? 0 : sourceCD.Total_SFH_Owner_Units__c) + (sourceCD.Total_SFH_Rental_Units__c == null ? 0 : sourceCD.Total_SFH_Rental_Units__c) > 0) ? 'SFU' : null;
            }
               /*********************************************************************
                *  Explanation of above (above used for improved code coverage %)
                *  
                * if ((sourceCD.Total_Cottage_Rental_Units__c == null ? 0 : sourceCD.Total_Cottage_Rental_Units__c) + 
                * 		(sourceCD.Total_Cottage_Owner_Units__c == null ? 0 : sourceCD.Total_Cottage_Owner_Units__c) +
                * 		(sourceCD.Total_Tower_Rental_Units__c == null ? 0 : sourceCD.Total_Tower_Rental_Units__c) + 
                * 		(sourceCD.Total_Tower_Owner_Units__c == null ? 0 : sourceCD.Total_Tower_Owner_Units__c) > 0) {
                * 	hl3Item.constructionType__c = 'MDU';
                * } else if (sourceCD.Total_SFH_Owner_Units__c + sourceCD.Total_SFH_Rental_Units__c > 0) {
                * 	hl3Item.constructionType__c = 'SFU';
                * } else {
                * 	hl3Item.constructionType__c = null;
                * }
                ***********************************************************************/
                
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
	            hl3Item.ctlOn__c = (sourceCD.Service_Delivery_NM__c == CTLON || 
                                    sourceCD.Service_Delivery_NM__c == INSTANT_INTERNET);                
            } else {                
	            hl3Item.ctlOn__c = (sourceCD.Service_Delivery__c == CTLON || 
                                    sourceCD.Service_Delivery__c == INSTANT_INTERNET);                
            }
               /*********************************************************************
                *  Explanation of above (above used for improved code coverage %)
                *  
                * if (sourceCD.Service_Delivery__c == CTLON || 
                * 		sourceCD.Service_Delivery__c == INSTANT_INTERNET) {
                * 	hl3Item.ctlOn__c = true;
                * } else {
                * 	hl3Item.ctlOn__c = false;
                * }
                ***********************************************************************/
                
                
            hl3Item.currencyCode__c = 'USD';
            
            hl3Item.f2Footage__c = (sourceCD.F2_Footage_ft__c == null ? 0 : sourceCD.F2_Footage_ft__c);            
            
            /*  Section is being replaced due to ESCJ-1912 Map CCT to Cap & Exp Spread
             *  OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c and OP_F4_Total_Cost_Comb_Cost__c and OP_Media_Panel_Total_Cost_Comb_Cost__c are being replaced with:
             *      Distribution_Structure_Conduit__c
            hl3Item.insideWiringCapEx__c = (sourceCD.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c == null ? 0.00 : sourceCD.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c) + 
                (sourceCD.OP_F4_Total_Cost_Comb_Cost__c == null ? 0.00 : sourceCD.OP_F4_Total_Cost_Comb_Cost__c)  +  
                (sourceCD.OP_Media_Panel_Total_Cost_Comb_Cost__c == null ? 0.00 : sourceCD.OP_Media_Panel_Total_Cost_Comb_Cost__c);
            *******************************************************************************/
            hl3Item.insideWiringCapEx__c = (sourceCD.Distribution_Structure_Conduit__c == null ? 0.00 : sourceCD.Distribution_Structure_Conduit__c); 
            
            //QFCJ-4282
            hl3Item.ontType__c = mapONTModelToBrainONT(sourceCD.ONT_Model__c);

            //QFCJ-4286
			hl3Item = buildDistrF2AndDropCostForHL3Item(hl3Item, sourceCD.Id);

            /*  Replaced with Other_MDU_F4__c
             * hl3Item.additionalOpExNrc__c = (sourceCD.OP_Res_Gateway_Total_Cost_Comb_Cost__c == null ? 0 : sourceCD.OP_Res_Gateway_Total_Cost_Comb_Cost__c) + 
             *    (sourceCD.Other_AC_Power_CAT_6_Expense__c == null ? 0 : sourceCD.Other_AC_Power_CAT_6_Expense__c);
             */
            Integer totSRUnits = 0;
            Integer totSOUnits = 0;
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
                totSRUnits = sourceCD.Total_SFH_Rental_Units_NM__c != null ? Integer.valueOf(sourceCD.Total_SFH_Rental_Units_NM__c) : 0;
                totSOUnits = sourceCD.Total_SFH_Owner_Units_NM__c != null ? Integer.valueOf(sourceCD.Total_SFH_Owner_Units_NM__c) : 0;
            } else {
                totSRUnits = sourceCD.Total_SFH_Rental_Units__c != null ? Integer.valueOf(sourceCD.Total_SFH_Rental_Units__c) : 0;
                totSOUnits = sourceCD.Total_SFH_Owner_Units__c != null ? Integer.valueOf(sourceCD.Total_SFH_Owner_Units__c) : 0;
			}
            Integer totalSFUs = totSRUnits + totSOUnits;
            
            Integer totCRUnits = 0;
            Integer totTRUnits = 0;
            Integer totCOUnits = 0;
            Integer totTOUnits = 0;
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
                totCRUnits = sourceCD.Total_Cottage_Rental_Units_NM__c != null ? Integer.valueOf(sourceCD.Total_Cottage_Rental_Units_NM__c) : 0;
                totTRUnits = sourceCD.Total_Tower_Rental_Units_NM__c != null ? Integer.valueOf(sourceCD.Total_Tower_Rental_Units_NM__c) : 0;
                totCOUnits = sourceCD.Total_Cottage_Owner_Units_NM__c != null ? Integer.valueOf(sourceCD.Total_Cottage_Owner_Units_NM__c) : 0;
                totTOUnits = sourceCD.Total_Tower_Owner_Units_NM__c != null ? Integer.valueOf(sourceCD.Total_Tower_Owner_Units_NM__c) : 0;
            } else {
                totCRUnits = sourceCD.Total_Cottage_Rental_Units__c != null ? Integer.valueOf(sourceCD.Total_Cottage_Rental_Units__c) : 0;
                totTRUnits = sourceCD.Total_Tower_Rental_Units__c != null ? Integer.valueOf(sourceCD.Total_Tower_Rental_Units__c) : 0;
                totCOUnits = sourceCD.Total_Cottage_Owner_Units__c != null ? Integer.valueOf(sourceCD.Total_Cottage_Owner_Units__c) : 0;
                totTOUnits = sourceCD.Total_Tower_Owner_Units__c != null ? Integer.valueOf(sourceCD.Total_Tower_Owner_Units__c) : 0;
            }
            Integer totMRUnits = totCRUnits + totTRUnits;
            Integer totMOUnits = totCOUnits + totTOUnits;
            Integer totalMDUs = totMRUnits + totMOUnits;

            //QFCJ-4188 BRAIN double counting of the Gateway costs
            Decimal totalOtherAndMDUF4 = (sourceCD.Other_MDU_F4__c == null ? 0.0 : sourceCD.Other_MDU_F4__c);
            Decimal resGatewayCosts = (sourceCD.OP_Res_Gateway_Total_Cost_Comb_Cost__c == null ? 0.0 : sourceCD.OP_Res_Gateway_Total_Cost_Comb_Cost__c);
            Decimal adjustedOtherAndMDUF4 = totalOtherAndMDUF4 - resGatewayCosts;
            
            //QFCJ-4512 Correct IW BRAIN Mapping combined with QFCJ-4188                
			if (!sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING) && sourceCD.Technology_Type__c.equalsIgnoreCase(INSTANT_WIFI)) {
                hl3Item.additionalOpExMrc__c = sourceCD.Recurring_Additional_Expenses_Monthly__c;
                hl3Item.additionalOpExNrc__c = sourceCD.One_Time_Additional_Expense__c + adjustedOtherAndMDUF4;
            } else {
	            hl3Item.additionalOpExMrc__c = 0;
                if (totalSFUs > 0) {
					//QFCJ-4514 Drop-Cost-Source
                    if (String.isBlank(hl3Item.productType__c) || String.isBlank(hl3Item.dropCostSource__c) || (!String.isBlank(hl3Item.productType__c) && hl3Item.productType__c.equalsIgnoreCase('FTTH') && !String.isBlank(hl3Item.dropCostSource__c) && hl3Item.dropCostSource__c.equalsIgnoreCase('STANDARD'))) {
	                    hl3Item.additionalOpExNrc__c = 0;
                    } else {
	                    hl3Item.additionalOpExNrc__c = (sourceCD.F4_Inside_Wiring_SFH__c == null ? 0.00 : sourceCD.F4_Inside_Wiring_SFH__c) + 
                            							adjustedOtherAndMDUF4;
                    }
                } else {
                    hl3Item.additionalOpExNrc__c = adjustedOtherAndMDUF4;
                }
            }
            hl3Item.occupantType__c = sourceCD.Occupant_Type__c;
            hl3Item.lotFrontageFeet__c = Decimal.valueOf((sourceCD.for_SFU_Average_Lot_Size__c != null ? sourceCD.for_SFU_Average_Lot_Size__c.isNumeric() ? sourceCD.for_SFU_Average_Lot_Size__c : '0' : '0'));
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
				hl3Item.maxDownstreamSpeedKbps__c = (sourceCD.Max_Downstream_Speed_NM__c != null ? sourceCD.Max_Downstream_Speed_NM__c : 0) * 1000;
            } else {
            	hl3Item.maxDownstreamSpeedKbps__c = Decimal.valueOf((associatedOppty.Property__r.Max_Bandwidth_Available__c != null ? associatedOppty.Property__r.Max_Bandwidth_Available__c.isNumeric() ? associatedOppty.Property__r.Max_Bandwidth_Available__c : '0' : '0')) * 1000;
            }
            
            //QFCJ-4007 Enabling BROWNFIELD being sent to BRAIN with QFCJ-4088 Implement ClusterId
            //        AND QFCJ-4264 Cluster Not Available
            //        AND QFCJ-4548 Repurpose 'Cluster ID Not Available' Checkbox
            /* if (sourceCD.Cluster_not_Available__c != null && sourceCD.Cluster_not_Available__c) {
	           	hl3Item.clusterId__c = null;                
            } else {
	           	hl3Item.clusterId__c = sourceCD.Cluster_ID__c;
            } */
            hl3Item.clusterId__c = sourceCD.Cluster_ID__c;
                        
            //The following were new to BRAIN release
            hl3Item.fdhCost__c = 0.00;
            hl3Item.splitterCost__c = 0.00;
            hl3Item.splitterPorts__c = 0;
            hl3Item.idfElectronicsCost__c = sourceCD.Electronics_Shelf_UPS_Cost__c;
            //end new to BRAIN release

			//Associated to Instant WiFi            
            hl3Item.wirelessAccessPointsCost__c = (sourceCD.Wireless_Access_Points_Cost__c == null ? 0.00 : sourceCD.Wireless_Access_Points_Cost__c);
            
            //QFCJ-4309 and QFCJ-4264 and QFCJ-4807
            /***************************************************************************************************************************
            if (!sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING) && sourceCD.Development_Status__c !=null && 
                	sourceCD.Development_Status__c.equalsIgnoreCase('brownfield') && 
                    sourceCD.Cluster_not_Available__c != null && sourceCD.Cluster_not_Available__c) {
                String legacyBaseCTIn = null;
                ContractTypeMap baseCTMap = mapContractTypeWithOtherProviderContractType(legacyBaseCTIn);
                hl3Item.baseContractType__c = baseCTMap.contractType;
            } else 
             ***************************************************************************************************************************/ 
			if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
                if (sourceCD.Development_Status_NM__c !=null && sourceCD.Development_Status_NM__c.equalsIgnoreCase('greenfield')) {
        	        hl3Item.baseContractType__c = null;
                } else {
                    hl3Item.baseContractType__c = (sourceCD.Network_Investment__c !=null && sourceCD.Network_Investment__c.equalsIgnoreCase('PRODUCT')) ? 'COMPETITIVE LOSS' : 'NONE'; 
                }
            } else {
	            System.debug('(BRAINFARequestHelper.composeFromCapitalDesign) sourceCD.Network_Investment__c  = ' + sourceCD.Network_Investment__c);
                String legacyBaseCTIn = (sourceCD.Network_Investment__c !=null && sourceCD.Network_Investment__c.equalsIgnoreCase('NEW DEVELOPMENT')) ? null : (sourceCD.Network_Investment__c.equalsIgnoreCase('PRODUCT')) ? 'COMPETITIVE LOSS' : 'NONE';
	            System.debug('(BRAINFARequestHelper.composeFromCapitalDesign) legacyBaseCTIn = ' + legacyBaseCTIn);
                ContractTypeMap baseCTMap = mapContractTypeWithOtherProviderContractType(legacyBaseCTIn);
                hl3Item.baseContractType__c = baseCTMap.contractType;
            }            
            
            String legacyConTypeIn = null;
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
                legacyConTypeIn = 'NONE';
            } else {
	         	 legacyConTypeIn = 'NONE';
            }
            if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
                hl3Item.contractType__c = 'NONE';
                hl3Item.otherProviderContractType__c = 'NoCompetition';
            } else {
                ContractTypeMap ctMap = mapContractTypeWithOtherProviderContractType(legacyConTypeIn);
                hl3Item.contractType__c = ctMap.contractType;
                hl3Item.otherProviderContractType__c = ctMap.otherProviderContractType;
            }
            /***********************************************************************************
            * if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
            *    hl3Item.contractType__c = 'NONE';
            * } else {
	        * 	 hl3Item.contractType__c = associatedOppty.Sole_Provider__c == 'Yes' ? 'SOLE PROVIDER' : 
			* 		(sourceCD.Offer__r.Offer_Type__c == 'Exclusive Marketing') ? 'EMA' :
			*       (sourceCD.Offer__r.Offer_Type__c == 'Shared Marketing') ? 'SMA' :
			*       (sourceCD.Offer__r.Offer_Type__c ==  'Bulk Agreement') ? 'BULK' :
			*       (sourceCD.Offer__r.Offer_Type__c == 'Building Entry Agreement') ? 'COMPETITIVE LOSS' : 'NONE';
            * }
            **************************************************************************************************** 
            *   This will need to be added into the BRAIN process... 
            *      BAU/CapDesign should be NoCompetition by DEFAULT, 
            *      Offer could have one of the values from the BRAIN documentation
            * hl3Item.otherProviderContractType = 'NoCompetition';              
            *************************************************************************************/ 
                
            hl3Item.contractTermMonths__c = 0;                
            /***********************************************************************************
            *	if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
	        *	    hl3Item.contractTermMonths__c = 0;
            *	} else {
			*       hl3Item.contractTermMonths__c = Decimal.valueOf((sourceCD.Offer__r.Contract_Term__c != null ? sourceCD.Offer__r.Contract_Term__c.isNumeric() ? sourceCD.Offer__r.Contract_Term__c : '0' : '0'));
			*	}
			************************************************************************************/
            //QFCJ-4541[Map Product in SFAINT to Technology Type in SFCJ for NMA]
            String cdTechType = sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING) ? (sourceCD.Product__c.equalsIgnoreCase('CTLOn') ? 'FTTU' : (sourceCD.Product__c.equalsIgnoreCase('FTTH') ? 'FTTB' : sourceCD.Product__c)) : sourceCD.Technology_Type__c;
            String cdSvcType = sourceCD.Service_Type__c;            
    		String techTypeSpecified = ( sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING) ? cdTechType : 
                                        (totalSFUs > 0) ? ((cdTechType.equalsIgnoreCase('CO-IP') || cdTechType.equalsIgnoreCase('FTTN') || cdTechType.equalsIgnoreCase('DSL')) ? 'DSL' : cdTechType) :
            						    ((cdTechType.equalsIgnoreCase('CO-IP') || cdTechType.equalsIgnoreCase('FTTN') || cdTechType.equalsIgnoreCase('DSL') || ( (cdTechType.equalsIgnoreCase(FTTIDF_GFAST) || cdTechType.equalsIgnoreCase(FTTIDF_CAT5)) && ((cdSvcType != null) && (!cdSvcType.equalsIgnoreCase(CTLON)))) ) ? 'DSL' : cdTechType) );
                /**********************************************************************
                *   Explanation of above (above used for improved code coverage %)
                * 
                * 
                *   if (sourceCD.Total_SFH_Owner_Units__c + sourceCD.Total_SFH_Rental_Units__c> 0) {
                *      if (sourceCD.Technology_Type__c == 'CO-IP' || sourceCD.Technology_Type__c == 'FTTN' || sourceCD.Technology_Type__c == 'DSL') 
                *      {
                *          techTypeSpecified = 'DSL';
                *      } else {
                *          techTypeSpecified = sourceCD.Technology_Type__c;
                *      }
            	*   } else {
                *      if (sourceCD.Technology_Type__c == 'CO-IP' || sourceCD.Technology_Type__c == 'FTTN' || sourceCD.Technology_Type__c == 'DSL' || ( (sourceCD.Technology_Type__c == FTTIDF_GFAST || sourceCD.Technology_Type__c == FTTIDF_CAT5) && sourceCD.Service_Type__c != null && sourceCD.Service_Type__c != CTLON) ) {
                *         techTypeSpecified = 'DSL';
                *      } else {
                *         techTypeSpecified = sourceCD.Technology_Type__c;
                *      }
            	*   }
                *************************************************************************/                        
            System.debug('(CapDesign) techTypeSpecified = ' + techTypeSpecified);
                
            Hl3ItemOverride__c hl3ItemOverride = new Hl3ItemOverride__c();
               /**********************************************************************  
                * BRAIN expects this to be NULL unless specifically overridden, but not sure when that applies,
                * so setting it to null until that logic can be determined and applied in SFCJ
                *        OP_ONT_Total_Cost_Comb_Cost__c is being replaced with: MDU_ONT_Drop__c
                *   hl3ItemOverride.ontCost__c = sourceCD.OP_ONT_Total_Cost_Comb_Cost__c;
                * 
                * ontCostSource: (one of PROVIDED, STANDARD)
                *    Tells BRAIN what value to use for ONT cost. 
                * 		PROVIDED uses the provided ONT cost, 
                * 		STANDARD has BRAIN calculate the value for ONT Cost based on site attributes. 
                *    This is required for fiber products (which require an ONT to deliver the service) and 
                * 		should be left null for copper products (for which an ONT is not used).
                * 
                * ontCost: (number)
                * 	The total ONT cost for the Hl3Item. This is required when ontCostSource is set to PROVIDED.
                *************************************************************************/
            if (techTypeSpecified == 'DSL') {
	            hl3ItemOverride.ontCostSource__c = null;
                hl3ItemOverride.ontCost__c = null;
            } else {
	            hl3ItemOverride.ontCostSource__c = sourceCD.Service_Type__c.equalsIgnoreCase('Retail') ? 'STANDARD' : 'PROVIDED';
                hl3ItemOverride.ontCost__c = sourceCD.Service_Type__c.equalsIgnoreCase('Retail') ? null : (sourceCD.MDU_ONT_Drop__c != null && sourceCD.MDU_ONT_Drop__c != 0) ? sourceCD.MDU_ONT_Drop__c : 0;
            }
                /**********************************************************************
                *   Explanation of above (above used for improved code coverage %)
                * 
                * 
                *    if (sourceCD.Service_Type__c == 'Retail') {
                *        if (techTypeSpecified == 'DSL') {
                *        	hl3ItemOverride.ontCostSource__c = null;
                *        } else {
                *        	hl3ItemOverride.ontCostSource__c = 'STANDARD';
                *        }
                *    } else {
                *        if (techTypeSpecified == 'DSL') {
                *    	    hl3ItemOverride.ontCostSource__c = null;
                *        } else {
                *        	hl3ItemOverride.ontCostSource__c = 'PROVIDED';
                *        }           
                *    }    
                *************************************************************************/                        
                        
            //add child object hl2Item
            hl2ItemsList.add(hl2Item);
            
            hl2ItemsList = BRAINFAObjectDMLManager.upsertHL2ItemList(hl2ItemsList);
                
            //set hl2ItemId as hl2ItemMaster__c
            hl3Item.hl2ItemMaster__c = hl2ItemsList?.get(0)?.Id;
            
            //Add this hl3Item to list of hl3Items for initial BRAINFAObjectDMLManager.upsert
            hl3ItemsList.add(hl3Item);
            
            //update hl3Item with its subobjects' ids
            hl3ItemsList = BRAINFAObjectDMLManager.upsertHL3ItemList(hl3ItemsList);
            System.debug('(BRAINFARequestHelper.composeFromCapDesignData) AFTER UPSERT HL3ItemList, hl3ItemsList?.get(0)?.Id = ' + hl3ItemsList?.get(0)?.Id);

            List<demographic__c> demographicsList = new List<demographic__c>();
            demographic__c demographic = null;
            
            //Using totCRUnits and totTRUnits defined above, build Demographic for MDU Rental
            demographic = new demographic__c();
            demographic.quantity__c =  totCRUnits + totTRUnits;
            demographic.rental__c = true;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined MDU-Rental demographic to list of demographics if # of units > 0
            if (totCRUnits + totTRUnits > 0) {
                demographicsList.add(demographic);
            }
            
            //Using totSRUnitsdefined above, build Demographic for SFU Rental
            demographic = new demographic__c();
            demographic.quantity__c =  totSRUnits;
            demographic.rental__c = true;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined SFU-Rental demographic to list of demographics if # of units > 0
            if (totSRUnits > 0) {
                demographicsList.add(demographic);
            }
            
            //Using totCOUnits and totTOUnits defined above, build Demographic for MDU Owner-Occupied
            demographic = new demographic__c();
            demographic.quantity__c =  totCOUnits + totTOUnits;
            demographic.rental__c = false;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined MDU-OO demographic to list of demographics if # of units > 0
            if (totCOUnits + totTOUnits > 0) {
                demographicsList.add(demographic);
            }
            
            //Using totSOUnits defined above, build Demographic for SFU Owner-Occupied
            demographic = new demographic__c();
            demographic.quantity__c =  totSOUnits;
            demographic.rental__c = false;
            demographic.incomeLevel__c = 0;
            demographic.hl3ItemMaster__c = hl3ItemsList.get(0).Id;
            //Add this fully-defined SFU-OO demographic to list of demographics if # of units > 0
            if (totSOUnits > 0) {
                demographicsList.add(demographic);
            }
                /**********************************************************************
                *   Explanation of above (above used for improved code coverage %)
                * 
                * 
                *             if (sourceCD.Total_Cottage_Rental_Units__c + sourceCD.Total_Tower_Rental_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_Cottage_Rental_Units__c + sourceCD.Total_Tower_Rental_Units__c);
                *                 demographic.rental__c = true;
                *             } else if (sourceCD.Total_Cottage_Owner_Units__c + sourceCD.Total_Tower_Owner_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_Cottage_Owner_Units__c + sourceCD.Total_Tower_Owner_Units__c);
                *                 demographic.rental__c = false;
                *             } else if (sourceCD.Total_SFH_Rental_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_SFH_Rental_Units__c);
                *                 demographic.rental__c = true;
                *             } else if (sourceCD.Total_SFH_Owner_Units__c > 0) {
                *                 demographic.quantity__c = Integer.valueOf(sourceCD.Total_SFH_Owner_Units__c);
                *                 demographic.rental__c = false;
                *             } else {
                *                 demographic.quantity__c = 0;
                *                 demographic.rental__c = false;            
                *             }
                *************************************************************************/                
            //add child object demographicList
            demographicsList = BRAINFAObjectDMLManager.upsertDemographicList(demographicsList);                    
            
            //Set demographicsList as hl3Item > demographics  
            hl3ItemsList.get(0).demographics__c = demographicsList.get(0).Id;
            
            //set hl3ItemId as hl3ItemMaster__c
            hl3ItemOverride.hl3ItemMaster__c = hl3ItemsList?.get(0)?.Id;
            
            //add child object hl3ItemOverride
            hl3ItemOverride = BRAINFAObjectDMLManager.upsertHL3ItemOverride(hl3ItemOverride);
            
            //Set hl3ItemOverride as hl3Item > hl3ItemOverride
            hl3Item.hl3ItemOverride__c = hl3ItemOverride.Id;
                        
            //update hl3Item in the hl3ItemsList with its subobjects' ids
            hl3ItemsList = BRAINFAObjectDMLManager.upsertHL3ItemList(hl3ItemsList);
            
            //Convert list of hl3Items to Array and set as hl2Item > hl3Items
            hl2ItemsList.get(0).hl3Items__c = hl3ItemsList?.get(0)?.Id;
            
            //update hl2Item with its subobject's ids
            hl2ItemsList = BRAINFAObjectDMLManager.upsertHL2ItemList(hl2ItemsList);
            
            //Convert list of hl2Items to Array and set as faRequest > hl2Items
            faRequest.hl2Items__c = hl2ItemsList?.get(0)?.Id;
        } catch(Exception  composeReqX) {
            System.debug('(BRAINFARequestHelper.composeFromCapDesignData) EXCEPTION! \n' + composeReqX.getTypeName() + '\n' + composeReqX.getMessage() + '\n' + composeReqX.getLineNumber() + '\n' + composeReqX.getStackTraceString());
            faRequest = null;
        }
        return faRequest;
    }//end method composeFromCapDesignData

    public static hl3Item__c buildDistrF2AndDropCostForHL3Item(hl3Item__c hl3Item, Id capDesignId) {
		Capital_Design__c sourceCD = null;        

               /*********************************************************************
                *  Explanation of Drop Cost for QFCJ-4268 "Update Drop Cost Values being set incorrectly"
                * When Development_Status__c is GREENFIELD 
                *      AND Building_Style__c is SFU CTL-ON or SFU BULK, 
                *      AND TechType of FTTU, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
                *       AND Set BRAIN productType to CTLON
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to OP_F3_Total_Cost_Comb_Cost
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to Distribution_F2
                * 
                *  
                * When Development_Status__c is BROWNFIELD
                *  	   AND Building_Style__c is SFU CTL-ON or BULK, 
                *      AND TechType of FTTU, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to value of Network_Investment__c
                *       AND Set BRAIN productType to CTLON
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to OP_F3_Total_Cost_Comb_Cost
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to Distribution_F2
                * 
                *  
                * When Development_Status__c is GREENFIELD 
                * 	   AND Building_Style__c is SFU RETAIL, 
                *      AND TechType of FTTU, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
                *       AND Set BRAIN productType to FTTH
                *       AND Set dropCostSource to STANDARD
                *       AND Set dropCost to null (as BRAIN ignores dropCost when dropCostSource is STANDARD)
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to Distribution_F2
                * 
                *  
                * When Development_Status__c is BROWNFIELD
                *  	   AND Building_Style__c is SFU RETAIL, 
                *      AND TechType of FTTU, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to value of Network_Investment__c
                *       AND Set BRAIN productType to FTTH
                *       AND Set dropCostSource to STANDARD
                *       AND Set dropCost to null (as BRAIN ignores dropCost when dropCostSource is STANDARD)
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to Distribution_F2
                * 
                *  
                * When Development_Status__c is GREENFIELD
                *  	   AND Building_Style__c is Cottage CTL-ON, Midrise CTL-ON or Highrise CTL-ON 
                *      AND TechType of Instant WiFi,
                *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
                *       AND Set BRAIN productType to Instant WiFi
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to 0.00
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to Distribution_F2
                * 
                *  
                * When Development_Status__c is GREENFIELD 
                *  	   AND Building_Style__c is Midrise CTL-ON or Highrise CTL-ON, Midrise Bulk or Highrise Bulk
                *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
                *       AND Set BRAIN productType to CTLON
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to 0.00
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to Distribution_F2
                * 
                *  
                * When Development_Status__c is BROWNFIELD
                *  	   AND Building_Style__c is Midrise CTL-ON or Highrise CTL-ON, Midrise Bulk or Highrise Bulk
                *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to value of Network_Investment__c
                *       AND Set BRAIN productType to CTLON
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to 0.00
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to Distribution_F2
                * 
                *  
                * When Development_Status__c is GREENFIELD 
                *  	   AND Building_Style__c is Midrise Retail or Highrise Retail
                *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
                *       AND Set BRAIN productType to FTTH
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to 0.00
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to Distribution_F2
                * 
                *  
                * When Development_Status__c is BROWNFIELD
                *  	   AND Building_Style__c is Midrise Retail or Highrise Retail
                *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to value of Network_Investment__c
                *       AND Set BRAIN productType to FTTH
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to 0.00
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to Distribution_F2
                * 
                *  
                * When Development_Status__c is GREENFIELD
                *  	   AND Building_Style__c is Cottage CTL-ON or Cottage Bulk, 
                *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
                *       AND Set BRAIN productType to CTLON
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to OP_F3_Fiber_Stub_Sub_Cost_Comb_Cost__c
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to (OP_F2_Total_Cost_Combined_Cost__c - OP_F2_Conduit_Sub_cost_Combined_Cost__c) + OP_F3_Total_Cost_Comb_Cost__c
                * 
                *  
                * When Development_Status__c is BROWNFIELD
                *  	   AND Building_Style__c is Cottage CTL-ON or Cottage Bulk, 
                *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to value of Network_Investment__c
                *       AND Set BRAIN productType to CTLON
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to OP_F3_Fiber_Stub_Sub_Cost_Comb_Cost__c
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to (OP_F2_Total_Cost_Combined_Cost__c - OP_F2_Conduit_Sub_cost_Combined_Cost__c) + OP_F3_Total_Cost_Comb_Cost__c
                * 
                *  
                * When Development_Status__c is GREENFIELD
                *  	   AND Building_Style__c is Cottage Retail, 
                *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
                *       AND Set BRAIN productType to FTTH
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to OP_F3_Fiber_Stub_Sub_Cost_Comb_Cost__c
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to (OP_F2_Total_Cost_Combined_Cost__c - OP_F2_Conduit_Sub_cost_Combined_Cost__c) + OP_F3_Total_Cost_Comb_Cost__c
                * 
                *  
                * When Development_Status__c is BROWNFIELD
                *  	   AND Building_Style__c is Cottage Retail, 
                *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
                *      THEN Set BRAIN networkInvestmentType to value of Network_Investment__c
                *       AND Set BRAIN productType to FTTH
                *       AND Set dropCostSource to PROVIDED
                *       AND Set dropCost to OP_F3_Fiber_Stub_Sub_Cost_Comb_Cost__c
                *       AND Set f2CostSource to PROVIDED
                *       AND Set f2Cost to (OP_F2_Total_Cost_Combined_Cost__c - OP_F2_Conduit_Sub_cost_Combined_Cost__c) + OP_F3_Total_Cost_Comb_Cost__c
                * 
                *  
            *******************************************************************************/
        try {
            if (capDesignId == null) {
                throw new NullObjectException('CapitalDesignID for DropCost was NULL');
            }            
            List<Capital_Design__c> cdList = BRAINFAObjectSOQLManager.queryCapDesignListById(capDesignId);
            if (cdList == null || cdList?.size() == 0 || cdList?.get(0) == null) {
                throw new NullObjectException('Capital_Design__c ojbect for DropCost by CapDesignId = ' + capDesignId + ' was NULL');
            }
            sourceCD = cdList.get(0);
            
			//QFCJ-4541[Map Product in SFAINT to Technology Type in SFCJ for NMA]
            String cdTechType = sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING) ? (sourceCD.Product__c.equalsIgnoreCase('CTLOn') ? 'FTTU' : (sourceCD.Product__c.equalsIgnoreCase('FTTH') ? 'FTTB' : sourceCD.Product__c)) : sourceCD.Technology_Type__c;
            String cdSvcType = sourceCD.Service_Type__c;
            System.debug('(BRAINFARequestHelper.buildDistrF2AndDropCostForHL3Item) cdTechType = ' + cdTechType + '   AND cdSvcType = ' + cdSvcType + '   AND sourceCD.Development_Status__c = ' + sourceCD.Development_Status__c + '  AND sourceCD.Network_Investment__c = ' + sourceCD.Network_Investment__c + '  AND sourceCD.Building_Style__c = ' + sourceCD.Building_Style__c);
			//QFCJ-4541[Map Product in SFAINT to Technology Type in SFCJ for NMA]
            if ((sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING) && sourceCD.Development_Status_NM__c !=null && sourceCD.Development_Status_NM__c.equalsIgnoreCase('brownfield')) || 
                (!sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING) && sourceCD.Development_Status__c !=null && sourceCD.Development_Status__c.equalsIgnoreCase('brownfield'))) { //BROWNFIELD
                if (sourceCD.Building_Style__c != null && (sourceCD.Building_Style__c.equalsIgnoreCase('sfu ctl-on') ||
                     sourceCD.Building_Style__c.equalsIgnoreCase('sfu bulk')) &&
                    (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    //QFCJ-4264 Cluster Not Available
                    hl3Item.networkInvestmentType__c = sourceCD.Network_Investment__c != null ? sourceCD.Network_Investment__c.toUpperCase() : 'NONE';
                    hl3Item.productType__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'CTLON';
                    hl3Item.dropCostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'PROVIDED';
                    hl3Item.dropCost__c = sourceCD.OP_F3_Total_Cost_Comb_Cost__c;
                    hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                    hl3Item.f2CostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') ? null : 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && sourceCD.Building_Style__c.equalsIgnoreCase('sfu retail') &&
                           (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = sourceCD.Network_Investment__c != null ? sourceCD.Network_Investment__c.toUpperCase() : 'NONE';
                    hl3Item.productType__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'FTTH';
                    hl3Item.dropCostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'STANDARD';
                    hl3Item.dropCost__c = null;
                    hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                    hl3Item.f2CostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') ? null : 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && (sourceCD.Building_Style__c.equalsIgnoreCase('cottage ctl-on') || sourceCD.Building_Style__c.equalsIgnoreCase('cottage bulk')) &&
                           (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = sourceCD.Network_Investment__c != null ? sourceCD.Network_Investment__c.toUpperCase() : 'NONE';
                    hl3Item.productType__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'CTLON';
                    hl3Item.dropCostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'PROVIDED';
                    hl3Item.dropCost__c = sourceCD.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c;
                    hl3Item.f2Cost__c = (sourceCD.OP_F2_Total_Cost_Combined_Cost__c - sourceCD.OP_F2_Conduit_Sub_cost_Combined_Cost__c) + sourceCD.OP_F3_Total_Cost_Comb_Cost__c;
                    hl3Item.f2CostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') ? null : 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && sourceCD.Building_Style__c.equalsIgnoreCase('cottage retail') &&
                           (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = sourceCD.Network_Investment__c != null ? sourceCD.Network_Investment__c.toUpperCase() : 'NONE';
                    hl3Item.productType__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'FTTH';
                    hl3Item.dropCostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'PROVIDED';
                    hl3Item.dropCost__c = sourceCD.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c;
                    hl3Item.f2Cost__c = (sourceCD.OP_F2_Total_Cost_Combined_Cost__c - sourceCD.OP_F2_Conduit_Sub_cost_Combined_Cost__c) + sourceCD.OP_F3_Total_Cost_Comb_Cost__c;
                    hl3Item.f2CostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') ? null : 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && (sourceCD.Building_Style__c.equalsIgnoreCase('midrise ctl-on') ||
                           sourceCD.Building_Style__c.equalsIgnoreCase('highrise ctl-on') || sourceCD.Building_Style__c.equalsIgnoreCase('midrise bulk') ||
                           sourceCD.Building_Style__c.equalsIgnoreCase('highrise bulk')) &&
                           (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = sourceCD.Network_Investment__c != null ? sourceCD.Network_Investment__c.toUpperCase() : 'NONE';
                    hl3Item.productType__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'CTLON';
                    hl3Item.dropCostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'PROVIDED';
                    hl3Item.dropCost__c = 0.00;
                    hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                    hl3Item.f2CostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') ? null : 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && (sourceCD.Building_Style__c.equalsIgnoreCase('midrise retail') ||
                           sourceCD.Building_Style__c.equalsIgnoreCase('highrise retail')) && 
                           (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = sourceCD.Network_Investment__c != null ? sourceCD.Network_Investment__c.toUpperCase() : 'NONE';
                    hl3Item.productType__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'FTTH';
                    hl3Item.dropCostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'PROVIDED';
                    hl3Item.dropCost__c = 0.00;
                } else { //BROWNFIELD and NOT SFU CTL-ON/BULK/RETAIL and NOT Cottage CTL-ON/BULK/RETAIL and NOT Midrise CTL-ON/BULK/RETAIL and NOT Highrise CTL-ON/BULK/RETAIL
                    hl3Item.networkInvestmentType__c = sourceCD.Network_Investment__c != null ? sourceCD.Network_Investment__c.toUpperCase() : 'NONE';
                    hl3Item.productType__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : (cdTechType == null && cdSvcType != null &&  cdSvcType != 'CTL_ON') ? 'NONE' : ( (cdTechType == 'CO-IP' || cdTechType == 'FTTN' || cdTechType == 'DSL') && (cdSvcType != null && cdSvcType != 'CTL_ON') ) ? 'DSL' : 
                    						   ( (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == FTTIDF_GFAST || cdTechType == 'GPON' || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled' || cdTechType == 'CO-IP' || cdTechType == 'FTTN' || cdTechType == 'DSL') && (cdSvcType == 'CTL_ON') ) ? 'CTLON' : 
                                               ( (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'GPON' || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled') && (cdSvcType != null && cdSvcType != 'CTL_ON') ) ? 'FTTH' :  
                                                 (cdTechType == FTTIDF_GFAST && (cdSvcType != null && cdSvcType != 'CTL_ON') ) ? 'DSL' : 
                                                 (cdTechType == INSTANT_WIFI) ? 'Instant WiFi' :'NONE';
                    hl3Item.dropCostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : 'PROVIDED';
                    hl3Item.dropCost__c = (sourceCD.MDU_ONT_Drop__c == null ? 0.00 : sourceCD.MDU_ONT_Drop__c);                                                                            }                
                    hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                    hl3Item.f2CostSource__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') ? null : 'PROVIDED';
            } 
            else if ((sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING) && sourceCD.Development_Status_NM__c !=null && sourceCD.Development_Status_NM__c.equalsIgnoreCase('greenfield')) || 
                (!sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING) && sourceCD.Development_Status__c !=null && sourceCD.Development_Status__c.equalsIgnoreCase('greenfield'))) 
            { //GREENFIELD
                if (sourceCD.Building_Style__c != null && (sourceCD.Building_Style__c.equalsIgnoreCase('sfu ctl-on') || sourceCD.Building_Style__c.equalsIgnoreCase('sfu bulk')) &&
                    (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = 'NEW DEVELOPMENT';
                    hl3Item.productType__c = 'CTLON';
                    hl3Item.dropCostSource__c = 'PROVIDED';
                    hl3Item.dropCost__c = sourceCD.OP_F3_Total_Cost_Comb_Cost__c;
                    hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                    hl3Item.f2CostSource__c = 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && sourceCD.Building_Style__c.equalsIgnoreCase('sfu retail') &&
                           (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = 'NEW DEVELOPMENT';
                    hl3Item.productType__c = 'FTTH';
                    hl3Item.dropCostSource__c = 'STANDARD';
                    hl3Item.dropCost__c = null;
                    hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                    hl3Item.f2CostSource__c = 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && (sourceCD.Building_Style__c.equalsIgnoreCase('cottage ctl-on') ||
                           sourceCD.Building_Style__c.equalsIgnoreCase('midrise ctl-on') || sourceCD.Building_Style__c.equalsIgnoreCase('highrise ctl-on')) &&
                            (cdTechType == INSTANT_WIFI)) 
                {
                    hl3Item.networkInvestmentType__c = 'NEW DEVELOPMENT';
                    hl3Item.productType__c = 'Instant WiFi';
                    hl3Item.dropCostSource__c = 'PROVIDED';
                    hl3Item.dropCost__c = 0.00;
                    hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                    hl3Item.f2CostSource__c = 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && (sourceCD.Building_Style__c.equalsIgnoreCase('midrise ctl-on') ||
                           sourceCD.Building_Style__c.equalsIgnoreCase('highrise ctl-on') || sourceCD.Building_Style__c.equalsIgnoreCase('midrise bulk') ||
                           sourceCD.Building_Style__c.equalsIgnoreCase('highrise bulk')) &&
                            (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = 'NEW DEVELOPMENT';
                    hl3Item.productType__c = 'CTLON';
                    hl3Item.dropCostSource__c = 'PROVIDED';
                    hl3Item.dropCost__c = 0.00;
                    hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                    hl3Item.f2CostSource__c = 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && (sourceCD.Building_Style__c.equalsIgnoreCase('midrise retail') ||
                           sourceCD.Building_Style__c.equalsIgnoreCase('highrise retail')) && 
                            (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = 'NEW DEVELOPMENT';
                    hl3Item.productType__c = 'CTLON';
                    hl3Item.dropCostSource__c = 'PROVIDED';
                    hl3Item.dropCost__c = 0.00;
                    hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                    hl3Item.f2CostSource__c = 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && (sourceCD.Building_Style__c.equalsIgnoreCase('cottage ctl-on') ||
                           sourceCD.Building_Style__c.equalsIgnoreCase('cottage bulk')) &&
                           (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = 'NEW DEVELOPMENT';
                    hl3Item.productType__c = 'CTLON';
                    hl3Item.dropCostSource__c = 'PROVIDED';
                    hl3Item.dropCost__c = sourceCD.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c;
                    hl3Item.f2Cost__c = (sourceCD.OP_F2_Total_Cost_Combined_Cost__c - sourceCD.OP_F2_Conduit_Sub_cost_Combined_Cost__c) + sourceCD.OP_F3_Total_Cost_Comb_Cost__c;
                    hl3Item.f2CostSource__c = 'PROVIDED';
                } else if (sourceCD.Building_Style__c != null && sourceCD.Building_Style__c.equalsIgnoreCase('cottage retail') &&
                           (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled')) 
                {
                    hl3Item.networkInvestmentType__c = 'NEW DEVELOPMENT';
                    hl3Item.productType__c = 'FTTH';
                    hl3Item.dropCostSource__c = 'PROVIDED';
                    hl3Item.dropCost__c = sourceCD.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c;
                    hl3Item.f2Cost__c = (sourceCD.OP_F2_Total_Cost_Combined_Cost__c - sourceCD.OP_F2_Conduit_Sub_cost_Combined_Cost__c) + sourceCD.OP_F3_Total_Cost_Comb_Cost__c;
                    hl3Item.f2CostSource__c = 'PROVIDED';
                } else { //GREENFIELD and NOT SFU CTL-ON/BULK/RETAIL and NOT Cottage CTL-ON/BULK/RETAIL and NOT Midrise CTL-ON/BULK/RETAIL and NOT Highrise CTL-ON/BULK/RETAIL
                    hl3Item.networkInvestmentType__c = sourceCD.Network_Investment__c !=null ? sourceCD.Network_Investment__c.toUpperCase() : 'NONE';
                    hl3Item.productType__c = (cdTechType == null && cdSvcType != null &&  cdSvcType != 'CTL_ON') ? 'NONE' : ( (cdTechType == 'CO-IP' || cdTechType == 'FTTN' || cdTechType == 'DSL') && (cdSvcType != null && cdSvcType != 'CTL_ON') ) ? 'DSL' : 
                                             ( (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == FTTIDF_GFAST || cdTechType == 'GPON' || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled' || cdTechType == 'CO-IP' || cdTechType == 'FTTN' || cdTechType == 'DSL') && (cdSvcType == 'CTL_ON') ) ? 'CTLON' : 
                                             ( (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'GPON' || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled') && (cdSvcType != null && cdSvcType != 'CTL_ON') ) ? 'FTTH' :  
                                               (cdTechType == FTTIDF_GFAST && (cdSvcType != null && cdSvcType != 'CTL_ON') ) ? 'DSL' : (cdTechType == INSTANT_WIFI) ? 'Instant WiFi' :'NONE';
                    hl3Item.dropCostSource__c = 'PROVIDED';
                    hl3Item.dropCost__c = (sourceCD.MDU_ONT_Drop__c == null ? 0.00 : sourceCD.MDU_ONT_Drop__c); 
                    hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                    hl3Item.f2CostSource__c = 'PROVIDED';
                }                
            } else { //NOT BROWNFIELD NOR GREENFIELD
                hl3Item.networkInvestmentType__c = sourceCD.Network_Investment__c !=null ? sourceCD.Network_Investment__c.toUpperCase() : 'NONE';
                hl3Item.productType__c = hl3Item.networkInvestmentType__c.equalsIgnoreCase('NONE') || hl3Item.networkInvestmentType__c.equalsIgnoreCase('SPEED') ? null : (cdTechType == null && cdSvcType != null &&  cdSvcType != 'CTL_ON') ? 'NONE' : ( (cdTechType == 'CO-IP' || cdTechType == 'FTTN' || cdTechType == 'DSL') && (cdSvcType != null && cdSvcType != 'CTL_ON') ) ? 'DSL' : 
                ( (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == FTTIDF_GFAST || cdTechType == 'GPON' || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled' || cdTechType == 'CO-IP' || cdTechType == 'FTTN' || cdTechType == 'DSL') && (cdSvcType == 'CTL_ON') ) ? 'CTLON' : 
                ( (cdTechType == 'FTTU' || cdTechType == 'FTTB' || cdTechType == FTTIDF_CAT5 || cdTechType == 'GPON' || cdTechType == 'XGSPON Compliant' || cdTechType == 'XGSPON Enabled') && (cdSvcType != null && cdSvcType != 'CTL_ON') ) ? 'FTTH' :  
                (cdTechType == FTTIDF_GFAST && (cdSvcType != null && cdSvcType != 'CTL_ON') ) ? 'DSL' : 
                (cdTechType == INSTANT_WIFI) ? 'Instant WiFi' :'NONE';
                hl3Item.dropCostSource__c = 'PROVIDED';
                hl3Item.dropCost__c = (sourceCD.MDU_ONT_Drop__c == null ? 0.00 : sourceCD.MDU_ONT_Drop__c); 
                hl3Item.f2Cost__c = (sourceCD.Distribution_F2__c == null ? 0.00 : sourceCD.Distribution_F2__c);
                hl3Item.f2CostSource__c = 'PROVIDED';
            }
        } catch(Exception dropX) {
            System.debug('(BRAINFARequestHelper.buildDistrF2AndDropCostForHL3Item) EXCEPTION! \n' + dropX.getTypeName() + '\n' + dropX.getMessage() + '\n' + dropX.getLineNumber() + '\n' + dropX.getStackTraceString());
        }
        return hl3Item;
    }//end method buildDistrF2AndDropCostForHL3Item

    //QFCJ-4282
    public static String mapONTModelToBrainONT(String ontModelIn) {
    	String ontBrainOut = null;
        try {
            if (String.isBlank(ontModelIn)) {
                throw new NullObjectException('OntModelIn for determining MapONTModelToBrainONT was NULL');
            }
            switch on ontModelIn {
                when 'Calix-711GE-outdoor-FTTB', 'Adtran-TA352-outdoor-FTTB',
                	 'Adtran-TA374-outdoor-FTTB', 'Calix-716GE-outdoor-FTTB',
                	 'Calix-717GE-outdoor-FTTB', 'Calix-762GX-outdoor-FTTB' {
	                    ontBrainOut = 'Calix/Adtran Outdoor';
                }
                when 'Adtran-C424G-indoor-integrated-FTTU', 'Adtran-TA324-indoor-FTTIDF',
                	 'Adtran-TA374-indoor-FTTIDF', 'Adtran-TA411-indoor-FTTU',
                	 'Calix-716GE-i-indoor-FTTIDF', 'Calix-803G-indoor-FTTU',
                     'Calix-C844G-indoor-integrated-FTTU' {
	                    ontBrainOut = 'Calix/Adtran Indoor';
                }
                when 'Axon-C5500XK-indoor-integrated-FTTU', 'Axon-C6510XK-indoor-integrated-FTTU' {
	                    ontBrainOut = 'SmartNID';
                }
            }//end switch on ontModelIn			            
        } catch(Exception ontX) {
            System.debug('(BRAINFARequestHelper.mapONTModelToBrainONT) EXCEPTION! \n' + ontX.getTypeName() + '\n' + ontX.getMessage() + '\n' + ontX.getLineNumber() + '\n' + ontX.getStackTraceString());
            ontBrainOut = null;
        }
        return ontBrainOut;
    }//end method mapONTModelToBrainONT   

    //QFCJ-4309
    public static ContractTypeMap mapContractTypeWithOtherProviderContractType(String legacyContractTypeIn) {
        String newContractTypeOut = null;
    	String otherProvContractTypeOut = null;
        ContractTypeMap contractTypeMap = null;
        try {
            System.debug('(mapContractTypeWithOtherProviderContractType) legacyContractTypeIn = ' + legacyContractTypeIn);
            if (String.isBlank(legacyContractTypeIn)) {
                throw new NullObjectException('LegacyContractTypeIn for determining ContractTypeMap was NULL');
            }
            /***********************************************************************************
            * PREVIOUS LOGIC needs to be incorporated as well
            * if (sourceCD.Capital_Design_Type__c.equalsIgnoreCase(NON_MARKETING)) {
            *    hl3Item.contractType__c = 'NONE';
            * } else {
	        * 	hl3Item.contractType__c = associatedOppty.Sole_Provider__c == 'Yes' ? 'SOLE PROVIDER' : 
			* 		(sourceCD.Offer__r.Offer_Type__c == 'Exclusive Marketing') ? 'EMA' :
			*      (sourceCD.Offer__r.Offer_Type__c == 'Shared Marketing') ? 'SMA' :
			*      (sourceCD.Offer__r.Offer_Type__c ==  'Bulk Agreement') ? 'BULK' :
			*      (sourceCD.Offer__r.Offer_Type__c == 'Building Entry Agreement') ? 'COMPETITIVE LOSS' : 'NONE';
            * }
			***********************************************************************************/
            switch on legacyContractTypeIn {
                when 'NONE' {
                    	newContractTypeOut = 'NONE';
	                    otherProvContractTypeOut = 'MarketingAgreement';
                }
                when 'EMA', 'Exclusive Marketing' {
                    	newContractTypeOut = 'EMA';
	                    otherProvContractTypeOut = 'NonContracted';
                }
                when 'SMA', 'Shared Marketing' {
                    	newContractTypeOut = 'SMA';
	                    otherProvContractTypeOut = 'MarketingAgreement';
                }
                when 'BULK', 'Bulk Agreement' {
                    	newContractTypeOut = 'BULK';
	                    otherProvContractTypeOut = 'NoCompetition';
                }
                when 'COMPETITIVE LOSS', 'Building Entry Agreement' {
                    	newContractTypeOut = 'NONE';
	                    otherProvContractTypeOut = 'NonContracted';
                }
                when 'SOLE PROVIDER' {
                    	newContractTypeOut = 'EMA';
	                    otherProvContractTypeOut = 'NoCompetition';
                }
                when else {
                    	newContractTypeOut = null;
	                    otherProvContractTypeOut = null;
                }
            }//end switch on legacyContractTypeIn			            
           	contractTypeMap = new ContractTypeMap(newContractTypeOut, otherProvContractTypeOut);
        } catch(Exception typeX) {
            System.debug('(BRAINFARequestHelper.mapContractTypeWithOtherProviderContractType) EXCEPTION! \n' + typeX.getTypeName() + '\n' + typeX.getMessage() + '\n' + typeX.getLineNumber() + '\n' + typeX.getStackTraceString());
           	contractTypeMap = new ContractTypeMap(null, null);
        }
        return contractTypeMap;
    }//end method mapContractTypeWithOtherProviderContractType   

    public static String extractNumericValueFromPicklistString(String plStringIn) { 
        String numericValOut = null;
        String extractP1 = null;
        try {
            System.debug('(BRAINFARequestHelper.extractNumericValueFromPicklistString) plStringIn = "' + plStringIn + '"');
            if(String.isBlank(plStringIn)) {
                throw new NullObjectException('EXCEPTION! DL/UL value was null -- no selection was made');
            }
            if((!plStringIn.contains('/')) && (!plStringIn.contains('<'))) {
                throw new InvalidNumericPicklistStringException('Incoming String "' + plStringIn + '" does not contain expected "/" or "<".');
            }            
            if(plStringIn.contains('<')) {
                extractP1 = plStringIn.substringAfter('<');
            } else {
                extractP1 = plStringIn.substringBefore('/');
            }
            System.debug('(BRAINFARequestHelper.extractNumericValueFromPicklistString) extractP1 = "' + extractP1 + '"');
            if(!extractP1.contains('M')) {
                throw new InvalidNumericPicklistStringException('Parsed String "' + extractP1 + '" does not contain expected "M".');
            }
            String extractP2 = extractP1.substringBefore('M');
            System.debug('(BRAINFARequestHelper.extractNumericValueFromPicklistString) extractP2 = "' + extractP2 + '"');
            if(!extractP2.isNumeric()) {
                throw new InvalidNumericPicklistStringException('Parsed String "' + extractP2 + '" is not numeric.');
            }
            numericValOut = extractP2;
            System.debug('(BRAINFARequestHelper.extractNumericValueFromPicklistString) numericValOut = "' + numericValOut + '"');
            return numericValOut;
        } catch(Exception extractX) {
            System.debug('(BRAINFARequestHelper.extractNumericValueFromPicklistString) EXCEPTION! \n' + extractX.getTypeName() + '\n' + extractX.getMessage() + '\n' + extractX.getLineNumber() + '\n' + extractX.getStackTraceString());
            numericValOut = null;
	        return numericValOut;
        }
    }//end method getNumericValueFromPicklistString

    @AuraEnabled
    public static BRAIN_FA_Request__c queryFARequestById(Id faRequestId) {
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
                throw new NullObjectException('EXCEPTION! Query for BRAIN_FA_Request__c object records with Id ' + faRequestId.to15() + ' returned NULL');
            }
            return faRequest;
        } catch(Exception queryX) {
            System.debug('(BRAINFARequestHelper.queryFARequestById-GHOSTED) EXCEPTION! \n' + queryX.getTypeName() + '\n' + queryX.getMessage() + '\n' + queryX.getLineNumber() + '\n' + queryX.getStackTraceString());
            throw queryX;
        }
    }//end method queryFARequestById
	
    //QFCJ-4309
    public with sharing class ContractTypeMap {
        public String contractType;
        public String otherProviderContractType;
        public ContractTypeMap (String contractTypeIn, String otherProviderContractTypeIn) {
            this.contractType = contractTypeIn;
            this.otherProviderContractType = otherProviderContractTypeIn;
        }
    }//end public class ContractTypeMap
     
}//end class BRAINFARequestHelper