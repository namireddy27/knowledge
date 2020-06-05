({
	doReload : function(component, event, helper) {
		var CDPath = component.find("CDPath");
        CDPath.refreshPath();
	}
})