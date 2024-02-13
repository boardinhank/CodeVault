/******************************************************************************
===================================================================================
Purpose: JS controller of validateAddressUsingGeoes.html
===================================================================================
History:

AUTHOR     DATE         Reference     Description
Navin M    31/01/2022   ESCJ-379      Initial draft
********************************************************************************/
import { LightningElement, track, api } from 'lwc';
// Import the getMatchingAddresses method of GeoesServiceAddressValidationCallout apex class
import getMatchingAddresses from '@salesforce/apex/GeoesServiceAddressValidationCallout.getMatchingAddresses';

// Columns to be dipslayed in the Matching Addresses Table
const columns = [
    { label: 'Address Matches', fieldName: 'addressMatches'},
    { label: 'Match Type', fieldName: 'matchType'},
];


export default class ValidateAddressUsingGeoes extends LightningElement {
    columns = columns;
    @track data = [];
    @track totalNumberOfRows = 0;
    @track showMatchingAddresses = false;
    // Address fields to be updated with values received from the parent component
    @track address = {
        Service_Street__c : "",
        Service_Street_2__c : "",
        Service_City__c : "",
        Service_State__c : "",
        Service_Country__c : "",
        Service_Postal_Code__c : "",
        Own_Or_Rent_Your_Primary_Residence__c : "",
        GeoAddressId : "",
        GeoSubAddressId : "",
        Service_Latitude__c: "",
        Service_Longitude__c: ""
    };

    // Getter for the Address field
    @api
    get addressDetails() {
        return this.address;
    }

    // Setter for the Address field
    set addressDetails(address) {
        this.address = address;
    }

    /**********************************************************************************************
    Purpose: To be called from the Manual Lead Creation component on the click of 'Validate Address'
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    @api
    handleValidateAddress(event) {
        // Unselect the previously selected address radio button
        this.selectedRows = [];
        // Get GeoAddressId
        const geoAddressId = this.address?.GeoAddressId;
        // Get Address info
        const addressInfoMap = {
            addressLine1: this.address?.Service_Street__c,
            locality: this.address?.Service_City__c,
            stateOrProvince: this.address?.Service_State__c,
            postCode: this.address?.Service_Postal_Code__c,
            //country: 'USA'
        };
        //Get Lat & Long Info
        const propLatitude = this.address.Service_Latitude__c;
        const propLongitude = this.address.Service_Longitude__c;

        // If GeoAddressId is not blank or null then proceed further
        if (geoAddressId != null && geoAddressId != '') {
            this.getMatchingAddressUsingGeoAddressId(geoAddressId, true);
        }
        // If Address info is not blank or null then proceed further
        else if(addressInfoMap.addressLine1!='' && addressInfoMap.locality!='' && addressInfoMap.stateOrProvince!='' && addressInfoMap.postCode!='') {
            this.getMatchingAddressUsingAddressInfo(addressInfoMap, true);
        }
        else if(propLatitude!=null && propLongitude!=null){
            console.log('LATLONGMAP###');
            console.log('ADDRMAP###'+JSON.stringify(propLatitude));
           this.getMatchingAddressUsingLatLong(propLatitude,propLongitude,true);
       }
    }

    /**********************************************************************************************
    Purpose: To handle the row selection when address is selected by clicking on radio button
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    handleRowAction(event) {
        // Get the details/properties of the row selected
        const selectedRows = event.detail.selectedRows;
        const row = selectedRows != null ? selectedRows[0] : null;
        // If the address selected is of type 'Near Match' then again make callout to get Latitude and Longitude info
        if (row?.matchType == 'Near Match') {
            const geoAddressId = row?.geoAddressId;
            const addressInfoMap = {
                addressLine1: row?.streetAddress,
                locality: row?.locality,
                stateOrProvince: row?.stateOrProvince,
                postCode: row?.postCode,
                //country: 'USA'
            };
            const propLatitude = this.address.Service_Latitude__c;
            const propLongitude = this.address.Service_Longitude__c;

            if (geoAddressId != null && geoAddressId != '') {
                this.getMatchingAddressUsingGeoAddressId(geoAddressId, false);
             } else if(addressInfoMap.addressLine1!='' && addressInfoMap.locality!='' && addressInfoMap.stateOrProvince!='' && addressInfoMap.postCode!='') {
            this.getMatchingAddressUsingAddressInfo(addressInfoMap, true);
            }        
            else if(propLatitude!=null && propLongitude!=null){
                console.log('LATLONGMAP###');
                console.log('ADDRMAP###'+JSON.stringify(propLatitude));
            this.getMatchingAddressUsingLatLong(propLatitude,propLongitude,true);
        }
        }
        // If the address selected is of type 'Exact Match' then return the address info back to parent component
        else {
            this.triggerSelectedAddressEvent(row);
        }
    }

    /**********************************************************************************************
    Purpose: To get matching addresses from apex using Geo Address Id
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    getMatchingAddressUsingGeoAddressId(geoAddressId, updateDataTable) {
        getMatchingAddresses({ geoAddressId : geoAddressId, addressInfoMap : null })
        .then((res) => {
            if (res?.isSuccess) {
                this.processResponse(res?.data, updateDataTable);
            } else {
                console.log('Apex Error GetMatchingAddressUsingGeoAddressId - ',res?.message);
            }
        })
        .catch((e) => {
            console.log('Error GetMatchingAddressUsingGeoAddressId - ',e.message);
        })
    }

    /**********************************************************************************************
    Purpose: To get matching addresses from apex using address details
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    getMatchingAddressUsingAddressInfo(addressInfoMap, updateDataTable) {
        getMatchingAddresses({ geoAddressId : null, addressInfoMap : addressInfoMap })
        .then((res) => {
            if (res.isSuccess) {
                this.processResponse(res?.data, updateDataTable);
            } else {
                console.log('Apex Error GetMatchingAddressUsingAddressInfo - ',res?.message);
            }
        })
        .catch((e) => {
            console.log('Error GetMatchingAddressUsingAddressInfo - ',e.message);
        })
    }

    /**********************************************************************************************
    Purpose: To get matching addresses from apex using Latitude & Longitude
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Naga                    QFCJ-2156      Initial draft
    ***********************************************************************************************/
    getMatchingAddressUsingLatLong(propLatitude,propLongitude, updateDataTable) {
        getMatchingAddresses({ geoAddressId : null, addressInfoMap : null, propLatitude : propLatitude,propLongitude : propLongitude })
        .then((res) => {
            if (res?.isSuccess) {
                this.processResponse(res?.data, updateDataTable);
            } else {
                console.log('Apex Error GetMatchingAddressUsingGeoAddressId - ',res?.message);
            }
        })
        .catch((e) => {
            console.log('Error GetMatchingAddressUsingGeoAddressId - ',e.message);
        })
    }


