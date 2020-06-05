({
    loadChartData: function(component, event, helper, configurationObject) {
        var action = component.get("c.getSerializedChartResponse");
        var request = {};
        
        request.Id = component.get("v.contextParentIdentifier");
        request.ChartId = component.get("v.contextChartIdentifier");
        request.ChartDataProviderName = component.get("v.chartDataProvider");
        request.BrowserFormFactor = component.get("v.browserFormFactor");
        request.ExtendedProperty = {};
        request.Filter = [];
        request.ChartType = component.get("v.chartType");
        
        if (configurationObject && configurationObject.request && configurationObject.request.Id) {
            request = configurationObject.request;
        }
        
        action.setParams(
            {
                serializedRequest: JSON.stringify(request)
            }
        );

        action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
	            var chartResponseString = response.getReturnValue();
                if (chartResponseString == null || chartResponseString == "" || chartResponseString == "[]" || chartResponseString == "{}"){
                    component.set("v.isChartDataEmpty", true);
                    return;
                } else {
                    component.set("v.isChartDataEmpty", false);
                }

                var chartResponse = JSON.parse(chartResponseString);
                var chartSeries = chartResponse.ChartSeries;
				
                var chartData = helper.getConvertedChartData(component, event, helper, {chartSeries: chartSeries});

                var configurationObject = {};
                configurationObject.chartData = chartData;
            	configurationObject.chartOption = {};

            	helper.drawChart(component, event, helper, configurationObject);
            }
            else {
                console.log('Error');
                console.log(response.getError());
                console.log(response);
            }
        });
        
        $A.enqueueAction(action);
    },
    getConvertedChartData: function(component, event, helper, configurationObject) {
        var chartSeries = configurationObject.chartSeries;
        var chartData;
        var chartType = component.get("v.chartType");
        var isSeriesChart = false;
        switch (chartType) {
            case "Pie":
                chartData = [];
                break;
                
            case "Doughnut":
                chartData = [];
                break;
                
            case "Polar Area":
                chartType = "PolarArea";
                component.set("v.chartType", chartType);
                chartData = [];
                break;
                
            case "Bar":
                chartData = {};
                chartData.datasets = [];
                var isSeriesChart = true;
                break;
                
            case "Line":
                chartData = {};
                chartData.datasets = [];
                var isSeriesChart = true;
                break;
                
            case "Radar":
                chartData = {};
                chartData.datasets = [];
                var isSeriesChart = true;
                break;
                
        }
        
        if (chartSeries.Dataset) {
            
        }
        for (var chartSeriesIndex = 0; chartSeriesIndex < chartSeries.Dataset.length; chartSeriesIndex++) {
            var dataset = {};
            if (isSeriesChart) {
                dataset.fillColor = chartSeries.Dataset[chartSeriesIndex].FillColor;
                dataset.strokeColor = chartSeries.Dataset[chartSeriesIndex].StrokeColor;
                dataset.pointColor = chartSeries.Dataset[chartSeriesIndex].PointColor;
                dataset.pointStrokeColor = chartSeries.Dataset[chartSeriesIndex].PointStrokeColor;
                dataset.data = chartSeries.Dataset[chartSeriesIndex].PointValue;
                dataset.label = chartSeries.Dataset[chartSeriesIndex].Label;
                chartData.datasets.push(dataset);
            }
            else {
                dataset.label = chartSeries.Dataset[chartSeriesIndex].Label;
                dataset.value = chartSeries.Dataset[chartSeriesIndex].PointValue[0];
                dataset.color = chartSeries.Dataset[chartSeriesIndex].FillColor;
                dataset.highlight = chartSeries.Dataset[chartSeriesIndex].HighlightColor;
                chartData.push(dataset);
            }
            
        }
        chartData.labels = chartSeries.Labels;
        
        return chartData;
    }, 
    ////
    // Draw chart using chart.js.
    // If chart instance already exists, it will be destroyed and re-created.
	drawChart: function(component, event, helper, configurationObject){
        var chartData = configurationObject.chartData;
        var chartOption = configurationObject.chartOption;
        
        // In case of Line, Bar, Radar.
        if (chartData.datasets != null && chartData.datasets.length > 0){
            var colors = this.getDistributedColor(component, chartData.datasets.length, true);
            var chartLegend = [];
            for (var i=0; i < chartData.datasets.length; i++){
                // If fillColor is null, set it.
                if (chartData.datasets[i].fillColor == null){
                    chartData.datasets[i].fillColor = "RGBA(" + colors[i][0] + "," + colors[i][1] + "," + colors[i][2] + ",0.2)";
                }
                // if strokeColor is null, set it.
                if (chartData.datasets[i].strokeColor == null){
                    chartData.datasets[i].strokeColor = "RGBA(" + colors[i][0] + "," + colors[i][1] + "," + colors[i][2] + ",0.8)";
                }
                // if pointColor is null, set it.
                if (chartData.datasets[i].pointColor == null){
                    chartData.datasets[i].pointColor = "RGBA(" + colors[i][0] + "," + colors[i][1] + "," + colors[i][2] + ",0.8)";
                }
                // if pointStrokeColor is null, set it.
                if (chartData.datasets[i].pointStrokeColor == null){
                    chartData.datasets[i].pointStrokeColor = "#fff";
                }

                // if data is not set, exit.
                if (chartData.datasets[i].data == null || typeof chartData.datasets[i].data != 'object'){
                    console.error("Chart data is corrupted. Required property 'chartData.datasets[" + i + "].data' not found or data format is incorrect.");
                    return;
                }
                
                // Set chart legend.
                if (chartData.datasets[i].label != null && chartData.datasets[i].label != ""){
                    chartLegend.push({
                        label : chartData.datasets[i].label,
                        color : chartData.datasets[i].strokeColor,
                        amount : null
                    });
                }
            }
            component.set("v.chartLegend", chartLegend);
        }

        // In case of Pie, Doughnut, PolarArea.
        if (chartData.length > 0 && chartData[0].value != null){
            var colors = this.getDistributedColor(component, chartData.length, true);
            var chartLegend = [];
            for (i=0; i < chartData.length; i++){
                // If color is null, set it.
                if (chartData[i].color == null){
                    chartData[i].color = "RGBA(" + colors[i][0] + "," + colors[i][1] + "," + colors[i][2] + ",0.8)";
                }

                // If value is not set, exit.
                if (chartData[i].value == null){
                    console.error("Chart data is corrupted. Required property 'chartData[" + i + "].value' not found.");
                    return;
                }
                
                // Set chart legend.
                if (chartData[i].label != null && chartData[i].label != ""){
                    chartLegend.push({
                        label : chartData[i].label,
                        color : chartData[i].color,
                        amount : chartData[i].value
                    });
                }
            }
            component.set("v.chartLegend", chartLegend);
        }

        // Check available Chart Type based on the provided data
        var availableChartTypeList = this.getAvailableChartTypeList(component, chartData);
        component.set("v.availableChartTypeList", availableChartTypeList);

        // If Chart Type is not specified, apply default Chart Type
        var chartType = component.get("v.chartType");
        if (chartType == null || chartType == ""){
            chartType = this.getDefaultChartTypeByAvailableChartTypeList(component, availableChartTypeList);
        }
        component.set("v.chartType", chartType);

        // If chart already exists, we destroy it first and re-create to clean the state.
        var chart = component.get("v.chart");
        if (chart != null){
            chart.destroy();
        }

        // Draw chart.
        var globalId = component.getGlobalId();
        var ctx = document.getElementById(globalId + "_chart").getContext("2d");
        chart = new Chart(ctx)[chartType](chartData, chartOption);
        debugger;

        // Set action on clicking chart segment.
        var chartContainer = document.getElementById(globalId + "_chartContainer");
        chartContainer.onclick = function(evt){
            if (chartType == 'Line' || chartType == 'Radar'){
                var activePoints = chart.getPointsAtEvent(evt);
            } else if (chartType == 'Bar'){
                var activePoints = chart.getBarsAtEvent(evt);
            } else if (chartType == "Pie" || chartType == "Doughnut" || chartType == "PolarArea"){
            	var activePoints = chart.getSegmentsAtEvent(evt);
            }
            var e = $A.get("e.c:ChartjsChartClick");
            e.setParams({
                activePoints: activePoints,
                componentName: component.get("v.componentName"),
                chartType: chartType
            });
            e.fire();
        }

        // Save chart instance, chart data and chart option so that we can refer them afterward. Ex. Those properties are refered when chart type is changed.
        component.set("v.chart", chart);
        component.set("v.chartData", chartData);
        component.set("v.serializedChartData", JSON.stringify(chartData));
        component.set("v.chartOption", chartOption);
    },
    ////
    // Return available chart types based on the provided chart data.
    getAvailableChartTypeList : function(component, chartData){
        if (chartData.length > 0){
            if (chartData[0].value != null && chartData[0].color != null){
                return [
                    {name:"Pie",label:"Pie"},
                    {name:"Doughnut", label:"Doughnut"},
                    {name:"PolarArea", label:"Polar Area"}
                ];
            }
        }
        if (chartData.datasets != null && chartData.labels != null) {
            return [
                {name:"Line",label:"Line"},
                {name:"Bar", label:"Bar"},
                {name:"Radar", label:"Radar"}
            ];
        }
    },
    ////
    // Return the default color based on the available chart types.
    getDefaultChartTypeByAvailableChartTypeList : function(component, availableChartTypeList){
        return availableChartTypeList[0].name;
    },
    ////
    // Method to generate distributed colors for charts.
    // If chart data does not contain color or fillColor property, this method is called and try to set all colors automatically.
    getDistributedColor : function(component, input, thin) {
        var r = 0x0;
        var g = 0x0;
        var b = 0x0;
        var thin_plus = ( thin )? 1:0;
        var colors_array = new Array();
        for( var i=0 ; ; i++ )
        {
                if( Math.pow(i,3) >= input )
                {
                        var max = i - 1 + thin_plus;
                        break;
                }
        }
        
        var _plus = 0xff / max;
        for( var i=thin_plus ; i<=max ; i++ )
        {
                r = _plus * i;
                g = 0x0;
                b = 0x0;
                for( var j=thin_plus ; j<=max ; j++ )
                {
                        g = _plus * j;
                        b = 0x0;
                        for( var k=thin_plus ; k<=max ; k++ )
                        {
                                b = _plus * k;
                                colors_array.push( [ Math.round(r) , Math.round(g) , Math.round(b) ] );
                                if( colors_array.length >= input )return colors_array;
                        }
                        if( colors_array.length >= input )return colors_array;
                }
                if( colors_array.length >= input )return colors_array;
        }
    }, 
    getChartOptions: function(component, event, helper, configurationObject) {
        var fontSize = component.get("v.yAxisFontSize");
        var xAxisFontSize = parseInt ( component.get("v.xAxisFontSize") );
        var yAxisFontSize = parseInt ( component.get("v.yAxisFontSize") );
        debugger;
        var chartOption = {};
        chartOption.tooltips = {};
        chartOption.tooltips.enabled = false;
        chartOption.legend = {};
        chartOption.legend.labels = {};
        chartOption.legend.labels.defaultFontSize; fontSize; 
        chartOption.scales = {};
        chartOption.scales.xAxes = [];
        var xAxes = {};
        xAxes.fontSize = xAxisFontSize;
        xAxes.ticks = {};
        xAxes.ticks.fontSize = xAxisFontSize;
        chartOption.scales.xAxes.push(xAxes);
        chartOption.scales.yAxes = [];
        var yAxes = {};
        yAxes.fontSize = yAxisFontSize;
        yAxes.ticks = {};
        yAxes.ticks.fontSize = yAxisFontSize;
        chartOption.scales.yAxes.push(yAxes);
        chartOption.scales.scaleLabel = {};
        chartOption.scales.scaleLabel.fontSize = fontSize;
		chartOption.animation = true;
		chartOption.customTooltips = false;
        chartOption.scaleFontSize = 12;
        chartOption.scaleShowLabels = false;
        chartOption.showTooltips = false;
        chartOption.tooltipFontSize = fontSize;
        chartOption.tooltipTitleFontSize = fontSize;
		chartOption.responsive = true;
        chartOption.maintainAspectRatio = true;
        
		return chartOption;       
    }
})