/***************************************************************
===============================================================
Purpose: Prospector Callout Helper class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 09/08/2022   ESCJ-653  	  Initial draft
***************************************************************/ 
public class ProspectorCalloutHelper {
    public static final String GREEN = 'Green';
    public static final String RED = 'Red';
    public static String transactionSummaryId;
    public static ApiTransactionService allApiTransactionsServiceManager;

    public static void deleteExistingPWTEntries() {
        //Delete all entries from new Prospector_Working_Table__c table
        try{
            List<Prospector_Working_Table__c> pwtLst = [select id from Prospector_Working_Table__c WHERE Create_Date_Time__c < N_DAYS_AGO:1];
            System.debug('(ProspectorCalloutHelper.deleteExistingPWTEntries) About to DELETE pwtList-size = ' + (pwtLst!=null?pwtLst.size():-1));
            delete pwtLst;
        }catch(Exception delExe){
            System.debug('ProspectorCalloutHelper EXCEPTION! \n Type: ' + delExe.getTypeName() + '\n Message:  ' + delExe.getMessage() + '\n Line#: ' + delExe.getLineNumber() + '\n StackTrace:  ' + delExe.getStackTraceString());
        }
    }//end method deleteExistingPWTEntries
    
    public static boolean checkNewPropertyHasLatAndLong(Property__c newProperty) {
        boolean latLongExists = false;
        List<Property__c> propertyList = [SELECT Id, Transaction_Summary__c, Latitude__c, Longitude__c FROM Property__c WHERE Latitude__c != null AND Longitude__c != null AND Id = :newProperty.Id LIMIT 1];
        if (propertyList != null && propertyList.size() > 0) {
            latLongExists = true;
        }        
        return latLongExists;
    }//end method checkNewPropertyHasLatAndLong
    
    public static List<Property__c> getPropertyById(String propertyId) {
        return [SELECT Id, Transaction_Summary__c, Latitude__c, Longitude__c FROM Property__c WHERE Latitude__c != null AND Longitude__c != null AND Id = :propertyId LIMIT 1];
    }//end method getPropertyById
    
	public static List<Property__c> retrieveProperties() {
        Integer maxDemandPoints = 300;
        List<Property__c> propertyList = new List<Property__c>();
        try{
            List<Prospector_Working_Table__c> pwtList = [select Property_Id__c from Prospector_Working_Table__c ORDER BY Property_Id__c];
    
            String holdPropId = '';
            
            Set<Id> propertyEvalSet = new Set<Id>();
            for (Prospector_Working_Table__c pwtEval : pwtList) {
                if (holdPropId != pwtEval.Property_Id__c) {
                  propertyEvalSet.add(pwtEval.Property_Id__c);
                    holdPropId = pwtEval.Property_Id__c;
                }
            }
    
            // Select properties for NO Prospector_Last_Update_Date__c AND 7 day retry
            propertyList = [SELECT Id, Transaction_Summary__c, Latitude__c, Longitude__c 
                                                FROM Property__c 
                                               WHERE Latitude__c != null 
                                                 AND Longitude__c != null 
                                                 AND Distance_to_Fiber_Splice__c = null 
                                                 AND Id NOT IN :propertyEvalSet
                                                 AND (Prospector_Last_Update_Date__c = null 
                                                   OR Prospector_Last_Update_Date__c < N_DAYS_AGO:7) 
                                              ORDER BY Prospector_Last_Update_Date__c ASC 
                                              LIMIT :maxDemandPoints];
            
            maxDemandPoints = maxDemandPoints - propertyList.size();
            
            // Select properties for 28 day refresh
            List<Property__c> property28DayList = [SELECT Id, Transaction_Summary__c, Latitude__c, Longitude__c 
                                                     FROM Property__c 
                                                    WHERE Latitude__c != null 
                                                      AND Longitude__c != null 
                                                      AND Distance_to_Fiber_Splice__c != null 
                                                      AND Id NOT IN :propertyEvalSet
                                                      AND Prospector_Last_Update_Date__c < N_DAYS_AGO:28 
                                                    ORDER BY Prospector_Last_Update_Date__c ASC 
                                                    LIMIT :maxDemandPoints];
                                 propertyList.addAll(property28DayList);
    	}catch(Exception retExe){
        	System.debug('ProspectorCalloutHelper EXCEPTION! \n Type: ' + retExe.getTypeName() + '\n Message:  ' + retExe.getMessage() + '\n Line#: ' + retExe.getLineNumber() + '\n StackTrace:  ' + retExe.getStackTraceString());
    	}
        
        return propertyList;
    }//end method retrieveProperties
    
