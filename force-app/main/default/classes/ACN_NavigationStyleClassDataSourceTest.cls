@isTest(SeeAllData=true)
public class ACN_NavigationStyleClassDataSourceTest {
    @isTest public static void myTest(){
        ACN_NavigationStyleClassDataSource navStyle = new ACN_NavigationStyleClassDataSource();
         navStyle.getDefaultValue();
        //VisualEditor.DataRow data = navStyle.getDefaultValue();
         navStyle.getValues();
    }
}