({
    doInit: function(component, event, helper) {
        let applicationId	= component.get("v.recordId");
        let action			= component.get("c.getButtonDetails");
        action.setParams({
            applicationId : applicationId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){
                let outputResonse = response.getReturnValue();
                if(outputResonse ==null) {
                    component.set("v.showButton",false); 
                } else{
                    component.set("v.scheduleCBT",outputResonse.scheduleCBT);  
                    component.set("v.scheduleMedical",outputResonse.scheduleMedical);
                    component.set("v.cancelSchedule",outputResonse.cancelSchedule);

                }
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    
    clickCBTLink : function(component, event, helper) {	
        helper.updateSSOFieldHelper (component, event, helper);
        component.set("v.showConfirtmation",true);
        helper.getExternalSysStatus(component, event, helper); 
        component.set("v.isInvited",true);
        component.set("v.externalSystemSuccess",false);
        component.set("v.externalSystemError",false);
        component.set("v.candidateNotfound",false); 
        
        var sec = 60;
        var timer = setInterval(function() {
            component.set("v.timer", timer); 
            // Display the result in the element with id="demo"
            var timeLeft =  sec-- ;
            component.set("v.timeLeft", timeLeft);
            if(sec==30){
                component.set("v.isInvited",false);
                component.set("v.externalSystemError",true);
                //$A.get('e.force.refreshView').fire();
                //window.location.reload();
                var v = component.get("v.timer");
                return false;
                //   window.clearInterval(timer);
                
            } 
            else if(sec==10){
                component.set("v.isInvited",false);
                component.set("v.externalSystemError",true);
                //                 $A.get('e.force.refreshView').fire();
                //window.location.reload();
                component.set("v.showConfirtmation",false);
                //         component.set("v.timeLeft", 0);
                var v = component.get("v.timer");
                window.clearInterval(v);
                ///window.location.reload();
                $A.get('e.force.refreshView').fire();
            }
            
        }, 1000);
        
        
    },
    closeModel : function(component, event, helper){
        component.set("v.showConfirtmation",false);
        //         component.set("v.timeLeft", 0);
        var v = component.get("v.timer");
        window.clearInterval(v);
        window.location.reload();
        $A.get('e.force.refreshView').fire();
        
    },
    
    scheduleCBT : function(component, event, helper){         
        
        helper.getnewSSOlink(component, event, helper);        
        component.set("v.showConfirtmation",false); 
        window.location.reload();
        //$A.get('e.force.refreshView').fire();
    },
    
    
    
})