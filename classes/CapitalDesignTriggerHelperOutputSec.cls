/******************************************************************************************************************* 
* @uthor : Lumen.com
* @Class : CapitalDesignTriggerHelperOutputSec
* @ Descriptions : Helper class for calculating Totals
                   for F1, F2, F3, F4 Output Sections 
****************************************************************** 
Author    *          UserStory   *    Date         *       Description 
Ganesh Sirpuram       ESCJ-***        07/03/2022           Output Section calculations 
===============================================================================================
 * Date         Author      UserStory          Description  
 * 08/02/2023   T2Cabato    QFCJ-4286          BRAIN-Drop-Cost-Fix                   
 * 09/13/2023   T2Cabato    QFCJ-4469 		   SmartNID-for-ONT-Total-Cost-Installation
 * 09/22/2023   T2Cabato    QFCJ-4580          Round CCT cost fields results to 2 decimals 
 ***********************************************************************************************/
public class CapitalDesignTriggerHelperOutputSec {
    public static Map<String,StatesCostforCapitalDesign__c> stateDataMap = CapitalDesignCalculationHelper.stateDataMap != NULL && !CapitalDesignCalculationHelper.stateDataMap.isEmpty() ?
         CapitalDesignCalculationHelper.stateDataMap : CapitalDesignCalculationHelper.initializeStateCostMap();
    public static Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontUPSShelfEstDataMap = CapitalDesignCalculationHelper.ontUPSShelfEstDataMap != NULL && !CapitalDesignCalculationHelper.ontUPSShelfEstDataMap.isEmpty() ?
         CapitalDesignCalculationHelper.ontUPSShelfEstDataMap : CapitalDesignCalculationHelper.initializeONTUPSShelfEstimatorMap();  
    public static List<CCT_Cost_Estimator__c> costEstDataListBySFU  = CapitalDesignCalculationHelper.costEstDataListBySFU != NULL && !CapitalDesignCalculationHelper.costEstDataListBySFU.isEmpty() ?
         CapitalDesignCalculationHelper.costEstDataListBySFU : CapitalDesignCalculationHelper.initializeCostEstimatorDataForSFU();
    public static List<CCT_Cost_Estimator__c> costEstDataListByMDU = CapitalDesignCalculationHelper.costEstDataListByMDU != NULL && !CapitalDesignCalculationHelper.costEstDataListByMDU.isEmpty() ?
         CapitalDesignCalculationHelper.costEstDataListByMDU : CapitalDesignCalculationHelper.initializeCostEstimatorDataForMDU();
      
         public static Map<String, String> valuesFromOntModel = new Map<String, String>();
     
     public static void populateOutPutSection(List<Capital_Design__c> capitalDesigns){
          
          
         for(Capital_Design__c cd : capitalDesigns){ 
             StatesCostforCapitalDesign__c stateAllCostsObj = CapitalDesignCalculationHelper.getStateCostObject(cd.Primary_Address_State_Name__c,cd.Property_Address_State__c);
             valuesFromOntModel = CDUtility.getValuesFromOntModel(cd?.ONT_Model__c);
             System.debug('valuesFromOntModel---------------------------------'+valuesFromOntModel);
             String buildingStyle = CDUtility.getBuildStyle(cd.Building_Style__c);
             System.debug('(CDTriggerHelperOutputSec.populateOutPutSection) For CapitalDesignCalculationHelper.getStateCostObject, using cd.Property_Address_State__c = ' + cd.Property_Address_State__c);
             /* ******************** Second row (F3 Fiber Drop Sub-cost) start ************************************/
             //F3 Fiber Drop Sub-cost -> combined cost
             if(!CDUtility.isStringsEqual(buildingStyle, CDConstants.SFU)){
                 cd.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c = CDConstants.ZERO;
             }else{
                 if(cd.F3_Sub_total__c != null && (cd.F3_Sub_total__c == 0 || cd.F3_Sub_total__c == 100)){
                     if(cd.F3_Sub_total_For_cost__c != null && cd.F3_Sub_total_For_cost__c > 0 ){
                          cd.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c = (CDUtility.getValue(cd.F3_Sub_total_For_cost__c)).setScale(2, System.RoundingMode.HALF_UP);
                     }else{
                         decimal f3CostLU = null;
                         if(CDUtility.isStringsEqual(cd.F3_Fiber_Type__c, CDConstants.BURIED)){
                             f3CostLU = CDUtility.getValue(stateAllCostsObj?.F3_Cost_Buried_Cost_LU__c);
                         }else if(CDUtility.isStringsEqual(cd.F3_Fiber_Type__c, CDConstants.AERIAL)){
                             f3CostLU = CDUtility.getValue(stateAllCostsObj?.F3_Cost_Aerial_Cost_LU__c);
                         }
                         decimal f3CostMultiplier = CDUtility.getValue(CDUtility.getF3CostMultiplier(stateAllCostsObj, cd.Project_Type__c, cd.Service_Type__c ));
                         cd.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c = (CDUtility.getValForMultiply(f3CostLU) * CDUtility.getValForMultiply(f3CostMultiplier) * CDUtility.getValForMultiply(CDUtility.getAdjstdnbrLivingUnits(cd))).setScale(2, System.RoundingMode.HALF_UP);
                     }
                 }else{
                     cd.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c = null; 
                 }
             }
             
             //F3 Fiber Drop Sub-cost -> Cost/LU
             if(cd.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c != null && CDUtility.getAdjstdnbrLivingUnits(cd)!=NULL && CDUtility.isValGreaterThanZero(CDUtility.getAdjstdnbrLivingUnits(cd))){
                 cd.OP_F3_Fiber_Drop_Sub_Cost_LU__c = (CDUtility.getValue(cd.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c) / CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP);
             }else{
                 cd.OP_F3_Fiber_Drop_Sub_Cost_LU__c = null;
             }
             /* ******************** Second row (F3 Fiber Drop Sub-cost ->) End ************************************/
             
             
              /* ******************** Third row (F3 Fiber Stub Sub-cost -> ->) start ************************************/
             
             //F3 Fiber Stub Sub-cost -> Unit
             if(CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE)){
                     if(cd.F2_nbr_of_IDF_locations__c != null){
                        cd.OP_F3_Fiber_Stub_Sub_Cost_Unit__c = (CDUtility.getValue(cd.F2_nbr_of_IDF_locations__c)).setScale(0, System.RoundingMode.HALF_UP);
                         //Updated for Bug-676 and added I75
                     }else if(CDUtility.getOvrrdF2nbrIDFlocations(cd) !=NULL ){
                         cd.OP_F3_Fiber_Stub_Sub_Cost_Unit__c = (CDUtility.getOvrrdF2nbrIDFlocations(cd)).setScale(0, System.RoundingMode.HALF_UP);
                     }
             }else{
                 cd.OP_F3_Fiber_Stub_Sub_Cost_Unit__c = CDConstants.ZERO;
             }
                          
             // F3 Fiber Stub Sub-cost -> Sub-unit
             if(CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE)){
               //      String adjustedOntModel = CDUtility.getAdjustedOntModel(cd.ONT_Model__c);
                	 String locationFromOntModel = valuesFromOntModel?.get('ontmodel');
                     System.debug('ONTMODEL is -----------------------------------'+valuesFromOntModel?.get('ontmodel'));
                     decimal quotient = 0;
                     if(CDUtility.isValGreaterThanZero(cd.OP_F3_Fiber_Stub_Sub_Cost_Unit__c)){
                         quotient = (CDUtility.getAdjstdnbrLivingUnits(cd) / cd.OP_F3_Fiber_Stub_Sub_Cost_Unit__c).setScale(2, System.RoundingMode.HALF_UP);
                     }
                     cd.OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c = CDUtility.getNumForOntModel(locationFromOntModel, quotient);
             }else{
                 cd.OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c = CDConstants.ZERO;
             }
     
