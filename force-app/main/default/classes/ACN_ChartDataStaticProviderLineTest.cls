@isTest
public class ACN_ChartDataStaticProviderLineTest {
     @isTest static void acn_ChartDataStaticProviderLineTestMethod(){
        test.startTest();
        ACN_ChartDataStaticProviderLine chartsDataStaticProvider=new ACN_ChartDataStaticProviderLine();
        ACN_ChartLibrary.ChartRequest testmethod1= new ACN_ChartLibrary.ChartRequest();
        chartsDataStaticProvider.GetChartResponse(testmethod1);
        chartsDataStaticProvider.SavePreference(testmethod1);
        chartsDataStaticProvider.LoadPreference(testmethod1);
        test.stopTest();
    }

}