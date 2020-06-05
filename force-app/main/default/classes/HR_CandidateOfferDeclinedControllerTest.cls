@istest
public class HR_CandidateOfferDeclinedControllerTest {
static testMethod void classTest() {
     HR_Application__C hrapp = new HR_Application__C();

     Id RecordTypeIdContact = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
   //  hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
     hrapp.Hiring_Stage__c = 'Qualification Review';
    // hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
     // hrapp.Accept__c = true;
     hrapp.RecordTypeId = RecordTypeIdContact;
     insert hrapp;
   
  Account a = new Account();
    a.Name = 'test';
    insert a;
     HR_Offer__c off = new HR_Offer__c();
    off.Application__c = hrapp.Id;
    off.Candidate__c = a.id;	
    insert off;
     HR_CandidateOfferDeclinedController.getButtonDetails(hrapp.Id);
    HR_CandidateOfferDeclinedController.declined(hrapp.Id,'Not Interested');
    hrapp.Application_Status__c='Declined';
    update hrapp;
       HR_CandidateOfferDeclinedController.getButtonDetails(hrapp.Id);
 }
}
/* HR ORG 4/30

@IsTest
public class HR_CandidateOfferDeclinedControllerTest {
    static testMethod void classTest() {
        
        Id RecordTypeIdContact1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('TSA Person').getRecordTypeId(); 
        Account acc = new Account();
        acc.LastName ='Reddy';
        acc.Email_Address__c ='v@googletest.com';
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
        hroff.Status__c = 'TJO Extended';
        insert hroff;
        
        HR_CandidateOfferDeclinedController.declined(hrapp.id);
        HR_CandidateOfferDeclinedController.getButtonDetails(hrapp.Id);
        HR_Application__C hrapp2 = new HR_Application__C();
        
        Id RecordTypeIdContac2t = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        hrapp.Hiring_Stage__c = 'Qualification Review';
        hrapp2.Application_Status__c = 'Declined';
        hrapp2.RecordTypeId = RecordTypeIdContac2t;
        hrapp2.Candidate__c =acc.Id;
        insert hrapp2;
        
        HR_CandidateOfferDeclinedController.getButtonDetails(hrapp2.Id);

    }
}
*/