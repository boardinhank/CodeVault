public class CreatePropertyFromPrrQueueable implements Queueable, Database.AllowsCallouts {     
    private List<Property_Request_Record__c> prrList;
    private Map<Id, Property_Request_Record__c> prrMapToUpdate;
    Map<String, Property__c> propertiesToInsertMap;
    Map<Id, String> transSummaryParcelServiceMap;
    Map<String, Contact> contactsToInsertMap;
    Map<String, Contact> contactsMap;
    Map<Id, GeoesParcelService.AddressValidationWrapper> wrapperMap;
    List<Property_Request_Record__c> prrs;
    Set<Id> prrIds;
    Map<String, GeoesParcelService.AddressValidationWrapper> wrapperMapByUniqueId;
    List<Property_Request_Record__c> invalidPrrs;
    public Boolean isChainable;
    public Integer retryCount;
    public Set<Id> propertyIdsInserted;
    static final Integer MAX_RETRY_COUNT_SIZE_DEFAULT = 3;
    public static final String MAX_RETRY_COUNT_SIZE_KEY = 'CreatePropertyFromPrrQueueable.maxRetryCount';
    public Integer maxRetryCount {
        get {
            if(maxRetryCount == null) {
                maxRetryCount = Integer.valueOf(
                    ConfigKeyValuePairMetadata.getMetadata(
                        MAX_RETRY_COUNT_SIZE_KEY,
                        MAX_RETRY_COUNT_SIZE_DEFAULT
                    )
                );
            }
            return maxRetryCount;
        }
        set;
    }
	
							

    public CreatePropertyFromPrrQueueable(
        Set<Id> prrIds
    ) {
        this.prrIds = prrIds;
        this.retryCount = 0;
        this.isChainable = false;
        this.propertyIdsInserted = new Set<Id>();
    }

    public CreatePropertyFromPrrQueueable(
        Set<Id> prrIds,
        Boolean isChainable
    ) {
        this.prrIds = prrIds;
        this.isChainable = isChainable;
        this.retryCount = 0;
        this.propertyIdsInserted = new Set<Id>();
    }

    public CreatePropertyFromPrrQueueable(
        List<Property_Request_Record__c> prrs
    ) {
        this.prrs = prrs;
        this.retryCount = 0;
        this.isChainable = false;
        this.propertyIdsInserted = new Set<Id>();
    }

    public void execute(QueueableContext context) {
        System.debug('(CreatePropertyFromPrrQueuable.execute~started) this.isChainable = ' + this.isChainable);
        System.debug('(CreatePropertyFromPrrQueuable.execute~started) this.prrIds null or Empty? ' + (this.prrIds == null || this.prrIds.isEmpty()));
        if(this.prrIds != null && !this.prrIds.isEmpty()) {
	        System.debug('(CreatePropertyFromPrrQueuable.execute~NOT-null-NOT-empty) this.prrIds.size() = ' + this.prrIds.size() + '  AND this.prrIds = ' + this.prrIds);
            if(this.isChainable) {
                List<Id> prrIdList = new List<Id>(this.prrIds);
                this.prrs = getPropertyRequestRecords(
                    new Set<Id>{ 
                        prrIdList.remove(0) 
                    }
                );
                this.prrIds = new Set<Id>(prrIdList);
		        System.debug('(CreatePropertyFromPrrQueuable.execute~NOT-null-NOT-empty-isChainable) this.prrIds?.size() = ' + this.prrIds?.size() + '  AND this.prrIds = ' + this.prrIds);
            } else {
                this.prrs = getPropertyRequestRecords(
                    this.prrIds
                );
            }
        }
        System.debug('(CreatePropertyFromPrrQueuable.execute~after_if/else_NOT-null-NOT-empty) this.prrs = ' + this.prrs);
        if(this.prrs == null 
            && (this.prrIds == null 
                || this.prrIds.isEmpty()
            ) 
        ) {
            return;
        }
        
        System.debug('(CreatePropertyFromPrrQueuable.execute) this.prrs?.size() = ' + this.prrs?.size());
        if(this.isChainable && this.prrs.size() > 1) {
            this.prrIds = new Map<Id, Property_Request_Record__c>(
                this.prrs
            ).keySet();
            Property_Request_Record__c prr = this.prrs.remove(0);
            this.prrs = new List<Property_Request_Record__c>{
                prr
            };
            this.prrIds.remove(prr.Id);
	        System.debug('(CreatePropertyFromPrrQueuable.execute~isChainable_this.prrs.size>1) this.prrIds?.size() = ' + this.prrIds?.size() + '  AND this.prrIds = ' + this.prrIds);
        }
        //System.assert(false, CreatePropertyFromPrrBatch.filterDuplicates(this.prrs));
        this.prrMapToUpdate = new Map<Id, Property_Request_Record__c>();
        this.propertiesToInsertMap =  new Map<String, Property__c>();
        this.transSummaryParcelServiceMap = new Map<Id,String>();
        this.contactsToInsertMap = new Map<String, Contact>();
        this.contactsMap = new Map<String, Contact>();
        this.wrapperMapByUniqueId = new Map<String, GeoesParcelService.AddressValidationWrapper>();
        this.invalidPrrs = new List<Property_Request_Record__c>();

        try{
            GeoesParcelService service = new GeoesParcelService(
                this.prrs, 
                true
            );
            this.wrapperMap = service.execute();
            
            for(Id prrId : this.wrapperMap.keySet()) {
                System.debug('(CreatePropertyFromPrrQueuable.execute~after-GeoesParceLService_for-loop-thru-wrapperMap.keySet) prrId = ' + prrId);
                GeoesParcelService.AddressValidationWrapper wrapper = this.wrapperMap.get(prrId);
                if(!wrapper.isSuccessfulTransaction) {
                    if(this.isChainable) {
                        if(this.retryCount < maxRetryCount) {
                            this.retryCount++;
                            this.clearState();
                            this.prrIds.add(prrId);
					        System.debug('(CreatePropertyFromPrrQueuable.execute~isChainable_this.retryCount<maxRetryCount) this.prrIds?.size() = ' + this.prrIds?.size() + '  AND this.prrIds = ' + this.prrIds);
                            System.enqueueJob(this);
                            return;
                        } 
                    }
			        System.debug('(CreatePropertyFromPrrQueuable.execute~AFTER-isChainable_this.retryCount<maxRetryCount) did NOT return so continuing');
                    continue;
                }
		        System.debug('(CreatePropertyFromPrrQueuable.execute~after-GeoesParceLService_for-loop-thru-wrapperMap.keySet_continuing) String.isBlank(wrapper.countyCode)? ' + String.isBlank(wrapper.countyCode) + ', wrapper.countyCode = ' + wrapper.countyCode);
		        System.debug('(CreatePropertyFromPrrQueuable.execute~after-GeoesParceLService_for-loop-thru-wrapperMap.keySet_continuing) String.isBlank(wrapper.apn)? ' + String.isBlank(wrapper.apn) + ', wrapper.apn = ' + wrapper.apn);
		        System.debug('(CreatePropertyFromPrrQueuable.execute~after-GeoesParceLService_for-loop-thru-wrapperMap.keySet_continuing) String.isBlank(wrapper.stateCode)? ' + String.isBlank(wrapper.stateCode) + ', wrapper.stateCode = ' + wrapper.stateCode);
                if(String.isBlank(wrapper.countyCode)
                    || String.isBlank(wrapper.apn)
                    || String.isBlank(wrapper.stateCode)
                ) {
			        System.debug('(CreatePropertyFromPrrQueuable.execute~after-GeoesParceLService_for-loop-thru-wrapperMap.keySet_continuing) ALL were TRUE, adding wrapper.propertyRequestRecord to invalidPrrs');
                    this.invalidPrrs.add(
                        wrapper.propertyRequestRecord
                    );
                    continue;
                }
		        System.debug('(CreatePropertyFromPrrQueuable.execute~after-GeoesParceLService_for-loop-thru-wrapperMap.keySet) putting wrapper.uniqueId and wrapper into wrapperMapByUniqueId');
                this.wrapperMapByUniqueId.put(
                    wrapper.uniqueId,
                    wrapper
                );
            }//end for-loop thru wrapperMap.keySet
            
	        System.debug('(CreatePropertyFromPrrQueuable.execute~after_for-loop-thru-wrapperMap.keySet) querying for list of Properties WHERE Unique_Id__c IN wrapperMapByUniqueId.keySet() '+this.wrapperMapByUniqueId.keySet());
            List<Property__c> properties = [
                SELECT 
                    County_Code__c, 
                    APN__c, 
                    State_Code__c,
                    Property_Unique_ID__c,
                    Unique_Id__c
                FROM Property__c 
                WHERE Unique_Id__c IN :this.wrapperMapByUniqueId.keySet()
            ];
	        System.debug('(CreatePropertyFromPrrQueuable.execute~after_query) Query returned ' + properties.size() + ' Property__c records '+properties);
            Map<String, Property__c> propertyMap = new Map<String, Property__c>();
	        System.debug('(CreatePropertyFromPrrQueuable.execute~after_query) Putting Property__c Unique_Id__c and records into propertyMap');
            for(Property__c property : properties) {
                propertyMap.put(
                    property.Unique_Id__c,
                    property
                );
            }

            Set<String> contactNames = new Set<String>();

	        System.debug('(CreatePropertyFromPrrQueuable.execute~after_query) Looping thru wrapperMapByUniqueId.keySet');
            for(String uniqueId : this.wrapperMapByUniqueId.keySet()) {
                GeoesParcelService.AddressValidationWrapper wrapper = this.wrapperMapByUniqueId.get(uniqueId);
                Property_Request_Record__c propertyRequestRecord = wrapper.propertyRequestRecord;
                contactNames.add(
                    wrapper.contactName
                );

		        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.keySet) Setting foundProperty to propertyMap.get(uniqueId) '+propertyMap.get(uniqueId));
                Property__c foundProperty = propertyMap.get(uniqueId);

                if(foundProperty != null) {
			        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.keySet) foundProperty is NOT NULL, so setting propertyRequestRecord.Duplicate_Property_Found__c = GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_YES');
                    propertyRequestRecord.Duplicate_Property_Found__c = GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_YES;
			        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.keySet) foundProperty is NOT NULL, so setting propertyRequestRecord.Match_Found_In_System__c = GeoesConstants.MATCH_SYSTEM_FOUND_PRR_YES');
                    propertyRequestRecord.Match_Found_In_System__c = GeoesConstants.MATCH_SYSTEM_FOUND_PRR_YES;
			        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.keySet) foundProperty is NOT NULL, so setting wrapper.property = foundProperty');
                    wrapper.property = foundProperty;
                } else {
			        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.keySet) foundProperty is NULL');
                    if(wrapper.hasParcels()) {
				        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.keySet) foundProperty is NULL, wrapper.hasParcels is TRUE, setting propertyRequestRecord.Match_Found_In_System__c = GeoesConstants.MATCH_SYSTEM_FOUND_PRR_YES');
                        propertyRequestRecord.Match_Found_In_System__c = GeoesConstants.MATCH_SYSTEM_FOUND_PRR_YES;
                    } else {
				        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.keySet) foundProperty is NULL, wrapper.hasParcels is FALSE, setting propertyRequestRecord.Match_Found_In_System__c = GeoesConstants.MATCH_SYSTEM_FOUND_PRR_NO');
                        propertyRequestRecord.Match_Found_In_System__c = GeoesConstants.MATCH_SYSTEM_FOUND_PRR_NO;
                    }
			        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.keySet) foundProperty is NULL, setting propertyRequestRecord.Duplicate_Property_Found__c = GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_NO');
                    propertyRequestRecord.Duplicate_Property_Found__c = GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_NO;
                }
                this.prrMapToUpdate.put(
                    wrapper.propertyRequestRecord.Id, 
                    wrapper.propertyRequestRecord
                );
            }//end for-loop thru wrapperMapByUniqueId.keySet
            
	        System.debug('(CreatePropertyFromPrrQueuable.execute~after_Looping thru wrapperMapByUniqueId.keySet) Calling this.createPropertyRecords()');
            this.createPropertyRecords();
            /*List<Contact> contacts = [
                SELECT
                    FirstName,
                    LastName,
                    Name
                FROM Contact
                WHERE Name IN :contactNames
            ];
            for(Contact c : contacts) {
                contactsMap.put(
                    c.Name,
                    c
                );
            }
            insert this.contactsToInsertMap.values();
            */
            for(Property__c property : this.propertiesToInsertMap.values()) {
                Contact c = this.contactsToInsertMap.get(
                    property.Unique_Id__c
                );
                if(c == null) {
                    continue;
                }
                property.Property_Contact__c = c.Id;
            }     

	        System.debug('(CreatePropertyFromPrrQueuable.execute~after_Calling this.createPropertyRecords) Setting propertiesToInsert = this.propertiesToInsertMap.values()');
            List<Property__c> propertiesToInsert = this.propertiesToInsertMap.values();
            if(!this.propertiesToInsertMap.keySet().isEmpty()) {
		        System.debug('(CreatePropertyFromPrrQueuable.execute~after_Setting_propertiesToInsert) this.propertiesToInsertMap.keySet() is NOT Empty, insert propertiesToInsert with FALSE for "all or none" and save into propertySaveResults');
                Database.SaveResult[] propertySaveResults = Database.insert(
                    propertiesToInsert,
                    false //all or none
                );

                //System.assert(false, propertySaveResults);
                
		        System.debug('(CreatePropertyFromPrrQueuable.execute~after_Inserting-propertiesToInsert) for-loop thru propertySaveResults');
                for(Integer i = 0; i < propertySaveResults.size(); i++) {
                    Database.SaveResult propertySaveResult = propertySaveResults.get(i);
                    Property__c property = propertiesToInsert.get(i);
                    GeoesParcelService.AddressValidationWrapper wrapper = this.wrapperMapByUniqueId.get(
                        property.Unique_Id__c
                    );
                    wrapper.propertyRequestRecord.Match_Found_In_System__c = GeoesConstants.MATCH_SYSTEM_FOUND_PRR_YES;
			        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-propertySaveResults) propertySaveResult.isSuccess? ' + propertySaveResult.isSuccess());
                    if(propertySaveResult.isSuccess()) {
				        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-propertySaveResults_AND_propertySaveResult.isSuccess-TRUE) Add property.Id to this.propertyIdsInserted');
                        this.propertyIdsInserted.add(
                            property.Id
                        );
                        continue;
                    }
			        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-propertySaveResults) setting wrapper.propertyRequestRecord.Duplicate_Property_Found__c = GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_YES');
                    wrapper.propertyRequestRecord.Duplicate_Property_Found__c = GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_YES;
                }
            }

	        System.debug('(CreatePropertyFromPrrQueuable.execute~after_for-loop-thru-propertySaveResults) Calling buildTransactionSummaries');
            Map<Id, Transaction_Summary__c> transactionSummaries = buildTransactionSummaries(
                this.propertiesToInsertMap.values()
            );
	        System.debug('(CreatePropertyFromPrrQueuable.execute~after_calling-buildTransactionSummaries) upsert transactionSummaries.values');
            upsert transactionSummaries.values();

            List<Property__c> propertiesInserted = new List<Property__c>();
            for(Property__c property : this.propertiesToInsertMap.values()) {
                if(property.Id == null) {
                    continue;
                }
                propertiesInserted.add(property);
            }//end for-loop thru propertiesToInserMap.values
	        System.debug('(CreatePropertyFromPrrQueuable.execute~post_for-loop-thru-propertiesToInserMap.values) added property to propertiesInserted');

            for(GeoesParcelService.AddressValidationWrapper wrapper : this.wrapperMapByUniqueId.values()) {
                if(wrapper.property == null) {
                    continue;
                }
		        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.values) wrapper.propertyRequestRecord.Duplicate_Property_Found__c == GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_YES? ' + (wrapper.propertyRequestRecord.Duplicate_Property_Found__c == GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_YES));
                if(wrapper.propertyRequestRecord.Duplicate_Property_Found__c == GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_YES) {
			        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.values) wrapper.propertyRequestRecord.Existing_Property_found_in_SF_with_PRR__c = wrapper.property.Id');
                    wrapper.propertyRequestRecord.Existing_Property_found_in_SF_with_PRR__c = wrapper.property.Id;
                    continue;
                }
		        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-wrapperMapByUniqueId.values) wrapper.propertyRequestRecord.New_Property_Created__c = wrapper.property.Id');
                wrapper.propertyRequestRecord.New_Property_Created__c = wrapper.property.Id;
            }//end for-loop thru wrapperMapByUniqueId.values 

            List<Property_Request_Record__c> prrsToUpdate = new List<Property_Request_Record__c>();            
            prrsToUpdate.addAll(
                this.prrMapToUpdate.values()
            );
	        System.debug('(CreatePropertyFromPrrQueuable.execute~post_for-loop-thru-wrapperMapByUniqueId.values) added ALL this.prrMapToUpdate.values to prrsToUpdate');

            for(Property_Request_Record__c prr : this.invalidPrrs) {
		        System.debug('(CreatePropertyFromPrrQueuable.execute~for-loop-thru-invalidPrrs) set isProcessed TRUE, set Invalid_Data TRUE, add prr to prrsToUpdate');
                prr.isProcessed__c = true;
                prr.Invalid_Data__c = true;
                prrsToUpdate.add(prr);
            }
            prrsToUpdate = buildPrrsForDml(
                prrsToUpdate
            );
	        System.debug('(CreatePropertyFromPrrQueuable.execute~post-buildPrrsForDml) update prrsToUpdate');
            update prrsToUpdate;
            
            service.commitChanges(); //save api transactions
	        System.debug('(CreatePropertyFromPrrQueuable.execute~post-update-prrsToUpdate) commitChanges');
        } catch(Exception ex) {
            insert new API_Transaction__c(
                API_Name__c = 'DEV_TEST_ERROR',
                API_Request_JSON__c = String.format(
                    '{0}\n{1}\n{2}',
                    new List<String>{
                        String.valueOf(ex.getLineNumber()),
                        ex.getMessage(),
                        JSON.serialize(prrs)
                    }
                ), 
                API_Response_JSON__c = ex.getStackTraceString()
            );
        }
        system.debug('im here 1@@@' +prrIds );
        this.clearState(); //queueables are stateful by default
        if(this.isChainable) {
	        System.debug('(CreatePropertyFromPrrQueuable.execute~after_updatePrrsToUpdate_clearState_isChainable) this.prrIds?.size() = ' + this.prrIds?.size() + '  AND this.prrIds = ' + this.prrIds);

            if(!this.prrIds.isEmpty()) {
                system.debug('im here 2@@@' +prrIds );
                if(Test.isRunningTest()) {
                    this.execute(null);
                } else {
			        System.debug('(CreatePropertyFromPrrQueuable.execute~isChainable_this.prrIds-NOT-empty) enqueueing this job again because more to process');
                    System.enqueueJob(this);
                }
            }
            else if(!this.propertyIdsInserted.isEmpty()) {
		        System.debug('(CreatePropertyFromPrrQueuable.execute~isChainable_this.propertyIdsInserted-NOT-empty) constructing then enqueueing PropertyCreationTelcoQueueable');
                PropertyCreationTelcoQueueable telcoQueueable = new PropertyCreationTelcoQueueable(
                    this.propertyIdsInserted
                );
                if(Test.isRunningTest()) {
                    telcoQueueable.execute(null);
                } else {
			        System.debug('(CreatePropertyFromPrrQueuable.execute~isChainable_this.propertyIdsInserted-NOT-empty) enqueueing PropertyCreationTelcoQueueable');
                    System.enqueueJob(telcoQueueable);
                }
            }
        }
    }

    private void clearState() {
        this.prrList = null;
        this.prrMapToUpdate = null;
        this.propertiesToInsertMap = null;
        this.transSummaryParcelServiceMap = null;
        this.contactsToInsertMap = null;
        this.contactsMap = null;
        this.wrapperMap = null;
        this.wrapperMapByUniqueId = null;
        this.invalidPrrs = null;
    }

    private void createPropertyRecords() {
        for(String uniqueId : this.wrapperMapByUniqueId.keySet()) {
            System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords~for-loop-thru-wrapperMapByUniqueId.keySet) setting GeoesParcelService.AddressValidationWrapper using wrapperMapByUniqueId.uniqueId');
            GeoesParcelService.AddressValidationWrapper wrapper = this.wrapperMapByUniqueId.get(uniqueId);
            System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords~for-loop-thru-wrapperMapByUniqueId.keySet) setting Property_Request_Record__c using wrapper.propertyRequestRecord');
            Property_Request_Record__c propertyRequestRecord = wrapper.propertyRequestRecord;
            System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords~for-loop-thru-wrapperMapByUniqueId.keySet) Is propertyRequestRecord.Match_Found_In_System__c != GeoesConstants.MATCH_SYSTEM_FOUND_PRR_YES? ' + (propertyRequestRecord.Match_Found_In_System__c != GeoesConstants.MATCH_SYSTEM_FOUND_PRR_YES));
            System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords~for-loop-thru-wrapperMapByUniqueId.keySet) Is propertyRequestRecord.Duplicate_Property_Found__c != GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_NO? ' + (propertyRequestRecord.Duplicate_Property_Found__c != GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_NO));
            System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords~for-loop-thru-wrapperMapByUniqueId.keySet) Does !wrapper.hasParcels? ' + (!wrapper.hasParcels()));
            System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords~for-loop-thru-wrapperMapByUniqueId.keySet) Is wrapper.parcelLatitude NULL? ' + (wrapper.parcelLatitude == null));
            System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords~for-loop-thru-wrapperMapByUniqueId.keySet) Is wrapper.parcelLongitude NULL? ' + (wrapper.parcelLongitude == null));
            if(propertyRequestRecord.Match_Found_In_System__c != GeoesConstants.MATCH_SYSTEM_FOUND_PRR_YES
                || propertyRequestRecord.Duplicate_Property_Found__c != GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_NO
                || !wrapper.hasParcels()
                || wrapper.parcelLatitude == null 
                || wrapper.parcelLongitude == null
            ) {
                continue;
            }

	        System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords) Since ALL were TRUE, now constructing Property');
            Property__c property = new Property__c();
            property.Name                      = wrapper.subdivisionName;
            property.Latitude__c               = Decimal.valueOf(wrapper.parcelLatitude);
            property.Longitude__c              = Decimal.valueOf(wrapper.parcelLongitude);
            property.Primary_Address_City__c   = wrapper.city;
            property.Primary_Address_State__c  = wrapper.state;
            property.Primary_Address_Street__c = wrapper.address;
            property.Primary_Address_Zip__c    = wrapper.zipCode;
            property.County_Code__c            = wrapper.countyCode;
            property.State_Code__c             = wrapper.stateCode;
            property.APN__c                    = wrapper.apn;
            property.Unique_Id__c              = uniqueId;
            if (propertyRequestRecord.Data_Source__c == 'Customer Success') {
                property.Property_Binder_Partner__c = propertyRequestRecord.CS_SBS_Tech_Module__c;
                property.Property_Total_Units__c = propertyRequestRecord.CS_HH_Field__c;
                property.First_Occupancy_Date__c = propertyRequestRecord.CS_FOD_Field__c;
                //property.Property_Type__c = propertyRequestRecord.CS_Property_Type__c; //QFCJ-4554
                if (propertyRequestRecord.CS_Property_Type__c != null) {
                    if (propertyRequestRecord.CS_Property_Type__c == 'BULK') {
                        property.Property_Type__c = 'Other'; 
                    } else if (propertyRequestRecord.CS_Property_Type__c == 'CAM') {
                        property.Property_Type__c = 'HOA';                    
                    } else if (propertyRequestRecord.CS_Property_Type__c == 'MDU') {
                        property.Property_Type__c = 'Apartment';                    
                    } else if (propertyRequestRecord.CS_Property_Type__c == 'SFH') {
                        property.Property_Type__c = 'Single Family Home (SFH)';
                    }
                }
                property.Legacy_CDG_ID__c = propertyRequestRecord.CS_Legacy_CDG_ID__c;
                property.External_Source_ID__c = propertyRequestRecord.CS_External_Source_ID__c;
                property.Property_Structure__c = propertyRequestRecord.User_Property_Structure__c;
	            property.MSK_ID_1__c = propertyRequestRecord.CS_MSK_ID_1__c; //QFCJ-4554
	            property.MSK_ID_2__c = propertyRequestRecord.CS_MSK_ID_2__c; //QFCJ-4554
	            property.MSK_ID_3__c = propertyRequestRecord.CS_MSK_ID_3__c; //QFCJ-4554
	            property.MSK_ID_4__c = propertyRequestRecord.CS_MSK_ID_4__c; //QFCJ-4554
	            property.MSK_ID_5__c = propertyRequestRecord.CS_MSK_ID_5__c; //QFCJ-4554
            } else {
                property.Property_Total_Units__c = propertyRequestRecord.User_Number_of_Living_Units__c;
                property.First_Occupancy_Date__c = propertyRequestRecord.User_First_Occupancy_Date__c;
                property.Property_Type__c = propertyRequestRecord.User_Property_Type__c;                
                property.Property_Structure__c = propertyRequestRecord.User_Property_Structure__c;
            }
            property.Region__c = propertyRequestRecord.Region__c;
            property.Market__c = propertyRequestRecord.Market__c;
            property.Property_Age_In_Years__c = propertyRequestRecord.Property_Age_In_Years__c;
            property.Preferred_Contact_Method__c = propertyRequestRecord.Preferred_Contact_Method__c;
            property.Construction_Start_Date__c = propertyRequestRecord.User_Construction_Start_Date__c;
            property.Construction_Completion_Date__c = propertyRequestRecord.User_Construction_Completion_Date__c;
            property.Initial_Source_Development_Status__c = propertyRequestRecord.Development_Status__c;
	        System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords) PRR has Transaction_Summary__c = ' + propertyRequestRecord.Transaction_Summary__c);
            //Added to see if assigning Transaction_Summary__c from PRR to property will store in property record upon save where it can be used in AddTelco and 1G
            property.Transaction_Summary__c = propertyRequestRecord.Transaction_Summary__c;
            
            wrapper.property = property;
	        System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords) set wrapper.property to property');

	        System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords) calling buildPropertyContact using wrapper');
            buildPropertyContact(wrapper);

	        System.debug('(CreatePropertyFromPrrQueuable.createPropertyRecords) putting uniqueId and property into propertiesToInsertMap');
            this.propertiesToInsertMap.put(
                uniqueId,
                property
            );
        }
    }

    private void buildPropertyContact(
        GeoesParcelService.AddressValidationWrapper wrapper
    ) {
        System.debug('(CreatePropertyFromPrrQueuable.buildPropertyContact) input parameter is GeoesParcelService.AddressValidationWrapper');
        if(this.contactsMap.containsKey(wrapper.contactName)) {
	        System.debug('(CreatePropertyFromPrrQueuable.buildPropertyContact) this.contactsMap containsKey wrapper.contactName so returning');
            return;
        }
        System.debug('(CreatePropertyFromPrrQueuable.buildPropertyContact) Contact created from wrapper.buildContact');
        Contact c = wrapper.buildContact();
        if(c == null) {
	        System.debug('(CreatePropertyFromPrrQueuable.buildPropertyContact) Created contact was NULL so returning');
            return;
        }
        System.debug('(CreatePropertyFromPrrQueuable.buildPropertyContact) putting wrapper.uniqueId into contactsToInsertMap');
        this.contactsToInsertMap.put(
            wrapper.uniqueId,
            c
        );
    }

    private Map<Id, Transaction_Summary__c> buildTransactionSummaries(List<Property__c> propertyList) {
        Map<Id, Transaction_Summary__c> transactionList = new Map<Id, Transaction_Summary__c>();

        for(Property__c property : propertyList) {
            Transaction_Summary__c transSummary = new Transaction_Summary__c();
            System.debug('(CreatePropertyFromPrrQueuable.buildTransactionSummaries) Property with Name "' + property.Name + '" has Transaction_Summary__c = ' + property.Transaction_Summary__c);
            transSummary.Id                       = property.Transaction_Summary__c;
            transSummary.Property_Name__c         = property.Name;
            transSummary.Property_Latitude__c     = property.Latitude__c;
            transSummary.Property_Longitude__c    = property.Longitude__c;
            transSummary.Property_City__c         = property.Primary_Address_City__c;
            transSummary.Property_Address__c      = property.Primary_Address_Street__c;
            transSummary.Property_State__c        = property.Primary_Address_State__c;
            transSummary.Property_APN__c          = property.APN__c;
            transSummary.Property_CountyCode__c   = property.County_Code__c;
            transSummary.Property_StateCode__c    = property.State_Code__c;
            //todo refactor these 3 lines
            if(this.transSummaryParcelServiceMap?.containsKey(property?.Transaction_Summary__c)){
                transSummary.Last_Step__c = this.transSummaryParcelServiceMap.get(property?.Transaction_Summary__c);
            }
            transactionList.put(transSummary.Id , transSummary);
        }

        return transactionList;
    }
    
    private static List<Property_Request_Record__c> buildPrrsForDml(
        List<Property_Request_Record__c> prrListToUpdate
    ) {
        List<Property_Request_Record__c> dmlPrrs = new List<Property_Request_Record__c>();
        for(Property_Request_Record__c prr : prrListToUpdate) {
            String matchFoundInSystem = null;
            if(prr.Match_Found_In_System__c == null) {
                matchFoundInSystem = GeoesConstants.MATCH_SYSTEM_FOUND_PRR_NO;
            } else {
                matchFoundInSystem = prr.Match_Found_In_System__c;
            }
            dmlPrrs.add(
                new Property_Request_Record__c(
                    Id = prr.Id,
                    GEOES_results__c                            = prr.GEOES_results__c,
                    GEOES_Inventory_Source__c                   = prr.GEOES_Inventory_Source__c,
                    GEOES_Legacy_Provider__c                    = prr.GEOES_Legacy_Provider__c,
                    Development_Status__c                       = prr.Development_Status__c,
                    GEOES_Latitude_Coordinate__c                = prr.GEOES_Latitude_Coordinate__c,
                    GEOES_Longitude_Coordinate__c               = prr.GEOES_Longitude_Coordinate__c,
                    Match_Found_In_System__c                    = matchFoundInSystem,
                    New_Property_Created__c                     = prr.New_Property_Created__c,
                    Duplicate_Property_Found__c                 = prr.Duplicate_Property_Found__c,
                    isProcessed__c                              = true,
                    Existing_Property_found_in_SF_with_PRR__c   = prr.Existing_Property_found_in_SF_with_PRR__c
                )
            );
        }

        return dmlPrrs;
    }
    
    private static List<Property_Request_Record__c> getPropertyRequestRecords(
        Set<Id> prrIds
    ) {
        return [
            SELECT
                Id,Name,
            	Region__c,
            	Market__c,
                Data_Source__c,
                GPSLatitude__c,
                GPSLongitude__c,
                GEO_LATITUDE__c,
                GEO_LONGITUDE__c,
                User_Latitude__c,
                User_Longitude__c,
                ManagerFirstName__c,
                ManagerLastName__c,
                Owner_Contact_Name__c,
                User_Contact_First_Name__c,
                User_Contact_Last_Name__c,
                ProjectAddress__c,
                ProjectCity__c,
                ProjectState__c,
                STREET__c,
                CITY__c,
                STATE__c,
                ProjectZIP__c,
                County__c,
                User_Property_Address__c,
                User_Property_City__c,
                User_Property_State__c,
                User_Property_Zip_Code__c,
                User_Property_Structure__c,
            	User_Property_Type__c,
            	User_Number_of_Living_Units__c,
            	Property_Age_In_Years__c,
            	Preferred_Contact_Method__c,
            	User_First_Occupancy_Date__c,
            	User_Construction_Start_Date__c,
            	User_Construction_Completion_Date__c,
                Transaction_Summary__c,
                Match_Found_In_System__c,
                isProcessed__c,
                COUNTRY__c,
                ZIP_CODE__c,
                COUNTY_1__c,
                GEOES_results__c,
                BEST_PROP_ADDR__c,
                BEST_PROP_CITY__c,
                BEST_PROP_STATE__c,
                BEST_PROP_ZIP__c,
                BEST_PROP_NM__c,
                Duplicate_Property_Found__c,
                GEOES_Inventory_Source__c,
                GEOES_Legacy_Provider__c,
                Development_Status__c,
                New_Property_Created__c,
                GEOES_Latitude_Coordinate__c,
                GEOES_Longitude_Coordinate__c,
                Existing_Property_found_in_SF_with_PRR__c,
            	CS_SBS_Tech_Module__c, CS_HH_Field__c, CS_FOD_Field__c, CS_Property_Type__c, CS_Legacy_CDG_ID__c, CS_External_Source_ID__c, //QFCJ-4554
            	CS_Property_Name__c, CS_Location__c, CS_City__c, CS_State__c, CS_Zip__c, //QFCJ-4554
            	CS_MSK_ID_1__c, CS_MSK_ID_2__c, CS_MSK_ID_3__c, CS_MSK_ID_4__c, CS_MSK_ID_5__c //QFCJ-4554
            FROM Property_Request_Record__c
            WHERE Id IN :prrIds
        ];
    }
}//end class CreatePropertyFromPrrQueueable