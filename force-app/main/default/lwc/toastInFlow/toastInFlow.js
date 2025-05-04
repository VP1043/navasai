import { LightningElement, api } from 'lwc';
 import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 export default class ToastInFlow extends LightningElement {
    @api mode;
    @api variant;    
    @api message;    

    connectedCallback() {
        this.showToast();
    }

    showToast() {
        const toastEvt = new ShowToastEvent({
            title:"LWC Toast",
            mode: this.mode,
            variant: this.variant,            
            message: this.message
        });
        this.dispatchEvent(toastEvt);
    }
 }