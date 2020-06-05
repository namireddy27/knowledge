({
    doInit : function(component, event, helper) {
        var configurationObject = {};
        var contextualMenuesLevels = [];
        var topContextParentIdentifier = component.get("v.topContextParentIdentifier");
        contextualMenuesLevels.push({Name: "1"});
        component.set("v.contextualMenuesLevels", contextualMenuesLevels);
	}, 
    handleContextualMenuItemPressed: function (component, event, helper) {
        /*
            name="topContextParentIdentifier" type="String" description="The Context Menu Item Top Context Parent Identifier."
            name="contextParentIdentifier" type="String" description="The Context Menu Item Context Parent Identifier."
            name="contextIdentifier" type="String" description="The Context Menu Item Context Identifier."
            name="contextualMenuItems" type="ACN_NavigationLibrary.NavigationListItem[]" description="The Items for the contextual menu item pressed."
        */
        var topContextParentIdentifier = event.getParam("topContextParentIdentifier");
        var contextParentIdentifier = event.getParam("contextParentIdentifier");
        var contextIdentifier = event.getParam("contextIdentifier");
        var contextualMenuItems = event.getParam("contextualMenuItems");

        component.set("v.contextualMenuItems", contextualMenuItems);
        component.set("v.pressedContextIdentifier", contextParentIdentifier);
    },
    
    handleBurgerClick : function(cmp, evt, helper) {
        
    }
})