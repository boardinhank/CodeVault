/*******************************************************************
====================================================================
Purpose: Test class for Helper Class PropertyReqRecordTriggerHelper.
====================================================================
History:

AUTHOR     DATE         Reference     Description
Ami P    7/1/2021       ESCJ-327      Initial draft
********************************************************************/
@isTest
public class PropertyReqRecordTriggerHelper_Test {
    /**********************************************************************************************
    Purpose: To create Test data
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference       Description
    Ami P   7/1/2021	     ESCJ-327      Initial draft
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
            prrRecordList.addAll(prrALNRecords);

            List<Property_Request_Record__c> prrDodgeRecords = TestDataFactory.createPropertyReqRecords(
                'Dodge', street, city, state, latitude, longitude, 1, false
            );
            prrRecordList.addAll(prrDodgeRecords);

            List<Property_Request_Record__c> prrUserRecords = TestDataFactory.createPropertyReqRecords(
                'User', street, city, state, latitude, longitude, 1, false
            );
            prrRecordList.addAll(prrUserRecords);
	
            List<Property_Request_Record__c> prrCSRecords = TestDataFactory.createPropertyReqRecords(
                'Customer Success', street, city, state, null, null, 1, false
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
	
	 	    List<Property_Request_Record__c> prrTestRecords = TestDataFactory.createPropertyReqRecords(
                'User', street, city, state, null, null, 1, false
            );
            prrRecordList.addAll(prrTestRecords);


            INSERT prrRecordList;
    }

    /**********************************************************************************************
     Purpose: To test Transaction Summaries  are created when PRR records are created
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Ami P    7/1/2021       ESCJ-327      Initial draft
    ***********************************************************************************************/
        @isTest static void testTransactionSummaryCreation() {
	set<Id>  prrId = new set<Id>();
        List<Property_Request_Record__c>  prrRecordList = getPrrRecordList();
	if(!prrRecordList.isEmpty()){
            for(Property_Request_Record__c prr: prrRecordList){
                prrId.add(prr.Id);
            }
         }

        Test.startTest();
          PropertyReqRecordTriggerHelper.createTransactionSummary(prrRecordList);
	  GeoesParcelService  geoesParcel= new GeoesParcelService(prrRecordList);
          GeoesParcelService  geoesParcel1= new GeoesParcelService(prrId);
          GeoesParcelService  geoesParcel3= new GeoesParcelService(prrId,false);
        Test.stopTest();
        List<Transaction_Summary__c> transSummaryList = [SELECT Id, PRR_Address__c,PRR_City__c,PRR_Latitude__c,PRR_Longitude__c,PRR_State__c,PRR_Data_Source__c FROM Transaction_Summary__c];
        System.assertEquals(5,[SELECT COUNT() FROM Transaction_Summary__c]);
        System.assertEquals('6001 YANKEE HILL RD', transSummaryList[0].PRR_Address__c);
        System.assertEquals('LINCOLN', transSummaryList[0].PRR_City__c);
        System.assertEquals('NE', transSummaryList[0].PRR_State__c);
        System.assertEquals('ALN', transSummaryList[0].PRR_Data_Source__c);
        System.assertEquals(40.72445911093, transSummaryList[0].PRR_Latitude__c);
        System.assertEquals(-96.6389346791281, transSummaryList[0].PRR_Longitude__c);
    }
    

   /**********************************************************************************************
    Purpose: To get property Request Records
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Ami P    20/12/2021     ESCJ-327      Initial draft
    ***********************************************************************************************/
    private static List<Property_Request_Record__c>  getPrrRecordList(){
        return [
            SELECT
                Id,Name,
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
                CS_SBS_Tech_Module__c, CS_HH_Field__c, CS_FOD_Field__c, CS_Property_Type__c, CS_Legacy_CDG_ID__c, CS_External_Source_ID__c, //QFCJ-4554
            	CS_Property_Name__c, CS_Location__c, CS_City__c, CS_State__c, CS_Zip__c, //QFCJ-4554
            	CS_MSK_ID_1__c, CS_MSK_ID_2__c, CS_MSK_ID_3__c, CS_MSK_ID_4__c, CS_MSK_ID_5__c //QFCJ-4554
            FROM Property_Request_Record__c
        ];
    }
}