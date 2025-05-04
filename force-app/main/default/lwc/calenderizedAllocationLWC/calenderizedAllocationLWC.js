import { LightningElement,track,api } from 'lwc';

export default class CalenderizedAllocationLWC extends LightningElement {
    @api territories;
    @api months;
    @track isModalOpen = false;

    openModal() {
        this.isModalOpen = true;
    }

    handleClose() {
        this.isModalOpen = false;
        this.dispatchEvent(new CustomEvent('closemodal'));
    }
    months = [
        { id: 1, name: 'January' },
        { id: 2, name: 'February' },
        { id: 3, name: 'March' },
        { id: 4, name: 'April' },
        { id: 5, name: 'May' },
        { id: 6, name: 'June' },
        { id: 7, name: 'July' },
        { id: 8, name: 'August' },
        { id: 9, name: 'Sepetember' },
        { id: 10, name: 'October' },
        { id: 11, name: 'November' },
        { id: 12, name: 'December' },
        // Add more months as needed
    ];

    territories = [
        { id: 1, name: 'Area 1 Allocated Product' },
        { id: 2, name: 'Area 2 Allocated Product' },
        { id: 3, name: 'Area 3 Allocated Product' },
        { id: 4, name: 'Area 4 Allocated Product' },
        // Add more territories as needed
    ];

    // Sample data structure to hold cell values
    cellValues = {};

    connectedCallback() {
        console.log('hmm here');
        // Initialize cell values
        this.months.forEach(month => {
            this.territories.forEach(territory => {
                this.cellValues[`${month.id}-${territory.id}`] = '';
            });
        });
    }

    getCellValue(monthId, territoryId) {
        return this.cellValues[`${monthId}-${territoryId}`];
    }

    handleValueChange(event) {
        const { value } = event.target;
        const monthId = event.target.dataset.month;
        const territoryId = event.target.dataset.territory;

        // Update cell value in the data structure
        this.cellValues[`${monthId}-${territoryId}`] = value;
    }
     calculateTotal(territoryId) {
        let total = 0;
        this.months.forEach(month => {
            const cellValue = this.cellValues[`${month.id}-${territoryId}`];
            total += cellValue ? parseFloat(cellValue) : 0;
        });
        return total;
    }
}

// import { LightningElement,api, wire } from 'lwc';
// import getCalPrdAllocWrapper from '@salesforce/apex/gsfpClsProductAllocationCalendarize.getCalPrdAllocWrapper';

// export default class GsfplwcPrdAllocCalendatize extends LightningElement {

//     // regions;
//     // months;
//     @api selectedProdAllocation;
//     @api selectedSeason;
//     productData;
//     productIds;
//     productId;
//     territories;
//     months;
//     territoryTotals=[];
//     updatedProductData;
//     tableData = [];
//     allocatedProduct;
//     remainingAllocatioin;
//     @wire(getCalPrdAllocWrapper, {prdAllocIds: '$selectedProdAllocation', seasonId: '$selectedSeason'})
//     wiredCalPrdAllocData({error, data}){
//         if(data){
//             this.productData = data;
//             console.log('this.productData',this.productData);
//             this.updatedProductData = JSON.parse(JSON.stringify(this.productData));
//             this.productIds = Object.keys(this.updatedProductData);
//             this.productId = this.productIds[0];
//             this.initializeData(this.productId);
//         } else if(error){
//             console.error('Error', error);
//         }
//     }
//     connectedCallback(){
//         console.log('selectedProdAllocation',selectedProdAllocation);
//         console.log('seasonId',selectedSeason);
//     }

//     initializeData(productId){
//         const productInfo = this.updatedProductData[productId];
//         this.territories = productInfo.teriterris;
//         this.months =productInfo.teriterris[0].allocattion;
//         this.allocatedProduct = productInfo.alloatedProduct;
        
//         // const uniqueMonths = new Set();
//         // this.territories.forEach(territory=>{
//         //     Object.keys(territory.allocattion).forEach(month =>{
//         //         uniqueMonths.add(month);
//         //     })
//         // });
//         // this.months = Array.from(uniqueMonths);
//         this.calculateTerritoryTotal();
//         this.remainingAllocatioin=productInfo.remainingAllocatioin;
//         this.generateTableData();
//         console.log('this.months'+this.months);
//         console.log('this.territories'+this.territories);
//     }

//     generateTableData(){
//         const uniqueMonths = new Set();
//         this.territories.forEach(territory=>{
//             Object.keys(territory.allocattion).forEach(month =>{
//                 uniqueMonths.add(month);
//             })
//         });

//         const tableData=[];
//         uniqueMonths.forEach(month => {
//             const monthRow = {month: month, territories:[]};
//             this.territories.forEach(territory=>{
//                 const value = territory.allocattion[month] || 0;
//                 monthRow.territories.push({territory:territory.name, value: value});
//             });
//             tableData.push(monthRow);
//         });
//         this.tableData=tableData;
//         console.log('this.tableData'+JSON.stringify(this.tableData));

//     }

//     handlePreviousClick(){
//         const currentIndex = this.productIds.indexOf(this.productId);
//         const previousIndex = (currentIndex - 1)% this.productIds.length;
//         this.productId=this.productIds[previousIndex];
//         this.initializeData(this.productId);
//     }

//     handleNextClick(){
//         const currentIndex = this.productIds.indexOf(this.productId);
//         const nextIndex = (currentIndex + 1)% this.productIds.length;
//         this.productId=this.productIds[nextIndex];
//         this.initializeData(this.productId);
//     }

//     handleDismiss(){
//         const closeEvent = new CustomEvent('close');
//         this.dispatchEvent(closeEvent);
//     }

//     handleClose(){
//         const closeEvent = new CustomEvent('close');
//         this.dispatchEvent(closeEvent);
//     }
//     handleClick(){

//     }

//     handleChange(event){
//         const month = event.target.dataset.month;
//         const territoryName = event.target.dataset.region;
//         const value = parseFloat(event.target.value);
//         console.log('month',month);
//         console.log('territoryName',territoryName);
//         console.log('value',value);
        

//         this.updatedProductData[this.productId].teriterris.find(t=>t.name ===territoryName).allocattion[month] = value ? value : 0;
//         this.calculateTerritoryTotal();

//         console.log('Updated Product Data', this.updatedProductData);
//     }

//     calculateTerritoryTotal(){
//         console.log('Here Iam');
//         const totals={};
//         let productTotalAllocation = 0;
//         this.territories.forEach(territory=>{
//             Object.keys(territory.allocattion).forEach(month=>{
//                 totals[territory.name] = (totals[territory.name] || 0) + parseFloat(territory.allocattion[month]);
//                 productTotalAllocation += parseFloat(territory.allocattion[month]);
//             });
//         });


//         this.territoryTotals=Object.keys(totals).map(territoryName => ({territory: territoryName, value: totals[territoryName]}));

//         this.updatedProductData[this.productId].teriterris.forEach(territory=>{
//             const territoryTotal = this.territoryTotals.find(total => total.territory === territory.name);
//             territory.total = territoryTotal ? territoryTotal.value :0;
            
//         })
//         this.updatedProductData[this.productId].remainingAllocatioin=this.updatedProductData[this.productId].alloatedProduct - productTotalAllocation;

//         this.remainingAllocatioin=this.updatedProductData[this.productId].remainingAllocatioin;
//         console.log('this.updatedProductData'+this.updatedProductData);
//         console.log('this.territoryTotals'+productTotalAllocation);
//         this.territoryTotals.forEach(tot => console.log(tot.territory, tot.value));
        
//     }
// }