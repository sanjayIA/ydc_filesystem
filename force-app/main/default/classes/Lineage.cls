public with sharing
class Lineage {
	public Lineage() {

	}

	@AuraEnabled(Cacheable = true)
	public static string getLineageData(Id recordId){
		String sObjectType=String.valueOf(recordId.getSobjectType());     
		String jsonData;
		Lineage lineage=new Lineage();
		switch on sObjectType{
		when 'BiField__c','ydc__BiField__c'{
			BiField__c fieldData = [SELECT Id, Name, (SELECT Id, Name,Column__r.Name,Column__r.Id FROM BI_Field_Column__r) FROM BiField__c WHERE Id =: recordId];
			//Create a fieldRecord
			ParentData fieldRecord = new ParentData(fieldData.Name,null,lineage.reportUrl(recordId,'BiField__c'),'BiField','Related to');
			//Loop on BiField_Column
			for(BiField_Column__c fieldColumnData: fieldData.BI_Field_Column__r) {

				fieldRecord.children.add(new ChildData(fieldColumnData.Column__r.Name,'Top Level',lineage.reportUrl(fieldColumnData.Column__r.Id,'Column__c'),'Column','Related to'));

			}

			//Get the Json data
			jsonData = JSON.serialize(fieldRecord);

		}

		}

		return jsonData;
	}

	public String reportUrl(Id id,String objName){
		String url=URL.getSalesforceBaseUrl().toExternalForm()+'/lightning/r/'+objName+'/'+id+'/view';

		return url;
	}

}