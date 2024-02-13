@isTest
public class AddressCheckUsingGEOAMTest {
    
    
    @isTest static void testgeoamservercall(){
        String q = '4926-4936 NE FREMONT ST PORTLAND OR';
        String GEOAM = 'GEOAM';
        Map<String, String> queryParamMap = new Map<String, String>();
        queryParamMap.put('q',q);
        Test.startTest();
        AddressCheckUsingGEOAM obj = new AddressCheckUsingGEOAM();
        String data = (String)AddressCheckUsingGEOAM.geoamservercall(q);
        Test.stopTest();
        System.assertNotEquals(data, null);
    }
}