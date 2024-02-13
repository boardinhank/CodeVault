/***************************************************************
===============================================================
Purpose: Test class for Prospector List Jobs service callout class
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 08/29/2022   ESCJ-653  	  Initial draft
***************************************************************/
public class ProspectorGetRoutesWrap {
    public String        status;
    public String        message;
    public List<Payload> payload;

    public class Payload {
        public String             routeName;
        public String             demandName;
        public String             facilityType;
        public Integer            facilityOid;
        public Integer            naFacilityFid;
        public String             routeAsJson;
        public String             routeGuid;
        public String             parentGuid;
        public String             treeGuid;
        public List<Payload>	  childDetails;
        public SolveType		  solveType;
        public Double             geodesicLength;
        public Integer            chainCount;
        public Double             chainRatio;
        public Integer            businessCount;
        public Double             lcrCost;
        public Double             totalCost;
        public Double             startSegmentCost;
        public Double             endSegmentCost;
        public Double             totalTreeCost;
        public Double             demandToInfrastructureLength;
        public Integer            persistedOid;
        public String             lengthUnits;
        public Double             crewCost;
        public Double             accessCost;
        public Double             minLateralCost;
        public String             createdDate;
        public String             lastEditedDate;
        
        public String ToReadableString() {
            String readableStr = 'ProspectorGetRoutesWrap: { ';
            readableStr += '\n "routeName": "' + routeName + '", ';
            readableStr += '\n "demandName": "' + demandName + '", ';
            readableStr += '\n "facilityType": "' + facilityType + '", ';
            readableStr += '\n "routeAsJson": "' + routeAsJson + '", ';
            readableStr += '\n "routeGuid": "' + routeGuid + '", ';
            readableStr += '\n "parentGuid": "' + parentGuid + '", ';
            readableStr += '\n "treeGuid": "' + treeGuid + '", ';
            readableStr += '\n "createdDate": "' + createdDate + '", ';
            readableStr += '\n "lastEditedDate": "' + lastEditedDate + '" \n } ';
            return readableStr;
        }//end method ToReadableString
	}//end class Payload
    
    public class SolveType {
       	public Integer            id ;
       	public String             name ;
    }//end class SolveType
        
    /**********************************************************************************************
    Purpose: To parse jsonBody String into ProspectorGetRoutesWrap
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/29/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    public static ProspectorGetRoutesWrap parse(String jsonBody) {
        System.debug('Size: ' + jsonBody.length());
        System.debug('(ProspectorGetRoutesWrap.parse) jsonBody = \n' + jsonBody);
        return (ProspectorGetRoutesWrap) System.JSON.deserialize(
            jsonBody,
            ProspectorGetRoutesWrap.class
        );
    }       
}//end class ProspectorGetRoutesWrap