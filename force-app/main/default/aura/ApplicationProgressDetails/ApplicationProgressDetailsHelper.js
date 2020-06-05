({
    scriptsLoaded : function(component, event, helper) {
        
        Chart.Chart.pluginService.register({
            beforeDraw: function(chart) {
                if (chart.config.centerText.display !== null &&
                    typeof chart.config.centerText.display !== 'undefined' &&
                    chart.config.centerText.display) {
                    var width = chart.chart.width,
                        height = chart.chart.height,
                        ctx = chart.chart.ctx;
                    
                    ctx.restore();
                    var fontSize = (height / 70).toFixed(2);
                    ctx.font = fontSize + "em sans-serif";
                    ctx.textBaseline = "middle";
                    
                    var text = chart.config.centerText.text,
                        textX = Math.round((width - ctx.measureText(text).width) / 2),
                        textY = height / 2;
                    
                    ctx.fillText(text, textX, textY);
                    ctx.save();
                }
            },
        });

         
                var Percentage_Complete =component.get('v.nvRecord.Percentage_Complete__c');
                var restItem = 100 - Percentage_Complete;
                
                var config = {
                    type: 'doughnut',
                    data: {
                        datasets: [{
                            data: [
                                // Transposed here for status bar
                                Percentage_Complete,
                                restItem
                             ],
                            backgroundColor: [
                                // Transposed here for status bar
                                '#4BCA81',
                                '#16325C'
                            ],
                        }],
                        labels: [
                            "Completed",
                            "Incomplete" + ''
                        ]
                    },
                    options: {
                        responsive: true,
                        legend: {
                            display: false,
                        },
                        title: {
                            display: false,
                        },
                        animation: {
                            animateScale: true,
                            animateRotate: true
                        },
                        cutoutPercentage: 65
                    },
                    centerText: {
                        display: true,
                        text: Percentage_Complete + "%"
                    }
                };
                var ctx = document.getElementById('chart-area').getContext('2d');
                
                window.myDoughnut = new Chart(ctx, config);
                ctx.fillText('10%', 100, 100, 200);
            }
//        });
//        $A.enqueueAction(action);
//    }
})