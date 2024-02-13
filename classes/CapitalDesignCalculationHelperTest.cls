/**
 * @author  : IBM
 * @Description : This class will help to get formula calculations for cct tool
 *  create utility methods 
 * @Date : 16/02/2022
 *  
 * 
===============================================================================================
 * Date         Author      UserStory          Description  
 * 08/02/2023   T2Cabato    QFCJ-4286          BRAIN-Drop-Cost-Fix                   
 * 09/22/2023   T2Cabato    QFCJ-4580          Round CCT cost fields results to 2 decimals 
 ***********************************************************************************************/
@isTest
public class CapitalDesignCalculationHelperTest {
    
    
     @testSetup static void testData(){
       TestDataFactory.createStateCostData(1,TRUE);
       TestDataFactory.createCCTF2CostEstimator('SFU',500,1,15,TRUE);
       TestDataFactory.createCCTF2StubEstimator(100, 2, 1, TRUE);
      // TestDataFactory.createCCTF2FDHEstimator(100, 2, 1, TRUE);//Commenting this as Method is commented in TestDataFacory, which is causing issue while deploying
       TestDataFactory.createCCTCostEstimator('FL', 2, TRUE);   
       TestDataFactory.createStateCostData(1, TRUE);
     }
    @isTest static void testCDMethods(){
        CapitalDesignCalculationHelper.initializeStateCostMap();
        CapitalDesignCalculationHelper.initializeF2CostEstimatorMap();
            CapitalDesignCalculationHelper.initializeF2StubEstimatorMap();
            CapitalDesignCalculationHelper.initializeF2FDHEstimatorMap();
            CapitalDesignCalculationHelper.initializeF1CostEstimatorMap();
            CapitalDesignCalculationHelper.initializeONTUPSShelfEstimatorMap();
            CapitalDesignCalculationHelper.initializeCostEstimatorMap();
            CapitalDesignCalculationHelper.initializeCostEstimatorDataForSFU();
            CapitalDesignCalculationHelper.initializeCostEstimatorDataForMDU();
            CapitalDesignCalculationHelper.getStateCostObject('Alabama', 'AL');
            CapitalDesignCalculationHelper.getF2StubEstBySubUnit(2.0);
            CapitalDesignCalculationHelper.getCostEstimatorByMatDesc('Test');
            CapitalDesignCalculationHelper.getCostEstimatorByRGCostModel('Test');
    }
 
}//end test-class CapitalDesignCalculationHelperTest