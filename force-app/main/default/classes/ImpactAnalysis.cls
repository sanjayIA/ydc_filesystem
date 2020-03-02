public with sharing
class ImpactAnalysis {
	public ImpactAnalysis() {

	}

	@AuraEnabled(Cacheable = true)
	public static string getImpactData(Id recordId){
		String sObjectType=String.valueOf(recordId.getSobjectType());     
		String jsonData;
		ImpactAnalysis impact=new ImpactAnalysis();
		switch on sObjectType{
		when 'Column__c','ydc__Column__c'{

			Column__c columnData = [SELECT Id, Name,Table__r.Name, (SELECT Id, Name,Bi_Field__r.Name,Bi_Field__r.Id FROM BI_Field_Column__r) FROM Column__c WHERE Id =: recordId];
			//Create a columnrecord
			ParentData columnRecord = new ParentData(columnData.Name,null,impact.reportUrl(recordId,'Column__c'),'Column','Related to');
			//Loop on BiField_Column
			for(BIField_Column__c columnFieldData: columnData.BI_Field_Column__r) {

				columnRecord.children.add(new ChildData(columnFieldData.BI_Field__r.Name,'Top Level',impact.reportUrl(columnFieldData.BI_Field__r.Id,'BIField__c'),'BIField','Related to'));

			}

			//Get the Json data
			jsonData = JSON.serialize(columnRecord);

		}

		}

		return jsonData;
	}

	public String reportUrl(Id id,String objName){
		String url=URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/'+objName+'/'+id+'/view';

		return url;
	}
}