/***************************************************************************************************************
* Apex Class : Level3Utils
*
* Description : Generic Utilities class for Level 3
*
* Where Used?
*
*
* Change History:
* Date          Person Responsible      Traceability        Details
* 06/08/2012    Brian Clift             US44037             Created
* 06/18/2012    Brian Clift             US38820             Added processBulkLoadHeaders
* 09/04/2012    Brian Clift                                 Added trigger custom setting methods
*
* 11/11/2012    Shah Kadirmohideen                          Added the following methods: formatDate(), formatDateTimeInGMT(),
                                                            concatenate(), prepareURL(). Also added QueryBuilder inner class.
* 01/07/2013    Shah Kadirmohideen                          Updated getSOQLWithCondition() method. Added new method: getWhereClause()
*
* 07/12/2013    Sanjay Sankar           US82437             Added business-hour date/time methods
* 03/26/2014    Jeyavel S               Updated             Refactored and Updated getRecordTypeId() to use RecordType developerName
* 06/10/2014    Jeyavel S               Updated             getLevel3RestAuthentication method
* 01/02/2015    Sorna                   US140704            When a GLM Validated Account has any address fields updated, Address Validation Status is set to Needed
* 01/21/2015    Srinkanth Chintapally   US146266            Added method getUserRoleName()
* 02/05/2015    Jeyavel S               US146205            Cleanup and Enhancements
* 03/20/2015    Feike Postma            US154077            Modified resetLocation
* 06/25/2015    Srikanth                US159387            Prevent Users from Entering Blacklist Email address on Contacts and Leads
* 07/01/2015    Feike Postma            US159390            Prevent Users from Entering Blacklist First & last Names on Contacts and Leads
* 10/19/2015    Feike Postma            US169335            Added method generateGuid -- copied code from SC Prod for Service Cloud
* 01/11/2016    Sreeram V               US181110            Added methods to get Account and Account Child Integration Fields from Custom Metadata
* 02/29/2016    Srikanth Reddy          US181514            Added methods to support Get Support Request Response
* 03/01/2016    Hema                    US146037            Field consolidation
* 03/02/2016    Sreeram V               DE34491             GLM doesn't store or validate PO Box addresses hence the address validation status
                                                            is set to 'Validated' for PO Box addresses on Account, Contact & Building object. 
                                                            Updated resetLocation method.
* 03/07/2016    Sreeram V               US188289            Added getScenarioStatusesBeyondSubmit method
* 04/06/2016    Sorna                   DE36099             To avoid null pointer exception so that null Mailing Street would be handled by validation rule
* 06/06/2016    Sreeram V               DE37981             Updated externalURL method
* 02/24/2017    Curtis                  US214903            Removed references to state_new__c, country_new__c, and postalcode_new__c fields
* 03/28/2017    Srikanth                US238784            Adding method getEmailVSCQueueMap
* 04/05/2017    Sorna                   US237228        	Updated code to use new country, state picklists fields
* 04/07/2017    Sreeram V               US232516            Bypass execution of few methods on Budget Impacting Approval Process
* 05/12/2017    Sorna                   DE47523             Added a check not to reset address validation status when it's from a Lead conversion and the Lead is already validated
* 06/27/2017    Steve G                 US163499, US162916  Migrating to CenturyLink Instance 
* 06/29/2017    Feike                   US163499            Modified Trigger_Settings__c to TriggerSettings__c
* 08/14/2017    Narasimha Rao           US181430            SFDC Contacts - Prevent Users from entering Blacklist First and Last Names
                Narasimha Rao           US181432            SFDC Contact - Prevent Users from entering Blacklist Email Addresses
                Narasimha Rao           US181433            SFDC Leads/Contact Prevent Users from entering Blacklist Phone Numbers
* 10//02/2017   Sorna                   US184613            Added TriggerStack.peek logic for Lead ResetLocation
* 10/13/2017	Sai Soma				US191197			Added htmlEncode to fix issue:ApexXSSFromURLParam  
* 11/09/2017	Feike					US169179			Adding code to keep track of converted Accounts
* 03/28/2018	Jeyavel S				US229814			Remove ref's to SSL Cert/password
* 04/10/2018    Sai Soma				US231324			Adding Global_Region__c to getuser SOQL
* 10/23/2018	Karun Kumar				US264241			added a method checkCurrentUserIsInGroup
* 09/10/2019	Sarthak Pani			US339582			Added getRecordTypeIdByDeveloperName()
* 02/28/2020	Sai Soma				LBOCM-5234			Added isLightningTheme()
* 07/22/2020	Surendra				LBOCM-13810			Update checkCurrentUserIsInGroup() to use group API name instead of label
* 09/04/2020    Nagarjuna               LBOCM-14735         Updated Profiles for Restrict Access to @AuraEnabled Apex Methods
* 02/09/2022    Kuehl                   ESCJ-390            Copied from SFDC Enterprise Prod
* 11/28/2022 	Kuehl										Added code to Remove CJ from Detected Env which is diven from SalesForce URL.
* 11/30/2022	Kuehl					Code Coverage 82% using Level3Utils_Test 
*****************************************************************************************************************/

