({
    doInit: function(component, event, helper) {
        var firstLayoutItemSize = component.get("v.firstLayoutItemSize");
        var firstLayoutItemSizeArray = component.get("v.firstLayoutItemSizeArray");
        var firstLayoutItemSizeParts = firstLayoutItemSize.split(",");
        for (var sizeIndex in firstLayoutItemSizeParts) {
            var size = firstLayoutItemSizeParts[sizeIndex];
            firstLayoutItemSizeArray.push(size);
        }
        component.set("v.firstLayoutItemSizeArray", firstLayoutItemSizeArray);

        var secondLayoutItemSize = component.get("v.secondLayoutItemSize");
        var secondLayoutItemSizeArray = component.get("v.secondLayoutItemSizeArray");
        var secondLayoutItemSizeParts = secondLayoutItemSize.split(",");
        for (var sizeIndex in secondLayoutItemSizeParts) {
            var size = secondLayoutItemSizeParts[sizeIndex];
            secondLayoutItemSizeArray.push(size);
        }
        component.set("v.secondLayoutItemSizeArray", secondLayoutItemSizeArray);
        
        var thirdLayoutItemSize = component.get("v.thirdLayoutItemSize");
        var thirdLayoutItemSizeArray = component.get("v.thirdLayoutItemSizeArray");
        var thirdLayoutItemSizeParts = thirdLayoutItemSize.split(",");
        for (var sizeIndex in thirdLayoutItemSizeParts) {
            var size = thirdLayoutItemSizeParts[sizeIndex];
            thirdLayoutItemSizeArray.push(size);
        }
        component.set("v.thirdLayoutItemSizeArray", thirdLayoutItemSizeArray);
        
        var navigationItemException = component.get("v.navigationItemException");
        navigationItemException = {};
        navigationItemException.HasError = false;
        navigationItemException.Error = "";
        var designSettingValue = "";
        component.set("v.navigationItemException", navigationItemException);
        
        var navigationItem = component.get("v.navigationItem");
        var navigationItemId = component.get("v.navigationItemId");
        var navigationItemName = component.get("v.navigationItemName");
        var navigationItemDescription = component.get("v.navigationItemDescription");
        var navigationItemImage = component.get("v.navigationItemImage");
        var navigationItemType = component.get("v.navigationItemNavigationType");
        var navigationItemTarget = component.get("v.navigationItemNavigationTarget");

        if (!navigationItem && (navigationItemId || navigationItemName || navigationItemDescription || navigationItemType || navigationItemTarget)) {
            navigationItem = {};
            navigationItem.Id = navigationItemId;
            navigationItem.Name = navigationItemName;
            navigationItem.Description = navigationItemDescription;
            navigationItem.SmallImageUrl = navigationItemImage;
            navigationItem.LargeImageUrl = navigationItemImage;
            navigationItem.NavigationType = navigationItemType;
            navigationItem.NavigationTarget = navigationItemTarget;
            
            switch(navigationItem.NavigationType.toLowerCase()) {
                case "community page":
                    navigationItem.TargetUrl = '/' + navigationItem.NavigationTarget;
                    break;
            }
            
            component.set("v.navigationItem", navigationItem);
        }
        if (navigationItem == null || navigationItem == {} ) {
            navigationItem = {};
            navigationItem.Id = navigationItemId;
            navigationItem.Name = navigationItemName;
            designSettingValue = component.get("v.navigationItemLabel");
            if (typeof designSettingValue !== "undefined") {
                navigationItem.Name = designSettingValue;
                designSettingValue = '';
            }
            navigationItem.Description = '';
            designSettingValue = component.get("v.navigationItemDescription");
            if (typeof designSettingValue !== "undefined") {
                navigationItem.Description = designSettingValue;
                designSettingValue = '';
            }
            navigationItem.Code = '';
            navigationItem.SmallImageUrl = 'no image';
            designSettingValue = component.get("v.navigationItemImageUrl");
            if (typeof designSettingValue !== "undefined") {
                navigationItem.SmallImageUrl = designSettingValue;
                designSettingValue = '';
            }
            navigationItem.LargeImageUrl = 'no image';
            designSettingValue = component.get("v.navigationItemImageUrl");
            if (typeof designSettingValue !== "undefined") {
                navigationItem.LargeImageUrl = designSettingValue;
                designSettingValue = '';
            }
            navigationItem.Link = [];
            navigationItem.TargetUrl = '';
            navigationItem.ContentRows = 1;
            navigationItem.ContentColumns = 1;
            navigationItem.Level = 1;
            navigationItem.GroupName = '';
            navigationItem.StyleClassName = 'navigationCard';
            navigationItem.NavigationType = '';
            designSettingValue = component.get("v.navigationItemNavigationType");
            if (typeof designSettingValue !== "undefined") {
                navigationItem.NavigationType = designSettingValue;
                designSettingValue = '';
            }
            navigationItem.NavigationTarget = '';
            designSettingValue = component.get("v.navigationItemNavigationTarget");
            if (typeof designSettingValue !== "undefined") {
                navigationItem.NavigationTarget = designSettingValue;
                designSettingValue = '';
            }
            navigationItem.NavigationTargetVariable = {};
            navigationItem.ItemContent = [];
            navigationItem.ShowInCarousel = false;
            navigationItem.ShowInNavigationList = true;
        }
        
        var overrideItemClassName = component.get("v.overrideItemClassName");
        var styleClass = component.get("v.styleClass");
        var itemClassName = navigationItem.StyleClassName;
        //debugger;
        if (overrideItemClassName && styleClass) {
            itemClassName = styleClass;
        }
        component.set("v.itemClassName", itemClassName);
        
        if (navigationItem.Scoring && navigationItem.Scoring.length > 0) {
            component.set("v.scoring", JSON.parse(navigationItem.Scoring));
            component.set("v.hasScoring", true);
        }
        if (navigationItem.Badges && navigationItem.Badges.length > 0) {
            component.set("v.badges", JSON.parse(navigationItem.Badges));
        }

        if (navigationItem.ImageUrl && navigationItem.ImageUrl.toLowerCase().indexOf('style')>-1) {
            var imageUrl = navigationItem.ImageUrl;
            var reg = /style="[a-zA-Z0-9:;\.\s\(\)\-\,]*"/gi;
            var matchesStyle = imageUrl.match(reg);
            navigationItem.ImageUrl = navigationItem.ImageUrl.replace(matchesStyle, "");
        }
        
        if (navigationItem.ImageUrl && navigationItem.ImageUrl.toLowerCase().indexOf('url:')>-1) {
            var imageUrl = "<img src='" + navigationItem.ImageUrl.replace("url:","") + "' />";
            navigationItem.ImageUrl = imageUrl
        }

        if (navigationItem.ImageUrl && navigationItem.ImageUrl.toLowerCase().indexOf('lightning:icon')==-1) {
            var imageUrlArray = [];
            var imageUrl = new String (navigationItem.ImageUrl);
            var reg = /<img.*?src="(.*?)"/;
            var matchesDoubleQuote = imageUrl.match(reg);
            if (matchesDoubleQuote && matchesDoubleQuote.length > 0) {
                for (var matchesDoubleQuoteIndex = 0; matchesDoubleQuoteIndex < matchesDoubleQuote.length; matchesDoubleQuoteIndex++) {
                    var matchesDoubleQuoteString = matchesDoubleQuote[matchesDoubleQuoteIndex];
                    if (matchesDoubleQuoteString.indexOf("src=")===-1) {
                        imageUrlArray.push(matchesDoubleQuoteString);
                    }
                }
            }
            reg = /<img.*?src='(.*?)'/;
            var matchesSingleQuote = imageUrl.match(reg);
            if (matchesSingleQuote && matchesSingleQuote.length > 0) {
                for (var matchesSingleQuoteIndex = 0; matchesSingleQuoteIndex < matchesSingleQuote.length; matchesSingleQuoteIndex++) {
                    var matchesSingleQuoteString = matchesSingleQuote[matchesSingleQuoteIndex];
                    if (matchesSingleQuoteString.indexOf("src=")===-1) {
                        imageUrlArray.push(matchesSingleQuoteString);
                    }
                }
            }
            var navigationItemMaskedImageUrl = "";
            if (imageUrlArray && imageUrlArray.length > 0) {
                navigationItemMaskedImageUrl = imageUrlArray[0];
            }
            navigationItemMaskedImageUrl = navigationItemMaskedImageUrl.replace(/&amp;/gi,"&");
            if (navigationItemMaskedImageUrl.indexOf("/servlet")>-1 && navigationItemMaskedImageUrl.indexOf("sfsites/c")===-1) {
                navigationItemMaskedImageUrl = navigationItemMaskedImageUrl.replace("/servlet", "/sfsites/c/servlet");
            }
            component.set("v.navigationItemMaskedImageUrl", navigationItemMaskedImageUrl);
        }

        if (navigationItem.ImageUrl && navigationItem.ImageUrl.toLowerCase().indexOf('lightning:icon')>-1) {
            var lightningIconPartsArray = navigationItem.ImageUrl.toLowerCase().split('=');
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
        }
    },
    onClickEventHandler : function(component, event, helper) {
        var isNavigationEnabled = component.get("v.isNavigationEnabled");
        if (!isNavigationEnabled) {
            return;
        }
        var pressedNavigationItem = component.get("v.navigationItem");
        if (!pressedNavigationItem) {
            return;
        }
        var inactiveTargetIdentifier = component.get("v.inactiveTargetIdentifier");
        if (pressedNavigationItem.NavigationTarget == inactiveTargetIdentifier) {
            return;
        }
        
        var isStandAlone = component.get("v.isStandAlone");
        if (isStandAlone) {
            if(pressedNavigationItem.NavigationTarget && pressedNavigationItem.NavigationType != "Preview") {
                switch(pressedNavigationItem.NavigationType.toLowerCase()) {
                    case "community page":
                        if (pressedNavigationItem.NavigationTarget == '\/.') {
                            window.location.reload();
                        }
                        else {
                            var newURL = window.location.protocol + "//" + window.location.host + ("/" + window.location.pathname).replace('//','/');
                            //console.log(newURL);
                            if (newURL.indexOf('?') > 0) {
                                newURL = newURL.substr(0, newURL.indexOf('?'));
                            }
                            if (newURL.indexOf('\/s\/') > 0) {
                                newURL = newURL.substr(0, newURL.indexOf('\/s\/')+3);
                            }
                            
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                "url": newURL + pressedNavigationItem.NavigationTarget
                            });
                            urlEvent.fire();
                            //window.location.reload();
                        }
						break;

                    case "url":
                        if (pressedNavigationItem.NavigationTarget == '\/\/') {
                            var newURL = window.location.protocol + "//" + window.location.host + ("/" + window.location.pathname).replace('//','/');
                            //console.log(newURL);
                            if (newURL.indexOf('?') > 0) {
                                newURL = newURL.substr(0, newURL.indexOf('?'));
                            }
                            if (newURL.indexOf('\/s\/') > 0) {
                                newURL = newURL.substr(0, newURL.indexOf('\/s\/')+3);
                            }
                            window.location.replace(newURL);
                        }
                        else {
                            if (pressedNavigationItem.NavigationTarget == '\/.') {
                                window.location.reload();
                            }
                            else {                
                                var urlEvent = $A.get("e.force:navigateToURL");
                                urlEvent.setParams({
                                    "url": pressedNavigationItem.NavigationTarget
                                });
                                urlEvent.fire();
                                //window.location.reload();
                            }
                        }
                        break;
                        
                }
            }            
        }
        else {
            var navigationListItemPressedEvent = component.getEvent("navigationListItemPressed");
            navigationListItemPressedEvent.setParams({
                navigationItem: pressedNavigationItem
            });
            navigationListItemPressedEvent.fire();
        }
        
        var notifyNavigationToMenu = component.get("v.notifyNavigationToMenu");
        if (notifyNavigationToMenu) {
            var navigationMenuChangedEvent = $A.get("e.c:ACN_NavigationMenuChanged");
            if (navigationMenuChangedEvent) {
                navigationMenuChangedEvent.setParams({
                    navigationItem: pressedNavigationItem
                });
                navigationMenuChangedEvent.fire();
            }
        }
        
        var contentPreviewIdentifier = component.get("v.contentPreviewIdentifier");
        if (contentPreviewIdentifier) {
            var navigationItemContentPreviewPressedEvent = $A.get("e.c:ACN_NavigationItemContentPreviewPressed");
            if (navigationItemContentPreviewPressedEvent) {
                navigationItemContentPreviewPressedEvent.setParams({
                    navigationItem: pressedNavigationItem,
                    contentPreviewIdentifier: contentPreviewIdentifier
                });
                navigationItemContentPreviewPressedEvent.fire();
            }
        }
    },
    handleElementPressed: function(component, event, helper) {
        var navigationItem = component.get("v.navigationItem");

        var inactiveTargetIdentifier = component.get("v.inactiveTargetIdentifier");
        if (navigationItem.NavigationTarget == inactiveTargetIdentifier) {
            return;
        }
        
        if (navigationItem.NavigationTarget) {
            var lightningEvent = $A.get(navigationItem.NavigationTarget);
            var lightningParameters = {};
            if (lightningEvent) {
                if (navigationItem.SerializedNavigationTargetVariable) {
                    var serializedEventParameters = navigationItem.SerializedNavigationTargetVariable;

                    if (serializedEventParameters.indexOf("\{"  + "!" + "eventSource" + "\}")>-1) {
                        serializedEventParameters = serializedEventParameters.replace("\{"  + "!" + "eventSource" + "\}", navigationItem.Id);
                    }

                    try {
                        lightningParameters = JSON.parse(serializedEventParameters);
                        lightningEvent.setParams(lightningParameters);
                        console.log(lightningParameters);
                    } 
                    catch(e) {
                        
                    }
                }
                else {
                    if (navigationItem.NavigationTargetVariable) {
                        //To-Do: json parse might be needed in other browsers?
                        //lightningParameters = JSON.parse(navigationItem.NavigationTargetVariable);
                        lightningParameters = navigationItem.NavigationTargetVariable;
                        lightningEvent.setParams(lightningParameters);
                    }
                }
                lightningEvent.fire();                        
            }
        }
    }
})