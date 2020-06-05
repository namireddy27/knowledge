global class ACN_NavigationTestData {
    public static Map < String, String > fillUserDataMap1() {
        Map < String, String > userDataMap = new Map < String, String > ();

        userDataMap.put('FirstName', 'Representative');
        userDataMap.put('LastName', 'Derpenstein');
        userDataMap.put('EmailEncodingKey', 'ISO-8859-1');
        userDataMap.put('Alias', 'derp');
        userDataMap.put('TimeZoneSidKey', 'America/New_York');
        userDataMap.put('LanguageLocaleKey', 'en_US');
        userDataMap.put('LocaleSidKey', 'en_US');
        userDataMap.put('CommunityNickname', 'derp');
        userDataMap.put('Email', 'derp@example.com');
        userDataMap.put('Username', 'derp@example.com');

        return userDataMap;
    }
    
    public static Id getProfileId(String profileName) {
        Id profileId;
        List < Profile > profileList = [SELECT Id FROM Profile WHERE Name =: profileName];
        if (profileList.size() > 0) {
            profileId = profileList[0].Id;
        }
        return profileId;
    }
        
    public static User createUser(Map < String, String > userDataMap, Id profileId, Id userRoleId) {
        return new User(
            FirstName = userDataMap.get('FirstName'),
            LastName = userDataMap.get('LastName'),
            EmailEncodingKey = userDataMap.get('EmailEncodingKey'),
            Email = userDataMap.get('Email'),
            Alias = userDataMap.get('Alias'),
            TimeZoneSidKey = userDataMap.get('TimeZoneSidKey'),
            Username = userDataMap.get('Username'),
            LanguageLocaleKey = userDataMap.get('LanguageLocaleKey'),
            LocaleSidKey = userDataMap.get('LocaleSidKey'),
            CommunityNickname = userDataMap.get('CommunityNickname'),
            ProfileId = profileId,
            UserRoleId = userRoleId
        );
    }
}