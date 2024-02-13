/***************************************************************************************************
 * Name:  SF2SFConnectionController
 * Platform: Salesforce Connected Journey (SFCJ)
 * Controller class for BRAIN Financial Analyses interaction between SFCJ and BRAIN API
 * Code Coverage:  SF2SFConnectionController -- %  11/28/2022
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 11/28/2022  	T2Cabato    Feature(Epic) ESCJ-337	        Base version
 * 01/27/2023   T2Cabato    Story ESCJ-2365                 Revised per Story
****************************************************************************************************/
public with sharing class SF2SFConnectionController implements Queueable, Database.AllowsCallouts {
    public class InvalidParameterParsingException extends Exception {}
    public class InvalidHttpResponseException extends Exception {}
    public class UnauthorizedAccessException extends Exception {}
    public class UnhappyStatusCodeHttpResponseException extends Exception {}
	public List<SF2SFConnectionController.ConnectParams> connParamsList;
    public String sourceInstance;
    public String targetInstance;
    
    public SF2SFConnectionController(String sourceInstanceIn, String targetInstanceIn) {
        this.sourceInstance = sourceInstanceIn;
        this.targetInstance = targetInstanceIn;
        this.connParamsList = new List<SF2SFConnectionController.ConnectParams>();
        SF2SFConnectionController.ConnectParams cp = new SF2SFConnectionController.ConnectParams();
        cp.sourceInstance = this.sourceInstance;
        cp.targetInstance = this.targetInstance;
        this.connParamsList.add(cp);
    }//end constructor 
    
    public void execute(QueueableContext ctx) { 
		this.automatedIdentifyConnectionInfo(this.connParamsList);
        this.clearState();
    }//end method execute

    public class ConnectParams {
        @invocableVariable(label='Source SF Instance Name' description='The Name of the Source SF Instance (either SFCJ or SFAINT, but not same as Target SF Instance)' required=true)
        public String sourceInstance;
        @invocableVariable(label='Target SF Instance Name' description='The Name of the Target SF Instance (either SFCJ or SFAINT, but not same as Source SF Instance)' required=true)
        public String targetInstance;
    }
    
    @InvocableMethod(label='Identify Connection Info'
                     description='Identify Connection Info for SF-to-SF Connection'
                     callout=true
                     category='Capital Design Transit')
    public static List<String> identifyConnectionInfo(List<ConnectParams> connectParams) {
        String sourceInst = null;
        String targetInst = null;
        String sfcjDomain = null;
        String sfaintDomain = null;
        String jsonMap = null;
        List<String> connMapList = new List<String>();
        
        try {        
            //Extract parameters into the key variables
            System.debug('(SF2SFConnectionController.identifyConnectionInfo) connParams.size() = ' + connectParams.size());
            sourceInst = connectParams.get(0).sourceInstance;
            targetInst = connectParams.get(0).targetInstance;
            System.debug('(SF2SFConnectionController.identifyConnectionInfo) sourceInst = ' + sourceInst +
                          '\n targetInst = ' + targetInst);
            
            if (String.isBlank(sourceInst) || String.isBlank(targetInst) || sourceInst.equalsIgnoreCase(targetInst)) {
                throw new InvalidParameterParsingException();
            }
            
            sfcjDomain = getSFCJConnectionInfo();
            sfaintDomain = getSFAINTConnectionInfo();
            if (sourceInst.equalsIgnoreCase('SFCJ')) {
                jsonMap = '{ "sourceDomain": "' + sfcjDomain + '", "targetDomain": "' + sfaintDomain + '", "sourceInstance": "' + sourceInst + '", "targetInstance": "' + targetInst + '" }';                
            } else {
                jsonMap = '{ "sourceDomain": "' + sfaintDomain + '", "targetDomain": "' + sfcjDomain + '", "sourceInstance": "' + sourceInst + '", "targetInstance": "' + targetInst + '" }';                
            }
        } catch(Exception checkParamsX) {
            System.debug('(SF2SFConnectionController.identifyConnectionInfo) EXCEPTION! \n Type: ' + checkParamsX.getTypeName() + '\n Message:  ' + checkParamsX.getMessage() + '\n Line#: ' + checkParamsX.getLineNumber() + '\n StackTrace:  ' + checkParamsX.getStackTraceString());            
            jsonMap = 'The retrieval of Connection Information for Source "' + sourceInst + '" and Target "' + targetInst + '" resulted in an EXCEPTION.  \n\nErrorMessage: ' + checkParamsX.getMessage() + '\n StackTrace: ' + checkParamsX.getStackTraceString();
        } finally {
            System.debug('(SF2SFConnectionController.identifyConnectionInfo) Returning in connMapList, jsonMap = ' + jsonMap);
            connMapList.add(jsonMap);
        }
        return connMapList;
    }//end method identifyConnectionInfo
    
    public List<String> automatedIdentifyConnectionInfo(List<ConnectParams> connectParams) {
        String sourceInst = null;
        String targetInst = null;
        String sfcjDomain = null;
        String sfaintDomain = null;
        String jsonMap = null;
        List<String> connMapList = new List<String>();
        
        try {        
            if (connectParams == null || connectParams.size() == 0) {
                connectParams = this.connParamsList;
            }
            //Extract parameters into the key variables
            sourceInst = connectParams.get(0).sourceInstance;
            targetInst = connectParams.get(0).targetInstance;
            System.debug('(SF2SFConnectionController.identifyConnectionInfo) sourceInst = ' + sourceInst +
                          '\n targetInst = ' + targetInst);
            
            if (String.isBlank(sourceInst) || String.isBlank(targetInst) || sourceInst.equalsIgnoreCase(targetInst)) {
                throw new InvalidParameterParsingException();
            }
            
            sfcjDomain = getSFCJConnectionInfo();
            sfaintDomain = getSFAINTConnectionInfo();
            if (sourceInst.equalsIgnoreCase('SFCJ')) {
                jsonMap = '{ "sourceDomain": "' + sfcjDomain + '", "targetDomain": "' + sfaintDomain + '", "sourceInstance": "' + sourceInst + '", "targetInstance": "' + targetInst + '" }';                
            } else {
                jsonMap = '{ "sourceDomain": "' + sfaintDomain + '", "targetDomain": "' + sfcjDomain + '", "sourceInstance": "' + sourceInst + '", "targetInstance": "' + targetInst + '" }';                
            }
        } catch(Exception checkParamsX) {
            System.debug('(SF2SFConnectionController.automatedIdentifyConnectionInfo) EXCEPTION! \n Type: ' + checkParamsX.getTypeName() + '\n Message:  ' + checkParamsX.getMessage() + '\n Line#: ' + checkParamsX.getLineNumber() + '\n StackTrace:  ' + checkParamsX.getStackTraceString());
            jsonMap = 'The retrieval of Connection Information for Source "' + sourceInst + '" and Target "' + targetInst + '" resulted in an EXCEPTION.  \n\nErrorMessage: ' + checkParamsX.getMessage() + '\n StackTrace: ' + checkParamsX.getStackTraceString();
        } finally {
            System.debug('(SF2SFConnectionController.automatedIdentifyConnectionInfo) Returning in connMapList, jsonMap = ' + jsonMap);
            connMapList.add(jsonMap);
        }
        return connMapList;
    }//end method automatedIdentifyConnectionInfo
    
    public void clearState() {
    	this.connParamsList = null;
    }//end method  clearState

    public static String getSFCJConnectionInfo() {
        String domainName = [SELECT Id, Domain FROM Domain LIMIT 1].Domain;
        if (!domainName.containsIgnoreCase('connectedlumn')) {
            return null;
        }
        if (!domainName.containsIgnoreCase('sandbox')) {
            return 'PROD';
        }
        if (domainName.containsIgnoreCase('dev1')) {
            return 'DEV1';
        }
        if (domainName.containsIgnoreCase('dev2')) {
            return 'DEV2';
        } 
        if (domainName.containsIgnoreCase('dev3')) {
            return 'DEV3';
        }
        if (domainName.containsIgnoreCase('test1')) {
            return 'TEST1';
        }
        if (domainName.containsIgnoreCase('test2')) {
            return 'TEST2';
        }
        if (domainName.containsIgnoreCase('test3')) {
            return 'TEST3';
        }
        if (domainName.containsIgnoreCase('prepod') || domainName.containsIgnoreCase('preprod')) {
            return 'PREPROD';
        }   
        return null;
    }//end method getSFCJConnectionInfo

    public static String getSFAINTConnectionInfo() {
        String domainName = [SELECT Id, Domain FROM Domain LIMIT 1].Domain;
        if (!domainName.containsIgnoreCase('lumn')) {
            return null;
        }
        if (!domainName.containsIgnoreCase('sandbox')) {
            return 'PROD';
        }
        if (domainName.containsIgnoreCase('int1')) {
            return 'INT1';
        }
        if (domainName.containsIgnoreCase('int2')) {
            return 'INT2';
        } 
        if (domainName.containsIgnoreCase('int4')) {
            return 'INT4';
        }
        if (domainName.containsIgnoreCase('itv1')) {
            return 'ITV1';
        }
        if (domainName.containsIgnoreCase('itv2')) {
            return 'ITV2';
        }
        if (domainName.containsIgnoreCase('itv4')) {
            return 'ITV4';
        }
        if (domainName.containsIgnoreCase('release1')) {
            return 'RELEASE1';
        }
        if (domainName.containsIgnoreCase('release2')) {
            return 'RELEASE2';
        }
        if (domainName.containsIgnoreCase('release4')) {
            return 'RELEASE4';
        }        
        return null;
    }//end method getSFAINTConnectionInfo
}//end class SF2SFConnectionController