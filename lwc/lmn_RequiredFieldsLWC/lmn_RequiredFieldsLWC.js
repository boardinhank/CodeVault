import {LightningElement, api} from 'lwc';
import getRequiredFields from '@salesforce/apex/lmn_CDRequiredFieldsController.getRequiredFields';
export default class Lmn_RequiredFieldsLWC extends LightningElement {

    requiredFields
    refreshHandlerID

    @api recordId;
    connectedCallback(){
        this.queryFields()
    }

    queryFields(){
        getRequiredFields({"recId" : this.recordId}).then(response=>{
                this.requiredFields = response
            }).catch(error=>{
                console.error(error)
            })
        }

    }