import { LightningElement } from 'lwc';
import backgroundUrl from '@salesforce/resourceUrl/background';

export default class PdfGenerator extends LightningElement {
    entriesFlag=false;
    agreeFlag=false;
    agreeUnitFlag=false;
    defaultFlag=true;
    paymentFlag=false;
get backgroundStyle() {
    return `height:50rem;background-image:url(${backgroundUrl})`;
}

    handleEntries(){
        this.entriesFlag=true;
        this.agreeFlag=false;
        this.agreeUnitFlag=false;
        this.defaultFlag=false;
        this.paymentFlag=false;
        console.log('im heere');
    }

    handleFlagValue(event){
        this.entriesFlag=false;
        this.defaultFlag=true;

    }

    handleAgree(){
        this.agreeFlag=true;
        this.entriesFlag=false;
        this.agreeUnitFlag=false;
        this.defaultFlag=false;
        this.paymentFlag=false;
    } 

    handleAgreeFlagValue(event){
        this.agreeFlag=false;
        this.defaultFlag=true;
    }

    handleUnit(){
        this.agreeUnitFlag=false;
        this.paymentFlag=true;
        this.entriesFlag=false;
        this.agreeFlag=false;
        this.defaultFlag=false;
    }

    handleUnitFlagValue(event){
        this.agreeUnitFlag=false;
        this.defaultFlag=true;
    }
    handleStatement(){
        this.agreeUnitFlag=true;
        this.paymentFlag=false;
        this.entriesFlag=false;
        this.agreeFlag=false;
        this.defaultFlag=false;
    }
    handlePaymentFlagValue(event){
        this.paymentFlag=false;
        this.defaultFlag=true;
    }
}