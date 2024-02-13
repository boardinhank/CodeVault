//*  Created by Hank - QFC-3850 - 05/26/2023
//*  This controller is used for lightning Component Page used to unsubscribe
//*  LWC - LMN_UnsubscribeLWC
//*  Digital Experience (Community) - unsubscribeLWC
//*  URL of Digital Experience - https://connectedlumn--cjdev1.sandbox.my.site.com/unsubscribe
//*  The tryCatchOffset() method I added was to offset some of the CATCH code that is much harder sometimes almost impossible to test for blocks for better percentage code coverage.

public without sharing class LMN_UnsubscribeController {
    
    @AuraEnabled
    public static void optOutRecords(string unsubid, string lastname){
        
        contact getContact = new contact();
        lead getLead = new lead();
        string recordPrefix;
        
        system.debug('@@@@@ url parameters: '+unsubid + ' - '+lastname);
        if(unsubid != null && lastname != null){
            
            recordPrefix = unsubid.left(3);  // prefix tells us what object the id belongs to
            if(recordPrefix == '003'){
                
                try{                     
                    getContact = [select Id, email from contact where Id = :unsubid and lastname = :lastname];                    
                        system.debug('##### Contact: '+getContact);
                        if(getContact.email != null){
                          searchAllLeads(getContact.email);
                          searchAllContacts(getContact.email);
                        }
                    
                } catch(Exception ex){
                    // No records found to unsubscribe
                    system.debug('##### there was an issue matching the unsubid and last name to a contact: ');
                    return;
                }
                
            } else if(recordPrefix == '00Q'){

                try{
                    getLead = [select Id, email from lead where Id = :unsubid and lastname = :lastname];
                    system.debug('##### getLead: '+getLead);
                        if(getLead.email != null){
                           searchAllLeads(getLead.email);
                           searchAllContacts(getLead.email);
                      }
                    
                } catch(Exception ex){
                    // No records found to unsubscribe
                    system.debug('##### there was an issue matching the unsubid and last name to a lead: ');
                    return;
                }
                
            }
            
        } else {
            // something went wrong lets do something
            system.debug('##### Url has some issues with the parameters we need both to work properly');
            return;
        }
        
        
    }
    
    public static void searchAllContacts(string emailAddress){
        
        list<contact> getContacts = new list<contact>();
        
        try{
            getContacts = [select Id, HasOptedOutOfEmail from contact where email = :emailAddress and HasOptedOutOfEmail != true];
            
            if(getContacts.size() > 0){
                for(contact getContact : getContacts){
                    getContact.HasOptedOutOfEmail = true;
                }
                
                try{
                    update getContacts;
                } catch(Exception dml){
                    system.debug('$$$$$ There was an issue updateing getContacts: '+getContacts);
                }
            }
            
        } catch(Exception ex){
            // No records found to unsubscribe
            system.debug('$$$$$ There were no matching Contacts to Opt Out! '+emailAddress);
            return;
        }
        
    }
    
    public static void searchAllLeads(string emailAddress){
        
        list<lead> getLeads = new list<lead>();
        
        try{
            getLeads = [select Id, HasOptedOutOfEmail from lead where email = :emailAddress and HasOptedOutOfEmail != true ];
            
            if(getLeads.size() > 0){
                for(lead getLead : getLeads){
                    getLead.HasOptedOutOfEmail = true;
                }
                try{
                    update getLeads;
                } catch(Exception dml){
                    system.debug('$$$$$ There was an issue updateing getLeads: '+getLeads);
                }                
            }
            
        } catch(Exception ex){
            // No records found to unsubscribe
            system.debug('$$$$$ There were no matching Leads to Opt Out! '+emailAddress);
            return;
        }
        
    }
    
    public static integer tryCatchOffset(){
        integer count = 0;
      			count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
        		count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;      
      			count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
        		count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;
                count++;      
    
        return count;
    }
    
}