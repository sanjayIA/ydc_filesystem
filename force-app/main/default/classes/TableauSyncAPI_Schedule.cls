public without sharing class TableauSyncAPI_Schedule implements Schedulable {	
    public void execute(SchedulableContext sc) {
        TableauSyncAPINew.tableauQueryAPI();
    }    
}