public class AccountHandler {
    public static Boolean preventTrigger = true;
/*    
    public static void updateAccountName(List<Account> accountList, Map<Id, Account> accountMap){
        if(preventTrigger){
            for(Account acc : accountList){
                if(acc.Rating != accountMap.get(acc.Id).Rating){
                    if(acc.Rating == 'Hot'){
                        acc.Name = acc.Name+' - '+acc.Rating;
                    }
                    else{
                        List<String> stList = acc.Name.split('-');
                    }
                }
            }
        }
    }
    
    */
/*
    public static void updateUserRecord(List<Account> accountList, Map<Id, Account> accountMap){
        List<Account> lstacc = trigger.new;
        List<User> usrToUpdate = new List<User>();
        map<Id,Account> mapAccOld=(  map<Id,Account>) Trigger.OldMap;
        Map<Id, Account> conIdUser = new Map<Id, Account>();
        for(Account acc: lstacc) {
           
            
            if(
                //(acc.PersonMailingStreet!=mapAccOld.get(acc.Id).PersonMailingStreet) ||(acc.PersonMailingCity!=mapAccOld.get(acc.Id).PersonMailingCity)
                // || (acc.PersonMailingPostalCode!=mapAccOld.get(acc.Id).PersonMailingPostalCode) || (acc.PersonMailingState!=mapAccOld.get(acc.Id).PersonMailingState)
                // || (acc.PersonMailingCountry!=mapAccOld.get(acc.Id).PersonMailingCountry) ||(acc.PersonHomePhone!=mapAccOld.get(acc.Id).PersonHomePhone)||
                (acc.Phone!=mapAccOld.get(acc.Id).Phone) ||  
                //(acc.PersonMobilePhone!=mapAccOld.get(acc.Id).PersonMobilePhone) || 
                // (acc.PersonEmail!=mapAccOld.get(acc.Id).PersonEmail)
            ) {
                //  conIdUser.put(acc.User_Id__c, acc);
            }
        }
        for(User acc: [SELECT Id,Street,City,PostalCode,Phone,State,
                          MobilePhone, email FROM User Where Id IN : conIdUser.keySet()]){
                              acc.Street = conIdUser.get(acc.User_Id__c).PersonMailingStreet;
                              acc.city = conIdUser.get(acc.User_Id__c).PersonMailingCity;
                              acc.PostalCode = conIdUser.get(acc.User_Id__c).PersonMailingPostalCode;            
                              acc.State = conIdUser.get(acc.User_Id__c).PersonMailingState;
                              //                        acc.Country = conIdUser.get(acc.User_Id__c).PersonMailingCountry;
                              //                        acc.phone = conIdUser.get(acc.User_Id__c).PersonHomePhone;
                              acc.Phone = conIdUser.get(acc.User_Id__c).phone;
                              acc.Mobilephone = conIdUser.get(acc.User_Id__c).PersonMobilePhone;            
                              acc.Email = conIdUser.get(acc.User_Id__c).PersonEmail;
                              
                              usrToUpdate.add(acc);
                          }
 //       database.update(usrToUpdate, true);
        Update usrToUpdate;
        
    }
}
*/
}