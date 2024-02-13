/***************************************************************
===============================================================
Purpose: To create test data to be used in test classes
===============================================================
History:

History:
AUTHOR      DATE        Reference   Description
Navin M     14/12/2021  ESCJ-364    Initial draft
===============================================================================================
 * Date         Author      UserStory          Description  
 * 08/02/2023   T2Cabato    QFCJ-4286          BRAIN-Drop-Cost-Fix                    
****************************************************************/
@isTest
public with sharing class TestDataFactory {  

    /***********************************************************************************************
    Purpose: Create Test Property request records
    Parameters: data source, street, city, state, latitude, longitude, count, doInsert
    Return: List of Property request records
    ================================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     14/12/2021  ESCJ-364    Initial draft
    ************************************************************************************************/
    public static List<Property_Request_Record__c> createPropertyReqRecords(
        String dataSource,
        String street,
        String city,
        String state,
        Decimal latitude,
        Decimal longitude,
        Integer count,
        Boolean doInsert
    ) {
        List<Property_Request_Record__c> propertyRequestRecords = new List<Property_Request_Record__c>();
        for (Integer i = 0; i < count; i++) {
            if (dataSource == 'ALN') {
                // If data source is ALN
                propertyRequestRecords.add(
                    new Property_Request_Record__c(
                        Data_Source__c = dataSource,
                        ProjectAddress__c = street,
                        ProjectCity__c = city,
                        ProjectState__c = state,
                        GPSLatitude__c = latitude,
                        GPSLongitude__c = longitude
                    )
                );
            }
            // If data source is Dodge
            else if (dataSource == 'Dodge') {
                propertyRequestRecords.add(
                    new Property_Request_Record__c(
                        Data_Source__c = dataSource,
                        STREET__c = street,
                        CITY__c = city,
                        STATE__c = state,
                        GEO_LATITUDE__c = latitude,
                        GEO_LONGITUDE__c = longitude
                    )
                );
            }
            // If data source is User
            else if (dataSource == 'User') {
                propertyRequestRecords.add(
                    new Property_Request_Record__c(
                        Data_Source__c = dataSource,
                        User_Property_Address__c = street,
                        User_Property_City__c = city,
                        User_Property_State__c = state,
                        User_Latitude__c = latitude,
                        User_Longitude__c = longitude
                    )
                );
            }
            // If data source is User
            else if (dataSource == 'Customer Success') {
                propertyRequestRecords.add(
                    new Property_Request_Record__c(
                        Data_Source__c = dataSource,
                        CS_Location__c = street, //QFCJ-4554
                        CS_City__c = city, //QFCJ-4554
                        CS_State__c = state, //QFCJ-4554
                        User_Latitude__c = latitude,
                        User_Longitude__c = longitude
                    )
                );
            }
        }
        if (doInsert) {
            insert propertyRequestRecords;
        }
        return propertyRequestRecords;
    }

    /************************************************************************************************
    Purpose: Create Test Transaction summary records
    Parameters: prrDataSource, prrAddress, prrCity, prrState, prrLatitude, prrLongitude, count, doInsert
    Return: List of Transaction summary records
    =================================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     14/12/2021  ESCJ-364    Initial draft
    ************************************************************************************************/
    public static List<Transaction_Summary__c> createTransactionSummaries(
        String prrDataSource,
        String prrAddress,
        String prrCity,
        String prrState,
        Decimal prrLatitude,
        Decimal prrLongitude,
        Integer count,
        Boolean doInsert
    ) {
        List<Transaction_Summary__c> transactionSummaries = new List<Transaction_Summary__c>();
        for (Integer i = 0; i < count; i++) {
            transactionSummaries.add(
                new Transaction_Summary__c(
                    PRR_Data_Source__c = prrDataSource,
                    PRR_Address__c = prrAddress,
                    PRR_City__c = prrCity,
                    PRR_State__c = prrState,
                    PRR_Latitude__c = prrLatitude,
                    PRR_Longitude__c = prrLongitude
                )
            );
        }
        if (doInsert) {
            insert transactionSummaries;
        }
        return transactionSummaries;
    }

    /***********************************************************************************************
    Purpose: Create Test Property records
    Parameters: primaryAddressStreet, primaryAddressCity, primaryAddressState, countyCode, stateCode,
    apn, latitude, longitude, count, doInsert
    Return: List of Property records
    ================================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Navin M     14/12/2021  ESCJ-364    Initial draft
    ***********************************************************************************************/
    public static List<Property__c> createProperties(
        String primaryAddressStreet,
        String primaryAddressCity,
        String primaryAddressState,
        String countyCode,
        String stateCode,
        String apn,
        Decimal latitude,
        Decimal longitude,
        Integer count,
        Boolean doInsert
    ) {
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < count; i++) {
            properties.add(
                new Property__c(
                    Primary_Address_Street__c = primaryAddressStreet,
                    Primary_Address_City__c = primaryAddressCity,
                    Primary_Address_State__c = primaryAddressState,
                    County_Code__c = countyCode,
                    State_Code__c = stateCode,
                    APN__c = apn,
                    Latitude__c = latitude,
                    Longitude__c = longitude,
                    Max_Bandwidth_Available__c = '1000'
                )
            );
        }
        if (doInsert) {
            insert properties;
        }
        return properties;
    }
    
    
    /***********************************************************************************************
    Purpose: Create Test CONTACT records
    Parameters: firstName, lastName, count, doInsert
    Return: List of Contact records
    ================================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Ami P     21/12/2021    ESCJ-327    Initial draft
    ***********************************************************************************************/
    public static List<Contact> createContacts(
        String firstName,
        String lastName,
        Integer count,
        Boolean doInsert
    ) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < count; i++) {
            contacts.add(
                new Contact(
                    FirstName = firstName,
                    LastName = lastName
                )
            );
        }
        if (doInsert) {
            insert contacts;
        }
        return contacts;
    }
    
    /***********************************************************************************************
    Purpose: Create NetworkWireCenter records
    Parameters: wireCenterName
    Return: List of NetworkWireCenter records
    ================================================================================================
    History:
    AUTHOR      DATE        Reference   Description
    Deepak k    22/12/2021  ESCJ-363    Initial draft
    ***********************************************************************************************/
    public static List<Network_Wire_Center__c> createNetworkWireCenters(
        String wireCenterName,
        Integer count,
        Boolean doInsert
    ) {
        List<Network_Wire_Center__c> wireCenters = new List<Network_Wire_Center__c>();
        for (Integer i = 0; i < count; i++) {
            wireCenters.add(
                new Network_Wire_Center__c(
                    Name = wireCenterName
                )
            );
        }
        if (doInsert) {
            insert wireCenters;
        }
        return wireCenters;
    }
    
    
    
    /***********************************************************************************************
     Purpose: Create Test State Cost records
     Parameters: count, doInsert
     Return: List of StateCost records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ami Parekh      03/03/2022      ESCJ-557    Initial draft
    ************************************************************************************************/
    public static List<StatesCostforCapitalDesign__c> createStateCostData(Integer count,Boolean doInsert){
         
        List<StatesCostforCapitalDesign__c> scList = new List<StatesCostforCapitalDesign__c>();
        for (Integer i = 0; i < count; i++) {
            scList.add(
                new StatesCostforCapitalDesign__c(
                    Name = 'FL',
                    F1_Cost_ft_LE_Use_Existing_Spare__c = 0.22,
                    F1_Cost_ft_LE_Use_Vacant_12f__c=1.14,
                    F1_Cost_ft_LE_Plow_2_c_48f__c=7,
                    F1_Cost_ft_LE_Aerial_10M_144f__c=15,
                    F1_Cost_ft_LE_Overpull_1_25_c_864f__c=10,
                    F1_Cst_ft_BackbonBore_1_25_c_3_in4_c864__c=37,
                    F1_Cost_ft_LE_Cobble_Bore_1_25_c_864f__c=44.5,
                    F1_Cst_ft_Cobble_Bore_1_25_c_in_4_c_864__c=51,
                    F1_Cost_ft_LE_Direct_Buried_96f__c=10,
                    F1_Cost_ft_LE_Lateral_Bore_1_25_c_864f__c=28,
                    F1_Cost_ft_LE_Rock_Bore_1_25_c_864f__c=60.5,
                    F1_Cst_ft_Rock_Bore_1_25_c_in_4_c_864f__c=80.5,
                    F1_Cost_ft_FW_Blended__c=13.9,
                    F1_Cost_ft_FW_Greenfield_F1_Multiplier__c=1,
                    F1_Cost_ft_FW_Brownfield_F1_Multiplier__c=1,
                    F2_Cost_ft_LE_Direct_Buried_96f__c=8.05,
                    F2_Cost_ft_LE_Aerial_10M_144f__c=15,
                    F2_Cost_ft_LE_Pull_Fiber_96f__c=1.85,
                    F2_Cost_ft_LE_Place_Conduit_4_c__c=3.09,
                    F2_Cost_ft_PlaceConduitPullFiber_4_c96f__c=4.94,
                    F2_Cost_ft_LE_Trench_4_c_96f__c=12.69,
                    F2_Cost_ft_LE_Bore_1_25_c_96f__c=22.02,
                    F2_Cost_ft_LE_Cobble_Bore_1_25_c_96f__c=39.91,
                    F2_Cost_ft_LE_Rock_Bore_1_25_c_96f__c=54.43,
                    F2_Eng_time_Cost_Over_200K_OVH__c=6.57,
                    F2_Eng_time_Cost_100K_200K_OVH__c=8.09,
                    F2_Eng_time_Cost_50K_100K_OVH__c =11.57,
                    F2_Eng_time_Cost_Under_50K_OVH__c = 20.26,  
                    F3_cost_ft_LE_Aerial_12f__c=1.9,
                    F3_cost_ft_LE_Bore_1_25_c_12f__c=14.4,
                    F3_cost_ft_LE_Buried_w_Conduit_12f__c=6.3,
                    F3_cost_ft_LE_Direct_Buried_12f__c=2.9,
                    F3_cost_ft_LE_Pull_Fiber_12f__c=2.0,
                    F3_Cost_LU_LE_Slack_box__c=23.0
                )
            );
        }
        if (doInsert) {
            INSERT scList;
        }  
               
        return scList;
    }

    /***********************************************************************************************
    Purpose: Create Test Opportunities records
    Parameters: name, developmentStatus, stageName, closeDate, propertyId, count, doInsert
    Return: List of Opportunity records
    ================================================================================================
    History:
    AUTHOR             DATE        Reference   Description
    Ami Parekh     03/03/2022      ESCJ-557    Initial draft
    ************************************************************************************************/

    public static List<Opportunity> createOpportunities(
        String name,
        String developmentStatus,
        String stageName,
        Date closeDate,
        Id propertyId,
        Integer count,
        Boolean doInsert
    ){
        List<Opportunity> opportunities = new List<Opportunity>();
        if (count > 1) {
             for (Integer i = 0; i < count; i++) {
                opportunities.add(
                    new Opportunity(
                        Name = name+i,
                        Property__c = propertyId,
                        CloseDate = closeDate,
                        StageName = stageName ,
                        Development_Status__c=developmentStatus   
                    )
                );
            }
        } else {
	        opportunities.add(
                new Opportunity(
                    Name = name,
                    Property__c = propertyId,
                    CloseDate = closeDate,
                    StageName = stageName ,
                    Development_Status__c=developmentStatus   
                    )
                );
        }
        if (doInsert) {
            insert opportunities;
        }
        return opportunities;
    }

    /***********************************************************************************************
     Purpose: Create Test CapitalDesign records
     Parameters:oppId, count, doInsert
     Return: List of CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ami Parekh      03/03/2022      ESCJ-557    Initial draft
    ************************************************************************************************/
    public static List<Capital_Design__c> createCapitalDesigns(Id oppId,Integer count,Boolean doInsert){
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            capitalDesigns.add(
                new Capital_Design__c(
                    Opportunity__c = oppId,
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,
                    F2_Footage_ft__c = 66450,
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c =0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c =0,
                    Cobble_Bore_1_25_c_96f__c =0,
                    Rock_Bore_1_25_c_96f__c =0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97 ,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c =0,
                    Use_Vacant_12f__c =0,
                    Plow_2_c_48f__c =0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c =0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c=0,
                    Cobble_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_in_4_c_864f__c=0,
                    F1_Joint_Trench_Custom_with_conduit__c=85,
                    F1_Custom_without_conduit__c=0,
                    F1_Footage_ft__c=5300,
                    Service_Type__c = 'CTL_ON',
                    Building_Style__c ='SFU CTL-ON',
                    nbr_of_Living_Units__c = 1289,
                    for_SFU_Average_Lot_Size__c= '50',
                    for_MDU_nbr_of_Buildings__c= 10,
                    for_Midrise_Highrise_nbof_average_Floors__c= 10,
                    Capital_Design_Stage__c='Planner Design Complete',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c=10,
                    F1_Cost_ft_for_Custom_without_conduit__c	=0,
                    F2_Cost_ft_for_Custom_without_conduit__c=7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c=11.7,
                    Direct_Buried_12f__c=15,
                    Buried_w_Conduit_12f__c=15,
                    Aerial_12f__c=20,
                    Bore_1_25_c_12f__c=15,
                    Joint_Trench_Custom__c=15,
                    Pull_Fiber_12f__c=20 
                )
            );
        }
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }


    /***********************************************************************************************
     Purpose: Create Test Cost Estimator records
     Parameters: buildingType, footageBld, footageFlr, count, doInsert
     Return: List of CostEstimator records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ami Parekh      03/03/2022      ESCJ-557    Initial draft
    ************************************************************************************************/
    public static List<CCT_F2_Cost_Estimator__c> createCCTF2CostEstimator(
        String buildingType,
        Decimal footageBld,
        Decimal footageFlr,
        Integer count,
        Boolean doInsert
    ){ 
        List<CCT_F2_Cost_Estimator__c> costEstimators = new List<CCT_F2_Cost_Estimator__c>();
        for (Integer i = 0; i < count; i++) {
            costEstimators.add(
                new CCT_F2_Cost_Estimator__c(
                    F2_CostE_Building_Type__c = buildingType,
                    F2_CostE_Footage_Bld__c=footageBld,
                    F2_CostE_Footage_Flr__c =footageFlr  
                )
            );
        }
        if (doInsert) {
            insert costEstimators;
        }
        return costEstimators;
    }
    
    
    /***********************************************************************************************
     Purpose: Create Test F2 Stub Estimator records
     Parameters: buildingType, footageBld, footageFlr, count, doInsert
     Return: List of F2 Stub Estimator records
    ================================================================================================
     History:
     Author    *          UserStory   *    Date              
    Muhammad Nadeer MK       ESCJ-583        14/03/2022
    ************************************************************************************************/
    public static List<CCT_F2_Stub_Estimator__c> createCCTF2StubEstimator(
        Decimal MatCost,
        Decimal Size,
        Integer count,
        Boolean doInsert
    ){ 
        List<CCT_F2_Stub_Estimator__c> costEstimators = new List<CCT_F2_Stub_Estimator__c>();
        for (Integer i = 0; i < count; i++) {
            costEstimators.add(
                new CCT_F2_Stub_Estimator__c(
                    F2_STUBE_Material_Cost__c = MatCost,
                    F2_STUBE_Stub_Size__c= Size
                )
            );
        }
        if (doInsert) {
            insert costEstimators;
        }
        return costEstimators;
    }
    
    
    
    /***********************************************************************************************
     Purpose: Create Test CCT Cost Estimator records
     Parameters: buildingType, footageBld, footageFlr, count, doInsert
     Return: List of CCT Cost Estimator records
    ================================================================================================
     History:
     Author    *          UserStory   *    Date              
    Muhammad Nadeer MK       ESCJ-583        14/03/2022
    ************************************************************************************************/
    public static List<CCT_Cost_Estimator__c> createCCTCostEstimator(
        String State,
        Integer count,
        Boolean doInsert
    ){ 
        List<CCT_Cost_Estimator__c> costEstimators = new List<CCT_Cost_Estimator__c>();
        for (Integer i = 0; i < count; i++) {
            costEstimators.add(
                new CCT_Cost_Estimator__c(
                    State__c = State
                )
            );
        }
        if (doInsert) {
            insert costEstimators;
        }
        return costEstimators;
    }
    
    /***********************************************************************************************
     Purpose: Create Test CCT Cost Estimator records
     Parameters: buildingType, footageBld, footageFlr, count, doInsert
     Return: List of CCT Cost Estimator records
    ================================================================================================
     History:
     Author    *          UserStory   *    Date              
    Muhammad Nadeer MK       ESCJ-583        14/03/2022
    ************************************************************************************************/
    public static List<Offer__c> createOffer(List<Opportunity> oppList, Integer count,boolean doInsert){ 
        List<Offer__c> offerList = new List<Offer__c>();
        for (Integer i = 0; i < count; i++) {
            offerList.add(
                new Offer__c(
                    Capital_Design_Required__c = 'Yes',
                    Opportunity__c = (oppList.get(i)).Id
                )
            );
        }
        if (doInsert) {
            insert offerList;
        }
        return offerList;
    }
    
     /***********************************************************************************************
     Purpose: Create Test CCT Cost Estimator records
     Parameters: buildingType, footageBld, footageFlr, count, doInsert
     Return: List of CCT Cost Estimator records
    ================================================================================================
     History:
     Author    *          UserStory   *    Date              
    Muhammad Nadeer MK       ESCJ-583        14/03/2022
    ************************************************************************************************/
    public static List<Segment__c > createSegment(List<Opportunity> oppList,List<Property__c> propList, Integer count,boolean doInsert){ 
        List<Segment__c > segList = new List<Segment__c >();
        for (Integer i = 0; i < count; i++) {
            segList.add(
                new Segment__c (
                    Segment_Total_Units__c = 0,
                    Segment_Structure__c = 'Cottage',
                    Property__c = (propList.get(i)).Id,
                    Segment_Status__c = 'Active Opportunity',
                    Opportunity__c = (oppList.get(i)).Id,
                    Segment_Inventory_Type__c = 'Unit Inventory Driver',
                    Segment_Use__c = 'Rental'
                )
            );
        }
        if (doInsert) {
            insert segList;
        }
        return segList;
    }
  
 /***********************************************************************************************
     Purpose: Create Test CCT F2 FDH Estimator records
     Parameters: buildingType, footageBld, footageFlr, count, doInsert
     Return: List of CCT Cost Estimator records
    ================================================================================================
     History:
     Author    *          UserStory   *    Date              
    Muhammad Nadeer MK       ESCJ-583        14/03/2022
    ************************************************************************************************/
    public static List<CCT_F2_FDH_Estimator__c> createCCTF2FDHEstimator(
        Decimal outdoorLUFDH,
        Decimal indoorLUFDH,
        Integer count,
        Boolean doInsert
    ){ 
        List<CCT_F2_FDH_Estimator__c> costEstimators = new List<CCT_F2_FDH_Estimator__c>();
        for (Integer i = 0; i < count; i++) {
            costEstimators.add(
                new CCT_F2_FDH_Estimator__c(
                    F2_FDHE_Outdoor_LU_FDH__c = outdoorLUFDH,
                    F2_FDHE_Indoor_LU_FDH__c = indoorLUFDH
                )
            );
        }
        if (doInsert) {
            insert costEstimators;
        }
        return costEstimators;
    }
    /***********************************************************************************************
     Purpose: Create Test CapitalDesign records with BRAIN Defaults
     Parameters:oppId, count, doInsert
     Return: List of CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ted Cabato         12/01/2022  ESCJ-2138    Initial draft
    ************************************************************************************************/
    public static List<Offer__c> createOffersForBRAINTests(List<Opportunity> oppList, Integer count, boolean doInsert){ 
        List<Offer__c> offerList = new List<Offer__c>();
        String designatedOfferType = null;
        String designatedContractType = null;
        String designatedOtherProviderContractType = null;
        for (Integer i = 0; i < count; i++) {
            if (math.mod(i,6) == 0) { //legacy = EMA
                designatedOfferType = 'Exclusive Marketing';
                designatedContractType = 'EMA';
                designatedOtherProviderContractType = 'NonContracted';
            } else if (math.mod(i,6) == 1) { //legacy = SMA
                designatedOfferType = 'Shared Marketing';
                designatedContractType = 'SMA';
                designatedOtherProviderContractType = 'MarketingAgreement';
            } else if (math.mod(i,6) == 2) { //legacy = BULK 
                designatedOfferType = 'Bulk Agreement';
                designatedContractType = 'BULK';
                designatedOtherProviderContractType = 'NoCompetition';
            } else if (math.mod(i,6) == 3) { //legacy = NONE
                designatedOfferType = 'Building Entry Agreement';
                designatedContractType = 'NONE';
                designatedOtherProviderContractType = 'NonContracted';
            } else if (math.mod(i,6) == 4) { //legacy = SOLE PROVIDER
                designatedOfferType = 'Exclusive Marketing';
                designatedContractType = 'EMA';
                designatedOtherProviderContractType = 'NoCompetition';
            } else { //legacy = COMPETITIVE LOSS
                designatedOfferType = 'None';
                designatedContractType = 'NONE';
                designatedOtherProviderContractType = 'MarketingAgreement';
            }
            offerList.add(
                new Offer__c(
                    Capital_Design_Required__c = 'Yes',
                    Opportunity__c = (oppList.get(i)).Id,
                    Offer_Type__c = designatedOfferType,
                    Other_Provider_Contract_Type__c = designatedOtherProviderContractType,
                    Offer_Status__c = 'Capital Evaluation',
                    Contract_Term__c = '60',
                    Bulk_Data_Type__c = 'Other',
                    Bulk_Data_Speed_Profile_DL_UL__c = '940M/940M',
                    Data_Bounty_Amount__c = 13.60, 
                    Requested_Bulk_Data_Price__c = 29.95,
                    Prepaid_Marketing_Fee_Per_Unit__c = 200.00,
                    Flat_Revenue_Share__c = 3.45,
                    Bulk_Data_Type_Approved__c = 'GPON',
                    Bulk_Data_Speed_Profile_DL_UL_Approv__c = '940M/940M',
                    Data_Bounty_Amount_Approved__c = 13.60, 
                    Requested_Bulk_Data_Price_Approved__c = 29.95,
                    Prepaid_Marketing_Fee_Per_Unit_Approve__c = 200.00,
                    Flat_Revenue_Share_Approved__c = 3.45,
                    Revenue_Share_Agent_Commission_Rate__c = 3.45 / 100,
                    Revenue_Share_MIN_Penetration_Rate__c = 0,
                    Revenue_Share_MAX_Penetration_Rate__c = 1                
                )
            );
        }
        if (doInsert) {
            insert offerList;
        }
        return offerList;
    }
    /***********************************************************************************************
     Purpose: Create Test CapitalDesign records with BRAIN Defaults
     Parameters:oppId, count, doInsert
     Return: List of CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ted Cabato         12/01/2022  ESCJ-2138    Initial draft
    ************************************************************************************************/
    public static List<Capital_Design__c> createCapitalDesignsWithBRAINDefaults(Id oppId,String stateName,Integer count,Boolean doInsert){
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            capitalDesigns.add(
                new Capital_Design__c(
                    Opportunity__c = oppId,
                    Capital_Design_Type__c = 'Standard',
                    Primary_Address_State_Name__c = stateName,
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,                    
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c =0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c =0,
                    Cobble_Bore_1_25_c_96f__c =0,
                    Rock_Bore_1_25_c_96f__c =0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97 ,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c =0,
                    Use_Vacant_12f__c =0,
                    Plow_2_c_48f__c =0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c =0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c=0,
                    Cobble_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_in_4_c_864f__c=0,
                    F1_Joint_Trench_Custom_with_conduit__c=85,
                    F1_Custom_without_conduit__c=0,
                    F1_Footage_ft__c=5300,
                    Building_Style__c ='Cottage Retail',
                    nbr_of_Living_Units__c = 1289,
                    for_SFU_Average_Lot_Size__c= '50',
                    for_MDU_nbr_of_Buildings__c= 10,
                    for_Midrise_Highrise_nbof_average_Floors__c= 10,
                    Capital_Design_Stage__c='Planner Design Complete',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c=10,
                    F1_Cost_ft_for_Custom_without_conduit__c	=0,
                    F2_Cost_ft_for_Custom_without_conduit__c=7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c=11.7,
                    Direct_Buried_12f__c=15,
                    Buried_w_Conduit_12f__c=15,
                    Aerial_12f__c=20,
                    Bore_1_25_c_12f__c=15,
                    Joint_Trench_Custom__c=15,
                    Pull_Fiber_12f__c=20, 
                    Core_Switch_Electronics__c = 0.00,//coreElectronicsCost
                    Transport_Interoffice_Fiber__c = 0.00,//interofficeFiberCost
                    CO_Electronics__c = 9360.00,//coElectronicsCost
                    Feeder_F1_Access_and_or_PON__c = 25414.00,//f1FeederCost
                    Remote_Electronics__c = 0.00,//remoteElectronicsCost
                    Distribution_F2__c = 0.00,//f2Cost
                    F2_Footage_ft__c = 800.00,//f2Footage
                    Distribution_Structure_Conduit__c = 54380.5875,//insideWiringCapEx
                    Electronics_Shelf_UPS_Cost__c = 2312.48,
                    MDU_ONT_Drop__c = 0.00,
                    OP_Res_Gateway_Total_Cost_Comb_Cost__c = 2208.00,
                    OP_F2_Total_Cost_Combined_Cost__c = 88859.37,
                    OP_F2_Conduit_Sub_cost_Combined_Cost__c = 6748.75,
                    OP_F3_Total_Cost_Comb_Cost__c = 31585.80,
                    F4_Inside_Wiring_SFH__c = 0.00,//dropCost
                    Other_MDU_F4__c = 18098.70,//additionalOpExNrc
                    Network_Investment__c = 'NEW DEVELOPMENT',//networkInvestmentType
                    Service_Type__c = 'Retail',//partly into productType
                    Technology_Type__c = 'FTTU',//partly into productType
                    Occupant_Type__c = 'CONSUMER'//occupantType                            
                )
            );
        }
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end createCapitalDesignsWithBRAINDefaults
    public static List<Capital_Design__c> createCapitalDesignsWithBRAINDefaults(Id oppId,Integer count,Boolean doInsert){
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            capitalDesigns.add(
                new Capital_Design__c(
                    Opportunity__c = oppId,
                    Capital_Design_Type__c = 'Standard',
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,                    
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c =0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c =0,
                    Cobble_Bore_1_25_c_96f__c =0,
                    Rock_Bore_1_25_c_96f__c =0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97 ,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c =0,
                    Use_Vacant_12f__c =0,
                    Plow_2_c_48f__c =0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c =0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c=0,
                    Cobble_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_in_4_c_864f__c=0,
                    F1_Joint_Trench_Custom_with_conduit__c=85,
                    F1_Custom_without_conduit__c=0,
                    F1_Footage_ft__c=5300,
                    Building_Style__c ='Cottage Retail',
                    nbr_of_Living_Units__c = 1289,
                    for_SFU_Average_Lot_Size__c= '50',
                    for_MDU_nbr_of_Buildings__c= 10,
                    for_Midrise_Highrise_nbof_average_Floors__c= 10,
                    Capital_Design_Stage__c='Planner Design Complete',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c=10,
                    F1_Cost_ft_for_Custom_without_conduit__c	=0,
                    F2_Cost_ft_for_Custom_without_conduit__c=7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c=11.7,
                    Direct_Buried_12f__c=15,
                    Buried_w_Conduit_12f__c=15,
                    Aerial_12f__c=20,
                    Bore_1_25_c_12f__c=15,
                    Joint_Trench_Custom__c=15,
                    Pull_Fiber_12f__c=20, 
                    Core_Switch_Electronics__c = 0.00,//coreElectronicsCost
                    Transport_Interoffice_Fiber__c = 0.00,//interofficeFiberCost
                    CO_Electronics__c = 9360.00,//coElectronicsCost
                    Feeder_F1_Access_and_or_PON__c = 25414.00,//f1FeederCost
                    Remote_Electronics__c = 0.00,//remoteElectronicsCost
                    Distribution_F2__c = 0.00,//f2Cost
                    F2_Footage_ft__c = 800.00,//f2Footage
                    Distribution_Structure_Conduit__c = 54380.5875,//insideWiringCapEx
                    Electronics_Shelf_UPS_Cost__c = 2312.48,
                    MDU_ONT_Drop__c = 0.00,
                    OP_Res_Gateway_Total_Cost_Comb_Cost__c = 2208.00,
                    OP_F2_Total_Cost_Combined_Cost__c = 88859.37,
                    OP_F2_Conduit_Sub_cost_Combined_Cost__c = 6748.75,
                    OP_F3_Total_Cost_Comb_Cost__c = 31585.80,
                    F4_Inside_Wiring_SFH__c = 0.00,//dropCost
                    Other_MDU_F4__c = 18098.70,//additionalOpExNrc
                    Network_Investment__c = 'NEW DEVELOPMENT',//networkInvestmentType
                    Service_Type__c = 'Retail',//partly into productType
                    Technology_Type__c = 'FTTU',//partly into productType
                    Occupant_Type__c = 'CONSUMER'//occupantType                            
                )
            );
        }
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end createCapitalDesignsWithBRAINDefaults
    /***********************************************************************************************
     Purpose: Create Test CapitalDesign records with BRAIN Defaults
     Parameters:oppId, count, doInsert
     Return: List of CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ted Cabato         12/01/2022  ESCJ-2138    Initial draft
    ************************************************************************************************/
    public static List<Capital_Design__c> createCapitalDesignsWithBACTAndBRAINDefaults(Id bactId, Id oppId, String stateName, Integer count, Boolean doInsert){
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            capitalDesigns.add(
                new Capital_Design__c(
                    BRAIN_API_Call_Tracker_Master__c = bactId,
                    Last_Associated_BRAIN_FA_Call__c = bactId,
                    Opportunity__c = oppId,
                    Capital_Design_Type__c = 'Standard',
                    Primary_Address_State_Name__c = stateName,
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,                    
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c =0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c =0,
                    Cobble_Bore_1_25_c_96f__c =0,
                    Rock_Bore_1_25_c_96f__c =0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97 ,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c =0,
                    Use_Vacant_12f__c =0,
                    Plow_2_c_48f__c =0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c =0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c=0,
                    Cobble_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_in_4_c_864f__c=0,
                    F1_Joint_Trench_Custom_with_conduit__c=85,
                    F1_Custom_without_conduit__c=0,
                    F1_Footage_ft__c=5300,
                    Building_Style__c ='Cottage Retail',
                    nbr_of_Living_Units__c = 1289,
                    for_SFU_Average_Lot_Size__c= '50',
                    for_MDU_nbr_of_Buildings__c= 10,
                    for_Midrise_Highrise_nbof_average_Floors__c= 10,
                    Capital_Design_Stage__c='Planner Design Complete',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c=10,
                    F1_Cost_ft_for_Custom_without_conduit__c	=0,
                    F2_Cost_ft_for_Custom_without_conduit__c=7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c=11.7,
                    Direct_Buried_12f__c=15,
                    Buried_w_Conduit_12f__c=15,
                    Aerial_12f__c=20,
                    Bore_1_25_c_12f__c=15,
                    Joint_Trench_Custom__c=15,
                    Pull_Fiber_12f__c=20, 
                    Core_Switch_Electronics__c = 0.00,//coreElectronicsCost
                    Transport_Interoffice_Fiber__c = 0.00,//interofficeFiberCost
                    CO_Electronics__c = 9360.00,//coElectronicsCost
                    Feeder_F1_Access_and_or_PON__c = 25414.00,//f1FeederCost
                    Remote_Electronics__c = 0.00,//remoteElectronicsCost
                    Distribution_F2__c = 0.00,//f2Cost
                    F2_Footage_ft__c = 800.00,//f2Footage
                    Distribution_Structure_Conduit__c = 54380.5875,//insideWiringCapEx
                    Electronics_Shelf_UPS_Cost__c = 2312.48,
                    MDU_ONT_Drop__c = 0.00,
                    OP_Res_Gateway_Total_Cost_Comb_Cost__c = 2208.00,
                    OP_F2_Total_Cost_Combined_Cost__c = 88859.37,
                    OP_F2_Conduit_Sub_cost_Combined_Cost__c = 6748.75,
                    OP_F3_Total_Cost_Comb_Cost__c = 31585.80,
                    F4_Inside_Wiring_SFH__c = 0.00,//dropCost
                    Other_MDU_F4__c = 18098.70,//additionalOpExNrc
                    Network_Investment__c = 'NEW DEVELOPMENT',//networkInvestmentType
                    Service_Type__c = 'Retail',//partly into productType
                    Technology_Type__c = 'FTTU',//partly into productType
                    Occupant_Type__c = 'CONSUMER'//occupantType                            
                )
            );
        }
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end createCapitalDesignsWithBACTAndBRAINDefaults
    /***********************************************************************************************
     Purpose: Create Test NMA-CapitalDesign records with BRAIN Defaults
     Parameters:oppId, count, doInsert
     Return: List of NMA-CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ted Cabato         02/23/2023  ESCJ-2365    Initial draft
    ************************************************************************************************/
    public static List<Capital_Design__c> createNMACapitalDesignsWithBRAINDefaults(Id bactId,Integer count,Boolean doInsert){
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            capitalDesigns.add(
                new Capital_Design__c(
                    BRAIN_API_Call_Tracker_Master__c = bactId,
                    Capital_Design_Type__c = 'Non-Marketing',
                    Primary_Address_State_Name__c = 'COLORADO',
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,                    
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c =0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c =0,
                    Cobble_Bore_1_25_c_96f__c =0,
                    Rock_Bore_1_25_c_96f__c =0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97 ,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c =0,
                    Use_Vacant_12f__c =0,
                    Plow_2_c_48f__c =0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c =0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c=0,
                    Cobble_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_in_4_c_864f__c=0,
                    F1_Joint_Trench_Custom_with_conduit__c=85,
                    F1_Custom_without_conduit__c=0,
                    F1_Footage_ft__c=5300,
                    Building_Style__c ='Cottage CTL-ON',
                    nbr_of_Living_Units__c = 24,
                    for_SFU_Average_Lot_Size__c= null,
                    for_MDU_nbr_of_Buildings__c= 24,
                    Capital_Design_Stage__c='Engineer Complete',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c=10,
                    F1_Cost_ft_for_Custom_without_conduit__c	=0,
                    F2_Cost_ft_for_Custom_without_conduit__c=7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c=11.7,
                    Direct_Buried_12f__c=15,
                    Buried_w_Conduit_12f__c=15,
                    Aerial_12f__c=20,
                    Bore_1_25_c_12f__c=15,
                    Joint_Trench_Custom__c=15,
                    Pull_Fiber_12f__c=20, 
                    Core_Switch_Electronics__c = 0.00,//coreElectronicsCost
                    Transport_Interoffice_Fiber__c = 0.00,//interofficeFiberCost
                    CO_Electronics__c = 9360.00,//coElectronicsCost
                    Feeder_F1_Access_and_or_PON__c = 25414.00,//f1FeederCost
                    Remote_Electronics__c = 0.00,//remoteElectronicsCost
                    Distribution_F2__c = 0.00,//f2Cost
                    F2_Footage_ft__c = 800.00,//f2Footage
                    Distribution_Structure_Conduit__c = 54380.5875,//insideWiringCapEx
                    Electronics_Shelf_UPS_Cost__c = 2312.48,
                    MDU_ONT_Drop__c = 0.00,
                    OP_Res_Gateway_Total_Cost_Comb_Cost__c = 2208.00,
                    OP_F2_Total_Cost_Combined_Cost__c = 88859.37,
                    OP_F2_Conduit_Sub_cost_Combined_Cost__c = 6748.75,
                    OP_F3_Total_Cost_Comb_Cost__c = 31585.80,
                    F4_Inside_Wiring_SFH__c = 0.00,//dropCost
                    Other_MDU_F4__c = 18098.70,//additionalOpExNrc
                    Network_Investment__c = 'NEW DEVELOPMENT',//networkInvestmentType
                    Service_Type__c = 'CTL_ON',//partly into productType
                    Technology_Type__c = 'FTTU',//partly into productType
                    Occupant_Type__c = 'CONSUMER',//occupantType   
                    F3_Fiber_Type__c = 'Buried',
                    F4_Fiber_Type__c = 'CTL provide Ruggedized',
                    Population_Density__c = 'Suburban',
                    Development_Status_NM__c = 'Greenfield',
                    First_Occupancy_Date_NM__c = (Date.today()).addMonths(20),
                    Latitude_NM__c = 30.23548000,
                    Longitude_NM__c = -87.77961100,
                    Max_Downstream_Speed_NM__c = 1000000,
                    Planner_Reassignment_Email__c = 'john.chase@lumen.com',
                    Service_Delivery_NM__c = 'Instant Internet',
                    Total_Cottage_Owner_Units_NM__c = 0,
                    Total_Cottage_Rental_Units_NM__c = 24,
                    Total_SFH_Owner_Units_NM__c = 0,
                    Total_SFH_Rental_Units_NM__c = 0,
                    Total_Tower_Owner_Units_NM__c = 0,
                    Total_Tower_Rental_Units_NM__c = 0                    
                )
            );
        }
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end createNMACapitalDesignsWithBRAINDefaults
    /***********************************************************************************************
     Purpose: Create Test NMA-CapitalDesign records with BRAIN Defaults
     Parameters:oppId, count, doInsert
     Return: List of NMA-CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ted Cabato         02/23/2023  ESCJ-2365    Initial draft
    ************************************************************************************************/
    public static List<Capital_Design__c> createNMACapitalDesignsWithBACTAndBRAINDefaults(Id bactId, String stateName, Integer count, Boolean doInsert){
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            capitalDesigns.add(
                new Capital_Design__c(                    
                    Capital_Design_Type__c = 'Non-Marketing',
                    BRAIN_API_Call_Tracker_Master__c = bactId,
                    Last_Associated_BRAIN_FA_Call__c = bactId,
                    Primary_Address_State_Name__c = stateName,
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,                    
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c =0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c =0,
                    Cobble_Bore_1_25_c_96f__c =0,
                    Rock_Bore_1_25_c_96f__c =0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97 ,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c =0,
                    Use_Vacant_12f__c =0,
                    Plow_2_c_48f__c =0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c =0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c=0,
                    Cobble_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_in_4_c_864f__c=0,
                    F1_Joint_Trench_Custom_with_conduit__c=85,
                    F1_Custom_without_conduit__c=0,
                    F1_Footage_ft__c=5300,
                    Building_Style__c ='Cottage CTL-ON',
                    nbr_of_Living_Units__c = 24,
                    for_SFU_Average_Lot_Size__c= '50',
                    for_MDU_nbr_of_Buildings__c= 24,
                    Capital_Design_Stage__c='Engineer Complete',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c=10,
                    F1_Cost_ft_for_Custom_without_conduit__c	=0,
                    F2_Cost_ft_for_Custom_without_conduit__c=7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c=11.7,
                    Direct_Buried_12f__c=15,
                    Buried_w_Conduit_12f__c=15,
                    Aerial_12f__c=20,
                    Bore_1_25_c_12f__c=15,
                    Joint_Trench_Custom__c=15,
                    Pull_Fiber_12f__c=20, 
                    Core_Switch_Electronics__c = 0.00,//coreElectronicsCost
                    Transport_Interoffice_Fiber__c = 0.00,//interofficeFiberCost
                    CO_Electronics__c = 9360.00,//coElectronicsCost
                    Feeder_F1_Access_and_or_PON__c = 25414.00,//f1FeederCost
                    Remote_Electronics__c = 0.00,//remoteElectronicsCost
                    Distribution_F2__c = 0.00,//f2Cost
                    F2_Footage_ft__c = 800.00,//f2Footage
                    Distribution_Structure_Conduit__c = 54380.5875,//insideWiringCapEx
                    Electronics_Shelf_UPS_Cost__c = 2312.48,
                    MDU_ONT_Drop__c = 0.00,
                    OP_Res_Gateway_Total_Cost_Comb_Cost__c = 2208.00,
                    OP_F2_Total_Cost_Combined_Cost__c = 88859.37,
                    OP_F2_Conduit_Sub_cost_Combined_Cost__c = 6748.75,
                    OP_F3_Total_Cost_Comb_Cost__c = 31585.80,
                    F4_Inside_Wiring_SFH__c = 0.00,//dropCost
                    Other_MDU_F4__c = 18098.70,//additionalOpExNrc
                    Network_Investment__c = 'NEW DEVELOPMENT',//networkInvestmentType
                    Service_Type__c = 'CTL_ON',//partly into productType
                    Technology_Type__c = 'FTTU',//partly into productType
                    Occupant_Type__c = 'CONSUMER',//occupantType   
                    F3_Fiber_Type__c = 'Buried',
                    F4_Fiber_Type__c = 'CTL provide Ruggedized',
                    Population_Density__c = 'Suburban',
                    Development_Status_NM__c = 'Greenfield',
                    First_Occupancy_Date_NM__c = (Date.today()).addMonths(20),
                    Latitude_NM__c = 30.23548000,
                    Longitude_NM__c = -87.77961100,
                    Max_Downstream_Speed_NM__c = 1000000,
                    Planner_Reassignment_Email__c = 'john.chase@lumen.com',
                    Service_Delivery_NM__c = 'Instant Internet',
                    Total_Cottage_Owner_Units_NM__c = 0,
                    Total_Cottage_Rental_Units_NM__c = 24,
                    Total_SFH_Owner_Units_NM__c = 0,
                    Total_SFH_Rental_Units_NM__c = 0,
                    Total_Tower_Owner_Units_NM__c = 0,
                    Total_Tower_Rental_Units_NM__c = 0                    
                )
            );
        }
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end createNMACapitalDesignsWithBRAINDefaults
    /***********************************************************************************************
     Purpose: Create Test Instant_WiFi-CapitalDesign records with BRAIN Defaults
     Parameters:oppId, count, doInsert
     Return: List of Instant_WiFi-CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ted Cabato         02/23/2023  ESCJ-2365    Initial draft
    ************************************************************************************************/
    public static List<Capital_Design__c> createIWFCapitalDesignsWithBRAINDefaults(Id oppId,Id bactId,Integer count,Boolean doInsert){
        Integer designatedLUs = 250;
        String designatedSFUAvgLotSize = null;//'50',
        Integer designatedMDUNbrBuildings = null;//10,
        Integer designatedMHriseAvgFloors = null;//10,
        Decimal designatedRetailTakeRate = null;//
        String scenarioDevelopmentStatus = null;
        String scenarioBuildingStyle = null;
        String scenarioServiceType = null;
        String scenarioTechType = null;
        String designatedNetworkInvestmentType = null;
        String designatedProductType = null;
        String designatedDropCostSource = null;        
        Decimal designatedDropCost = 0.00;
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            scenarioDevelopmentStatus = 'Greenfield';
            scenarioServiceType = 'CTL_ON';
            scenarioTechType = 'Instant Wi-Fi';
            scenarioBuildingStyle = 'Cottage CTL-ON';
            designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
            designatedProductType = 'Instant WiFi';
            designatedDropCostSource = 'PROVIDED';
            designatedDropCost = 0.00;
            designatedSFUAvgLotSize = null;
            designatedMDUNbrBuildings = designatedLUs;
            designatedMHriseAvgFloors = null;
            designatedRetailTakeRate = null;
            capitalDesigns.add(
                new Capital_Design__c(
                    Capital_Design_Type__c = 'Standard',
                    Opportunity__c = oppId,
                    BRAIN_API_Call_Tracker_Master__c = bactId,
                    Last_Associated_BRAIN_FA_Call__c = bactId,
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,                    
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c = 0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c = 0,
                    Cobble_Bore_1_25_c_96f__c = 0,
                    Rock_Bore_1_25_c_96f__c = 0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c = 0,
                    Use_Vacant_12f__c = 0,
                    Plow_2_c_48f__c = 0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c = 0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c = 0,
                    Cobble_Bore_1_25_c_864f__c = 0,
                    Rock_Bore_1_25_c_864f__c = 0,
                    Rock_Bore_1_25_c_in_4_c_864f__c = 0,
                    F1_Joint_Trench_Custom_with_conduit__c = 85,
                    F1_Custom_without_conduit__c = 0,
                    F1_Footage_ft__c = 5300,
                    Building_Style__c = scenarioBuildingStyle,
                    nbr_of_Living_Units__c = designatedLUs,
                    for_SFU_Average_Lot_Size__c= designatedSFUAvgLotSize,
                    for_MDU_nbr_of_Buildings__c= designatedMDUNbrBuildings,
                    for_Midrise_Highrise_nbof_average_Floors__c= designatedMHriseAvgFloors,
                    for_Retail_Take_rate__c = designatedRetailTakeRate,
                    Capital_Design_Stage__c = 'Additional Engineer Input Needed',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c = 10,
                    F1_Cost_ft_for_Custom_without_conduit__c = 0,
                    F2_Cost_ft_for_Custom_without_conduit__c = 7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c = 11.7,
                    Direct_Buried_12f__c = 15,
                    Buried_w_Conduit_12f__c = 15,
                    Aerial_12f__c = 20,
                    Bore_1_25_c_12f__c = 15,
                    Joint_Trench_Custom__c = 15,
                    Pull_Fiber_12f__c = 20, 
                    Core_Switch_Electronics__c = 0.00,//coreElectronicsCost
                    Transport_Interoffice_Fiber__c = 0.00,//interofficeFiberCost
                    CO_Electronics__c = 9360.00,//coElectronicsCost
                    Feeder_F1_Access_and_or_PON__c = 25414.00,//f1FeederCost
                    Remote_Electronics__c = 0.00,//remoteElectronicsCost
                    Distribution_F2__c = 0.00,//f2Cost
                    F2_Footage_ft__c = 1800.00,//f2Footage
                    Distribution_Structure_Conduit__c = 54380.5875,//insideWiringCapEx
                    Electronics_Shelf_UPS_Cost__c = 2312.48,
                    MDU_ONT_Drop__c = designatedDropCost,
                    OP_Res_Gateway_Total_Cost_Comb_Cost__c = 2208.00,
                    OP_F2_Total_Cost_Combined_Cost__c = 88859.37,
                    OP_F2_Conduit_Sub_cost_Combined_Cost__c = 6748.75,
                    OP_F3_Total_Cost_Comb_Cost__c = 31585.80,
                    F4_Inside_Wiring_SFH__c = 0.00,//dropCost
                    Other_MDU_F4__c = 18098.70,//additionalOpExNrc
                    Network_Investment__c = designatedNetworkInvestmentType,//networkInvestmentType
                    Service_Type__c = scenarioServiceType,//partly into productType
                    Technology_Type__c = scenarioTechType,//partly into productType
                    Occupant_Type__c = 'CONSUMER',//occupantType   
                    F3_Fiber_Type__c = 'Buried',
                    ONT_Model__c = 'Calix-803G-indoor-FTTU',
                    F4_Fiber_Type__c = 'CTL provide Ruggedized',
                    CTL_to_install_F4__c = false,
                    Population_Density__c = 'Suburban',
                    Access_Cost__c = 12500.00,
                    IP_CapEx_Shared__c = 65432.10,
                    IP_NetEx_Shared_MRC__c = 4567.89,
                    Wireless_Access_Points_Cost__c = 7500.00,
                    BCET_Wire_Center__c = 'DNVRCOSO',
                    One_Time_Additional_Expense__c = 18250.00,
                    Recurring_Additional_Expenses_Monthly__c = 1975.00
                )
            );
        }
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end createIWFCapitalDesignsWithBRAINDefaults
    /***********************************************************************************************
     Purpose: Create Test Instant_WiFi-CapitalDesign records with BRAIN Defaults
     Parameters:oppId, count, doInsert
     Return: List of Instant_WiFi-CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ted Cabato         02/23/2023  ESCJ-2365    Initial draft
    ************************************************************************************************/
    public static List<Capital_Design__c> createIWFCapitalDesignsWithBRAINDefaultsAndNullBCETWC(Id oppId,String stateName,Integer count,Boolean doInsert){
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            capitalDesigns.add(
                new Capital_Design__c(
                    Capital_Design_Type__c = 'Standard',
                    Opportunity__c = oppId,
                    Primary_Address_State_Name__c = stateName,
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,                    
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c = 0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c = 0,
                    Cobble_Bore_1_25_c_96f__c = 0,
                    Rock_Bore_1_25_c_96f__c = 0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c = 0,
                    Use_Vacant_12f__c = 0,
                    Plow_2_c_48f__c = 0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c = 0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c = 0,
                    Cobble_Bore_1_25_c_864f__c = 0,
                    Rock_Bore_1_25_c_864f__c = 0,
                    Rock_Bore_1_25_c_in_4_c_864f__c = 0,
                    F1_Joint_Trench_Custom_with_conduit__c = 85,
                    F1_Custom_without_conduit__c = 0,
                    F1_Footage_ft__c = 5300,
                    Building_Style__c = 'Cottage CTL-ON',
                    nbr_of_Living_Units__c = 24,
                    for_MDU_nbr_of_Buildings__c = 24,
                    Capital_Design_Stage__c = 'Additional Engineer Input Needed',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c = 10,
                    F1_Cost_ft_for_Custom_without_conduit__c = 0,
                    F2_Cost_ft_for_Custom_without_conduit__c = 7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c = 11.7,
                    Direct_Buried_12f__c = 15,
                    Buried_w_Conduit_12f__c = 15,
                    Aerial_12f__c = 20,
                    Bore_1_25_c_12f__c = 15,
                    Joint_Trench_Custom__c = 15,
                    Pull_Fiber_12f__c = 20, 
                    Core_Switch_Electronics__c = 0.00,//coreElectronicsCost
                    Transport_Interoffice_Fiber__c = 0.00,//interofficeFiberCost
                    CO_Electronics__c = 9360.00,//coElectronicsCost
                    Feeder_F1_Access_and_or_PON__c = 25414.00,//f1FeederCost
                    Remote_Electronics__c = 0.00,//remoteElectronicsCost
                    Distribution_F2__c = 0.00,//f2Cost
                    F2_Footage_ft__c = 1800.00,//f2Footage
                    Distribution_Structure_Conduit__c = 54380.5875,//insideWiringCapEx
                    Electronics_Shelf_UPS_Cost__c = 2312.48,
                    MDU_ONT_Drop__c = 0.00,
                    OP_Res_Gateway_Total_Cost_Comb_Cost__c = 2208.00,
                    OP_F2_Total_Cost_Combined_Cost__c = 88859.37,
                    OP_F2_Conduit_Sub_cost_Combined_Cost__c = 6748.75,
                    OP_F3_Total_Cost_Comb_Cost__c = 31585.80,
                    F4_Inside_Wiring_SFH__c = 0.00,//dropCost
                    Other_MDU_F4__c = 18098.70,//additionalOpExNrc
                    Network_Investment__c = 'NEW DEVELOPMENT',//networkInvestmentType
                    Service_Type__c = 'CTL_ON',//partly into productType
                    Technology_Type__c = 'Instant Wi-Fi',//partly into productType
                    Occupant_Type__c = 'CONSUMER',//occupantType   
                    F3_Fiber_Type__c = 'Buried',
                    ONT_Model__c = 'Calix-803G-indoor-FTTU',
                    F4_Fiber_Type__c = 'CTL provide Ruggedized',
                    CTL_to_install_F4__c = false,
                    Population_Density__c = 'Suburban',
                    Access_Cost__c = 12500.00,
                    IP_CapEx_Shared__c = 65432.10,
                    IP_NetEx_Shared_MRC__c = 4567.89,
                    Wireless_Access_Points_Cost__c = 7500.00,
                    BCET_Wire_Center__c = null,
                    One_Time_Additional_Expense__c = 18250.00,
                    Recurring_Additional_Expenses_Monthly__c = 1975.00
                )
            );
        }
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end createIWFCapitalDesignsWithBRAINDefaultsAndNullBCETWC
    /***********************************************************************************************
     Purpose: Create Test Instant_WiFi-CapitalDesign records with BRAIN Defaults
     Parameters:oppId, count, doInsert
     Return: List of Instant_WiFi-CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ted Cabato         02/23/2023  ESCJ-2365    Initial draft
    ************************************************************************************************/
    public static List<Capital_Design__c> createIWFCapitalDesignsWithBACTAndBRAINDefaults(Id bactId, Id oppId, String stateName, Integer count, Boolean doInsert){
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            capitalDesigns.add(
                new Capital_Design__c(                    
                    Capital_Design_Type__c = 'Standard',
                    BRAIN_API_Call_Tracker_Master__c = bactId,
                    Last_Associated_BRAIN_FA_Call__c = bactId,
                    Opportunity__c = oppId,
                    Primary_Address_State_Name__c = stateName,
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,                    
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c = 0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c = 0,
                    Cobble_Bore_1_25_c_96f__c = 0,
                    Rock_Bore_1_25_c_96f__c = 0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c = 0,
                    Use_Vacant_12f__c = 0,
                    Plow_2_c_48f__c = 0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c = 0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c = 0,
                    Cobble_Bore_1_25_c_864f__c = 0,
                    Rock_Bore_1_25_c_864f__c = 0,
                    Rock_Bore_1_25_c_in_4_c_864f__c = 0,
                    F1_Joint_Trench_Custom_with_conduit__c = 85,
                    F1_Custom_without_conduit__c = 0,
                    F1_Footage_ft__c = 5300,
                    Building_Style__c = 'Cottage CTL-ON',
                    nbr_of_Living_Units__c = 24,
                    for_MDU_nbr_of_Buildings__c = 24,
                    Capital_Design_Stage__c = 'Additional Engineer Input Needed',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c = 10,
                    F1_Cost_ft_for_Custom_without_conduit__c = 0,
                    F2_Cost_ft_for_Custom_without_conduit__c = 7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c = 11.7,
                    Direct_Buried_12f__c = 15,
                    Buried_w_Conduit_12f__c = 15,
                    Aerial_12f__c = 20,
                    Bore_1_25_c_12f__c = 15,
                    Joint_Trench_Custom__c = 15,
                    Pull_Fiber_12f__c = 20, 
                    Core_Switch_Electronics__c = 0.00,//coreElectronicsCost
                    Transport_Interoffice_Fiber__c = 0.00,//interofficeFiberCost
                    CO_Electronics__c = 9360.00,//coElectronicsCost
                    Feeder_F1_Access_and_or_PON__c = 25414.00,//f1FeederCost
                    Remote_Electronics__c = 0.00,//remoteElectronicsCost
                    Distribution_F2__c = 0.00,//f2Cost
                    F2_Footage_ft__c = 1800.00,//f2Footage
                    Distribution_Structure_Conduit__c = 54380.5875,//insideWiringCapEx
                    Electronics_Shelf_UPS_Cost__c = 2312.48,
                    MDU_ONT_Drop__c = 0.00,
                    OP_Res_Gateway_Total_Cost_Comb_Cost__c = 2208.00,
                    OP_F2_Total_Cost_Combined_Cost__c = 88859.37,
                    OP_F2_Conduit_Sub_cost_Combined_Cost__c = 6748.75,
                    OP_F3_Total_Cost_Comb_Cost__c = 31585.80,
                    F4_Inside_Wiring_SFH__c = 0.00,//dropCost
                    Other_MDU_F4__c = 18098.70,//additionalOpExNrc
                    Network_Investment__c = 'NEW DEVELOPMENT',//networkInvestmentType
                    Service_Type__c = 'CTL_ON',//partly into productType
                    Technology_Type__c = 'Instant Wi-Fi',//partly into productType
                    Occupant_Type__c = 'CONSUMER',//occupantType   
                    F3_Fiber_Type__c = 'Buried',
                    ONT_Model__c = 'Calix-803G-indoor-FTTU',
                    F4_Fiber_Type__c = 'CTL provide Ruggedized',
                    CTL_to_install_F4__c = false,
                    Population_Density__c = 'Suburban',
                    Access_Cost__c = 12500.00,
                    IP_CapEx_Shared__c = 65432.10,
                    IP_NetEx_Shared_MRC__c = 4567.89,
                    Wireless_Access_Points_Cost__c = 7500.00,
                    BCET_Wire_Center__c = 'DNVRCOSO',
                    One_Time_Additional_Expense__c = 18250.00,
                    Recurring_Additional_Expenses_Monthly__c = 1975.00
                )
            );
        }
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end createIWFCapitalDesignsWithBRAINDefaults
    /***********************************************************************************************
    Purpose: Create Test BRAIN_FA_Request__c records for NMA
    Parameters: count, doInsert
    Return: List of BRAIN_FA_Request__c records
    ================================================================================================
    History:
    AUTHOR             DATE        Reference   Description
    Ted Cabato         02/23/2023  ESCJ-2365   Initial draft
    ************************************************************************************************/
    public static List<BRAIN_FA_Request__c> createBrainFARequestForNMA(List<Capital_Design__c> cdList, Integer count, Boolean doInsert){
        List<BRAIN_FA_Request__c> reqList = new List<BRAIN_FA_Request__c>();
        for (Integer i = 0; i < count; i++) {
            if (cdList != null && cdList.size() > 0) {
                reqList.add(
                    new BRAIN_FA_Request__c(
                        sourceSystem__c = 'SFCJ',
                        financialMetricCurrencyCode__c = 'USD',
                        financialMetricCurrencyExchangeDate__c = null,						
                        sourceSystemId__c = cdList.get(0).Id,
                        sourceSystemIdType__c = 'CAPITAL-DESIGN',
                        analysisOverride__c = null,
                        cuid__c ='AA14082'
                    )
                );
            } else {
                reqList.add(
                    new BRAIN_FA_Request__c(
                        sourceSystem__c = 'SFCJ',
                        financialMetricCurrencyCode__c = 'USD',
                        financialMetricCurrencyExchangeDate__c = null,						
                        sourceSystemId__c = null,
                        sourceSystemIdType__c = 'CAPITAL-DESIGN',
                        analysisOverride__c = null,
                        cuid__c ='AA14082'
                    )
                );
            }
        }//end for-loop
		if (doInsert) {
			insert reqList;
        }
        return reqList;        
    }//end method createBrainFARequestForNMA
    /***********************************************************************************************
    Purpose: Create Test BRAIN_FA_Request__c records
    Parameters: count, doInsert
    Return: List of BRAIN_FA_Request__c records
    ================================================================================================
    History:
    AUTHOR             DATE        Reference   Description
    Pooja Kumari    11/17/2022      ESCJ-2107    Initial draft
    ************************************************************************************************/
    public static List<BRAIN_FA_Request__c> createBrainFARequest(List<Capital_Design__c> cdList, List<Offer__c> offerList, Integer count,
        Boolean doInsert){
        List<BRAIN_FA_Request__c> reqList = new List<BRAIN_FA_Request__c>();
        for (Integer i = 0; i < count; i++) {
			if (offerList != null && offerList.size() > 0) {
				reqList.add(
					new BRAIN_FA_Request__c(
						sourceSystem__c = 'SFCJ',
						financialMetricCurrencyCode__c = 'USD',
						financialMetricCurrencyExchangeDate__c = null,						
						sourceSystemId__c = (offerList == null ? null : offerList.size() == 0 ? null : offerList.get(i) == null ? null : (offerList.get(i).Id == null) ? null : offerList.get(i).Id),
						sourceSystemIdType__c = 'OFFER',
						analysisOverride__c = null,
						cuid__c ='AA14082'
					)
				);
			} else {
				if (cdList != null && cdList.size() > 0) {
					reqList.add(
						new BRAIN_FA_Request__c(
							sourceSystem__c = 'SFCJ',
							financialMetricCurrencyCode__c = 'USD',
							financialMetricCurrencyExchangeDate__c = null,						
							sourceSystemId__c = (cdList == null ? null : cdList.size() == 0 ? null : cdList.get(i) == null ? null : (cdList.get(i).Id == null) ? null : cdList.get(i).Id),
							sourceSystemIdType__c = 'CAPITAL-DESIGN',
							analysisOverride__c = null,
							cuid__c ='AA14082'
						)
					);
				} else {
					reqList.add(
						new BRAIN_FA_Request__c(
							sourceSystem__c = 'SFCJ',
							financialMetricCurrencyCode__c = 'USD',
							financialMetricCurrencyExchangeDate__c = null,						
							sourceSystemId__c = null,
							sourceSystemIdType__c = null,
							analysisOverride__c = null,
							cuid__c ='AA14082'
						)
					);
				}
			}
        }//end for-loop
		if (doInsert) {
			insert reqList;
        }
        return reqList;        
    }
    /***********************************************************************************************
    Purpose: Create Test BRAIN_FA_Response__c records
    Parameters: count, doInsert
    Return: List of BRAIN_FA_Response__c records
    ================================================================================================
    History:
    AUTHOR             DATE        Reference   Description
    Ted Cabato    12/01/2022      ESCJ-2138    Initial draft
    ************************************************************************************************/
    public static List<BRAIN_FA_Response__c> createBrainFAResponse(List<BRAIN_API_Call_Tracker__c> bactList, Integer count, Boolean doInsert){
        List<BRAIN_FA_Response__c> respList = new List<BRAIN_FA_Response__c>();
        for (Integer i = 0; i < count; i++) {
            respList.add(
                new BRAIN_FA_Response__c(
                    BRAIN_API_Call_Tracker_Master__c = (bactList == null ? null : bactList.size() == 0 ? null : bactList.get(i)==null ? null : bactList.get(i).Id==null ? null : bactList.get(i).Id),
                    errorCode__c = null,
                    errorMessage__c = null,
                    status__c = null,
                    BRAIN_ID__c = null
                )
            );
        }//end for-loop
		if (doInsert) {
			insert respList;
        }
        return respList;        
    }
    /***********************************************************************************************
    Purpose: Create Test BRAIN_API_Call_Tracker__c records
    Parameters: count, doInsert
    Return: List of BRAIN_API_Call_Tracker__c records
    ================================================================================================
    History:
    AUTHOR             DATE        Reference   Description
    TCabato            03/27/2023  QFCJ-2365   Initial draft
    ************************************************************************************************/
    public static List<BRAIN_API_Call_Tracker__c> createBaseBrainAPICallTracker(Integer count,
        Boolean doInsert){
            List<BRAIN_API_Call_Tracker__c> brainAPICallTrackerList = new List<BRAIN_API_Call_Tracker__c>();
        for (Integer i = 0; i < count; i++) {
            brainAPICallTrackerList.add(
                new BRAIN_API_Call_Tracker__c(
                )
            );
        }
            if (doInsert) {
            insert brainAPICallTrackerList;
        }
        return brainAPICallTrackerList;
        
    }//end method createBaseBrainAPICallTracker
    /***********************************************************************************************
    Purpose: Create Test BRAIN_API_Call_Tracker__c records
    Parameters: count, doInsert
    Return: List of BRAIN_API_Call_Tracker__c records
    ================================================================================================
    History:
    AUTHOR             DATE        Reference   Description
    Pooja Kumari    11/17/2022      ESCJ-2107    Initial draft
    ************************************************************************************************/
    public static List<BRAIN_API_Call_Tracker__c> createBrainAPICallTracker(List<Capital_Design__c> cdList, List<Offer__c> offerList, Integer count,
        Boolean doInsert){
            List<BRAIN_API_Call_Tracker__c> brainAPICallTrackerList = new List<BRAIN_API_Call_Tracker__c>();
        for (Integer i = 0; i < count; i++) {
            brainAPICallTrackerList.add(
                new BRAIN_API_Call_Tracker__c(
                    Capital_Design__c = (cdList == null ? null : cdList.size() == 0 ? null : cdList.get(i) == null ? null : (cdList.get(i).Id == null) ? null : cdList.get(i).Id),
					Offer__c = (offerList == null ? null : offerList.size() == 0 ? null : offerList.get(i) == null ? null : (offerList.get(i).Id == null) ? null : offerList.get(i).Id)
                )
            );
        }
        if (doInsert) {
            insert brainAPICallTrackerList;
        }
        return brainAPICallTrackerList;
        
    }
    /***********************************************************************************************

    Purpose: Create Test BRAIN_API_Call_Tracker__c records for NMA
    Parameters: count, doInsert
    Return: List of BRAIN_API_Call_Tracker__c records
    ================================================================================================
    History:
    AUTHOR             DATE        Reference   Description
    Ted Cabato         02/23/2023  ESCJ-2365   Initial draft
    ************************************************************************************************/
    public static List<BRAIN_API_Call_Tracker__c> createBrainAPICallTrackerForNMA(List<Capital_Design__c> cdList, Integer count,
        Boolean doInsert){
            List<BRAIN_API_Call_Tracker__c> brainAPICallTrackerList = new List<BRAIN_API_Call_Tracker__c>();
        for (Integer i = 0; i < count; i++) {
            brainAPICallTrackerList.add(
                new BRAIN_API_Call_Tracker__c(
                    Capital_Design__c = (cdList == null ? null : cdList.size() == 0 ? null : (cdList.get(0).Id == null) ? null : cdList.get(0).Id)
                )
            );
        }
            if (doInsert) {
            insert brainAPICallTrackerList;
        }
        return brainAPICallTrackerList;
        
    }//end method createBrainAPICallTrackerForNMA
    
    /***********************************************************************************************
     Purpose: Create Test CapitalDesign records with NRMA Defaults
     Parameters:oppId, offerId count, doInsert
     Return: List of CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ted Cabato         01/20/2023  ESCJ-1932     Initial draft
     Ted Cabato         08/02/2023  ESCJ-4268     Drop Cost Variations
     Ted Cabato    		08/15/2023  QFCJ-4309     BRAIN-ContractType-and-OtherProviderContractType-Mapping
    ================================================================================================
    *******  Explanation of Drop Cost for QFCJ-4268 "Update Drop Cost Values being set incorrectly" *******
	*
    * When Development_Status__c is Greenfield 
    * 	   AND Building_Style__c is SFU RETAIL, 
    *      AND TechType of FTTU, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
    *       AND Set BRAIN productType to FTTH
    *       AND Set dropCostSource to STANDARD
    *       AND Set dropCost to null (as BRAIN ignores dropCost when dropCostSource is STANDARD)
    *  
    * When Development_Status__c is Brownfield
    *  	   AND Building_Style__c is SFU RETAIL, 
    *      AND TechType of FTTU, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to PRODUCT
    *       AND Set BRAIN productType to FTTH
    *       AND Set dropCostSource to STANDARD
    *       AND Set dropCost to null (as BRAIN ignores dropCost when dropCostSource is STANDARD)
    *  
    * When Development_Status__c is Greenfield 
    *      AND Building_Style__c is SFU CTL-ON or SFU BULK, 
    *      AND TechType of FTTU, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
    *       AND Set BRAIN productType to CTLON
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to OP_F3_Total_Cost_Comb_Cost
    *  
    * When Development_Status__c is Brownfield
    *  	   AND Building_Style__c is SFU CTL-ON or BULK, 
    *      AND TechType of FTTU, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to PRODUCT
    *       AND Set BRAIN productType to CTLON
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to OP_F3_Total_Cost_Comb_Cost
    *  
    * When Development_Status__c is Greenfield
    *  	   AND Building_Style__c is Cottage CTL-ON, Midrise CTL-ON or Highrise CTL-ON 
    *      AND TechType of Instant WiFi,
    *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
    *       AND Set BRAIN productType to Instant WiFi
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to 0.00
    *  
    * When Development_Status__c is Greenfield 
    *  	   AND Building_Style__c is Midrise CTL-ON or Highrise CTL-ON, Midrise Bulk or Highrise Bulk
    *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
    *       AND Set BRAIN productType to CTLON
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to 0.00
    *  
    * When Development_Status__c is Brownfield
    *  	   AND Building_Style__c is Midrise CTL-ON or Highrise CTL-ON, Midrise Bulk or Highrise Bulk
    *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to PRODUCT
    *       AND Set BRAIN productType to CTLON
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to 0.00
    *  
    * When Development_Status__c is Greenfield 
    *  	   AND Building_Style__c is Midrise Retail or Highrise Retail
    *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
    *       AND Set BRAIN productType to FTTH
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to 0.00
    *  
    * When Development_Status__c is Brownfield
    *  	   AND Building_Style__c is Midrise Retail or Highrise Retail
    *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to PRODUCT
    *       AND Set BRAIN productType to FTTH
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to 0.00
    *  
    * When Development_Status__c is Greenfield
    *  	   AND Building_Style__c is Cottage CTL-ON or Cottage Bulk, 
    *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
    *       AND Set BRAIN productType to CTLON
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to (OP_F2_Total_Cost_Combined_Cost__c - OP_F2_Conduit_Sub_cost_Combined_Cost__c) + OP_F3_Total_Cost_Comb_Cost__c
    *  
    * When Development_Status__c is Brownfield
    *  	   AND Building_Style__c is Cottage CTL-ON or Cottage Bulk, 
    *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to PRODUCT
    *       AND Set BRAIN productType to CTLON
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to (OP_F2_Total_Cost_Combined_Cost__c - OP_F2_Conduit_Sub_cost_Combined_Cost__c) + OP_F3_Total_Cost_Comb_Cost__c
    * 
    * When Development_Status__c is Greenfield
    *  	   AND Building_Style__c is Cottage Retail, 
    *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to NEW DEVELOPMENT
    *       AND Set BRAIN productType to FTTH
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to (OP_F2_Total_Cost_Combined_Cost__c - OP_F2_Conduit_Sub_cost_Combined_Cost__c) + OP_F3_Total_Cost_Comb_Cost__c
    * 
    * When Development_Status__c is Brownfield
    *  	   AND Building_Style__c is Cottage Retail, 
    *      AND TechType of FTTU, FTTIDF-Cat5, FTTB, XGSPON Compliant, XGSPON Enabled,
    *      THEN Set BRAIN networkInvestmentType to PRODUCT
    *       AND Set BRAIN productType to FTTH
    *       AND Set dropCostSource to PROVIDED
    *       AND Set dropCost to (OP_F2_Total_Cost_Combined_Cost__c - OP_F2_Conduit_Sub_cost_Combined_Cost__c) + OP_F3_Total_Cost_Comb_Cost__c
    * 
    ************************************************************************************************/    
    public static List<Capital_Design__c> createCapitalDesignsWithNRMADefaults(List<Opportunity> opptyList,List<Offer__c> offerList, List<BRAIN_API_Call_Tracker__c> bactList, Integer count, Boolean doInsert){
        List<Capital_Design__c> capitalDesigns = new List<Capital_Design__c>();
        Integer designatedLUs = 250;
        String designatedSFUAvgLotSize = null;//'50',
        Integer designatedMDUNbrBuildings = null;//10,
        Integer designatedMHriseAvgFloors = null;//10,
        Decimal designatedRetailTakeRate = null;//
        String scenarioDevelopmentStatus = null;
        String scenarioBuildingStyle = null;
        String scenarioServiceType = null;
        String scenarioTechType = null;
        String designatedNetworkInvestmentType = null;
        String designatedProductType = null;
        String designatedOntModel = null;
        String designatedDropCostSource = null;        
        Decimal designatedDropCost = 0.00;
        
        System.debug('(TestDataFactory.createCapitalDesignsWithNRMADefaults) opptyList?.size() = ' + opptyList?.size() + '  AND offerList?.size() = ' + offerList?.size() +
                    		 '  AND bactList?.size() = ' + bactList?.size());
        for (Integer i = 0; i < count; i++) {
			if (i == 0) { 
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'Retail';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'SFU Retail';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Calix-711GE-outdoor-FTTB';
                designatedDropCostSource = 'STANDARD';
                designatedDropCost = null;
		        designatedSFUAvgLotSize = '50';
        		designatedMDUNbrBuildings = null;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = 5.08;
            } else if (i == 1) { 
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'Retail';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'SFU Retail';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Adtran-TA352-outdoor-FTTB';
                designatedDropCostSource = 'STANDARD';
                designatedDropCost = null;
		        designatedSFUAvgLotSize = '50';
        		designatedMDUNbrBuildings = null;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = 5.08;
            } else if (i == 2) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'CTL_ON';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'SFU CTL-ON';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Adtran-C424G-indoor-integrated-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 31585.80;
		        designatedSFUAvgLotSize = '50';
        		designatedMDUNbrBuildings = null;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = null;
            } else if (i == 3) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'CTL_ON';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'SFU CTL-ON';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Adtran-TA411-indoor-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 31585.80;
		        designatedSFUAvgLotSize = '50';
        		designatedMDUNbrBuildings = null;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = null;
            } else if (i == 4) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'Bulk';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'SFU Bulk';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Adtran-TA411-indoor-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 31585.80;
		        designatedSFUAvgLotSize = '50';
        		designatedMDUNbrBuildings = null;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = null;
            } else if (i == 5) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'Bulk';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'SFU Bulk';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Adtran-TA411-indoor-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 31585.80;
		        designatedSFUAvgLotSize = '50';
        		designatedMDUNbrBuildings = null;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = null;
            } else if (i == 6) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'CTL_ON';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Midrise CTL-ON';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Adtran-TA324-indoor-FTTIDF';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 10;
        		designatedMHriseAvgFloors = 5;
        		designatedRetailTakeRate = null;
            } else if (i == 7) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'CTL_ON';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Midrise CTL-ON';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Adtran-TA324-indoor-FTTIDF';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 10;
        		designatedMHriseAvgFloors = 5;
        		designatedRetailTakeRate = null;
            } else if (i == 8) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'CTL_ON';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Highrise CTL-ON';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Calix-716GE-i-indoor-FTTIDF';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 5;
        		designatedMHriseAvgFloors = 20;
        		designatedRetailTakeRate = null;
            } else if (i == 9) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'CTL_ON';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Highrise CTL-ON';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Calix-716GE-i-indoor-FTTIDF';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 5;
        		designatedMHriseAvgFloors = 20;
        		designatedRetailTakeRate = null;
            } else if (i == 10) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'Bulk';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Midrise Bulk';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Calix-803G-indoor-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 10;
        		designatedMHriseAvgFloors = 5;
        		designatedRetailTakeRate = null;
            } else if (i == 11) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'Bulk';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Midrise Bulk';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Calix-803G-indoor-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 10;
        		designatedMHriseAvgFloors = 5;
        		designatedRetailTakeRate = null;
            } else if (i == 12) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'Bulk';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Highrise Bulk';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Calix-C844G-indoor-integrated-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 5;
        		designatedMHriseAvgFloors = 20;
        		designatedRetailTakeRate = null;
            } else if (i == 13) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'Bulk';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Highrise Bulk';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Calix-C844G-indoor-integrated-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 5;
        		designatedMHriseAvgFloors = 20;
        		designatedRetailTakeRate = null;
            } else if (i == 14) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'Retail';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Midrise Retail';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Calix-803G-indoor-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 10;
        		designatedMHriseAvgFloors = 5;
        		designatedRetailTakeRate = 5.08;
            } else if (i == 15) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'Retail';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Midrise Retail';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Calix-803G-indoor-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 10;
        		designatedMHriseAvgFloors = 5;
        		designatedRetailTakeRate = 5.08;
            } else if (i == 16) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'Retail';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Highrise Retail';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Calix-803G-indoor-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 5;
        		designatedMHriseAvgFloors = 20;
        		designatedRetailTakeRate = 5.08;
            } else if (i == 17) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'Retail';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Highrise Retail';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Calix-803G-indoor-FTTU';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = 0.00;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = 5;
        		designatedMHriseAvgFloors = 20;
        		designatedRetailTakeRate = 5.08;
            } else if (i == 18) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'Bulk';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Cottage Bulk';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Calix-762GX-outdoor-FTTB';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = (88859.37 - 6748.75) + 31585.80;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = designatedLUs;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = null;
            } else if (i == 19) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'Bulk';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Cottage Bulk';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'CTLON';
                designatedOntModel = 'Calix-762GX-outdoor-FTTB';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = (88859.37 - 6748.75) + 31585.80;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = designatedLUs;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = null;
            } else if (i == 20) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'Retail';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Cottage Retail';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Calix-762GX-outdoor-FTTB';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = (88859.37 - 6748.75) + 31585.80;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = designatedLUs;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = 5.08;
            } else if (i == 21) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'Retail';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Cottage Retail';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Calix-762GX-outdoor-FTTB';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = (88859.37 - 6748.75) + 31585.80;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = designatedLUs;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = 5.08;
            } else if (i == 22) {
                scenarioDevelopmentStatus = 'Greenfield';
                scenarioServiceType = 'CTL_ON';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Cottage CTL-ON';
                designatedNetworkInvestmentType = 'NEW DEVELOPMENT';
                designatedProductType = 'FTTU';
                designatedOntModel = 'Calix-716GE-outdoor-FTTB';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = (88859.37 - 6748.75) + 31585.80;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = designatedLUs;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = null;
            } else if (i == 23) {
                scenarioDevelopmentStatus = 'Brownfield';
                scenarioServiceType = 'CTL_ON';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Cottage CTL-ON';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Calix-716GE-outdoor-FTTB';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = (88859.37 - 6748.75) + 31585.80;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = designatedLUs;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = null;
            } else if (i == 24) {
                scenarioDevelopmentStatus = 'Brownfield Overbuild';
                scenarioServiceType = 'CTL_ON';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Cottage CTL-ON';
                designatedNetworkInvestmentType = 'PRODUCT';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Calix-716GE-outdoor-FTTB';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = (88859.37 - 6748.75) + 31585.80;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = designatedLUs;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = null;                
            } else {
                scenarioDevelopmentStatus = 'OTHER';
                scenarioServiceType = 'CTL_ON';
	            scenarioTechType = 'FTTU';
                scenarioBuildingStyle = 'Cottage CTL-ON';
                designatedNetworkInvestmentType = 'NONE';
                designatedProductType = 'FTTH';
                designatedOntModel = 'Calix-716GE-outdoor-FTTB';
                designatedDropCostSource = 'PROVIDED';
                designatedDropCost = (88859.37 - 6748.75) + 31585.80;
		        designatedSFUAvgLotSize = null;
        		designatedMDUNbrBuildings = designatedLUs;
        		designatedMHriseAvgFloors = null;
        		designatedRetailTakeRate = null;                
            }
            capitalDesigns.add(
                new Capital_Design__c(
                    Opportunity__c = opptyList.get(i).Id,                    
                    Offer__c = offerList.get(i).Id,
					BRAIN_API_Call_Tracker_Master__c = bactList.get(i).Id,
                    Capital_Design_Type__c = 'Standard',
                    Capital_Design_Id__c = null,
                    Primary_Address_State_Name__c = 'Colorado',
                    State_Name__c = 'CO',
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,                    
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c =0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c =0,
                    Cobble_Bore_1_25_c_96f__c =0,
                    Rock_Bore_1_25_c_96f__c =0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97 ,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c =0,
                    Use_Vacant_12f__c =0,
                    Plow_2_c_48f__c =0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c =0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c=0,
                    Cobble_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_in_4_c_864f__c=0,
                    F1_Joint_Trench_Custom_with_conduit__c=85,
                    F1_Custom_without_conduit__c=0,
                    F1_Footage_ft__c=5300,
                    Building_Style__c = scenarioBuildingStyle,
                    nbr_of_Living_Units__c = designatedLUs,
                    for_SFU_Average_Lot_Size__c= designatedSFUAvgLotSize,
                    for_MDU_nbr_of_Buildings__c= designatedMDUNbrBuildings,
                    for_Midrise_Highrise_nbof_average_Floors__c= designatedMHriseAvgFloors,
                    for_Retail_Take_rate__c = designatedRetailTakeRate,
                    F3_Fiber_Type__c = 'Aerial',
                    Are_there_IDF__c = 'Yes',
                    Capital_Design_Stage__c='Capital Evaluation Complete',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c=10,
                    F1_Cost_ft_for_Custom_without_conduit__c	=0,
                    F2_Cost_ft_for_Custom_without_conduit__c=7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c=11.7,
                    Direct_Buried_12f__c=15,
                    Buried_w_Conduit_12f__c=15,
                    Aerial_12f__c=20,
                    Bore_1_25_c_12f__c=15,
                    Joint_Trench_Custom__c=15,
                    Pull_Fiber_12f__c=20, 
                    Core_Switch_Electronics__c = 0.00,//coreElectronicsCost
                    Transport_Interoffice_Fiber__c = 0.00,//interofficeFiberCost
                    CO_Electronics__c = 9360.00,//coElectronicsCost
                    Feeder_F1_Access_and_or_PON__c = 25414.00,//f1FeederCost
                    Remote_Electronics__c = 0.00,//remoteElectronicsCost
                    Distribution_F2__c = 0.00,//f2Cost
                    F2_Footage_ft__c = 800.00,//f2Footage
                    Distribution_Structure_Conduit__c = 54380.5875,//insideWiringCapEx
                    Electronics_Shelf_UPS_Cost__c = 2312.48,
                    MDU_ONT_Drop__c = designatedDropCost,
                    OP_Res_Gateway_Total_Cost_Comb_Cost__c = 2208.00,
                    OP_F2_Total_Cost_Combined_Cost__c = 88859.37,
                    OP_F2_Conduit_Sub_cost_Combined_Cost__c = 6748.75,
                    OP_F3_Total_Cost_Comb_Cost__c = 31585.80,
                    F4_Inside_Wiring_SFH__c = 0.00,//dropCost
                    Other_MDU_F4__c = 18098.70,//additionalOpExNrc
                    ONT_Model__c = designatedOntModel,
                    Network_Investment__c = designatedNetworkInvestmentType,//networkInvestmentType
                    Service_Type__c = scenarioServiceType,//partly into productType
                    Technology_Type__c = scenarioTechType,
                    Occupant_Type__c = 'CONSUMER'//occupantType                            
                )
            );
        }//end for-loop 0 thru count
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end createCapitalDesignsWithNRMADefaults    
    /***********************************************************************************************


     Purpose: Create Test CapitalDesign records with NRMA Defaults
     Parameters:oppId, offerId count, doInsert
     Return: List of CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ted Cabato         01/20/2023  ESCJ-1932     Initial draft
    ************************************************************************************************/
    public static List<Capital_Design__c> createCapitalDesignsWithNRMADefaults(Id oppId,Id offerId,Id bactId,Integer count,Boolean doInsert){
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            capitalDesigns.add(
                new Capital_Design__c(
                    Opportunity__c = oppId,
                    Offer__c = offerId,
					BRAIN_API_Call_Tracker_Master__c = bactId,
                    Capital_Design_Type__c = 'Standard',
                    Capital_Design_Id__c = null,
                    Primary_Address_State_Name__c = 'Colarado',
                    State_Name__c = 'CO',
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,                    
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c =0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c =0,
                    Cobble_Bore_1_25_c_96f__c =0,
                    Rock_Bore_1_25_c_96f__c =0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97 ,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c =0,
                    Use_Vacant_12f__c =0,
                    Plow_2_c_48f__c =0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c =0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c=0,
                    Cobble_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_in_4_c_864f__c=0,
                    F1_Joint_Trench_Custom_with_conduit__c=85,
                    F1_Custom_without_conduit__c=0,
                    F1_Footage_ft__c=5300,
                    Building_Style__c ='Cottage Retail',
                    nbr_of_Living_Units__c = 1289,
                    for_SFU_Average_Lot_Size__c= '50',
                    for_MDU_nbr_of_Buildings__c= 10,
                    for_Midrise_Highrise_nbof_average_Floors__c= 10,
                    Capital_Design_Stage__c='Capital Evaluation Complete',  //ESCJ-1688
                    F1Cost_ft_JointTrench_Custom_withconduit__c=10,
                    F1_Cost_ft_for_Custom_without_conduit__c	=0,
                    F2_Cost_ft_for_Custom_without_conduit__c=7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c=11.7,
                    Direct_Buried_12f__c=15,
                    Buried_w_Conduit_12f__c=15,
                    Aerial_12f__c=20,
                    Bore_1_25_c_12f__c=15,
                    Joint_Trench_Custom__c=15,
                    Pull_Fiber_12f__c=20, 
                    Core_Switch_Electronics__c = 0.00,//coreElectronicsCost
                    Transport_Interoffice_Fiber__c = 0.00,//interofficeFiberCost
                    CO_Electronics__c = 9360.00,//coElectronicsCost
                    Feeder_F1_Access_and_or_PON__c = 25414.00,//f1FeederCost
                    Remote_Electronics__c = 0.00,//remoteElectronicsCost
                    Distribution_F2__c = 0.00,//f2Cost
                    F2_Footage_ft__c = 800.00,//f2Footage
                    Distribution_Structure_Conduit__c = 54380.5875,//insideWiringCapEx
                    MDU_ONT_Drop__c = 0.00,
                    F4_Inside_Wiring_SFH__c = 0.00,//dropCost
                    Other_MDU_F4__c = 18098.70,//additionalOpExNrc
                    Network_Investment__c = 'NEW DEVELOPMENT',//networkInvestmentType
                    Service_Type__c = 'Retail',//partly into productType
                    Technology_Type__c = 'FTTU',//partly into productType
                    Occupant_Type__c = 'CONSUMER'//occupantType                            
                )
            );
        }
        if (doInsert) {
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end createCapitalDesignsWithNRMADefaults    
    /***********************************************************************************************
    Purpose: Create Test NRMA__c records
    Parameters: count, doInsert
    Return: List of NRMA__c records
    ================================================================================================
    History:
    AUTHOR             DATE        Reference   Description
    Ted Cabato         01/19/2023  ESCJ-1932   Initial draft
    ************************************************************************************************/
    public static List<NRMA__c> createNRMARequest(List<Capital_Design__c> cdList, List<Property__c> propertyList, Integer count,
        Boolean doInsert){
            List<NRMA__c> nrmaList = new List<NRMA__c>();
        for (Integer i = 0; i < count; i++) {
            nrmaList.add(
                new NRMA__c(
                    Associated_Brain_ID__c = '1225879202939539456',
                    ATC_Total__c = 0,
                    Beginning_Penetration__c = 0,
                    Bounty_Per_Unit__c = 50,
                    Brownfield_MDU_Count__c = 0,
                    Brownfield_SFU_Count__c = 0,
                    Build_Direct_CapEx_Total__c = 0,
                    Build_OpEx_Total__c = 0,
                    Build_Project_CapEx_Total__c = 49900,
                    Build_Shared_CapEx_Total__c = 5000,
                    Bulk_Price_Per_Unit_Average__c = 0,
                    Associated_Capital_Design__c = cdList == null ? null : cdList.size() == 0 ? null : (cdList.get(0).Id == null) ? null : cdList.get(0).Id,
                    Capital_Release_Requested_Amount__c = 0,
                    City__c = '',
                    Construction_Months__c = 48,
                    Consultant_Name__c = null,
                    Email_Address__c = 'john.chase@centurylink.com',
                    Contract_Language__c = null,
                    Contract_Term_Months__c = '84',
                    Developer_Name__c = null,
                    Door_Fee__c = 0,
                    Early_Term_Liability__c = null,
                    Ending_Penetration__c = 81.14,
                    Escalated__c = false,
                    Finance_Current_Phase_Begin_Time__c = null,
                    Finance_Workflow_Completed_Time__c = null,
                    Finance_Workflow_ID__c = '55478786',
                    Finance_Workflow_Status__c = '',
                    Financial_Evaluation_Message__c = 'Payback: 20.4 (<= 96.0)',
                    Financial_Evaluation_Result_Code__c = 'GREEN',
                    Greenfield_MDU_Count__c = 0,
                    Greenfield_SFU_Count__c = 400,
                    High_Cost_Explanation__c = '',
                    Investment_Total__c = 54900,
                    Name__c = null,
                    No_Agreement_Reason__c = null,
                    Notes__c = '',
                    Notification_Email_Addresses__c = 'john.chase@centurylink.com',
                    NRMA_Request_ID__c = '1225879548856373248',
                    Offer_ID__c = cdList == null ? null : cdList.size() == 0 ? null : (cdList.get(0).Offer__c == null) ? null : cdList.get(0).Offer__c,
                    Offer_Management_Current_Phase_BeginTime__c = Datetime.valueOf('2020-03-20T23:28:44Z'.left(19).replace('T',' ')),
                    Offer_Management_Workflow_Completed_Time__c = null,
                    Offer_Management_Workflow_ID__c = '55478788',
                    Offer_Management_Workflow_Status__c = 'Archived',
                    Open_Trench_Date__c = Date.valueOf('2020-06-30T00:00:00Z'.left(19).replace('T',' ')),
                    Opportunity__c = (cdList?.get(0)?.Offer__r?.Opportunity__r?.Id != null) ? cdList?.get(0)?.Offer__r?.Opportunity__r?.Id : null,
                    Opportunity_Title__c = 'Test <$100K Non CTL ON SFH EMA FTTU Sole Provider',
                    OwnerId = UserInfo.getUserId(),                    
                    Product__c = 'FTTH',
                    Associated_Property_ID__c = (propertyList?.get(0)?.Id != null) ? propertyList?.get(0)?.Id : null,
                    Service_Revenue_Shares__c = 0,
                    Simple_Payback_Months__c = 0,
                    State__c = '',
                    Submission_Date_From_NRMA__c = Datetime.valueOfGmt('2020-02-07T00:00:00Z'.left(19).replace('T',' ')),
                    CUID__c = 'jchase',
                    Supporting_Document_URLs__c = null,
                    URL__c = null,
                    Wire_Center_Treatment__c = null
                )
            );
        }
        if (doInsert) {
	       insert nrmaList;
        }
        return nrmaList;
        
    }//end method createNRMARequest 

    /***********************************************************************************************
     Purpose: Create Test CapitalDesign records
     Parameters:oppId, count, doInsert
     Return: List of CapitalDesign records
    ================================================================================================
     History:
     AUTHOR             DATE        Reference     Description
     Ami Parekh      03/03/2022      ESCJ-557    Initial draft
    ************************************************************************************************/
    public static List<Capital_Design__c> createCapitalDesignsForBRAINFAScheduler(Id oppId,Integer count,Boolean doInsert){
        List<Capital_Design__c>capitalDesigns = new List<Capital_Design__c>();
        for (Integer i = 0; i < count; i++) {
            capitalDesigns.add(
                new Capital_Design__c(
                    Opportunity__c = oppId,
                    F2_Direct_Buried_96f__c = 0,
                    F2_Aerial_10M_144f__c = 0 ,
                    Pull_Fiber_96f__c = 0,
                    F2_Footage_ft__c = 66450,
                    Place_Conduit_4_c__c = 0,
                    Place_Conduit_and_Pull_Fiber_4_c_96f__c =0,
                    Trench_4_c_96f__c = 0,
                    Bore_1_25_c_96f__c =0,
                    Cobble_Bore_1_25_c_96f__c =0,
                    Rock_Bore_1_25_c_96f__c =0,
                    F2_Joint_Trench_Custom_with_conduit__c = 97 ,
                    F2_Custom_without_conduit__c = 3,
                    Use_Existing_Spare__c =0,
                    Use_Vacant_12f__c =0,
                    Plow_2_c_48f__c =0,
                    F1_Direct_Buried_96f__c = 0,
                    F1_Aerial_10M_144f__c = 0,
                    Overpull_1_25_c_864f__c  = 15,
                    Blended_Cost_from_FW__c = 0,
                    Lateral_Bore_1_25_c_864f__c = 0,
                    Backbone_Bore_1_25_c_3_in_4_c_864f__c =0,
                    Cobble_Bore_1_25_c_in_4_c_864f__c=0,
                    Cobble_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_864f__c=0,
                    Rock_Bore_1_25_c_in_4_c_864f__c=0,
                    F1_Joint_Trench_Custom_with_conduit__c=85,
                    F1_Custom_without_conduit__c=0,
                    F1_Footage_ft__c=5300,
                    Service_Type__c = 'CTL_ON',
                    Building_Style__c ='SFU CTL-ON',
                    nbr_of_Living_Units__c = 1289,
                    for_SFU_Average_Lot_Size__c= '50',
                    for_MDU_nbr_of_Buildings__c= 10,
                    for_Midrise_Highrise_nbof_average_Floors__c= 10,
                    Capital_Design_Stage__c='Planner Design Complete',  //ESCJ-1688
                    QueuedForBRAINFARun__c = TRUE,
                    F1Cost_ft_JointTrench_Custom_withconduit__c=10,
                    F1_Cost_ft_for_Custom_without_conduit__c	=0,
                    F2_Cost_ft_for_Custom_without_conduit__c=7,
                    F2Cost_ft_JointTrench_Custom_withconduit__c=11.7,
                    OP_Res_Gateway_Total_Cost_Comb_Cost__c = 2208.00,
                    OP_F2_Total_Cost_Combined_Cost__c = 88859.37,
                    OP_F2_Conduit_Sub_cost_Combined_Cost__c = 6748.75,
                    OP_F3_Total_Cost_Comb_Cost__c = 31585.80,
                    Electronics_Shelf_UPS_Cost__c = 2312.48,
                    Direct_Buried_12f__c=15,
                    Buried_w_Conduit_12f__c=15,
                    Aerial_12f__c=20,
                    Bore_1_25_c_12f__c=15,
                    Joint_Trench_Custom__c=15,
                    Pull_Fiber_12f__c=20 
                )
            );
        }
        if (doInsert) { 
            INSERT capitalDesigns;
        }
        return capitalDesigns;
    }//end method createCapitalDesignsForBRAINFAScheduler

}//end class TestDataFactory