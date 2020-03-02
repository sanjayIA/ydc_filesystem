public without sharing class MetadataSearchController {
    
    private final static Integer MAX_RESULTS = 10;

    @AuraEnabled(Cacheable=true)
    public static List<MetadataSearchResult> search(String searchTerm, List<String> selectedIds) {
        System.debug('search called');
        /*
        // Prepare query paramters.
        searchTerm = '*' + searchTerm + '*';

        // Execute search query.
        List<List<SObject>> searchResults = [
            FIND :searchTerm
            IN ALL FIELDS
            RETURNING
                Column__c(Id, Name WHERE Id NOT IN :selectedIds),
                Table__c(Id, Name WHERE Id NOT IN :selectedIds),
            	Schema__c(Id, Name WHERE Id NOT IN :selectedIds),
            	Database__c(Id, Name WHERE Id NOT IN :selectedIds)
            LIMIT :MAX_RESULTS
        ];

        // Prepare results.
        List<MetadataSearchResult> results = new List<MetadataSearchResult>();

        // Extract columns and convert them into MetadataSearchResult.
        String cIcon = 'custom:custom59';
        Column__c[] columns = ((List<Column__c>) searchResults[0]);
        for (Column__c c : columns) {
            results.add(
                new MetadataSearchResult(
                    c.Id,
                    'Column__c',
                    cIcon,
                    c.Name,
                    'Column • ' + c.Name
                )
            );
        }

        // Extract tables and convert them into MetadataSearchResult.
        String tIcon = 'custom:custom104';
        Table__c[] tables = ((List<Table__c>) searchResults[1]);
        for (Table__c t : tables) {
            results.add(
                new MetadataSearchResult(
                    t.Id,
                    'Table__c',
                    tIcon,
                    t.Name,
                    'Table • ' + t.Name
                )
            );
        }
        
        // Extract tables and convert them into MetadataSearchResult.
        String sIcon = 'custom:custom57';
        Schema__c[] schemas = ((List<Schema__c>) searchResults[2]);
        for (Schema__c s : schemas) {
            results.add(
                new MetadataSearchResult(
                    s.Id,
                    'Schema__c',
                    sIcon,
                    s.Name,
                    'Schema • ' + s.Name
                )
            );
        }

        // Extract tables and convert them into MetadataSearchResult.
        String dbIcon = 'custom:custom13';
        Database__c[] databases = ((List<Database__c>) searchResults[3]);
        for (Database__c db : databases) {
            results.add(
                new MetadataSearchResult(
                    db.Id,
                    'Database__c',
                    dbIcon,
                    db.Name,
                    'Database • ' + db.Name
                )
            );
        }

        return results;
        */

        List<MetadataSearchResult> results = new List<MetadataSearchResult>();
        String cIcon = 'custom:custom59';
        results.add(
                new MetadataSearchResult(
                    'a0A6g000005aRVhEAM',
                    'Column__c',
                    cIcon,
                    'JASQFT',
                    'Column • ' + 'F4452.JASQFT (Square Feet)'
                )
            );
        return results;
    }
    
}