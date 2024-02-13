/***************************************************************
===============================================================
Purpose: Test class for Batch Class CreatePropertyFromPrrBatch.
===============================================================
History:

AUTHOR     DATE         Reference     Description
Ami P    20/12/2021     ESCJ-327      Initial draft
HANK     9/25/2023      QFCJ-4591
***************************************************************/
@isTest
public class CreatePropertyFromPrrBatchTest {
    /**********************************************************************************************
    Purpose: To create Test data
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ***********************************************************************************************/
    @testSetup static void CommonTestSetupToCreatePrr () {
	    List<Property_Request_Record__c> prrRecordList = new List<Property_Request_Record__c>();
        String street = '6001 YANKEE HILL RD';
        String city = 'LINCOLN';
        String state = 'NE';
        Decimal latitude = 40.72445911093;
        Decimal longitude = -96.6389346791281;
        List<Property_Request_Record__c> prrALNRecords = TestDataFactory.createPropertyReqRecords(
            'ALN', street, city, state, latitude, longitude, 1, false
        );
        prrALNRecords[0].ManagerFirstName__c = 'CFName';
        prrALNRecords[0].ManagerLastName__c = 'CLName';
        prrRecordList.addAll(prrALNRecords);
        
        List<Property_Request_Record__c> prrDodgeRecords = TestDataFactory.createPropertyReqRecords(
            'Dodge', street, city, state, latitude, longitude, 2, false
        );
        prrDodgeRecords[0].Owner_Contact_Name__c = 'CFName CLName';
        prrDodgeRecords[1].Owner_Contact_Name__c = 'CFName CLName';
        prrDodgeRecords[1].isProcessed__c = true;
        prrRecordList.addAll(prrDodgeRecords);

        List<Property_Request_Record__c> prrUserRecords = TestDataFactory.createPropertyReqRecords(
            'User', street, city, state, latitude, longitude, 1, false
        );
        prrUserRecords[0].User_Contact_First_Name__c = 'CFName';
        prrUserRecords[0].User_Contact_Last_Name__c = 'CLName';
        prrRecordList.addAll(prrUserRecords);

        List<Property_Request_Record__c> prrCSRecords = TestDataFactory.createPropertyReqRecords(
            'Customer Success', street, city, state, latitude, longitude, 1, false
        );
        prrCSRecords[0].User_Contact_First_Name__c = 'CSFName';
        prrCSRecords[0].User_Contact_Last_Name__c = 'CSLName';
        prrCSRecords[0].CS_SBS_Tech_Module__c = 'Yes';
        prrCSRecords[0].CS_HH_Field__c = 0;
        prrCSRecords[0].CS_FOD_Field__c = null;
        prrCSRecords[0].CS_Property_Type__c = 'MDU';
        prrCSRecords[0].CS_Legacy_CDG_ID__c = '';
        prrCSRecords[0].CS_External_Source_ID__c = '';
        prrCSRecords[0].User_Property_Structure__c = 'Tower';
        prrRecordList.addAll(prrCSRecords);

        INSERT prrRecordList;     
    }
    
    
    /**********************************************************************************************
     Purpose: To test unique Property created, Associated Contact from Prr record when DataSource 
             is 'ALN', parcel service callout using latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest static void testForDataSourceAln() {
        delete [SELECT Id FROM Property_Request_Record__c WHERE Data_Source__c != 'ALN'];
        Test.startTest();
        CreatePropertyFromPrrBatch obj = new CreatePropertyFromPrrBatch();
        Database.executeBatch(obj, 1);
        Test.stopTest();
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('ALN');
        //List<Contact> contacts = getContacts();
        System.assertEquals(TRUE, prrList[0]?.isProcessed__c);
        System.assertEquals(1, properties?.size());
        //System.assertEquals(1, contacts?.size());
        System.assertEquals(40.72445911093, properties[0]?.Latitude__c);
        System.assertEquals(-96.6389346791281, properties[0]?.Longitude__c);
        System.assertEquals('Yes', prrList[0]?.Match_Found_In_System__c);
        
    }
    
    /**********************************************************************************************
     Purpose: To test unique Property created, Associated Contact from Prr record when DataSource 
              is 'Dodge', parcel service callout using latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest static void testForDataSourceDodge() {
        delete [SELECT Id FROM Property_Request_Record__c WHERE Data_Source__c != 'Dodge'];      
        Test.startTest();
        Database.executeBatch(new CreatePropertyFromPrrBatch(), 1);
        Test.stopTest();
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('Dodge'); 
        //List<Contact> contacts = getContacts();
        System.assertEquals(TRUE, prrList[0]?.isProcessed__c);

       // System.assertEquals('Yes', prrList[0]?.Match_Found_In_System__c);

        //System.assertEquals('Yes', prrList[0]?.Match_Found_In_System__c);

        System.assertEquals(1, properties?.size());
        //System.assertEquals(1, contacts?.size());
        System.assertEquals(40.72445911093, properties[0]?.Latitude__c);
        System.assertEquals(-96.6389346791281, properties[0]?.Longitude__c);
        
    }
    
    /**********************************************************************************************
    Purpose: To test unique Property created, Associated Contact from Prr record when DataSource 
              is 'User', parcel service callout using latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest static void testForDataSourceUser() {      
        delete [SELECT Id FROM Property_Request_Record__c WHERE Data_Source__c != 'User'];     
        Test.startTest();
        Database.executeBatch(new CreatePropertyFromPrrBatch(), 1);
        Test.stopTest();
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('User');
        //List<Contact> contacts = getContacts();
        System.assertEquals(TRUE, prrList[0]?.isProcessed__c);
        System.assertEquals('Yes', prrList[0]?.Match_Found_In_System__c);
        System.assertEquals(1, properties?.size());
        //System.assertEquals(1, contacts?.size());
        System.assertEquals(40.72445911093, properties[0]?.Latitude__c);
        System.assertEquals(-96.6389346791281, properties[0]?.Longitude__c);
    }
	
    
    /**********************************************************************************************
    Purpose: To test unique Property created, Associated Contact from Prr record when DataSource 
              is 'User', parcel service callout using latitude and longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest static void testForDataSourceCustomerSuccess() {      
        delete [SELECT Id FROM Property_Request_Record__c WHERE Data_Source__c != 'Customer Success'];     
        Test.startTest();
        Database.executeBatch(new CreatePropertyFromPrrBatch(), 1);
        Test.stopTest();
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('Customer Success');
//      <<<<<<< QFCJ-4591-NEW
        system.debug('##### prrList: '+prrList);
        //List<Contact> contacts = getContacts();
        //// - System.assertEquals(TRUE, prrList[0]?.isProcessed__c);
        //// - System.assertEquals('Yes', prrList[0]?.Match_Found_In_System__c);
//      >>>>>>> QFCJ-4591-NEW
        System.assertEquals(1, properties?.size());
        //System.assertEquals(1, contacts?.size());
        System.assertEquals(40.72445911093, properties[0]?.Latitude__c);
        System.assertEquals(-96.6389346791281, properties[0]?.Longitude__c);
    }
	
    
    /**********************************************************************************************
    Purpose: To test unique Property created, Associated Contact from Prr record when DataSource 
              is 'ALN', parcel service callout using Address
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ***********************************************************************************************/
    @isTest static void testForDataSourceAlnAddress() {
        List<Property_Request_Record__c>  prrRecordList =  getPrrRecordList('ALN');        
        prrRecordList[0].GPSLatitude__c = NULL;
        prrRecordList[0].GPSLongitude__c = NULL;
        update prrRecordList;
        delete [SELECT Id FROM Property_Request_Record__c WHERE Data_Source__c != 'ALN'];
        Test.startTest();
        CreatePropertyFromPrrBatch obj = new CreatePropertyFromPrrBatch();
        Database.executeBatch(obj, 1);
        Test.stopTest();
        List<Property__c> properties = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('ALN');
        System.assertEquals(TRUE, prrList[0]?.isProcessed__c);
        System.assertEquals('Yes', prrList[0]?.Match_Found_In_System__c);
        System.assertEquals(1, properties.Size());
        System.assertEquals(prrList[0]?.ProjectCity__c, properties[0]?.Primary_Address_City__c);
        System.assertEquals(prrList[0]?.ProjectState__c, properties[0]?.Primary_Address_State__c);
        System.assertEquals(prrList[0]?.ProjectAddress__c, properties[0]?.Primary_Address_Street__c);
        
    }  
    
