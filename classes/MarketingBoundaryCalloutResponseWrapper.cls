public with sharing class MarketingBoundaryCalloutResponseWrapper {
	
    public parcelMarketingBoundary parcelMarketingBoundary;
	 
    public class parcelMarketingBoundary{
        public String marketingBoundaryName{get;set;}
    	public Integer marketingBoundaryId{get;set;}
    }
    
    
    public static MarketingBoundaryCalloutResponseWrapper parse(String jsonBody) {
        return (MarketingBoundaryCalloutResponseWrapper) System.JSON.deserialize(
            jsonBody,
            MarketingBoundaryCalloutResponseWrapper.class
        );
    }
}