({
	getNavigationListItems: function(component, event, helper) {
		var action = component.get("c.getSerializedNavigationList");
        var selectedPage = 1;
        var pageSize = 1;
        var carouselIntervalInSeconds = 0;
		var navigationProviderName = component.get("v.dataProviderName");
        if (!navigationProviderName) {
            return;
        }
		var request = {};
        request.Id = "COMMUNITYNAVIGATIONMENU";
        request.IsIdRequired = false;
        request.DefaultId = "";
		request.SelectedId = "";
		request.UseContextForCarousel = false;
        request.ShowAllDescendants = false;
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
		request.ShowArticleViewCount = false;
        request.ShowPublishDate = false; 
        request.ShowArticleType = false;
        request.ShowArticleRating = false;
        request.ShowSmallImage = false;
        request.BrowserFormFactor = helper.getBrowserFormFactor(component, event, helper);
        request.Filter = [];
        request.ShowGroups = false;
        request.IncludeParentNavigationItem = false;
        request.NameFieldOverride = false;
        request.DescriptionFieldOverride = false;
        request.ImageFieldOverride = false;
        request.TargetFieldOverride = false;
        request.GroupFieldOverride = false;
        request.SortFieldOverride = false;

		action.setParams(
            {
                serializedRequest: JSON.stringify(request)
            }
        );

        action.setCallback(this, function(response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var navigationList = JSON.parse(response.getReturnValue());
				var navigationListItems = navigationList.Items;

                navigationListItems = helper.sortListItems(component, event, helper, {"navigationListItems": navigationListItems});
                
                //to-do: check which items to show
                console.log(navigationListItems);
                component.set("v.navigationListItems", navigationListItems);
			}
            else {
                console.log('Error');
                console.log(response.getError());
                console.log(response);
            }
	        helper.hideLoadingMessage(component, event, helper);
    	});
        helper.showLoadingMessage(component, event, helper);
        
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
    sortListItems: function(component, event, helper, configurationObject) {
        function compare(firstElement, secondElement) {
            var firstElementSortName = "";
            var secondElementSortName = "";
            if (firstElement.SortName) {
                firstElementSortName = firstElement.SortName.toUpperCase();
            }
            if (secondElement.SortName) {
                secondElementSortName = secondElement.SortName.toUpperCase();
            }

            var comparison = 0;
            if (firstElementSortName > secondElementSortName) {
                comparison = 1;
            } else if (firstElementSortName < secondElementSortName) {
                comparison = -1;
            }
            return comparison;
        }
		
        if (configurationObject && configurationObject.navigationListItems) {
            configurationObject.navigationListItems.sort(compare);
        }
        return configurationObject.navigationListItems;
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
    getBrowserFormFactor: function (component, event, helper) {
        var browserFormFactor = component.get("v.browserFormFactor");
        if (!browserFormFactor){
            browserFormFactor = "BROWSER";
        }
        return browserFormFactor;
    }
})