/***************************************************************
===============================================================
Purpose: Class for Prospector Mock Http Response Generator
===============================================================
History:

AUTHOR     DATE         Reference     Description
Stan & Ted 09/15/2022   ESCJ-653  	  Initial draft
***************************************************************/
public class ProspectorMockHttpResponseGenerator {
    private String apiName;
    private String facilityType;

    //constants
    private static final String CREATE_PROJECT       	= 'CreateProject';
    private static final String ADD_DEMAND_POINTS    	= 'AddDemandPoints';
    private static final String SUBMIT_JOB	        	= 'SubmitJob';
    private static final String LIST_JOBS	        	= 'ListJobs';
    private static final String GET_ROUTES_BY_PROJECT	= 'GetRoutesByProject';
    private static final String FACILITY_TYPE_MHHH		= 'MH_HH';
    private static final String FACILITY_TYPE_SPLICE	= 'Splice_Closure';

    /**********************************************************************************************
    Purpose: Parameterized cosntructor for passing API Name
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    17/12/2021   ESCJ-364      Initial draft
    ***********************************************************************************************/
    public ProspectorMockHttpResponseGenerator(String thisApiName, String thisFacilityType) {
        apiName = thisApiName;
        facilityType = thisFacilityType;
    }//end constructor ProspectorMockHttpResponseGenerator

    /**********************************************************************************************
    Purpose: Http respond method of HttpCalloutMock interface which will return the mock response
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    17/12/2021   ESCJ-364      Initial draft
    Navin M    31/01/2022   ESCJ-379      Added condition for the GEOES service
    ***********************************************************************************************/
    public HTTPResponse respond(HTTPRequest request) {
        String jsonBody;
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        // If the HttpRequest is not null then proceed further
        if (request != null) {
            //Determine the mock-response json body to return based on apiName
			if (apiName == CREATE_PROJECT) {
                jsonBody = getProspectorCreateProjectCalloutJsonString();
            } else if (apiName == ADD_DEMAND_POINTS) {
                jsonBody = getProspectorAddDemandPointsCalloutJsonString();
            } else if (apiName == SUBMIT_JOB) {
                jsonBody = getProspectorSubmitJobCalloutJsonString();
            } else if (apiName == LIST_JOBS) {
                jsonBody = getProspectorListJobsCalloutJsonString();
            } else if (apiName == GET_ROUTES_BY_PROJECT) {
                if (facilityType == FACILITY_TYPE_SPLICE) {
	                jsonBody = getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesSpliceClosure();                    
                } else if (facilityType == FACILITY_TYPE_MHHH) {
	                jsonBody = getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesMHHH();                    
                } else {
	                jsonBody = getProspectorGetRoutesByProjectCalloutJsonString();
                }
            } else {
	            jsonBody = 'apiName not found';
            }
            response.setBody(jsonBody);
            response.setStatusCode(200);
        }
        // If the HttpRequest is null then set the status code as 400 and send nul; response body
        else {
            response.setBody(jsonBody);
            response.setStatusCode(400);
        }
        return response;
    }//end method respond

