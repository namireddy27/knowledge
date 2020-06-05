({
	doInit : function(component, event, helper) {
        var v=window.location.href.split('/');
        let applicationId = v[6];
        component.set('v.applicaitonId', applicationId);
		
	},
    uploadDocument:  function(component, event, helper) {
      
		component.set("v.showUploadDocument", true);
	},
   closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.showUploadDocument", false);
   },
  
   submitDetails: function(component, event, helper) {
      // Set isModalOpen attribute to false
      //Add your code to call apex method or do some processing
      component.set("v.showUploadDocument", false);
   }
})