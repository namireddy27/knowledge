({ //automation
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
    },     // automation end
	handleEdit : function(component, event, helper) {
		component.set("v.showConfirtmation",true);
	},
    closeModel : function(component, event, helper){
        component.set("v.showConfirtmation",false);
    },
    handleWithdraw : function(component, event,helper){      
 
        let applicationId	= component.get("v.recordId");

        let action			= component.get("c.withdrawn"); //automation
        action.setParams({
            applicationId : applicationId,
        });
//        debugger;
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){
//                console.log('Application Withdrawaled !');
                component.set("v.showConfirtmation",false);
               //window.location.reload();
                $A.get('e.force:refreshView').fire();
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);         
    },
   
})