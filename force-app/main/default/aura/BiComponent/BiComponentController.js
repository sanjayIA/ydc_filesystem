({
    doInit: function(component, event, helper) {
        helper.fetchPickListVal(component, 'Type__c', 'datatype');
    },
    onPicklistChange: function(component, event, helper) {
        // get the value of select option 
       
        if(event.getSource().get("v.value")=='Tableau')
    {
     window.location = "https://ydc-domain-dev-ed.lightning.force.com/lightning/o/BiProject__c/list?filterName=00B6g000008LvgvEAC";
    }
    },
})