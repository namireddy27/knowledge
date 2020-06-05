global class ACN_ChartDataProvider implements ACN_ChartDataProviderService {
    public class ChartDataProviderNameException extends Exception {

    }

    public static final Map<String, ACN_ChartDataProviderService> ChartDataProviders;
    static {
        ACN_ChartConfiguration__c config = ACN_ChartConfiguration__c.getInstance();
        List<String> chartDataProvidersNames = new List<String>();
        if (config != null && !String.isBlank(config.ChartDataProviderServices__c)) {
            chartDataProvidersNames = config.ChartDataProviderServices__c.split(',');
            for (Integer chartDataProviderNameIndex = 0; chartDataProviderNameIndex < chartDataProvidersNames.size(); chartDataProviderNameIndex++) {
                chartDataProvidersNames[chartDataProviderNameIndex] = chartDataProvidersNames[chartDataProviderNameIndex].trim();
            }
        } 
        
        ChartDataProviders = new Map<String, ACN_ChartDataProviderService>();
        for (String chartDataProviderName : chartDataProvidersNames ) {
            try {
                //System.debug('$$$$$$ chartDataProviderName: ' + chartDataProviderName);
                ChartDataProviders.put(chartDataProviderName, (ACN_ChartDataProviderService)Type.forName(chartDataProviderName).newInstance());
            }
            catch (Exception e) {
                throw new ChartDataProviderNameException (e.getMessage());
                //System.debug('ACN_ChartDataProvider caught Exception: ' + e);
                continue;
            }
        }
    } 

    private ACN_ChartDataProviderService chartDataProvider;
    
    global ACN_ChartDataProvider ( String chartDataProviderName ) {
        system.debug('===> ENTER ACN_ChartDataProviderService\n\t\t\t chartDataProviderName: ' + chartDataProviderName + '\n');
        if (!ChartDataProviders.containsKey(chartDataProviderName)) {
            throw new ChartDataProviderNameException(chartDataProviderName);
        }
        this.chartDataProvider = ChartDataProviders.get(chartDataProviderName);
        //system.debug('===> ENTER ACN_ChartDataProvider(dataProviderName)\n\t\t\t chartDataProviderName: ' + chartDataProviderName + '\n');
    }

    global ACN_ChartLibrary.ChartResponse GetChartResponse (ACN_ChartLibrary.ChartRequest request) {
        return this.chartDataProvider.GetChartResponse (request);
    }
    
    global ACN_ChartLibrary.ChartResponse SavePreference (ACN_ChartLibrary.ChartRequest request) {
        return this.chartDataProvider.SavePreference (request);
    }
    
    global ACN_ChartLibrary.ChartResponse LoadPreference (ACN_ChartLibrary.ChartRequest request) {
        return this.chartDataProvider.LoadPreference (request);
    }
}