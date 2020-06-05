({
    refreshChart: function(component, event, helper, configurationObject) {
        var navigationItem = component.get("v.navigationItem");
        var showChart = component.get("v.showChart");
        var chartDataProvider = component.get("v.chartDataProvider");
        var serializedChartSeries = component.get("v.serializedChartSeries");
        var chartType = component.get("v.chartType");
        var chartTitle = component.get("v.chartTitle");
        var contextParentIdentifier = component.get("v.contextParentIdentifier");
        var showChartTitle = component.get("v.showChartTitle");
        var showChartLegend = component.get("v.showChartLegend");
        var showSeriesBubble = component.get("v.showSeriesBubble");
        var xAxisFontSize = component.get("v.xAxisFontSize");
        var yAxisFontSize = component.get("v.yAxisFontSize");
        
        if (navigationItem && navigationItem.ExtendedProperty){
            if (navigationItem.ExtendedProperty.ShowChart) {
                var extendedPropertyShowChart = navigationItem.ExtendedProperty.ShowChart == 'true' ? true : false;
                
                if (extendedPropertyShowChart && showChart != extendedPropertyShowChart) {
                    showChart = extendedPropertyShowChart;
                }
            }
            
            if (navigationItem.ExtendedProperty.ChartId) {
                var extendedPropertyChartId = navigationItem.ExtendedProperty.ChartId;
                
                if (extendedPropertyChartId && contextParentIdentifier != extendedPropertyChartId) {
                    contextParentIdentifier = extendedPropertyChartId;
                }
            }
            
            if (navigationItem.ExtendedProperty.ChartTitle) {
                var extendedPropertyChartTitle = navigationItem.ExtendedProperty.ChartTitle;
                
                if (extendedPropertyChartTitle && chartTitle != extendedPropertyChartTitle) {
                    chartTitle = extendedPropertyChartTitle;
                }
            }
            
            if (navigationItem.ExtendedProperty.ChartType) {
                var extendedPropertyChartType = navigationItem.ExtendedProperty.ChartType;
                
                if (extendedPropertyChartType && chartType != extendedPropertyChartType) {
                    chartType = extendedPropertyChartType;
                }
            }
            
            if (navigationItem.ExtendedProperty.ChartDataProvider) {
                var extendedPropertyChartDataProvider = navigationItem.ExtendedProperty.ChartDataProvider;
                
                if (extendedPropertyChartDataProvider && chartDataProvider != extendedPropertyChartDataProvider) {
                    chartDataProvider = extendedPropertyChartDataProvider;
                }
            }
            
            if (navigationItem.ExtendedProperty.ChartSeries) {
                var extendedPropertySerializedChartSeries = navigationItem.ExtendedProperty.ChartSeries;
                
                if (extendedPropertySerializedChartSeries && serializedChartSeries != extendedPropertySerializedChartSeries) {
                    serializedChartSeries = extendedPropertySerializedChartSeries;
                }
            }
            
            if (navigationItem.ExtendedProperty.ShowChartTitle) {
                var extendedPropertyShowChartTitle = navigationItem.ExtendedProperty.ShowChartTitle == 'true' ? true : false;
                
                if (extendedPropertyShowChartTitle && showChartTitle != extendedPropertyShowChartTitle) {
                    showChartTitle = extendedPropertyShowChartTitle;
                }
            }

            if (navigationItem.ExtendedProperty.ShowChartLegend) {
                var extendedPropertyShowChartLegend = navigationItem.ExtendedProperty.ShowChartLegend == 'true' ? true : false;
                
                if (extendedPropertyShowChartLegend && showChartLegend != extendedPropertyShowChartLegend) {
                    showChartLegend = extendedPropertyShowChartLegend;
                }
            }

            if (navigationItem.ExtendedProperty.ShowSeriesBubble) {
                var extendedPropertyShowSeriesBubble = navigationItem.ExtendedProperty.ShowSeriesBubble == 'true' ? true : false;
                
                if (extendedPropertyShowSeriesBubble && showSeriesBubble != extendedPropertyShowSeriesBubble) {
                    showSeriesBubble = extendedPropertyShowSeriesBubble;
                }
            }

            if (navigationItem.ExtendedProperty.XAxisFontSize) {
                var extendedPropertyXAxisFontSize = navigationItem.ExtendedProperty.XAxisFontSize;
                
                if (extendedPropertyXAxisFontSize && xAxisFontSize != extendedPropertyXAxisFontSize) {
                    xAxisFontSize = extendedPropertyXAxisFontSize;
                }
            }

            if (navigationItem.ExtendedProperty.YAxisFontSize) {
                var extendedPropertyYAxisFontSize = navigationItem.ExtendedProperty.YAxisFontSize;
                
                if (extendedPropertyYAxisFontSize && yAxisFontSize != extendedPropertyYAxisFontSize) {
                    yAxisFontSize = extendedPropertyYAxisFontSize;
                }
            }
        }
        
        component.set("v.chartDataProvider", chartDataProvider);
        component.set("v.serializedChartSeries", serializedChartSeries);
        component.set("v.chartType", chartType);
        component.set("v.chartTitle", chartTitle);
        component.set("v.contextParentIdentifier", contextParentIdentifier);
        component.set("v.showChart", showChart);
        component.set("v.showChartTitle", showChartTitle);
        component.set("v.showChartLegend", showChartLegend);
        component.set("v.showSeriesBubble", showSeriesBubble);
        component.set("v.xAxisFontSize", xAxisFontSize);
        component.set("v.yAxisFontSize", yAxisFontSize);
    }
})