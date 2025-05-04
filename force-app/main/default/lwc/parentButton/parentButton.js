// parentComponent.js
import { LightningElement, track } from 'lwc';

export default class ParentButton extends LightningElement {
    @track isModalOpen = false;
    territories = []; // Add your territories data
    months = []; // Add your months data

    openModal() {
        console.log('here');
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
}

// import { LightningElement, track } from 'lwc';


// export default class DummyProductAllocation extends LightningElement {
//      @track isOpenModal = false;
//      @track selectedProdAllocation =[];
//      @track selectedSeason;

//      @track productData={
//           'product1':{
//                alloatedProduct:2000,
//                teriterris: [
//                     {
//                          name:'Territory A',
//                          allocattion: {
//                               'Nov': 0,
//                               'Dec': 3,
//                               'January': 0,
//                               'February': 3,
//                               'March': 5,
//                               'April': 0,
//                               'May': 0,
//                               'June': 0
//                          }
//                     },
//                     {
//                          name:'Territory B',
//                          allocattion: {
//                               'January': 0,
//                               'February': 0,
//                               'March': 0,
//                               'April': 0,
//                               'May': 0,
//                               'June': 0
//                          }
//                     },
//                     {
//                          name:'Territory C',
//                          allocattion: {
//                               'January': 0,
//                               'February': 0,
//                               'March': 0,
//                               'April': 0,
//                               'May': 0,
//                               'June': 0
//                          }
//                     },
//                     {
//                          name:'Territory D',
//                          allocattion: {
//                               'January': 0,
//                               'February': 0,
//                               'March': 0,
//                               'April': 0,
//                               'May': 0,
//                               'June': 0
//                          }
//                     }
//                ]
//           },
//           'product2':{
//                alloatedProduct:1000,
//                teriterris: [
//                     {
//                          name:'Territory D',
//                          allocattion: {
//                               'January': 0,
//                               'February': 0,
//                               'March': 0,
//                               'April': 0,
//                               'May': 0,
//                               'June': 0
//                          }
//                     },
//                     {
//                          name:'Territory E',
//                          allocattion: {
//                               'January': 0,
//                               'February': 0,
//                               'March': 0,
//                               'April': 0,
//                               'May': 0,
//                               'June': 0
//                          }
//                     },
//                     {
//                          name:'Territory F',
//                          allocattion: {
//                               'January': 0,
//                               'February': 0,
//                               'March': 0,
//                               'April': 0,
//                               'May': 0,
//                               'June': 0
//                          }
//                     }
//                ]
//           },
//           'product3':{
//                alloatedProduct:500,
//                teriterris: [
//                     {
//                          name:'Territory D',
//                          allocattion: {
//                               'January': 0,
//                               'February': 0,
//                               'March': 0,
//                               'April': 0,
//                               'May': 0,
//                               'June': 0
//                          }
//                     },
//                     {
//                          name:'Territory E',
//                          allocattion: {
//                               'January': 0,
//                               'February': 0,
//                               'March': 0,
//                               'April': 0,
//                               'May': 0,
//                               'June': 0
//                          }
//                     }
//                ]
//           }
          
     
//      }

//      selectedProdAllocation=['a8cE10000005HTGIA2'];

//      selectedSeason='a2sE10000020yB8IAI';

//      openModal() {
//           this.isOpenModal = true;
//      }

//      closeModal() {
//           this.isOpenModal = false;
//      }


// }