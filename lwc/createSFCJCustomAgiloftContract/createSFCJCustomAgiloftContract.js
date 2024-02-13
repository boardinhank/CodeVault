/***************************************************************************************  
* Modification History
*
* Date          Updated By  User story      Notes
* 03/23/2022	Kuehl       ESCJ-388        Copied from SFDC Enterprise to use in SFCJ and tweaked for SFCJ needs
****************************************************************************************/
import { LightningElement, api } 	from 'lwc'; 
import { CloseActionScreenEvent } 	from 'lightning/actions';
import { ShowToastEvent } 		    from "lightning/platformShowToastEvent";

import createAgiloftContract 	    from '@salesforce/apex/CLMUtils.createAgiloftContract';

export default class CreateAgiloftContract extends LightningElement 
{
    showSpinner = false;
    showModal   = true;
   
    @api recordId;
    
    createAction(e)
    {
        this.showSpinner = true;
        
        console.log('Calling APEX CLMUtils class createAgiloftContract function... Contract Id: ' + this.recordId);

        createAgiloftContract({ recordId: this.recordId })  // Contract Id from Contract Object Screen
            
            .then(response => 
            {
                this.showModal      = false;
                this.showSpinner    = false;
                
                this.closeAction();
                
                if (response.startsWith('A new CLM contract record is being created')) // This msg must match Custom Settings: AgiloftSuccessMessage value...
                {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: response,
                            variant: 'success',
                            mode: 'sticky'
                        })
                    );
                }
                else 
                {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Error!',
                            message: response,
                            variant: 'error',
                            mode: 'sticky'
                        })
                    );
                }
            })

            .catch(error => 
            {
                console.log('createAgiloftContract in error');
                console.log(error);
                this.closeAction();

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error!',
                        message: error.body.message,
                        variant: 'error',
                        mode: 'sticky'
                    })
                );
                this.showSpinner = false;
            });  

    } 

    closeAction()
    {
        console.log('Closing lwc');
        this.dispatchEvent(new CloseActionScreenEvent());
        const closeQA = new CustomEvent('close'); // Dispatches the event. 
        this.dispatchEvent(closeQA);
    }
}