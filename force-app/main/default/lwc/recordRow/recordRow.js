import { LightningElement, track, api} from 'lwc';

export default class RecordRow extends LightningElement {
    @api pcc;
    @api ipn;
    @api occ;
    @api mrn;
    @api band;
    @api positiontitle;
    @api key;

    @track displaytext = "";

    handleCheckboxSelect(event) {
        if (event.target.checked === true) {
          this.displaytext = "Hello World";
          //Add row from selected checkbox on the position results row to selectedRecordsTable.html
          //Reggie: Use events and listeners: 
          //Read more at: https://developer.salesforce.com/docs/component-library/documentation/lwc/lwc.events
          /*
            pcc;
            ipn;
            occ;
            mrn;
            band;
            positiontitle;
            key;
          */
         //Store position.Id into an array
         //Send array of Position.Id back to flow
         //Flow Element: Create Records: https://help.salesforce.com/articleView?id=flow_ref_elements_data_create.htm&type=5
        }
        if (event.target.checked === false) {
          this.displaytext = "This checkbox was unchecked";
          //Remove row from search results to LWC Select Records Table
        }
      }
}