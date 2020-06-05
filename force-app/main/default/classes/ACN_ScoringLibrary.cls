global with sharing class ACN_ScoringLibrary {
    public class MethodNotImplementedException extends Exception {
    }

    global class ScoringRequest {
        public String Id {get; set;}
        public String UserId {get; set;}
        public String ScoringProviderName {get;set;}
        public Boolean IncludeFiveStarsRating {get;set;}
        public Boolean IncludeLikes {get;set;}
        public Boolean IncludeNotLikes {get;set;}
        public Boolean IncludeLoveIts {get;set;}
        public Boolean IncludeViews {get;set;}
        public Boolean IncludeTotalCount {get;set;}
        public Boolean IsLiked {get;set;}
        public Boolean IsNotLiked {get;set;}
        public Boolean IsLoved {get;set;}
        public Boolean IsViewed {get;set;}
        public Decimal FiveStarsRating {get;set;}

        global ScoringRequest () {
            this.IncludeFiveStarsRating = false;
            this.IncludeLikes = false;
            this.IncludeNotLikes = false;
            this.IncludeLoveIts = false;
            this.IncludeTotalCount = false;
            this.IsLiked = false;
            this.IsNotLiked = false;
            this.IsLoved = false;
            this.FiveStarsRating = -1;
        }
    }

    global class Scoring {
        public String UserId {get; set;}
        public Boolean IsLiked {get;set;}
        public Integer IsLikedCount {get;set;}
        public Boolean IsNotLiked {get;set;}
        public Integer IsNotLikedCount {get;set;}
        public Boolean IsLoved {get;set;}
        public Integer IsLovedCount {get;set;}
        public Boolean IsViewed {get;set;}
        public Integer IsViewedCount {get;set;}
        public Decimal FiveStarsRating {get;set;}
        public Decimal AverageFiveStarsRating {get;set;}
        public Integer FiveStarsRatingCount {get;set;}
        public Integer TotalViews {get;set;}
    }
    
    global class ScoringResponse {
        public String Id {get; set;}
        public String UserId {get; set;}
        public String ScoringProviderName {get;set;}
        public Boolean IncludeFiveStarsRating {get;set;}
        public Boolean IncludeLikes {get;set;}
        public Boolean IncludeNotLikes {get;set;}
        public Boolean IncludeLoveIts {get;set;}
        public Boolean IncludeViews {get;set;}
        public Boolean IncludeTotalCount {get;set;}
        public Boolean IsLiked {get;set;}
        public Boolean IsNotLiked {get;set;}
        public Boolean IsLoved {get;set;}
        public Boolean IsViewed {get;set;}
        public Decimal FiveStarsRating {get;set;}
        public Decimal AverageFiveStarsRating {get;set;}
        public Map<String, Scoring> ScoringSummary {get;set;}

        global ScoringResponse () {
            this.IncludeFiveStarsRating = false;
            this.IncludeLikes = false;
            this.IncludeNotLikes = false;
            this.IncludeLoveIts = false;
            this.IncludeTotalCount = false;
            this.IsLiked = false;
            this.IsNotLiked = false;
            this.IsLoved = false;
            this.IsViewed = false;
            this.FiveStarsRating = -1;
            
            this.ScoringSummary = new Map<String, Scoring>();
        }
    }
}