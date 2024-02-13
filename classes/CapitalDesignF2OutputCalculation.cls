/******************************************************************************************************************* 
* @Class : CapitalDesignF2OutputCalculation
* @ Descriptions : ESCJ-497 F2 SECTION
* 					Helper class for calculating formulas for F2 Output section for Trigger CapitalDesignTrigger
****************************************************************** 
Author    *          UserStory   *    Date         *       Description 
Muhammad Nadeer MK (IBM)      ESCJ-497        10/03/2022           F2 Output calculations
===============================================================================================
* Date         Author      UserStory          Description  
* 08/02/2023   T2Cabato    QFCJ-4286          BRAIN-Drop-Cost-Fix
* 09/22/2023   T2Cabato    QFCJ-4580          Round CCT cost fields results to 2 decimals 
* 10/02/2023   T2Cabato    QFCJ-4636          F2 FDH Size in output section not pulling correct values from cost table 
* 10/17/2023   T2Cabato    QFCJ-4683          CCT Rounding Integers using HALF_UP except for Splitter Sub-cost Unit  
***********************************************************************************************/

public class CapitalDesignF2OutputCalculation {
    
    /******************************************************************************************************************** 
  * @Developer : Muhammad Nadeer MK (IBM)
  * @Method : doF2OutputCalculations
  * @Params : Input parameter Capital_Design__c object's field
  * @Descriptions : ESCJ-497
  * 				   For performing Calculation for F2 output section
  ******************************************************************************************************************/
    
