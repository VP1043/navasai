import { LightningElement, track } from 'lwc';

export default class ButtonComponent extends LightningElement {
    @track isModalOpen = false;
    @track productData = {
        'product1': {
            months: ['January', 'February', 'March','April','May','June'],
            territories: ['Territory A', 'Territory B','Territory c','Territory D']
        },
        'product2': {
            months: ['April', 'May', 'June'],
            territories: ['Territory E', 'Territory F','Territory G', 'Territory H']
        }
        // Add more products as needed
    };

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
}