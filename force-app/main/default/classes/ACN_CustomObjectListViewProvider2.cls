global with sharing class ACN_CustomObjectListViewProvider2  {
  public void getDescription(string appid)
  {
 ///get app it 
 /*    HR_App__c  hrapp = [select id,ExternalHiringStage__c,External_Navigation_Record__r.Name,External_Navigation_Record__c 
                from HR_App__c where id =:appId limit 1];
                 String myrecordType= [select id,ParentNavigationItemId__r.Code__c 
                              from Navigation_Items__c 
                              where Id =:hrapp.External_Navigation_Record__c limit 1].ParentNavigationItemId__r.Code__c;
                              
                               List<Navigation_Items__c> lstName =[select id,name from Navigation_Items__c 
                                            where ParentNavigationItemId__c != null 
                                            and ParentNavigationItemId__r.Code__c  =:myrecordType
                                            order by Order__c ];
   */             
  }
}