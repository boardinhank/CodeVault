@isTest
public class leadTriggerHelperTest {
    
    @isTest    
    static void setLeadSourceEmployee(){
        lead newLead = new lead(
        	firstname = 'test',
            lastname = 'test',
            company = 'test',
            lead_type__c = 'Hand Raised',
            leadSource = 'Employee Referral'
        );
        
        insert newLead;
        lead getLead = [select id, leadsource from lead where id = :newLead.id];
        system.assert(getLead.leadSource == 'Employee Referral');
    }
    
        @isTest    
    static void setLeadSourceInternal(){
        lead newLead1 = new lead(
        	firstname = 'test1',
            lastname = 'test1',
            company = 'test1',
            lead_type__c = 'Hand Raised',
            leadSource = 'Internal Referral'
        );
        
        insert newLead1;
        lead getLead1 = [select id, leadsource from lead where id = :newLead1.id];
        system.assert(getLead1.leadSource == 'Internal Referral');
    }
    
            @isTest    
    static void setLeadSourceWebForm(){
        lead newLead2 = new lead(
        	firstname = 'test2',
            lastname = 'test2',
            company = 'test2',
            lead_type__c = 'Hand Raised',
            leadSource = ''
            
        );
        
        insert newLead2;
        lead getLead2 = [select id, leadsource from lead where id = :newLead2.id];   
        system.assert(getLead2.leadSource == 'Web Form');
    }
    

}