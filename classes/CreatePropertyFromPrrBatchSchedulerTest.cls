/**********************************************************************************
==================================================================================
Purpose: Test class for Scheduler Class CreatePropertyFromPrrBatchScheduler.
==================================================================================
History:

AUTHOR     DATE         Reference     Description
Ami P    20/12/2021     ESCJ-327      Initial draft
**********************************************************************************/
@isTest
public class CreatePropertyFromPrrBatchSchedulerTest {

    public static final String TEST_GREEN_ADDRESS = '22 E MONUMENT ST';
    public static final String TEST_GREEN_CITY = 'COLORADO SPRINGS';
    public static final String TEST_GREEN_STATE = 'CO';
    

  /*  @isTest
    static void test() {
        final String street = TEST_GREEN_ADDRESS;
        final String city = TEST_GREEN_CITY;
        final String state = TEST_GREEN_STATE;
        final Decimal latitude = 40.72445911093;
        final Decimal longitude = -96.6389346791281;

        List<Property_Request_Record__c> prrRecords = new List<Property_Request_Record__c>{
            new Property_Request_Record__c(
                Data_Source__c = GeoesConstants.PROPERTY_REQUEST_RECORD_ALN,
                ProjectAddress__c = '16000+N+Scottsdale+Rd',
                ProjectCity__c = 'SCOTTSDALE',
                ProjectState__c = 'AZ',
                ProjectZIP__c='85254-2152',
                County__c='USA',
                COUNTRY__c='USA',
                ManagerFirstName__c='',
                ManagerLastName__c=''
            ),
                new Property_Request_Record__c(
                Data_Source__c = GeoesConstants.PROPERTY_REQUEST_RECORD_ALN,
                ProjectAddress__c = '16000+N+Scottsdale+Rd',
                ProjectCity__c = 'SCOTTSDALE',
                ProjectState__c = 'AZ',
                ProjectZIP__c='85254-2152',
                County__c='USA',
                COUNTRY__c='USA',
                ManagerFirstName__c='',
                ManagerLastName__c=''
            ),
            new Property_Request_Record__c(
                Data_Source__c = GeoesConstants.PROPERTY_REQUEST_RECORD_DODGE,
                STREET__c = '455+SW+5TH+ST',
                CITY__c = 'DES+MOINES',
                STATE__c = 'IA',
                ZIP_CODE__c='50309',
                COUNTY_1__c='USA',
                COUNTRY__c='USA'
            ),
                new Property_Request_Record__c(
                Data_Source__c = GeoesConstants.PROPERTY_REQUEST_RECORD_DODGE,
                STREET__c = '455+SW+5TH+ST',
                CITY__c = 'DES+MOINES',
                STATE__c = 'IA',
                ZIP_CODE__c='50309',
                COUNTY_1__c='USA',
                COUNTRY__c='USA'
            ),
            new Property_Request_Record__c(
                Data_Source__c = GeoesConstants.PROPERTY_REQUEST_RECORD_CUSTOMER_SUCCESS,
                BEST_PROP_ADDR__c = street,
                BEST_PROP_CITY__c = city,
                BEST_PROP_STATE__c = state,
                User_Latitude__c = latitude,
                User_Longitude__c = longitude
            )
        };
        insert prrRecords;
        System.debug('prrRecords####'+prrRecords);
        List<Property__c> potentialCreatedProperties = [SELECT Id FROM Property__c];
        System.debug('potentialCreatedProperties####'+potentialCreatedProperties);
        if(!potentialCreatedProperties.isEmpty()) {
            delete potentialCreatedProperties;
        }
        System.debug('potentialCreatedProperties post delete####'+potentialCreatedProperties);
        Map<Id, Property_Request_Record__c> prrMap = new Map<Id, Property_Request_Record__c>(
            prrRecords
        );
        System.debug('prrMap####'+prrMap);
        PropertyReqRecordTriggerHandler.triggerDisabled = true;
            for(Property_Request_Record__c prr : prrRecords) {
                prr.isProcessed__c = false;
                prr.Match_Found_In_System__c = GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_NO;
                prr.Duplicate_Property_Found__c = GeoesConstants.MATCH_SYSTEM_FOUND_PRR_NO;
                prr.New_Property_Created__c = null;
                prr.GEOES_results__c = null;
            }
            update prrRecords;
            System.debug('updated prrRecords####'+prrRecords);
        PropertyReqRecordTriggerHandler.triggerDisabled = false;

        Test.startTest();
            CreatePropertyFromPrrBatchScheduler.BATCH_SIZE = 200;
            insert new Property_Request_Record__c(
                Data_Source__c = GeoesConstants.PROPERTY_REQUEST_RECORD_USER,
                User_Property_Address__c = street,
                User_Property_City__c = city,
                User_Property_State__c = state,
                User_Latitude__c = latitude,
                User_Longitude__c = longitude
            );
            System.debug('Batch PRR records####'+[SELECT id,name,Data_Source__c,STREET__c,CITY__c,STATE__c,ZIP_CODE__c,COUNTY_1__c,COUNTRY__c,GEO_LONGITUDE__c,GEO_LATITUDE__c,Owner_Contact_Name__c from Property_Request_Record__c where isProcessed__c = false]);
            
            new CreatePropertyFromPrrBatchScheduler().execute(null);
        Test.stopTest();

        Map<Id, Property_Request_Record__c> prrs = new Map<Id, Property_Request_Record__c>(
            [
                SELECT
                    isProcessed__c,name,Data_Source__c
                FROM Property_Request_Record__c
                WHERE Id IN :prrMap.keySet() 
            ]
        );
System.debug('prrs ####'+prrs);
        for(Property_Request_Record__c prr : prrs.values()) {
            System.assertEquals(true,prr.isProcessed__c,'Prr should be processed');
        }

        List<Property__c> properties = [SELECT Id FROM Property__c];
    System.debug('properties ####'+properties);
        System.assertEquals(
            1, 
            properties.size(), 
            'There should only be one property created'
        );
    }*/
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

        INSERT prrRecordList;
        
    }

     @isTest static void testForDataSourceAln() {
        delete [SELECT Id FROM Property_Request_Record__c WHERE Data_Source__c != 'ALN'];
        Test.startTest();
          new CreatePropertyFromPrrBatchScheduler().execute(null);
        Test.stopTest();
            }
}