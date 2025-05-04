import { LightningElement, api } from 'lwc';

export default class PortfolioUserDetails extends LightningElement {
    @api recordId
    @api objectApiName
    @api resumeUrl
    downloadResume(){
        window.open(this.resumeUrl,"_blank")
    }
    //"https://github.com/karkranikhil/nikhil-resume/raw/main/SFdummyResume%20(1).pdf"
}