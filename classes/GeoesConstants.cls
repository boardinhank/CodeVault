public class GeoesConstants {
    public static final String GREENFIELD                        = 'Greenfield';
    public static final String BROWNFIELD                        = 'Brownfield';
    public static final String MATCH_SYSTEM_FOUND_YES            = 'Yes';
    public static final String MATCH_SYSTEM_FOUND_NO             = 'No';
    public static final String MATCH_SYSTEM_FOUND_DUPLICATE      = 'Duplicate';
    public static final String ADDRESSLINE1_FIELDNAME            = 'addressLine1';
    public static final String LOCALITY_FIELDNAME                = 'locality';
    public static final String STATEORPROVINCE_FIELDNAME         = 'stateOrProvince';
    public static final String POSTCODE_FIELDNAME                = 'postCode';
    public static final String COUNTY_FIELDNAME                  = 'county';
    public static final String COUNTRY_FIELDNAME                 = 'country';
    public static final String GEOADDRESSID_FIELDNAME            = 'geoAddressId';
    public static final String SEARCHALLSOURCES_FIELDNAME        = 'searchAllSources';
    public static final String LIVEDATA_FIELDNAME                = 'liveData';
    public static final String EXPAND_FIELDNAME                  = 'expand';
    public static final String SOURCES_FIELDNAME                 = 'sources';
    public static final String EXPAND_FIELDVALUE                 = 'attributes,wirecenter,geoPoint';
    public static final String SOURCES_FIELDVALUE                = 'lfacs,martens,clc';
    public static final String EXACT_MATCHTYPE                   = 'Exact Match';
    public static final String NEAR_MATCHTYPE                    = 'Near Match';
    public static final String PROPERTY_REQUEST_RECORD_ALN       = 'ALN';
    public static final String PROPERTY_REQUEST_RECORD_DODGE     = 'Dodge';
    public static final String PROPERTY_REQUEST_RECORD_USER      = 'User';
    public static final String PROPERTY_REQUEST_RECORD_CUSTOMER_SUCCESS = 'Customer Success';
    public static final String INVENTORY_SOURCE_LFACS            = 'LFACS';
    public static final String INVENTORY_SOURCE_MARTENS          = 'Martens';
    public static final String INVENTORY_SOURCE_CLC              = 'CLC'; // Added by Sravya (for US-ESCJ-1367)
    public static final String INVENTORY_SOURCE_QUANTUM_FIBER_O2 = 'Quantum Fiber/O2';
    
    public static final String PRR_MAPPING_ADDRESS    = 'address';
    public static final String PRR_MAPPING_CITY       = 'city';
    public static final String PRR_MAPPING_STATE      = 'state';
    public static final String PRR_MAPPING_ZIPCODE    = 'zipCode';
    public static final String PRR_MAPPING_COUNTY     = 'county';
    public static final String PRR_MAPPING_COUNTRY    = 'country';
    public static final String PRR_MAPPING_LATITUDE   = 'latitude';
    public static final String PRR_MAPPING_LONGITUDE  = 'longitude';
    public static final String PRR_MAPPING_APN        = 'apn';
    public static final String PRR_MAPPING_FIRSTNAME = 'firstName';
    public static final String PRR_MAPPING_LASTNAME = 'lastName';
    public static final String PRR_MAPPING_NAME = 'name';
    public static final String INCLUDE_MARKET_BOUNDARIES = 'includeMarketBoundaries';
    public static final String LIMIT_RESPONSE = 'limitResponse';

    public static final String HTTP_SUCCESS_STATUS_CODE = String.valueOf(200);
    public static final String HTTP_BAD_REQUEST_STATUS_CODE = String.valueOf(400);

    public static final String PARCEL_SERVICE_BY_LAT_LONG = 'ParcelServiceByLatLong';
    public static final String PARCEL_SERVICE_BY_ADDRESS = 'ParcelServiceByAddress';
    public static final String BIW_SERVICE_BY_LAT_LONG = 'BIWServiceByLatLong';
    public static final String BMPLOOPQUAL_SERVICE = 'BMPLoopQualService';
    public static final String UNIQUAL_BOUNDARY_SERVICE ='BoundaryUniqualService';
    public static final String LOOPQUAL_BANDWIDTH_SERVICE = 'LoopQualForBandwidth';
    
    public static final String DEFAULT_COUNTRY = 'USA';

    public static final String MATCH_SYSTEM_FOUND_PRR_DUPLICATE = 'Duplicate';
    public static final String MATCH_SYSTEM_FOUND_PRR_YES = 'Yes';
    public static final String MATCH_SYSTEM_FOUND_PRR_NO = 'No';

    public static final String DUPLICATE_PROPERTY_FOUND_PRR_YES = 'Yes';
    public static final String DUPLICATE_PROPERTY_FOUND_PRR_NO = 'No';
    public static final String DUPLICATE_PROPERTY_FOUND_PRR_DUPLICATE_PRR = 'Duplicate PRR';

    public static final String GEOES_RESULT_RED = 'Red';
    public static final String GEOES_RESULT_GREEN = 'Green';

    public static List<String> VALID_DATA_SOURCES {
        get {
            if(VALID_DATA_SOURCES == null) {
                VALID_DATA_SOURCES = new List<String>{
                    GeoesConstants.PROPERTY_REQUEST_RECORD_ALN,
                    GeoesConstants.PROPERTY_REQUEST_RECORD_DODGE,
                    GeoesConstants.PROPERTY_REQUEST_RECORD_CUSTOMER_SUCCESS,
                    GeoesConstants.PROPERTY_REQUEST_RECORD_USER
                };
            }
            return VALID_DATA_SOURCES;
        }
        set;
    }

    public static Map<String, Map<String, String>> propertyRequestDataSourceFieldMap {
        get {
            if(propertyRequestDataSourceFieldMap == null) {
                propertyRequestDataSourceFieldMap = new Map<String, Map<String, String>>{
                    PROPERTY_REQUEST_RECORD_ALN => new Map<String, String>{
                        PRR_MAPPING_ADDRESS     => Property_Request_Record__c.ProjectAddress__c.getDescribe().getName(),
                        PRR_MAPPING_CITY        => Property_Request_Record__c.ProjectCity__c.getDescribe().getName(),
                        PRR_MAPPING_STATE       => Property_Request_Record__c.ProjectState__c.getDescribe().getName(),
                        PRR_MAPPING_ZIPCODE     => Property_Request_Record__c.ProjectZIP__c.getDescribe().getName(),
                        PRR_MAPPING_COUNTY      => Property_Request_Record__c.County__c.getDescribe().getName(),
                        PRR_MAPPING_COUNTRY     => Property_Request_Record__c.COUNTRY__c.getDescribe().getName(),
                        PRR_MAPPING_LONGITUDE   => Property_Request_Record__c.GPSLongitude__c.getDescribe().getName(),
                        PRR_MAPPING_LATITUDE    => Property_Request_Record__c.GPSLatitude__c.getDescribe().getName(),
                        PRR_MAPPING_FIRSTNAME   => Property_Request_Record__c.ManagerFirstName__c.getDescribe().getName(),
                        PRR_MAPPING_LASTNAME    => Property_Request_Record__c.ManagerLastName__c.getDescribe().getName()
                    },
                    PROPERTY_REQUEST_RECORD_DODGE => new Map<String, String>{
                        PRR_MAPPING_ADDRESS     => Property_Request_Record__c.STREET__c.getDescribe().getName(),
                        PRR_MAPPING_CITY        => Property_Request_Record__c.CITY__c.getDescribe().getName(),
                        PRR_MAPPING_STATE       => Property_Request_Record__c.STATE__c.getDescribe().getName(),
                        PRR_MAPPING_ZIPCODE     => Property_Request_Record__c.ZIP_CODE__c.getDescribe().getName(),
                        PRR_MAPPING_COUNTY      => Property_Request_Record__c.COUNTY_1__c.getDescribe().getName(),
                        PRR_MAPPING_COUNTRY     => Property_Request_Record__c.COUNTRY__c.getDescribe().getName(),
                        PRR_MAPPING_LONGITUDE   => Property_Request_Record__c.GEO_LONGITUDE__c.getDescribe().getName(),
                        PRR_MAPPING_LATITUDE    => Property_Request_Record__c.GEO_LATITUDE__c.getDescribe().getName(),
                        PRR_MAPPING_NAME        => Property_Request_Record__c.Owner_Contact_Name__c.getDescribe().getName()
                    },//fix below
                    PROPERTY_REQUEST_RECORD_USER => new Map<String, String>{
                        PRR_MAPPING_ADDRESS     => Property_Request_Record__c.User_Property_Address__c.getDescribe().getName(),
                        PRR_MAPPING_CITY        => Property_Request_Record__c.User_Property_City__c.getDescribe().getName(),
                        PRR_MAPPING_STATE       => Property_Request_Record__c.User_Property_State__c.getDescribe().getName(),
                        PRR_MAPPING_ZIPCODE     => Property_Request_Record__c.User_Property_Zip_Code__c.getDescribe().getName(),
                        PRR_MAPPING_COUNTY      => Property_Request_Record__c.County__c.getDescribe().getName(),
                        PRR_MAPPING_COUNTRY     => Property_Request_Record__c.COUNTRY__c.getDescribe().getName(),
                        PRR_MAPPING_LATITUDE    => Property_Request_Record__c.User_Latitude__c.getDescribe().getName(),
                        PRR_MAPPING_LONGITUDE   => Property_Request_Record__c.User_Longitude__c.getDescribe().getName(),
                        PRR_MAPPING_FIRSTNAME   => Property_Request_Record__c.User_Contact_First_Name__c.getDescribe().getName(),
                        PRR_MAPPING_LASTNAME    => Property_Request_Record__c.User_Contact_Last_Name__c.getDescribe().getName()
                    },
                    PROPERTY_REQUEST_RECORD_CUSTOMER_SUCCESS => new Map<String, String>{
                        PRR_MAPPING_ADDRESS     => Property_Request_Record__c.CS_Location__c.getDescribe().getName(), //QFCJ-4554
                        PRR_MAPPING_CITY        => Property_Request_Record__c.CS_City__c.getDescribe().getName(), //QFCJ-4554
                        PRR_MAPPING_STATE       => Property_Request_Record__c.CS_State__c.getDescribe().getName(), //QFCJ-4554
                        PRR_MAPPING_ZIPCODE     => Property_Request_Record__c.CS_Zip__c.getDescribe().getName(), //QFCJ-4554
                        PRR_MAPPING_COUNTY      => Property_Request_Record__c.County__c.getDescribe().getName(),
                        PRR_MAPPING_COUNTRY     => Property_Request_Record__c.COUNTRY__c.getDescribe().getName(),
                        PRR_MAPPING_LATITUDE    => Property_Request_Record__c.User_Latitude__c.getDescribe().getName(),
                        PRR_MAPPING_LONGITUDE   => Property_Request_Record__c.User_Longitude__c.getDescribe().getName(),
                        PRR_MAPPING_NAME        => Property_Request_Record__c.CS_Property_Name__c.getDescribe().getName() //QFCJ-4554
                    }
                };
            }
            return propertyRequestDataSourceFieldMap;
        }
        set;
    }
}