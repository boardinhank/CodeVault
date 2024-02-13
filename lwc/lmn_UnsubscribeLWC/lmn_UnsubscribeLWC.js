import { LightningElement, wire, track } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import optOutRecords from '@salesforce/apex/LMN_UnsubscribeController.optOutRecords';  // This is the controller class

export default class unsubscribeLWC extends LightningElement { 

  unsubid = '';
  lastname = '';
  myMessage = '';
  showButton = '';

  @track working = false;
  @wire(CurrentPageReference)

  getStateParameters(currentPageReference) {

 if (currentPageReference) {

      const unsubid = currentPageReference.state.c__unsubid;
      const lastname = currentPageReference.state.c__lastname;
      this.unsubid = unsubid;
      this.lastname = lastname;

  if (unsubid) {
     this.showButton = true;
    // this.myMessage = `Are you sure you want to Unsubscribe? ${unsubid} ${lastname}`;
      this.myMessage = `You will no longer receive the latest updates from Quantum Fiber. Are you sure you want to Unsubscribe?`;
   } else {
    // this.displayValue = ` There is an issue with your unsubscribe url - No unsubid Provided `;
      this.showButton = false;
      this.myMessage = `There is an issue with your unsubscribe url - No unsubid Provided`;
        }
  }
}


handleClickGo() {
   this.working = true;
   optOutRecords({unsubid : this.unsubid, lastname : this.lastname})
   .then(result=>{
     // this.myMessage = JSON.stringify(result);
      this.working = false;
      this.showButton = false;
      this.myMessage = 'You have been successfully Unsubscribed';
   })
   .catch(error=>{
      this.working = false;
      this.showButton = false;
      this.myMessage = 'An error has occured please contact support: ' + JSON.stringify(error) + ' ';
   })
}

HandleClickStay() {
  
     this.showButton = false;
     this.myMessage = 'We value you as a customer and will continue to update you with the latest in Quantum Fiber!';

}

}

//   the format of the url needs to be the following or it will not work and will not throw a message that it did not work. (Hank - QFC-3850 - 6/10/2023)
//   https://connectedlumn--cjdev1.sandbox.my.site.com/unsubscribe/?c__unsubid=0035900000Tws7NAAR&c__lastname=henrie                                                                 -  URL as passed from merge field hyperlink (Copy and paste to test)
//   <a href="{{{Recipient.Salesforce_Server_URL__c}}}/unsubscribe/?c__unsubid={{{Recipient.Id}}}&c__lastname={{{Recipient.lastname}}}" title="Unsubscribe">click here</a>           -  how the merge fields look in email template