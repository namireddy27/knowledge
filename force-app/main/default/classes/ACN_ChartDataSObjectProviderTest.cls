@isTest
public class ACN_ChartDataSObjectProviderTest {
    @isTest(SeeAllData=true) static void acn_ChartDataSObjectProviderTestMethod(){
        test.startTest();
        ACN_ChartDataSObjectProvider chartsObjectProv=new ACN_ChartDataSObjectProvider();
        ACN_ChartLibrary.ChartRequest testmethod1= new ACN_ChartLibrary.ChartRequest();
        chartsObjectProv.GetChartResponse(testmethod1);
        chartsObjectProv.SavePreference(testmethod1);
        chartsObjectProv.LoadPreference(testmethod1);
        ACN_ChartDataProvider chartDataProvider = new ACN_ChartDataProvider('test');
        ACN_ChartLibrary.ChartResponse testmethod2= new ACN_ChartLibrary.ChartResponse();
        test.stopTest();
    }
}