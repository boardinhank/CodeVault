/**
****************************************************************** 
Author    *      UserStory   *    Date         *       Description 
Sambasiva	     ESCj-1924        10/4/2022			Contact Update - DONT EERS
**/

public class ContactPEUpdate1 {
    
     public static final String insertfun='insertion';
     public static final String updatefun='updation';
    
   /* public static void ContactPEHelperInsert(Map<Id,Contact> newaccMap){
        for(Contact cont:newaccMap.values()){
           System.enqueueJob(new ContactPEHandler1(insertfun,cont));           
        }
     }  */
    
     public static void ContactPEHelperUpdate(Map<Id,Contact> newaccMap, Map<Id,Contact> oldaccMap){
        
        for(Contact cont:newaccMap.values()){
            Contact oldContact = oldaccMap.get(cont.id);
          	if (oldContact != null && (oldContact.phone != cont.Phone || oldContact.email != cont.Email)) {
          		System.enqueueJob(new ContactPEHandler1(updatefun,cont));
            }
        }
    }
  }