    public static List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> buildDemandPointsFromProperties(List<Property__c> propertyList) {
        List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList = new List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint>();
        try{
            ProspectorAddDemandPointsCallout.ProspectorDemandPoint thisPDP = new ProspectorAddDemandPointsCallout.ProspectorDemandPoint();
            System.debug('(ProspectorCalloutHelper.buildDemandPointsFromProperties) propertyList-size = ' + (propertyList!=null?propertyList.size():-1));
            for (Property__c thisProp: propertyList) {
                thisPDP = new ProspectorAddDemandPointsCallout.ProspectorDemandPoint();
                thisPDP.dpName = thisProp.Id;
                thisPDP.dpTransactionSummaryId = thisProp.Transaction_Summary__c;
                thisPDP.dpLat = String.valueOf(thisProp.Latitude__c);
                thisPDP.dpLong = String.valueOf(thisProp.Longitude__c);
                dpList.add(thisPDP);
            }//end for-loop through queried property-List to create demandPoint-List
            System.debug('(ProspectorCalloutHelper.buildDemandPointsFromProperties) Created DemandPoints List, dpList-size = ' + (dpList!=null?dpList.size():-1));
        }catch(Exception demretExe){
            System.debug('ProspectorCalloutHelper EXCEPTION! \n Type: ' + demretExe.getTypeName() + '\n Message:  ' + demretExe.getMessage() + '\n Line#: ' + demretExe.getLineNumber() + '\n StackTrace:  ' + demretExe.getStackTraceString());
        }    
        return dpList;
    }//end method buildDemandPointsFromProperties    

    public static ProspectorCreateProjectCallout.ProspectorProject step1CreateProject(String colorIn) {
        ProspectorCreateProjectCallout.ProspectorProject project = new ProspectorCreateProjectCallout.ProspectorProject();
        try{
            System.debug('(ProspectorCalloutHelper.step1CreateProject) Initializing object createProjectCallout for ' + colorIn + ' AND ProspectorCalloutHelper.transactionSummaryId = ' + transactionSummaryId);
            ProspectorCreateProjectCallout createProjectCallout = new ProspectorCreateProjectCallout(transactionSummaryId);
            System.debug('(ProspectorCalloutHelper.step1CreateProject) 1st step for ' + colorIn + ' ');
    
            System.debug('(ProspectorCalloutHelper.step1CreateProject) About to call method createProjectCallout.getProjectName for ' + colorIn + '...');
            project = createProjectCallout.getProjectName(colorIn);
            System.debug('(ProspectorCalloutHelper.step1CreateProject) After calling method createProjectCallout.getProjectName for ' + colorIn + ', project==null? ' + (project==null));
            for (API_Transaction__c apiT : createProjectCallout.getApiTransactionServiceManager().apiTransactions) {
                allApiTransactionsServiceManager.apiTransactions.add(apiT);        
            }
        }catch(Exception calloutExe){
            System.debug('ProspectorCalloutHelper EXCEPTION! \n Type: ' + calloutExe.getTypeName() + '\n Message:  ' + calloutExe.getMessage() + '\n Line#: ' + calloutExe.getLineNumber() + '\n StackTrace:  ' + calloutExe.getStackTraceString());
        }
        return project; 
    }//end method step1CreateProject    

    public static ProspectorCreateProjectCallout.ProspectorProject step2AddDemandPoints(String projectId, List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList, String colorIn) {        
        System.debug('(ProspectorCalloutHelper.step2AddDemandPoints) Initializing object adpCallout for ' + colorIn + ' AND ProspectorCalloutHelper.transactionSummaryId = ' + transactionSummaryId);
        ProspectorCreateProjectCallout.ProspectorProject project = new ProspectorCreateProjectCallout.ProspectorProject();
        try{
            ProspectorAddDemandPointsCallout adpCallout = new ProspectorAddDemandPointsCallout(transactionSummaryId);
            if (projectId != null) {
                System.debug('(ProspectorCalloutHelper.step2AddDemandPoints) Project from previous step for ' + colorIn + '  was NOT NULL with projectId = ' + projectId + ' AND about to create DemandPoints for ' + colorIn + ' to be added...');
                
                System.debug('(ProspectorCalloutHelper.step2AddDemandPoints) About to make addDemandPoints-callout for ' + colorIn + '...');
                project = adpCallout.addDemandPoints(projectId, dpList);
                System.debug('(ProspectorCalloutHelper.step2AddDemandPoints) Made addDemandPoints-callout for ' + colorIn + ', resulting in projectId = ' + projectId);
                for (API_Transaction__c apiT : adpCallout.getApiTransactionServiceManager().apiTransactions) {
                    allApiTransactionsServiceManager.apiTransactions.add(apiT);        
                }
            }
        }catch(Exception step2calloutExe){
            System.debug('ProspectorCalloutHelper EXCEPTION! \n Type: ' + step2calloutExe.getTypeName() + '\n Message:  ' + step2calloutExe.getMessage() + '\n Line#: ' + step2calloutExe.getLineNumber() + '\n StackTrace:  ' + step2calloutExe.getStackTraceString());
        }
        
        return project;
    }//end method step2AddDemandPoints    

