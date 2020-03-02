public without sharing class DataQualityRuleController {
    
    @AuraEnabled
    public static void addColumnsToDataQualityRule(List<String> columnIds, String dataQualityRuleId) {
        System.debug('Data quality rule id is ' + dataQualityRuleId);
        System.debug('Column ids are' + columnIds);
        if (columnIds != null && columnIds.size() > 0) {
	        saveDataQualityRuleColumns(columnIds, dataQualityRuleId);            
        }
    }
        
    private static void saveDataQualityRuleColumns(List<Id> ids, String dataRequestId) {                        
        List<Data_Quality_Rule_Column__c> drqcs = new List<Data_Quality_Rule_Column__c>();
        
        for (Id id : ids) {
            String sObjectType = String.valueOf(id.getSobjectType());
            switch on sObjectType {
                when 'Column__c', 'ydc__Column__c' {
                    addColumn(drqcs, id, dataRequestId);
                }
            }
        }

        if (
            !Schema.sObjectType.Data_Quality_Rule_Column__c.isCreateable()
        ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: Insufficient Write Access'));
        }
        
        insert drqcs;
    }
    
    private static void addColumn(List<Data_Quality_Rule_Column__c> drqcs, Id column, String dataQualityRuleId) {
        Data_Quality_Rule_Column__c drqc = new Data_Quality_Rule_Column__c();
        drqc.Data_Quality_Rule__c = dataQualityRuleId;
        drqc.Column__c = column;
        drqcs.add(drqc);
    }
    
    private static void addColumns(List<Data_Quality_Rule_Column__c> drqcs, List<Column__c> columns, String dataQualityRuleId) {
        if (columns != null) {
            for (Column__c column : columns) {
                addColumn(drqcs, column.Id, dataQualityRuleId);
            }
        }
    }
    
}