trigger HR_UpdatePersonAccountWithUser on User (After Update ) {
/* if(Trigger.isUpdate && Trigger.isAfter){
        List<User> users= Trigger.new;
       	Map<Id, user> conIdUser = new Map<Id, user>();
        List<Account> accToUpdate = new List<Account>();
        map<Id,User> mapUserOld= Trigger.OldMap;
        for(User user: users){
            if(User.Street!=mapUserOld.get(User.Id).Street || User.City!=mapUserOld.get(User.Id).City || User.PostalCode!=mapUserOld.get(User.Id).PostalCode
              || User.State!=mapUserOld.get(User.Id).State || User.Phone!=mapUserOld.get(User.Id).Phone
              || User.MobilePhone!=mapUserOld.get(User.Id).MobilePhone || User.email!=mapUserOld.get(User.Id).email)
            {
            	conIdUser.put(user.ContactId, user);
            }
        }
        for(account acc: [SELECT Id,Personcontactid,PersonMailingStreet,PersonMailingCity,PersonMailingPostalCode,PersonMailingState,Phone,PersonMobilePhone,
                          PersonEmail, User_Id__c FROM account Where Personcontactid IN : conIdUser.keySet()]){
                        acc.PersonMailingStreet = conIdUser.get(acc.PersoncontactId).street;
                        acc.PersonMailingCity = conIdUser.get(acc.PersoncontactId).City;
                        acc.PersonMailingPostalCode = conIdUser.get(acc.PersoncontactId).PostalCode;            
                        acc.PersonMailingState = conIdUser.get(acc.PersoncontactId).State;
//                        acc.PersonMailingCountry = conIdUser.get(acc.PersoncontactId).Country;
//                        acc.PersonHomePhone = conIdUser.get(acc.PersoncontactId).phone;
                        acc.Phone = conIdUser.get(acc.PersoncontactId).phone;
                        acc.PersonMobilePhone = conIdUser.get(acc.PersoncontactId).Mobilephone;            
                        acc.PersonEmail = conIdUser.get(acc.PersoncontactId).email;
           
            accToUpdate.add(acc);
        }
 //      database.upsert(accToUpdate, true); 
		update accToUpdate;      
    }
    
}*/
    
    
}