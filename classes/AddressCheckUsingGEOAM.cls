public with sharing class AddressCheckUsingGEOAM {
	Static Final String GEOAM = 'GEOAM';
    @AuraEnabled
    public static object geoamservercall(String searchStr){
	    
        Map<String, String> queryParamMap = new Map<String, String>();
        queryParamMap.put('q', searchStr+'&maxResults=5');
        APITransactionController objApiTransactionCtrl = new APITransactionController(
        GEOAM,
        null,
        queryParamMap,
        null
        );
        HttpResponse httpResponse = APITransactionController.serviceCallout();
        return httpResponse.getBody();

    }
    /*@auraEnabled(continuation=true)
    public static object processGEOAMResponse(List<String> labels){
        
        try{
            HttpResponse httpResponse = Continuation.getResponse(labels.get(0));
            system.debug('@@ResponseBody: '+httpResponse); 
            system.debug('@@ResponseBody: '+httpResponse.getbody()); 
            if(httpResponse.getStatusCode()==200)
                return (object)JSON.deserializeUntyped(httpResponse.getBody());
            else
                return null;
        }catch(exception e){
            return null;
        }
    }*/
}