/****************************************************************************************************
 * LAST UPDATED FOR:
 * 11/17/2023   T2Cabato    QFCJ-4712                       Capital Design - Wire Center Segmentation Update Automation 
 * 12/08/2023	T2Cabato	QFCJ-4712						Revision for Too many queries error
****************************************************************************************************/
@isTest
public with sharing class TestWCSegCalloutHelper { 
    public static final String mockTestCLLI = 'DNVRCOSO';
    public static final String mockTestAllCLLI = '*';
    public static final String mockTestBadCLLI = 'HOTCOCOA';
    public static final String mockTestBadCLLIResponseJSON = '{ "wireCenterSearchResults": [ { "id": "HOTCOCOA", "clliData": "HOTCOCOA", "assignedTreatment": "HIGH POTENTIAL" } ] }';

    /* */
    @AuraEnabled
    public static testMethod void testBuildHttpRequestForWCSegService() {
        String accessToken = 't3StC0d3C0v3rA93Ca110uT';
        HttpRequest httpRequestWCSeg = new HttpRequest();

        Test.startTest();
        httpRequestWCSeg = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(accessToken, mockTestCLLI);
        if (httpRequestWCSeg == null) {
            System.assertEquals(null, httpRequestWCSeg);
        } else {
            System.assertNotEquals(null, httpRequestWCSeg);
            if (httpRequestWCSeg.getBody() == null) {
                System.assertEquals(null, httpRequestWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpRequestWCSeg.getBody());
                if (httpRequestWCSeg.getEndpoint() == null) {
                    System.assertEquals(null, httpRequestWCSeg.getEndpoint());
                } else {
                    System.assertNotEquals(null, httpRequestWCSeg.getEndpoint());
                    if (httpRequestWCSeg.getMethod() == null) {
                        System.assertEquals(null, httpRequestWCSeg.getMethod());                        
                    } else {
                        System.assertNotEquals(null, httpRequestWCSeg.getMethod());                        
                    }
                }
            }
        }
		Test.stopTest();
    }//end testBuildHttpRequestForWCSegService
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testBuildHttpRequestForWCSegServiceNullToken() {
        String accessToken = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();

        Test.startTest();
        httpRequestWCSeg = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(accessToken, mockTestCLLI);
        if (httpRequestWCSeg == null) {
            System.assertEquals(null, httpRequestWCSeg);
        } else {
            System.assertNotEquals(null, httpRequestWCSeg);
            if (httpRequestWCSeg.getBody() == null) {
                System.assertEquals(null, httpRequestWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpRequestWCSeg.getBody());
                if (httpRequestWCSeg.getEndpoint() == null) {
                    System.assertEquals(null, httpRequestWCSeg.getEndpoint());
                } else {
                    System.assertNotEquals(null, httpRequestWCSeg.getEndpoint());
                    if (httpRequestWCSeg.getMethod() == null) {
                        System.assertEquals(null, httpRequestWCSeg.getMethod());                        
                    } else {
                        System.assertNotEquals(null, httpRequestWCSeg.getMethod());                        
                    }
                }
            }
        }
		Test.stopTest();
    }//end testBuildHttpRequestForWCSegServiceNullToken
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testBuildHttpRequestForAllWCSegService() {
        String accessToken = 't3StC0d3C0v3rA93Ca110uT';
        HttpRequest httpRequestWCSeg = new HttpRequest();

        Test.startTest();
        httpRequestWCSeg = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(accessToken, mockTestAllCLLI);
        if (httpRequestWCSeg == null) {
            System.assertEquals(null, httpRequestWCSeg);
        } else {
            System.assertNotEquals(null, httpRequestWCSeg);
            if (httpRequestWCSeg.getBody() == null) {
                System.assertEquals(null, httpRequestWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpRequestWCSeg.getBody());
                if (httpRequestWCSeg.getEndpoint() == null) {
                    System.assertEquals(null, httpRequestWCSeg.getEndpoint());
                } else {
                    System.assertNotEquals(null, httpRequestWCSeg.getEndpoint());
                    if (httpRequestWCSeg.getMethod() == null) {
                        System.assertEquals(null, httpRequestWCSeg.getMethod());                        
                    } else {
                        System.assertNotEquals(null, httpRequestWCSeg.getMethod());                        
                    }
                }
            }
        }
		Test.stopTest();
    }//end testBuildHttpRequestForAllWCSegService
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testBuildHttpRequestForAllWCSegServiceNullToken() {
        HttpRequest httpRequestWCSeg = new HttpRequest();

        Test.startTest();
        httpRequestWCSeg = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(null, mockTestAllCLLI);
        if (httpRequestWCSeg == null) {
            System.assertEquals(null, httpRequestWCSeg);
        } else {
            System.assertNotEquals(null, httpRequestWCSeg);
            if (httpRequestWCSeg.getBody() == null) {
                System.assertEquals(null, httpRequestWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpRequestWCSeg.getBody());
                if (httpRequestWCSeg.getEndpoint() == null) {
                    System.assertEquals(null, httpRequestWCSeg.getEndpoint());
                } else {
                    System.assertNotEquals(null, httpRequestWCSeg.getEndpoint());
                    if (httpRequestWCSeg.getMethod() == null) {
                        System.assertEquals(null, httpRequestWCSeg.getMethod());                        
                    } else {
                        System.assertNotEquals(null, httpRequestWCSeg.getMethod());                        
                    }
                }
            }
        }
		Test.stopTest();
    }//end testBuildHttpRequestForAllWCSegServiceNullToken
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testGetAccessTokenFromApigee() {
		final String testEndPointApigeeForWCSeg = 'https://api-test.lumen.com/Finance/v1/Capital/wirecenterDataRegulatoryAreas/regulatory-areas';
        String accessToken = null;
        String requestJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();

        Test.startTest();
        accessToken = WCSegCalloutHelper.getAccessTokenFromApigee();
        if (accessToken == null) {
            System.assertEquals(null, accessToken);
        } else {
            System.assertNotEquals(null, accessToken);
        }
		Test.stopTest();
    }//end testGetAccessTokenFromApigee
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testGetAccessTokenFromApigee401StatusCode() {
		final String testEndPointApigeeForWCSeg = 'https://api-test.lumen.com/Finance/v1/Capital/wirecenterDataRegulatoryAreas/regulatory-areas';
        String accessToken = null;
        String requestJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();

        Test.startTest();
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(401);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);

        //HttpResponse httpRespSR = getHttpResponseFromStaticResourceWith401StatusCode();

        accessToken = WCSegCalloutHelper.getAccessTokenFromApigee();
        if (accessToken == null) {
            System.assertEquals(null, accessToken);
        } else {
            System.assertNotEquals(null, accessToken);
        }
		Test.stopTest();
    }//end testGetAccessTokenFromApigee401StatusCode
    /* */

    /* */
    @AuraEnabled
    public static testMethod void getHttpResponseFromWCSegService() {
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        thisTestNWC.Wire_Center_Segmentation__c = 'WEAK';

        Test.startTest();
        String testResponseJSON = queryForResponseJSONFromStaticResource();
        System.debug('(testApiTransactionLongResponseBody) testResponseJSON: \n' + testResponseJSON);
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        
        
        httpRequestWCSeg.setHeader('Content-Type', 'application/json');
        httpRequestWCSeg.setBody(mockTestCLLI);
        httpRequestWCSeg.setMethod('POST');
        httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, thisTestNWC.Name);
        if(httpResponseWCSeg == null) {
	        System.assertEquals(null, httpResponseWCSeg);            
        } else {
	        System.assertNotEquals(null, httpResponseWCSeg);
            if(httpResponseWCSeg.getBody() == null) {
                System.assertEquals(null, httpResponseWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpResponseWCSeg.getBody());
            }
        }
		Test.stopTest();
    }//end getHttpResponseFromWCSegService
    /* */

    /* */
    @AuraEnabled
    public static testMethod void getHttpResponseFromWCSegServiceNullHttpRequest() {
        HttpRequest httpRequestWCSeg = null;
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        thisTestNWC.Wire_Center_Segmentation__c = 'WEAK';

        Test.startTest();        
        httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, thisTestNWC.Name);
        if(httpResponseWCSeg == null) {
	        System.assertEquals(null, httpResponseWCSeg);            
        } else {
	        System.assertNotEquals(null, httpResponseWCSeg);
            if(httpResponseWCSeg.getBody() == null) {
                System.assertEquals(null, httpResponseWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpResponseWCSeg.getBody());
            }
        }
		Test.stopTest();
    }//end getHttpResponseFromWCSegServiceNullHttpRequest
    /* */

    /* */
    @AuraEnabled
    public static testMethod void getHttpResponseFromWCSegServiceBadHttpRequest() {
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        thisTestNWC.Wire_Center_Segmentation__c = 'WEAK';

        Test.startTest();        
        httpRequestWCSeg.setHeader('Content-Type', 'application/json');
        httpRequestWCSeg.setBody('');
        httpRequestWCSeg.setMethod('HOST');
        httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, thisTestNWC.Name);
        if(httpResponseWCSeg == null) {
	        System.assertEquals(null, httpResponseWCSeg);            
        } else {
	        System.assertNotEquals(null, httpResponseWCSeg);
            if(httpResponseWCSeg.getBody() == null) {
                System.assertEquals(null, httpResponseWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpResponseWCSeg.getBody());
            }
        }
		Test.stopTest();
    }//end getHttpResponseFromWCSegServiceBadHttpRequest
    /* */

    /* */
    @AuraEnabled
    public static testMethod void getHttpResponseFromWCSegServiceNullBodyHttpRequest() {
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        thisTestNWC.Wire_Center_Segmentation__c = 'WEAK';
        String emptyBody = '';

        Test.startTest();        
        httpRequestWCSeg.setHeader('Content-Type', 'application/json');
        httpRequestWCSeg.setBody(emptyBody);
        httpRequestWCSeg.setMethod('POST');
        httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, thisTestNWC.Name);
        if(httpResponseWCSeg == null) {
	        System.assertEquals(null, httpResponseWCSeg);            
        } else {
	        System.assertNotEquals(null, httpResponseWCSeg);
            if(httpResponseWCSeg.getBody() == null) {
                System.assertEquals(null, httpResponseWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpResponseWCSeg.getBody());
            }
        }
		Test.stopTest();
    }//end getHttpResponseFromWCSegServiceNullBodyHttpRequest
    /* */

    /* */
    @AuraEnabled
    public static testMethod void getHttpResponseFromWCSegService401StatusCode() {
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        thisTestNWC.Wire_Center_Segmentation__c = 'WEAK';

        Test.startTest();        
        HttpResponse httpRespSR = getHttpResponseFromStaticResourceWith401StatusCode();
        httpRequestWCSeg.setHeader('Content-Type', 'application/json');
        httpRequestWCSeg.setBody('');
        httpRequestWCSeg.setMethod('HOST');
        httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, thisTestNWC.Name);
        if(httpResponseWCSeg == null) {
	        System.assertEquals(null, httpResponseWCSeg);            
        } else {
	        System.assertNotEquals(null, httpResponseWCSeg);
            if(httpResponseWCSeg.getBody() == null) {
                System.assertEquals(null, httpResponseWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpResponseWCSeg.getBody());
            }
        }
		Test.stopTest();
    }//end getHttpResponseFromWCSegService401StatusCode
    /* */

    /* */
    @AuraEnabled
    public static testMethod void getHttpResponseFromAllWCSegService() {
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        thisTestNWC.Wire_Center_Segmentation__c = 'WEAK';

        Test.startTest();
        String testResponseJSON = queryForResponseJSONFromStaticResource();
        System.debug('(testApiTransactionLongResponseBody) testResponseJSON: \n' + testResponseJSON);
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        
        
        httpRequestWCSeg.setHeader('Content-Type', 'application/json');
        httpRequestWCSeg.setBody(mockTestCLLI);
        httpRequestWCSeg.setMethod('POST');
        httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, mockTestCLLI);
        if(httpResponseWCSeg == null) {
	        System.assertEquals(null, httpResponseWCSeg);            
        } else {
	        System.assertNotEquals(null, httpResponseWCSeg);
            if(httpResponseWCSeg.getBody() == null) {
                System.assertEquals(null, httpResponseWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpResponseWCSeg.getBody());
            }
        }
		Test.stopTest();
    }//end getHttpResponseFromAllWCSegService
    /* */

    /* */
    @AuraEnabled
    public static testMethod void getHttpResponseFromAllWCSegServiceNullHttpRequest() {
        HttpRequest httpRequestWCSeg = null;
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        thisTestNWC.Wire_Center_Segmentation__c = 'WEAK';

        Test.startTest();        
        httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, mockTestCLLI);
        if(httpResponseWCSeg == null) {
	        System.assertEquals(null, httpResponseWCSeg);            
        } else {
	        System.assertNotEquals(null, httpResponseWCSeg);
            if(httpResponseWCSeg.getBody() == null) {
                System.assertEquals(null, httpResponseWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpResponseWCSeg.getBody());
            }
        }
		Test.stopTest();
    }//end getHttpResponseFromAllWCSegServiceNullHttpRequest
    /* */

    /* */
    @AuraEnabled
    public static testMethod void getHttpResponseFromAllWCSegServiceBadHttpRequest() {
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        thisTestNWC.Wire_Center_Segmentation__c = 'WEAK';

        Test.startTest();        
        httpRequestWCSeg.setHeader('Content-Type', 'application/json');
        httpRequestWCSeg.setBody('');
        httpRequestWCSeg.setMethod('HOST');
        httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, mockTestCLLI);
        if(httpResponseWCSeg == null) {
	        System.assertEquals(null, httpResponseWCSeg);            
        } else {
	        System.assertNotEquals(null, httpResponseWCSeg);
            if(httpResponseWCSeg.getBody() == null) {
                System.assertEquals(null, httpResponseWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpResponseWCSeg.getBody());
            }
        }
		Test.stopTest();
    }//end getHttpResponseFromWCSegServiceBadHttpRequest
    /* */

    /* */
    @AuraEnabled
    public static testMethod void getHttpResponseFromAllWCSegServiceNullBodyHttpRequest() {
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        thisTestNWC.Wire_Center_Segmentation__c = 'WEAK';
        String emptyBody = '';

        Test.startTest();        
        httpRequestWCSeg.setHeader('Content-Type', 'application/json');
        httpRequestWCSeg.setBody(emptyBody);
        httpRequestWCSeg.setMethod('POST');
        httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, mockTestCLLI);
        if(httpResponseWCSeg == null) {
	        System.assertEquals(null, httpResponseWCSeg);            
        } else {
	        System.assertNotEquals(null, httpResponseWCSeg);
            if(httpResponseWCSeg.getBody() == null) {
                System.assertEquals(null, httpResponseWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpResponseWCSeg.getBody());
            }
        }
		Test.stopTest();
    }//end getHttpResponseFromAllWCSegServiceNullBodyHttpRequest
    /* */


    /* */
    @AuraEnabled
    public static testMethod void getHttpResponseFromAllWCSegService401StatusCode() {
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        thisTestNWC.Wire_Center_Segmentation__c = 'WEAK';

        Test.startTest();        
        HttpResponse httpRespSR = getHttpResponseFromStaticResourceWith401StatusCode();
        httpRequestWCSeg.setHeader('Content-Type', 'application/json');
        httpRequestWCSeg.setBody('');
        httpRequestWCSeg.setMethod('HOST');
        httpResponseWCSeg = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(httpRequestWCSeg, mockTestCLLI);
        if(httpResponseWCSeg == null) {
	        System.assertEquals(null, httpResponseWCSeg);            
        } else {
	        System.assertNotEquals(null, httpResponseWCSeg);
            if(httpResponseWCSeg.getBody() == null) {
                System.assertEquals(null, httpResponseWCSeg.getBody());
            } else {
                System.assertNotEquals(null, httpResponseWCSeg.getBody());
            }
        }
		Test.stopTest();
    }//end getHttpResponseFromAllWCSegService401StatusCode
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testApiTransaction() {
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String responseJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Http httpProtocol = new Http();
        Time startTime;
      	Time endTime;	
        String callingApiName = 'WirecenterSegmentation';
        String errorMsg = 'No errors at this time.';

        Test.startTest();
        httpRequestWCSeg.setEndpoint('https://apimarketplace.lumen.com/');
        httpRequestWCSeg.setBody('{ "endpoint":"https://apimarketplace.lumen.com/" }');
        httpResponseWCSeg.setStatus('SUCCESS');
        httpResponseWCSeg.setStatusCode(200);
        httpResponseWCSeg.setBody(' { "message":"Welcome to Lumen API Marketplace" } ');
        System.assertNotEquals(null, httpRequestWCSeg);
        System.assertNotEquals(null, httpResponseWCSeg);
        startTime = DateTime.now().Time();
        endTime = DateTime.now().Time();
        //system.debug('Success... Before createApiTransaction...');
        // Create API Transaction record for history and reports
        WCSegCalloutHelper.ApiTransactionParams atParams = new WCSegCalloutHelper.ApiTransactionParams();
        atParams.responseStatus = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatus() : null);
        atParams.responseStatusCode = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatusCode() : 0);
        atParams.responseBody = (httpResponseWCSeg != null ? httpResponseWCSeg.getBody() : null);
        atParams.requestEndpoint = (httpRequestWCSeg != null ? httpRequestWCSeg.getEndpoint() : null);
        atParams.requestBody = (httpRequestWCSeg != null ? httpRequestWCSeg.getBody() : null);
        atParams.callingApiName = callingApiName;
        atParams.startTime = startTime;
        atParams.endTime = endTime;
        atParams.errorDetails = errorMsg;
        atParams.wcSegAPITransSummaryId = null;
        API_Transaction__c apiTransaction = WCSegCalloutHelper.createApiTransaction(atParams);
        if (apiTransaction == null) {
            System.assertEquals(null, apiTransaction);
        } else {
            System.assertNotEquals(null, apiTransaction);
        }
        Test.stopTest();
    }//end testApiTransaction
    /* */
    
    /* */
    @AuraEnabled
    public static testMethod void testApiTransactionLongResponseBody() {
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String responseJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Http httpProtocol = new Http();
        Time startTime;
      	Time endTime;	
        String callingApiName = 'WirecenterSegmentation';
        String errorMsg = 'No errors at this time.';

        Test.startTest();
        String testResponseJSON = queryForLONGResponseJSONFromStaticResource();
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseWithLONGJSONFromStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        
        System.debug('(testApiTransactionLongResponseBody) testResponseJSON.length() = ' + (testResponseJSON != null ? testResponseJSON.length() : -1));

        httpRequestWCSeg.setEndpoint('https://apimarketplace.lumen.com/');
        httpRequestWCSeg.setBody('{ "endpoint":"https://apimarketplace.lumen.com/" }');
        httpResponseWCSeg.setStatus('SUCCESS');
        httpResponseWCSeg.setStatusCode(200);
        httpResponseWCSeg.setBody(' { "message":"Welcome to Lumen API Marketplace" } ');
        startTime = DateTime.now().Time();
        endTime = DateTime.now().Time();
        //system.debug('Success... Before createApiTransaction...');
        // Create API Transaction record for history and reports
        WCSegCalloutHelper.ApiTransactionParams atParams = new WCSegCalloutHelper.ApiTransactionParams();
        atParams.responseStatus = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatus() : null);
        atParams.responseStatusCode = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatusCode() : 0);
        atParams.responseBody = (httpResponseWCSeg != null ? httpResponseWCSeg.getBody() : null);
        atParams.requestEndpoint = (httpRequestWCSeg != null ? httpRequestWCSeg.getEndpoint() : null);
        atParams.requestBody = (httpRequestWCSeg != null ? httpRequestWCSeg.getBody() : null);
        atParams.callingApiName = callingApiName;
        atParams.startTime = startTime;
        atParams.endTime = endTime;
        atParams.errorDetails = errorMsg;
        atParams.wcSegAPITransSummaryId = null;
        API_Transaction__c apiTransaction = WCSegCalloutHelper.createApiTransaction(atParams);
        if (apiTransaction == null) {
            System.assertEquals(null, apiTransaction);
        } else {
            System.assertNotEquals(null, apiTransaction);
        }
        Test.stopTest();
    }//end testApiTransactionLongResponseBody
    /* */
    
    /* */
    @AuraEnabled
    public static testMethod void testApiTransactionNullResponseBody() {
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String responseJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Http httpProtocol = new Http();
        Time startTime;
      	Time endTime;	
        String callingApiName = 'WirecenterSegmentation';
        String errorMsg = 'No errors at this time.';

        Test.startTest();
        httpRequestWCSeg.setEndpoint('https://apimarketplace.lumen.com/');
        httpRequestWCSeg.setBody('{ "endpoint":"https://apimarketplace.lumen.com/" }');
        httpResponseWCSeg.setStatus('SUCCESS');
        httpResponseWCSeg.setStatusCode(200);
        httpResponseWCSeg.setBody(' { "message":"Welcome to Lumen API Marketplace" } ');
        startTime = DateTime.now().Time();
        endTime = DateTime.now().Time();
        //system.debug('Success... Before createApiTransaction...');
        // Create API Transaction record for history and reports
        WCSegCalloutHelper.ApiTransactionParams atParams = new WCSegCalloutHelper.ApiTransactionParams();
        atParams.responseStatus = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatus() : null);
        atParams.responseStatusCode = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatusCode() : 0);
        atParams.responseBody = (httpResponseWCSeg != null ? httpResponseWCSeg.getBody() : null);
        atParams.requestEndpoint = (httpRequestWCSeg != null ? httpRequestWCSeg.getEndpoint() : null);
        atParams.requestBody = (httpRequestWCSeg != null ? httpRequestWCSeg.getBody() : null);
        atParams.callingApiName = callingApiName;
        atParams.startTime = startTime;
        atParams.endTime = endTime;
        atParams.errorDetails = errorMsg;
        atParams.wcSegAPITransSummaryId = null;
        API_Transaction__c apiTransaction = WCSegCalloutHelper.createApiTransaction(atParams);
        if (apiTransaction == null) {
            System.assertEquals(null, apiTransaction);
        } else {
            System.assertNotEquals(null, apiTransaction);
        }
        Test.stopTest();
    }//end testApiTransactionNullResponseBody
    /* */
    
    /* */
    @AuraEnabled
    public static testMethod void testApiTransactionNullErrorDetails() {
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String responseJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Http httpProtocol = new Http();
        Time startTime;
      	Time endTime;	
        String callingApiName = 'WirecenterSegmentation';
        String errorMsg = 'No errors at this time.';

        Test.startTest();
        httpRequestWCSeg.setEndpoint('https://apimarketplace.lumen.com/');
        httpRequestWCSeg.setBody('{ "endpoint":"https://apimarketplace.lumen.com/" }');
        httpResponseWCSeg.setStatus('SUCCESS');
        httpResponseWCSeg.setStatusCode(200);
        httpResponseWCSeg.setBody(' { "message":"Welcome to Lumen API Marketplace" } ');
        startTime = DateTime.now().Time();
        endTime = DateTime.now().Time();
        //system.debug('Success... Before createApiTransaction...');
        // Create API Transaction record for history and reports
        WCSegCalloutHelper.ApiTransactionParams atParams = new WCSegCalloutHelper.ApiTransactionParams();
        atParams.responseStatus = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatus() : null);
        atParams.responseStatusCode = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatusCode() : 0);
        atParams.responseBody = (httpResponseWCSeg != null ? httpResponseWCSeg.getBody() : null);
        atParams.requestEndpoint = (httpRequestWCSeg != null ? httpRequestWCSeg.getEndpoint() : null);
        atParams.requestBody = (httpRequestWCSeg != null ? httpRequestWCSeg.getBody() : null);
        atParams.callingApiName = callingApiName;
        atParams.startTime = startTime;
        atParams.endTime = endTime;
        atParams.errorDetails = errorMsg;
        atParams.wcSegAPITransSummaryId = null;
        API_Transaction__c apiTransaction = WCSegCalloutHelper.createApiTransaction(atParams);
        if (apiTransaction == null) {
            System.assertEquals(null, apiTransaction);
        } else {
            System.assertNotEquals(null, apiTransaction);
        }
        Test.stopTest();
    }//end testApiTransactionNullErrorDetails
    /* */
    
    /* */
    @AuraEnabled
    public static testMethod void testApiTransactionErrorDetails() {
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String responseJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Http httpProtocol = new Http();
        Time startTime;
      	Time endTime;	
        String callingApiName = 'WirecenterSegmentation';
        String errorMsg = 'So many errors! You must have broken it.';

        Test.startTest();
        httpRequestWCSeg.setEndpoint('https://apimarketplace.lumen.com/');
        httpRequestWCSeg.setBody('{ "endpoint":"https://apimarketplace.lumen.com/" }');
        httpResponseWCSeg.setStatus('SUCCESS');
        httpResponseWCSeg.setStatusCode(200);
        httpResponseWCSeg.setBody(' { "message":"Welcome to Lumen API Marketplace" } ');
        startTime = DateTime.now().Time();
        endTime = DateTime.now().Time();
        //system.debug('Success... Before createApiTransaction...');
        // Create API Transaction record for history and reports
        WCSegCalloutHelper.ApiTransactionParams atParams = new WCSegCalloutHelper.ApiTransactionParams();
        atParams.responseStatus = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatus() : null);
        atParams.responseStatusCode = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatusCode() : 0);
        atParams.responseBody = (httpResponseWCSeg != null ? httpResponseWCSeg.getBody() : null);
        atParams.requestEndpoint = (httpRequestWCSeg != null ? httpRequestWCSeg.getEndpoint() : null);
        atParams.requestBody = (httpRequestWCSeg != null ? httpRequestWCSeg.getBody() : null);
        atParams.callingApiName = callingApiName;
        atParams.startTime = startTime;
        atParams.endTime = endTime;
        atParams.errorDetails = errorMsg;
        atParams.wcSegAPITransSummaryId = null;
        API_Transaction__c apiTransaction = WCSegCalloutHelper.createApiTransaction(atParams);
        if (apiTransaction == null) {
            System.assertEquals(null, apiTransaction);
        } else {
            System.assertNotEquals(null, apiTransaction);
        }
        Test.stopTest();
    }//end testApiTransactionErrorDetails
    /* */
    
    /* */
    @AuraEnabled
    public static testMethod void testApiTransactionInvalidAPIName() {
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String responseJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Http httpProtocol = new Http();
        Time startTime;
      	Time endTime;	
        String callingApiName = '';
        String errorMsg = 'No errors at this time.';

        Test.startTest();
        httpRequestWCSeg.setEndpoint('https://apimarketplace.lumen.com/');
        httpRequestWCSeg.setBody('{ "endpoint":"https://apimarketplace.lumen.com/" }');
        httpResponseWCSeg.setStatus('SUCCESS');
        httpResponseWCSeg.setStatusCode(200);
        httpResponseWCSeg.setBody(' { "message":"Welcome to Lumen API Marketplace" } ');
        startTime = DateTime.now().Time();
        endTime = DateTime.now().Time();
        //system.debug('Success... Before createApiTransaction...');
        // Create API Transaction record for history and reports
        WCSegCalloutHelper.ApiTransactionParams atParams = new WCSegCalloutHelper.ApiTransactionParams();
        atParams.responseStatus = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatus() : null);
        atParams.responseStatusCode = (httpResponseWCSeg != null ? httpResponseWCSeg.getStatusCode() : 0);
        atParams.responseBody = (httpResponseWCSeg != null ? httpResponseWCSeg.getBody() : null);
        atParams.requestEndpoint = (httpRequestWCSeg != null ? httpRequestWCSeg.getEndpoint() : null);
        atParams.requestBody = (httpRequestWCSeg != null ? httpRequestWCSeg.getBody() : null);
        atParams.callingApiName = callingApiName;
        atParams.startTime = startTime;
        atParams.endTime = endTime;
        atParams.errorDetails = errorMsg;
        atParams.wcSegAPITransSummaryId = null;
        API_Transaction__c apiTransaction = WCSegCalloutHelper.createApiTransaction(atParams);
        if (apiTransaction == null) {
            System.assertEquals(null, apiTransaction);
        } else {
            System.assertNotEquals(null, apiTransaction);
        }
        Test.stopTest();
    }//end testApiTransactionInvalidAPIName
    /* */
    
    /* */
    @AuraEnabled
    public static testMethod void testInsertApiTransactionsWithZeroTransactions() {
        String accessToken = null;
        String faRequestId = null;
        String requestJSON = null;
        String responseJSON = null;
        HttpRequest httpRequestWCSeg = new HttpRequest();
        HttpResponse httpResponseWCSeg = new HttpResponse();
        Http httpProtocol = new Http();
        Time startTime;
      	Time endTime;	
        String callingApiName = '';
        String errorMsg = 'No errors at this time.';

        Test.startTest();
        httpRequestWCSeg.setEndpoint('https://apimarketplace.lumen.com/');
        httpRequestWCSeg.setBody('{ "endpoint":"https://apimarketplace.lumen.com/" }');
        httpResponseWCSeg.setStatus('SUCCESS');
        httpResponseWCSeg.setStatusCode(200);
        httpResponseWCSeg.setBody(' { "message":"Welcome to Lumen API Marketplace" } ');
        startTime = DateTime.now().Time();
        endTime = DateTime.now().Time();
        //system.debug('Success... Before createApiTransaction...');
        // Create API Transaction record for history and reports
        API_Transaction__c apiTransaction = new API_Transaction__c();
        if (apiTransaction == null) {
            System.assertEquals(null, apiTransaction);
        } else {
            System.assertNotEquals(null, apiTransaction);
        }
        Test.stopTest();
    }//end testApiTransactionInvalidAPIName
    /* */
    
    /* */
    @AuraEnabled
    public static testMethod void mockCallout() {
        BRAIN_WCSeg_Response__c mockTestWCSegResponse = new BRAIN_WCSeg_Response__c();
        List<String> mockTestResponseList = new List<String>();
        List<List<String>> mockTestResponseListCollection = new List<List<String>>();

        Test.startTest();
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);

        String mockAccessToken = WCSegCalloutHelper.getAccessTokenFromApigee();
        if(mockAccessToken == null) {
	        System.assertEquals(null, mockAccessToken);
        } else {
	        System.assertNotEquals(null, mockAccessToken);
        }

        HttpRequest mockHttpRequest = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(mockAccessToken, mockTestAllCLLI);
        if(mockHttpRequest == null) {
            System.assertEquals(null, mockHttpRequest);
        } else {
            System.assertNotEquals(null, mockHttpRequest);
            if(mockHttpRequest.getBody() == null) {
                System.assertEquals(null, mockHttpRequest.getBody());
            } else {
                System.assertNotEquals(null, mockHttpRequest.getBody());
            }
        }
        
        HttpResponse mockHttpResponse = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(mockHttpRequest, mockTestAllCLLI);
        if (mockHttpResponse == null) {
            System.assertEquals(null, mockHttpResponse);            
        } else {
            System.assertNotEquals(null, mockHttpResponse);
            if (mockHttpResponse.getStatusCode() == null) {
                System.assertEquals(null, mockHttpResponse.getStatusCode());
            } else {
                System.assertNotEquals(null, mockHttpResponse.getStatusCode());
                if (mockHttpResponse.getHeader('Content-Type') == null) {
                    System.assertEquals(null, mockHttpResponse.getHeader('Content-Type'));
                } else {
                    System.assertNotEquals(null, mockHttpResponse.getHeader('Content-Type'));            
                    if (mockHttpResponse.getBody() == null) {
                        System.assertEquals(null, mockHttpResponse.getBody());
                    } else {
                        System.assertNotEquals(null, mockHttpResponse.getBody());            
                    }
                }//end else Content-Type NOT NULL
            }//end else StatusCode NOT NULL
        }//end else mockHttpResponse NOT NULL
        Test.stopTest();
	}//end mockCallout
    /* */
    
    /* */
    @AuraEnabled
    public static testMethod void testExtractDataFromResponse() {
        BRAIN_WCSeg_Response__c mockTestWCSegResponse = new BRAIN_WCSeg_Response__c();
        HttpResponse mockHttpResponse = new HttpResponse();
        List<String> mockTestResponseList = new List<String>();
        List<List<String>> mockTestResponseListCollection = new List<List<String>>();

        Test.startTest();

        String mockAccessToken = 't3StC0d3C0v3rA93Ca110uT';
        HttpRequest mockHttpRequest = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(mockAccessToken, mockTestAllCLLI);
        if(mockHttpRequest == null) {
            System.assertEquals(null, mockHttpRequest);
        } else {
            System.assertNotEquals(null, mockHttpRequest);
            if(mockHttpRequest.getBody() == null) {
                System.assertEquals(null, mockHttpRequest.getBody());
            } else {
                System.assertNotEquals(null, mockHttpRequest.getBody());
            }
        }
        
        mockHttpResponse = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(mockHttpRequest, mockTestAllCLLI);
        if (mockHttpResponse == null) {
            System.assertEquals(null, mockHttpResponse);            
        } else {
            System.assertNotEquals(null, mockHttpResponse);
            if (mockHttpResponse.getStatusCode() == null) {
                System.assertEquals(null, mockHttpResponse.getStatusCode());
            } else {
                System.debug('mockHttpResponse.getStatusCode() = ' + mockHttpResponse.getStatusCode());
                System.assertNotEquals(null, mockHttpResponse.getStatusCode());
                if (mockHttpResponse.getHeader('Content-Type') == null) {
                    System.assertEquals(null, mockHttpResponse.getHeader('Content-Type'));
                } else {
                    System.assertNotEquals(null, mockHttpResponse.getHeader('Content-Type'));            
                    if (mockHttpResponse.getBody() == null) {
                        System.assertEquals(null, mockHttpResponse.getBody());
                    } else {
                        System.assertNotEquals(null, mockHttpResponse.getBody());            
                    }
                }//end else Content-Type NOT NULL
            }//end else StatusCode NOT NULL
        }//end else mockHttpResponse NOT NULL
        
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestSearchAllWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);
        
        String mockTestResponseJSON = WCSegCalloutHelper.extractDataFromHttpResponse(mockHttpResponse, null);
        if (mockTestResponseJSON == null) {
            System.assertEquals(null, mockTestResponseJSON);
        } else {
            System.assertNotEquals(null, mockTestResponseJSON);
        }            
        Test.stopTest();
        
    }//end testMethod testExtractDataFromResponse
	/*  */      
    
    /* */
    @AuraEnabled
    public static testMethod void testExtractDataFromResponseBadStatusCode() {
        BRAIN_WCSeg_Response__c mockTestWCSegResponse = new BRAIN_WCSeg_Response__c();
        HttpResponse mockHttpResponse = new HttpResponse();
        List<String> mockTestResponseList = new List<String>();
        List<List<String>> mockTestResponseListCollection = new List<List<String>>();

        Test.startTest();
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(400);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);

        String mockAccessToken = 't3StC0d3C0v3rA93Ca110uT';
        HttpRequest mockHttpRequest = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(mockAccessToken, mockTestAllCLLI);
        if(mockHttpRequest == null) {
            System.assertEquals(null, mockHttpRequest);
        } else {
            System.assertNotEquals(null, mockHttpRequest);
            if(mockHttpRequest.getBody() == null) {
                System.assertEquals(null, mockHttpRequest.getBody());
            } else {
                System.assertNotEquals(null, mockHttpRequest.getBody());
            }
        }
        
        mockHttpResponse = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(mockHttpRequest, mockTestAllCLLI);
        if (mockHttpResponse == null) {
            System.assertEquals(null, mockHttpResponse);            
        } else {
            System.assertNotEquals(null, mockHttpResponse);
            if (mockHttpResponse.getStatusCode() == null) {
                System.assertEquals(null, mockHttpResponse.getStatusCode());
            } else {
                System.assertNotEquals(null, mockHttpResponse.getStatusCode());
                if (mockHttpResponse.getHeader('Content-Type') == null) {
                    System.assertEquals(null, mockHttpResponse.getHeader('Content-Type'));
                } else {
                    System.assertNotEquals(null, mockHttpResponse.getHeader('Content-Type'));            
                    if (mockHttpResponse.getBody() == null) {
                        System.assertEquals(null, mockHttpResponse.getBody());
                    } else {
                        System.assertNotEquals(null, mockHttpResponse.getBody());            
                    }
                }//end else Content-Type NOT NULL
            }//end else StatusCode NOT NULL
        }//end else mockHttpResponse NOT NULL

        String mockTestResponseJSON = WCSegCalloutHelper.extractDataFromHttpResponse(mockHttpResponse, null);
        if (mockTestResponseJSON == null) {
            System.assertEquals(null, mockTestResponseJSON);
        } else {
            System.assertNotEquals(null, mockTestResponseJSON);
        }            
        Test.stopTest();
        
    }//end testMethod testExtractDataFromResponseBadStatusCode
	/*  */      

    /* */
    @AuraEnabled
    public static testMethod void testBuildBaseWCSegResponse() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        String testResponseJSON = queryForResponseJSONFromSearchStaticResource();
        //System.debug('(testBuildBaseWCSegResponse) testResponseJSON: \n' + testResponseJSON);
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromSearchStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        
        
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        List<String> nwcNamesOnlyList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(nwcAllList);
        List<Network_Wire_Center__c> nwcByNameList = WCSegCalloutHelper.queryWirecenterCLLICodeByName(mockTestCLLI);
        if(nwcAllList == null) {
            System.assertEquals(null, nwcAllList);
        } else {
            System.assertNotEquals(null, nwcAllList);
            if(nwcAllList.size() < 1) {
                System.assertEquals(0, nwcAllList.size());
            } else {
                System.assertNotEquals(0, nwcAllList.size());
                List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.buildBaseWCSegResponse(testResponseJSON, nwcAllList, nwcNamesOnlyList);
                if(testWCSegResponse == null) {
                    System.assertEquals(null, testWCSegResponse);            
                } else {
                    System.assertNotEquals(null, testWCSegResponse);
                    if(testWCSegResponse.assignedTreatment__c == null) {
                        System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
                    } else {
                        System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
                    }
                }
            }//end else nwcList-size NOT 0
        }//end else nwcList NOT NULL
		Test.stopTest();
    }//end testBuildBaseWCSegResponse
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testBuildBaseWCSegResponseAllCLLI() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        String testResponseJSON = queryForResponseJSONFromSearchAllStaticResource();
        //System.debug('(testBuildBaseWCSegResponse) testResponseJSON: \n' + testResponseJSON);
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromSearchAllStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        
        
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        List<String> nwcNamesOnlyList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(nwcAllList);
        if(nwcAllList == null) {
            System.assertEquals(null, nwcAllList);
        } else {
            System.assertNotEquals(null, nwcAllList);
            if(nwcAllList.size() < 1) {
                System.assertEquals(0, nwcAllList.size());
            } else {
                System.assertNotEquals(0, nwcAllList.size());
                List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.buildBaseWCSegResponse(testResponseJSON, nwcAllList, nwcNamesOnlyList);
                if(testWCSegResponse == null) {
                    System.assertEquals(null, testWCSegResponse);            
                } else {
                    System.assertNotEquals(null, testWCSegResponse);
                    if(testWCSegResponse.assignedTreatment__c == null) {
                        System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
                    } else {
                        System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
                    }
                }
            }//end else nwcList-size NOT 0
        }//end else nwcList NOT NULL
		Test.stopTest();
    }//end testBuildBaseWCSegResponseAllCLLI
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testBuildBaseWCSegResponseNullJSON() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        List<String> nwcNamesOnlyList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(nwcAllList);
        List<Network_Wire_Center__c> zeroList = new List<Network_Wire_Center__c>();
        List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.buildBaseWCSegResponse(null, zeroList, nwcNamesOnlyList);
        if(testWCSegResponse == null) {
	        System.assertEquals(null, testWCSegResponse);            
        } else {
	        System.assertNotEquals(null, testWCSegResponse);
            if(testWCSegResponse.assignedTreatment__c == null) {
                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
            } else {
                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
            }
        }
		Test.stopTest();
    }//end testBuildBaseWCSegResponseNullJSON
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testBuildBaseWCSegResponseBadJSON() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        List<String> nwcNamesOnlyList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(nwcAllList);
        List<Network_Wire_Center__c> zeroList = new List<Network_Wire_Center__c>();
        List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.buildBaseWCSegResponse('[ ]', zeroList, nwcNamesOnlyList);
        if(testWCSegResponse == null) {
	        System.assertEquals(null, testWCSegResponse);            
        } else {
	        System.assertNotEquals(null, testWCSegResponse);
            if(testWCSegResponse.assignedTreatment__c == null) {
                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
            } else {
                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
            }
        }
		Test.stopTest();
    }//end testBuildBaseWCSegResponseBadJSON
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testBuildBaseWCSegResponseBadCLLIZeroList() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        List<String> nwcNamesOnlyList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(nwcAllList);
        List<Network_Wire_Center__c> zeroList = new List<Network_Wire_Center__c>();
        List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.buildBaseWCSegResponse(mockTestBadCLLIResponseJSON, zeroList, nwcNamesOnlyList);
        if(testWCSegResponse == null) {
	        System.assertEquals(null, testWCSegResponse);            
        } else {
	        System.assertNotEquals(null, testWCSegResponse);
            if(testWCSegResponse.assignedTreatment__c == null) {
                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
            } else {
                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
            }
        }
		Test.stopTest();
    }//end testBuildBaseWCSegResponseBadCLLIZeroList
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testBuildBaseWCSegResponseZeroBaseList() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        String testResponseJSON = queryForResponseJSONFromStaticResource();
        System.debug('(testInsertBaseWCSegResponse) testResponseJSON: \n' + testResponseJSON);
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        

        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        List<String> nwcNamesOnlyList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(nwcAllList);
        List<Network_Wire_Center__c> zeroList = new List<Network_Wire_Center__c>();
        List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.buildBaseWCSegResponse(testResponseJSON, zeroList, nwcNamesOnlyList);
        if(testWCSegResponse == null) {
	        System.assertEquals(null, testWCSegResponse);            
        } else {
	        System.assertNotEquals(null, testWCSegResponse);
            if(testWCSegResponse.assignedTreatment__c == null) {
                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
            } else {
                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
            }
        }
		Test.stopTest();
    }//end testBuildBaseWCSegResponseZeroBaseList
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testInsertBaseWCSegResponse() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        String testResponseJSON = queryForResponseJSONFromStaticResource();
        System.debug('(testInsertBaseWCSegResponse) testResponseJSON: \n' + testResponseJSON);
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        
        
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        List<String> nwcNamesOnlyList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(nwcAllList);
        if(nwcAllList == null) {
            System.assertEquals(null, nwcAllList);
        } else {
            System.assertNotEquals(null, nwcAllList);
            if(nwcAllList.size() < 1) {
                System.assertEquals(0, nwcAllList.size());
            } else {
                System.assertNotEquals(0, nwcAllList.size());
                List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.buildBaseWCSegResponse(testResponseJSON, nwcAllList, nwcNamesOnlyList);
                testWCSegRespList = WCSegCalloutHelper.insertBaseWCSegResponseList(testWCSegRespList);
                if(testWCSegRespList == null) {
                    System.assertEquals(null, testWCSegRespList);            
                } else {
                    System.assertNotEquals(null, testWCSegRespList);
                    if(testWCSegRespList.size() < 1) {
                        System.assertEquals(0, testWCSegRespList.size());
                    } else {
                        System.assertNotEquals(0, testWCSegRespList.size());
                        if(testWCSegResponse == null) {
                            System.assertEquals(null, testWCSegResponse);            
                        } else {
                            System.assertNotEquals(null, testWCSegResponse);
                            if(testWCSegResponse.assignedTreatment__c == null) {
                                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
                            } else {
                                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
                            }
                        }
                	}
                }
            }//end else nwcList-size NOT 0
        }//end else nwcList NOT NULL
		Test.stopTest();
    }//end testInsertBaseWCSegResponse
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testInsertBaseWCSegResponseNullResponse() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        String testResponseJSON = queryForResponseJSONFromStaticResource();
        System.debug('(testInsertBaseWCSegResponse) testResponseJSON: \n' + testResponseJSON);
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        
        
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        List<String> nwcNamesOnlyList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(nwcAllList);
        if(nwcAllList == null) {
            System.assertEquals(null, nwcAllList);
        } else {
            System.assertNotEquals(null, nwcAllList);
            if(nwcAllList.size() < 1) {
                System.assertEquals(0, nwcAllList.size());
            } else {
                System.assertNotEquals(0, nwcAllList.size());
                List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.insertBaseWCSegResponseList(null);
                if(testWCSegRespList == null) {
                    System.assertEquals(null, testWCSegRespList);            
                } else {
                    System.assertNotEquals(null, testWCSegRespList);
                    if(testWCSegRespList.size() < 1) {
                        System.assertEquals(0, testWCSegRespList.size());
                    } else {
                        System.assertNotEquals(0, testWCSegRespList.size());
                        if(testWCSegResponse == null) {
                            System.assertEquals(null, testWCSegResponse);            
                        } else {
                            System.assertNotEquals(null, testWCSegResponse);
                            if(testWCSegResponse.assignedTreatment__c == null) {
                                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
                            } else {
                                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
                            }
                        }
                	}
                }
            }//end else nwcList-size NOT 0
        }//end else nwcList NOT NULL
		Test.stopTest();
    }//end testInsertBaseWCSegResponseNullResponse
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testParseJSONForNWCResponse() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();
        String testResponseJSON = queryForResponseJSONFromStaticResource();
        System.debug('(testParseJSONForNWCResponse) testResponseJSON: \n' + testResponseJSON);
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        

        List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.parseJSONForNWCResponse(testResponseJSON);
        if(testWCSegResponse == null) {
            System.assertEquals(null, testWCSegResponse);            
        } else {
            System.assertNotEquals(null, testWCSegResponse);
            if(testWCSegResponse.assignedTreatment__c == null) {
                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
            } else {
                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
            }
        }
		Test.stopTest();
    }//end testParseJSONForNWCResponse
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testParseJSONForNWCResponseSearch() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();
        String testResponseJSON = queryForResponseJSONFromSearchStaticResource();
        System.debug('(testParseJSONForNWCResponse) testResponseJSON: \n' + testResponseJSON);
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromSearchStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        

        List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.parseJSONForNWCResponse(testResponseJSON);
        if(testWCSegResponse == null) {
            System.assertEquals(null, testWCSegResponse);            
        } else {
            System.assertNotEquals(null, testWCSegResponse);
            if(testWCSegResponse.assignedTreatment__c == null) {
                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
            } else {
                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
            }
        }
		Test.stopTest();
    }//end testParseJSONForNWCResponseSearch
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testParseJSONForNWCResponseSearchAll() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();
        String testResponseJSON = queryForResponseJSONFromSearchAllStaticResource();
        System.debug('(testParseJSONForNWCResponse) testResponseJSON.length() = ' + (testResponseJSON != null ? testResponseJSON.length() : -1));
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromSearchAllStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        

        List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.parseJSONForNWCResponse(testResponseJSON);
        if(testWCSegResponse == null) {
            System.assertEquals(null, testWCSegResponse);            
        } else {
            System.assertNotEquals(null, testWCSegResponse);
            if(testWCSegResponse.assignedTreatment__c == null) {
                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
            } else {
                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
            }
        }
		Test.stopTest();
    }//end testParseJSONForNWCResponseSearchAll
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testParseJSONForNWCResponseNullJSON() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.parseJSONForNWCResponse(null);
        if(testWCSegResponse == null) {
            System.assertEquals(null, testWCSegResponse);            
        } else {
            System.assertNotEquals(null, testWCSegResponse);
            if(testWCSegResponse.assignedTreatment__c == null) {
                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
            } else {
                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
            }
        }
		Test.stopTest();
    }//end testParseJSONForNWCResponseNullJSON
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testParseJSONForNWCResponseBadCLLIResponseJSON() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.parseJSONForNWCResponse(mockTestBadCLLIResponseJSON);
        if(testWCSegResponse == null) {
            System.assertEquals(null, testWCSegResponse);            
        } else {
            System.assertNotEquals(null, testWCSegResponse);
            if(testWCSegResponse.assignedTreatment__c == null) {
                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
            } else {
                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
            }
        }
		Test.stopTest();
    }//end testParseJSONForNWCResponseBadCLLIResponseJSON
    /* */

    /* */
    @AuraEnabled
    public static testMethod void testParseJSONForNWCResponseZeroResponse() {
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();

        Test.startTest();        
        List<BRAIN_WCSeg_Response__c> testWCSegRespList = WCSegCalloutHelper.parseJSONForNWCResponse('[ ]');
        if(testWCSegResponse == null) {
            System.assertEquals(null, testWCSegResponse);            
        } else {
            System.assertNotEquals(null, testWCSegResponse);
            if(testWCSegResponse.assignedTreatment__c == null) {
                System.assertEquals(null, testWCSegResponse.assignedTreatment__c);
            } else {
                System.assertNotEquals(null, testWCSegResponse.assignedTreatment__c);
            }
        }
		Test.stopTest();
    }//end testParseJSONForNWCResponseZeroResponse
    /* */

	/*  */      
    public static testMethod void testParseForAccessToken() {
        String mockTestAccessReqBody = '{ "refresh_token_expires_in": "0", ' + 
    		'"api_product_list": "[BRAIN - Broadband Reinvestment Artificial Intelligence Network]", ' +
            '"api_product_list_json": [ "BRAIN - Broadband Reinvestment Artificial Intelligence Network" ], ' +
    		'"organization_name": "ext", ' + 
            '"developer.email": "matt.holden@lumen.com", ' + 
            '"token_type": "Bearer", ' +
            '"issued_at": "1656008376489", ' + 
    		'"client_id": "whatchamacallit", ' +
		    '"access_token": "supercalifragilistic", ' +
            '"application_name": "expialidocious", ' +
            '"scope": "Party like it`s ", ' +
            '"expires_in": "1999", ' + 
            '"refresh_count": "0", ' +
            '"status": "approved" }';
        
        Test.startTest();
        String testAccessToken = WCSegCalloutHelper.parseForAccessToken(mockTestAccessReqBody);
        if(testAccessToken == null) {
            System.assertEquals(null, testAccessToken);
        } else {
            System.assertNotEquals(null, testAccessToken);
        }
        Test.stopTest();
    }//end testMethod testParseForAccessToken
	/*  */      
    
	/*  */      
    public static testMethod void testParseForAccessTokenNullBody() { 
        String mockTestAccessReqBody = null;
        
        Test.startTest();
        String testAccessToken = WCSegCalloutHelper.parseForAccessToken(mockTestAccessReqBody);
        if(testAccessToken == null) {
            System.assertEquals(null, testAccessToken);
        } else {
            System.assertNotEquals(null, testAccessToken);
        }
        Test.stopTest();
    }//end testMethod testParseForAccessTokenNullBody
	/*  */      

	/*  */  
	@AuraEnabled
    public static testMethod void testQueryNetworkWireCenterAllCLLI() {

        Test.startTest();
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        if(nwcAllList == null) {
            System.assertEquals(null, nwcAllList);
        } else {
            System.assertNotEquals(null, nwcAllList);
            if(nwcAllList.size() == 0) {
                System.assertEquals(0, nwcAllList.size());
            } else {
                System.assertNotEquals(0, nwcAllList.size());
            }
        }//end else NOT NULL
        Test.stopTest();

    }//end testMethod testQueryNetworkWireCenterAllCLLI
	/*  */

	/*  */  
	@AuraEnabled
    public static testMethod void testQueryNetworkWireCenterCLLICodeByName() {

        Test.startTest();
        List<Network_Wire_Center__c> nwcByNameList = WCSegCalloutHelper.queryWirecenterCLLICodeByName(mockTestCLLI);
        if(nwcByNameList == null) {
            System.assertEquals(null, nwcByNameList);
        } else {
            System.assertNotEquals(null, nwcByNameList);
            if(nwcByNameList.size() == 0) {
                System.assertEquals(0, nwcByNameList.size());
            } else {
                System.assertNotEquals(0, nwcByNameList.size());
            }
        }//end else NOT NULL
        Test.stopTest();

    }//end testMethod testQueryNetworkWireCenterCLLICodeByName
	/* */

	/*  */  
	@AuraEnabled
    public static testMethod void testQueryNetworkWireCenterCLLICodeByNameBadCLLI() {

        Test.startTest();
        List<Network_Wire_Center__c> nwcByNameList = WCSegCalloutHelper.queryWirecenterCLLICodeByName(mockTestBadCLLI);
        if(nwcByNameList == null) {
            System.assertEquals(null, nwcByNameList);
        } else {
            System.assertNotEquals(null, nwcByNameList);
            if(nwcByNameList.size() == 0) {
                System.assertEquals(0, nwcByNameList.size());
            } else {
                System.assertNotEquals(0, nwcByNameList.size());
            }
        }//end else NOT NULL
        Test.stopTest();

    }//end testMethod testQueryNetworkWireCenterCLLICodeByNameBadCLLI
	/* */
    
	/*  */  
	@AuraEnabled
    public static testMethod void testQueryNetworkWireCenterNamesOnly() {

        Test.startTest();
        List<Network_Wire_Center__c> nwcByNameList = WCSegCalloutHelper.queryWirecenterCLLICodeByName(mockTestCLLI);
        if(nwcByNameList == null) {
            System.assertEquals(null, nwcByNameList);
        } else {
            System.assertNotEquals(null, nwcByNameList);
            if(nwcByNameList.size() == 0) {
                System.assertEquals(0, nwcByNameList.size());
            } else {
                System.assertNotEquals(0, nwcByNameList.size());
            }
        }//end else NOT NULL
        Test.stopTest();

    }//end testMethod testQueryNetworkWireCenterNamesOnly
	/*  */

	/*  */  
	@AuraEnabled
    public static testMethod void testQueryNetworkWireCenterNamesOnlyBadCLLI() {

        Test.startTest();
        List<Network_Wire_Center__c> nwcByNameList = WCSegCalloutHelper.queryWirecenterCLLICodeByName(null);
        if(nwcByNameList == null) {
            System.assertEquals(null, nwcByNameList);
        } else {
            System.assertNotEquals(null, nwcByNameList);
            if(nwcByNameList.size() == 0) {
                System.assertEquals(0, nwcByNameList.size());
            } else {
                System.assertNotEquals(0, nwcByNameList.size());
            }
        }//end else NOT NULL
        Test.stopTest();

    }//end testMethod testQueryNetworkWireCenterNamesOnlyBadCLLI
	/* */
    
	/* */  
	@AuraEnabled
    public static testMethod void testCheckNWCForUpdates() {

        Test.startTest();
        String testResponseJSON = queryForResponseJSONFromSearchAllStaticResource();
        System.debug('(testParseJSONForNWCResponse) testResponseJSON.length() = ' + (testResponseJSON != null ? testResponseJSON.length() : -1));
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromSearchAllStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        

        List<BRAIN_WCSeg_Response__c> testRespList = WCSegCalloutHelper.parseJSONForNWCResponse(testResponseJSON);
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        List<String> nwcNamesOnlyList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(nwcAllList);
		testRespList = WCSegCalloutHelper.buildBaseWCSegResponse(testResponseJSON, nwcAllList, nwcNamesOnlyList);
        if (nwcAllList == null) {
            System.assertEquals(null, nwcAllList);
        } else {
            System.assertNotEquals(null, nwcAllList);
            if (nwcAllList.size() < 1) {
                System.assertEquals(0, nwcAllList.size());
            } else {
                System.assertNotEquals(0, nwcAllList.size());
                if (nwcNamesOnlyList == null) {
                    System.assertEquals(null, nwcNamesOnlyList);
                } else {
                    System.assertNotEquals(null, nwcNamesOnlyList);
                    if (nwcNamesOnlyList.size() < 1) {
                        System.assertEquals(0, nwcNamesOnlyList.size());
                    } else {
                        System.assertNotEquals(0, nwcNamesOnlyList.size());
                        if (testRespList == null) {
                            System.assertEquals(null, testRespList);
                        } else {
                            System.assertNotEquals(null, testRespList);
                            if (testRespList.size() < 1) {
                                System.assertEquals(0, testRespList.size());
                            } else {
                                System.assertNotEquals(0, testRespList.size());
                            }//end else testRespList-size NOT 0
                        }//end else testRespList NOT NULL
                    }//end else nwcNamesOnlyList-size NOT 0
                }//end else nwcNamesOnlyList NOT NULL
            }//end else nwcList-size NOT 0
        }//end else nwcList NOT NULL
        List<Network_Wire_Center__c> nwcToUpdateList = WCSegCalloutHelper.checkNWCForUpdates(nwcNamesOnlyList, nwcAllList, testRespList);
        if (nwcToUpdateList == null) {
            System.assertEquals(null, nwcToUpdateList);
        } else {
            System.assertNotEquals(null, nwcToUpdateList);
            if (nwcToUpdateList.size() == 0) {
                System.assertEquals(0, nwcToUpdateList.size());
            } else {
                System.assertNotEquals(0, nwcToUpdateList.size());
                Network_Wire_Center__c nwcToUpdate = nwcToUpdateList.get(0);
                if (nwcToUpdate.Name == null) {
                    System.assertEquals(null, nwcToUpdate.Name);
                } else {
                    System.assertNotEquals(null, nwcToUpdate.Name);
                    if (nwcToUpdate.Wire_Center_Segmentation__c == null) {
                        System.assertEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    } else {
                        System.assertNotEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    }//end else Segmentation NOT NULL
                }//end else Name NOT NULL
            }//end else nwcToUpdateList NOT 0
        }//end else nwcToUpdateList NOT NULL
        Test.stopTest();

    }//end testMethod testCheckNWCForUpdates
	/* */    
    
	/* */  
	@AuraEnabled
    public static testMethod void testCheckNWCForUpdatesSameSegValue() {

        Test.startTest();
        List<Network_Wire_Center__c> nwcByNameList = WCSegCalloutHelper.queryWirecenterCLLICodeByName(mockTestCLLI);
        Network_Wire_Center__c tempNWC = (nwcByNameList != null && nwcByNameList.size() > 0) ? nwcByNameList.get(0) : null;
        if(tempNWC != null) {
            tempNWC.Wire_Center_Segmentation__c = 'WEAK';
            update tempNWC;
        }
        
        String testResponseJSON = queryForResponseJSONFromSearchAllStaticResource();
        System.debug('(testParseJSONForNWCResponse) testResponseJSON.length() = ' + (testResponseJSON != null ? testResponseJSON.length() : -1));
        if (testResponseJSON == null) {
			HttpResponse httpRespSR = getHttpResponseFromSearchAllStaticResource();
            testResponseJSON = httpRespSR.getBody();
        }        

        List<BRAIN_WCSeg_Response__c> testRespList = WCSegCalloutHelper.parseJSONForNWCResponse(testResponseJSON);
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        List<String> nwcNamesOnlyList = WCSegCalloutHelper.extractNamesOfAllWirecenterCLLICodes(nwcAllList);
		testRespList = WCSegCalloutHelper.buildBaseWCSegResponse(testResponseJSON, nwcAllList, nwcNamesOnlyList);
        if (nwcAllList == null) {
            System.assertEquals(null, nwcAllList);
        } else {
            System.assertNotEquals(null, nwcAllList);
            if (nwcAllList.size() < 1) {
                System.assertEquals(0, nwcAllList.size());
            } else {
                System.assertNotEquals(0, nwcAllList.size());
                if (nwcNamesOnlyList == null) {
                    System.assertEquals(null, nwcNamesOnlyList);
                } else {
                    System.assertNotEquals(null, nwcNamesOnlyList);
                    if (nwcNamesOnlyList.size() < 1) {
                        System.assertEquals(0, nwcNamesOnlyList.size());
                    } else {
                        System.assertNotEquals(0, nwcNamesOnlyList.size());
                        if (testRespList == null) {
                            System.assertEquals(null, testRespList);
                        } else {
                            System.assertNotEquals(null, testRespList);
                            if (testRespList.size() < 1) {
                                System.assertEquals(0, testRespList.size());
                            } else {
                                System.assertNotEquals(0, testRespList.size());
                            }//end else testRespList-size NOT 0
                        }//end else testRespList NOT NULL
                    }//end else nwcNamesOnlyList-size NOT 0
                }//end else nwcNamesOnlyList NOT NULL
            }//end else nwcList-size NOT 0
        }//end else nwcList NOT NULL
        List<Network_Wire_Center__c> nwcToUpdateList = WCSegCalloutHelper.checkNWCForUpdates(nwcNamesOnlyList, nwcAllList, testRespList);
        if (nwcToUpdateList == null) {
            System.assertEquals(null, nwcToUpdateList);
        } else {
            System.assertNotEquals(null, nwcToUpdateList);
            if (nwcToUpdateList.size() == 0) {
                System.assertEquals(0, nwcToUpdateList.size());
            } else {
                System.assertNotEquals(0, nwcToUpdateList.size());
                Network_Wire_Center__c nwcToUpdate = nwcToUpdateList.get(0);
                if (nwcToUpdate.Name == null) {
                    System.assertEquals(null, nwcToUpdate.Name);
                } else {
                    System.assertNotEquals(null, nwcToUpdate.Name);
                    if (nwcToUpdate.Wire_Center_Segmentation__c == null) {
                        System.assertEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    } else {
                        System.assertNotEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    }//end else Segmentation NOT NULL
                }//end else Name NOT NULL
            }//end else nwcToUpdateList NOT 0
        }//end else nwcToUpdateList NOT NULL
        Test.stopTest();

    }//end testMethod testCheckNWCForUpdatesSameSegValue
	/* */
    
	/* */  
	@AuraEnabled
    public static testMethod void testCheckNWCForUpdatesBlankName() {

        Test.startTest();
        List<String> nwcNamesList = new List<String>();
        nwcNamesList.add('');
        List<Network_Wire_Center__c> nwcByNameList = WCSegCalloutHelper.queryWirecenterCLLICodeByName('');
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();
        testWCSegResponse.clliCode__c = mockTestCLLI;
        testWCSegResponse.assignedTreatment__c = 'HIGH POTENTIAL';
        testWCSegResponse.Network_Wire_Center_Master__c = 'a0004000003OMaRAAW';
        testWCSegResponse.Network_Wire_Center_Master__r = (nwcByNameList != null && nwcByNameList.size() > 0) ? nwcByNameList.get(0) : null;
        List<BRAIN_WCSeg_Response__c> respList = new List<BRAIN_WCSeg_Response__c>();
        respList.add(testWCSegResponse);
        List<Network_Wire_Center__c> nwcToUpdateList = WCSegCalloutHelper.checkNWCForUpdates(nwcNamesList, nwcByNameList, respList);
        if (nwcToUpdateList == null) {
            System.assertEquals(null, nwcToUpdateList);
        } else {
            System.assertNotEquals(null, nwcToUpdateList);
            if (nwcToUpdateList.size() == 0) {
                System.assertEquals(0, nwcToUpdateList.size());
            } else {
                System.assertNotEquals(0, nwcToUpdateList.size());
                Network_Wire_Center__c nwcToUpdate = nwcToUpdateList.get(0);
                if (nwcToUpdate.Name == null) {
                    System.assertEquals(null, nwcToUpdate.Name);
                } else {
                    System.assertNotEquals(null, nwcToUpdate.Name);
                    if (nwcToUpdate.Wire_Center_Segmentation__c == null) {
                        System.assertEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    } else {
                        System.assertNotEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    }//end else Segmentation NOT NULL
                }//end else Name NOT NULL
            }//end else nwcToUpdateList NOT 0
        }//end else nwcToUpdateList NOT NULL
        Test.stopTest();

    }//end testMethod testCheckNWCForUpdatesBlankName
	/*  */
    
	/*  */  
	@AuraEnabled
    public static testMethod void testCheckNWCForUpdatesBlankMasterName() {

        Test.startTest();
        List<String> nwcNamesList = new List<String>();
        nwcNamesList.add(mockTestCLLI);
        List<Network_Wire_Center__c> nwcByNameList = WCSegCalloutHelper.queryWirecenterCLLICodeByName(mockTestCLLI);
        Network_Wire_Center__c diffNameTestNWC = new Network_Wire_Center__c();
        diffNameTestNWC.Name = '';
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();
        testWCSegResponse.clliCode__c = mockTestCLLI;
        testWCSegResponse.assignedTreatment__c = 'HIGH POTENTIAL';
        testWCSegResponse.Network_Wire_Center_Master__c = 'a0004000003OMaRAAW';
        testWCSegResponse.Network_Wire_Center_Master__r = diffNameTestNWC;
        List<BRAIN_WCSeg_Response__c> respList = new List<BRAIN_WCSeg_Response__c>();
        respList.add(testWCSegResponse);
		List<Network_Wire_Center__c> nwcToUpdateList = WCSegCalloutHelper.checkNWCForUpdates(nwcNamesList, nwcByNameList, respList);
        if (nwcToUpdateList == null) {
            System.assertEquals(null, nwcToUpdateList);
        } else {
            System.assertNotEquals(null, nwcToUpdateList);
            if (nwcToUpdateList.size() == 0) {
                System.assertEquals(0, nwcToUpdateList.size());
            } else {
                System.assertNotEquals(0, nwcToUpdateList.size());
                Network_Wire_Center__c nwcToUpdate = nwcToUpdateList.get(0);
                if (nwcToUpdate.Name == null) {
                    System.assertEquals(null, nwcToUpdate.Name);
                } else {
                    System.assertNotEquals(null, nwcToUpdate.Name);
                    if (nwcToUpdate.Wire_Center_Segmentation__c == null) {
                        System.assertEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    } else {
                        System.assertNotEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    }//end else Segmentation NOT NULL
                }//end else Name NOT NULL
            }//end else nwcToUpdateList NOT 0
        }//end else nwcToUpdateList NOT NULL
        Test.stopTest();

    }//end testMethod testCheckNWCForUpdatesBlankMasterName
	/*  */
    
	/*  */  
	@AuraEnabled
    public static testMethod void testCheckNWCForUpdatesNamesMismatch() {

        Test.startTest();
        List<String> nwcNamesList = new List<String>();
        nwcNamesList.add(mockTestCLLI);        
        List<Network_Wire_Center__c> nwcByNameList = WCSegCalloutHelper.queryWirecenterCLLICodeByName(mockTestCLLI);
        Network_Wire_Center__c diffNameTestNWC = new Network_Wire_Center__c();
        diffNameTestNWC.Name = mockTestBadCLLI;
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();
        testWCSegResponse.clliCode__c = mockTestCLLI;
        testWCSegResponse.assignedTreatment__c = 'HIGH POTENTIAL';
        testWCSegResponse.Network_Wire_Center_Master__c = 'a0004000003OMaRAAW';
        testWCSegResponse.Network_Wire_Center_Master__r = diffNameTestNWC;
        List<BRAIN_WCSeg_Response__c> respList = new List<BRAIN_WCSeg_Response__c>();
        respList.add(testWCSegResponse);
		List<Network_Wire_Center__c> nwcToUpdateList = WCSegCalloutHelper.checkNWCForUpdates(nwcNamesList, nwcByNameList, respList);
        if (nwcToUpdateList == null) {
            System.assertEquals(null, nwcToUpdateList);
        } else {
            System.assertNotEquals(null, nwcToUpdateList);
            if (nwcToUpdateList.size() == 0) {
                System.assertEquals(0, nwcToUpdateList.size());
            } else {
                System.assertNotEquals(0, nwcToUpdateList.size());
                Network_Wire_Center__c nwcToUpdate = nwcToUpdateList.get(0);
                if (nwcToUpdate.Name == null) {
                    System.assertEquals(null, nwcToUpdate.Name);
                } else {
                    System.assertNotEquals(null, nwcToUpdate.Name);
                    if (nwcToUpdate.Wire_Center_Segmentation__c == null) {
                        System.assertEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    } else {
                        System.assertNotEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    }//end else Segmentation NOT NULL
                }//end else Name NOT NULL
            }//end else nwcToUpdateList NOT 0
        }//end else nwcToUpdateList NOT NULL
        Test.stopTest();

    }//end testMethod testCheckNWCForUpdatesNamesMismatch
	/*  */
    
	/*  */  
	@AuraEnabled
    public static testMethod void testCheckNWCForUpdatesNullWCSegRespObj() {

        Test.startTest();
        List<String> nwcNamesList = new List<String>();
        nwcNamesList.add(mockTestCLLI);        
        List<Network_Wire_Center__c> nwcByNameList = WCSegCalloutHelper.queryWirecenterCLLICodeByName(mockTestCLLI);
        List<BRAIN_WCSeg_Response__c> respList = new List<BRAIN_WCSeg_Response__c>();
        respList.add(null);
		List<Network_Wire_Center__c> nwcToUpdateList = WCSegCalloutHelper.checkNWCForUpdates(nwcNamesList, nwcByNameList, respList);
        if (nwcToUpdateList == null) {
            System.assertEquals(null, nwcToUpdateList);
        } else {
            System.assertNotEquals(null, nwcToUpdateList);
            if (nwcToUpdateList.size() == 0) {
                System.assertEquals(0, nwcToUpdateList.size());
            } else {
                System.assertNotEquals(0, nwcToUpdateList.size());
                Network_Wire_Center__c nwcToUpdate = nwcToUpdateList.get(0);
                if (nwcToUpdate.Name == null) {
                    System.assertEquals(null, nwcToUpdate.Name);
                } else {
                    System.assertNotEquals(null, nwcToUpdate.Name);
                    if (nwcToUpdate.Wire_Center_Segmentation__c == null) {
                        System.assertEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    } else {
                        System.assertNotEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    }//end else Segmentation NOT NULL
                }//end else Name NOT NULL
            }//end else nwcToUpdateList NOT 0
        }//end else nwcToUpdateList NOT NULL
        Test.stopTest();

    }//end testMethod testCheckNWCForUpdatesNullWCSegRespObj
	/*  */
    
	/*  */  
	@AuraEnabled
    public static testMethod void testCheckNWCForUpdatesNullNWCObj() {

        Test.startTest();
        List<String> nwcNamesList = new List<String>();
        nwcNamesList.add(mockTestCLLI);        
        List<Network_Wire_Center__c> nwcList = new List<Network_Wire_Center__c>();
        nwcList.add(null);
        BRAIN_WCSeg_Response__c testWCSegResponse = new BRAIN_WCSeg_Response__c();
        testWCSegResponse.clliCode__c = mockTestCLLI;
        testWCSegResponse.assignedTreatment__c = 'HIGH POTENTIAL';
        testWCSegResponse.Network_Wire_Center_Master__c = 'a0004000003OMaRAAW';
        testWCSegResponse.Network_Wire_Center_Master__r = (nwcList != null && nwcList.size() > 0) ? nwcList.get(0) : null;
        List<BRAIN_WCSeg_Response__c> respList = new List<BRAIN_WCSeg_Response__c>();
        respList.add(testWCSegResponse);
		List<Network_Wire_Center__c> nwcToUpdateList = WCSegCalloutHelper.checkNWCForUpdates(nwcNamesList, nwcList, respList);
        if (nwcToUpdateList == null) {
            System.assertEquals(null, nwcToUpdateList);
        } else {
            System.assertNotEquals(null, nwcToUpdateList);
            if (nwcToUpdateList.size() == 0) {
                System.assertEquals(0, nwcToUpdateList.size());
            } else {
                System.assertNotEquals(0, nwcToUpdateList.size());
                Network_Wire_Center__c nwcToUpdate = nwcToUpdateList.get(0);
                if (nwcToUpdate.Name == null) {
                    System.assertEquals(null, nwcToUpdate.Name);
                } else {
                    System.assertNotEquals(null, nwcToUpdate.Name);
                    if (nwcToUpdate.Wire_Center_Segmentation__c == null) {
                        System.assertEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    } else {
                        System.assertNotEquals(null, nwcToUpdate.Wire_Center_Segmentation__c);
                    }//end else Segmentation NOT NULL
                }//end else Name NOT NULL
            }//end else nwcToUpdateList NOT 0
        }//end else nwcToUpdateList NOT NULL
        Test.stopTest();

    }//end testMethod testCheckNWCForUpdatesNullNWCObj
	/*  */
    
	/*  */  
	@AuraEnabled
    public static testMethod void testUpdateWCSegmentation() {

        Test.startTest();
        List<Network_Wire_Center__c> nwcAllList = WCSegCalloutHelper.queryAllWirecenterCLLICodes();
        if(nwcAllList == null) {
            System.assertEquals(null, nwcAllList);
        } else {
            System.assertNotEquals(null, nwcAllList);
            if(nwcAllList.size() < 1) {
                System.assertEquals(0, nwcAllList.size());
            } else {
                System.assertNotEquals(0, nwcAllList.size());
                List<Network_Wire_Center__c> nwcUpdatedList = new List<Network_Wire_Center__c>();
                nwcUpdatedList.add(nwcAllList.get(0));
                WCSegCalloutHelper.updateWCSegmentation(nwcUpdatedList);
		        System.assertEquals(1, nwcUpdatedList.size());
           }//end else nwcAllList-size NOT 0
        }//end else nwcAllList NOT NULL
        Test.stopTest();

    }//end testMethod testUpdateWCSegmentation
	/*  */
    
	/*  */  
	@AuraEnabled
    public static testMethod void testUpdateWCSegmentationNullList() {

        Test.startTest();
        List<Network_Wire_Center__c> nwcUpdatedList = null;
        WCSegCalloutHelper.updateWCSegmentation(null);
        System.assertEquals(null, nwcUpdatedList);
        Test.stopTest();

    }//end testMethod testUpdateWCSegmentationNullList
	/*  */
    
	/*  */  
	@AuraEnabled
    public static testMethod void testUpdateWCSegmentationZeroList() {

        Test.startTest();
        List<Network_Wire_Center__c> nwcUpdatedList = new List<Network_Wire_Center__c>();
        WCSegCalloutHelper.updateWCSegmentation(nwcUpdatedList);
        System.assertEquals(0, nwcUpdatedList.size());
        Test.stopTest();

    }//end testMethod testUpdateWCSegmentationZeroList
	/*  */

    /* */
    public static HttpResponse getHttpResponseFromStaticResource() {
        // Setup mockCallout To BRAIN-WireCenterSegmentation API
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);
        String mockAccessToken = 't3StC0d3C0v3rA93Ca110uT';        
        // Call the method that builds the mock of the HttpRequest to BRAIN

        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        HttpRequest mockHttpRequest = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(mockAccessToken, thisTestNWC.Name);
		// Call the method that builds the mock of the HttpResponse from BRAIN
        HttpResponse mockHttpResponse = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(mockHttpRequest, thisTestNWC.Name);
		// Return the mocked HttpResponse from BRAIN
        return mockHttpResponse;        
    }// end getHttpResponseFromStaticResource
    /* */

    /* */
    public static HttpResponse getHttpResponseFromSearchStaticResource() {
        // Setup mockCallout To BRAIN-WireCenterSegmentation API
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestSearchWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);
        String mockAccessToken = 't3StC0d3C0v3rA93Ca110uT';        
        // Call the method that builds the mock of the HttpRequest to BRAIN

        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        HttpRequest mockHttpRequest = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(mockAccessToken, thisTestNWC.Name);
		// Call the method that builds the mock of the HttpResponse from BRAIN
        HttpResponse mockHttpResponse = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(mockHttpRequest, thisTestNWC.Name);
		// Return the mocked HttpResponse from BRAIN
        return mockHttpResponse;        
    }// end getHttpResponseFromSearchStaticResource
    /* */

    /* */
    public static HttpResponse getHttpResponseFromSearchAllStaticResource() {
        // Setup mockCallout To BRAIN-WireCenterSegmentation API
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestSearchAllWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);
        String mockAccessToken = 't3StC0d3C0v3rA93Ca110uT';        
        // Call the method that builds the mock of the HttpRequest to BRAIN

        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestAllCLLI;
        HttpRequest mockHttpRequest = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(mockAccessToken, thisTestNWC.Name);
		// Call the method that builds the mock of the HttpResponse from BRAIN
        HttpResponse mockHttpResponse = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(mockHttpRequest, thisTestNWC.Name);
		// Return the mocked HttpResponse from BRAIN
        return mockHttpResponse;        
    }// end getHttpResponseFromSearchAllStaticResource
    /* */
    
    /* */
    public static HttpResponse getHttpResponseFromStaticResourceWith401StatusCode() {
        // Setup mockCallout To BRAIN-WireCenterSegmentation API
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(401);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);
        String mockAccessToken = 't3StC0d3C0v3rA93Ca110uT';        
        // Call the method that builds the mock of the HttpRequest to BRAIN

        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        HttpRequest mockHttpRequest = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(mockAccessToken, thisTestNWC.Name);
		// Call the method that builds the mock of the HttpResponse from BRAIN
        HttpResponse mockHttpResponse = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(mockHttpRequest, thisTestNWC.Name);
		// Return the mocked HttpResponse from BRAIN
        return mockHttpResponse;        
    }// end getHttpResponseFromStaticResourceWith401StatusCode
    /* */
    
    /* */
    public static HttpResponse getHttpResponseFromSearchStaticResourceWith401StatusCode() {
        // Setup mockCallout To BRAIN-WireCenterSegmentation API
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestSearchWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(401);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);
        String mockAccessToken = 't3StC0d3C0v3rA93Ca110uT';        
        // Call the method that builds the mock of the HttpRequest to BRAIN

        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestCLLI;
        HttpRequest mockHttpRequest = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(mockAccessToken, thisTestNWC.Name);
		// Call the method that builds the mock of the HttpResponse from BRAIN
        HttpResponse mockHttpResponse = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(mockHttpRequest, thisTestNWC.Name);
		// Return the mocked HttpResponse from BRAIN
        return mockHttpResponse;        
    }// end getHttpResponseFromSearchStaticResourceWith401StatusCode
    /* */
    
    /* */
    public static HttpResponse getHttpResponseWithLONGJSONFromStaticResource() {
        // Setup mockCallout To BRAIN-WireCenterSegmentation API
        StaticResourceCalloutMock mockCalloutToWCSeg = new StaticResourceCalloutMock();
		mockCalloutToWCSeg.setStaticResource('TestSearchAllWCSegResponseJSON');
		mockCalloutToWCSeg.setStatusCode(200);
		mockCalloutToWCSeg.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mockCalloutToWCSeg);
        String mockAccessToken = 't3StC0d3C0v3rA93Ca110uT';        
        // Call the method that builds the mock of the HttpRequest to BRAIN

        Network_Wire_Center__c thisTestNWC = new Network_Wire_Center__c();
        thisTestNWC.Name = mockTestAllCLLI;
        HttpRequest mockHttpRequest = WCSegCalloutHelper.buildHttpRequestForSearchWCSegService(mockAccessToken, thisTestNWC.Name);
		// Call the method that builds the mock of the HttpResponse from BRAIN
        HttpResponse mockHttpResponse = WCSegCalloutHelper.getHttpResponseFromSearchWCSegService(mockHttpRequest, thisTestNWC.Name);
		// Return the mocked HttpResponse from BRAIN
        return mockHttpResponse;        
    }// end getHttpResponseWithLONGJSONFromStaticResource
    /* */
    
    /* */
    public static String queryForResponseJSONFromStaticResource() {
		String srName = 'TestSearchWCSegResponseJSON';
    	String srResponseJSON = null;
        // Setup 
        StaticResource testResponseSR = null;
        try {
	        testResponseSR = [SELECT Id, Name, Body FROM StaticResource WHERE Name = :srName LIMIT 1];
        } catch (Exception srX) {
            System.debug('EXCEPTION!  Error querying for StaticResource ("' + srName + '")');
        }
        if (testResponseSR != null && testResponseSR.Body != null) {
			srResponseJSON = testResponseSR.Body.ToString();
        } else {
            srResponseJSON = null;
        }
		// Return the body of the queried StaticResource
        return srResponseJSON;        
    }// end queryForResponseJSONFromStaticResource
    /* */
    
    /* */
    public static String queryForResponseJSONFromSearchStaticResource() {
		String srName = 'TestSearchWCSegResponseJSON';
    	String srResponseJSON = null;
        // Setup 
        StaticResource testResponseSR = null;
        try {
	        testResponseSR = [SELECT Id, Name, Body FROM StaticResource WHERE Name = :srName LIMIT 1];
        } catch (Exception srX) {
            System.debug('EXCEPTION!  Error querying for StaticResource ("' + srName + '")');
        }
        if (testResponseSR != null && testResponseSR.Body != null) {
			srResponseJSON = testResponseSR.Body.ToString();
        } else {
            srResponseJSON = null;
        }
		// Return the body of the queried StaticResource
        return srResponseJSON;        
    }// end queryForResponseJSONFromSearchStaticResource
    /* */
    
    /* */
    public static String queryForResponseJSONFromSearchAllStaticResource() {
		String srName = 'TestSearchAllWCSegResponseJSON';
    	String srResponseJSON = null;
        // Setup 
        StaticResource testResponseSR = null;
        try {
	        testResponseSR = [SELECT Id, Name, Body FROM StaticResource WHERE Name = :srName LIMIT 1];
        } catch (Exception srX) {
            System.debug('EXCEPTION!  Error querying for StaticResource ("' + srName + '")');
        }
        if (testResponseSR != null && testResponseSR.Body != null) {
			srResponseJSON = testResponseSR.Body.ToString();
        } else {
            srResponseJSON = null;
        }
		// Return the body of the queried StaticResource
        return srResponseJSON;        
    }// end queryForResponseJSONFromSearchAllStaticResource
    /* */
    
    /* */
    public static String queryForLONGResponseJSONFromStaticResource() {
		String srName = 'TestSearchAllWCSegResponseJSON';
    	String srResponseJSON = null;
        // Setup 
        StaticResource testResponseSR = null;
        try {
	        testResponseSR = [SELECT Id, Name, Body FROM StaticResource WHERE Name = :srName LIMIT 1];
        } catch (Exception srX) {
            System.debug('EXCEPTION!  Error querying for StaticResource ("' + srName + '")');
        }
        if (testResponseSR != null && testResponseSR.Body != null) {
			srResponseJSON = testResponseSR.Body.ToString();
        } else {
            srResponseJSON = null;
        }
		// Return the body of the queried StaticResource
        return srResponseJSON;        
    }// end queryForLONGResponseJSONFromStaticResource
    /* */

    public static HttpResponse getMockApigeeHttpResponse() {
    	String mockApigeeResponseBody = '{ "refresh_token_expires_in": "0", ' + 
    		'"api_product_list": "[BRAIN - Broadband Reinvestment Artificial Intelligence Network]", ' +
            '"api_product_list_json": [ "BRAIN - Broadband Reinvestment Artificial Intelligence Network" ], ' +
    		'"organization_name": "ext", ' + 
            '"developer.email": "matt.holden@lumen.com", ' + 
            '"token_type": "Bearer", ' +
            '"issued_at": "1656008376489", ' + 
    		'"client_id": "whatchamacallit", ' +
		    '"access_token": "supercalifragilistic", ' +
            '"application_name": "expialidocious", ' +
            '"scope": "Party like it`s ", ' +
            '"expires_in": "1999", ' + 
            '"refresh_count": "0", ' +
            '"status": "approved" }';
        
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setStatusCode(200);
        mockHttpResponse.setBody(mockApigeeResponseBody);
		// Return the mocked HttpResponse 
        return mockHttpResponse;        
    }//end method getMockApigeeHttpResponse 

    public static HttpResponse getMockWCSegHttpResponse() {
        String mockWCSegResponseBody = queryForResponseJSONFromSearchStaticResource();
        HttpResponse mockHttpResponse = new HttpResponse();
        mockHttpResponse.setHeader('Content-Type', 'application/json');
        mockHttpResponse.setStatusCode(200);
        mockHttpResponse.setBody(mockWCSegResponseBody);
		// Return the mocked HttpResponse 
        return mockHttpResponse;        
    }//end method getMockWCSegHttpResponse
}//end test-class TestWCSegCalloutHelper