/**
 * 
 * HANK		10/17/2023		QFCJ-4013 -  this is used to format and serialize data to be sent to SFCJ
 * 
 * 
 */

 public class lmn_AttachmentWrapper {
    
    public string title {get; set;}
     public string pathOnClient {get; set;}
    public string contentLocation {get; set;}
    public Id firstPublishLocationId {get; set;}
    public string versionData {get; set;}

public lmn_AttachmentWrapper(string title, string pathOnClient, string contentLocation, Id firstPublishLocationId, string versionData) {
    this.title = title;
    this.pathOnClient = pathOnClient;
    this.contentLocation = contentLocation;  
    this.firstPublishLocationId = firstPublishLocationId;
    this.versionData = versionData;
 
}

}