public class PropertyCreationTelcoQueueable implements Queueable, Database.AllowsCallouts {     
    public Set<Id> propertyIds;
    public Set<Id> propertyIdsToProcess;
    public Set<Id> processedPropertyIds;
    public PropertyCreationTelcoQueueable(Set<Id> propertyIds) {
        this.propertyIds = propertyIds;
        this.propertyIdsToProcess = new Set<Id>(propertyIds);
        this.processedPropertyIds = new Set<Id>();
    }
    public void execute(QueueableContext context) {
        System.debug('(PropertyCreationTelcoQueuable.execute~started) this.propertyIdsToProcess null or Empty? ' + (this.propertyIdsToProcess == null || this.propertyIdsToProcess.isEmpty()));
        if(this.propertyIdsToProcess == null || this.propertyIdsToProcess.isEmpty()) {
            return;
        }

        System.debug('(PropertyCreationTelcoQueuable.execute~After-check-null/Empty) Set propertyIdList based on this.propertyIdsToProcess');
        List<Id> propertyIdList = new List<Id>(this.propertyIdsToProcess);
        System.debug('(PropertyCreationTelcoQueuable.execute~After-new-propertyIdList) Get Id propertyId from first item before removing it from list');
        Id propertyId = propertyIdList.remove(0);
        System.debug('(PropertyCreationTelcoQueuable.execute~After-remove) Removed first item from this.propertyIdsToProcess ');
        this.propertyIdsToProcess = new Set<Id>(propertyIdList);

        System.debug('(PropertyCreationTelcoQueuable.execute~After-set-this.propertyIdsToProcess-to-Set<Id>-from-propertyIdList) Query for list of properties based on Id of propertyId from first item in propertyIdList');
        List<Property__c> properties = [
            SELECT 
                County_Code__c, 
                APN__c, 
                State_Code__c,
                Property_Unique_ID__c,
                Unique_Id__c,
                Latitude__c,
                Longitude__c,
                Transaction_Summary__c,
                Initial_Source_Region__c,
                ocnName__c,
                LQ_Region_Parameter__c,
                Network_Wire_Center__c
            FROM Property__c 
            WHERE Id = :propertyId
        ];
        System.debug('(PropertyCreationTelcoQueuable.execute~After-query) Construct instance of BatchToProcessPropertiesForAddTelco');
        BatchToProcessPropertiesForAddTelco telcoBatch = new BatchToProcessPropertiesForAddTelco(
            true
        );
        System.debug('(PropertyCreationTelcoQueuable.execute~After-construct-instance) Execute BatchToProcessPropertiesForAddTelco instance with properties from query');
        telcoBatch.execute(
            null,
            properties
        );
        System.debug('(PropertyCreationTelcoQueuable.execute~After-execute-telcoBatch) Finish BatchToProcessPropertiesForAddTelco');
        telcoBatch.finish(null);
        if(new Map<Id, Property__c>(
                telcoBatch.propertiesToBeUpdated
            ).containsKey(propertyId)
        ) {
	        System.debug('(PropertyCreationTelcoQueuable.execute~telcoBatch.propertiesToBeUpdated-containsKey-propertyId) add propertyId to this.processedPropertyIds');
            this.processedPropertyIds.add(propertyId);
        }
        System.debug('(PropertyCreationTelcoQueuable.execute~After-containsKey) !this.propertyIdsToProcess.isEmpty()' + !this.propertyIdsToProcess.isEmpty());
        if(!this.propertyIdsToProcess.isEmpty()) {
            if(Test.isRunningTest()) {
                this.execute(null);
            } else {
		        System.debug('(PropertyCreationTelcoQueuable.execute~this.propertyIdsToProcess-NOT-Empty) enqueueing this job again because more to process');
                System.enqueueJob(this);
            }
        } else if(!this.processedPropertyIds.isEmpty()) { 
            if(Test.isRunningTest()) {
                new PropertyCreation1gQueueable(
                        this.processedPropertyIds
                    ).execute(null);
            } else {
		        System.debug('(PropertyCreationTelcoQueuable.execute~this.processedPropertyIds-NOT-Empty) enqueueing PropertyCreation1gQueueable');
                System.enqueueJob(
                    new PropertyCreation1gQueueable(
                        this.processedPropertyIds
                    )
                );
            }
        }
    }


}