import { LightningElement } from 'lwc';
import savePayment from '@salesforce/apex/ElectricityBillCalculator.savePayment';
import getStatement from '@salesforce/apex/ElectricityBillCalculator.getStatement';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class PaymentForm extends LightningElement {
    handleAmount;
    showSpinner=false;
    error;
    rentaConId;
    statementFlag=false;
    finalStat=[];
    finalTot;

    lookupRecord(event){
        let detailCon = JSON.stringify(event.detail.selectedRecord);
        let finalCon = JSON.parse(detailCon);
        
        let conId = finalCon.Id;
        this.rentaConId = conId;
        console.log('detailCon',finalCon);
        console.log('conId',conId);
        
    }

    handleAmountChange(event){
        console.log(event.target.value);
        this.handleAmount = event.target.value;
        console.log(' this.handleAmount', this.handleAmount);

    }
    handleSearchCLick(){
        this.statementFlag=true;
        this.finalStat=[];
        this.finalTot=0;
        console.log('stats');
        if(this.rentaConId){
           getStatement({ruId: this.rentaConId})
           .then(result=>{
               let stats = result;
               this.finalStat = stats;
               this.finalTot =  this.finalStat.Rental_Agreement__r.Balance__c;
               console.log('stats',stats);
           })
           .catch(error => {
                this.showSpinner = false;
                this.error = error;
                console.log('error',error);

            })
        }
    }
    
    handleCLick(){
        this.showSpinner = true;
        if(this.rentaConId && this.handleAmount){
            savePayment({ruId: this.rentaConId, amount: this.handleAmount})
            .then(result => {
                let agreement = result;
                this.error = undefined;
                console.log('agreement',agreement);
                if(result == 'Success'){
                    this.showSpinner = false;
                    console.log('Imherea');
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: 'Payment has  been created Successfully',
                        variant: 'Success'
                    });
                    this.dispatchEvent(evt);
                    this.handleRefresh();
                }else{
                    this.showSpinner = false;
                    const evt = new ShowToastEvent({
                        title: 'Error',
                        message: 'Error in Creating Payment',
                        variant: 'Error'                      
                    });
                    this.dispatchEvent(evt);
                }
            })
            .catch(error => {
                this.showSpinner = false;
                this.error = error;
                console.log('error',error);

            })
        }else{
            const evt = new ShowToastEvent({
                        title: 'Error',
                        message: 'Please fill all fields',
                        variant: 'Error'
                    });
                    this.dispatchEvent(evt);
        }
    }

    closeFlaghandler(){
        this.closeflag = true;
        const flagEvent = new CustomEvent("getflagvalue", {detail: this.closeflag});
        this.dispatchEvent(flagEvent);
    }

    handleRefresh() {
    // Refresh the page
    window.location.reload();
  }
}