global with sharing class Level3Utils 
{
    static String detectedEnv = getGlobalSetting('SFCJInstance');

    @AuraEnabled

    /*
    public static Id getRecordTypeIdByDeveloperName(String objApiName, String recTypDevName) 
    {
        return Schema.getGlobalDescribe().get(objApiName).getDescribe().getRecordTypeInfosByDeveloperName().get(recTypDevName).getRecordTypeId();
    }
    
    public static Set<Id> getRecordTypeIdsByDeveloperName(String objApiName, Set<String> recTypDevNames) 
    {
        Set<Id> recordTypeIds = new Set<Id>();
        Map<String, Schema.RecordTypeInfo> recordTypeMap = new Map<String, Schema.RecordTypeInfo>();
        for(String recTypeDevName : recTypDevNames){
            if(recordTypeMap.containsKey(recTypeDevName)){
                recordTypeIds.add(recordTypeMap.get(recTypeDevName).getRecordTypeId());
            }
        }
        return recordTypeIds;
    }
    */
    //public static boolean isLightningTheme() {
    //    return (System.Label.Lightning_Themes.split(',').contains(UserInfo.getUiThemeDisplayed()));        
    //}
    
    public static String htmlEncode(String input) {
		if (String.isBlank(input))
			return input;
        
		return input.replace('&', '&amp;').replace('<','&lt;').replace('>','&gt;').replace('"','&quot;').replace('\'','&#39;');        
	}

    public static string externalURL(String env){
        if(env == 'Prod'){
            if(Url.getSalesforceBaseUrl().toExternalForm().contains('visual'))
                return Url.getSalesforceBaseUrl().toExternalForm().replace(Url.getSalesforceBaseUrl().toExternalForm().substringBetween('level3', 'visual.'),'.my.sales').replace('visual.','').toLowerCase();
            else
                return Url.getSalesforceBaseUrl().toExternalForm();
        } else{
            return Url.getSalesforceBaseUrl().toExternalForm().replace('--c','').replace('visual.','my.sales').toLowerCase();
        }
       //comment out for api 42 -- return null;
    }
    
 //US169179 track the Accounts created by Lead conversion
 //this is called from 
 /* public static Set<Id> convertedAccountIds
 {
   get{
     if(convertedAccountIds == null)
       convertedAccountIds = new Set<Id>();     
     return convertedAccountIds;
   }set;
 }  
*/
    public static String getEnvFromUrl(String hostName, String userName) {
        Pattern
            p1 = Pattern.compile('([a-zA-Z0-9]+)--([a-zA-Z0-9]+)\\.([a-zA-Z0-9]+)\\.my\\.salesforce\\.com'),
            p2 = Pattern.compile('([a-zA-Z0-9]+)-([a-zA-Z0-9]+)\\.([a-zA-Z0-9]+)\\.force\\.com'),
            p3 = Pattern.compile('([a-zA-Z0-9]+)--([a-zA-Z0-9]+)--c\\.([a-zA-Z0-9]+)\\.visual\\.force\\.com'),
            p4 = Pattern.compile('(c\\.)?([a-zA-Z0-9]+)\\.(sales|visual\\.)?force\\.com'),
            p5 = Pattern.compile('([a-zA-Z0-9]+)--([a-zA-Z0-9]+)\\.my\\.salesforce\\.com'),
            p6 = Pattern.compile('([a-zA-Z0-9]+)-([a-zA-Z0-9]+)\\.force\\.com'),
            p7 = Pattern.compile('([a-zA-Z0-9]+)--([a-zA-Z0-9]+)--c\\.visual\\.force\\.com');
        Matcher
            m1 = p1.matcher(hostName),
            m2 = p2.matcher(hostName),
            m3 = p3.matcher(hostName),
            m4 = p4.matcher(hostName),
            m5 = p5.matcher(hostName),
            m6 = p6.matcher(hostName),
            m7 = p7.matcher(hostName);
        if(m1.matches()) {
            detectedEnv = m1.group(2).toLowerCase();
        } else if(m2.matches()) {
            detectedEnv = m2.group(1).toLowerCase();
        } else if(m3.matches()) {
            detectedEnv = m3.group(2).toLowerCase();
        } if(m5.matches()) {
            detectedEnv = m5.group(2).toLowerCase();
        } else if(m6.matches()) {
            detectedEnv = m6.group(1).toLowerCase();
        } else if(m7.matches()) {
            detectedEnv = m7.group(2).toLowerCase();
        }else if(m4.matches()) {
            String pod = m4.group(2);
            if(pod.startsWithIgnoreCase('cs') || pod.startsWithIgnoreCase('tapp')) {
                detectedEnv = userName.substringAfterLast('.').toLowerCase();
            }
        }
        if(detectedEnv == null) 
        {
            detectedEnv = 'prod';
        }
        
        return detectedEnv;
    }

    public static String detectEnv() {
        if(detectedEnv == null) 
        {
            system.debug ('Url.getSalesforceBaseUrl().getHost():  ' + Url.getSalesforceBaseUrl().getHost());
            system.debug ('UserInfo.getUserName():  ' + UserInfo.getUserName() );
            detectedEnv = getEnvFromUrl(Url.getSalesforceBaseUrl().getHost(), UserInfo.getUserName());
            
            string env = detectedEnv.toUpperCase();
        	detectedEnv = env.remove('CJ');  // Remove "CJ" from the beginning. spk 10-25-2022
            
            setGlobalSetting('SFCJInstance', detectedEnv.toUpperCase());            
        }
        
        return detectedEnv;
    }


    /***
     Method: getEndBusDateinGMT

     Traceability: US82437

     Description: adds business days to a datetime to return the end datetime

     @param - DateTime refDateTimeGMT = beginning DateTime in GMT to which duration is added to get ending datetime
     @param - Integer duration = business days to add to get ending datetime
     @param - Set<Date> holidays = set of holidays for a region that the calling method should pass. Use Level3Utils.getHolidayMap and pass the set of holidays for the region
     @param - Set<String> workingDays = set of working days for a region that the calling method should pass. Use Level3Utils.getWorkingDaysMap and pass the set of working days for the region
     @return - DateTime target date/time
    ***/
/*
    public static Date getEndBusDateinGMT(DateTime refDateTimeGMT, Integer duration, Set<Date> holidays, Set<String> workingDays) {

        Date dtTargetGMT;

        if (null != refDateTimeGMT && null != duration && 0 < duration) {
            Integer i = 1;

            DateTime dtTemp = refDateTimeGMT;
            while(i<=duration) {
                dtTemp = dtTemp.addDays(1);

                if (holidays == null || !holidays.contains(dtTemp.date()) //holiday check
                  && (workingDays == null || workingDays.contains(dtTemp.format('EEEE')))) //weekend check
                {
                    dtTargetGMT = dtTemp.date();
                    i++;
                }
            }
        }
        return dtTargetGMT;
    }
*/

    /***
     Method: getWorkingDaysMap

     Traceability: US82437

     Description: returns the a set of working days for a given region

     @return - Map<String region, set of String working days> example-{region=NA, working days={'Friday', 'Monday', 'Thursday', 'Tuesday', 'Wednesday'}}
    ***/
    private static Map<String, Set<String>> workingDaysMap;

    public static Map<String, Set<String>> getWorkingDaysMap() 
    {

        try {
            if(workingDaysMap == null) {
                workingDaysMap = new Map<String, Set<String>>();
                for (BusinessHours objBusHours : [select Id, Name, SundayStartTime, SundayEndTime,
                                                    MondayStartTime, MondayEndTime,
                                                    TuesdayStartTime, TuesdayEndTime,
                                                    WednesdayStartTime, WednesdayEndTime,
                                                    ThursdayStartTime, ThursdayEndTime,
                                                    FridayStartTime, FridayEndTime,
                                                    SaturdayStartTime, SaturdayEndTime
                                                    from BusinessHours])  {
                    Set<String> workingDays = new Set<String>();
                    for(String day : Level3Constants.startTimes.keySet()){
                        if(objBusHours.get(Level3Constants.startTimes.get(day))!= null && objBusHours.get(Level3Constants.endTimes.get(day)) != null)
                            workingDays.add(day);
                    }

                    if (workingDays.size() > 0 && !workingDaysMap.containsKey(objBusHours.Name)) {
                        workingDaysMap.put(objBusHours.Name, workingDays);
                    }
                }
            }
        }
        catch (Exception e){
            System.debug ('Error in getWorkingDays: ' + e.getMessage());
        }

        return workingDaysMap;
    }

    public static Map<String, Set<String>> getOnHoldWorkingDaysMap() {

        try {
            if(workingDaysMap == null) {
                workingDaysMap = new Map<String, Set<String>>();
                for (BusinessHours objBusHours : [select Id, Name, SundayStartTime, SundayEndTime,
                                                    MondayStartTime, MondayEndTime,
                                                    TuesdayStartTime, TuesdayEndTime,
                                                    WednesdayStartTime, WednesdayEndTime,
                                                    ThursdayStartTime, ThursdayEndTime,
                                                    FridayStartTime, FridayEndTime,
                                                    SaturdayStartTime, SaturdayEndTime
                                                    from BusinessHours])  {
                    Set<String> workingDays = new Set<String>();
                    for(String day : Level3Constants.startTimes.keySet()){
                        if(objBusHours.get(Level3Constants.onHoldstartTimes.get(day))!= null && objBusHours.get(Level3Constants.onHoldendTimes.get(day)) != null)
                            workingDays.add(day);
                    }

                    if (workingDays.size() > 0 && !workingDaysMap.containsKey(objBusHours.Name)) {
                        workingDaysMap.put(objBusHours.Name, workingDays);
                    }
                }
            }
        }
        catch (Exception e){
            System.debug ('Error in getWorkingDays: ' + e.getMessage());
        }

        return workingDaysMap;
    }


   static Map<string,Map<string, map<string,time>>> mapBusHoursByRegion;
/*
   public static Map<string, time> getBusinessHours(String strDay, String strRegion) {
        try {
            if(mapBusHoursByRegion == null) {
                mapBusHoursByRegion = new Map<string,Map<string,map<string,time>>>();
            }
            if(!mapBusHoursByRegion.containsKey(strRegion)){
                List<BusinessHours> objBusHours = [select Id,Name, SundayStartTime, SundayEndTime,
                                             MondayStartTime, MondayEndTime,
                                             TuesdayStartTime, TuesdayEndTime,
                                             WednesdayStartTime, WednesdayEndTime,
                                             ThursdayStartTime, ThursdayEndTime,
                                             FridayStartTime, FridayEndTime,
                                             SaturdayStartTime, SaturdayEndTime
                                             from BusinessHours];

                for(BusinessHours hrs : objBusHours){
                    if(!mapBusHoursByRegion.containsKey(hrs.Name)){
                        map<string,map<string,time>> mapWeekDays = new Map<string,map<string,time>>();
                        for(String day : Level3Constants.startTimes.keySet())
                        {
                            map<string,time> mapTimes = new map<string,time>();
                            mapTimes.put('Start',(time)hrs.get(Level3Constants.startTimes.get(day)));
                            mapTimes.put('End',(time)hrs.get(Level3Constants.endTimes.get(day)));
                            mapWeekDays.put(day,mapTimes);
                        }
                        mapBusHoursByRegion.put(hrs.Name,mapWeekDays);
                    }
                }
            }
        }catch (QueryException e){ system.debug('Exception in getBusinessHours->'+ e.getMessage());}

        return mapBusHoursByRegion.get(strRegion).get(strDay)!= null?mapBusHoursByRegion.get(strRegion).get(strDay):Level3Constants.defaultBusHours;
    }
*/
    
    public static String getDayOfTheWeek(Date dInput) {
        return DateTime.newInstance(dInput.year(), dInput.month(), dInput.day()).format('EEEE');
    }

    public static String getDayOfTheWeek(Datetime dtmInput) {
        return dtmInput.format('EEEE');
    }

    // returns name of the object for a given Id
    public static String getObjectName(Id strRecordId) {
        return strRecordId == null? null: String.valueOf(strRecordId.getSObjectType());
    }


    static map<id,SObject> mapOwnerNameById;

    public static map<id,SObject> getOwnerNameById(set<id> ids,string sobjectType){
        if(mapOwnerNameById == null) {
            mapOwnerNameById = new map<id,SObject>();
        }
        if(!mapOwnerNameById.keySet().containsAll(ids)){
            if('Group'.equalsIgnoreCase(sobjectType)){
                for(Group g : [Select Id, Name,DeveloperName From Group Where Id IN : ids])
                    mapOwnerNameById.put(g.id,g);
            }else if('User'.equalsIgnoreCase(sobjectType)) {
                for(User u : [Select Id, Name From User Where Id IN :ids])
                    mapOwnerNameById.put(u.id,u);
            }
        }

        return mapOwnerNameById;
    }

    //  Author:         ||c
    //  Date:           2012.06.05
    //  Description:    Returns a User object based on owner id
    //
    public static String getOwnerNameById(Id ownerId){
        if(ownerId != null) {
            string sobjectType = ownerId.getSobjectType() == Group.SObjectType?'Group':'User';
            return (String)getOwnerNameById(new set<Id>{ownerId},sobjectType).get(ownerId).get('Name');
        }
        return null;
    }

    //  Author:         ||c
    //  Date:           2012.02.10
    //  Description:    returns the id of a Queue based on the name
    //
   /*
    public static Map<String, String> getQueueId(List<String> strQueueNames){
        Map<String, String> queueIdMap = new Map<String, String>();
        for (Group theGroup:[Select Id,Name from Group where Name in :strQueueNames]) {
            queueIdMap.put(theGroup.Name, theGroup.Id);
        }
        return queueIdMap;
    }
*/
	
    /*
	*@param queueMembersList : list of Queue/Group names
	*@param groupType: Type of Group
	*@return true if the logged in user is part of group members of queue passed in parameter
	*/
    /*
    public static boolean checkCurrentUserIsInGroup(List<String> queueMembersList, String groupType) {
        boolean flag = false;
        for(GroupMember gm : [Select UserOrGroupId From GroupMember 
                              where Group.Type = :groupType
                              		AND Group.DeveloperName IN :queueMembersList 
                              		AND UserOrGroupId=:UserInfo.getUserId()]) {
            flag = true;
        }
        return flag;
    }
*/


    static Map<Id, User> userMap;

    public static User getuser(Id userId) {
        if(userMap == null) {
            userMap = new Map<Id, User>();
        }
        User theUser;

        if(userMap.containsKey(userId)) {
            theUser = userMap.get(userId);
        } else if(userId != null) {
            //userMap.put(userId, theUser = [select Name, Profile.Name, Email, Universal_Id__c, Global_Region__c from User where Id = :userId]);
            userMap.put(userId, theUser = [select Name, Profile.Name, Email from User where Id = :userId]);
        }
        return theUser;
    }

    static Map<String, Map<String,RecordType>> mapRecordTypeByName = new Map<String, Map<String,RecordType>>();
    static Map<string,Map<id,RecordType>> mapRecordTypeById = new Map<String, Map<Id,RecordType>>();

    //output Map<sObject.Name,set<RecordType.Id,RecordType>>
    /*
    public static map<string,Map<Id,RecordType>> getRecordTypeIds(map<string,set<Id>> sObjectRecordTypes){
        if(!mapRecordTypeById.keySet().containsAll(sObjectRecordTypes.keyset())){
            for(RecordType rc:[Select Id, SobjectType,Name,developerName,Description from RecordType where IsActive = True and sObjectType = :sObjectRecordTypes.keySet()]) {
                if(!mapRecordTypeByName.containsKey(rc.SobjectType)){
                    mapRecordTypeByName.put(rc.SobjectType, new Map<String, RecordType>{rc.DeveloperName=>rc});
                    mapRecordTypeById.put(rc.SobjectType, new Map<Id, RecordType>{rc.Id=>rc});
                }else{
                    mapRecordTypeByName.get(rc.SobjectType).put(rc.developerName,rc);
                    mapRecordTypeById.get(rc.SobjectType).put(rc.Id,rc);
                }
            }
        }
*/
    /*
        Map<String, Map<Id,RecordType>> mapRecordTypeByIdClone = new Map<string,map<id,RecordType>>();
        for(string sObjectName : sObjectRecordTypes.keySet()){
            mapRecordTypeByIdClone.put(sObjectName,mapRecordTypeById.get(sObjectName).deepClone());
            set<Id> setRecTypes = sObjectRecordTypes.get(sObjectName);
            if(null != setRecTypes &&!setRecTypes.isEmpty())
                mapRecordTypeByIdClone.get(sObjectName).keySet().retainAll(setRecTypes);

        }

        return  mapRecordTypeByIdClone;
    }
*/
    //input Map<sObject.Name,set<sObject.RecordType.DeveloperName>>
    //output Map<sObject.Name,set<RecordType.DeveloperName,RecordType>>
   /*
    public static map<string,Map<string,RecordType>> getRecordTypes(map<string,set<string>> sObjectRecordTypes)
    {
        if(!mapRecordTypeByName.keySet().containsAll(sObjectRecordTypes.keyset())){
            for(RecordType rc:[Select Id, SobjectType,Name,developerName,Description from RecordType where IsActive = True and sObjectType = :sObjectRecordTypes.keySet()]) {
                if(!mapRecordTypeByName.containsKey(rc.SobjectType)){
                    mapRecordTypeByName.put(rc.SobjectType, new Map<String, RecordType>{rc.DeveloperName=>rc});
                    mapRecordTypeById.put(rc.SobjectType, new Map<Id, RecordType>{rc.Id=>rc});
                }else{
                    mapRecordTypeByName.get(rc.SobjectType).put(rc.developerName,rc);
                    mapRecordTypeById.get(rc.SobjectType).put(rc.Id,rc);
                }
            }
        }
*/
    /*
        Map<String, Map<String,RecordType>> mapRecordTypeByNameClone = new Map<string,Map<string,RecordType>>();
        for(string sObjectName : sObjectRecordTypes.keySet()){
            mapRecordTypeByNameClone.put(sObjectName,mapRecordTypeByName.get(sObjectName).deepClone());
            set<string> setRecTypes = sObjectRecordTypes.get(sObjectName);
            if(null!=setRecTypes && !setRecTypes.isEmpty())
                mapRecordTypeByNameClone.get(sObjectName).keySet().retainAll(setRecTypes);
        }

        return  mapRecordTypeByNameClone;
    }
*/
    
    //input Map<sObject.Name,set<sObject.RecordType.DeveloperName>>
    //output Map<sObject.Name,set<RecordType.Id,RecordType>>
   /*
    public static map<string,Map<Id,RecordType>> getRecordTypeIdsByName(map<string,set<string>> sObjectRecordTypes)
    {
        Map<String, Map<Id,RecordType>> mapRecordTypeByIdClone = new Map<string,map<id,RecordType>>();
        Map<String, Map<String,RecordType>> mapRecordTypeByNameClone = getRecordTypes(sObjectRecordTypes);
        
        for(string sObjectName : mapRecordTypeByNameClone.keySet()){            
            Map<String,RecordType> mapRecTypes = mapRecordTypeByNameClone.get(sObjectName);
            if(null!=mapRecTypes && !mapRecTypes.isEmpty()){
                if(!mapRecordTypeByIdClone.containsKey(sObjectName))
                    mapRecordTypeByIdClone.put(sObjectName,new map<id,RecordType>());
                for(RecordType rt : mapRecTypes.values()){
                    mapRecordTypeByIdClone.get(sObjectName).put(rt.id,rt);
                }
            }
        }
        
        return  mapRecordTypeByIdClone;
    }
*/
    /*
    // returns a recordtype id for a given object and recordtype name
    public static Id getRecordTypeID(String sObjectName, String recTypeDevName)
    {
        if(!mapRecordTypeByName.containsKey(sObjectName)) {
            getRecordTypes(new map<string,set<string>>{sObjectName=>new set<string>()});
        }

        return mapRecordTypeByName.get(sObjectName).get(recTypeDevName).Id;
    }
    */
    
    static Map<Id, String> userRoleMap;

    public static String getUserRoleName(Id userId) 
    {
        String result;

        if (userID != null) {
            if(userRoleMap == null) {
                userRoleMap = new Map<Id, String>();
            }
            if (userRoleMap.containsKey(userId)) {
                result = userRoleMap.get(userId);
            } else {
                userRoleMap.put(userId, result = [SELECT UserRole.Name FROM User WHERE Id = :userId].UserRole.Name);
            }
        }

        return result;
    }

    static Map<Id, String> userProfileMap;

    public static map<id,string> getUserProfileNames(set<id> usrIds){
        if(userProfileMap == null) {
            userProfileMap = new Map<Id, String>();
        }
        if(!userProfileMap.keyset().containsAll(usrIds)){
            for(User u : [SELECT Profile.Name FROM User WHERE Id IN : usrIds]){
                userProfileMap.put(u.id,u.Profile.Name);
            }
        }
        return userProfileMap;
    }

    public static String getUserProfileName(Id userId) {
        String result;
        if (userID != null) {
            result = getUserProfileNames(new set<id>{userId}).get(userId);
        }
        return result;
    }
/*
    public static Boolean isGlobalTriggerActive() {
        return !TriggerSettings__c.getOrgDefaults().Disabled__c; 
    }

    public static Boolean isHoliday(Date dInput, String strRegion) {
        return [select count() from Holiday where ActivityDate = :dInput and Description = :strRegion] > 0;
    }
*/
    //US82437
    static Map<String, Set<Date>> holidayMap;

    public static Map<String, Set<Date>> getHolidayMap() {

        if(holidayMap == null){
            holidayMap = new Map<String, Set<Date>>();
            for (Holiday h: [select Id, ActivityDate, Description from Holiday]) {
                if (holidayMap.containsKey(h.Description)) {
                    holidayMap.get(h.Description).add(h.ActivityDate);
                }
                else {
                    holidayMap.put(h.Description, new Set<Date> {h.ActivityDate});
                }
            }
        }

        return holidayMap;
    }

    public static string getUrl(String pageName) 
    {    
        string EnvironmentURLsName = pageName + '_' + detectEnv().toUpperCase();
            
        system.debug('EnvironmentURLsName:  ' + EnvironmentURLsName);
        
        EnvironmentURLs__c envSetting = EnvironmentURLs__c.getValues(EnvironmentURLsName);
                
		String sandboxUrl = envSetting.SandboxUrl__c;
                
        system.debug('Env setting:  ' + sandboxUrl);
        
        // return sandboxUrl if setting is NOT null, otherwise null      
        return sandboxUrl!=null?sandboxUrl:null;
    }


    static Map<String, Set<Id>> permissionSetAssigneeMap;
/*
    public static Set<Id> getPermissionSetAssignees(String permissionSetName) {     
        if (permissionSetAssigneeMap == null) {
            permissionSetAssigneeMap = new Map<String, Set<Id>>();
        }
        
        Set<Id> userIds = new Set<Id>();
        
        if (permissionSetAssigneeMap.containsKey(permissionSetName)) {
            userIds = permissionSetAssigneeMap.get(permissionSetName);
        } else {        
            for (PermissionSetAssignment theAssignee:[select AssigneeId from PermissionSetAssignment where PermissionSet.Name = :permissionSetName AND AssigneeId != NULL]) {
                userIds.add(theAssignee.AssigneeId);
                system.debug('assignee id' + theAssignee.AssigneeId);
            }
            
            permissionSetAssigneeMap.put(permissionSetName, userIds);
        }        
        
        return userIds;
   }
*/
    /**
        Formats the input datetime in GMT format
    */
    public static String formatDateTimeInGMT(DateTime dt) {
        return dt == null? null: dt.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }

    public static String getGlobalSetting(String name) {
        return Global_Settings__c.getValues(name) != null? Global_Settings__c.getValues(name).Value__c: null;
    }

    /*
     * Below are a set of utility methods to get back specific data types from GlobalSettings since the custom setting only stores values as strings.
     */
    private enum VarType {INTE, DECI, BOOL, DAT, DT}
    
    public static Integer getGlobalSettingIntValue(String name) {
        return (Integer)castValue(getGlobalSetting(name), VarType.INTE);
    }
    
    //Returns false by default
    public static Boolean getGlobalSettingBoolValue(String name) {
        Boolean boolVal = (Boolean)castValue(getGlobalSetting(name), VarType.BOOL);
        return boolVal != null ? boolVal : false;
    }
    
    public static Decimal getGlobalSettingDecimalValue(String name) {
        return (Decimal)castValue(getGlobalSetting(name), VarType.DECI);
    }
    
    public static Date getGlobalSettingDateValue(String name) {
        return (Date)castValue(getGlobalSetting(name), VarType.DAT);
    }
    
    public static DateTime getGlobalSettingDateTimeValue(String name) {
        return (DateTime)castValue(getGlobalSetting(name), VarType.DT);
    }
    
    private static Object castValue(String value, VarType vt) {
        
        if(String.isBlank(value))
            return null;
        
        try {
            switch on vt {
                when INTE {
                    return Integer.valueOf(value);
                }
                when DECI {
    				return Decimal.valueOf(value);
                }
                when BOOL {
                    return Boolean.valueOf(value);
                }
                when DAT {
                    return Date.valueOf(value);
                }
                when DT {
                    return DateTime.valueOf(value);
                }
            }
        }catch(Exception e) {
			System.debug('#*#*# Exception casting value from global setting: ' + e);
        }
        	return null;   
    }

    public static void setGlobalSettings(Map<String, String> values) {
        Global_Settings__c[] records = new Global_Settings__c[0];
        for(String key: values.keySet()) {
            records.add(new Global_Settings__c(Name=key, Value__c=values.get(key)));
        }
        upsert records Global_Settings__c.Name;
    }

    public static void setGlobalSetting(String name, String value) {
        setGlobalSettings(new Map<String, String> { name => value });
    }

    public static String randomString(Integer len) {
        Integer[] bytes = new Integer[0];
        while(bytes.size() < len) {
            bytes.add((Math.random()<0.5?65+Math.random()*25:48+Math.random()*9).intValue());
        }
        return String.fromCharArray(bytes);
    }    

    /*
    public static String getErrorAsString(List<Database.Error> lstErrors){

        String[] errors = new String[0];

        for (Database.Error theError : lstErrors) {
            errors.add(theError.getMessage());
        }

        return String.join(errors,'\n');
    }

*/
    /* PRIVATE METHODS */

    /**
     * utility class to work with Pages
     */
    global class Pages {

        /**
         * debug the request params
         */
        public void requestParamsToString(Map<String, String> params) {
            system.debug('\t\t\t + URL:' + ApexPages.currentPage().getUrl());
            for( String key : params.keySet() ) {
                system.debug('\t\t\t key:' + key);
                system.debug('\t\t\t value:' + params.get(key));
            }
        }
    }

    /*
    // Method to get the user's current access on the record
    public static UserRecordAccess getUserRecordAccess(Id userId, Id recordId)
    {
        UserRecordAccess userAccess = [SELECT RecordId, HasReadAccess, HasEditAccess, MaxAccessLevel FROM UserRecordAccess 
                                                WHERE UserId = :userId AND RecordId = :recordId];
        return userAccess;
    }
*/

    //US169335 copied this method from ApexUtils class in SC Prod for Service Cloud
    public String generateGuid()
    {
        Blob b = Crypto.generateAesKey(128);
        String h = EncodingUtil.convertToHex(b);
        String guid = h.substring(0,8) + '-' + h.substring(8,12) + '-' + h.substring(12,16) + '-' + h.substring(16,20) + '-' + h.substring(20,32);
        System.debug('GUID: ' + guid);
        return guid;
        
    }

    
    public static string encodeXML(string data){
        map<string,string> charEncoding = new map<string,string>{'<'=>'&lt;','>'=>'&gt;','&'=>'&amp;','"'=>'&quot;','\''=>'&apos;'};
        if(string.isNotBlank(data)){
            for(string s : charEncoding.keySet()){
                data = data.replaceAll(s, charEncoding.get(s));
            }
        }
        return data;
    }    
    
    //Gets all the Case Queues for the given developername
    /*
    public static Map<String, Id> getEmailQueueMap(String developerName){
        Map<String, Id> emailQueueMap = new Map<String, Id>();
        for(QueueSObject queueObject : [select QueueId, Queue.DeveloperName from QueueSObject where SobjectType = :'Case' and Queue.DeveloperName like :developerName]){
                emailQueueMap.put(queueObject.Queue.DeveloperName, queueObject.QueueId);    
            }
        return emailQueueMap;        
    }
*/
    
    public static Set<String> quoteStatusesbeyondSubmit { get; set; }
    
    public static Set<String> getQuoteStatusesBeyondSubmit(){
  		// 2-11-2022 spk commented out.  Does not like: Quote_Status_Beyond_Submit
  		//  
        /* if(quoteStatusesbeyondSubmit == null){
            quoteStatusesbeyondSubmit = new Set<String>(Label.Quote_Status_Beyond_Submit.split(','));
        }
*/
        return quoteStatusesbeyondSubmit;
    }    
    
    //Sreeram V - Created static method to reduce number of SOQLs
    static map<id,User> bmgSalesChannelUserMap;

    /*
    public static map<id,User> bmgSalesChannelUserMap(set<id> ids){
        if(bmgSalesChannelUserMap == null) {
            bmgSalesChannelUserMap = new map<id,User>();
        }
        if(!bmgSalesChannelUserMap.keySet().containsAll(ids)){
            //bmgSalesChannelUserMap.putAll([Select Id, BMG_Sales_Channel__c From User Where Id IN :ids]);
            bmgSalesChannelUserMap.putAll([Select Id From User Where Id IN :ids]);
        }
        return bmgSalesChannelUserMap;
    } 
*/

    /*
     * Params : 
     * controllingFieldName : API Name of the controlling field
     * dependentFieldName : API Name of the dependent field
     * fieldValueMap : JSONDeserializeUntyped field value map
     * Returns : Returns the select options (pisklist values) based on the Controlling Fields. Below method has been driven based on the metadata when there
    			 are more than 1 controlling fields
	*/
    
    /* public static List<SelectOption> getSelectOptions(String controllingFieldName, String dependentFieldName, Map<String, Object> fieldValueMap){
        List<SelectOption> options = new List<SelectOption>(), finalOptions = new List<SelectOption>();
        Map<String, String> maps = new Map<String, String>();
        Set<String> primaryOptions = new Set<String>();
        
        for(Manage_Dependent_Picklist__mdt mdata : [select Label, Dependent_Field__c, Field_Dependency_Mapping__c,isPrimary__c from Manage_Dependent_Picklist__mdt where Dependent_Field__c =:dependentFieldName]){
            if(controllingFieldName.equalsIgnoreCase(mdata.Label)){
                maps = (Map<String,String>) JSON.deserialize(mdata.Field_Dependency_Mapping__c, Map<String,String>.class);    
            } else if(mdata.isPrimary__c){
                Map<String, String> primary = (Map<String,String>) JSON.deserialize(mdata.Field_Dependency_Mapping__c, Map<String,String>.class);
                if(primary.containsKey((String)fieldValueMap.get(mdata.Label))){
                	primaryOptions.addAll(primary.get((String)fieldValueMap.get(mdata.Label)).split(','));    
                }
            }
            
        }
        if(!maps.isEmpty()){
            String controllingValue = (String)fieldValueMap.get(controllingFieldName);
            if(String.isNotBlank(controllingValue) && maps.containsKey(controllingValue)){
                for(String value : maps.get(controllingValue).split(',')){
                    if(primaryOptions.isEmpty() || (!primaryOptions.isEmpty() && primaryOptions.contains(value)))
                        options.add(new SelectOption(value, value));
                }
            }
        }
        if(options.isEmpty()){
            options.add(new SelectOption('','--None--'));
        } else if(options.size() > 1){
            options.add(0, new SelectOption('','--None--'));
        }
        return options;
    }
*/
    
    /**********************************************************************************
    * Description       :   This method is implemented to get Host URL
   /**********************************************************************************/
   webservice static String getHostName(){
       return(Url.getSalesforceBaseUrl().getHost());
   }
   
   /**********************************************************************************
   * Description       :   This method is implemented to fetch Org specific Instance
   /**********************************************************************************/
   webservice static String getOrganizationInstance(){
       return [select Name, InstanceName from Organization limit 1].InstanceName;
   }
}