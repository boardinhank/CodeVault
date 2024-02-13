/**
* @author  : IBM
* @Description : This class will help to maintain common utility methods
* @Date : 16/02/2022
*  
* 
===============================================================================================
* Date         Author      UserStory          Description  
* 08/02/2023   T2Cabato    QFCJ-4286          BRAIN-Drop-Cost-Fix                   
* 08/31/2023   T2Cabato    QFCJ-4469      	  SmartNID Residential-Gateway Material Cost Calculation
* 10/02/2023   T2Cabato    QFCJ-4636          F2 FDH Size in output section not pulling correct values from cost table 
***********************************************************************************************/
// write method level commens
public class CDUtility {
    
    /**
* This method will help to check the Field value is null or not null
* oupput number value 
* Input : Number fieldValue
**/
    public static Decimal getValue(Decimal fieldValue){
        
        return fieldValue != null ? fieldValue: 0;
    }
    
    /**
* This method check for string if two strings are equal or not, using equalsIgnoreCase.
* Output boolean value 
* Input : two string values 
**/
    public static boolean isStringsEqual(String str1, String str2){
        if(String.isBlank(str1)){ return false;}
        if(String.isBlank(str2)){ return false;}
        return str1.equalsIgnoreCase(str2);
    }
    
    /**
* This method to check the Field value is null and it's > 0
* output boolean value 
* Input : Number fieldValue
**/
    public static boolean isValGreaterThanZero(Decimal fieldValue){
        return fieldValue != null && fieldValue > 0;
    }
    
    /**
* This method is used to avoid NPE when we are trying to mulitple values.
* Input : Number fieldValue
* output : decimal fieldvalue or 1 
**/
    public static decimal getValForMultiply(Decimal fieldValue){
        return fieldValue != null ?  fieldValue : 1;
    }
    
    
    /**
* This method is used to get Build style.
* Input : Number fieldValue
* output : String fieldvalue 
**/
    public static String getBuildStyle(String fieldValue){
        return String.isNotBlank(fieldValue) ?  fieldValue.split(' ')[0] : '' ;
    }
    
