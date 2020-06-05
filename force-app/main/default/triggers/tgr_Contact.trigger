trigger tgr_Contact on Contact (after insert, after delete) {
	Set<Id> accountIdSet = new Set<Id>();
    Map<Id, Integer> contactCountMap = new Map<Id, Integer>();
    Map<Id, Account> accMapToUpdate = new Map<Id, Account>();
    for(Contact con : Trigger.isInsert ? Trigger.new : Trigger.Old){
        accountIdSet.add(con.AccountId);
    }
    if(accountIdSet.size() > 0){
        for(AggregateResult agg : [Select AccountId aId, count(Id) cId from Contact where AccountId IN : accountIdSet group by AccountId]){
            contactCountMap.put((Id)agg.get('aId'), (Integer)agg.get('cId'));
        }
    }
    if(contactCountMap.size() > 0){
        for(Contact con : Trigger.isInsert ? Trigger.new : Trigger.Old){
            if(contactCountMap.containsKey(con.AccountId)){
                Account acc = new Account(Id = con.AccountId);
                acc.Contact_Count__c = contactCountMap.get(con.AccountId);
                accMapToUpdate.put(acc.Id, acc);
            }
    	}
    }
    if(accMapToUpdate.size() > 0){
        //AccountHandler.preventTrigger = false;
        Update accMapToUpdate.values();
    }
}