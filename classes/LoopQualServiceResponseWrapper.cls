public class LoopQualServiceResponseWrapper {
	/*public boolean success{get;set;}
	public cls_status status{get;set;}
	public String referenceNumber{get;set;}	//ORN-15954218606238487
	public String qualificationResult{get;set;}	//SUCCESS
	public String serviceAddress{get;set;}*/
    public List<cls_qualifiedServices> qualifiedServices{get;set;}
	/*public boolean isRooftop{get;set;}*/
    
	/*public class cls_status {
		public String statusCode{get;set;}	//200
		public String reasonCode{get;set;}	//
		public String message{get;set;} //Success
	}*/
	public class cls_qualifiedServices {
		public String serviceCategory{get;set;}	//DATA
		public cls_serviceCharacteristic[] serviceCharacteristic{get;set;}
	}
	public class cls_serviceCharacteristic {
		public String name{get;set;}//downSpeed
		public String value{get;set;}	//940
		//public String uom{get;set;}//Mbps
	}
			
	public static LoopQualServiceResponseWrapper parse(String json){
		return (LoopQualServiceResponseWrapper) System.JSON.deserialize(json, LoopQualServiceResponseWrapper.class);
	}
}