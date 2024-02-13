/**
 *          When this is applied make sure that this class is made availble to the users profile or it will not display data
 *          2/12/2024        HANK            QFCJ-4863 - created for contract page layout
 * 
 */


public with sharing class lmn_ContractRequiredFieldsController {
        
    @AuraEnabled
        public static string getRequiredFields(Id recId){

            string fieldLabel;
            string requiredFields;
            string dots;

            list<fieldAndMessage> reqFields = new list<fieldAndMessage>();

            Contract getRequiredFields = [select id,
            Person_Designated_for_Notices__c,
            Address_for_Notices__c,
            City_for_Notices__c,
            State_for_Notices__c,
            ZipCode_for_Notices__c,
            Telephone_for_Notices__c,
            Email_Address_for_Notices__c,
            Copy_To_Name__c,
            Copy_To_Email__c
            from contract where Id = :recId];

            if(getRequiredFields.Person_Designated_for_Notices__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Person designated for notices';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Address_for_Notices__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Address for notices';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.City_for_Notices__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'City for notices';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.State_for_Notices__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'State for notices';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Zipcode_for_Notices__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Zipcode for notices';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Telephone_for_Notices__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Telephone for notices';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Email_Address_for_Notices__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Email address for notices';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Copy_To_Name__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Copy to name';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Copy_To_Email__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Copy to email';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            

            if(reqFields.size() > 0){
                for(fieldAndMessage reqField : reqFields){
                    if(requiredFields == null){
                        dots = howManySpace(reqField.tab);
                        requiredFields = 'Required Fields: \n';
                        requiredFields = requiredFields +reqField.tab+' '+dots+' '+reqField.field+'   '+reqField.message+'\n';
                    } else {
                        dots = howManySpace(reqField.tab);
                        requiredFields = requiredFields +reqField.tab+' '+dots+' '+reqField.field+'   '+reqField.message+'\n';
                    }
                }
            }

            return requiredFields;

    }

    public class fieldAndMessage{
        public string tab {get;set;}   
        public string field {get;set;} 
        public string message {get;set;}
        public decimal length {get;set;}
}

    public static string howManySpace(string Tab){

        string dots;

        if(tab == 'Property > SOW'){
            dots = '........................................................';
        }else if(tab == 'Property > Property Info'){
            dots = '.......................................';
        }else if(tab == 'Timeline'){
            dots = '.......................................';
        }else if(tab == 'Key Details'){
            dots = '...................................................................';
        }else if(tab == 'CCT > Input Section'){
            dots = '................................................';
        }else if(tab == 'Network & CapEX > Residential Network'){
            dots = '......';
        }else if(tab == 'Property > Timeline & Living Units'){
            dots = '...................';
        }else if(tab == ''){
            dots = '';
        }else{
            dots = '...';
        }
        
        return dots;
    }

}