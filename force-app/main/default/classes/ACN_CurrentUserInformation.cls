public class ACN_CurrentUserInformation {
    @AuraEnabled
    public static String GetUserName() {
        return userinfo.getName();
    }

    @AuraEnabled
    public static String SerializedCurrentUserInfo() {
        return JSON.serialize(ACN_CurrentUserInformation.CurrentUserInfo());
    }

    @AuraEnabled
    public static Map<String,String> CurrentUserInfo() {
        Map<String,String> UserInfoMap = new Map<String,String>();
        String userId = UserInfo.getUserId();
        
        UserInfoMap.put('DefaultCurrency', UserInfo.getDefaultCurrency());
        UserInfoMap.put('FirstName', UserInfo.getFirstName());
        UserInfoMap.put('Language', UserInfo.getLanguage());
        UserInfoMap.put('LastName', UserInfo.getLastName());
        UserInfoMap.put('Locale', UserInfo.getLocale());
        UserInfoMap.put('Name', UserInfo.getName());
        UserInfoMap.put('OrganizationId', UserInfo.getOrganizationId());
        UserInfoMap.put('OrganizationName', UserInfo.getOrganizationName());
        UserInfoMap.put('ProfileId', UserInfo.getProfileId());
        //UserInfoMap.put('TimeZone', JSON.serialize(UserInfo.getTimeZone()));
        UserInfoMap.put('UiTheme', UserInfo.getUiTheme());
        UserInfoMap.put('UserEmail', UserInfo.getUserEmail());
        UserInfoMap.put('UserId', userId);
        UserInfoMap.put('UserName', UserInfo.getUserName());
        UserInfoMap.put('UserRoleId', UserInfo.getUserRoleId());
        UserInfoMap.put('UserType', UserInfo.getUserType());
        //UserInfoMap.put('IsCurrentUserLicensed', JSON.serialize(UserInfo.isCurrentUserLicensed()));
        UserInfoMap.put('IsMultiCurrencyOrganization', JSON.serialize(UserInfo.isMultiCurrencyOrganization()));
        
        Map<String, Schema.FieldSetMember> userInfoFieldNames = new Map<String, Schema.FieldSetMember>();
        
        if (SObjectType.User.FieldSets != null && SObjectType.User.FieldSets.getMap() != null && SObjectType.User.FieldSets.getMap().size() > 0 && SObjectType.User.FieldSets.getMap().containsKey('ACN_CurrentUserInformation')) {
            Schema.FieldSet userInfoFieldSet = SObjectType.User.FieldSets.getMap().get('ACN_CurrentUserInformation');
            for(Schema.FieldSetMember fieldSetMember : userInfoFieldSet.getFields()) {
                userInfoFieldNames.put(fieldSetMember.getFieldPath(), fieldSetMember);
            }
        }
        else {
            userInfoFieldNames.put('Id', null);
        }
        List<String> userInfoFieldsList = new List<String>();
        userInfoFieldsList.addAll(userInfoFieldNames.keySet());
        
        String userInfoSoql = 'SELECT ';
        userInfoSoql += String.join(userInfoFieldsList, ', ') + ' ';
        userInfoSoql += 'FROM User ';
        userInfoSoql += 'WHERE Id = :userId ';
        userInfoSoql += 'LIMIT 1 ';
        
        List<User> usersList = Database.query(userInfoSoql);
        for (String fieldName : userInfoFieldNames.keySet()) {
            UserInfoMap.put(fieldName, String.valueOf(usersList[0].get(fieldName)));
        }
        
        //UserInfoMap.put('ACN_HasTemporaryAuthorization', JSON.serialize(usersList[0].ACN_HasTemporaryAuthorization__c));
        //UserInfoMap.put('ACN_TemporaryAuthorizationEndDate', JSON.serialize(usersList[0].ACN_TemporaryAuthorizationEndDate__c));
        
        
        return UserInfoMap;
    }
}