import { LightningElement } from 'lwc';
import getStatement from '@salesforce/apex/fetchStatement.getStatementByDate';
import generatePDFAndSendEmail from '@salesforce/apex/PDFGeneratorAndEmailer.generatePDFAndSendEmail';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class StatementByDate extends LightningElement {
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
    lastDue=false;
    balance =false;
    
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

    handleMonthChange(event){
        this.monthvalue = event.target.value;
    }

    handleYearChange(event){
        this.yearvalue=event.detail.value;
    }

    handleCLick(){
        
        if(this.monthvalue && this.yearvalue){
            this.showSpinner=true;
            getStatement({month:this.monthvalue, year:this.yearvalue})
            .then(result => {
                let statement = [];
                statement = result;
                this.error = undefined;
                this.finalStatement=statement;
                console.log('statement',this.finalStatement);
                for(let i in this.finalStatement){
                    if(this.finalStatement[i].Balance__c>0 && this.finalStatement[i].Amount_Paid__c>0){
                        this.finalStatement[i].Total_Amount__c = (this.finalStatement[i].Total_Amount__c - this.finalStatement[i].Amount_Paid__c);
                    }else{
                        console.log('statement in else');
                        this.finalStatement[i].Total_Amount__c = (this.finalStatement[i].Total_Amount__c + this.finalStatement[i].Balance__c);
                    }
                }
                //console.log('finalTotal',this.finalTotal);
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
    handleCLickEmail(){
        if(this.monthvalue && this.yearvalue){
            generatePDFAndSendEmail({month:this.monthvalue,recipientEmail: 'er.vaibhavpatel01@gmail.com', year:this.yearvalue})
            .then(result=>{
                console.log('result',result);
                const evt = new ShowToastEvent({
                        title: 'Success',
                        message: 'Email Sent Successfully',
                        variant: 'Success'
                    });
                    this.dispatchEvent(evt);
            })
            .catch(error=>{
                console.log('error',error);
                const evt = new ShowToastEvent({
                        title: 'Error',
                        message: 'Error in Sending Email',
                        variant: 'error'
                    });
            })
        }
    }
}