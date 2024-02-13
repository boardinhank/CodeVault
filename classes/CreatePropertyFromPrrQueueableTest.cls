@isTest
public class CreatePropertyFromPrrQueueableTest {

	@testSetup 
    private static void setup(){
	    List<Property_Request_Record__c> prrRecordList = new List<Property_Request_Record__c>();
        String street = '6001 YANKEE HILL RD';
        String city = 'LINCOLN';
        String state = 'NE';
        Decimal latitude = 40.72445911093;
        Decimal longitude = -96.6389346791281;
        List<Property_Request_Record__c> prrALNRecords = TestDataFactory.createPropertyReqRecords(
            'ALN', street, city, state, latitude, longitude, 2, false
        );
        Integer pCtr = 0;
        for (Property_Request_Record__c prr : prrALNRecords) {
            prr.ManagerFirstName__c = 'CFName_' + pCtr;
            prr.ManagerLastName__c = 'CLName_' + pCtr;
            pCtr++;
        }
        prrRecordList.addAll(prrALNRecords);

        List<Property_Request_Record__c> prrDodgeRecords = TestDataFactory.createPropertyReqRecords(
            'Dodge', street, city, state, latitude, longitude, 2, false
        );
        for (Property_Request_Record__c prr : prrDodgeRecords) {
            prr.Owner_Contact_Name__c = 'CFName_' + pCtr + ' CLName_' + pCtr;
            prr.isProcessed__c = true;
            pCtr++;
        }
        prrRecordList.addAll(prrDodgeRecords);

        List<Property_Request_Record__c> prrUserRecords = TestDataFactory.createPropertyReqRecords(
            'User', street, city, state, latitude, longitude, 2, false
        );
        for (Property_Request_Record__c prr : prrUserRecords) {
            prr.User_Contact_First_Name__c = 'CFName_' + pCtr;
            prr.User_Contact_Last_Name__c = 'CLName_' + pCtr;
            pCtr++;
        }
        prrRecordList.addAll(prrUserRecords);

        List<Property_Request_Record__c> prrCSRecords = TestDataFactory.createPropertyReqRecords(
            'Customer Success', street, city, state, latitude, longitude, 3, false
        );
        Integer csCtr = 1;
        for (Property_Request_Record__c prr : prrCSRecords) {
            prr.User_Contact_First_Name__c = 'CSFName_' + pCtr;
            prr.User_Contact_Last_Name__c = 'CSLName_' + pCtr;
            prr.CS_SBS_Tech_Module__c = 'Yes';
            prr.CS_HH_Field__c = 0;
            prr.CS_FOD_Field__c = null;
            prr.CS_Property_Type__c = 'MDU';
            prr.CS_Legacy_CDG_ID__c = '';
            prr.CS_External_Source_ID__c = '';
            if (csCtr == 1) {
	            prr.User_Property_Structure__c = 'SFH (Single Family Home)';
            } else if (csCtr == 2) {
	            prr.User_Property_Structure__c = 'Cottage';
            } else {
                prr.User_Property_Structure__c = 'Tower';
            }
            csCtr++;
            pCtr++;
        }
        prrRecordList.addAll(prrCSRecords);

        INSERT prrRecordList;     
    }//end method setup
    
    @isTest 
    public static void testMaxRetryCount() {
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('User');
        Test.startTest();
        CreatePropertyFromPrrQueueable objQ = new CreatePropertyFromPrrQueueable(prrList);
        Integer rCnt = objQ.maxRetryCount;
        Test.stopTest();
        System.assertNotEquals(0, rCnt, 'MaxRetryCount is NOT Equal 0');
    }//end test-method testMaxRetryCount

    @isTest 
    public static void testForDataSourceAln() {
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('ALN');
        Test.startTest();
        CreatePropertyFromPrrQueueable objQ = new CreatePropertyFromPrrQueueable(prrList);
        Test.stopTest();
        System.assertNotEquals(null, objQ, 'CreatePropertyFromPrrQueueable object for ALN is NOT NULL');
    }//end test-method testForDataSourceAln

    @isTest 
    public static void testForDataSourceDodge() {
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('Dodge');
        Test.startTest();
        CreatePropertyFromPrrQueueable objQ = new CreatePropertyFromPrrQueueable(prrList);
        Test.stopTest();
        System.assertNotEquals(null, objQ, 'CreatePropertyFromPrrQueueable object for Dodge is NOT NULL');
    }//end test-method testForDataSourceDodge
    
