public without sharing class HR_FileUploadController {
    
    @AuraEnabled
    public static ContentVersion saveFile(Id idParent, String docType, String lookUpObject, String strFileName, String base64Data) {
        // Decoding base64Data
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        // Create Document Record
        Document__c newDoc = new Document__c();
        newDoc.Document_Type__c = docType;
        System.debug('The field API name: '+lookUpObject);
        switch on lookUpObject{
            when 'Application__c' {
                newDoc.Application__c = idParent;
                newDoc.Candidate__c = getCandidateID(idParent);
            }
            when 'Account' {newDoc.Candidate__c = idParent;}
            when 'JOA__c' {newDoc.JOA__c = idParent;}
            when 'Assessment__c'{newDoc.Assessment__c = idParent;}
            when 'Offer__c' {newDoc.Offer__c = idParent;}
            when 'Cert__c' {newDoc.Cert__c = idParent;}
        }
        
        try {
            insert newDoc;
            System.debug('newDoc has been uploaded successfully');
        } catch (Exception e) {
            System.debug(e);
        }

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
    
    public static String getCandidateID(String appId){
        HR_Application__c a = [SELECT Id, Candidate__c FROM HR_Application__c WHERE Id = :appId LIMIT 1];
        return a.Candidate__c;
    }

    @AuraEnabled(cacheable=true)
    public static Map<ContentVersion, Document__c> getDocumentsFromApplication(String appId, String lookUpObject){
        String docQuery = 'SELECT Id, Document_Type__c FROM Document__c WHERE ' + lookUpObject + ' = :appId';
        List<Document__c> docs = Database.query(docQuery);
        //List<Document__c> docs = [SELECT Id, Document_Type__c FROM Document__c WHERE Application__c = :appId];
        List<Id> IdList = new List<Id>();
        for(Document__c d : docs){
            IdList.add(d.Id);
        }
        List<ContentDocumentLink> contentIdList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :IdList];
        IdList.clear();
        for(ContentDocumentLink cdl : contentIdList){
            IdList.add(cdl.ContentDocumentId);
        }
        List<ContentVersion> contentVersionList = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :IdList];
        Map<ContentVersion, Document__c> documents = new Map<ContentVersion, Document__c>();
        for(Integer i = 0; i < contentIdList.size(); i++){
            documents.put(contentVersionList[i], docs[i]);
        }
        return documents;
    }
     
    @AuraEnabled(cacheable=true)
    public static string getDownloadLink(String contentId){
        ContentVersion cv = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :contentId];
        System.debug('/sfc/servlet.shepherd/version/download/' + cv.Id);
        return '/sfc/servlet.shepherd/version/download/' + cv.Id + '?'; //+ '?operationContext=S1';
    }
}