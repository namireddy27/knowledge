import { LightningElement, track, api, wire } from 'lwc';
import saveFile from '@salesforce/apex/HR_FileUploadController.saveFile';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import DOCUMENT_OBJECT from '@salesforce/schema/Document__c';
import DOCUMENT_TYPE_FIELD from '@salesforce/schema/Document__c.Document_Type__c';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';


export default class CustomFileUploader extends LightningElement {
    @api recordId;
    @api lookUpObject;
    @api isFlow;
    @track docType = '';
    @track data;
    @track fileName = '';
    @track UploadFile = 'Upload Document';
    @track showLoadingSpinner = false;
    @track isTrue = false;
    selectedRecords;
    filesUploaded = [];
    file;
    fileContents;
    fileReader;
    content;
    MAX_FILE_SIZE = 250000000;

    @wire(getObjectInfo, { objectApiName: DOCUMENT_OBJECT })
    objectInfo;

    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: DOCUMENT_TYPE_FIELD})
    documentTypeValues;
    handleChange(event) {
        this.docType = event.detail.value;
    }

    // getting file 
    handleFilesChange(event) {
        if(event.target.files.length > 0) {
            this.filesUploaded = event.target.files;
            this.fileName = 'File ' + event.target.files[0].name + ' selected; Click Upload button below';
        }
    }

    handleSave() {
        if(this.filesUploaded.length > 0 && this.docType !== '') {
            this.uploadHelper();
        }
        else {
            //this.fileName = 'Please select file to upload!!';
            if(this.docType === ''){
                this.message = 'Please select a document type for this file';
            }
            else{
                this.message = 'Please select file to upload!!';
            }
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while uploading File',
                    message: this.message,
                    variant: 'error',
                }),
            );
        }
    }

    uploadHelper() {
        this.file = this.filesUploaded[0];
        
       if (this.file.size > this.MAX_FILE_SIZE) {
            window.console.log('File Size is too long');
            window.console.log('File size: ' + this.file.size);
            return ;
        }
        
        this.showLoadingSpinner = true;
        // create a FileReader object 
        this.fileReader= new FileReader();
        // set onload function of FileReader object  
        this.fileReader.onloadend = (() => {
            this.fileContents = this.fileReader.result;
            let base64 = 'base64,';
            this.content = this.fileContents.indexOf(base64) + base64.length;
            this.fileContents = this.fileContents.substring(this.content);
            
            // call the uploadProcess method 
            this.saveToFile();
        });
    
        this.fileReader.readAsDataURL(this.file);
    }

    // Calling apex class to insert the file
    saveToFile() {
        saveFile({ idParent: this.recordId, docType: this.docType, lookUpObject: this.lookUpObject, strFileName: this.file.name, base64Data: encodeURIComponent(this.fileContents)})
        .then(result => {
            window.console.log('result ====> ' +result);
            window.console.log('File size: ' + this.file.size);

            this.fileName = this.fileName + ' - uploaded successfully';
            this.UploadFile = 'File Uploaded';
            this.isTrue = true;
            this.showLoadingSpinner = false;

            // Showing Success message after file insert
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!',
                    message: this.file.name + ' - uploaded successfully.',
                    variant: 'success',
                }),
            );
            if(this.isFlow === true){
                const navigateNextEvent = new FlowNavigationNextEvent();
                this.dispatchEvent(navigateNextEvent);
            }
        })
        .catch(error => {
            // Showing errors if any while inserting the files
            window.console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while uploading File',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }

}