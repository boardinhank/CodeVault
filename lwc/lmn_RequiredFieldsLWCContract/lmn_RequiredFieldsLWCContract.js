import {LightningElement, api} from 'lwc';
import getRequiredFields from '@salesforce/apex/lmn_ContractRequiredFieldsController.getRequiredFields';
export default class Lmn_RequiredFieldsLWCContract extends LightningElement {

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