public class ProspectorListJobsWrap {
    public String status;
    public String message;
    public list<Payload> payload;
    
    public class Payload {
        public String userName;
        public String projectName;
        public String projectId;
        public String guid;
        public String status;
        public String machineName;
        public String processId;
        public String cancelRequested;
        public String created;
        public String lastUpdated;
    }//end class Payload
}//end class ProspectorListJobs