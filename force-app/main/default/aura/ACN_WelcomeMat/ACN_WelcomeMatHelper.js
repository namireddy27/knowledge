({
    displayMergedMessages: function(component, event, helper) {
        var action = component.get("c.SerializedCurrentUserInfo");
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var userInfo = JSON.parse(response.getReturnValue());
                component.set("v.loginUserName", userInfo.FirstName);
                component.set("v.UserInfo", userInfo);
                var greetingMessage = component.get("v.greetingMessage");
                var welcomeMessage = component.get("v.welcomeMessage");
                for (var propertyName in userInfo) {
                    if (greetingMessage.indexOf(propertyName) > -1) {
                        greetingMessage = helper.replaceAll(greetingMessage, "%userInfo." + propertyName + "%", userInfo[propertyName] ? userInfo[propertyName] : '');
                    }
                    if (welcomeMessage.indexOf(propertyName) > -1) {
                        welcomeMessage = helper.replaceAll(welcomeMessage, "%userInfo." + propertyName + "%", userInfo[propertyName] ? userInfo[propertyName] : '');
                    }
                }
                
                var url = location.search;
                var regex = /[?&]([^=#]+)=([^&#]*)/g;
                var match;
                while(match = regex.exec(url)) {
                    var queryParamName = match[1];
                    var queryParamValue = match[2];
                    queryParamValue = helper.replaceAll(queryParamValue, "\\\+", " ");
                    var utf8bytes = unescape(queryParamValue);
                    queryParamValue = decodeURIComponent(utf8bytes);
                    if (greetingMessage.indexOf(queryParamName) > -1) {
                        greetingMessage = helper.replaceAll(greetingMessage, "%queryParam." + queryParamName + "%", queryParamValue ? queryParamValue : '');
                    }
                    if (welcomeMessage.indexOf(queryParamName) > -1) {
                        welcomeMessage = helper.replaceAll(welcomeMessage, "%queryParam." + queryParamName + "%", queryParamValue ? queryParamValue : '');
                    }
                }
                
                component.set("v.greetingMessage", greetingMessage);
                component.set("v.welcomeMessage", welcomeMessage);
                component.set("v.showMessage", true);
            }
        });
        $A.enqueueAction(action);		
    }, 
    replaceAll: function(originalString, search, replacement) {
    	return originalString.replace(new RegExp(search, 'g'), replacement);
    }
})