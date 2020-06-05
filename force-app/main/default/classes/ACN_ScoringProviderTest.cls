@isTest(SeeAllData=True)
public class ACN_ScoringProviderTest {
  
    @isTest public static void GetScoringResponseTestMethod(){
        try{
        test.startTest();
        ACN_ScoringLibrary.ScoringRequest request =new ACN_ScoringLibrary.ScoringRequest();
        ACN_ScoringProvider scoringProvider = new ACN_ScoringProvider(request.scoringProviderName);
        ACN_ScoringLibrary.ScoringResponse Response=scoringProvider.GetScoringResponse(request);
        test.stopTest();
        }
        catch(exception e)
       {
           system.debug('####'+e.getMessage()); 
        }
    }  
    
   
}