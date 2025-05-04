import { LightningElement, api, track } from 'lwc';

export default class ModalComponent extends LightningElement {
    @api productData;
    @track productId;
    @track territories;
    @track months;
    @track allocationValues = {};
    @track productIds = [];
     @track showInfo = false;

    toggleInfo() {
        this.showInfo = !this.showInfo;
    }
    connectedCallback() {
        this.productIds = Object.keys(this.productData);
        this.productId = this.productIds[0]; // Default to the first product
        this.initializeData(this.productId);
    }

    initializeData(productId) {
        const productInfo = this.productData[productId];
        this.territories = productInfo.territories;
        this.months = productInfo.months;

        if (!this.allocationValues[productId]) {
            this.allocationValues[productId] = {};
        }

        this.months.forEach(month => {
            if (!this.allocationValues[productId][month]) {
                this.allocationValues[productId][month] = {};
            }
            this.territories.forEach(territory => {
                if (!this.allocationValues[productId][month][territory]) {
                    this.allocationValues[productId][month][territory] = '';
                }
            });
        });
    }

    handleClose() {
        const closeEvent = new CustomEvent('close');
        this.dispatchEvent(closeEvent);
    }

    previousProduct() {
        const currentIndex = this.productIds.indexOf(this.productId);
        const previousIndex = (currentIndex - 1 + this.productIds.length) % this.productIds.length;
        this.productId = this.productIds[previousIndex];
        this.initializeData(this.productId);
    }

    nextProduct() {
        const currentIndex = this.productIds.indexOf(this.productId);
        const nextIndex = (currentIndex + 1) % this.productIds.length;
        this.productId = this.productIds[nextIndex];
        this.initializeData(this.productId);
    }

    handleProductChange(event) {
        this.productId = event.target.value;
        this.initializeData(this.productId);
    }

    getAllocationValue(productId, month, territory) {
        return this.allocationValues[productId][month][territory];
    }

    handleChange(event){
        
    }
}