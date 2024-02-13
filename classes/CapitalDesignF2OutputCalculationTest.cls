/*************************************************************************************************
 Purpose: Test class for the CapitalDesignF2OutputCalculation to test different test scenarios.
===============================================================================================
History:
Author    *          			UserStory   *    	Date         *       Description 
Muhammad Nadeer MK (IBM)      	ESCJ-497         	10/03/2022           F2 Output calculations
Ted Cabato			 			QFCJ-4274			08/04/2023			 State Code & State Name Fix	
===============================================================================================
 * Date         Author      UserStory          Description  
 * 08/02/2023   T2Cabato    QFCJ-4286          BRAIN-Drop-Cost-Fix                   
 * 09/22/2023   T2Cabato    QFCJ-4580          Round CCT cost fields results to 2 decimals 
 * 10/02/2023   T2Cabato    QFCJ-4636          F2 FDH Size in output section not pulling correct values from cost table 
 * 10/17/2023   T2Cabato    QFCJ-4683          CCT Rounding Integers using HALF_UP except for Splitter Sub-cost Unit  
 ***********************************************************************************************/
@isTest
public class CapitalDesignF2OutputCalculationTest {

  /*************************************************************************************************
    Purpose: To create Test data
    ===============================================================================================
    History:
    Author    *          UserStory   *    Date              
    Muhammad Nadeer MK       ESCJ-583        10/03/2022       
    ***********************************************************************************************/
    
