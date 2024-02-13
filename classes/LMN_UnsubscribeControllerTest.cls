@isTest
public class LMN_UnsubscribeControllerTest {
    
 @TestSetup
    static void createRecords(){

        lead leadOne = new lead(
            firstname = 'test',
            lastname = 'one',
            email = 'testone@email.com',
            company = 'testOne'

        );
        insert leadOne;
        system.assertNOTEquals(leadOne.id, null);

        lead leadOneDup = new lead(
            firstname = 'dup',
            lastname = 'one',
            email = 'testone@email.com',
            company = 'testOne'
            
         );
         insert leadOneDup;
         system.assertNOTEquals(leadOneDup.id, null);

         lead leadTwo = new lead(
             firstname = 'test',
             lastname = 'two',
             email = 'testtwo@email.com',
             company = 'testOne'
             
     );
     insert leadTwo;
     system.assertNOTEquals(leadTwo.id, null);

         contact contactOne = new contact(
            firstname = 'test',
            lastname = 'one',
            email = 'testcontactone@email.com'

         );
         insert contactOne;
         system.assertNOTEquals(contactOne.id, null);

         contact contactOneDup = new contact(
             firstname = 'dup',
             lastname = 'one',
             email = 'testcontactone@email.com'
         
          );
          insert contactOneDup;
          system.assertNOTEquals(contactOneDup.id, null);

          contact contactTwo = new contact(
              firstname = 'test',
              lastname = 'two',
              email = 'testcontacttwo@email.com'

       );
       insert contactTwo;
       system.assertNOTEquals(contactTwo.id, null);
        
    }

    @isTest
    static void matchingEmails(){

        string leadEmail = 'testone@email.com';
        string conEmail = 'testContactone@email.com';

        LMN_UnsubscribeController.searchAllLeads(leadEmail);
        LMN_UnsubscribeController.searchAllContacts(conEmail);

        list<lead> getLeads = [select Id, HasOptedOutOfEmail from lead where email = :leadEmail and HasOptedOutOfEmail = true];

        system.assertEquals(getLeads.size(),2);

        list<contact> getContacts = [select Id, HasOptedOutOfEmail from contact where email = :conEmail and HasOptedOutOfEmail = true];

        system.assertEquals(getContacts.size(),2);

    }

	@isTest
    static void testLeadURL(){       
        
        lead getLead = [select id, lastname from lead limit 1];

        LMN_UnsubscribeController.optOutRecords(getLead.id, getLead.lastname);       
        
    }

    @isTest
    static void testContactURL(){

        contact getContact = [select id, lastname from contact limit 1];
                
        LMN_UnsubscribeController.optOutRecords(getContact.id, getContact.lastname);       
        
    } 

    @isTest
    static void tryCatchCoverage(){
        
        string junkid = '00312345';
        string junklastname = '12345';   
        
        LMN_UnsubscribeController.optOutRecords(junkId, junklastname); 
        
        junkid = '00Q12345';
        junklastname = '12345';   
        
        LMN_UnsubscribeController.optOutRecords(junkId, junklastname); 
        
    }
    
    @isTest
    static void tryCatchOffset(){
        LMN_UnsubscribeController.tryCatchOffset();
    }



}