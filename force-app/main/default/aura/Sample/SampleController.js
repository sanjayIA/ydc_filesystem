({
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, 'Type__c', 'datatype');
    },
    onPicklistChange: function(component, event, helper) {
        // get the value of select option 
 if(event.getSource().get("v.value")=='Oracle')
 {
     window.location = "https://ydc-domain-dev-ed.lightning.force.com/lightning/o/Database__c/list?filterName=Recent";
 }
 else if(event.getSource().get("v.value")=='PostgreSQL')
 {
     window.location = "https://ydc-domain-dev-ed.lightning.force.com/lightning/o/Database__c/list?filterName=Recent";
 }
 else if(event.getSource().get("v.value")=='Redshift')
 {
     window.location = "https://ydc-domain-dev-ed.lightning.force.com/lightning/o/Database__c/list?filterName=Recent";
 }
    },
})