    /**********************************************************************************************
    Purpose: To process the response from the apex class
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    processResponse(responseData, updateDataTable) {
        if (updateDataTable) {
            this.data = this.getServiceAddressFromApexResponse(responseData);
            this.updateMatchingAddressesCount(responseData?.length);
            this.showMatchingAddressTable(true);
        } else {
            const addressInfo = this.getServiceAddressFromApexResponse(responseData);
            this.triggerSelectedAddressEvent(addressInfo[0]);
        }
    }

    /**********************************************************************************************
    Purpose: To get list of service addresses from the apex response wrapper
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    getServiceAddressFromApexResponse(apexResponseData) {
        let serviceAddresses = [];
        let idCount = 0;
        apexResponseData.forEach(serviceAddress => {
            serviceAddresses.push({
                id: "id"+idCount,
                addressMatches: serviceAddress.fullAddress,
                matchType: serviceAddress.matchType,
                streetAddress: serviceAddress.streetAddress,
                locality: serviceAddress.locality,
                stateOrProvince: serviceAddress.stateOrProvince,
                postCode: serviceAddress.postCode,
                longitudeCoordinate: serviceAddress.longitudeCoordinate,
                latitudeCoordinate: serviceAddress.latitudeCoordinate,
                geoAddressId: serviceAddress.geoAddressId
            });
            idCount ++;
        });
        return serviceAddresses;
    }

    /**********************************************************************************************
    Purpose: To display the matching addresses table
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    showMatchingAddressTable(showTable) {
        this.showMatchingAddresses = showTable;
    }

    /**********************************************************************************************
    Purpose: To update the count of total no. of matching addresses in the table
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    updateMatchingAddressesCount(count) {
        this.totalNumberOfRows = count;
    }

    /**********************************************************************************************
    Purpose: To trigger the custom event for passing the address data to parent manual lead creation
             component
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    triggerSelectedAddressEvent(selectedaddress) {
        this.dispatchEvent(
            new CustomEvent('selectaddress', {
                detail: {
                    selectedaddress: Object.assign({}, selectedaddress)
                }
            })
        );
    }
}