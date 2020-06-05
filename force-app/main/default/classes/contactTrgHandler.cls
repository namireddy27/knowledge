/**
 * This class is for Contact Trigger logic
 * It has diff methods to execute diff scenarios on Contact events
 * */
public class contactTrgHandler {
    //This method is to check whether the contact got deactivated on update
	public static void checkForInactiveCons(List<Contact> list_ConsNew,Map<Id,Contact> map_ConsOld)
    {
        Set<Id> set_ConIds = new Set<Id>();
    	for(Contact con : list_ConsNew)
        {
            //Checking for activated status
        	if(con.Delete__c)// && !map_ConsOld.get(con.Id).Delete__c
            {
                set_ConIds.add(con.Id);
            }
        }
        if(set_ConIds.size() > 0) deleteContacts(set_ConIds);
    }
    
    //This method is to delete deactivated contacts
    //@future
    public static void deleteContacts(Set<Id> set_ConIds)
    {
        Delete [SELECT Id FROM Contact WHERE Id IN: set_ConIds];
    }
}