  	@testSetup 
    private static void setup() {
        List < Property__c > properties = TestDataFactory.createProperties(NULL, NULL, 'FL', NULL, 'FL', NULL, NULL, NULL, 12, TRUE);
        for (Integer p = 0; p < properties.size(); p++) {
            properties[p].Property_Total_Units__c = 35 * (p+1);
        }
        update properties;
        
        List < Opportunity > opportunities = new List<Opportunity>();
        for (Integer p = 0; p < properties.size(); p++) {
            String devStatus = null;
            if (Math.mod(p,2) == 0) { devStatus = 'Greenfield'; }
            else { devStatus = 'Brownfield'; }
            List<Opportunity> tempOpptyList = TestDataFactory.createOpportunities('TESTCCT', devStatus, 'Contracting', 
                                                                                  Date.today().addDays(5),
                                                                                  properties[p].Id, 1, TRUE);
            opportunities.add(tempOpptyList?.get(0));
        }
        
        List<Segment__c> segmentList = TestdataFactory.createSegment(opportunities, properties, 12, False); //ESCJ-1623 BUG FIX.
        for (Integer s = 0; s < segmentList.size(); s++) {
            segmentList.get(s).Segment_Total_Units__c = 35 * (s+1);
            segmentList.get(s).Segment_Use__c = 'Rental';
            if (Math.mod(s,5)==0) {
                segmentList.get(s).Segment_Structure__c = 'SFH (Single Family Home)';
            } else if (Math.mod(s,5)==1) {
                segmentList.get(s).Segment_Structure__c = 'Cottage';
            } else if (Math.mod(s,5)==2 || Math.mod(s,5)==3) {
                segmentList.get(s).Segment_Structure__c = 'Tower';
            } else {
                segmentList.get(s).Segment_Structure__c = 'Mixed';
            }
        }        
        
        List < CCT_F2_Cost_Estimator__c > F2costEstimators = TestDataFactory.createCCTF2CostEstimator('SFU', 500, 1, 5, false);
        String costPropType = null;
        for (Integer f = 0; f < F2costEstimators.size(); f++) {
            if (Math.mod(f,5)==0) {
                costPropType = 'SFU';
                F2costEstimators[f].F2_CostE_Footage_Bld__c = 150;
                F2costEstimators[f].F2_CostE_Footage_Flr__c = 150;
            } else if (Math.mod(f,5)==1) {
                costPropType = 'Cottage';
                F2costEstimators[f].F2_CostE_Footage_Bld__c = 250;
                F2costEstimators[f].F2_CostE_Footage_Flr__c = 250;
            } else if (Math.mod(f,5)==2) {
                costPropType = 'Midrise';
                F2costEstimators[f].F2_CostE_Footage_Bld__c = 350;
                F2costEstimators[f].F2_CostE_Footage_Flr__c = 350;
            } else if (Math.mod(f,5)==3) {
                costPropType = 'Midrise<100';
                F2costEstimators[f].F2_CostE_Footage_Bld__c = 350;
                F2costEstimators[f].F2_CostE_Footage_Flr__c = 350;
            } else {
                costPropType = 'Highrise';
                F2costEstimators[f].F2_CostE_Footage_Bld__c = 450;
                F2costEstimators[f].F2_CostE_Footage_Flr__c = 450;
            }
            F2costEstimators[f].F2_CostE_Building_Type__c = costPropType;
            F2costEstimators[f].FTTIDF__c = 20;
            F2costEstimators[f].F2_CostE_FTTB__c = 30;
            F2costEstimators[f].FTTU__c = 30;
            F2costEstimators[f].Material_Cost__c = 40;
        }
        Insert F2costEstimators;
    
        List < CCT_F2_Stub_Estimator__c > F2StubEstimator = TestDataFactory.createCCTF2StubEstimator(100, 2, 5, false);
        String stubPropType = null;
        for (Integer f = 0; f < F2StubEstimator.size(); f++) {
            F2StubEstimator[f].F2_STUBE_FTTU__c = 20;
            F2StubEstimator[f].F2_STUBE_FTTB__c = 30;
            F2StubEstimator[f].F2_STUBE_FTTIDF__c = 40;
            F2StubEstimator[f].F2_STUBE_Building__c = 'Yes';
            F2StubEstimator[f].F2_STUBE_Floor__c = 'Yes';
            if (Math.mod(f,5)==0) {
                stubPropType = 'SFU';
            } else if (Math.mod(f,5)==1) {
                stubPropType = 'Cottage';
            } else if (Math.mod(f,5)==2) {
                stubPropType = 'Midrise';
            } else if (Math.mod(f,5)==3) {
                stubPropType = 'Midrise<100';
            } else {
                stubPropType = 'Highrise';
            }
            F2StubEstimator[f].F2_STUBE_Building_Style__c = stubPropType;
        }
        Insert F2StubEstimator;
        
        List < CCT_F2_FDH_Estimator__c > F2FDHEstimator = TestDataFactory.createCCTF2FDHEstimator(100, 2, 8, false);
        for (Integer f = 0; f < F2FDHEstimator.size(); f++) {
            F2FDHEstimator[f].F2_FDHE_Outdoor_FDH_Model__c = '24/432';
            F2FDHEstimator[f].F2_FDHE_Outdoor_LU_FDH__c = 432;
            F2FDHEstimator[f].F2_FDHE_Outdoor_Material_Cost__c = 7626;
            F2FDHEstimator[f].F2_FDHE_Indoor_FDH_Model__c = '24/432';
            F2FDHEstimator[f].F2_FDHE_Indoor_LU_FDH__c = 432;
            F2FDHEstimator[f].F2_FDHE_Indoor_Material_Cost__c = 7626;
        }
        Insert F2FDHEstimator; 
    
        List < CCT_Cost_Estimator__c > CostEstimator = TestDataFactory.createCCTCostEstimator('FL', 5, false);
        for (Integer c = 0; c < CostEstimator.size(); c++) {    
            CostEstimator[c].F2_Ped_Est_Material_Cost__c = 300;
            CostEstimator[c].F2_Ped_Est_SFU_LU_Ped__c = 300;
            CostEstimator[c].F2_Ped_Est_Cottage_bld_Ped__c = 300;
            CostEstimator[c].State__c = 'FL';
            CostEstimator[c].F2_Splitter_LU_splitter__c = 32;
            CostEstimator[c].F2_Splitter_Exterior_Material_Cost__c = 1000;
            CostEstimator[c].F2_Splitter_Interior_Material_Cost__c = 1000;
        }
        insert CostEstimator;
    
        List<CCT_ONT_UPS_Shelf_Estimator__c> upsShelfList = new List<CCT_ONT_UPS_Shelf_Estimator__c>();
        CCT_ONT_UPS_Shelf_Estimator__c upsShelf = new CCT_ONT_UPS_Shelf_Estimator__c();        
        upsShelf.ONT_Model__c = 'Adtran-C424G-indoor-integrated-FTTU';//FTTIDF
        upsShelf.ONT_Part__c = '1287781F1C';
        upsShelf.ONT_MAT_Code__c = 1355164.00000;
        upsShelf.ONT_Description__c = 'C424G GPON ONT RG WITH WIFI RESIDENTIAL';
        upsShelf.ONT_SFU__c = 'Yes';
        upsShelf.ONT_Cottage__c = 'Yes';
        upsShelf.ONT_LU_per_ONT__c = 1;
        upsShelf.ONT_Material_Cost__c = 75.00;
        upsShelf.Indoor_Outdoor__c = 'Indoor';
        upsShelf.Includes_Gateway__c = 'Integrated';
        upsShelf.UPS_Model__c = '75W x2';
        upsShelf.LU_per_UPS__c = 16;
        upsShelf.LU_per_Shelf__c = 16;
        upsShelf.UPS_Shelf_SFU__c = 'Yes'; //ESCJ-1471 BUG FIX.
        upsShelf.UPS_Shelf_Cottage__c = 'Yes';        
        upsShelf.UPS_Shelf_Midrise__c = 'Yes';        
        upsShelf.UPS_Shelf_Highrise__c = 'Yes';
        upsShelf.UPS_Shelf_Per_LU__c = 28.67;
        upsShelf.Shelf_Cost__c = 250.00;
        upsShelf.UPS_Cost__c = 208.71;
        CapitalDesignTriggerHelperOutputSec.ontUPSShelfEstDataMap.put('Adtran-C424G-indoor-integrated-FTTU', upsShelf);        
        upsShelfList.add(upsShelf);
		
        upsShelf = new CCT_ONT_UPS_Shelf_Estimator__c();        
        upsShelf.ONT_Model__c = 'Axon-C6510XK-indoor-integrated-FTTU';
        upsShelf.ONT_Part__c = 'C6510XK';
        upsShelf.ONT_MAT_Code__c = 1477595.00000;
        upsShelf.ONT_Description__c = '6510XK Smart NID 2.0 for XGSPON';
        upsShelf.ONT_SFU__c = 'Yes';
        upsShelf.ONT_Cottage__c = 'Yes';
        upsShelf.ONT_Midrise__c = 'Yes';
        upsShelf.ONT_Highrise__c = 'Yes';
        upsShelf.ONT_LU_per_ONT__c = 1;
        upsShelf.ONT_Material_Cost__c = 81.03;
        upsShelf.Indoor_Outdoor__c = 'Indoor';
        upsShelf.Includes_Gateway__c = 'Non-integrated';
        upsShelf.UPS_Model__c = '150W';
        upsShelf.LU_per_UPS__c = 32;
        upsShelf.LU_per_Shelf__c = 32;
        upsShelf.UPS_Shelf_SFU__c = 'No'; //ESCJ-1471 BUG FIX.
        upsShelf.UPS_Shelf_Cottage__c = 'Yes';        
        upsShelf.UPS_Shelf_Midrise__c = 'Yes';        
        upsShelf.UPS_Shelf_Highrise__c = 'Yes';
        upsShelf.UPS_Shelf_Per_LU__c = 14.33;
        upsShelf.Shelf_Cost__c = 250.00;
        upsShelf.UPS_Cost__c = 208.71;
        CapitalDesignTriggerHelperOutputSec.ontUPSShelfEstDataMap.put('Axon-C6510XK-indoor-integrated-FTTU', upsShelf);        
        upsShelfList.add(upsShelf);

        upsShelf = new CCT_ONT_UPS_Shelf_Estimator__c();        
        upsShelf.ONT_Model__c = 'Calix-716GE-i-indoor-FTTIDF';
        upsShelf.ONT_Part__c = '100-04974';
        upsShelf.ONT_MAT_Code__c = 1356852.00000;
        upsShelf.ONT_Description__c = '716GE I R2 ONT MODULE WITH POWER ADAPTE';
        upsShelf.ONT_SFU__c = 'No';
        upsShelf.ONT_Cottage__c = 'Yes';
        upsShelf.ONT_Midrise__c = 'Yes';
        upsShelf.ONT_Highrise__c = 'Yes';
        upsShelf.ONT_LU_per_ONT__c = 4;
        upsShelf.ONT_Material_Cost__c = 75.00;
        upsShelf.Indoor_Outdoor__c = 'Indoor';
        upsShelf.Includes_Gateway__c = 'Non-integrated';
        upsShelf.UPS_Model__c = '75WX2';
        upsShelf.LU_per_UPS__c = 32;
        upsShelf.LU_per_Shelf__c = 32;
        upsShelf.UPS_Shelf_SFU__c = 'No'; //ESCJ-1471 BUG FIX.
        upsShelf.UPS_Shelf_Cottage__c = 'Yes';        
        upsShelf.UPS_Shelf_Midrise__c = 'Yes';        
        upsShelf.UPS_Shelf_Highrise__c = 'Yes';
        upsShelf.UPS_Shelf_Per_LU__c = 34.34;
        upsShelf.Shelf_Cost__c = 681.30;
        upsShelf.UPS_Cost__c = 417.42;
        CapitalDesignTriggerHelperOutputSec.ontUPSShelfEstDataMap.put('Calix-716GE-i-indoor-FTTIDF', upsShelf);        
        upsShelfList.add(upsShelf);
        
        upsShelf = new CCT_ONT_UPS_Shelf_Estimator__c();        
        upsShelf.ONT_Model__c = 'Calix-711GE-outdoor-FTTB';
        upsShelf.ONT_Part__c = '100-05159';
        upsShelf.ONT_MAT_Code__c = 1439779.00000;
        upsShelf.ONT_Description__c = '711GE ONT 2 POTS 2 GE 100-05159 CALIX';
        upsShelf.ONT_SFU__c = 'Yes';
        upsShelf.ONT_Cottage__c = 'Yes';
        upsShelf.ONT_Midrise__c = 'No';
        upsShelf.ONT_Highrise__c = 'No';
        upsShelf.ONT_LU_per_ONT__c = 2;
        upsShelf.ONT_Material_Cost__c = 265.77;
        upsShelf.Indoor_Outdoor__c = 'Outdoor';
        upsShelf.Includes_Gateway__c = 'Non-integrated';
        upsShelf.UPS_Model__c = '75W x5';
        upsShelf.LU_per_UPS__c = 16;
        upsShelf.LU_per_Shelf__c = 16;
        upsShelf.UPS_Shelf_SFU__c = 'Yes'; //ESCJ-1471 BUG FIX.
        upsShelf.UPS_Shelf_Cottage__c = 'No';        
        upsShelf.UPS_Shelf_Midrise__c = 'No';        
        upsShelf.UPS_Shelf_Highrise__c = 'No';
        upsShelf.UPS_Shelf_Per_LU__c = 18.93;
        upsShelf.Shelf_Cost__c = 94.09;
        upsShelf.UPS_Cost__c = 208.71;
        CapitalDesignTriggerHelperOutputSec.ontUPSShelfEstDataMap.put('Calix-711GE-outdoor-FTTB', upsShelf);        
        upsShelfList.add(upsShelf);
        INSERT upsShelfList;

        List < StatesCostforCapitalDesign__c > scList = TestDataFactory.createStateCostData(1, False);
        scList[0].Name = 'FL';
        scList[0].F1_Cost_ft_LE_Use_Existing_Spare__c = 0.22;
        scList[0].F1_Cost_ft_LE_Use_Vacant_12f__c=1.14;
        scList[0].F1_Cost_ft_LE_Plow_2_c_48f__c=7;
        scList[0].F1_Cost_ft_LE_Aerial_10M_144f__c=15;
        scList[0].F1_Cost_ft_LE_Overpull_1_25_c_864f__c=10;
        scList[0].F1_Cst_ft_BackbonBore_1_25_c_3_in4_c864__c=37;
        scList[0].F1_Cost_ft_LE_Cobble_Bore_1_25_c_864f__c=44.5;
        scList[0].F1_Cst_ft_Cobble_Bore_1_25_c_in_4_c_864__c=51;
        scList[0].F1_Cost_ft_LE_Direct_Buried_96f__c=10;
        scList[0].F1_Cost_ft_LE_Lateral_Bore_1_25_c_864f__c=28;
        scList[0].F1_Cost_ft_LE_Rock_Bore_1_25_c_864f__c=60.5;
        scList[0].F1_Cst_ft_Rock_Bore_1_25_c_in_4_c_864f__c=80.5;
        scList[0].F1_Cost_ft_FW_Blended__c=13.9;
        scList[0].F1_Cost_ft_FW_Greenfield_F1_Multiplier__c=1;
        scList[0].F1_Cost_ft_FW_Brownfield_F1_Multiplier__c=1;
        scList[0].F2_Cost_ft_LE_Direct_Buried_96f__c=8.05 ;
        scList[0].F2_Cost_ft_LE_Aerial_10M_144f__c=15;
        scList[0].F2_Cost_ft_LE_Pull_Fiber_96f__c=1.85;
        scList[0].F2_Cost_ft_LE_Place_Conduit_4_c__c=3.09;
        scList[0].F2_Cost_ft_PlaceConduitPullFiber_4_c96f__c=4.94;
        scList[0].F2_Cost_ft_LE_Trench_4_c_96f__c=12.69;
        scList[0].F2_Cost_ft_LE_Bore_1_25_c_96f__c=22.02;
        scList[0].F2_Cost_ft_LE_Cobble_Bore_1_25_c_96f__c=39.91;
        scList[0].F2_Cost_ft_LE_Rock_Bore_1_25_c_96f__c=54.43;
        scList[0].F2_Eng_time_Cost_Over_200K_OVH__c = 16885.90;
        scList[0].F2_Eng_time_Cost_100K_200K_OVH__c = 16371.65;
        scList[0].F2_Eng_time_Cost_50K_100K_OVH__c = 8763.13;
        scList[0].F2_Eng_time_Cost_Under_50K_OVH__c = 4135.10;
        scList[0].OC_General_Multiplier__c = 300;
        scList[0].F2_Cost_ft_FW_Greenfield_F2_Multiplier__c = 0.85;
        scList[0].F2_Cost_ft_FW_Brownfield_F2_Multiplier__c = 0.85;
        scList[0].F3_Cost_Aerial_Cost_LU__c = 2;
        scList[0].F3_cost_ft_LE_Aerial_12f__c=1.9;
        scList[0].F3_cost_ft_LE_Bore_1_25_c_12f__c=14.4;
        scList[0].F3_cost_ft_LE_Buried_w_Conduit_12f__c=6.3;
        scList[0].F3_cost_ft_LE_Direct_Buried_12f__c=2.9;
        scList[0].F3_cost_ft_LE_Pull_Fiber_12f__c=2.0;
        scList[0].F3_Cost_LU_LE_Slack_box__c=23.0;
        scList[0].IC_Splicing__c = 10;
        scList[0].IC_FDH_In__c = 20;
        scList[0].IC_FDH_Out__c = 30;
        scList[0].IC_Gateway_FTTU__c = 2;
        scList[0].IC_Handhole__c = 25;
        scList[0].IC_Ped__c = 30;
        Insert scList;

        List < Capital_Design__c > capitalDesigns = new List<Capital_Design__c>();
        for (Integer o = 0; o < opportunities.size(); o++) {
            List<Capital_Design__c> cdListNew = TestDataFactory.createCapitalDesigns(opportunities[o].Id, 1, FALSE);
            capitalDesigns.add(cdListNew.get(0));
        }
        String propType = null;
        String svcType = null;
        for (Integer c = 0; c < 12; c++) {
            capitalDesigns[c].Opportunity__c = opportunities[c].Id;
            capitalDesigns[c].F2_Direct_Buried_96f__c = 2;
            capitalDesigns[c].F2_Aerial_10M_144f__c = 2;
            capitalDesigns[c].Pull_Fiber_96f__c = 2;
            capitalDesigns[c].Place_Conduit_4_c__c = 2;
            capitalDesigns[c].Place_Conduit_and_Pull_Fiber_4_c_96f__c = 2;
            capitalDesigns[c].Trench_4_c_96f__c = 2;
            capitalDesigns[c].Bore_1_25_c_96f__c = 2;
            capitalDesigns[c].Cobble_Bore_1_25_c_96f__c = 2;
            capitalDesigns[c].Rock_Bore_1_25_c_96f__c = 2;
            capitalDesigns[c].F2_Joint_Trench_Custom_with_conduit__c = 2;
            capitalDesigns[c].F2_Custom_without_conduit__c = 2;
            if (c>=0 && c<=2) {
                propType = 'SFU';
	            capitalDesigns[c].for_SFU_Average_Lot_Size__c = '40';
                capitalDesigns[c].for_Midrise_Highrise_nbof_average_Floors__c = null;
                capitalDesigns[c].for_MDU_nbr_of_Buildings__c = NULL; 
            } else if (c>=3 && c<=5) {
                propType = 'Cottage';
	            capitalDesigns[c].for_SFU_Average_Lot_Size__c = null;
                capitalDesigns[c].for_Midrise_Highrise_nbof_average_Floors__c = null;
                capitalDesigns[c].for_MDU_nbr_of_Buildings__c = 305; 
            } else if (c>=6 && c<=8) {
                propType = 'Midrise';
	            capitalDesigns[c].for_SFU_Average_Lot_Size__c = null;
                capitalDesigns[c].for_Midrise_Highrise_nbof_average_Floors__c = 5;
                capitalDesigns[c].for_MDU_nbr_of_Buildings__c = 20; 
            } else {
                propType = 'Highrise';
	            capitalDesigns[c].for_SFU_Average_Lot_Size__c = null;
                capitalDesigns[c].for_Midrise_Highrise_nbof_average_Floors__c = 20;
                capitalDesigns[c].for_MDU_nbr_of_Buildings__c = 5; 
            }
            if (Math.mod(c,3)==0) {
                svcType = 'CTL_ON';
            } else if (Math.mod(c,3)==1) {
                svcType = 'Bulk';
            } else {
                svcType = 'Retail';
            }
            capitalDesigns[c].Building_Style__c = propType + ' ' + (svcType=='CTL_ON'?'CTL-ON':svcType);
            capitalDesigns[c].Service_Type__c = svcType;
            capitalDesigns[c].nbr_of_Living_Units__c = 35 * (c+1);
            capitalDesigns[c].F2_Footage_ft__c = 30;
            if (c==5) {
                capitalDesigns[c].Project_Type__c = 'Brownfield'; 
            } else {
                capitalDesigns[c].Project_Type__c = 'Greenfield';
            }
            capitalDesigns[c].F2_Footage_Direct_Buried_96f__c = 2;
            capitalDesigns[c].F2_Footage_Pull_Fiber_96f__c = 2;
            capitalDesigns[c].F2_Footage_Aerial_10M_144f__c = 2;
            capitalDesigns[c].F2_Footage_Custom_without_conduit__c = 2;
            capitalDesigns[c].F2_nbr_of_IDF_locations__c = NULL;
            capitalDesigns[c].Existing_FDH__c = false;
            capitalDesigns[c].F2_nbr_of_Handhole__c = NULL;
            capitalDesigns[c].F2_nbr_of_Ped__c = NULL;
            capitalDesigns[c].F2_Mobilization_Cost__c = NULL;
            capitalDesigns[c].F2_Pole_Make_Ready_Cost__c = NULL;
            capitalDesigns[c].F2_Pole_Anchor_and_Guy_Cost__c = NULL;
            capitalDesigns[c].F2_Pothole_Restoration_Cost__c = NULL;
            if (svcType == 'Retail') {
	            capitalDesigns[c].for_Retail_Take_rate__c = 2;
            } else {
	            capitalDesigns[c].for_Retail_Take_rate__c = null;
            }
            capitalDesigns[c].Opportunity__c = opportunities[0].Id;
            capitalDesigns[c].State__c = 'FL';
            capitalDesigns[c].State_Name__c = 'Florida';
            capitalDesigns[c].Primary_Address_State_Name__c = 'Florida';
            if (capitalDesigns[c].Building_Style__c.length() > propType.length() && (propType == 'SFU' || propType == 'Cottage')) {
	            capitalDesigns[c].ONT_Model__c = 'Calix-711GE-outdoor-FTTB';
        	    capitalDesigns[c].F4_Fiber_Type__c = 'No Drop'; 
            } else if (capitalDesigns[c].Building_Style__c.length() > propType.length() && propType == 'Highrise') {
	            capitalDesigns[c].ONT_Model__c = 'Calix-716GE-i-indoor-FTTIDF';
        	    capitalDesigns[c].F4_Fiber_Type__c = 'No Drop'; 
            } else {
	            capitalDesigns[c].ONT_Model__c = null;
        	    capitalDesigns[c].F4_Fiber_Type__c = null; 
            } 
            if (capitalDesigns[c].Building_Style__c.length() > propType.length() && (propType == 'SFU' || propType == 'Cottage')) {
	   	        capitalDesigns[c].F3_Fiber_Type__c = 'Aerial';
            } else {
	   	        capitalDesigns[c].F3_Fiber_Type__c = null;
            }
            if (capitalDesigns[c].Building_Style__c.length() > propType.length() && (propType == 'Midrise')) {
                if (c==6) {
                    capitalDesigns[c].Are_there_IDF__c = 'Yes';
                    capitalDesigns[c].ONT_Model__c = 'Calix-803G-indoor-FTTU';
                    capitalDesigns[c].F4_Fiber_Type__c = 'No Drop'; 
                } else {
                    capitalDesigns[c].Are_there_IDF__c = 'Yes';
                    capitalDesigns[c].ONT_Model__c = 'Calix-716GE-i-indoor-FTTIDF';
                    capitalDesigns[c].F4_Fiber_Type__c = 'No Drop'; 
                }
            } else {
	            capitalDesigns[c].Are_there_IDF__c = null;
            }
            capitalDesigns[c].F2_FDH_size__c = '32';
            //capitalDesigns[c].FDH_size__c = '32'; //ESCj-1578 US
            capitalDesigns[c].Responsible_for_Cable_Home_Wiring__c = 'Company to Provide and Install';
            capitalDesigns[c].Responsible_for_Home_Run_Wiring__c = 'Company to Provide and Install';
            capitalDesigns[c].Telecommunication_Cable_Types__c = 'Fiber';
            capitalDesigns[c].Telecom_Cable_Quantity_Per_Living_Unit__c = 0;
            capitalDesigns[c].Endpoint_Type_building_architecture__c = 'MDF to Living Unit';
            capitalDesigns[c].Responsible_for_Media_Panel__c = 'Company to Provide and Install';
            capitalDesigns[c].Exterior_Cabinets__c = 'Yes';
            capitalDesigns[c].NEMA_Rated_Cabinet__c = 'Yes';
            capitalDesigns[c].Backboards_required__c = 'Yes';
            capitalDesigns[c].Planned_Build_Out_Years__c = 4;
            capitalDesigns[c].Actual_Build_Out_Months__c = 48;
            capitalDesigns[c].Project_Start_Year__c = String.valueOf(Date.today().toStartOfMonth().addDays(365).year());
            capitalDesigns[c].Alarm_Due_Date__c = Date.today().toStartOfMonth().addDays(700);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
            capitalDesigns[c].Open_Trench_Date__c = Date.today().toStartOfMonth().addDays(400);
            capitalDesigns[c].ONT_Location__c = 'Interior Integrated';
            capitalDesigns[c].Inside_Wiring__c = 'F-4 Ruggedized';
            capitalDesigns[c].Units_Built_Year_1__c = 105;
            capitalDesigns[c].Units_Built_Year_2__c = 100;
            capitalDesigns[c].Units_Built_Year_3__c = 100;
            capitalDesigns[c].F1_Feeder_Type__c = 'Fiber';
            capitalDesigns[c].Access_Type__c = 'Fiber';
            capitalDesigns[c].Occupant_Type__c = 'CONSUMER';
            capitalDesigns[c].Existing_Feeder_Footage_Utilized__c = 1000;
            capitalDesigns[c].No_GPON_No_Integrated_Switch__c = 'Yes';
            capitalDesigns[c].Primary_Descriptor_of_CO_Area__c = 'Suburban with Significant Shopping';
            capitalDesigns[c].Existing_Phases_are_Copper__c = 'No';
            capitalDesigns[c].Footage_of_New_Feeder_Fiber_Built__c = 2500;
            capitalDesigns[c].Remote_Electronics_for_Cards_Only__c = 'No';
            capitalDesigns[c].Initial_CO_Deployment_Fiber_Technology__c = 'No';
            capitalDesigns[c].CO_Electronics_for_Cards_Only__c = 'No';
            capitalDesigns[c].F1_Footage_ft__c = 1500;
            capitalDesigns[c].Population_Density__c =  'Suburban';
            capitalDesigns[c].OP_F2_Conduit_Sub_cost_Combined_Cost__c = 2;
            capitalDesigns[c].OP_F2_Conduit_Sub_cost_Cost_ft__c =20;
            capitalDesigns[c].OP_F2_Conduit_Sub_cost_Cost_LU__c = 20;
            capitalDesigns[c].OP_F2_Conduit_Sub_cost_Unit__c = 20;
            capitalDesigns[c].OP_F2_FDH_Sub_cost_Comb_Cost__c = 20;
            capitalDesigns[c].OP_F2_FDH_Sub_cost_Cost_LU__c = 20;
            capitalDesigns[c].OP_F2_FDH_Sub_cost_Installation__c = 20;
            capitalDesigns[c].OP_F2_FDH_Sub_cost_Material__c = 20;
            capitalDesigns[c].OP_F2_FDH_Sub_cost_Overhead__c = 20;
            capitalDesigns[c].OP_F2_FDH_Sub_cost_Sub_unit__c = 20;
            capitalDesigns[c].OP_F2_FDH_Sub_cost_Unit__c = 20;
            capitalDesigns[c].OP_F2_Handhole_Sub_cost_Combined_Cost__c = 20;
            capitalDesigns[c].OP_F2_Handhole_Sub_cost_Cost_LU__c = 20;
            capitalDesigns[c].OP_F2_Handhole_Sub_cost_Installation__c = 20;
            capitalDesigns[c].OP_F2_Handhole_Sub_cost_Material__c = 20;
            capitalDesigns[c].OP_F2_Handhole_Sub_cost_Overhead__c = 20;
            capitalDesigns[c].OP_F2_Handhole_Sub_cost_Unit__c = 20;
            capitalDesigns[c].OP_F2_Horizontal_Fiber_Sub_cost_Cost_ft__c = 20;
            capitalDesigns[c].OP_F2_Horizontal_Fiber_Sub_cost_Cost_LU__c = 20;
            capitalDesigns[c].OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c = 20;
            capitalDesigns[c].OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c = 20;
            capitalDesigns[c].OP_F2_Ped_MST_AP_Sub_cost_Cost_LU__c = 20;
            capitalDesigns[c].OP_F2_Ped_MST_AP_Sub_cost_Installation__c = 20;
            capitalDesigns[c].OP_F2_Ped_MST_AP_Sub_cost_Material__c = 20;
            capitalDesigns[c].OP_F2_Splicing_Sub_cost_Unit__c = 20;
            capitalDesigns[c].OP_F2_Splitter_Sub_cost_Combined_Cost__c = 22;
            capitalDesigns[c].OP_F2_Splitter_Sub_cost_Cost_LU__c = 20;
            capitalDesigns[c].OP_F2_Splitter_Sub_cost_Installation__c = 20;
            capitalDesigns[c].OP_F2_Splitter_Sub_cost_Material__c = 20;
            capitalDesigns[c].OP_F2_Splitter_Sub_cost_Overhead__c = 20;
            capitalDesigns[c].OP_F2_Splitter_Sub_cost_Sub_Unit__c = 20;
            capitalDesigns[c].OP_F2_Splitter_Sub_cost_Unit__c = 20;
            capitalDesigns[c].OP_F2_Total_Cost_Combined_Cost__c = 20;
            capitalDesigns[c].OP_F2_Total_Cost_Cost_LU__c = 20;
            capitalDesigns[c].OP_F2Mobi_engtime_prmt_flag_SBcst_CstLU__c = 20;
            capitalDesigns[c].OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c = 20;
            capitalDesigns[c].OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c = 20;
            capitalDesigns[c].OP_F2SBcst_w_oF2Cond_FDH_Spltr_Cost_ft__c = 20;
            capitalDesigns[c].OP_F2SBcst_w_oF2Cond_FDH_Spltr_Cost_LU__c = 20;
            capitalDesigns[c].OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c = 20;
            capitalDesigns[c].OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c = 20;
            capitalDesigns[c].OP_F2Vertical_Fiber_Stub_Sub_cst_Cst_LU__c = 20;
            capitalDesigns[c].OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c = 20;
            capitalDesigns[c].OP_F2VerticalFiber_Stub_Sub_cst_Material__c = 20;
            capitalDesigns[c].OP_F2VerticalFiber_Stub_Sub_cst_Overhead__c = 20;
            capitalDesigns[c].OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c = 72;
            capitalDesigns[c].OP_F2_Ped_MST_AP_Sub_cost_Overhead__c = 20;
            capitalDesigns[c].OP_F2_Ped_MST_AP_Sub_cost_Unit__c = 20;
            capitalDesigns[c].OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c = 20;
            capitalDesigns[c].OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c = 20;
            capitalDesigns[c].OP_F2_Splicing_Sub_cost_Combined_Cost__c = 20;
            capitalDesigns[c].OP_F2_Splicing_Sub_cost_Cost_LU__c = 20;
            capitalDesigns[c].OP_F2_Splicing_Sub_cost_Installation__c = 20;
            capitalDesigns[c].OP_F2_Splicing_Sub_cost_Overhead__c = 20;
            capitalDesigns[c].Capital_Design_Stage__c = 'Planner Design Complete'; //ESCJ-1623 BUG FIX.
        }        
        INSERT capitalDesigns;
        
        List<Offer__c> offerList = TestDataFactory.createOffer(opportunities,12,false); //ESCJ-1623 BUG FIX.
        for (Integer o = 0; o < 12; o++) {
            offerList[o].Opportunity__c = opportunities[0].Id;
            offerList[o].Associated_Capital_Design__c = capitalDesigns[o].Id;
        }
        insert offerList;  //ESCJ-1623 BUG FIX.
    
    }//end test-setup
    
