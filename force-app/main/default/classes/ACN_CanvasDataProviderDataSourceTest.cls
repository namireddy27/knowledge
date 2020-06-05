@isTest(SeeAllData=false)
public class ACN_CanvasDataProviderDataSourceTest {
    @isTest public static void getDefaultValueTest(){
        ACN_CanvasDataProviderDataSource providersDataSource = new ACN_CanvasDataProviderDataSource();
        providersDataSource.getDefaultValue();
    }

    @isTest public static void getValuesTest(){
        ACN_CanvasDataProviderDataSource providersDataSource = new ACN_CanvasDataProviderDataSource();
        providersDataSource.getValues();
    }
}