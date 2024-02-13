@isTest
public class CreatePropertySuccessControllerTest {
    @isTest public static void testDontEersSuccess(){
          string apiname ='SolicitVerification';
        Lead load=new Lead();
        load.Company = 'Sachman';
        load.FirstName = 'Test Case01';
        load.LastName = 'test';
      
        load.Status = 'Open';
        
        load.Phone = '(222)555-1212';
        load.Email = 'ssr@sandler.com';
        insert load;
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('confirmationNo',load.Id);
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
        CreatePropertySuccessController dontEers = new CreatePropertySuccessController();
        dontEers.calldontEersCheck();
        test.stopTest();
    }

}