@isTest
public with sharing class lmn_CDRequiredFieldsControllerTest {

@isTest
    static void allPassReqFields(){

        Capital_Design__c allPass = new Capital_Design__c(
            Responsible_for_Cable_Home_Wiring__c = 'Company to Provide and Owner to Install',
            Responsible_for_Home_Run_Wiring__c = 'Company to Provide and Install',
            Telecommunication_Cable_Types__c = 'Fiber',
            Telecom_Cable_Quantity_Per_Living_Unit__c = 1,
            Endpoint_Type_building_architecture__c = 'MDF to Living Unit',
            Responsible_for_Media_Panel__c = 'Owner to Provide and Install',
            Exterior_Cabinets__c = 'no',
            NEMA_Rated_Cabinet__c = 'no',
            Backboards_required__c = 'no',   
            Planned_Build_Out_Years__c = 1,
            Actual_Build_Out_Months__c = 1,
            Project_Start_Year__c = '2023',
            Alarm_Due_Date__c = system.today(),
            Open_Trench_Date__c = system.today(),
            ONT_Location__c = 'Interior Non-Integrated',
            Inside_Wiring__c = 'F-4 Ruggedized',
          //  Opportunity__r.Property__r.Max_Bandwidth_Available__c,   
            Units_Built_Year_1__c = 1,
            Units_Built_Year_2__c = 1,
            Units_Built_Year_3__c = 1,    
            F1_Feeder_Type__c = 'Fiber',
            Access_Type__c = 'Fiber',
            Occupant_Type__c = 'CONSUMER',
            Existing_Feeder_Footage_Utilized__c = 1,
            No_GPON_No_Integrated_Switch__c = 'yes',
            Primary_Descriptor_of_CO_Area__c = 'Urban with Many Businesses',
            Existing_Phases_are_Copper__c = 'no',
            Footage_of_New_Feeder_Fiber_Built__c = 1,
            Remote_Electronics_for_Cards_Only__c = 'yes',
            Initial_CO_Deployment_Fiber_Technology__c = 'yes',
            CO_Electronics_for_Cards_Only__c = 'Yes',                    
            Population_Density__c = 'Rural',
            F1_Footage_ft__c = 0,        
            F4_Fiber_Type__c = 'No Drop',
            Capital_Design_Stage__c = 'In-Progress'
        );

        insert allPass;

        lmn_CDRequiredFieldsController.getRequiredFields(allPass.Id);

    }
    
    @isTest
    static void noPassReqFields(){

        Capital_Design__c noPass = new Capital_Design__c(
            Responsible_for_Cable_Home_Wiring__c = '',
            Responsible_for_Home_Run_Wiring__c = '',
            Telecommunication_Cable_Types__c = '',
            Telecom_Cable_Quantity_Per_Living_Unit__c = null,
            Endpoint_Type_building_architecture__c = '',
            Responsible_for_Media_Panel__c = '',
            Exterior_Cabinets__c = '',
            NEMA_Rated_Cabinet__c = '',
            Backboards_required__c = '',   
            Planned_Build_Out_Years__c = null,
            Actual_Build_Out_Months__c = null,
            Project_Start_Year__c = '',
            Alarm_Due_Date__c = null,
            Open_Trench_Date__c = null,
            ONT_Location__c = '',
            Inside_Wiring__c = '',
          //  Opportunity__r.Property__r.Max_Bandwidth_Available__c,   
            Units_Built_Year_1__c = null,
            Units_Built_Year_2__c = null,
            Units_Built_Year_3__c = null,    
            F1_Feeder_Type__c = '',
            Access_Type__c = '',
            Occupant_Type__c = '',
            Existing_Feeder_Footage_Utilized__c= null,
            No_GPON_No_Integrated_Switch__c = '',
            Primary_Descriptor_of_CO_Area__c = '',
            Existing_Phases_are_Copper__c = '',
            Footage_of_New_Feeder_Fiber_Built__c= null,
            Remote_Electronics_for_Cards_Only__c = '',
            Initial_CO_Deployment_Fiber_Technology__c = '',
            CO_Electronics_for_Cards_Only__c = '',                    
            Population_Density__c = '',
            F1_Footage_ft__c= null,        
            F4_Fiber_Type__c = '',
            Capital_Design_Stage__c = ''
        );

        insert noPass;

        lmn_CDRequiredFieldsController.getRequiredFields(noPass.Id);

    }

}