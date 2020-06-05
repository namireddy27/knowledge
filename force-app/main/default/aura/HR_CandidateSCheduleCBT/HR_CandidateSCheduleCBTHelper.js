({
    updateSSOFieldHelper : function(component, event, helper) {
        var applicationID	= component.get("v.recordId");
        var action = component.get("c.updateTogetSSOLink");
        action.setParams({
            "applicationId" : applicationID
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                console.log('Update SSO Link !');  
                var cmpTarget = component.find('myclickButton');
                $A.util.removeClass(cmpTarget, 'slds-button');
                $A.util.removeClass(cmpTarget, 'slds-button_brand');
                $A.util.addClass(cmpTarget, 'myButton');
              /*  window.setTimeout(
                    $A.getCallback(function() {
                       helper.getnewSSOlink(component, event, helper);
                    }), 15000
                );
                               var timerObj = setInterval(function() {
                   var timer =  component.get('v.timer');
                    timer = timer + 1;
                    component.set('v.timer', timer);
                    component.set('v.countdowntimer', timeout - timer);
                    if(timer == 15)
                    {
                        clearInterval(timerObj);
                    }
                }, 1000); 
                component.set('v.timerobj', timerObj);
                component.set('v.timerobj1', timerobj1);*/
                 /*var timeout =  component.get('v.timeout');
               	var timerobj1 =  window.setTimeout(    $A.getCallback(function() {
                    	helper.getnewSSOlink(component, event, helper);
                		}), timeout * 20000 );      
               var timerObj = setInterval(function() {
                   var timer =  component.get('v.timer');
                    timer = timer + 1;
                    component.set('v.timer', timer);
                    component.set('v.countdowntimer', timeout - timer);
                    if(timer == 15)
                    {
                        clearInterval(timerObj);
                    }
                }, 1000); 
                component.set('v.timerobj', timerObj);
                component.set('v.timerobj1', timerobj1);*/

            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    
    getExternalSysStatus : function(component, event, helper){
        //  helper.getExternalSystemStatus(component,helper);
        
        window.setInterval( 
            $A.getCallback(function() {
                helper.getExternalSystemStatus(component,helper);
            }), 5000
        );   
    },
    
    getExternalSystemStatus : function(component, event, helper) {
        var applicationID	= component.get("v.recordId");
        var action = component.get("c.getExternalSystemStatus");
        action.setParams({
            "applicationId" : applicationID
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){         
                var  externalSystemStatus =response.getReturnValue();             
                
                if(externalSystemStatus =='Success'){                  
                    component.set("v.isinvited",false);          
                    component.set("v.externalSystemSuccess",true); 
                    component.set("v.isButtonActive",true);
                    var cmpTarget = component.find('myclickButton');
                    $A.util.addClass(cmpTarget, 'slds-button');
                    $A.util.addClass(cmpTarget, 'slds-button_brand');
                    $A.util.removeClass(cmpTarget, 'myButton');
                }  else if(externalSystemStatus=='System Error'){
                    component.set("v.externalSystemError",true); 
                    component.set("v.isinvited",false);
                }
                    else {
                        component.set("v.isinvited",true); 
                        //  component.set("v.isinvited",true); 
                        //  alert(" External System Status :" +response.getReturnValue());
                    }
            }
            else{
                alert('ERROR');
            }
        });
        
        $A.enqueueAction(action); 
    },
    
    getnewSSOlink : function(component, event, helper) {
        var applicationID	= component.get("v.recordId");
        var action = component.get("c.getnewSSOLink");
        action.setParams({
            "applicationId" : applicationID
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == "SUCCESS"){                
                console.log('New SSO Link!');
                //  alert(" SSO link :" +response.getReturnValue());
                
                var  urllink =response.getReturnValue();
                console.log('New SSO Link! :'+urllink );
                
                // window.open(urllink);
                
                this.navigateToURL(component,urllink);
                
                component.set("v.showConfirtmation",false);               
                
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action); 
    },
    
    navigateToURL :function(component,urllink){
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": urllink
        });
        urlEvent.fire();
    }
})