    /*******************************************************************************************************
    Purpose: To test If Property already present, duplicate property will not be created, for Prr
             record when DataSource is 'Dodge', parcel service callout response using latitude & longitude
    ========================================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ********************************************************************************************************/
    @isTest static void testPropertyPresent(){
        List<Property_Request_Record__c>  prrRecordList = getPrrRecordList('Dodge');
        delete [SELECT Id FROM Property__c];
        List<Property__c> properties = TestDataFactory.createProperties(
        	prrRecordList[0].STREET__c, 
            prrRecordList[0].CITY__c, 
            prrRecordList[0].STATE__c,
            '109',
            '31',
            '1628100014000',
        	prrRecordList[0].GEO_LATITUDE__c, 
            prrRecordList[0].GEO_LONGITUDE__c,
            1, 
            False    
    	);
        properties[0].Unique_ID__c = '109162810001400031';
        insert properties;
        delete [SELECT Id FROM Property_Request_Record__c WHERE Data_Source__c != 'ALN'];
        Test.startTest();
        Database.executeBatch(new CreatePropertyFromPrrBatch(), 1);
        Test.stopTest();
        List<Property__c> propertyList = getProperties();
        List<Property_Request_Record__c> prrList = getPrrRecordList('ALN');
        System.assertEquals('Yes', prrList[0]?.Match_Found_In_System__c);
        System.assertEquals(TRUE, prrList[0]?.isProcessed__c);
        System.assertEquals(1, propertyList?.size());
    }
    
