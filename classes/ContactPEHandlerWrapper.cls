public class ContactPEHandlerWrapper {
    
   	public String tnOptOut {get;set;}
    public String emailOptOut {get;set;}   
    public String emailDivestetureOptOut {get;set;}      
    class cls_errors {
        public String field;    
        public String message;    
    }
    public static ContactPEHandlerWrapper parse(String json){
        return (ContactPEHandlerWrapper) System.JSON.deserialize(json, ContactPEHandlerWrapper.class);
    }        
}