/**
 * Implements functionality required to delete Contact by external users.
 */
public without sharing class DeleteContactController_LT {
    @TestVisible
    static private final String delegatedAdminPermSet = 'VPR_Customer_Account_Manager';

    /**
     * Allows contacts delition by external users, returns corresponding Account Id.
     */
     @AuraEnabled
    public static Id deleteContact(Id id) {
        Id accountId = [Select AccountId From Contact Where Id = :id Limit 1].AccountId;
        Id userId = UserInfo.getUserId();
        List<User> currentUser = [
            Select ContactId
            From User
            Where Id =: userId 
            Limit 1
        ];
        if (currentUser.size() == 0 || currentUser[0].ContactId == null) {
            // disable it for internal users
            throw new AuraHandledException('Only community users can delete Account Contact via portal.');
        }
        Id currentUserAccountId = [
            Select AccountId 
            From Contact 
            Where Id = :currentUser[0].ContactId 
            Limit 1
        ].AccountId;
        // Assert perm set assignment and check current user account
        List<PermissionSetAssignment> permSetAssignments = [
            Select PermissionSetId
            From PermissionSetAssignment 
            Where AssigneeId= :UserInfo.getUserId() And PermissionSet.Name = :delegatedAdminPermSet
            Limit 1
        ];
        if (permSetAssignments.size() != 1 || currentUserAccountId != accountId) {
            throw new AuraHandledException('Access Denied.');
        }
        Database.delete(id);
        return accountId;
    }
}