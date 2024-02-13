public class AzureUserRoleSync implements Queueable, Database.AllowsCallouts {     
    public Set<Id> userIds; 
    private List<User> users;
    private List<User> usersToUpdate;
    private List<API_Transaction__c> transactionHistory;
    private static final String API_NAME = 'Azure Role Sync';
    private static final String ENDPOINT_KEY = 'AzureRoleSync.EndPoint';
    private static final String URL_ENCODING = 'UTF-8';
    public AzureUserRoleSync(Set<Id> userIds)
    {
        this.userIds = userIds;
    }
    //called synchronously from Asynchronous Flow
    //The class is a queueable to support other asynchronous contexts
    public void execute(QueueableContext context) {  
        this.transactionHistory = new List<API_Transaction__c>();
        this.usersToUpdate = new List<User>();
        try {
            this.loadUsers();
            for(User us : this.users)
            {
                String userGroup = this.msAzureGrpCallout(us);
                if(String.isBlank(userGroup) || us.Azure_Role__c == userGroup) {
                    continue;
                }
                us.Azure_Role__c = userGroup; 
                this.usersToUpdate.add(us);  
            }
            update this.usersToUpdate;
        } catch(Exception ex) {
            this.transactionHistory.add(
                new API_Transaction__c(
                    API_Name__c = API_NAME,
                    API_Request_JSON__c = ex.getMessage()
                )
            );
        }
        //Can not perform DML Operation on Custom and Standard sObjects on single transaction
        //Can not log errors in this same transaction
        //insert this.transactionHistory;
        
        //Not Bulk Safe and expensive
        saveTransactionHistory(
            JSON.serialize(
                this.transactionHistory
            )
        );
    }
    
    @future
    private static void saveTransactionHistory(String transactionHistoryJson) {
        insert (List<API_Transaction__c>)JSON.deserialize(
            transactionHistoryJson,
            List<API_Transaction__c>.class
        );
    }

    public String msAzureGrpCallout(User us) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String encodedUriSuffix = String.format(
            ConfigKeyValuePairMetadata.metaData.get(ENDPOINT_KEY),
            new List<String>{  
                EncodingUtil.urlEncode(
                    String.format(
                        '\'{\'{0}\'}\'',
                        new List<String>{ us.Azure_ObjectID__c }
                    ),
                    URL_ENCODING
                )
            }
        );
        request.setHeader('ConsistencyLevel', 'Eventual'); 
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded;charset=UTF-8'); 
        request.setHeader('Accept', 'application/json'); 
        
        request.setEndpoint(String.format(
            'callout:Azure_Roles/{0}',
            new List<String>{ encodedUriSuffix }
        )); 
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        this.transactionHistory.add(
            new API_Transaction__c(
                API_Name__c = API_NAME,
                API_Request_JSON__c = request.getBody(),
                API_Response_JSON__c = response.getBody()
            )
        );
        if(response.getStatusCode() != 200) {
            return null;
        }
        Map<String, Object> jsonResponse = (Map<String, Object>)JSON.deserializeUntyped(
            response.getBody()
        );
        List<Object> values = (List<Object>)jsonResponse.get('value');
        if(values == null || values.isEmpty()) {
            return null;
        }
        Map<String, Object> value = (Map<String, Object>)values[0];
        if(value == null || value.keySet().isEmpty()) {
            return null;
        }
        return (String)value.get('displayName');
    }
    
    @InvocableMethod(label='Get Azure Role' description='Returns the list of filtered Group names corresponding to the specified User IDs.' category='User')
    public static void syncRoles(List<UserContextWrapper> userContexts) {
        Set<Id> asyncUserIds = new Set<Id>();
        Set<Id> syncUserIds = new Set<Id>();

        for(UserContextWrapper wrapper : userContexts) {
            if(wrapper.isAsync != null && wrapper.isAsync) {
                asyncUserIds.add(wrapper.userId);
                continue;
            }
            syncUserIds.add(wrapper.userId);
        }

        if(!asyncUserIds.isEmpty()) {
            System.enqueueJob(
                new AzureUserRoleSync(
                    new Set<Id>(asyncUserIds)
                )
            );
        }

        if(!syncUserIds.isEmpty()) {
            new AzureUserRoleSync(
                new Set<Id>(syncUserIds)
            ).execute(null);
        }
    }

    private void loadUsers() {
        this.users = [ 
            SELECT 
                Azure_ObjectID__c,
                Azure_Role__c
            FROM User 
            WHERE Id IN :this.userIds
        ];
    }  

    public class UserContextWrapper {
        @InvocableVariable(
            label = 'User ID' 
            description = 'User ID' 
            required = true
        )
        public Id userId;

        @InvocableVariable(
            label = 'Is Async' 
            description = 'Check this if you need to run this in an async context (queueable job)' 
        )
        public Boolean isAsync;
    }
}