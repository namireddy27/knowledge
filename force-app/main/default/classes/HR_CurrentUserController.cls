public without sharing class HR_CurrentUserController {
 
    @AuraEnabled
    public static User getCurrentUser(Id Userid) {
        User toReturn = [SELECT Id, FirstName, LastName, State, Street, City, PostalCode, Name, Country, Phone, Email FROM User WHERE Id = :Userid LIMIT 1];
        return toReturn;
    }  // method i updated 2nd 
    
    @AuraEnabled
    public static Contact getUserContact(Id Userid){
        id ContactId = [Select ContactId from User where id=:UserInfo.getUserId()].ContactId;
        Return [SELECT Id, FirstName, LastName, Name, Phone, Email, Account.BillingStreet, Account.BillingCity,
                Account.BillingState, Account.BillingPostalCode, Account.Phone FROM Contact WHERE Id = :ContactId LIMIT 1]; 
    }
}

/*
 * public without sharing class CurrentUserController {
 
    @AuraEnabled
    public static User getCurrentUser(Id Userid) {
        User toReturn = [SELECT Id, FirstName, LastName, State, Street, City, PostalCode, Name, Country, MobilePhone, Phone, Email FROM User WHERE Id = :Userid LIMIT 1];
        return toReturn;
    }  
    @AuraEnabled
    public static String getUserContact(Id Userid){
        id ContactId = [Select ContactId from User where id=:Userid].ContactId;
        Return [SELECT Id, AccountId FROM Contact WHERE Id = : ContactId LIMIT 1].AccountID;

 
 */