public class BIWQualificationServiceResponseWrapper {
	
    /*public String errCode{get;set;}
	public String errMessage{get;set;}
	public String id{get;set;}//19
	public String status{get;set;}	//IN SERVICE
	public String reason{get;set;}
	public String availabiltyDate{get;set;}	//2022-06-30*/
	public String bandwidth{get;set;}	//1000
	/*public String servingWireCenterClli{get;set;}	//WNGRFLXA
	public String servingWireCenterName{get;set;}	//WINTER GARDEN
	public String fiberCableId{get;set;}	//7.20591135116382e+1
	public String fiberLowStrand{get;set;}	//10
	public String fiberHighStrand{get;set;}
	//public String nDSJobNbr{get;set;}	//N
	//public String fWRKSJobNbr{get;set;}	//N
	public String serviceType{get;set;}	//BIWF
	public boolean digitalVoiceEnabled{get;set;}*/
		    
    public static BIWQualificationServiceResponseWrapper parse(String jsonBody) {
        return (BIWQualificationServiceResponseWrapper) System.JSON.deserialize(
            jsonBody,
            BIWQualificationServiceResponseWrapper.class
        );
    }
}