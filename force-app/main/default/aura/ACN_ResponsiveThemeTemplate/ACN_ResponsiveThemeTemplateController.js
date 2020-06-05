({
	doInit: function(component, event, helper) {
        /*component.set("v.browserFormFactor", "PHONE");*/
        
        helper.populateSizeArrays(component, event, helper);
        
        var showTop = component.get("v.showTop");
        component.set("v.showTop", !showTop);
        component.set("v.showTop", showTop);
	}, 
    handleBrowserFormFactorChanged: function(component, event, helper) {
        var browserFormFactor = $A.get("$Browser.formFactor"); //event.getParam("browserFormFactor");
        var currentBrowserFormFactor = component.get("v.browserFormFactor");
        console.log("currentBrowserFormFactor: " + currentBrowserFormFactor);

        if (browserFormFactor != currentBrowserFormFactor) {
            component.set("v.browserFormFactor", browserFormFactor);
        }
    }
})