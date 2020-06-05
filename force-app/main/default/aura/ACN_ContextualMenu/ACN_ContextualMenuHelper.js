({
    getNavigationListItems: function(component, event, helper, configurationObject) {
        var action = component.get("c.getSerializedNavigationList");
        
        var request = {};
        if (configurationObject.request.Id) {
            request = configurationObject.request;
        }
        else {
            request.Id = "";
            var contextParentIdentifier = component.get("v.contextParentIdentifier");
            if (contextParentIdentifier) {
                request.Id = contextParentIdentifier;
            }
            if (configurationObject && configurationObject.request && configurationObject.request.Id) {
                request.Id = configurationObject.request.Id;
            }

            if (!request.Id) return;
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
            request.IncludeRecommendations = false;
        }
        
        action.setParams(
            {
                serializedRequest: JSON.stringify(request)
            }
        );
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                var navigationList = JSON.parse(response.getReturnValue());
                var navigationListItemsObject = {};
                
                var navigationListItems = navigationList.Items;
                
                var contextualMenuItems = [];
                var topContextParentIdentifier = component.get("v.topContextParentIdentifier");
                var contextParentIdentifier = component.get("v.contextParentIdentifier");
                if (navigationListItems && navigationListItems.length == 0 && topContextParentIdentifier == contextParentIdentifier) {
                    contextualMenuItems = component.get("v.contextualMenuItems");
                }
                var menuItem = {};
                
                for ( var itemIndex = 0; itemIndex < navigationListItems.length; itemIndex++) {
                    menuItem = {};
                    var navigationListItem = navigationListItems[itemIndex];
                    
                    if (navigationListItem.ImageUrl && navigationListItem.ImageUrl.toLowerCase().indexOf('lightning:icon')>-1) {
                        var lightningIconPartsArray = navigationListItem.ImageUrl.toLowerCase().split('=');
                        var lightningIconAttributes = {};
                        var iconName = "";
                        if (lightningIconPartsArray.length>1) {
                            iconName = lightningIconPartsArray[1];
                            component.set("v.lightningIcon", iconName);
                        }
                        for (var lightningIconPartsArrayIndex = 0; lightningIconPartsArrayIndex < lightningIconPartsArray.length; lightningIconPartsArrayIndex++) {
                            var lightningIconPart = lightningIconPartsArray[lightningIconPartsArrayIndex];
                            
                            var lightningIconAttributePartsArray = lightningIconPart.split(":");
                            var propertyName = lightningIconAttributePartsArray[0];
                            var propertyValue = lightningIconAttributePartsArray[1];
                            lightningIconAttributes[propertyName] = propertyValue;
                        }
                        var size = "small";
                        if (lightningIconAttributes && lightningIconAttributes.size) {
                            size = lightningIconAttributes.size;
                            component.set("v.lightningIconSize", size);
                        }
                        var variant = "brand";
                        if (lightningIconAttributes && lightningIconAttributes.variant) {
                            variant = lightningIconAttributes.variant;
                            component.set("v.lightningIconVariant", variant);
                        }
                        menuItem.IconName = iconName;
                        menuItem.IconSize = size;
                        menuItem.IconVariant = variant;
                    }
                    
                    menuItem.IsActive = navigationListItem.IsDefault;
                    menuItem.Id =  navigationListItem.Id;
                    menuItem.Name = navigationListItem.Name;
                    menuItem.Url = navigationListItem.NavigationTarget;
                    contextualMenuItems.push(menuItem);
                    
                    if (menuItem.IsActive) {
                        component.set("v.lastPressedNavigationListItem", menuItem);
                    }
                    //console.log(navigationListItem);
                }                
                
                //if (contextualMenuItems && contextualMenuItems.Length > 0) {
                component.set("v.contextualMenuItems", contextualMenuItems);                
                //}
                
                if (configurationObject.callBackHandler) {
                    configurationObject.callBackHandler(component, event, helper);
                }
                
                //helper.setActiveTab(component, event, helper);
            }
            else {
                console.log('Error');
                console.log(response.getError());
                console.log(response);
            }
        });
        $A.enqueueAction(action);
    }, 
    setActiveTab: function (component, event, helper) {
        var contextualMenuItems = component.get("v.contextualMenuItems");
        var contextualMenuItemPressed = {};
        //var source = event.getSource();
        //var menuItemName = source.get("v.value");
        var topContextParentIdentifier = component.get("v.topContextParentIdentifier");
        var contextParentIdentifier = component.get("v.contextParentIdentifier");
        var lastPressedNavigationListItem = component.get("v.lastPressedNavigationListItem");
        for (var menuItemIndex = 0; menuItemIndex < contextualMenuItems.length; menuItemIndex++) {
            if (event && event.target && event.target.innerHTML) {
                var menuItemDiv = event.target;
                var pressedMenuItemName = menuItemDiv.innerHTML;
                if (menuItemDiv && menuItemDiv.id && menuItemDiv.id.indexOf(":")>-1) {
                    pressedMenuItemName = menuItemDiv.id.split(':')[1];
                }
                pressedMenuItemName = pressedMenuItemName.replace('&amp;', '&');
                
                contextualMenuItems[menuItemIndex].IsActive = false;
                if (event && event.target && contextualMenuItems[menuItemIndex].Name == pressedMenuItemName || (!event || !event.target) && menuItemIndex == 0 ) {
                    contextualMenuItems[menuItemIndex].IsActive = true;
                    contextualMenuItemPressed = contextualMenuItems[menuItemIndex];
                }                
            }
        }
        component.set("v.contextualMenuItems", contextualMenuItems);
        component.set("v.selectedMenuItem", contextualMenuItemPressed);
        
        if (topContextParentIdentifier == contextParentIdentifier) {
            var contextualMenuItemPressedEvent = component.getEvent("contextualMenuItemPressed");
            contextualMenuItemPressedEvent.setParams({
                contextParentIdentifier: contextualMenuItemPressed.Id,
                contextualMenuItems: contextualMenuItems
            });
            contextualMenuItemPressedEvent.fire();
        }
        
        if (contextualMenuItemPressed) {
            try {
                if(contextualMenuItemPressed.Url) {
                    if (lastPressedNavigationListItem && lastPressedNavigationListItem.Id) {
                        if (contextualMenuItemPressed.Url == '\/\/') {
                            var newURL = window.location.protocol + "//" + window.location.host + ("/" + window.location.pathname).replace('//','/');
                            //console.log(newURL);
                            var hasParameters = false;
                            if (newURL.indexOf('?') > 0) {
                                newURL = newURL.substr(0, newURL.indexOf('?'));
                                hasParameters = true;
                            }
                            if (newURL.indexOf('\/s\/') > 0) {
                                newURL = newURL.substr(0, newURL.indexOf('\/s\/')+3);
                            }
                            if (hasParameters) {
                                window.location.replace(newURL);
                            }
                            else {
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                    "url": "/"
                                });
                                urlEvent.fire();
                            }
                        }
                        else {
                            if (contextualMenuItemPressed.Url == '\/.') {
                                window.location.reload();
                            }
                            else {
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                    "url": contextualMenuItemPressed.Url
                                });
                                urlEvent.fire();
                            }
                        }
                    }
                    else {
                        component.set("v.lastPressedNavigationListItem", contextualMenuItemPressed);
                    }
                }
            }
            catch(ex) {
                console.log(ex);
            }
        }
    }, 
    showSmallImage: function (component, event, helper) {
        var showSmallImage = false;
        var browserFormFactor = component.get("v.browserFormFactor");
        if (browserFormFactor && browserFormFactor == 'PHONE'){
            showSmallImage = true;
        }
        //console.log(showSmallImage);
        return showSmallImage;
    }, 
    getBrowserFormFactor: function (component, event, helper) {
        var browserFormFactor = component.get("v.browserFormFactor");
        if (!browserFormFactor){
            browserFormFactor = "BROWSER";
        }
        return browserFormFactor;
    }
})