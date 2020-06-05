trigger tgr_Account on Account (before insert, before update, after insert, after update){
//    if(Trigger.isBefore && Trigger.isUpdate){
//        AccountHandler.updateAccountName(Trigger.new, Trigger.oldMap);
//    }
    if(Trigger.isAfter && trigger.isUpdate) {
        //AccountHandler.updateUserRecord(Trigger.New,trigger.oldMap);
    }
}