/***************************************************************
AUTHOR     DATE         Reference     Description
Sravya S   27/09/2022   ESCJ-1926    Call DONT/EERS realtime when a new account is created or an existing account is updated.
***************************************************************/

public class AccountPEHandlerWrapper {
public String nameDivestetureOptOut {get;set;}    
public String tnOptOut {get;set;}  
   class cls_errors {
    public String field;    
    public String message;    
}
public static AccountPEHandlerWrapper parse(String json){
    return (AccountPEHandlerWrapper) System.JSON.deserialize(json, AccountPEHandlerWrapper.class);
}        
}