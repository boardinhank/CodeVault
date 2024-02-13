@isTest
public class TriggerDispatcherTest {
    
    @isTest static void testRunMethod(){
 
        TriggerDispatcher.run(new CapitalDesignTriggerHandler(), 'CapitalDesignTrigger', null);
    }
    
    @isTest static void testRunMethod2(){
 
        TriggerDispatcher.run(new PropertyReqRecordTriggerHandler());
    }

}