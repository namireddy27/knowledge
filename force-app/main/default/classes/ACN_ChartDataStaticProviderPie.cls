global class ACN_ChartDataStaticProviderPie implements ACN_ChartDataProviderService {
    public class ChartDataStaticProviderException extends Exception {

    }
    
    global ACN_ChartLibrary.ChartResponse GetChartResponse (ACN_ChartLibrary.ChartRequest request) {
		ACN_ChartLibrary.ChartResponse response = new ACN_ChartLibrary.ChartResponse();
        
        response.Id = request.Id;
        response.ChartId = request.ChartId;
        response.ChartDataProviderName = request.ChartDataProviderName;
        response.BrowserFormFactor = request.BrowserFormFactor;
        response.ExtendedProperty = request.ExtendedProperty;
        response.Filter = request.Filter;
        response.ChartType = request.ChartType;
            
        try {
            ACN_ChartLibrary.ChartSeries chartSeries = new ACN_ChartLibrary.ChartSeries();
            chartSeries.Labels = new list<string>{'Jan','Feb','Mar','Apr','May','Jun','Jul'};
			chartSeries.Dataset = new List<ACN_ChartLibrary.ChartDataSet>();
            
            ACN_ChartLibrary.ChartDataSet dataSet = new ACN_ChartLibrary.ChartDataSet();
            dataSet.Label = 'Red';
            dataSet.FillColor = '#F7464A';
            dataSet.HighlightColor = '#F7464A';
            dataSet.PointValue = new list<integer>{300};
                
            chartSeries.Dataset.add(dataSet);
            
            dataSet = new ACN_ChartLibrary.ChartDataSet();
            dataSet.Label = 'Green';
            dataSet.FillColor = '#46BFBD';
            dataSet.HighlightColor = '#5AD3D1';
            dataSet.PointValue = new list<integer>{50};
                
            chartSeries.Dataset.add(dataSet);
            
            dataSet = new ACN_ChartLibrary.ChartDataSet();
            dataSet.Label = 'Yellow';
            dataSet.FillColor = '#FDB45C';
            dataSet.HighlightColor = '#FFC870';
            dataSet.PointValue = new list<integer>{100};
                
            chartSeries.Dataset.add(dataSet);
            
            response.ChartSeries = chartSeries;
        }
        catch (Exception Ex) {
            response.RequestException = new ChartDataStaticProviderException(Ex.getMessage());
        }
        
        return response;
    }
    
    global ACN_ChartLibrary.ChartResponse SavePreference (ACN_ChartLibrary.ChartRequest request) {
        return new ACN_ChartLibrary.ChartResponse();
    }
    
    global ACN_ChartLibrary.ChartResponse LoadPreference (ACN_ChartLibrary.ChartRequest request) {
        return new ACN_ChartLibrary.ChartResponse();
    }
}