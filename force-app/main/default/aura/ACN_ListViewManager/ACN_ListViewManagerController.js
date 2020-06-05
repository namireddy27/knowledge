({
    doInit : function(component, event, helper) {
		var placeHolderArray = component.get("v.placeHolderArray");
        if(!placeHolderArray || placeHolderArray.length <= 0) {
            placeHolderArray.push(1);
        }
        component.set("v.placeHolderArray", placeHolderArray);
	}
})