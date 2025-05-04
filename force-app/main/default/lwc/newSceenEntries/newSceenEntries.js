import { LightningElement, api } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
//import getFilledRentalUnit from '@salesforce/apex/entriesTransaction.getFilledRentalUnit';

export default class NewScreenEntries extends LightningElement {
    @api rentalUId;
    @api name;

    lookupRecord(event) {
        const selectedRecord = event.detail.selectedRecord;

        if (selectedRecord) {
            const rentalUnitId = selectedRecord.Id;
            const unitName = selectedRecord.Name;

            this.rentalUId = rentalUnitId;
            this.name = unitName;
            console.log('rentalUId', rentalUnitId);
            console.log('selectedRecord', selectedRecord);
        }


        //this.previousEnergy(rentalUnitId);
        //this.updateButtonState();

        this.dispatchFlowAttributeChangeEvent();
    }

    previousEnergy(rentalUnitId) {
        // Call the Apex method to get previous energy data
        getFilledRentalUnit({ rentalUnitId })
            .then(result => {
                // Handle the returned data
                console.log('Previous Energy:', result);
            })
            .catch(error => {
                // Handle any errors
                console.error('Error fetching previous energy:', error);
            });
    }

    dispatchFlowAttributeChangeEvent() {
        const attributeChangeEvent = new FlowAttributeChangeEvent('rentalUId', this.rentalUId);
        this.dispatchEvent(attributeChangeEvent);

        const attributeChangeEvent1 = new FlowAttributeChangeEvent('name', this.name);
        this.dispatchEvent(attributeChangeEvent1);
    }
}