    /**********************************************************************************************
  Purpose: This method is used to test Building Style equals with SFU CTL-ON.
  ===============================================================================================
  History:
  Author    *          UserStory   *    Date         
  Muhammad Nadeer MK       ESCJ-583        10/03/2022    
  ***********************************************************************************************/
  @isTest static void buildStyleSFUCTLONCalculations1() {
     
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
        if (cd.Building_Style__c == 'SFU CTL-ON') {
            cd.nbr_of_Living_Units__c = 305;
        }
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(buildStyleSFUCTLONCalculations1) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }
    
    
 /**********************************************************************************************
  Purpose: This method is used to test Building Style equals with Highrise CTL-ON.
  ===============================================================================================
  History:
  Author    *          UserStory   *    Date         
  Muhammad Nadeer MK       ESCJ-583        10/03/2022    
  ***********************************************************************************************/
  @isTest static void buildStyleHighriseCTLONCalculations1() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
        if(cd.Building_Style__c == 'Highrise CTL-ON') {
            cd.nbr_of_Living_Units__c = 305;
            cd.for_MDU_nbr_of_Buildings__c = 10;
            cd.for_Midrise_Highrise_nbof_average_Floors__c = 15;
        }
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(buildStyleHighriseCTLONCalculations1) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }
    
  
     /**********************************************************************************************
  Purpose: This method is used to test Building Style equals with Highrise Bulk.
  ===============================================================================================
  History:
  Author    *          UserStory   *    Date         
  Muhammad Nadeer MK       ESCJ-583        10/03/2022    
  ***********************************************************************************************/
  @isTest static void buildStyleHighriseBulkCalculations1() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
        if (cd.Building_Style__c == 'Highrise Bulk') {
            cd.nbr_of_Living_Units__c = 305;
            cd.for_MDU_nbr_of_Buildings__c = 10;
            cd.for_Midrise_Highrise_nbof_average_Floors__c = 15;
        }
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(buildStyleHighriseBulkCalculations1) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }
    
  
  /**********************************************************************************************
  Purpose: This method is used to test Building Style equals with SFU Retail.
  ===============================================================================================
  History:
  Author    *          UserStory   *    Date         
  Muhammad Nadeer MK       ESCJ-583        10/03/2022    
  ***********************************************************************************************/
  @isTest static void buildStyleSFURetailCalculations2() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
        if (cd.Building_Style__c == 'SFU Retail') {
            cd.nbr_of_Living_Units__c = 305;//ESCJ-1578 US
			cd.F2_nbr_of_Handhole__c = NULL;//ESCJ-1578 US
            cd.F2_nbr_of_Ped__c = 25;
        }
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(buildStyleSFURetailCalculations2) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }
        
    
    

  /**********************************************************************************************
  Purpose: This method is used to test Building Style equals with Midrise Retail.
  ===============================================================================================
  History:
  Author    *          UserStory   *    Date         
  Muhammad Nadeer MK       ESCJ-583        10/03/2022    
  ***********************************************************************************************/
  @isTest static void buildStyleMidriseRetailCalculations2() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
        if (cd.Building_Style__c == 'Midrise Retail') {
            cd.nbr_of_Living_Units__c = 305;
		    cd.for_MDU_nbr_of_Buildings__c = 30;
            cd.for_Midrise_Highrise_nbof_average_Floors__c = 5;
        }
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(buildStyleMidriseRetailCalculations2) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }
    
    
     /**********************************************************************************************
  Purpose: This method is used to test Building Style equals with Cottage CTL-ON.
  ===============================================================================================
  History:
  Author    *          UserStory   *    Date         
  Muhammad Nadeer MK       ESCJ-583        10/03/2022    
  ***********************************************************************************************/
  @isTest static void buildStyleCottageCTLONCalculations2() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
        if(cd.Building_Style__c == 'Cottage CTL-ON') {
            cd.nbr_of_Living_Units__c = 305;
            cd.for_MDU_nbr_of_Buildings__c = 305;
        }
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(buildStyleCottageCTLONCalculations2) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }
    
  @isTest 
  public static void testGetValueForPedUnit() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
      cd.OP_F2_Ped_MST_AP_Sub_cost_Cost_LU__c = CapitalDesignF2OutputCalculation.getValueForPedUnit(cd);
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(testGetValueForPedUnit) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }//end test-method testGetValueForPedUnit
    
  @isTest 
  public static void testGetValueForF2Handhole() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
      cd.OP_F2_Handhole_Sub_cost_Cost_LU__c = CapitalDesignF2OutputCalculation.getValueForF2Handhole(cd);
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(testGetValueForF2Handhole) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }//end test-method testGetValueForF2Handhole
    
  @isTest 
  public static void testGetValueForF2Mobilization() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
      cd.OP_F2Mobi_engtime_prmt_flag_SBcst_CstLU__c = CapitalDesignF2OutputCalculation.getValueForF2Mobilization(cd);
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(testGetValueForF2Mobilization) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }//end test-method testGetValueForF2Mobilization
    
  @isTest 
  public static void testGetValueForF2MobiCombCst() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
      cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c = CapitalDesignF2OutputCalculation.getValueForF2MobiCombCst(cd);
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(testGetValueForF2MobiCombCst) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }//end test-method testGetValueForF2MobiCombCst

  @isTest 
  public static void testGetValueForF2HF() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
      cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c = CapitalDesignF2OutputCalculation.getValueForF2HF(cd);
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(testGetValueForF2HF) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }//end test-method testGetValueForF2HF
    
  @isTest 
  public static void testGetValueForFDHSbUnit() {
    List < Capital_Design__c > capitalDesigns = getCapitalDesigns();
    for (Capital_Design__c cd: capitalDesigns) {
      cd.OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c = CapitalDesignF2OutputCalculation.getValueForFDHSbUnit(cd);
    }
    Test.startTest();
    for (Capital_Design__c cd: capitalDesigns) {
            System.debug('(testGetValueForFDHSbUnit) Required fields for Capital Design ' + cd.Name + ':  ' +
                         '\n cd.Responsible_for_Cable_Home_Wiring__c = ' + cd.Responsible_for_Cable_Home_Wiring__c +
                         '\n cd.Responsible_for_Home_Run_Wiring__c = ' + cd.Responsible_for_Home_Run_Wiring__c +
                         '\n cd.Telecommunication_Cable_Types__c = ' + cd.Telecommunication_Cable_Types__c +
                         '\n cd.Telecom_Cable_Quantity_Per_Living_Unit__c = ' + cd.Telecom_Cable_Quantity_Per_Living_Unit__c +
                         '\n cd.Endpoint_Type_building_architecture__c = ' + cd.Endpoint_Type_building_architecture__c +
                         '\n cd.Responsible_for_Media_Panel__c = ' + cd.Responsible_for_Media_Panel__c +
                         '\n cd.Exterior_Cabinets__c = ' + cd.Exterior_Cabinets__c +
                         '\n cd.NEMA_Rated_Cabinet__c = ' + cd.NEMA_Rated_Cabinet__c +
                         '\n cd.Backboards_required__c = ' + cd.Backboards_required__c +
                         '\n cd.Planned_Build_Out_Years__c = ' + cd.Planned_Build_Out_Years__c +
                         '\n cd.Actual_Build_Out_Months__c = ' + cd.Actual_Build_Out_Months__c +
                         '\n cd.Project_Start_Year__c = ' + cd.Project_Start_Year__c +
                         '\n cd.Alarm_Due_Date__c = ' + cd.Alarm_Due_Date__c +
                         '\n cd.Open_Trench_Date__c = ' + cd.Open_Trench_Date__c +
                         '\n cd.ONT_Location__c = ' + cd.ONT_Location__c +
                         '\n cd.Inside_Wiring__c = ' + cd.Inside_Wiring__c +
                         '\n cd.Units_Built_Year_1__c = ' + cd.Units_Built_Year_1__c +
                         '\n cd.Units_Built_Year_2__c = ' + cd.Units_Built_Year_2__c +
                         '\n cd.Units_Built_Year_3__c = ' + cd.Units_Built_Year_3__c +
                         '\n cd.F1_Feeder_Type__c = ' + cd.F1_Feeder_Type__c +
                         '\n cd.Access_Type__c = ' + cd.Access_Type__c +
                         '\n cd.Occupant_Type__c = ' + cd.Occupant_Type__c +
                         '\n cd.Existing_Feeder_Footage_Utilized__c = ' + cd.Existing_Feeder_Footage_Utilized__c +
                         '\n cd.No_GPON_No_Integrated_Switch__c = ' + cd.No_GPON_No_Integrated_Switch__c +
                         '\n cd.Primary_Descriptor_of_CO_Area__c = ' + cd.Primary_Descriptor_of_CO_Area__c +
                         '\n cd.Existing_Phases_are_Copper__c = ' + cd.Existing_Phases_are_Copper__c +
                         '\n cd.Footage_of_New_Feeder_Fiber_Built__c = ' + cd.Footage_of_New_Feeder_Fiber_Built__c +
                         '\n cd.Remote_Electronics_for_Cards_Only__c = ' + cd.Remote_Electronics_for_Cards_Only__c +
                         '\n cd.Initial_CO_Deployment_Fiber_Technology__c = ' + cd.Initial_CO_Deployment_Fiber_Technology__c +
                         '\n cd.CO_Electronics_for_Cards_Only__c = ' + cd.CO_Electronics_for_Cards_Only__c +
                         '\n cd.F1_Footage_ft__c = ' + cd.F1_Footage_ft__c +
                         '\n cd.Population_Density__c =  ' + cd.Population_Density__c);
    }
    UPDATE capitalDesigns;
    Test.stopTest();
  }//end test-method testGetValueForFDHSbUnit

  /**********************************************************************************************
  Purpose: This method is used to return the List of Capital Design records
  ===============================================================================================
  History:
   Author    *          UserStory   *    Date         
  Muhammad Nadeer MK       ESCJ-583        10/03/2022 
  ***********************************************************************************************/
  private static List < Capital_Design__c > getCapitalDesigns() {
    return [SELECT Id, Name,
            Opportunity__c,
            Property_Address_State__c,
            Primary_Address_State_Name__c,
            State__c,
            State_Name__c,
            F2_Fiber_Conduit_Placement_Sub_Total__c,
            F2_Direct_Buried_96f__c,
            F2_Aerial_10M_144f__c,
            Pull_Fiber_96f__c,
            Place_Conduit_4_c__c,
            Place_Conduit_and_Pull_Fiber_4_c_96f__c,
            Trench_4_c_96f__c,
            Bore_1_25_c_96f__c,
            Cobble_Bore_1_25_c_96f__c,
            Rock_Bore_1_25_c_96f__c,
            F2_Joint_Trench_Custom_with_conduit__c,
            F2_Custom_without_conduit__c,
            OP_F2_Conduit_Sub_cost_Combined_Cost__c,
            OP_F2_Conduit_Sub_cost_Cost_ft__c,
            OP_F2_Conduit_Sub_cost_Cost_LU__c,
            OP_F2_Conduit_Sub_cost_Unit__c,
            OP_F2_FDH_Sub_cost_Comb_Cost__c,
            OP_F2_FDH_Sub_cost_Cost_LU__c,
            OP_F2_FDH_Sub_cost_Installation__c,
            OP_F2_FDH_Sub_cost_Material__c,
            OP_F2_FDH_Sub_cost_Overhead__c,
            OP_F2_FDH_Sub_cost_Sub_unit__c,
            OP_F2_FDH_Sub_cost_Unit__c,
            OP_F2_Handhole_Sub_cost_Combined_Cost__c,
            OP_F2_Handhole_Sub_cost_Cost_LU__c,
            OP_F2_Handhole_Sub_cost_Installation__c,
            OP_F2_Handhole_Sub_cost_Material__c,
            OP_F2_Handhole_Sub_cost_Overhead__c,
            OP_F2_Handhole_Sub_cost_Unit__c,
            OP_F2_Horizontal_Fiber_Sub_cost_Cost_ft__c,
            OP_F2_Horizontal_Fiber_Sub_cost_Cost_LU__c,
            OP_F2_Horizontal_Fiber_Sub_cst_Comb_Cst__c,
            OP_F2_Ped_MST_AP_Sub_cost_Comb_Cost__c,
            OP_F2_Ped_MST_AP_Sub_cost_Cost_LU__c,
            OP_F2_Ped_MST_AP_Sub_cost_Installation__c,
            OP_F2_Ped_MST_AP_Sub_cost_Material__c,
            OP_F2_Splicing_Sub_cost_Unit__c,
            OP_F2_Splitter_Sub_cost_Combined_Cost__c,
            OP_F2_Splitter_Sub_cost_Cost_LU__c,
            OP_F2_Splitter_Sub_cost_Installation__c,
            OP_F2_Splitter_Sub_cost_Material__c,
            OP_F2_Splitter_Sub_cost_Overhead__c,
            OP_F2_Splitter_Sub_cost_Sub_Unit__c,
            OP_F2_Splitter_Sub_cost_Unit__c,
            OP_F2_Total_Cost_Combined_Cost__c,
            OP_F2_Total_Cost_Cost_LU__c,
            OP_F2_Vertical_Fiber_Stub_Sub_cst_Unit__c,
            OP_F2Mobi_engtime_prmt_flag_SBcst_CstLU__c,
            OP_F2Mobi_engtime_prmt_flag_SUBComb_Cst__c,
            OP_F2PotholeRestoration_Sub_cst_Comb_Cst__c,
            OP_F2SBcst_w_oF2Cond_FDH_Spltr_Cost_ft__c,
            OP_F2SBcst_w_oF2Cond_FDH_Spltr_Cost_LU__c,
            OP_F2SBcst_w_oF2Cond_FDH_Spltr_Comb_Cst__c,
            OP_F2Vertical_Fiber_Stub_Sub_cst_Cst_LU__c,
            OP_F2VerticalFiber_Stub_Sub_cst_Comb_Cst__c,
            OP_F2VerticalFiber_Stub_Sub_cst_Material__c,
            OP_F2VerticalFiber_Stub_Sub_cst_Overhead__c,
            OP_F2VerticalFiber_Stub_Sub_cst_Sub_unit__c,
            OP_F2_Ped_MST_AP_Sub_cost_Overhead__c,
            OP_F2_Ped_MST_AP_Sub_cost_Unit__c,
            OP_F2_Pole_Anchor_Guy_Sub_cost_Comb_Cst__c,
            OP_F2_Pole_Make_Ready_Sub_cost_Comb_Cst__c,
            OP_F2_Splicing_Sub_cost_Combined_Cost__c,
            OP_F2_Splicing_Sub_cost_Cost_LU__c,
            OP_F2_Splicing_Sub_cost_Installation__c,
            OP_F2_Splicing_Sub_cost_Overhead__c,
            Building_Style__c,
            nbr_of_Living_Units__c,
            F2_Footage_ft__c,
            Are_there_IDF__c,
            Project_Type__c,
            F2_Footage_Direct_Buried_96f__c,
            F2_Footage_Pull_Fiber_96f__c,
            F2_Footage_Aerial_10M_144f__c,
            F2_Footage_Custom_without_conduit__c,
            F2_nbr_of_IDF_locations__c,
            Existing_FDH__c,
            F2_FDH_size__c,
            F2_nbr_of_Handhole__c,
            F2_nbr_of_Ped__c,
            F2_Mobilization_Cost__c,
            F2_Pole_Make_Ready_Cost__c,
            F2_Pole_Anchor_and_Guy_Cost__c,
            F2_Pothole_Restoration_Cost__c,
            Service_Type__c,
            for_Retail_Take_rate__c,
            ONT_Model__c,
            for_SFU_Average_Lot_Size__c,
            for_MDU_nbr_of_Buildings__c,
            for_Midrise_Highrise_nbof_average_Floors__c,
            Responsible_for_Cable_Home_Wiring__c,
            Responsible_for_Home_Run_Wiring__c,
            Telecommunication_Cable_Types__c,
            Telecom_Cable_Quantity_Per_Living_Unit__c,
            Endpoint_Type_building_architecture__c,
            Responsible_for_Media_Panel__c,
            Exterior_Cabinets__c,
            NEMA_Rated_Cabinet__c,
            Backboards_required__c,
            Planned_Build_Out_Years__c,
            Actual_Build_Out_Months__c,
            Project_Start_Year__c,
            Alarm_Due_Date__c,
            Open_Trench_Date__c,
            ONT_Location__c,
            Inside_Wiring__c,
            Units_Built_Year_1__c,
            Units_Built_Year_2__c,
            Units_Built_Year_3__c,
            F1_Feeder_Type__c,
            Access_Type__c,
            Occupant_Type__c,
            Existing_Feeder_Footage_Utilized__c,
            No_GPON_No_Integrated_Switch__c,
            Primary_Descriptor_of_CO_Area__c,
            Existing_Phases_are_Copper__c,
            Footage_of_New_Feeder_Fiber_Built__c,
            Remote_Electronics_for_Cards_Only__c,
            Initial_CO_Deployment_Fiber_Technology__c,
            CO_Electronics_for_Cards_Only__c,
            F1_Footage_ft__c,
            Population_Density__c
      FROM Capital_Design__c
      WHERE Opportunity__c != NULL
    ];
  }//end method getCapitalDesigns

  /**********************************************************************************************
    Purpose: This method is used to return the List of CCT_F2_Stub_Estimator__c records
    ===============================================================================================
    History:
     Author    *          UserStory   *    Date         
    Muhammad Nadeer MK       ESCJ-583        15/03/2022 
    ***********************************************************************************************/
  private static List < CCT_F2_Stub_Estimator__c > getStubEstimator() {
  	return [SELECT Id,
		            F2_STUBE_FTTU__c,
        		    F2_STUBE_FTTB__c,
              		F2_STUBE_FTTIDF__c,
              		F2_STUBE_Building__c,
              		F2_STUBE_Floor__c,
              		F2_STUBE_Building_Style__c
              FROM CCT_F2_Stub_Estimator__c
              WHERE F2_STUBE_Building_Style__c != NULL];
  }//end method getStubEstimator
 
}//end test-class CapitalDesignF2OutputCalculationTest