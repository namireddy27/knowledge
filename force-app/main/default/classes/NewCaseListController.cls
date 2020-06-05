public class NewCaseListController {
    Public List<Case> getNewCases(){
        List<Case> cases = [SELECT Id, CaseNumber FROM Case WHERE status= 'New'];
        return cases;
        
    }

}