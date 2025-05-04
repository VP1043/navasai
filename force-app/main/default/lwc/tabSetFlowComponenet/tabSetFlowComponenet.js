import { LightningElement, api, track } from 'lwc';

export default class TabSetFlowComponenet extends LightningElement {
    @api tabData; // Expecting array of objects with {label, value, flowName}
    @track tabs = [];

    connectedCallback() {
        this.initializeTabs();
    }

    initializeTabs() {
        if (this.tabData) {
            this.tabs = JSON.parse(JSON.stringify(this.tabData));
        }
    }

    handleStatusChange(event) {
        // Handle flow status change if needed
        console.log('Flow Status Changed:', event.detail);
    }
}