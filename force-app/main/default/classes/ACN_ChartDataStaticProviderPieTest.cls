@isTest
public class ACN_ChartDataStaticProviderPieTest {
     @isTest static void ACN_ChartDataStaticProviderPieTestMethod(){
        test.startTest();
        ACN_ChartDataStaticProviderPie chartsDataStaticProvider=new ACN_ChartDataStaticProviderPie();
        ACN_ChartLibrary.ChartRequest testmethod1= new ACN_ChartLibrary.ChartRequest();
        chartsDataStaticProvider.GetChartResponse(testmethod1);
        chartsDataStaticProvider.SavePreference(testmethod1);
        chartsDataStaticProvider.LoadPreference(testmethod1); 
        test.stopTest();
    }

}