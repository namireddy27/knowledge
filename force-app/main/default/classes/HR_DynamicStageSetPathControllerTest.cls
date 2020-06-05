@isTest(SeeAllData=true)
public class HR_DynamicStageSetPathControllerTest {
     static testMethod void classTest() {
         
          HR_Application__C hrapp = new HR_Application__C();

     Id RecordTypeIdContact = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
   //  hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
     hrapp.Hiring_Stage__c = 'Qualification Review';
    // hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
     // hrapp.Accept__c = true;
     hrapp.RecordTypeId = RecordTypeIdContact;
       hrapp.Application_Status__c = 'Eligible';
     insert hrapp;
         
         HR_DynamicStageSetPathController.AppQuery(hrapp.id	);
         HR_DynamicStageSetPathController.getStatusValues(hrapp.id	,'Community');
          HR_DynamicStageSetPathController.getStatusValues(hrapp.id	,'Lightning');
         
         HR_DynamicStageSetPathController.shouldHiringStageBeRed(hrapp.id);
          hrapp.Application_Status__c = 'Declined';
     update hrapp;
         HR_DynamicStageSetPathController.shouldHiringStageBeRed(hrapp.id);
     }
    /**


        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('TSA Person').getRecordTypeId();
     	Account a = new Account();
    	a.RecordTypeId = RecordTypeIdAccount;
//     	a.Name = '12345678';
    	a.AccountNumber = '12345678';
  		a.lastname='test';
     	insert a;


    	HR_Application__C hrapp  = new HR_Application__c();
        Id RecordTypeIdContact = Schema.SObjectType.HR_Application__C.getRecordTypeInfosByName().get('Field MAP').getRecordTypeId();
        hrapp.Candidate_Portal_Hiring_Stage__c = 'Application Received';
        hrapp.RecordTypeId = RecordTypeIdContact;
     	hrapp.Candidate__c=a.id;
        insert hrapp;
    
     
  //  List<HR_Application_Hiring_Stage__mdt> abc = DynamicStageController.getcustomMetadata(); 
 
     test.startTest(); 
      HR_DynamicStageSetPathController.AppQuery(hrapp.id);
           HR_DynamicStageSetPathController.getStatusValues(hrapp.id);
     test.stopTest();
   
     
 }
**/
  
}