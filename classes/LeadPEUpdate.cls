/**
 * @author  : Sambasiva Techm
 * @Description : Lead Insert and Update - DONT EERS
 * @Date : 10/04/2022
 *  
 * 
****************************************************************** 
Author    *      UserStory   *    Date         *       Description 
Sambasiva	 ESCj-1925        10/4/2022	       Lead Insert and Update - DONT EERS
**/
public class LeadPEUpdate {
    
     public static final String insertfun='insertion';
     public static final String updatefun='updation';
    
    /* public static void LeadPEHelperInsert(Map<Id,Lead> newaccMap){
        for(Lead lead:newaccMap.values()){
           System.enqueueJob(new LeadPEHandler(insertfun,lead));           
        }
     } */
     public static void updateCustomLead(Map<Id,Lead> newaccMap, Map<Id,Lead> oldaccMap){
      for(Lead lead:newaccMap.values()){
          if(lead.Custom_Lead__c == true){
              lead.Custom_Lead__c =false;
          }
      }
  }
     
     public static void LeadPEHelperUpdate(Map<Id,Lead> newaccMap, Map<Id,Lead> oldaccMap){
        
        for(Lead lead:newaccMap.values()){
            Lead oldLead = oldaccMap.get(lead.id);
          	if (oldLead != null && (oldLead.phone != lead.Phone || oldLead.email != lead.Email || oldLead.company != lead.Company)) {
          		System.enqueueJob(new LeadPEHandler(updatefun,lead));
            }
        }
    }
    
   }