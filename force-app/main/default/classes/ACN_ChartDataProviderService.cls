public interface ACN_ChartDataProviderService {
    ACN_ChartLibrary.ChartResponse GetChartResponse (ACN_ChartLibrary.ChartRequest request);
    ACN_ChartLibrary.ChartResponse SavePreference (ACN_ChartLibrary.ChartRequest request);
    ACN_ChartLibrary.ChartResponse LoadPreference (ACN_ChartLibrary.ChartRequest request);
}