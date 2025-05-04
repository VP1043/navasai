import { LightningElement, track, wire } from 'lwc';
import getData from '@salesforce/apex/DatatableController.getData';
import saveData from '@salesforce/apex/DatatableController.saveData';
import saveEnergyBillAmountToCustomSetting from '@salesforce/apex/DatatableController.saveEnergyBillAmountToCustomSetting'; // Import the new method

import { refreshApex } from '@salesforce/apex';

export default class DataTable extends LightningElement {
    @track selectedMonth;
    @track selectedYear;
    @track data = [];
    @track columns = [];
    currYear;
    @track yearOptions = [];
    @track draftValues = [];
    showEnergyBill = false; // Default value
    unitRate;
    totalRow;
    energyAmountRate;

    monthOptions = [
        { label: 'January', value: 'January' },
        { label: 'February', value: 'February' },
        { label: 'March', value: 'March' },
        { label: 'April', value: 'April' },
        { label: 'May', value: 'May' },
        { label: 'June', value: 'June' },
        { label: 'July', value: 'July' },
        { label: 'August', value: 'August' },
        { label: 'September', value: 'September' },
        { label: 'October', value: 'October' },
        { label: 'November', value: 'November' },
        { label: 'December', value: 'December' }
    ];

    connectedCallback() {
        this.setCurrentMonthAndYear();
    }

    @wire(getData, { month: '$selectedMonth', year: '$selectedYear' })
    wiredData(result) {
        this.wiredResult = result;
        const { error, data } = result;
        if (data) {
            this.data = data;
            if (this.data.length > 0) {
                const totalRow = {
                    id: 'total',
                    name: 'Total',
                    rentalAmount: data.reduce((total, row) => total + row.rentalAmount, 0),
                    energyBill: data.reduce((total, row) => total + row.energyBill, 0),
                    waterBill: data.reduce((total, row) => total + row.waterBill, 0),
                    total: data.reduce((total, row) => total + row.total, 0),
                    energyBillPrvRead: data.reduce((energyBillPrvRead, row) => energyBillPrvRead + row.energyBillPrvRead, 0),
                    energyBillCurrRead: data.reduce((energyBillCurrRead, row) => energyBillCurrRead + row.energyBillCurrRead, 0),
                    rowClass: 'total-row',
                    customStyle: 'font-weight: bold; background-color: #f3f3f3; color: #000;'
                };

                // Append the total row to the data array
                this.data = [...data, totalRow];

                this.totalRow = this.data.find(item => item.id === 'total');

                this.unitRate = totalRow.energyBillCurrRead - totalRow.energyBillPrvRead;
                console.log('this.unitRate' + this.unitRate);
            }

            this.updateColumns();
            console.log('Data:', JSON.stringify(this.data));
        } else if (error) {
            console.error('Error fetching data', error);
        }
    }

    handleMonthChange(event) {
        this.selectedMonth = event.detail.value;
        this.fetchData();
    }

    handleYearChange(event) {
        this.selectedYear = event.detail.value;
        this.fetchData();
    }

    handleColumnToggle(event) {
        this.showEnergyBill = event.target.checked;
        this.updateColumns();
    }

    handleCellChange(event) {
        const updatedFields = event.detail.draftValues;
        console.log('Draft Values:', JSON.stringify(updatedFields));

        if (updatedFields.length === 0) {
            console.warn('No changes detected.');
            return;
        }

        const changedRecords = this.data.map(row => {
            const updatedRow = updatedFields.find(item => item.statementId === row.statementId);
            if (updatedRow) {
                const hasChanges = Object.keys(updatedRow).some(key => row[key] !== updatedRow[key]);
                if (hasChanges) {
                    return { ...row, ...updatedRow };
                }
            }
            return null;
        }).filter(record => record !== null);

        console.log('Changed Records:', JSON.stringify(changedRecords));

        if (changedRecords.length === 0) {
            console.warn('No records have changed.');
            return;
        }

        this.saveMainMeterBillAmonut()
         .then(() => {
                console.log('Data saved Bill Amount.');
                this.draftValues = [];
            })
            .catch(error => {
                console.error('Error saving data:', error);
            });

        this.saveDataToServer(changedRecords)
            .then(() => {
                console.log('Data saved successfully.');
                this.draftValues = [];
            })
            .catch(error => {
                console.error('Error saving data:', error);
            });

        this.totalRow = this.data.find(item => item.id === 'total');

        this.unitRate = this.energyAmountRate / (((totalRow.energyBillCurrRead - totalRow.energyBillPrvRead), 0) || 10);
        console.log('this.unitRate' + this.unitRate);
    }

