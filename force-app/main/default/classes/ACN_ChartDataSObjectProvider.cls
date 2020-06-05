global class ACN_ChartDataSObjectProvider implements ACN_ChartDataProviderService {
    public class ChartDataSObjectProviderException extends Exception {

    }
    
    global ACN_ChartLibrary.ChartResponse GetChartResponse (ACN_ChartLibrary.ChartRequest request) {
        return new ACN_ChartLibrary.ChartResponse();
    }
    
    global ACN_ChartLibrary.ChartResponse SavePreference (ACN_ChartLibrary.ChartRequest request) {
        return new ACN_ChartLibrary.ChartResponse();
    }
    
    global ACN_ChartLibrary.ChartResponse LoadPreference (ACN_ChartLibrary.ChartRequest request) {
        return new ACN_ChartLibrary.ChartResponse();
    }
}