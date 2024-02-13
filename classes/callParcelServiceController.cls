public class callParcelServiceController {

    @AuraEnabled
    public static Map<Boolean,String> callService(String recordId){
		
        Map<Boolean,String> message = new Map<Boolean,String>();
        List<Property_Request_Record__c> ppr = new List<Property_Request_Record__c>();
        
        try{
            List<Lead> ld = [Select Id, Property_Latitude__c, Property_Longitude__c,Property_Request_Record__c,Requires_Marketing_Review__c from Lead where Id =: recordId];
            if(ld[0].Property_Request_Record__c!=null){          
                ppr = [Select  Id,Name, 
                            Data_Source__c,
                            GPSLatitude__c, 
                            GPSLongitude__c,
                            GEO_LATITUDE__c,
                            GEO_LONGITUDE__c,
                            User_Latitude__c,
                            User_Longitude__c,
                            ManagerFirstName__c,
                            ManagerLastName__c, 
                            Owner_Contact_Name__c,
                            User_Contact_First_Name__c,
                            User_Contact_Last_Name__c,
                            ProjectAddress__c,
                            ProjectCity__c,
                            ProjectState__c,
                            STREET__c,
                            CITY__c,
                            STATE__c,
                            ProjectZIP__c,
                            County__c,
                            User_Property_Address__c,
                            User_Property_City__c,
                            User_Property_State__c,
                            User_Property_Zip_Code__c,
                            Transaction_Summary__c,
                            Match_Found_In_System__c,
                            isProcessed__c,
                            COUNTRY__c,
                            ZIP_CODE__c,
                            COUNTY_1__c from Property_Request_Record__c where Id =: ld[0].Property_Request_Record__c];
            }
            UniqualParcelServiceResponseWrap uniqualServiceParcelResponse;
            if(!ppr.isempty() && ppr[0].Match_Found_In_System__c==GeoesConstants.MATCH_SYSTEM_FOUND_PRR_NO && ppr[0].Data_Source__c!=GeoesConstants.PROPERTY_REQUEST_RECORD_USER && !ld.isEmpty() && ld[0].Property_Latitude__c!=null && ld[0].Property_Longitude__c!=null){
                uniqualServiceParcelResponse = new UniqualParcelServiceCallout(
                    String.valueOf(ld[0].Property_Latitude__c),
                    String.valueOf(ld[0].Property_Longitude__c),
                    null
                ).getPropertyInfo();
            }
            
            if(uniqualServiceParcelResponse!=null && uniqualServiceParcelResponse.Parcels!=null && !uniqualServiceParcelResponse.Parcels.isEmpty()){
                UniqualParcelServiceResponseWrap.Parcels parcel = uniqualServiceParcelResponse.Parcels.get(0);
                if(ppr[0].Data_Source__c == GeoesConstants.PROPERTY_REQUEST_RECORD_ALN){
                    ppr[0].GPSLatitude__c = Decimal.valueOf(parcel.latitude);
                    ppr[0].GPSLongitude__c = Decimal.valueOf(parcel.longitude);
                    ppr[0].ProjectState__c=parcel.stateCode;
                    ppr[0].ProjectZIP__c =parcel.zipCode;
                    ppr[0].County__c = parcel.countyCode;
                    ppr[0].Country__c = parcel.countyCode;
                    ppr[0].Match_Found_In_System__c='Yes';
                    ppr[0].ManagerFirstName__c =parcel.owner1FirstName;
                    ppr[0].ManagerLastName__c =parcel.owner1LastName;
                }
                if(ppr[0].Data_Source__c == GeoesConstants.PROPERTY_REQUEST_RECORD_DODGE){
                    ppr[0].GEO_LONGITUDE__c = Decimal.valueOf(parcel.latitude);
                    ppr[0].GEO_LATITUDE__c = Decimal.valueOf(parcel.longitude);
                    ppr[0].STATE__c=parcel.state;
                    ppr[0].ZIP_CODE__c =parcel.zipCode;
                    ppr[0].COUNTY_1__c = parcel.countyCode;
                    ppr[0].Country__c = parcel.countyCode;
                    ppr[0].Match_Found_In_System__c='Yes';
                }
                if(ppr[0].Data_Source__c == GeoesConstants.PROPERTY_REQUEST_RECORD_CUSTOMER_SUCCESS){
                    ppr[0].BEST_PROP_ADDR__c = parcel.address;
                    ppr[0].User_Latitude__c = Decimal.valueOf(parcel.latitude);
                    ppr[0].User_Longitude__c = Decimal.valueOf(parcel.longitude);
                    ppr[0].BEST_PROP_CITY__c = parcel.city;
                    ppr[0].BEST_PROP_STATE__c=parcel.stateCode;
                    ppr[0].BEST_PROP_ZIP__c =parcel.zipCode;
                    ppr[0].County__c = parcel.countyCode;
                    ppr[0].Country__c = parcel.countyCode;
                    ppr[0].Match_Found_In_System__c='Yes';
                    //ppr[0].BEST_PROP_NM__c =parcel.owner1FirstName;
                 }
                  update ppr[0];
                
                	/**************************************************************
                	 * Per QFCJ-4370, this is being removed from here and relocated to another part in the code
                	 * 
                	 * 	ld[0].Requires_Marketing_Review__c = false;
                	 * 	update ld[0];
                	 * 
                	 *************************************************************/ 
                    
                    //Pass Success Message -- Parcel Found in Uniqual
                    message.put(true, 'Parcel Found in Uniqual'); 
                
            }else{
                //Pass Error Message -- No tax parcel found, please try anoter lat/long value.
                message.put(false, 'No tax parcel found, please try another lat/long value');
            }
            
            return message;         
        }Catch(Exception e){
            //message.put(true, 'Parcel Found in Uniqual');
            return null;
        }       
    }
}