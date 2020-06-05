({
    doInit : function(component, event, helper) {
        var configurationObject = {};
        var request = {};
		request.Id = "";
        var contextParentIdentifier = component.get("v.contextParentIdentifier");
        if (contextParentIdentifier) {
            request.Id = contextParentIdentifier;
        }
        if (request.Id.indexOf("queryParam")>-1) {
            var queryParamsArray = request.Id.split(".");
            request.Id = "";
            var queryParamName = "";
            if (queryParamsArray.length > 1) {
                queryParamName = queryParamsArray[1];
                queryParamValue = helper.getParameterByName(queryParamName);
                if (queryParamValue) {
                    request.Id = queryParamValue;
                    component.set("v.contextParentIdentifier", request.Id);
                }
            }
        }
        request.IsIdRequired = component.get("v.isIdRequired");
        request.DefaultId = component.get("v.defaultContextParentIdentifier");
        if (!request.Id && request.IsIdRequired && request.DefaultId) {
            request.Id = request.DefaultId;
        }
        request.ShowAllDescendants = component.get("v.showAllDescendants");
        request.GoToItem = false;
        request.Level = 1;
        request.GoUp = false;
        request.GoPrevious = false;
        request.Previous = "";
        request.GoNext = false;
        request.Next = "";
        request.LastParentId = "";
        request.NavigationProviderName = component.get("v.dataProviderName");
        request.ShowSmallImage = helper.showSmallImage(component, event, helper);
        request.BrowserFormFactor = helper.getBrowserFormFactor(component, event, helper);
        configurationObject.request = request;
        //To-Do: Check for LockerServices
        configurationObject.callBackHandler = function(component, event, helper) {
            if (window && window.location && window.location.href && window.location.href.indexOf("commeditor") < 0) {
           		helper.setActiveTab(component, event, helper);
        	}
        };
        
		helper.getNavigationListItems(component, event, helper, configurationObject);
    },
    setActiveTab : function (component, event, helper) {
        helper.setActiveTab(component, event, helper);
    }, 
    handleNavigationMenuChanged: function(component, event, helper) {
        var navigationItem = event.getParams("navigationItem").navigationItem;
        var contextualMenuItems = component.get("v.contextualMenuItems");
        var foundMenuItem = false;
        if (!navigationItem.Name) {
            for (var contextualMenuItemsIndex = 0; contextualMenuItemsIndex < contextualMenuItems.length; contextualMenuItemsIndex++) {
                if (contextualMenuItems[contextualMenuItemsIndex].Id == navigationItem.Id || contextualMenuItems[contextualMenuItemsIndex].Code == navigationItem.Id || contextualMenuItems[contextualMenuItemsIndex].Name == navigationItem.Id) {
					navigationItem = contextualMenuItems[contextualMenuItemsIndex];
                    foundMenuItem = true;
                    break;
                }
            }
        }
        if(foundMenuItem) {
            var event = {};
            event.target = {};
            event.target.innerHTML = navigationItem.Name;
            helper.setActiveTab(component, event, helper);
        }
    }
})