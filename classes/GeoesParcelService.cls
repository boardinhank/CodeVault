public class GeoesParcelService implements Queueable, Database.AllowsCallouts {
    public Map<Id, AddressValidationWrapper> addressValidationWrapperMap;
    private List<Property_Request_Record__c> prrs;
    private Boolean disableDml = false;
    public Set<Id> prrIds;
    public List<String> remainingCallouts;
    public static final String PREFIX = '';

    private Map<Id, Property_Request_Record__c> prrsToUpdate {
        get {
            if(prrsToUpdate == null) {
                prrsToUpdate = new Map<Id, Property_Request_Record__c>();
            }
            return prrsToUpdate;
        }
        set;
    }

    public static List<String> SKIP_GEOES_SOURCES {
        get {
            if(SKIP_GEOES_SOURCES == null) {
                SKIP_GEOES_SOURCES = new List<String>{
                    //GeoesConstants.PROPERTY_REQUEST_RECORD_USER,//commented by Pooja for ESCJ-1975 bug fix
                    GeoesConstants.PROPERTY_REQUEST_RECORD_CUSTOMER_SUCCESS
                };
            }
            return SKIP_GEOES_SOURCES;
        }
        set;
    }

    public static List<String> VALID_INVENTORY_SOURCES {
        get {
            if(VALID_INVENTORY_SOURCES == null) {
                VALID_INVENTORY_SOURCES = new List<String>{
                    GeoesConstants.INVENTORY_SOURCE_LFACS,
                    GeoesConstants.INVENTORY_SOURCE_MARTENS,
                    GeoesConstants.INVENTORY_SOURCE_CLC, // Added by Sravya (for US-ESCJ-1367)
                    GeoesConstants.INVENTORY_SOURCE_QUANTUM_FIBER_O2
                };
            }
            return VALID_INVENTORY_SOURCES;
        }
        set;
    }

    private static List<String> VALID_OWNER_NAME_SOURCES {
        get {
            if(VALID_OWNER_NAME_SOURCES == null) { 
                VALID_OWNER_NAME_SOURCES = new List<String>{
                    GeoesConstants.PROPERTY_REQUEST_RECORD_DODGE,
                    GeoesConstants.PROPERTY_REQUEST_RECORD_CUSTOMER_SUCCESS
                };
            }
            return VALID_OWNER_NAME_SOURCES;
        }
        set;
    }
    
    public GeoesParcelService(
        Set<Id> prrIds
    ) {
        this.prrIds = prrIds;
    }
    public GeoesParcelService(
        List<Property_Request_Record__c> prrs
    ) {
        this.prrs = prrs;
    }
    
    public GeoesParcelService(
        Set<Id> prrIds,
        Boolean disableDml
    ) {
        this.prrIds = prrIds;
        this.disableDml = disableDml;
    }
    
    public GeoesParcelService(
        List<Property_Request_Record__c> prrs,
        Boolean disableDml
    ) {
        this.prrs = prrs;
        this.disableDml = disableDml;
    }

    public void execute(QueueableContext context) { 
        this.execute();
    }

    public Map<Id, AddressValidationWrapper> execute() {        
        this.loadData();
        for(AddressValidationWrapper wrapper : addressValidationWrapperMap.values()) {
            if(!SKIP_GEOES_SOURCES.contains(wrapper.dataSource)) {
                wrapper.buildGeoesValidationPayload()
                .geoesValidationCallout();
            }

            wrapper.parseGeoesValidationCallout()
            .uniqualbyLatLongcallout()
            .parseUniqualbyLatLongcallout()
            .uniqualbyAddressCallout()
            .parseUniqualbyAddressCallout();

            if(!SKIP_GEOES_SOURCES.contains(wrapper.dataSource)) {
                wrapper.uniqualbyGeoLatLongcallout()
                .parseUniqualbyGeoLatLongcallout();
            }
        }
        this.processRequestRecords();
        return this.addressValidationWrapperMap;
    }

    private void processRequestRecords() {        
        for(Id prrId : addressValidationWrapperMap.keySet()) {
            AddressValidationWrapper wrapper = addressValidationWrapperMap.get(prrId);
            wrapper.buildForDml();
        }
    }

    public void commitChanges() {
        ApiTransactionService allApiTransactionsServiceManager = new ApiTransactionService(true);
        allApiTransactionsServiceManager.apiTransactions = this.getApiTransactions();
        allApiTransactionsServiceManager.save();
        if(this.disableDml) {
            return;
        }
        update prrsToUpdate.values();
    }
    
    private void loadData() {
        if(this.addressValidationWrapperMap != null) {
            return;
        }
        this.addressValidationWrapperMap = new Map<Id, AddressValidationWrapper>();
        if(this.prrs == null) {
            this.prrs = [
                SELECT
                    Name, 
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
                    COUNTY_1__c,
                    CS_Location__c, //QFCJ-4554
                    CS_City__c, //QFCJ-4554
                    CS_State__c, //QFCJ-4554
                    CS_Zip__c, //QFCJ-4554
                    CS_Property_Name__c //QFCJ-4554
                FROM Property_Request_Record__c
                WHERE Id IN :this.prrIds
                    AND Data_Source__c IN :GeoesConstants.VALID_DATA_SOURCES
            ];
        }
        for(Property_Request_Record__c prr : prrs) {
            if(!GeoesConstants.VALID_DATA_SOURCES.contains(prr.Data_Source__c)) {
                continue;
            }
            addressValidationWrapperMap.put(
                prr.Id,
                new AddressValidationWrapper(
                    prr              
                )
            );
        }
    }

    private List<API_Transaction__c> getApiTransactions() {
        List<API_Transaction__c> apiTransactions = new List<API_Transaction__c>(); 
        for(AddressValidationWrapper wrapper : this.addressValidationWrapperMap.values()) {
            apiTransactions.addAll(
                wrapper.apiTransactionServiceManager.apiTransactions
            );
        }
        return apiTransactions;
    }

    public class AddressValidationWrapper {
        public Property_Request_Record__c propertyRequestRecord;
        public Decimal geoesLatitude;
        public Decimal geoesLongitude;
        public Boolean geoesMatchFound = false;
        public Boolean uniqualLatLongMatchFound = false;
        public Boolean uniqualAddressMatchFound = false;
        public Boolean uniqualGeoLatLongMatchFound = false;
        public String apn;
        public String stateCode;
        public String countyCode;
        public Property__c property;
        GeoesServiceAddressValidationCallout.GeoesServiceResponse geosServiceValidationResponse;
        UniqualParcelServiceResponseWrap uniqualServiceLatLongResponse;
        UniqualParcelServiceResponseWrap uniqualServiceAddress;
        UniqualParcelServiceResponseWrap uniqualServiceGeoLatLongResponse;
        Map<String, String> geosServiceValidationPayload;
        Map<String, String> geoesServiceLatLongValidationPayload;

        public UniqualParcelServiceResponseWrap parcelWrapper {
            get {
                if(this.uniqualServiceLatLongResponse != null
                    && this.uniqualServiceLatLongResponse.parcels != null
                    && !this.uniqualServiceLatLongResponse.parcels.isEmpty()
                ) {
                    return this.uniqualServiceLatLongResponse;
                }
                else if(this.uniqualServiceAddress != null
                    && this.uniqualServiceAddress.parcels != null
                    && !this.uniqualServiceAddress.parcels.isEmpty()
                ) {
                    return this.uniqualServiceAddress;
                }
                else if(this.uniqualServiceGeoLatLongResponse != null
                    && this.uniqualServiceGeoLatLongResponse.parcels != null
                    && !this.uniqualServiceGeoLatLongResponse.parcels.isEmpty()
                ) {
                    return this.uniqualServiceGeoLatLongResponse;
                }
                return null;
            }
            set;
        }

        public String contactName {
            get {
                if(VALID_OWNER_NAME_SOURCES.contains(this.dataSource)) {
                    if(!String.isEmpty(this.contactOwnerName)) {
                        return this.contactOwnerName;
                    }
                } else {
                    return String.format(
                        '{0} {1}',
                        new List<String>{
                            this.contactFirstName,
                            this.contactLastName
                        }
                    );
                }
                return null;
            }
            set;
        }

        public String contactFirstName {
            get {
                if(!VALID_OWNER_NAME_SOURCES.contains(this.dataSource)) {
                    return String.valueOf(
                        this.propertyRequestRecord.get(
                            this.dataSourceFieldMapping.get(
                                GeoesConstants.PRR_MAPPING_FIRSTNAME
                            )
                        )
                    );
                } else {
                    if(!String.isEmpty(this.contactOwnerName)) {
                        return this.contactOwnerName.split(' ')[0];
                    }
                }
                return null;
            }
            set;
        }
        public String contactLastName {
            get {
                if(!VALID_OWNER_NAME_SOURCES.contains(this.dataSource)) {
                    return String.valueOf(
                        this.propertyRequestRecord.get(
                            this.dataSourceFieldMapping.get(
                                GeoesConstants.PRR_MAPPING_LASTNAME
                            )
                        )
                    );
                } else {
                    if(!String.isEmpty(this.contactOwnerName)) {
                        List<String> contactOwnerNameSplit = this.contactOwnerName.split(' ');
                        if(contactOwnerNameSplit.size() > 1) {
                            return contactOwnerName.split(' ')[1];
                        }
                    }
                }
                return null;
            }
            set;
        }
        String contactOwnerName {
            get {
                if(!VALID_OWNER_NAME_SOURCES.contains(this.dataSource)) {
                    return null;
                }
                return String.valueOf(
                    this.propertyRequestRecord.get(
                        this.dataSourceFieldMapping.get(
                            GeoesConstants.PRR_MAPPING_NAME
                        )
                    )
                );
            }
            set;
        }
        public String subdivisionName {
            get{
                if(this.parcelWrapper == null || this.parcelWrapper.parcels == null || this.parcelWrapper.parcels.size() == 0) {
                    return null;
                }
                return this.parcelWrapper.parcels.get(0).subdivisionName;
            }
            set;
        }
        public String parcelLongitude {
            get{
                if(this.parcelWrapper == null || this.parcelWrapper.parcels == null || this.parcelWrapper.parcels.size() == 0) {
                    return null;
                }
                return this.parcelWrapper.parcels.get(0).longitude;
            }
            set;
        }
        public String parcelLatitude {
            get{
                if(this.parcelWrapper == null || this.parcelWrapper.parcels == null || this.parcelWrapper.parcels.size() == 0) {
                    return null;
                }
                return this.parcelWrapper.parcels.get(0).latitude;
            }
            set;
        }

        public String dataSource {
            get {
                return this.propertyRequestRecord.Data_Source__c;
            }
            set;
        }
        Map<String, String> dataSourceFieldMapping {
            get {
                return GeoesConstants.propertyRequestDataSourceFieldMap.get(
                    this.dataSource
                );
            }
            set;
        }
        public String address {
            get {
                return String.valueOf(
                    this.propertyRequestRecord.get(
                        this.dataSourceFieldMapping.get(
                            GeoesConstants.PRR_MAPPING_ADDRESS
                        )
                    )
                );
            }
            set;
        }
        public String city {
            get {
                return String.valueOf(
                    this.propertyRequestRecord.get(
                        this.dataSourceFieldMapping.get(
                            GeoesConstants.PRR_MAPPING_CITY
                        )
                    )
                );
            }
            set;
        }
        public String state {
            get {
                return String.valueOf(
                    this.propertyRequestRecord.get(
                        this.dataSourceFieldMapping.get(
                            GeoesConstants.PRR_MAPPING_STATE
                        )
                    )
                );
            }
            set;
        }
        public String zipCode {
            get {
                return String.valueOf(
                    this.propertyRequestRecord.get(
                        this.dataSourceFieldMapping.get(
                            GeoesConstants.PRR_MAPPING_ZIPCODE
                        )
                    )
                );
            }
            set;
        }
        public String county {
            get {
                return String.valueOf(
                    this.propertyRequestRecord.get(
                        this.dataSourceFieldMapping.get(
                            GeoesConstants.PRR_MAPPING_COUNTY
                        )
                    )
                );
            }
            set;
        }
        public String country {
            get {
                return String.valueOf(
                    this.propertyRequestRecord.get(
                        this.dataSourceFieldMapping.get(
                            GeoesConstants.PRR_MAPPING_COUNTRY
                        )
                    )
                );
            }
            set;
        }
        public Decimal latitude {
            get {
                return (Decimal)this.propertyRequestRecord.get(
                    this.dataSourceFieldMapping.get(
                        GeoesConstants.PRR_MAPPING_LATITUDE
                    )
                );
            }
            set;
        }

        public String latitudeStr {
            get {
                return String.valueOf(
                    this.latitude
                );
            }
            set;
        }
        public Decimal longitude {
            get {
                return (Decimal)this.propertyRequestRecord.get(
                    this.dataSourceFieldMapping.get(
                        GeoesConstants.PRR_MAPPING_LONGITUDE
                    )
                );
            }
            set;
        }
        public String longitudeStr {
            get {
                return String.valueOf(
                    this.longitude
                );
            }
            set;
        }
        public String uniqueId {
            get {
                return getUniquePropertyKey(
                    this.countyCode,
                    this.apn,
                    this.stateCode
                );
            }
            set;
        }
        public APITransactionService apiTransactionServiceManager {
            get {
                if(apiTransactionServiceManager == null) {
                    apiTransactionServiceManager = new ApiTransactionService(true);
                }
                return apiTransactionServiceManager;
            }
            set;
        }
        public Boolean isSuccessfulTransaction {
            get {
                if(apiTransactionServiceManager.apiTransactions.isEmpty()) {
                    return false;
                }
                for(API_Transaction__c apiTransaction : apiTransactionServiceManager.apiTransactions) {
                    if(apiTransaction.API_Status_Code__c == GeoesConstants.HTTP_SUCCESS_STATUS_CODE
                        ||apiTransaction.API_Status_Code__c == GeoesConstants.HTTP_BAD_REQUEST_STATUS_CODE
                    ) {
                        continue;
                    }
                    return false;
                }
                return true;
            }
            set;
        }
        public AddressValidationWrapper(
            Property_Request_Record__c propertyRequestRecord
        ) {
            this.propertyRequestRecord = propertyRequestRecord;
        }

        AddressValidationWrapper buildGeoesValidationPayload() {
            this.geosServiceValidationPayload = new Map<String, String>{
                GeoesConstants.ADDRESSLINE1_FIELDNAME      => this.address,
                GeoesConstants.LOCALITY_FIELDNAME          => this.city,
                GeoesConstants.STATEORPROVINCE_FIELDNAME   => this.state,
                GeoesConstants.POSTCODE_FIELDNAME          => this.zipCode,
                GeoesConstants.COUNTY_FIELDNAME            => this.county,
                GeoesConstants.COUNTRY_FIELDNAME           => this.country
            };
            return this;
        }
        
        AddressValidationWrapper geoesValidationCallout() {
            GeoesServiceAddressValidationCallout.apiTransactionServiceManager = apiTransactionServiceManager;
            this.geosServiceValidationResponse = GeoesServiceAddressValidationCallout.getMatchingAddresses(
                null,
                this.geosServiceValidationPayload,null,null,
                this.propertyRequestRecord.Transaction_Summary__c
            );
            return this;
        }
        
        AddressValidationWrapper parseGeoesValidationCallout() {
            if(this.geosServiceValidationResponse == null) {
                return this;
            }
            List<GeoesServiceAddressValidationCallout.ServiceAddress> addresses = (List<GeoesServiceAddressValidationCallout.ServiceAddress>)this.geosServiceValidationResponse.data;
            if(addresses == null) {
                return this;
            }
            for(GeoesServiceAddressValidationCallout.ServiceAddress serviceAddress : addresses) {
                if(serviceAddress.matchType != GeoesConstants.EXACT_MATCHTYPE) {
                    continue;
                }
                this.geoesMatchFound = true;
                this.geoesLatitude = serviceAddress.latitudeCoordinate;
                this.geoesLongitude = serviceAddress.longitudeCoordinate;
                break;
            }
            return this;
        }

        AddressValidationWrapper uniqualbyLatLongcallout() {
            UniqualParcelServiceCallout.apiTransactionServiceManager = apiTransactionServiceManager;
            this.uniqualServiceLatLongResponse = new UniqualParcelServiceCallout(
                this.latitudeStr,
                this.longitudeStr,
                this.propertyRequestRecord.Transaction_Summary__c
            ).getPropertyInfo();

            return this;
        }
        
        AddressValidationWrapper parseUniqualbyLatLongcallout() {
            if(this.uniqualServiceLatLongResponse == null 
                || this.uniqualServiceLatLongResponse.totalParcels == null 
                || this.uniqualServiceLatLongResponse.totalParcels == 0
            ) {
                return this;
            }
            UniqualParcelServiceResponseWrap.Parcels parcel = this.uniqualServiceLatLongResponse.parcels.get(0);
            this.apn = parcel.apn;
            this.stateCode = parcel.stateCode;
            this.countyCode = parcel.countyCode;
            this.uniqualLatLongMatchFound = true;
            return this;
        }
        
        AddressValidationWrapper uniqualbyAddressCallout() {
            String dataSource = this.propertyRequestRecord.Data_Source__c;
            UniqualParcelServiceCallout.apiTransactionServiceManager = apiTransactionServiceManager;
            if(!this.uniqualLatLongMatchFound) {
                if(!String.isBlank(this.address) && !String.isBlank(this.city) && !String.isBlank(this.state)) {
                this.uniqualServiceAddress = new UniqualParcelServiceCallout(
                    String.format(
                        '{0} {1} {2}',
                        new List<String>{
                            this.address,
                            this.city,
                            this.state
                        }
                    ),
                    this.propertyRequestRecord.Transaction_Summary__c
                ).getPropertyInfo();
                }
            }
            return this;
        }

        AddressValidationWrapper parseUniqualbyAddressCallout() {
            if(this.uniqualServiceAddress == null 
                || this.uniqualServiceAddress.totalParcels == null 
                || this.uniqualServiceAddress.totalParcels == 0
            ) {
                return this;
            }
            UniqualParcelServiceResponseWrap.Parcels parcel = this.uniqualServiceAddress.parcels.get(0);
            this.apn = parcel.apn;
            this.stateCode = parcel.stateCode;
            this.countyCode = parcel.countyCode;
            this.uniqualAddressMatchFound = true;
            return this;
        }

        AddressValidationWrapper uniqualbyGeoLatLongcallout() {
            if(!this.uniqualAddressMatchFound && !this.uniqualLatLongMatchFound) {
                UniqualParcelServiceCallout.apiTransactionServiceManager = apiTransactionServiceManager;
                this.uniqualServiceGeoLatLongResponse = new UniqualParcelServiceCallout(
                    String.valueOf(this.geoesLatitude),
                    String.valueOf(this.geoesLongitude),
                    this.propertyRequestRecord.Transaction_Summary__c
                ).getPropertyInfo();
            }
            return this;
        }

        AddressValidationWrapper parseUniqualbyGeoLatLongcallout() {
            if(this.uniqualServiceGeoLatLongResponse == null 
                || this.uniqualServiceGeoLatLongResponse.totalParcels == null 
                || this.uniqualServiceGeoLatLongResponse.totalParcels == 0
            ) {
                return this;
            }
            UniqualParcelServiceResponseWrap.Parcels parcel = this.uniqualServiceGeoLatLongResponse.parcels.get(0);
            this.apn = parcel.apn;
            this.stateCode = parcel.stateCode;
            this.countyCode = parcel.countyCode;
            this.uniqualGeoLatLongMatchFound = true;
            return this;
        }

        AddressValidationWrapper buildForDml() {
            if(!this.isSuccessfulTransaction) {
                return this;
            }
            if(this.geosServiceValidationResponse != null) {
                GeoesServiceAddressValidationWrapper geoValidationWrapper = this.geosServiceValidationResponse.wrapper;
                if(geoValidationWrapper != null) {
                    this.propertyRequestRecord.GEOES_results__c = geoValidationWrapper.result;
                    // Added by Sravya (for US-ESCJ-1367)
                     if(this.propertyRequestRecord.GEOES_results__c=='Red'){
                                this.propertyRequestRecord.Development_Status__c = GeoesConstants.GREENFIELD;
                            } // Added by Sravya (for US-ESCJ-1367)
                    List<GeoesServiceAddressValidationCallout.ServiceAddress> serviceAddresses = (List<GeoesServiceAddressValidationCallout.ServiceAddress>)this.geosServiceValidationResponse.data;
                
                    if(serviceAddresses != null) {
                        for(GeoesServiceAddressValidationCallout.ServiceAddress match : serviceAddresses) {
                            if(match.matchType != GeoesConstants.EXACT_MATCHTYPE) {
                                continue;
                            }
                            this.propertyRequestRecord.GEOES_Inventory_Source__c = match.source;
                            this.propertyRequestRecord.GEOES_Legacy_Provider__c = match.legacyProvider;
                            if(VALID_INVENTORY_SOURCES.contains(match.source)) {
                                this.propertyRequestRecord.Development_Status__c = GeoesConstants.BROWNFIELD;
                            } else {
                                this.propertyRequestRecord.Development_Status__c = GeoesConstants.GREENFIELD;
                            }
                           
                            this.propertyRequestRecord.GEOES_Latitude_Coordinate__c = this.geoesLatitude;
                            this.propertyRequestRecord.GEOES_Longitude_Coordinate__c = this.geoesLongitude;
                            break;
                        }
                    }
                }
            }
            return this;
        }

        public Contact buildContact() {
            if(this.contactFirstName == null
                || this.contactLastName == null
            ) {
                return null;
            }
            return new Contact(
                FirstName = this.contactFirstName,
                LastName = this.contactLastName
            );
        }

        public Boolean hasParcels() {
            return !(this.parcelWrapper == null 
                || this.parcelWrapper.parcels == null 
                || this.parcelWrapper.parcels.size() == 0);
        }
    }

    public static String getUniquePropertyKey(
        String countyCode, 
        String apn, 
        String stateCode
    ) {
        return String.format(
            '{0}{1}{2}{3}',
            new List<String>{
                PREFIX,
                countyCode,
                apn,
                stateCode
            }
        );
    }

    // public static void tEST_PRR(
    //     List<Property_Request_Record__c> prrs
    // ) {
    //     for(Property_Request_Record__c prr : prrs) {
    //         prr.isProcessed__c = false;
    //         prr.Match_Found_In_System__c = GeoesConstants.DUPLICATE_PROPERTY_FOUND_PRR_NO;
    //         prr.Duplicate_Property_Found__c = GeoesConstants.MATCH_SYSTEM_FOUND_PRR_NO;
    //         prr.Existing_Property_found_in_SF_with_PRR__c = null;
    //         prr.New_Property_Created__c = null;
    //         prr.GEOES_results__c = null;
    //     }
    // }

    // public static String getUniquePropertyKeyFromProperty(Property__c p) {
    //     return getUniquePropertyKey(
    //         p.County_Code__c,
    //         p.APN__c,
    //         p.State_Code__c
    //     );
    // }

    public virtual class GeoesParcelServiceException extends Exception { }
}