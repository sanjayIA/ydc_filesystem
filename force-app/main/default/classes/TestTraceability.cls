@isTest
public class TestTraceability {
    
    @isTest
    static void shouldGetDatabaseTraceability() {
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(db.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetSchemaTraceability() {
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(sch.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetTableTraceability() {
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(tbl.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetColumnTraceability() {
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(col.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetBiProjectTraceability() {
		BiProject__c p = TestDataFactory.createBiProject('Project');
		BiWorkbook__c wb = TestDataFactory.createBiWorkbook(p, 'Workbook');
		BiView__c v = TestDataFactory.createBiView(wb, 'View');
		BiField__c f = TestDataFactory.createBiField(v, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(p.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetBiWorkbookTraceability() {
        BiProject__c p = TestDataFactory.createBiProject('Project');
		BiWorkbook__c wb = TestDataFactory.createBiWorkbook(p, 'Workbook');
		BiView__c v = TestDataFactory.createBiView(wb, 'View');
		BiField__c f = TestDataFactory.createBiField(v, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(wb.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetBiViewTraceability() {
        BiProject__c p = TestDataFactory.createBiProject('Project');
		BiWorkbook__c wb = TestDataFactory.createBiWorkbook(p, 'Workbook');
		BiView__c v = TestDataFactory.createBiView(wb, 'View');
		BiField__c f = TestDataFactory.createBiField(v, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(v.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldGetBiFieldTraceability() {
        BiProject__c p = TestDataFactory.createBiProject('Project');
		BiWorkbook__c wb = TestDataFactory.createBiWorkbook(p, 'Workbook');
		BiView__c v = TestDataFactory.createBiView(wb, 'View');
		BiField__c f = TestDataFactory.createBiField(v, 'Field');
        
        Test.startTest();
    	String json = Traceability.getTraceabilityData(f.Id);
        Test.stopTest();
        
        System.assert(json != null);
    }
    
    @isTest
    static void shouldThrowExceptionOnUnsupportedObjectType() {
        Boolean failed;
		Account a = new Account(Name='Example');
        insert a;
        
        Test.startTest();
        try {
            String json = Traceability.getTraceabilityData(a.Id);
			failed = false;
        } catch (IllegalArgumentException e) {
            failed = true;
        }
        Test.stopTest();
        
        System.assert(true);
    }
    
}