    /**********************************************************************************************
    Purpose: To get the mock response json string for ProspectorCreateProject service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/29/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private String getProspectorCreateProjectCalloutJsonString(){
        System.debug('getProspectorCreateProjectCalloutJsonString...');
        String rBody = '';
        
        rBody += '{';
        rBody += ' "status": "success", ';
        rBody += ' "payload": "{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}", ';
        rBody += ' "message": null ';
        rBody += '}';
        
        return rBody;
    }//end method getProspectorCreateProjectCalloutJsonString

    /**********************************************************************************************
    Purpose: To get the mock response json string for ProspectorCreateProject service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/29/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private String getProspectorAddDemandPointsCalloutJsonString(){
        System.debug('getProspectorAddDemandPointsCalloutJsonString...');
        String rBody = '';
        
        rBody += '{';
        rBody += ' "status": "success", ';
        rBody += ' "payload": true, ';
        rBody += ' "message": null ';
        rBody += '}';
        
        return rBody;
    }//end method getProspectorAddDemandPointsCalloutJsonString

    /**********************************************************************************************
    Purpose: To get the mock response json string for ProspectorCreateProject service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/29/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private String getProspectorSubmitJobCalloutJsonString(){
        System.debug('getProspectorSubmitJobCalloutJsonString...');
        String rBody = '';
        
        rBody += '{';
        rBody += ' "status": "success", ';
        rBody += ' "payload": true, ';
        rBody += ' "message": null ';
        rBody += '}';
        
        return rBody;
    }//end method getProspectorSubmitJobCalloutJsonString

    /**********************************************************************************************
    Purpose: To get the mock response json string for ProspectorCreateProject service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/29/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private String getProspectorListJobsCalloutJsonString(){
        System.debug('getProspectorListJobsCalloutJsonString...');
        String rBody = '';
        
        rBody += '{';
        rBody += ' "payload": [ ';
        rBody += '     { ';
        rBody += '        "userName": "SFJCAPP", ';
        rBody += '        "projectName": "pn1661446091794", ';
        rBody += '        "projectId": "{30951238-AA8F-47E5-A3F0-F5B9E6E69272}", ';
        rBody += '        "guid": "{EB2825D0-A606-404A-BF20-6BAA78F0CEE4}", ';
        rBody += '        "status": 16, ';
        rBody += '        "machineName": "USDDCWVPRSPCTP1", ';
        rBody += '        "processId": 12532, ';
        rBody += '        "cancelRequested": false, ';
        rBody += '        "created": "2022-08-25T16:49:03.9377737Z", ';
        rBody += '        "lastUpdated": "2022-08-25T16:49:45.6631035Z" ';
        rBody += '     }, ';
        rBody += '     { ';
        rBody += '        "userName": "SFJCAPP", ';
        rBody += '        "projectName": "pn1661776658887", ';
        rBody += '        "projectId": "{5677A30D-21C3-4A80-9C4F-362E4DEE8E1B}", ';
        rBody += '        "guid": "{74D2C741-5BBF-4694-AAEA-D50A82A1CEBB}", ';
        rBody += '        "status": 16, ';
        rBody += '        "machineName": "USDDCWVPRSPCTP1", ';
        rBody += '        "processId": 25896, ';
        rBody += '        "cancelRequested": false, ';
        rBody += '        "created": "2022-08-29T12:38:03.791474Z", ';
        rBody += '        "lastUpdated": "2022-08-29T12:38:15.5667068Z" ';
        rBody += '     }, ';
        rBody += '     { ';
        rBody += '        "userName": "SFJCAPP", ';
        rBody += '        "projectName": "pn1661446091794", ';
        rBody += '        "projectId": "{D954B866-5BA0-4A53-B990-1F70F6090AE2}", ';
        rBody += '        "guid": "{EB2825D0-A606-404A-BF20-6BAA78F0CEE4}", ';
        rBody += '        "status": 16, ';
        rBody += '        "machineName": "USDDCWVPRSPCTP1", ';
        rBody += '        "processId": 12532, ';
        rBody += '        "cancelRequested": false, ';
        rBody += '        "created": "2022-08-25T16:49:03.9377737Z", ';
        rBody += '        "lastUpdated": "2022-08-25T16:49:45.6631035Z" ';
        rBody += '     }, ';
        rBody += '     { ';
        rBody += '        "userName": "SFJCAPP", ';
        rBody += '        "projectName": "pn1661776658887", ';
        rBody += '        "projectId": "{BA09EEE2-9FFF-457F-95A0-DCA408D18843}", ';
        rBody += '        "guid": "{74D2C741-5BBF-4694-AAEA-D50A82A1CEBB}", ';
        rBody += '        "status": 16, ';
        rBody += '        "machineName": "USDDCWVPRSPCTP1", ';
        rBody += '        "processId": 25896, ';
        rBody += '        "cancelRequested": false, ';
        rBody += '        "created": "2022-08-29T12:38:03.791474Z", ';
        rBody += '        "lastUpdated": "2022-08-29T12:38:15.5667068Z" ';
        rBody += '     } ';
        rBody += ' ],';
        rBody += ' "status": "success", ';
        rBody += ' "message": null ';
        rBody += '}';
        
        return rBody;
    }//end method getProspectorListJobsCalloutJsonString

    /**********************************************************************************************
    Purpose: To get the mock response json string for ProspectorCreateProject service callout
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Stan & Ted 08/29/2022   ESCJ-653  	  Initial draft
    ***********************************************************************************************/
    private String getProspectorGetRoutesByProjectCalloutJsonString(){
        System.debug('getProspectorGetRoutesByProjectCalloutJsonString...');
        String rBody = '';
        
        rBody += '{';
        rBody += '    "status": "success",';
        rBody += '    "message": null,';
        rBody += '    "payload": [';
        rBody += '        {';
        rBody += '            "routeName": "A0 - MH_HH_1134141",';
        rBody += '            "demandName": "FOLEY36535",';
        rBody += '            "facilityType": "MH_HH",';
        rBody += '            "facilityOid": 1134141,';
        rBody += '            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '            "routeAsJson": "{\"paths\":[[[-90.07765888199998,29.969037716000003],[-90.077545385999997,29.968935217000023],[-90.078044999999975,29.96838200000002],[-90.078463999999997,29.967922999999985],[-90.077671000000009,29.967367000000024],[-90.077642000000026,29.96734600000002],[-90.077616999999975,29.967326000000014],[-90.077649000000008,29.967289999999991],[-90.077693000000011,29.967243999999994],[-90.077746999999988,29.967190000000016],[-90.077767999999992,29.96704299999999],[-90.078614000000016,29.965998000000013],[-90.078730000000007,29.965872999999988],[-90.078958999999998,29.965619000000004],[-90.079158000000007,29.965395000000001],[-90.079298999999992,29.965220999999985],[-90.079926999999998,29.964531000000022],[-90.080343000000028,29.96405900000002],[-90.080605999999989,29.963755999999989],[-90.08063199999998,29.963729999999998],[-90.080693999999994,29.963655000000017],[-90.080984999999998,29.963326999999992],[-90.081330999999977,29.962935000000016],[-90.081715999999972,29.962542999999982],[-90.082090999999991,29.962124000000017],[-90.082134999999994,29.962072999999975],[-90.082174000000009,29.962028999999973],[-90.082218000000012,29.961977999999988],[-90.082560999999998,29.961610000000007],[-90.082990999999993,29.96109100000001],[-90.083730000000003,29.960274000000027],[-90.084171000000026,29.959773999999982],[-90.084420786999999,29.959490524999978],[-90.084474999999998,29.959429],[-90.084439999999972,29.959400000000016],[-90.084411999999986,29.95938000000001],[-90.084357000000011,29.959337000000005],[-90.084213999999974,29.959233999999981],[-90.08372700000001,29.958884000000012],[-90.082827000000009,29.958321000000012],[-90.082716000000005,29.958271000000025],[-90.082736000000011,29.95817199999999],[-90.083144000000004,29.956866999999988],[-90.083310999999981,29.956241999999975],[-90.083521000000019,29.955439000000013],[-90.083740999999975,29.954741000000013],[-90.083803999999986,29.954530999999974],[-90.083820000000003,29.95447999999999],[-90.083882000000017,29.954350999999974],[-90.083893999999987,29.95432599999998],[-90.083920999999975,29.954274999999996],[-90.083872999999983,29.954254999999989],[-90.083358148000002,29.954025709999996],[-90.083321049999995,29.954109010000025]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '            "routeGuid": "{2F37B9F4-E5F4-47CE-A5CC-C575C5894FF9}",';
        rBody += '            "parentGuid": "",';
        rBody += '            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '            "childDetails": [';
        rBody += '                {';
        rBody += '                    "routeName": "G6 - DAISY CHAIN 5392385",';
        rBody += '                    "demandName": "G6",';
        rBody += '                    "facilityType": "DAISY CHAIN",';
        rBody += '                    "facilityOid": 5392385,';
        rBody += '                    "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '                    "routeAsJson": "{\"paths\":[[[-90.080201616000011,29.971008096999981],[-90.080303499000024,29.971096247999981],[-90.080212000000017,29.971202000000005],[-90.079063000000019,29.970388000000014],[-90.078178999999977,29.969780000000014],[-90.077317999999991,29.969186999999977],[-90.077545385999997,29.968935217000023]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '                    "routeGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '                    "parentGuid": "{2F37B9F4-E5F4-47CE-A5CC-C575C5894FF9}",';
        rBody += '                    "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '                    "childDetails": [';
        rBody += '                        {';
        rBody += '                            "routeName": "E4 - DAISY CHAIN 5392386",';
        rBody += '                            "demandName": "E4",';
        rBody += '                            "facilityType": "DAISY CHAIN",';
        rBody += '                            "facilityOid": 5392386,';
        rBody += '                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '                            "routeAsJson": "{\"paths\":[[[-90.078216782000027,29.96966043499998],[-90.078255329000001,29.969695084000023],[-90.078178999999977,29.969780000000014]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '                            "routeGuid": "{4563223B-3C66-4551-8935-4298F427590E}",';
        rBody += '                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '                            "childDetails": [],';
        rBody += '                            "solveType": {';
        rBody += '                                "id": 1,';
        rBody += '                                "name": "LCR"';
        rBody += '                            },';
        rBody += '                            "geodesicLength": 57.0,';
        rBody += '                            "chainCount": 3,';
        rBody += '                            "chainRatio": 0.33444778,';
        rBody += '                            "businessCount": 305,';
        rBody += '                            "lcrCost": 0.0,';
        rBody += '                            "totalCost": 17000.0,';
        rBody += '                            "startSegmentCost": 1140.3387724,';
        rBody += '                            "endSegmentCost": 0.0,';
        rBody += '                            "totalTreeCost": 17000.0,';
        rBody += '                            "demandToInfrastructureLength": 7378.1280729,';
        rBody += '                            "persistedOid": 5392387,';
        rBody += '                            "lengthUnits": "Foot",';
        rBody += '                            "crewCost": 7187.59,';
        rBody += '                            "accessCost": 0.0,';
        rBody += '                            "minLateralCost": 0.0,';
        rBody += '                            "createdDate": null,';
        rBody += '                            "lastEditedDate": null';
        rBody += '                        },';
        rBody += '                        {';
        rBody += '                            "routeName": "B1 - DAISY CHAIN 5392386",';
        rBody += '                            "demandName": "B1",';
        rBody += '                            "facilityType": "DAISY CHAIN",';
        rBody += '                            "facilityOid": 5392386,';
        rBody += '                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '                            "routeAsJson": "{\"paths\":[[[-90.076714745000004,29.970013617000006],[-90.076641968999979,29.969949056000019],[-90.077317999999991,29.969186999999977]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '                            "routeGuid": "{9A23C744-4182-4891-BB36-A8F73B302597}",';
        rBody += '                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '                            "childDetails": [';
        rBody += '                                {';
        rBody += '                                    "routeName": "C2 - DAISY CHAIN 5392388",';
        rBody += '                                    "demandName": "C2",';
        rBody += '                                    "facilityType": "DAISY CHAIN",';
        rBody += '                                    "facilityOid": 5392388,';
        rBody += '                                    "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '                                    "routeAsJson": "{\"paths\":[[[-90.075856438000017,29.970692095000004],[-90.075924122000004,29.970752500000003],[-90.076310999999976,29.970319000000018],[-90.076540000000023,29.970063999999979],[-90.076641968999979,29.969949056000019]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '                                    "routeGuid": "{B9CB8880-5733-4583-9453-EAA4B714993E}",';
        rBody += '                                    "parentGuid": "{9A23C744-4182-4891-BB36-A8F73B302597}",';
        rBody += '                                    "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '                                    "childDetails": [';
        rBody += '                                        {';
        rBody += '                                            "routeName": "D3 - DAISY CHAIN 5392391",';
        rBody += '                                            "demandName": "D3",';
        rBody += '                                            "facilityType": "DAISY CHAIN",';
        rBody += '                                            "facilityOid": 5392391,';
        rBody += '                                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '                                            "routeAsJson": "{\"paths\":[[[-90.075041046000024,29.971379862999981],[-90.074972666999997,29.971481212000015],[-90.075168000000019,29.971612999999991],[-90.075763999999992,29.970929000000012],[-90.075837999999976,29.970848999999987],[-90.075924122000004,29.970752500000003]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '                                            "routeGuid": "{F3AE9F72-A007-453C-A90F-2B0EB136F656}",';
        rBody += '                                            "parentGuid": "{B9CB8880-5733-4583-9453-EAA4B714993E}",';
        rBody += '                                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '                                            "childDetails": [';
        rBody += '  		                                      {';
        rBody += '                                            		"routeName": "D3 - DAISY CHAIN 5392391",';
        rBody += '                                            		"demandName": "D3",';
        rBody += '                                            		"facilityType": "DAISY CHAIN",';
        rBody += '                                            		"facilityOid": 5392391,';
        rBody += '                                            		"naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '                                            		"routeAsJson": "{\"paths\":[[[-90.075041046000024,29.971379862999981],[-90.074972666999997,29.971481212000015],[-90.075168000000019,29.971612999999991],[-90.075763999999992,29.970929000000012],[-90.075837999999976,29.970848999999987],[-90.075924122000004,29.970752500000003]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '                                            		"routeGuid": "{F3AE9F72-A007-453C-A90F-2B0EB136F656}",';
        rBody += '                                            		"parentGuid": "{B9CB8880-5733-4583-9453-EAA4B714993E}",';
        rBody += '                                            		"treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '                                            		"childDetails": [],';
        rBody += '                                            		"solveType": {';
        rBody += '                                                		"id": 1,';
        rBody += '                                                		"name": "LCR"';
        rBody += '                                            	  	},';
        rBody += '                                            	  	"geodesicLength": 515.0,';
        rBody += '                                            	  	"chainCount": 5,';
        rBody += '                                            	  	"chainRatio": 0.922339,';
        rBody += '                                            	  	"businessCount": 375,';
        rBody += '                                            	  	"lcrCost": 0.0,';
        rBody += '                                            	  	"totalCost": 40665.61080085,';
        rBody += '                                            	  	"startSegmentCost": 2778.63714378,';
        rBody += '                                            		"endSegmentCost": 0.0,';
        rBody += '                                            		"totalTreeCost": 40665.61080085,';
        rBody += '                                            		"demandToInfrastructureLength": 8206.12945859,';
        rBody += '                                            		"persistedOid": 5392392,';
        rBody += '                                            		"lengthUnits": "Foot",';
        rBody += '                                            		"crewCost": 7187.59,';
        rBody += '                                            		"accessCost": 0.0,';
        rBody += '                                            		"minLateralCost": 0.0,';
        rBody += '                                            		"createdDate": null,';
        rBody += '                                            		"lastEditedDate": null';
        rBody += '                                               }';
            
        rBody += '                                             ],';
        rBody += '                                            "solveType": {';
        rBody += '                                                "id": 1,';
        rBody += '                                                "name": "LCR"';
        rBody += '                                            },';
        rBody += '                                            "geodesicLength": 515.0,';
        rBody += '                                            "chainCount": 5,';
        rBody += '                                            "chainRatio": 0.922339,';
        rBody += '                                            "businessCount": 375,';
        rBody += '                                            "lcrCost": 0.0,';
        rBody += '                                            "totalCost": 40665.61080085,';
        rBody += '                                            "startSegmentCost": 2778.63714378,';
        rBody += '                                            "endSegmentCost": 0.0,';
        rBody += '                                            "totalTreeCost": 40665.61080085,';
        rBody += '                                            "demandToInfrastructureLength": 8206.12945859,';
        rBody += '                                            "persistedOid": 5392392,';
        rBody += '                                            "lengthUnits": "Foot",';
        rBody += '                                            "crewCost": 7187.59,';
        rBody += '                                            "accessCost": 0.0,';
        rBody += '                                            "minLateralCost": 0.0,';
        rBody += '                                            "createdDate": null,';
        rBody += '                                            "lastEditedDate": null';
        rBody += '                                        }';
        rBody += '                                    ],';
        rBody += '                                    "solveType": {';
        rBody += '                                        "id": 1,';
        rBody += '                                        "name": "LCR"';
        rBody += '                                    },';
        rBody += '                                    "geodesicLength": 401.0,';
        rBody += '                                    "chainCount": 4,';
        rBody += '                                    "chainRatio": 0.91282539,';
        rBody += '                                    "businessCount": 428,';
        rBody += '                                    "lcrCost": 0.0,';
        rBody += '                                    "totalCost": 33245.72519549,';
        rBody += '                                    "startSegmentCost": 1994.92458822,';
        rBody += '                                    "endSegmentCost": 0.0,';
        rBody += '                                    "totalTreeCost": 73911.33599634,';
        rBody += '                                    "demandToInfrastructureLength": 7722.27151959,';
        rBody += '                                    "persistedOid": 5392391,';
        rBody += '                                    "lengthUnits": "Foot",';
        rBody += '                                    "crewCost": 7187.59,';
        rBody += '                                    "accessCost": 0.0,';
        rBody += '                                    "minLateralCost": 0.0,';
        rBody += '                                    "createdDate": null,';
        rBody += '                                    "lastEditedDate": null';
        rBody += '                                }';
        rBody += '                            ],';
        rBody += '                            "solveType": {';
        rBody += '                                "id": 1,';
        rBody += '                                "name": "LCR"';
        rBody += '                            },';
        rBody += '                            "geodesicLength": 383.0,';
        rBody += '                            "chainCount": 3,';
        rBody += '                            "chainRatio": 0.08194151,';
        rBody += '                            "businessCount": 404,';
        rBody += '                            "lcrCost": 0.0,';
        rBody += '                            "totalCost": 32088.70351604,';
        rBody += '                            "startSegmentCost": 2138.45202814,';
        rBody += '                            "endSegmentCost": 0.0,';
        rBody += '                            "totalTreeCost": 106000.03951238,';
        rBody += '                            "demandToInfrastructureLength": 7354.65939522,';
        rBody += '                            "persistedOid": 5392388,';
        rBody += '                            "lengthUnits": "Foot",';
        rBody += '                            "crewCost": 7187.59,';
        rBody += '                            "accessCost": 0.0,';
        rBody += '                            "minLateralCost": 0.0,';
        rBody += '                            "createdDate": null,';
        rBody += '                            "lastEditedDate": null';
        rBody += '                        },';
        rBody += '                        {';
        rBody += '                            "routeName": "H7 - DAISY CHAIN 5392386",';
        rBody += '                            "demandName": "H7",';
        rBody += '                            "facilityType": "DAISY CHAIN",';
        rBody += '                            "facilityOid": 5392386,';
        rBody += '                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '                            "routeAsJson": "{\"paths\":[[[-90.081274500000006,29.972039742999982],[-90.081328197000005,29.971960749000004],[-90.080212000000017,29.971202000000005]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '                            "routeGuid": "{D35EE5A9-0C2D-424E-A591-35B88FAA2C7C}",';
        rBody += '                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '                            "childDetails": [],';
        rBody += '                            "solveType": {';
        rBody += '                                "id": 1,';
        rBody += '                                "name": "LCR"';
        rBody += '                            },';
        rBody += '                            "geodesicLength": 482.0,';
        rBody += '                            "chainCount": 3,';
        rBody += '                            "chainRatio": 0.93368457,';
        rBody += '                            "businessCount": 161,';
        rBody += '                            "lcrCost": 0.0,';
        rBody += '                            "totalCost": 38503.73683915,';
        rBody += '                            "startSegmentCost": 2169.92614291,';
        rBody += '                            "endSegmentCost": 0.0,';
        rBody += '                            "totalTreeCost": 38503.73683915,';
        rBody += '                            "demandToInfrastructureLength": 8632.47179026,';
        rBody += '                            "persistedOid": 5392389,';
        rBody += '                            "lengthUnits": "Foot",';
        rBody += '                            "crewCost": 7187.59,';
        rBody += '                            "accessCost": 0.0,';
        rBody += '                            "minLateralCost": 0.0,';
        rBody += '                            "createdDate": null,';
        rBody += '                            "lastEditedDate": null';
        rBody += '                        },';
        rBody += '                        {';
        rBody += '                            "routeName": "F5 - DAISY CHAIN 5392386",';
        rBody += '                            "demandName": "F5",';
        rBody += '                            "facilityType": "DAISY CHAIN",';
        rBody += '                            "facilityOid": 5392386,';
        rBody += '                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '                            "routeAsJson": "{\"paths\":[[[-90.079064360000018,29.970264562000011],[-90.079124401000001,29.970315203999974],[-90.079063000000019,29.970388000000014]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '                            "routeGuid": "{92B7C311-392E-4369-8A8C-EC5F2A423965}",';
        rBody += '                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '                            "childDetails": [],';
        rBody += '                            "solveType": {';
        rBody += '                                "id": 1,';
        rBody += '                                "name": "LCR"';
        rBody += '                            },';
        rBody += '                            "geodesicLength": 59.0,';
        rBody += '                            "chainCount": 3,';
        rBody += '                            "chainRatio": 0.59358414,';
        rBody += '                            "businessCount": 244,';
        rBody += '                            "lcrCost": 0.0,';
        rBody += '                            "totalCost": 17000.0,';
        rBody += '                            "startSegmentCost": 1720.56231879,';
        rBody += '                            "endSegmentCost": 0.0,';
        rBody += '                            "totalTreeCost": 17000.0,';
        rBody += '                            "demandToInfrastructureLength": 7738.77279514,';
        rBody += '                            "persistedOid": 5392390,';
        rBody += '                            "lengthUnits": "Foot",';
        rBody += '                            "crewCost": 7187.59,';
        rBody += '                            "accessCost": 0.0,';
        rBody += '                            "minLateralCost": 0.0,';
        rBody += '                            "createdDate": null,';
        rBody += '                            "lastEditedDate": null';
        rBody += '                        }';
        rBody += '                    ],';
        rBody += '                    "solveType": {';
        rBody += '                        "id": 1,';
        rBody += '                        "name": "LCR"';
        rBody += '                    },';
        rBody += '                    "geodesicLength": 1384.0,';
        rBody += '                    "chainCount": 2,';
        rBody += '                    "chainRatio": 0.99236758,';
        rBody += '                    "businessCount": 399,';
        rBody += '                    "lcrCost": 0.0,';
        rBody += '                    "totalCost": 97116.45790917,';
        rBody += '                    "startSegmentCost": 2956.30145143,';
        rBody += '                    "endSegmentCost": 0.0,';
        rBody += '                    "totalTreeCost": 275620.2342607,';
        rBody += '                    "demandToInfrastructureLength": 8242.25234538,';
        rBody += '                    "persistedOid": 5392386,';
        rBody += '                    "lengthUnits": "Foot",';
        rBody += '                    "crewCost": 7187.59,';
        rBody += '                    "accessCost": 0.0,';
        rBody += '                    "minLateralCost": 0.0,';
        rBody += '                    "createdDate": null,';
        rBody += '                    "lastEditedDate": null';
        rBody += '                }';
        rBody += '            ],';
        rBody += '            "solveType": {';
        rBody += '                "id": 1,';
        rBody += '                "name": "LCR"';
        rBody += '            },';
        rBody += '            "geodesicLength": 6911.0,';
        rBody += '            "chainCount": 1,';
        rBody += '            "chainRatio": 0.0,';
        rBody += '            "businessCount": 404,';
        rBody += '            "lcrCost": 0.0,';
        rBody += '            "totalCost": 352645.49247436,';
        rBody += '            "startSegmentCost": 3365.7328753,';
        rBody += '            "endSegmentCost": 812.33743427,';
        rBody += '            "totalTreeCost": 628265.72673506,';
        rBody += '            "demandToInfrastructureLength": 6911.0,';
        rBody += '            "persistedOid": 5392385,';
        rBody += '            "lengthUnits": "Foot",';
        rBody += '            "crewCost": 7187.59,';
        rBody += '            "accessCost": 0.0,';
        rBody += '            "minLateralCost": 0.0,';
        rBody += '            "createdDate": null,';
        rBody += '            "lastEditedDate": null';
        rBody += '        }';
        rBody += '    ]';
        rBody += '}';
        
        return rBody;
    }//end method getProspectorGetRoutesByProjectCalloutJsonString

    public static String getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesMHHH() {
        System.debug('getProspectorGetRoutesByProjectCalloutJsonStringWithNewLines...');
        String rBody = '';
        
        rBody += '{';  //Line 1
        rBody += '\n    "status": "success",';
        rBody += '\n    "message": null,';
        rBody += '\n    "payload": [';
        rBody += '\n        {';
        rBody += '\n            "routeName": "A0 - MH_HH_1134141",';
        rBody += '\n            "demandName": "FOLEY36535",';
        rBody += '\n            "facilityType": "MH_HH",';
        rBody += '\n            "facilityOid": 1134141,';
        rBody += '\n            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n            "routeAsJson": "{\"paths\":[[[-90.07765888199998,29.969037716000003],[-90.077545385999997,29.968935217000023],[-90.078044999999975,29.96838200000002],[-90.078463999999997,29.967922999999985],[-90.077671000000009,29.967367000000024],[-90.077642000000026,29.96734600000002],[-90.077616999999975,29.967326000000014],[-90.077649000000008,29.967289999999991],[-90.077693000000011,29.967243999999994],[-90.077746999999988,29.967190000000016],[-90.077767999999992,29.96704299999999],[-90.078614000000016,29.965998000000013],[-90.078730000000007,29.965872999999988],[-90.078958999999998,29.965619000000004],[-90.079158000000007,29.965395000000001],[-90.079298999999992,29.965220999999985],[-90.079926999999998,29.964531000000022],[-90.080343000000028,29.96405900000002],[-90.080605999999989,29.963755999999989],[-90.08063199999998,29.963729999999998],[-90.080693999999994,29.963655000000017],[-90.080984999999998,29.963326999999992],[-90.081330999999977,29.962935000000016],[-90.081715999999972,29.962542999999982],[-90.082090999999991,29.962124000000017],[-90.082134999999994,29.962072999999975],[-90.082174000000009,29.962028999999973],[-90.082218000000012,29.961977999999988],[-90.082560999999998,29.961610000000007],[-90.082990999999993,29.96109100000001],[-90.083730000000003,29.960274000000027],[-90.084171000000026,29.959773999999982],[-90.084420786999999,29.959490524999978],[-90.084474999999998,29.959429],[-90.084439999999972,29.959400000000016],[-90.084411999999986,29.95938000000001],[-90.084357000000011,29.959337000000005],[-90.084213999999974,29.959233999999981],[-90.08372700000001,29.958884000000012],[-90.082827000000009,29.958321000000012],[-90.082716000000005,29.958271000000025],[-90.082736000000011,29.95817199999999],[-90.083144000000004,29.956866999999988],[-90.083310999999981,29.956241999999975],[-90.083521000000019,29.955439000000013],[-90.083740999999975,29.954741000000013],[-90.083803999999986,29.954530999999974],[-90.083820000000003,29.95447999999999],[-90.083882000000017,29.954350999999974],[-90.083893999999987,29.95432599999998],[-90.083920999999975,29.954274999999996],[-90.083872999999983,29.954254999999989],[-90.083358148000002,29.954025709999996],[-90.083321049999995,29.954109010000025]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n            "routeGuid": "{2F37B9F4-E5F4-47CE-A5CC-C575C5894FF9}",';
        rBody += '\n            "parentGuid": "",';
        rBody += '\n            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",'; //Line 14
        rBody += '\n            "childDetails": [';
        rBody += '\n                {';
        rBody += '\n                    "routeName": "G6 - DAISY CHAIN 5392385",';
        rBody += '\n                    "demandName": "G6",';
        rBody += '\n                    "facilityType": "DAISY CHAIN",';
        rBody += '\n                    "facilityOid": 5392385,';
        rBody += '\n                    "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                    "routeAsJson": "{\"paths\":[[[-90.080201616000011,29.971008096999981],[-90.080303499000024,29.971096247999981],[-90.080212000000017,29.971202000000005],[-90.079063000000019,29.970388000000014],[-90.078178999999977,29.969780000000014],[-90.077317999999991,29.969186999999977],[-90.077545385999997,29.968935217000023]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                    "routeGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '\n                    "parentGuid": "{2F37B9F4-E5F4-47CE-A5CC-C575C5894FF9}",';
        rBody += '\n                    "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                    "childDetails": [';
        rBody += '\n                        {';
        rBody += '\n                            "routeName": "E4 - DAISY CHAIN 5392386",';
        rBody += '\n                            "demandName": "E4",';
        rBody += '\n                            "facilityType": "DAISY CHAIN",';
        rBody += '\n                            "facilityOid": 5392386,';
        rBody += '\n                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                            "routeAsJson": "{\"paths\":[[[-90.078216782000027,29.96966043499998],[-90.078255329000001,29.969695084000023],[-90.078178999999977,29.969780000000014]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                            "routeGuid": "{4563223B-3C66-4551-8935-4298F427590E}",';
        rBody += '\n                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '\n                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                            "childDetails": [],';
        rBody += '\n                            "solveType": {';
        rBody += '\n                                "id": 1,';
        rBody += '\n                                "name": "LCR"';
        rBody += '\n                            },';
        rBody += '\n                            "geodesicLength": 57.0,';
        rBody += '\n                            "chainCount": 3,';
        rBody += '\n                            "chainRatio": 0.33444778,';
        rBody += '\n                            "businessCount": 305,';
        rBody += '\n                            "lcrCost": 0.0,';
        rBody += '\n                            "totalCost": 17000.0,';
        rBody += '\n                            "startSegmentCost": 1140.3387724,';
        rBody += '\n                            "endSegmentCost": 0.0,';
        rBody += '\n                            "totalTreeCost": 17000.0,';
        rBody += '\n                            "demandToInfrastructureLength": 7378.1280729,';
        rBody += '\n                            "persistedOid": 5392387,';
        rBody += '\n                            "lengthUnits": "Foot",';
        rBody += '\n                            "crewCost": 7187.59,';
        rBody += '\n                            "accessCost": 0.0,';
        rBody += '\n                            "minLateralCost": 0.0,';
        rBody += '\n                            "createdDate": null,';
        rBody += '\n                            "lastEditedDate": null';
        rBody += '\n                        },';
        rBody += '\n                        {';
        rBody += '\n                            "routeName": "B1 - DAISY CHAIN 5392386",';
        rBody += '\n                            "demandName": "B1",';
        rBody += '\n                            "facilityType": "DAISY CHAIN",';
        rBody += '\n                            "facilityOid": 5392386,';
        rBody += '\n                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                            "routeAsJson": "{\"paths\":[[[-90.076714745000004,29.970013617000006],[-90.076641968999979,29.969949056000019],[-90.077317999999991,29.969186999999977]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                            "routeGuid": "{9A23C744-4182-4891-BB36-A8F73B302597}",';
        rBody += '\n                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '\n                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                            "childDetails": [';
        rBody += '\n                                {';
        rBody += '\n                                    "routeName": "C2 - DAISY CHAIN 5392388",';
        rBody += '\n                                    "demandName": "C2",';
        rBody += '\n                                    "facilityType": "DAISY CHAIN",';
        rBody += '\n                                    "facilityOid": 5392388,';
        rBody += '\n                                    "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                                    "routeAsJson": "{\"paths\":[[[-90.075856438000017,29.970692095000004],[-90.075924122000004,29.970752500000003],[-90.076310999999976,29.970319000000018],[-90.076540000000023,29.970063999999979],[-90.076641968999979,29.969949056000019]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                                    "routeGuid": "{B9CB8880-5733-4583-9453-EAA4B714993E}",';
        rBody += '\n                                    "parentGuid": "{9A23C744-4182-4891-BB36-A8F73B302597}",';
        rBody += '\n                                    "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                                    "childDetails": [';
        rBody += '\n                                        {';
        rBody += '\n                                            "routeName": "D3 - DAISY CHAIN 5392391",';
        rBody += '\n                                            "demandName": "D3",';
        rBody += '\n                                            "facilityType": "DAISY CHAIN",';
        rBody += '\n                                            "facilityOid": 5392391,';
        rBody += '\n                                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                                            "routeAsJson": "{\"paths\":[[[-90.075041046000024,29.971379862999981],[-90.074972666999997,29.971481212000015],[-90.075168000000019,29.971612999999991],[-90.075763999999992,29.970929000000012],[-90.075837999999976,29.970848999999987],[-90.075924122000004,29.970752500000003]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                                            "routeGuid": "{F3AE9F72-A007-453C-A90F-2B0EB136F656}",';
        rBody += '\n                                            "parentGuid": "{B9CB8880-5733-4583-9453-EAA4B714993E}",';
        rBody += '\n                                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                                            "childDetails": [],';
        rBody += '\n                                            "solveType": {';
        rBody += '\n                                                "id": 1,';
        rBody += '\n                                                "name": "LCR"';
        rBody += '\n                                            },';
        rBody += '\n                                            "geodesicLength": 515.0,';
        rBody += '\n                                            "chainCount": 5,';
        rBody += '\n                                            "chainRatio": 0.922339,';
        rBody += '\n                                            "businessCount": 375,';
        rBody += '\n                                            "lcrCost": 0.0,';
        rBody += '\n                                            "totalCost": 40665.61080085,';
        rBody += '\n                                            "startSegmentCost": 2778.63714378,';
        rBody += '\n                                            "endSegmentCost": 0.0,';
        rBody += '\n                                            "totalTreeCost": 40665.61080085,';
        rBody += '\n                                            "demandToInfrastructureLength": 8206.12945859,';
        rBody += '\n                                            "persistedOid": 5392392,';
        rBody += '\n                                            "lengthUnits": "Foot",';
        rBody += '\n                                            "crewCost": 7187.59,';
        rBody += '\n                                            "accessCost": 0.0,';
        rBody += '\n                                            "minLateralCost": 0.0,';
        rBody += '\n                                            "createdDate": null,';
        rBody += '\n                                            "lastEditedDate": null';
        rBody += '\n                                        }';
        rBody += '\n                                    ],';
        rBody += '\n                                    "solveType": {';
        rBody += '\n                                        "id": 1,';
        rBody += '\n                                        "name": "LCR"';
        rBody += '\n                                    },';
        rBody += '\n                                    "geodesicLength": 401.0,';
        rBody += '\n                                    "chainCount": 4,';
        rBody += '\n                                    "chainRatio": 0.91282539,';
        rBody += '\n                                    "businessCount": 428,';
        rBody += '\n                                    "lcrCost": 0.0,';
        rBody += '\n                                    "totalCost": 33245.72519549,';
        rBody += '\n                                    "startSegmentCost": 1994.92458822,';
        rBody += '\n                                    "endSegmentCost": 0.0,';
        rBody += '\n                                    "totalTreeCost": 73911.33599634,';
        rBody += '\n                                    "demandToInfrastructureLength": 7722.27151959,';
        rBody += '\n                                    "persistedOid": 5392391,';
        rBody += '\n                                    "lengthUnits": "Foot",';
        rBody += '\n                                    "crewCost": 7187.59,';
        rBody += '\n                                    "accessCost": 0.0,';
        rBody += '\n                                    "minLateralCost": 0.0,';
        rBody += '\n                                    "createdDate": null,';
        rBody += '\n                                    "lastEditedDate": null';
        rBody += '\n                                }';
        rBody += '\n                            ],';
        rBody += '\n                            "solveType": {';
        rBody += '\n                                "id": 1,';
        rBody += '\n                                "name": "LCR"';
        rBody += '\n                            },';
        rBody += '\n                            "geodesicLength": 383.0,';
        rBody += '\n                            "chainCount": 3,';
        rBody += '\n                            "chainRatio": 0.08194151,';
        rBody += '\n                            "businessCount": 404,';
        rBody += '\n                            "lcrCost": 0.0,';
        rBody += '\n                            "totalCost": 32088.70351604,';
        rBody += '\n                            "startSegmentCost": 2138.45202814,';
        rBody += '\n                            "endSegmentCost": 0.0,';
        rBody += '\n                            "totalTreeCost": 106000.03951238,';
        rBody += '\n                            "demandToInfrastructureLength": 7354.65939522,';
        rBody += '\n                            "persistedOid": 5392388,';
        rBody += '\n                            "lengthUnits": "Foot",';
        rBody += '\n                            "crewCost": 7187.59,';
        rBody += '\n                            "accessCost": 0.0,';
        rBody += '\n                            "minLateralCost": 0.0,';
        rBody += '\n                            "createdDate": null,';
        rBody += '\n                            "lastEditedDate": null';
        rBody += '\n                        },';
        rBody += '\n                        {';
        rBody += '\n                            "routeName": "H7 - DAISY CHAIN 5392386",';
        rBody += '\n                            "demandName": "H7",';
        rBody += '\n                            "facilityType": "DAISY CHAIN",';
        rBody += '\n                            "facilityOid": 5392386,';
        rBody += '\n                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                            "routeAsJson": "{\"paths\":[[[-90.081274500000006,29.972039742999982],[-90.081328197000005,29.971960749000004],[-90.080212000000017,29.971202000000005]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                            "routeGuid": "{D35EE5A9-0C2D-424E-A591-35B88FAA2C7C}",';
        rBody += '\n                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '\n                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                            "childDetails": [],';
        rBody += '\n                            "solveType": {';
        rBody += '\n                                "id": 1,';
        rBody += '\n                                "name": "LCR"';
        rBody += '\n                            },';
        rBody += '\n                            "geodesicLength": 482.0,';
        rBody += '\n                            "chainCount": 3,';
        rBody += '\n                            "chainRatio": 0.93368457,';
        rBody += '\n                            "businessCount": 161,';
        rBody += '\n                            "lcrCost": 0.0,';
        rBody += '\n                            "totalCost": 38503.73683915,';
        rBody += '\n                            "startSegmentCost": 2169.92614291,';
        rBody += '\n                            "endSegmentCost": 0.0,';
        rBody += '\n                            "totalTreeCost": 38503.73683915,';
        rBody += '\n                            "demandToInfrastructureLength": 8632.47179026,';
        rBody += '\n                            "persistedOid": 5392389,';
        rBody += '\n                            "lengthUnits": "Foot",';
        rBody += '\n                            "crewCost": 7187.59,';
        rBody += '\n                            "accessCost": 0.0,';
        rBody += '\n                            "minLateralCost": 0.0,';
        rBody += '\n                            "createdDate": null,';
        rBody += '\n                            "lastEditedDate": null';
        rBody += '\n                        },';
        rBody += '\n                        {';
        rBody += '\n                            "routeName": "F5 - DAISY CHAIN 5392386",';
        rBody += '\n                            "demandName": "F5",';
        rBody += '\n                            "facilityType": "DAISY CHAIN",';
        rBody += '\n                            "facilityOid": 5392386,';
        rBody += '\n                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                            "routeAsJson": "{\"paths\":[[[-90.079064360000018,29.970264562000011],[-90.079124401000001,29.970315203999974],[-90.079063000000019,29.970388000000014]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                            "routeGuid": "{92B7C311-392E-4369-8A8C-EC5F2A423965}",';
        rBody += '\n                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '\n                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                            "childDetails": [],';
        rBody += '\n                            "solveType": {';
        rBody += '\n                                "id": 1,';
        rBody += '\n                                "name": "LCR"';
        rBody += '\n                            },';
        rBody += '\n                            "geodesicLength": 59.0,';
        rBody += '\n                            "chainCount": 3,';
        rBody += '\n                            "chainRatio": 0.59358414,';
        rBody += '\n                            "businessCount": 244,';
        rBody += '\n                            "lcrCost": 0.0,';
        rBody += '\n                            "totalCost": 17000.0,';
        rBody += '\n                            "startSegmentCost": 1720.56231879,';
        rBody += '\n                            "endSegmentCost": 0.0,';
        rBody += '\n                            "totalTreeCost": 17000.0,';
        rBody += '\n                            "demandToInfrastructureLength": 7738.77279514,';
        rBody += '\n                            "persistedOid": 5392390,';
        rBody += '\n                            "lengthUnits": "Foot",';
        rBody += '\n                            "crewCost": 7187.59,';
        rBody += '\n                            "accessCost": 0.0,';
        rBody += '\n                            "minLateralCost": 0.0,';
        rBody += '\n                            "createdDate": null,';
        rBody += '\n                            "lastEditedDate": null';
        rBody += '\n                        }';
        rBody += '\n                    ],';
        rBody += '\n                    "solveType": {';
        rBody += '\n                        "id": 1,';
        rBody += '\n                        "name": "LCR"';
        rBody += '\n                    },';
        rBody += '\n                    "geodesicLength": 1384.0,';
        rBody += '\n                    "chainCount": 2,';
        rBody += '\n                    "chainRatio": 0.99236758,';
        rBody += '\n                    "businessCount": 399,';
        rBody += '\n                    "lcrCost": 0.0,';
        rBody += '\n                    "totalCost": 97116.45790917,';
        rBody += '\n                    "startSegmentCost": 2956.30145143,';
        rBody += '\n                    "endSegmentCost": 0.0,';
        rBody += '\n                    "totalTreeCost": 275620.2342607,';
        rBody += '\n                    "demandToInfrastructureLength": 8242.25234538,';
        rBody += '\n                    "persistedOid": 5392386,';
        rBody += '\n                    "lengthUnits": "Foot",';
        rBody += '\n                    "crewCost": 7187.59,';
        rBody += '\n                    "accessCost": 0.0,';
        rBody += '\n                    "minLateralCost": 0.0,';
        rBody += '\n                    "createdDate": null,';
        rBody += '\n                    "lastEditedDate": null';
        rBody += '\n                }';
        rBody += '\n            ],';
        rBody += '\n            "solveType": {';
        rBody += '\n                "id": 1,';
        rBody += '\n                "name": "LCR"';
        rBody += '\n            },';
        rBody += '\n            "geodesicLength": 6911.0,';
        rBody += '\n            "chainCount": 1,';
        rBody += '\n            "chainRatio": 0.0,';
        rBody += '\n            "businessCount": 404,';
        rBody += '\n            "lcrCost": 0.0,';
        rBody += '\n            "totalCost": 352645.49247436,';
        rBody += '\n            "startSegmentCost": 3365.7328753,';
        rBody += '\n            "endSegmentCost": 812.33743427,';
        rBody += '\n            "totalTreeCost": 628265.72673506,';
        rBody += '\n            "demandToInfrastructureLength": 6911.0,';
        rBody += '\n            "persistedOid": 5392385,';
        rBody += '\n            "lengthUnits": "Foot",';
        rBody += '\n            "crewCost": 7187.59,';
        rBody += '\n            "accessCost": 0.0,';
        rBody += '\n            "minLateralCost": 0.0,';
        rBody += '\n            "createdDate": null,';
        rBody += '\n            "lastEditedDate": null';
        rBody += '\n        }';
        rBody += '\n    ]';
        rBody += '\n}';
        
        return rBody;
    }//end method getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesMHHH


    public static String getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesSpliceClosure() {
        System.debug('getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesSpliceClosure...');
        String rBody = '';
        
        rBody += '{';  //Line 1
        rBody += '\n    "status": "success",';
        rBody += '\n    "message": null,';
        rBody += '\n    "payload": [';
        rBody += '\n        {';
        rBody += '\n            "routeName": "A0 - Splice_Closure_1134141",';
        rBody += '\n            "demandName": "FOLEY36535",';
        rBody += '\n            "facilityType": "Splice_Closure",';
        rBody += '\n            "facilityOid": 1134141,';
        rBody += '\n            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n            "routeAsJson": "{\"paths\":[[[-90.07765888199998,29.969037716000003],[-90.077545385999997,29.968935217000023],[-90.078044999999975,29.96838200000002],[-90.078463999999997,29.967922999999985],[-90.077671000000009,29.967367000000024],[-90.077642000000026,29.96734600000002],[-90.077616999999975,29.967326000000014],[-90.077649000000008,29.967289999999991],[-90.077693000000011,29.967243999999994],[-90.077746999999988,29.967190000000016],[-90.077767999999992,29.96704299999999],[-90.078614000000016,29.965998000000013],[-90.078730000000007,29.965872999999988],[-90.078958999999998,29.965619000000004],[-90.079158000000007,29.965395000000001],[-90.079298999999992,29.965220999999985],[-90.079926999999998,29.964531000000022],[-90.080343000000028,29.96405900000002],[-90.080605999999989,29.963755999999989],[-90.08063199999998,29.963729999999998],[-90.080693999999994,29.963655000000017],[-90.080984999999998,29.963326999999992],[-90.081330999999977,29.962935000000016],[-90.081715999999972,29.962542999999982],[-90.082090999999991,29.962124000000017],[-90.082134999999994,29.962072999999975],[-90.082174000000009,29.962028999999973],[-90.082218000000012,29.961977999999988],[-90.082560999999998,29.961610000000007],[-90.082990999999993,29.96109100000001],[-90.083730000000003,29.960274000000027],[-90.084171000000026,29.959773999999982],[-90.084420786999999,29.959490524999978],[-90.084474999999998,29.959429],[-90.084439999999972,29.959400000000016],[-90.084411999999986,29.95938000000001],[-90.084357000000011,29.959337000000005],[-90.084213999999974,29.959233999999981],[-90.08372700000001,29.958884000000012],[-90.082827000000009,29.958321000000012],[-90.082716000000005,29.958271000000025],[-90.082736000000011,29.95817199999999],[-90.083144000000004,29.956866999999988],[-90.083310999999981,29.956241999999975],[-90.083521000000019,29.955439000000013],[-90.083740999999975,29.954741000000013],[-90.083803999999986,29.954530999999974],[-90.083820000000003,29.95447999999999],[-90.083882000000017,29.954350999999974],[-90.083893999999987,29.95432599999998],[-90.083920999999975,29.954274999999996],[-90.083872999999983,29.954254999999989],[-90.083358148000002,29.954025709999996],[-90.083321049999995,29.954109010000025]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n            "routeGuid": "{2F37B9F4-E5F4-47CE-A5CC-C575C5894FF9}",';
        rBody += '\n            "parentGuid": "",';
        rBody += '\n            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",'; //Line 14
        rBody += '\n            "childDetails": [';
        rBody += '\n                {';
        rBody += '\n                    "routeName": "G6 - DAISY CHAIN 5392385",';
        rBody += '\n                    "demandName": "G6",';
        rBody += '\n                    "facilityType": "DAISY CHAIN",';
        rBody += '\n                    "facilityOid": 5392385,';
        rBody += '\n                    "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                    "routeAsJson": "{\"paths\":[[[-90.080201616000011,29.971008096999981],[-90.080303499000024,29.971096247999981],[-90.080212000000017,29.971202000000005],[-90.079063000000019,29.970388000000014],[-90.078178999999977,29.969780000000014],[-90.077317999999991,29.969186999999977],[-90.077545385999997,29.968935217000023]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                    "routeGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '\n                    "parentGuid": "{2F37B9F4-E5F4-47CE-A5CC-C575C5894FF9}",';
        rBody += '\n                    "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                    "childDetails": [';
        rBody += '\n                        {';
        rBody += '\n                            "routeName": "E4 - DAISY CHAIN 5392386",';
        rBody += '\n                            "demandName": "E4",';
        rBody += '\n                            "facilityType": "DAISY CHAIN",';
        rBody += '\n                            "facilityOid": 5392386,';
        rBody += '\n                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                            "routeAsJson": "{\"paths\":[[[-90.078216782000027,29.96966043499998],[-90.078255329000001,29.969695084000023],[-90.078178999999977,29.969780000000014]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                            "routeGuid": "{4563223B-3C66-4551-8935-4298F427590E}",';
        rBody += '\n                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '\n                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                            "childDetails": [],';
        rBody += '\n                            "solveType": {';
        rBody += '\n                                "id": 1,';
        rBody += '\n                                "name": "LCR"';
        rBody += '\n                            },';
        rBody += '\n                            "geodesicLength": 57.0,';
        rBody += '\n                            "chainCount": 3,';
        rBody += '\n                            "chainRatio": 0.33444778,';
        rBody += '\n                            "businessCount": 305,';
        rBody += '\n                            "lcrCost": 0.0,';
        rBody += '\n                            "totalCost": 17000.0,';
        rBody += '\n                            "startSegmentCost": 1140.3387724,';
        rBody += '\n                            "endSegmentCost": 0.0,';
        rBody += '\n                            "totalTreeCost": 17000.0,';
        rBody += '\n                            "demandToInfrastructureLength": 7378.1280729,';
        rBody += '\n                            "persistedOid": 5392387,';
        rBody += '\n                            "lengthUnits": "Foot",';
        rBody += '\n                            "crewCost": 7187.59,';
        rBody += '\n                            "accessCost": 0.0,';
        rBody += '\n                            "minLateralCost": 0.0,';
        rBody += '\n                            "createdDate": null,';
        rBody += '\n                            "lastEditedDate": null';
        rBody += '\n                        },';
        rBody += '\n                        {';
        rBody += '\n                            "routeName": "B1 - DAISY CHAIN 5392386",';
        rBody += '\n                            "demandName": "B1",';
        rBody += '\n                            "facilityType": "DAISY CHAIN",';
        rBody += '\n                            "facilityOid": 5392386,';
        rBody += '\n                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                            "routeAsJson": "{\"paths\":[[[-90.076714745000004,29.970013617000006],[-90.076641968999979,29.969949056000019],[-90.077317999999991,29.969186999999977]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                            "routeGuid": "{9A23C744-4182-4891-BB36-A8F73B302597}",';
        rBody += '\n                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '\n                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                            "childDetails": [';
        rBody += '\n                                {';
        rBody += '\n                                    "routeName": "C2 - DAISY CHAIN 5392388",';
        rBody += '\n                                    "demandName": "C2",';
        rBody += '\n                                    "facilityType": "DAISY CHAIN",';
        rBody += '\n                                    "facilityOid": 5392388,';
        rBody += '\n                                    "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                                    "routeAsJson": "{\"paths\":[[[-90.075856438000017,29.970692095000004],[-90.075924122000004,29.970752500000003],[-90.076310999999976,29.970319000000018],[-90.076540000000023,29.970063999999979],[-90.076641968999979,29.969949056000019]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                                    "routeGuid": "{B9CB8880-5733-4583-9453-EAA4B714993E}",';
        rBody += '\n                                    "parentGuid": "{9A23C744-4182-4891-BB36-A8F73B302597}",';
        rBody += '\n                                    "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                                    "childDetails": [';
        rBody += '\n                                        {';
        rBody += '\n                                            "routeName": "D3 - DAISY CHAIN 5392391",';
        rBody += '\n                                            "demandName": "D3",';
        rBody += '\n                                            "facilityType": "DAISY CHAIN",';
        rBody += '\n                                            "facilityOid": 5392391,';
        rBody += '\n                                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                                            "routeAsJson": "{\"paths\":[[[-90.075041046000024,29.971379862999981],[-90.074972666999997,29.971481212000015],[-90.075168000000019,29.971612999999991],[-90.075763999999992,29.970929000000012],[-90.075837999999976,29.970848999999987],[-90.075924122000004,29.970752500000003]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                                            "routeGuid": "{F3AE9F72-A007-453C-A90F-2B0EB136F656}",';
        rBody += '\n                                            "parentGuid": "{B9CB8880-5733-4583-9453-EAA4B714993E}",';
        rBody += '\n                                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                                            "childDetails": [],';
        rBody += '\n                                            "solveType": {';
        rBody += '\n                                                "id": 1,';
        rBody += '\n                                                "name": "LCR"';
        rBody += '\n                                            },';
        rBody += '\n                                            "geodesicLength": 515.0,';
        rBody += '\n                                            "chainCount": 5,';
        rBody += '\n                                            "chainRatio": 0.922339,';
        rBody += '\n                                            "businessCount": 375,';
        rBody += '\n                                            "lcrCost": 0.0,';
        rBody += '\n                                            "totalCost": 40665.61080085,';
        rBody += '\n                                            "startSegmentCost": 2778.63714378,';
        rBody += '\n                                            "endSegmentCost": 0.0,';
        rBody += '\n                                            "totalTreeCost": 40665.61080085,';
        rBody += '\n                                            "demandToInfrastructureLength": 8206.12945859,';
        rBody += '\n                                            "persistedOid": 5392392,';
        rBody += '\n                                            "lengthUnits": "Foot",';
        rBody += '\n                                            "crewCost": 7187.59,';
        rBody += '\n                                            "accessCost": 0.0,';
        rBody += '\n                                            "minLateralCost": 0.0,';
        rBody += '\n                                            "createdDate": null,';
        rBody += '\n                                            "lastEditedDate": null';
        rBody += '\n                                        }';
        rBody += '\n                                    ],';
        rBody += '\n                                    "solveType": {';
        rBody += '\n                                        "id": 1,';
        rBody += '\n                                        "name": "LCR"';
        rBody += '\n                                    },';
        rBody += '\n                                    "geodesicLength": 401.0,';
        rBody += '\n                                    "chainCount": 4,';
        rBody += '\n                                    "chainRatio": 0.91282539,';
        rBody += '\n                                    "businessCount": 428,';
        rBody += '\n                                    "lcrCost": 0.0,';
        rBody += '\n                                    "totalCost": 33245.72519549,';
        rBody += '\n                                    "startSegmentCost": 1994.92458822,';
        rBody += '\n                                    "endSegmentCost": 0.0,';
        rBody += '\n                                    "totalTreeCost": 73911.33599634,';
        rBody += '\n                                    "demandToInfrastructureLength": 7722.27151959,';
        rBody += '\n                                    "persistedOid": 5392391,';
        rBody += '\n                                    "lengthUnits": "Foot",';
        rBody += '\n                                    "crewCost": 7187.59,';
        rBody += '\n                                    "accessCost": 0.0,';
        rBody += '\n                                    "minLateralCost": 0.0,';
        rBody += '\n                                    "createdDate": null,';
        rBody += '\n                                    "lastEditedDate": null';
        rBody += '\n                                }';
        rBody += '\n                            ],';
        rBody += '\n                            "solveType": {';
        rBody += '\n                                "id": 1,';
        rBody += '\n                                "name": "LCR"';
        rBody += '\n                            },';
        rBody += '\n                            "geodesicLength": 383.0,';
        rBody += '\n                            "chainCount": 3,';
        rBody += '\n                            "chainRatio": 0.08194151,';
        rBody += '\n                            "businessCount": 404,';
        rBody += '\n                            "lcrCost": 0.0,';
        rBody += '\n                            "totalCost": 32088.70351604,';
        rBody += '\n                            "startSegmentCost": 2138.45202814,';
        rBody += '\n                            "endSegmentCost": 0.0,';
        rBody += '\n                            "totalTreeCost": 106000.03951238,';
        rBody += '\n                            "demandToInfrastructureLength": 7354.65939522,';
        rBody += '\n                            "persistedOid": 5392388,';
        rBody += '\n                            "lengthUnits": "Foot",';
        rBody += '\n                            "crewCost": 7187.59,';
        rBody += '\n                            "accessCost": 0.0,';
        rBody += '\n                            "minLateralCost": 0.0,';
        rBody += '\n                            "createdDate": null,';
        rBody += '\n                            "lastEditedDate": null';
        rBody += '\n                        },';
        rBody += '\n                        {';
        rBody += '\n                            "routeName": "H7 - DAISY CHAIN 5392386",';
        rBody += '\n                            "demandName": "H7",';
        rBody += '\n                            "facilityType": "DAISY CHAIN",';
        rBody += '\n                            "facilityOid": 5392386,';
        rBody += '\n                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                            "routeAsJson": "{\"paths\":[[[-90.081274500000006,29.972039742999982],[-90.081328197000005,29.971960749000004],[-90.080212000000017,29.971202000000005]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                            "routeGuid": "{D35EE5A9-0C2D-424E-A591-35B88FAA2C7C}",';
        rBody += '\n                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '\n                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                            "childDetails": [],';
        rBody += '\n                            "solveType": {';
        rBody += '\n                                "id": 1,';
        rBody += '\n                                "name": "LCR"';
        rBody += '\n                            },';
        rBody += '\n                            "geodesicLength": 482.0,';
        rBody += '\n                            "chainCount": 3,';
        rBody += '\n                            "chainRatio": 0.93368457,';
        rBody += '\n                            "businessCount": 161,';
        rBody += '\n                            "lcrCost": 0.0,';
        rBody += '\n                            "totalCost": 38503.73683915,';
        rBody += '\n                            "startSegmentCost": 2169.92614291,';
        rBody += '\n                            "endSegmentCost": 0.0,';
        rBody += '\n                            "totalTreeCost": 38503.73683915,';
        rBody += '\n                            "demandToInfrastructureLength": 8632.47179026,';
        rBody += '\n                            "persistedOid": 5392389,';
        rBody += '\n                            "lengthUnits": "Foot",';
        rBody += '\n                            "crewCost": 7187.59,';
        rBody += '\n                            "accessCost": 0.0,';
        rBody += '\n                            "minLateralCost": 0.0,';
        rBody += '\n                            "createdDate": null,';
        rBody += '\n                            "lastEditedDate": null';
        rBody += '\n                        },';
        rBody += '\n                        {';
        rBody += '\n                            "routeName": "F5 - DAISY CHAIN 5392386",';
        rBody += '\n                            "demandName": "F5",';
        rBody += '\n                            "facilityType": "DAISY CHAIN",';
        rBody += '\n                            "facilityOid": 5392386,';
        rBody += '\n                            "naFacilityFid": 0,';
        rBody += '\n            "routeAsJson": "",';
//        rBody += '\n                            "routeAsJson": "{\"paths\":[[[-90.079064360000018,29.970264562000011],[-90.079124401000001,29.970315203999974],[-90.079063000000019,29.970388000000014]]],\"spatialReference\":{\"wkid\":4326,\"latestWkid\":4326}}",';
        rBody += '\n                            "routeGuid": "{92B7C311-392E-4369-8A8C-EC5F2A423965}",';
        rBody += '\n                            "parentGuid": "{84056686-6371-48E7-83CC-BDFA339F99FC}",';
        rBody += '\n                            "treeGuid": "{D5592BBE-7341-4700-8E6E-E2CEE946D5E4}",';
        rBody += '\n                            "childDetails": [],';
        rBody += '\n                            "solveType": {';
        rBody += '\n                                "id": 1,';
        rBody += '\n                                "name": "LCR"';
        rBody += '\n                            },';
        rBody += '\n                            "geodesicLength": 59.0,';
        rBody += '\n                            "chainCount": 3,';
        rBody += '\n                            "chainRatio": 0.59358414,';
        rBody += '\n                            "businessCount": 244,';
        rBody += '\n                            "lcrCost": 0.0,';
        rBody += '\n                            "totalCost": 17000.0,';
        rBody += '\n                            "startSegmentCost": 1720.56231879,';
        rBody += '\n                            "endSegmentCost": 0.0,';
        rBody += '\n                            "totalTreeCost": 17000.0,';
        rBody += '\n                            "demandToInfrastructureLength": 7738.77279514,';
        rBody += '\n                            "persistedOid": 5392390,';
        rBody += '\n                            "lengthUnits": "Foot",';
        rBody += '\n                            "crewCost": 7187.59,';
        rBody += '\n                            "accessCost": 0.0,';
        rBody += '\n                            "minLateralCost": 0.0,';
        rBody += '\n                            "createdDate": null,';
        rBody += '\n                            "lastEditedDate": null';
        rBody += '\n                        }';
        rBody += '\n                    ],';
        rBody += '\n                    "solveType": {';
        rBody += '\n                        "id": 1,';
        rBody += '\n                        "name": "LCR"';
        rBody += '\n                    },';
        rBody += '\n                    "geodesicLength": 1384.0,';
        rBody += '\n                    "chainCount": 2,';
        rBody += '\n                    "chainRatio": 0.99236758,';
        rBody += '\n                    "businessCount": 399,';
        rBody += '\n                    "lcrCost": 0.0,';
        rBody += '\n                    "totalCost": 97116.45790917,';
        rBody += '\n                    "startSegmentCost": 2956.30145143,';
        rBody += '\n                    "endSegmentCost": 0.0,';
        rBody += '\n                    "totalTreeCost": 275620.2342607,';
        rBody += '\n                    "demandToInfrastructureLength": 8242.25234538,';
        rBody += '\n                    "persistedOid": 5392386,';
        rBody += '\n                    "lengthUnits": "Foot",';
        rBody += '\n                    "crewCost": 7187.59,';
        rBody += '\n                    "accessCost": 0.0,';
        rBody += '\n                    "minLateralCost": 0.0,';
        rBody += '\n                    "createdDate": null,';
        rBody += '\n                    "lastEditedDate": null';
        rBody += '\n                }';
        rBody += '\n            ],';
        rBody += '\n            "solveType": {';
        rBody += '\n                "id": 1,';
        rBody += '\n                "name": "LCR"';
        rBody += '\n            },';
        rBody += '\n            "geodesicLength": 6911.0,';
        rBody += '\n            "chainCount": 1,';
        rBody += '\n            "chainRatio": 0.0,';
        rBody += '\n            "businessCount": 404,';
        rBody += '\n            "lcrCost": 0.0,';
        rBody += '\n            "totalCost": 352645.49247436,';
        rBody += '\n            "startSegmentCost": 3365.7328753,';
        rBody += '\n            "endSegmentCost": 812.33743427,';
        rBody += '\n            "totalTreeCost": 628265.72673506,';
        rBody += '\n            "demandToInfrastructureLength": 6911.0,';
        rBody += '\n            "persistedOid": 5392385,';
        rBody += '\n            "lengthUnits": "Foot",';
        rBody += '\n            "crewCost": 7187.59,';
        rBody += '\n            "accessCost": 0.0,';
        rBody += '\n            "minLateralCost": 0.0,';
        rBody += '\n            "createdDate": null,';
        rBody += '\n            "lastEditedDate": null';
        rBody += '\n        }';
        rBody += '\n    ]';
        rBody += '\n}';
        
        return rBody;
    }//end method getProspectorGetRoutesByProjectCalloutJsonStringWithNewLinesSpliceClosure
    
}//end class ProspectorMockHttpResponseGenerator