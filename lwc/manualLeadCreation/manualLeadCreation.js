import { LightningElement, track, api, wire} from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import geoamservercall from "@salesforce/apex/AddressCheckUsingGEOAM.geoamservercall";
import callLeadPE from "@salesforce/apex/SyncLeadPEHandler.dontEersCheck";
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class ManualLeadCreation extends NavigationMixin (LightningElement) {
    @track isModalOpen = true;

    @track enteredAddress = "";
    @track returnedAddresses = [];
    @track addresValue = "";
    @track isRender = true;
    @track geoAddressId;
    @track showAddress;
    @track mdu;
    @track fields = {
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
    @track address = {};
    @track isSpinner = false;
    @track mapselectAddress = {};
    @track selectedAddress = {};

    @track accountId = "";
    @track customlead = true;
    @track propertyAddressValidated = false;
    @track disableBtn = false;

    handlePropertyAddresssection(event){
        console.log('Entry###');
        const extProperty = event.target.value;
        console.log(JSON.stringify(extProperty));
        let propName = this.template.querySelector("[data-id='propName']");
        let propStreet = this.template.querySelector("[data-id='propStreet']");
        let propCity = this.template.querySelector("[data-id='propCity']");
        let propState = this.template.querySelector("[data-id='propState']");
        let propZip = this.template.querySelector("[data-id='propZip']");
        let propLat = this.template.querySelector("[data-id='propLat']");
        let propLong = this.template.querySelector("[data-id='propLong']");
        let propMsg = this.template.querySelector("[data-id='propMsg']");
        let propLTU = this.template.querySelector("[data-id='propLTU']");
        let propFOD = this.template.querySelector("[data-id='propFOD']");
        let propCSD = this.template.querySelector("[data-id='propCSD']");
        let propCCD = this.template.querySelector("[data-id='propCCD']");
        let propType = this.template.querySelector("[data-id='propType']");
        let propstructure = this.template.querySelector("[data-id='propstructure']");
        let propStatus = this.template.querySelector("[data-id='propStatus']");
        let addressInput = this.template.querySelector("[data-id='addressInput']");
        let propuse = this.template.querySelector("[data-id='propuse']");
       
        if(extProperty!=null){
            propName.disabled = true;
            propStreet.disabled=true;
            propCity.disabled = true;
            propState.disabled = true;
            propZip.disabled = true;
            propLat.disabled = true;
            propLong.disabled = true;
            propMsg.disabled = true;
            propLTU.disabled = true;
            propFOD.disabled = true;
            propCSD.disabled = true;
            propCCD.disabled = true;
            propType.disabled = true;
            propstructure.disabled = true;
            propStatus.disabled = true;
            addressInput.disabled= true;
            propuse.disabled= true;
           
            addressInput.reset();
            propName.reset();
            propStreet.reset();
            propCity.reset();
            propState.reset();
            propZip.reset();
            propLat.reset();
            propMsg.reset();
            propLTU.reset();
            propFOD.reset();
            propCSD.reset();
            propCCD.reset();
            propType.reset();
            propstructure.reset();
            propStatus.reset();
            propuse.reset();
        }
        if(extProperty==''){
            propName.disabled = false;
            propStreet.disabled=false;
            propCity.disabled = false;
            propState.disabled = false;
            propZip.disabled = false;
            propLat.disabled = false;
            propLong.disabled = false;
            propMsg.disabled = false;
            propLTU.disabled = false;
            propFOD.disabled = false;
            propCSD.disabled = false;
            propCCD.disabled = false;
            propType.disabled = false;
            propstructure.disabled = false;
            propStatus.disabled = false;
            addressInput.disabled= false;
            propuse.disabled= false;
            
        }
    }

    handleAccountChange(event) {
        console.log('Value - ',event.target.value);
        this.accountId = event.target.value;
        console.log('accountId - ',this.accountId);
    }

    @wire(getRecord, { recordId: '$accountId', fields: [NAME_FIELD]})
    account;

    get companyName() {
        console.log('inside get companyname ');
        return getFieldValue(this.account.data, NAME_FIELD);
    }

    /*************Begin of ESCJ-379+:Navin M on 31/01/2022*****************/
    // Getter and setter of 'fields'
    @api
    get addressDetails() {
        return this.fields;
    }

    set addressDetails(address) {
        this.fields = address;
    }
    /*************End of ESCJ-379+:Navin M on 31/01/2022*****************/

    closeModal() {
        this.isModalOpen = false;
        this.dispatchCloseEvent();
    }

     dispatchCloseEvent(){
         console.log(" dispatchCloseEvent called ");
        var close = true;
        const closeclickedevt = new CustomEvent('closeclicked', {
                detail: { close },
        });
            // Fire the custom event
        this.dispatchEvent(closeclickedevt);
     }

    /**********************************************************************************************
    Purpose: To handle onclick event of 'Validate Address' button
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Deepak K   NA           ESCJ-373      Initial draft
    Navin M    31/01/22     ESCJ-379      1. Made the Propery Latitude and longitude field blank on click
                                          2. Called handleValidateAddress method of
                                          validateAddressUsingGeoes component
    ***********************************************************************************************/
    valProAddress() {
    /*this.fields.Service_Latitude__c = "";
    this.fields.Service_Longitude__c = "";
    this.template.querySelector('c-validate-address-using-geoes').handleValidateAddress();*/
        console.log('Entry@@@'+JSON.stringify(this.fields.Service_Latitude__c));
        if(this.fields.Service_Street__c!='' && this.fields.Service_City__c!='' && this.fields.Service_State__c!='' && this.fields.Service_Postal_Code__c!=''){
            console.log('Entry1@@@');
            this.propertyAddressValidated = false;
            this.fields.Service_Latitude__c = "";
            this.fields.Service_Longitude__c = "";
            this.template.querySelector('c-validate-address-using-geoes').handleValidateAddress();
        }else if((this.fields.Service_Latitude__c!='' && this.fields.Service_Longitude__c!='') && (this.fields.Service_Street__c=='' || this.fields.Service_City__c=='' || this.fields.Service_State__c=='' || this.fields.Service_Postal_Code__c=='')){
            console.log('Entry2@@@');
            this.propertyAddressValidated = false;
            this.template.querySelector('c-validate-address-using-geoes').handleValidateAddress();
        }

    }

    /**********************************************************************************************
    Purpose: To handle the custom 'onselectaddress' event triggered from the child
             validateAddressUsingGeoes component and update the address values with the data received
             from child component
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    handleChangeSelectedAddress(event) {
        const selectedAddress = event.detail.selectedaddress;
        this.fields.Service_Street__c = selectedAddress?.streetAddress;
        this.fields.Service_City__c = selectedAddress?.locality;
        this.fields.GeoAddressId = selectedAddress?.geoAddressId;
        this.fields.Service_State__c = selectedAddress?.stateOrProvince;
        this.fields.Service_Postal_Code__c = selectedAddress?.postCode;
        this.fields.Service_Latitude__c = selectedAddress?.latitudeCoordinate;
        this.fields.Service_Longitude__c = selectedAddress?.longitudeCoordinate;
        //this.addresValue = selectedAddress?.addressMatches;
        this.propertyAddressValidated = true;
    }

    /**********************************************************************************************
    Purpose: To handle the onchange event on the property address fields
    ===============================================================================================
    History:
    AUTHOR     DATE         Reference     Description
    Navin M    31/01/2022   ESCJ-379      Initial draft
    ***********************************************************************************************/
    handlePropertyAddressChange(event) {
        if (event.target.fieldName == 'Property_Address_Street__c') {
                this.fields.Service_Street__c = event.target.value;
        } else if (event.target.fieldName == 'Property_Address_City__c') {
                this.fields.Service_City__c = event.target.value;
        } else if (event.target.fieldName == 'Property_Address_State__c') {
                this.fields.Service_State__c = event.target.value;
        } else if (event.target.fieldName == 'Property_Address_Zip__c') {
                this.fields.Service_Postal_Code__c = event.target.value;
        } else if (event.target.fieldName == 'Property_Latitude__c') {
                this.fields.Service_Latitude__c = event.target.value;
        } else if (event.target.fieldName == 'Property_Longitude__c') {
                this.fields.Service_Longitude__c = event.target.value;
        }
        this.fields.GeoAddressId = "";
        /*this.propertyAddressValidated = false;
        this.fields.Service_Latitude__c = "";
        this.fields.Service_Longitude__c = "";*/
    }

    handleSuccess(event){
		 callLeadPE({checkconst:'inserting',leadId:event.detail.id}).then(response => {
            console.log('testing'+response);
        });
        
        var creditnoteId = event.detail.id;
        console.log(" save was usccessfull ");
        this.dispatchEvent(new CloseActionScreenEvent());
        const evt = new ShowToastEvent({
            title: 'Success!',
            message: 'Lead was created!',
            variant: 'success'
        });
        this.dispatchEvent(evt);
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                    recordId:creditnoteId,
                    objectApiName:'Lead',
                    actionName:'view'
            }
        });
        console.log("-------- clearing the fields--------");
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        //this.dispatchCloseEvent();
    }

    handleSubmit(event){
        event.preventDefault();
        return;
    }
    handleOnClick(event){
        this.disableBtn = true;
        event.preventDefault();
        const myfield = event.detail.fields;
        this.template.querySelector('lightning-record-edit-form').submit(myfield);
    }
    handleError(){
        const evt = new ShowToastEvent({
            title: 'Error!',
            message: 'There was an issue in saving the record!',
            variant: 'error'
        });
        this.disableBtn = false;
        this.dispatchEvent(evt);
    }

    hoverAttribute(event) {
        event.target.style = "background-color: #e9e9e9; cursor: pointer;";
    }

    hoverAttributeOver(event) {
        event.target.style = "background-color:#E0FFFF;font-weight:bold;";
    }

    pickSelectedAddressInfo(event) {
        console.log(event.target);
        this.addresValue = event.target.value;
        this.template.querySelector('[data-id="addressInput"]').value =
        event.target.value;
        this.mdu = event.target.dataset.mdu;
        this.isRender = false;
        for (var address of this.returnedAddresses) {
            if (this.addresValue === address.fullAddress) {
                this.fields = address.fields;
                this.geoAddressId = address.id;
                this.addresValue = address.fullAddress;
                /*this.propertyAddressValidated = false;
                this.fields.Service_Latitude__c = "";
                this.fields.Service_Longitude__c = "";*/
            }
        }
    }

    reteriveAddressFromGeoAM(event) {
        const value = event.target.value;
        this.isRender = true;
        this.returnedAddresses = [];
        this.mapselectAddress = {};
        this.geoAddressId = "";
        this.fields.GeoAddressId = "";
        if (event.target.value && event.target.value.length >= 4) {
            this.enteredAddress = event.target.value;
            geoamservercall({searchStr:event.target.value}).then(response => {
                console.log('@@AUTOCOMPLETE RESP GEOAM=> ' + response);
                if (response!=null) {
                    this.returnedAddresses = [];
                    let resp = JSON.parse(response);
                    //Currently am just looking at full address
                    let prevAddr = [];
                    for (var address of resp.responseData.addresses) {
                        //Return an array of addresses to HTML, where I parse at bottom
                        console.log(address);
                        const trimmedValue = address.fullAddress.trim();
                        if (prevAddr.includes(trimmedValue)) continue;
                        prevAddr.push(trimmedValue);
                        const addrSegments = trimmedValue
                            .replace(/\s*,\s*/g, ",")
                            .split(",");
                        if (addrSegments.length < 4) {
                            continue;
                        }
                        const hasMDU = addrSegments.length === 4;
                        const stateAndZip = addrSegments[hasMDU ? 2 : 3].split(" ");
                        address.fields = {
                            Service_Street__c: addrSegments[0],
                            Service_Street_2__c: hasMDU ? "" : addrSegments[1],
                            Service_City__c: addrSegments[hasMDU ? 1 : 2],
                            Service_State__c: stateAndZip[0],
                            Service_Country__c: addrSegments[hasMDU ? 3 : 4],
                            Service_Postal_Code__c: stateAndZip[1],
                            Own_Or_Rent_Your_Primary_Residence__c: this.homeType,
                            GeoAddressId: address.id,
                            GeoSubAddressId: ""
                        };
                        this.returnedAddresses = [...this.returnedAddresses, address];
                    }
                }
            });
        }
    }
}