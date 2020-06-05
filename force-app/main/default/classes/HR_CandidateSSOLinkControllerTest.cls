@IsTest
public class HR_CandidateSSOLinkControllerTest {
    
    
    static testMethod void classTest() {
        
        
        Account acc = new Account();
        acc.Name ='Venu Reddy';
        insert acc;
        HR_Application__C hrapp = new HR_Application__C();    
        Id RecordTypeIdContact = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        hrapp.Hiring_Stage__c = 'Qualification Review';
        hrapp.Application_Status__c ='Accepted';
        hrapp.RecordTypeId = RecordTypeIdContact;
        hrapp.Candidate__c =acc.Id;
        insert hrapp;
        HR_Application__C hrapp2 = new HR_Application__C();    
        hrapp2.Hiring_Stage__c = 'Qualification Review';
        hrapp2.RecordTypeId = RecordTypeIdContact;
        hrapp2.Candidate__c =acc.Id;
        insert hrapp2;
        HR_CandidateSSOLinkController.updateTogetSSOLink(hrapp.id);
        HR_CandidateSSOLinkController.updateExtSystemStatus(hrapp.id);
        HR_CandidateSSOLinkController.getnewSSOLink(hrapp.id);
        HR_CandidateSSOLinkController.getExternalSystemStatus(hrapp.id);
        HR_CandidateSSOLinkController.getButtonDetails(hrapp.id);
        HR_CandidateSSOLinkController.getButtonDetails(hrapp2.id);
    }
    
    
}