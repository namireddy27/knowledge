global class ACN_ChartDataStaticProviderLine implements ACN_ChartDataProviderService {
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
            dataSet.Label = 'My First dataset';
            dataSet.FillColor = 'rgba(220,220,220,0.2)';
            dataSet.StrokeColor = 'rgba(220,220,220,1)';
            dataSet.PointColor = 'rgba(220,220,220,1)';
            dataSet.PointStrokeColor = '#fff';
            dataSet.PointHighlightFill = '#fff';
            dataSet.PointHighlightStroke = 'rgba(220,220,220,1)';
            dataSet.PointValue = new list<integer>{65, 59, 80, 81, 56, 55, 40};
                
            chartSeries.Dataset.add(dataSet);
            
            dataSet = new ACN_ChartLibrary.ChartDataSet();
            dataSet.Label = 'My Second dataset';
            dataSet.FillColor = 'rgba(151,187,205,0.2)';
            dataSet.StrokeColor = 'rgba(151,187,205,1)';
            dataSet.PointColor = 'rgba(151,187,205,1)';
            dataSet.PointStrokeColor = '#fff';
            dataSet.PointHighlightFill = '#fff';
            dataSet.PointHighlightStroke = 'rgba(151,187,205,1)';
            dataSet.PointValue = new list<integer>{28, 48, 40, 19, 86, 27, 90};
                
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