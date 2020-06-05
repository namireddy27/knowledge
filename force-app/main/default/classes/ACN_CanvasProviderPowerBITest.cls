@isTest(SeeAllData=false)
public class ACN_CanvasProviderPowerBITest {
     @isTest(SeeAllData=true) static void testGetCanvasResponse() {
         ACN_CanvasProviderPowerBI canvasProviderPowerBI = new ACN_CanvasProviderPowerBI();
         ACN_CanvasLibrary.CanvasRequest request = new ACN_CanvasLibrary.CanvasRequest();
         ACN_CanvasLibrary.CanvasResponse response = canvasProviderPowerBI.GetCanvasResponse(request );
         
         //To-do: asserts here!!!
     }
}