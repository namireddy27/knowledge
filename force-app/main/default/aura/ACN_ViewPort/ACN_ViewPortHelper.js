({
    getCanvasResponse: function(component, event, helper) {
        var action = component.get("c.getSerializedCanvasResponse");

        component.set("v.refreshCanvas", false); 
        
        var request = {};
        request.DataProviderName = component.get("v.dataProviderName");
        request.DataContextId = component.get("v.contextParentIdentifier");
        request.IsCacheEnabled = component.get("v.isCacheEnabled");
        request.IsDataLoadAsynchronous = component.get("v.isDataLoadAsynchronous");
        request.Id = component.get("v.canvasId");
        request.ContainerId = component.get("v.containerId");
        request.ReferenceId = component.get("v.referenceId");
        request.Name = component.get("v.canvasAppName");
        request.Title = component.get("v.title");
        request.DeveloperName = component.get("v.canvasAppDeveloperName");
        request.Border = component.get("v.border");
        request.Width = component.get("v.width");
        request.MaxWidth = component.get("v.maxWidth");
        request.Height = component.get("v.height");
        request.MaxHeight = component.get("v.maxHeight");
        request.Scrolling = component.get("v.scrolling");
        request.DisplayLocation = component.get("v.displayLocation");
        request.DisplaySubLocation = component.get("v.sublocation");
        request.Watermark = component.get("v.watermark");
        request.Parameter = {};
        //debugger;
        var url = location.search;
        /*
        var query = url.substr(1);
        query.split("&").forEach(function(part) {
            var item = part.split("=");
            request.Parameter[item[0]] = decodeURIComponent(item[1]);
        });
        */
        /*
        if (URLSearchParams) {
            try {
                var urlParams = new URLSearchParams(location.search);
                urlParams.forEach(function(value, key) {
                    request.Parameter[key] = value;
                });
            }
            catch(e) {
                //to-do: could not find any parameters
            }
        }
        */
        var regex = /[?&]([^=#]+)=([^&#]*)/g;
        var match;
        while(match = regex.exec(url)) {
            request.Parameter[match[1]] = match[2];
        }
        request.Parameter.browserFormFactor = component.get("v.browserFormFactor");
        request.Parameter.browserIsAndroid = component.get("v.browserIsAndroid");
        request.Parameter.browserIsIOS = component.get("v.browserIsIOS");
        request.Parameter.browserIsIPad = component.get("v.browserIsIPad");
        request.Parameter.browserIsIPhone = component.get("v.browserIsIPhone");
        request.Parameter.browserIsPhone = component.get("v.browserIsPhone");
        request.Parameter.browserIsTablet = component.get("v.browserIsTablet");
        request.Parameter.browserIsWindowsPhone = component.get("v.browserIsWindowsPhone");

        action.setParams(
            {
                serializedRequest: JSON.stringify(request)
            }
        );

        action.setCallback(this, function(response) {
			var state = response.getState();
            //debugger;
			if (component.isValid() && state === "SUCCESS") {
				var canvasResponse = JSON.parse(response.getReturnValue());
                //to-do: pass canvas parameters to canvas app
                //Add any other parameters from the url
                //var parameterList = canvasResponse.Parameter;
                //console.log(JSON.parse(canvasResponse.SerializedParameters));
                //alert(canvasResponse.SerializedParameters);

                component.set("v.canvasAppParameters", canvasResponse.SerializedParameters);
                //component.set("v.canvasAppParameters", canvasResponse.Parameter);
                window.setTimeout($A.getCallback(function() {
                    if(component.isValid()) {
                        component.set("v.refreshCanvas", true);
                    }
                }), 100);                
			}
            else {
                console.log('Error');
                console.log(response.getError());
                console.log(response);
            }
    	});
        
        var isCacheEnabled = component.get("v.isCacheEnabled"); 
        if (isCacheEnabled) {
            action.setStorable();
        }
        var isDataLoadAsynchronous = component.get("v.isDataLoadAsynchronous"); 
        if (isDataLoadAsynchronous) {
            window.setTimeout($A.getCallback(function() {
                if(component.isValid()) {
                    $A.enqueueAction(action);
                }
            }), 100);
        }
        else {
            $A.enqueueAction(action);
        }
    },
	loadViewport: function(component, event, helper) {
        // interact with the DOM here
        var iframeContainerDiv = component.find("iframe");
        if (iframeContainerDiv) {
            var makeIframe = document.createElement("iframe");
            
            var urlFieldName = component.get("v.urlFieldName");
            var recordId = component.get("v.recordId");
            var recordError = component.get("v.recordError");
            var url = component.get("v.currentUrl");
            //debugger;
            if (recordId && urlFieldName && !recordError) {
                //url = "";
            }
            makeIframe.setAttribute("src", url);
            makeIframe.setAttribute("scrolling", component.get("v.scrolling"));
            makeIframe.setAttribute("border", component.get("v.border"));
            //makeIframe.setAttribute("left", component.get("v.left"));
            //makeIframe.setAttribute("top", component.get("v.top"));
            //makeIframe.setAttribute("position", component.get("v.relative"));
            makeIframe.setAttribute("width", component.get("v.width"));
            makeIframe.setAttribute("height", component.get("v.height"));
            iframeContainerDiv.getElement().appendChild(makeIframe);
        }
	}
})