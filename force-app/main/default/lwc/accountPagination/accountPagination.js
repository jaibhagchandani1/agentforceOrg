import { LightningElement, track, wire } from 'lwc';
import getAccounts from '@salesforce/apex/AccountPaginationController.getAccounts';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Industry', fieldName: 'Industry' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { label: 'Website', fieldName: 'Website', type: 'url' }
];

export default class AccountPagination extends LightningElement {
    @track accounts = [];
    columns = COLUMNS;
    error;

    pageNumber = 1;
    pageSize = 10;
    totalRecords = 0;
    totalPages = 0;

    @wire(getAccounts, { pageSize: '$pageSize', pageNumber: '$pageNumber' })
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data.records;
            this.totalRecords = data.totalRecords;
            this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
            this.error = undefined;
        } else if (error) {
            this.error = error.body ? error.body.message : error.message;
            this.accounts = [];
        }
    }

    get isFirstPage() {
        return this.pageNumber === 1;
    }

    get isLastPage() {
        return this.pageNumber >= this.totalPages || this.totalPages === 0;
    }

    handlePrevious() {
        if (this.pageNumber > 1) {
            this.pageNumber = this.pageNumber - 1;
        }
    }

    handleNext() {
        if (this.pageNumber < this.totalPages) {
            this.pageNumber = this.pageNumber + 1;
        }
    }
}
