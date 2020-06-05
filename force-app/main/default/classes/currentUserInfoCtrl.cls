public with sharing class currentUserInfoCtrl {
   @AuraEnabled 
    public static user fetchUser(){
     // query current user information  
      User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                 FROM User Where id =: userInfo.getUserId()];
        return oUser;
    }
}