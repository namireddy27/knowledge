({
	myAction : function(component, event, helper) {
		
	}
})

/*
ffd


<template>
    <lightning-card title="Document Uploader" icon-name="action:upload">
        <div class="slds-m-around_medium">
            <template if:true={documentTypeValues.data}>
                <lightning-combobox label="Document Type"
                                    value={docType}
                                    placeholder="-Select-"
                                    options={documentTypeValues.data.values}
                                    onchange={handleChange} 
                                    required>
                </lightning-combobox>
          
                <br/>
                <div>
                    <lightning-input label="Select File" name="file uploader" onchange={handleFilesChange} type="file"></lightning-input>
                </div>

                <div class="slds-text-body_small slds-text-color_success">{fileName}
                    <template if:true={showLoadingSpinner}>
                        <lightning-spinner alternative-text="Uploading......" size="medium"></lightning-spinner>
                    </template>
                </div><br/>
                
                <div>
                    <lightning-button class="slds-m-top--medium" label={UploadFile} onclick={handleSave} variant="brand" disabled={isTrue}></lightning-button>
                </div>
            </template>
        </div>
    </lightning-card>
</template>

------------------------------

import { LightningElement, track, api, wire } from 'lwc';
import saveFile from '@salesforce/apex/HR_FileUploadController.saveFile';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import DOCUMENT_OBJECT from '@salesforce/schema/Document__c';
import DOCUMENT_TYPE_FIELD from '@salesforce/schema/Document__c.Document_Type__c';


export default class CustomFileUploader extends LightningElement {
    @api recordId;
    @api lookUpObject;
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
    MAX_FILE_SIZE = 1500000;

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
            window.console.log('File Size is to long');
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




<LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>47.0</apiVersion>
    <isExposed>true</isExposed>
    <masterLabel>Document File Uploader</masterLabel>
    <targets>
        <target>lightning__RecordPage</target>
        <target>lightningCommunity__Page</target>
        <target>lightningCommunity__Default</target>
    </targets>
    <targetConfigs>
        <targetConfig targets="lightning__RecordPage">
            <objects>
                <object>HR_Application__c</object>
                <object>Account</object>
                <object>HR_Cert__c</object>
                <object>HR_JOA__c</object>
                <object>HR_Assessment__c</object>
                <object>HR_Offer__c</object>
            </objects>
            <property name="lookUpObject" type="String" default="" label="Document Lookup API Name" description="API name of the Lookup Reference field on Document__c object"/>
        </targetConfig>
        <targetConfig targets="lightningCommunity__Default">
            <property name="recordId" type="String" label="Record Id To find similarities" description="Default uses the current page's record id" default="{!recordId}"/>
            <property name="lookUpObject" type="String" default="{!lookUpObject}" label="Document Lookup API Name"/>
        </targetConfig>
    </targetConfigs>
</LightningComponentBundle>







*/