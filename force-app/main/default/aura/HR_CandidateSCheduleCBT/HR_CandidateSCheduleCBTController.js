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
                component.set("v.showButton",response.getReturnValue()); 
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
        
        clearInterval(component.get('v.timerobj'));
        clearTimeout(component.get('v.timerobj1'));
        component.set("v.timer",0); 
        component.set("v.countdowntimer",component.get('v.timeout')); 
        
        
        /* window.setTimeout(helper.getExternalSystemStatus(component, event, helper),10000);
         window.setTimeout(
            $A.getCallback(function() {
             component.set("v.isinvited",false);    
             component.set("v.externalSystemSuccess",true); 
             component.set("v.isButtonActive",true);   
                
            }), 20000
           );*/                 
        
    },
    closeModel : function(component, event, helper){
        component.set("v.showConfirtmation",false);
    },
    scheduleCBT : function(component, event, helper){          
        helper.getnewSSOlink(component, event, helper);
        component.set("v.showConfirtmation",false);  
    },
    
})

/* as of 04/20 old 

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
  						component.set("v.showButton",response.getReturnValue()); 
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    clickCBTLink : function(component, event, helper) {	
        component.set('v.showConfirmation',true);
        let applicationId	= component.get("v.recordId");
        let action			= component.get("c.updateTogetSSOLink");
        action.setParams({
            applicationId : applicationId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){
                //component.set("v.showButton",response.getReturnValue()); 
              //window.location.href ='http://www.google.com';
              window.open('http://www.google.com');
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);

//	   window.setTimeout(
//            $A.getCallback(function() {
//             component.set("v.isButtonActive",true);    
//            }), 20000
//           );                 
	},
    closeModel : function(component, event, helper){
        component.set("v.showConfirmation",false);
    },
    scheduleCBT : function(component, event, helper){          
         helper.updateSSOFieldHelper (component, event, helper);
       helper.getnewSSOlink(component, event, helper);
      component.set("v.showConfirmation",false);  
    },
  
})
*/