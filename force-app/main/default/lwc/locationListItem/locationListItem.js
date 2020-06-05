import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import LOCATION_OBJECT from '@salesforce/schema/Location__c';

/**
 * A presentation component to display a HR_Location__c sObject. The provided
 * HR_Location__c data must contain all fields used by this component.
 */
export default class LocationListItem extends NavigationMixin(LightningElement) {
    @api location;

    /** View Details Handler to navigates to the record page */
    handleViewDetailsClick() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.location.Id,
                objectApiName: LOCATION_OBJECT.objectApiName,
                actionName: 'view'
            }
        });
    }
}