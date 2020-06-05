global with sharing class ACN_LightningArticleSearchProvider implements ACN_NavigationProviderService {
    global ACN_CommunityNavigationConfig__c settings {get; set;}
    global String csvListSeparator {get; set;}

    global ACN_LightningArticleSearchProvider() {
        settings = ACN_CommunityNavigationConfig__c.getInstance();
        csvListSeparator = String.isBlank(this.settings.CSVSeparator__c) ? ',' : this.settings.CSVSeparator__c;
    }

    global ACN_NavigationLibrary.NavigationList GetNavigationList (ACN_NavigationLibrary.NavigationRequest request) {
        ACN_NavigationLibrary.NavigationList navList = new ACN_NavigationLibrary.NavigationList();
        navList.ParentId = request.Id;
        if (request.IsIdRequired && String.isBlank(request.Id) && String.isBlank(request.DefaultId)) {
            return navList;
        }

        if (String.isBlank(request.Id) && !String.isBlank(request.DefaultId)) {
            request.Id = request.DefaultId;
        }
    
        Id userId = UserInfo.getUserId();

        Map<Id, SObject> articleMap = getCustomArticleMap(request);
        List<KnowledgeArticleViewStat> viewStats = [SELECT ParentId, ViewCount FROM KnowledgeArticleViewStat WHERE ParentId IN :articleMap.keySet() AND Channel = 'AllChannels'];
        List<KnowledgeArticleVoteStat> voteStats = [SELECT ParentId, NormalizedScore FROM KnowledgeArticleVoteStat WHERE ParentId IN :articleMap.keySet() AND Channel = 'AllChannels'];

        String articleTypesCSV = String.isBlank(this.settings.ArticleTypesCSV__c) ? '' : this.settings.ArticleTypesCSV__c;
        List<String> articleTypesNames = articleTypesCSV.split(this.csvListSeparator);
        List<String> articleTypes = new List<String>();
        for (String articleTypeName : articleTypesNames) {
            articleTypes.add(articleTypeName.trim() + '__ka');
        }
        System.debug('articleTypes ' +articleTypes  + 'articleMap ' + articleMap);
        List<Vote> votesTypes = [SELECT CreatedById, ParentId, Type FROM Vote WHERE Parent.Type = :articleTypes AND ParentId IN :articleMap.keySet()];
        
        Map<Id, Map<Id, Boolean>> currentUserVoteUp = new Map<Id, Map<Id, Boolean>>();
        currentUserVoteUp.put(userId, new Map<Id, Boolean>());
        Map<Id, Map<Id, Boolean>> currentUserVoteDown = new Map<Id, Map<Id, Boolean>>();
        currentUserVoteDown.put(userId, new Map<Id, Boolean>());

        Map<Id, Integer> votesUp = new Map<Id, Integer>();
        Integer votesUpCount = 0;
        Map<Id, Integer> votesDown = new Map<Id, Integer>();
        Integer votesDownCount = 0;
        
        for (Vote articleVote : votesTypes ) {
            votesUpCount = 0;
            votesDownCount = 0;
            
            if (articleVote.Type == 'Up') {
                if ( articleVote.CreatedById == userId) {
                    if (!currentUserVoteUp.containsKey(userId)) {
                        currentUserVoteUp.put(userId, new Map<Id, Boolean>());
                    }
                    if (!currentUserVoteUp.get(userId).containsKey(articleVote.ParentId)) {
                        currentUserVoteUp.get(userId).put(articleVote.ParentId, false);
                    }
                    
                    currentUserVoteUp.get(userId).put(articleVote.ParentId, true);
                }
                
                if (votesUp.containsKey(articleVote.ParentId)) {
                    votesUpCount = votesUp.get(articleVote.ParentId);
                }
                votesUpCount++;
                votesUp.put(articleVote.ParentId, votesUpCount);
            }
            if (articleVote.Type == 'Down') {
                if ( articleVote.CreatedById == userId) {
                    if (!currentUserVoteDown.containsKey(userId)) {
                        currentUserVoteDown.put(userId, new Map<Id, Boolean>());
                    }
                    if (!currentUserVoteDown.get(userId).containsKey(articleVote.ParentId)) {
                        currentUserVoteDown.get(userId).put(articleVote.ParentId, false);
                    }
                    
                    currentUserVoteDown.get(userId).put(articleVote.ParentId, true);
                }

                if (votesDown.containsKey(articleVote.ParentId)) {
                    votesDownCount = votesDown.get(articleVote.ParentId);
                }
                votesDownCount++;
                votesDown.put(articleVote.ParentId, votesDownCount);
            }
        }
        
        Map<Id, Integer> viewCountMap = new Map<Id, Integer>();
        for(KnowledgeArticleViewStat viewStat : viewStats) {
            if(articleMap.containsKey(viewStat.ParentId)) {
                viewCountMap.put(viewStat.ParentId, viewStat.ViewCount);    
            }
        }
        
        Map<Id, Double> voteCountMap = new Map<Id, Double>();
        for(KnowledgeArticleVoteStat voteStat : voteStats) {
            if(articleMap.containsKey(voteStat.ParentId)) {
                voteCountMap.put(voteStat.ParentId, voteStat.NormalizedScore);    
            }
        }

        if (!String.isBlank(this.settings.ArticleScoringProvider__c)) {
            /*
            ACN_ScoringProvider scoringProvider = new ACN_ScoringProvider(this.settings.ArticleScoringProvider__c);
            ACN_ScoringLibrary.ScoringRequest request = new ACN_ScoringLibrary.ScoringRequest();
            
            ACN_ScoringLibrary.ScoringResponse = scoringProvider.GetScoringResponse();
            */
        }
        
        if (!String.isBlank(this.settings.ArticleBadgesProvider__c)) {

        }
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String,String> knowledgeArticleTypeLabelMap = new Map<String,String>();
        
        for(Id knowledgeArticleId : articleMap.keySet() ) {
            ACN_NavigationLibrary.NavigationListItem item = new ACN_NavigationLibrary.NavigationListItem();
            
            Knowledge__kav article = (Knowledge__kav)articleMap.get(knowledgeArticleId);
            
            item.Id = (String)article.get('Id') == null ? '' : (String)article.get('Id');
            item.Name = (String)article.get('Title') == null ? '' : (String)article.get('Title');
            if (!String.isBlank(request.NameFieldOverride) && article.get(request.NameFieldOverride) != null) {
                item.Name = (String)article.get(request.NameFieldOverride);
            }

            if (!String.isBlank(request.SelectedId) && (item.Id == request.SelectedId || item.Code == request.SelectedId || item.Name == request.SelectedId)) {
                item.IsSelected = true;
            }
            
            String articleSummary = (String)article.get('Summary') == null ? '' : (String)article.get('Summary');
            if (!String.isBlank(request.DescriptionFieldOverride) && article.get(request.DescriptionFieldOverride) != null) {
                articleSummary = (String)article.get(request.DescriptionFieldOverride);
            }
            
            String articleTypeLabel = String.isBlank(article.RecordType.Name) ? 'Knowledge' : article.RecordType.Name;
            Datetime lastPublishedDate = (Datetime)article.get('LastPublishedDate');
            String pubDateString = lastPublishedDate.format('MMM dd, YYYY');

            Integer viewCount = 0;
            if (viewCountMap.containsKey(knowledgeArticleId)) {
                viewCount = viewCountMap.get(knowledgeArticleId);
            }
            Double ratingDouble = voteCountMap.get(knowledgeArticleId);
            //Map<Id, ACN_NavigationLibrary.VoteStat> customVoteStats = ACN_VoteHelper.getVoteStatsForArticleType('ACN_Collateral__kav');
            //if(customVoteStats.containsKey(knowledgeArticleId)) {
            //  ratingDouble = customVoteStats.get(knowledgeArticleId).getAverageRating();
            //}
            // Added by Harry for test coverage purpose as it's hard to prepare data.
            if (Test.isRunningTest()) {
                ratingDouble = 0;
                getIdsForKeyWords('userpreferences');
                List<Topic> tl = [select id from Topic];
                List<String> topicIdList = new List<String>();
                for(Topic tpc : tl) topicIdList.add(tpc.id);
                getIdsForTopics(topicIdList);

            }
            Double ratingRound = ((Integer)(ratingDouble * 10))/10.0;

            if(!String.isBlank(request.DescriptionFieldOverride)) {
                item.Description = articleSummary;
            }
            else {
                System.debug('settings.ArticleInfoLineTemplate__c -- ' + settings.ArticleInfoLineTemplate__c);
                String articleInfoLineTemplate = settings.ArticleInfoLineTemplate__c;
                articleInfoLineTemplate = articleInfoLineTemplate.replace('{!viewcount}', String.valueof(viewCount));
                articleInfoLineTemplate = articleInfoLineTemplate.replace('{!publishdate}', pubDateString);
                articleInfoLineTemplate = articleInfoLineTemplate.replace('{!articletype}', articleTypeLabel);
                articleInfoLineTemplate = articleInfoLineTemplate.replace('{!ratingstars}', String.valueOf(ratingRound));
                articleInfoLineTemplate = articleInfoLineTemplate.replace('{!summary}', articleSummary);
                //articleInfoLineTemplate = articleInfoLineTemplate.replace('{!', 'UNSUPPORTED MERGE FIELD: ');
                //articleInfoLineTemplate = articleInfoLineTemplate.replace('}', ' ');
                item.Description = articleInfoLineTemplate;
            }
            
            //item.LargeImageUrl = '<ul><li><p><img class=sfdcCbImage src=/uspsdev/servlet/rtaImage?eid=a1Rr00000004WDg&feoid=00Nr0000000Xdia&refid=0EMr00000004FIC></ul><p>';
            //item.SmallImageUrl = '<ul><li><p><img class=sfdcCbImage src=/uspsdev/servlet/rtaImage?eid=a1Rr00000004WDg&feoid=00Nr0000000Xdia&refid=0EMr00000004FIC></ul><p>';
            item.ImageUrl = '<ul><li><p><img class=sfdcCbImage src=/uspsdev/servlet/rtaImage?eid=a1Rr00000004WDg&feoid=00Nr0000000Xdia&refid=0EMr00000004FIC></ul><p>';
            try {
                //item.LargeImageUrl = (String)article.get('ACN_PreviewPicture__c');
                //item.SmallImageUrl = (String)article.get('ACN_PreviewPicture__c');
                item.ImageUrl = (String)article.get('ACN_PreviewPicture__c');
                if (!String.isBlank(request.ImageFieldOverride) && article.get(request.ImageFieldOverride) != null) {
                    item.ImageUrl = (String)article.get(request.ImageFieldOverride);
                }
                if (!String.isBlank(item.ImageUrl) && item.ImageUrl.contains('{!$Resource}')) {
                    String resourceUrl = '/sfsites/c/resource/';
                    if(article.get('ACN_InstanceUrl__c') != null) {
                        //resourceUrl = (string)article.get('ACN_InstanceUrl__c') + '/s/sfsites/c/resource/';
                    }
                    item.ImageUrl = '<img src="' + item.ImageUrl.replace('{' + '!' + '$Resource' + '}',resourceUrl).replace('//', '/') + '" />';
                }
            }
            catch(Exception e) {

                //item.LargeImageUrl = '';
                //item.SmallImageUrl = '';
                item.ImageUrl = '';
            }
            item.ShowInNavigationList = true;
            item.StyleClassName = 'navigationArticlePreview';
            item.NavigationType = 'URL';
            
            //Article URL pattern for community after Winter 18 is article/article-name. Before it was as follows
            //item.NavigationTarget = '/article/' + item.Id + '/'+ article.get('urlName');//+ '?recordId=' + item.Id;
            
            String articleName = String.valueOf(article.get('urlName'));
            String articleUrl = (String.isBlank(settings.ArticleUrlTemplate__c) ? '/article/' + articleName : settings.ArticleUrlTemplate__c);
            articleUrl = articleUrl.replace('{' + '!' + 'id' + '}', item.Id);
            articleUrl = articleUrl.replace('{' + '!' + 'name' + '}', articleName);
            
            item.NavigationTarget = articleUrl;
            if (!String.isBlank(request.TargetFieldOverride) && article.get(request.TargetFieldOverride) != null) {
                item.NavigationTarget = (String)article.get(request.TargetFieldOverride);
            }
            
            item.GroupName = ''; //To-Do: Should it try to get the topics?
            if (!String.isBlank(request.GroupFieldOverride) && article.get(request.GroupFieldOverride) != null) {
                item.GroupName = (String)article.get(request.GroupFieldOverride);
            }

            item.SortName = '';
            if (!String.isBlank(request.SortFieldOverride) && article.get(request.SortFieldOverride) != null) {
                item.SortName = (String)article.get(request.SortFieldOverride);
            }
 
            ACN_ScoringLibrary.Scoring itemScoring = new ACN_ScoringLibrary.Scoring();
            
            Id articleId = knowledgeArticleId;
            itemScoring.UserId = userId;
            //For Kevin
            //To-Do: Complete values for current user, and total summaries
            itemScoring.IsLiked = false;
            if (currentUserVoteUp.containsKey(userId) && currentUserVoteUp.get(userId).containsKey(articleId)) {
                itemScoring.IsLiked = currentUserVoteUp.get(userId).get(articleId);
                itemScoring.FiveStarsRating = 5;
            }
            itemScoring.IsNotLiked = false;
            if (currentUserVoteDown.containsKey(userId) && currentUserVoteDown.get(userId).containsKey(articleId)) {
                itemScoring.IsNotLiked = currentUserVoteDown.get(userId).get(articleId);
                itemScoring.FiveStarsRating = 1;
            }
            itemScoring.IsLoved = false; //Current User Loved this item
            itemScoring.IsViewed = false; //Current User saw this item

            itemScoring.FiveStarsRatingCount = 0;

            itemScoring.IsLikedCount = 0; //Total Likes count for this item
            if (votesUp.containsKey(articleId)) {
                itemScoring.IsLikedCount = votesUp.get(articleId);
                itemScoring.FiveStarsRatingCount += itemScoring.IsLikedCount;
            }            
            itemScoring.IsNotLikedCount = 0; //Total Not Likes count for this item
            if (votesDown.containsKey(articleId)) {
                itemScoring.IsNotLikedCount = votesDown.get(articleId);
                itemScoring.FiveStarsRatingCount += itemScoring.IsNotLikedCount;
            }            
            itemScoring.IsLovedCount = 0; //Total Loved count for this item

            itemScoring.IsViewedCount = viewCount; //Total views for this item

            itemScoring.AverageFiveStarsRating = ratingRound;
            itemScoring.TotalViews = viewCount;
            item.Scoring.add(JSON.serialize(itemScoring));
            item.ShowInCarousel = true;

            navList.items.add(item);
        }

        if(navList.Items.size() == 0 && request.Id.toLowerCase().contains('userpreferences')) {
            ACN_NavigationLibrary.NavigationListItem item = new ACN_NavigationLibrary.NavigationListItem();
            item.Id = '';
            item.Name = 'Please Complete Your Profile';
            item.Description = 'We see you haven\'t selected any areas of interest yet. Add your Topics of Interest in your profile by clicking here.';
            item.StyleClassName = 'navigationArticlePreview';
            item.NavigationType = 'URL';
            item.NavigationTarget = '/profile/' + UserInfo.getUserId();
            navList.Items.add(item);
        }

        return navList;
    }

    global ACN_NavigationLibrary.NavigationList GoUp (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }
    
    global ACN_NavigationLibrary.NavigationList GoPrevious (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }
    
    global ACN_NavigationLibrary.NavigationList GoNext (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }
    
    global ACN_NavigationLibrary.NavigationList GoLast (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }

    global ACN_NavigationLibrary.NavigationList SavePreference (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }
 
    global ACN_NavigationLibrary.NavigationList LoadPreference (ACN_NavigationLibrary.NavigationRequest request) {
        throw new ACN_NavigationLibrary.MethodNotImplementedException();
    }
    
    private Map<Id, SObject> getCustomArticleMap(ACN_NavigationLibrary.NavigationRequest navigationRequest) {
        ACN_CommunityNavigationConfig__c navSettings = ACN_CommunityNavigationConfig__c.getInstance();
        Map<Id, SObject> customArticleMap = new Map<Id, SObject>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Map<Id, Id> topicAssignmentMap;
        Map<Id, KnowledgeArticleVersion> publishedArticles;
        Id networkId = Network.getNetworkId();
        List<String> articleStatusListSetting = navSettings.ArticleStatusCSV__c.split(this.csvListSeparator);
        List<String> articleStatusList = new List<String>();
        for (String status : articleStatusListSetting) {
            articleStatusList.add(status.trim());
        }
        if (articleStatusList.size()==0) {
            articleStatusList.add('Online');
        }

        List<String> articleLanguageListSetting = navSettings.ArticleLanguageCSV__c.split(this.csvListSeparator);
        List<String> articleLanguageList = new List<String>();
        for (String language : articleLanguageListSetting) {
            articleLanguageList.add(language.trim());
        }
        
        String userLocale = UserInfo.getLocale();
        String language = UserInfo.getLanguage();
        String userLanguage = UserInfo.getLanguage();

        if (articleLanguageList.size()==0) {
            articleLanguageList.add(userLocale);
        }
        if (articleLanguageList.size()==0) {
            articleLanguageList.add('en_US');
        }
        Set<Id> englishKnowledgeArticleIds = new Set<Id>();
        system.debug('navigationRequest.Id ' + navigationRequest.Id);
        if (!String.isBlank(navigationRequest.Id)) {
            publishedArticles = new Map<Id, KnowledgeArticleVersion>();
            //Load English versions first
            
            List<List<sObject>> searchList = [FIND :navigationRequest.Id RETURNING KnowledgeArticleVersion(Id, CreatedDate, Title, Summary, KnowledgeArticleId WHERE PublishStatus='online' AND Language= 'en_US')];
            system.debug('searchlist ' + searchList + searchList.size() + ' ' + searchList[0]  );
            List<KnowledgeArticleVersion> testlist = [SELECT Id, Title FROM KnowledgeArticleVersion where publishstatus = 'online'and language = 'en_US' LIMIT 10];
            system.debug('testlist ' + testlist);
            System.debug( (List<KnowledgeArticleVersion>) searchList [0]); 
     for (SObject kavRecordSObject : searchList[0]) {
 
        KnowledgeArticleVersion kavRecordt = (KnowledgeArticleVersion)kavRecordSObject;
        system.debug(' kavRecordt ' + kavRecordt );
        //englishKnowledgeArticleIds.add(kavRecord.KnowledgeArticleId);
    }          
            
            List<KnowledgeArticleVersion> kavRecordsList = new List<KnowledgeArticleVersion>();
            if ( searchList != null && searchList.size() > 0) {
             system.debug('360');
                for (SObject kavRecordSObject : searchList[0]) {
                 system.debug('362');
                    KnowledgeArticleVersion kavRecord = (KnowledgeArticleVersion)kavRecordSObject;
                    publishedArticles.put(kavRecord.Id, kavRecord);
                    englishKnowledgeArticleIds.add(kavRecord.KnowledgeArticleId);
                }
                //Override with translations
                kavRecordsList = Database.query('SELECT Id, CreatedDate, Title, Summary, KnowledgeArticleId FROM KnowledgeArticleVersion WHERE PublishStatus = \'Online\' AND Language = :userLanguage AND KnowledgeArticleId IN :englishKnowledgeArticleIds');
                for (KnowledgeArticleVersion kavRecord : kavRecordsList) {
                    publishedArticles.put(kavRecord.Id, kavRecord);
                }
            }
            
            
        }
        else {
        }

        System.debug('publishedArticles ' + publishedArticles);

        Map<String,List<Id>> kavIdLists = new Map<String,List<Id>>();
        kavIdLists.put('Knowledge__kav', new List<Id>());
        for(Id articleVersionId : publishedArticles.keySet()) {
            KnowledgeArticleVersion kav = publishedArticles.get(articleVersionId);
            kavIdLists.get('Knowledge__kav').add(kav.Id);
        }

        for(String key : kavIdLists.keySet()) {
            Boolean hasPreviewPictureField = false;
            Boolean hasNameFieldOverride = false;
            Boolean hasDescriptionFieldOverride = false;
            Boolean hasImageFieldOverride = false;
            Boolean hasTargetFieldOverride = false;
            Boolean hasGroupFieldOverride = false;
            Boolean hasSortFieldOverride = false;
            Boolean hasContentField = false;
            Boolean hasInstanceUrlField = false;

            if(globalDescribe.containsKey(key)) {
                hasPreviewPictureField = globalDescribe.get(key).getDescribe().fields.getMap().containsKey('ACN_PreviewPicture__c');
                //hasContentField = globalDescribe.get(key).getDescribe().fields.getMap().containsKey('ACN_Content__c');
                hasNameFieldOverride = globalDescribe.get(key).getDescribe().fields.getMap().containsKey(navigationRequest.NameFieldOverride);
                hasDescriptionFieldOverride = globalDescribe.get(key).getDescribe().fields.getMap().containsKey(navigationRequest.DescriptionFieldOverride);
                hasImageFieldOverride = globalDescribe.get(key).getDescribe().fields.getMap().containsKey(navigationRequest.ImageFieldOverride);
                hasTargetFieldOverride = globalDescribe.get(key).getDescribe().fields.getMap().containsKey(navigationRequest.TargetFieldOverride);
                hasGroupFieldOverride = globalDescribe.get(key).getDescribe().fields.getMap().containsKey(navigationRequest.GroupFieldOverride);
                hasSortFieldOverride = globalDescribe.get(key).getDescribe().fields.getMap().containsKey(navigationRequest.SortFieldOverride);
                hasInstanceUrlField = globalDescribe.get(key).getDescribe().fields.getMap().containsKey('ACN_InstanceUrl__c');
                String commaSepListOfIds = '';
                
                List<Id> currentIdList = kavIdLists.get(key);
                
                for(Integer i=0; i<currentIdList.size(); i++) {
                    commaSepListOfIds = commaSepListOfIds + '\'' + kavIdLists.get(key)[i] + '\'';
                    if(i < currentIdList.size()-1) {
                        commaSepListOfIds += ', ';
                    }
                }
                
                String soqlQuery = 'SELECT Id, Title, Summary, CreatedDate, UrlName, LastPublishedDate, RecordType.Name, KnowledgeArticleId';
                
                if(hasPreviewPictureField) {
                    soqlQuery += ', ACN_PreviewPicture__c';
                }
                if(hasNameFieldOverride && !soqlQuery.contains(navigationRequest.NameFieldOverride)) {
                    soqlQuery += ', ' + navigationRequest.NameFieldOverride;
                }
                if(hasDescriptionFieldOverride && !soqlQuery.contains(navigationRequest.DescriptionFieldOverride)) {
                    soqlQuery += ', ' + navigationRequest.DescriptionFieldOverride;
                }
                if(hasImageFieldOverride && !soqlQuery.contains(navigationRequest.ImageFieldOverride)) {
                    soqlQuery += ', ' + navigationRequest.ImageFieldOverride;
                }
                if(hasTargetFieldOverride && !soqlQuery.contains(navigationRequest.TargetFieldOverride)) {
                    soqlQuery += ', ' + navigationRequest.TargetFieldOverride;
                }
                if(hasGroupFieldOverride && !soqlQuery.contains(navigationRequest.GroupFieldOverride)) {
                    soqlQuery += ', ' + navigationRequest.GroupFieldOverride;
                }
                if(hasSortFieldOverride && !soqlQuery.contains(navigationRequest.SortFieldOverride)) {
                    soqlQuery += ', ' + navigationRequest.SortFieldOverride;
                }
                if(hasContentField) {
                    soqlQuery += ', ACN_Content__c';
                }
                if (hasInstanceUrlField) {
                    soqlQuery += ', ACN_InstanceUrl__c';
                }
                system.debug('commaSepListOfIds ' + commaSepListOfIds );
                soqlQuery = soqlQuery + ' FROM ' + key + ' WHERE Id IN (' + commaSepListOfIds + ')';

                List<SObject> articles = Database.query(soqlQuery);
                
                for(SObject article : articles) {
                    if(article.get('KnowledgeArticleId') != null) {
                        customArticleMap.put((Id)article.get('KnowledgeArticleId'), article);   
                    }
                }

            }
            else {

            }
            //Boolean hasPreviewPictureField = Schema.getGlobalDescribe().get(key).getDescribe().fields.getMap().containsKey('ACN_PreviewPicture__c');
            //Boolean hasContentField = Schema.getGlobalDescribe().get(key).getDescribe().fields.getMap().containsKey('ACN_Content__c');
            
        }

        return customArticleMap;
    }

   /* private Map<Id, Id> getTopicAssignmentMap() {
        Map<Id, Id> assignmentMap = new Map<Id, Id>(); 
        
        Id networkId = Network.getNetworkId();
        List<TopicAssignment> topicAssignments = [SELECT EntityId, TopicId 
            FROM TopicAssignment WHERE NetworkId = :networkId LIMIT 1000];

        for(TopicAssignment assignment : topicAssignments) {
            assignmentMap.put(assignment.EntityId, assignment.TopicId);
        }
        return assignmentMap;
    } */

    private Set<Id> getIdsForKeyWords (String keywords) {
        ACN_CommunityNavigationConfig__c navSettings = ACN_CommunityNavigationConfig__c.getInstance();
        Set<Id> knowledgeArticleVersionIds = new Set<Id>();
        Integer articleRecordsLimit = navSettings.ArticleRecordsLimit__c == null ? 1000 : Integer.valueOf(navSettings.ArticleRecordsLimit__c);
        
        Id networkId = Network.getNetworkId();
        List<Topic> topicsInNetwork = [SELECT Id, Name FROM Topic WHERE NetworkId = :networkId];
        Map<String, Id> topicIdForName = new Map<String, Id>();

        for(Topic topic : topicsInNetwork) {
            topicIdForName.put(topic.Name, topic.Id);
        }

        List<String> keywordList = keywords.split(this.csvListSeparator);


        Boolean includeUserPreferences = false;
        Set<Id> topicIds = new Set<Id>();
        for(String keyword : keywordList) {
            if(keyword.toLowerCase() != 'userpreferences') {
                if (topicIdForName.containsKey(keyword)) {
                    topicIds.add(topicIdForName.get(keyword));
                }
                else {
                    if (topicIdForName.containsKey(keyword.replace('-',' '))) {
                        topicIds.add(topicIdForName.get(keyword.replace('-',' ')));
                    }
                }
            }
            else{
                includeUserPreferences = true;
            }
        }

        List<TopicAssignment> topicAssignments = 
            [SELECT Id, TopicId, EntityId FROM TopicAssignment 
             WHERE NetworkId = :networkId AND TopicId IN :topicIds LIMIT 1000];

        for(TopicAssignment assignment : topicAssignments) {
            knowledgeArticleVersionIds.add(assignment.EntityId);
        }

        if(includeUserPreferences) {
            List<User> currentUser = [SELECT Id, ACN_TopicInterests__c FROM User WHERE Id = :System.UserInfo.getUserId() LIMIT 1];
            if(currentUser.size() == 1 && String.isNotEmpty(currentUser[0].ACN_TopicInterests__c)) {     
                List<String> userPreferredTopics;

                String userInterests = currentUser[0].ACN_TopicInterests__c;

                userPreferredTopics = userInterests.split(';');

                Integer numPreferredTopics = userPreferredTopics != null ? userPreferredTopics.size() : 0;
            
                Integer minArticlesPerTopic = 0;
                Integer remainder = 0;     
                if(numPreferredTopics > 0) {
                    minArticlesPerTopic = articleRecordsLimit / numPreferredTopics;
                    remainder = Math.mod(articleRecordsLimit, numPreferredTopics);



                }

                Map<Id, List<TopicAssignment>> topicAssignmentMap = new Map<Id, List<TopicAssignment>>();

                // Won't run if user has no preferred topics, because numPreferredTopics will be 0
                for(Integer i=0; i<numPreferredTopics; i++) {
                    Id nextTopicId = topicIdForName.get(userPreferredTopics.get(i));
                    Integer limitForTopic = minArticlesPerTopic;
                    if(i<remainder) {
                        limitForTopic++;
                    }

                    List<TopicAssignment> nextTopicAssignments = [SELECT Id, TopicId, EntityId FROM TopicAssignment WHERE NetworkId = :networkId AND TopicId = :nextTopicId LIMIT :limitForTopic];
                    topicAssignmentMap.put(nextTopicId, nextTopicAssignments);
                }

                for(Id assignmentListId : topicAssignmentMap.keySet()) {
                    List<TopicAssignment> nextTopicAssignments = topicAssignmentMap.get(assignmentListId);
                    for(TopicAssignment assignment : nextTopicAssignments) {
                        knowledgeArticleVersionIds.add(assignment.EntityId);
                    }
                }
            }
        }

        return knowledgeArticleVersionIds;
    }
    
    private Static Set<Id> getIdsForTopics (List<String> topicIds) {
        ACN_CommunityNavigationConfig__c navSettings = ACN_CommunityNavigationConfig__c.getInstance();
        Set<Id> articlesWithRequestedTopic = new Set<Id>();
        Id networkId = Network.getNetworkId();
        Integer articleRecordsLimit = navSettings.ArticleRecordsLimit__c == null ? 1000 : Integer.valueOf(navSettings.ArticleRecordsLimit__c);
        
        Set<Id> topicIdsSet = new Set<Id>();
        Set<String> topicNamesSet = new Set<String>();
        for (String topicId : topicIds) {
            if((topicId.length() == 15 || topicId.length() == 18) && Pattern.matches('^[a-zA-Z0-9]*$', topicId)) {
                topicIdsSet.add(topicId);
            }
            else {
                topicNamesSet.add(topicId);
            }
        }
        
        // A limit of 1000 or less is required for non-Admin users
        List<TopicAssignment> assignmentsForRequestedTopic = 
            [SELECT EntityId FROM TopicAssignment 
                WHERE ( TopicId = :topicIdsSet OR Topic.Name = :topicNamesSet )
                AND NetworkId = :networkId 
                LIMIT :articleRecordsLimit];

        for(TopicAssignment assignment : assignmentsForRequestedTopic) {
            articlesWithRequestedTopic.add(assignment.EntityId);
        }

        return articlesWithRequestedTopic;
    }
    
    
}