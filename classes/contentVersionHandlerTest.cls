@isTest
public class contentVersionHandlerTest {
     @testSetup static void setupTestData(){
        List<Property__c> properties =TestDataFactory.createProperties(NULL,NULL,'FL',NULL,NULL,NULL,NULL,NULL,1,false);
        	insert properties;
        List<Opportunity> opportunities=TestDataFactory.createOpportunities('TESTCCT','Greenfield','Contracting',Date.today().addDays(5),properties[0].id,1,TRUE);
        List<Capital_Design__c> capitalDesigns = TestDataFactory.createCapitalDesigns(opportunities[0].id,1,FALSE);
          insert capitalDesigns; 
     }
	
    @isTest
    public static void testinsertContentVersion() {
        Test.startTest();
        List<Capital_Design__c> capitalDesigns = [select id from Capital_Design__c];
        ContentVersion cv=new Contentversion();
        cv.title='TestFile.pdf';
        cv.PathOnClient ='TestPath';
        Blob b=Blob.valueOf('Unit Test Attachment Body');
        cv.versiondata=EncodingUtil.base64Decode('Unit Test Attachment Body');
        cv.FirstPublishLocationId=capitalDesigns[0].id;
        insert cv;
        Test.stopTest();
		}
}