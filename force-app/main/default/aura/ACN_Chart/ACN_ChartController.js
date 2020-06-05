({
    doInit : function(component, event, helper){
        if (component.get("v.showLegend") == true){
            component.set("v.chartContainerClass", "pure-u-1-2");
        } else {
            component.set("v.chartContainerClass", "pure-u-1-1");
        }
    },
    createChart : function(component, event, helper){
        var serializedChartData = component.get("v.serializedChartData");
        var configurationObject = {};
        
		var chartOption = helper.getChartOptions(component, event, helper, configurationObject);

        if (serializedChartData) {
            var chartData = JSON.parse(serializedChartData);
            
            configurationObject.chartData = chartData;
            configurationObject.chartOption = chartOption;
            
            helper.drawChart(component, event, helper, configurationObject);
        }
        else {
            var serializedChartSeries = component.get("v.serializedChartSeries");
            if (serializedChartSeries) {
                var chartSeries = JSON.parse(serializedChartSeries);
				var chartData = helper.getConvertedChartData(component, event, helper, {chartSeries: chartSeries});
                component.set("v.serializedChartData", JSON.stringify(chartData));
                component.set("v.chartData", chartData);

                configurationObject.chartData = chartData;
                configurationObject.chartOption = chartOption;
                
                helper.drawChart(component, event, helper, configurationObject);
            }
            else {
                var request = {};
                
                request.Id = component.get("v.contextParentIdentifier");
                request.ChartId = component.get("v.contextChartIdentifier");
                request.ChartDataProviderName = component.get("v.chartDataProvider");
                request.BrowserFormFactor = component.get("v.browserFormFactor");
                request.ExtendedProperty = {};
                request.Filter = [];
                request.ChartType = component.get("v.chartType");
                
                var configurationObject = {};
                configurationObject.request = request;
                
                helper.loadChartData(component, event, helper, configurationObject);            
            }
        }
    },
    updateChart : function(component, event, helper){
        var chartData = event.getParam("chartData");
        var chartOption = {};
        
        var chartOption = {
            legend:{
                labels: {
                    // This more specific font property overrides the global property
                    fontSize: 5
                }                
        	}, 
            scales: {
                xAxes: [{
                    fontSize: 5, 
                    ticks: {
                        fontSize: 5
                    }
                }], 
                yAxes: [{
                    fontSize: 5, 
                    ticks: {
                        fontSize: 5
                    }
                }], 
                scaleLabel: { 
                    fontSize: 5 
                }
            }
        };
        
        var contextChartIdentifier = event.getParam("contextChartIdentifier");
        if (chartData == null || contextChartIdentifier == null){
            helper.loadChartData(component, event, helper, {});
        } else {
            var configurationObject = {};
            configurationObject.chartData = chartData;
            configurationObject.chartOption = chartOption;
            
            helper.drawChart(component, event, helper, configurationObject);
        }
    },
    changeChartType : function(component, event, helper){
        var globalId = component.getGlobalId();
        if (globalId != event.getParam("componentId")){
            return;
        }
        
        // Retrieve chart instance and destroy to clean the canvas.
        var chart = component.get("v.chart");
        chart.destroy();
        
        // Draw new chart with new chart type and existing chart data & option.
        var ctx = document.getElementById(globalId + "_chart").getContext("2d");
        chart = new Chart(ctx)[event.getParam("chartType")](component.get("v.chartData"), component.get("v.chartOption"));
        
        // Set new chart instance to component property.
        component.set("v.chart", chart);
        component.set("v.chartType", event.getParam("chartType"));
    }
})