@IsTest
public class HR_CandidateRequestContactControllerTest {
    static testMethod void classTest() {
        
        Id RecordTypeIdContact1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('TSA Person').getRecordTypeId(); 
        Account acc = new Account();
//        acc.LastName ='Reddy';
//        acc.Email_Address__c ='v@googletest.com';
        acc.RecordTypeId = RecordTypeIdContact1;
        insert acc;

        HR_Application__C hrapp = new HR_Application__C();
        
        Id RecordTypeIdContact = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
        hrapp.Application_Status__c = 'In Process';
        hrapp.RecordTypeId = RecordTypeIdContact;
        hrapp.Candidate__c =acc.Id;
        insert hrapp;
        
        HR_Offer__c hroff = new HR_Offer__c();
        hroff.Application__c = hrapp.Id;
        hroff.Candidate__c =acc.Id;
        hroff.Request_Contact__c = true;
        insert hroff;
        
        HR_CandidateRequestContactController.requested(hrapp.id);
        HR_CandidateRequestContactController.getButtonDetails(hrapp.Id);
        HR_Application__C hrapp2 = new HR_Application__C();
        
        Id RecordTypeIdContac2t = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        hrapp.Hiring_Stage__c = 'Qualification Review';
        hrapp2.Application_Status__c = 'Declined';
        hrapp2.RecordTypeId = RecordTypeIdContac2t;
        hrapp2.Candidate__c =acc.Id;
        insert hrapp2;
        
        HR_CandidateRequestContactController.getButtonDetails(hrapp2.Id);
        
    }
}