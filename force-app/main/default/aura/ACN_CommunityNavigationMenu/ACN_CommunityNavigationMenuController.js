({
    doInit: function(component, event, helper) {
        helper.getNavigationListItems(component, event, helper);
    }, 
    navigationMenuItemPressed: function(component, event, helper) {
        var id = event.target.dataset.menuItemId;
        if (id) {
            component.getSuper().navigate(id);
        }
        component.set("v.layoutMultipleRows", true);
    }
})