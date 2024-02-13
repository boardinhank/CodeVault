import { LightningElement, track, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';	

import './checkNRMARequestStatus.css';

export default class CheckNRMARequestStatus extends NavigationMixin( LightningElement ) 
{
    @track showSpinner = false;
    //@track showModal = true;
    @track showCheckNRMAStatusTimer = false;
    @track showCheckNRMAStatusButton = true;

    @track checkStatusTimerText = "Timer Starting...";

    timeAllowedTilReshow = 1000 * 60 * 5;
	@track rbtimer = this.template.querySelector("span");//lightning-input");	
    @track rbutton = this.template.querySelector("button");//lightning-button");
    @track rspinner = this.template.querySelector("lightning-spinner");

    @api recordId;

    // Set the date we're counting down to
	hideButton(e) {
        let parentThis = this;
		let countDownDate = Date.now() + this.timeAllowedTilReshow;	
        	
        //hide button, show timer initially with message "Timer Starting..."	
        this.showCheckNRMAStatusButton = false;	
        this.showCheckNRMAStatusTimer = true;	
        this.checkStatusTimerText = "Timer Started...";

		// Update the timer count down every 1 second	
        let timerInterval = setInterval(function() {	


            // Get today's date and time
            let now = new Date().getTime();

            // Find the distance between now and the count down date
            let distance = countDownDate - now;

            // Time calculations for minutes and seconds
            let minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            let seconds = Math.floor((distance % (1000 * 60)) / 1000);

            // Output the result in an element with id="demo"
            parentThis.checkStatusTimerText = " " + minutes + " mins " + (seconds < 10 ? "0" : "") + seconds + " secs ";

            // If the count down is over, write some text 
            if (distance < 0) {
                clearInterval(timerInterval);
                parentThis.showCheckNRMAStatusTimer = false;
                parentThis.showCheckNRMAStatusButton = true;
                parentThis.checkStatusTimerText = "Timer Starting...";
            }
	    }, 1000);	
    }//end method hideButton     
    
    checkNRMARequestStatusAction(e)
    {
        this.showSpinner = true;

        this.hideButton(e);
         this[ NavigationMixin.Navigate ]( {	
            type: 'standard__webPage',	
            attributes: {	
                url: '/flow/NRMA_Button_Send_to_BRAIN?recordId='+this.recordId+'&retURL=/'+this.recordId	
                              	
            }	
        },	
        false // Replaces the current page in your browser history with the URL if set to true	
        );
        
        console.log("checkNRMARequestStatusAction) APEX would be called next if it existed (coming soon)");
        this.showSpinner = false;
    }//end method checkNRMARequestStatusAction 

    closeAction()
    {
        console.log('Closing CheckNRMARequestStatus LWC');
        this.dispatchEvent(new CloseActionScreenEvent());
        const closeNRMAStatus = new CustomEvent('close'); // Dispatches the event. 
        this.dispatchEvent(closeNRMAStatus);
    }//end method closeAction
}