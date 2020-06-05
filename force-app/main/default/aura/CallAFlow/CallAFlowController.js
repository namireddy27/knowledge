({
    init : function (component) {
        // Find the component whose aura:id is "flowData"
        var flow = component.find("flowData");
       
        // In that component, start your flow. Reference the flow's Unique Name.
        flow.startFlow("InboundNewApponitment", inputVariables );
         component.set("v.isModalOpen", false);
    },
    openModel: function (component) {
         component.set("v.isModalOpen", true);
    },
     closeModel: function(component, event, helper) {
      // Set isModalOpen attribute to false  
      component.set("v.isModalOpen", false);
   },

})