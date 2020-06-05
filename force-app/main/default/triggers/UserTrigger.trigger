trigger UserTrigger on User (before insert, before update) {

   /* if(trigger.isUpdate && trigger.isBefore) {
        List<User> lstuser = trigger.new;
        for(User us : lstuser) {
            if(us.Postalcode == '333') {
                us.addError('ofgiegoroghr');

            }
        }
    }*/
}