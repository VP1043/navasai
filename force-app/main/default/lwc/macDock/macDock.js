import { LightningElement,track } from 'lwc';
import backgroundUrl from '@salesforce/resourceUrl/background';
import { NavigationMixin } from "lightning/navigation";

export default class MacDock extends LightningElement {
salesApp ='';
servicesApp='lightning/n/Rent_Entries';
marketingApp='';
salesConsoleApp='';
serviceConsoleApp='';
communityApp='';
OtherApp='';
codeBuiler='';
entriesFlag=false;
agreeFlag=false;
agreeUnitFlag=false;

orgURL='https://navasai2-dev-ed.develop.lightning.force.com/';
get backgroundStyle() {
    return `height:50rem;background-image:url(${backgroundUrl})`;
}

newAgreement(){

          //console.log('orgURL',this.orgURL);
          this.agreeFlag=true;
         
         }


        newEntries(){
            this.entriesFlag=true;
        }  

       rentUnits(){
            this.agreeUnitFlag=true;
       }  

       rentStatement(){
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: orgURL + salesConsoleApp
            }
          });
       }  

       
       energy(){
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'orgURL + serviceConsoleApp'
            }
          });
       }  

       handleFlagValue(event){
        this.entriesFlag=false;
        console.log('in parent',event.detail);
       }
       
       handleAgreeFlagValue(event){
        this.agreeFlag=false;
       } 

       handleUnitFlagValue(event){
        this.agreeUnitFlag=false;
       } 
       
}