public without sharing class ConfigKeyValuePairMetadata {
    public static Map<String, String> metaData {
        get {
            if(metaData == null) {
                metaData = new Map<String, String>();
                for(ConfigKeyValuePair__mdt pair : configKeyValuePairs) {
                    metaData.put(pair.Key__c, pair.Value__c);
                }
            }
            return metaData;
        }
        set;
    }
    public static List<ConfigKeyValuePair__mdt> configKeyValuePairs {
        get {
            if(configKeyValuePairs == null) {
                configKeyValuePairs = [
                    SELECT 
                        Key__c,
                        Value__c
                    FROM ConfigKeyValuePair__mdt
                ];
            }
            return configKeyValuePairs;
        }
        set;
    }
    public static String getMetadata(String key, Object def) {
        String returnValue = null;
        returnValue = metaData.get(key);
        if(returnValue == null) {
            returnValue = String.valueOf(def);
        }
        return returnValue;
    }
}