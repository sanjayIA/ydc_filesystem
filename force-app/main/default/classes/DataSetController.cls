public with sharing class DataSetController {
    @AuraEnabled
    public static List<Data_Set__c> getDataSets() {
        return [SELECT Id, Name, Description__c, Frequency__c FROM Data_Set__c ORDER BY Name LIMIT 25];
    }
}