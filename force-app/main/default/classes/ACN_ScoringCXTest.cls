@isTest(SeeAllData=True)
public class ACN_ScoringCXTest {
    
    @isTest public static void  ACN_ScoringCXTestMethod(){
        try{
         ACN_ScoringCX ScorCX = new  ACN_ScoringCX();
         ACN_ScoringLibrary.ScoringRequest request = new ACN_ScoringLibrary.ScoringRequest();
         ACN_ScoringCX.scoringResponseJSON();
            ACN_ScoringCX.getScoringResponse(request);
            ACN_ScoringCX.getSerializedscoringResponse('Test Response');
            ACN_ScoringCX.getObjectPrefix('Account');
            }
        catch(Exception e)
        {
            system.debug('####'+e.getMessage());
        }
    }
}