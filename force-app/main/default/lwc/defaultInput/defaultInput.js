import { LightningElement, api } from 'lwc';
export default class DefaultInput extends LightningElement {
//@track inputValue;
@api reactiveValue;

  connectedCallback() {
    // Set the default value here (e.g., fetching from a data source)
    this.newValue = this.reactiveValue;
    console.log('newVal', this.newValue);
    console.log('newVal1', this.reactiveValue);
  }

  handleInputChange(event) {
    this.newValue = event.target.value;
  }
}