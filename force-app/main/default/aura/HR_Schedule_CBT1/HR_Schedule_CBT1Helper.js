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
                var cmpTarget = component.find('myscheduleButton');
                $A.util.removeClass(cmpTarget, 'slds-button');
                $A.util.removeClass(cmpTarget, 'slds-button_brand');
                $A.util.addClass(cmpTarget, 'myCBTButton');
            }
            else{
                alert('ERROR');
            }
            
        });
        $A.enqueueAction(action);
    },
    
    getExternalSysStatus : function(component, event, helper){
        //  helper.getExternalSystemStatus(component,helper);
        
       var timer2= window.setInterval( 
            $A.getCallback(function() {
                component.set('v.timer2',timer2);
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
                    component.set("v.isInvited",false);          
                    component.set("v.externalSystemSuccess",true); 
                    component.set("v.isButtonActive",true);
                    var v = component.get("v.timer");
                    window.clearInterval(v);
                    var timer2 = component.get("v.timer2");
                    window.clearInterval(timer2);
                    component.set("v.externalSystemError",false);
                    var cmpTarget = component.find('myscheduleButton');
                    $A.util.addClass(cmpTarget, 'slds-button');
                    $A.util.addClass(cmpTarget, 'slds-button_brand');
                    $A.util.removeClass(cmpTarget, 'myCBTButton');
                    var v = component.get("v.timer");
                    window.clearInterval(v);
                     
                }  else if(externalSystemStatus=='System Error'){
                    component.set("v.externalSystemError",true); 
                    component.set("v.isInvited",false);
                    var v = component.get("v.timer");
                    window.clearInterval(v);
                    var timer2 = component.get("v.timer2");
                    window.clearInterval(timer2);
                    
                } else if(externalSystemStatus=='Candidate Not Found'){
                    component.set("v.candidateNotfound",true); 
                    component.set("v.isInvited",false);
                    var v = component.get("v.timer");
                    window.clearInterval(v);
                    var timer2 = component.get("v.timer2");
                    window.clearInterval(timer2);
                }
                
                    else {
                        //myscheduleButton
                        $A.util.removeClass(cmpTarget, 'slds-button');
                        $A.util.removeClass(cmpTarget, 'slds-button_brand');
                        $A.util.addClass(cmpTarget, 'myCBTButton');
                        component.set("v.isInvited",true); 
                     /*   var v = component.get("v.timer");
                        window.clearInterval(v);*/
                        
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
                
                //  window.open("https://www.w3schools.com");
                
                this.navigateToURL(component,urllink);
                component.set("v.showConfirtmation",false);               
                // this.navigateToURL(component,urllink);
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
        var v = component.get("v.timer");
        window.clearInterval(v);
    }
    
})