global with sharing class ACN_CanvasCX {

    public ACN_CanvasCX() {

    }
    
    @AuraEnabled(cacheable=true)
    public static ACN_CanvasLibrary.CanvasResponse getCanvasResponse (ACN_CanvasLibrary.CanvasRequest request)  {
        ACN_CanvasLibrary.CanvasResponse response = new ACN_CanvasLibrary.CanvasResponse();
        ACN_CanvasProvider canvasProvider;
        if(!String.isEmpty(request.DataProviderName)) {
            canvasProvider = new ACN_CanvasProvider (request.DataProviderName);
            response = canvasProvider.GetCanvasResponse (request);
        }

        return response;
    }
    
    @AuraEnabled(cacheable=true)
    public static String getSerializedCanvasResponse(String serializedRequest) {
        ACN_CanvasLibrary.CanvasRequest request = (ACN_CanvasLibrary.CanvasRequest)JSON.deserialize(serializedRequest, ACN_CanvasLibrary.CanvasRequest.Class);
        return JSON.serialize(getCanvasResponse(request));
    }
}