import { LightningElement } from 'lwc';

export default class ParentStatementComponent extends LightningElement {

      closeFlaghandler(){
        this.closeflag = true;
        const flagEvent = new CustomEvent("getflagvalue", {detail: this.closeflag});
        this.dispatchEvent(flagEvent);
    }
}