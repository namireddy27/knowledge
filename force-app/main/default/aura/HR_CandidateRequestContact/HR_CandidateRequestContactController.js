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
	handleEdit : function(component, event, helper) {
        component.set("v.showConfirtmation",true);
	},
    closeModel : function(component, event, helper){
        component.set("v.showConfirtmation",false);
    },
    handleRequest: function(component, event, helper) {
		let applicationId	= component.get("v.recordId");
        let comments = component.get("v.reason");
        let action			= component.get("c.requested");
        action.setParams({
            applicationId : applicationId,
            comments :comments
        });
         action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){
                component.set("v.showConfirtmation",false);
//                var compevent = $A.get("e.c:HR_CandidateRefreshButtons");
//                compevent.fire();
                 window.location.reload();
                //$A.get('e.force:refreshView').fire(); 
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
	},
    onerror: function(component,event) {
        var error = event.getParams("error");
    }
   
})