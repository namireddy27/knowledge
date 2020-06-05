trigger contactTrg on Contact (after insert) 
{
    if(Trigger.IsAfter)
    {
        if(Trigger.IsUpdate)
        {
            contactTrgHandler.checkForInactiveCons(Trigger.New,Trigger.OldMap);
        }
    }
}