    public static ProspectorCreateProjectCallout.ProspectorProject step3SubmitJob(String projectId, String colorIn) {
        System.debug('(ProspectorCalloutHelper.step3SubmitJob) Initializing object sjCallout with projectId = ' + projectId  + ' AND ProspectorCalloutHelper.transactionSummaryId = ' + transactionSummaryId);
        ProspectorCreateProjectCallout.ProspectorProject project = new ProspectorCreateProjectCallout.ProspectorProject();
        try{
            ProspectorSubmitJobCallout sjCallout = new ProspectorSubmitJobCallout(transactionSummaryId);
            if (projectId != null) {
                System.debug('(ProspectorCalloutHelper.step3SubmitJob) Project from previous step for ' + colorIn + ' was NOT NULL with projectId = ' + projectId + ' AND about to SubmitJob for ' + colorIn + '...');
    
                System.debug('(ProspectorCalloutHelper.step3SubmitJob) About to make submitJob-callout for ' + colorIn + ' and projectId = ' + projectId);
                project = sjCallout.submitJob(projectId, colorIn);
                System.debug('(ProspectorCalloutHelper.step3SubmitJob) Make submitJob-callout for ' + colorIn + ', resulting in projectId = ' + projectId);
                for (API_Transaction__c apiT : sjCallout.getApiTransactionServiceManager().apiTransactions) {
                    allApiTransactionsServiceManager.apiTransactions.add(apiT);        
                }
            }
        }catch(Exception submitjobExe){
            System.debug('ProspectorCalloutHelper EXCEPTION! \n Type: ' + submitjobExe.getTypeName() + '\n Message:  ' + submitjobExe.getMessage() + '\n Line#: ' + submitjobExe.getLineNumber() + '\n StackTrace:  ' + submitjobExe.getStackTraceString());
        }
        
        return project;
    }//end method step3SubmitJob    

    public static List<Prospector_Working_Table__c> step4InsertToPWT(String projectId, List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList, String colorIn) {
        System.debug('(ProspectorCalloutHelper.step4InsertToPWT) Initializing object sjCallout with transactionSummaryId = ' + transactionSummaryId);
        List<Prospector_Working_Table__c> pwtToInsertList = new List<Prospector_Working_Table__c>();
        try{
            ProspectorCreateProjectCallout.ProspectorProject project = new ProspectorCreateProjectCallout.ProspectorProject();
            if (projectId != null) {
                System.debug('(ProspectorCalloutHelper.step4InsertToPWT) Project from previous step for ' + colorIn + ' was NOT NULL with projectId = ' + projectId + ' AND about to SubmitJob for ' + colorIn + '...');
    
                System.debug('(ProspectorCalloutHelper.step4InsertToPWT) Inserting data into ProspectorWorkingTable for ' + colorIn + ' and projectId = ' + projectId);
                pwtToInsertList = prepareInsertProspectorWorkingTable(projectId, colorIn, dpList);
                System.debug('(ProspectorCalloutHelper.step4InsertToPWT) Inserted data into ProspectorWorkingTable for ' + colorIn + ', resulting in projectId = ' + projectId);
            }
        }catch(Exception pwtinsertExe){
            System.debug('ProspectorCalloutHelper EXCEPTION! \n Type: ' + pwtinsertExe.getTypeName() + '\n Message:  ' + pwtinsertExe.getMessage() + '\n Line#: ' + pwtinsertExe.getLineNumber() + '\n StackTrace:  ' + pwtinsertExe.getStackTraceString());
        }
        return pwtToInsertList;
    }//end method step4InsertToPWT    

    public static List<Prospector_Working_Table__c> prepareInsertProspectorWorkingTable(String projectName, String ilColor, List<ProspectorAddDemandPointsCallout.ProspectorDemandPoint> dpList){
        List<Prospector_Working_Table__c> pwtList = new List<Prospector_Working_Table__c>();
        Prospector_Working_Table__c pwt = new Prospector_Working_Table__c();
        
        for (ProspectorAddDemandPointsCallout.ProspectorDemandPoint dp: dpList) {
            pwt = new Prospector_Working_Table__c(); 
            
            pwt.Project_Id__c = projectName;
            pwt.Infrastructure_Layer_Color__c = ilColor;
            pwt.Property_Id__c = dp.dpName;
            pwt.Property_Transaction_Summary__c = transactionSummaryId;
            pwt.Create_Date_Time__c = DateTime.Now();
            
            pwtList.add(pwt);
        }
        return pwtList;
    }//end method insertProspectorWorkingTable
    
    public static void commitChanges() {
        for (API_Transaction__c apiT : allApiTransactionsServiceManager.apiTransactions) {
            System.debug('(ProspectorCalloutHelper.commitChanges) apiT = ' + apiT);
        }
        try{
        	allApiTransactionsServiceManager.save();
        }catch(Exception saveExe){
            System.debug('ProspectorCalloutHelper EXCEPTION! \n Type: ' + saveExe.getTypeName() + '\n Message:  ' + saveExe.getMessage() + '\n Line#: ' + saveExe.getLineNumber() + '\n StackTrace:  ' + saveExe.getStackTraceString());
        }
        //if(this.disableDml) {
        //    return;
        //}        
    }
}//end class ProspectorCalloutHelper