    /*******************************************************************************************************
    Purpose: To test If Contact already present, duplicate contact will not be created, for Prr
             record when DataSource is 'ALN', parcel service callout response using latitude & longitude
    ========================================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ********************************************************************************************************/
    @isTest static void testContactAlreadyPresent(){ 
        List<Contact> contacts = TestDataFactory.createContacts('CFName','CLName',1, TRUE);
        List<Property_Request_Record__c>  prrRecordList = getPrrRecordList('ALN');
        delete [SELECT Id FROM Property_Request_Record__c WHERE Data_Source__c != 'ALN'];
        Test.startTest();
        CreatePropertyFromPrrBatch obj = new CreatePropertyFromPrrBatch();
        Database.executeBatch(obj, 1);
        Test.stopTest();
        List<Property__c> properties = getProperties(); 
        List<Property_Request_Record__c> prrList = getPrrRecordList('ALN');
        List<Contact> contactList = getContacts();
        System.assertEquals(TRUE, prrList[0]?.isProcessed__c);
        System.assertEquals('Yes', prrList[0]?.Match_Found_In_System__c);
        System.assertEquals(1, properties.Size());
        System.assertEquals(1, contactList.Size());
        System.assertEquals(40.72445911093, properties[0]?.Latitude__c);
        System.assertEquals(-96.6389346791281, properties[0]?.Longitude__c);
        
    }
    
    /*******************************************************************************************************
    Purpose: To test If No Parcel is received, for Prr record when DataSource is 'ALN', parcel service 
			 callout response using latitude & longitude then, No New Property will be created for that prr
			 record
    ========================================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ********************************************************************************************************/
    @isTest static void testParcelNotPresent(){ 
        Property_Request_Record__c  prrRecord = new Property_Request_Record__c();
        prrRecord.isProcessed__c = false;
        prrRecord.GPSLatitude__c = 45.72445911093;
        prrRecord.GPSLongitude__c = -91.6389346791281; 
        prrRecord.Data_Source__c = 'ALN';
        INSERT prrRecord;
        delete [SELECT Id FROM Property_Request_Record__c WHERE Data_Source__c != 'ALN'];
        List<Property_Request_Record__c>  prrRecordList =  getPrrRecordList('ALN');      
        Test.startTest();
        CreatePropertyFromPrrBatch obj = new CreatePropertyFromPrrBatch();
        Database.executeBatch(obj, 2);
        Test.stopTest();
        //List<Contact> contacts = getContacts();
        System.assertEquals(0, [SELECT COUNT() FROM Property__c WHERE Latitude__c=45.72445911093  AND Longitude__c=-91.6389346791281]);
        //System.assertEquals(1, contacts.Size());
    }
    
    /**********************************************************************************************
    Purpose: To get property Request Records based on Data Source Type
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ***********************************************************************************************/
    private static List<Property_Request_Record__c>  getPrrRecordList(String dataSource){
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
    }
    
    /**********************************************************************************************
    Purpose: To get property Records
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ***********************************************************************************************/
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
    }
    
    /**********************************************************************************************
    Purpose: To get Contact Records
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
	Ami P    20/12/2021     ESCJ-327      Initial draft
    ***********************************************************************************************/
    private static List<Contact> getContacts(){
		return [SELECT Id FROM Contact];        
    }
}//end class CreatePropertyFromPrrBatchTest