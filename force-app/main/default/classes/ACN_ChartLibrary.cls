global class ACN_ChartLibrary {
    global class ChartRequest {
        public String Id {get; set;}
        public String ChartId {get; set;}
        public String ChartDataProviderName {get;set;}
        public String BrowserFormFactor {get; set;}
        public Map<String, String> ExtendedProperty {get; set;}
        public List<String> Filter {get; set;}
        global String ChartType {get; set;}
        
        global ChartRequest() {
            this.ExtendedProperty = new Map<String, String>();
            this.Filter = new List<String>();
        }        
    }

    global class ChartResponse {
        public String Id {get; set;}
        public String ChartId {get; set;}
        public String ChartDataProviderName {get;set;}
        public String BrowserFormFactor {get; set;}
        public Map<String, String> ExtendedProperty {get; set;}
        public List<String> Filter {get; set;}
        global String ChartType {get; set;}
        global ChartSeries ChartSeries {get; set;}
        global Exception RequestException {get; set;}
        
        global ChartResponse() {
            this.ChartSeries = new ChartSeries();
            this.ExtendedProperty = new Map<String, String>();
            this.Filter = new List<String>();
        }
    }

    global class ChartSeries {
        global List<String> Labels {get; set;}
        global List<ChartDataSet> Dataset {get; set;}
        
        global ChartSeries() {
            this.Dataset = new List<ChartDataSet>();
        }
    }
    
    global class ChartDataSet {
        global String Label {get; set;}
        global String FillColor {get; set;}
        global String HighlightColor {get; set;}
        global String StrokeColor {get; set;}
        global String PointColor {get; set;}
        global String PointStrokeColor {get; set;}
        global String PointHighlightFill {get; set;}
        global String PointHighlightStroke {get; set;}
        global List<Decimal> PointValue {get; set;}
        
        global ChartDataSet () {
            this.PointValue = new List<Decimal>();
            //this.FillColor = 'white';
            //this.StrokeColor = 'black';
            //this.PointColor = 'red';
        }
    }
    
}