public class LeadPEHandlerWrapper {
	public String tnOptOut {get;set;}
    public String emailOptOut {get;set;}   
    public String emailDivestetureOptOut {get;set;}  
     public String nameDivestetureOptOut {get;set;}  
    class cls_errors {
        public String field;    
        public String message;    
    }
    public static LeadPEHandlerWrapper parse(String json){
        return (LeadPEHandlerWrapper) System.JSON.deserialize(json, LeadPEHandlerWrapper.class);
    }
}