    public static void doF2OutputCalculations(Capital_Design__c cd,sObject oldValue,sObject newValue) {
        
        try{
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) We are inside the method!  ');
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.Name = ' + cd.Name + '  AND cd.Property_Address_State__c = ' + cd.Property_Address_State__c);
            
            //Fetching the Objects in respective variables
            StatesCostforCapitalDesign__c stateCDObj = CapitalDesignTriggerHelper.stateDataMap.get(cd.Property_Address_State__c);
            CCT_Cost_Estimator__c costEst = CapitalDesignTriggerHelper.costEstDataMapByState.get(cd.Property_Address_State__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) Initial costEst is NULL? ' + (costEst==null));
            if (costEst==null && String.isNotBlank(cd.Primary_Address_State_Name__c)) costEst = CapitalDesignTriggerHelper.costEstDataMapByState.get(cd.Primary_Address_State_Name__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) 2nd Chance costEst is NULL? ' + (costEst==null));
            CCT_F2_Cost_Estimator__c f2CostEstObj = CapitalDesignTriggerHelper.f2CostEstDataMap.get(CDUtility.getBuildStyle(cd.Building_Style__c));
            CCT_Cost_Estimator__c SplitterEstObj = CapitalDesignTriggerHelper.getSpltrEstimatorDataMap.get(CDConstants.THIRTYTWOPOINTZERO);
            String buildingValue = CDUtility.getBuildStyle(cd.Building_Style__c);
            String ontModelValue = CDUtility.getAdjustedOntModel(cd.ONT_Model__c);
            String AdjstBuildngStyle = CDUtility.getAdjstBuildingStyle(cd);
            Decimal AdjustdnbrLivingUnits = CDUtility.getAdjstdnbrLivingUnits(cd);
            Decimal valueSPLInst = CDConstants.ZERO;
            
            //Common Calculation
            Decimal valFootage;
            if (cd.F2_Footage_ft__c != NULL) {
                valFootage = cd.F2_Footage_ft__c;
            } else {
                valFootage = getValueForF2HF(cd);
            }
            
            //Calculation of a value for Fetching Datamap of F2 FDH Estimator Table that used for Calculation of Fiber Distribution Hub (FDH) Sub-cost Material field
            Decimal f2StubMatCost;
            Integer varFDHMaterialField;
            Integer varFDHMatCalculation = Integer.valueof(CDUtility.getValue(getValueForFDHMat(cd)) * CDConstants.ONEPOINTZEROFIVE);
            if ((CDUtility.getValue(getValueForFDHMat(cd)) * CDConstants.ONEPOINTZEROFIVE) > CDConstants.FOURHUNDREDANDTHIRTYTWO) {
                varFDHMaterialField = math.mod(varFDHMatCalculation, CDConstants.FOURHUNDREDANDTHIRTYTWO);
            } else {
                varFDHMaterialField = varFDHMatCalculation;
            }
            String VarFDH = String.valueof(varFDHMaterialField);
            VarFDH = varFDH + '.00';
            Decimal varFDHdec = Decimal.valueOf(varFDH);
            List <CCT_F2_Stub_Estimator__c> F2StbEstObjctList = CapitalDesignCalculationHelper.getF2StubEstBySubUnit(cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c);
            if (F2StbEstObjctList != null && F2StbEstObjctList.size() > 0) {
                CCT_F2_Stub_Estimator__c f2StubEst = F2StbEstObjctList[0];
                f2StubMatCost = f2StubEst.F2_STUBE_Material_Cost__c;
            }
            
            
            // <<-- F2 Conduit Sub-cost -->>
            
            // Calculation of F2 Conduit Sub-cost Unit field
            Decimal sumConduitSBUnit;
            sumConduitSBUnit = (CDUtility.getValue(valFootage) - (CDUtility.getValue(cd.F2_Footage_Direct_Buried_96f__c) +
                                                                  CDUtility.getValue(cd.F2_Footage_Aerial_10M_144f__c) + CDUtility.getValue(cd.F2_Footage_Pull_Fiber_96f__c)) -
                                CDUtility.getValue(cd.F2_Footage_Custom_without_conduit__c))?.setScale(2, System.RoundingMode.HALF_UP);
            
            if (buildingValue == CDConstants.MIDRISE || buildingValue == CDConstants.HIGHRISE) {
                cd.OP_F2_Conduit_Sub_cost_Unit__c = CDConstants.ZERO;
            } else if (cd.F2_Fiber_Conduit_Placement_Sub_Total__c == CDConstants.ZERO || cd.F2_Fiber_Conduit_Placement_Sub_Total__c == CDConstants.HUNDRED) {
                cd.OP_F2_Conduit_Sub_cost_Unit__c = (sumConduitSBUnit)?.setScale(2, System.RoundingMode.HALF_UP);
            }else
            {
                cd.OP_F2_Conduit_Sub_cost_Unit__c = CDConstants.ZERO;
            }
            
            
            // Calculation of F2 Conduit Sub-cost Combined Cost field
            if (buildingValue == CDConstants.MIDRISE || buildingValue == CDConstants.HIGHRISE) {
                cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c = CDConstants.ZERO;
            } else {
                cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c = (CDUtility.getValue(CDConstants.TWO) * CDUtility.getValue(cd.OP_F2_Conduit_Sub_cost_Unit__c))?.setScale(2, System.RoundingMode.HALF_UP);
            }
            
            // Calculation of F2 Conduit Sub-cost Cost/ft field
            if (CDUtility.isValGreaterThanZero(valFootage) && CDUtility.isValGreaterThanZero(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c)) {
                cd.OP_F2_Conduit_Sub_cost_Cost_ft__c = (cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c / valFootage)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Conduit_Sub_cost_Cost_ft__c = CDConstants.ZERO;
            }
            
            
            // Calculation of F2 Conduit Sub-cost Cost/LU field
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c)) {
                cd.OP_F2_Conduit_Sub_cost_Cost_LU__c = (cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c / cd.nbr_of_Living_Units__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Conduit_Sub_cost_Cost_LU__c = CDConstants.ZERO;
            }
            
            
            
            
            
            // <<-- F2 Vertical Fiber (Stub) Sub-cost -->>
            
            // Calculation of F2 Vertical Fiber(Stub) Sub-cost Unit field
            if (buildingValue == CDConstants.HIGHRISE || ((AdjstBuildngStyle == CDConstants.MIDRISELESSTHAN100 ||
                                                           AdjstBuildngStyle == CDConstants.MIDRISE) && cd.Are_there_IDF__c == 'Yes')) {
                                                               if (cd.F2_nbr_of_IDF_locations__c != NULL) {
                                                                   cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c = cd.F2_nbr_of_IDF_locations__c;
                                                               } else {
                                                                   cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c = CDUtility.getOvrrdF2nbrIDFlocations(cd);
                                                               }
                                                           } else {
                                                               cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c = CDConstants.ZERO;
                                                           }
            
            // Calculation of  F2 Vertical Fiber (Stub) Sub-cost Sub-unit field
            Decimal valF2VFSbUnit;
            if (CDUtility.isValGreaterThanZero(cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c) && CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c)) {
                valF2VFSbUnit = (cd.nbr_of_Living_Units__c / cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c)?.setScale(2, System.RoundingMode.HALF_UP);
            }
            if (buildingValue == CDConstants.HIGHRISE ||
                ((AdjstBuildngStyle == CDConstants.MIDRISELESSTHAN100 || AdjstBuildngStyle == CDConstants.MIDRISE) &&
                 cd.Are_there_IDF__c == 'Yes')) {
                     if (ontModelValue == CDConstants.FTTU) {
                         if (valF2VFSbUnit <= CDConstants.SIX) {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.SIX;
                         } else if (valF2VFSbUnit <= CDConstants.TWELVE) {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.TWELVE;
                         } else if (valF2VFSbUnit <= CDConstants.TWENTYFOUR) {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.TWENTYFOUR;
                         } else if (valF2VFSbUnit <= CDConstants.FOURTYEIGHT) {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.FOURTYEIGHT;
                         } else if (valF2VFSbUnit <= CDConstants.SIXTY) {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.SIXTY;
                         } else {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.SEVENTYTWO;
                         }
                     } else if (ontModelValue == CDConstants.FTTB) {
                         if (valF2VFSbUnit <= CDConstants.TWENTYFOUR) {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.SIX;
                         } else {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.TWELVE;
                         }
                     } else if (ontModelValue == CDConstants.FTTIDF) {
                         if (valF2VFSbUnit <= CDConstants.TWENTYFOUR) {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.SIX;
                         } else if (valF2VFSbUnit <= CDConstants.FOURTYEIGHT) {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.TWELVE;
                         } else {
                             cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.TWENTYFOUR;
                         }
                     }
                 } else {
                     cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = CDConstants.ZERO;
                 }
            
            
            // Calculation of F2 Vertical Fiber (Stub) Sub-cost Material field
            if (buildingValue == CDConstants.HIGHRISE || ((AdjstBuildngStyle == CDConstants.MIDRISELESSTHAN100 ||
                                                           AdjstBuildngStyle == CDConstants.MIDRISE) && cd.Are_there_IDF__c == 'Yes')) {
                                                               if (cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c > CDConstants.ZERO) {
                                                                   cd.OP_F2VerticalFiber_Stub_Sub_cst_Material__c = (CDUtility.getValue(cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c) * CDUtility.getValue(f2StubMatCost))?.setScale(2, System.RoundingMode.HALF_UP);
                                                               } else {
                                                                   cd.OP_F2VerticalFiber_Stub_Sub_cst_Material__c = CDConstants.ZERO;
                                                               }
                                                           }else{
                                                               cd.OP_F2VerticalFiber_Stub_Sub_cst_Material__c = CDConstants.ZERO;
                                                           }
            
            
            // Calculation of F2 Vertical Fiber (Stub) Sub-cost Overhead field
            StatesCostforCapitalDesign__c F2VFO = CapitalDesignCalculationHelper.getStateCostObject(cd.Primary_Address_State_Name__c,cd.Property_Address_State__c);
            //if (F2VFO == null) F2VFO = CapitalDesignCalculationHelper.getStateCostObject(cd.State_Name__c,cd.State__c);
            if (buildingValue == CDConstants.HIGHRISE || ((AdjstBuildngStyle == CDConstants.MIDRISELESSTHAN100 ||
                                                           AdjstBuildngStyle == CDConstants.MIDRISE) && cd.Are_there_IDF__c == 'Yes')) {
                                                               if (cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c > CDConstants.ZERO) {
                                                                   cd.OP_F2VerticalFiber_Stub_Sub_cst_Overhead__c = ((CDUtility.getValue(cd.OP_F2VerticalFiber_Stub_Sub_cst_Material__c)) *
                                                                                                                     (CDUtility.getValue(F2VFO.OC_General_Multiplier__c) - CDConstants.ONE))?.setScale(2, System.RoundingMode.HALF_UP);
                                                               } else {
                                                                   cd.OP_F2VerticalFiber_Stub_Sub_cst_Overhead__c = CDConstants.ZERO;
                                                               }
                                                           } else {
                                                               cd.OP_F2VerticalFiber_Stub_Sub_cst_Overhead__c = CDConstants.ZERO;
                                                           }
            
            // Calculation of F2 Vertical Fiber (Stub) Sub-cost Installation field
            if (buildingValue == CDConstants.HIGHRISE || ((AdjstBuildngStyle== CDConstants.MIDRISELESSTHAN100 ||
                                                           AdjstBuildngStyle == CDConstants.MIDRISE) && cd.Are_there_IDF__c == 'Yes')) {
                                                               if(cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c == CDConstants.SIX)
                                                               {
                                                                   cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Inst__c = (cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c * stateCDObj.IC_Stub12__c)?.setScale(2, System.RoundingMode.HALF_UP);
                                                               }else if(cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c == CDConstants.TWELVE)
                                                               {
                                                                   cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Inst__c = (cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c * stateCDObj.IC_Stub12__c)?.setScale(2, System.RoundingMode.HALF_UP);
                                                               }else if(cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c == CDConstants.TWENTYFOUR)
                                                               {
                                                                   cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Inst__c = (cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c * stateCDObj.IC_Stub24__c)?.setScale(2, System.RoundingMode.HALF_UP);
                                                               }else if(cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c == CDConstants.FOURTYEIGHT)
                                                               {
                                                                   cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Inst__c = (cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c * stateCDObj.IC_Stub48__c)?.setScale(2, System.RoundingMode.HALF_UP);
                                                               }else if(cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c == CDConstants.SIXTY)
                                                               {
                                                                   cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Inst__c = (cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c * stateCDObj.IC_Stub60__c)?.setScale(2, System.RoundingMode.HALF_UP);
                                                               }else if(cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c == CDConstants.SEVENTYTWO)
                                                               {
                                                                   cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Inst__c = (cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c * stateCDObj.IC_Stub72__c)?.setScale(2, System.RoundingMode.HALF_UP);
                                                               }else{
                                                                   cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Inst__c = CDConstants.ZERO;
                                                               }
                                                           }else{
                                                               cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Inst__c = CDConstants.ZERO;
                                                           }
            
            // Calculation of F2 Vertical Fiber (Stub) Sub-cost Combined Cost field
            Decimal ValF2VFCombCst = (CDUtility.getValue(cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c) + CDUtility.getValue(cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c))?.setScale(2, System.RoundingMode.HALF_UP);
            if (buildingValue == CDConstants.HIGHRISE || ((AdjstBuildngStyle == CDConstants.MIDRISELESSTHAN100 ||
                                                           AdjstBuildngStyle == CDConstants.MIDRISE) && cd.Are_there_IDF__c == 'Yes')) {
                                                               if (ValF2VFCombCst > CDConstants.ZERO) {
                                                                   cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c = (CDUtility.getValue(cd.OP_F2VerticalFiber_Stub_Sub_cst_Material__c) +
                                                                                                                     CDUtility.getValue(cd.OP_F2VerticalFiber_Stub_Sub_cst_Overhead__c) + CDUtility.getValue(cd.OP_F2_Vertical_Fiber_Stub_Sub_cst_Inst__c))?.setScale(2, System.RoundingMode.HALF_UP);
                                                               } else {
                                                                   cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c = CDConstants.ZERO;
                                                               }
                                                           } else {
                                                               cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c = CDConstants.ZERO;
                                                           }
            // Calculation of F2 Vertical Fiber (Stub) Sub-cost Cost/LU field
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c)) {
                cd.OP_F2Vertical_Fiber_Stub_Sub_cst_Cst_LU__c = (CDUtility.getValue(cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c) / cd.nbr_of_Living_Units__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2Vertical_Fiber_Stub_Sub_cst_Cst_LU__c = CDConstants.ZERO;
            }
            
            
            // <<-- F2 Splicing Sub-cost -->>
            
            // Calculation of  F2 Splicing Sub-cost Unit field
            if (ontModelValue == CDConstants.FTTU) {
                cd.OP_F2_Splicing_Sub_cost_Unit__c = (((CDUtility.getValue(cd.nbr_of_Living_Units__c) * CDUtility.getValue(f2CostEstObj.FTTU__c))?.setScale(2, System.RoundingMode.HALF_UP))
                                                      + cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else if (ontModelValue == CDConstants.FTTB) {
                cd.OP_F2_Splicing_Sub_cost_Unit__c = (((CDUtility.getValue(cd.nbr_of_Living_Units__c) *
                                                        CDUtility.getValue(f2CostEstObj.F2_CostE_FTTB__c))?.setScale(2, System.RoundingMode.HALF_UP)) + cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else if (ontModelValue == CDConstants.FTTIDF) {
                cd.OP_F2_Splicing_Sub_cost_Unit__c = (((CDUtility.getValue(cd.nbr_of_Living_Units__c) *
                                                        CDUtility.getValue(f2CostEstObj.FTTIDF__c))?.setScale(2, System.RoundingMode.HALF_UP)) + cd.OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Splicing_Sub_cost_Unit__c = CDConstants.ZERO;
            }
            
            // Calculation of  F2 Splicing Sub-cost Installation field
            if (stateCDObj != NULL) {
                cd.OP_F2_Splicing_Sub_cost_Installation__c = (CDUtility.getValue(cd.OP_F2_Splicing_Sub_cost_Unit__c) * CDUtility.getValue(stateCDObj.IC_Splicing__c))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Splicing_Sub_cost_Installation__c = CDConstants.ZERO;
            }
            
            
            
            // Calculation of  F2 Splicing Sub-cost Combined Cost field
            if (cd.OP_F2_Splicing_Sub_cost_Unit__c > CDConstants.ZERO) {
                cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c = (CDUtility.getValue(cd.OP_F2_Splicing_Sub_cost_Overhead__c) +
                                                               CDUtility.getValue(cd.OP_F2_Splicing_Sub_cost_Installation__c))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c = CDConstants.ZERO;
            }
            // Calculation of F2 Splicing Sub-cost Cost/LU field
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c)) {
                cd.OP_F2_Splicing_Sub_cost_Cost_LU__c = (cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c / cd.nbr_of_Living_Units__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Splicing_Sub_cost_Cost_LU__c = CDConstants.ZERO;
            }
            
            // <<--Fiber Distribution Hub (FDH) Sub-cost -->>
            decimal nbrBuffer;
            if(ontModelValue == CDConstants.FTTIDF || ontModelValue == CDConstants.FTTB){
                nbrBuffer = (Math.round((cd.nbr_of_Living_Units__c * CDConstants.POINTTHREE))*(CDConstants.ONEPOINTZEROFIVE))?.setScale(2, System.RoundingMode.HALF_UP);
            }else{
                nbrBuffer = ((cd.nbr_of_Living_Units__c * CDConstants.ONEPOINTZEROFIVE))?.setScale(2, System.RoundingMode.HALF_UP); //ESCj-1578 US code fix
            }
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost -> nbrBuffer = ' + nbrBuffer);
            
            if(nbrBuffer > CDConstants.FOURHUNDREDANDTHIRTYTWO){
                cd.Show_FDH_Size__c = false;
                cd.F2_FDH_size__c = NULL;
            }else{
                String fdhdefaultSize = String.valueOf(getValueForFDHSize(cd,nbrBuffer));
              System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost -> fdhdefaultSize = ' + fdhdefaultSize);
                Integer olddefaultVal = Integer.valueOf(fdhdefaultSize);
                Integer oldval = Integer.valueOf(oldValue.get('F2_FDH_size__c'));
                Integer newval = Integer.valueOf(newValue.get('F2_FDH_size__c'));
                if(oldValue.get('nbr_of_Living_Units__c') == newValue.get('nbr_of_Living_Units__c')){
                    if(oldval == NULL || oldValue.get('ONT_Model__c') != newValue.get('ONT_Model__c')){
                        cd.F2_FDH_size__c = fdhdefaultSize;
                    }
                    if(oldval != newval){
                        if(olddefaultVal > newval && newval !=olddefaultVal){
                            cd.addError('This value is too low for the Units on the property. Please select a higher value');
                        }else{
                            cd.F2_FDH_size__c = String.valueOf(newval);
                        }
                    }
                }else{
                    cd.F2_FDH_size__c = fdhdefaultSize;
                }
                cd.Show_FDH_Size__c = true;
            }
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost -> cd.F2_FDH_size__c = ' + cd.F2_FDH_size__c);
            
            // Calculation of Fiber Distribution Hub (FDH) Sub-cost Sub-unit field
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Sub-unit -> cd.Existing_FDH__c = ' + cd.Existing_FDH__c);
            if (cd.Existing_FDH__c != true) {
                if (cd.F2_FDH_size__c != NULL) {
                    String VarFDHSize = cd.F2_FDH_size__c;
                    VarFDHSize = VarFDHSize + '.00000'; //ESCJ-1578 US code fix
                    Decimal fdhSize = Decimal.valueOf(VarFDHSize);
                    cd.OP_F2_FDH_Sub_cost_Sub_unit__c = (fdhSize)?.setScale(0, System.RoundingMode.HALF_UP);
                    //cd.OP_F2_FDH_Sub_cost_Sub_unit__c = decimal.valueof(cd.F2_FDH_size__c);
                }//ESCj-1578 US code fix
                else {
                    cd.OP_F2_FDH_Sub_cost_Sub_unit__c = (getValueForFDHSbUnit(cd))?.setScale(0, System.RoundingMode.HALF_UP);
                }
            } else {
                cd.OP_F2_FDH_Sub_cost_Sub_unit__c = CDConstants.ZERO;
            }
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Sub-unit -> cd.OP_F2_FDH_Sub_cost_Sub_unit__c = ' + cd.OP_F2_FDH_Sub_cost_Sub_unit__c);
            
            
            // Calculation of Fiber Distribution Hub (FDH) Sub-cost Unit field
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Unit -> CDUtility.getValue(getValueForFDHMat(cd) = ' + CDUtility.getValue(getValueForFDHMat(cd)));
            Decimal valFDHUnit = (CDUtility.getValue(getValueForFDHMat(cd)) * CDConstants.ONEPOINTZEROFIVE);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Unit -> valFDHUnit = ' + valFDHUnit);
            if (cd.Existing_FDH__c != true) {
                if (buildingValue == CDConstants.MIDRISE || buildingValue == CDConstants.HIGHRISE) {
                    if (valFDHUnit > CDConstants.FOURHUNDREDANDTHIRTYTWO) {
                        //cd.OP_F2_FDH_Sub_cost_Unit__c = (valFDHUnit / CDConstants.FOURHUNDREDANDTHIRTYTWO).round(System.RoundingMode.UP);
                        //cd.OP_F2_FDH_Sub_cost_Unit__c = Math.round(valFDHUnit / CDConstants.FOURHUNDREDANDTHIRTYTWO);
                        cd.OP_F2_FDH_Sub_cost_Unit__c = Integer.valueof((valFDHUnit / CDConstants.FOURHUNDREDANDTHIRTYTWO)?.setScale(0, System.RoundingMode.HALF_UP));//ESCJ-1715 bug fix
                    } else {
                        cd.OP_F2_FDH_Sub_cost_Unit__c = CDConstants.ZERO;
                    }
                } else {
                    //cd.OP_F2_FDH_Sub_cost_Unit__c = CDConstants.ZERO;
                    if (valFDHUnit > CDConstants.FOURHUNDREDANDTHIRTYTWO) {
                        cd.OP_F2_FDH_Sub_cost_Unit__c = Integer.valueof((valFDHUnit / CDConstants.FOURHUNDREDANDTHIRTYTWO)?.setScale(0, System.RoundingMode.HALF_UP));//ESCJ-1715 bug fix
                        //cd.OP_F2_FDH_Sub_cost_Unit__c = Math.round(valFDHUnit / CDConstants.FOURHUNDREDANDTHIRTYTWO);//ESCJ-1623 Bug Fix
                    } else {
                        cd.OP_F2_FDH_Sub_cost_Unit__c = CDConstants.ZERO;
                    }
                }
            } else {
                cd.OP_F2_FDH_Sub_cost_Unit__c = CDConstants.ZERO;
            }          
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Unit -> cd.OP_F2_FDH_Sub_cost_Unit__c = ' + cd.OP_F2_FDH_Sub_cost_Unit__c);            
            
  
            // Calculation of Fiber Distribution Hub (FDH) Sub-cost Material field
            Decimal f2FDHEstMaterialIndoor;
            Decimal f2FDHEstMatOut;
            Decimal f2FDHEstvar;
            CCT_F2_FDH_Estimator__c f2FDHEstIndoorObj;
            CCT_F2_FDH_Estimator__c f2FDHEstOutdoorObj;
            
            // If we have value that's not inthe F2 FDH Static table, this value will be using the least value, So sorted the object by order by.
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Material -> KEY=' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) + ', AND CapitalDesignTriggerHelper.f2FDHEstIndoorMap.containsKey(CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c)) = ' + CapitalDesignTriggerHelper.f2FDHEstIndoorMap.containsKey(CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c)));
            if(CapitalDesignTriggerHelper.f2FDHEstIndoorMap.containsKey(CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c))) {
                f2FDHEstIndoorObj =  CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c));
            } else {
                //QFCJ-4636 OP F2 FDH Size not mapping from cost table
                for (Decimal subunit : CapitalDesignTriggerHelper.f2FDHEstIndoorMap.keySet()) {
                System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Material -> for-loop thru IndoorMap.keySet, this subunit = ' + subunit + ' AND KEY=' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) + ' -- Do they match? ' + (subunit == CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c)));
                    if (subunit == CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c)) {
                      f2FDHEstIndoorObj = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(subunit);
                      break;
                    }
                }//end for-loop
            }
            
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Material -> CapitalDesignTriggerHelper.f2FDHEstOutdoorMap.containsKey(CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c)) = ' + CapitalDesignTriggerHelper.f2FDHEstOutdoorMap.containsKey(CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c)));
            if(CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.containsKey(CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c))){
                f2FDHEstOutdoorObj =  CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.get(CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c));
            }else{                
                //QFCJ-4636 OP F2 FDH Size not mapping from cost table
                for(Decimal subunit : CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.keySet()){
                System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Material -> for-loop thru OutdoorMap.keySet, this subunit = ' + subunit + ' AND KEY=' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) + ' -- Do they match? ' + (subunit == CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c)));
                    if (subunit == CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c)) {
                      f2FDHEstOutdoorObj = CapitalDesignTriggerHelper.f2FDHEstOutdoorMap.get(subunit);
                      break;
                    }
                }//end for-loop
            }
            if(f2FDHEstIndoorObj != NULL){
                f2FDHEstMaterialIndoor = f2FDHEstIndoorObj.F2_FDHE_Indoor_Material_Cost__c;
            }
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Material -> f2FDHEstMaterialIndoor = ' + f2FDHEstMaterialIndoor);
            if(f2FDHEstOutdoorObj != NULL)
            {
                f2FDHEstMatOut = f2FDHEstOutdoorObj.F2_FDHE_Outdoor_Material_Cost__c;
            }
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Material -> f2FDHEstMatOut = ' + f2FDHEstMatOut);
            if (buildingValue == CDConstants.MIDRISE || buildingValue == CDConstants.HIGHRISE) {
                if (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) > CDConstants.ZERO) {
                    if (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) > CDConstants.ZERO) {
                        //f2FDHEstvar = (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) * CDUtility.getValue(f2FDHEstMaterialIndoor));
                        CCT_F2_FDH_Estimator__c f2FDHEstIndoorObj1 = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDUtility.getValue(CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO));//ESCJ-1623 bug fix
                        f2FDHEstvar = ((CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c)) * f2FDHEstIndoorObj1.F2_FDHE_Indoor_Material_Cost__c)?.setScale(2, System.RoundingMode.HALF_UP); //ESCJ-1623 Bug Fix.
                    } else {
                        f2FDHEstvar = CDConstants.ZERO;
                    }
                System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Material -> ' + buildingValue + ': f2FDHEstvar = ' + f2FDHEstvar);
                    if (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) > CDConstants.ZERO) {
                        cd.OP_F2_FDH_Sub_cost_Material__c = (f2FDHEstMaterialIndoor + f2FDHEstvar)?.setScale(2, System.RoundingMode.HALF_UP);
                    } else {
                        cd.OP_F2_FDH_Sub_cost_Material__c = CDConstants.ZERO;
                    }
                }else{
                    cd.OP_F2_FDH_Sub_cost_Material__c = CDConstants.ZERO;
                }
            }else if(CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) > CDConstants.ZERO) {
                if (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) > CDConstants.ZERO) {
                    //f2FDHEstvar = (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) * CDUtility.getValue(f2FDHEstMatOut));
                    CCT_F2_FDH_Estimator__c f2FDHEstOutdoorObj1 = CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.get(CDUtility.getValue(CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO));//ESCJ3-1623 BUG FIX
                    f2FDHEstvar = ((CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c)) * f2FDHEstOutdoorObj1.F2_FDHE_Outdoor_Material_Cost__c)?.setScale(2, System.RoundingMode.HALF_UP); //ESCJ-1623 Bug Fix.
                }else
                {
                    f2FDHEstvar = CDConstants.ZERO;
                }
              System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Material -> ' + buildingValue + ': f2FDHEstvar = ' + f2FDHEstvar);
                if (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) > CDConstants.ZERO) {
                    cd.OP_F2_FDH_Sub_cost_Material__c = ((CDUtility.getValue(f2FDHEstMatOut) + f2FDHEstvar))?.setScale(2, System.RoundingMode.HALF_UP);
                } else {
                    cd.OP_F2_FDH_Sub_cost_Material__c = CDConstants.ZERO;
                }
            }else {
                cd.OP_F2_FDH_Sub_cost_Material__c = CDConstants.ZERO;
            }
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Material -> cd.OP_F2_FDH_Sub_cost_Material__c = ' + cd.OP_F2_FDH_Sub_cost_Material__c);
            
            
            // Calculation of Fiber Distribution Hub (FDH) Sub-cost Overhead field
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Overhead -> CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) of ' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) + ' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) of ' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) + ' = ' + (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c)));
            if ((CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c)) > CDConstants.ZERO) { 
                if(CDUtility.isValGreaterThanZero(cd.OP_F2_FDH_Sub_cost_Material__c) == true)
                {
                    cd.OP_F2_FDH_Sub_cost_Overhead__c = (CDUtility.getValForMultiply(cd.OP_F2_FDH_Sub_cost_Material__c) *
                                                         (CDUtility.getValue(F2VFO?.OC_General_Multiplier__c) - CDConstants.ONE))?.setScale(2, System.RoundingMode.HALF_UP);
                }
                else
                {
                    cd.OP_F2_FDH_Sub_cost_Overhead__c = ((CDUtility.getValue(F2VFO?.OC_General_Multiplier__c) - CDConstants.ONE))?.setScale(2, System.RoundingMode.HALF_UP);
                }
            } else {
                cd.OP_F2_FDH_Sub_cost_Overhead__c = CDConstants.ZERO;
            } 
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Overhead -> cd.OP_F2_FDH_Sub_cost_Overhead__c = ' + cd.OP_F2_FDH_Sub_cost_Overhead__c);
            
            
            // Calculation of Fiber Distribution Hub (FDH) Sub-cost Installation field
            Decimal valueFDHInst;
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Installation -> CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) of ' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) + ' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) of ' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) + ' = ' + (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c)));
            if (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) > CDConstants.ZERO) {
                if (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) >= CDConstants.SEVENTYTWO) { //ESCJ-1702 bug fix
                    valueFDHInst = CDConstants.ONE;
                } else {
                    valueFDHInst = CDConstants.ZERO;
                }
                if (stateCDObj != NULL) {
                    if ((buildingValue == CDConstants.MIDRISE || buildingValue == CDConstants.HIGHRISE)) {
                        cd.OP_F2_FDH_Sub_cost_Installation__c = ((CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) + CDUtility.getValue(valueFDHInst)) *
                                                                 CDUtility.getValue(stateCDObj.IC_FDH_In__c))?.setScale(2, System.RoundingMode.HALF_UP);
                    } else {
                        cd.OP_F2_FDH_Sub_cost_Installation__c = ((CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) + CDUtility.getValue(valueFDHInst)) *
                                                                 CDUtility.getValue(stateCDObj.IC_FDH_Out__c))?.setScale(2, System.RoundingMode.HALF_UP);
                    }
                } else {
                    cd.OP_F2_FDH_Sub_cost_Installation__c = CDConstants.ZERO;
                }
            } else {
                cd.OP_F2_FDH_Sub_cost_Installation__c = CDConstants.ZERO;
            }
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Installation -> cd.OP_F2_FDH_Sub_cost_Installation__c = ' + cd.OP_F2_FDH_Sub_cost_Installation__c);
            
            
            // Calculation of Fiber Distribution Hub (FDH) Sub-cost Combined Cost field 
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Combined-Cost -> CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) of ' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) + ' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) of ' + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) + ' = ' + (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c) + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c)));
            if ((CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Unit__c) + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Sub_unit__c)) > CDConstants.ZERO) {
                cd.OP_F2_FDH_Sub_cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Material__c) +
                                                      CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Overhead__c) + CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Installation__c))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_FDH_Sub_cost_Comb_Cost__c = CDConstants.ZERO;
            }
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Combined-Cost -> cd.OP_F2_FDH_Sub_cost_Comb_Cost__c = ' + cd.OP_F2_FDH_Sub_cost_Comb_Cost__c);
            
            
            // Calculation of Fiber Distribution Hub (FDH) Sub-cost Cost/LU field
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Cost/LU -> cd.nbr_of_Living_Units__c = ' + cd.nbr_of_Living_Units__c + '  AND cd.OP_F2_FDH_Sub_cost_Comb_Cost__c = ' + cd.OP_F2_FDH_Sub_cost_Comb_Cost__c);
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F2_FDH_Sub_cost_Comb_Cost__c)) {
                cd.OP_F2_FDH_Sub_cost_Cost_LU__c = (cd.OP_F2_FDH_Sub_cost_Comb_Cost__c / cd.nbr_of_Living_Units__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_FDH_Sub_cost_Cost_LU__c = CDConstants.ZERO;
            }
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) FDH Sub-cost Cost/LU -> cd.OP_F2_FDH_Sub_cost_Cost_LU__c = ' + cd.OP_F2_FDH_Sub_cost_Cost_LU__c);
            
            
            // <<--F2 Splitter sub cost -->>
            
            
            // Calculation of F2 splitter sub cost unit field
            if (AdjustdnbrLivingUnits > CDConstants.TWOHUNDRED) {
                cd.OP_F2_Splitter_Sub_cost_Unit__c = ((AdjustdnbrLivingUnits + CDConstants.SIXTEEN) / CDConstants.THIRTYTWO)?.round(System.RoundingMode.UP);
            } else {
                cd.OP_F2_Splitter_Sub_cost_Unit__c = ((AdjustdnbrLivingUnits + CDConstants.EIGHT) / CDConstants.THIRTYTWO)?.round(System.RoundingMode.UP);
            }
            
            Decimal valSpltr = CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Unit__c) + CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Sub_Unit__c);
            
            
            //Calculation of F2 Splitter sub cost material field
            if (valSpltr > CDConstants.ZERO) {
                if (cd.OP_F2_Splitter_Sub_cost_Unit__c > CDConstants.ZERO) {
                    if (buildingValue == CDConstants.SFU || buildingValue == CDConstants.COTTAGE) {
                        cd.OP_F2_Splitter_Sub_cost_Material__c = (CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Unit__c)*
                                                                  SplitterEstObj.F2_Splitter_Exterior_Material_Cost__c)?.setScale(2, System.RoundingMode.HALF_UP);
                    } else {
                        cd.OP_F2_Splitter_Sub_cost_Material__c = (CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Unit__c)*
                                                                  SplitterEstObj.F2_Splitter_Interior_Material_Cost__c)?.setScale(2, System.RoundingMode.HALF_UP);
                    }
                }
            } else {
                cd.OP_F2_Splitter_Sub_cost_Material__c = CDConstants.ZERO;
            }
            
            
            
            //Calculation of F2 splitter sub cost overhead field
            Decimal ValueMatF2SOverhead = stateCDObj.OC_General_Multiplier__c;
            if (valSpltr > CDConstants.ZERO) {
                cd.OP_F2_Splitter_Sub_cost_Overhead__c = (CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Material__c) * (ValueMatF2SOverhead - CDConstants.ONE))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Splitter_Sub_cost_Overhead__c = CDConstants.ZERO;
            }
            
            
            
            // Calculation of F2 splitter sub cost installation field
            
            if (valSpltr > CDConstants.ZERO) {
                if (cd.OP_F2_Splitter_Sub_cost_Sub_Unit__c > CDConstants.ZERO) {
                    valueSPLInst = CDConstants.ONE;
                }
                cd.OP_F2_Splitter_Sub_cost_Installation__c = ((CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Unit__c) +
                                                               CDUtility.getValue(valueSPLInst)) * CDUtility.getValue(stateCDObj.IC_Splitter__c))?.setScale(2, System.RoundingMode.HALF_UP);
            }
            
            
            //Calculation of F2 Splitter sub cost combined cost field
            if (valSpltr > CDConstants.ZERO) {
                cd.OP_F2_Splitter_Sub_cost_Combined_Cost__c = (CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Material__c) +
                                                               CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Overhead__c) +
                                                               CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Installation__c))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Splitter_Sub_cost_Combined_Cost__c = CDConstants.ZERO;
            }
            
            
            //Calculation of F2 Splitter sub cost cost/LU field
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F2_Splitter_Sub_cost_Combined_Cost__c)) {
                // Added RoundUp for getting exact values as CCT Tool
                cd.OP_F2_Splitter_Sub_cost_Cost_LU__c = ((cd.OP_F2_Splitter_Sub_cost_Combined_Cost__c / AdjustdnbrLivingUnits))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Splitter_Sub_cost_Cost_LU__c = CDConstants.ZERO;
            }
            
            
            // <<-- F2 Handhole Sub-cost -->>
            
            // Calculation of F2 Handhole Sub-cost Unit field
            if (buildingValue == CDConstants.SFU || buildingValue == CDConstants.COTTAGE) {
                if (cd.F2_nbr_of_Handhole__c != NULL) {
                    cd.OP_F2_Handhole_Sub_cost_Unit__c = cd.F2_nbr_of_Handhole__c;
                } else {
                    cd.OP_F2_Handhole_Sub_cost_Unit__c = getValueForF2Handhole(cd);
                }
            } else {
                cd.OP_F2_Handhole_Sub_cost_Unit__c = CDConstants.ZERO;
            }
            
            // Calculation of F2 Handhole Sub-cost Material field
            if (buildingValue == CDConstants.SFU || buildingValue == CDConstants.COTTAGE) {
                if (cd.OP_F2_Handhole_Sub_cost_Unit__c > CDConstants.ZERO) {
                    cd.OP_F2_Handhole_Sub_cost_Material__c = (CDUtility.getValue(cd.OP_F2_Handhole_Sub_cost_Unit__c) * CDUtility.getValue(f2CostEstObj.Material_Cost__c))?.setScale(2, System.RoundingMode.HALF_UP);
                } else {
                    cd.OP_F2_Handhole_Sub_cost_Material__c = CDConstants.ZERO;
                }
            } else {
                cd.OP_F2_Handhole_Sub_cost_Material__c = CDConstants.ZERO;
            }
            
            
            // Calculation of F2 Handhole Sub-cost Overhead field
            if (buildingValue == CDConstants.SFU || buildingValue == CDConstants.COTTAGE) {
                if (cd.OP_F2_Handhole_Sub_cost_Unit__c > CDConstants.ZERO) {
                    cd.OP_F2_Handhole_Sub_cost_Overhead__c = (CDUtility.getValue(cd.OP_F2_Handhole_Sub_cost_Material__c) *
                                                              (CDUtility.getValue(F2VFO.OC_General_Multiplier__c) - CDConstants.ONE))?.setScale(2, System.RoundingMode.HALF_UP);
                } else {
                    cd.OP_F2_Handhole_Sub_cost_Overhead__c = CDConstants.ZERO;
                }
            } else {
                cd.OP_F2_Handhole_Sub_cost_Overhead__c = CDConstants.ZERO;
            }
            
            
            // Calculation of F2 Handhole Sub-cost Installation field
            if (buildingValue == CDConstants.SFU || buildingValue == CDConstants.COTTAGE) {
                if (cd.OP_F2_Handhole_Sub_cost_Unit__c > CDConstants.ZERO) {
                    cd.OP_F2_Handhole_Sub_cost_Installation__c = (CDUtility.getValue(cd.OP_F2_Handhole_Sub_cost_Unit__c) *
                                                                  CDUtility.getValue(stateCDObj.IC_Handhole__c))?.setScale(2, System.RoundingMode.HALF_UP);
                } else {
                    cd.OP_F2_Handhole_Sub_cost_Installation__c = CDConstants.ZERO;
                }
            } else {
                cd.OP_F2_Handhole_Sub_cost_Installation__c = CDConstants.ZERO;
            }
            
            // Calculation of F2 Handhole Sub-cost Combined Cost field
            if (cd.OP_F2_Handhole_Sub_cost_Unit__c > CDConstants.ZERO) {
                cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c = (CDUtility.getValue(cd.OP_F2_Handhole_Sub_cost_Material__c) +
                                                               CDUtility.getValue(cd.OP_F2_Handhole_Sub_cost_Installation__c) +
                                                               CDUtility.getValue(cd.OP_F2_Handhole_Sub_cost_Overhead__c))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c = CDConstants.ZERO;
            }
            
            // Calculation of F2 Handhole Sub-cost Cost/LU field
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c)) {
                cd.OP_F2_Handhole_Sub_cost_Cost_LU__c = (cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c / cd.nbr_of_Living_Units__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Handhole_Sub_cost_Cost_LU__c = CDConstants.ZERO;
            }
            
            
            // <<-- Ped (MST|AP) Sub-cost-->
            
            // Calculation of Ped (MST|AP) Sub-cost Unit field
            if (buildingValue == CDConstants.SFU || buildingValue == CDConstants.COTTAGE) {
                if (cd.F2_nbr_of_Ped__c != NULL) {
                    cd.OP_F2_Ped_MST_AP_Sub_cost_Unit__c = cd.F2_nbr_of_Ped__c;
                } else {
                    cd.OP_F2_Ped_MST_AP_Sub_cost_Unit__c = getValueForPedUnit(cd);
                }
            } else {
                cd.OP_F2_Ped_MST_AP_Sub_cost_Unit__c = CDConstants.ZERO;
            }
            
            // Calculation of Ped (MST|AP) Sub-cost Material field
            if ((cd.OP_F2_Ped_MST_AP_Sub_cost_Unit__c) > CDConstants.ZERO) {
                System.debug('(CDF2OutputCalc.doF2OutputCalculations) costEst is NULL? ' + (costEst==null) + '   AND costEst?.F2_Ped_Est_Material_Cost__c = ' + costEst?.F2_Ped_Est_Material_Cost__c);
                System.debug('(CDF2OutputCalc.doF2OutputCalculations) CDUtility.getValue(costEst.F2_Ped_Est_Material_Cost__c) = ' + CDUtility.getValue(costEst.F2_Ped_Est_Material_Cost__c));
                cd.OP_F2_Ped_MST_AP_Sub_cost_Material__c = (CDUtility.getValue(cd.OP_F2_Ped_MST_AP_Sub_cost_Unit__c) *
                                                            CDUtility.getValue(costEst.F2_Ped_Est_Material_Cost__c))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Ped_MST_AP_Sub_cost_Material__c = CDConstants.ZERO;
            }
            
            
            // Calculation of Ped (MST|AP) Sub-cost Overhead field
            if (cd.OP_F2_Ped_MST_AP_Sub_cost_Unit__c > CDConstants.ZERO) {
                cd.OP_F2_Ped_MST_AP_Sub_cost_Overhead__c = (CDUtility.getValue(cd.OP_F2_Ped_MST_AP_Sub_cost_Material__c) *
                                                            (CDUtility.getValue(F2VFO.OC_General_Multiplier__c) - CDConstants.ONE))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Ped_MST_AP_Sub_cost_Overhead__c = CDConstants.ZERO;
            }
            
            
            // Calculation of Ped (MST|AP) Sub-cost Installation field
            if (cd.OP_F2_Ped_MST_AP_Sub_cost_Unit__c > CDConstants.ZERO) {
                cd.OP_F2_Ped_MST_AP_Sub_cost_Installation__c = (CDUtility.getValue(cd.OP_F2_Ped_MST_AP_Sub_cost_Unit__c) * CDUtility.getValue(stateCDObj.IC_Ped__c))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Ped_MST_AP_Sub_cost_Installation__c = CDConstants.ZERO;
            }
            
            
            // Calculation of Ped (MST|AP) Sub-cost Combined Cost field
            if (cd.OP_F2_Ped_MST_AP_Sub_cost_Unit__c > CDConstants.ZERO) {
                cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c = (CDUtility.getValue(cd.OP_F2_Ped_MST_AP_Sub_cost_Material__c) +
                                                             CDUtility.getValue(cd.OP_F2_Ped_MST_AP_Sub_cost_Installation__c) +
                                                             CDUtility.getValue(cd.OP_F2_Ped_MST_AP_Sub_cost_Overhead__c))?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c = CDConstants.ZERO;
            }
            
            // Calculation of Ped (MST|AP) Sub-cost Cost/LU field
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c)) {
                cd.OP_F2_Ped_MST_AP_Sub_cost_Cost_LU__c = (cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c / cd.nbr_of_Living_Units__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Ped_MST_AP_Sub_cost_Cost_LU__c = CDConstants.ZERO;
            }
            
            
            // <<--F2 Mobilization (eng-time, permit, flagging) Sub-cost-->>
            
            // Calculation of F2 Mobilization (eng-time, permit, flagging) Sub-cost Combined Cost field
            if (cd.F2_Mobilization_Cost__c != NULL) {
                cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c = (cd.F2_Mobilization_Cost__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else if (getValueForF2Mobilization(cd) != NULL) {
                cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c = (getValueForF2Mobilization(cd))?.setScale(2, System.RoundingMode.HALF_UP);
            }
            
            // Calculation of F2 Mobilization (eng-time, permit, flagging) Sub-cost Cost/LU field
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c)) {
                cd.OP_F2Mobi_engtime_prmt_flag_SBcst_CstLU__c = (cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c / cd.nbr_of_Living_Units__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2Mobi_engtime_prmt_flag_SBcst_CstLU__c = CDConstants.ZERO;
            }
            
            // <<--F2 Pole Make-Ready Sub-cost-->>
            
            // Calculation of F2 Pole Make-Ready Sub-cost Combined Cost field
            cd.OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c = (CDUtility.getValue(cd.F2_Pole_Make_Ready_Cost__c))?.setScale(2, System.RoundingMode.HALF_UP);
            
            // <<--F2 Pole Anchor & Guy Sub-cost-->>
            
            // Calculation of F2 Pole Anchor & Guy Sub-cost Combined Cost field
            cd.OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c = (CDUtility.getValue(cd.F2_Pole_Anchor_and_Guy_Cost__c))?.setScale(2, System.RoundingMode.HALF_UP);
            
            // <<--F2 Pothole Restoration Sub-cost-->>
            
            // Calculation of F2 Pothole Restoration Sub-cost Combined Cost field
            cd.OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c = (CDUtility.getValue(cd.F2_Pothole_Restoration_Cost__c))?.setScale(2, System.RoundingMode.HALF_UP);
            
            
            // <<-- F2 Horizontal Fiber Sub-cost -->>
            
            // Calculation of F2 Horizontal Fiber Sub-cost Combined Cost field
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.Building_Style__c = ' + cd.Building_Style__c + '  AND cd.Are_there_IDF__c = ' + cd.Are_there_IDF__c);
            if(CDUtility.getBuildStyle(cd.Building_Style__c) == CDConstants.MIDRISE && cd.Are_there_IDF__c == 'No')
            {
                cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = CDConstants.ZERO;
            }else if(cd.F2_Sub_Total_of_Cost__c != NULL && cd.F2_Sub_Total_of_Cost__c > 0)
            {
                System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.F2_Sub_Total_of_Cost__c = ' + cd.F2_Sub_Total_of_Cost__c + '  AND cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c = ' + cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c);
                System.debug('(CDF2OutputCalc.doF2OutputCalculations) CDUtility.getValue(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c) = ' + CDUtility.getValue(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c));
                cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = (cd.F2_Sub_Total_of_Cost__c - CDUtility.getValue(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c))?.setScale(2, System.RoundingMode.HALF_UP);
                System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = ' + cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c);
            }else if (cd.Project_Type__c == CDConstants.GREENFIELD) {
                cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = ((CDUtility.getValue(stateCDObj.F2_Cost_ft_FW_Blended__c) * 
                                                                  CDUtility.getValue(stateCDObj.F2_Cost_ft_FW_Greenfield_F2_Multiplier__c) *
                                                                  valFootage) - CDUtility.getValue(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c))?.setScale(2, System.RoundingMode.HALF_UP);
            } else if (cd.Project_Type__c == CDConstants.BROWNFIELD) {
                cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = ((CDUtility.getValue(stateCDObj.F2_Cost_ft_FW_Blended__c) * 
                                                                  CDUtility.getValue(stateCDObj.F2_Cost_ft_FW_Brownfield_F2_Multiplier__c) *
                                                                  valFootage ) - CDUtility.getValue(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c))?.setScale(2, System.RoundingMode.HALF_UP);
            } else
            {
                cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = CDConstants.ZERO;
            }
            
            
            // Calculation of  F2 Horizontal Fiber Sub-cost Cost/ft field
            if (CDUtility.isValGreaterThanZero(valFootage) && CDUtility.isValGreaterThanZero(cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c)) {
                cd.OP_F2_Horizontal_Fiber_Sub_cost_Cost_ft__c = (cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c / valFootage)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Horizontal_Fiber_Sub_cost_Cost_ft__c = CDConstants.ZERO;
            }
            
            // Calculation of F2 Horizontal Fiber Sub-cost Cost/LU field
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c)) {
                cd.OP_F2_Horizontal_Fiber_Sub_cost_Cost_LU__c = ((cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c) / cd.nbr_of_Living_Units__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2_Horizontal_Fiber_Sub_cost_Cost_LU__c = CDConstants.ZERO;
            }
            
            // <<-- F2 Subtotal-cost (w/o F2 Cond, FDH & Splitter) -->>
            
            // Calculation of F2 Subtotal-cost (w/o F2 Cond, FDH & Splitter) Combined Cost field
            cd.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c = (CDUtility.getValue(cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c) +
                                                             CDUtility.getValue(cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c) +
                                                             CDUtility.getValue(cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c) +
                                                             CDUtility.getValue(cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c) +
                                                             CDUtility.getValue(cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c) +
                                                             CDUtility.getValue(cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c) +
                                                             CDUtility.getValue(cd.OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c) +
                                                             CDUtility.getValue(cd.OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c) +
                                                             CDUtility.getValue(cd.OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c))?.setScale(2, System.RoundingMode.HALF_UP);
            
            // Calculation of F2 Subtotal-cost (w/o F2 Cond, FDH & Splitter) Cost/ft field
            if (CDUtility.isValGreaterThanZero(valFootage) && CDUtility.isValGreaterThanZero(cd.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c)) {
                cd.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Cost_ft__c = (cd.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c / valFootage)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Cost_ft__c = CDConstants.ZERO;
            }
            
            // Calculation of F2 Subtotal-cost (w/o F2 Cond, FDH & Splitter) Cost/LU field
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) && CDUtility.isValGreaterThanZero(cd.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c)) {
                cd.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Cost_LU__c = (cd.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c / cd.nbr_of_Living_Units__c)?.setScale(2, System.RoundingMode.HALF_UP);
            } else {
                cd.OP_F2SBcst_w_oF2Cond_FDH_Spltr_Cost_LU__c = CDConstants.ZERO;
            }
            
            
            //  <<-- F2 Total-Cost -->>
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = ' + cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c = ' + cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c = ' + cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c = ' + cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2_FDH_Sub_cost_Comb_Cost__c = ' + cd.OP_F2_FDH_Sub_cost_Comb_Cost__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2_Splitter_Sub_cost_Combined_Cost__c = ' + cd.OP_F2_Splitter_Sub_cost_Combined_Cost__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c = ' + cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c = ' + cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c = ' + cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c = ' + cd.OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c = ' + cd.OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c);
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) cd.OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c = ' + cd.OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c);
            //Calculation of OP F2 Total-Cost Combined Cost field 
            cd.OP_F2_Total_Cost_Combined_Cost__c = (CDUtility.getValue(cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c) +
                                                    CDUtility.getValue(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c) +
                                                    CDUtility.getValue(cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c) +
                                                    CDUtility.getValue(cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c) +
                                                    CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Comb_Cost__c) +
                                                    CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Combined_Cost__c) +
                                                    CDUtility.getValue(cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c) +
                                                    CDUtility.getValue(cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c) +
                                                    CDUtility.getValue(cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c) +
                                                    CDUtility.getValue(cd.OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c) +
                                                    CDUtility.getValue(cd.OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c) +
                                                    CDUtility.getValue(cd.OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c))?.setScale(2, System.RoundingMode.HALF_UP);
            
            // Calculation of F2 Total-Cost Cost/LU field
            
            Decimal varf2totalcost;
            if(CDUtility.isValGreaterThanZero(AdjustdnbrLivingUnits))
            {
                varf2totalcost =  (CDUtility.getValue(cd.OP_F2_Splitter_Sub_cost_Combined_Cost__c) / AdjustdnbrLivingUnits)?.setScale(2, System.RoundingMode.HALF_UP);        
            }
            else
            {
                varf2totalcost = CDConstants.ZERO;
            }
            if (CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c) &&
                CDUtility.isValGreaterThanZero(cd.OP_F2_Splitter_Sub_cost_Combined_Cost__c)) {
                    cd.OP_F2_Total_Cost_Cost_LU__c = (((CDUtility.getValue(cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c) +
                                                        CDUtility.getValue(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c) +
                                                        CDUtility.getValue(cd.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c) +
                                                        CDUtility.getValue(cd.OP_F2_Splicing_Sub_cost_Combined_Cost__c) +
                                                        CDUtility.getValue(cd.OP_F2_FDH_Sub_cost_Comb_Cost__c) +
                                                        CDUtility.getValue(cd.OP_F2_Handhole_Sub_cost_Combined_Cost__c) +
                                                        CDUtility.getValue(cd.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c) +
                                                        CDUtility.getValue(cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c) +
                                                        CDUtility.getValue(cd.OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c) +
                                                        CDUtility.getValue(cd.OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c) +
                                                        CDUtility.getValue(cd.OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c)) /
                                                       cd.nbr_of_Living_Units__c))?.setScale(2, System.RoundingMode.HALF_UP) + (varf2totalcost);
                } else {
                    cd.OP_F2_Total_Cost_Cost_LU__c = CDConstants.ZERO;
                }
            System.debug('-----From F2Output cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c----- '+CDUtility.getValue(cd.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c));
            System.debug('-----From F2Output cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c---- '+CDUtility.getValue(cd.OP_F2_Conduit_Sub_cost_Combined_Cost__c));
        }catch(Exception e){
            System.debug('(CDF2OutputCalc.doF2OutputCalculations) EXCEPTION! \n Type: ' + e.getTypeName() + '\n Message:  ' + e.getMessage() + '\n Line#: ' + e.getLineNumber() + '\n StackTrace:  ' + e.getStackTraceString());
            
        }
    }
    
    /******************************************************************************************************************** 
  * @Developer : Muhammad Nadeer MK
  * @Method : getValueForFDHMat
  * @Params : Input parameter Capital_Design__c object's field
  * @Descriptions : ESCJ-497
  * 				   For performing Calculation for Fiber Distribution Hub (FDH) Sub-cost Material field and
  *                  Fiber Distribution Hub (FDH) Sub-cost Unit field in F2 Output Section. (K16)
  ******************************************************************************************************************/
    public static decimal getValueForFDHMat(Capital_Design__c cd) {
        decimal val = null;
        if (CDUtility.getAdjustedOntModel(cd.ONT_Model__c) == CDConstants.FTTIDF || CDUtility.getAdjustedOntModel(cd.ONT_Model__c) == CDConstants.FTTB) {
            val = (CDUtility.getValue(cd.nbr_of_Living_Units__c) * (CDConstants.POINTTHREE))?.setScale(0, System.RoundingMode.HALF_UP);
        } else {
            val = cd.nbr_of_Living_Units__c;
        }
        return val;
        
    }
    
    
    /******************************************************************************************************************** 
  * @Developer : Muhammad Nadeer MK
  * @Method : getValueForF2HF
  * @Params : Input parameter Capital_Design__c object's field
  * @Descriptions : ESCJ-497
  * 				   For performing Calculation for F2 Subtotal-cost (w/o F2 Cond, FDH & Splitter) Cost/ft field,
  *                  F2 Horizontal Fiber Sub-cost Combined Cost field, F2 Horizontal Fiber Sub-cost Cost/ft field,
  *                  F2 Conduit Sub-cost Cost/ft field and F2 Conduit Sub-cost Unit field in F2 Output Section.
  ******************************************************************************************************************/
    public static decimal getValueForF2HF(Capital_Design__c cd) {
        decimal val = null;
        Map < String, CCT_F2_Cost_Estimator__c > f2CostEstDataMap = CapitalDesignCalculationHelper.initializeF2CostEstimatorMap();
        CCT_F2_Cost_Estimator__c footageBldFOrCottage = f2CostEstDataMap.get(CDConstants.COTTAGE);
        CCT_F2_Cost_Estimator__c footageBldFOrMidrise100 = f2CostEstDataMap.get(CDConstants.MIDRISELESSTHAN100);
        CCT_F2_Cost_Estimator__c footageBldFOrMidrise = f2CostEstDataMap.get(CDConstants.MIDRISE);
        CCT_F2_Cost_Estimator__c footageBldFOrHighrise = f2CostEstDataMap.get(CDConstants.HIGHRISE);
        String valueforF2vf = CDUtility.getAdjstBuildingStyle(cd);
        if (footageBldFOrMidrise != NULL &&
            footageBldFOrMidrise100 != NULL &&
            footageBldFOrCottage != NULL &&
            footageBldFOrHighrise != NULL) {
                if (valueforF2vf == CDConstants.SFU) {
                    val = CDUtility.getValue(cd.nbr_of_Living_Units__c) * Decimal.valueOf(cd.for_SFU_Average_Lot_Size__c);
                } else if (valueforF2vf == CDConstants.COTTAGE) {
                    val = CDUtility.getValue(cd.for_MDU_nbr_of_Buildings__c) * CDUtility.getValue(footageBldFOrCottage.F2_CostE_Footage_Bld__c);
                } else if (valueforF2vf == CDConstants.MIDRISELESSTHAN100) {
                    val = CDUtility.getValue(cd.for_MDU_nbr_of_Buildings__c) *
                        CDUtility.getValue(footageBldFOrMidrise100.F2_CostE_Footage_Bld__c) + CDUtility.getValue(cd.for_Midrise_Highrise_nbof_average_Floors__c) *
                        CDUtility.getValue(footageBldFOrMidrise100.F2_CostE_Footage_Flr__c);
                } else if (valueforF2vf == CDConstants.MIDRISE) {
                    val = CDUtility.getValue(cd.for_MDU_nbr_of_Buildings__c) * CDUtility.getValue(footageBldFOrMidrise.F2_CostE_Footage_Bld__c) +
                        CDUtility.getValue(cd.for_Midrise_Highrise_nbof_average_Floors__c) *
                        CDUtility.getValue(footageBldFOrMidrise.F2_CostE_Footage_Flr__c);
                } else if (valueforF2vf == CDConstants.HIGHRISE) {
                    val = CDUtility.getValue(cd.for_MDU_nbr_of_Buildings__c) * CDUtility.getValue(footageBldFOrHighrise.F2_CostE_Footage_Bld__c) +
                        CDUtility.getValue(cd.for_Midrise_Highrise_nbof_average_Floors__c) *
                        CDUtility.getValue(footageBldFOrHighrise.F2_CostE_Footage_Flr__c);
                }
            }
        return (val)?.setScale(0, System.RoundingMode.HALF_UP);
    }
    
    
    /******************************************************************************************************************** 
  * @Developer : Muhammad Nadeer MK
  * @Method : getValueForF2MobiCombCst
  * @Params : Input parameter Capital_Design__c object's field
  * @Descriptions : ESCJ-497
  * 				   For performing Calculation for F2 Mobilization (eng-time, permit, flagging) Sub-cost Combined Cost field
  *                       in F2 Output Section.
  ******************************************************************************************************************/
    public static decimal getValueForF2MobiCombCst(Capital_Design__c cd) {
        decimal val = null;
        val = CDUtility.getValue(cd?.OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c) +
            CDUtility.getValue(cd?.OP_F2_Conduit_Sub_cost_Combined_Cost__c) +
            CDUtility.getValue(cd?.OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c) +
            CDUtility.getValue(cd?.OP_F2_Splicing_Sub_cost_Combined_Cost__c) +
            CDUtility.getValue(cd?.OP_F2_FDH_Sub_cost_Comb_Cost__c) +
            CDUtility.getValue(cd?.OP_F2_Splitter_Sub_cost_Combined_Cost__c) +
            CDUtility.getValue(cd?.OP_F2_Handhole_Sub_cost_Combined_Cost__c) +
            CDUtility.getValue(cd?.OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c) +
            CDUtility.getValue(cd?.OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c) +
            CDUtility.getValue(cd?.OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c) +
            CDUtility.getValue(cd?.OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c);
        return (val)?.setScale(2, System.RoundingMode.HALF_UP);
    }
    
    /******************************************************************************************************************** 
  * @Developer : Muhammad Nadeer MK
  * @Method : getValueForF2Mobilization
  * @Params : Input parameter Capital_Design__c object's field
  * @Descriptions : ESCJ-497
  * 				   For performing Calculation for F2 Mobilization (eng-time, permit, flagging) Sub-cost Combined Cost field
  *                   in F2 Output Section.
  ******************************************************************************************************************/
    public static decimal getValueForF2Mobilization(Capital_Design__c cd) {
        decimal val = null;
        decimal val1 = null;
        StatesCostforCapitalDesign__c stateCDObj = CapitalDesignTriggerHelper.stateDataMap.get(cd?.Property_Address_State__c);
        Decimal f2mobiComCost = getValueForF2MobiCombCst(cd);
        if (stateCDObj != NULL && f2mobiComCost != NULL) {
            if (f2mobiComCost > CDConstants.TWOLAKH) {
                val1 = stateCDObj.F2_Eng_time_Cost_Over_200K_OVH__c;
            } else if (f2mobiComCost > CDConstants.ONELAKH) {
                val1 = stateCDObj.F2_Eng_time_Cost_100K_200K_OVH__c;
            } else if (f2mobiComCost > CDConstants.FIFTHYTHOUSAND) {
                val1 = stateCDObj.F2_Eng_time_Cost_50K_100K_OVH__c;
            } else {
                val1 = stateCDObj.F2_Eng_time_Cost_Under_50K_OVH__c;
            }
            if ((f2mobiComCost *  (val1/CDConstants.HUNDRED)) < CDConstants.FIVETHOUSAND) {
                val = CDConstants.FIVETHOUSAND;
            } else {
                val = f2mobiComCost *  (val1/CDConstants.HUNDRED);
            }
        }
        
        return (val)?.setScale(2, System.RoundingMode.HALF_UP);
    }
    
    /******************************************************************************************************************** 
  * @Developer : Muhammad Nadeer MK
  * @Method : getValueForF2Handhole
  * @Params : Input parameter Capital_Design__c object's field
  * @Descriptions : ESCJ-497
  * 				   For performing Calculation for F2 Handhole Sub-cost Unit field in F2 Output Section.(I76)
  ******************************************************************************************************************/
    public static decimal getValueForF2Handhole(Capital_Design__c cd) {
        decimal val = null;
        System.debug('(CDF2OPCalc.getValueForF2Handhole) cd is NULL? ' + (cd==null) + '  and cd?.Building_Style__c = ' + cd?.Building_Style__c);
        String buildingValue = CDUtility.getBuildStyle(cd?.Building_Style__c);
        System.debug('(CDF2OPCalc.getValueForF2Handhole) buildingValue = ' + buildingValue);
        if (buildingValue == CDConstants.COTTAGE) {
            if (cd?.F2_Footage_ft__c != NULL) {
                if (CDUtility.isValGreaterThanZero(cd?.F2_Footage_ft__c)) {
                    System.debug('(CDF2OPCalc.getValueForF2Handhole) Calculating F2Handhole VAL using cd?.F2_Footage_ft__c = ' + cd?.F2_Footage_ft__c);
                    val = (cd?.F2_Footage_ft__c / CDConstants.THREETHOUSAND)?.setScale(0, System.RoundingMode.HALF_UP);
                }
            } else {
                if (cd!=null && CDUtility.isValGreaterThanZero(getValueForF2HF(cd))) {
                    System.debug('(CDF2OPCalc.getValueForF2Handhole) Calculating F2Handhole VAL using getValueForF2HF(cd) = ' + (getValueForF2HF(cd)));
                    val = (getValueForF2HF(cd) / CDConstants.THREETHOUSAND)?.setScale(0, System.RoundingMode.HALF_UP);
                }
            }
        } else if (buildingValue == CDConstants.SFU) {
            System.debug('(CDF2OPCalc.getValueForF2Handhole) Calculating F2Handhole VAL using cd?.nbr_of_Living_Units__c = ' + cd?.nbr_of_Living_Units__c);
            val = (cd?.nbr_of_Living_Units__c / CDConstants.TWOHUNDRED)?.setScale(0, System.RoundingMode.HALF_UP);
        }
        return val;
    }
    
    /******************************************************************************************************************** 
  * @Developer : Muhammad Nadeer MK
  * @Method : getValueForPedUnit
  * @Params : Input parameter Capital_Design__c object's field
  * @Descriptions : ESCJ-497
  * 				   For performing Calculation for Ped (MST|AP) Sub-cost Unit field in F2 Output Section.(I77)
  ******************************************************************************************************************/
    public static decimal getValueForPedUnit(Capital_Design__c cd) {
        CCT_Cost_Estimator__c costEst = CapitalDesignTriggerHelper.costEstDataMapByState.get(cd.Property_Address_State__c);
        decimal val = null;
        
        String buildingValue = CDUtility.getBuildStyle(cd.Building_Style__c);
        if (buildingValue == CDConstants.SFU && costEst.F2_Ped_Est_SFU_LU_Ped__c != NULL) {
            if (CDUtility.isValGreaterThanZero(costEst.F2_Ped_Est_SFU_LU_Ped__c) && CDUtility.isValGreaterThanZero(cd.nbr_of_Living_Units__c)) {
                val = (cd.nbr_of_Living_Units__c / costEst.F2_Ped_Est_SFU_LU_Ped__c)?.setScale(0, System.RoundingMode.HALF_UP);
            }
        } else if (buildingValue == CDConstants.COTTAGE && costEst.F2_Ped_Est_Cottage_bld_Ped__c != NULL) {
            if (CDUtility.isValGreaterThanZero(costEst.F2_Ped_Est_Cottage_bld_Ped__c) && CDUtility.isValGreaterThanZero(cd.for_MDU_nbr_of_Buildings__c)) {
                val = (cd.for_MDU_nbr_of_Buildings__c / costEst.F2_Ped_Est_Cottage_bld_Ped__c)?.setScale(0, System.RoundingMode.HALF_UP);
            }
        }
        return val;
    }
    
    /******************************************************************************************************************** 
  * @Developer : Muhammad Nadeer MK
  * @Method : getValueForFDHSbUnit
  * @Params : Input parameter Capital_Design__c object's field
  * @Descriptions : ESCJ-497
  * 				   For performing Calculation for Fiber Distribution Hub (FDH) Sub-cost Sub-unit field in F2 Output Section. (I78)
  ******************************************************************************************************************/
    public static decimal getValueForFDHSbUnit(Capital_Design__c cd) {
        decimal val = null;
        Integer varFDHMaterialField;
        CCT_F2_FDH_Estimator__c f2FDHEStIndoor;
        CCT_F2_FDH_Estimator__c f2FDHEStOutdoor;
        Integer varFDHMatCalculation =Integer.valueof((CDUtility.getValue(getValueForFDHMat(cd))* CDConstants.ONEPOINTZEROFIVE)?.setScale(0, System.RoundingMode.HALF_UP)); //ESCj-1730 bug fix
        if (varFDHMatCalculation > CDConstants.FOURHUNDREDANDTHIRTYTWO) { //ESCJ-1623 Bug Fix
            varFDHMaterialField = math.mod(varFDHMatCalculation, CDConstants.FOURHUNDREDANDTHIRTYTWO);
        } else {
            varFDHMaterialField = varFDHMatCalculation;
        }
        String VarFDH = String.valueof(varFDHMaterialField);
        VarFDH = varFDH + '.00000'; //ESCJ-1730 bug fix
        Decimal varFDHdec = Decimal.valueOf(varFDH);
        //Indoor
        if(varFDHdec == CDConstants.THIRTYTWOPOINTZERO || varFDHdec == CDConstants.SEVENTYTWOPOINTZERO || varFDHdec == CDConstants.NINTYSIXPOINTZERO ||
           varFDHdec == CDConstants.ONEFOURTYFOURPOINTZERO || varFDHdec == CDConstants.TWOONESIXPOINTZERO ||
           varFDHdec == CDConstants.TWOEIGHTYEIGHTPOINTZERO || varFDHdec == CDConstants.THREESIXZEROPOINTZERO || varFDHdec == CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO)
        {
            f2FDHEStIndoor = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(varFDHdec);
            
        }else if(varFDHdec < CDConstants.THIRTYTWOPOINTZERO){
            f2FDHEStIndoor = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDConstants.THIRTYTWOPOINTZERO);
        }else if(varFDHdec < CDConstants.SEVENTYTWOPOINTZERO)
        {
            f2FDHEStIndoor = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDConstants.SEVENTYTWOPOINTZERO);
        }else if(varFDHdec < CDConstants.NINTYSIXPOINTZERO)
        {
            f2FDHEStIndoor = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDConstants.NINTYSIXPOINTZERO);
        }else if(varFDHdec < CDConstants.ONEFOURTYFOURPOINTZERO)
        {
            f2FDHEStIndoor = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDConstants.ONEFOURTYFOURPOINTZERO);
        }else if(varFDHdec < CDConstants.TWOONESIXPOINTZERO)
        {
            f2FDHEStIndoor = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDConstants.TWOONESIXPOINTZERO);
        }else if(varFDHdec < CDConstants.TWOEIGHTYEIGHTPOINTZERO)
        {
            f2FDHEStIndoor = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDConstants.TWOEIGHTYEIGHTPOINTZERO);
        }else if(varFDHdec < CDConstants.THREESIXZEROPOINTZERO)
        {
            f2FDHEStIndoor = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDConstants.THREESIXZEROPOINTZERO);
        }else if(varFDHdec < CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO)
        {
            f2FDHEStIndoor = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO);
        }
        if(f2FDHEStIndoor == NULL)
        {
            f2FDHEStIndoor = CapitalDesignTriggerHelper.f2FDHEstIndoorMap.get(CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO);
        }
        
        //Outdoor      
        if(varFDHdec == CDConstants.THIRTYTWOPOINTZERO || varFDHdec == CDConstants.SEVENTYTWOPOINTZERO || varFDHdec == CDConstants.SIXTYFOURPOINTZERO ||
           varFDHdec == CDConstants.ONEFOURTYFOURPOINTZERO || varFDHdec == CDConstants.TWOONESIXPOINTZERO ||
           varFDHdec == CDConstants.TWOEIGHTYEIGHTPOINTZERO || varFDHdec == CDConstants.THREESIXZEROPOINTZERO || varFDHdec == CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO)
        {
            f2FDHEStOutdoor = CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.get(varFDHdec);
            
        }else if(varFDHdec < CDConstants.THIRTYTWOPOINTZERO){
            f2FDHEStOutdoor = CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.get(CDConstants.THIRTYTWOPOINTZERO);
        }else if(varFDHdec < CDConstants.SIXTYFOURPOINTZERO)
        {
            f2FDHEStOutdoor = CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.get(CDConstants.SIXTYFOURPOINTZERO);
        }else if(varFDHdec < CDConstants.SEVENTYTWOPOINTZERO)
        {
            f2FDHEStOutdoor = CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.get(CDConstants.SEVENTYTWOPOINTZERO);
        }else if(varFDHdec < CDConstants.ONEFOURTYFOURPOINTZERO)
        {
            f2FDHEStOutdoor = CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.get(CDConstants.ONEFOURTYFOURPOINTZERO);
        }else if(varFDHdec < CDConstants.TWOEIGHTYEIGHTPOINTZERO)
        {
            f2FDHEStOutdoor = CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.get(CDConstants.TWOEIGHTYEIGHTPOINTZERO);
        }else if(varFDHdec < CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO)
        {
            f2FDHEStOutdoor = CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.get(CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO);
        }
        if(f2FDHEStOutdoor == NULL)
        {
            f2FDHEStOutdoor = CapitalDesignTriggerHelper.f2FDHEstOutDoorMap.get(CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO);
        }
        String buildingValue = CDUtility.getBuildStyle(cd.Building_Style__c);
        if (f2FDHEStIndoor != NULL || f2FDHEStOutdoor != NULL) { // ESCJ-1623 Bug Fix
            if (buildingValue == CDConstants.MIDRISE || buildingValue == CDConstants.HIGHRISE) {
                val = f2FDHEStIndoor.F2_FDHE_Indoor_LU_FDH__c;
            } else {
                val = f2FDHEStOutdoor.F2_FDHE_Outdoor_LU_FDH__c;
            }
        }
        return val;
    }
    /******************************************************************************************************************** 
  * @Developer : Pooja Kumari
  * @Method : getValueForFDHSize()
  * @Params : Input parameter Capital_Design__c object's field and unist size * 1.05 decimal value
  * @Descriptions : ESCJ-1816
  * 				   For performing Calculation for default FDH Size for F2 Tab cct
  ******************************************************************************************************************/
    public static decimal getValueForFDHSize(Capital_Design__c cd,decimal nbrBufferVal) {
        Integer val = null;
        Integer varFDHMaterialField;
        Integer f2FDHEStIndoor;
        Integer f2FDHEStOutdoor;
        Decimal fdhSize = nbrBufferVal;
        
        //Indoor
        if(fdhSize <= CDConstants.THIRTYTWOPOINTZERO){
            f2FDHEStIndoor = CDConstants.THIRTYTWO;
        }else if(fdhSize <= CDConstants.SEVENTYTWOPOINTZERO)
        {
            f2FDHEStIndoor = CDConstants.SEVENTYTWO;
        }else if(fdhSize <= CDConstants.NINTYSIXPOINTZERO)
        {
            f2FDHEStIndoor = CDConstants.NINTYSIX;
        }else if(fdhSize <= CDConstants.ONEFOURTYFOURPOINTZERO)
        {
            f2FDHEStIndoor = CDConstants.ONEFOURTYFOUR;
        }else if(fdhSize <= CDConstants.TWOONESIXPOINTZERO)
        {
            f2FDHEStIndoor = CDConstants.TWOONESIX;
        }else if(fdhSize <= CDConstants.TWOEIGHTYEIGHTPOINTZERO)
        {
            f2FDHEStIndoor = CDConstants.TWOEIGHTYEIGHT;
        }else if(fdhSize <= CDConstants.THREESIXZEROPOINTZERO)
        {
            f2FDHEStIndoor = CDConstants.THREESIXZERO;
        }else if(fdhSize <= CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO)
        {
            f2FDHEStIndoor = CDConstants.FOURHUNDREDANDTHIRTYTWO;
        }
        
        
        //Outdoor      
        if(fdhSize <= CDConstants.THIRTYTWOPOINTZERO){
            f2FDHEStOutdoor = CDConstants.THIRTYTWO;
        }else if(fdhSize <= CDConstants.SIXTYFOURPOINTZERO)
        {
            f2FDHEStOutdoor = CDConstants.SIXTYFOUR;
        }else if(fdhSize <= CDConstants.SEVENTYTWOPOINTZERO)
        {
            f2FDHEStOutdoor = CDConstants.SEVENTYTWO;
        }else if(fdhSize <= CDConstants.ONEFOURTYFOURPOINTZERO)
        {
            f2FDHEStOutdoor = CDConstants.ONEFOURTYFOUR;
        }else if(fdhSize <= CDConstants.TWOEIGHTYEIGHTPOINTZERO)
        {
            f2FDHEStOutdoor = CDConstants.TWOEIGHTYEIGHT;
        }else if(fdhSize <= CDConstants.FOURHUNDREDANDTHIRTYTWOPOINTZERO)
        {
            f2FDHEStOutdoor = CDConstants.FOURHUNDREDANDTHIRTYTWO;
        }
        String buildingValue = CDUtility.getBuildStyle(cd.Building_Style__c);
        if (f2FDHEStIndoor != NULL || f2FDHEStOutdoor != NULL) {
            if (buildingValue == CDConstants.MIDRISE || buildingValue == CDConstants.HIGHRISE) {
                val = f2FDHEStIndoor;
            } else {
                val = f2FDHEStOutdoor;
            }
            
        }
        system.debug('FDHSize##'+val);
        return val;
    }
  }//end class CapitalDesignF2OutputCalculation