    saveDataToServer(changedRecords) {
        return saveData({ data: changedRecords })
            .then(() => {
                this.draftValues = [];
                return refreshApex(this.wiredResult);
            })
            .catch(error => {
                console.error('Error saving data:', error);
                throw error;
            });
    }

    saveMainMeterBillAmonut() {
        saveEnergyBillAmountToCustomSetting({ energyBillAmount: this.energyAmountRate })
            .then(() => {
                console.log('Energy Bill Amount saved to custom setting');
            })
            .catch(error => {
                console.error('Error saving Energy Bill Amount to custom setting', error);
            });
    }

    updateColumns() {
        this.columns = [
            {
                label: 'Name', fieldName: 'name', initialWidth: 180, cellAttributes: {
                    class: { fieldName: 'rowClass' },
                    style: { fieldName: 'customStyle' }
                }
            },
            {
                label: 'Rent Amount', fieldName: 'rentalAmount', type: 'currency', initialWidth: 150, cellAttributes: {
                    class: { fieldName: 'rowClass' },
                    style: { fieldName: 'customStyle' }
                }
            },
            {
                label: 'Energy Bill', fieldName: 'energyBill', type: 'currency', initialWidth: 150, cellAttributes: {
                    class: { fieldName: 'rowClass' },
                    style: { fieldName: 'customStyle' }
                }
            },
            {
                label: 'Water Bill', fieldName: 'waterBill', type: 'currency', editable: true, initialWidth: 150, cellAttributes: {
                    class: { fieldName: 'rowClass' },
                    style: { fieldName: 'customStyle' }
                }
            },
            {
                label: 'Total', fieldName: 'total', type: 'currency', initialWidth: 150, cellAttributes: {
                    class: { fieldName: 'rowClass' },
                    style: { fieldName: 'customStyle' }
                }
            }
        ];

        if (this.showEnergyBill) {
            this.columns.push(
                {
                    label: 'Previous Reading', fieldName: 'energyBillPrvRead', type: 'number', editable: true, initialWidth: 150, cellAttributes: {
                        class: { fieldName: 'rowClass' },
                        style: { fieldName: 'customStyle' }
                    }
                },
                {
                    label: 'Current Reading', fieldName: 'energyBillCurrRead', type: 'number', editable: true, initialWidth: 150, cellAttributes: {
                        class: { fieldName: 'rowClass' },
                        style: { fieldName: 'customStyle' }
                    }
                }
                //{ label: 'Unit Rate (Rs/Unit)', fieldName: 'energyBillUnitRate', type: 'number', editable: true, initialWidth: 150 }
            );
        }
    }

    setCurrentMonthAndYear() {
        const date = new Date();
        const monthNames = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
        ];

        this.selectedMonth = monthNames[date.getMonth()];
        const currentYear = date.getFullYear();
        this.selectedYear = currentYear.toString();
        this.currYear = currentYear.toString();

        this.yearOptions = [
            { label: (currentYear - 1).toString(), value: (currentYear - 1).toString() },
            { label: currentYear.toString(), value: currentYear.toString() }
        ];
    }

    fetchData() {
        return refreshApex(this.wiredResult);
    }

    get isDataAvailable() {
        return this.data.length > 0;
    }

    handleBillChange(event) {
        this.energyAmountRate = event.target.value;
        const name = event.target.dataset.name;
        this.draftValues = [...name];
        console.log('draftValues' + this.draftValues);
        console.log('energyAmountRate' + this.energyAmountRate);
        this.totalRow = this.data.find(item => item.id === 'total');
        this.unitRate = this.energyAmountRate / ((this.totalRow.energyBillCurrRead - this.totalRow.energyBillPrvRead) || 10);
        console.log('this.unitRate' + this.unitRate);
        console.log('this.energyBillCurrRead' + this.totalRow.energyBillCurrRead);
        console.log('this.energyBillPrvRead' + this.totalRow.energyBillPrvRead);

    }
}