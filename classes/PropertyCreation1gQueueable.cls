public class PropertyCreation1gQueueable implements Queueable, Database.AllowsCallouts {     
    public Set<Id> propertyIds;
    public Set<Id> propertyIdsToProcess;
    public PropertyCreation1gQueueable(Set<Id> propertyIds) {
        this.propertyIds = propertyIds;
        this.propertyIdsToProcess = new Set<Id>(propertyIds);
    }
    public void execute(QueueableContext context) {
        System.debug('(PropertyCreation1gQueueable.execute~started) this.propertyIdsToProcess null or Empty? ' + (this.propertyIdsToProcess == null || this.propertyIdsToProcess.isEmpty()));
        if(this.propertyIdsToProcess == null || this.propertyIdsToProcess.isEmpty()) {
            return;
        }

        List<Id> propertyIdList = new List<Id>(this.propertyIdsToProcess);
        Id propertyId = propertyIdList.remove(0);
        this.propertyIdsToProcess = new Set<Id>(propertyIdList);

        
        List<Property__c> properties = [
            SELECT 
                County_Code__c, 
                APN__c, 
                State_Code__c,
                Property_Unique_ID__c,
                Unique_Id__c,
                LQ_Region_Parameter__c,
                Network_Wire_Center_Name_Text__c,
                Property_Auto_Gen_Number__c,
                Transaction_Summary__c
            FROM Property__c 
            WHERE Id = :propertyId
        ];
        BatchToProcessPropertiesFor1GService oneGBatch = new BatchToProcessPropertiesFor1GService(
            true
        );
        System.debug('(PropertyCreation1gQueueable.execute~After-construct-instance) Execute BatchToProcessPropertiesFor1GService instance with properties from query');
        oneGBatch.execute(
            null,
            properties
        );
        System.debug('(PropertyCreation1gQueueable.execute~After-construct-instance) Finish execute BatchToProcessPropertiesFor1GService');
        oneGBatch.finish(null);
        /*if(this.propertyIdsToProcess.isEmpty()) {
            return;
        }
        System.enqueueJob(this);*/
        System.debug('(PropertyCreation1gQueueable.execute~After-finish-batch) propertyId!=null? ' + (propertyId!=null));
        if(propertyId!=null) {
		        System.debug('(PropertyCreation1gQueueable.execute~After-propertyId!=null) Constructing instance of MarketingBoundaryCalloutservice with propertyId = ' + propertyId);
                MarketingBoundaryCalloutservice boundaryQueueable = new MarketingBoundaryCalloutservice(
                    propertyId
                );
                if(Test.isRunningTest()) {
                    boundaryQueueable.execute(null);
                } else {
			        System.debug('(PropertyCreation1gQueueable.execute~After-constructing-MarketingBoundaryCalloutservice) enqueueing MarketingBoundaryCalloutservice');
                    System.enqueueJob(boundaryQueueable);
                }
            }
    }


}