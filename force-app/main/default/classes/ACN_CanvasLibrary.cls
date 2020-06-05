global with sharing class ACN_CanvasLibrary {
    public class MethodNotImplementedException extends Exception {
    }
    public class ItemCommunityMissingException extends Exception {
    }

    global class CanvasRequest {
        public String Id {get; set;}
        public String ContainerId {get; set;}
        public String ReferenceId {get; set;}
        public String Name {get; set;}
        public String Title {get; set;}
        public String DeveloperName {get; set;}
        public String Border {get; set;}
        public String Width {get; set;}
        public String MaxWidth {get; set;}
        public String Height {get; set;}
        public String MaxHeight {get; set;}
        public String Scrolling {get; set;}
        public String DisplayLocation {get; set;}
        public String DisplaySubLocation {get; set;}
        public Boolean Watermark {get; set;}
        public String DataProviderName {get; set;}
        public String DataContextId {get; set;}
        public Boolean IsCacheEnabled {get; set;}
        public Boolean IsDataLoadAsynchronous {get; set;}
        
        public String SerializedParameters {get; set;} 
        public Map<String,String> Parameter {get; set;} 
        
        global CanvasRequest() {
            this.Parameter = new Map<String,String>();
        }
    }

    global class CanvasResponse {
        public String Id {get; set;}
        public String ContainerId {get; set;}
        public String ReferenceId {get; set;}
        public String Name {get; set;}
        public String Title {get; set;}
        public String DeveloperName {get; set;}
        public String Border {get; set;}
        public String Width {get; set;}
        public String MaxWidth {get; set;}
        public String Height {get; set;}
        public String MaxHeight {get; set;}
        public String Scrolling {get; set;}
        public String DisplayLocation {get; set;}
        public String DisplaySubLocation {get; set;}
        public Boolean Watermark {get; set;}
        public String DataProviderName {get; set;}
        public String DataContextId {get; set;}
        public Boolean IsCacheEnabled {get; set;}
        public Boolean IsDataLoadAsynchronous {get; set;}
        
        public String SerializedParameters {get; set;} 
        public Map<String,String> Parameter {get; set;} 
        
        global CanvasResponse() {
            this.Parameter = new Map<String,String>();
        }
    }
    
    global class KeyValuePair {
        public String key {get; set;}
        public String value {get; set;}
    }
}