({
	handleEdit : function(component, event, helper) {
		component.set("v.showConfirtmation",true);
	},
    closeModel : function(component, event, helper){
        component.set("v.showConfirtmation",false);
    },
    handleWithdraw : function(component, event, helper){
//   var v=window.location.href.split('/');
        let applicationId	= component.get("v.recordId");
//        applicationId=v[6];
        let action			= component.get("c.withdraw");
        action.setParams({
                applicationId : applicationId,
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if(state == "SUCCESS"){
                console.log('Application Withdrawaled !');
                component.set("v.showConfirtmation",false);
            }
            else{
                alert('ERROR');
            }
        });
        $A.enqueueAction(action);
    },
    initFlow : function(component, event, helper){
        var action = component.get("c.initFlow");
        action.setParams({ AppId : component.get('v.recordId')});
        $A.enqueueAction(action);
    }
})

//1. If withdrawing your only active TSO application and have already attended an
//airport assessment, but have not completed the medical and background
//investigation steeps, you will no longer receive consideration for a TSO position.