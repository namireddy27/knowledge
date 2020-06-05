var ACN = ACN || {};
ACN.JSLibrary = ACN.JSLibrary || {};

ACN.JSLibrary.LiveChat = ACN.JSLibrary.LiveChat || {};

ACN.JSLibrary.LiveChat = function (configObject) {
    this.version = '1.00.00';
    this.acnlib = new ACN.JSLibrary({"instantiatedBy":this});

    for ( propertyName in configObject ) {
        this[propertyName] = configObject[propertyName];
    }
}

ACN.JSLibrary.LiveChat.prototype = {
    initializeLiveChatServices: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};
        
        var liveChatUrl = acnLiveChat.liveChatUrl;
        if (configObject.liveChatUrl) {
            liveChatUrl = configObject.liveChatUrl;
        }
        var liveChatDeploymentId = acnLiveChat.liveChatDeploymentId;
        if (configObject.liveChatDeploymentId) {
            liveChatDeploymentId = configObject.liveChatDeploymentId;
        }
        var liveChatOrganizationId = acnLiveChat.liveChatOrganizationId;
        if (configObject.liveChatOrganizationId) {
            liveChatOrganizationId = configObject.liveChatOrganizationId;
        }
        
        if (!configObject.liveChat || !configObject.liveChat.init || !liveChatUrl || !liveChatDeploymentId || !liveChatOrganizationId) {
            //throw exceptions with missing parameters?
            return;
        }
        
        configObject.liveChat.init(liveChatUrl, liveChatDeploymentId, liveChatOrganizationId);
    }, 
    initializeLiveChatPresence: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};

		acnLiveChat.window.setTimeout (function() {
			var offLineButton = acnLiveChat.document.getElementById(acnLiveChat.offLineButtonElementId);
			if (offLineButton) {
				if (!offLineButton.style || !offLineButton.style.display) {
					var loadedMessage = {};
					loadedMessage.actionName = acnLiveChat.liveChatNotifyAgentNotPresentActionName;
					acnLiveChat.postMessage(loadedMessage);
				}

				var offLineButtonObserver = new MutationObserver(function (event) {
					var mutationRecord = event[0];
					if (mutationRecord.attributeName === "style" && (!mutationRecord.target.attributeStyleMap || !mutationRecord.target.attributeStyleMap.size || mutationRecord.target.attributeStyleMap.size === 0)) {
						var loadedMessage = {};
						loadedMessage.actionName = acnLiveChat.liveChatNotifyAgentNotPresentActionName;
						acnLiveChat.postMessage(loadedMessage);
					}
				});
				offLineButtonObserver.observe(offLineButton, {
					attributes: true, 
					attributeFilter: ['style'],
					childList: false, 
					characterData: false
				});
			}

			var onLineButton = acnLiveChat.document.getElementById(acnLiveChat.onLineButtonElementId);
			if (onLineButton) {
				if (!onLineButton.style || !onLineButton.style.display) {
					var loadedMessage = {};
					loadedMessage.actionName = acnLiveChat.liveChatNotifyAgentPresentActionName;
					acnLiveChat.postMessage(loadedMessage);
				}

				var onLineButtonObserver = new MutationObserver(function (event) {
					var mutationRecord = event[0];
					if (mutationRecord.attributeName === "style" && (!mutationRecord.target.attributeStyleMap || !mutationRecord.target.attributeStyleMap.size || mutationRecord.target.attributeStyleMap.size === 0)) {
						var loadedMessage = {};
						loadedMessage.actionName = acnLiveChat.liveChatNotifyAgentPresentActionName;
						acnLiveChat.postMessage(loadedMessage);
					}
				});
				
				onLineButtonObserver.observe(onLineButton, {
					attributes: true, 
					attributeFilter: ['style'],
					childList: false, 
					characterData: false
				});
			}
		}, acnLiveChat.liveChatInitializationTimeoutMs);				
    }, 
    initializeLiveChatWindow: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};

        acnLiveChat.window.setTimeout (function() {
            var liveAgentMessageContainer = acnLiveChat.document.getElementById(acnLiveChat.liveAgentMessageContainerElementId);
            if (liveAgentMessageContainer) {
                var liveAgentMessageContainerObserver = new MutationObserver(function (event) {
                    var mutationRecord = event[0];

                    if (mutationRecord.removedNodes && mutationRecord.removedNodes.length > 0) {
                        var newPanel = mutationRecord.removedNodes[0];
                        if (newPanel.childNodes && newPanel.childNodes.length == 2 && newPanel.childNodes[1].nodeName && newPanel.childNodes[1].nodeName === acnLiveChat.liveChatCloseButtonElementType && newPanel.childNodes[1].innerText && newPanel.childNodes[1].innerText === acnLiveChat.liveChatCloseButtonLabel ) {
                            closeChat(
                                {
                                    "from": acnLiveChat.closeChatFromCloseChatButtonLabel
                                }
                            );
                        }
                    }
                });
                
                liveAgentMessageContainerObserver.observe(liveAgentMessageContainer, {
                  attributes: false, 
                  childList: true, 
                  characterData: false
                });
            }
            
            var liveAgentClientChat = acnLiveChat.document.getElementById(acnLiveChat.liveAgentClientChatElementId);
            if (liveAgentClientChat) {
                var liveAgentClientChatObserver = new MutationObserver(function (event) {
                    var liveChatClientStatus = acnLiveChat.liveChatClientStatusDefaultValue;
                    if (event && event.length > 0) {
                        for (var mutationRecordIndex in event) {
                            var mutationRecord = event[mutationRecordIndex];
                            if (mutationRecord.attributeName && mutationRecord.attributeName === "class") {
                                if (mutationRecord && mutationRecord.target && mutationRecord.target.className) {
                                    liveChatClientStatus = mutationRecord.target.className;
                                }
                                break;
                            }
                        }
                    }
                    var isAgentAvailable = false;
                    var isAgentAvailableElement = acnLiveChat.document.getElementById(acnLiveChat.agentAvailableElementId);
                    if (isAgentAvailableElement) { 
                        isAgentAvailable =  isAgentAvailableElement.value === "true";
                    }
                    var config = {};
                    config.liveAgentSuatus = liveChatClientStatus;
                    config.chatSaveEndButtonsPanel = acnLiveChat.document.getElementById(acnLiveChat.chatSaveEndButtonsPanelElementId);
                    config.chatSaveEndButtonSave = acnLiveChat.document.getElementById(acnLiveChat.chatSaveEndButtonSaveElementId);
                    config.chatSaveEndButtonEnd = acnLiveChat.document.getElementById(acnLiveChat.chatSaveEndButtonEndElementId);
                    config.chatSaveEndButtonCancel = acnLiveChat.document.getElementById(acnLiveChat.chatSaveEndButtonCancelElementId);
                    config.chatAlertsPanel = acnLiveChat.document.getElementById(acnLiveChat.chatAlertsPanelElementId);
                    config.chatStatusPanel = acnLiveChat.document.getElementById(acnLiveChat.chatStatusPanelElementId);
                    config.chatWaitPanel = acnLiveChat.document.getElementById(acnLiveChat.chatWaitPanelElementId);
                    config.chatLogPanel = acnLiveChat.document.getElementById(acnLiveChat.liveChatLogPanelContainerElementId);
                    config.chatMessagingPanel = acnLiveChat.document.getElementById(acnLiveChat.chatMessagingPanelElementId);
                    config.closeButtonPanel = acnLiveChat.document.getElementById(acnLiveChat.closeButtonPanelElementId);
                    config.showEndSaveButtonsTogether = false;
                    config.isAgentAvailable = isAgentAvailable;
                    config.event = event;

                    var brandingElement = acnLiveChat.document.getElementById(acnLiveChat.brandingElementId);
                    if (brandingElement && brandingElement.value) {
                        var branding = JSON.parse(brandingElement.value);
                        if (branding && branding.backgroundColor) {
                            var list = acnLiveChat.document.getElementsByTagName(acnLiveChat.liveChatButtonsTagName);
                            for (var elementIndex in list) {
                                var element = list[elementIndex];
                                try {
									element.setAttribute("style", "background-image: linear-gradient(to top, " + branding.backgroundColor + " 0%, " + acn.colorShadeBlendConvert(acnLiveChat.liveChatButtonGradientPercentage, branding.backgroundColor) + " 100%) !important;color: " + branding.lightingColor + " !important;");
                                }
                                catch (e) {
                                    //element is not an html element, ignore
                                }
                            }
                            
                            list = acnLiveChat.document.getElementsByTagName(acnLiveChat.liveChatInputsTagName);
                            for (var elementIndex in list) {
                                var element = list[elementIndex];
                                try {
                                    element.setAttribute("style", "border-color: " + branding.backgroundColor + " !important;");
                                }
                                catch (e) {
                                    //element is not an html element, ignore
                                }
                            }
                            list = acnLiveChat.document.getElementById(acnLiveChat.liveChatLogPanelContainerElementId);
                            try {
                                list.setAttribute("style", "border-color: " + branding.backgroundColor + " !important;");
                            }
                            catch (e) {
                                //element is not an html element, ignore
                            }
                        }
                    }

                    var messageToPost = {};
                    messageToPost.actionName = liveChatClientStatus;
                    acnLiveChat.postMessage(messageToPost);
                    switch (liveChatClientStatus) {
                        case acnLiveChat.liveChatClientStatusWaitingForAgentValue:
                            acnLiveChat.showLiveAgentStateWaitingForAgent(config);
                            break;

                        case acnLiveChat.liveChatClientStatusWaitingDequeuedValue:
                            acnLiveChat.showLiveAgentStateWaitingDequeued(config);
                            break;

                        case acnLiveChat.liveChatClientStatusActiveChatValue:
                            acnLiveChat.showLiveAgentState(config);
                            break;

                        case acnLiveChat.liveChatClientStatusChatEndedValue:
                            if (config.isAgentAvailable) {
                                acnLiveChat.showLiveAgentStateEnded(config);
                            }
                            else {
                                acnLiveChat.showLiveAgentStateNotAvailable(config);
                            }
                            break;

                        default:
                            acnLiveChat.showLiveAgentStateDefault(config);
                            break;
                    }
                });
                
                liveAgentClientChatObserver.observe(liveAgentClientChat, {
                    attributes: true, 
                    attributeFilter: ['class'],
                    childList: false, 
                    characterData: false
                });
            }
            var loadedMessage = {};
            loadedMessage.actionName = acnLiveChat.liveChatRequestBrandingActionName;
            acnLiveChat.postMessage(loadedMessage);
        }, acnLiveChat.liveChatInitializationTimeoutMs);
    }, 
    initializeLiveChatEmbedding: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};

		var addRule = (
			function (style) {
				var sheet = acnLiveChat.document.head.appendChild(style).sheet;
				return function (selector, css) {
					var propText = typeof css === "string" ? css : Object.keys(css).map(function (p) {
						return p + ":" + (p === "content" ? "'" + css[p] + "'" : css[p]);
					}).join(";");
					sheet.insertRule(selector + "{" + propText + "}", sheet.cssRules.length);
				};
			}
		) (acnLiveChat.document.createElement("style"));

        acnLiveChat.window.addEventListener("message", function(event) {
            //if (event.origin !== baseUrl) {
            //    console.log(baseUrl);
            //    console.log(event.origin);
            //    return;
            //}
            var message = {};
            try {
                message = acnLiveChat.JSON.parse(event.data);
            }
            catch (e) {
                //event.data cannot be deserialized
            }
            if (message && message.backgroundColor) {
                addRule("span.client:nth-last-child(1):before", {
                    background: "linear-gradient(to top, " + message.backgroundColor + " 0%, " + acn.colorShadeBlendConvert(acnLiveChat.liveChatClientMessageBubbleTailGradientPercentage, message.backgroundColor) + " 100%) !important;",
                    content: "''"
                });                    
            
                var branding = acnLiveChat.document.getElementById(acnLiveChat.brandingElementId);
                if (branding) {
                    branding.value = acnLiveChat.JSON.stringify(message);
                }
                var list = acnLiveChat.document.getElementsByTagName("button");
                for (var elementIndex in list) {
                    var element = list[elementIndex];
                    //console.log(element);
                    //console.log(message.backgroundColor);
                    try {
						element.setAttribute("style", "background-image: linear-gradient(to top, " + message.backgroundColor + " 0%, " + acn.colorShadeBlendConvert(acnLiveChat.liveChatClientMessageBubbleGradientPercentage, message.backgroundColor) + " 100%);");
					}
                    catch (e) {
                        //element is not an html element, ignore
                    }
                }
                //console.log(message.backgroundColor);
            }
        }, false);
    }, 
    cancelChatRequest: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};

        acnLiveChat.SfdcApp.LiveAgent.Chasitor.cancelChat();
        acnLiveChat.closeChat(
            {
                "from" : acnLiveChat.closeChatFromCancelChatButtonLabel
            }
        );
    }, 
    endChat: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};

        acnLiveChat.SfdcApp.LiveAgent.Chasitor.endChat();
        acnLiveChat.closeChat(
            {
                "from" : acnLiveChat.closeChatFromEndChatButtonLabel
            }
        );
    }, 
    closeChatDialog: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};

        acnLiveChat.closeChat(
            {
                "from" : acnLiveChat.closeChatFromCloseChatCustomButtonLabel
            }
        );
    }, 
    showLiveAgentStateWaitingForAgent: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};

        configObject.chatSaveEndButtonCancel.classList.add(acnLiveChat.elementDisabledStyleClassName);
        configObject.chatSaveEndButtonEnd.classList.add(acnLiveChat.elementDisabledStyleClassName);
        configObject.chatSaveEndButtonSave.classList.add(acnLiveChat.elementDisabledStyleClassName);
        if (configObject.chatSaveEndButtonsPanel) {
            configObject.chatSaveEndButtonsPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatAlertsPanel) {
            configObject.chatAlertsPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatStatusPanel) {
            configObject.chatStatusPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatWaitPanel) {
            configObject.chatWaitPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatLogPanel) {
            configObject.chatLogPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatMessagingPanel) {
            configObject.chatMessagingPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.closeButtonPanel) {
            configObject.closeButtonPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
    }, 
    showLiveAgentStateWaitingDequeued: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};

        if (configObject.chatSaveEndButtonsPanel) {
            if (acnLiveChat.collapseCancelEndChatButton) {
                configObject.chatSaveEndButtonEnd.classList.add(acnLiveChat.elementHiddenStyleClassName);
                configObject.chatSaveEndButtonCancel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
            }
            else {
                configObject.chatSaveEndButtonEnd.classList.add(acnLiveChat.elementDisabledStyleClassName);
                configObject.chatSaveEndButtonCancel.classList.remove(acnLiveChat.elementDisabledStyleClassName);
            }
            configObject.chatSaveEndButtonsPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
            configObject.chatSaveEndButtonSave.classList.add(acnLiveChat.elementDisabledStyleClassName);
        }
        if (configObject.chatAlertsPanel) {
            configObject.chatAlertsPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatStatusPanel) {
            configObject.chatStatusPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatWaitPanel) {
            configObject.chatWaitPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatLogPanel) {
            configObject.chatLogPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatMessagingPanel) {
            configObject.chatMessagingPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.closeButtonPanel) {
            configObject.closeButtonPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
    }, 
    showLiveAgentState: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};

        var isAgentAvailable = acnLiveChat.document.getElementById(acnLiveChat.agentAvailableElementId);
        if (isAgentAvailable) { 
            isAgentAvailable.value = true;
        }
        
        if (configObject.chatSaveEndButtonsPanel) {
            if (acnLiveChat.collapseCancelEndChatButton) {
                configObject.chatSaveEndButtonCancel.classList.add(acnLiveChat.elementHiddenStyleClassName);
                configObject.chatSaveEndButtonEnd.classList.remove(acnLiveChat.elementHiddenStyleClassName);
            }
            else {
                configObject.chatSaveEndButtonCancel.classList.add(acnLiveChat.elementDisabledStyleClassName);
                configObject.chatSaveEndButtonEnd.classList.remove(acnLiveChat.elementDisabledStyleClassName);
            }
            configObject.chatSaveEndButtonsPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
            configObject.chatSaveEndButtonSave.classList.add(acnLiveChat.elementDisabledStyleClassName);
            if(configObject.showEndSaveButtonsTogether) {
                //configObject.chatSaveEndButtonSave.classList.remove(acnLiveChat.elementHiddenStyleClassName);
            }
            else {
                //configObject.chatSaveEndButtonSave.classList.add(acnLiveChat.elementHiddenStyleClassName);
                //configObject.chatSaveEndButtonEnd.classList.remove("slds-size_6-of-12");
                //configObject.chatSaveEndButtonEnd.classList.add("slds-size_12-of-12");
                //configObject.chatSaveEndButtonEnd.classList.remove("slds-small-size_6-of-12");
                //configObject.chatSaveEndButtonEnd.classList.add("slds-small-size_12-of-12");
                //configObject.chatSaveEndButtonEnd.classList.remove("slds-medium-size_6-of-12");
                //configObject.chatSaveEndButtonEnd.classList.add("slds-medium-size_12-of-12");
                //configObject.chatSaveEndButtonEnd.classList.remove("slds-large-size_6-of-12");
                //configObject.chatSaveEndButtonEnd.classList.add("slds-large-size_12-of-12");
            }
        }
        if (configObject.chatAlertsPanel) {
            configObject.chatAlertsPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatStatusPanel) {
            configObject.chatStatusPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatWaitPanel) {
            configObject.chatWaitPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatLogPanel) {
            configObject.chatLogPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatMessagingPanel) {
            configObject.chatMessagingPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.closeButtonPanel) {
            configObject.closeButtonPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        
        acnLiveChat.window.setTimeout (function() {
            //scroll chat as new text shows
            var liveAgentChatLogTyping = acnLiveChat.document.getElementById(acnLiveChat.liveChatLogTypingElementId);
            if (liveAgentChatLogTyping) {
                var liveAgentChatLogTypingObserver = new MutationObserver(function (event) {
                    var logPanel = acnLiveChat.document.getElementById(acnLiveChat.liveChatLogPanelContainerElementId);
                    if (logPanel) {
                        liveAgentChatLogTyping.scrollIntoView({ behavior: 'smooth', block: 'end' });
                    }
                });
                
                liveAgentChatLogTypingObserver.observe(liveAgentChatLogTyping, {
                  attributes: true, 
                  attributeFilter: ['style', 'class', 'attributes'],
                  childList: false, 
                  characterData: false
                });

                var liveAgentChatLogText = acnLiveChat.document.getElementById(acnLiveChat.liveChatLogTextElementId);
                if (liveAgentChatLogText) {
                    var liveAgentChatLogTextObserver = new MutationObserver(function (event) {
                        var mutationRecord = event[0];
                        if (mutationRecord.addedNodes && mutationRecord.addedNodes.length > 0) {
                            var newChatMessage = mutationRecord.addedNodes[mutationRecord.addedNodes.length-1];
                            if (newChatMessage.nodeName === acnLiveChat.liveChatLogMessageElementType) {
                                if (newChatMessage.classList.contains(acnLiveChat.liveChatLogMessageClientStyleClassName)) {
                                    var messageColor = acnLiveChat.liveChatLogMessageClientDefaultBackgroundColor;
                                    var branding = acnLiveChat.document.getElementById(acnLiveChat.brandingElementId);
                                    if (branding && branding.value) {
                                        var message = acnLiveChat.JSON.parse(branding.value);
                                        if (message && message.backgroundColor) {
                                            newChatMessage.setAttribute("style", "background: linear-gradient(to top, " + message.backgroundColor + " 0%, " + acn.colorShadeBlendConvert(acnLiveChat.liveChatButtonGradientPercentage, message.backgroundColor) + " 100%) !important;");
                                        }
                                    }
                                }
                                else {
                                    var messageToPost = {};
                                    messageToPost.actionName = acnLiveChat.liveChatLogMessageActionName;
                                    messageToPost.actionValue = newChatMessage.value;
                                    acnLiveChat.postMessage(messageToPost);
                                }
								newChatMessage.scrollIntoView({ behavior: 'smooth', block: 'end' });
                            }
                        }
                    });
                    
                    liveAgentChatLogTextObserver.observe(liveAgentChatLogText, {
                      attributes: false, 
                      childList: true, 
                      characterData: false
                    });
                }
                    
            }                        
        }, acnLiveChat.liveChatInitializationTimeoutMs);
    }, 
    showLiveAgentStateEnded: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};

        var isAgentAvailable = acnLiveChat.document.getElementById(acnLiveChat.agentAvailableElementId);
        if (isAgentAvailable && !isAgentAvailable.value) { 
            //Close button should be visible
        }

        if (configObject.chatSaveEndButtonsPanel) {
            configObject.chatSaveEndButtonsPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
            configObject.chatSaveEndButtonCancel.classList.add(acnLiveChat.elementDisabledStyleClassName);
            configObject.chatSaveEndButtonEnd.classList.add(acnLiveChat.elementDisabledStyleClassName);
            configObject.chatSaveEndButtonSave.classList.remove(acnLiveChat.elementDisabledStyleClassName);
            if(configObject.showEndSaveButtonsTogether) {
                //configObject.chatSaveEndButtonEnd.classList.remove(acnLiveChat.elementHiddenStyleClassName);
            }
            else {
                //configObject.chatSaveEndButtonEnd.classList.add(acnLiveChat.elementHiddenStyleClassName);
                //configObject.chatSaveEndButtonSave.classList.remove("slds-size_6-of-12");
                //configObject.chatSaveEndButtonSave.classList.add("slds-size_12-of-12");
                //configObject.chatSaveEndButtonSave.classList.remove("slds-small-size_6-of-12");
                //configObject.chatSaveEndButtonSave.classList.add("slds-small-size_12-of-12");
                //configObject.chatSaveEndButtonSave.classList.remove("slds-medium-size_6-of-12");
                //configObject.chatSaveEndButtonSave.classList.add("slds-medium-size_12-of-12");
                //configObject.chatSaveEndButtonSave.classList.remove("slds-large-size_6-of-12");
                //configObject.chatSaveEndButtonSave.classList.add("slds-large-size_12-of-12");
            }
        }
        if (configObject.chatAlertsPanel) {
            /*configObject.chatAlertsPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);*/
        }
        if (configObject.chatStatusPanel) {
            configObject.chatStatusPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatWaitPanel) {
            configObject.chatWaitPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatLogPanel) {
            configObject.chatLogPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatMessagingPanel) {
            configObject.chatMessagingPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.closeButtonPanel) {
            configObject.closeButtonPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
    }, 
    showLiveAgentStateNotAvailable: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};
        
        if (configObject.chatSaveEndButtonsPanel) {
            configObject.chatSaveEndButtonsPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatAlertsPanel) {
            configObject.chatAlertsPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatStatusPanel) {
            configObject.chatStatusPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatWaitPanel) {
            configObject.chatWaitPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatLogPanel) {
            configObject.chatLogPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.chatMessagingPanel) {
            configObject.chatMessagingPanel.classList.add(acnLiveChat.elementHiddenStyleClassName);
        }
        if (configObject.closeButtonPanel) {
            configObject.closeButtonPanel.classList.remove(acnLiveChat.elementHiddenStyleClassName);
        }
    }, 
    showLiveAgentStateDefault: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};
        
        //console.log("showLiveAgentStateDefault");
        //configObject.log(configObject);
        configObject.chatSaveEndButtonCancel.classList.add(acnLiveChat.elementDisabledStyleClassName);
        configObject.chatSaveEndButtonEnd.classList.add(acnLiveChat.elementDisabledStyleClassName);
        configObject.chatSaveEndButtonSave.classList.remove(acnLiveChat.elementDisabledStyleClassName);
    }, 
    closeChat: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};
        
        var messageToPost = configObject;
        messageToPost.actionName = acnLiveChat.liveChatCloseChatActionName;
        acnLiveChat.postMessage(messageToPost);
    }, 
    postMessage: function (configObject) {
        var acnlib = this.acnlib;
        var acn = acnlib.acn;
        var acnLiveChat = this;
        var returnObject = {};
        
        var lightningOrigin = acnLiveChat.lightningOrigin;
        var visualForceMessage = {};
        visualForceMessage.actionName = configObject.actionName;
        visualForceMessage.originUrl = lightningOrigin;
        acnLiveChat.parent.postMessage(acnLiveChat.JSON.stringify(visualForceMessage), lightningOrigin);
    }
}
