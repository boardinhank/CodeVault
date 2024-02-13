@isTest
public class LeadPEUpdateTest {
   //  public static final String phoneservice='phonecheck';
   //  public static final String emailservice='emailcheck';
   //  public static final String nameservice='namecheck';
     public static final String insertfun='insertion';
     public static final String updatefun='updation';
    static testmethod void createLead(){
       
        string apiname ='SolicitVerification';
      
        Lead load=new Lead();
        load.Company = 'COLD CHAIN';
        load.FirstName = 'Test Case01';
        load.LastName = 'test';
      
        load.Status = 'Open';
        
        load.Phone = '(222)555-1212';
        load.Email = 'crsmith1@qwest.net';
        insert load;
                       
		
        
  	    Test.startTest();
     			  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
  			      LeadPEHandler bs = new LeadPEHandler(insertfun,load);
  			            		  
               		LeadPEHandler bs4 = new LeadPEHandler(insertfun,load);
        			
        			LeadPEHandler bs6 = new LeadPEHandler(insertfun,load);
        			system.enqueueJob(bs);
       				// system.enqueueJob(bs2);
        			 //system.enqueueJob(bs3);
        				 system.enqueueJob(bs4); 
        				//	 system.enqueueJob(bs5); 
        						 system.enqueueJob(bs6); 
        Test.stopTest();
    } 
    static testmethod void createLead1(){
       
        string apiname ='SolicitVerificationn';
      
        Lead load1=new Lead();
        load1.FirstName = 'Test Case01';
        load1.LastName = 'test';
        load1.Company = 'ARMGASYS, INC';
        load1.Status = 'Open';
    
        load1.Phone = '(222)555-1212';
        load1.Email = 'carpetguy2648@home.com';
        insert load1;
        load1.Phone ='(972)310-7711';
        load1.Email = 'crsmith1@qwest.net';
        update load1;
  	    Test.startTest();
     			  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
  			      LeadPEHandler ss = new LeadPEHandler(insertfun,load1); 
			      LeadPEHandler ss2 = new LeadPEHandler(updatefun,load1);
               		 LeadPEHandler ss3 = new LeadPEHandler(insertfun,load1);
			      LeadPEHandler ss4 = new LeadPEHandler(updatefun,load1);
         LeadPEHandler ss5 = new LeadPEHandler(updatefun,load1);
        LeadPEHandler ss6 = new LeadPEHandler(updatefun,load1);
        			system.enqueueJob(ss);
       				 system.enqueueJob(ss2);   
        system.enqueueJob(ss3);
       				 system.enqueueJob(ss4);
        system.enqueueJob(ss5);
        system.enqueueJob(ss6);
        Test.stopTest();
    } 
     static testmethod void createLead2(){
       
        string apiname ='SolicitVerificationnn';
      
        Lead load1=new Lead();
        load1.FirstName = 'Test Case01';
        load1.LastName = 'test';
        load1.Company = 'ARMGASYSD, INC';
        load1.Status = 'Open';
    
        load1.Phone = '(222)555-1212';
        load1.Email = 'carpetguy2648@home.com';
        insert load1;
        load1.Phone ='(972)310-7711';
        load1.Email = 'bluemaxboat@hotmail.com';
        update load1;
  	    Test.startTest();
     			  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
  			      LeadPEHandler ss = new LeadPEHandler(insertfun,load1);
			      LeadPEHandler ss2 = new LeadPEHandler(updatefun,load1);
               		 LeadPEHandler ss3 = new LeadPEHandler(insertfun,load1);
			      LeadPEHandler ss4 = new LeadPEHandler(updatefun,load1);
         		 LeadPEHandler ss5 = new LeadPEHandler(updatefun,load1);
                 LeadPEHandler ss6 = new LeadPEHandler(updatefun,load1);
        			system.enqueueJob(ss);
       				 system.enqueueJob(ss2);   
        system.enqueueJob(ss3);
       				 system.enqueueJob(ss4);
         				 system.enqueueJob(ss5);
         				 system.enqueueJob(ss6);
        Test.stopTest();
    } 
    static testmethod void createLead3(){
       
        string apiname ='SolicitVerificationnn';
      
        Lead load1=new Lead();
        load1.FirstName = 'Test Case01';
        load1.LastName = 'test';
        load1.Company = 'ARMGASYSD, INC';
        load1.Status = 'Open';
    
        load1.Phone = '(222)555-1212';
        load1.Email = 'jaj@gmail.com';
        insert load1;
        load1.Phone ='(972)310-7711';
        load1.Email = 'ssr@sandler.com';
        update load1;
  	    Test.startTest();
     			  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
  			      LeadPEHandler ss = new LeadPEHandler(insertfun,load1);
			      LeadPEHandler ss2 = new LeadPEHandler(updatefun,load1);
               		 LeadPEHandler ss3 = new LeadPEHandler(insertfun,load1);
			      LeadPEHandler ss4 = new LeadPEHandler(updatefun,load1);
         		 LeadPEHandler ss5 = new LeadPEHandler(updatefun,load1);
                 LeadPEHandler ss6 = new LeadPEHandler(updatefun,load1);
        			system.enqueueJob(ss);
       				 system.enqueueJob(ss2);   
        system.enqueueJob(ss3);
       				 system.enqueueJob(ss4);
         				 system.enqueueJob(ss5);
         				 system.enqueueJob(ss6);
        Test.stopTest();
    } 
    static testmethod void createLead4(){
       
        string apiname ='SolicitVerificationnn';
      
        Lead load1=new Lead();
        load1.FirstName = 'Test Case01';
        load1.LastName = 'test';
        load1.Company = 'ARMGASYSD, INC';
        load1.Status = 'Open';
    
        load1.Phone = '';
        load1.Email = '';
        insert load1;
        load1.Phone ='(972)310-7711';
        load1.Email = '';
        update load1;
  	    Test.startTest();
     			  Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
  			      LeadPEHandler ss = new LeadPEHandler(insertfun,load1);
			      LeadPEHandler ss2 = new LeadPEHandler(updatefun,load1);
               		 LeadPEHandler ss3 = new LeadPEHandler(insertfun,load1);
			      LeadPEHandler ss4 = new LeadPEHandler(updatefun,load1);
         		 LeadPEHandler ss5 = new LeadPEHandler(updatefun,load1);
                 LeadPEHandler ss6 = new LeadPEHandler(updatefun,load1);
        			system.enqueueJob(ss);
       				 system.enqueueJob(ss2);   
        system.enqueueJob(ss3);
       				 system.enqueueJob(ss4);
         				 system.enqueueJob(ss5);
         				 system.enqueueJob(ss6);
        Test.stopTest();
    } 
    
    static testmethod void createLeadwithProprty(){
        
        Property__c newProp = new Property__c();
        newProp.Name = 'TestProperty';
        insert newProp;
        
        Lead newLead =new Lead();
        newLead.FirstName = 'Test';
        newLead.LastName = 'LeadProperty';
        newLead.Company = 'TestCompany';
        newLead.Status = 'Open';
        newLead.Property__c = newProp.Id;
        
        insert newLead;
        
        newLead.Property_Address__c='Test';
        newLead.Lead_Total_Units__c=123;
        
        update newLead;
    }
}