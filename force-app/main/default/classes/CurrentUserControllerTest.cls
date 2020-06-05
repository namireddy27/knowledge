@isTest
public class CurrentUserControllerTest {
static testMethod void classTest() {
    Account a = new Account();
    //a.Phone = '1234567890';
    a.Name = '12345678';
    a.AccountNumber = '12345678';
    insert a;
    
    Contact c = new Contact();
    c.Accountid = a.id;
 	c.LastName = 'Test';
    insert c;
    
    User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'Customer Community User'].Id,
     LastName = 'last',
     Email = 'puser000@amamama.com',
     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
     Phone = '1234567890',
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US',
 
     ContactID = c.id
);
    insert u;
    
    CurrentUserController.getCurrentUser(u.id);
    CurrentUserController.getUserContact(u.id);
}
}