             // F3 Fiber Stub Sub-cost -> Installation
             if(CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE)){
                     //*
                     //cd.OP_F3_Fiber_Stub_Sub_Cost_Installation__c = OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c */
                     system.debug(' cd.OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c curr test 1: '+cd.OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c);
                     if(cd.OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c != null){
                         decimal stubValue = CDUtility.getStubFromStateCost(stateAllCostsObj, cd.OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c);
                         if(CDUtility.isValGreaterThanZero(stubValue)){
                             cd.OP_F3_Fiber_Stub_Sub_Cost_Installation__c = (CDUtility.getValue(cd.OP_F3_Fiber_Stub_Sub_Cost_Unit__c) * stubValue).setScale(2, System.RoundingMode.HALF_UP);
                         }
                     }else{
                         cd.OP_F3_Fiber_Stub_Sub_Cost_Installation__c = CDConstants.ZERO;
                     }
             }else{
                 cd.OP_F3_Fiber_Stub_Sub_Cost_Installation__c = CDConstants.ZERO;
             }
            
             // F3 Fiber Stub Sub-cost -> Overhead
             if(CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE)){
                 if(CDUtility.isValGreaterThanZero(cd.OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c)){
                     if(cd.OP_F3_Fiber_Stub_Sub_Cost_Material__c != null && stateAllCostsObj?.OC_General_Multiplier__c != null){
                         cd.OP_F3_Fiber_Stub_Sub_Cost_Overhead__c = (CDUtility.getValue(cd.OP_F3_Fiber_Stub_Sub_Cost_Material__c) * (CDUtility.getValue(stateAllCostsObj?.OC_General_Multiplier__c) - 1)).setScale(2, System.RoundingMode.HALF_UP);
                     }
                 }else{
                     cd.OP_F3_Fiber_Stub_Sub_Cost_Overhead__c = CDConstants.ZERO;
                 }
             }else{
                 cd.OP_F3_Fiber_Stub_Sub_Cost_Overhead__c = CDConstants.ZERO;
             }
            
             // F3 Fiber Stub Sub-cost -> Material
             if(CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE)){
                 if(CDUtility.isValGreaterThanZero(cd.OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c)){
                     decimal f2StubMatCost = CDConstants.ZERO;
                     List<CCT_F2_Stub_Estimator__c> f2StubEstList = CapitalDesignCalculationHelper.getF2StubEstBySubUnit(cd.OP_F3_Fiber_Stub_Sub_Cost_Sub_Unit__c);
                     if(f2StubEstList!= null && f2StubEstList.size() > 0 ){
                         CCT_F2_Stub_Estimator__c f2StubEst = f2StubEstList[0];
                         f2StubMatCost = CDUtility.getValue(f2StubEst?.F2_STUBE_Material_Cost__c);
                     }
                     if( CDUtility.isValGreaterThanZero(f2StubMatCost) && cd.OP_F3_Fiber_Stub_Sub_Cost_Unit__c != null){
                         cd.OP_F3_Fiber_Stub_Sub_Cost_Material__c = (cd.OP_F3_Fiber_Stub_Sub_Cost_Unit__c * f2StubMatCost).setScale(2, System.RoundingMode.HALF_UP);//mult by material cost
                     }
                 }else{
                     cd.OP_F3_Fiber_Stub_Sub_Cost_Material__c = CDConstants.ZERO;
                 }
             }else{
                 cd.OP_F3_Fiber_Stub_Sub_Cost_Material__c = CDConstants.ZERO;
             }
             
             //F3 Fiber Stub Sub-cost -> combined cost
             if(!CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE)){
                 cd.OP_F3_Fiber_Stub_Sub_Cost_Comb_Cost__c = CDConstants.ZERO;
             }else{
                 cd.OP_F3_Fiber_Stub_Sub_Cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_F3_Fiber_Stub_Sub_Cost_Material__c)  
                     + CDUtility.getValue(cd.OP_F3_Fiber_Stub_Sub_Cost_Overhead__c) + CDUtility.getValue(cd.OP_F3_Fiber_Stub_Sub_Cost_Installation__c)).setScale(2, System.RoundingMode.HALF_UP);
             }
             
             //F3 Fiber Stub Sub-cost -> cost/LU
             if(cd.OP_F3_Fiber_Stub_Sub_Cost_Comb_Cost__c != null && CDUtility.isValGreaterThanZero(CDUtility.getAdjstdnbrLivingUnits(cd))){
                 cd.OP_F3_Fiber_Stub_Sub_Cost_LU__c = (cd.OP_F3_Fiber_Stub_Sub_Cost_Comb_Cost__c / CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP);
             }else{
                 cd.OP_F3_Fiber_Stub_Sub_Cost_LU__c = null;
             }
             
             /********************* Third row (F3 Fiber Drop Sub-cost) End ************************************/
             
             
             /********************* Fourth row (F3 Slack-Box Sub-cost ->) Start ************************************/
             //F3 Slack-Box Sub-cost -> Combined Cost
             if(!CDUtility.isStringsEqual(buildingStyle, CDConstants.SFU)){
                 cd.OP_F3_Slack_Box_Sub_Cost_Comb_Cost__c = CDConstants.ZERO;
             }else{
                 //talk to shobit get the field name for the field "F3 Slack Box Cost:" $D112
                 if(cd.F3_related_cost_for_slack_box_cost__c != null){ //if it a number
                     cd.OP_F3_Slack_Box_Sub_Cost_Comb_Cost__c = (cd.F3_related_cost_for_slack_box_cost__c).setScale(2, System.RoundingMode.HALF_UP);
                 }
                 
                 
                     //for BUG ESCJ-676, adding I112 Scenario if D112 is blank
                 
                 else if(cd.F3_Sub_total__c == CDConstants.HUNDRED && stateDataMap.containsKey(cd.Property_Address_State__c)){
                     if(StateDataMap.get(cd.Property_Address_State__c).F3_Cost_LU_LE_Slack_box__c!=null && CDUtility.getAdjstdnbrLivingUnits(cd) != null){
                         cd.OP_F3_Slack_Box_Sub_Cost_Comb_Cost__c = (StateDataMap.get(cd.Property_Address_State__c).F3_Cost_LU_LE_Slack_box__c*CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP); 
                     }   
                 }
                 //End of logic for I112
                 
                 
                 else{
                     cd.OP_F3_Slack_Box_Sub_Cost_Comb_Cost__c = CDConstants.ZERO;
                 }
             }
             
             //F3 Slack-Box Sub-cost -> Cost/LU
             if(cd.OP_F3_Slack_Box_Sub_Cost_Comb_Cost__c != null && CDUtility.isValGreaterThanZero(CDUtility.getAdjstdnbrLivingUnits(cd) )){
                 cd.OP_F3_Slack_Box_Sub_Cost_LU__c = (cd.OP_F3_Slack_Box_Sub_Cost_Comb_Cost__c / CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP);
             }else{
                 cd.OP_F3_Slack_Box_Sub_Cost_LU__c = null;
             }
             /********************* Fourth row (F3 Slack-Box Sub-cost ->) End ************************************/
             
              /* ******************** First row (F3 Total-cost ->) start ************************************/
             //F3 Total Cost -> Combined cost
             cd.OP_F3_Total_Cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_F3_Fiber_Drop_Sub_Cost_Comb_Cost__c) +  CDUtility.getValue(cd.OP_F3_Fiber_Stub_Sub_Cost_Comb_Cost__C)
                 + CDUtility.getValue(cd.OP_F3_Slack_Box_Sub_Cost_Comb_Cost__C)).setScale(2, System.RoundingMode.HALF_UP);
             
             //F3 Total Cost Combined ->  Cost/LU
             if(CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && cd.OP_F3_Total_Cost_Comb_Cost__c != null && CDUtility.isValGreaterThanZero(CDUtility.getAdjstdnbrLivingUnits(cd))){
                 cd.OP_F3_Total_Cost_LU__c =  (CDUtility.getValue(cd.OP_F3_Total_Cost_Comb_Cost__c) / CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP);
             }
             /* ******************** First row (F3 Total-cost ->) end ************************************/
             
             
             /***************************** Row 1 starts for (F4 Total-cost ) **************************/
             
             //F4 Total-cost -> combined cost
             String adjustedOntModel = CDUtility.getAdjustedOntModel(cd.ONT_Model__c); 
             String ontModel = valuesFromOntModel?.get('ontmodel'); 
             System.debug('adjustedOntModel-----------------------------------------'+adjustedOntModel);
             System.debug('Location is -----------------------------------'+valuesFromOntModel?.get('ontmodel'));
             if(CDUtility.isStringsEqual(cd.F4_Fiber_Type__c, CDConstants.NO_DROP) || CDUtility.isStringsEqual(ontModel, CDConstants.FTTIDF) ){
                 cd.OP_F4_Total_Cost_Comb_Cost__c = CDConstants.ZERO;
             }else{   
                 //to odentify which Installation type need to use I26
                 String installType = CDConstants.CTL_INSTALL;
                 if((cd.CTL_to_install_F4__c == false) || CDUtility.isStringsEqual(cd.F4_Fiber_Type__c, CDConstants.CTL_PROV_DUCT)){
                     installType = CDConstants.DEV_INSTALL;
                     System.debug('installType--'+installType);
                 }  
                 decimal f4Cost = null;
                 if(cd.Project_Type__c != null && cd.F4_Fiber_Type__c != null){
                     f4Cost = (CDUtility.getValue(CDUtility.getF4CostBasedOnBuildAndInstallType(cd, installType, stateAllCostsObj))).setScale(2, System.RoundingMode.HALF_UP);
                     System.debug('f4Cost---'+f4Cost);
                 }
                 //finally calculate the value
                 if(f4Cost != null && CDUtility.getAdjstdnbrLivingUnits(cd) != null){
                     	System.debug('CDUtility.getAdjstdnbrLivingUnits(cd)---'+CDUtility.getAdjstdnbrLivingUnits(cd));
                        cd.OP_F4_Total_Cost_Comb_Cost__c = (CDUtility.getValue(f4Cost) *  CDUtility.getValue(CDUtility.getAdjstdnbrLivingUnits(cd))).setScale(2, System.RoundingMode.HALF_UP);
                 }
            }//close else part of No Drop
             
            //F4 Total-cost -> Cost/LU
            if(cd.OP_F4_Total_Cost_Comb_Cost__c  != null && CDUtility.isValGreaterThanZero(CDUtility.getAdjstdnbrLivingUnits(cd))) {
                 cd.OP_F4_Total_Cost_LU__c = (cd.OP_F4_Total_Cost_Comb_Cost__c / CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP);
            }      
             
            /***************************** Row 1 Ends for (F4 Total-cost ) **************************/ 
            
            /***************************** Row 2 starts for (ONT Total-cost ) **************************/
             //ONT Total-cost -> Sub-unit 
             System.debug('BEGIN of ONT Total Cost Calculation: ontModel = ' + cd?.ONT_Model__c + '  AND isSmartNID = ' + (CDUtility.isOntEstModelSmartNID(cd?.ONT_Model__c, ontUPSShelfEstDataMap)));
             boolean isOntBuildStyleOn = CDUtility.isOntEstBuildingStyleOn(cd.ONT_Model__c, buildingStyle, ontUPSShelfEstDataMap);
             boolean isOntBuildStyle = CDUtility.isOntEstBuildingStyle(cd.ONT_Model__c, buildingStyle, ontUPSShelfEstDataMap); //ESCJ-1471 BUG FIX.
             System.debug('isOntBuildStyleOn = ' + isOntBuildStyleOn + '   AND isOntBuildStyle = ' + isOntBuildStyle);
             if(isOntBuildStyleOn){
                 decimal luPerOnt = null;
                 if(!CDUtility.isStringsEqual(buildingStyle, CDConstants.SFU)){
                     CCT_ONT_UPS_Shelf_Estimator__c ontShelfEst = CDUtility.getEstByOntModel(cd.ONT_Model__c, ontUPSShelfEstDataMap); 
                     if(ontShelfEst != null){
                         luPerOnt = ontShelfEst?.ONT_LU_per_ONT__c;
                     }
                 }else{
                     luPerOnt = CDConstants.ONE;
                 }
                // if(cd.nbr_of_Living_Units__c != null && CDUtility.isValGreaterThanZero(luPerOnt)){
                  //   cd.OP_ONT_Total_Cost_Sub_Unit__c = (cd.nbr_of_Living_Units__c / luPerOnt).round(System.RoundingMode.UP);
                 //}
                 //*FOR ESCJ-676, INSTEAD OF D16, I16
                 if(CDUtility.getAdjstdnbrLivingUnits(cd) != null && CDUtility.isValGreaterThanZero(luPerOnt)){
                     cd.OP_ONT_Total_Cost_Sub_Unit__c = (CDUtility.getAdjstdnbrLivingUnits(cd)/ luPerOnt).setScale(0, System.RoundingMode.HALF_UP);
                 }
                 //END OF I16 LOGIC
                 else
                 {
                     cd.OP_ONT_Total_Cost_Sub_Unit__c = CDConstants.ZERO;
                 }
             }else
                 {
                     cd.OP_ONT_Total_Cost_Sub_Unit__c = CDConstants.ZERO;
                 }
               
             //ONT Total-cost -> Unit 
             if(CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE)){
                 try{
                     decimal quotient = null;
                     if(cd.OP_ONT_Total_Cost_Sub_Unit__c != null && CDUtility.isValGreaterThanZero(cd.for_MDU_nbr_of_Buildings__c)){
                         quotient = (cd.OP_ONT_Total_Cost_Sub_Unit__c / cd.for_MDU_nbr_of_Buildings__c).setScale(0, System.RoundingMode.HALF_UP);
                     }
                     if(cd.for_MDU_nbr_of_Buildings__c != null && quotient != null){
                          cd.OP_ONT_Total_Cost_Unit__c = (quotient * cd.for_MDU_nbr_of_Buildings__c).setScale(0, System.RoundingMode.HALF_UP);
                     }
                 }catch(Exception e){
                     system.debug(' exception while doing round up for Ont Total Cost Unit '+e.getMessage());
                 } 
             }else{
                 cd.OP_ONT_Total_Cost_Unit__c = (CDUtility.getValue(cd.OP_ONT_Total_Cost_Sub_Unit__c)).setScale(0, System.RoundingMode.HALF_UP);
             }
             
            //ONT Total-cost -> Material
             if(cd.ONT_Model__c != null){
                 decimal ontMateCost = (CDUtility.getValue(CDUtility.getOntMaterialCost(cd.ONT_Model__c, buildingStyle, ontUPSShelfEstDataMap))).setScale(2, System.RoundingMode.HALF_UP);
                 System.debug(ontMateCost);
                 if(cd.OP_ONT_Total_Cost_Unit__c != null && ontMateCost != null){
                     cd.OP_ONT_Total_Cost_Material__c = (CDUtility.getValue(cd.OP_ONT_Total_Cost_Unit__c) * ontMateCost).setScale(2, System.RoundingMode.HALF_UP);
                     decimal totalOntCostMaterail = (CDUtility.getValue(cd.OP_ONT_Total_Cost_Unit__c) * ontMateCost).setScale(2, System.RoundingMode.HALF_UP);
                     if(!cd.Building_Style__c.contains('SFU')){
                          cd.OP_ONT_Total_Cost_Material__c = (totalOntCostMaterail + (cd.OP_ONT_Total_Cost_Unit__c * 15)).setScale(2, System.RoundingMode.HALF_UP);
                     }
                 }else
                 {
                     cd.OP_ONT_Total_Cost_Material__c = CDConstants.ZERO;
                 }
             }
             
             
             //ONT Total-cost -> Overhead
             if(CDUtility.isValGreaterThanZero(cd.OP_ONT_Total_Cost_Unit__c)){
                 if(stateAllCostsObj != null) {
                    if(cd.OP_ONT_Total_Cost_Material__c != null && stateAllCostsObj?.OC_ONT_Multiplier__c != null){
                         cd.OP_ONT_Total_Cost_Overhead__c = (CDUtility.getValue(cd.OP_ONT_Total_Cost_Material__c) * (stateAllCostsObj?.OC_ONT_Multiplier__c - 1)).setScale(2, System.RoundingMode.HALF_UP);    
                    }   
                 }
             }else{
                 cd.OP_ONT_Total_Cost_Overhead__c = 0;    
             }
             
             //ONT Total-cost -> Installation  //need to discuss j24 value
             //QFCJ-4469 SmartNID for ONT Installation -- need to add the stateAllCostsObj?.IC_ONT__c together with the stateAllCostsObj?.IC_Gateway_FTTU__c
             System.debug('REMINDER before determining OP_ONT_Total_Cost_Installation: isOntBuildStyleOn = ' + isOntBuildStyleOn + '   AND isOntBuildStyle = ' + isOntBuildStyle + '   AND isSmartNID = ' + (CDUtility.isOntEstModelSmartNID(cd?.ONT_Model__c, ontUPSShelfEstDataMap)));
             if(CDUtility.isValGreaterThanZero(cd.OP_ONT_Total_Cost_Unit__c)){
                 isOntBuildStyleOn = CDUtility.isOntEstBuildingStyleOn(cd.ONT_Model__c, buildingStyle, ontUPSShelfEstDataMap);
                 decimal unitInstallCost = null;
                 if(isOntBuildStyleOn){
                     if(cd.OP_ONT_Total_Cost_Unit__c != null && stateAllCostsObj?.IC_ONT__c != null){
	                      System.debug('CDUtility.getValue(cd.OP_ONT_Total_Cost_Unit__c)--'+CDUtility.getValue(cd.OP_ONT_Total_Cost_Unit__c));
	                      System.debug('CDUtility.getValue(stateAllCostsObj?.IC_ONT__c--'+CDUtility.getValue(stateAllCostsObj?.IC_ONT__c));
                         unitInstallCost = (CDUtility.getValue(cd.OP_ONT_Total_Cost_Unit__c) * CDUtility.getValue(stateAllCostsObj?.IC_ONT__c)).setScale(2, System.RoundingMode.HALF_UP);
                     }
                 }
                 
                 decimal valToBeAdded = null;
                 //Ont model
                 System.debug('Location is -----------------------------------'+valuesFromOntModel?.get('location'));
                 //adjustedOntModel = CDUtility.getAdjustedOntModel(cd.ONT_Model__c);
                 if(CDUtility.isStringsEqual(valuesFromOntModel?.get('gateway'), CDConstants.INTEGRATED)) {
                     if (CDUtility.isOntEstModelSmartNID(cd?.ONT_Model__c, ontUPSShelfEstDataMap)) {
                         if(CDUtility.isStringsEqual(valuesFromOntModel?.get('ontmodel'), CDConstants.FTTU)) {                             
                              System.debug('CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Unit__c) --> '+CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Unit__c));
                              System.debug('CDUtility.getValue(stateAllCostsObj?.IC_Gateway_FTTU__c --> '+CDUtility.getValue(stateAllCostsObj?.IC_Gateway_FTTU__c));
                             valToBeAdded = (CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Unit__c) * CDUtility.getValue(stateAllCostsObj?.IC_Gateway_FTTU__c)).setScale(2, System.RoundingMode.HALF_UP);
                         }
                     } else {
	                     valToBeAdded = 0;
                     }
                 }else{
                      decimal gatwayCost = null;
                 		System.debug('ontModel is -----------------------------------'+valuesFromOntModel?.get('ontmodel'));
                         if(CDUtility.isStringsEqual(valuesFromOntModel?.get('ontmodel'), CDConstants.FTTU)){
                             gatwayCost = (CDUtility.getValue(stateAllCostsObj?.IC_Gateway_FTTU__c)).setScale(2, System.RoundingMode.HALF_UP);
                         } else if(CDUtility.isStringsEqual(valuesFromOntModel?.get('ontmodel'), CDConstants.FTTB)){
                              gatwayCost = (CDUtility.getValue(stateAllCostsObj?.IC_Gateway_FTTB__c)).setScale(2, System.RoundingMode.HALF_UP);
                         }else{
                             gatwayCost = CDUtility.getValue(stateAllCostsObj?.IC_Gateway_FTTIDF__c).setScale(2, System.RoundingMode.HALF_UP);
                         }
                     if(gatwayCost != null && cd.OP_Res_Gateway_Total_Cost_Unit__c != null){
                         valToBeAdded = (CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Unit__c) * gatwayCost).setScale(2, System.RoundingMode.HALF_UP);
                     }
                 }
                 
                 System.debug('PRIOR to Setting OP_ONT_Total_Cost_Installation__c, unitInstallCost = ' + unitInstallCost + '   AND valToBeAdded = ' + valToBeAdded);
                 if(unitInstallCost != null){
                     cd.OP_ONT_Total_Cost_Installation__c = unitInstallCost;
                 }
                 if(valToBeAdded != null) {
                     cd.OP_ONT_Total_Cost_Installation__c = (CDUtility.getValue(cd.OP_ONT_Total_Cost_Installation__c) + valToBeAdded).setScale(2, System.RoundingMode.HALF_UP);
                 }
             }else{
                 cd.OP_ONT_Total_Cost_Installation__c = CDConstants.ZERO;  
             }
             System.debug('Final OP_ONT_Total_Cost_Installation__c = ' + cd.OP_ONT_Total_Cost_Installation__c);
          
 
            //ONT Total-cost -> combined cost
             if(!(cd.OP_ONT_Total_Cost_Material__c == null && cd.OP_ONT_Total_Cost_Overhead__c == null && cd.OP_ONT_Total_Cost_Installation__c == null)){
                    cd.OP_ONT_Total_Cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_ONT_Total_Cost_Material__c) + CDUtility.getValue(cd.OP_ONT_Total_Cost_Overhead__c) + CDUtility.getValue(cd.OP_ONT_Total_Cost_Installation__c)).setScale(2, System.RoundingMode.HALF_UP);
             }
           
           //ONT Total-cost -> cost/LU
           if(cd.OP_ONT_Total_Cost_Comb_Cost__c  != null && CDUtility.isValGreaterThanZero(CDUtility.getAdjstdnbrLivingUnits(cd))) {
                 cd.OP_ONT_Total_Cost_LU__c = (cd.OP_ONT_Total_Cost_Comb_Cost__c / CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP);
            } 
             
           /***************************** Row 2 Ends for (ONT Total-cost) **************************/
           
             
           /***************************** Row 3 Starts for (UPS+Shelf Total-cost) **************************/
           //UPS+Shelf Total-cost -> Sub Unit
            isOntBuildStyleOn = CDUtility.isOntEstBuildingStyleOn(cd.ONT_Model__c, buildingStyle, ontUPSShelfEstDataMap);
            isOntBuildStyle = CDUtility.isOntEstBuildingStyle(cd.ONT_Model__c, buildingStyle, ontUPSShelfEstDataMap); //ESCJ-1471 BUG FIX.
            System.debug('Location is -----------------------------------'+valuesFromOntModel?.get('ontmodel'));
            if(CDUtility.isStringsEqual(valuesFromOntModel?.get('ontmodel'), CDConstants.FTTU) || CDUtility.isStringsEqual(buildingStyle, CDConstants.SFU)){
                 cd.OP_UPS_Shelf_Total_Cost_Sub_Unit__c = CDConstants.ZERO;	
            }else if(isOntBuildStyleOn && isOntBuildStyle){
                decimal luPerUps = null;
                CCT_ONT_UPS_Shelf_Estimator__c ontShelfEst = CDUtility.getEstByOntModel(cd.ONT_Model__c, ontUPSShelfEstDataMap); 
                if(ontShelfEst != null){
                    luPerUps = CDUtility.getValue(ontShelfEst?.LU_per_UPS__c);
                }
                //FOR ESCJ-676, I16 VALUE IS UPDATED INSTEAD OF D16
                if(CDUtility.getAdjstdnbrLivingUnits(cd) !=NULL && (luPerUps != null && luPerUps > 0)){
                    cd.OP_UPS_Shelf_Total_Cost_Sub_Unit__c = (CDUtility.getAdjstdnbrLivingUnits(cd)/ luPerUps).setScale(0, System.RoundingMode.HALF_UP);
                }
            }else{
                cd.OP_UPS_Shelf_Total_Cost_Sub_Unit__c = CDConstants.ZERO;	 
            }
  
            //UPS+Shelf Total-cost -> Unit
             decimal totalVal = null;
             if(CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE)){
                 totalVal = CDConstants.ONE;
             }else{
                 totalVal = (CDUtility.getValue(cd.for_MDU_nbr_of_Buildings__c)).setScale(0, System.RoundingMode.HALF_UP);
             }
             decimal valBasedInOntModel = null;
             //adjustedOntModel = CDUtility.getAdjustedOntModel(cd.ONT_Model__c);
             System.debug('ONT Model is -----------------------------------'+valuesFromOntModel?.get('ontmodel'));
             if(CDUtility.isStringsEqual(valuesFromOntModel?.get('ontmodel'), CDConstants.FTTU) || CDUtility.isStringsEqual(buildingStyle, CDConstants.SFU)){
                 valBasedInOntModel = CDConstants.ZERO;	
             }else if(cd.F2_nbr_of_IDF_locations__c != null){
                 if(cd.F2_nbr_of_IDF_locations__c > cd.OP_UPS_Shelf_Total_Cost_Sub_Unit__c){
                     valBasedInOntModel = (CDUtility.getValue(cd.F2_nbr_of_IDF_locations__c)).setScale(0, System.RoundingMode.HALF_UP);
                 }else{
                     valBasedInOntModel = (CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Sub_Unit__c)).setScale(0, System.RoundingMode.HALF_UP);
                 }
             }else if(CDUtility.isStringsEqual(buildingStyle, CDConstants.MIDRISE) && (cd.Are_there_IDF__c == 'No')){
                     valBasedInOntModel = (CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Sub_Unit__c)).setScale(0, System.RoundingMode.HALF_UP);
             }else if(CDUtility.getValue(CDUtility.getOvrrdF2nbrIDFlocations(cd)) > CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Sub_Unit__c)){
                 valBasedInOntModel = (CDUtility.getOvrrdF2nbrIDFlocations(cd)).setScale(0, System.RoundingMode.HALF_UP);
             }else{
                 try{
                     decimal quotient = null;
                     if(cd.OP_ONT_Total_Cost_Unit__c != null && CDUtility.isValGreaterThanZero(cd.for_MDU_nbr_of_Buildings__c)){
                         quotient = ((cd.OP_ONT_Total_Cost_Unit__c / cd.for_MDU_nbr_of_Buildings__c) / 4).setScale(2, System.RoundingMode.HALF_UP);
                     }
                     if(quotient != null){
                          valBasedInOntModel = (quotient * CDUtility.getValue(cd.for_MDU_nbr_of_Buildings__c)).setScale(0, System.RoundingMode.HALF_UP);
                     }
                 }catch(Exception e){
                     system.debug(' exception while doing round up for UPS Shelf Total Cost -> Unit '+e.getMessage());
                 } 
             }
             
            cd.OP_UPS_Shelf_Total_Cost_Unit__c = (CDUtility.getValue(totalVal) + CDUtility.getValue(valBasedInOntModel)).setScale(0, System.RoundingMode.HALF_UP);
             System.debug('CDUtility.getValue(totalVal)'+CDUtility.getValue(totalVal));
             
             
            //UPS+Shelf Total-cost -> Material
             if(CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Unit__c) == CDConstants.Zero){
                 cd.OP_UPS_Shelf_Total_Cost_Material__c = CDConstants.Zero;
             }else{
                 isOntBuildStyleOn = CDUtility.isOntEstBuildingStyleOn(cd.ONT_Model__c, buildingStyle, ontUPSShelfEstDataMap);
                 isOntBuildStyle = CDUtility.isOntEstBuildingStyle(cd.ONT_Model__c, buildingStyle, ontUPSShelfEstDataMap); //ESCJ-1471 BUG FIX.
                 if(isOntBuildStyleOn && isOntBuildStyle){  //ESCJ-1471 BUG FIX.
                    CCT_ONT_UPS_Shelf_Estimator__c ontShelfEst = CDUtility.getEstByOntModel(cd.ONT_Model__c, ontUPSShelfEstDataMap);
                    //initializeONTUPSShelfEstimatorMap                  
                         if(ontShelfEst != null){
                            decimal costUnitAndUpsCost = (CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Unit__c) * CDUtility.getValue(ontShelfEst.UPS_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
                            decimal costUnitAndShelfCost = (CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Unit__c) * CDUtility.getValue(ontShelfEst.Shelf_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
                            cd.OP_UPS_Shelf_Total_Cost_Material__c = (CDUtility.getValue(costUnitAndUpsCost) + CDUtility.getValue(costUnitAndShelfCost)).setScale(2, System.RoundingMode.HALF_UP);
                         }
                 }
                 else{

                     cd.OP_UPS_Shelf_Total_Cost_Material__c = CDConstants.Zero;  //ESCJ-1471 BUG FIX.

                 }
             }
             
             //UPS+Shelf Total-cost -> Overhead
             if(CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Unit__c) == CDConstants.Zero){
                 cd.OP_UPS_Shelf_Total_Cost_Overhead__c = CDConstants.Zero;
             }else if(CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Unit__c) > 0) {
                 if(!(stateAllCostsObj == null && cd.OP_UPS_Shelf_Total_Cost_Material__c == null)) {
                     cd.OP_UPS_Shelf_Total_Cost_Overhead__c = (CDUtility.getValForMultiply(cd.OP_UPS_Shelf_Total_Cost_Material__c)  
                                                             * (CDUtility.getValue(stateAllCostsObj?.OC_RG_UPS_Media_Multiplier__c) - 1)).setScale(2, System.RoundingMode.HALF_UP);
                 }
             }else{
                 cd.OP_UPS_Shelf_Total_Cost_Overhead__c = CDConstants.Zero;        
             }
             
           //UPS+Shelf Total-cost -> Installation
           if(CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Unit__c) == CDConstants.Zero){
                   //cd.OP_UPS_Shelf_Total_Cost_Unit__c = CDConstants.Zero;
               	   cd.OP_UPS_Shelf_Total_Cost_Installation__c = CDConstants.Zero;
           }else{
               isOntBuildStyleOn = CDUtility.isOntEstBuildingStyleOn(cd.ONT_Model__c, buildingStyle, ontUPSShelfEstDataMap);
               isOntBuildStyle = CDUtility.isOntEstBuildingStyle(cd.ONT_Model__c, buildingStyle, ontUPSShelfEstDataMap);  //ESCJ-1471 BUG FIX. 
               if(isOntBuildStyleOn && isOntBuildStyle){  //ESCJ-1471 BUG FIX.
                     decimal icUPSShelf = null;
                     //FOR ESCJ-1323
                     //adjustedOntModel = CDUtility.getONTModel(cd.ONT_Model__c);
                     System.debug('Location is -----------------------------------'+valuesFromOntModel?.get('location'));
                     if(CDUtility.isStringsEqual(valuesFromOntModel?.get('location'), CDConstants.INDOOR)){
                         icUPSShelf = CDUtility.getValue(stateAllCostsObj?.IC_UPS_shelf_In__c);
                         System.debug('icUPSShelf INDOOR....'+icUPSShelf);
                     }else{
                         icUPSShelf = CDUtility.getValue(stateAllCostsObj?.IC_UPS_Shelf_Out__c);
                         System.debug('icUPSShelf OUTDOOR....'+icUPSShelf);
                     }
                     if(icUPSShelf != null && cd.OP_UPS_Shelf_Total_Cost_Unit__c != null){
                         cd.OP_UPS_Shelf_Total_Cost_Installation__c = (icUPSShelf * cd.OP_UPS_Shelf_Total_Cost_Unit__c).setScale(2, System.RoundingMode.HALF_UP);
                     }
                 }else{
                   cd.OP_UPS_Shelf_Total_Cost_Installation__c = CDConstants.Zero;          
                 }
           }
 
         //UPS+Shelf Total-cost -> combined cost
             if(CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Unit__c) == CDConstants.Zero){
                 cd.OP_UPS_Shelf_Total_Cost_Comb_Cost__c = CDConstants.Zero;
             }else{
                 if(!(cd.OP_UPS_Shelf_Total_Cost_Material__c == null && cd.OP_UPS_Shelf_Total_Cost_Overhead__c == null
                    && cd.OP_UPS_Shelf_Total_Cost_Installation__c == null)){
                      cd.OP_UPS_Shelf_Total_Cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Material__c) +
                           CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Overhead__c) + CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Installation__c)).setScale(2, System.RoundingMode.HALF_UP);   
                    }
             }
   
           //UPS+Shelf Total-cost -> cost/LU
           if(cd.OP_UPS_Shelf_Total_Cost_Comb_Cost__c  != null && CDUtility.isValGreaterThanZero(CDUtility.getAdjstdnbrLivingUnits(cd))) {
                 cd.OP_UPS_Shelf_Total_Cost_LU__c = (cd.OP_UPS_Shelf_Total_Cost_Comb_Cost__c / CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP);
            } 
             
           /***************************** Row 3 Ends for (UPS+Shelf Total-cost ) **************************/
           
             
          /***************************** Row 4 Starts for (Residential Gateway (WiFi) Total-cost ) **************************/
             
                    
          //ResGateway Total-cost -> Unit
          System.debug('BEGIN of Residential Gateway OutputSection Calculation: ontModel = ' + cd?.ONT_Model__c + '  AND isSmartNID = ' + (CDUtility.isOntEstModelSmartNID(cd?.ONT_Model__c, ontUPSShelfEstDataMap)));
          System.debug('Gateway is -----------------------------------'+valuesFromOntModel?.get('gateway'));
          if(CDUtility.isStringsEqual(valuesFromOntModel?.get('gateway'), CDConstants.INTEGRATED)){
          	  if (CDUtility.isOntEstModelSmartNID(cd?.ONT_Model__c, ontUPSShelfEstDataMap)) {
              	cd.OP_Res_Gateway_Total_Cost_Unit__c = (CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(0, System.RoundingMode.HALF_UP); //set value for I16              	    
              } else {
				cd.OP_Res_Gateway_Total_Cost_Unit__c = CDConstants.Zero;
              }
          } else { 
              	cd.OP_Res_Gateway_Total_Cost_Unit__c = (CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(0, System.RoundingMode.HALF_UP); //set value for I16
          }
       
          //ResGateway Total-cost -> Material  
          System.debug('valuesFromOntModel?.get("gateway")[' + (valuesFromOntModel?.get('gateway')) + '] == CDConstants.INTEGRATED[' + CDConstants.INTEGRATED + ']? ' + (CDUtility.isStringsEqual(valuesFromOntModel?.get('gateway'), CDConstants.INTEGRATED)));
          if (CDUtility.isStringsEqual(valuesFromOntModel?.get('gateway'), CDConstants.INTEGRATED)) {
          	  if (CDUtility.isOntEstModelSmartNID(cd?.ONT_Model__c, ontUPSShelfEstDataMap)) {
                  	decimal matCostRG = null;
              	    CCT_Cost_Estimator__c costEstRG = CapitalDesignCalculationHelper.getCostEstimatorByRGCostModel(CDConstants.SMART_NID_BASE_RG_COST_MODEL);
                     if (costEstRG != null) {
                        matCostRG = (CDUtility.getValue(costEstRG.RG_Cost_Material_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
                     }
                     if (cd.OP_Res_Gateway_Total_Cost_Unit__c != null && matCostRG != null) {
                         cd.OP_Res_Gateway_Total_Cost_Material__c = (CDUtility.getValForMultiply(cd.OP_Res_Gateway_Total_Cost_Unit__c)
                                                                     * CDUtility.getValForMultiply(matCostRG)).setScale(2, System.RoundingMode.HALF_UP);
                     }
              } else {
              		cd.OP_Res_Gateway_Total_Cost_Material__c = CDConstants.Zero;
              }
          } else {
              decimal matCost = null;
              if(CDUtility.isStringsEqual(buildingStyle, CDConstants.SFU)){
                  if(costEstDataListBySFU != null && costEstDataListBySFU.size() > 0){
                      matCost = (CDUtility.getValue(costEstDataListBySFU[0].RG_Cost_Material_Cost__c)).setScale(2, System.RoundingMode.HALF_UP); 
                      System.debug('costEstDataListBySFU[0].RG_Cost_Material_Cost__c--'+costEstDataListBySFU[0].RG_Cost_Material_Cost__c);
                  }
              }else{
                  if(costEstDataListByMDU != null && costEstDataListByMDU.size() > 0){
                      matCost = (CDUtility.getValue(costEstDataListByMDU[0].RG_Cost_Material_Cost__c)).setScale(2, System.RoundingMode.HALF_UP); 
                      System.debug('costEstDataListBySFU[0].RG_Cost_Material_Cost__c--'+costEstDataListByMDU[0].RG_Cost_Material_Cost__c);
                  }
              }
              if(matCost != null && cd.OP_Res_Gateway_Total_Cost_Unit__c != null){
                  System.debug('matCost--'+matCost);
                  System.debug('cd.OP_Res_Gateway_Total_Cost_Unit__c--'+cd.OP_Res_Gateway_Total_Cost_Unit__c);
                 cd.OP_Res_Gateway_Total_Cost_Material__c = (cd.OP_Res_Gateway_Total_Cost_Unit__c * CDUtility.getValue(matCost)).setScale(2, System.RoundingMode.HALF_UP);
              }
          }
             
          //ResGateway Total-cost -> Overhead 
          if(CDUtility.isStringsEqual(valuesFromOntModel?.get('gateway'), CDConstants.INTEGRATED)){
          	  if (CDUtility.isOntEstModelSmartNID(cd?.ONT_Model__c, ontUPSShelfEstDataMap)) {
                  if(cd.OP_Res_Gateway_Total_Cost_Material__c != null && stateAllCostsObj?.OC_RG_UPS_Media_Multiplier__c != null){
                       cd.OP_Res_Gateway_Total_Cost_Overhead__c = (CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Material__c) * (CDUtility.getValue(stateAllCostsObj?.OC_RG_UPS_Media_Multiplier__c) - 1)).setScale(2, System.RoundingMode.HALF_UP);
                  }
              } else {
              	cd.OP_Res_Gateway_Total_Cost_Overhead__c = CDConstants.Zero;
              }
          }else if(CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Unit__c) > 0){
              if(cd.OP_Res_Gateway_Total_Cost_Material__c != null && stateAllCostsObj?.OC_RG_UPS_Media_Multiplier__c != null){
                   cd.OP_Res_Gateway_Total_Cost_Overhead__c = (CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Material__c) * (CDUtility.getValue(stateAllCostsObj?.OC_RG_UPS_Media_Multiplier__c) - 1)).setScale(2, System.RoundingMode.HALF_UP);
              }
          }else{
             cd.OP_Res_Gateway_Total_Cost_Overhead__c = CDConstants.Zero;          
          }
             
 
          //ResGateway Total-cost -> Installation 
          if(CDUtility.isStringsEqual(valuesFromOntModel?.get('gateway'), CDConstants.INTEGRATED)){
          	  if (CDUtility.isOntEstModelSmartNID(cd?.ONT_Model__c, ontUPSShelfEstDataMap)) {
                  cd.OP_Res_Gateway_Total_Cost_Installation__c = CDConstants.Zero;
              } else {
                  cd.OP_Res_Gateway_Total_Cost_Installation__c = CDConstants.Zero;
              }
          }else{
             // adjustedOntModel = CDUtility.getAdjustedOntModel(cd.ONT_Model__c);
              decimal gatewayFromRelatedTable  = null;
              System.debug('Ont Model is -----------------------------------'+valuesFromOntModel?.get('ontmodel'));
              if(CDUtility.isStringsEqual(valuesFromOntModel?.get('ontmodel'), CDConstants.FTTU)){
                 gatewayFromRelatedTable  = (CDUtility.getValue(stateAllCostsObj?.IC_Gateway_FTTU__c)).setScale(2, System.RoundingMode.HALF_UP);
              }else if(CDUtility.isStringsEqual(valuesFromOntModel?.get('ontmodel'), CDConstants.FTTB)){
                 gatewayFromRelatedTable  = (CDUtility.getValue(stateAllCostsObj?.IC_Gateway_FTTB__c)).setScale(2, System.RoundingMode.HALF_UP);
              }else{
                 gatewayFromRelatedTable  = (CDUtility.getValue(stateAllCostsObj?.IC_Gateway_FTTIDF__c)).setScale(2, System.RoundingMode.HALF_UP);
              }
              if(gatewayFromRelatedTable != null){
                  cd.OP_Res_Gateway_Total_Cost_Installation__c = (CDConstants.Zero * gatewayFromRelatedTable).setScale(2, System.RoundingMode.HALF_UP);
              }
          }
           
          //ResGateway Total-cost -> Combined Cost     
          System.debug('gateway is -----------------------------------'+valuesFromOntModel?.get('gateway'));   
          if(CDUtility.isStringsEqual(valuesFromOntModel?.get('gateway'), CDConstants.INTEGRATED)){
          	  if (CDUtility.isOntEstModelSmartNID(cd?.ONT_Model__c, ontUPSShelfEstDataMap)) {
                  if (!(cd.OP_Res_Gateway_Total_Cost_Material__c == null && 
                        cd.OP_Res_Gateway_Total_Cost_Overhead__c == null && 
                        cd.OP_Res_Gateway_Total_Cost_Installation__c == null)) {
	                  cd.OP_Res_Gateway_Total_Cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Material__c) +
    											                  CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Overhead__c) + 
                          										  CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Installation__c)).setScale(2, System.RoundingMode.HALF_UP);   
                  }
              } else {
                     cd.OP_Res_Gateway_Total_Cost_Comb_Cost__c = CDConstants.Zero;
              }
          }else{
              if(!(cd.OP_Res_Gateway_Total_Cost_Material__c == null && cd.OP_Res_Gateway_Total_Cost_Overhead__c == null
                   && cd.OP_Res_Gateway_Total_Cost_Installation__c == null)){
                       cd.OP_Res_Gateway_Total_Cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Material__c) +
                           CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Overhead__c) + CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Installation__c)).setScale(2, System.RoundingMode.HALF_UP);   
                   }
          }
         
          //ResGateway Total-cost -> Cost/LU    
          if(cd.OP_Res_Gateway_Total_Cost_Comb_Cost__c  != null && CDUtility.isValGreaterThanZero(CDUtility.getAdjstdnbrLivingUnits(cd))) {
                 cd.OP_Res_Gateway_Total_Cost_LU__c = (cd.OP_Res_Gateway_Total_Cost_Comb_Cost__c / CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP);
          } 
             
          /***************************** Row 4 Ends for (Residential Gateway (WiFi) Total-cost ) **************************/
          
             
         /***************************** Row 5 Starts for (Media Panel Total-cost -> ) **************************/
         
                  
             //Media Panel Total-cost -> Unit
             if(CDUtility.isStringsEqual(cd.Service_Type__c, CDConstants.RETAIL)
               || CDUtility.isStringsEqual(cd.Media_Panel__c, CDConstants.NOT_NEEDED)) 
             {
                 cd.OP_Media_Panel_Total_Cost_Unit__c = CDConstants.Zero;
             }else{
                 cd.OP_Media_Panel_Total_Cost_Unit__c = (CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(0, System.RoundingMode.HALF_UP);
            }
             
           //Media Panel Total-cost -> Material
             if(CDUtility.isStringsEqual(cd.Service_Type__c, CDConstants.RETAIL)
               || CDUtility.isStringsEqual(cd.Media_Panel__c, CDConstants.NOT_NEEDED))
             {
                 cd.OP_Media_Panel_Total_Cost_Material__c = CDConstants.Zero;
             }else{
                 if( CDUtility.getValue(cd.OP_Media_Panel_Total_Cost_Unit__c) > 0){
                     //cd.OP_Media_Panel_Total_Cost_Unit__c * 
                     decimal matCost = null;
                     CCT_Cost_Estimator__c costEst = CapitalDesignCalculationHelper.getCostEstimatorByMatDesc(cd.Media_Panel__c);
                     if(costEst != null){
                        matCost = (CDUtility.getValue(costEst?.Media_Cost_Material_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
                     }
                     if(!(cd.OP_Media_Panel_Total_Cost_Unit__c == null && matCost == null)){
                         cd.OP_Media_Panel_Total_Cost_Material__c = (CDUtility.getValForMultiply(cd.OP_Media_Panel_Total_Cost_Unit__c)
                                                                     * CDUtility.getValForMultiply(matCost)).setScale(2, System.RoundingMode.HALF_UP);
                     }
                 }else{
                    cd.OP_Media_Panel_Total_Cost_Material__c = CDConstants.Zero;         
                 }
             }
           
             //Media Panel Total-cost -> Overhead
             if(CDUtility.isStringsEqual(cd.Service_Type__c, CDConstants.RETAIL)
               || CDUtility.isStringsEqual(cd.Media_Panel__c, CDConstants.NOT_NEEDED))
             {
                 cd.OP_Media_Panel_Total_Cost_Overhead__c = CDConstants.Zero;
             }else{
                 if(CDUtility.getValue(cd.OP_Media_Panel_Total_Cost_Unit__c) > 0){
                     if(cd.OP_Media_Panel_Total_Cost_Material__c != null && stateAllCostsObj?.OC_RG_UPS_Media_Multiplier__c != null){
                         cd.OP_Media_Panel_Total_Cost_Overhead__c = (cd.OP_Media_Panel_Total_Cost_Material__c * (stateAllCostsObj?.OC_RG_UPS_Media_Multiplier__c - 1)).setScale(2, System.RoundingMode.HALF_UP);   
                      }
                 }else{
                     cd.OP_Media_Panel_Total_Cost_Overhead__c = CDConstants.Zero;
                 }
             }
             
             //Media Panel Total-cost -> Installation
             if(CDUtility.isStringsEqual(cd.Service_Type__c, CDConstants.RETAIL)
               || CDUtility.isStringsEqual(cd.Media_Panel__c, CDConstants.NOT_NEEDED))
             {
                 cd.OP_Media_Panel_Total_Cost_Installation__c = CDConstants.Zero;
             }else{
                 if(CDUtility.getValue(cd.OP_Media_Panel_Total_Cost_Unit__c) > 0){
                     if(stateAllCostsObj != null && cd.OP_Media_Panel_Total_Cost_Unit__c != null && stateAllCostsObj?.IC_Panel__c != null){
                             cd.OP_Media_Panel_Total_Cost_Installation__c = (cd.OP_Media_Panel_Total_Cost_Unit__c * (stateAllCostsObj?.IC_Panel__c)).setScale(2, System.RoundingMode.HALF_UP);   
                      }
                 }else{
                     cd.OP_Media_Panel_Total_Cost_Installation__c = CDConstants.Zero;
                 }
             }
        
            //Media Panel Total-cost -> Comb Unit  
             if(CDUtility.isStringsEqual(cd.Service_Type__c, CDConstants.RETAIL)
               || CDUtility.isStringsEqual(cd.Media_Panel__c, CDConstants.NOT_NEEDED)) 
             {
                 cd.OP_Media_Panel_Total_Cost_Comb_Cost__c = CDConstants.Zero;
             }else{
                  if(!(cd.OP_Media_Panel_Total_Cost_Material__c == null && cd.OP_Media_Panel_Total_Cost_Overhead__c == null
                     && cd.OP_Media_Panel_Total_Cost_Installation__c == null)){
                           cd.OP_Media_Panel_Total_Cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_Media_Panel_Total_Cost_Material__c) +
                                                                         CDUtility.getValue(cd.OP_Media_Panel_Total_Cost_Overhead__c) + CDUtility.getValue(cd.OP_Media_Panel_Total_Cost_Installation__c)).setScale(2, System.RoundingMode.HALF_UP);   
                  }   
             }
             
             //Media Panel Total-cost -> Cost/LU
             if(cd.OP_Media_Panel_Total_Cost_Comb_Cost__c  != null && CDUtility.isValGreaterThanZero(CDUtility.getAdjstdnbrLivingUnits(cd))) {
                 cd.OP_Media_Panel_Total_Cost_LU__c = (cd.OP_Media_Panel_Total_Cost_Comb_Cost__c / CDUtility.getAdjstdnbrLivingUnits(cd)).setScale(2, System.RoundingMode.HALF_UP);
              }          
         /***************************** Row 5 Ends for (Media Panel Total-cost ->) **************************/
             
             
             /***************************** Row 6 Starts for (Total-cost ->) **************************/
             
             //Total-cost -> Comb Cost
             cd.OP_Total_Cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_ISP_Total_cost_Combined_Cost__c) + 
                                             CDUtility.getValue(cd.OP_F1_Total_Cost_Comb_Cost__c) +
                                             CDUtility.getValue(cd.OP_F2_Total_Cost_Combined_Cost__c) +
                                             CDUtility.getValue(cd.OP_F3_Total_Cost_Comb_Cost__c) +
                                             CDUtility.getValue(cd.OP_F4_Total_Cost_Comb_Cost__c) +
                                             CDUtility.getValue(cd.OP_ONT_Total_Cost_Comb_Cost__c) +
                                             CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_Comb_Cost__c) +
                                             CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_Comb_Cost__c) +
                                             CDUtility.getValue(cd.OP_Media_Panel_Total_Cost_Comb_Cost__c)).setScale(2, System.RoundingMode.HALF_UP);
             
              //Total-cost -> Cost/LU  
             cd.OP_Total_Cost_LU__c = (CDUtility.getValue(cd.OP_ISP_Total_cost_Cost_LU__c) + 
                                             CDUtility.getValue(cd.OP_F1_Total_Cost_Cost_LU__c) +
                                             CDUtility.getValue(cd.OP_F2_Total_Cost_Cost_LU__c) +
                                             CDUtility.getValue(cd.OP_F3_Total_Cost_LU__c) +
                                             CDUtility.getValue(cd.OP_F4_Total_Cost_LU__c) +
                                             CDUtility.getValue(cd.OP_ONT_Total_Cost_LU__c) +
                                             CDUtility.getValue(cd.OP_UPS_Shelf_Total_Cost_LU__c) +
                                             CDUtility.getValue(cd.OP_Res_Gateway_Total_Cost_LU__c) +
                                             CDUtility.getValue(cd.OP_Media_Panel_Total_Cost_LU__c)).setScale(2, System.RoundingMode.HALF_UP);
             
             /***************************** Row 6 Starts for (Total-cost ->) **************************/
           
         }// close capital design for loop
     }//close method
 
}//end class CapitalDesignTriggerHelperOutputSec