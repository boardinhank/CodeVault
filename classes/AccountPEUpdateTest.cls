/***************************************************************
AUTHOR     DATE         Reference     Description (TestClass)
Sravya S   27/09/2022   ESCJ-1926    Call DONT/EERS realtime when a new account is created or an existing account is updated.
***************************************************************/

@isTest
public class AccountPEUpdateTest {
    public static final String insertfun='insertion';
    public static final String updatefun='updation';
    static testmethod void createAccount(){      
        string apiname ='SolicitVerification';
        Account accRec = new Account();
        accRec.Name = 'SANDLER TRAINING';
       // accRec.Phone = '3256561714';
        insert accRec;      
        accRec.Name = 'SANDLER';
        accRec.Phone = '2102683600';
        update accRec;
        accRec.Name = 'ARMGASYS,INC';
        accRec.Phone = '';
        update accRec;
    Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname));
            AccountPEHandler bs1 = new AccountPEHandler(insertfun,accRec);
            AccountPEHandler bs2 = new AccountPEHandler(insertfun,accRec);
             system.enqueueJob(bs1); 
          	 system.enqueueJob(bs2); 
        Test.stopTest();   
    }
    static testmethod void createAccount1(){      
        string apiname ='SolicitVerificationnn';
        Account accRec1 = new Account();
        accRec1.Name = 'BOISE';
        accRec1.Phone = '8062062113';
        insert accRec1;      
        accRec1.Name = 'Test1';
        accRec1.Phone = '8178100175';
        update accRec1;
        accRec1.Name = 'ARMGASYS,INC';
        accRec1.Phone = '';
        update accRec1;
        accRec1.Name = 'CHAIN';
        accRec1.Phone = '3256561714';
        update accRec1;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(apiname)); 
                AccountPEHandler ss = new AccountPEHandler(insertfun,accRec1); 
			    AccountPEHandler ss1 = new AccountPEHandler(updatefun,accRec1);
                AccountPEHandler ss2 = new AccountPEHandler(updatefun,accRec1);
                AccountPEHandler ss3 = new AccountPEHandler(updatefun,accRec1);
        		system.enqueueJob(ss);
       			system.enqueueJob(ss1);   
                system.enqueueJob(ss2);
                system.enqueueJob(ss3);
    Test.stopTest();      
    }
}