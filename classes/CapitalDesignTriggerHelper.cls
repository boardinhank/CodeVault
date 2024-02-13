/******************************************************************************************************************* 
* @uthor : Lumen.com
* @Class : CapitalDesignTriggerHelper
* @ Descriptions : ESCJ-407, ESCJ-415 ,ESCJ-485 , ESCJ-557 F1 & F2 SECTION
					ESCJ-416, ESCJ-505 F3 & F4 SECTION
* 					Helper class for calculating formulas for F1,F2 and F3 section for Trigger CapitalDesignTrigger
****************************************************************** 
Author    *          UserStory   *    Date         *       Description 
Ganesh Sirpuram       ESCJ-558        07/03/2022           F1 Output calculations 
===============================================================================================
 * Date         Author      UserStory          Description  
 * 08/02/2023   T2Cabato    QFCJ-4286          BRAIN-Drop-Cost-Fix                   
 * 09/22/2023   T2Cabato    QFCJ-4580          Round CCT cost fields results to 2 decimals 
 * 10/17/2023   T2Cabato    QFCJ-4683          CCT Rounding Integers using HALF_UP except for Splitter Sub-cost Unit  
 ***********************************************************************************************/
global class CapitalDesignTriggerHelper { 
    global static Map<String,StatesCostforCapitalDesign__c> stateDataMap = CapitalDesignCalculationHelper.stateDataMap != NULL && !CapitalDesignCalculationHelper.stateDataMap.isEmpty() ?
    CapitalDesignCalculationHelper.stateDataMap : CapitalDesignCalculationHelper.initializeStateCostMap(); 
    global static  Map<String,CCT_F2_Cost_Estimator__c> f2CostEstDataMap = CapitalDesignCalculationHelper.f2CostEstDataMap != NULL && !CapitalDesignCalculationHelper.f2CostEstDataMap.isEmpty() ?
    CapitalDesignCalculationHelper.f2CostEstDataMap : CapitalDesignCalculationHelper.initializeF2CostEstimatorMap();
    global static Map<String,CCT_Cost_Estimator__c> costEstDataMap = CapitalDesignCalculationHelper.initializeCostEstimatorMap();
    global static Map<String,CCT_F1_Cost_Estimator__c> f1CostEstDataMap = CapitalDesignCalculationHelper.initializeF1CostEstimatorMap();
    global static Map<Decimal,CCT_F2_FDH_Estimator__c> f2FDHEstIndoorMap = CapitalDesignCalculationHelper.f2FDHEstIndoorMap != NULL && !CapitalDesignCalculationHelper.f2FDHEstIndoorMap.isEmpty() ?
    CapitalDesignCalculationHelper.f2FDHEstIndoorMap : CapitalDesignCalculationHelper.initializeF2FDHEstimatorMap();
    global static Map<Decimal,CCT_F2_FDH_Estimator__c> f2FDHEstOutDoorMap = CapitalDesignCalculationHelper.f2FDHEstOutDoorMap != NULL && !CapitalDesignCalculationHelper.f2FDHEstOutDoorMap.isEmpty() ?
    CapitalDesignCalculationHelper.f2FDHEstOutDoorMap : CapitalDesignCalculationHelper.initializeF2FDHEstimatorMap();
    global static Map<String,CCT_Cost_Estimator__c> costEstDataMapByState = CapitalDesignCalculationHelper.costEstDataMapByState != NULL && !CapitalDesignCalculationHelper.costEstDataMapByState.isEmpty() ?
    CapitalDesignCalculationHelper.costEstDataMapByState : CapitalDesignCalculationHelper.initializeCostEstimatorMap();
    global static Map<Decimal,CCT_Cost_Estimator__c> getSpltrEstimatorDataMap = CapitalDesignCalculationHelper.getSpltrEstimatorDataMap != NULL && !CapitalDesignCalculationHelper.getSpltrEstimatorDataMap.isEmpty() ?
    CapitalDesignCalculationHelper.getSpltrEstimatorDataMap : CapitalDesignCalculationHelper.initializeCostEstimatorDataForSplitter();
    global static Map<String,CCT_F2_Stub_Estimator__c> f2StubEstBuildingStyleMap = CapitalDesignCalculationHelper.f2StubEstBuildingStyleMap != NULL && !CapitalDesignCalculationHelper.f2StubEstBuildingStyleMap.isEmpty() ?
    CapitalDesignCalculationHelper.f2StubEstBuildingStyleMap : CapitalDesignCalculationHelper.initializeF2StubEstimatorMap();
    
    public static Double tempMobilizationF1 = 0;
    public static sObject forOldValuesOfCapitalDesign;
    public static sObject forNewValuesOfCapitalDesign;
    public static Double calculateRelCostF2VarOne = 0;
    public static Double tempCostCalVariable = 0; 
    public static Double calculateCostValues = 0;
    public static Double tempvariablef3 = 0;
   /******************************************************************************************************************* 
     * @Developer : Ami Parekh
     * @Method : doCapitalCalculations
     * @params : Input parameter Capital_Design__c obect's field
     * @ Descriptions : ESCJ-407, ESCJ-415, ESCJ-485 , ESCJ-557
     * 					For calling all the apex methods in Handler
     * *****************************************************************************************************************/ 
     public static void doCapitalCalculations(List<Capital_Design__c> capitalDesigns){
         try{
             for(Capital_Design__c cd : capitalDesigns){ 
                cd.State_Name__c = cd.Property_Address_State__c;
                 cd.Text_Capital_Design_Name__c = cd.Name;
                 cd.Num_F1_Cost_for_Aerial_10M_144f__c = cd.F1_Cost_for_Aerial_10M_144f__c;
                 cd.NumF1_Cost_CobbleBore_1_25_c_in_4_c_864f__c = cd.F1_Cost_CobbleBore_1_25_c_in_4_c_864f__c;
                 cd.Num_F1_Cost_for_Blended_Cost_from_FW_c__c = cd.F1_Cost_for_Blended_Cost_from_FW__c;
                 cd.Num_F1_Cost_for_Cobble_Bore_1_25_c_864f__c = cd.F1_Cost_for_Cobble_Bore_1_25_c_864f__c;
                 cd.Num_F1_Cost_for_Custom_without_conduit__c = cd.F1_Cost_for_Custom_without_conduit__c;
                 cd.Num_F1_Cost_for_Direct_Buried_96f__c = cd.F1_Cost_for_Direct_Buried_96f__c;
                 cd.Num_F1_Cost_for_Lateral_Bore_1_25_c_864f__c = cd.F1_Cost_for_Lateral_Bore_1_25_c_864f__c;
                 cd.Num_F1_Cost_for_Plow_2_c_48f__c = cd.F1_Cost_for_Plow_2_c_48f__c;
                 cd.Num_F1_Cost_for_Overpull_1_25_c_864f__c = cd.F1_Cost_for_Overpull_1_25_c_864f__c;
                 cd.Num_F1_Cost_for_Rock_Bore_1_25_c_864f__c = cd.F1_Cost_for_Rock_Bore_1_25_c_864f__c;
                 cd.NumF1_Cost_for_RockBore1_25_c_in_4_c_864__c = cd.F1_Cost_for_RockBore1_25_c_in_4_c_864__c;
                 cd.Num_F1_Cost_for_Use_Existing_Spare__c = cd.F1_Cost_for_Use_Existing_Spare__c;
                 cd.Num_F1_Cost_for_Use_Vacant_12f__c = cd.F1_Cost_for_Use_Vacant_12f__c;
                 cd.NuF1_CostBackboneBore_1_25_c_3_i_4_c864f__c = cd.F1_CostBackboneBore_1_25_c_3_i_4_c864f__c;
                 cd.Num_F1CostforTrench_Custom_with_conduit__c = cd.F1CostforTrench_Custom_with_conduit__c;
                 cd.Num_F1_Fiber_And_Conduit_Sub_Total__c = cd.F1_Fiber_And_Conduit_Sub_Total__c;
                 cd.NuF1_Footage_CobbleBore1_25_c_in_4_c_864__c = cd.F1_Footage_Cobble_Bore_1_25_c_in_4_c_864__c;
                 cd.Num_F1_Footage_for_Aerial_10M_144f__c = cd.F1_Footage_for_Aerial_10M_144f__c;
                 cd.Num_F1_Footage_for_Blended_Cost_from_FW__c = cd.F1_Footage_for_Blended_Cost_from_FW__c;
                 cd.NuF1_Footage_for_Cobble_Bore_1_25_c_864f__c = cd.F1_Footage_for_Cobble_Bore_1_25_c_864f__c;
                 cd.NuF1_Footage_for_Custom_without_conduit__c = cd.F1_Footage_for_Custom_without_conduit__c;
                 cd.Num_F1_Footage_for_Direct_Buried_96f__c = cd.F1_Footage_for_Direct_Buried_96f__c;
                 cd.NuF1_Footage_for_Lateral_Bore1_25_c_864f__c = cd.F1_Footage_for_Lateral_Bore_1_25_c_864f__c;
                 cd.Num_F1_Footage_for_Overpull_1_25_c_864f__c = cd.F1_Footage_for_Overpull_1_25_c_864f__c;
                 cd.Num_F1_Footage_for_Plow_2_c_48f__c = cd.F1_Footage_for_Plow_2_c_48f__c;
                 cd.Num_F1_Footage_for_Rock_Bore_1_25_c_864f__c = cd.F1_Footage_for_Rock_Bore_1_25_c_864f__c;
                 cd.NuF1_Footage_for_RockBore1_25_cin4_c_864__c = cd.F1_Footage_for_RockBore1_25_c_in_4_c_864__c;
                 cd.Num_F1_Footage_for_Use_Existing_Spare__c = cd.F1_Footage_for_Use_Existing_Spare__c;
                 cd.Num_F1_Footage_for_Use_Vacant_12f__c = cd.F1_Footage_for_Use_Vacant_12f__c;
                 cd.NuF1FootageBackbonBore1_25_c_3_in4_c864f__c = cd.F1FootageBackbonBore_1_25_c_3_in4_c864f__c;
                 cd.Num_F1FootageTrench_Custom_with_conduit__c = cd.F1FootageTrench_Custom_with_conduit__c;
                 cd.Num_F2_Cost_for_Aerial_10M_144f__c = cd.F2_Cost_for_Aerial_10M_144f__c;
                 cd.Num_F2_Cost_for_Bore_1_25_c_96f__c = cd.F2_Cost_for_Bore_1_25_c_96f__c;
                 cd.Num_F2_Cost_for_Cobble_Bore_1_25_c_96f__c = cd.F2_Cost_for_Cobble_Bore_1_25_c_96f__c;
                 cd.Num_F2_Cost_for_Custom_without_conduit__c = cd.F2_Cost_for_Custom_without_conduit__c;
                 cd.Num_F2_Cost_for_Direct_Buried_96f__c = cd.F2_Cost_for_Direct_Buried_96f__c;
                 cd.Num_F2_Cost_for_Place_Conduit_4_c__c = cd.F2_Cost_for_Place_Conduit_4_c__c;
                 cd.Num_F2_Cost_for_Pull_Fiber_96f__c = cd.F2_Cost_for_Pull_Fiber_96f__c;
                 cd.Num_F2_Cost_for_Rock_Bore_1_25_c_96f__c = cd.F2_Cost_for_Rock_Bore_1_25_c_96f__c;
                 cd.Num_F2_Cost_for_Trench_4_c_96f__c = cd.F2_Cost_for_Trench_4_c_96f__c;
                 cd.NuF2_CostJoint_Trench_Custom_withconduit__c = cd.F2_Cost_Joint_Trench_Custom_withconduit__c;
                 cd.Num_F2_CostPlaceConduitPull_Fiber_4_c96f__c = cd.F2_CostPlaceConduitPull_Fiber_4_c96f__c;
                 cd.NuF2_Fiber_Conduit_Placement_Sub_Total__c = cd.F2_Fiber_Conduit_Placement_Sub_Total__c;
                 cd.Num_F3_Cost_for_Aerial_12f__c = cd.F3_Cost_for_Aerial_12f__c;
                 cd.Num_F3_Cost_for_Bore_1_25_c_12f__c = cd.F3_Cost_for_Bore_1_25_c_12f__c;
                 cd.Num_F3_Cost_for_Buried_w_Conduit_12f__c = cd.F3_Cost_for_Buried_w_Conduit_12f__c;
                 cd.Num_F3_Cost_for_Direct_Buried_12f__c = cd.F3_Cost_for_Direct_Buried_12f__c;
                 cd.Num_F3_Cost_for_Joint_Trench_Custom__c = cd.F3_Cost_for_Joint_Trench_Custom__c;
                 cd.Num_F3_Cost_for_Pull_Fiber_12f__c = cd.F3_Cost_for_Pull_Fiber_12f__c;
                 cd.Num_F3_Footage_For_Aerial_12f__c = cd.F3_Footage_For_Aerial_12f__c;
                 cd.Num_F3_Footage_For_Bore_1_25_c_12f__c = cd.F3_Footage_For_Bore_1_25_c_12f__c;
                 cd.Num_F3_Footage_For_Buried_w_Conduit_12f__c = cd.F3_Footage_For_Buried_w_Conduit_12f__c;
                 cd.Num_F3_Footage_for_Direct_Buried_12f__c = cd.F3_Footage_for_Direct_Buried_12f__c;
                 cd.Num_F3_Footage_For_Joint_Trench_Custom__c = cd.F3_Footage_For_Joint_Trench_Custom__c;
                 cd.Num_F3_Footage_For_Pull_Fiber_12f__c = cd.F3_Footage_For_Pull_Fiber_12f__c;
                 cd.Num_F3_Footage_for_Subtotal__c = cd.F3_Footage_for_Sub_total__c;
                 cd.Num_F3_Sub_total__c = cd.F3_Sub_total__c; 
                 if(cd.F2_FDH_size__c!=null){
                     cd.F2_FDH_Size_Num__c=decimal.valueof(cd.F2_FDH_size__c);
                 } else{
                     cd.F2_FDH_Size_Num__c = 0;
                 }  
             forOldValuesOfCapitalDesign = Trigger.oldMap.get(cd.ID);  
             forNewValuesOfCapitalDesign = Trigger.newMap.get(cd.Id);
		     footageForF2(cd);
             performCalculationforCostFtF1andF2(cd); 
             subTotalofFootageforF1(cd);
             subTotalofCostforF1(cd);
             subTotalofCostftforF1(cd);
             calculationforF1RelatedSubTotal(cd); 
             subTotalofFootageforF2(cd);
             performCalculationforCostFtF3(cd);
             calculationforF3RelatedSubTotal(cd);
             subTotalofCostforF3(cd);
             subTotalofCostftforF3(cd);
             doF1OutputCalculations(cd);
             CapitalDesignF2OutputCalculation.doF2OutputCalculations(cd,forOldValuesOfCapitalDesign,forNewValuesOfCapitalDesign); 
             subTotalofF2RelatedCost(cd);    
         } 
         }Catch(Exception ex){
             system.debug('ex line no.---> '+ex.getLineNumber());
         }
         
    }
    
	 /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : performCalculationforCostFtF1andF2
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions : For Cost/ft field values in F1 and F2 section based on States from StateCostTable
     ******************************************************************************************************************/ 
    public static void performCalculationforCostFtF1andF2(Capital_Design__c cd){
        
            if((String.isNotBlank(cd.Property_Address_State__c) && stateDataMap?.containsKey(cd?.Property_Address_State__c)) || (String.isNotBlank(cd.Primary_Address_State_Name__c) && stateDataMap?.containsKey(cd?.Primary_Address_State_Name__c))) {
                StatesCostforCapitalDesign__c stateCDObj = stateDataMap?.get(cd.Property_Address_State__c);
                if (stateCDObj == null) stateCDObj = stateDataMap?.get(cd.Primary_Address_State_Name__c);
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_for_Aerial_10M_144f__c, stateCDObj.F1_Cost_ft_LE_Aerial_10M_144f__c)){
                        cd.F1_Cost_ft_for_Aerial_10M_144f__c = stateCDObj.F1_Cost_ft_LE_Aerial_10M_144f__c ;
                    }
                	if(isFieldValueNullOrZero(cd.F1_Cost_ft_for_Use_Existing_Spare__c, stateCDObj.F1_Cost_ft_LE_Use_Existing_Spare__c)){
                        cd.F1_Cost_ft_for_Use_Existing_Spare__c = stateCDObj.F1_Cost_ft_LE_Use_Existing_Spare__c ;
                    }
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_for_Use_Vacant_12f__c, stateCDObj.F1_Cost_ft_LE_Use_Vacant_12f__c)){
                        cd.F1_Cost_ft_for_Use_Vacant_12f__c = stateCDObj.F1_Cost_ft_LE_Use_Vacant_12f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_for_Plow_2_c_48f__c, stateCDObj.F1_Cost_ft_LE_Plow_2_c_48f__c)){    
                        cd.F1_Cost_ft_for_Plow_2_c_48f__c =stateCDObj.F1_Cost_ft_LE_Plow_2_c_48f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_for_Direct_Buried_96f__c, stateCDObj.F1_Cost_ft_LE_Direct_Buried_96f__c)){    
                        cd.F1_Cost_ft_for_Direct_Buried_96f__c = stateCDObj.F1_Cost_ft_LE_Direct_Buried_96f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_for_Overpull_1_25_c_864f__c, stateCDObj.F1_Cost_ft_LE_Overpull_1_25_c_864f__c)){    
                        cd.F1_Cost_ft_for_Overpull_1_25_c_864f__c =stateCDObj.F1_Cost_ft_LE_Overpull_1_25_c_864f__c;  
                    }
                    
                    //Refering Values from COST FW Value Starts
                    System.debug('values before if ft Cost Blended----'+cd.F1_Cost_ft_for_Blended_Cost_from_FW__c);
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_for_Blended_Cost_from_FW__c, stateCDObj.F1_Cost_ft_FW_Blended__c) ){
                        if(cd.Development_Status__c == CDConstants.GREENFIELD){
                        if(stateCDObj.F1_Cost_ft_FW_Greenfield_F1_Multiplier__c != NULL){
                            cd.F1_Cost_ft_for_Blended_Cost_from_FW__c = (stateCDObj.F1_Cost_ft_FW_Blended__c* stateCDObj.F1_Cost_ft_FW_Greenfield_F1_Multiplier__c).setScale(2, System.RoundingMode.HALF_UP);   
                        	System.debug('ft Cost Blended----'+cd.F1_Cost_ft_for_Blended_Cost_from_FW__c);
                           }}
                        if(cd.Development_Status__c == CDConstants.BROWNFIELD || cd.Development_Status__c ==CDConstants.BROWNFIELD_OVERBUILD ){
                            if(stateCDObj.F1_Cost_ft_FW_Brownfield_F1_Multiplier__c != NULL){
                                 cd.F1_Cost_ft_for_Blended_Cost_from_FW__c = (stateCDObj.F1_Cost_ft_FW_Blended__c* stateCDObj.F1_Cost_ft_FW_Brownfield_F1_Multiplier__c).setScale(2, System.RoundingMode.HALF_UP);   
                       		System.debug('ft Cost Blended----'+cd.F1_Cost_ft_for_Blended_Cost_from_FW__c);
                            }
                        }
                       
                    }    
                    //Refering Values from COST FW Value Stop
                    
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_for_Lateral_Bore_1_25_c_864f__c, stateCDObj.F1_Cost_ft_LE_Lateral_Bore_1_25_c_864f__c)){
                        cd.F1_Cost_ft_for_Lateral_Bore_1_25_c_864f__c = stateCDObj.F1_Cost_ft_LE_Lateral_Bore_1_25_c_864f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F1Cost_ftBackbonBore_1_25_c_3_in4_c864f__c, stateCDObj.F1_Cst_ft_BackbonBore_1_25_c_3_in4_c864__c)){     
                        cd.F1Cost_ftBackbonBore_1_25_c_3_in4_c864f__c = stateCDObj.F1_Cst_ft_BackbonBore_1_25_c_3_in4_c864__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_for_Cobble_Bore_1_25_c_864f__c, stateCDObj.F1_Cost_ft_LE_Cobble_Bore_1_25_c_864f__c)){     
                        cd.F1_Cost_ft_for_Cobble_Bore_1_25_c_864f__c = stateCDObj.F1_Cost_ft_LE_Cobble_Bore_1_25_c_864f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_forCobbleBore1_25_c_in4_c_864__c, stateCDObj.F1_Cst_ft_Cobble_Bore_1_25_c_in_4_c_864__c)){    
                        cd.F1_Cost_ft_forCobbleBore1_25_c_in4_c_864__c = stateCDObj.F1_Cst_ft_Cobble_Bore_1_25_c_in_4_c_864__c ;  
                    }
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_for_Rock_Bore_1_25_c_864f__c, stateCDObj.F1_Cost_ft_LE_Rock_Bore_1_25_c_864f__c)){    
                        cd.F1_Cost_ft_for_Rock_Bore_1_25_c_864f__c = stateCDObj.F1_Cost_ft_LE_Rock_Bore_1_25_c_864f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F1_Cost_ft_RockBore_1_25_c_in_4_c_864f__c, stateCDObj.F1_Cst_ft_Rock_Bore_1_25_c_in_4_c_864f__c)){    
                        cd.F1_Cost_ft_RockBore_1_25_c_in_4_c_864f__c = stateCDObj.F1_Cst_ft_Rock_Bore_1_25_c_in_4_c_864f__c;  
                    }
                    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////                  
                    //F2 section Cost/ft fields
                    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    if(isFieldValueNullOrZero(cd.F2_Cost_ft_for_Direct_Buried_96f__c, stateCDObj.F2_Cost_ft_LE_Direct_Buried_96f__c)){
                        cd.F2_Cost_ft_for_Direct_Buried_96f__c = stateCDObj.F2_Cost_ft_LE_Direct_Buried_96f__c ;  
                    }
                    if(isFieldValueNullOrZero(cd.F2_Cost_ft_for_Aerial_10M_144f__c, stateCDObj.F2_Cost_ft_LE_Aerial_10M_144f__c)){     
                        cd.F2_Cost_ft_for_Aerial_10M_144f__c =stateCDObj.F2_Cost_ft_LE_Aerial_10M_144f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F2_Cost_ft_for_Pull_Fiber_96f__c, stateCDObj.F2_Cost_ft_LE_Pull_Fiber_96f__c)){     
                        cd.F2_Cost_ft_for_Pull_Fiber_96f__c = stateCDObj.F2_Cost_ft_LE_Pull_Fiber_96f__c ;  
                    }
                    if(isFieldValueNullOrZero(cd.F2_Cost_ft_for_Place_Conduit_4_c__c, stateCDObj.F2_Cost_ft_LE_Place_Conduit_4_c__c)){ 
                        cd.F2_Cost_ft_for_Place_Conduit_4_c__c =  stateCDObj.F2_Cost_ft_LE_Place_Conduit_4_c__c ;  
                    }
                    if(isFieldValueNullOrZero(cd.F2Cost_ft_PlaceConduit_PullFiber_4_c_96f__c, stateCDObj.F2_Cost_ft_PlaceConduitPullFiber_4_c96f__c)){ 
                        cd.F2Cost_ft_PlaceConduit_PullFiber_4_c_96f__c = stateCDObj.F2_Cost_ft_PlaceConduitPullFiber_4_c96f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F2_Cost_ft_for_Trench_4_c_96f__c, stateCDObj.F2_Cost_ft_LE_Trench_4_c_96f__c)){ 
                        cd.F2_Cost_ft_for_Trench_4_c_96f__c = stateCDObj.F2_Cost_ft_LE_Trench_4_c_96f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F2_Cost_ft_for_Bore_1_25_c_96f__c, stateCDObj.F2_Cost_ft_LE_Bore_1_25_c_96f__c)){ 
                        cd.F2_Cost_ft_for_Bore_1_25_c_96f__c = stateCDObj.F2_Cost_ft_LE_Bore_1_25_c_96f__c ;  
                    }
                    if(isFieldValueNullOrZero(cd.F2_Cost_ft_for_Cobble_Bore_1_25_c_96f__c, stateCDObj.F2_Cost_ft_LE_Cobble_Bore_1_25_c_96f__c)){  
                        cd.F2_Cost_ft_for_Cobble_Bore_1_25_c_96f__c = stateCDObj.F2_Cost_ft_LE_Cobble_Bore_1_25_c_96f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F2_Cost_ft_for_Rock_Bore_1_25_c_96f__c, stateCDObj.F2_Cost_ft_LE_Rock_Bore_1_25_c_96f__c)){ 
                        cd.F2_Cost_ft_for_Rock_Bore_1_25_c_96f__c =stateCDObj.F2_Cost_ft_LE_Rock_Bore_1_25_c_96f__c;  
                    }
            
            }}
  
 	 /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : calculationforF1RelatedSubTotal
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions :Calculation of excel formulas for F1 related sub total
     ******************************************************************************************************************/
     public static void calculationforF1RelatedSubTotal(Capital_Design__c cd){
         if(cd.F1_Mobilization_Cost__c == NULL || (cd.F1_Footage_ft__c != NULL && forOldValuesOfCapitalDesign.get('F1_Footage_ft__c') != cd.F1_Footage_ft__c)){  
                if((cd.F1_Footage_ft__c * CDConstants.POINTEIGHT ) <= CDConstants.FIVETHOUSAND){
                    tempMobilizationF1= CDConstants.FIVETHOUSAND;
                    System.debug('tempMobilizationF1------'+tempMobilizationF1);
                }else {
                    tempMobilizationF1 = cd.F1_Footage_ft__c * CDConstants.POINTEIGHT;
                    System.debug('tempMobilizationF1------'+tempMobilizationF1);
                }
            }
         if(cd.F1_Mobilization_Cost__c == NULL && tempMobilizationF1 >0 && tempMobilizationF1 !=NULL){
             tempMobilizationF1 = tempMobilizationF1;
         }
         else if(cd.F1_Mobilization_Cost__c !=NULL){
             tempMobilizationF1 = cd.F1_Mobilization_Cost__c;
         }
         if(cd.F1_Footage_ft__c != NULL)  
         cd.F1_Related_Cost_Sub_Total__c = (CDUtility.getValue(tempMobilizationF1) +
                                                   CDUtility.getValue(cd.F1_Splicing_Testing_Cost__c)+
                                                   CDUtility.getValue(cd.F1_Roadway_Crossing_Cost__c)+
                                                   CDUtility.getValue(cd.F1_Railroad_Crossing_Cost__c)+
                                                   CDUtility.getValue(cd.F1_Bridge_Crossing_Cost__c)+
                                                   CDUtility.getValue(cd.F1_Canal_Crossing_Cost__c)+
                                                   CDUtility.getValue(cd.F1_Highway_Crossing_Cost__c)+
                                                   CDUtility.getValue(cd.F1_Pole_Make_ready_Cost__c)+
                                                   CDUtility.getValue(cd.F1_Pole_Anchor_and_Guy_Cost__c)+
                                                   CDUtility.getValue(cd.F1_Pothole_Restoration_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
        }
    
     /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : subTotalofFootageforF1
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions :For performing calculation on footage fields and Calculating Sub Total for Footage F1
     ******************************************************************************************************************/ 
     public static void subTotalofFootageforF1(Capital_Design__c cd){
            System.debug('Outside if of Footage condition Sub Total....'+cd.F1_Fiber_And_Conduit_Sub_Total__c);
            if(cd.F1_Fiber_And_Conduit_Sub_Total__c != NULL && cd.F1_Fiber_And_Conduit_Sub_Total__c == CDConstants.HUNDRED ){
                System.debug('Inside if of Footage condition Sub Total....'+cd.F1_Fiber_And_Conduit_Sub_Total__c);
                cd.F1_Fiber_Conduit_Sub_Total_for_Footage__c = (CDUtility.getValue(cd.F1_Footage_for_Use_Existing_Spare__c) +
                                                                CDUtility.getValue(cd.F1_Footage_for_Use_Vacant_12f__c) +
                                                                CDUtility.getValue(cd.F1_Footage_for_Plow_2_c_48f__c) + 
                                                                CDUtility.getValue(cd.F1_Footage_for_Direct_Buried_96f__c) +
                                                                CDUtility.getValue(cd.F1_Footage_for_Aerial_10M_144f__c) +
                                                                CDUtility.getValue(cd.F1_Footage_for_Overpull_1_25_c_864f__c) +
                                                                CDUtility.getValue(cd.F1_Footage_for_Blended_Cost_from_FW__c) + 
                                                                CDUtility.getValue(cd.F1_Footage_for_Lateral_Bore_1_25_c_864f__c) +
                                                                CDUtility.getValue(cd.F1FootageBackbonBore_1_25_c_3_in4_c864f__c) + 
                                                                CDUtility.getValue(cd.F1_Footage_Cobble_Bore_1_25_c_in_4_c_864__c) +
                                                                CDUtility.getValue(cd.F1_Footage_for_Cobble_Bore_1_25_c_864f__c) + 
                                                                CDUtility.getValue(cd.F1_Footage_for_Rock_Bore_1_25_c_864f__c) +
                                                                CDUtility.getValue(cd.F1_Footage_for_RockBore1_25_c_in_4_c_864__c) + 
                                                                CDUtility.getValue(cd.F1FootageTrench_Custom_with_conduit__c) +
                                                                CDUtility.getValue(cd.F1_Footage_for_Custom_without_conduit__c)).setScale(2, System.RoundingMode.HALF_UP);
                
                System.debug('Values in if condition for sub total of Footage  -- '+ cd.F1_Fiber_Conduit_Sub_Total_for_Footage__c);
            }else{
                cd.F1_Fiber_Conduit_Sub_Total_for_Footage__c = CDConstants.ZERO;
            }  
        }
    
     /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : subTotalofCostforF1
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions :For performing calculation on cost fields and Calculating Sub Total for Cost F1
     ******************************************************************************************************************/ 
    public static void subTotalofCostforF1(Capital_Design__c cd){
        Double calculateValues = 0;  
        if(cd.F1_Fiber_Conduit_Sub_Total_for_Footage__c !=NULL && cd.F1_Footage_ft__c != NULL){
             if(cd.F1_Fiber_Conduit_Sub_Total_for_Footage__c == cd.F1_Footage_ft__c ){
                calculateValues = (CDUtility.getValue(cd.F1_Cost_for_Use_Existing_Spare__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_Use_Vacant_12f__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_Plow_2_c_48f__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_Direct_Buried_96f__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_Aerial_10M_144f__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_Overpull_1_25_c_864f__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_Blended_Cost_from_FW__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_Lateral_Bore_1_25_c_864f__c) +
                                   CDUtility.getValue(cd.F1_CostBackboneBore_1_25_c_3_i_4_c864f__c) +
                                   CDUtility.getValue(cd.F1_Cost_CobbleBore_1_25_c_in_4_c_864f__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_Cobble_Bore_1_25_c_864f__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_Rock_Bore_1_25_c_864f__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_RockBore1_25_c_in_4_c_864__c) +
                                   CDUtility.getValue(cd.F1CostforTrench_Custom_with_conduit__c) +
                                   CDUtility.getValue(cd.F1_Cost_for_Custom_without_conduit__c)).setScale(2, System.RoundingMode.HALF_UP);
                System.debug('Calculated values--'+calculateValues);
                if(calculateValues <= CDConstants.ZERO){
                    cd.F1_Fiber_Conduit_Sub_Total_for_Cost__c = CDConstants.ZERO;
                }
                else{
                    cd.F1_Fiber_Conduit_Sub_Total_for_Cost__c = calculateValues;
                }	  
            } 
             else{
                cd.F1_Fiber_Conduit_Sub_Total_for_Cost__c = CDConstants.ZERO;
            } 
        }  else{
                cd.F1_Fiber_Conduit_Sub_Total_for_Cost__c = CDConstants.ZERO;
            }   
        }
    
     /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : subTotalofCostftforF1
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions :For performing Calculation for Sub Total of Cost/ft F1
     * *****************************************************************************************************************/ 
     public static void subTotalofCostftforF1(Capital_Design__c cd){
         
         if(cd.F1_Fiber_Conduit_Sub_Total_for_Footage__c != NULL && cd.F1_Fiber_Conduit_Sub_Total_for_Cost__c != NULL){
             if(cd.F1_Fiber_Conduit_Sub_Total_for_Footage__c > CDConstants.ZERO && cd.F1_Fiber_Conduit_Sub_Total_for_Cost__c > CDConstants.ZERO ){
     
                cd.F1_Fiber_Conduit_Sub_Total_for_Cost_ft__c = (cd.F1_Fiber_Conduit_Sub_Total_for_Cost__c/cd.F1_Fiber_Conduit_Sub_Total_for_Footage__c).setScale(2, System.RoundingMode.HALF_UP) ;
                    }
              else {
                cd.F1_Fiber_Conduit_Sub_Total_for_Cost_ft__c = CDConstants.ZERO ;
            }
         }
            
            else {
                cd.F1_Fiber_Conduit_Sub_Total_for_Cost_ft__c = CDConstants.ZERO ;
            }
        }
    

     /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : footageForF2
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions : For performing Calculation on footage for all F2 fields
     ****************]**************************************************************************************************/
     public static void footageForF2(Capital_Design__c cd){
        String buildingStyle = CDUtility.getAdjstBuildingStyle(cd);
         if( String.isNotBlank(buildingStyle) && f2CostEstDataMap.containsKey(buildingStyle) ){
                    CCT_F2_Cost_Estimator__c  f2CostEstObj = f2CostEstDataMap.get(buildingStyle);
                 if( CDConstants.SFU.equals(buildingStyle)){
                     if(cd.nbr_of_Living_Units__c != NULL && (cd.for_SFU_Average_Lot_Size__c)!= NULL){
                         tempCostCalVariable = (CDUtility.getValue(cd.nbr_of_Living_Units__c) * CDUtility.getValue(Decimal.valueOf(cd.for_SFU_Average_Lot_Size__c))).setScale(2, System.RoundingMode.HALF_UP);
                     }
                     System.debug('tempCostCalVariable when SFU---'+tempCostCalVariable);
                 }else if(CDConstants.COTTAGE.equals(buildingStyle)){
                     if(cd.for_MDU_nbr_of_Buildings__c!=NULL || f2CostEstObj.F2_CostE_Footage_Bld__c !=NULL){
                         tempCostCalVariable =  (CDUtility.getValue(cd.for_MDU_nbr_of_Buildings__c) *  CDUtility.getValue(f2CostEstObj.F2_CostE_Footage_Bld__c)).setScale(2, System.RoundingMode.HALF_UP); 
                         System.debug('tempCostCalVariable WHEN COTTAGE---'+tempCostCalVariable);
                     }
                       
                    }else if(CDConstants.MIDRISELESSTHAN100.equals(buildingStyle) || CDConstants.MIDRISE.equals(buildingStyle) || CDConstants.HIGHRISE.equals(buildingStyle)){
                        if(cd.for_MDU_nbr_of_Buildings__c != NULL || f2CostEstObj.F2_CostE_Footage_Bld__c != NULL || (cd.for_Midrise_Highrise_nbof_average_Floors__c !=NULL && f2CostEstObj.F2_CostE_Footage_Flr__c !=NULL))
                            tempCostCalVariable = (( CDUtility.getValue(cd.for_MDU_nbr_of_Buildings__c) *  CDUtility.getValue(f2CostEstObj.F2_CostE_Footage_Bld__c ))+( CDUtility.getValue(cd.for_Midrise_Highrise_nbof_average_Floors__c) *  CDUtility.getValue(f2CostEstObj.F2_CostE_Footage_Flr__c))).setScale(2, System.RoundingMode.HALF_UP);
                        System.debug('tempCostCalVariable WHEN MIDRISE<100/ MIDRISE/ HIGHRISE---'+tempCostCalVariable);
                    }
                    
                }else{
                        tempCostCalVariable = CDConstants.ZERO ;
                        System.debug('tempCostCalVariable---'+tempCostCalVariable);
                    }
            
         
         if(cd.F2_Direct_Buried_96f__c > CDConstants.ZERO && cd.F2_Direct_Buried_96f__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2_Footage_Direct_Buried_96f__c = ((cd.F2_Direct_Buried_96f__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
             }else {
                 cd.F2_Footage_Direct_Buried_96f__c = ((cd.F2_Direct_Buried_96f__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
             }
         }
         else{
             cd.F2_Footage_Direct_Buried_96f__c = CDConstants.ZERO;
         }
           
         if(cd.F2_Aerial_10M_144f__c > CDConstants.ZERO && cd.F2_Aerial_10M_144f__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2_Footage_Aerial_10M_144f__c = ((cd.F2_Aerial_10M_144f__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP) ;
             }else {
                 cd.F2_Footage_Aerial_10M_144f__c = ((cd.F2_Aerial_10M_144f__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
             }
         }
         else{
             cd.F2_Footage_Aerial_10M_144f__c = CDConstants.ZERO;
         } 
             
         if(cd.Pull_Fiber_96f__c > CDConstants.ZERO && cd.Pull_Fiber_96f__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2_Footage_Pull_Fiber_96f__c = ((cd.Pull_Fiber_96f__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
             }else {
                 cd.F2_Footage_Pull_Fiber_96f__c = ((cd.Pull_Fiber_96f__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
             }
         }
         else{
             cd.F2_Footage_Pull_Fiber_96f__c = CDConstants.ZERO;
         } 
    
         if(cd.Place_Conduit_4_c__c > CDConstants.ZERO && cd.Place_Conduit_4_c__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2_Footage_Place_Conduit_4_c__c = ((cd.Place_Conduit_4_c__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
             }else {
                 cd.F2_Footage_Place_Conduit_4_c__c = ((cd.Place_Conduit_4_c__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
             }
         }
         else{
             cd.F2_Footage_Place_Conduit_4_c__c = CDConstants.ZERO;
         }   
             
		 if(cd.Place_Conduit_and_Pull_Fiber_4_c_96f__c > CDConstants.ZERO && cd.Place_Conduit_and_Pull_Fiber_4_c_96f__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2_Footage_PlaceConduitFiber_4_c_96f__c = ((cd.Place_Conduit_and_Pull_Fiber_4_c_96f__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
             }else {
                 cd.F2_Footage_PlaceConduitFiber_4_c_96f__c = ((cd.Place_Conduit_and_Pull_Fiber_4_c_96f__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
             }
         }
         else{
             cd.F2_Footage_PlaceConduitFiber_4_c_96f__c = CDConstants.ZERO;
         }              
             
       
         if(cd.Trench_4_c_96f__c > CDConstants.ZERO && cd.Trench_4_c_96f__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2_Footage_Trench_4_c_96f__c = ((cd.Trench_4_c_96f__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
             }else {
                 cd.F2_Footage_Trench_4_c_96f__c = ((cd.Trench_4_c_96f__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
             }
         }
         else{
             cd.F2_Footage_Trench_4_c_96f__c = CDConstants.ZERO;
         }           
             
         
	      if(cd.Bore_1_25_c_96f__c > CDConstants.ZERO && cd.Bore_1_25_c_96f__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2_Footage_Bore_1_25_c_96f__c = ((cd.Bore_1_25_c_96f__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
             }else {
                 cd.F2_Footage_Bore_1_25_c_96f__c = ((cd.Bore_1_25_c_96f__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
             }
         }
         else{
             cd.F2_Footage_Bore_1_25_c_96f__c = CDConstants.ZERO;
         }               
            
          if(cd.Cobble_Bore_1_25_c_96f__c > CDConstants.ZERO && cd.Cobble_Bore_1_25_c_96f__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2_Footage_Cobble_Bore_1_25_c_96f__c = ((cd.Cobble_Bore_1_25_c_96f__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
             }else {
                 cd.F2_Footage_Cobble_Bore_1_25_c_96f__c = ((cd.Cobble_Bore_1_25_c_96f__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
             }
         }
         else{
             cd.F2_Footage_Cobble_Bore_1_25_c_96f__c = CDConstants.ZERO;
         }          
            
         if(cd.Rock_Bore_1_25_c_96f__c > CDConstants.ZERO && cd.Rock_Bore_1_25_c_96f__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2_Footage_Rock_Bore_1_25_c_96f__c = ((cd.Rock_Bore_1_25_c_96f__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
             }else {
                 cd.F2_Footage_Rock_Bore_1_25_c_96f__c = ((cd.Rock_Bore_1_25_c_96f__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
             }
         }
         else{
             cd.F2_Footage_Rock_Bore_1_25_c_96f__c = CDConstants.ZERO;
         }  
          
             
          if(cd.F2_Joint_Trench_Custom_with_conduit__c > CDConstants.ZERO && cd.F2_Joint_Trench_Custom_with_conduit__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2FootageJointTrench_Custom_withconduit__c = ((cd.F2_Joint_Trench_Custom_with_conduit__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
             	 System.debug('cd.F2FootageJointTrench_Custom_withconduit__c '+cd.F2FootageJointTrench_Custom_withconduit__c);
             }else {
                 cd.F2FootageJointTrench_Custom_withconduit__c = ((cd.F2_Joint_Trench_Custom_with_conduit__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
            	 System.debug('cd.F2FootageJointTrench_Custom_withconduit__c '+cd.F2FootageJointTrench_Custom_withconduit__c);
             }
         }
         else{
             cd.F2FootageJointTrench_Custom_withconduit__c = CDConstants.ZERO;
         }      
          
             
          if(cd.F2_Custom_without_conduit__c > CDConstants.ZERO && cd.F2_Custom_without_conduit__c !=NULL){
             If( cd.F2_Footage_ft__c > CDConstants.ZERO && cd.F2_Footage_ft__c !=NULL){
                 cd.F2_Footage_Custom_without_conduit__c = ((cd.F2_Custom_without_conduit__c/CDConstants.HUNDRED)* cd.F2_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
             }else {
                 cd.F2_Footage_Custom_without_conduit__c = ((cd.F2_Custom_without_conduit__c/CDConstants.HUNDRED)* tempCostCalVariable).setScale(2, System.RoundingMode.HALF_UP);
        
             }
         }
         else{
             cd.F2_Footage_Custom_without_conduit__c = CDConstants.ZERO;
         }     
         }
  
     /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : subTotalofFootageforF2
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions : For performing Calculation on sub total for footage F2
     ******************************************************************************************************************/
     public static void subTotalofFootageforF2(Capital_Design__c cd){
         if(cd.F2_Fiber_Conduit_Placement_Sub_Total__c != NULL){
              if(cd.F2_Fiber_Conduit_Placement_Sub_Total__c == CDConstants.HUNDRED){
                    cd.F2_Sub_Total_of_Footage__c = (CDUtility.getValue(cd.F2_Footage_Direct_Buried_96f__c)+
                                                     CDUtility.getValue(cd.F2_Footage_Aerial_10M_144f__c)+
                                                     CDUtility.getValue(cd.F2_Footage_Pull_Fiber_96f__c)+
                                                     CDUtility.getValue(cd.F2_Footage_Place_Conduit_4_c__c)+
                                                     CDUtility.getValue(cd.F2_Footage_PlaceConduitFiber_4_c_96f__c)+
                                                     CDUtility.getValue(cd.F2_Footage_Trench_4_c_96f__c)+
                                                     CDUtility.getValue(cd.F2_Footage_Bore_1_25_c_96f__c)+
                                                     CDUtility.getValue(cd.F2_Footage_Cobble_Bore_1_25_c_96f__c)+
                                                     CDUtility.getValue(cd.F2_Footage_Rock_Bore_1_25_c_96f__c)+
                                                     CDUtility.getValue(cd.F2FootageJointTrench_Custom_withconduit__c)+
                                                     CDUtility.getValue(cd.F2_Footage_Custom_without_conduit__c)).setScale(2, System.RoundingMode.HALF_UP);
                }
              else{
                    cd.F2_Sub_Total_of_Footage__c = CDConstants.ZERO;
                }
         }                else{
                    cd.F2_Sub_Total_of_Footage__c = CDConstants.ZERO;
                }
         }
     /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : subTotalofCostforF2
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions : For performing Calculation on sub total for Cost F2
     ******************************************************************************************************************/
    public static void subTotalofCostforF2(Capital_Design__c cd){
        
        if((cd.F2_Footage_ft__c !=NULL || tempCostCalVariable !=NULL) && cd.F2_Sub_Total_of_Footage__c !=NULL ){
            if((cd.F2_Sub_Total_of_Footage__c == cd.F2_Footage_ft__c) || (tempCostCalVariable == cd.F2_Sub_Total_of_Footage__c)){
                calculateCostValues =(CDUtility.getValue(cd.F2_Cost_for_Direct_Buried_96f__c)+
                                      CDUtility.getValue(cd.F2_Cost_for_Aerial_10M_144f__c)+
                                      CDUtility.getValue(cd.F2_Cost_for_Pull_Fiber_96f__c)+
                                      CDUtility.getValue(cd.F2_Cost_for_Place_Conduit_4_c__c)+
                                      CDUtility.getValue(cd.F2_CostPlaceConduitPull_Fiber_4_c96f__c)+
                                      CDUtility.getValue(cd.F2_Cost_for_Trench_4_c_96f__c)+
                                      CDUtility.getValue(cd.F2_Cost_for_Bore_1_25_c_96f__c)+
                                      CDUtility.getValue(cd.F2_Cost_for_Cobble_Bore_1_25_c_96f__c)+
                                      CDUtility.getValue(cd.F2_Cost_for_Rock_Bore_1_25_c_96f__c)+
                                      CDUtility.getValue(cd.F2_Cost_Joint_Trench_Custom_withconduit__c)+
                                      CDUtility.getValue(cd.F2_Cost_for_Custom_without_conduit__c)).setScale(2, System.RoundingMode.HALF_UP);
     
                if(calculateCostValues <= CDConstants.ZERO){
                    cd.F2_Sub_Total_of_Cost__c = CDConstants.ZERO;
                }
                else{
                    cd.F2_Sub_Total_of_Cost__c = calculateCostValues; 
                }
            }
            else{
            cd.F2_Sub_Total_of_Cost__c = CDConstants.ZERO;
        }
        }
        
        else{
            cd.F2_Sub_Total_of_Cost__c = CDConstants.ZERO;
        }
    }
     /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : subTotalofCostftforF2
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions : For performing Calculation on sub total for Cost/ft F2
     ******************************************************************************************************************/
     public static void subTotalofCostftforF2(Capital_Design__c cd){
         System.debug('(CDTriggerHelper.subTotalofCostftforF2) cd?.F2_Sub_Total_of_Footage__c = ' + cd?.F2_Sub_Total_of_Footage__c + '  \n cd?.F2_Sub_Total_of_Cost__c = ' + cd?.F2_Sub_Total_of_Cost__c);
        if(cd.F2_Sub_Total_of_Footage__c != NULL && cd.F2_Sub_Total_of_Cost__c != NULL){
            if(cd.F2_Sub_Total_of_Footage__c > CDConstants.ZERO && cd.F2_Sub_Total_of_Cost__c > CDConstants.ZERO ){
                cd.F2_Sub_Total_of_Cost_ft__c = (cd.F2_Sub_Total_of_Cost__c/cd.F2_Sub_Total_of_Footage__c).setScale(2, System.RoundingMode.HALF_UP);
            }
            else{
                cd.F2_Sub_Total_of_Cost_ft__c = CDConstants.ZERO;
            }
        }
        else{
            cd.F2_Sub_Total_of_Cost_ft__c = CDConstants.ZERO;
        }
    }
     /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : subTotalofF2RelatedCost
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions : For performing Calculation on sub total for Related Cost F2
     ******************************************************************************************************************/
      public static void subTotalofF2RelatedCost(Capital_Design__c cd){
      if(cd.F2_Mobilization_Cost__c == NULL){
            if((String.isNotBlank(cd.Property_Address_State__c) && stateDataMap?.containsKey(cd?.Property_Address_State__c)) || (String.isNotBlank(cd.Primary_Address_State_Name__c) && stateDataMap?.containsKey(cd?.Primary_Address_State_Name__c))) {
                StatesCostforCapitalDesign__c sc = stateDataMap?.get(cd.Property_Address_State__c);
                if (sc == null) sc = stateDataMap?.get(cd.Primary_Address_State_Name__c);
                System.debug('sc----'+sc.id);  
                    calculateRelCostF2VarOne = (CDUtility.getValue(cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c)+
                                                CDUtility.getValue(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c)+
                                                CDUtility.getValue(cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c)+
                                                CDUtility.getValue(cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c)+
                                                CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Comb_Cost__c)+
                                                CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Combined_Cost__c)+
                                                CDUtility.getValue(cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c)+
                                                CDUtility.getValue(cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c)+
                                                CDUtility.getValue(cd.OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c)+
                                                CDUtility.getValue(cd.OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c)+
                                                CDUtility.getValue(cd.OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c)).setScale(2, System.RoundingMode.HALF_UP);
                    System.debug('-----before calculation-----'+calculateRelCostF2VarOne);
                if(calculateRelCostF2VarOne > 0 && calculateRelCostF2VarOne != NULL){
                     if(calculateRelCostF2VarOne >  CDConstants.TWOLAKH){
                        calculateRelCostF2VarOne = (calculateRelCostF2VarOne * (CDUtility.getValue(sc.F2_Eng_time_Cost_Over_200K_OVH__c)/100)).setScale(2, System.RoundingMode.HALF_UP) ;	
                        System.debug('----- calculation-----'+calculateRelCostF2VarOne);
                    }else if(calculateRelCostF2VarOne > CDConstants.ONELAKH){
                        calculateRelCostF2VarOne = (calculateRelCostF2VarOne * (CDUtility.getValue(sc.F2_Eng_time_Cost_100K_200K_OVH__c)/100)).setScale(2, System.RoundingMode.HALF_UP);
                        System.debug('----- calculation-----'+calculateRelCostF2VarOne);
                    }
                    else if(calculateRelCostF2VarOne > CDConstants.FIFTHYTHOUSAND){
                        calculateRelCostF2VarOne = (calculateRelCostF2VarOne * (CDUtility.getValue(sc.F2_Eng_time_Cost_50K_100K_OVH__c)/100)).setScale(2, System.RoundingMode.HALF_UP);	
                        System.debug('----- calculation-----'+calculateRelCostF2VarOne);
                    }
                    else{
                        calculateRelCostF2VarOne = (calculateRelCostF2VarOne * (CDUtility.getValue(sc.F2_Eng_time_Cost_Under_50K_OVH__c)/100)).setScale(2, System.RoundingMode.HALF_UP); 
                        System.debug('----- calculation-----'+calculateRelCostF2VarOne);
                    }
                    if(calculateRelCostF2VarOne < CDConstants.FIVETHOUSAND){
                        calculateRelCostF2VarOne = CDConstants.FIVETHOUSAND; 
                    }
                   // cd.F2_Mobilization_Cost__c = calculateRelCostF2VarOne;
                }
                }}
          		  if(cd.F2_Mobilization_Cost__c == NULL && calculateRelCostF2VarOne >0 && calculateRelCostF2VarOne !=NULL){
                calculateRelCostF2VarOne = calculateRelCostF2VarOne;
         }
         else if(cd.F2_Mobilization_Cost__c !=NULL){
             calculateRelCostF2VarOne = (cd.F2_Mobilization_Cost__c).setScale(2, System.RoundingMode.HALF_UP);
         }

          
          
                    cd.F2_Related_Cost_Sub_Total__c = (CDUtility.getValue(calculateRelCostF2VarOne)+
                                                       CDUtility.getValue(cd.F2_Pole_Make_Ready_Cost__c)+
                                                       CDUtility.getValue(cd.F2_Pole_Anchor_and_Guy_Cost__c)+
                                                       CDUtility.getValue(cd.F2_Pothole_Restoration_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
        }
    
     /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : isFieldValueNullOrZero
     * @params : fieldValue1,fieldValue2 
     * @ Descriptions : For checking either Field is Null or Zero and if it has value then only return Field value
     ******************************************************************************************************************/
    public static boolean isFieldValueNullOrZero(Decimal fieldValue1, Decimal fieldValue2){
        
       return (fieldValue1 == NULL || fieldValue1  == CDConstants.ZERO) && fieldValue2 != NULL ?TRUE:FALSE;
        
    }
    

     /*******************************************************************************************************************
     * @Developer : Shobith N
     * @Method : performCalculationforCostFtF3
     * @params : Input parameter Capital_Design__c object's field 
     * @ Descriptions : ESCJ-416, ESCJ-505 
     *                  For Cost/ft field values in F3 section based on States from StateCostTable
     * *****************************************************************************************************************/
     public static void performCalculationforCostFtF3(Capital_Design__c cd){
        
            if((String.isNotBlank(cd.Property_Address_State__c) && stateDataMap?.containsKey(cd?.Property_Address_State__c)) || (String.isNotBlank(cd.Primary_Address_State_Name__c) && stateDataMap?.containsKey(cd?.Primary_Address_State_Name__c))) {
                StatesCostforCapitalDesign__c stateCDObj = stateDataMap?.get(cd.Property_Address_State__c);
                if (stateCDObj == null) stateCDObj = stateDataMap?.get(cd.Primary_Address_State_Name__c);
                    if(isFieldValueNullOrZero(cd.F3_Cost_ft_for_Aerial_12f__c, stateCDObj.F3_cost_ft_LE_Aerial_12f__c)){
                        cd.F3_Cost_ft_for_Aerial_12f__c = stateCDObj.F3_cost_ft_LE_Aerial_12f__c ;
                    }
                	if(isFieldValueNullOrZero(cd.F3_Cost_ft_for_Bore_1_25_c_12f__c, stateCDObj.F3_cost_ft_LE_Bore_1_25_c_12f__c )){
                        cd.F3_Cost_ft_for_Bore_1_25_c_12f__c = stateCDObj.F3_cost_ft_LE_Bore_1_25_c_12f__c  ;
                    }
                    if(isFieldValueNullOrZero(cd.F3_Cost_ft_for_Buried_w_Conduit_12f__c, stateCDObj.F3_cost_ft_LE_Buried_w_Conduit_12f__c)){
                        cd.F3_Cost_ft_for_Buried_w_Conduit_12f__c = stateCDObj.F3_cost_ft_LE_Buried_w_Conduit_12f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F3_cost_ft_direct_buried_12f__c, stateCDObj.F3_cost_ft_LE_Direct_Buried_12f__c)){    
                        cd.F3_cost_ft_direct_buried_12f__c =stateCDObj.F3_cost_ft_LE_Direct_Buried_12f__c;  
                    }
                    if(isFieldValueNullOrZero(cd.F3_Cost_ft_for_Pull_Fiber_12f__c, stateCDObj.F3_cost_ft_LE_Pull_Fiber_12f__c)){    
                        cd.F3_Cost_ft_for_Pull_Fiber_12f__c = stateCDObj.F3_cost_ft_LE_Pull_Fiber_12f__c;  
                    }
                   // if(isFieldValueNullOrZero(cd.F3_related_cost_for_slack_box_cost__c, stateCDObj.F3_Cost_LU_LE_Slack_box__c)){    
                        //cd.F3_related_cost_for_slack_box_cost__c =stateCDObj.F3_Cost_LU_LE_Slack_box__c;  
                    //}                 
            }}
  
    
     /*******************************************************************************************************************
     * For F3 Related Cost
     ******************************************************************************************************************** 
     * @Developer : Shobith N
     * @Method : calculationforF3RelatedSubTotal
     * @Params : Input parameter Capital_Design__c object's field
     * @Descriptions : ESCJ-416, ESCJ-505 
     * 				   For performing Calculation on sub total for Related Cost F3
     ******************************************************************************************************************/
     public static void calculationforF3RelatedSubTotal(Capital_Design__c cd){
         system.debug('enter into calculationforF3RelatedSubTotal' );
                   system.debug('enter the value ');
         String buildingStyle = CDUtility.getBuildStyle(cd.Building_Style__c);
         if(buildingStyle != NULL){
                 if(buildingStyle.equalsIgnoreCase(CDConstants.SFU)){
                     system.debug(' enter into Building_Style__c');
                     if(cd.F3_Sub_total__c == CDConstants.HUNDRED && stateDataMap.containsKey(cd.Property_Address_State__c)){
                         //system.debug('enter into F3_Sub_total__c');
                         //if(StateDataMap.get(cd.Property_Address_State__c).F3_Cost_LU_LE_Slack_box__c!=null && CDUtility.getAdjstdnbrLivingUnits(cd) != null){
                     tempvariablef3  = ((StateDataMap.get(cd.Property_Address_State__c).F3_Cost_LU_LE_Slack_box__c) * CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP); 
                       //System.debug('cd.F3_related_cost_for_slack_box_cost__c------'+cd.F3_related_cost_for_slack_box_cost__c);
                         
                         }  //ESCJ-1540 BUG FIX.
                     }
                     if(cd.F3_related_cost_for_slack_box_cost__c  == NULL && tempvariablef3 > 0 && tempvariablef3 !=NULL){
             tempvariablef3 = tempvariablef3;
         }
         else if(cd.F3_related_cost_for_slack_box_cost__c !=NULL){
             tempvariablef3 = cd.F3_related_cost_for_slack_box_cost__c;      
         }    
                    // else{
                    //cd.F3_related_cost_for_slack_box_cost__c = CDConstants.ZERO;
                    // System.debug('cd.F3_related_cost_for_slack_box_cost__c------'+cd.F3_related_cost_for_slack_box_cost__c);
                    //   }
                     
                 
                    cd.F3_Related_cost_Sub_Total__c = Decimal.valueOf(tempvariablef3).setScale(2, System.RoundingMode.HALF_UP); 
               } 
         }    //ESCJ-1540 BUG FIX.
     /*******************************************************************************************************************
     * @Developer : Shobith N
     * @Method : subTotalofCostforF3
     * @Params : Input parameter Capital_Design__c object's field
     * @Descriptions : ESCJ-416, ESCJ-505 
     * 				   For performing Calculation on sub total for Cost F3
     ******************************************************************************************************************/
    public static void subTotalofCostforF3(Capital_Design__c cd){
        Double calculateValues = 0;   
             if( (cd.F3_Footage_for_Sub_total__c !=NULL && cd.F3_Avg_Drop_Length_ft__c !=NULL && cd.nbr_of_Living_Units__c != NULL)){
              //    if(cd.F3_Footage_for_Sub_total__c == CDUtility.getValue(Decimal.valueOf(cd.F3_Avg_Drop_Length_ft__c))*CDUtility.getAdjstdnbrLivingUnits(cd)){
                  if(cd.F3_Footage_for_Sub_total__c == CDUtility.getValue(Decimal.valueOf(cd.F3_Avg_Drop_Length_ft__c))*CDUtility.getAdjstdnbrLivingUnits(cd)){
            System.debug('test....');
            
                  System.debug('Inside cost if condition..');
                 calculateValues = (cd.F3_Cost_for_Direct_Buried_12f__c +
                                        cd.F3_Cost_for_Buried_w_Conduit_12f__c +
                                        cd.F3_Cost_for_Pull_Fiber_12f__c +
                                        cd.F3_Cost_for_Aerial_12f__c +
                                        cd.F3_Cost_for_Bore_1_25_c_12f__c +
                                        cd.F3_Cost_for_Joint_Trench_Custom__c).setScale(2, System.RoundingMode.HALF_UP);
            System.debug('Calculated values--'+calculateValues);
                 if(calculateValues <= 0.0){
                     cd.F3_Sub_total_For_cost__c = CDConstants.ZERO;
                 }
                 else{
                     cd.F3_Sub_total_For_cost__c = calculateValues;
                     System.debug('Sub total Cost..........cd.F3_Sub_total_For_cost__c== '+cd.F3_Sub_total_For_cost__c);
                 }
        }
             else{
                cd.F3_Sub_total_For_cost__c = CDConstants.ZERO;
             }
                     
                 }
                 else{
                cd.F3_Sub_total_For_cost__c = CDConstants.ZERO;
             }
              
       // }
    }
            
    

     /******************************************************************************************************************** 
     * @Developer : Shobith N
     * @Method : subTotalofCostftforF3
     * @Params : Input parameter Capital_Design__c object's field
     * @Descriptions : ESCJ-416, ESCJ-505 
     * 				   For performing Calculation on sub total for Cost/ft F3
     ******************************************************************************************************************/
     public static void subTotalofCostftforF3(Capital_Design__c cd){
        
                     if(cd.F3_Footage_for_Sub_total__c > CDConstants.ZERO && cd.F3_Sub_total_For_cost__c > CDConstants.ZERO && (cd.F3_Footage_for_Sub_total__c != NULL && cd.F3_Sub_total_For_cost__c != NULL)){ 
                System.debug('cd.F3_Sub_total_For_cost__c.......'+cd.F3_Sub_total_For_cost__c);
                System.debug('cd.F3_Footage_for_Sub_total__c.......'+cd.F3_Footage_for_Sub_total__c);
                cd.F3_Sub_total_for_Cost_ft__c = (cd.F3_Sub_total_For_cost__c/cd.F3_Footage_for_Sub_total__c).setScale(2, System.RoundingMode.HALF_UP) ;
            	System.debug('Values of Cost/FT------'+cd.F3_Sub_total_for_Cost_ft__c);
            
                     } else {
                cd.F3_Sub_total_for_Cost_ft__c = CDConstants.ZERO ;
            }
		    
     }
        
    

    /*****************************************************************************************************************
     * @Developer : Ami Parekh
     * @Method : calculationforF1RelatedSubTotal
     * @params : Input parameter Capital_Design__c object
     * @ Descriptions :ESCJ-614
     *				   Some values are not getting updated in before update trigger, for that updating those values in
					   after update & using DML
     ******************************************************************************************************************/
     public static void getF2CostandCostft (Map<Id,Capital_Design__c> mapCdIds){
         List<Capital_Design__c> capitalDesign = [SELECT Id,
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
                                                  F2_Footage_ft__c,
                                                  F2_Sub_Total_of_Footage__c,
                                                  F2_Sub_Total_of_Cost__c,
                                                  F2_Sub_Total_of_Cost_ft__c,
                                                  F2_Fiber_Conduit_Placement_Sub_Total__c
                                                  FROM Capital_Design__c
                                                  WHERE ID IN : mapCdIds.keySet()];
         try{
             for(Capital_Design__c cd : capitalDesign){  
                 subTotalofCostforF2(cd);
                 subTotalofCostftforF2(cd);
                  if(cd.F2_Fiber_Conduit_Placement_Sub_Total__c>CDConstants.HUNDRED){
                     cd.F2_Sub_Total_of_Cost_ft__c=0;
                     cd.F2_Sub_Total_of_Cost__c=0;    
                 }
             } 
         }Catch(Exception ex){
             system.debug('ex---> '+ex);
         }      
         if(!capitalDesign.isEmpty()){
             DATABASE.UPDATE(capitalDesign, FALSE); 
         }   
     }
    
      /******************************************************************************************************************** 
     * @Developer : Ganesh S
     * @Method : doF1OutputCalculations
     * @Params : Input parameter Capital_Design__c object's field
     * @Descriptions : ESCJ-558
     * 				   For performing Calculation for F1 and ISP output section
     ******************************************************************************************************************/
      public static void doF1OutputCalculations(Capital_Design__c cd){
         System.debug('*************** Start - doF1OutputCalculations ********************');
         if(cd.OLT_non_shared_direct_Sub_cost__c != null && cd.OLT_non_shared_direct_Sub_cost__c > CDConstants.ZERO ){ 
             cd.OP_OLT_Non_Shared_Sub_Cost_Comb_Cost__c = (cd.OLT_non_shared_direct_Sub_cost__c).setScale(2, System.RoundingMode.HALF_UP);
         } else {
             cd.OP_OLT_Non_Shared_Sub_Cost_Comb_Cost__c = CDConstants.ZERO ;
         }
          Decimal takerate = CDUtility.getAdjstdnbrLivingUnits(cd);
          if(cd.OLT_shared_Sub_cost__c == Null){ 
              cd.OP_OLT_Shared_Sub_Cost_CombCost__c = costEstDataMap?.containsKey(CDConstants.CLAMIX_ADTRAN) ? (costEstDataMap?.get(CDConstants.CLAMIX_ADTRAN)?.ISP_Estimator_Cost_per_LU__c * takerate).setScale(2, System.RoundingMode.HALF_UP) : null;
          } else {
              cd.OP_OLT_Shared_Sub_Cost_CombCost__c = (cd.OLT_shared_Sub_cost__c).setScale(2, System.RoundingMode.HALF_UP) ;
          }
          /****  QFCJ-4387 Changed from below to *****
          if( cd.OP_OLT_Non_Shared_Sub_Cost_Comb_Cost__c != null && cd.OP_OLT_Shared_Sub_Cost_CombCost__c != null){
            cd.OP_ISP_Total_cost_Combined_Cost__c =  cd.OP_OLT_Non_Shared_Sub_Cost_Comb_Cost__c + cd.OP_OLT_Shared_Sub_Cost_CombCost__c;
         }else{
              cd.OP_ISP_Total_cost_Combined_Cost__c = CDConstants.ZERO ;
          }
			******New for QFCJ-4387 Below*************/
	      cd.OP_ISP_Total_cost_Combined_Cost__c = (CDUtility.getValue(cd.OP_OLT_Non_Shared_Sub_Cost_Comb_Cost__c) + CDUtility.getValue(cd.OP_OLT_Shared_Sub_Cost_CombCost__c)).setScale(2, System.RoundingMode.HALF_UP);

          if( CDUtility.isValGreaterThanZero(cd.OP_OLT_Non_Shared_Sub_Cost_Comb_Cost__c ) &&  CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c)){
             cd.OP_OLT_Non_Shared_Sub_Cost_Cost_LU__c = (cd.OP_OLT_Non_Shared_Sub_Cost_Comb_Cost__c/cd.nbr_of_Living_Units__c).setScale(2, System.RoundingMode.HALF_UP); 
         }else{
              cd.OP_OLT_Non_Shared_Sub_Cost_Cost_LU__c = CDConstants.ZERO ;
          }
         if( CDUtility.isValGreaterThanZero(cd.OP_OLT_Shared_Sub_Cost_CombCost__c) &&  CDUtility.isValGreaterThanZero(takerate)){
             cd.OP_OLT_Shared_Sub_Cost_Cost_LU__c = (cd.OP_OLT_Shared_Sub_Cost_CombCost__c/takerate).setScale(2, System.RoundingMode.HALF_UP);
         } else{
              cd.OP_OLT_Shared_Sub_Cost_Cost_LU__c = CDConstants.ZERO ;
          }
         //if( CDUtility.isValGreaterThanZero(cd.OP_OLT_Non_Shared_Sub_Cost_Cost_LU__c) && CDUtility.isValGreaterThanZero(cd.OP_OLT_Shared_Sub_Cost_Cost_LU__c)){
            cd.OP_ISP_Total_cost_Cost_LU__c = (CDUtility.getValue(cd.OP_OLT_Non_Shared_Sub_Cost_Cost_LU__c) + CDUtility.getValue(cd.OP_OLT_Shared_Sub_Cost_Cost_LU__c)).setScale(2, System.RoundingMode.HALF_UP);
         //} else{
            //  cd.OP_ISP_Total_cost_Cost_LU__c = CDConstants.ZERO ;
          //}
         
         if(CDUtility.isValGreaterThanZero(cd.OP_F1_Fiber_Sub_Cost_Comb_Cost__c) && CDUtility.isValGreaterThanZero(cd.F1_Footage_ft__c)) {
          cd.OP_F1_Fiber_Sub_Cost_Cost_ft__c = (cd.OP_F1_Fiber_Sub_Cost_Comb_Cost__c/cd.F1_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP); 
        }else{
              cd.OP_F1_Fiber_Sub_Cost_Cost_ft__c = CDConstants.ZERO ;
          }
         if(CDUtility.isValGreaterThanZero(cd.OP_F1_Fiber_Sub_Cost_Comb_Cost__c) && CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c)) {
          cd.OP_F1_Fiber_Sub_Cost_Cost_LU__c = (cd.OP_F1_Fiber_Sub_Cost_Comb_Cost__c/cd.nbr_of_Living_Units__c).setScale(2, System.RoundingMode.HALF_UP);
        }else{
              cd.OP_F1_Fiber_Sub_Cost_Cost_LU__c = CDConstants.ZERO ;
          }
          if(cd.F1_Fiber_And_Conduit_Sub_Total__c != null & (cd.F1_Fiber_And_Conduit_Sub_Total__c == CDConstants.ZERO || cd.F1_Fiber_And_Conduit_Sub_Total__c == CDConstants.HUNDRED) ){
         if( CDUtility.isValGreaterThanZero(cd.F1_Footage_ft__c)){
            cd.OP_F1_Conduit_Sub_Cost_Unit__c = (cd.F1_Footage_ft__c - (CDUtility.getValue(cd.F1_Footage_for_Use_Existing_Spare__c)+CDUtility.getValue(cd.F1_Footage_for_Use_Vacant_12f__c)+CDUtility.getValue(cd.F1_Footage_for_Plow_2_c_48f__c)+CDUtility.getValue(cd.F1_Footage_for_Direct_Buried_96f__c)+CDUtility.getValue(cd.F1_Footage_for_Aerial_10M_144f__c) + CDUtility.getValue(cd.F1_Footage_for_Overpull_1_25_c_864f__c))- (CDUtility.getValue(cd.F1_Footage_for_Custom_without_conduit__c))).setScale(0, System.RoundingMode.HALF_UP);
         }else{
        cd.OP_F1_Conduit_Sub_Cost_Unit__c = CDConstants.ZERO;
      }
      }else{
        cd.OP_F1_Conduit_Sub_Cost_Unit__c = CDConstants.ZERO;
      }
         if( CDUtility.isValGreaterThanZero(cd.OP_F1_Conduit_Sub_Cost_Unit__c)){
          cd.OP_F1_Conduit_Sub_Cost_Comb_Cost__c = (cd.OP_F1_Conduit_Sub_Cost_Unit__c * CDConstants.TWO).setScale(2, System.RoundingMode.HALF_UP);
      }else{
        cd.OP_F1_Conduit_Sub_Cost_Comb_Cost__c = CDConstants.ZERO;
      }
         if(CDUtility.isValGreaterThanZero(cd.F1_Footage_ft__c)) {
             if(cd.F1_Fiber_Conduit_Sub_Total_for_Cost__c != null && cd.F1_Fiber_Conduit_Sub_Total_for_Cost__c > CDConstants.ZERO ){
                 cd.OP_F1_Fiber_Sub_Cost_Comb_Cost__c = (cd.F1_Fiber_Conduit_Sub_Total_for_Cost__c - CDUtility.getValue(cd.OP_F1_Conduit_Sub_Cost_Comb_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
              }else{ 
                 cd.OP_F1_Fiber_Sub_Cost_Comb_Cost__c = ((stateDataMap?.get(cd.Property_Address_State__c).F1_Cost_ft_FW_Blended__c  *  (cd.Project_Type__c == CDConstants.GREENFIELD ? stateDataMap.get(cd.Property_Address_State__c).F1_Cost_ft_FW_Greenfield_F1_Multiplier__c: stateDataMap.get(cd.Property_Address_State__c).F1_Cost_ft_FW_Brownfield_F1_Multiplier__c)* cd.F1_Footage_ft__c) -CDUtility.getValue(cd.OP_F1_Conduit_Sub_Cost_Comb_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
             } 
         }
          if(CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F1_Conduit_Sub_Cost_Comb_Cost__c)){
           cd.OP_F1_Conduit_Sub_Cost_Cost_LU__c = (cd.OP_F1_Conduit_Sub_Cost_Comb_Cost__c/cd.nbr_of_Living_Units__c).setScale(2, System.RoundingMode.HALF_UP);
        } else{
        cd.OP_F1_Conduit_Sub_Cost_Cost_LU__c = CDConstants.ZERO;
      } 
           if( CDUtility.isValGreaterThanZero(cd.OP_F1_Conduit_Sub_Cost_Comb_Cost__c) && CDUtility.isValGreaterThanZero(cd.OP_F1_Conduit_Sub_Cost_Unit__c)){
           cd.OP_F1_Conduit_Sub_Cost_Cost_ft__c = (cd.OP_F1_Conduit_Sub_Cost_Comb_Cost__c/cd.OP_F1_Conduit_Sub_Cost_Unit__c).setScale(2, System.RoundingMode.HALF_UP);
        }else{
        cd.OP_F1_Conduit_Sub_Cost_Cost_ft__c = CDConstants.ZERO;
      } 
         Decimal f1handholeEstimatore;
            if(CDUtility.isValGreaterThanZero(cd.F1_Footage_ft__c)) {
                CCT_F1_Cost_Estimator__c f1CostE  = f1CostEstDataMap?.containsKey(cd.Population_Density__c) ? f1CostEstDataMap?.get(cd.Population_Density__c):null;
                if(f1CostE != null && CDUtility.isValGreaterThanZero(f1CostE.F1_Handhole_Spacing__c)){
                    f1handholeEstimatore = (cd.F1_Footage_ft__c/f1CostE.F1_Handhole_Spacing__c).setScale(0, System.RoundingMode.HALF_UP);
                }
                cd.OP_F1_Handhole_Sub_Cost_Unit__c = cd.F1_nbr_of_Handhole__c != null && cd.F1_nbr_of_Handhole__c >=0 ? cd.F1_nbr_of_Handhole__c : f1handholeEstimatore;
                cd.OP_F1_Handhole_Sub_Cost_Comb_Cost__c = 0; // default to 0
                if(CDUtility.isValGreaterThanZero(cd.OP_F1_Handhole_Sub_Cost_Unit__c)){
                   cd.OP_F1_Handhole_Sub_Cost_installation__c = (cd.OP_F1_Handhole_Sub_Cost_Unit__c *  CDUtility.getValue(stateDataMap?.get(cd.Property_Address_State__c)?.IC_Handhole__c)).setScale(2, System.RoundingMode.HALF_UP);
                    cd.OP_F1_Handhole_Sub_Cost_Material__c =  (cd.OP_F1_Handhole_Sub_Cost_Unit__c * CDUtility.getValue(f1CostEstDataMap?.get(cd.Population_Density__c)?.F1_Handhole_Material_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
                    cd.OP_F1_Handhole_Sub_Cost_Overhead__c =  (cd.OP_F1_Handhole_Sub_Cost_Material__c * (CDUtility.getValue(stateDataMap?.get(cd.Property_Address_State__c)?.OC_General_Multiplier__c) - CDConstants.ONE)).setScale(2, System.RoundingMode.HALF_UP);
                    cd.OP_F1_Handhole_Sub_Cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_F1_Handhole_Sub_Cost_installation__c) + CDUtility.getValue(cd.OP_F1_Handhole_Sub_Cost_Material__c) + CDUtility.getValue(cd.OP_F1_Handhole_Sub_Cost_Overhead__c)).setScale(2, System.RoundingMode.HALF_UP);
                }else{
                      cd.OP_F1_Handhole_Sub_Cost_installation__c = CDConstants.ZERO;
                      cd.OP_F1_Handhole_Sub_Cost_Material__c = CDConstants.ZERO;
                      cd.OP_F1_Handhole_Sub_Cost_Overhead__c = CDConstants.ZERO;
                      cd.OP_F1_Handhole_Sub_Cost_Comb_Cost__c = CDConstants.ZERO;
                }
                if(CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c ) && CDUtility.isValGreaterThanZero(cd.OP_F1_Handhole_Sub_Cost_Comb_Cost__c)){
             	 cd.OP_F1_Handhole_Sub_Cost_Cost_LU__c =  (CDUtility.getValue(cd.OP_F1_Handhole_Sub_Cost_Comb_Cost__c)/cd.nbr_of_Living_Units__c).setScale(2, System.RoundingMode.HALF_UP);
                 }else{
                     cd.OP_F1_Handhole_Sub_Cost_Cost_LU__c = CDConstants.ZERO;
                 }
            }
          if(cd.F1_Mobilization_Cost__c == NULL && cd.F1_Footage_ft__c != NULL ){  
             if((cd.F1_Footage_ft__c * CDConstants.POINTEIGHT ) <= CDConstants.FIVETHOUSAND){
                 cd.OP_Mob_Sub_Cost_Comb_Cost__c = CDConstants.FIVETHOUSAND;
                 System.debug('cd.F1_Mobilization_Cost__c------'+cd.F1_Mobilization_Cost__c);
             }else {
                 cd.OP_Mob_Sub_Cost_Comb_Cost__c = (cd.F1_Footage_ft__c * CDConstants.POINTEIGHT).setScale(2, System.RoundingMode.HALF_UP);
                 System.debug('cd.F1_Mobilization_Cost__c------'+cd.F1_Mobilization_Cost__c);
             }
         }else{
             cd.OP_Mob_Sub_Cost_Comb_Cost__c = (cd.F1_Mobilization_Cost__c).setScale(2, System.RoundingMode.HALF_UP);
         }
         cd.OP_F1_Splicing_Sub_Cost_Comb_Cost__c = cd.F1_Splicing_Testing_Cost__c != null && cd.F1_Splicing_Testing_Cost__c > 0 ? (cd.F1_Splicing_Testing_Cost__c).setScale(2, System.RoundingMode.HALF_UP) : 0; 
		 cd.OP_F1_Major_Cross_Sub_Cost_Comb_Cost__c = (CDUtility.getValue(cd.F1_Railroad_Crossing_Cost__c) + CDUtility.getValue(cd.F1_Roadway_Crossing_Cost__c) + CDUtility.getValue(cd.F1_Bridge_Crossing_Cost__c) + CDUtility.getValue(cd.F1_Canal_Crossing_Cost__c) + CDUtility.getValue(cd.F1_Highway_Crossing_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
         cd.OP_F1_Pole_Make_Ready_Sub_Cst_Comb_Cst__c =  (CDUtility.getValue(cd.F1_Pole_Make_ready_Cost__c)).setScale(2, System.RoundingMode.HALF_UP); //!= null && cd.F1_Pole_Make_ready_Cost__c > 0 ? cd.F1_Pole_Make_ready_Cost__c : 0; 
         cd.OP_F1_Pole_Anchor_Sub_Cost_Comb_Cost__c = (CDUtility.getValue(cd.F1_Pole_Anchor_and_Guy_Cost__c)).setScale(2, System.RoundingMode.HALF_UP); //!= null && cd.F1_Pole_Anchor_and_Guy_Cost__c > 0 ? cd.F1_Pole_Anchor_and_Guy_Cost__c : 0; 
         cd.OP_F1_Pothole_Rest_Sub_Cost_Comb_Cost__c = (CDUtility.getValue(cd.F1_Pothole_Restoration_Cost__c)).setScale(2, System.RoundingMode.HALF_UP); // != null && cd.F1_Pothole_Restoration_Cost__c > 0 ? cd.F1_Pothole_Restoration_Cost__c : 0; 
         cd.OP_F1_Total_Cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_F1_Fiber_Sub_Cost_Comb_Cost__c) + CDUtility.getValue(cd.OP_F1_Conduit_Sub_Cost_Comb_Cost__c) +  CDUtility.getValue(cd.OP_F1_Handhole_Sub_Cost_Comb_Cost__c) +  CDUtility.getValue(cd.OP_Mob_Sub_Cost_Comb_Cost__c) +  CDUtility.getValue(cd.OP_F1_Splicing_Sub_Cost_Comb_Cost__c) +  CDUtility.getValue(cd.OP_F1_Major_Cross_Sub_Cost_Comb_Cost__c) +  CDUtility.getValue(cd.OP_F1_Pole_Make_Ready_Sub_Cst_Comb_Cst__c) +  CDUtility.getValue(cd.OP_F1_Pole_Anchor_Sub_Cost_Comb_Cost__c) +  CDUtility.getValue(cd.OP_F1_Pothole_Rest_Sub_Cost_Comb_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
         
          if(CDUtility.isValGreaterThanZero(cd.F1_Footage_ft__c) && CDUtility.isValGreaterThanZero(cd.OP_F1_Total_Cost_Comb_Cost__c)) {
              cd.OP_F1_Total_Cost_Cost_ft__c = (cd.OP_F1_Total_Cost_Comb_Cost__c/cd.F1_Footage_ft__c).setScale(2, System.RoundingMode.HALF_UP);
          }else{
              cd.OP_F1_Total_Cost_Cost_ft__c = CDConstants.ZERO;
          }
         if(CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F1_Total_Cost_Comb_Cost__c)) {
              cd.OP_F1_Total_Cost_Cost_LU__c = (cd.OP_F1_Total_Cost_Comb_Cost__c/cd.nbr_of_Living_Units__c).setScale(2, System.RoundingMode.HALF_UP);
         }else{
             cd.OP_F1_Total_Cost_Cost_LU__c = CDConstants.ZERO;
         }
         System.debug('*************** End - doF1OutputCalculations ********************');
          
     }
     //ESCJ-1468
 public Static Void CreateNote(List<Capital_Design__c> capitalDesigns){
     list<ContentVersion> ContVers = new List<ContentVersion>();
      for(Capital_Design__c cd : capitalDesigns){
        ContentVersion objCntNote = new ContentVersion();      
        objCntNote.Title = String.valueOf(System.now());
        objCntNote.PathOnClient = objCntNote.Title + '.snote';
        objCntNote.VersionData = Blob.valueOf(cd.Comments__c);
        objCntNote.FirstPublishLocationId = cd.Id;
        ContVers.add(objCntNote);
             }
        insert ContVers;  
    } 
    // QFCJ-4487
    public static void syncCapitalDesignFieldsOnCreate(List<Capital_Design__c> newCapitalDesigns){

        for(Capital_Design__c newCapitalDesign : newCapitalDesigns){

            // Lets keep the Capital Design Id Field in sync with the Capital Design Name
            newCapitalDesign.capital_design_id__c = newCapitalDesign.name;

            // if created from the SFAINT side I check the sfaint side first because of default values used.
            if(newCapitalDesign.SFAINT_Capital_Design_Type__c != null){
                if(newCapitalDesign.SFAINT_Capital_Design_Type__c == 'Non-Marketing'){
                    newCapitalDesign.Capital_Design_Type__c = 'Non-Marketing';
                } else {
                    newCapitalDesign.Capital_Design_Type__c = 'Standard';
                }
            // if created from the SFCJ side
        } else if(newCapitalDesign.capital_design_type__c != null){
            if(newCapitalDesign.capital_design_type__c == 'Standard'){
                newCapitalDesign.SFAINT_Capital_Design_Type__c = 'Marketing';
            } else {
                newCapitalDesign.SFAINT_Capital_Design_Type__c = 'Non-Marketing';
            }
      }
     }
     
    }
   // QFCJ-4487
    public static void syncCapitalDesignFieldsOnUpdate(List<Capital_Design__c> newCapitalDesigns, Map<Id,Capital_Design__c> oldMap){

            for(Capital_Design__c newCapitalDesign : newCapitalDesigns){
                // get the old set of record values
                Capital_Design__c oldCapitalDesign = oldMap.get(newCapitalDesign.id);
                
             if(newCapitalDesign.name != newCapitalDesign.capital_design_id__c){
                 newCapitalDesign.capital_design_id__c = newCapitalDesign.name;

             }
             // if someone changes the type on SFCJ side
             if(newCapitalDesign.capital_design_type__c != oldCapitalDesign.capital_design_type__c){
                if(newCapitalDesign.capital_design_type__c == 'Standard'){
                    newCapitalDesign.SFAINT_Capital_Design_Type__c = 'Marketing';
                } else {
                    newCapitalDesign.SFAINT_Capital_Design_Type__c = 'Non-Marketing';
                }
                // if someone changes type on the SFAINT side
            } else if(newCapitalDesign.SFAINT_Capital_Design_Type__c != oldCapitalDesign.SFAINT_capital_design_type__c){
                if(newCapitalDesign.SFAINT_Capital_Design_Type__c == 'Non-Marketing'){
                    newCapitalDesign.Capital_Design_Type__c = 'Non-Marketing';
                } else {
                    // just default to standard till there is a reason not to.
                    newCapitalDesign.Capital_Design_Type__c = 'Standard';
                }
            }
          }
        
    }
    
    public static void validateCapitalDesignFieldsOnUpdate(List<Capital_Design__c> newCapitalDesigns, Map<Id,Capital_Design__c> oldMap){
        
        for(Capital_Design__c newCapitalDesign : newCapitalDesigns){
                // get the old set of record values
                Capital_Design__c oldCapitalDesign = oldMap.get(newCapitalDesign.id);
            	system.debug('Stage$$$$'+oldCapitalDesign.Capital_Design_Stage__c+' '+newCapitalDesign.Capital_Design_Stage__c);
            if(oldCapitalDesign.Capital_Design_Stage__c=='Engineer Complete' && newCapitalDesign.Capital_Design_Stage__c=='Engineer Complete'){
                newCapitalDesigns[0].addError('Unable to edit capital design##');
            }
        }
        
    }


}//end class CapitalDesignTriggerHelper