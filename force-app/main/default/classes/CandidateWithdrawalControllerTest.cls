@isTest
public class CandidateWithdrawalControllerTest {
	@isTest
    public static void withdrawTest(){
        Account acc = new Account();
        acc.name = 'testAcc';
        acc.AccountNumber = '01236547';
        Insert acc;
        test.startTest();
        HR_App__c app = new HR_App__c();
        app.Candidate__c = acc.Id;
        app.Hiring_Stage__c = 'CBT';
        Insert app;
        CandidateWithdrawalController.withdraw(app.Id);
        test.stopTest();
    }
}

//System.DmlException: Insert failed. First exception on row 0; first error: FIELD_FILTER_VALIDATION_EXCEPTION, 
//Value does not exist or does not match filter criteria.: [Candidate__c]