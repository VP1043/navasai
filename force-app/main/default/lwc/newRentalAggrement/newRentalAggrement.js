import { LightningElement } from 'lwc';
import saveNewAgreement from '@salesforce/apex/ElectricityBillCalculator.saveNewAgreement';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class NewRentalAggrement extends LightningElement {
    agreementName;
    depositValue;
    monthRent;
    validateBtnState = true;
    rentalUId;
    totalBill = false;
    rentaConId;
    showSpinner =false;
    confirmflag=false;
    closeflag;

    handleAgreementChange(event){
        this.agreementName = event.target.value;
        this.updateButtonState();
    }

    handleDepositChange(event){
        this.depositValue = event.target.value;
        this.updateButtonState();
    }

    handleMonthRentChange(event){
        this.monthRent = event.target.value;
        this.updateButtonState();
    }

    updateButtonState(){
        if(this.agreementName && this.depositValue && this.monthRent && this.rentalUId){
            this.validateBtnState = false;
        }else{
            this.validateBtnState = true;
        }
    }

    lookupRecordProperty(event){
        //alert('Selected Record Value on Parent Component is ' +  JSON.stringify(event.detail.selectedRecord));
        let detailRU = JSON.stringify(event.detail.selectedRecord);
        let finalRU = JSON.parse(detailRU);
        
        let ruId = finalRU.Id;
        this.rentalUId = ruId;
        console.log('detailRU',detailRU);
        console.log('ruId',ruId);
        
        this.updateButtonState();
    }

    lookupRecordContact(event){
        let detailCon = JSON.stringify(event.detail.selectedRecord);
        let finalCon = JSON.parse(detailCon);
        
        let conId = finalCon.Id;
        this.rentaConId = conId;
        console.log('detailCon',finalCon);
        console.log('conId',conId);
        
        this.updateButtonState();
    }

    handleCLick(){
        this.showSpinner = true;
        if(this.rentalUId && this.agreementName && this.depositValue && this.monthRent && this.rentaConId){
            saveNewAgreement({ruId: this.rentalUId, agreeName: this.agreementName, deposit: this.depositValue, mRent: this.monthRent, renter: this.rentaConId})
            .then(result => {
                let agreement = result;
                this.error = undefined;
                console.log('agreement',agreement);
                if(result == 'Success'){
                    this.showSpinner = false;
                    console.log('Imherea');
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: 'Aggrement has  been created Successfully',
                        variant: 'Success'
                    });
                    this.dispatchEvent(evt);
                }else{
                    this.showSpinner = false;
                    const evt = new ShowToastEvent({
                        title: 'Error',
                        message: 'Error in Creating Agreement',
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
        }
    }
    closeFlaghandler(){
        this.closeflag = true;
        const flagEvent = new CustomEvent("getflagvalue", {detail: this.closeflag});
        this.dispatchEvent(flagEvent);
    }
}