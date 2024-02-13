/**
 * @author  : Ganesh Sirpuram IBM
 * @Description : This class will help to maintain common utility methods and Constants
 * @Date : 16/02/2022
 *  
 * 
===============================================================================================
 * Date         Author      UserStory          Description  
 * 08/02/2023   T2Cabato    QFCJ-4286          BRAIN-Drop-Cost-Fix                   
 * 09/22/2023   T2Cabato    QFCJ-4580          Round CCT cost fields results to 2 decimals 
 * 10/02/2023   T2Cabato    QFCJ-4636          F2 FDH Size in output section not pulling correct values from cost table 
 ***********************************************************************************************/

 @isTest
 public class CDUtilityTest {
    private static StatesCostforCapitalDesign__c testStateCostObj = null;
      @testSetup static void setupTestData(){
         List<StatesCostforCapitalDesign__c> scList = TestDataFactory.createStateCostData(1,TRUE);
       testStateCostObj = scList.get(0);
         
         List<Property__c> properties =TestDataFactory.createProperties(NULL,NULL,'FL',NULL,NULL,NULL,NULL,NULL,1,false);
         properties[0].property_total_units__c = 50;
         //properties[0].Units_Available_for_Segments__c=70;
         insert properties;
         List<Opportunity> opportunities=TestDataFactory.createOpportunities('TESTCCT',
                                                                             'Greenfield',
                                                                             'Contracting',
                                                                             Date.today().addDays(5),
                                                                             properties[0].Id,
                                                                             1,
                                                                             TRUE);
         //List<Segment__c> segList = TestDataFactory.createSegment(opportunities,properties,1,True);
         List<Segment__c> segList = new  List<Segment__c>();
          for(Segment__c seg :  [select Segment_Use__c  from Segment__c]){
              seg.Segment_Use__c = 'Rental';
                  segList.add(seg);
          }
       update segList;
      List<Offer__c> offerList = TestDataFactory.createOffer(opportunities,1,true);
         
         List<CCT_F2_Cost_Estimator__c> costEstimators = TestDataFactory.createCCTF2CostEstimator(
                                        'SFU',500,1,15,TRUE);
     
         
         
         List<Capital_Design__c> capitalDesigns = TestDataFactory.createCapitalDesigns(opportunities[0].Id,1,FALSE);
                                                                   
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
         capitalDesigns[0].Capital_Design_Stage__c='Planner Design Complete'; //ESCJ-1688
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
         capitalDesigns[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_RUGGED;
         capitalDesigns[0].Population_Density__c='Urban';
         capitalDesigns[0].Offer__c = offerList[0].id;
    
         INSERT capitalDesigns; 
        TestDataFactory.createCCTF2CostEstimator('SFU',500,1,15,TRUE);
        TestDataFactory.createCCTF2StubEstimator(100, 2, 1, TRUE);
       // TestDataFactory.createCCTF2FDHEstimator(100, 2, 1, TRUE);//Commenting this as Method is commented in TestDataFacory, which is causing issue while deploying
        TestDataFactory.createCCTCostEstimator('FL', 2, TRUE);   
          
          offerList[0].Associated_Capital_Design__c = capitalDesigns[0].id;
          update offerList;
     }
     
      @isTest static void testGetNumForOntModel(){
          callGetNumForOntModel(CDConstants.FTTU);
          callGetNumForOntModel(CDConstants.FTTB);
          callGetNumForOntModel(CDConstants.FTTIDF);
      }
    
     static void callGetNumForOntModel(String ontModel){
           if(ontModel.equals(CDConstants.FTTB)){
             Integer returnedVal = CDUtility.getNumForOntModel(ontModel, 12.0);
             system.assertEquals(6, returnedVal);
              
             returnedVal = CDUtility.getNumForOntModel(ontModel, 26.0);
             system.assertEquals(12, returnedVal);
          }else if(ontModel.equals(CDConstants.FTTIDF)){
             Integer returnedVal = CDUtility.getNumForOntModel(ontModel, 12.0);
             system.assertEquals(6, returnedVal);
            
             returnedVal = CDUtility.getNumForOntModel(ontModel, 26.0);
             system.assertEquals(12, returnedVal);
              
             returnedVal = CDUtility.getNumForOntModel(ontModel, 50.0);
             system.assertEquals(24, returnedVal);
          }else{
             
              Integer returnedVal = CDUtility.getNumForOntModel(ontModel, 5.0);
              system.assertEquals(6, returnedVal);
              
              returnedVal = CDUtility.getNumForOntModel(ontModel, 12.0);
              system.assertEquals(12, returnedVal);
     
              returnedVal = CDUtility.getNumForOntModel(ontModel, 24.0);
              system.assertEquals(24, returnedVal);
              
              returnedVal = CDUtility.getNumForOntModel(ontModel, 48.0);
              system.assertEquals(48, returnedVal);
              
              returnedVal = CDUtility.getNumForOntModel(ontModel, 60.0);
              system.assertEquals(60, returnedVal);
              
              returnedVal = CDUtility.getNumForOntModel(ontModel, 72.0);
              system.assertEquals(72, returnedVal);
          }
 
     }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType1(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
     Test.stopTest(); 
     }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType2(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType3(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
             cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType4(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType5(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_DUCT;
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
         Test.stopTest();
      }
      @isTest static void testGetF4CostBasedOnBuildAndInstallType6(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
          cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_FIBER;
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
           Test.stopTest();
      }
     
      @isTest static void testGetF4CostBasedOnBuildAndInstallType1BF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
          cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType2BF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType3BF(){
             Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
             cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType4BF(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType5BF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_DUCT;
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
         Test.stopTest();
      }
      @isTest static void testGetF4CostBasedOnBuildAndInstallType6BF(){
           Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
          cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_FIBER;
          cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
           Test.stopTest();
      }
     
     //Cottage
      @isTest static void testGetF4CostBasedOnBuildAndInstallType1CGF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
           cdList[0].Building_Style__c ='Cottage CTL-ON';
          cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
            cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType2CGF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
            cdList[0].Building_Style__c ='Cottage CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType3CGF(){
             Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
             cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
          cdList[0].Building_Style__c ='Cottage CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType4CGF(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
         cdList[0].Building_Style__c ='Cottage CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType5CGF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_DUCT;
        cdList[0].Building_Style__c ='Cottage CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
         Test.stopTest();
      }
      @isTest static void testGetF4CostBasedOnBuildAndInstallType6CGF(){
           Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
          cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_FIBER;
          cdList[0].Building_Style__c ='Cottage CTL-ON';
          cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
            cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
           Test.stopTest();
      }
     //Cottage-Brownfield
      @isTest static void testGetF4CostBasedOnBuildAndInstallType1CBF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
           cdList[0].Building_Style__c ='Cottage CTL-ON';
          cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
            cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType2CBF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
            cdList[0].Building_Style__c ='Cottage CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType3CBF(){
             Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
             cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
          cdList[0].Building_Style__c ='Cottage CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType4CBF(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
         cdList[0].Building_Style__c ='Cottage CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType5CBF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_DUCT;
        cdList[0].Building_Style__c ='Cottage CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
         Test.stopTest();
      }
      @isTest static void testGetF4CostBasedOnBuildAndInstallType6CBF(){
           Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
          cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_FIBER;
          cdList[0].Building_Style__c ='Cottage CTL-ON';
          cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
            cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
           Test.stopTest();
      }
       //For MIDRISE
      @isTest static void testGetF4CostBasedOnBuildAndInstallType1MGF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
           cdList[0].Building_Style__c ='Midrise CTL-ON';
           cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
            cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType2MGF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
            cdList[0].Building_Style__c ='Midrise CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType3MGF(){
             Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
             cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
          cdList[0].Building_Style__c ='Midrise CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType4MGF(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
         cdList[0].Building_Style__c ='Midrise CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType5MGF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_DUCT;
        cdList[0].Building_Style__c ='Midrise CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
         Test.stopTest();
      }
      @isTest static void testGetF4CostBasedOnBuildAndInstallType6MGF(){
           Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
          cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_FIBER;
          cdList[0].Building_Style__c ='Midrise CTL-ON';
          cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
            cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
           Test.stopTest();
      }
     //Midrise-Brownfield
      @isTest static void testGetF4CostBasedOnBuildAndInstallType1MBF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
           cdList[0].Building_Style__c ='Midrise CTL-ON';
          cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
            cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType2MBF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
            cdList[0].Building_Style__c ='Midrise CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType3MBF(){
             Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
             cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
          cdList[0].Building_Style__c ='Midrise CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType4MBF(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
         cdList[0].Building_Style__c ='Midrise CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType5MBF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_DUCT;
        cdList[0].Building_Style__c ='Midrise CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
         Test.stopTest();
      }
      @isTest static void testGetF4CostBasedOnBuildAndInstallType6MBF(){
           Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
          cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_FIBER;
          cdList[0].Building_Style__c ='Midrise CTL-ON';
          cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 5;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
          cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
           Test.stopTest();
      }
      //For HIGHRISE
      @isTest static void testGetF4CostBasedOnBuildAndInstallType1HGF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
           cdList[0].Building_Style__c ='Highrise CTL-ON';
           cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
            cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType2HGF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
            cdList[0].Building_Style__c ='Highrise CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType3HGF(){
             Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
             cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
          cdList[0].Building_Style__c ='Highrise CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType4HGF(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
         cdList[0].Building_Style__c ='Highrise CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType5HGF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_DUCT;
        cdList[0].Building_Style__c ='Highrise CTL-ON';
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
         Test.stopTest();
      }
      @isTest static void testGetF4CostBasedOnBuildAndInstallType6HGF(){
           Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
          cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_FIBER;
          cdList[0].Building_Style__c ='Highrise CTL-ON';
          cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
            cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
           Test.stopTest();
      }
     //Midrise-Brownfield
      @isTest static void testGetF4CostBasedOnBuildAndInstallType1HBF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
           cdList[0].Building_Style__c ='Highrise CTL-ON';
          cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
            cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType2HBF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
            cdList[0].Building_Style__c ='Highrise CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType3HBF(){
             Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
             cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
          cdList[0].Building_Style__c ='Highrise CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
          Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType4HBF(){
         Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_MICRO;
         cdList[0].Building_Style__c ='Highrise CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
         Test.stopTest();
      }
     @isTest static void testGetF4CostBasedOnBuildAndInstallType5HBF(){
          Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
              cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_DUCT;
        cdList[0].Building_Style__c ='Highrise CTL-ON';
         cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
         cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
           cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.DEV_INSTALL, testStateCostObj);
         Test.stopTest();
      }
      @isTest static void testGetF4CostBasedOnBuildAndInstallType6HBF(){
           Test.startTest();
          List<Capital_Design__c> cdList  = [select Property_Address_State__c, Primary_Address_State_Name__c, Building_Style__c,Project_Type__c,F4_Fiber_Type__c from Capital_Design__c limit 1];
          cdList[0].F4_Fiber_Type__c = CDConstants.CTL_PROV_FIBER;
          cdList[0].Building_Style__c ='Highrise CTL-ON';
          cdList[0].Project_Type__c = CDConstants.BROWNFIELD;
          cdList[0].for_Midrise_Highrise_nbof_average_Floors__c = 7;
          cdList[0].for_MDU_nbr_of_Buildings__c  = 5;
          cdList[0].Are_there_IDF__c = 'No';
          update  cdList;
            CDUtility.getF4CostBasedOnBuildAndInstallType(cdList[0], CDConstants.CTL_INSTALL, testStateCostObj);
           Test.stopTest();
      }
     @isTest static void testGetF3CostMultiplierGR(){
        Test.startTest();
         f3CostMultiplierData(CDConstants.GREENFIELD,CDConstants.RETAIL);
         Test.stopTest();
     }
     @isTest static void testGetF3CostMultiplierGCO(){
        Test.startTest();
         f3CostMultiplierData(CDConstants.GREENFIELD,CDConstants.CTL_ON);
         Test.stopTest();
     }
     @isTest static void testGetF3CostMultiplierGBSTR(){
        Test.startTest();
         f3CostMultiplierData(CDConstants.GREENFIELD,CDConstants.BULK_STR);
         Test.stopTest();
     }
      @isTest static void testGetF3CostMultiplierBR(){
        Test.startTest();
         f3CostMultiplierData(CDConstants.BROWNFIELD,CDConstants.RETAIL);
         Test.stopTest();
     }
     @isTest static void testGetF3CostMultiplierBCO(){
        Test.startTest();
         f3CostMultiplierData(CDConstants.BROWNFIELD,CDConstants.CTL_ON);
         Test.stopTest();
     }
     @isTest static void testGetF3CostMultiplierBBSTR(){
        Test.startTest();
         f3CostMultiplierData(CDConstants.BROWNFIELD,CDConstants.BULK_STR);
         Test.stopTest();
     }
     private static void f3CostMultiplierData(String projectType, String serviceType){
          StatesCostforCapitalDesign__c stateCost = new StatesCostforCapitalDesign__c();
         stateCost.F3_Cost_Greenfield_Retail_F3_Multiplier__c = 1;
         stateCost.F3_Cost_Greenfield_CTL_ON_F3_Multiplier__c = 1;
         stateCost.F3_Cost_Greenfield_Bulk_F3_Multiplier__c = 1;
         stateCost.F3_Cost_Brownfield_Retail_F3_Multiplier__c = 1.2;
         stateCost.F3_Cost_Brownfield_CTL_ON_F3_Multiplier__c = 1.2;
         stateCost.F3_Cost_Brownfield_Bulk_F3_Multiplier__c = 1.2;
         CDUtility.getF3CostMultiplier(stateCost,projectType,serviceType);
     }
     
     
          @isTest static void testgetAdjustedOntModel1(){
        Test.startTest();
         CDUtility.getAdjustedOntModel('integrated');
         Test.stopTest();
     }
     @isTest static void testgetAdjustedOntModel2(){
        Test.startTest();
         CDUtility.getAdjustedOntModel('indoor');
         Test.stopTest();
     }
     @isTest static void testgetAdjustedOntModel3(){
        Test.startTest();
         CDUtility.getAdjustedOntModel('outdoor');
         Test.stopTest();
     }
     @isTest static void testgetOntMaterialCostCottage(){
        Test.startTest();
         CCT_ONT_UPS_Shelf_Estimator__c shelfEst = new CCT_ONT_UPS_Shelf_Estimator__c();
         shelfEst.ONT_SFU__c =  CDConstants.YES;
         shelfEst.ONT_Cottage__c =  CDConstants.YES;
         shelfEst.ONT_Midrise__c =    CDConstants.YES;
         shelfEst.ONT_Highrise__c =  CDConstants.YES;
             
          Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontEst = new Map<String,CCT_ONT_UPS_Shelf_Estimator__c>();
         ontEst.put('Adtran-TA352-outdoor-FTTB', shelfEst);
         CDUtility.getOntMaterialCost('Adtran-TA352-outdoor-FTTB', 'Cottage CTL-ON', ontEst);
         Test.stopTest();
     }
     
      @isTest static void testgetOntMaterialCostMidrise(){
        Test.startTest();
         CCT_ONT_UPS_Shelf_Estimator__c shelfEst = new CCT_ONT_UPS_Shelf_Estimator__c();
         shelfEst.ONT_SFU__c =  CDConstants.YES;
         shelfEst.ONT_Cottage__c =  CDConstants.YES;
         shelfEst.ONT_Midrise__c =    CDConstants.YES;
         shelfEst.ONT_Highrise__c =  CDConstants.YES;
             
          Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontEst = new Map<String,CCT_ONT_UPS_Shelf_Estimator__c>();
         ontEst.put('Adtran-TA352-outdoor-FTTB', shelfEst);
         CDUtility.getOntMaterialCost('Adtran-TA352-outdoor-FTTB', 'Midrise CTL-ON', ontEst);
         Test.stopTest();
     }
     
      @isTest static void testgetOntMaterialCostHighrise(){
        Test.startTest();
         CCT_ONT_UPS_Shelf_Estimator__c shelfEst = new CCT_ONT_UPS_Shelf_Estimator__c();
         shelfEst.ONT_SFU__c =  CDConstants.YES;
         shelfEst.ONT_Cottage__c =  CDConstants.YES;
         shelfEst.ONT_Midrise__c =    CDConstants.YES;
         shelfEst.ONT_Highrise__c =  CDConstants.YES;
             
          Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontEst = new Map<String,CCT_ONT_UPS_Shelf_Estimator__c>();
         ontEst.put('Adtran-TA352-outdoor-FTTB', shelfEst);
         CDUtility.getOntMaterialCost('Adtran-TA352-outdoor-FTTB', 'Highrise CTL-ON', ontEst);
         Test.stopTest();
     }
     
      @isTest static void testgetOntMaterialCostSFU(){
        Test.startTest();
         CCT_ONT_UPS_Shelf_Estimator__c shelfEst = new CCT_ONT_UPS_Shelf_Estimator__c();
         shelfEst.ONT_SFU__c =  CDConstants.YES;
         shelfEst.ONT_Cottage__c =  CDConstants.YES;
         shelfEst.ONT_Midrise__c =    CDConstants.YES;
         shelfEst.ONT_Highrise__c =  CDConstants.YES;
             
          Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontEst = new Map<String,CCT_ONT_UPS_Shelf_Estimator__c>();
         ontEst.put('Adtran-TA352-outdoor-FTTB', shelfEst);
         CDUtility.getOntMaterialCost('Adtran-TA352-outdoor-FTTB', 'SFU CTL-ON', ontEst);
         Test.stopTest();
     }
     
     @isTest static void testgetStubFromStateCostSIX(){
        Test.startTest();
        List<StatesCostforCapitalDesign__c> liststate = [select IC_Stub6__c, IC_Stub12__c,IC_Stub24__c,IC_Stub48__c,IC_Stub60__c,IC_Stub72__c from  StatesCostforCapitalDesign__c limit 1];
         CDUtility.getStubFromStateCost(liststate[0],CDConstants.SIX);
         Test.stopTest();
     }
     
     @isTest static void testgetStubFromStateCostTWELVE(){
        Test.startTest();
        List<StatesCostforCapitalDesign__c> liststate = [select IC_Stub6__c, IC_Stub12__c,IC_Stub24__c,IC_Stub48__c,IC_Stub60__c,IC_Stub72__c from  StatesCostforCapitalDesign__c limit 1];
         CDUtility.getStubFromStateCost(liststate[0],CDConstants.TWELVE);
         Test.stopTest();
     }
     
     @isTest static void testgetStubFromStateCostTWENTYFOUR(){
        Test.startTest();
        List<StatesCostforCapitalDesign__c> liststate = [select IC_Stub6__c, IC_Stub12__c,IC_Stub24__c,IC_Stub48__c,IC_Stub60__c,IC_Stub72__c from  StatesCostforCapitalDesign__c limit 1];
         CDUtility.getStubFromStateCost(liststate[0],CDConstants.TWENTYFOUR);
         Test.stopTest();
     }
     
     @isTest static void testgetStubFromStateCostFOURTYEIGHT(){
        Test.startTest();
        List<StatesCostforCapitalDesign__c> liststate = [select IC_Stub6__c, IC_Stub12__c,IC_Stub24__c,IC_Stub48__c,IC_Stub60__c,IC_Stub72__c from  StatesCostforCapitalDesign__c limit 1];
         CDUtility.getStubFromStateCost(liststate[0],CDConstants.FOURTYEIGHT);
         Test.stopTest();
     }
     
     @isTest static void testgetStubFromStateCostSIXTY(){
        Test.startTest();
        List<StatesCostforCapitalDesign__c> liststate = [select IC_Stub6__c, IC_Stub12__c,IC_Stub24__c,IC_Stub48__c,IC_Stub60__c,IC_Stub72__c from  StatesCostforCapitalDesign__c limit 1];
         CDUtility.getStubFromStateCost(liststate[0],CDConstants.SIXTY);
         Test.stopTest();
     }
     
     @isTest static void testgetStubFromStateCostSEVENTYTWO(){
        Test.startTest();
        List<StatesCostforCapitalDesign__c> liststate = [select IC_Stub6__c, IC_Stub12__c,IC_Stub24__c,IC_Stub48__c,IC_Stub60__c,IC_Stub72__c from  StatesCostforCapitalDesign__c limit 1];
         CDUtility.getStubFromStateCost(liststate[0],CDConstants.SEVENTYTWO);
         Test.stopTest();
     }
      
     @isTest static void testIsOntEstModelSmartNID(){
        Test.startTest();
		Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontUPSShelfEstDataMap = CapitalDesignCalculationHelper.ontUPSShelfEstDataMap != NULL && !CapitalDesignCalculationHelper.ontUPSShelfEstDataMap.isEmpty() ?
         										CapitalDesignCalculationHelper.ontUPSShelfEstDataMap : CapitalDesignCalculationHelper.initializeONTUPSShelfEstimatorMap();
        CDUtility.isOntEstModelSmartNID('Axon-C5500XK', ontUPSShelfEstDataMap);
        Test.stopTest();
     }
      
     @isTest static void testIsOntEstModelSmartNIDEstNULL(){
        Test.startTest();
        CDUtility.isOntEstModelSmartNID('Axon-C5500XK', null);
        Test.stopTest();
     }
      
     @isTest static void testIsOntEstModelSmartNIDModelNULL(){
        Test.startTest();
		Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontUPSShelfEstDataMap = CapitalDesignCalculationHelper.ontUPSShelfEstDataMap != NULL && !CapitalDesignCalculationHelper.ontUPSShelfEstDataMap.isEmpty() ?
         										CapitalDesignCalculationHelper.ontUPSShelfEstDataMap : CapitalDesignCalculationHelper.initializeONTUPSShelfEstimatorMap();
        CDUtility.isOntEstModelSmartNID(null, ontUPSShelfEstDataMap);
        Test.stopTest();
     }
      
     @isTest static void testIsOntEstModelSmartNIDModelNonSmartNID(){
        Test.startTest();
		Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontUPSShelfEstDataMap = CapitalDesignCalculationHelper.ontUPSShelfEstDataMap != NULL && !CapitalDesignCalculationHelper.ontUPSShelfEstDataMap.isEmpty() ?
         										CapitalDesignCalculationHelper.ontUPSShelfEstDataMap : CapitalDesignCalculationHelper.initializeONTUPSShelfEstimatorMap();
        CDUtility.isOntEstModelSmartNID('Calix-803G', ontUPSShelfEstDataMap);
        Test.stopTest();
     }
      
 }//end test-class CDUtilityTest