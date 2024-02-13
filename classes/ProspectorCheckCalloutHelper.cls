/***************************************************************
===============================================================
Purpose: Prospector Check Callout Helper class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 09/14/2022   ESCJ-653  	  Initial draft
***************************************************************/
public class ProspectorCheckCalloutHelper {

/********************************
 *  List of Status Codes
 * Initializing = 0
 * ExtractingData = 4
 * ProcessingNetwork = 8
 * Solving = 12
 * Complete = 16
 * Cancelled = 20
 * Failed = 24
 * Shutdown = 28
 ********************************/
    
    //public static String transactionSummaryId;
    public static ApiTransactionService allApiTransactionsServiceManager;
    private static String facilityTypeCheck;
    public static List<Property__c> propsToBeUpdatedList;
    public static List<Property__c> propUpdList;
    public static List<Prospector_Working_Table__c> pwtToDeleteList;
    
    public static void compareLists(List<ProspectorCheckCalloutHelper.ProspectorProjectId> ppiList, List<ProspectorListJobsWrap.Payload> ljPayloadList, List<Prospector_Working_Table__c> pwtList) {
        Id transactionSummaryId = null;
        List<String> propertyIdsAlreadyProcessedForUpdate = new List<String>();
        //Reset the public lists containing records that need to be updated or deleted
        propsToBeUpdatedList = new List<Property__c>();
        propUpdList = new List<Property__c>();
        pwtToDeleteList = new List<Prospector_Working_Table__c>();
        
        System.debug('(ProspectorCheckCalloutHelper.compareLists) ppiList.size1: ' + ppiList.size());
        System.debug('(ProspectorCheckCalloutHelper.compareLists) ljPayloadList.size1: ' + ljPayloadList.size());
        System.debug('(ProspectorCheckCalloutHelper.compareLists) pwtList.size1: ' + pwtList.size());
        
        Set<Id> propertyEvalSet = new Set<Id>();
        for (Prospector_Working_Table__c pwtEval : pwtList) {
            propertyEvalSet.add(pwtEval.Property_Id__c);
        }        
		List<Property__c> propEvalList = [Select Id, MH_HH_Distance_to_Green_Fiber__c, Splice_Closure_Distance_to_Green_Fiber__c, MH_HH_Distance_to_Red_Fiber__c, Splice_Closure_Distance_to_Red_Fiber__c, Distance_to_Fiber_Splice__c, Prospector_Last_Update_Date__c 
                                            FROM Property__c                                             
                                           WHERE Id IN :propertyEvalSet];

        // list of submitted jobs and their demandPoint names
        for (ProspectorCheckCalloutHelper.ProspectorProjectId ppi: ppiList){
            // list of all submitted jobs and their current status
            Integer ctr = 0;
            Boolean isGTE16 = false;
            while (!isGTE16 && ctr < ljPayloadList.size()) {
                ProspectorListJobsWrap.Payload thisPl = ljPayloadList.get(ctr);
                /*
                System.debug('(ProspectorCheckCalloutHelper.compareLists) thisPl.projectId = ' + thisPl.projectId +
                             '\n ppi.projectId = ' + ppi.projectId + 
                             '\n Is thisPl.projectId==ppi.projectId? ' + (thisPl.projectId==ppi.projectId));
                System.debug('(ProspectorCheckCalloutHelper.compareLists) ctr = ' + ctr);
				*/
                if (thisPl.projectId == ppi.projectId) {                       
                    System.debug('(ProspectorCheckCalloutHelper.compareLists) thisPl.projectId = ' + thisPl.projectId + ' has thisPl.status = ' + thisPl.status);
                    if ((thisPl.status).isNumeric() && Integer.valueOf(thisPl.status) >= 16){
                        isGTE16 = true;

                        if ((thisPl.status).isNumeric() && Integer.valueOf(thisPl.status) > 16){
                            for (Prospector_Working_Table__c pwt : pwtList){
                                if (thisPl.projectId == pwt.Project_Id__c) {
                                    if (pwt != null && pwt.Id != null) pwtToDeleteList.add(pwt);
                                }
                            }
                        } else
                        if (Integer.valueOf(thisPl.status) == 16) {
                            ProspectorGetRoutesWrap grResWrapper;
                            ProspectorGetRoutesByProjectCallout pgrbpCallout = new ProspectorGetRoutesByProjectCallout(ppi.propertyTransactionSummaryId);
                            grResWrapper = pgrbpCallout.getRoutesByProject(ppi.projectId, null); //passing null for facilityType which will return MH_HH from Mock
                            for (API_Transaction__c apiT : allApiTransactionsServiceManager.apiTransactions) {
                                //Integer apiTIdx = allApiTransactionsServiceManager.apiTransactions.indexOf(apiT);
                                allApiTransactionsServiceManager.apiTransactions.add(apiT);        
                            }
                            if (grResWrapper != null) {
                                List<ProspectorGetRoutesWrap.Payload> routesPayloadList = grResWrapper.payload;
                                System.debug('(ProspectorCheckCalloutHelper.compareLists) pwtList.size2: ' + pwtList.size());
                                for (Prospector_Working_Table__c pwt : pwtList){
                                    if (thisPl.projectId == pwt.Project_Id__c) {
                                        System.debug('(ProspectorCheckCalloutHelper.compareLists) pwt.Id = ' + pwt.Id);
                                        if (pwt != null && pwt.Id != null) pwtToDeleteList.add(pwt);
		                                System.debug('(ProspectorCheckCalloutHelper.compareLists) routesPayloadList.size: ' + routesPayloadList.size());
                                        for (ProspectorGetRoutesWrap.Payload routesPL : routesPayloadList) {
                                            if (!ProspectorCheckCalloutHelper.evaluatePayloadForMatch(routesPL, pwt, propEvalList)) {
                                                // check childDetails to see if pwt matches in that childDetails-payload
                                                List<ProspectorGetRoutesWrap.Payload> routesChildDetails = routesPL.childDetails;
                                                for (ProspectorGetRoutesWrap.Payload routesCDPL : routesChildDetails) {
                                                    if (!ProspectorCheckCalloutHelper.evaluatePayloadForMatch(routesCDPL, pwt, propEvalList)) {
                                                        // check childDetails to see if pwt matches in that childDetails-payload
                                                        List<ProspectorGetRoutesWrap.Payload> nestedLayer3ChildDetails = routesCDPL.childDetails;
                                                        for (ProspectorGetRoutesWrap.Payload nl3CDPL : nestedLayer3ChildDetails) {
                                                            if (!ProspectorCheckCalloutHelper.evaluatePayloadForMatch(nl3CDPL, pwt, propEvalList)) {
                                                                // check childDetails to see if pwt matches in that childDetails-payload
                                                                List<ProspectorGetRoutesWrap.Payload> nestedLayer4ChildDetails = nl3CDPL.childDetails;
                                                                for (ProspectorGetRoutesWrap.Payload nl4CDPL : nestedLayer4ChildDetails) {
                                                                    if (!ProspectorCheckCalloutHelper.evaluatePayloadForMatch(nl4CDPL, pwt, propEvalList)) {
                                                                        // check childDetails to see if pwt matches in that childDetails-payload
                                                                        List<ProspectorGetRoutesWrap.Payload> nestedLayer5ChildDetails = nl4CDPL.childDetails;
                                                                        for (ProspectorGetRoutesWrap.Payload nl5CDPL : nestedLayer4ChildDetails) {
                                                                            if (!ProspectorCheckCalloutHelper.evaluatePayloadForMatch(nl5CDPL, pwt, propEvalList)) {
                                                                                // check childDetails to see if pwt matches in that childDetails-payload
                                                                                List<ProspectorGetRoutesWrap.Payload> nestedLayer6ChildDetails = nl5CDPL.childDetails;
                                                                                for (ProspectorGetRoutesWrap.Payload nl6CDPL : nestedLayer6ChildDetails) {
                                                                                    if (!ProspectorCheckCalloutHelper.evaluatePayloadForMatch(nl6CDPL, pwt, propEvalList)) {
                                                                                        // check childDetails to see if pwt matches in that childDetails-payload
                                                                                        List<ProspectorGetRoutesWrap.Payload> nestedLayer7ChildDetails = nl6CDPL.childDetails;
                                                                                        for (ProspectorGetRoutesWrap.Payload nl7CDPL : nestedLayer7ChildDetails) {
                                                                                            if (!ProspectorCheckCalloutHelper.evaluatePayloadForMatch(nl7CDPL, pwt, propEvalList)) {
                                                                                            }//end if nl7CDPL-DemandName != pwt-Property_Id__c
                                                                                        }//end for-loop thru nestedLayer7ChildDetails-payload
                                                                                    }//end if nl6CDPL-DemandName != pwt-Property_Id__c
                                                                                }//end for-loop thru nestedLayer6ChildDetails-payload
                                                                            }//end if nl5CDPL-DemandName != pwt-Property_Id__c
                                                                        }//end for-loop thru nestedLayer5ChildDetails-payload
                                                                    }//end if nl4CDPL-DemandName != pwt-Property_Id__c
                                                                }//end for-loop thru nestedLayer4ChildDetails-payload
                                                            }//end if nl3CDPL-DemandName != pwt-Property_Id__c
                                                        }//end for-loop thru nestedLayer3ChildDetails-payload
                                                    }//end if routesChildDetails-DemandName != pwt-Property_Id__c
                                                }//end for-loop thru childDetails-payload
                                            }//end if routes-DemandName != pwt-Property_Id__c
                                        }//end for-loop thru payload
                                    }//end if the payload-projectId matches the pwt-projectId
                                }//end for-loop thru pwt list
                            }//end if returned grResWrapper is NOT NULL
                        }//end if status == 16
                    }//end if status >= 16
                    else {
                    // jump out of loop once property is found AND status >= 16
                        ctr = ctr + ljPayloadList.size();
                    }
                }//end if projectName == projectId 
                ctr++;
            }//end while-loop thru payload list 
        }//end for-loop thru individual-project-id list 
        Set<Id> propertySet = new Set<Id>();
        for (Prospector_Working_Table__c pwtD : pwtToDeleteList) {
            propertySet.add(pwtD.Property_Id__c);
        }
        List<Property__c> propList = [Select Id from Property__c WHERE Id IN :propertySet];
        for (Property__c prop: propList) {
            if (!propertyIdsAlreadyProcessedForUpdate.contains(prop.Id)) {
                propertyIdsAlreadyProcessedForUpdate.add(prop.Id);
                prop.Prospector_Last_Update_Date__c = date.today();
                propUpdList.add(prop);
            }
        }
    }//end method compareLists
    
