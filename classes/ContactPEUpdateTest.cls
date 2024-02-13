@isTest
public class ContactPEUpdateTest {
    // public static final String phoneservice='phonecheck';
     //public static final String emailservice='emailcheck';    
     public static final String insertfun='insertion';
     public static final String updatefun='updation';
    static testmethod void createContact(){      
        string apiname ='SolicitVerification';     
        Contact load=new Contact();    
        load.FirstName = 'Test Case01';
        load.LastName = 'test';       
        load.Phone = '(222)555-1212';
        load.Email = 'crsmith1@qwest.net';
        insert load;       
  	    Test.startTest();
     			  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
                		ContactPEHandler1 bs4 = new ContactPEHandler1(insertfun,load);
              			ContactPEHandler1 bs6 = new ContactPEHandler1(insertfun,load);
                        system.enqueueJob(bs4); 
          			    system.enqueueJob(bs6); 
        Test.stopTest();
        
    } 
    static testmethod void createLead1(){
       
        string apiname ='SolicitVerificationn';
      
        Contact load1=new Contact();
        load1.FirstName = 'Test Case01';
        load1.LastName = 'test';
       // load1.Company = 'ARMGASYS, INC';
      //  load1.Status = 'Open';
    
        load1.Phone = '(222)555-1212';
        load1.Email = 'carpetguy2648@home.com';
        insert load1;
        load1.Phone ='(972)310-7711';
        load1.Email = '';
        update load1;
  	    Test.startTest();
     			  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
  			      ContactPEHandler1 ss = new ContactPEHandler1(insertfun,load1); 
			      ContactPEHandler1 ss2 = new ContactPEHandler1(updatefun,load1);
              
         ContactPEHandler1 ss5 = new ContactPEHandler1(updatefun,load1);
        ContactPEHandler1 ss6 = new ContactPEHandler1(updatefun,load1);
        			system.enqueueJob(ss);
       				 system.enqueueJob(ss2);   
              system.enqueueJob(ss5);
        system.enqueueJob(ss6);
        Test.stopTest();
    } 
     static testmethod void createContact2(){
       
        string apiname ='SolicitVerificationnn';
      
        Contact load1=new Contact();
        load1.FirstName = 'Test Case01';
        load1.LastName = 'test';
       
    
        load1.Phone = '(222)555-1212';
        load1.Email = 'carpetguy2648@home.com';
        insert load1;
        load1.Phone ='';
        load1.Email = '';
        update load1;
  	    Test.startTest();
     			  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
  			      ContactPEHandler1 ss = new ContactPEHandler1(insertfun,load1);
			      ContactPEHandler1 ss2 = new ContactPEHandler1(updatefun,load1);
               		
         		 ContactPEHandler1 ss5 = new ContactPEHandler1(updatefun,load1);
                 ContactPEHandler1 ss6 = new ContactPEHandler1(updatefun,load1);
        			system.enqueueJob(ss);
       				 system.enqueueJob(ss2);   
      
         				 system.enqueueJob(ss5);
         				 system.enqueueJob(ss6);
        Test.stopTest();
    } 
    static testmethod void createContact3(){
       
        string apiname ='SolicitVerificationnn';
      
        Contact load1=new Contact();
        load1.FirstName = 'Test Case01';
        load1.LastName = 'test';
        
    
        load1.Phone = '';
        load1.Email = '';
        insert load1;
        load1.Phone ='(972)310-7711';
        load1.Email = 'carpetguy2648@home.com';
        update load1;
  	    Test.startTest();
     			  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
  			      ContactPEHandler1 ss = new ContactPEHandler1(insertfun,load1);
			      ContactPEHandler1 ss2 = new ContactPEHandler1(Updatefun,load1);
               		
         		 ContactPEHandler1 ss5 = new ContactPEHandler1(updatefun,load1);
                 ContactPEHandler1 ss6 = new ContactPEHandler1(updatefun,load1);
        			system.enqueueJob(ss);
       				 system.enqueueJob(ss2);   
      
         				 system.enqueueJob(ss5);
         				 system.enqueueJob(ss6);
        Test.stopTest();
    } 
}