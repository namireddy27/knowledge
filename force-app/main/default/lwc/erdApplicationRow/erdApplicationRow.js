import { LightningElement, track, api } from 'lwc';

export default class ErdApplicationRow extends LightningElement {
    @api application;
    @api candidate;
    @api gender;
    @api ptq1;
    @api ptq2;
    @api ptq3;
    @api ptq4;
    @api ptqtotal;


    //Boolean value to store the state of the checkbox
    @track isCheckboxSelected;

    @api selectedApplicationId;
    //Array of Application__c record Ids that were selected by the user
    @api applicationArray;

    connectedCallback() {
        if(typeof this.applicationArray != "undefined" && this.applicationArray != null
        && this.applicationArray.length == null && this.applicationArray.length === 0
        && this.applicationArray.includes(this.applicationid)) {
            this.isCheckboxSelected = false;
        }
    }

    handleCheckboxSelect(event) {
        if(event.target.checked === true) {
            this.selectedApplicationId = event.target.value;
            const selectEvent = new CustomEvent("select", {detail: this.selectedApplicationId}, {bubbles:true}, {composed:true});
            this.dispatchEvent(selectEvent);
        } else if (event.target.checked === false) {
            const unselectEvent = new CustomEvent("unselect", {detail: this.selectedApplicationId}, {bubbles:true}, {composed:true});
            this.dispatchEvent(unselectEvent);
        }
    }

}