import { LightningElement, api } from 'lwc';
import callParcelService from '@salesforce/apex/callParcelServiceController.callService';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class CallParcelService extends LightningElement {

@api recordId;
mapdata = [];
message = '';

    connectedCallback() {

        console.log('Record Id$$'+this.recordId);
        
   
    }

    renderedCallback(){
        console.log('Rendered Reocrd Id'+this.recordId);
        if(this.recordId){
            console.log('Test 1');
            callParcelService({ recordId : this.recordId})
            .then(result => {
                console.log('Test 2'+result);
                if(result){
                    this.mapdata = result;
                    console.log('in result'+result);
                    if(this.mapdata.true){
                        this.message = this.mapdata.true;
                        const evt = new ShowToastEvent({
                            title: 'Success',
                            message: this.message,
                            variant: 'success'
                        });
                        this.dispatchEvent(evt);
                        this.dispatchEvent(new CloseActionScreenEvent());
                    }
                    if(this.mapdata.false){
                        this.message = this.mapdata.false;
                        const evt = new ShowToastEvent({
                            title: 'Error',
                            message: this.message,
                            variant: 'error'
                        });
                        this.dispatchEvent(evt);
                        this.dispatchEvent(new CloseActionScreenEvent());
                    }
                }
                else{
                    this.message = 'Error calling Parcel Service, please try again.';
                    const evt = new ShowToastEvent({
                        title: 'Error',
                        message: this.message,
                        variant: 'error'
                    });
                    this.dispatchEvent(evt);
                    this.dispatchEvent(new CloseActionScreenEvent());
                }
            })
            .catch(error => {
                console.log('Apex error'+JSON.stringify(error));
                this.message = 'Error calling Parcel Service, please try again.';
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: this.message,
                    variant: 'error'
                });
                this.dispatchEvent(evt);
                this.dispatchEvent(new CloseActionScreenEvent());
            });
        }
    }
}