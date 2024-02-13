/***************************************************************
===============================================================
Purpose: Prospector Check Callout Controller class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/26/2022   ESCJ-653  	  Initial draft
Stan & Ted 10/07/2022   ESCJ-1975     Fix issues preventing PRR processing
***************************************************************/
public class ProspectorCheckCalloutController implements Queueable, Database.AllowsCallouts { 

    public void execute(QueueableContext ctx) {
        ProspectorCheckCalloutHelper.allApiTransactionsServiceManager = new ApiTransactionService(true);
        processWorkingTable();
        this.clearState();
        ProspectorCheckCalloutHelper.commitChanges();
    }//end method execute
    
    public static void processWorkingTable() { 
        Id transactionSummaryId = null;
        ProspectorListJobsWrap ljResWrapper = new ProspectorListJobsWrap();
        ProspectorListJobsCallout pljCallout = new ProspectorListJobsCallout(transactionSummaryId); 
        List<Property__c> allPropsToBeUpdatedList = new List<Property__c>();
        List<Property__c> allPropUpdList = new List<Property__c>();
        List<Prospector_Working_Table__c> allPwtToDeleteList = new List<Prospector_Working_Table__c>();
        
        
        //Process Green
        System.debug('ProspectorCheckCalloutController.processWorkingTable) Processing Green now...');
        List<ProspectorCheckCalloutHelper.ProspectorProjectId> ppiList = ProspectorCheckCalloutHelper.retrieveDistinctProjIdsFromProspectorWorkingTable(ProspectorCalloutHelper.GREEN);
        
        if (ppiList.size() > 0) {
            ljResWrapper = pljCallout.listJobs();
            /*
            for (API_Transaction__c apiT : ProspectorCheckCalloutHelper.allApiTransactionsServiceManager.apiTransactions) {
                //Integer apiTIdx = ProspectorCheckCalloutHelper.allApiTransactionsServiceManager.apiTransactions.indexOf(apiT);
                ProspectorCheckCalloutHelper.allApiTransactionsServiceManager.apiTransactions.add(apiT);        
            }*/
            
            if (ljResWrapper.payload != null){
                List<Prospector_Working_Table__c> pwtList = ProspectorCheckCalloutHelper.retrieveAllPropertyNameColorFromProspectorWorkingTable(ProspectorCalloutHelper.GREEN);
                ProspectorCheckCalloutHelper.compareLists(ppiList, ljResWrapper.payload, pwtList);
                
                //Add lists for GREEN to their associated all-Lists
                System.debug('(ProspectorCheckCalloutController.processWorkingTable) ProspectorCheckCalloutHelper.propsToBeUpdatedList?.size() = ' + ProspectorCheckCalloutHelper.propsToBeUpdatedList?.size()); 
                if (ProspectorCheckCalloutHelper.propsToBeUpdatedList != null && ProspectorCheckCalloutHelper.propsToBeUpdatedList.size() > 0) allPropsToBeUpdatedList.addAll(ProspectorCheckCalloutHelper.propsToBeUpdatedList);
                System.debug('(ProspectorCheckCalloutController.processWorkingTable) ProspectorCheckCalloutHelper.propUpdList?.size() = ' + ProspectorCheckCalloutHelper.propUpdList?.size()); 
                if (ProspectorCheckCalloutHelper.propUpdList != null && ProspectorCheckCalloutHelper.propUpdList.size() > 0) allPropUpdList.addAll(ProspectorCheckCalloutHelper.propUpdList);
                System.debug('(ProspectorCheckCalloutController.processWorkingTable) ProspectorCheckCalloutHelper.pwtToDeleteList?.size() = ' + ProspectorCheckCalloutHelper.pwtToDeleteList?.size());
                if (ProspectorCheckCalloutHelper.pwtToDeleteList != null && ProspectorCheckCalloutHelper.pwtToDeleteList.size() > 0) allPwtToDeleteList.addAll(ProspectorCheckCalloutHelper.pwtToDeleteList);
            }
        }//end if individual-project-id list size > 0
        System.debug('ProspectorCheckCalloutController.processWorkingTable) AFTER Green, allPropsToBeUpdatedList?.size() = ' + allPropsToBeUpdatedList?.size() + '\n allPropUpdList?.size() = ' + allPropUpdList?.size() + '\n allPwtToDeleteList?.size() = ' + allPwtToDeleteList?.size());
        
        //Process Red
        System.debug('ProspectorCheckCalloutController.processWorkingTable) Processing Red now...');
        ppiList = ProspectorCheckCalloutHelper.retrieveDistinctProjIdsFromProspectorWorkingTable(ProspectorCalloutHelper.RED);
        
        if (ppiList.size() > 0) {
            if (ljResWrapper.payload == null){
                ljResWrapper = pljCallout.listJobs();
            }
            
            if (ljResWrapper.payload != null){
                List<Prospector_Working_Table__c> pwtList = ProspectorCheckCalloutHelper.retrieveAllPropertyNameColorFromProspectorWorkingTable(ProspectorCalloutHelper.RED);
                ProspectorCheckCalloutHelper.compareLists(ppiList, ljResWrapper.payload, pwtList);
                
                //Add lists for RED to their associated all-Lists
                System.debug('(ProspectorCheckCalloutController.processWorkingTable) For Red, ProspectorCheckCalloutHelper.propsToBeUpdatedList?.size() = ' + ProspectorCheckCalloutHelper.propsToBeUpdatedList?.size()); 
                if (ProspectorCheckCalloutHelper.propsToBeUpdatedList != null && ProspectorCheckCalloutHelper.propsToBeUpdatedList.size() > 0) {
                    for (Property__c prop2BUpd : ProspectorCheckCalloutHelper.propsToBeUpdatedList) {
                        Boolean wasFound = false;
		                System.debug('(ProspectorCheckCalloutController.processWorkingTable) For Red-check-against-all, PRIOR to comparing, allPropsToBeUpdatedList?.size() = ' + allPropsToBeUpdatedList?.size()); 
                        for (Property__c allP2BU : allPropsToBeUpdatedList) {
                            if (prop2BUpd.Id == allP2BU.Id) {
                                //merge
                                allP2BU.MH_HH_Distance_to_Red_Fiber__c = prop2BUpd.MH_HH_Distance_to_Red_Fiber__c;
                                allP2BU.Splice_Closure_Distance_to_Red_Fiber__c = prop2BUpd.Splice_Closure_Distance_to_Red_Fiber__c;
                                
								System.debug('(ProspectorCheckCalloutController.processWorkingTable) Existing allP2BU.Distance_to_Fiber_Splice__c = ' + allP2BU.Distance_to_Fiber_Splice__c);
                                if (allP2BU.Distance_to_Fiber_Splice__c > 0) {
                                    //use existing value from Green
									System.debug('(ProspectorCheckCalloutController.processWorkingTable) Going to use the existing Green-allP2BU.Distance_to_Fiber_Splice__c = ' + allP2BU.Distance_to_Fiber_Splice__c);
                                } else {
                                    //use alternative value from Red
									System.debug('(ProspectorCheckCalloutController.processWorkingTable) Going to use the alternative Red-prop2Bupd.Distance_to_Fiber_Splice__c = ' + prop2BUpd.Distance_to_Fiber_Splice__c);
                                    allP2BU.Distance_to_Fiber_Splice__c = prop2BUpd.Distance_to_Fiber_Splice__c;
				                }
								System.debug('(ProspectorCheckCalloutController.processWorkingTable) Ending allP2BU.Distance_to_Fiber_Splice__c = ' + allP2BU.Distance_to_Fiber_Splice__c);
                                wasFound = true;
                            }//end if red/all-ids are equal
                        }//end for-loop thru list of all properties to be updated
                        if (!wasFound) {
							System.debug('(ProspectorCheckCalloutController.processWorkingTable) prop2BUpd NOT FOUND, prop2BUpd.Distance_to_Fiber_Splice__c = ' + prop2BUpd.Distance_to_Fiber_Splice__c);
                            allPropsToBeUpdatedList.add(prop2BUpd);
                        }
                    }//end for-loop thru list of Red properties to be updated
                }//end if list of Red properties to be updated > 0
                System.debug('(ProspectorCheckCalloutController.processWorkingTable) ProspectorCheckCalloutHelper.propUpdList?.size() = ' + ProspectorCheckCalloutHelper.propUpdList?.size()); 
                if (ProspectorCheckCalloutHelper.propUpdList != null && ProspectorCheckCalloutHelper.propUpdList.size() > 0) {
                    for (Property__c propUpd : ProspectorCheckCalloutHelper.propUpdList) {
                       Boolean wasFound = false;
                        for (Property__c allPU : allPropUpdList) {
                            if (propUpd.Id == allPU.Id) {
			                    wasFound = true;
	                        }
                        }
                        if (!wasFound) {
	                        allPropUpdList.add(propUpd);
                        }
                    }
                }
                System.debug('(ProspectorCheckCalloutController.processWorkingTable) ProspectorCheckCalloutHelper.pwtToDeleteList?.size() = ' + ProspectorCheckCalloutHelper.pwtToDeleteList?.size());
                if (ProspectorCheckCalloutHelper.pwtToDeleteList != null && ProspectorCheckCalloutHelper.pwtToDeleteList.size() > 0) {
                    for (Prospector_Working_Table__c pwt2Del : ProspectorCheckCalloutHelper.pwtToDeleteList) {
                        Boolean wasFound = false;
                        for (Prospector_Working_Table__c allPWT : allPwtToDeleteList) {
                            if (pwt2Del.Id == allPWT.Id) {
			                    wasFound = true;
	                        }
                        }
                        if (!wasFound) {
		                    allPwtToDeleteList.add(pwt2Del);
                        }
                    }
                }
            }
        }//end if individual-project-id list size > 0
        System.debug('ProspectorCheckCalloutController.processWorkingTable) AFTER Red, allPropsToBeUpdatedList?.size() = ' + allPropsToBeUpdatedList?.size() + '\n allPropUpdList?.size() = ' + allPropUpdList?.size() + '\n allPwtToDeleteList?.size() = ' + allPwtToDeleteList?.size());

        System.debug('(ProspectorCheckCalloutController.processWorkingTable) allPropsToBeUpdatedList?.size() = ' + allPropsToBeUpdatedList?.size()); 
        if (allPropsToBeUpdatedList != null && allPropsToBeUpdatedList.size() > 0) update allPropsToBeUpdatedList;
        System.debug('(ProspectorCheckCalloutController.processWorkingTable) allPropUpdList?.size() = ' + allPropUpdList?.size()); 
        if (allPropUpdList != null && allPropUpdList.size() > 0) update allPropUpdList;
        System.debug('(ProspectorCheckCalloutController.processWorkingTable) allPwtToDeleteList?.size() = ' + allPwtToDeleteList?.size());
        if (allPwtToDeleteList != null && allPwtToDeleteList.size() > 0) delete allPwtToDeleteList;
    }//end method processWorkingTable
    
    private void clearState() {
    }
    
}//end class ProspectorCheckCalloutController