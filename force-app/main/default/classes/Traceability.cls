public with sharing
class Traceability {
	public Traceability() {

	}

	@AuraEnabled(Cacheable = true)
	public static string getTraceabilityData(Id recordId){
		String sObjectType=String.valueOf(recordId.getSobjectType());     
		String jsonData;
		Traceability traceability=new Traceability();
		switch on sObjectType{
		when 'BiProject__c', 'ydc__BiProject__c'{
			BiProject__c projectData = [SELECT Id, Name, (SELECT Id, Name FROM BiWorkbook__r) FROM BiProject__c WHERE Id =: recordId];
			//Create a project record
			ParentData projectRecord = new ParentData(projectdata.Name,null,traceability.reportUrl(recordId,'BiProject__c'),'BiProject','Contains');
			//Loop on workBook
			for(BiWorkbook__c workBook: projectdata.BiWorkbook__r) {
				projectRecord.children.add(new ChildData(workBook.Name,'Top Level',traceability.reportUrl(workBook.Id,'BiWorkbook__c'),'BiWorkbook','Conatins'));

			}

			//Get the Json data
			jsonData = JSON.serialize(projectRecord);

		}

		when 'BiWorkbook__c', 'ydc__BiWorkbook__c'{
			BiWorkbook__c workBookdata = [SELECT Id, Name, (SELECT Id, Name FROM BiView__r) FROM BiWorkbook__c WHERE Id =: recordId];
			//Create a workBook record
			ParentData workBookRecord = new ParentData(workBookdata.Name,null,traceability.reportUrl(recordId,'BiWorkbook__c'),'BiWorkbook','Contains');
			//Loop on BiView
			for(BiView__c viewData: workBookdata.BiView__r) {
				workBookRecord.children.add(new ChildData(viewData.Name,'Top Level',traceability.reportUrl(viewData.Id,'BiView__c'),'BiView','Contains'));
			}

			//Get the Json data
			jsonData = JSON.serialize(workBookRecord);

		}
		when 'BiView__c', 'ydc__BiView__c'{
			BiView__c viewData = [SELECT Id, Name, (SELECT Id, Name FROM Bi_Fields__r) FROM BiView__c WHERE Id =: recordId];
			//Create a BiView
			ParentData viewRecord = new ParentData(viewData.Name,null,traceability.reportUrl(recordId,'BiView__c'),'BiView','Contains');
			//Loop on View_Field
			for(BiField__c fieldData: viewData.Bi_Fields__r) {

				viewRecord.children.add(new ChildData(fieldData.Name,'Top Level',traceability.reportUrl(fieldData.Id,'BiField__c'),'BiField','Contains'));

			}
			//Get the Json data
			jsonData = JSON.serialize(viewRecord);

		}
		when 'BiField__c', 'ydc__BiField__c'{
			BiField__c fieldData = [SELECT Id, Name,Bi_View__r.Name,Bi_View__r.Id FROM BiField__c where id=:recordId];

			//Create a View record
			ParentData viewRecord = new ParentData(fieldData.Bi_View__r.Name,null,traceability.reportUrl(fieldData.Bi_View__r.Id,'BiView__c'),'BiView','Contains');
			viewRecord.children.add(new ChildData(fieldData.Name,'Top Level',traceability.reportUrl(fieldData.Id,'BiField__c'),'BiField','Contains'));

			//Get the Json data
			jsonData = JSON.serialize(viewRecord);


		}


		when 'Database__c', 'ydc__Database__c' {
			Database__c databaseData = [SELECT Id, Name, (SELECT Id, Name FROM Schema__r) FROM Database__c WHERE Id =: recordId];
			//Create a database record
			ParentData databaseRecord = new ParentData(databaseData.Name,null,traceability.reportUrl(recordId,'Database__c'),'Database','Contains');
			//Loop on Schemas
			for(Schema__c schemaData: databasedata.Schema__r) {
				databaseRecord.children.add(new ChildData(schemaData.Name,'Top Level',traceability.reportUrl(schemaData.Id,'Schema__c'),'Schema','Contains'));
			}

			//Get the Json data
			jsonData = JSON.serialize(databaseRecord);

		}
		when 'Schema__c', 'ydc__Schema__c'{
		Schema__c schemaData = [SELECT Id, Name, (SELECT Id, Name FROM Table__r) FROM Schema__c WHERE Id =: recordId];
            //Create a Schema record
            ParentData schemaRecord = new ParentData(schemaData.Name,null,traceability.reportUrl(recordId,'Schema__c'),'Schema','Contains');
            //Loop on tables
            for(Table__c tableData: schemaData.Table__r) {
                ChildData child=new ChildData(tableData.Name,'Top Level',traceability.reportUrl(tableData.Id,'Table__c'),'Table','Contains');
                Table__c subTabledata=[SELECT Id, Name, (SELECT Id, Name FROM Column__r) FROM Table__c WHERE Id =: tableData.Id];
                for(Column__c columndata: subTabledata.Column__r) {
                    child.children.add(new SubChildClass(columndata.Name,'Top Level',traceability.reportUrl(columndata.Id,'Column__c'),'Column'));
                
                }
                schemaRecord.children.add(child);
            }

            //Get the Json data
            jsonData = JSON.serialize(schemaRecord);
		}
		when 'Table__c', 'ydc__Table__c'{
			Table__c tableData = [SELECT Id, Name, (SELECT Id, Name FROM Column__r) FROM Table__c WHERE Id =: recordId];
			//Create a Table record
			ParentData tableRecord = new ParentData(tableData.Name,null,traceability.reportUrl(recordId,'Table__c'),'Table','Contains');
			//Loop on Columns
			for(Column__c columndata: tableData.Column__r) {
				ChildData child=new ChildData(columndata.Name,'Top Level',traceability.reportUrl(columndata.Id,'Column__c'),'Column','Contains');
				Column__c subColumnData = [SELECT Id, Name,Table__r.Name, (SELECT Id, Name,Term__r.Name,Term__r.Id FROM Term_Column__r) FROM Column__c WHERE Id =: columndata.Id];
				for(Term_Column__c columnFieldData: subColumnData.Term_Column__r) {

					child.children.add(new SubChildClass(columnFieldData.Term__r.Name,'Top Level',traceability.reportUrl(columnFieldData.Term__r.Id,'Term__c'),'Term'));

				}

				tableRecord.children.add(child);

			}

			//Get the Json data
			jsonData = JSON.serialize(tableRecord);

		}
		when 'Column__c', 'ydc__Column__c'{
			Column__c columnData = [SELECT Id, Name, (SELECT Id, Name,Term__r.Name,Term__r.Id FROM Term_Column__r) FROM Column__c WHERE Id =: recordId];
			//Create a columnRecord
			ParentData columnRecord = new ParentData(columnData.Name,null,traceability.reportUrl(recordId,'Column__c'),'Column','Contains');
			//Loop on Term_Column
			for(Term_Column__c termColumnData: columnData.Term_Column__r) {

				columnRecord.children.add(new ChildData(termColumnData.Term__r.Name,'Top Level',traceability.reportUrl(termColumnData.Term__r.Id,'Term__c'),'Term','Contains'));

			}

			//Get the Json data
			jsonData = JSON.serialize(columnRecord);

		}
		when 'Term__c', 'ydc__Term__c'{
			Term__c termData = [SELECT Id, Name, (SELECT Id, Name,Column__r.Name,Column__r.Id FROM Term_Column__r) FROM Term__c WHERE Id =: recordId];
			//Create a termRecord
			ParentData termRecord = new ParentData(termData.Name,null,traceability.reportUrl(recordId,'Term__c'),'Term','Contains');
			//Loop on Term_Column
			for(Term_Column__c termColumnData: termData.Term_Column__r) {

				termRecord.children.add(new ChildData(termColumnData.Column__r.Name,'Top Level',traceability.reportUrl(termColumnData.Column__r.Id,'Column__c'),'Column','Contains'));

			}

			//Get the Json data
			jsonData = JSON.serialize(termRecord);

		}
		when 'Data_Quality_Rules__c', 'ydc__Data_Quality_Rules__c'{
			Data_Quality_Rules__c dataQualityData = [SELECT Id, Name, (SELECT Id, Name,Data_Element__r.Name,Data_Element__r.Id FROM Data_Quality_Rules_Data_Elements__r) FROM Data_Quality_Rules__c WHERE Id =: recordId];
			//Create a dataQualityRecord
			ParentData dataQualityRecord = new ParentData(dataQualityData.Name,null,traceability.reportUrl(recordId,'Data_Quality_Rules__c'),'DataQualityRule','Contains');
			//Loop on DataQuality_DataElement
			for(Data_Quality_Rules_Data_Elements__c dataQualityElementData: dataQualityData.Data_Quality_Rules_Data_Elements__r) {
				dataQualityRecord.children.add(new ChildData(dataQualityElementData.Data_Element__r.Name+'(DataElement)','Top Level',traceability.reportUrl(dataQualityElementData.Data_Element__r.Id,'Data_Element__c'),'Data_Element','Contains'));

			}

			//Get the Json data
			jsonData = JSON.serialize(dataQualityRecord);

		}
		when 'Data_Element__c', 'ydc__Data_Element__c'{
			Data_Element__c dataQualityData = [SELECT Id, Name, (SELECT Id, Name,Data_Quality_Rule__r.Name,Data_Quality_Rule__r.Id FROM Data_Quality_Rules_Data_Elements__r) FROM Data_Element__c WHERE Id =: recordId];
			//Create a dataQualityRecord
			ParentData dataQualityRecord = new ParentData(dataQualityData.Name,null,traceability.reportUrl(recordId,'Data_Element__c'),'Data_Element','Contains');
			//Loop on DataQuality_DataElement
			for(Data_Quality_Rules_Data_Elements__c dataQualityElementData: dataQualityData.Data_Quality_Rules_Data_Elements__r) {
				dataQualityRecord.children.add(new ChildData(dataQualityElementData.Data_Quality_Rule__r.Name+'(DataQualityRule)','Top Level',traceability.reportUrl(dataQualityElementData.Data_Quality_Rule__r.Id,'Data_Quality_Rules__c'),'Data_Quality_Rule','Contains'));

			}

			//Get the Json data
			jsonData = JSON.serialize(dataQualityRecord);

		}
		when 'File_System__c', 'ydc__File_System__c'{
			File_System__c fileSystemData =[select id,name,(select id,name from Folders__r),(select id,name from Files__r) from File_System__c  WHERE Id =: recordId];
			//Create a fileSystemRecord
			ParentData fileSystemRecord = new ParentData(fileSystemData.Name,null,traceability.reportUrl(recordId,'File_System__c'),'File System','Contains');
			//Loop on folderData
			for(Folder__c folderData: fileSystemData.Folders__r) {
				fileSystemRecord.children.add(new ChildData(folderData.Name,'Top Level',traceability.reportUrl(folderData.Id,'Folder__c'),'Folder','Contains'));

			}
			for(File__c fileData: fileSystemData.Files__r) {
				fileSystemRecord.children.add(new ChildData(fileData.Name,'Top Level',traceability.reportUrl(fileData.Id,'File__c'),'File','Contains'));

			}

			//Get the Json data
			jsonData = JSON.serialize(fileSystemRecord);

		}
		when 'Folder__c', 'ydc__Folder__c'{
			Folder__c foldersData =[select id,name,(select id,name from Folders__r),(select id,name from Files__r) from Folder__c  WHERE Id =: recordId];
			//Create a folderRecord
			ParentData folderRecord = new ParentData(foldersData.Name,null,traceability.reportUrl(recordId,'Folder__c'),'Folder','Contains');
			//Loop on folderData
			for(Folder__c folderData: foldersData.Folders__r) {
				folderRecord.children.add(new ChildData(folderData.Name,'Top Level',traceability.reportUrl(folderData.Id,'Folder__c'),'Folder','Contains'));

			}
			for(File__c fileData: foldersData.Files__r) {
				folderRecord.children.add(new ChildData(fileData.Name,'Top Level',traceability.reportUrl(fileData.Id,'File__c'),'File','Contains'));

			}

			//Get the Json data
			jsonData = JSON.serialize(folderRecord);

		}
		when 'File__c', 'ydc__File__c'{
			File__c fileData =[select id,name,(select id,name from Fields__r) from File__c  WHERE Id =: recordId];
			//Create a fileRecord
			ParentData fileRecord = new ParentData(fileData.Name,null,traceability.reportUrl(recordId,'File__c'),'File','Contains');
			//Loop on fieldData
			for(Field__c fieldData: fileData.Fields__r) {
				fileRecord.children.add(new ChildData(fieldData.Name,'Top Level',traceability.reportUrl(fieldData.Id,'Fields__c'),'Field','Contains'));

			}
			//Get the Json data
			jsonData = JSON.serialize(fileRecord);

    } 
    when 'Field__c', 'ydc__Field__c'{
			Field__c fieldData =[select id,name from Field__c  WHERE Id =: recordId];
			//Create a fieldRecord
			ParentData fieldRecord = new ParentData(fieldData.Name,null,traceability.reportUrl(recordId,'Field__c'),'Field','Contains');
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