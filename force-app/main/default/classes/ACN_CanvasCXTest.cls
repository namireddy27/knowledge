@isTest(SeeAllData=false)
public class ACN_CanvasCXTest {
    @isTest public static void getCanvasResponseTest(){
        ACN_CanvasLibrary.CanvasRequest request = new ACN_CanvasLibrary.CanvasRequest();
        request.DataProviderName = 'ACN_CanvasProviderPowerBI';
        ACN_CanvasLibrary.CanvasResponse response = ACN_CanvasCX.GetCanvasResponse(request); 
   }
    
    @isTest public static void getSerializedCanvasResponseTest(){
        ACN_CanvasLibrary.CanvasRequest request = new ACN_CanvasLibrary.CanvasRequest();
        request.DataProviderName = 'ACN_CanvasProviderPowerBI';
        ACN_CanvasCX.getSerializedCanvasResponse(JSON.serialize(request));
    }
}