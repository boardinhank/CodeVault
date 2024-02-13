/* ===============================================================
Purpose: Test class for SyncLeadPEHandler.apxc
AUTHOR     		DATE         Reference     Description
Pooja Kumari   10/14/2022         Test class for SyncLeadPEHandler.apxc
************************************************************** */
@istest
public class SyncLeadPEHandlerTest {
    public static final String insertfun='insertion';
    public static final String updatefun='updation';
    @istest
    public static void testdontEersCheck(){
        string apiname ='SolicitVerification';
        Lead load=new Lead();
        load.Company = 'Sachman';
        load.FirstName = 'Test Case01';
        load.LastName = 'test';
      
        load.Status = 'Open';
        
        load.Phone = '(222)555-1212';
        load.Email = 'ssr@sandler.com';
        insert load;
          test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
          SyncLeadPEHandler.dontEersCheck(insertfun, load.id);
          test.stopTest();
    }
	
    
    @istest
    public static void testdontEersCheck1(){
        string apiname ='SolicitVerificationn';
        Lead load=new Lead();
        load.Company = 'COLD CHAIN';
        load.FirstName = 'Test Case01';
        load.LastName = 'test';
      
        load.Status = 'Open';
        
        load.Phone = '(222)555-1212';
        load.Email = 'crsmith1@qwest.net';
        insert load;
          test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
  			      SyncLeadPEHandler.dontEersCheck(insertfun, load.id);
          test.stopTest();
    }
    @istest
    public static void testdontEersCheck2(){
        string apiname ='SolicitVerificationnn';
        Lead load=new Lead();
        load.Company = 'COLD CHAIN';
        load.FirstName = 'Test Case01';
        load.LastName = 'test';
      
        load.Status = 'Open';
        
        load.Phone = '(222)555-1212';
        load.Email = 'crsmith1@qwest.net';
        insert load;
          test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
           SyncLeadPEHandler.dontEersCheck(insertfun, load.id);
          test.stopTest();
    }
    @istest
    public static void testdontEersCheck3(){
        string apiname ='SolicitVerificationnnn';
        Lead load=new Lead();
        load.Company = 'COLD CHAIN';
        load.FirstName = 'Test Case01';
        load.LastName = 'test';
      
        load.Status = 'Open';
        
        load.Phone = '(222)555-1212';
        load.Email = '';
        insert load;
        load.Phone ='(972)310-7711';
        load.Email = 'bluemaxboat@hotmail.com';
        update load;
          test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
           SyncLeadPEHandler.dontEersCheck(updatefun, load.id);
          test.stopTest();
    }
    @istest
    public static void testdontEersCheck4(){
        string apiname ='SolicitVerificationnnn';
        Lead load1=new Lead();
        load1.FirstName = 'Test Case01';
        load1.LastName = 'test';
        load1.Company = 'ARMGASYS, INC';
        load1.Status = 'Open';
    
        load1.Phone = '(222)555-1212';
        load1.Email = '';
        insert load1;
        load1.Phone ='(972)310-7711';
        update load1;
          test.startTest();
          Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
           SyncLeadPEHandler.dontEersCheck(updatefun, load1.id);
          test.stopTest();
    }
}