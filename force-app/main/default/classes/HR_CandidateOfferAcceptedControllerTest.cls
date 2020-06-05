@IsTest
public class HR_CandidateOfferAcceptedControllerTest {
 static testMethod void classTest() {
     
     
     Account acc = new Account();
     acc.Name ='Venu Reddy';
     insert acc;
     HR_Application__C hrapp = new HR_Application__C();

     Id RecordTypeIdContact = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
   //  hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
     hrapp.Hiring_Stage__c = 'Qualification Review';
    // hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
     // hrapp.Accept__c = true;
     hrapp.RecordTypeId = RecordTypeIdContact;
     hrapp.Candidate__c =acc.Id;
     insert hrapp;
     
     HR_Offer__c hroff = new HR_Offer__c();
     hroff.Application__c = hrapp.Id;
      hroff.Candidate__c =acc.Id;
     insert hroff;
     
     HR_CandidateOfferAcceptedController.accepted(hrapp.id);
     
    HR_CandidateOfferAcceptedController.getButtonDetails(hrapp.Id);

      HR_Application__C hrapp2 = new HR_Application__C();

     Id RecordTypeIdContac2t = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
     hrapp.Hiring_Stage__c = 'Qualification Review';
     hrapp2.Application_Status__c = 'Accepted';
    // hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
     // hrapp.Accept__c = true;
     hrapp2.RecordTypeId = RecordTypeIdContac2t;
     hrapp2.Candidate__c =acc.Id;
     insert hrapp2;
       HR_CandidateOfferAcceptedController.getButtonDetails(hrapp2.Id);
 }
}

/*                  from HR ORG 4/30
@IsTest
public class HR_CandidateOfferAcceptedControllerTest {
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
        
        HR_CandidateOfferAcceptedController.accepted(hrapp.id);
        HR_CandidateOfferAcceptedController.getButtonDetails(hrapp.Id);
        HR_Application__C hrapp2 = new HR_Application__C();
        
        Id RecordTypeIdContac2t = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        hrapp.Hiring_Stage__c = 'Qualification Review';
        hrapp2.Application_Status__c = 'Accepted';
        hrapp2.RecordTypeId = RecordTypeIdContac2t;
        hrapp2.Candidate__c =acc.Id;
        insert hrapp2;
        
        HR_Offer__c hroff1 = new HR_Offer__c();
        hroff1.Application__c = hrapp2.Id;
        hroff1.Candidate__c =acc.Id;
        hroff1.Status__c = 'FJO Extended';
        insert hroff1;
        
        HR_CandidateOfferAcceptedController.getButtonDetails(hrapp2.Id);
        HR_CandidateOfferAcceptedController.accepted(hrapp2.id);
    }
}


**/