import { LightningElement, track } from 'lwc';

import getCases
from '@salesforce/apex/CaseKeysetPaginationController.getCases';

export default class CasePagination
extends LightningElement {

    @track cases = [];

    pageSize = 50;

    lastCreatedDate;

    lastRecordId;

    isFirstPage = true;

    columns = [

        {
            label: 'Case Number',
            fieldName: 'CaseNumber'
        },

        {
            label: 'Subject',
            fieldName: 'Subject'
        },

        {
            label: 'Status',
            fieldName: 'Status'
        },

        {
            label: 'Priority',
            fieldName: 'Priority'
        },

        {
            label: 'Created Date',
            fieldName: 'CreatedDate',
            type: 'date'
        }

    ];

    connectedCallback() {

        this.loadCases();

    }

    loadCases() {

        getCases({

            pageSize: this.pageSize,

            lastCreatedDate:
                this.lastCreatedDate,

            lastRecordId:
                this.lastRecordId,

            isFirstPage:
                this.isFirstPage

        })

        .then(result => {

            this.cases =
                result.records;

            if (this.cases.length > 0) {

                const lastRecord =
                    this.cases[
                        this.cases.length - 1
                    ];

                this.lastCreatedDate =
                    lastRecord.CreatedDate;

                this.lastRecordId =
                    lastRecord.Id;

                this.isFirstPage = false;

            }

        })

        .catch(error => {

            console.error(error);

        });

    }

    handleNext() {

        this.loadCases();

    }

    get isLastPage() {

        return this.cases.length
            < this.pageSize;

    }

}