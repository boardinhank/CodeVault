public class leadTriggerHelper {
    
    public static void setLeadSource(list<lead> newLeads){
        
        for(lead newLead : newLeads){
            if(newLead.Lead_Type__c == 'Hand Raised' && newLead.LeadSource != 'Employee Referral' && newLead.LeadSource != 'Internal Referral'){
                newLead.LeadSource = 'Web Form';
            } 
        }
        
    }
}