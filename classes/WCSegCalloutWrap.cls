/***************************************************************************************************
 * Name:  WCSegCalloutWrap
 * Platform: Salesforce Connected Journey (SFCJ)
 * Wrapper class for WireCenter CLLI Segmentation interaction between SFCJ and BRAIN/WCSeg API
 * Code Coverage:  TestWCSegCalloutWrap -- 100%  12/06/2023
 * Change History: 
 * Date        	Author		JIRA Traceability		        Details
 * 12/06/2023   T2Cabato    QFCJ-4712                       Capital Design - Wire Center Segmentation Update Automation 
****************************************************************************************************/
/********* Sample Wire Center Segmentation from BRAIN API ******************************************
 "id": "PTVLPAXP", 
 "clliData": "PTVLPA  ", 
 "address": "1125 W PORTERSVILLE RD", 
 "city": "PORTERSVILLE", 
 "stateCode": "PA", 
 "zipCode": "16051", 
. "county": "BUTLER", 
 "sumSquareMiles": 63.20245675, 
 "centralOfficeCount": 1, 
 "wirecenterName": "PORTERSVILLE                                      ", 
 "companySapId": null, 
 "assignedTreatment": "PTVLPAXP" 
******************************************************************************************************/
public with sharing class WCSegCalloutWrap {
	public List<WCSegPayload> wcSegList;

	public class WCSegPayload {
        public String id;
        public String clliData;
        public String address;
        public String city;
        public String stateCode;
        public String zipCode;
        public String county;
        public Decimal sumSquareMiles;
        public Integer centralOfficeCount;
        public String wirecenterName;
        public Boolean companySapId;
        public String assignedTreatment;
    }

   /**********************************************************************************************
    Description: Used when parsing the JSON Response-body into WCSegCalloutWrap
    ***********************************************************************************************/
    public static WCSegCalloutWrap parse(String responseBodySection) {
        System.debug('(WCSegCalloutWrap.parse) responseBodySection = \n' + responseBodySection);
        return (WCSegCalloutWrap) System.JSON.deserialize(responseBodySection, WCSegCalloutWrap.class);
    }//end method parse

    public static List<Network_Wire_Center__c> createNWCsForSeg(
        Integer count,
		Integer cntStart,
        Boolean doInsert
    ) {
        String nameCtrMod = '';
        String segToUse = null;
        List<Network_Wire_Center__c> wireCenters = new List<Network_Wire_Center__c>();
        System.debug('(createNWCsForSeg) count = ' + count + '  AND cntStart = ' + cntStart + '  AND doInsert = ' + doInsert);
        if (count >= 10000) {
            count = 9999;
        }
        System.debug('(createNWCsForSeg) AFTER check, count = ' + count);
		Integer newCount = cntStart + count;
        System.debug('(createNWCsForSeg) AFTER check, newCount = ' + newCount);
        for (Integer i = cntStart; i < newCount; i++) {
            if (i < 10) {
                nameCtrMod = '0000'; 
            } else if (i >= 10 && i < 100) {
                nameCtrMod = '000';
            } else if (i >= 100 && i < 1000) {
                nameCtrMod = '00';
            } else if (i >= 1000 && i < 10000) {
                nameCtrMod = '0';
            } else if (i >= 10000 && i < 100000) {
                nameCtrMod = '';
            }
	        System.debug('(createNWCsForSeg) For i = ' + i + ', nameCtrMod = ' + nameCtrMod);
            if (Math.mod(i, 5) == 0) {
                segToUse = 'STAR';               
            } else if (Math.mod(i, 5) == 1) {
                segToUse = 'HIGH POTENTIAL';
            } else if (Math.mod(i, 5) == 2) {
                segToUse = 'ADJACENT';
            } else if (Math.mod(i, 5) == 3) {
                segToUse = 'MATURE';
            } else {
                segToUse = 'WEAK';
            }
	        System.debug('(createNWCsForSeg) For i = ' + i + ', segToUse = ' + segToUse);
            wireCenters.add(
                new Network_Wire_Center__c(
                    Name = 'WC' + nameCtrMod + String.valueOf(i),
                    Wire_Center_Segmentation__c = segToUse
                )
            );
        }//end for-loop
        System.debug('(createNWCsForSeg) AFTER for-loop, wireCenters.size() = ' + wireCenters.size());        
        if (doInsert) {
            insert wireCenters;
        }
        return wireCenters;
    }//createWCsForSeg    
}//end class WCSegCalloutWrap