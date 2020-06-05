({
    reloadNavigationList: function(component, event, helper) {
        component.set("v.isListEmpty", false);
        var configurationObject = {};
        configurationObject.request = {};
        configurationObject.callBackHandler = false;
        configurationObject.request = helper.getRequestTemplate(component, event, helper, configurationObject);
        
        var navigationListRowSize = component.get("v.navigationListRowSize");
        if (!navigationListRowSize) {
            navigationListRowSize = 0;
        }
        var columnWidth = "";
        var maxColumnWidth = 30;
        if (navigationListRowSize > 0) {
            maxColumnWidth = 100 / navigationListRowSize;
            columnWidth = "width: " + maxColumnWidth + '%;';
        }
        
        component.set("v.navigationListRowSize", navigationListRowSize);
        component.set("v.maxColumnWidth", maxColumnWidth);
        component.set("v.columnWidth", columnWidth);

        component.set("v.isListEmpty", false);
        
		helper.getNavigationListItems(component, event, helper, configurationObject);
        helper.getCurrentUserId(component, event, helper);
	},
	getNavigationListItems: function(component, event, helper, configurationObject) {
		var action = component.get("c.getSerializedNavigationList");
		var isCacheEnabled = component.get("v.isCacheEnabled"); 
        if (isCacheEnabled) {
            action = component.get("c.getSerializedNavigationListCached");
        }
        component.set("v.isListEmpty", false);
        var selectedPage = parseInt(component.get("v.navigationListSelectedPage"));
        var pageSize = parseInt(component.get("v.navigationListPageSize"));
        var carouselIntervalInSeconds = parseInt(component.get("v.carouselIntervalInSeconds"));
        var request = helper.getRequestTemplate(component, event, helper, configurationObject);
		action.setParams(
            {
                serializedRequest: JSON.stringify(request)
            }
        );
		
        var navigationListPageSize = component.get("v.navigationListPageSize");

        action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var navigationList = JSON.parse(response.getReturnValue());
				var navigationListItemsObject = {};
				var navigationListItemGroups = [];
				var groupIndex = 0;
				var groupIndexes = [];
				var navigationListItems = navigationList.Items;
                var filterItems = navigationList.FilterItem;
                var navigationListItemsPage = [];
                var carouselItems = [];
                var showLoadMore = false;
                
                if (request.ExtendedProperty) {
	                component.set("v.extendedProperty", request.ExtendedProperty);
                }
	            component.set("v.isInitialLoad", request.IsInitialLoad);

                component.set("v.sortDirection", navigationList.CurrentSortDirection);
                navigationListItems = helper.sortListItems(component, event, helper, {"navigationListItems": navigationListItems});

                if (navigationList.GroupItemGridSize) {
                    component.set("v.groupsGridLayoutItemSize", navigationList.GroupItemGridSize);
                }
                var groupsGridLayoutItemSizeArray = component.get("v.groupsGridLayoutItemSizeArray");
                var groupsGridLayoutItemSizeArrayParts = [];
                if (navigationList.GroupItemGridSize) {
                    groupsGridLayoutItemSizeArrayParts = navigationList.GroupItemGridSize.split(",");
                }
                if (groupsGridLayoutItemSizeArray.length < 1) {
                    groupsGridLayoutItemSizeArray.push(groupsGridLayoutItemSizeArray[0]);
                }
                if (groupsGridLayoutItemSizeArray.length < 2 ) {
                    groupsGridLayoutItemSizeArray.push(groupsGridLayoutItemSizeArray[1]);
                }
                if (groupsGridLayoutItemSizeArray.length < 3 ) {
                    groupsGridLayoutItemSizeArray.push(groupsGridLayoutItemSizeArray[2]);
                }
                if (groupsGridLayoutItemSizeArray.length < 4 ) {
                    groupsGridLayoutItemSizeArray.push(groupsGridLayoutItemSizeArray[3]);
                }
                if (navigationList.GroupItemGridSizeDefault && navigationList.GroupItemGridSizeDefault !== "-1") {
                    groupsGridLayoutItemSizeArray[0] = navigationList.GroupItemGridSizeDefault;
                }
                if (navigationList.GroupItemGridSizeDesktop && navigationList.GroupItemGridSizeDesktop !== "-1") {
                    groupsGridLayoutItemSizeArray[1] = navigationList.GroupItemGridSizeDesktop;
                }
                if (navigationList.GroupItemGridSizeTablet && navigationList.GroupItemGridSizeTablet !== "-1") {
                    groupsGridLayoutItemSizeArray[2] = navigationList.GroupItemGridSizeTablet;
                }
                if (navigationList.GroupItemGridSizePhone && navigationList.GroupItemGridSizePhone !== "-1") {
                    groupsGridLayoutItemSizeArray[3] = navigationList.GroupItemGridSizePhone;
                }
                component.set("v.groupsGridLayoutItemSizeArray", groupsGridLayoutItemSizeArray);
                
                var isLastItemPresent = component.get("v.isLastItemPresent");
                if (!navigationListItems || !navigationListItems.length || navigationListItems.length == 0) {
	                component.set("v.isListEmpty", true);
                    isLastItemPresent = true;
                }
                else {
                    var isInfiniteLoading = component.get("v.isInfiniteLoading");
                    var pageSize = component.get("v.pageSize");
                    
                    if (navigationList.hasOwnProperty("IsLastItemPresent") && typeof navigationList.IsLastItemPresent !== "undefined") {
                        isLastItemPresent = navigationList.IsLastItemPresent;
                    }
                }
                component.set("v.isLastItemPresent", isLastItemPresent);
                
                if (navigationList.PageSize) {
                    component.set("v.pageSize", navigationList.PageSize);
                }
                if (navigationList.CurrentPage) {
                    component.set("v.currentPage", navigationList.CurrentPage);
                }
                if (navigationList.ItemsOffset) {
                    component.set("v.itemsOffset", navigationList.ItemsOffset);
                }
                if (navigationList.hasOwnProperty("IsInfiniteLoading")) {
                    component.set("v.isInfiniteLoading", navigationList.IsInfiniteLoading);
                }
                
                var sortingItems = navigationList.SortingItem;
                var serializedSorting = [];

                if (sortingItems && sortingItems.length > 0) {
                    for (var sortingItemIndex in sortingItems) {
                        var sortingItem = sortingItems[sortingItemIndex];
                        serializedSorting.push(JSON.stringify(sortingItem));
                    }
                    component.set("v.serializedSorting", serializedSorting);
                }

                var selectedItemIdentifier = component.get("v.selectedItemIdentifier");
                if (selectedItemIdentifier.indexOf("queryParam.")>-1) {
                    selectedItemIdentifier = helper.getParameterByName(selectedItemIdentifier);
                }
                else {
                    if (navigationList.ParentId && !selectedItemIdentifier) {
                        selectedItemIdentifier = navigationList.ParentId;
                    }
                }
                
                var groupNames = {};
				for ( var itemIndex = 0; itemIndex < navigationListItems.length; itemIndex++) {
                    var navigationListItem = navigationListItems[itemIndex];
                    if (!navigationListItem.ItemGridSize) {
                        navigationListItem.ItemGridSize = component.get("v.groupLayoutItemBodySize");
                    }
                    if (navigationListItem.ItemGridSize) {
                        var itemGridSize  = navigationListItem.ItemGridSize;
                        var itemGridSizeArray  = [];
                        if (itemGridSize) {
                            itemGridSizeArray = itemGridSize.split(",");
                        }
                        if (itemGridSize && itemGridSizeArray.length > 0) {
                            navigationListItem.ItemGridSizeDefault = itemGridSizeArray[0];
                            navigationListItem.ItemGridSizeDesktop = itemGridSizeArray[0];
                            navigationListItem.ItemGridSizeTablet = itemGridSizeArray[0];
                            navigationListItem.ItemGridSizePhone = itemGridSizeArray[0];
                        }
                        if (itemGridSize && itemGridSizeArray.length > 1) {
                            navigationListItem.ItemGridSizeDesktop = itemGridSizeArray[1];
                        }
                        if (itemGridSize && itemGridSizeArray.length > 2) {
                            navigationListItem.ItemGridSizeTablet = itemGridSizeArray[2];
                        }
                        if (itemGridSize && itemGridSizeArray.length > 3) {
                            navigationListItem.ItemGridSizePhone = itemGridSizeArray[3];
                        }
                    }
                    
                    if (!navigationListItem.IsSelected) {
                        if (selectedItemIdentifier && (selectedItemIdentifier == navigationListItem.Id || selectedItemIdentifier == navigationListItem.Code || selectedItemIdentifier == navigationListItem.Name) ) {
                            navigationListItem.IsSelected = true;
                        }
                        else {
                            navigationListItem.IsSelected = false;
                        }
                    }
                    if (navigationListItem.ShowInNavigationList) {
                        //to-do - id list item = true
                        var groupName = navigationListItem.GroupName;
                        if (!groupName) {
                            groupName = "none";
                        }
                        if (groupNames[groupName] == undefined) {
                            groupNames[groupName] = []
                        }
                        groupNames[groupName].push(navigationListItem);
					}
                    if (navigationListItem.ShowInCarousel) {
                        carouselItems.push(navigationListItem);
                    }
				}
				for ( var carouselItemIndex = 0; carouselItemIndex < carouselItems.length; carouselItemIndex++) {
                    var navigationListItem = carouselItems[carouselItemIndex];
                    if (carouselItemIndex >= selectedPage * navigationListPageSize - navigationListPageSize && carouselItemIndex < selectedPage * navigationListPageSize ) {
                        navigationListItemsPage.push(navigationListItem);
                    }
                }
                
                //Check if group extended information has been provided
                var navigationListGroups = {};
                if (navigationList.GroupItems) {
                    navigationListGroups = navigationList.GroupItems;
                }
                var navigationListFooterGroups = {};
                if (navigationList.GroupFooterItems) {
                    navigationListFooterGroups = navigationList.GroupFooterItems;
                }
                for (groupName in groupNames) {
					var group = {};
					group.Name = groupName;
					group.Index = parseInt(groupIndex);
                    group.groupItems = {};
                    group.groupItems.Items = groupNames[groupName];
					groupIndexes.push(group.Index);
                    if (navigationListGroups && navigationListGroups[groupName]) {
                        group.NavigationItem = navigationListGroups[groupName];
                    }
                    if (navigationListFooterGroups && navigationListFooterGroups[groupName]) {
                        group.Footer = {};
                        group.Footer.NavigationItem = navigationListFooterGroups[groupName];
                    }
					navigationListItemGroups.push(group);
					groupIndex++;
                }

                var navigationListTotalPages = parseInt(carouselItems.length / pageSize);
                if ( carouselItems.length % pageSize > 0) {
                    navigationListTotalPages++;
                }
                var navigationListTotalPageArray = [];
                for(var pageCount = 1; pageCount <= navigationListTotalPages; pageCount++){
                    navigationListTotalPageArray.push(pageCount);
                }
                //debugger;
                component.set("v.groupIndexes", groupIndexes);
				component.set("v.navigationListItems", navigationListItems);
				component.set("v.navigationListItemGroups", navigationListItemGroups);
				component.set("v.navigationListItemsPage", navigationListItemsPage);
				component.set("v.carouselItems", carouselItems);
				component.set("v.navigationListTotalPages", navigationListTotalPages);
                component.set("v.navigationListTotalPageArray", navigationListTotalPageArray);
                component.set("v.lastCarouselDirection", "next");
                component.set("v.filterItems", filterItems);

                var componentId = component.get("v.componentId");
                
                var isFilterListLoaded = component.get("v.isFilterListLoaded");
                if (!isFilterListLoaded) {
                    var filterContextIdentifier = component.get("v.filterContextIdentifier");
                    var navigationFilterValuesChangedEvent = $A.get("e.c:ACN_NavigationFilterValuesChanged");
                    if (navigationFilterValuesChangedEvent) {
                        navigationFilterValuesChangedEvent.setParams({
                            filterItems: filterItems, 
                            filterContextIdentifier: filterContextIdentifier
                        });
                        navigationFilterValuesChangedEvent.fire();
                        component.set("v.isFilterListLoaded", true);
                    }
                }
                
                if (configurationObject.callBackHandler) {
					configurationObject.callBackHandler(component, event, helper);
                }
                
                if (carouselIntervalInSeconds > 0 && carouselItems.length > 1) {
                    helper.spinCarousel(component, event, helper);
                }
                
                if (navigationList.DoRefreshAll) {
                    var navigationListRefreshAllRequestedEvent = $A.get("e.c:ACN_NavigationListRefreshAllRequested");
                    navigationListRefreshAllRequestedEvent.fire();
                }

                var selectionContextIdentifier = component.get("v.selectionContextIdentifier");
                if (selectionContextIdentifier) {
                    var selectedNavigationItemRequested = $A.get("e.c:ACN_SelectedNavigationItemRequested");
                    if (selectedNavigationItemRequested) {
                        selectedNavigationItemRequested.setParams({
                            selectionContextIdentifier: selectionContextIdentifier
                        });
                        selectedNavigationItemRequested.fire();
                    }        
                }
			}
            else {
                console.log('Error');
                console.log(response.getError());
                console.log(response);
            }
	        helper.hideLoadingMessage(component, event, helper);
    	});
        helper.showLoadingMessage(component, event, helper);
        
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
    sortListItems: function(component, event, helper, configurationObject) {
        var sortDirection = component.get("v.sortDirection");

        function compare(firstElement, secondElement) {
            var firstElementSortName = "";
            var secondElementSortName = "";
            var comparison = 0;
            
            if (sortDirection !== "none") {
                if (firstElement.SortName) {
                    firstElementSortName = sortDirection === "ascending" ? firstElement.SortName.toUpperCase() : secondElement.SortName.toUpperCase();
                }
                if (secondElement.SortName) {
                    secondElementSortName = sortDirection === "ascending" ? secondElement.SortName.toUpperCase() : firstElement.SortName.toUpperCase();
                }
                if (firstElementSortName > secondElementSortName) {
                    comparison = 1;
                } else if (firstElementSortName < secondElementSortName) {
                    comparison = -1;
                }
            }
            return comparison;
        }
        
        if (configurationObject && configurationObject.navigationListItems) {
            configurationObject.navigationListItems.sort(compare);
        }
        return configurationObject.navigationListItems;
    },
    handleSelectedNavigationItemResponseReturned: function(component, event, helper) {
        var navigationListItems = component.get("v.navigationListItems");
        var selectionContextIdentifier = component.get("v.selectionContextIdentifier");
        var eventSelectionContextIdentifier = event.getParam("selectionContextIdentifier");
        var eventLastSelectedNavigationItem = event.getParam("navigationItem");

        if (selectionContextIdentifier && eventSelectionContextIdentifier && selectionContextIdentifier == eventSelectionContextIdentifier ) {
            for (var navigationListItemsIndex = 0; navigationListItemsIndex < navigationListItems.length; navigationListItemsIndex++) {
                navigationListItems[navigationListItemsIndex].IsSelected = false;
                if (eventLastSelectedNavigationItem && eventLastSelectedNavigationItem.Id && eventLastSelectedNavigationItem.Id == navigationListItems[navigationListItemsIndex].Id) {
                    navigationListItems[navigationListItemsIndex].IsSelected = true;
                    //console.log('Navigation Item Selected is: ' + navigationListItems[navigationListItemsIndex].Name);
                }
            }
        }
        component.set("v.navigationListItems", navigationListItems);
    },
	spinCarousel: function(component, event, helper) {
        var carouselIntervalInSeconds = parseInt(component.get("v.carouselIntervalInSeconds"));
        var intervalId = component.get("v.intervalId");
        var carouselItems = component.get("v.carouselItems");
        
        if (carouselIntervalInSeconds > 0 && carouselItems.length > 1) {
            if (intervalId == -1) {
                component.set("v.navigationListSelectedPage", 1);
                intervalId = window.setInterval(
                        $A.getCallback(function() {
                            var currentIntervalId = component.get("v.intervalId");
                            var carouselItems = component.get("v.carouselItems");
                            if (currentIntervalId != -1 && carouselItems && carouselItems.length < 2) {
                                window.clearInterval(currentIntervalId);
                                currentIntervalId = -1;
                                component.set("v.intervalId", currentIntervalId);
                            }
                            else {
                                helper.buttonNextPressed(component, event, helper);
                            }
                            
                        }), carouselIntervalInSeconds * 1000
                    );
            }
        }
        else {
            if (intervalId != -1) {
                window.clearInterval(intervalId);
                intervalId = -1;
            }
        }

        component.set("v.intervalId", intervalId);
    }, 
    buttonPreviousPressed: function(component, event, helper) {
        if (component.isValid()) {
            component.set("v.lastCarouselDirection", "previous");
            var cmpTarget = component.find('carouselList');
            if (cmpTarget) {
                //$A.util.addClass(cmpTarget, "slds-transition-hide");
                $A.util.removeClass(cmpTarget, "acn-list-slide-in-from-left");
                $A.util.removeClass(cmpTarget, "acn-list-slide-out-from-left");
                $A.util.removeClass(cmpTarget, "acn-list-slide-in-from-right");
                $A.util.addClass(cmpTarget, "acn-list-slide-out-from-right");
                
                window.setTimeout($A.getCallback(function() {
                    if(component.isValid()) {
                        var selectedPage = parseInt(component.get("v.navigationListSelectedPage"));
                        var pageSize = parseInt(component.get("v.navigationListPageSize"));
                        var carouselItems = component.get("v.carouselItems"); 
                        var navigationListTotalPages = component.get("v.navigationListTotalPages"); 
                        
                        selectedPage--;
                        if ( selectedPage < 1 ) {
                            selectedPage = navigationListTotalPages;
                        }
                        component.set("v.navigationListSelectedPage", selectedPage);
                        helper.changePage(component, event, helper);
                    }
                }), 1000);
                helper.changePage(component, event, helper);
            }
        }
	}, 
	buttonNextPressed: function(component, event, helper) {
        if (component.isValid()) {
            component.set("v.lastCarouselDirection", "next");
            var cmpTarget = component.find('carouselList');
            if (cmpTarget) {
                //$A.util.addClass(cmpTarget, "slds-transition-hide");
                $A.util.removeClass(cmpTarget, "acn-list-slide-in-from-left");
                $A.util.removeClass(cmpTarget, "acn-list-slide-out-from-right");
                $A.util.removeClass(cmpTarget, "acn-list-slide-in-from-right");
                $A.util.addClass(cmpTarget, "acn-list-slide-out-from-left");
                
                window.setTimeout($A.getCallback(function() {
                    if(component.isValid()) {
                        var selectedPage = parseInt(component.get("v.navigationListSelectedPage"));
                        var pageSize = parseInt(component.get("v.navigationListPageSize"));
                        var carouselItems = component.get("v.carouselItems"); 
                        
                        selectedPage++;
                        if ( ( selectedPage - 1 ) * pageSize > carouselItems.length - 1 ) {
                            selectedPage = 1;
                        }
                        component.set("v.navigationListSelectedPage", selectedPage);
                        helper.changePage(component, event, helper);
                    }
                }), 1000);
            }
        }
	},    
    loadMoreItems : function(component, event, helper) {
	    component.set("v.loadingMoreItems", true);
        var configurationObject = {};
        configurationObject.request = {};
        var isInfiniteLoading = component.get("v.isInfiniteLoading");
        var currentPage = component.get("v.currentPage");
        currentPage++;
        var itemsOffset = component.get("v.itemsOffset");
        var initialPageSize = component.get("v.initialPageSize");
        var pagesize = component.get("v.pageSize");
        if (isInfiniteLoading) {
            pagesize += initialPageSize;
            itemsOffset = 0;
            currentPage = 1;
        }
        else {
            itemsOffset = (currentPage-1) * pagesize;
        }
        component.set("v.currentPage", currentPage);
        component.set("v.itemsOffset", itemsOffset);
        configurationObject.request.PageSize = pagesize;
        configurationObject.callBackHandler = false;
        configurationObject.request = helper.getRequestTemplate(component, event, helper, configurationObject);
        helper.getNavigationListItems(component, event, helper, configurationObject);
    },
    gotoNextPage: function(component, event, helper) {
        var isLastItemPresent = component.get("v.isLastItemPresent");
        if (isLastItemPresent) {
            return;
        }
	    component.set("v.loadingMoreItems", true);
        var configurationObject = {};
        configurationObject.request = {};
        var isInfiniteLoading = component.get("v.isInfiniteLoading");
        var currentPage = component.get("v.currentPage");
        currentPage++;
        var itemsOffset = component.get("v.itemsOffset");
        var initialPageSize = component.get("v.initialPageSize");
        var pagesize = component.get("v.pageSize");
        if (isInfiniteLoading) {
            pagesize += initialPageSize;
            itemsOffset = 0;
            currentPage = 1;
        }
        else {
            itemsOffset = (currentPage-1) * pagesize;
        }
        component.set("v.currentPage", currentPage);
        component.set("v.itemsOffset", itemsOffset);
        configurationObject.request.PageSize = pagesize;
        configurationObject.callBackHandler = false;
        configurationObject.request = helper.getRequestTemplate(component, event, helper, configurationObject);
        helper.getNavigationListItems(component, event, helper, configurationObject);
    },
    gotoPreviousPage: function(component, event, helper) {
        var currentPage = component.get("v.currentPage");
        if (currentPage===1) {
            return;
        }
	    component.set("v.loadingMoreItems", true);
        var configurationObject = {};
        configurationObject.request = {};
        var isInfiniteLoading = component.get("v.isInfiniteLoading");
        currentPage--;
        var itemsOffset = component.get("v.itemsOffset");
        var initialPageSize = component.get("v.initialPageSize");
        var pagesize = component.get("v.pageSize");
        if (isInfiniteLoading) {
            pagesize += initialPageSize;
            itemsOffset = 0;
            currentPage = 1;
        }
        else {
            itemsOffset = (currentPage-1) * pagesize;
        }
        component.set("v.currentPage", currentPage);
        component.set("v.itemsOffset", itemsOffset);
        configurationObject.request.PageSize = pagesize;
        configurationObject.callBackHandler = false;
        configurationObject.request = helper.getRequestTemplate(component, event, helper, configurationObject);
        helper.getNavigationListItems(component, event, helper, configurationObject);
    },
    changePage: function (component, event, helper) {
        if (component.isValid()) {
            var carouselItems = component.get("v.carouselItems");
            var selectedPage = parseInt(component.get("v.navigationListSelectedPage"));
            var pageSize = parseInt(component.get("v.navigationListPageSize"));
            var navigationListItemsPage = [];
            
            for ( var carouselItemIndex = 0; carouselItemIndex < carouselItems.length; carouselItemIndex++) {
                var navigationListItem = carouselItems[carouselItemIndex];
                if (carouselItemIndex >= selectedPage * pageSize - pageSize && carouselItemIndex < selectedPage * pageSize ) {
                    navigationListItemsPage.push(navigationListItem);
                }
            }
            component.set("v.navigationListItemsPage", navigationListItemsPage);
        }
    }, 
    swipe: function (component, event, helper) {
		var carousel = component.find("carousel");
        if (carousel) {
            // To-Do: Check for LockerServices Compatibility
            var carouselElement = carousel.getElement();
            
            if (!carouselElement) {
                carouselElement = document;
            }
            
            carouselElement.addEventListener('touchstart', function(e) {
                component.set('v.touchStart', e.pageX);
            });
            
            carouselElement.addEventListener('touchend', function(e) {
                component.set('v.touchEnd', e.pageX);
            });
            
            carouselElement.addEventListener('mousedown', function(e) {
                console.log(e.pageX);
                component.set('v.touchStart', e.pageX);
                
            });
            
            carouselElement.addEventListener('mouseup', function(e) {
                console.log(e.pageX);
                component.set('v.touchEnd', e.pageX);
                var startX = component.get('v.touchStart');
                var endX = component.get('v.touchEnd');
                if (startX > endX) {
                    helper.buttonNextPressed(component, {}, helper);
                }
                else {
                    if (startX < endX) {
                        helper.buttonPreviousPressed(component, {}, helper);
                    }
                }
            });
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
    }, 
    mergeStringData: function (stringData) {
        var currentUserId = component.get("v.currentUserId");
        //stringData = stringData.replace('{!$user.id}', currentUserId);
        return stringData;
    }, 
    getCurrentUserId: function (component, event, helper) {
		var action = component.get("c.getUserId");

		action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var currentUserId = response.getReturnValue();
				component.set("v.currentUserId", currentUserId);
                var emptyListLink = component.get("v.emptyListLink");
                if (emptyListLink) {
                    //console.log(emptyListLink);
                    emptyListLink = emptyListLink.replace(/user.id/ig,'user.id');
                	emptyListLink = emptyListLink.replace('{' + '!' + '$' + 'user.id' + '}', currentUserId);
                    //console.log(emptyListLink);
                }
                component.set("v.emptyListLink", emptyListLink);
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
    showLoadingMessage: function (component, event, helper) {
        var showLoadingMessage = component.get("v.showLoadingMessage");
        if (showLoadingMessage) {
            component.set("v.showSpinner", true);
        }
    }, 
    hideLoadingMessage: function (component, event, helper) {
        var showLoadingMessage = component.get("v.showLoadingMessage");
        if (showLoadingMessage) {
            component.set("v.showSpinner", false);
        }
    }, 
    handleParentContextIdentifierChanged: function (component, event, helper) {
        var currentContextParentIdentifierContextIdentifier = component.get("v.contextParentIdentifierContextIdentifier");
        var eventContextParentIdentifierContextIdentifier = event.getParam("contextParentIdentifierContextIdentifier");
		var currentContextParentIdentifier = component.get("v.contextParentIdentifier");
        var contextParentIdentifier = event.getParam("contextParentIdentifier");

        if (currentContextParentIdentifierContextIdentifier && eventContextParentIdentifierContextIdentifier && currentContextParentIdentifierContextIdentifier == eventContextParentIdentifierContextIdentifier) {
            if (currentContextParentIdentifier != contextParentIdentifier) {
                var currentIntervalId = component.get("v.intervalId");
                if (currentIntervalId != -1) {
                    window.clearInterval(currentIntervalId);
                    currentIntervalId = -1;
                    component.set("v.intervalId", currentIntervalId);
                    component.set("v.navigationListSelectedPage", 1);
                }
                component.set("v.contextParentIdentifier", contextParentIdentifier);
                helper.reloadNavigationList(component, event, helper);
            }
        }
    }, 
    getParameterByName: function (name, url) {
        if (!url) url = window.location.href;
        name = name.replace(/[\[\]]/g, '\\$&').replace("queryParam.","");
        var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
            results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, ' '));
    }, 
    loadGridSizeArrays: function (component, event, helper) {
        var gridLayoutItemSize = component.get("v.gridLayoutItemSize");
        var gridLayoutItemSizeArray = component.get("v.gridLayoutItemSizeArray");
        var gridLayoutItemSizeParts = gridLayoutItemSize.split(",");
        for (var sizeIndex in gridLayoutItemSizeParts) {
            var size = gridLayoutItemSizeParts[sizeIndex];
            gridLayoutItemSizeArray.push(size);
        }
        component.set("v.gridLayoutItemSizeArray", gridLayoutItemSizeArray);

        var contentTitleLayoutItemSize = component.get("v.contentTitleLayoutItemSize");
        var contentTitleLayoutItemSizeArray = component.get("v.contentTitleLayoutItemSizeArray");
        var contentTitleLayoutItemSizeParts = contentTitleLayoutItemSize.split(",");
        for (var sizeIndex in contentTitleLayoutItemSizeParts) {
            var size = contentTitleLayoutItemSizeParts[sizeIndex];
            contentTitleLayoutItemSizeArray.push(size);
        }
        component.set("v.contentTitleLayoutItemSizeArray", contentTitleLayoutItemSizeArray);

        var contentBodyLayoutItemSize = component.get("v.contentBodyLayoutItemSize");
        var contentBodyLayoutItemSizeArray = component.get("v.contentBodyLayoutItemSizeArray");
        var contentBodyLayoutItemSizeParts = contentBodyLayoutItemSize.split(",");
        for (var sizeIndex in contentBodyLayoutItemSizeParts) {
            var size = contentBodyLayoutItemSizeParts[sizeIndex];
            contentBodyLayoutItemSizeArray.push(size);
        }
        component.set("v.contentBodyLayoutItemSizeArray", contentBodyLayoutItemSizeArray);

        var groupLayoutItemHeaderSize = component.get("v.groupLayoutItemHeaderSize");
        var groupLayoutItemHeaderSizeArray = component.get("v.groupLayoutItemHeaderSizeArray");
        var groupLayoutItemHeaderSizeParts = groupLayoutItemHeaderSize.split(",");
        for (var sizeIndex in groupLayoutItemHeaderSizeParts) {
            var size = groupLayoutItemHeaderSizeParts[sizeIndex];
            groupLayoutItemHeaderSizeArray.push(size);
        }
        component.set("v.groupLayoutItemHeaderSizeArray", groupLayoutItemHeaderSizeArray);

        var groupLayoutItemBodySize = component.get("v.groupLayoutItemBodySize");
        var groupLayoutItemBodySizeArray = component.get("v.groupLayoutItemBodySizeArray");
        var groupLayoutItemBodySizeParts = groupLayoutItemBodySize.split(",");
        for (var sizeIndex in groupLayoutItemBodySizeParts) {
            var size = groupLayoutItemBodySizeParts[sizeIndex];
            groupLayoutItemBodySizeArray.push(size);
        }
        component.set("v.groupLayoutItemBodySizeArray", groupLayoutItemBodySizeArray);

        var contentTitleLayoutItemLevel01Size = component.get("v.contentTitleLayoutItemLevel01Size");
        var contentTitleLayoutItemLevel01SizeArray = component.get("v.contentTitleLayoutItemLevel01SizeArray");
        var contentTitleLayoutItemLevel01SizeParts = contentTitleLayoutItemLevel01Size.split(",");
        for (var sizeIndex in contentTitleLayoutItemLevel01SizeParts) {
            var size = contentTitleLayoutItemLevel01SizeParts[sizeIndex];
            contentTitleLayoutItemLevel01SizeArray.push(size);
        }
        component.set("v.contentTitleLayoutItemLevel01SizeArray", contentTitleLayoutItemLevel01SizeArray);

        var contentTitleLayoutItemLevel02Size = component.get("v.contentTitleLayoutItemLevel02Size");
        var contentTitleLayoutItemLevel02SizeArray = component.get("v.contentTitleLayoutItemLevel02SizeArray");
        var contentTitleLayoutItemLevel02SizeParts = contentTitleLayoutItemLevel02Size.split(",");
        for (var sizeIndex in contentTitleLayoutItemLevel02SizeParts) {
            var size = contentTitleLayoutItemLevel02SizeParts[sizeIndex];
            contentTitleLayoutItemLevel02SizeArray.push(size);
        }
        component.set("v.contentTitleLayoutItemLevel02SizeArray", contentTitleLayoutItemLevel02SizeArray);
        
        var contentTitleLayoutItemLevel03Size = component.get("v.contentTitleLayoutItemLevel03Size");
        var contentTitleLayoutItemLevel03SizeArray = component.get("v.contentTitleLayoutItemLevel03SizeArray");
        var contentTitleLayoutItemLevel03SizeParts = contentTitleLayoutItemLevel03Size.split(",");
        for (var sizeIndex in contentTitleLayoutItemLevel03SizeParts) {
            var size = contentTitleLayoutItemLevel03SizeParts[sizeIndex];
            contentTitleLayoutItemLevel03SizeArray.push(size);
        }
        component.set("v.contentTitleLayoutItemLevel03SizeArray", contentTitleLayoutItemLevel03SizeArray);
        
        var groupsGridLayoutItemSize = component.get("v.groupsGridLayoutItemSize");
        var groupsGridLayoutItemSizeArray = component.get("v.groupsGridLayoutItemSizeArray");
        var groupsGridLayoutItemSizeArrayParts = groupsGridLayoutItemSize.split(",");
        for (var sizeIndex in groupsGridLayoutItemSizeArrayParts) {
            var size = groupsGridLayoutItemSizeArrayParts[sizeIndex];
            groupsGridLayoutItemSizeArray.push(size);
        }
        component.set("v.groupsGridLayoutItemSizeArray", groupsGridLayoutItemSizeArray);

        var groupLayoutItemFooterSize = component.get("v.groupLayoutItemFooterSize");
        var groupLayoutItemFooterSizeArray = component.get("v.groupLayoutItemFooterSizeArray");
        var groupLayoutItemFooterSizeParts = groupLayoutItemFooterSize.split(",");
        for (var sizeIndex in groupLayoutItemFooterSizeParts) {
            var size = groupLayoutItemFooterSizeParts[sizeIndex];
            groupLayoutItemFooterSizeArray.push(size);
        }
        component.set("v.groupLayoutItemFooterSizeArray", groupLayoutItemFooterSizeArray);

        var buttonableLayoutItemBodySize = component.get("v.buttonableLayoutItemBodySize");
        var buttonableLayoutItemBodySizeArray = component.get("v.buttonableLayoutItemBodySizeArray");
        var buttonableLayoutItemBodySizeParts = buttonableLayoutItemBodySize.split(",");
        for (var sizeIndex in buttonableLayoutItemBodySizeParts) {
            var size =buttonableLayoutItemBodySizeParts[sizeIndex];
            buttonableLayoutItemBodySizeArray.push(size);
        }
        component.set("v.buttonableLayoutItemBodySizeArray", buttonableLayoutItemBodySizeArray);

        var buttonableLayoutItemButtonsSize = component.get("v.buttonableLayoutItemButtonsSize");
        var buttonableLayoutItemButtonsSizeArray = component.get("v.buttonableLayoutItemButtonsSizeArray");
        var buttonableLayoutItemButtonsSizeParts = buttonableLayoutItemButtonsSize.split(",");
        for (var sizeIndex in buttonableLayoutItemButtonsSizeParts) {
            var size =buttonableLayoutItemButtonsSizeParts[sizeIndex];
            buttonableLayoutItemButtonsSizeArray.push(size);
        }
        component.set("v.buttonableLayoutItemButtonsSizeArray", buttonableLayoutItemButtonsSizeArray);
    }, 
    getRequestTemplate: function(component, event, helper, configurationObject) {
        var request = {};
        request.Id = "";
        var contextParentIdentifier = component.get("v.contextParentIdentifier");
        if (contextParentIdentifier) {
            request.Id = contextParentIdentifier;
        }
        request.IsIdRequired = component.get("v.isIdRequired");
        request.DefaultId = component.get("v.defaultContextParentIdentifier");
        if (request.Id.indexOf("queryParam")>-1) {
            var queryParamsArray = request.Id.split(".");
            request.Id = "";
            var queryParamName = "";
            if (queryParamsArray.length > 1) {
                queryParamName = queryParamsArray[1];
                var queryParamValue = helper.getParameterByName(queryParamName);
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
        request.SelectedId = component.get("v.selectedItemIdentifier");
        if (request.SelectedId && request.SelectedId.indexOf("queryParam.")>-1) {
            request.SelectedId = helper.getParameterByName(request.SelectedId);
        }
        request.UseContextForCarousel = component.get("v.useContextForCarousel");
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
        request.IncludeRecommendations = component.get("v.showCarouselList");
        request.ShowArticleViewCount = component.get("v.showArticleViewCount");
        request.ShowPublishDate = component.get("v.showArticlePublishDate"); 
        request.ShowArticleType = component.get("v.showArticleType");
        request.ShowArticleRating = component.get("v.showArticleRating");
        request.ShowSmallImage = helper.showSmallImage(component, event, helper);
        request.BrowserFormFactor = helper.getBrowserFormFactor(component, event, helper);
        request.Filter = component.get("v.navigationFilter");
        request.ShowGroups = component.get("v.showNavigationListGroups");
        request.IncludeParentNavigationItem = component.get("v.includeParentNavigationItem");
        request.NameFieldOverride = component.get("v.nameFieldOverride");
        request.DescriptionFieldOverride = component.get("v.descriptionFieldOverride");
        request.ImageFieldOverride = component.get("v.imageFieldOverride");
        request.TargetFieldOverride = component.get("v.targetFieldOverride");
        request.GroupFieldOverride = component.get("v.groupFieldOverride");
        request.SortFieldOverride = component.get("v.sortFieldOverride");
        request.ItemGridSize = component.get("v.gridLayoutItemSize");
        request.GroupItemGridSize = component.get("v.groupLayoutItemHeaderSize");
        request.PageSize = component.get("v.pageSize");
        request.CurrentPage = component.get("v.currentPage");
        request.ItemsOffset = component.get("v.itemsOffset");
        request.IsInfiniteLoading = component.get("v.isInfiniteLoading");
        request.ComponentId = component.get("v.componentId");
        request.ExtendedProperty = component.get("v.extendedProperty");
        request.IsInitialLoad = component.get("v.isInitialLoad");
        request.CurrentSortDirection = component.get("v.sortDirection");
        request.Sorting = [];
        var sortingItems = component.get("v.sortingItems");
        var serializedSorting = component.get("v.serializedSorting");
        if (serializedSorting && serializedSorting.length > 0 && (!sortingItems || sortingItems.length==0)) {
            for (var serializedSortingIndex in serializedSorting) {
                var serializedSortingItem = serializedSorting[serializedSortingIndex];
                sortingItems.push(JSON.parse(serializedSortingItem));
            }
            component.set("v.sortingItems", sortingItems);
        }
        if (sortingItems && sortingItems.length > 0 && (!serializedSorting || serializedSorting.length == 0)) {
            for (var sortingItemIndex in sortingItems) {
                var sortingItem = sortingItems[sortingItemIndex];
                serializedSorting.push(JSON.stringify(sortingItem));
            }
            component.set("v.serializedSorting", serializedSorting);
        }
        if (serializedSorting && serializedSorting.length > 0) {
            request.Sorting = serializedSorting;
        }
        request.IsInfiniteLoading = component.get("v.isInfiniteLoading");
        request.CurrentPage = component.get("v.currentPage");
        request.PageSize = component.get("v.pageSize");
        request.ItemsOffset = component.get("v.itemsOffset");
        if (configurationObject && configurationObject.request) {
            for (var propertyKey in configurationObject.request) {
                request[propertyKey] = configurationObject.request[propertyKey];
            }
        }
        
        return request;
    }
})