/**
 * Aux. data service for custom data binding.
 */
public inherited sharing class CommunityDataService {
    // TODO: review if we need it along with account information for custom profile menu etc.
    public static Object getCurrentUserContact() {
        Id userId = UserInfo.getUserId();
        return (String)[
            Select ContactId
            From User
            Where Id =: userId 
            Limit 1
        ].ContactId;
    }

    /**
     * Allows obtaining BLM Products for specified Case Group
     */
    public static List<NGPS_Product__c> getProductsForRecordType(String caseGroup) {
        return [
            Select Id, Name
            From NGPS_Product__c
            Where Case_Group__c =: caseGroup
        ];
    }

    /**
     * Obtains list of claims availalbe to current user.
     */
    public static List<NGPS_Case__c> getRelatedClaims() {
        Id userId = UserInfo.getUserId();
        List<User> currentUser = [
            Select ContactId
            From User
            Where Id =: userId 
            Limit 1
        ];
        if (currentUser.size() == 0 || currentUser[0].ContactId == null) {
            // disable it for internal users
            throw new AuraHandledException('Only community users can access related claims.');
        }
        Id currentUserAccountId = [
            Select AccountId 
            From Contact 
            Where Id = :currentUser[0].ContactId 
            Limit 1
        ].AccountId;
        // find all cases related to this account
        // TODO: review in case infinite scrall will be added
        List<Id> connectedIds = new List<Id>();
        for (Case_Customer__c cc : [Select NGPS_Case__r.Id From Case_Customer__c Where Account__r.Id =: currentUserAccountId]) {
            connectedIds.add(cc.NGPS_Case__r.Id);
        }
        return [
            Select Id, Case_Name__c, Serial_Number__c, Case_Status__c
            From NGPS_Case__c
            Where Id In :connectedIds
        ];
    }

    /**
     * Obtains BLM_Case__c asserting current user authorization.
     */
    public static NGPS_Case__c getClaimDetails(Id recordId) {
        Id userId = UserInfo.getUserId();
        List<User> currentUser = [
            Select ContactId
            From User
            Where Id =: userId 
            Limit 1
        ];
        if (currentUser.size() == 0 || currentUser[0].ContactId == null) {
            // disable it for internal users
            throw new AuraHandledException('Only community users can access claims related to their accounts.');
        }
        Id currentUserAccountId = [
            Select AccountId 
            From Contact 
            Where Id = :currentUser[0].ContactId 
            Limit 1
        ].AccountId;
        List<Case_Customer__c> caseCustomers = [
            Select NGPS_Case__r.Id, Account__r.Id
            From Case_Customer__c 
            Where NGPS_Case__r.Id =: recordId
        ];
        for (Case_Customer__c caseCustomer : caseCustomers) {
            if (caseCustomer.Account__r.Id == currentUserAccountId) {
                return [
                    Select Id, Case_Name__c, Serial_Number__c, Case_Status__c
                    From NGPS_Case__c
                    Where Id =: recordId
                    Limit 1
                ];
            }
        }
        throw new AuraHandledException('Anauthorized.');
    }
}