    @isTest 
    public static void testForDataSourceUser() {      
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('User');
        Test.startTest();
        CreatePropertyFromPrrQueueable objQ = new CreatePropertyFromPrrQueueable(prrList);
        Test.stopTest();
        System.assertNotEquals(null, objQ, 'CreatePropertyFromPrrQueueable object for User is NOT NULL');
    }//end test-method testForDataSourceUser
	
    @isTest 
    public static void testForDataSourceCustomerSuccess() {      
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('Customer Success');
        Test.startTest();
        CreatePropertyFromPrrQueueable objQ = new CreatePropertyFromPrrQueueable(prrList);
        Test.stopTest();
        System.assertNotEquals(null, objQ, 'CreatePropertyFromPrrQueueable object for Customer Success is NOT NULL');
    }//end test-method testForDataSourceCustomerSuccess
    
    @isTest 
    public static void testForPrrMap() {
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordListForAllDS();
        Test.startTest();
        CreatePropertyFromPrrQueueable objQ = new CreatePropertyFromPrrQueueable(
            										new Map<Id, Property_Request_Record__c>(prrList).keySet());
        Test.stopTest();
        System.assertNotEquals(null, objQ, 'CreatePropertyFromPrrQueueable object for User is NOT NULL');
    }//end test-method testForPrrMap
    
    @isTest 
    public static void testForChainable() {      
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordListForAllDS();
        Test.startTest();
        CreatePropertyFromPrrQueueable objQ = new CreatePropertyFromPrrQueueable(
            										new Map<Id, Property_Request_Record__c>(prrList).keySet(), true);
        Test.stopTest();
        System.assertNotEquals(null, objQ, 'CreatePropertyFromPrrQueueable object for User is NOT NULL');
    }//end test-method testForChainable
    
    private static List<Property_Request_Record__c> getPrrRecordList(String dataSource){
        return [
            SELECT 
                Id,Name,
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
                User_Property_Structure__c,
            	User_Property_Type__c,
            	User_Number_of_Living_Units__c,
            	Property_Age_In_Years__c,
            	Preferred_Contact_Method__c,
            	User_First_Occupancy_Date__c,
            	User_Construction_Start_Date__c,
            	User_Construction_Completion_Date__c,
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
                GEOES_Longitude_Coordinate__c,
                Existing_Property_found_in_SF_with_PRR__c,
            	CS_SBS_Tech_Module__c,CS_HH_Field__c,CS_FOD_Field__c,CS_Property_Type__c,CS_Legacy_CDG_ID__c,CS_External_Source_ID__c
            FROM Property_Request_Record__c
            WHERE 
            	Data_Source__c=:dataSource
            LIMIT 1
        ];
    }//end method getPrrRecordList
    
    private static List<Property_Request_Record__c> getPrrRecordListForAllDS(){
        return [
            SELECT 
                Id,Name,
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
                User_Property_Structure__c,
            	User_Property_Type__c,
            	User_Number_of_Living_Units__c,
            	Property_Age_In_Years__c,
            	Preferred_Contact_Method__c,
            	User_First_Occupancy_Date__c,
            	User_Construction_Start_Date__c,
            	User_Construction_Completion_Date__c,
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
                GEOES_Longitude_Coordinate__c,
                Existing_Property_found_in_SF_with_PRR__c,
            	CS_SBS_Tech_Module__c,CS_HH_Field__c,CS_FOD_Field__c,CS_Property_Type__c,CS_Legacy_CDG_ID__c,CS_External_Source_ID__c
            FROM Property_Request_Record__c
            LIMIT 5
        ];
    }//end method getPrrRecordListForAllDS

    private static List<Property__c> getProperties(){
        return [
            SELECT 
            	Id,
            	Latitude__c,
            	Longitude__c,
            	Primary_Address_City__c,
            	Primary_Address_State__c,
            	Primary_Address_Street__c
            FROM Property__c
        ];
    }//end method getProperties
    
    private static List<Contact> getContacts(){
		return [SELECT Id FROM Contact];        
    }//end method getContacts
}//end test-class CreatePropertyFromPrrQueueableTest