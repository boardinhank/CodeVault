public class LoopQualMaxBandwidthServiceRespWrapper {

    public lq_maxQualifiedSpeeds maxQualifiedSpeeds{get;set;}

	public class lq_maxQualifiedSpeeds {
		public lq_ipSpeeds[] ipSpeeds{get;set;}
	}
    
	public class lq_ipSpeeds {
		//public String niiCode{get;set;}	// FTTN-ETH-V2-PB
		//public String upSpeed{get;set;}	// 1000
		public String downspeed{get;set;}	// 80000
	}
			
	public static LoopQualMaxBandwidthServiceRespWrapper parse(String json){
		return (LoopQualMaxBandwidthServiceRespWrapper) System.JSON.deserialize(json, LoopQualMaxBandwidthServiceRespWrapper.class);
	}
}