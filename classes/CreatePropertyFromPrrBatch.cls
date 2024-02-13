/**
 *
 *      how to fire this manually:    Id batchJobId = Database.executeBatch(new CreatePropertyFromPrrBatch(), 200);
 *      9/25/2023 		HANK		QFCJ-4591 -  Added logic to set how many records to process, sort order and apiCount 
 * 		1/30/2024		HANK		QFCJ-4879 made the initial query check for isProcessed__c != true vs = false		
 * 
 */
public with sharing class CreatePropertyFromPrrBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
// <<<<<<< QFCJ-4591-NEW

    public DateTime lastAttempt;
    public Integer hours;
    Decimal apiCount;
    String sortBy;
    Integer howManyRecords;

    public Database.QueryLocator start(Database.BatchableContext bc) {

  /**  public static String query {
     get {
         if(query == null) {
             query = 'SELECT'
                     + ' Name'
                     + ', Region__c'
                     + ', Market__c'
                     + ', Data_Source__c'
                     + ', GPSLatitude__c'
                     + ', GPSLongitude__c'
                     + ', GEO_LATITUDE__c'
                     + ', GEO_LONGITUDE__c'
                     + ', User_Latitude__c'
                     + ', User_Longitude__c'
                     + ', ManagerFirstName__c'
                     + ', ManagerLastName__c'
                     + ', Owner_Contact_Name__c'
                     + ', User_Contact_First_Name__c'
                     + ', User_Contact_Last_Name__c'
                     + ', ProjectAddress__c'
                     + ', ProjectCity__c'
                     + ', ProjectState__c'
                     + ', STREET__c'
                     + ', CITY__c'
                     + ', STATE__c'
                     + ', ProjectZIP__c'
                     + ', County__c'
                     + ', User_Property_Address__c'
                     + ', User_Property_City__c'
                     + ', User_Property_State__c'
                     + ', User_Property_Zip_Code__c'
                     + ', Transaction_Summary__c'
                     + ', Match_Found_In_System__c'
                     + ', isProcessed__c'
                     + ', COUNTRY__c'
                     + ', ZIP_CODE__c'
                     + ', COUNTY_1__c'
                     + ', GEOES_results__c'
                     + ', BEST_PROP_ADDR__c'
                     + ', BEST_PROP_CITY__c'
                     + ', BEST_PROP_STATE__c'
                     + ', BEST_PROP_ZIP__c'
                     + ', BEST_PROP_NM__c'
                     + ', Duplicate_Property_Found__c'
                     + ', GEOES_Inventory_Source__c'
                     + ', GEOES_Legacy_Provider__c'
                     + ', Development_Status__c'
                     + ', New_Property_Created__c'
                     + ', GEOES_Latitude_Coordinate__c'
                     + ', GEOES_Longitude_Coordinate__c'
                     + ', lastAPICallout__c'
                     + ', failedCount__c'
                 + ' FROM Property_Request_Record__c'
                 + ' WHERE'
                     + ' Data_Source__c IN :validDataSources'
                     + ' AND isProcessed__c = false ' 
             ;
         }
         return query;
     }
     set;
 } **/

        List<String> validDataSources = GeoesConstants.VALID_DATA_SOURCES;

            // get metadata and setup variables for query
            BatchConfigSetting__mdt getMetaConfig = [select id, failedCount__c, hourOffset__c, recordsToProcess__c, sortByAscDesc__c from BatchConfigSetting__mdt where developername = 'CreatePropertyFromPrrBatchScheduler'];
              hours = integer.valueOf(getMetaConfig.hourOffset__c);
              lastAttempt = system.now().addhours(-hours);
              apiCount = getMetaConfig.failedCount__c;
              sortBy = getMetaConfig.sortByAscDesc__c;
              howManyRecords = Integer.valueOf(getMetaConfig.recordsToProcess__c);

if(sortBy == 'ASC'){
        return Database.getQueryLocator([select Name, Market__c, Data_Source__c, GPSLatitude__c, GPSLongitude__c, GEO_LATITUDE__c, GEO_LONGITUDE__c, User_Latitude__c, User_Longitude__c, 
        ManagerFirstName__c, ManagerLastName__c, Owner_Contact_Name__c, User_Contact_First_Name__c, User_Contact_Last_Name__c, ProjectAddress__c, ProjectCity__c, ProjectState__c, STREET__c, 
        CITY__c, STATE__c, ProjectZIP__c, County__c, User_Property_Address__c, User_Property_City__c, User_Property_State__c, User_Property_Zip_Code__c, Transaction_Summary__c, Match_Found_In_System__c, 
        isProcessed__c, COUNTRY__c,  ZIP_CODE__c,  COUNTY_1__c,  GEOES_results__c, BEST_PROP_ADDR__c, BEST_PROP_CITY__c, BEST_PROP_STATE__c, BEST_PROP_ZIP__c, BEST_PROP_NM__c, Duplicate_Property_Found__c, 
        GEOES_Inventory_Source__c, GEOES_Legacy_Provider__c, Development_Status__c, New_Property_Created__c, GEOES_Latitude_Coordinate__c, GEOES_Longitude_Coordinate__c, lastAPICallout__c, apiCount__c
           FROM Property_Request_Record__c WHERE Data_Source__c IN :validDataSources AND isProcessed__c != true AND (lastAPICallout__c > :lastAttempt OR lastAPICallout__c = null)
           AND (apiCount__c < :apiCount OR apiCount__c = null) order by createddate asc limit :howManyRecords]);
} else {
    return Database.getQueryLocator([select Name, Market__c, Data_Source__c, GPSLatitude__c, GPSLongitude__c, GEO_LATITUDE__c, GEO_LONGITUDE__c, User_Latitude__c, User_Longitude__c, 
    ManagerFirstName__c, ManagerLastName__c, Owner_Contact_Name__c, User_Contact_First_Name__c, User_Contact_Last_Name__c, ProjectAddress__c, ProjectCity__c, ProjectState__c, STREET__c, 
    CITY__c, STATE__c, ProjectZIP__c, County__c, User_Property_Address__c, User_Property_City__c, User_Property_State__c, User_Property_Zip_Code__c, Transaction_Summary__c, Match_Found_In_System__c, 
    isProcessed__c, COUNTRY__c,  ZIP_CODE__c,  COUNTY_1__c,  GEOES_results__c, BEST_PROP_ADDR__c, BEST_PROP_CITY__c, BEST_PROP_STATE__c, BEST_PROP_ZIP__c, BEST_PROP_NM__c, Duplicate_Property_Found__c, 
    GEOES_Inventory_Source__c, GEOES_Legacy_Provider__c, Development_Status__c, New_Property_Created__c, GEOES_Latitude_Coordinate__c, GEOES_Longitude_Coordinate__c, lastAPICallout__c, apiCount__c
       FROM Property_Request_Record__c WHERE Data_Source__c IN :validDataSources AND isProcessed__c != true AND (lastAPICallout__c > :lastAttempt OR lastAPICallout__c = null)
           AND (apiCount__c < :apiCount OR apiCount__c = null) order by createddate desc limit :howManyRecords]);
}
// >>>>>>> QFCJ-4591-NEW
    }

    public void execute(Database.BatchableContext bc, List<Property_Request_Record__c> prrs) {
        //surround below with try/catch incase limits are broken - the rest of the code should run in a separate transaction just fine.
        try{
            PrrDuplicateResponse duplicationResponse = filterDuplicates(prrs);
            Map<Id, Property_Request_Record__c> uniquePrrMap = new Map<Id, Property_Request_Record__c>(
            duplicationResponse.uniquePrrs
            );


            List<Property_Request_Record__c> duplicatePrrs = new List<Property_Request_Record__c>();
            for(Property_Request_Record__c prr : prrs) {
                if(prr.apiCount__c == null){
                    prr.apiCount__c = 1;
                } else {
                    prr.apiCount__c = prr.apiCount__c +1;
                }
                prr.lastAPICallout__c = system.now();

                if(uniquePrrMap.containsKey(prr.Id)) {
                    continue;
                }
                prr.Match_Found_In_System__c = GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_DUPLICATE_PRR;
                prr.isProcessed__c = true;
                GeoesParcelService.AddressValidationWrapper wrappedPrr = new GeoesParcelService.AddressValidationWrapper(
                    prr
                );
                Property_Request_Record__c ogRecord = duplicationResponse.duplicatePrrMap.get(
                    wrappedPrr.uniqueId
                );
                if(ogRecord != null && ogRecord.New_Property_Created__c != null) {
                    prr.Existing_Property_found_in_SF_with_PRR__c = ogRecord.New_Property_Created__c;
                }
                duplicatePrrs.add(prr);
            }
            if(!uniquePrrMap.keySet().isEmpty()) {
                System.enqueueJob(
                    new CreatePropertyFromPrrQueueable(
                        new Map<Id, Property_Request_Record__c>(
                            duplicationResponse.uniquePrrs
                        ).keySet(), 
                        true
                    )
                );
            }
            if(!duplicatePrrs.isEmpty()) {
                update duplicatePrrs;
            }
        } catch(Exception e) {
            System.enqueueJob(
                new CreatePropertyFromPrrQueueable(
                    new Map<Id, Property_Request_Record__c>(
                        prrs
                    ).keySet(),
                    true
                )
            );
        }
    }

    public static PrrDuplicateResponse filterDuplicates(
        List<Property_Request_Record__c> prrs
    ) {
        Map<Id, GeoesParcelService.AddressValidationWrapper> prrWrappers = new Map<Id, GeoesParcelService.AddressValidationWrapper>();
        for(Property_Request_Record__c prr : prrs) {
            prrWrappers.put(
                prr.Id,
                new GeoesParcelService.AddressValidationWrapper(
                    prr
                )
            );
        }
        PrrDuplicateResponse result = new PrrDuplicateResponse();

        Set<Decimal> aggregatedLongitude = new Set<Decimal>();
        Set<Decimal> aggregatedLatitude = new Set<Decimal>();
        Set<String> aggregatedAddresses = new Set<String>();
        Set<String> aggregatedCities = new Set<String>();
        Set<String> aggregatedStates = new Set<String>();

        for(GeoesParcelService.AddressValidationWrapper prr : prrWrappers.values()) {
            if(prr.longitude != null) {
                aggregatedLongitude.add(prr.longitude);
            }
            if(prr.latitude != null) {
                aggregatedLatitude.add(prr.latitude);
            }
            if(prr.address != null) {
                aggregatedAddresses.add(prr.address);
            }
            if(prr.city != null) {
                aggregatedCities.add(prr.city);
            }
            if(prr.state != null) {
                aggregatedStates.add(prr.state);
            }
        }

        List<Property_Request_Record__c> potentialDuplicates = new List<Property_Request_Record__c>();

        potentialDuplicates.addAll([
            SELECT 
                Name,
            	Region__c,
            	Market__c,
                Data_Source__c,
                GPSLatitude__c,
                GPSLongitude__c,
                GEO_LATITUDE__c,
                GEO_LONGITUDE__c,
                User_Latitude__c,
                User_Longitude__c,
                ManagerFirstName__c,
                ManagerLastName__c,
                Owner_Contact_Name__c,
                User_Contact_First_Name__c,
                User_Contact_Last_Name__c,
                ProjectAddress__c,
                ProjectCity__c,
                ProjectState__c,
                STREET__c,
                CITY__c,
                STATE__c,
                ProjectZIP__c,
                County__c,
                User_Property_Address__c,
                User_Property_City__c,
                User_Property_State__c,
                User_Property_Zip_Code__c,
                Transaction_Summary__c,
                Match_Found_In_System__c,
                isProcessed__c,
                COUNTRY__c,
                ZIP_CODE__c,
                COUNTY_1__c,
                GEOES_results__c,
                BEST_PROP_ADDR__c,
                BEST_PROP_CITY__c,
                BEST_PROP_STATE__c,
                BEST_PROP_ZIP__c,
                BEST_PROP_NM__c,
                Duplicate_Property_Found__c,
                GEOES_Inventory_Source__c,
                GEOES_Legacy_Provider__c,
                Development_Status__c,
                New_Property_Created__c,
                GEOES_Latitude_Coordinate__c,
                GEOES_Longitude_Coordinate__c
            FROM Property_Request_Record__c
            WHERE Data_Source__c = :GeoesConstants.PROPERTY_REQUEST_RECORD_ALN
                AND (
                    (
                        GPSLongitude__c IN :aggregatedLongitude
                        AND GPSLatitude__c IN :aggregatedLatitude
                    ) OR (
                        ProjectAddress__c IN :aggregatedAddresses
                        AND ProjectCity__c IN :aggregatedCities
                        AND ProjectState__c IN :aggregatedStates
                    )
                )
                AND isProcessed__c = true
        ]);

        potentialDuplicates.addAll([
            SELECT 
                Name,
            	Region__c,
            	Market__c,
                Data_Source__c,
                GPSLatitude__c,
                GPSLongitude__c,
                GEO_LATITUDE__c,
                GEO_LONGITUDE__c,
                User_Latitude__c,
                User_Longitude__c,
                ManagerFirstName__c,
                ManagerLastName__c,
                Owner_Contact_Name__c,
                User_Contact_First_Name__c,
                User_Contact_Last_Name__c,
                ProjectAddress__c,
                ProjectCity__c,
                ProjectState__c,
                STREET__c,
                CITY__c,
                STATE__c,
                ProjectZIP__c,
                County__c,
                User_Property_Address__c,
                User_Property_City__c,
                User_Property_State__c,
                User_Property_Zip_Code__c,
                Transaction_Summary__c,
                Match_Found_In_System__c,
                isProcessed__c,
                COUNTRY__c,
                ZIP_CODE__c,
                COUNTY_1__c,
                GEOES_results__c,
                BEST_PROP_ADDR__c,
                BEST_PROP_CITY__c,
                BEST_PROP_STATE__c,
                BEST_PROP_ZIP__c,
                BEST_PROP_NM__c,
                Duplicate_Property_Found__c,
                GEOES_Inventory_Source__c,
                GEOES_Legacy_Provider__c,
                Development_Status__c,
                New_Property_Created__c,
                GEOES_Latitude_Coordinate__c,
                GEOES_Longitude_Coordinate__c
            FROM Property_Request_Record__c
            WHERE Data_Source__c = :GeoesConstants.PROPERTY_REQUEST_RECORD_DODGE
                AND (
                    (
                        GEO_LONGITUDE__c IN :aggregatedLongitude
                        AND GEO_LATITUDE__c IN :aggregatedLatitude
                    ) OR (
                        STREET__c IN :aggregatedAddresses
                        AND CITY__c IN :aggregatedCities
                        AND STATE__c IN :aggregatedStates
                    )
                )
                AND isProcessed__c = true
        ]);

        potentialDuplicates.addAll([
            SELECT 
                Name,
            	Region__c,
            	Market__c,
                Data_Source__c,
                GPSLatitude__c,
                GPSLongitude__c,
                GEO_LATITUDE__c,
                GEO_LONGITUDE__c,
                User_Latitude__c,
                User_Longitude__c,
                ManagerFirstName__c,
                ManagerLastName__c,
                Owner_Contact_Name__c,
                User_Contact_First_Name__c,
                User_Contact_Last_Name__c,
                ProjectAddress__c,
                ProjectCity__c,
                ProjectState__c,
                STREET__c,
                CITY__c,
                STATE__c,
                ProjectZIP__c,
                County__c,
                User_Property_Address__c,
                User_Property_City__c,
                User_Property_State__c,
                User_Property_Zip_Code__c,
                Transaction_Summary__c,
                Match_Found_In_System__c,
                isProcessed__c,
                COUNTRY__c,
                ZIP_CODE__c,
                COUNTY_1__c,
                GEOES_results__c,
                BEST_PROP_ADDR__c,
                BEST_PROP_CITY__c,
                BEST_PROP_STATE__c,
                BEST_PROP_ZIP__c,
                BEST_PROP_NM__c,
                Duplicate_Property_Found__c,
                GEOES_Inventory_Source__c,
                GEOES_Legacy_Provider__c,
                Development_Status__c,
                New_Property_Created__c,
                GEOES_Latitude_Coordinate__c,
                GEOES_Longitude_Coordinate__c
            FROM Property_Request_Record__c
            WHERE Data_Source__c = :GeoesConstants.PROPERTY_REQUEST_RECORD_USER
                AND (
                    (
                        User_Latitude__c IN :aggregatedLatitude
                        AND User_Longitude__c IN :aggregatedLongitude
                    ) OR (
                        User_Property_Address__c IN :aggregatedAddresses
                        AND User_Property_City__c IN :aggregatedCities
                        AND User_Property_State__c IN :aggregatedStates
                    )
                )
                AND isProcessed__c = true
        ]);

        potentialDuplicates.addAll([
            SELECT 
                Name,
            	Region__c,
            	Market__c,
                Data_Source__c,
                GPSLatitude__c,
                GPSLongitude__c,
                GEO_LATITUDE__c,
                GEO_LONGITUDE__c,
                User_Latitude__c,
                User_Longitude__c,
                ManagerFirstName__c,
                ManagerLastName__c,
                Owner_Contact_Name__c,
                User_Contact_First_Name__c,
                User_Contact_Last_Name__c,
                ProjectAddress__c,
                ProjectCity__c,
                ProjectState__c,
                STREET__c,
                CITY__c,
                STATE__c,
                ProjectZIP__c,
                County__c,
                User_Property_Address__c,
                User_Property_City__c,
                User_Property_State__c,
                User_Property_Zip_Code__c,
                Transaction_Summary__c,
                Match_Found_In_System__c,
                isProcessed__c,
                COUNTRY__c,
                ZIP_CODE__c,
                COUNTY_1__c,
                GEOES_results__c,
                BEST_PROP_ADDR__c,
                BEST_PROP_CITY__c,
                BEST_PROP_STATE__c,
                BEST_PROP_ZIP__c,
                BEST_PROP_NM__c,
                Duplicate_Property_Found__c,
                GEOES_Inventory_Source__c,
                GEOES_Legacy_Provider__c,
                Development_Status__c,
                New_Property_Created__c,
                GEOES_Latitude_Coordinate__c,
                GEOES_Longitude_Coordinate__c
            FROM Property_Request_Record__c
            WHERE Data_Source__c = :GeoesConstants.PROPERTY_REQUEST_RECORD_CUSTOMER_SUCCESS
                AND (
                    BEST_PROP_ADDR__c IN :aggregatedAddresses
                    AND BEST_PROP_CITY__c IN :aggregatedCities
                    AND BEST_PROP_STATE__c IN :aggregatedStates
                )
                AND isProcessed__c = true
        ]);

        List<GeoesParcelService.AddressValidationWrapper> potentialDuplicateWrappers = new List<GeoesParcelService.AddressValidationWrapper>();
        for(Property_Request_Record__c prr : potentialDuplicates) {
            if(prrWrappers.containsKey(prr.Id)) {
                continue;
            }
            potentialDuplicateWrappers.add(
                new GeoesParcelService.AddressValidationWrapper(
                    prr
                )
            );
        }

        
        for(GeoesParcelService.AddressValidationWrapper prr : prrWrappers.values()) {
            GeoesParcelService.AddressValidationWrapper duplicatePrr = null;
            for(GeoesParcelService.AddressValidationWrapper potentialDuplicate : potentialDuplicateWrappers) {
                if(prr.address == potentialDuplicate.address
                    && prr.city == potentialDuplicate.city
                    && prr.state == potentialDuplicate.state
                ) {
                    if(prr.dataSource != GeoesConstants.PROPERTY_REQUEST_RECORD_CUSTOMER_SUCCESS) {
                        if(prr.longitude != potentialDuplicate.longitude
                            || prr.latitude != potentialDuplicate.latitude
                        ) {
                            continue;
                        }
                    }
                    duplicatePrr = potentialDuplicate;
                    break;
                }
            }

            if(duplicatePrr != null) {
                result.duplicatePrrMap.put(
                    duplicatePrr.uniqueId,
                    duplicatePrr.propertyRequestRecord
                );
                continue;
            }
            result.uniquePrrs.add(
                prr.propertyRequestRecord
            );
        }
        return result;
    }

    public void finish(Database.BatchableContext bc) { }

    public class PrrDuplicateResponse {
        public List<Property_Request_Record__c> uniquePrrs;
        public Map<String, Property_Request_Record__c> duplicatePrrMap;

        public PrrDuplicateResponse() {
            this.duplicatePrrMap = new Map<String, Property_Request_Record__c>();
            this.uniquePrrs = new List<Property_Request_Record__c>();
        }
    }
}//end class CreatePropertyFromPrrBatch