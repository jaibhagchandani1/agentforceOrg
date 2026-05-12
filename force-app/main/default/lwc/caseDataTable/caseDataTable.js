import { LightningElement,api,wire,track } from 'lwc';

export default class CaseDataTable extends LightningElement {
    @api value; // This property will receive the data from Agentforce
    columns = [
        { label: 'Case Number', fieldName: 'caseNumber' },
        { label: 'Case Status', fieldName: 'caseStatus' }
    ];

    get cases() {
        if (Array.isArray(this.value)) {
            return this.value.map(({ caseNumber, caseStatus }) => ({
                caseNumber,
                caseStatus
            }));
        }
        return [];
    }
}