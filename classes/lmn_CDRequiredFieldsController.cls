/****************************************************************************************************
 * 01/19/2024   T2Cabato    QFCJ-4858			            Add Requirement for Total [Structure] [Use] Units
 * 01/23/24     Hank        QFCJ-4708                       Added extra fields to check for, an update to the required field on CD to get send to planner button to show. 
****************************************************************************************************/
public with sharing class lmn_CDRequiredFieldsController {
    
    @AuraEnabled
        public static string getRequiredFields(Id recId){
      
        string fieldLabel;
        string requiredFields;
        string dots;
        boolean sendToPlannerTitle = false;
        boolean sendToPlannerButton; 


   
        list<fieldAndMessage> reqFields = new list<fieldAndMessage>();
        list<fieldAndMessage> sendToPlanner = new list<fieldAndMessage>();
        list<segment__c> getSegments = new list<segment__c>();

        Capital_Design__c getRequiredFields = [select id,
                                               Responsible_for_Cable_Home_Wiring__c,
                                               Responsible_for_Home_Run_Wiring__c,
                                               Telecommunication_Cable_Types__c,
                                               Telecom_Cable_Quantity_Per_Living_Unit__c,
                                               Endpoint_Type_building_architecture__c,
                                               Responsible_for_Media_Panel__c,
                                               Exterior_Cabinets__c,
                                               NEMA_Rated_Cabinet__c,
                                               Backboards_required__c,   
                                               Planned_Build_Out_Years__c,
                                               Actual_Build_Out_Months__c,
                                               Project_Start_Year__c,
                                               Alarm_Due_Date__c,
                                               Open_Trench_Date__c,
                                               ONT_Location__c,
                                               Inside_Wiring__c,
                                               Opportunity__c,
                                               Opportunity__r.Property__r.Max_Bandwidth_Available__c,   
                                               Units_Built_Year_1__c,
                                               Units_Built_Year_2__c,
                                               Units_Built_Year_3__c,    
                                               F1_Feeder_Type__c,
                                               Access_Type__c,
                                               Occupant_Type__c,
                                               Existing_Feeder_Footage_Utilized__c,
                                               No_GPON_No_Integrated_Switch__c,
                                               Primary_Descriptor_of_CO_Area__c,
                                               Existing_Phases_are_Copper__c,
                                               Footage_of_New_Feeder_Fiber_Built__c,
                                               Remote_Electronics_for_Cards_Only__c,
                                               Initial_CO_Deployment_Fiber_Technology__c,
                                               CO_Electronics_for_Cards_Only__c,                    
                                               Population_Density__c,
                                               F1_Footage_ft__c,        
                                               F4_Fiber_Type__c,
												//For Units logic
											   Property_Structure__c,
                                               Building_Style__c,
												//Standard units
                                               Total_Cottage_Owner_Units__c,
                                               Total_Cottage_Rental_Units__c,
                                               Total_SFH_Owner_Units__c,
                                               Total_SFH_Rental_Units__c,
                                               Total_Tower_Owner_Units__c,
                                               Total_Tower_Rental_Units__c,
												//Non-Marketing units
                                               Total_Cottage_Owner_Units_NM__c,
                                               Total_Cottage_Rental_Units_NM__c,
                                               Total_SFH_Owner_Units_NM__c,
                                               Total_SFH_Rental_Units_NM__c,
                                               Total_Tower_Owner_Units_NM__c,
                                               Total_Tower_Rental_Units_NM__c,
                                               Capital_Design_Stage__c,
                                               Capital_Design_Type__c
                                               
                                               From capital_design__c where Id = :recId];

        
        if(getRequiredFields != null){
            //Collect all segments to loop through later
            getSegments = [select id, Segment_Structure__c, Segment_Use__c, Segment_Total_Units__c from segment__c where Opportunity__c = :getRequiredFields.Opportunity__c];

            // ----------------------------------------------------------------------  Property > Property Info
            if(getRequiredFields.Endpoint_Type_building_architecture__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Endpoint Type building architecture';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Telecommunication_Cable_Types__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Home Run Cable Types';
                addField.tab = 'Key Details';
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);
            }
            if(getRequiredFields.Telecom_Cable_Quantity_Per_Living_Unit__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Home Run Quantity Per Living Unit';
                addField.tab = 'Key Details'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            }   
            if(getRequiredFields.Responsible_for_Cable_Home_Wiring__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Responsible for Cable Home Wiring';
                addField.tab = 'Key Details';
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)'; 
                addField.length = addField.tab.length();
                reqFields.add(addField);
            }
            if(getRequiredFields.Responsible_for_Home_Run_Wiring__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Responsible for Home Run Wiring';   
                addField.tab = 'Key Details';
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';  
                addField.length = addField.tab.length();
                reqFields.add(addField);  
            }  
            // ----------------------------------------------------------------------  Property > Property Info
            if(getRequiredFields.Inside_Wiring__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Inside Wiring';
                addField.tab = 'Property > Property Info'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)'; 
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            }     
            if(getRequiredFields.Occupant_Type__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Occupant Type';
                addField.tab = 'Property > Property Info'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.ONT_Location__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'ONT Location';
                addField.tab = 'Property > Property Info'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)'; 
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            // ----------------------------------------------------------------------  Property > SOW   
            if(getRequiredFields.Backboards_required__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Backboards required';
                addField.tab = 'Property > SOW'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Exterior_Cabinets__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Exterior Cabinets';
                addField.tab = 'Property > SOW'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            }     
            if(getRequiredFields.NEMA_Rated_Cabinet__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'NEMA Rated Cabinet';
                addField.tab = 'Property > SOW'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';  
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            }  
            if(getRequiredFields.Responsible_for_Media_Panel__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Responsible for Media Panel';
                addField.tab = 'Property > SOW'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';  
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            // ----------------------------------------------------------------------  Property > Timeline & Living Units
            if(getRequiredFields.Actual_Build_Out_Months__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Actual Build Out Months';
                addField.tab = 'Property > Timeline & Living Units'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Alarm_Due_Date__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Alarm Due Date';
                addField.tab = 'Property > Timeline & Living Units'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Open_Trench_Date__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Open Trench Date';
                addField.tab = 'Property > Timeline & Living Units'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)'; 
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Planned_Build_Out_Years__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Planned Build Out Years';
                addField.tab = 'Property > Timeline & Living Units'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Project_Start_Year__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Project Start Year';
                addField.tab = 'Property > Timeline & Living Units'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';   
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Units_Built_Year_1__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Units Built - Year 1';
                addField.tab = 'Property > Timeline & Living Units'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Units_Built_Year_2__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Units Built - Year 2';
                addField.tab = 'Property > Timeline & Living Units'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Units_Built_Year_3__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Units Built - Year 3';
                addField.tab = 'Property > Timeline & Living Units'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(!String.isBlank(getRequiredFields.Capital_Design_Type__c) && getRequiredFields.Capital_Design_Type__c.equalsIgnoreCase('standard') && 
            !String.isBlank(getRequiredFields.Building_Style__c) && getRequiredFields.Building_Style__c.startsWith('Cottage') &&
            (getRequiredFields.Total_Cottage_Owner_Units__c == null || getRequiredFields.Total_Cottage_Owner_Units__c == 0) &&
            (getRequiredFields.Total_Cottage_Rental_Units__c == null || getRequiredFields.Total_Cottage_Rental_Units__c == 0)){
             fieldAndMessage addField = new fieldAndMessage();
             fieldLabel = 'Total Cottage [Rental/Owner] Units';
             addField.tab = 'Property > Timeline & Living Units';
             addField.field = fieldLabel;
             addField.message = '(Cannot be empty or zero when Standard~Cottage)'; 
             addField.length = addField.tab.length();
             reqFields.add(addField);
         }
         if(!String.isBlank(getRequiredFields.Capital_Design_Type__c) && getRequiredFields.Capital_Design_Type__c.equalsIgnoreCase('standard') && 
            !String.isBlank(getRequiredFields.Building_Style__c) && getRequiredFields.Building_Style__c.startsWith('SF') && 
            (getRequiredFields.Total_SFH_Owner_Units__c == null || getRequiredFields.Total_SFH_Owner_Units__c == 0) &&
            (getRequiredFields.Total_SFH_Rental_Units__c == null || getRequiredFields.Total_SFH_Rental_Units__c == 0)){
             fieldAndMessage addField = new fieldAndMessage();
             fieldLabel = 'Total SFH [Rental/Owner] Units';
             addField.tab = 'Property > Timeline & Living Units';
             addField.field = fieldLabel;
             addField.message = '(Cannot be empty or zero when Standard~SFH)'; 
             addField.length = addField.tab.length();
             reqFields.add(addField);
         }
         if(!String.isBlank(getRequiredFields.Capital_Design_Type__c) && getRequiredFields.Capital_Design_Type__c.equalsIgnoreCase('standard') && 
            !String.isBlank(getRequiredFields.Building_Style__c) && (getRequiredFields.Building_Style__c.startsWith('Midrise') || getRequiredFields.Building_Style__c.startsWith('Highrise')) &&
            (getRequiredFields.Total_Tower_Owner_Units__c == null || getRequiredFields.Total_Tower_Owner_Units__c == 0) &&
            (getRequiredFields.Total_Tower_Rental_Units__c == null || getRequiredFields.Total_Tower_Rental_Units__c == 0)){
             fieldAndMessage addField = new fieldAndMessage();
             fieldLabel = 'Total Tower [Rental/Owner] Units';
             addField.tab = 'Property > Timeline & Living Units';
             addField.field = fieldLabel;
             addField.message = '(Cannot be empty or zero when Standard~[Midrise/Highrise])'; 
             addField.length = addField.tab.length();
             reqFields.add(addField);
         }
         // ----------------------------------------------------------------------  Network & CapEX > Residential Network
         if(getRequiredFields.Access_Type__c == null){
            fieldAndMessage addField = new fieldAndMessage();
            fieldLabel = 'Access Type';
            addField.tab = 'Network & CapEX > Residential Network'; 
            addField.field = fieldLabel;
            addField.message = '(Cannot be empty)';
            addField.length = addField.tab.length();
            reqFields.add(addField);    
        } 
        if(getRequiredFields.CO_Electronics_for_Cards_Only__c == null){
            fieldAndMessage addField = new fieldAndMessage();
            fieldLabel = 'CO Electronics for Cards Only';
            addField.tab = 'Network & CapEX > Residential Network'; 
            addField.field = fieldLabel;
            addField.message = '(Cannot be empty)';
            addField.length = addField.tab.length();
            reqFields.add(addField);    
        } 
            if(getRequiredFields.Existing_Feeder_Footage_Utilized__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Existing Feeder Footage Utilized';
                addField.tab = 'Network & CapEX > Residential Network'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Existing_Phases_are_Copper__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Existing Phases are Copper';
                addField.tab = 'Network & CapEX > Residential Network'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.F1_Feeder_Type__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'F1 Feeder Type';
                addField.tab = 'Network & CapEX > Residential Network'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)'; 
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Footage_of_New_Feeder_Fiber_Built__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Footage of New Feeder Fiber Built';
                addField.tab = 'Network & CapEX > Residential Network'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Initial_CO_Deployment_Fiber_Technology__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Initial CO Deployment Fiber Technology';
                addField.tab = 'Network & CapEX > Residential Network'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.No_GPON_No_Integrated_Switch__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'No GPON / No Integrated Switch';
                addField.tab = 'Network & CapEX > Residential Network'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Primary_Descriptor_of_CO_Area__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Primary Descriptor of CO Area';
                addField.tab = 'Network & CapEX > Residential Network'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Remote_Electronics_for_Cards_Only__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Remote Electronics for Cards Only';
                addField.tab = 'Network & CapEX > Residential Network'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            // ----------------------------------------------------------------------  CCT > Input Section
            if(getRequiredFields.F1_Footage_ft__c  == null || getRequiredFields.F1_Footage_ft__c  == 0){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'F1 Footage (ft)';
                addField.tab = 'CCT > Input Section'; 
                addField.field = fieldLabel;
                addField.message = '(Must be greater than 0)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.F4_Fiber_Type__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'F4 Fiber Type';
                addField.tab = 'CCT > Input Section'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            if(getRequiredFields.Population_Density__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Population Density';
                addField.tab = 'CCT > Input Section'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            // ----------------------------------------------------------------------  Non Marketing CCT Details
            if(!String.isBlank(getRequiredFields.Capital_Design_Type__c) && getRequiredFields.Capital_Design_Type__c.equalsIgnoreCase('non-marketing') && 
			   !String.isBlank(getRequiredFields.Building_Style__c) && getRequiredFields.Building_Style__c.startsWith('Cottage') &&
               (getRequiredFields.Total_Cottage_Owner_Units_NM__c == null || getRequiredFields.Total_Cottage_Owner_Units_NM__c == 0) &&
               (getRequiredFields.Total_Cottage_Rental_Units_NM__c == null || getRequiredFields.Total_Cottage_Rental_Units_NM__c == 0)){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Total Cottage [Rental/Owner] Units NM';
                addField.tab = 'Non Marketing CCT Details';
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty or zero when Non-Marketing~Cottage)'; 
                addField.length = addField.tab.length();
                reqFields.add(addField);
            }
            if(!String.isBlank(getRequiredFields.Capital_Design_Type__c) && getRequiredFields.Capital_Design_Type__c.equalsIgnoreCase('non-marketing') && 
			   !String.isBlank(getRequiredFields.Building_Style__c) && getRequiredFields.Building_Style__c.startsWith('SF') &&
               (getRequiredFields.Total_SFH_Owner_Units_NM__c == null || getRequiredFields.Total_SFH_Owner_Units_NM__c == 0) &&
               (getRequiredFields.Total_SFH_Rental_Units_NM__c == null || getRequiredFields.Total_SFH_Rental_Units_NM__c == 0)){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Total SFH [Rental/Owner] Units NM';
                addField.tab = 'Non Marketing CCT Details';
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty or zero when Non-Marketing~SFH)'; 
                addField.length = addField.tab.length();
                reqFields.add(addField);
            }
            if(!String.isBlank(getRequiredFields.Capital_Design_Type__c) && getRequiredFields.Capital_Design_Type__c.equalsIgnoreCase('non-marketing') && 
			   !String.isBlank(getRequiredFields.Building_Style__c) && (getRequiredFields.Building_Style__c.startsWith('Midrise') || getRequiredFields.Building_Style__c.startsWith('Highrise')) &&
               (getRequiredFields.Total_Tower_Owner_Units_NM__c == null || getRequiredFields.Total_Tower_Owner_Units_NM__c == 0) &&
               (getRequiredFields.Total_Tower_Rental_Units_NM__c == null || getRequiredFields.Total_Tower_Rental_Units_NM__c == 0)){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Total Tower [Rental/Owner] Units NM';
                addField.tab = 'Non Marketing CCT Details';
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty or zero when Non-Marketing~[Midrise/Highrise])'; 
                addField.length = addField.tab.length();
                reqFields.add(addField);
            }
            // ----------------------------------------------------------------------  Opportunity fields
            if(getRequiredFields.Opportunity__r.Property__r.Max_Bandwidth_Available__c == null){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Opportunity Max Bandwidth';
                addField.tab = 'Opportunity Record'; 
                addField.field = fieldLabel;
                addField.message = '(Cannot be empty)';
                addField.length = addField.tab.length();
                reqFields.add(addField);    
            } 
            // ----------------------------------------------------------------------  Submit to Planner button criteria below

            if(getRequiredFields.Capital_Design_Stage__c != 'In-Progress' && getRequiredFields.Capital_Design_Stage__c != 'Additional Engineer Input Needed'){
                fieldAndMessage addField = new fieldAndMessage();
                fieldLabel = 'Capital Design Stage';
                addField.tab = ''; 
                addField.field = fieldLabel;
                addField.message = '(Needs to be either In-Progress or Additional Engineer Input Needed)';
                addField.length = addField.tab.length();
                sendToPlanner.add(addField);    
            } 
            if(getSegments.size() > 0){
                for(segment__c getSegment : getSegments){
                    if((String.isBlank(getSegment.Segment_Structure__c) || getSegment.Segment_Total_Units__c == null || String.isBlank(getSegment.Segment_Use__c))){
                        fieldAndMessage addField = new fieldAndMessage();
                        fieldLabel = 'Segment Structure Missing';
                        addField.tab = 'Related Opportunity'; 
                        addField.field = fieldLabel;
                        addField.message = '(All Segments need to have a Segment Structure, Segment Use & Segment Total Units)';
                        addField.length = addField.tab.length();
                        sendToPlanner.add(addField); 
                        break;
                    }
                }
            }
        }
        //  lets loop through the lists to create the string output
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
        // next list should take into consideration if the first list was null or not
    if(sendToPlanner.size() > 0){
        for(fieldAndMessage reqField : sendToPlanner){
            if(requiredFields == null){
                    dots = howManySpace(reqField.tab);
                    requiredFields = 'Send To Planner Button: \n';
                    sendToPlannerTitle = true;
                    requiredFields = requiredFields +reqField.tab+' '+dots+' '+reqField.field+'   '+reqField.message+'\n';
            } else{
                if(sendToPlannerTitle == false){
                    dots = howManySpace(reqField.tab);
                    requiredFields = requiredFields +'\n';
                    requiredFields = requiredFields + 'Send To Planner Button: \n';
                    sendToPlannerTitle = true;
                }
                    dots = howManySpace(reqField.tab);
                    requiredFields = requiredFields +reqField.tab+' '+dots+' '+reqField.field+'   '+reqField.message+'\n';
            }
        }
    }

        // add data sets to output used in HTML
        if(requiredFields == null){
            Capital_Design__c capitalDesignTouch = new Capital_Design__c();
            capitalDesignTouch.Id = recId;
            capitalDesignTouch.RequiredFieldsMissing__c = false;
            if(capitalDesignTouch != null){
                update capitalDesignTouch;
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