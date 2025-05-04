import { LightningElement } from 'lwc';
import previousReading from '@salesforce/apex/ElectricityBillCalculator.getPreviousReading';
import saveRentalEntries from '@salesforce/apex/ElectricityBillCalculator.saveRentalEntries';	
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class RentalEntriesForm extends LightningElement {
 prvreading='';
    curreading='';
    finalMonthList;
    billAmount;
    validateBtnState=true;
    totalBill;
    lookupId;
    reportYearList =[];
    finalYearList =[];
    //energyBill;
    yearvalue;
    monthvalue;
    rentalUnitId;
    rentalUId;
    closeflag=false;
    detailRU;

    connectedCallback(){
        const month = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "Octomber", "November", "December"];
        var today = new Date();
        var yyyy = today.getFullYear();
        //this.yearvalue = yyyy.toString();
        if(today.getMonth()>0){
            this.monthvalue = month[today.getMonth()-1];
            this.yearvalue = (yyyy).toString();
        }else{
            this.monthvalue = month[11];
            this.yearvalue = (yyyy-1).toString();
        }
        this.reportYearList.push(yyyy-1);
        this.reportYearList.push(yyyy);
        this.reportYearList.push(yyyy+1);

        for(let i in this.reportYearList){
            this.finalYearList = [...this.finalYearList, {value: this.reportYearList[i].toString(), label: this.reportYearList[i].toString()}];
        }
        console.log('yearvalueconect',this.yearvalue);
        console.log('reportYearList',today.getMonth());
        console.log('monthvalue',this.monthvalue);

    }

    get monthList(){
        return[
            {label:"January" , value: "January"},
            {label:"February" , value: "February"},
            {label:"March" , value: "March"},
            {label:"April" , value: "April"},
            {label:"May" , value: "May"},
            {label:"June" , value: "Jun"},
            {label:"July" , value: "July"},
            {label:"August" , value: "August"},
            {label:"September" , value: "September"},
            {label:"Octomber" , value: "October"},
            {label:"November" , value: "November"},
            {label:"December" , value: "December"},
        ]
    }

    handlePrvReadingChange(event){
        this.prvreading=event.target.value;
        this.updateButtonState();
    }
    handleCurReadingChange(event){
        this.curreading=event.target.value;
        this.updateButtonState();
    }

    handleMonthChange(event){
        this.monthvalue = event.target.value;
    }

    handleWaterbillChange(event){
        this.billAmount = event.target.value;
    }

    handleYearChange(event){
        this.yearvalue=event.detail.value;
        console.log('yearvalue',this.yearvalue);
        this.updateButtonState();
    }

    handleMonthChange(event){
        this.monthvalue=event.detail.value;
        this.updateButtonState();
    }

    handleCLick(){
        this.totalBill=(this.curreading-this.prvreading);
        saveRentalEntries({ ruId: this.rentalUId, prevReading: this.prvreading, curReading: this.curreading, month:this.monthvalue, year:this.yearvalue, waterbill:this.billAmount})
		.then(result => {
            let newenergyBill = result;
            if(result == 'Success'){
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Record Saved Successfully',
                    variant: 'Success'
                });
                this.dispatchEvent(evt);
                this.handleReset();
                this.handleRefresh();
            }
            this.error = undefined;
            console.log('newenergyBill',newenergyBill);
        })
        .catch(error => {
			this.error = error;
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'Error in Creating Agreement',
                variant: 'Error'                      
            });
            this.dispatchEvent(evt);
			this.accounts = undefined;
		})
        
    }

    lookupRecord(event){
        //alert('Selected Record Value on Parent Component is ' +  JSON.stringify(event.detail.selectedRecord));
        try {
            this.detailRU = JSON.stringify(event.detail.selectedRecord);
            let finalRU = JSON.parse(this.detailRU);
            
            let ruId = finalRU.Id;
            this.rentalUId = ruId;
            console.log('detailRU', this.detailRU);
            console.log('ruId', ruId);
            this.previousEnergy(ruId);
            this.updateButtonState();
        } catch (error) {
            console.error('Error in lookupRecord: ', error);
            // Handle the error or display an error message to the user as needed.
        }
    }

    previousEnergy(rentalUnitId){
        this.prvreading='';
        console.log('Im here');
        if(rentalUnitId != null || rentalUnitId != ''){
        previousReading({ ruId: rentalUnitId })
		.then(result => {
			let energyBill = result;
			this.error = undefined;
            this.prvreading = energyBill;
            console.log('energyBill',energyBill);
            this.updateButtonState();
		})
		.catch(error => {
			this.error = error;
			this.accounts = undefined;
		})
        }
    }

    updateButtonState(){ 
        //alert(this.upiId);
        if(this.prvreading  && this.curreading){
        this.validateBtnState=false;
        }else{
            this.validateBtnState=true;
        }
        console.log('this.prvreading',this.prvreading);
        console.log('this.validateBtnState',this.validateBtnState);
    }

    closeFlaghandler(){
        this.closeflag = true;
        console.log('In Child');
        const flagEvent = new CustomEvent("getflagvalue", {detail: this.closeflag});

        this.dispatchEvent(flagEvent);
    }

    handleReset(){
        this.prvreading='';
        this.curreading='';
        this.billAmount='';
        this.detailRU='';
    }

    handleRefresh(){
        window.location.reload();
    }
}