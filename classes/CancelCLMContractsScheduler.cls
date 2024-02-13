/***************************************************************************************************
 * Name:  CancelCLMContractScheduler
 * Platform: Salesforce Connected Journey (SFCJ)
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 12/14/2023   Kuehl       QFCJ-4697                       Cancel CLM contracts in Agioft by using SFCJ Contract records criteria
 *
****************************************************************************************************/
global with sharing class CancelCLMContractsScheduler implements Schedulable 
{ 
    global void execute(SchedulableContext sc) 
    {        
        ID lv_BatchProcessdId = Database.executeBatch(new CancelCLMContracts());
    }    
}