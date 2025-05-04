import { LightningElement, api } from 'lwc';
import BackgroundImg from '@salesforce/resourceUrl/userDetailImg';

export default class PortfolioUserDetailandWrapperComponent extends LightningElement {
    //recordId="a002w00000YuZC1AAN"
    //objectApiName="Portfolio__c"
    //background Img
    imageUrl = BackgroundImg;

    get getBackgroundImage(){
        return `background-image:url("${this.imageUrl}")`;
    }

    @api recordId
    @api objectApiName
    @api rank
    @api badges
    @api points
    @api trails
    @api resumeUrl
}