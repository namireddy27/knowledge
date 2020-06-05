({
    doInit : function(component, event, helper) {
        var initHasRun = component.get("v.initComplete");
        if (initHasRun) return;
        component.set("v.isListEmpty", false);
		helper.loadGridSizeArrays(component, event, helper);
        helper.reloadNavigationList(component, event, helper);
        var title = component.get("v.titleLevel01");
        title = title.replace(/-/g, " ");
        component.set("v.titleLevel01", title);
        title = component.get("v.titleLevel02");
        title = title.replace(/-/g, " ");
        component.set("v.titleLevel02", title);
		title = component.get("v.titleLevel03");
        title = title.replace(/-/g, " ");
        component.set("v.titleLevel03", title);
		title = component.get("v.emptyListMessage");
        title = title.replace(/-/g, " ");
        component.set("v.emptyListMessage", title);
        component.set("v.initComplete", true);
        component.set("v.initialPageSize", component.get("v.pageSize"));
    }, 
    handleNavigationListRefreshAllRequested: function(component, event, helper) {
        component.set("v.isListEmpty", false);
        var isRefreshAllHandled = component.get("v.isRefreshAllHandled");
        if (isRefreshAllHandled) {
            helper.reloadNavigationList(component, event, helper);
        }
    }, 
    doneRendering: function(component, event, helper) {
        window.setTimeout($A.getCallback(function() {
            if(component.isValid()) {
                var lastCarouselDirection = component.get("v.lastCarouselDirection");
                var cmpTarget = component.find('carouselList');
                if (cmpTarget) {
                    $A.util.removeClass(cmpTarget, "slds-transition-hide");
                    if (lastCarouselDirection == 'next') {
                        $A.util.removeClass(cmpTarget, "acn-list-slide-out-from-left");
                        $A.util.removeClass(cmpTarget, "acn-list-slide-out-from-right");
                        $A.util.removeClass(cmpTarget, "acn-list-slide-in-from-left");
                        $A.util.addClass(cmpTarget, "acn-list-slide-in-from-right");
                    } 
                    else {
                        $A.util.removeClass(cmpTarget, "acn-list-slide-out-from-left");
                        $A.util.removeClass(cmpTarget, "acn-list-slide-out-from-right");
                        $A.util.removeClass(cmpTarget, "acn-list-slide-in-from-right");
                        $A.util.addClass(cmpTarget, "acn-list-slide-in-from-left");
                    }
                    //$A.util.removeClass(cmpTarget, "acn-list-slide-out-from-left");
                    //$A.util.addClass(cmpTarget, "acn-list-slide-in-from-right");
                }
            }
        }), 1000);
    },
    pathSegmentChange: function(component, event, helper) {
        var navigationPathSegmentItem = event.getParams("navigationPathSegment");
        var configurationObject = {};
        configurationObject.request = {};
        configurationObject.callBackHandler = false;      
        configurationObject.request.Id = navigationPathSegmentItem.value.Id;
        configurationObject.request.GoUp = true;
        configurationObject.request = helper.getRequestTemplate(component, event, helper, configurationObject);
        helper.getNavigationListItems(component, event, helper, configurationObject);
    }, 
    handleNavigationListItemPressed: function(component, event, helper) {
        var action = component.get("c.getSerializedNavigationList");
        var navigationItem = event.getParam("navigationItem");
        component.set("v.selectedNavigationItemId", navigationItem.Id);

        var configurationObject = {};
        configurationObject.request = {};
        configurationObject.callBackHandler = false;      
        configurationObject.request.Id = navigationItem.Id;
        configurationObject.request.GoUp = false;
        configurationObject.request = helper.getRequestTemplate(component, event, helper, configurationObject);

        var selectionContextIdentifier = component.get("v.selectionContextIdentifier");
        if (selectionContextIdentifier) {
            var navigationItemSelected = $A.get("e.c:ACN_NavigationItemSelected");
            if (navigationItemSelected) {
                navigationItemSelected.setParams({
                    navigationItem: navigationItem, 
                    selectionContextIdentifier: selectionContextIdentifier
                });
                navigationItemSelected.fire();
            }
        }

        var navigationSelectionUpdated = $A.get("e.c:ACN_NavigationSelectionUpdated");
        navigationSelectionUpdated.fire();
        
        switch(navigationItem.NavigationType) {
            case "Preview":
                configurationObject.callBackHandler = function(component, event, helper) {
                    var pressedNavigationItem = event.getParams("navigationItem").navigationItem;
                    component.set("v.selectedNavigationItem", pressedNavigationItem);
                    
                    var navigationPathChangedEvent = component.getEvent("navigationPathChanged");
                    if (navigationPathChangedEvent) {
                        navigationPathChangedEvent.setParams({
                            navigationItem: navigationItem
                        }).fire();
                    }
                    /*
                    var navigationMenuChangedEvent = $A.get("e.c:ACN_NavigationMenuChanged");
                    if (navigationMenuChangedEvent) {
                        navigationMenuChangedEvent.setParams({
                            navigationItem: pressedNavigationItem
                        });
                        navigationMenuChangedEvent.fire();
                    } 
                    */
                }
                helper.getNavigationListItems(component, event, helper, configurationObject);
                break;
		                
            case "Event":
                if (navigationItem.NavigationTarget) {
                    debugger;
                    var lightningEvent = $A.get(navigationItem.NavigationTarget);
                    var lightningParameters = {};
                    if (lightningEvent) {
                        if (navigationItem.SerializedNavigationTargetVariable) {
                            try {
                                if (navigationItem.SerializedNavigationTargetVariable.indexOf("{"  + "!" + "eventSource" + "}")>-1) {
                                    navigationItem.SerializedNavigationTargetVariable = navigationItem.SerializedNavigationTargetVariable.replace("{"  + "!" + "eventSource" + "}", event.getSource().get("v.name"));
                                }
                                lightningParameters = JSON.parse(navigationItem.SerializedNavigationTargetVariable);
                                lightningEvent.setParams(lightningParameters);
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
                break;
                
            case "Email":
                if (!navigationItem.NavigationTarget) {
                    return;
                }
                var emailFeatures = "mailto:" + navigationItem.NavigationTarget;
                if (navigationItem.NavigationTargetVariable) {
                    var urlSeparator = "?";
                    for (var variableName in navigationItem.NavigationTargetVariable) {
	                    emailFeatures += urlSeparator;
                        var variableValue = navigationItem.NavigationTargetVariable[variableName];
                        emailFeatures += variableName + "=" + variableValue;
                        urlSeparator = "&";
                    }
                }
                var mail = document.createElement("a");
                mail.href = emailFeatures;
                mail.click();
                return;
                break;
                
            case "JS":
                var windowFeatures = "";
                if (navigationItem.NavigationTargetVariable) {
                    for (var variableName in navigationItem.NavigationTargetVariable) {
                        var variableValue = navigationItem.NavigationTargetVariable[variableName];
                        windowFeatures += variableName + "=" + variableValue + ",";
                    }
                }
                
                //windowFeatures = menubar=no,location=no,resizable=no,scrollbars=no,status=yes";
                window.open(navigationItem.NavigationTarget, navigationItem.Name, windowFeatures);
                break;
                
            case "Record":
                if (navigationItem.NavigationTarget) {
                    var queryParameters = "";
                    if (navigationItem.NavigationTargetVariable) {
                        for (var variableName in navigationItem.NavigationTargetVariable) {
                            if (!queryParameters || queryParameters== "") {
                                queryParameters = "?";
                            }
                            else {
                                queryParameters += "&";
                            }
                            var variableValue = navigationItem.NavigationTargetVariable[variableName];
                            queryParameters += variableName + "=" + encodeURI(variableValue);
                        }
                    }
                    
                    var url = navigationItem.NavigationTarget + queryParameters;
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": url
                    });
                    urlEvent.fire();
                }
                break;
                
            default:
                if(navigationItem.NavigationTarget){
                    if(navigationItem.NavigationType === "URL") {
                        if (navigationItem.ShowInterstitial) {
                            var modalBody;
                            var modalFooter;
                            $A.createComponents([
                                ["c:ACN_NavigationConfirm",{}],
                                ["c:ACN_NavigationConfirmFooter",{"navigationItem" : navigationItem }]
                            ]
                            ,
                            function(components, status){
                                if (status === "SUCCESS") {
                                    modalBody = components[0];
                                    modalFooter = components[1];
                                    component.find('overlayLib').showCustomModal({
                                       header: "Navigation Confirmation",
                                       body: modalBody,
                                       footer: modalFooter,
                                       showCloseButton: true,
                                       closeCallback: function() {
                                           //alert('You closed the alert!');
                                       }
                                   })
                                }
                            }
                           );
                        } else {
                            if (navigationItem.NavigationTarget == '\/\/') {
                                var newURL = window.location.protocol + "//" + window.location.host + ("/" + window.location.pathname).replace('//','/');
                                //console.log(newURL);
                                if (newURL && newURL.indexOf('?') > 0) {
                                    newURL = newURL.substr(0, newURL.indexOf('?'));
                                }
                                if (newURL && newURL.indexOf('\/s\/') > 0) {
                                    newURL = newURL.substr(0, newURL.indexOf('\/s\/')+3);
                                }
                                window.location.replace(newURL);
                            }
                            else {
                                if (navigationItem.NavigationTarget == '\/.') {
                                    window.location.reload();
                                }
                                else {                
                                    var urlEvent = $A.get("e.force:navigateToURL");
                                    urlEvent.setParams({
                                        "url": navigationItem.NavigationTarget
                                    });
                                    urlEvent.fire();
                                    //window.location.reload();
                                }
                            }
                        }
                    }
                }
                
                configurationObject.callBackHandler = function(component, event, helper) {
                    //   debugger;
                    var pressedNavigationItem = event.getParams("navigationItem").navigationItem;
                    component.set("v.selectedNavigationItem", pressedNavigationItem);
                    
                    var navigationPathChangedEvent = component.getEvent("navigationPathChanged");
                    if (navigationPathChangedEvent) {
                        navigationPathChangedEvent.setParams({
                            navigationItem: navigationItem
                        }).fire();
                    }
                    /*
                    if (navigationItem.IsMenuItem) {
                        var navigationMenuChangedEvent = $A.get("e.c:ACN_NavigationMenuChanged");
                        if (navigationMenuChangedEvent) {
                            navigationMenuChangedEvent.setParams({
                                navigationItem: pressedNavigationItem
                            });
                            navigationMenuChangedEvent.fire();
                        } 
                    }
                    */
                }
                
                if (navigationItem && (!navigationItem.NavigationType || navigationItem.NavigationType && "EVENT,URL,COMMUNITY,TOPIC,OBJECT".indexOf(navigationItem.NavigationType.toUpperCase()) == -1 || navigationItem.NavigationType && !navigationItem.NavigationTarget)) {
	                helper.getNavigationListItems(component, event, helper, configurationObject);
                }            
                break;
        }
    }, 
    handleSelectedNavigationItemResponseReturned: function(component, event, helper) {
        helper.handleSelectedNavigationItemResponseReturned(component, event, helper);
    }, 
    update : function(component) {
        alert('u');
    },
    toggleAccordion: function() {
        //To-Do: Check for LockerServices
        var acc = document.getElementsByClassName("accordion");
        var i;
        
        for (i = 0; i < acc.length; i++) {
            acc[i].onclick = function() {
                this.classList.toggle("active");
                this.nextElementSibling.classList.toggle("show");
            }
        }
    }, 
    buttonPreviousPressed: function(component, event, helper) {
        helper.buttonPreviousPressed(component, event, helper);
    }, 
    buttonNextPressed: function(component, event, helper) {
        helper.buttonNextPressed(component, event, helper);
    }, 
    loadMoreItems: function(component, event, helper) {
        helper.loadMoreItems(component, event, helper);
    },
    gotoNextPage: function(component, event, helper) {
        helper.gotoNextPage(component, event, helper);
    },
    gotoPreviousPage: function(component, event, helper) {
        helper.gotoPreviousPage(component, event, helper);
    },
    pageSelectorPressed: function(component, event, helper) {
        //To-Do: Check for LockerServices
        var pressedPageSelector = event.getSource().get("v.body")[0].elements[0].pagenumber;
        //console.log(pressedPageSelector);
        component.set("v.navigationListSelectedPage", pressedPageSelector);
        helper.changePage(component, event, helper);
    },
    handleNavigationFilterChanged: function(component, event, helper) {
        var filterContextIdentifier = component.get("v.filterContextIdentifier");
        var eventFilterContextIdentifier = event.getParam("filterContextIdentifier");
        
        if (!filterContextIdentifier || !eventFilterContextIdentifier || filterContextIdentifier != eventFilterContextIdentifier) {
            return;
        }
        
        var filterList = event.getParam("filterList");
        component.set("v.navigationFilter" , filterList);
        
        helper.reloadNavigationList(component, event, helper);
    },
    showLoadingMessage: function (component, event, helper) {
        helper.showLoadingMessage (component, event, helper);
    }, 
    hideLoadingMessage: function (component, event, helper) {
        helper.hideLoadingMessage (component, event, helper);
    }, 
    handleParentContextIdentifierChanged: function (component, event, helper) {
        helper.handleParentContextIdentifierChanged (component, event, helper);
    },
    handleNavigationSelectionUpdated: function (component, event, helper) {
        /*
		var selectedItemIdentifier = component.get("v.selectedItemIdentifier");
        if (selectedItemIdentifier && selectedItemIdentifier.indexOf("queryParam.")>-1) {
            selectedItemIdentifier = helper.getParameterByName(selectedItemIdentifier);
        }
        var navigationItems = component.get("v.navigationListItems");debugger;
        if (navigationItems && navigationItems.length && navigationItems.length > 0) {
            for ( var itemIndex = 0; itemIndex < navigationItems.length; itemIndex++) {
                var navigationItem = navigationItems[itemIndex];
                
                if (selectedItemIdentifier && selectedItemIdentifier == navigationItem.Id || selectedItemIdentifier == navigationItem.Code || selectedItemIdentifier == navigationItem.Name ) {
                    navigationItem.IsSelected = true;
                }
                else {
                    navigationItem.IsSelected = false;
                }
            }
            component.set("v.navigationListItems", navigationItems);
        }
        */
    }, 
    handleItemConfirm: function(component, event, helper) {
        var navigationItem = event.getParam("navigationItem");
        if(navigationItem.NavigationTarget){
            if(navigationItem.NavigationType === "URL") {
                if (navigationItem.NavigationTarget == '\/\/') {
                    var newURL = window.location.protocol + "//" + window.location.host + ("/" + window.location.pathname).replace('//','/');
                    //console.log(newURL);
                    if (newURL && newURL.indexOf('?') > 0) {
                        newURL = newURL.substr(0, newURL.indexOf('?'));
                    }
                    if (newURL && newURL.indexOf('\/s\/') > 0) {
                        newURL = newURL.substr(0, newURL.indexOf('\/s\/')+3);
                    }
                    window.location.replace(newURL);
                }
                else {
                    if (navigationItem.NavigationTarget == '\/.') {
                        window.location.reload();
                    }
                    else {
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": navigationItem.NavigationTarget
                        });
                        urlEvent.fire();
                    }
                }
            }
        }
    }, 
    handleNavigationListRefreshRequested: function(component, event, helper) {
        var componentId = component.get("v.componentId");
        var componentIds = event.getParam("componentIds");
        if (componentIds && componentIds.length > 0 && componentIds.includes(componentId)) {
            //console.log('refreshing componentId: ' + componentId + ' handleNavigationListRefreshRequested');

            helper.reloadNavigationList(component, event, helper);
        }
    },
    
       HR_CandidateRefresh : function(component, event, helper) {
       console.log('Testrefresh');
   		$A.get('e.force:refreshView').fire(); 
    },

    HR_RefreshActionItems : function(component, event, helper) {
       var dataProviderName = component.get("v.dataProviderName");
       if (dataProviderName == "HR_ApplicationHiringStageProvider"){
        var initHasRun = component.get("v.initComplete");
        if (initHasRun) return;
        component.set("v.isListEmpty", false);
		helper.loadGridSizeArrays(component, event, helper);
        helper.reloadNavigationList(component, event, helper);
        var title = component.get("v.titleLevel01");
        title = title.replace(/-/g, " ");
        component.set("v.titleLevel01", title);
        title = component.get("v.titleLevel02");
        title = title.replace(/-/g, " ");
        component.set("v.titleLevel02", title);
		title = component.get("v.titleLevel03");
        title = title.replace(/-/g, " ");
        component.set("v.titleLevel03", title);
		title = component.get("v.emptyListMessage");
        title = title.replace(/-/g, " ");
        component.set("v.emptyListMessage", title);
        component.set("v.initComplete", true);
        component.set("v.initialPageSize", component.get("v.pageSize"));
    }
    }
    
})