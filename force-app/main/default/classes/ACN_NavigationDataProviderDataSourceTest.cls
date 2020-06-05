@isTest(SeeAllData=false)
public class ACN_NavigationDataProviderDataSourceTest {
@isTest public static void myTest(){
    ApexClass[] classes = (ApexClass[])[FIND 'ACN_NavigationProviderService' 
                                    IN ALL FIELDS
                                    RETURNING ApexClass(Id, Name)][0];
    system.debug('Query'+classes);
        ACN_NavigationDataProviderDataSource navData = new ACN_NavigationDataProviderDataSource();
         navData.getDefaultValue();
        //VisualEditor.DataRow data = navStyle.getDefaultValue();
         navData.getValues();
    }
}