    public static boolean evaluatePayloadForMatch(ProspectorGetRoutesWrap.Payload payloadIn, Prospector_Working_Table__c pwtIn, List<Property__c> propList) {
        boolean isFound = false;
        System.debug('(ProspectorCheckCalloutHelper.evaluatePayloadForMatch) payloadIn.demandName = ' + payloadIn.demandName + 
                     '\n pwtIn.Property_Id__c = ' + pwtIn.Property_Id__c +
                     '\n payloadIn.demandName == pwtIn.Property_Id__c? ' + (payloadIn.demandName == pwtIn.Property_Id__c));

        if (payloadIn.facilityType != 'DAISY CHAIN') {
            facilityTypeCheck = payloadIn.facilityType;
        }
        
        if (payloadIn.demandName == pwtIn.Property_Id__c) {
            System.debug('(ProspectorCheckCalloutHelper.evaluatePayloadForMatch) propList?.size() = ' + propList?.size());
            System.debug('(ProspectorCheckCalloutHelper.evaluatePayloadForMatch) payloadIn.geodesicLength = ' + payloadIn.geodesicLength);
            
            Property__c prop = new Property__c();
            Integer foundIdx = 0;
            boolean propIdFound = false;
            while (!propIdFound && foundIdx < propList?.size()) {
                if (pwtIn.Property_Id__c == propList.get(foundIdx).Id) {
                    prop = propList.get(foundIdx);
                    propIdFound = true;
                }
                foundIdx++;
            }
            if (propIdFound) {
                if (facilityTypeCheck == 'MH_HH'){
                    if (pwtIn.Infrastructure_Layer_Color__c == 'Green') {
                        prop.MH_HH_Distance_to_Green_Fiber__c = payloadIn.geodesicLength;
                    } else {
                        prop.MH_HH_Distance_to_Red_Fiber__c = payloadIn.geodesicLength;
                    }
                } else if ((facilityTypeCheck == 'Splice_Closure') || (facilityTypeCheck == 'SpliceClosure')){
                    if (pwtIn.Infrastructure_Layer_Color__c == 'Green') {
                        prop.Splice_Closure_Distance_to_Green_Fiber__c = payloadIn.geodesicLength;
                    } else {
                        prop.Splice_Closure_Distance_to_Red_Fiber__c = payloadIn.geodesicLength;
                    }  
                }
                prop.Prospector_Last_Update_Date__c = date.today();
                if (prop.Splice_Closure_Distance_to_Green_Fiber__c >= 0){
                    prop.Distance_to_Fiber_Splice__c = prop.Splice_Closure_Distance_to_Green_Fiber__c;}
                else if (prop.MH_HH_Distance_to_Green_Fiber__c >= 0){
                    prop.Distance_to_Fiber_Splice__c = prop.MH_HH_Distance_to_Green_Fiber__c;}
                else if (prop.Splice_Closure_Distance_to_Red_Fiber__c >= 0){
                    prop.Distance_to_Fiber_Splice__c = prop.Splice_Closure_Distance_to_Red_Fiber__c;}
                else if (prop.MH_HH_Distance_to_Red_Fiber__c >= 0){
                    prop.Distance_to_Fiber_Splice__c = prop.MH_HH_Distance_to_Red_Fiber__c;
                }

                propsToBeUpdatedList.add(prop);                
            }
            isFound = true;            
        }//end if payloadIn-DemandName EQUALS pwtIn-Property_Id__c
        
        return isFound;
    }//end method evaluatePayloadForMatch    

