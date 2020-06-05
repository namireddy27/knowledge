global with sharing class ACN_NavigationLibrary {
/*
    public class MethodNotImplementedException extends Exception {
    }
    public class ItemCommunityMissingException extends Exception {
    }
    public enum SortingDirection {Ascending, Descending, None}

    global class NavigationDeflectionRequest {
        public String Id {get; set;}
        public String NavigationDeflectionProviderName {get; set;}
        public String CurrentPage {get; set;}
        public String TargetPage {get; set;}
        public List<String> AllowedTags {get; set;}
        public String CurrentTag {get; set;}
        public Map<String, String> AllowedTagTargetPageMap {get; set;}
        public Boolean ShowDeflectionDialog {get; set;}
        
        global NavigationDeflectionRequest () {
            this.ShowDeflectionDialog = false;
            this.AllowedTags = new List<String>();
            this.AllowedTagTargetPageMap = new Map<String, String>();
        }
    }

    global class NavigationDeflectionResponse {
        public String Id {get; set;}
        public String NavigationDeflectionProviderName {get; set;}
        public String CurrentPage {get; set;}
        public String TargetPage {get; set;}
        public List<String> AllowedTags {get; set;}
        public String CurrentTag {get; set;}
        public Map<String, String> AllowedTagTargetPageMap {get; set;}
        public Boolean ShowDeflectionDialog {get; set;}
        
        global NavigationDeflectionResponse () {
            this.ShowDeflectionDialog = false;
            this.AllowedTags = new List<String>();
            this.AllowedTagTargetPageMap = new Map<String, String>();
        }
    }

    // ACN_NavigationLibrary.NavigationRequest
    global class NavigationRequest {
        public String Id {get; set;}
        public Boolean IsIdRequired {get; set;}
        public String DefaultId {get; set;}
        public String SelectedId {get; set;}
        public Boolean GoToItem {get; set;}
        public Boolean ShowAllDescendants {get; set;}
        public Integer Level {get; set;}
        public Boolean GoUp {get; set;}
        public Boolean GoPrevious {get; set;}
        public String Previous {get; set;}
        public Boolean GoNext {get; set;}
        public String Next {get; set;}
        public String LastParentId {get; set;}
        public String NavigationProviderName {get;set;}
        public Boolean IncludeRecommendations {get; set;}
        public Boolean IncludeParentNavigationItem {get; set;}
        public Boolean UseContextForCarousel {get; set;}
        public Boolean IsMenuItem {get; set;}
        public Boolean ShowArticleViewCount {get; set;}
        public Boolean ShowPublishDate {get; set;}
        public Boolean ShowArticleType {get; set;}
        public Boolean ShowArticleRating {get; set;}
        public Boolean ShowSmallImage {get; set;}
        public Boolean ShowGroups {get; set;}
        public Boolean DoRefreshAll {get; set;}
        public String BrowserFormFactor {get; set;}
        public Map<String, String> ExtendedProperty {get; set;}
        public List<String> Filter {get; set;}
        public List<String> Sorting {get; set;}
        public String NameFieldOverride {get;set;}
        public String DescriptionFieldOverride {get;set;}
        public String ImageFieldOverride {get;set;}
        public String TargetFieldOverride {get;set;}
        public String SortFieldOverride {get;set;}
        public String GroupFieldOverride {get;set;}
        public String ItemGridSize {get;set;}
        public String GroupItemGridSize {get;set;}
        public Integer PageSize {get;set;}
        public Integer CurrentPage {get;set;}
        public Integer ItemsOffset {get;set;}
        public Boolean IsInfiniteLoading {get;set;}
        public Boolean IsLastItemPresent {get;set;}
        public Integer ItemsCountLimit {get;set;}
        public String ComponentId {get; set;}
        public String CurrentSortDirection {get; set;}
        public Boolean IsInitialLoad {get; set;}
        
        global NavigationRequest() {
            //Level = 1;
            this.IsIdRequired = false;
            this.IncludeRecommendations = false;
            this.ShowSmallImage = false;
            this.Filter = new List<String>();
            this.DoRefreshAll = false;
            this.ShowGroups = false;
            this.ExtendedProperty = new Map<String, String>();
            this.IncludeParentNavigationItem = false;
            this.PageSize = 0;
            this.CurrentPage = 0;
            this.ItemsOffset = 0;
            this.ItemsCountLimit = 0;
            this.IsInfiniteLoading = false;
            this.IsInitialLoad = false;
        }
    }
    
    global class NavigationListItem {
        public String Id {get; set;}
        public String Name {get;set;}
        public String Description {get;set;}
        public String Code {get;set;}
        public String SmallImageUrl {get;set;}
        public String LargeImageUrl {get;set;}
        public String ImageUrl {get;set;}
        public List<String> Link {get;set;}
        public String TargetUrl {get;set;}
        public Integer ContentRows {get;set;}
        public Integer ContentColumns {get;set;}
        public Integer Level{get;set;}
        public String GroupName {get;set;}
        public Integer GroupNumber {get;set;}
        public String SortName {get;set;}
        public String StyleClassName {get;set;}
        public String NavigationType {get;set;}
        public String NavigationTarget {get;set;}
        public Map<String,String> NavigationTargetVariable {get;set;}
        public String SerializedNavigationTargetVariable {get;set;}
        public List<List<NavigationListItemContent>> ItemContent {get;set;}
        public List<String> Badge {get;set;}
        public List<String> Scoring {get;set;}
        public Boolean ShowInCarousel {get;set;}
        public Boolean ShowInNavigationList {get;set;}
        public Boolean IsMenuItem {get;set;}
        public Boolean IsDefault {get;set;}
        public Boolean IsTemplateItem {get;set;}
        public Boolean IsSortableItem {get;set;}
        public Boolean IsFilterableItem {get;set;}
        public Boolean IsGroupableItem {get;set;}
        public List<String> Filter {get; set;}
        public Integer Order {get; set;}
        public String Index {get; set;}
        public Map<String, String> ExtendedProperty {get; set;}
        public String NameFieldOverride {get;set;}
        public String DescriptionFieldOverride {get;set;}
        public String ImageFieldOverride {get;set;}
        public String TargetFieldOverride {get;set;}
        public Boolean IsSelected {get; set;}
        public String ItemGridSize {get;set;}
        public String ItemGridSizeDefault {get;set;}
        public String ItemGridSizeDesktop {get;set;}
        public String ItemGridSizeTablet {get;set;}
        public String ItemGridSizePhone {get;set;}
        public Boolean ShowInterstitial {get;set;}
        public String ParentId {get; set;}
        public String DecorationClassItemBody {get; set;}
        public String DecorationClassItemBodyBlock01 {get; set;}
        public String DecorationClassItemBodyBlock02 {get; set;}
        public String DecorationClassItemBodyBlock03 {get; set;}
        
        global NavigationListItem () {
            this.Link = new List<String>();
            this.ItemContent = new List<List<NavigationListItemContent>>();
            this.NavigationTargetVariable = new Map<String,String>();
            this.Badge = new List<String>();
            this.Scoring = new List<String>();
            this.Filter = new List<String>();
            this.Order = -1;
            List<NavigationListItemContent> itemContent = new List<NavigationListItemContent>();
            NavigationListItemContent ic = new NavigationListItemContent();
            itemContent.add(ic);
            this.ItemContent.add(itemContent);
            this.ExtendedProperty = new Map<String, String>();
            this.IsSelected = false;
            this.IsSortableItem = false;
            this.IsFilterableItem = false;
            this.IsGroupableItem = false;
        }
    }
    
    global class NavigationBadge {
        public String Id {get; set;}
        public String Name {get;set;}    
        public String Value {get;set;}    
        public String Type {get;set;}    
        public String ImageUrl {get;set;}    
        public String StyleClass {get;set;}    
    }
    
    global class NavigationListItemContent {
        public Integer CellIndex {get;set;}
        public String Content {get;set;}
    }
    
    global class NavigationList {
        public String ParentId {get; set;}
        public List<NavigationListItem> Items {get; set;}
        public Map<String,NavigationListItem> GroupItems {get; set;}
        public Map<String,NavigationListItem> GroupFooterItems {get; set;}
        public Integer MinimumColumns {get; set;}
        public Boolean IsInitialized {get; set;}
        public Boolean DoRefreshAll {get; set;}
        public Boolean hasErrors {get;set;}
        public String errors {get;set;}
        public String homePageLabel {get;set;}
        public List<NavigationFilterItem> FilterItem {get; set;}
        public List<NavigationSortingItem> SortingItem {get; set;}
        public Map<String, String> ExtendedProperty {get; set;}
        public String ItemGridSize {get;set;}
        public String GroupItemGridSize {get;set;}
        public String GroupItemGridSizeDefault {get;set;}
        public String GroupItemGridSizeDesktop {get;set;}
        public String GroupItemGridSizeTablet {get;set;}
        public String GroupItemGridSizePhone {get;set;}
        public Integer PageSize {get;set;}
        public Integer CurrentPage {get;set;}
        public Integer ItemsOffset {get;set;}
        public Boolean IsInfiniteLoading {get;set;}
        public Integer ItemsCountLimit {get;set;}
        public Boolean IsLastItemPresent {get;set;}
        public String ComponentId {get; set;}
        public String CurrentSortDirection {get; set;}
        public Boolean IsInitialLoad {get; set;}
        
        global NavigationList () {
            this.Items = new List<NavigationListItem>();
            this.GroupItems = new Map<String,NavigationListItem>();
            this.GroupFooterItems = new Map<String,NavigationListItem>();
            this.IsInitialized = false;
            this.FilterItem = new List<NavigationFilterItem>();
            this.DoRefreshAll = false;
            this.ExtendedProperty = new Map<String, String>();
            this.PageSize = 0;
            this.CurrentPage = 0;
            this.ItemsOffset = 0;
            this.ItemsCountLimit = 0;
            this.IsInfiniteLoading = false;
            this.IsInitialLoad = false;
        }
    }
    
    global class NavigationPathSegment {
        public String Name {get;set;}
        public String Id {get;set;}
        public Integer Level {get;set;}
        public String ImageUrl {get;set;}
    }

    global class VoteStat {
        public Id EntityId {get;set;}
        public Integer NumVotes {get;set;}
        public Integer TotalRating {get;set;}

        public Double getAverageRating() {
            return (Double)TotalRating / NumVotes;
        }
    }

    global static Id GetCurrentCommunityId () {
        Id communityId = Network.getNetworkId();
        return communityId;
    }

    global class NavigationItem {
        public String Name {get;set;}
        public String Type {get;set;}
        public String Id {get;set;}
        public Integer Level {get;set;}
        public String ImageUrl {get;set;}
        public String CommunityId {get;set;}
        public String CommunityItemURL {get;set;}
     }

    global class ItemRequest {
        public String ItemName {get;set;}
        public String ItemType {get;set;}
        public String ItemDefaultGroup {get;set;}
        public String ItemId {get;set;}
        public Integer ItemLevel {get;set;}
        public String ItemCommunityId {get;set;}
        public Map<String, String> ExtendedProperty {get; set;}

        global ItemRequest () {
            this.ExtendedProperty = new Map<String, String>();
        }
    }

    global class NavigationFilterItem implements comparable {
        public String Id {get;set;}
        public String Name {get;set;}
        public String Type {get;set;}
        public String FilterIdentifier {get;set;}
        public String GroupName {get;set;}
        public Integer Level {get;set;}
        public String SortKey {get;set;}
        public String AttributeName {get;set;}
        public String AttributeOperator {get;set;}
        public String AttributeValue {get;set;}
        public Boolean IsMultipleSelection {get;set;}
        public Boolean IsSelected {get;set;}
        public Boolean IsClearAll {get;set;}

        public Integer compareTo(Object compareToFilterItem) {
            NavigationFilterItem navigationFilterItem = (NavigationFilterItem)compareToFilterItem;
            if(this.SortKey == navigationFilterItem.SortKey) return 0;
            if(this.SortKey > navigationFilterItem.SortKey) return 1;
            return -1;
        }
    }
   
    global class NavigationSortingItem {
        public String Id {get;set;}
        public String Name {get;set;}
        public String Type {get;set;}
        public String SortIdentifier {get;set;}
        public String GroupName {get;set;}
        public Integer Level {get;set;}
        public Integer Order {get;set;}
        public String SortName {get;set;}
        public String SortValue {get;set;}
        public String SortDirection {get;set;}
        public Boolean IsActive {get;set;}
        
        public NavigationSortingItem() {
            this.Level = 0;
            this.Order = 0;
            this.IsActive = false;
        }
    }

    public class ACN_KeyValuePair implements Comparable {
        public String Key {get; set;}
        public String Value {get; set;}
        public Boolean IsKeyCompared {get; set;}
        public SortingDirection Direction {get; set;}

        public ACN_KeyValuePair() {
        }
        
        public ACN_KeyValuePair(String key, String value, SortingDirection direction) {
            this.Key = key;
            this.Value = value;
            this.IsKeyCompared = false;
            this.Direction = direction;
        }

        public ACN_KeyValuePair(String key, String value) {
            this.Key = key;
            this.Value = value;
            this.IsKeyCompared = false;
            this.Direction = SortingDirection.Ascending;
        }
        
        public Integer compareTo(Object compareToKeyValuePair) {
            ACN_KeyValuePair keyValuePair = (ACN_KeyValuePair)compareToKeyValuePair;
            if (this.IsKeyCompared) {
                if(this.Key == keyValuePair.Key) return 0;
                if(this.Key > keyValuePair.Key) return (this.Direction == SortingDirection.Ascending ? 1 : -1);
                return (this.Direction == SortingDirection.Ascending ? -1 : 1);
            }
            else {
                if(this.Value.toLowerCase() == keyValuePair.Value.toLowerCase()) return 0;
                if(this.Value.toLowerCase() > keyValuePair.Value.toLowerCase()) return (this.Direction == SortingDirection.Ascending ? 1 : -1);
                return (this.Direction == SortingDirection.Ascending ? -1 : 1);
            }
        }
    }
   
    global static List<NavigationItem> getNavigationTopics (ItemRequest request) {
        List<NavigationItem> items = new List<NavigationItem>();
        //ConnectApi.ManagedTopicCollection topicCollection = new ConnectApi.ManagedTopicCollection ();
        List<Topic> topicRecords = new List<Topic>();
        
        if (String.isBlank(request.ItemCommunityId)) {
            request.ItemCommunityId = GetCurrentCommunityId();
            if (String.isBlank(request.ItemCommunityId)) {
                throw new ItemCommunityMissingException();
            }
        }

        String communityId = request.ItemCommunityId;
        String itemName = request.ItemName;
        String itemId = request.ItemId;

        String itemsSoql = '';
        itemsSoql += 'SELECT ';
        itemsSoql += 'Id, Name, Description, NetworkId ';
        itemsSoql += 'FROM Topic ';
        itemsSoql += 'WHERE NetworkId = :communityId ';

        if (!String.isBlank(request.ItemType)) {
            //topicCollection = ConnectApi.getManagedTopics(communityId);
        } 
        else {
            //topicCollection = ConnectApi.getManagedTopics(communityId, request.TopicType);
        }

        if (!String.isBlank(request.ItemName)) {
            itemsSoql += 'AND Name = :itemName ';
        } 

        if (!String.isBlank(request.ItemId)) {
            itemsSoql += 'AND Id = :itemId ';
        } 

        topicRecords = Database.query(itemsSoql);
        
        for (Topic topicRecord : topicRecords) {
            NavigationItem navItem = new NavigationItem();
            navItem.Name = topicRecord.Name.replace(':','').replace(' ','-');
            //navItem.Type = topicRecord.Type;
            navItem.Id = topicRecord.Id;
            //navItem.Level = topicRecord.Level;
            //navItem.ImageUrl = topicRecord.Image;
            //navItem.CommunityId = topicRecord.NetworkId;
            navItem.CommunityItemURL = '/topic/' + navItem.Id + '/' + EncodingUtil.urlEncode(navItem.Name,'UTF-8');
            
            items.add(navItem);
        }
        
        return items;
    }

    global static String getPathForListViewName(String sObjectType, String listViewName) {
        if( listViewName == 'Recent' ) {
            return listViewName;
        }
        else {
            return getListViewId(sObjectType, listViewName);
        }
    }

    global static String getListViewId (String sObjectType, String listViewName) {
        List<ListView> defaultListViewList = 
            [SELECT Id FROM ListView 
             WHERE SobjectType = :sObjectType AND Name = :listViewName 
             LIMIT 1];
        if (defaultListViewList.size() == 1) {
            return defaultListViewList[0].Id;
        }
        else {
            return null;
        }
    }

    global static List<NavigationItem> getObjectNavigationItems (ItemRequest request) {
        List<NavigationItem> items = new List<NavigationItem>();
        
        ACN_CommunityNavigationConfig__c navSettings = ACN_CommunityNavigationConfig__c.getInstance();
        String defaultListViewName = navSettings.DefaultListViewName__c;

        NavigationItem navItem = new NavigationItem();
        navItem.Name = request.ItemName;

        String itemListViewPath;
        if (!String.isBlank(request.ItemDefaultGroup)) {
            itemListViewPath = getPathForListViewName(navItem.name, request.ItemDefaultGroup);
        }

        if(itemListViewPath == null) {
            itemListViewPath = getPathForListViewName(navItem.name, defaultListViewName);
        }

        navItem.CommunityItemURL = '/recordlist/' + navItem.Name + '/' + itemListViewPath;
        items.add(navItem);
        
        return items;
    }

    global static List<NavigationItem> getPageNavigationItems (ItemRequest request) {
        List<NavigationItem> items = new List<NavigationItem>();
        
        NavigationItem navItem = new NavigationItem();
        navItem.Name = request.ItemName.toLowerCase().replaceAll(' ', '-');
        navItem.CommunityItemURL = '/' + navItem.Name;
        if (request.extendedProperty != null && request.extendedProperty.size()>0) {
            String queryParamSeparator = '?';
            for (String queryParamName : request.ExtendedProperty.keySet()) {
                String queryParamValue = request.ExtendedProperty.get(queryParamName);
                navItem.CommunityItemURL += queryParamSeparator + queryParamName + '=' + EncodingUtil.urlEncode(queryParamValue , 'UTF-8');
                queryParamSeparator = '&';
            }
        }

        //System.Debug('\n\n$$$$$$\nlink: ' + navItem.CommunityItemURL + '\n\n$$$$$$');

        items.add(navItem);
        
        return items;
    }
    
    global static String GetCurrentCommunityUrl () {
        return Network.getLoginUrl(GetCurrentCommunityId()).replace('/login', '');
    }
    
    global static String getMergedString (String templateString, SObject currentsObject) {
        //Merge current user id
        if (!String.isEmpty(templateString)) {
            templateString = templateString.replace('{' + '!' + '$' + 'User.Id' + '}', UserInfo.getUserId());
        }
        return templateString;
    }
    
    global static String getSObjectTypeNameFromId (String sObjectIdString) {
        Id sObjectId;
        try {
            sObjectId = Id.valueOf(sObjectIdString);
        } 
        catch (Exception ex) {
            return '';
        }
        String sObjectType = String.valueOf(sObjectId.getSObjectType());
        return sObjectType;
    }
    
    global static ConnectAPI.ManagedTopicCollection getNavigationTopics(){
        Id communityId = ACN_NavigationLibrary.GetCurrentCommunityId() ;
        return ConnectAPI.ManagedTopics.getManagedTopics(communityId, ConnectApi.ManagedTopicType.Navigational);
    }

    global static ConnectAPI.ManagedTopicCollection getNavigationTopics(Integer level){
        Id communityId = ACN_NavigationLibrary.GetCurrentCommunityId() ;
        return ConnectAPI.ManagedTopics.getManagedTopics(communityId, ConnectApi.ManagedTopicType.Navigational, level);
    }

    global static ConnectAPI.ManagedTopicCollection getNavigationTopics(List<Id> topicIds, Integer level){
        Id communityId = ACN_NavigationLibrary.GetCurrentCommunityId() ;
        return ConnectAPI.ManagedTopics.getManagedTopics(communityId, ConnectApi.ManagedTopicType.Navigational, topicIds, level);
    }    */
}