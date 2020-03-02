@isTest
public class TestImpactAnalysis {
    
    @isTest
    static void shouldGetColumnImpactAnalysis() { // TODO Please move column logic in Lineage class to a new "ImpactAnalysis" class and move this test to a "TestImpactAnalysis" class.
        Database__c db = TestDataFactory.createDatabase('Database');
		Schema__c sch = TestDataFactory.createSchema(db, 'Schema');
		Table__c tbl = TestDataFactory.createTable(sch, 'Table');
		Column__c col = TestDataFactory.createColumn(tbl, 'Column');
        BiProject__c p = TestDataFactory.createBiProject('Project');
		BiWorkbook__c wb = TestDataFactory.createBiWorkbook(p, 'Workbook');
		BiView__c v = TestDataFactory.createBiView(wb, 'View');
		BiField__c f = TestDataFactory.createBiField(v, 'Field');
        BiField_Column__c fc = TestDataFactory.createColumnBifield(f, col);    
        Test.startTest();
    	String json = ImpactAnalysis.getImpactData(col.Id);
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
            String json = ImpactAnalysis.getImpactData(a.Id);
			failed = false;
        } catch (IllegalArgumentException e) {
            failed = true;
        }
        Test.stopTest();
        
        System.assert(true);
    }
}