/* eslint-disable no-console */
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import apexSearch from '@salesforce/apex/MetadataSearchController.search';
import addColumnsToDataQualityRule from '@salesforce/apex/DataQualityRuleController.addColumnsToDataQualityRule';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

export default class NewDataQualityRuleForm extends NavigationMixin(LightningElement) {

    @api recordId = '';

    @wire(getObjectInfo, { objectApiName: 'Data_Quality_Rules__c',})
    objectInfo;

    addColumnsToDataQualityRule() {
        console.log('addColumnsToDataQualityRule called');
        let sourceIds = this.sources.map(src => src.id);
        console.log('sourceIds: ' + JSON.stringify(sourceIds));
        addColumnsToDataQualityRule({
            columnIds: sourceIds, 
            dataQualityRuleId: this.recordId
        })
        .then(results => {
            console.log('Navigating to record view');
            this.navigateToRecordView();
        })
        .catch(error => {
            console.log('An unexpected error occurred when updating the data request');
            console.log(error);
        });
    }

    handleSuccess(event) {
        console.log('handleSuccess called');
        this.recordId = event.detail.id;
        console.log('Successfully created data request: ', this.recordId);
        this.addColumnsToDataQualityRule();        
    }

    submitForm() {
        if (this.dataWheraboutsValue === 'known' && (this.sources === undefined || this.sources.length == 0)) {
            const event = new ShowToastEvent({
                'title': 'Error',
                'message': 'Since "I know the physical location of the data I want" is selected, at least one source is required.',
                'variant': 'error'
            });
            this.dispatchEvent(event);
        } else {
            this.template.querySelector('lightning-record-edit-form').submit();
        }
    }

    sources = [];
    handleSourceSelected(event) {
        console.log('handleSourceSelected called');
        const selection = event.target.getSelection();
        console.log('after getting selection');
        this.sources = selection;
        console.log('Sources are ' + JSON.stringify(this.sources));
    }

    handleSearch(event) {
        const target = event.target;
        console.log('Performing search: ' + event.detail);
        apexSearch(event.detail)
            .then(results => {
                target.setSearchResults(results);
            })
            .catch(error => {
                console.log('An unexpected error occurred when executing search');
                console.log(error);
            });
    }

    navigateToRecordView() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Data_Quality_Rules__c',
                actionName: 'view'
            }
        });
    }

    handleCancel() {
        window.history.back();
    }

}