    public static List<ProspectorProjectId> retrieveDistinctProjIdsFromProspectorWorkingTable(String colorIn) {        
        ProspectorProjectId ppi = new ProspectorProjectId();
        List<ProspectorProjectId> ppiList = new List<ProspectorProjectId>();
        List<Prospector_Working_Table__c> pwtList = 
            [SELECT Project_Id__c, Property_Transaction_Summary__c 
               FROM Prospector_Working_Table__c 
              WHERE Infrastructure_Layer_Color__c = :colorIn 
              ORDER BY Project_Id__c ASC];
        
        String holdProjId = '';
        
        Integer ctr = 0;
        Integer maxNbrOfProjects = 500;
        Prospector_Working_Table__c pwt = new Prospector_Working_Table__c();

        System.debug('(ProspectorCheckCalloutHelper.retrieveDistinctProjIdsFromProspectorWorkingTable) pwtList.size(): ' + pwtList.size());
        
        while (ppiList.size() < maxNbrOfProjects && ctr < pwtList.size()) {
            pwt = pwtList.get(ctr);
            
            ppi = new ProspectorProjectId();
            
            if (holdProjId != pwt.Project_Id__c) {
                ppi.projectId = pwt.Project_Id__c;
                ppi.propertyTransactionSummaryId = pwt.Property_Transaction_Summary__c;
                ppiList.add(ppi);
                holdProjId = pwt.Project_Id__c;
                System.debug('(ProspectorCheckCalloutHelper.retrieveDistinctProjIdsFromProspectorWorkingTable) holdProjId: ' + holdProjId);
            }
            ctr++;
        }
		
        System.debug('(ProspectorCheckCalloutHelper.retrieveDistinctProjIdsFromProspectorWorkingTable) ppiList.size(): ' + ppiList.size());

        return ppiList;

    }//end method retrieveDistinctProjIdsFromProspectorWorkingTable
    
    public static List<Prospector_Working_Table__c> retrieveAllPropertyNameColorFromProspectorWorkingTable(String colorIn) {
        return
//            [SELECT Id, Project_Id__c, Property_Id__c, Infrastructure_Layer_Color__c FROM Prospector_Working_Table__c ORDER BY Id ASC LIMIT 75];
            [SELECT Id, Project_Id__c, Property_Id__c, Infrastructure_Layer_Color__c, Property_Transaction_Summary__c 
               FROM Prospector_Working_Table__c 
              WHERE Infrastructure_Layer_Color__c = :colorIn 
              ORDER BY Id ASC];

    }//end method retrieveAllPropertyNameColorFromProspectorWorkingTable
    
    public class ProspectorProjectId {
        public String projectId;
        public String propertyTransactionSummaryId;
    }
    
    public static void commitChanges() {
        for (API_Transaction__c apiT : allApiTransactionsServiceManager.apiTransactions) {
            System.debug('(ProspectorCalloutHelper.commitChanges) apiT = ' + apiT);
        }
        allApiTransactionsServiceManager.save();
        //if(this.disableDml) {
        //    return;
        //}        
    }

}//end class ProspectorCheckCalloutHelper