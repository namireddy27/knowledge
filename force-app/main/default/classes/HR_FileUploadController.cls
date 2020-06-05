public with sharing class HR_FileUploadController {
    
    @AuraEnabled
    public static ContentVersion saveFile(Id idParent, String docType, String lookUpObject, String strFileName, String base64Data) {
        // Decoding base64Data
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        // Create Document Record
        Document__c newDoc = new Document__c();
        newDoc.Document_Type__c = docType;
        System.debug('The field API name: '+lookUpObject);
        if (lookUpObject == 'HR_Application__c') newDoc.Application__c = idParent;
    //    if (lookUpObject == 'Account') newDoc.Candidate__c = idParent;
     //   if (lookUpObject == 'HR_JOA__c') newDoc.JOA__c = idParent;
     //   if (lookUpObject == 'HR_Assessment__c') newDoc.Assessment__c = idParent;
     //   if (lookUpObject == 'HR_Offer__c') newDoc.Offer__c = idParent;
     //   if (lookUpObject == 'HR_Cert__c') newDoc.Cert__c = idParent;
        
        insert newDoc;

        // inserting file
        ContentVersion cv = new ContentVersion();
        cv.Title = strFileName;
        cv.PathOnClient = '/' + strFileName;
        cv.FirstPublishLocationId = newDoc.Id;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        Insert cv;
        return cv;
    }

}