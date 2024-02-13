/**
 * @author  : Ganesh Sirpuram IBM
 * @Description : This class will help to get formula calculations for cct tool
 *  create common formula utility methods 
 * @Date : 16/02/2022
 *  
 * 
===============================================================================================
 * Date         Author      UserStory          Description  
 * 08/02/2023   T2Cabato    QFCJ-4286          BRAIN-Drop-Cost-Fix                   
 ***********************************************************************************************/
// write method level commens
public With sharing class CapitalDesignCalculationHelper {
    
    public static Map<String,StatesCostforCapitalDesign__c> stateDataMap = new Map<String,StatesCostforCapitalDesign__c>();
    public static Map<String,CCT_F2_Cost_Estimator__c> f2CostEstDataMap = new Map<String,CCT_F2_Cost_Estimator__c>();
    //public static Map<String,CCT_F2_Stub_Estimator__c> f2StubEstDataMap = new Map<String,CCT_F2_Stub_Estimator__c>();
    public static Map<String,CCT_F2_Stub_Estimator__c> f2StubEstBuildingStyleMap = new Map<String,CCT_F2_Stub_Estimator__c>();
    //public static Map<String,CCT_F2_Stub_Estimator__c> f2StubEstBuildingTypeMap = new Map<String,CCT_F2_Stub_Estimator__c>();
    public static Map<Decimal,CCT_F2_FDH_Estimator__c> f2FDHEstIndoorMap = new Map<Decimal,CCT_F2_FDH_Estimator__c>();
    public static Map<Decimal,CCT_F2_FDH_Estimator__c> f2FDHEstOutDoorMap = new Map<Decimal,CCT_F2_FDH_Estimator__c>();
    public static Map<Decimal,CCT_F2_FDH_Estimator__c> f2FDHEstSuttlePedMap = new Map<Decimal,CCT_F2_FDH_Estimator__c>();
    public static Map<String,CCT_F1_Cost_Estimator__c> f1CostEstDataMap = new Map<String,CCT_F1_Cost_Estimator__c>();
    public static Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontUPSShelfEstDataMap = new Map<String,CCT_ONT_UPS_Shelf_Estimator__c>();
    public static Map<String,CCT_Cost_Estimator__c> costEstDataMap = new Map<String,CCT_Cost_Estimator__c>();
    public static Map<String,CCT_Cost_Estimator__c> costEstDataMapByState = new Map<String,CCT_Cost_Estimator__c>();
    public static List<CCT_Cost_Estimator__c> costEstDataListBySFU = new List<CCT_Cost_Estimator__c>();
    public static List<CCT_Cost_Estimator__c> costEstDataListByMDU = new List<CCT_Cost_Estimator__c>();
    public static Map<Decimal,CCT_Cost_Estimator__c> getSpltrEstimatorDataMap = new Map<Decimal,CCT_Cost_Estimator__c>();
       
       
       
   /**
        * Description : This method will help to check the Field value is null or not null
        * Param output : number value 
        * Param Input : Number fieldValue
        **/
       public static Map<String,StatesCostforCapitalDesign__c> initializeStateCostMap(){
           
           for(StatesCostforCapitalDesign__c sc :[SELECT Id, Name, F1_Cost_ft_LE_Use_Existing_Spare__c,
                                                  F1_Cost_ft_LE_Use_Vacant_12f__c,
                                                  F1_Cost_ft_LE_Plow_2_c_48f__c,
                                                  F1_Cost_ft_LE_Aerial_10M_144f__c,
                                                  F1_Cost_ft_LE_Overpull_1_25_c_864f__c,
                                                  F1_Cst_ft_BackbonBore_1_25_c_3_in4_c864__c,
                                                  F1_Cost_ft_LE_Cobble_Bore_1_25_c_864f__c,
                                                  F1_Cst_ft_Cobble_Bore_1_25_c_in_4_c_864__c,
                                                  F1_Cost_ft_LE_Direct_Buried_96f__c,
                                                  F1_Cost_ft_LE_Lateral_Bore_1_25_c_864f__c,
                                                  F1_Cost_ft_LE_Rock_Bore_1_25_c_864f__c,
                                                  F1_Cst_ft_Rock_Bore_1_25_c_in_4_c_864f__c,
                                                  F1_Cost_ft_FW_Blended__c,
                                                  F1_Cost_ft_FW_Greenfield_F1_Multiplier__c,
                                                  F1_Cost_ft_FW_Brownfield_F1_Multiplier__c,
                                                  F2_Cost_ft_LE_Direct_Buried_96f__c,
                                                  F2_Cost_ft_LE_Aerial_10M_144f__c,
                                                  F2_Cost_ft_LE_Pull_Fiber_96f__c,
                                                  F2_Cost_ft_LE_Place_Conduit_4_c__c,
                                                  F2_Cost_ft_PlaceConduitPullFiber_4_c96f__c,
                                                  F2_Cost_ft_LE_Trench_4_c_96f__c,
                                                  F2_Cost_ft_LE_Bore_1_25_c_96f__c,
                                                  F2_Cost_ft_LE_Cobble_Bore_1_25_c_96f__c,
                                                  F2_Cost_ft_LE_Rock_Bore_1_25_c_96f__c,
                                                  F2_Eng_time_Cost_Over_200K_OVH__c,
                                                  F2_Eng_time_Cost_100K_200K_OVH__c,
                                                  F2_Eng_time_Cost_50K_100K_OVH__c,
                                                  F2_Eng_time_Cost_Under_50K_OVH__c,
                                                  F3_cost_ft_LE_Aerial_12f__c,
                                                  F3_cost_ft_LE_Bore_1_25_c_12f__c,
                                                  F3_cost_ft_LE_Buried_w_Conduit_12f__c,
                                                  F3_cost_ft_LE_Direct_Buried_12f__c,
                                                  F3_cost_ft_LE_Pull_Fiber_12f__c,
                                                  F3_Cost_LU_LE_Slack_box__c,
                                                   F3_Cost_Buried_Cost_LU__c,
                                                  F3_Cost_Greenfield_Retail_F3_Multiplier__c,
                                                  F3_Cost_Greenfield_CTL_ON_F3_Multiplier__c,
                                                  F3_Cost_Greenfield_Bulk_F3_Multiplier__c,
                                                  F3_Cost_Brownfield_Retail_F3_Multiplier__c,
                                                  F3_Cost_Brownfield_CTL_ON_F3_Multiplier__c,
                                                  F3_Cost_Brownfield_Bulk_F3_Multiplier__c,
                                                  IC_Stub6__c,
                                                  IC_Stub12__c,
                                                  IC_Stub24__c,
                                                  IC_Stub48__c,
                                                  IC_Stub60__c,
                                                  IC_Stub72__c,
                                                  IC_Handhole__c,
                                                  OC_General_Multiplier__c,
                                                  IC_Gateway_FTTB__c,
                                                  F3_Cost_Aerial_Cost_LU__c,
                                                  OC_RG_UPS_Media_Multiplier__c,
                                                  F4_Cottage_GF_CTL_Prov_Rugged_CTL_Inst__c,
                                                  IC_Gateway_FTTU__c,
                                                  OC_ONT_Multiplier__c,
                                                  IC_Panel__c,
                                                  IC_Gateway_FTTIDF__c,
                                                  IC_UPS_Shelf_Out__c,
                                                  IC_ONT__c,
                                                  IC_Splicing__c,
                                                  IC_FDH_In__c,
                                                  IC_FDH_Out__c,
                                                  IC_Ped__c,
                                                  IC_Splitter__c,
                                                  F2_Cost_ft_FW_Blended__c,
                                                  F2_Cost_ft_FW_Greenfield_F2_Multiplier__c,
                                                  F2_Cost_ft_FW_Brownfield_F2_Multiplier__c,
                                                  //F4_SFU_GF_CTL_Prov_Rugged_Dev_Inst__c,
                                                  F4_SFU_GF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                  F4_SFU_GF_CTL_Prov_Rugged_CTL_Inst__c,
                                                  F4_SFU_GF_CTL_Prov_Micro_CTL_Inst__c,
                                                  //F4_SFU_GF_CTL_Prov_Micro_Dev_Inst__c,
                                                  F4_SFU_GF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                  F4_SFU_GF_CTL_Prov_Duct_Dev_Inst__c,
                                                  //F4_Cottage_GF_CTL_Prov_Rugged_Dev_Inst__c,
                                                  F4_Cottage_GF_CTL_Prov_Rugged_Dev_Inst_N__c,
                                                  F4_MidR_GF_CTL_Prov_Duct_Dev_Inst__c,           
                                                  F4_MidR_GF_CTL_Prov_Fiber_CTL_Inst__c,
                                                  F4_MidR_GF_CTL_Prov_Micro_CTL_Inst__c,
                                                  //F4_MidR_GF_CTL_Prov_Micro_Dev_Inst__c,
                                                  F4_MidR_GF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                  F4_MidR_GF_CTL_Prov_Rugged_CTL_Inst__c,
                                                  //F4_MidR_GF_CTL_Prov_Rugged_Dev_Inst__c,
                                                  F4_MidR_GF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                  F4_HghR_GF_CTL_Prov_Duct_Dev_Inst__c,
                                                  F4_HghR_GF_CTL_Prov_Fiber_CTL_Inst__c,
                                                  F4_HghR_GF_CTL_Prov_Micro_CTL_Inst__c,
                                                  //F4_HghR_GF_CTL_Prov_Micro_Dev_Inst__c,
                                                  F4_HghR_GF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                  F4_HghR_GF_CTL_Prov_Rugged_CTL_Inst__c,
                                                  //F4_HghR_GF_CTL_Prov_Rugged_Dev_Inst__c,
                                                  F4_HghR_GF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                  F4_SFU_GF_CTL_Prov_Fiber_CTL_Inst__c,
                                                  F4_SFU_BF_CTL_Prov_Rugged_CTL_Inst__c,
                                                  //F4_SFU_BF_CTL_Prov_Rugged_Dev_Inst__c,
                                                  F4_SFU_BF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                  F4_SFU_BF_CTL_Prov_Micro_CTL_Inst__c,
                                                  //F4_SFU_BF_CTL_Prov_Micro_Dev_Inst__c,
                                                  F4_SFU_BF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                  F4_SFU_BF_CTL_Prov_Duct_Dev_Inst__c,
                                                  F4_SFU_BF_CTL_Prov_Fiber_CTL_Inst__c,
                                                  F4_Cottage_GF_CTL_Prov_Micro_CTL_Inst__c,
                                                  //F4_Cottage_GF_CTL_Prov_Micro_Dev_Inst__c,
                                                  F4_Cottage_GF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                  F4_Cottage_GF_CTL_Prov_Duct_Dev_Inst__c,
                                                  F4_Cottage_GF_CTL_Prov_Fiber_CTL_Inst__c,
                                                  F4_Cottage_BF_CTL_Prov_Rugged_CTL_Inst__c,
                                                  //F4_Cottage_BF_CTL_Prov_Rugged_Dev_Inst__c,
                                                  F4_Cottage_BF_CTL_Prov_Rugged_Dev_Inst_N__c,
                                                  F4_Cottage_BF_CTL_Prov_Micro_CTL_Inst__c,
                                                  //F4_Cottage_BF_CTL_Prov_Micro_Dev_Inst__c,
                                                  F4_Cottage_BF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                  F4_Cottage_BF_CTL_Prov_Duct_Dev_Inst__c,
                                                  F4_Cottage_BF_CTL_Prov_Fiber_CTL_Inst__c,
                                                  F4_MidR_BF_CTL_Prov_Rugged_CTL_Inst__c,
                                                  //F4_MidR_BF_CTL_Prov_Rugged_Dev_Inst__c,
                                                  F4_MidR_BF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                  F4_MidR_BF_CTL_Prov_Micro_CTL_Inst__c,
                                                  //F4_MidR_BF_CTL_Prov_Micro_Dev_Inst__c,
                                                  F4_MidR_BF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                  F4_MidR_BF_CTL_Prov_Duct_Dev_Inst__c,
                                                  F4_MidR_BF_CTL_Prov_Fiber_CTL_Inst__c,
                                                  F4_HghR_BF_CTL_Prov_Rugged_CTL_Inst__c,
                                                  //F4_HghR_BF_CTL_Prov_Rugged_Dev_Inst__c,
                                                  F4_HghR_BF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                  F4_HghR_BF_CTL_Prov_Micro_CTL_Inst__c,
                                                  //F4_HghR_BF_CTL_Prov_Micro_Dev_Inst__c,
                                                  F4_HghR_BF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                  F4_HghR_BF_CTL_Prov_Duct_Dev_Inst__c,
                                                  F4_HghR_BF_CTL_Prov_Fiber_CTL_Inst__c,
                                                  IC_UPS_shelf_In__c
                                                  FROM StatesCostforCapitalDesign__c ] ){
                                                      
                                                      stateDataMap.put(sc.Name,sc);    
                                                  }
           return stateDataMap;
       }
       /**
        * Description : This method will help to check the Field value is null or not null
        * Param output : number value 
        * Param Input : Number fieldValue
        **/
      public static Map<String,CCT_F2_Cost_Estimator__c> initializeF2CostEstimatorMap(){
            for(CCT_F2_Cost_Estimator__c ce : [SELECT Id, F2_CostE_Building_Type__c,
                                                      F2_CostE_Footage_Bld__c,F2_CostE_Footage_Flr__c,
                                                       FTTU__c, F2_CostE_FTTB__c, FTTIDF__c,
                                                       Material_Cost__c
                                                      FROM CCT_F2_Cost_Estimator__c]){
                                                          f2CostEstDataMap.put(ce.F2_CostE_Building_Type__c ,ce);               
                                                      } 
           return f2CostEstDataMap;
       }
       /**
        * Description : This method update the F2_Stub_Estimator object Map based on Adjusted Building Style(Cell K17)
        * Param output : Map<String,CCT_F2_Stub_Estimator__c>
        * Param Input : void
        **/
           public static Map<String,CCT_F2_Stub_Estimator__c> initializeF2StubEstimatorMap(){
                  for(CCT_F2_Stub_Estimator__c f2se : [SELECT F2_STUBE_Building_Style__c,
                                                       F2_STUBE_Building__c,
                                                       F2_STUBE_Floor__c,
                                                       F2_STUBE_FTTB__c,
                                                       F2_STUBE_FTTIDF__c,
                                                       F2_STUBE_FTTU__c FROM CCT_F2_Stub_Estimator__c]){
                                                       if(String.isNotBlank(f2se.F2_STUBE_Building_Style__c)){
                                                           f2StubEstBuildingStyleMap.put(f2se.F2_STUBE_Building_Style__c ,f2se);  
                                                       }
                     }  
           return f2StubEstBuildingStyleMap;
        }
   
   
         /**
        * Description : This method will update F2 FDH Indoor and Outdoor DataMap
        *  Param output : Map<Decimal,CCT_F2_FDH_Estimator__c>
        * Param Input : Void
        **/
       public static Map<Decimal,CCT_F2_FDH_Estimator__c> initializeF2FDHEstimatorMap(){
            for(CCT_F2_FDH_Estimator__c fdhe : [SELECT Id,F2_FDHE_Outdoor_FDH_Model__c,
                                                F2_FDHE_Outdoor_LU_FDH__c,
                                                F2_FDHE_Outdoor_Material_Cost__c,
                                                F2_FDHE_Indoor_FDH_Model__c,
                                                F2_FDHE_Indoor_LU_FDH__c,
                                                F2_FDHE_Indoor_Material_Cost__c 
                                                FROM CCT_F2_FDH_Estimator__c ORDER BY F2_FDHE_Indoor_LU_FDH__c,F2_FDHE_Outdoor_LU_FDH__c]){
                                            f2FDHEstIndoorMap.put(fdhe.F2_FDHE_Indoor_LU_FDH__c ,fdhe);
                                            f2FDHEstOutDoorMap.put(fdhe.F2_FDHE_Outdoor_LU_FDH__c ,fdhe); 
            }
           System.debug('f2FDHEstIndoorMap' + f2FDHEstIndoorMap);
           System.debug('f2FDHEstOutDoorMap' + f2FDHEstOutDoorMap);
           return f2FDHEstIndoorMap;
       }
       
       
        /**
        * Description : This method will update F2 FDH Outdoor DataMap
        *  Param output : Map<Decimal,CCT_F2_FDH_Estimator__c>
        * Param Input : Void
        **/
       /*public static Map<Decimal,CCT_F2_FDH_Estimator__c> initializeF2FDHEstimatorOutdoorMap(){
            for(CCT_F2_FDH_Estimator__c fdhe : [SELECT Id,F2_FDHE_Outdoor_FDH_Model__c,
                                                F2_FDHE_Outdoor_LU_FDH__c,
                                                F2_FDHE_Outdoor_Material_Cost__c
                                                FROM CCT_F2_FDH_Estimator__c]){
                                            f2FDHEstOutDoorMap.put(fdhe.F2_FDHE_Outdoor_LU_FDH__c ,fdhe);    
            }
           return f2FDHEstOutDoorMap;
       }*/
       
       
   
     /**
        * Description : This method will help to check the Field value is null or not null
        * Param output : number value 
        * Param Input : Number fieldValue
        **/
       public static Map<String,CCT_F1_Cost_Estimator__c> initializeF1CostEstimatorMap(){
           if(f1CostEstDataMap?.isEmpty()){
              for(CCT_F1_Cost_Estimator__c f1CostE : [SELECT F1_CostE_Density__c,
                                           F1_Handhole_Material_Cost__c,
                                           F1_Handhole_Spacing__c,
                                           F1_Handhole_Traffic_Control__c,
                                           F1_Handhole_Traffic_Permit__c,
                                           F1_Pole_Anchor_guy_Cost__c,
                                           F1_Pole_Make_ready_Cost__c,
                                           F1_Pole_Pole_Spacing__c,
                                           F1_Pole_Traffic_Control__c,
                                           F1_Pole_Traffic_Permit__c,
                                           F1_Splicing_Handhole_Spacing__c,
                                           F1_Splicing_Traffic_Control__c,
                                           F1_Splicing_Traffic_Permit__c,
                                           F1_Utility_Crossing_Pothole_restoration__c,
                                           F1_Utility_Crossing_Traffic_Control__c,
                                           F1_Utility_Crossing_Traffic_Permit__c,
                                           F1_Utility_Crossing_Utility_Spacing__c FROM CCT_F1_Cost_Estimator__c]){
                                        f1CostEstDataMap.put(f1CostE.F1_CostE_Density__c , f1CostE);   
    
              } 
    
           }
           return f1CostEstDataMap;
     }
       
       /**
        * Description : This method will help to check the Field value is null or not null
        * Param output : number value 
        * Param Input : Number fieldValue
        **/
       public static Map<String,CCT_ONT_UPS_Shelf_Estimator__c> initializeONTUPSShelfEstimatorMap(){
            for(CCT_ONT_UPS_Shelf_Estimator__c ontUPSShelfE : [SELECT Includes_Gateway__c,
                                                                       Indoor_Outdoor__c,
                                                                       LU_per_Shelf__c,
                                                                       LU_per_UPS__c,
                                                                       ONT_Cottage__c,
                                                                       ONT_Data_POTS__c,
                                                                       ONT_Description__c,
                                                                       ONT_Highrise__c,
                                                                       ONT_LU_per_ONT__c,
                                                                       ONT_MAT_Code__c,
                                                                       ONT_Material_Cost__c,
                                                                       ONT_Midrise__c,
                                                                       ONT_Model__c,
                                                                       ONT_Part__c,
                                                                       ONT_Per_LU__c,
                                                                       ONT_SFU__c,
                                                                       Shelf_Cost__c,
                                                                       UPS_Model__c,
                                                                       UPS_Cost__c,
                                                                       UPS_Shelf_Cottage__c,
                                                                       UPS_Shelf_Highrise__c,
                                                                       UPS_Shelf_Midrise__c,
                                                                       UPS_Shelf_Per_LU__c,
                                                                       UPS_Shelf_SFU__c
                                                      FROM CCT_ONT_UPS_Shelf_Estimator__c]){
                                                          ontUPSShelfEstDataMap.put(ontUPSShelfE.ONT_Model__c , ontUPSShelfE);               
                                                      } 
           return ontUPSShelfEstDataMap;
       }
       
        /**
        * Description : Load Cost estimator data into map to cache the cost setup data
        * Param output : number value 
        * Param Input : Number fieldValue
        **/
      public static  Map<String,CCT_Cost_Estimator__c> initializeCostEstimatorMap(){
          if(costEstDataMap?.isEmpty()){
               for(CCT_Cost_Estimator__c coste : [SELECT ISP_Estimator_OLT_Model__c,
                                                       ISPE_Str_shelf_Qpd_21_of_21_PON_cards__c,
                                                       ISP_Estimator_LU_per_starter_shelf__c,
                                                       ISP_Estimator_Max_LU_per_loaded_shelf__c,
                                                       ISPE_Efficiency_due_to_field_condition__c,
                                                       ISP_Estimator_Usable_LU_per_loaded_shelf__c,
                                                       ISP_Estimator_Cost_per_LU__c,
                                                       ISP_Estimator_OLT_ports__c,
                                                       ISP_Estimator_Cost_per_OLT_port__c,
                                                       F1_Crossings__c,
                                                       F1_Crossing_Each_Lane_Width_ft__c,
                                                       F1_Crossing_Each_side_WkSp_Clrce_ft__c,
                                                       F2_Splitter_Model__c,
                                                       F2_Splitter_LU_splitter__c,
                                                       F2_Splitter_Interior_Material_Cost__c,
                                                       F2_Splitter_Exterior_Material_Cost__c,
                                                       RG_Cost_Model__c,
                                                       RG_Cost_LU_per_RG__c,
                                                       RG_Cost_Material_Cost__c,
                                                       RG_Cost_SFU__c,
                                                       RG_Cost_MDU__c,
                                                       RG_Cost_MAT_code__c,
                                                       RG_Cost_Part__c,
                                                       RG_Cost_Description__c,
                                                       Media_Cost_MAT_code__c,
                                                       Media_Cost_Mat_Desc__c,
                                                       Media_Cost_LU__c,
                                                       Media_Cost_Material_Cost__c,
                                                      State__c,
                                                      F2_Ped_Est_Material_Cost__c,
                                                      F2_Ped_Est_Cottage_bld_Ped__c,
                                                      F2_Ped_Est_SFU_LU_Ped__c
                                                  FROM CCT_Cost_Estimator__c]){
                costEstDataMap.put(coste.ISP_Estimator_OLT_Model__c, coste);
                costEstDataMapByState.put(coste.State__c, coste);
                //getSpltrEstimatorDataMap.put(coste.F2_Splitter_LU_splitter__c,coste);
            } 
          }
           return costEstDataMap;
       }
       
       
       /**
        * Description : Load Cost estimator data into map to Splitter Estimator
        * Param output : Map<Decimal,CCT_Cost_Estimator__c> value 
        **/
      public static Map<Decimal,CCT_Cost_Estimator__c> initializeCostEstimatorDataForSplitter(){
              for(CCT_Cost_Estimator__c coste : [SELECT Id,
                                              Name,
                                              F2_Splitter_Model__c,
                                                       F2_Splitter_LU_splitter__c,
                                                       F2_Splitter_Interior_Material_Cost__c,
                                                       F2_Splitter_Exterior_Material_Cost__c
                                                  FROM CCT_Cost_Estimator__c]){
                getSpltrEstimatorDataMap.put(coste.F2_Splitter_LU_splitter__c,coste);
            } 
          System.debug('getSpltrEstimatorDataMap'+getSpltrEstimatorDataMap.get(32.00000));
           return getSpltrEstimatorDataMap;
       }
       
       
        /**
        * Description : Load Cost estimator data into map to cache the cost setup data based on RGCost SFU
        * Param output : List<CCT_Cost_Estimator__c> value 
        **/
      public static  List<CCT_Cost_Estimator__c> initializeCostEstimatorDataForSFU(){
          if(costEstDataListBySFU?.isEmpty()){
              costEstDataListBySFU = [SELECT RG_Cost_Model__c,
                                                       RG_Cost_LU_per_RG__c,
                                                       RG_Cost_Material_Cost__c,
                                                       RG_Cost_SFU__c,
                                                       RG_Cost_MDU__c,
                                                       RG_Cost_MAT_code__c,
                                                       RG_Cost_Part__c,
                                                       RG_Cost_Description__c            
                                                  FROM CCT_Cost_Estimator__c 
                                                     WHERE RG_Cost_SFU__c =: CDConstants.Y
                                                        OR RG_Cost_SFU__c =: CDConstants.YES];
          }
           return costEstDataListBySFU;
       }
       
        /**
        * Description : Load Cost estimator data into map to cache the cost setup data based on RGCost MDU
        * Param output : List<CCT_Cost_Estimator__c> value 
        **/
      public static  List<CCT_Cost_Estimator__c> initializeCostEstimatorDataForMDU(){
          if(costEstDataListByMDU?.isEmpty()){
               costEstDataListByMDU = [SELECT RG_Cost_Model__c,
                                                       RG_Cost_LU_per_RG__c,
                                                       RG_Cost_Material_Cost__c,
                                                       RG_Cost_SFU__c,
                                                       RG_Cost_MDU__c,
                                                       RG_Cost_MAT_code__c,
                                                       RG_Cost_Part__c,
                                                       RG_Cost_Description__c             
                                                  FROM CCT_Cost_Estimator__c 
                                                     WHERE RG_Cost_MDU__c =: CDConstants.Y
                                                     OR RG_Cost_MDU__c =: CDConstants.YES];
          }
           return costEstDataListByMDU;
       }
      
       
        /**
        * Description : This method will help to check the Field value is null or not null
        * Param output : number value 
        * Param Input : Number fieldValue
        **/
            public static StatesCostforCapitalDesign__c getStateCostObject(String stateName, String stateCode){
                System.debug('(getStateCostObject) stateName = ' + stateName + '  AND stateDataMap.isEmpty() ? ' + stateDataMap.isEmpty());
                if(String.isNotBlank(stateName) || String.isNotBlank(stateCode)) {
                    if (!stateDataMap.isEmpty()) {
                        StatesCostforCapitalDesign__c stateCostObj = stateDataMap.get(stateName);
                        if (stateCostObj != null) { 
                            System.debug('(getStateCostObject) Returning existing stateDataMap for stateName = ' + stateName);
                            return stateCostObj;
                        }
                        stateCostObj = stateDataMap.get(stateCode);
                        System.debug('(getStateCostObject) Returning existing stateDataMap for stateCode = ' + stateCode);
                        return stateCostObj;
	                } else {
                       System.debug('(getStateCostObject) Returning fresh query for stateName = ' + stateName + ' OR for stateCode = ' + stateCode);
                       List<StatesCostforCapitalDesign__c> stateCostList = new List<StatesCostforCapitalDesign__c>();
                       stateCostList = [SELECT Id, Name, F1_Cost_ft_LE_Use_Existing_Spare__c,
                                                      F1_Cost_ft_LE_Use_Vacant_12f__c,
                                                      F1_Cost_ft_LE_Plow_2_c_48f__c,
                                                      F1_Cost_ft_LE_Aerial_10M_144f__c,
                                                      F1_Cost_ft_LE_Overpull_1_25_c_864f__c,
                                                      F1_Cst_ft_BackbonBore_1_25_c_3_in4_c864__c,
                                                      F1_Cost_ft_LE_Cobble_Bore_1_25_c_864f__c,
                                                      F1_Cst_ft_Cobble_Bore_1_25_c_in_4_c_864__c,
                                                      F1_Cost_ft_LE_Direct_Buried_96f__c,
                                                      F1_Cost_ft_LE_Lateral_Bore_1_25_c_864f__c,
                                                      F1_Cost_ft_LE_Rock_Bore_1_25_c_864f__c,
                                                      F1_Cst_ft_Rock_Bore_1_25_c_in_4_c_864f__c,
                                                      F2_Cost_ft_LE_Direct_Buried_96f__c,
                                                      F2_Cost_ft_LE_Aerial_10M_144f__c,
                                                      F2_Cost_ft_LE_Pull_Fiber_96f__c,
                                                      F2_Cost_ft_LE_Place_Conduit_4_c__c,
                                                      F2_Cost_ft_PlaceConduitPullFiber_4_c96f__c,
                                                      F2_Cost_ft_LE_Trench_4_c_96f__c,
                                                      F2_Cost_ft_LE_Bore_1_25_c_96f__c,
                                                      F2_Cost_ft_LE_Cobble_Bore_1_25_c_96f__c,
                                                      F2_Cost_ft_LE_Rock_Bore_1_25_c_96f__c,
                                                      F3_cost_ft_LE_Aerial_12f__c,
                                                      F3_cost_ft_LE_Bore_1_25_c_12f__c,
                                                      F3_cost_ft_LE_Buried_w_Conduit_12f__c,
                                                      F3_cost_ft_LE_Direct_Buried_12f__c,
                                                      F3_cost_ft_LE_Pull_Fiber_12f__c,
                                                      F3_Cost_LU_LE_Slack_box__c,
                                                      F3_Cost_Buried_Cost_LU__c,
                                                      F3_Cost_Greenfield_Retail_F3_Multiplier__c,
                                                      F3_Cost_Greenfield_CTL_ON_F3_Multiplier__c,
                                                      F3_Cost_Greenfield_Bulk_F3_Multiplier__c,
                                                      F3_Cost_Brownfield_Retail_F3_Multiplier__c,
                                                      F3_Cost_Brownfield_CTL_ON_F3_Multiplier__c,
                                                      F3_Cost_Brownfield_Bulk_F3_Multiplier__c,
                                                      IC_Stub6__c,
                                                      IC_Stub12__c,
                                                      IC_Stub24__c,
                                                      IC_Stub48__c,
                                                      IC_Stub60__c,
                                                      IC_Stub72__c,
                                                      OC_General_Multiplier__c,
                                                      IC_Gateway_FTTB__c,
                                                      F3_Cost_Aerial_Cost_LU__c,
                                                      OC_RG_UPS_Media_Multiplier__c,
                                                      F4_Cottage_GF_CTL_Prov_Rugged_CTL_Inst__c,
                                                      F4_Cottage_GF_CTL_Prov_Duct_Dev_Inst__c,
                                                      IC_Gateway_FTTU__c,
                                                      OC_ONT_Multiplier__c,
                                                      IC_Panel__c,
                                                      IC_Gateway_FTTIDF__c,
                                                      IC_UPS_Shelf_Out__c,
                                                      IC_ONT__c,
                                                      //F4_SFU_GF_CTL_Prov_Rugged_Dev_Inst__c,
                                                      F4_SFU_GF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                      F4_SFU_GF_CTL_Prov_Rugged_CTL_Inst__c,
                                                      F4_SFU_GF_CTL_Prov_Micro_CTL_Inst__c,
                                                      //F4_SFU_GF_CTL_Prov_Micro_Dev_Inst__c,
                                                      F4_SFU_GF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                      F4_SFU_GF_CTL_Prov_Duct_Dev_Inst__c,
                                                      //F4_Cottage_GF_CTL_Prov_Rugged_Dev_Inst__c,
                                                      F4_Cottage_GF_CTL_Prov_Rugged_Dev_Inst_N__c,
                                                      F4_MidR_GF_CTL_Prov_Duct_Dev_Inst__c,
                                                      F4_MidR_GF_CTL_Prov_Fiber_CTL_Inst__c,
                                                      F4_MidR_GF_CTL_Prov_Micro_CTL_Inst__c,
                                                      //F4_MidR_GF_CTL_Prov_Micro_Dev_Inst__c,
                                                      F4_MidR_GF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                      F4_MidR_GF_CTL_Prov_Rugged_CTL_Inst__c,
                                                      //F4_MidR_GF_CTL_Prov_Rugged_Dev_Inst__c,
                                                      F4_MidR_GF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                      F4_HghR_GF_CTL_Prov_Duct_Dev_Inst__c,
                                                      F4_HghR_GF_CTL_Prov_Fiber_CTL_Inst__c,
                                                      F4_HghR_GF_CTL_Prov_Micro_CTL_Inst__c,
                                                      //F4_HghR_GF_CTL_Prov_Micro_Dev_Inst__c,
                                                      F4_HghR_GF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                      F4_HghR_GF_CTL_Prov_Rugged_CTL_Inst__c,
                                                      //F4_HghR_GF_CTL_Prov_Rugged_Dev_Inst__c,
                                                      F4_HghR_GF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                      F4_SFU_GF_CTL_Prov_Fiber_CTL_Inst__c,
                                                      F4_SFU_BF_CTL_Prov_Rugged_CTL_Inst__c,
                                                      //F4_SFU_BF_CTL_Prov_Rugged_Dev_Inst__c,
                                                      F4_SFU_BF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                      F4_SFU_BF_CTL_Prov_Micro_CTL_Inst__c,
                                                      //F4_SFU_BF_CTL_Prov_Micro_Dev_Inst__c,
                                                      F4_SFU_BF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                      F4_SFU_BF_CTL_Prov_Duct_Dev_Inst__c,
                                                      F4_SFU_BF_CTL_Prov_Fiber_CTL_Inst__c,
                                                      F4_Cottage_GF_CTL_Prov_Micro_CTL_Inst__c,
                                                      //F4_Cottage_GF_CTL_Prov_Micro_Dev_Inst__c,
                                                      F4_Cottage_GF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                      F4_Cottage_GF_CTL_Prov_Fiber_CTL_Inst__c,
                                                      F4_Cottage_BF_CTL_Prov_Rugged_CTL_Inst__c,
                                                      //F4_Cottage_BF_CTL_Prov_Rugged_Dev_Inst__c,
                                                      F4_Cottage_BF_CTL_Prov_Rugged_Dev_Inst_N__c,
                                                      F4_Cottage_BF_CTL_Prov_Micro_CTL_Inst__c,
                                                      //F4_Cottage_BF_CTL_Prov_Micro_Dev_Inst__c,
                                                      F4_Cottage_BF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                      F4_Cottage_BF_CTL_Prov_Duct_Dev_Inst__c,
                                                      F4_Cottage_BF_CTL_Prov_Fiber_CTL_Inst__c,
                                                      F4_MidR_BF_CTL_Prov_Rugged_CTL_Inst__c,
                                                      //F4_MidR_BF_CTL_Prov_Rugged_Dev_Inst__c,
                                                      F4_MidR_BF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                      F4_MidR_BF_CTL_Prov_Micro_CTL_Inst__c,
                                                      //F4_MidR_BF_CTL_Prov_Micro_Dev_Inst__c,
                                                      F4_MidR_BF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                      F4_MidR_BF_CTL_Prov_Duct_Dev_Inst__c,
                                                      F4_MidR_BF_CTL_Prov_Fiber_CTL_Inst__c,
                                                      F4_HghR_BF_CTL_Prov_Rugged_CTL_Inst__c,
                                                      //F4_HghR_BF_CTL_Prov_Rugged_Dev_Inst__c,
                                                      F4_HghR_BF_CTL_Prov_Rugged_Dev_Inst_No__c,
                                                      F4_HghR_BF_CTL_Prov_Micro_CTL_Inst__c,
                                                      //F4_HghR_BF_CTL_Prov_Micro_Dev_Inst__c,
                                                      F4_HghR_BF_CTL_Prov_Micro_Dev_Inst_No__c,
                                                      F4_HghR_BF_CTL_Prov_Duct_Dev_Inst__c,
                                                      F4_HghR_BF_CTL_Prov_Fiber_CTL_Inst__c,
                                                      IC_UPS_shelf_In__c,
                                                      F2_Cost_ft_FW_Blended__c 
                                                      FROM StatesCostforCapitalDesign__c Where Name = :stateName OR Name = :stateCode ];
                        System.debug('(getStateCostObject) stateCostList is NULL? ' + (stateCostList==null) + '  AND stateCostList.size() = ' + stateCostList.size());
                        if (stateCostList != null && stateCostList.size() > 0) {
                            return stateCostList.get(0);
                        }
                        System.debug('(getStateCostObject) stateCostList was NULL or contained 0 records, thus returning NULL');
                        return null;
                    }//end else stateDataMap was EMPTY
                }//end if VALID stateName or stateCode
                System.debug('(getStateCostObject) Neither stateName NOR stateCode were VALID, thus returning NULL');
                return null;
            }//end method getStateCostObject
           
        /**
        * Description : This method return the F2_Stub_Estimator object based on subUnit
        * Param output : List<CCT_F2_Stub_Estimator__c> value 
        * Param Input :Integer subUnit
        **/
        public static List<CCT_F2_Stub_Estimator__c> getF2StubEstBySubUnit(decimal subUnit){
             return [ SELECT id , 
                     F2_STUBE_Material_Cost__c, 
                     F2_STUBE_Stub_Size__c  
                     FROM CCT_F2_Stub_Estimator__c 
                     where F2_STUBE_Material_Stub_Size__c =:subUnit ];
        }
       
         /**
        * Description : This method will return CC_Cost_Estimator__c based 'Mat Desc' from Cost_Estimator__c table
        * Param Input : String value 
        * Param Output : CCT_Cost_Estimator__c
        **/
        public static CCT_Cost_Estimator__c getCostEstimatorByMatDesc(string matDesc){
            CCT_Cost_Estimator__c costEst = null;
            if(String.isNotBlank(matDesc)){
              List<CCT_Cost_Estimator__c> costEstList = [SELECT Id, Media_Cost_Material_Cost__c FROM CCT_Cost_Estimator__c
                                                              WHERE Media_Cost_Mat_Desc__c =:matDesc];
                if(costEstList != null && costEstList.size() > 0){
                    costEst = costEstList[0];
                }
             }
   
            return costEst;
        }
       
         /**  QFCJ-4469 SmartNID RG Cost -- TCabato 08/31/2023
        * Description : This method will return CC_Cost_Estimator__c based 'RG Cost Model' from Cost_Estimator__c table
        * Param Input : String value 
        * Param Output : CCT_Cost_Estimator__c
        **/
        public static CCT_Cost_Estimator__c getCostEstimatorByRGCostModel(string rgCostModel){
            CCT_Cost_Estimator__c costEst = null;
            if(String.isNotBlank(rgCostModel)){
              List<CCT_Cost_Estimator__c> costEstList = [SELECT Id, RG_Cost_Model__c,
                                                                 RG_Cost_LU_per_RG__c,
                                                                 RG_Cost_Material_Cost__c,
                                                                 RG_Cost_SFU__c,
                                                                 RG_Cost_MDU__c,
                                                                 RG_Cost_MAT_code__c,
                                                                 RG_Cost_Part__c,
                                                                 RG_Cost_Description__c 
                                                           FROM CCT_Cost_Estimator__c
                                                          WHERE RG_Cost_Model__c = :rgCostModel];
                if(costEstList != null && costEstList.size() > 0){
                    costEst = costEstList[0];
                }
             }
   
            return costEst;
        }//end method getCostEstimatorByRGCostModel

}//end class CapitalDesignCalculationHelper