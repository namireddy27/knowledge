trigger TestAccountUpdateTrg on User (After Update) {
    
    if(Trigger.isUpdate && Trigger.isAfter){
        List<User> users= Trigger.new;
       	Map<Id, user> conIdUser = new Map<Id, user>();
        Map<Id, Id> mapAccConId = new Map<Id, Id>();
        List<Account> accToUpdate = new List<Account>();
        
        for(User user: users){
            conIdUser.put(user.ContactId, user);
        }
        
        List<Contact> conLi = [SELECT Id, AccountId, Email FROM Contact Where Id IN : conIdUser.keySet()];
        for(Contact con : conLi){
            mapAccConId.put(con.AccountId,Con.Id);
        }
        
        /*for(account acc: [SELECT Id, PersonEmail, User_Id__c FROM account Where id IN : mapAccConId.keySet()]){
            acc.PersonEmail = conIdUser.get(mapAccConId.get(acc.Id)).email;
            accToUpdate.add(acc);
        }
        database.upsert(accToUpdate, true); */
    }
    
    
}