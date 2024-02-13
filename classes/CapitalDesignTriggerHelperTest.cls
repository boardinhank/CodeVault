/*************************************************************************************************
 Purpose: Test class for the CapitalDesignTriggerHelper to test different test scenarios.
===============================================================================================
History:
AUTHOR         DATE           Reference        Description
Ami Parekh    3/03/2022       ESCJ-557         Initial draft
===============================================================================================
 * Date         Author      UserStory          Description  
 * 08/02/2023   T2Cabato    QFCJ-4286          BRAIN-Drop-Cost-Fix                   
 * 09/22/2023   T2Cabato    QFCJ-4580          Round CCT cost fields results to 2 decimals 
 * 10/17/2023   T2Cabato    QFCJ-4683          CCT Rounding Integers using HALF_UP except for Splitter Sub-cost Unit  
 ************************************************************************************************/ 
@isTest
    public class CapitalDesignTriggerHelperTest {
   /*************************************************************************************************
    Purpose: To create Test data
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    1/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/ 
    @testSetup static void testData(){
        List<StatesCostforCapitalDesign__c> scList = TestDataFactory.createStateCostData(1,TRUE);

        
        List<Property__c> properties =TestDataFactory.createProperties(NULL,NULL,'FL',NULL,NULL,NULL,NULL,NULL,1,TRUE);
  
        
        List<Opportunity> opportunities=TestDataFactory.createOpportunities('TESTCCT',
                                                                            'Greenfield',
                                                                            'Contracting',
                                                                            Date.today().addDays(5),
                                                                            properties[0].Id,
                                                                            1,
                                                                            TRUE);
     
        
        List<CCT_F2_Cost_Estimator__c> costEstimators = TestDataFactory.createCCTF2CostEstimator(
            									'SFU',500,1,15,TRUE);
    
        
        
        List<Capital_Design__c> capitalDesigns = TestDataFactory.createCapitalDesigns(opportunities[0].Id,
                                                                                      1,
                                                                                      FALSE);
        capitalDesigns[0].F1_Mobilization_Cost__c = NULL;
        capitalDesigns[0].F1_Splicing_Testing_Cost__c = 7500;
        capitalDesigns[0].F1_Roadway_Crossing_Cost__c = 0;
        capitalDesigns[0].F1_Railroad_Crossing_Cost__c = 0;
        capitalDesigns[0].F1_Bridge_Crossing_Cost__c =0;
        capitalDesigns[0].F1_Canal_Crossing_Cost__c=0;
        capitalDesigns[0].F1_Highway_Crossing_Cost__c=0;
        capitalDesigns[0].F1_Pole_Make_ready_Cost__c=0;
        capitalDesigns[0].F1_Pole_Anchor_and_Guy_Cost__c=0;
        capitalDesigns[0].F1_Pothole_Restoration_Cost__c=0;
        capitalDesigns[0].OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = 10000;
        capitalDesigns[0].OP_F2_Conduit_Sub_cost_Combined_Cost__c = 20000;
        capitalDesigns[0].OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c =30000;
        capitalDesigns[0].OP_F2_Splicing_Sub_cost_Combined_Cost__c =40000;
        capitalDesigns[0].OP_F2_FDH_Sub_cost_Comb_Cost__c =10000;
        capitalDesigns[0].OP_F2_Handhole_Sub_cost_Combined_Cost__c = 200000;
        capitalDesigns[0].OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c = 10000;
        capitalDesigns[0].OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c =1000000;
        capitalDesigns[0].OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c =10000;
        capitalDesigns[0].OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c =10000;
        capitalDesigns[0].F2_Mobilization_Cost__c = NULL;
        capitalDesigns[0].F2_Pole_Make_Ready_Cost__c = NULL;
        capitalDesigns[0].F2_Pole_Anchor_and_Guy_Cost__c = NULL;
        capitalDesigns[0].F2_Pothole_Restoration_Cost__c = NULL;
        capitalDesigns[0].Building_Style__c ='SFU CTL-ON';
        capitalDesigns[0].nbr_of_Living_Units__c = 1289;
        capitalDesigns[0].for_SFU_Average_Lot_Size__c= '50';
        capitalDesigns[0].for_MDU_nbr_of_Buildings__c= NULL;  //Because of custom validation updated field value
        capitalDesigns[0].for_Midrise_Highrise_nbof_average_Floors__c= 10;
        capitalDesigns[0].Capital_Design_Stage__c='Planner Design Complete';  //ESCJ-1688
        capitalDesigns[0].F1_Cost_ft_for_Aerial_10M_144f__c = NULL;
        capitalDesigns[0].F1_Cost_ft_for_Blended_Cost_from_FW__c=NULL;
        capitalDesigns[0].F1_Cost_ft_for_Cobble_Bore_1_25_c_864f__c =NULL;
        capitalDesigns[0].F1_Cost_ft_for_Custom_without_conduit__c = NULL;
        capitalDesigns[0].F2_Sub_Total_of_Footage__c =NULL;
        capitalDesigns[0].F1Cost_ft_JointTrench_Custom_withconduit__c=10;
        capitalDesigns[0].F1_Cost_ft_for_Custom_without_conduit__c	=0;
        capitalDesigns[0].F2_Cost_ft_for_Custom_without_conduit__c=7;
        capitalDesigns[0].F2Cost_ft_JointTrench_Custom_withconduit__c=11.7;
        capitalDesigns[0].F1_Cost_ft_for_Overpull_1_25_c_864f__c=NULL;
         //capitalDesigns[0].F3_Avg_Drop_Length_ft__c=100;
        capitalDesigns[0].F3_related_cost_for_slack_box_cost__c=1500;
        capitalDesigns[0].F3_Cost_ft_for_Aerial_12f__c=NULL;
        capitalDesigns[0].F3_Cost_ft_for_Bore_1_25_c_12f__c=NULL;
        capitalDesigns[0].F3_Cost_ft_for_Buried_w_Conduit_12f__c=0;
        capitalDesigns[0].F3_cost_ft_direct_buried_12f__c=NULL;
        capitalDesigns[0].F3_Cost_ft_for_Joint_Trench_Custom__c=1;
        capitalDesigns[0].F3_Cost_ft_for_Pull_Fiber_12f__c=NULL;
        capitalDesigns[0].Project_Type__c = CDConstants.GREENFIELD;
        capitalDesigns[0].Service_Type__c = CDConstants.CTL_ON;
        capitalDesigns[0].F3_Fiber_Type__c = CDConstants.BURIED;
        capitalDesigns[0].Population_Density__c='Urban';
     	capitalDesigns[0].F4_Fiber_Type__c='No Drop';
        INSERT capitalDesigns;        
    }

    /**********************************************************************************************
    Purpose: This method is used to test, with required input all apex formulas ,
             including sub total for F1, F2 & F3
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/ 
    @isTest static void testMethodPositiveScenario() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
             for(Capital_Design__c c : capitalDesigns){
            c.F1_Splicing_Testing_Cost__c = 7500;
        }
        UPDATE capitalDesigns;
        Test.startTest();
        List<Capital_Design__c> capitalDesign = getcapitalDesigns();
        capitalDesign[0].F1_Footage_ft__c=5300;
        UPDATE capitalDesign;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT F2_Footage_Custom_without_conduit__c,
                                     F1_Fiber_Conduit_Sub_Total_for_Footage__c,
                                     F1_Fiber_Conduit_Sub_Total_for_Cost__c,
                                     F1_Related_Cost_Sub_Total__c,
                                     F1_Fiber_Conduit_Sub_Total_for_Cost_ft__c,
                                     F2FootageJointTrench_Custom_withconduit__c,
                                     F2_Related_Cost_Sub_Total__c,
                                     F2_Sub_Total_of_Footage__c,
                                     F1_Cost_ft_for_Overpull_1_25_c_864f__c,
                                     F1FootageTrench_Custom_with_conduit__c,
                                     F1_Footage_for_Overpull_1_25_c_864f__c,
                                     F2_Sub_Total_of_Cost_ft__c,
                                     F2_Sub_Total_of_Cost__c,
                                     F1_Cost_ft_for_Blended_Cost_from_FW__c
                                     FROM Capital_Design__c ];
        			//System.assertEquals(expected, actual);
                    System.assertEquals(5300, c[0].F1_Fiber_Conduit_Sub_Total_for_Footage__c);
                    System.assertEquals(4505, c[0].F1FootageTrench_Custom_with_conduit__c);
                    System.assertEquals(795, c[0].F1_Footage_for_Overpull_1_25_c_864f__c);
                    System.assertEquals(12500, c[0].F1_Related_Cost_Sub_Total__c);
                    System.assertEquals(64456.5, c[0].F2FootageJointTrench_Custom_withconduit__c);
                    System.assertEquals(1993.5, c[0].F2_Footage_Custom_without_conduit__c);
                    System.assertEquals(66450.0, c[0].F2_Sub_Total_of_Footage__c);   
                    System.assertEquals(13.9, c[0].F1_Cost_ft_for_Blended_Cost_from_FW__c);
                    System.assertEquals(768095.55, c[0].F2_Sub_Total_of_Cost__c);
                    System.assertEquals(11.56, c[0].F2_Sub_Total_of_Cost_ft__c);
                    System.assertEquals(53000, c[0].F1_Fiber_Conduit_Sub_Total_for_Cost__c);
                    System.assertEquals(10, c[0].F1_Fiber_Conduit_Sub_Total_for_Cost_ft__c);
    }
     
    /**********************************************************************************************
    Purpose: This method is used to test, F2 Footage Formulas
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/ 
		//To test F2 Footage formulas 
    @isTest static void testMethodForF2Footage() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
            cd.F2_Direct_Buried_96f__c = 10;
            cd.F2_Aerial_10M_144f__c = 10 ;
            cd.Pull_Fiber_96f__c = 10;
            cd.Place_Conduit_4_c__c = 10;
            cd.Place_Conduit_and_Pull_Fiber_4_c_96f__c =10;
            cd.Trench_4_c_96f__c = 10;
            cd.Bore_1_25_c_96f__c =10;
            cd.Cobble_Bore_1_25_c_96f__c =10;
            cd.Rock_Bore_1_25_c_96f__c =10;
            cd.F2_Joint_Trench_Custom_with_conduit__c = 10 ;
            cd.F2_Custom_without_conduit__c = 10;    
        }   
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT F2_Footage_Custom_without_conduit__c,
                                     F2_Footage_Direct_Buried_96f__c,
                                     F2_Footage_Aerial_10M_144f__c,
                                     F2_Footage_Pull_Fiber_96f__c,
                                     F2_Footage_Place_Conduit_4_c__c,
                                     F2_Footage_PlaceConduitFiber_4_c_96f__c,
                                     F2_Footage_Trench_4_c_96f__c,
                                     F2_Footage_Bore_1_25_c_96f__c,
                                     F2_Footage_Cobble_Bore_1_25_c_96f__c,
                                     F2_Footage_Rock_Bore_1_25_c_96f__c,
                                     F2FootageJointTrench_Custom_withconduit__c
                                     FROM Capital_Design__c ];
         System.assertEquals(6645, c[0].F2_Footage_Custom_without_conduit__c); 
         System.assertEquals(6645, c[0].F2_Footage_Direct_Buried_96f__c); 
         System.assertEquals(6645, c[0].F2_Footage_Aerial_10M_144f__c); 
         System.assertEquals(6645, c[0].F2_Footage_Pull_Fiber_96f__c); 
         System.assertEquals(6645, c[0].F2_Footage_Place_Conduit_4_c__c); 
         System.assertEquals(6645, c[0].F2_Footage_PlaceConduitFiber_4_c_96f__c); 
         System.assertEquals(6645, c[0].F2_Footage_Trench_4_c_96f__c); 
         System.assertEquals(6645, c[0].F2_Footage_Bore_1_25_c_96f__c); 
         System.assertEquals(6645, c[0].F2_Footage_Cobble_Bore_1_25_c_96f__c); 
         System.assertEquals(6645, c[0].F2_Footage_Rock_Bore_1_25_c_96f__c); 
         System.assertEquals(6645, c[0].F2FootageJointTrench_Custom_withconduit__c);     
    }
    
    
    /**********************************************************************************************
    Purpose: This method is used to test, if calculatedValues is greater than one lakh then
            F2 Mobilization Cost will be calculated based on F2_Eng_time_Cost_100K_200K_OVH__c
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    1/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/ 
    @isTest static void subTotalofF2RelatedCostGreaterThanOneLakh() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
            cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = 1000;
            cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c = 2000;
            cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c =3000;
            cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c =4000;
            cd.OP_F2_FDH_Sub_cost_Comb_Cost__c =1000;
            cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c = 2000;
            cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c = 1000;
            cd.OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c =100000;
            cd.OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c =1000;
            cd.OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c =1000;
            cd.F2_Mobilization_Cost__c=4000;
        }
        
         Test.startTest();
		UPDATE capitalDesigns;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT F2_Mobilization_Cost__c,
                                     F2_Related_Cost_Sub_Total__c
                                     FROM Capital_Design__c ];
         System.assertEquals(4000, c[0].F2_Mobilization_Cost__c); 
    }
    
    /**********************************************************************************************
    Purpose: This method is used to test, if calculatedValues is greater than fifty thousand then
            F2 Mobilization Cost will be calculated based on F2_Eng_time_Cost_50K_100K_OVH__c
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    1/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/ 
    @isTest static void subTotalofF2RelatedCostGreaterThanFiftyThousand() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
            cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = 1000;
            cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c = 2000;
            cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c =3000;
            cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c =4000;
            cd.OP_F2_FDH_Sub_cost_Comb_Cost__c =1000;
            cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c = 20000;
            cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c = 10000;
            cd.OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c =10000;
            cd.OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c =10000;
            cd.OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c =10000; 
        }
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT F2_Mobilization_Cost__c,
                                     F2_Related_Cost_Sub_Total__c
                                     FROM Capital_Design__c ];
         System.assertEquals(NULL, c[0].F2_Mobilization_Cost__c); 
        
    }
    

    /**********************************************************************************************
    Purpose: This method is used to test Cost/ft for F1 when Development Status is Brownfield
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/ 
    @isTest static void f1CostftDevelopmentStatusAsBrownfield() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        Opportunity opp = [SELECT ID, Development_Status__c FROM Opportunity LIMIT 1];
        opp.Development_Status__c='Brownfield';
        UPDATE opp;
        for(Capital_Design__c cd : capitalDesigns){
                cd.Overpull_1_25_c_864f__c = NULL;
        }
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT F1_Cost_ft_for_Blended_Cost_from_FW__c,
                                     F1_Fiber_Conduit_Sub_Total_for_Cost__c,
                                     F1_Fiber_Conduit_Sub_Total_for_Cost_ft__c
                                     FROM Capital_Design__c ];
        System.assertEquals(13.9, c[0].F1_Cost_ft_for_Blended_Cost_from_FW__c); 
    }
    
    /**********************************************************************************************
    Purpose: This method is used to test If sub total is greater than 100 then Footage, Cost/ft ,
			 Cost value will not be calculated
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    1/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/     
    @isTest static void f1CalculationNegativeScenario() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
         cd.F1_Footage_ft__c = 1000;
         cd.Lateral_Bore_1_25_c_864f__c = 70;
         cd.Backbone_Bore_1_25_c_3_in_4_c_864f__c =70;
        }
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT F1_Fiber_Conduit_Sub_Total_for_Footage__c,
                                     F1_Fiber_Conduit_Sub_Total_for_Cost__c,
                                     F1_Fiber_Conduit_Sub_Total_for_Cost_ft__c,
                                     F1_Fiber_And_Conduit_Sub_Total__c
                                     FROM Capital_Design__c ];
        System.assertEquals(0, c[0].F1_Fiber_Conduit_Sub_Total_for_Footage__c); 
        System.assertEquals(240, c[0].F1_Fiber_And_Conduit_Sub_Total__c);
        System.assertEquals(0, c[0].F1_Fiber_Conduit_Sub_Total_for_Cost__c);
        System.assertEquals(0, c[0].F1_Fiber_Conduit_Sub_Total_for_Cost_ft__c);
    }
    
    /**********************************************************************************************
    Purpose: This method is used to test when Building Style as Cottage then tempCostVariable 
             will be calculated based on it's respective formula 
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
    @isTest static void whenBuildingTypeCootageForF2Footage() {
        CCT_F2_Cost_Estimator__c ce = [SELECT Id,F2_CostE_Building_Type__c FROM CCT_F2_Cost_Estimator__c LIMIT 1];
        ce.F2_CostE_Building_Type__c = 'Cottage'; 
        UPDATE ce;
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
            cd.Building_Style__c = 'Cottage CTL-ON';
            cd.for_MDU_nbr_of_Buildings__c=10;
        } 
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        System.assertEquals(5000, CapitalDesignTriggerHelper.tempCostCalVariable);  
    }
    
    /**********************************************************************************************
    Purpose: This method is used to test when Building Style as NULL then tempCostVariable 
             will be Zero and further calcutions based on this will not performed and Calculations
             for other formulas will be calculated based on other conditions
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
      @isTest static void whenBuildingTypeNullForF2Footage() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
            cd.Building_Style__c = '';
        } 
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        System.assertEquals(0, CapitalDesignTriggerHelper.tempCostCalVariable);  
    }
 
    /**********************************************************************************************
    Purpose: This method is used to test when F1 Footage is Greater and F1_Mobilization_Cost__c is
             null then based on Formula Sub total calculated
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
      @isTest static void f1MobilizationWhenFootageIsGreater() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
            cd.F1_Footage_ft__c=8000;
        } 
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT F1_Mobilization_Cost__c,
                                     F1_Related_Cost_Sub_Total__c
                                     FROM Capital_Design__c ];
        System.assertEquals(13900.00, c[0].F1_Related_Cost_Sub_Total__c); 
    }
    
    /**********************************************************************************************
    Purpose: This method is used to test when Input Fields value for F2 is NULL then Footage
             for those fileds will be Zero
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
     @isTest static void whenFieldForF2NullFootageZero() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
            cd.Place_Conduit_4_c__c=NULL;
        } 
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT 
                                     F2_Footage_Place_Conduit_4_c__c
                                     FROM Capital_Design__c ]; 
        System.assertEquals(0, c[0].F2_Footage_Place_Conduit_4_c__c);  
    }
        
        
    /**********************************************************************************************
    Purpose: This method is used to test F1_Mobilization_Cost__c is not blank
             added in Sub total calculated
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    24/03/2022       ESCJ-614        Initial draft
    ***********************************************************************************************/
      @isTest static void f1Mobilization() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
            cd.F1_Footage_ft__c=8000;
            cd.F1_Mobilization_Cost__c=800;
        } 
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT F1_Mobilization_Cost__c,
                                     F1_Related_Cost_Sub_Total__c
                                     FROM Capital_Design__c ];
        System.assertEquals(8300.00, c[0].F1_Related_Cost_Sub_Total__c); 
    }    

    /**********************************************************************************************
    Purpose: This method is used to test when Building Style as Highrise then tempCostVariable 
             will be calculated based on it's respective formula 
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
    @isTest static void whenBuildingTypeHighriseForF2Footage() {
        CCT_F2_Cost_Estimator__c ce = [SELECT Id,F2_CostE_Building_Type__c FROM CCT_F2_Cost_Estimator__c LIMIT 1];
        ce.F2_CostE_Building_Type__c = 'Highrise'; 
        UPDATE ce;
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
            cd.Building_Style__c = 'Highrise CTL-ON';
            cd.for_MDU_nbr_of_Buildings__c=10;
        } 
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        System.assertEquals(5010, CapitalDesignTriggerHelper.tempCostCalVariable);  
    }
    

    /**********************************************************************************************
    Purpose: This method is used to test when Footage F2 is Zero then further Calcutions are 
             based on tempCostCalVariable and formulas for F2 Footage, Cost/ft, Cost will be 
             calculated based on that.
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/
        @isTest static void whenF2FootageIsZeroOrNull() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c cd : capitalDesigns){
            cd.F2_Footage_ft__c=0;
        } 
        Test.startTest();
        UPDATE capitalDesigns;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT id,
                                     F2_Footage_Custom_without_conduit__c,
                                     F2FootageJointTrench_Custom_withconduit__c,
                                     F2_Footage_ft__c,
                                     F2_Sub_Total_of_Footage__c
                                     FROM Capital_Design__c ];
        System.assertEquals(64450, CapitalDesignTriggerHelper.tempCostCalVariable); 
        System.assertEquals(62516.5, C[0].F2FootageJointTrench_Custom_withconduit__c); 
        System.assertEquals(1933.5, C[0].F2_Footage_Custom_without_conduit__c); 
        System.assertEquals(64450.0, C[0].F2_Sub_Total_of_Footage__c);    
        System.assertEquals(0, C[0].F2_Footage_ft__c); 
    } 
   
    
    
     /**********************************************************************************************
    Purpose: This method is used to test Related cost field for F3 
			 
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Shobith N     1/03/2022        ESCJ-559         Initial draft
    ***********************************************************************************************/  
    @isTest static void testMethodPositiveScenario1() {
              
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
        for(Capital_Design__c c : capitalDesigns){
            c.F3_related_cost_for_slack_box_cost__c = 1000;
        }  

       UPDATE capitalDesigns;
        Test.startTest();
        CapitalDesignTriggerHelper obj=new CapitalDesignTriggerHelper();
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT  F3_Related_cost_Sub_Total__c ,
                                             F3_Cost_ft_for_Aerial_12f__c
                                                  FROM Capital_Design__c ];
       //System.assertEquals(1000, c[0]. F3_Related_cost_Sub_Total__c);
       // System.assertEquals(2, c[0]. F3_Cost_ft_for_Aerial_12f__c);
}
    
     
     /**********************************************************************************************
    Purpose: This method is used to test Sub Total Fields of F3 
			 
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Shobith N     1/03/2022        ESCJ-559         Initial draft
    ***********************************************************************************************/  
    
     @isTest static void F3subtotal() {
        List<Capital_Design__c> capitalDesigns = getcapitalDesigns();
             for(Capital_Design__c c : capitalDesigns){
            c.F3_related_cost_for_slack_box_cost__c = 1000;
        }
        UPDATE capitalDesigns;
        Test.startTest();
        List<Capital_Design__c> capitalDesign = getcapitalDesigns();
        //capitalDesign[0].F3_Avg_Drop_Length_ft__c=100;
        UPDATE capitalDesign;
        Test.stopTest();
        List<Capital_Design__c> c = [SELECT  F3_Footage_For_Bore_1_25_c_12f__c,
                                     F3_Sub_total_For_cost__c,
                                     F3_Related_cost_Sub_Total__c,
                                     F3_Sub_total_for_Cost_ft__c,
                                     F3_Sub_total__c,
                                     F3_Footage_for_Sub_total__c
                                     FROM Capital_Design__c ];
        
       // System.assertEquals(c[0].F3_Footage_for_Sub_total__c, 5300);
        //System.assertEquals(c[0].F3_Footage_For_Bore_1_25_c_12f__c, 530);
       // System.assertEquals(c[0].F3_Related_cost_Sub_Total__c, 12500);
        //System.assertEquals(c[0].F3_Sub_total_For_cost__c,53000);
        //System.assertEquals(c[0].F3_Sub_total_for_Cost_ft__c,10);
    }
    
    
   /**********************************************************************************************
    Purpose: This method is used to return the List of Capital Design records
    ===============================================================================================
    History:
    AUTHOR         DATE           Reference        Description
    Ami Parekh    3/03/2022       ESCJ-557         Initial draft
    ***********************************************************************************************/ 
  
    private static List<Capital_Design__c> getcapitalDesigns(){
        return [SELECT Id,
                Opportunity__c,
                Opportunity__r.Name,
                F2_Direct_Buried_96f__c,
                F2_Aerial_10M_144f__c,
                Pull_Fiber_96f__c,
                F2_Footage_ft__c,
                Place_Conduit_4_c__c,
                Place_Conduit_and_Pull_Fiber_4_c_96f__c,
                Trench_4_c_96f__c,
                Bore_1_25_c_96f__c,
                Cobble_Bore_1_25_c_96f__c,
                Rock_Bore_1_25_c_96f__c,
                F2_Joint_Trench_Custom_with_conduit__c,
                F2_Custom_without_conduit__c,
                Use_Existing_Spare__c,
                Use_Vacant_12f__c,
                Plow_2_c_48f__c,
                F1_Direct_Buried_96f__c,
                F1_Aerial_10M_144f__c,
                Overpull_1_25_c_864f__c,
                Blended_Cost_from_FW__c,
                Lateral_Bore_1_25_c_864f__c,
                Backbone_Bore_1_25_c_3_in_4_c_864f__c,
                Cobble_Bore_1_25_c_in_4_c_864f__c,
                Cobble_Bore_1_25_c_864f__c,
                Rock_Bore_1_25_c_864f__c,
                Rock_Bore_1_25_c_in_4_c_864f__c,
                F1_Joint_Trench_Custom_with_conduit__c,
                F1_Custom_without_conduit__c,
                F1_Footage_ft__c,
                F1_Mobilization_Cost__c,
                F1_Splicing_Testing_Cost__c,
                F1_Roadway_Crossing_Cost__c,
                F1_Railroad_Crossing_Cost__c,
                F1_Bridge_Crossing_Cost__c,
                F1_Canal_Crossing_Cost__c,
                F1_Highway_Crossing_Cost__c,
                F1_Pole_Make_ready_Cost__c,
                F1_Pole_Anchor_and_Guy_Cost__c,
                F1_Pothole_Restoration_Cost__c,
                OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c,
                OP_F2_Conduit_Sub_cost_Combined_Cost__c,
                OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c,
                OP_F2_Splicing_Sub_cost_Combined_Cost__c,
                OP_F2_FDH_Sub_cost_Comb_Cost__c,
                OP_F2_Handhole_Sub_cost_Combined_Cost__c,
                OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c,
                OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c,
                OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c,
                OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c,
                F2_Mobilization_Cost__c,
                F2_Pole_Make_Ready_Cost__c,
                F2_Pole_Anchor_and_Guy_Cost__c,
                F2_Pothole_Restoration_Cost__c,
                Building_Style__c,
                for_SFU_Average_Lot_Size__c,
                nbr_of_Living_Units__c ,        
                for_MDU_nbr_of_Buildings__c,
                for_Midrise_Highrise_nbof_average_Floors__c,
                F1_Cost_ft_for_Aerial_10M_144f__c ,
                F1_Cost_ft_for_Blended_Cost_from_FW__c,
                F1_Cost_ft_for_Cobble_Bore_1_25_c_864f__c,
                F1_Cost_ft_for_Custom_without_conduit__c ,
                F2_Sub_Total_of_Footage__c, 
                Property_Address_State__c,
                Primary_Address_State_Name__c,
                F1_Cost_ft_for_Use_Existing_Spare__c,
                F1_Cost_ft_for_Use_Vacant_12f__c,
                F1_Cost_ft_for_Plow_2_c_48f__c,
                F1_Cost_ft_for_Direct_Buried_96f__c,
                F1_Cost_ft_for_Overpull_1_25_c_864f__c,
                F1_Cost_ft_for_Lateral_Bore_1_25_c_864f__c,
                F1Cost_ftBackbonBore_1_25_c_3_in4_c864f__c,
                F1_Cost_ft_forCobbleBore1_25_c_in4_c_864__c,
                F1_Cost_ft_for_Rock_Bore_1_25_c_864f__c,
                Development_Status__c,
                F2_Cost_ft_for_Direct_Buried_96f__c,
                F2_Cost_ft_for_Aerial_10M_144f__c,
                F2_Cost_ft_for_Pull_Fiber_96f__c,
                F2_Cost_ft_for_Place_Conduit_4_c__c,
                F2Cost_ft_PlaceConduit_PullFiber_4_c_96f__c,
                F2_Cost_ft_for_Trench_4_c_96f__c,
                F2_Cost_ft_for_Bore_1_25_c_96f__c,
                F2_Cost_ft_for_Cobble_Bore_1_25_c_96f__c,
                F2_Cost_ft_for_Rock_Bore_1_25_c_96f__c,
                F1_Fiber_And_Conduit_Sub_Total__c,
                F1_Fiber_Conduit_Sub_Total_for_Footage__c,
                F1_Footage_for_Use_Vacant_12f__c,
                F1_Footage_for_Plow_2_c_48f__c,
                F1_Footage_for_Direct_Buried_96f__c,
                F1_Footage_for_Aerial_10M_144f__c,
                F1_Footage_for_Overpull_1_25_c_864f__c,
                F1_Footage_for_Blended_Cost_from_FW__c,
                F1_Footage_for_Lateral_Bore_1_25_c_864f__c,
                F1FootageBackbonBore_1_25_c_3_in4_c864f__c,
                F1_Footage_Cobble_Bore_1_25_c_in_4_c_864__c,
                F1_Footage_for_Cobble_Bore_1_25_c_864f__c,
                F1_Footage_for_Rock_Bore_1_25_c_864f__c,
                F1_Footage_for_RockBore1_25_c_in_4_c_864__c,
                F1_Footage_for_Use_Existing_Spare__c,
                F1FootageTrench_Custom_with_conduit__c,
                F1_Footage_for_Custom_without_conduit__c,
                F1_Cost_for_Plow_2_c_48f__c,
                F1_Cost_for_Direct_Buried_96f__c,
                F1_Cost_for_Aerial_10M_144f__c,
                F1_Cost_for_Overpull_1_25_c_864f__c,
                F1_Cost_for_Blended_Cost_from_FW__c,
                F1_Cost_for_Lateral_Bore_1_25_c_864f__c,
                F1_CostBackboneBore_1_25_c_3_i_4_c864f__c,
                F1_Cost_CobbleBore_1_25_c_in_4_c_864f__c,
                F1_Cost_for_Cobble_Bore_1_25_c_864f__c,
                F1_Cost_for_Rock_Bore_1_25_c_864f__c,
                F1_Cost_for_RockBore1_25_c_in_4_c_864__c,
                F1CostforTrench_Custom_with_conduit__c,
                F1_Cost_for_Custom_without_conduit__c,
                F1_Fiber_Conduit_Sub_Total_for_Cost__c,
                F1_Fiber_Conduit_Sub_Total_for_Cost_ft__c,
                F1_Cost_for_Use_Existing_Spare__c,
                F1_Cost_for_Use_Vacant_12f__c,
                F2_Footage_Direct_Buried_96f__c,
                F2_Footage_Aerial_10M_144f__c,
                F2_Footage_Pull_Fiber_96f__c,
                F2_Footage_Place_Conduit_4_c__c,
                F2_Footage_PlaceConduitFiber_4_c_96f__c,
                F2_Footage_Trench_4_c_96f__c,
                F2_Footage_Bore_1_25_c_96f__c,
                F2_Footage_Cobble_Bore_1_25_c_96f__c,
                F2_Footage_Rock_Bore_1_25_c_96f__c,
                F2FootageJointTrench_Custom_withconduit__c,
                F2_Footage_Custom_without_conduit__c,
                F2_Cost_for_Direct_Buried_96f__c,
                F2_Cost_for_Aerial_10M_144f__c,
                F2_Cost_for_Pull_Fiber_96f__c,
                F2_Cost_for_Place_Conduit_4_c__c,
                F2_CostPlaceConduitPull_Fiber_4_c96f__c,
                F2_Cost_for_Trench_4_c_96f__c,
                F2_Cost_for_Bore_1_25_c_96f__c,
                F2_Cost_for_Cobble_Bore_1_25_c_96f__c,
                F2_Cost_for_Rock_Bore_1_25_c_96f__c,
                F2_Cost_Joint_Trench_Custom_withconduit__c,
                F2_Cost_for_Custom_without_conduit__c,
                F2_Sub_Total_of_Cost__c,
                F2_Sub_Total_of_Cost_ft__c,
                F2_Related_Cost_Sub_Total__c,
                F2_Fiber_Conduit_Placement_Sub_Total__c,
                OP_F2_Splitter_Sub_cost_Combined_Cost__c,
                F1_Cost_ft_RockBore_1_25_c_in_4_c_864f__c,
                F2_Cost_ft_for_Custom_without_conduit__c,
                F2Cost_ft_JointTrench_Custom_withconduit__c,
                //f3 section fields
                Direct_Buried_12f__c,
                Buried_w_Conduit_12f__c,
                Aerial_12f__c,
                Bore_1_25_c_12f__c,
                Joint_Trench_Custom__c,
               // F3_Avg_Drop_Length_ft__c,
                F3_related_cost_for_slack_box_cost__c,
                F3_Related_cost_Sub_Total__c,
                Pull_Fiber_12f__c,
                F3_Cost_ft_for_Aerial_12f__c,
                F3_Cost_ft_for_Bore_1_25_c_12f__c,
                F3_Cost_ft_for_Buried_w_Conduit_12f__c,
                F3_cost_ft_direct_buried_12f__c,
                F3_Cost_ft_for_Joint_Trench_Custom__c,
                F3_Cost_ft_for_Pull_Fiber_12f__c,
                F3_Sub_total_for_Cost_ft__c ,
                F3_Cost_for_Aerial_12f__c,
                F3_Cost_for_Bore_1_25_c_12f__c,
                F3_Cost_for_Buried_w_Conduit_12f__c,
                F3_Cost_for_Direct_Buried_12f__c,
                F3_Cost_for_Joint_Trench_Custom__c,
                F3_Cost_for_Pull_Fiber_12f__c,
                F3_Sub_total_For_cost__c,
                F3_Footage_For_Aerial_12f__c,
                F3_Footage_For_Bore_1_25_c_12f__c,
                F3_Footage_For_Buried_w_Conduit_12f__c,
                F3_Footage_for_Direct_Buried_12f__c,
                F3_Footage_For_Joint_Trench_Custom__c,
                F3_Footage_For_Pull_Fiber_12f__c,
                F3_Sub_total__c,
                F3_Footage_for_Sub_total__c,
                Population_Density__c,
                F3_Fiber_Type__c,// 1471 BUG FIX.
                OP_F3_Fiber_Stub_Sub_Cost_Installation__c // ESCJ-1471 BUG FIX
                FROM Capital_Design__c 
                WHERE Opportunity__c !=NULL
                  AND Opportunity__r.Name LIKE 'TESTCCT%' LIMIT 1];
    }
   
}//end test-class CapitalDesignTriggerHelperTest