@isTest(SeeAllData=false)  
public class ACN_CanvasLibraryTest {
    @isTest public static void canvasRequestTest(){
        ACN_CanvasLibrary.CanvasRequest request = new ACN_CanvasLibrary.CanvasRequest();
    }

    @isTest public static void canvasResponseTest(){
        ACN_CanvasLibrary.CanvasResponse response = new ACN_CanvasLibrary.CanvasResponse();
        ACN_CanvasLibrary library = new ACN_CanvasLibrary();
    }
}