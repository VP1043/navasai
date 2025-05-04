import { LightningElement, api, wire } from 'lwc';
import fetchLookupData from '@salesforce/apex/lookupRentalNameClass.fetchLookupData';
import fetchDefaultRecord from '@salesforce/apex/lookupRentalNameClass.fetchDefaultRecord';

const DELAY = 300; // Delay in milliseconds

export default class CustomLookupLwc extends LightningElement {
    @api label = 'custom lookup label';
    @api placeholder = 'search...';
    @api iconName = 'standard:account';
    @api sObjectApiName = 'Rental_Unit__c';
    @api defaultRecordId = '';
    @api filledFlag = '';

    lstResult = [];
    hasRecords = true;
    searchKey = '';
    isSearchLoading = false;
    delayTimeout;
    selectedRecord = {};

    connectedCallback() {
        if (this.defaultRecordId) {
            this.fetchDefaultRecord();
        }
    }

    fetchDefaultRecord() {
        fetchDefaultRecord({ recordId: this.defaultRecordId, sObjectApiName: this.sObjectApiName, filledFlag: this.filledFlag })
            .then(result => {
                if (result) {
                    this.selectedRecord = result;
                    this.handleSelectRecordHelper();
                }
            })
            .catch(error => {
                console.error('Error fetching default record:', error);
                this.selectedRecord = {};
            });
    }

    @wire(fetchLookupData, { searchKey: '$searchKey', sObjectApiName: '$sObjectApiName', filledFlag: '$filledFlag' })
    searchResult({ data, error }) {
        this.isSearchLoading = false;
        if (data) {
            this.hasRecords = data.length > 0;
            this.lstResult = [...data];
        } else if (error) {
            console.error('Error in @wire searchResult:', error);
            this.lstResult = [];
            this.hasRecords = false;
        }
    }

    handleKeyChange(event) {
        this.isSearchLoading = true;
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
    }

    toggleResult(event) {
        try {
            const lookupInputContainer = this.template.querySelector('.lookupInputContainer');
            const clsList = lookupInputContainer.classList;
            const whichEvent = event.target.dataset.source;
            if (whichEvent === 'searchInputField') {
                clsList.add('slds-is-open');
            } else if (whichEvent === 'lookupContainer') {
                clsList.remove('slds-is-open');
            }
        } catch (error) {
            console.error('Error in toggleResult:', error);
        }
    }

    handleRemove() {
        this.searchKey = '';
        this.selectedRecord = {};
        this.lookupUpdatehandler(null);

        this.toggleSearchBoxVisibility(true);
    }

    handelSelectedRecord(event) {
        try {
            const objId = event.target.dataset.recid;
            this.selectedRecord = this.lstResult.find(record => record.Id === objId);
            this.lookupUpdatehandler(this.selectedRecord);
            this.handleSelectRecordHelper();

            const lookupInputContainer = this.template.querySelector('.lookupInputContainer');
            const clsList = lookupInputContainer.classList;
            const whichEvent = event.target.dataset.source;
            if (whichEvent === 'searchInputField') {
                clsList.add('slds-is-open');
            } else if (whichEvent === 'lookupContainer1') {
                clsList.remove('slds-is-open');
            }
        } catch (error) {
            console.error('Error in handelSelectedRecord:', error);
        }
    }

    handleSelectRecordHelper() {
        try {
            this.toggleSearchBoxVisibility(false);
        } catch (error) {
            console.error('Error in handleSelectRecordHelper:', error);
        }
    }

    toggleSearchBoxVisibility(showSearchBox) {
        const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
        const pillDiv = this.template.querySelector('.pillDiv');

        if (showSearchBox) {
            searchBoxWrapper.classList.remove('slds-hide');
            searchBoxWrapper.classList.add('slds-show');
            pillDiv.classList.remove('slds-show');
            pillDiv.classList.add('slds-hide');
        } else {
            searchBoxWrapper.classList.remove('slds-show');
            searchBoxWrapper.classList.add('slds-hide');
            pillDiv.classList.remove('slds-hide');
            pillDiv.classList.add('slds-show');
        }
    }

    lookupUpdatehandler(value) {
        try {
            const updateEvent = new CustomEvent('lookupupdate', {
                detail: { selectedRecord: value }
            });
            this.dispatchEvent(updateEvent);
        } catch (error) {
            console.error('Error in lookupUpdatehandler:', error);
        }
    }
}