    /**
* This method to return the cost/LU from F4 cost tables based on
* buildingStyle, projectType, FiberType and installType and being used in output f4 section.
* Input : CD Object and Install type.
* Output cost/lu based on matching column in F4 cost tables
**/
    public static decimal getF4CostBasedOnBuildAndInstallType(Capital_Design__c cd, String installType, StatesCostforCapitalDesign__c f4CostSFURecord){
        decimal f4Cost = null;
        //for SFU
        String buildingStyle = getBuildStyle(cd?.Building_Style__c);
        if(CDUtility.isStringsEqual(buildingStyle, CDConstants.SFU)){
            if(CDUtility.isStringsEqual(cd?.Project_Type__c, CDConstants.GREENFIELD)){
                if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_SFU_GF_CTL_Prov_Rugged_CTL_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_SFU_GF_CTL_Prov_Rugged_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_SFU_GF_CTL_Prov_Rugged_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_SFU_GF_CTL_Prov_Micro_CTL_Inst__c; 
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_SFU_GF_CTL_Prov_Micro_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_SFU_GF_CTL_Prov_Micro_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_DUCT) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_SFU_GF_CTL_Prov_Duct_Dev_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_FIBER) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_SFU_GF_CTL_Prov_Fiber_CTL_Inst__c;
                }
            }else if(CDUtility.isStringsEqual(cd?.Project_Type__c, CDConstants.BROWNFIELD)) {
                if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_SFU_BF_CTL_Prov_Rugged_CTL_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_SFU_BF_CTL_Prov_Rugged_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_SFU_BF_CTL_Prov_Rugged_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_SFU_BF_CTL_Prov_Micro_CTL_Inst__c; 
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_SFU_BF_CTL_Prov_Micro_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_SFU_BF_CTL_Prov_Micro_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_DUCT) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_SFU_BF_CTL_Prov_Duct_Dev_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_FIBER) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_SFU_BF_CTL_Prov_Fiber_CTL_Inst__c;
                }
            }
            //for COTTAGE
        }else if(CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE)){
            if(CDUtility.isStringsEqual(cd?.Project_Type__c, CDConstants.GREENFIELD)){
                if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_Cottage_GF_CTL_Prov_Rugged_CTL_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_Cottage_GF_CTL_Prov_Rugged_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_Cottage_GF_CTL_Prov_Rugged_Dev_Inst_N__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_Cottage_GF_CTL_Prov_Micro_CTL_Inst__c; 
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_Cottage_GF_CTL_Prov_Micro_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_Cottage_GF_CTL_Prov_Micro_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_DUCT) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_Cottage_GF_CTL_Prov_Duct_Dev_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_FIBER) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_Cottage_GF_CTL_Prov_Fiber_CTL_Inst__c;
                }
            }else if(CDUtility.isStringsEqual(cd?.Project_Type__c, CDConstants.BROWNFIELD)) {
                if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_Cottage_BF_CTL_Prov_Rugged_CTL_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_Cottage_BF_CTL_Prov_Rugged_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_Cottage_BF_CTL_Prov_Rugged_Dev_Inst_N__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_Cottage_BF_CTL_Prov_Micro_CTL_Inst__c; 
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_Cottage_BF_CTL_Prov_Micro_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_Cottage_BF_CTL_Prov_Micro_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_DUCT) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_Cottage_BF_CTL_Prov_Duct_Dev_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_FIBER) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_Cottage_BF_CTL_Prov_Fiber_CTL_Inst__c;
                }
            }
            //For MIDRISE    
        }else if(CDUtility.isStringsEqual(buildingStyle, CDConstants.MIDRISE)){
            if(CDUtility.isStringsEqual(cd?.Project_Type__c, CDConstants.GREENFIELD)){
                if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_MidR_GF_CTL_Prov_Rugged_CTL_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_MidR_GF_CTL_Prov_Rugged_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_MidR_GF_CTL_Prov_Rugged_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_MidR_GF_CTL_Prov_Micro_CTL_Inst__c; 
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_MidR_GF_CTL_Prov_Micro_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_MidR_GF_CTL_Prov_Micro_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_DUCT) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_MidR_GF_CTL_Prov_Duct_Dev_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_FIBER) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_MidR_GF_CTL_Prov_Fiber_CTL_Inst__c;
                }
            }else if(CDUtility.isStringsEqual(cd?.Project_Type__c, CDConstants.BROWNFIELD)) {
                if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_MidR_BF_CTL_Prov_Rugged_CTL_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_MidR_BF_CTL_Prov_Rugged_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_MidR_BF_CTL_Prov_Rugged_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_MidR_BF_CTL_Prov_Micro_CTL_Inst__c; 
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_MidR_BF_CTL_Prov_Micro_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_MidR_BF_CTL_Prov_Micro_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_DUCT) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_MidR_BF_CTL_Prov_Duct_Dev_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_FIBER) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_MidR_BF_CTL_Prov_Fiber_CTL_Inst__c;
                }
            }
            // for HIGHRISE
        }else if(CDUtility.isStringsEqual(buildingStyle, CDConstants.HIGHRISE)){
            if(CDUtility.isStringsEqual(cd?.Project_Type__c, CDConstants.GREENFIELD)){                
                if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_HghR_GF_CTL_Prov_Rugged_CTL_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_HghR_GF_CTL_Prov_Rugged_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_HghR_GF_CTL_Prov_Rugged_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_HghR_GF_CTL_Prov_Micro_CTL_Inst__c; 
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_HghR_GF_CTL_Prov_Micro_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_HghR_GF_CTL_Prov_Micro_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_DUCT) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_HghR_GF_CTL_Prov_Duct_Dev_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_FIBER) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_HghR_GF_CTL_Prov_Fiber_CTL_Inst__c;
                }
            }else if(CDUtility.isStringsEqual(cd?.Project_Type__c, CDConstants.BROWNFIELD)) {
                if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_HghR_BF_CTL_Prov_Rugged_CTL_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_RUGGED) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_HghR_BF_CTL_Prov_Rugged_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_HghR_BF_CTL_Prov_Rugged_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_HghR_BF_CTL_Prov_Micro_CTL_Inst__c; 
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_MICRO) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    //f4Cost = f4CostSFURecord?.F4_HghR_BF_CTL_Prov_Micro_Dev_Inst__c;
                    f4Cost = f4CostSFURecord?.F4_HghR_BF_CTL_Prov_Micro_Dev_Inst_No__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_DUCT) && CDUtility.isStringsEqual(installType, CDConstants.DEV_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_HghR_BF_CTL_Prov_Duct_Dev_Inst__c;
                }else if(CDUtility.isStringsEqual(cd?.F4_Fiber_Type__c, CDConstants.CTL_PROV_FIBER) && CDUtility.isStringsEqual(installType, CDConstants.CTL_INSTALL)){
                    f4Cost = f4CostSFURecord?.F4_HghR_BF_CTL_Prov_Fiber_CTL_Inst__c;
                }
            }
        }
        return f4Cost;
    }//close the method
    
    /**
* Methos to return the adjustedOntModel
* it splits the ontModel Val using - and then takes tht part whatever after indoor and outdoor.
* Input : takes ontModel as input
* Output : return adjsuted ont value 
**/
    public static String getAdjustedOntModel(String ontModel){
        String adjustedOntModel = '';
        try{
            if(String.isBlank(ontModel)) return adjustedOntModel;
            List<String> ontList = ontModel.split('-');
            if(ontList.size() > 0 && ontList.indexOf('integrated') >= 0){
                adjustedOntModel = ontList?.get(ontList.indexOf('integrated')+1);
            }else if(ontList.size() > 0 && ontList.indexOf('indoor') >= 0){
                adjustedOntModel = ontList?.get(ontList.indexOf('indoor')+1);
            }else if(ontList.size() > 0 && ontList.indexOf('outdoor') >= 0){
                adjustedOntModel = ontList.get(ontList?.indexOf('outdoor')+1);
            }
        }catch(Exception e){
            system.debug('exception while getting the adjustedOntModel');
        }
        return adjustedOntModel;
    }
    
    /**
* Method is to return the onTMaterialCost based on ONTModel and building style form OntEstimator table
* Input Param : ontModel and buildingStyle
* Return : onTMaterialCost
**/
    public static decimal getOntMaterialCost(String ontModel, String buildingStyle,Map<String, CCT_ONT_UPS_Shelf_Estimator__c> ontEst){
        decimal ontMatCost = null;
        CCT_ONT_UPS_Shelf_Estimator__c ontShelfEst = null;
        if(!ontEst?.isEmpty()){
            ontShelfEst = ontEst?.get(ontModel);
        }
        boolean isBuildingStyleOn = isOntEstBuildingStyleOn(ontModel, buildingStyle, ontEst);
        if(isBuildingStyleOn && ontShelfEst != null){
            ontMatCost = ontShelfEst?.ONT_Material_Cost__c;
        }
        return ontMatCost;
    }//close method
    
    /**
* Method is to return the value of building style from the ONT Estimator table
* Input Param : ontModel and buildingStyle
* Return : boolean based on building style is Y or N
**/
    public static boolean isOntEstBuildingStyleOn(String ontModel, String buildingStyle, Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontEst){
        boolean isBuildingStyle = false;
        if(ontEst == null){
            return isBuildingStyle;
        }
        system.debug(' ontEst : '+ontEst);
        system.debug(' ontModel : '+ontModel);
        CCT_ONT_UPS_Shelf_Estimator__c ontShelfEst = ontEst?.get(ontModel);
        if(ontShelfEst != null){
            if(CDUtility.isStringsEqual(buildingStyle, CDConstants.SFU) && CDUtility.isStringsEqual(ontShelfEst?.ONT_SFU__c , CDConstants.YES)){
                isBuildingStyle = true;
            }else if(CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE) && CDUtility.isStringsEqual(ontShelfEst?.ONT_Cottage__c ,  CDConstants.YES)){
                isBuildingStyle = true;
            }else if(CDUtility.isStringsEqual(buildingStyle, CDConstants.MIDRISE) && CDUtility.isStringsEqual(ontShelfEst?.ONT_Midrise__c ,  CDConstants.YES)){
                isBuildingStyle = true;
            }else if(CDUtility.isStringsEqual(buildingStyle, CDConstants.HIGHRISE) && CDUtility.isStringsEqual(ontShelfEst?.ONT_Highrise__c ,  CDConstants.YES)){
                isBuildingStyle = true;
            }
        }
        return isBuildingStyle;
    }//close method
    //Added by Pooja ESCJ-1471 BUG FIX 29/6/2022
    
    /**

* Method is to return the value of building style from the ONT Estimator table

* Input Param : ontModel and buildingStyle

* Return : boolean based on building style is Y or N

**/
    
    public static boolean isOntEstBuildingStyle(String ontModel, String buildingStyle, Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontEst){
        
        boolean isBuildingStyle = false;
        
        if(ontEst == null){
            
            return isBuildingStyle;
            
        }
        
        system.debug(' ontEst : '+ontEst);
        
        system.debug(' ontModel : '+ontModel);
        
        CCT_ONT_UPS_Shelf_Estimator__c ontShelfEst = ontEst?.get(ontModel);
        
        System.debug('ontShelfEst------------------------------------------------------------ '+ontShelfEst);
        
        if(ontShelfEst != null){
            
            if(CDUtility.isStringsEqual(buildingStyle, CDConstants.SFU) && CDUtility.isStringsEqual(ontShelfEst?.UPS_Shelf_SFU__c , CDConstants.YES)){
                
                isBuildingStyle = true;
                
            }else if(CDUtility.isStringsEqual(buildingStyle, CDConstants.COTTAGE) && CDUtility.isStringsEqual(ontShelfEst?.UPS_Shelf_Cottage__c ,  CDConstants.YES)){
                
                isBuildingStyle = true;
                
            }else if(CDUtility.isStringsEqual(buildingStyle, CDConstants.MIDRISE) && CDUtility.isStringsEqual(ontShelfEst?.UPS_Shelf_Midrise__c ,  CDConstants.YES)){
                
                isBuildingStyle = true;
                
            }else if(CDUtility.isStringsEqual(buildingStyle, CDConstants.HIGHRISE) && CDUtility.isStringsEqual(ontShelfEst?.UPS_Shelf_Highrise__c ,  CDConstants.YES)){
                
                isBuildingStyle = true;
                
            }
            
        }
        
        return isBuildingStyle;
        
    }//close method    
    
    /*
* Method returnd the multiplier value based on state, projectType and serviceType from stateCost table.
* Input : StatesCostforCapitalDesign__c f3StateCost, String projectType, String serviceType
* Return : decimal multiplier value
*/
    public static decimal getF3CostMultiplier(StatesCostforCapitalDesign__c f3StateCost, String projectType, String serviceType ){
        decimal f3CostMultiplier = null;
        if(CDUtility.isStringsEqual(projectType, CDConstants.GREENFIELD)){
            if(CDUtility.isStringsEqual(serviceType, CDConstants.RETAIL)){
                f3CostMultiplier = f3StateCost?.F3_Cost_Greenfield_Retail_F3_Multiplier__c;
            }else if(CDUtility.isStringsEqual(serviceType, CDConstants.CTL_ON)){
                f3CostMultiplier = f3StateCost?.F3_Cost_Greenfield_CTL_ON_F3_Multiplier__c;
            }else if(CDUtility.isStringsEqual(serviceType, CDConstants.BULK_STR)){
                f3CostMultiplier = f3StateCost?.F3_Cost_Greenfield_Bulk_F3_Multiplier__c;
            }
        }else if (CDUtility.isStringsEqual(projectType, CDConstants.BROWNFIELD)){
            if(CDUtility.isStringsEqual(serviceType, CDConstants.RETAIL)){
                f3CostMultiplier = f3StateCost?.F3_Cost_Brownfield_Retail_F3_Multiplier__c;
            }else if(CDUtility.isStringsEqual(serviceType, CDConstants.CTL_ON)){
                f3CostMultiplier = f3StateCost?.F3_Cost_Brownfield_CTL_ON_F3_Multiplier__c;
            }else if(CDUtility.isStringsEqual(serviceType, CDConstants.BULK_STR)){
                f3CostMultiplier = f3StateCost?.F3_Cost_Brownfield_Bulk_F3_Multiplier__c;
            }
        }
        return f3CostMultiplier;
    }
    
    /*
* This method is to return the some integer value based on OntModel
* Input:  String adjustedOntModel, decimal quotient
* Return : integer based on adjustedOntModel value
*/
    public static Integer getNumForOntModel(String adjustedOntModel, decimal quotient){
        Integer returnedVal = null;
        if(CDUtility.isStringsEqual(adjustedOntModel, CDConstants.FTTU)){
            if( quotient <= CDConstants.SIX ){
                returnedVal = CDConstants.SIX;
            }else if( quotient <= CDConstants.TWELVE ){
                returnedVal = CDConstants.TWELVE;
            }else if( quotient <= CDConstants.TWENTYFOUR ){
                returnedVal = CDConstants.TWENTYFOUR;
            }else if( quotient <= CDConstants.FOURTYEIGHT ){
                returnedVal = CDConstants.FOURTYEIGHT;
            }else if( quotient <= CDConstants.SIXTY ){
                returnedVal = CDConstants.SIXTY ;
            }else {
                returnedVal = CDConstants.SEVENTYTWO;
            }
        }else if( CDUtility.isStringsEqual(adjustedOntModel, CDConstants.FTTB) ){
            if( quotient <= CDConstants.TWENTYFOUR ){
                returnedVal = CDConstants.SIX;
            }else {
                returnedVal = CDConstants.TWELVE;
            }  
        }else if( CDUtility.isStringsEqual(adjustedOntModel, CDConstants.FTTIDF)){
            if( quotient <= CDConstants.TWENTYFOUR ){
                returnedVal = CDConstants.SIX;
            }else if( quotient <= CDConstants.FOURTYEIGHT ){
                returnedVal = CDConstants.TWELVE;
            }else {
                returnedVal = CDConstants.TWENTYFOUR;
            }  
        }
        return returnedVal;
    }//method close
    
    
    /* This method to return the stub value from the stateCost Table based on subUnit.
* Input Param : StatesCostforCapitalDesign__c instalStateCost, decimal subUnit
* Return : decimal stubValue
*/
    public static decimal getStubFromStateCost(StatesCostforCapitalDesign__c instalStateCost, decimal subUnit ){
        decimal stubValue = CDConstants.ZERO;
        if(subUnit == CDConstants.SIX) {
            stubValue = instalStateCost?.IC_Stub6__c;
        }else if(subUnit == CDConstants.TWELVE) {
            stubValue = instalStateCost?.IC_Stub12__c;
        }else if(subUnit == CDConstants.TWENTYFOUR) {
            stubValue = instalStateCost?.IC_Stub24__c;
        }else if(subUnit == CDConstants.FOURTYEIGHT) {
            stubValue = instalStateCost?.IC_Stub48__c;
        }else if(subUnit == CDConstants.SIXTY) {
            stubValue = instalStateCost?.IC_Stub60__c;
        }else if(subUnit == CDConstants.SEVENTYTWO) {
            stubValue = instalStateCost?.IC_Stub72__c;
        }
        return stubValue;
    }//close method
    
    /* This method returns a record from the ONT_UPS_Shelf_Estimator based on the OntModel.
* Input : String ontModel
* Output : CCT_ONT_UPS_Shelf_Estimator__c ontShelfEst
*/
    public static CCT_ONT_UPS_Shelf_Estimator__c getEstByOntModel(String ontModel, Map<String, CCT_ONT_UPS_Shelf_Estimator__c> ontEst){
        CCT_ONT_UPS_Shelf_Estimator__c ontShelfEst = null;
        if(ontEst != null && ontModel != null){
            ontShelfEst = ontEst?.get(ontModel);   
        }
        return ontShelfEst;
    }
    
    /******************************************************************************************************************** 
* @Developer : Muhammad Nadeer MK
* @Method : getAdjstdnbrLivingUnits
* @Params : Input parameter Capital_Design__c object's field
* @Descriptions : ESCJ-497
* 				   For Calculating Adjusted Number of Living Units. (I16)
******************************************************************************************************************/
    public static decimal getAdjstdnbrLivingUnits(Capital_Design__c cd) {
        decimal val = null;
        if (CDUtility.isStringsEqual(cd.Service_Type__c, CDConstants.RETAIL)) {
            if (cd?.nbr_of_Living_Units__c != null && cd?.for_Retail_Take_rate__c != null) {
                val = (CDUtility.getValue(cd?.nbr_of_Living_Units__c) *
                       CDUtility.getValue(cd?.for_Retail_Take_rate__c)/CDConstants.HUNDRED).round(System.RoundingMode.UP);
            } else {
                val = cd?.nbr_of_Living_Units__c != null ? cd?.nbr_of_Living_Units__c : 0;
            }
        } else {
            val = cd?.nbr_of_Living_Units__c != null ? cd?.nbr_of_Living_Units__c : 0;
        }
        return val;
    }
    
    
    
    /******************************************************************************************************************** 
* @Developer : Muhammad Nadeer MK
* @Method : getAdjstBuildingStyle
* @Params : Input parameter Capital_Design__c object's field
* @Descriptions : ESCJ-497
* 				   For performing Calculation for F2 Vertical Fiber (Stub) Sub-cost Combined Cost, Material, 
*                  Overhead,Installation,Unit and Sub-unit Fields in F2 Output Section.
* 					Adjusted Building Style (K17)
******************************************************************************************************************/
    public static String getAdjstBuildingStyle(Capital_Design__c cd) {
        String buildingStyle1;
        String buildingStyle = CDUtility.getBuildStyle(cd?.Building_Style__c);
        if ((buildingStyle == CDConstants.MIDRISE) && (cd?.nbr_of_Living_Units__c < CDConstants.HUNDRED)) {
            buildingStyle1 = buildingStyle + CDConstants.LESSTHAN100;
        } else {
            buildingStyle1 = buildingStyle;
        }
        return buildingStyle1;
    }
    
    
    
    
    /******************************************************************************************************************** 
* @Developer : Muhammad Nadeer MK
* @Method : getOvrrdF2nbrIDFlocations
* @Params : Input parameter Capital_Design__c object's field
* @Descriptions : ESCJ-497
* 				   For performing Calculation for F2 Vertical Fiber (Stub) Sub-cost Unit field in F2 Output Section.
* 					Get Override Value for F2 #of IDF Locations(I75)
******************************************************************************************************************/
    public static decimal getOvrrdF2nbrIDFlocations(Capital_Design__c cd) {
        decimal val = null;
        Map <String, CCT_F2_Stub_Estimator__c> F2StbobjList = CapitalDesignTriggerHelper.f2StubEstBuildingStyleMap;
        CCT_F2_Stub_Estimator__c F2Stbobj = F2StbobjList?.get(CDUtility.getAdjstBuildingStyle(cd));
        String valueforspcunit = CDUtility.getAdjustedOntModel(cd?.ONT_Model__c); 
        if (CDUtility.getAdjstBuildingStyle(cd) == CDConstants.SFU || 
            ((CDUtility.getAdjstBuildingStyle(cd) == CDConstants.MIDRISELESSTHAN100 ||
              CDUtility.getAdjstBuildingStyle(cd) == CDConstants.MIDRISE) &&
             cd?.Are_there_IDF__c == 'No')) {
                 val = CDConstants.ZERO;
             } else if (F2Stbobj != NULL) {
                 if ((F2Stbobj?.F2_STUBE_Building__c == CDConstants.YES) &&
                     (F2Stbobj?.F2_STUBE_Floor__c == CDConstants.YES)) {
                         if (valueforspcunit == CDConstants.FTTU) {
                             val = CDUtility.getValue(cd?.for_MDU_nbr_of_Buildings__c) * CDUtility.getValue(cd?.for_Midrise_Highrise_nbof_average_Floors__c) *
                                 CDUtility.getValue(F2Stbobj?.F2_STUBE_FTTU__c);
                         } else if (valueforspcunit == CDConstants.FTTB) {
                             val = CDUtility.getValue(cd?.for_MDU_nbr_of_Buildings__c) * CDUtility.getValue(cd?.for_Midrise_Highrise_nbof_average_Floors__c) * CDUtility.getValue(F2Stbobj.F2_STUBE_FTTB__c);
                         } else if (valueforspcunit == CDConstants.FTTIDF) {
                             val = CDUtility.getValue(cd?.for_MDU_nbr_of_Buildings__c) * CDUtility.getValue(cd?.for_Midrise_Highrise_nbof_average_Floors__c) *
                                 CDUtility.getValue(F2Stbobj.F2_STUBE_FTTIDF__c);
                         }
                     } else if (F2Stbobj?.F2_STUBE_Building__c == CDConstants.NO && F2Stbobj?.F2_STUBE_Floor__c == CDConstants.YES) {
                         if (valueforspcunit == CDConstants.FTTU) {
                             val = CDUtility.getValue(cd?.for_Midrise_Highrise_nbof_average_Floors__c) * CDUtility.getValue(F2Stbobj?.F2_STUBE_FTTU__c);
                         } else if (valueforspcunit == CDConstants.FTTB) {
                             val = CDUtility.getValue(cd?.for_Midrise_Highrise_nbof_average_Floors__c) * CDUtility.getValue(F2Stbobj?.F2_STUBE_FTTB__c);
                         } else if (valueforspcunit == CDConstants.FTTIDF) {
                             val = CDUtility.getValue(cd?.for_Midrise_Highrise_nbof_average_Floors__c) * CDUtility.getValue(F2Stbobj?.F2_STUBE_FTTIDF__c);
                         }
                     } else if (F2Stbobj?.F2_STUBE_Building__c == CDConstants.YES && F2Stbobj?.F2_STUBE_Floor__c == CDConstants.NO) {
                         if (valueforspcunit == CDConstants.FTTU) {
                             val = CDUtility.getValue(cd?.for_MDU_nbr_of_Buildings__c) * CDUtility.getValue(F2Stbobj?.F2_STUBE_FTTU__c);
                         } else if (valueforspcunit == CDConstants.FTTB) {
                             val = CDUtility.getValue(cd?.for_MDU_nbr_of_Buildings__c) * CDUtility.getValue(F2Stbobj?.F2_STUBE_FTTB__c);
                         } else if (valueforspcunit == CDConstants.FTTIDF) {
                             val = CDUtility.getValue(cd?.for_MDU_nbr_of_Buildings__c) * CDUtility.getValue(F2Stbobj?.F2_STUBE_FTTIDF__c);
                         }
                     } else if (F2Stbobj?.F2_STUBE_Building__c == CDConstants.NO && F2Stbobj?.F2_STUBE_Floor__c == CDConstants.NO) {
                         if (valueforspcunit == CDConstants.FTTU) {
                             val = F2Stbobj?.F2_STUBE_FTTU__c;
                         } else if (valueforspcunit == CDConstants.FTTB) {
                             val = F2Stbobj?.F2_STUBE_FTTB__c;
                         } else if (valueforspcunit == CDConstants.FTTIDF) {
                             val = F2Stbobj?.F2_STUBE_FTTIDF__c;
                         }
                     }
             }else{
                 val = CDConstants.ZERO;
             }
        System.debug(val);
        return val;
    }
    
    /***************************************************************************************************
* FOR ESCJ-1323
* Method is used to return ontModel, location, gateway value based on keyValue
* For I24, J24, K24 values
* Input : takes ontModel as input
* Output : return value from OntModel based on Key 
/**************************************************************************************************/
    public static Map<String, String> getValuesFromOntModel(String ontModel){
        Map<String, String> ontmodelMap = new MAp<String,String>();       
        if(ontModel !=NULL && String.isNotBlank(ontModel)){
            List<String> splitString = ontmodel?.split('-');
            if(splitString?.indexof('indoor')> 0){
                ontmodelMap.put('location', 'indoor');
            }else if(splitString?.indexof('outdoor') > 0){
                ontmodelMap.put('location', 'outdoor');
            }
            if(splitString?.indexof('integrated') > 0){
                ontmodelMap.put('gateway', 'integrated');
            }
            ontmodelMap.put('code', splitString?.get(1));
            if(splitString.size() > 0){
                ontmodelMap.put('ontmodel', splitString?.get(splitString.size()-1));
            }
        }
        return ontmodelMap;
    }
    /**************************************************************************************************/
    
    /**
* Method is to return the value of TRUE/FALSE if the ONT Model in the ONT Estimator table is for Smart NID
* Input Param : ontModel
* Return : boolean based on Smart NID is Y or N
* 
* 08/31/2023   T2Cabato    QFCJ-4469      SmartNID Residential-Gateway Material Cost Calculation
**/
    public static Boolean isOntEstModelSmartNID(String ontModel, Map<String,CCT_ONT_UPS_Shelf_Estimator__c> ontEst){
        Boolean isSmartNID = false;
        System.debug('(CDUtility.isOntEstModelSmartNID) Incoming ontModel = ' + ontModel);
        if (ontEst == null || String.isBlank(ontModel)) {
            return isSmartNID;
        }
        CCT_ONT_UPS_Shelf_Estimator__c ontShelfEst = ontEst?.get(ontModel);
        if (ontShelfEst != null) {
            System.debug('(CDUtility.isOntEstModelSmartNID) For ontModel = ' + ontModel + ', ontShelfEst?.ONT_Description__c = ' + ontShelfEst?.ONT_Description__c);
            if ((String.isNotBlank(ontShelfEst?.ONT_Description__c) && ontShelfEst?.ONT_Description__c.contains('Smart NID')) || (ontModel?.contains('Axon-C5500XK')) || (ontModel?.contains('Axon-C6510XK'))) {
                isSmartNID = true;
            }
        }
        System.debug('(CDUtility.isOntEstModelSmartNID) For ontModel = ' + ontModel + ', returning isSmartNID = ' + isSmartNID);
        return isSmartNID;
    }//close method
    
}//end class CDUtility