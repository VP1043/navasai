import { LightningElement, api, wire } from 'lwc';
import previousReading from '@salesforce/apex/ElectricityBillCalculator.getPreviousReading';
import saveRentalEntries from '@salesforce/apex/ElectricityBillCalculator.saveRentalEntries';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const MONTHS = [
    { label: 'January', value: 'January' },
    { label: 'February', value: 'February' },
    { label: 'March', value: 'March' },
    { label: 'April', value: 'April' },
    { label: 'May', value: 'May' },
    { label: 'June', value: 'June' },
    { label: 'July', value: 'July' },
    { label: 'August', value: 'August' },
    { label: 'September', value: 'September' },
    { label: 'October', value: 'October' },
    { label: 'November', value: 'November' },
    { label: 'December', value: 'December' },
];

export default class ElectricityBillCalculator extends LightningElement {
    prvreading;
    curreading;
    billAmount;
    validateBtnState = true;
    totalBill;
    lookupId;
    reportYearList = [];
    finalYearList = [];
    yearvalue;
    monthvalue;
    rentalUnitId;
    rentalUId;
    closeflag = false;
    detailRU;

    connectedCallback() {
        const today = new Date();
        const yyyy = today.getFullYear();
        const prevMonthIndex = today.getMonth() - 1;
        this.monthvalue = MONTHS[prevMonthIndex] || MONTHS[11];
        this.yearvalue = prevMonthIndex >= 0 ? yyyy.toString() : (yyyy - 1).toString();
        this.reportYearList = [yyyy - 1, yyyy, yyyy + 1];
        this.finalYearList = this.reportYearList.map(year => ({ value: year.toString(), label: year.toString() }));
        console.log('yearvalueconect', this.yearvalue);
        console.log('reportYearList', today.getMonth());
        console.log('monthvalue', this.monthvalue);
    }

    get monthList() {
        return MONTHS;
    }

    handlePrvReadingChange(event) {
        this.prvreading = event.target.value;
        this.updateButtonState();
    }

    handleCurReadingChange(event) {
        this.curreading = event.target.value;
        this.updateButtonState();
    }

    handleMonthChange(event) {
        this.monthvalue = event.target.value;
        this.updateButtonState();
    }

    handleWaterbillChange(event) {
        this.billAmount = event.target.value;
    }

    handleYearChange(event) {
        this.yearvalue = event.detail.value;
        console.log('yearvalue', this.yearvalue);
        this.updateButtonState();
    }

    handleClick() {
        this.totalBill = this.curreading - this.prvreading;
        saveRentalEntries({
                ruId: this.rentalUId,
                prevReading: this.prvreading,
                curReading: this.curreading,
                month: this.monthvalue,
                year: this.yearvalue,
                waterbill: this.billAmount
            })
            .then(result => {
                if (result === 'Success') {
                    this.showToast('Record Saved Successfully', 'Success');
                    this.handleReset();
                }
                console.log('newenergyBill', result);
            })
            .catch(error => {
                this.error = error;
                this.showToast('Error in Creating Agreement', 'Error');
                this.accounts = undefined;
            })
            .finally(() => {
                this.error = undefined;
            });
    }
    
    showToast(message, variant) {
        const evt = new ShowToastEvent({
            title: variant,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    lookupRecord(event) {
        const selectedRecord = event.detail.selectedRecord;
        this.detailRU = JSON.stringify(selectedRecord);
        this.rentalUId = selectedRecord.Id;
        console.log('detailRU', this.detailRU);
        console.log('ruId', this.rentalUId);
        this.previousEnergy(this.rentalUId);
        this.updateButtonState();
    }
    previousEnergy(rentalUnitId) {
        if (!rentalUnitId) {
            return;
        }
    
        previousReading({ ruId: rentalUnitId })
            .then(previousReading => {
                this.error = undefined;
                this.prvreading = previousReading;
                this.updateButtonState();
            })
            .catch(error => {
                this.error = error;
                this.accounts = undefined;
            });
    }
    
      
      updateButtonState() {
        this.validateBtnState = Boolean(this.prvreading) && Boolean(this.curreading);
        console.log('this.prvreading', this.prvreading);
        console.log('this.validateBtnState', this.validateBtnState);
      }
      
      closeFlaghandler() {
        this.closeflag = true;
        console.log('In Child');
        const flagEvent = new CustomEvent("getflagvalue", { detail: this.closeflag });
        this.dispatchEvent(flagEvent);
      }
      
      handleReset() {
        this.prvreading = '';
        this.curreading = '';
        this.billAmount = '';
        this.detailRU = '';
      }
    }