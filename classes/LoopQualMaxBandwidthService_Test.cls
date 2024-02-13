@isTest
public class LoopQualMaxBandwidthService_Test {

    @IsTest
    static void getMaxBandwidthTest(){
        String requestId='t12346';
        String houseNumber='3080';
        String streetName='VINELAND RD';
        String unit='PORTED TN';
        String floor='';
        String building='';
        String city='KISSIMMEE';
        String state='FL';
        String network='CTL';
        String isCache='N';
        String messageSrcSystem='BLUEMARBLE';
        
        Test.startTest();
        LoopQualMaxBandwidthService lqmbs = new LoopQualMaxBandwidthService(requestId, houseNumber, streetName, unit, floor, building, city, state, network, isCache, messageSrcSystem);
        Decimal maxBandwidth = lqmbs.getMaxBandwidthInfo();
        System.debug('testMB: ' + maxBandwidth);
        
        System.assertEquals(1.5, maxBandwidth, 'Test data should be equal');
        Test.stopTest();
    }
}