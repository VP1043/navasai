import { LightningElement } from 'lwc';
import getStatement from '@salesforce/apex/fetchStatement.getStatement';

export default class StatementFilter extends LightningElement {
    yearvalue;
    monthvalue;
    reportYearList =[];
    finalYearList =[];
    finalStatement=[];
    statementFlag=false;
    dateValue;
    closeflag;
    showSpinner=false;
    finalTotal;


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
        //this.dateValue=this.monthvalue+'-'+this.yearvalue;

    }
    
    get monthList(){
        return[
            {label:"January" , value: "January"},
            {label:"February" , value: "February"},
            {label:"March" , value: "March"},
            {label:"April" , value: "April"},
            {label:"May" , value: "May"},
            {label:"June" , value: "June"},
            {label:"July" , value: "July"},
            {label:"August" , value: "August"},
            {label:"September" , value: "September"},
            {label:"October" , value: "October"},
            {label:"November" , value: "November"},
            {label:"December" , value: "December"},
        ]
    }

    lookupRecordProperty(event){
        let detailRU = JSON.stringify(event.detail.selectedRecord);
        let finalRU = JSON.parse(detailRU);
        let ruId = finalRU.Id;
        this.rentalUId = ruId;
        console.log('detailRU',detailRU);
        console.log('ruId',ruId);
    }

    handleMonthChange(event){
        this.monthvalue = event.target.value;
    }

    handleYearChange(event){
        this.yearvalue=event.detail.value;
    }

    handleCLick(){
        
        if(this.rentalUId && this.monthvalue && this.yearvalue){
            this.showSpinner=true;
            getStatement({ ruId: this.rentalUId, month:this.monthvalue, year:this.yearvalue})
            .then(result => {
                let statement = [];
                statement = result;
                this.error = undefined;
                this.finalStatement=statement;
                console.log('statement',this.finalStatement);
                this.finalTotal = (this.finalStatement.Total_Amount__c + this.finalStatement.Rental_Agreement__r.Balance__c);
                console.log('finalTotal',this.finalTotal);
                this.statementFlag=true;
                this.showSpinner=false;
                if(this.finalStatement == null){
                    this.statementFlag=false;
                }
            })
            .catch(error => {
                this.error = error;
                console.log('error',this.error);
                this.accounts = undefined;
                this.finalStatement=[];
                this.showSpinner=false;
                this.statementFlag=false;
            })
        }
    }
    closeFlaghandler(){
        this.closeflag = true;
        console.log('In Child');
        const flagEvent = new CustomEvent("getflagvalue", {detail: this.closeflag});

        this.dispatchEvent(flagEvent);
    }
}