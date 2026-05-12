import { LightningElement,api } from 'lwc';

export default class PicklistRatingBooks extends LightningElement {

    @api get readOnly(){
        return this._readOnly;
    }
    set readOnly(value){
        this._readOnly = value;
    }
    _readOnly = false;
    _value;

    @api get value(){
        return this._value;
    }

    set value(value){
        this._value = value;
    }

    rating;

    get options(){
        return [
            {label:'1',value:'1'},
            {label:'2',value:'2'},
            {label:'3',value:'3'},
            {label:'4',value:'4'},
            {label:'5',value:'5'},
        ]
    }

    connectedCallback(){
        if(this.value){
            this.rating = this.value?.rating || '';
        }
    }

    handleChange(event){
        this.rating = event.detail.value;
        event.stopPropogation();
        this.dispatchEvent(new CustomEvent('valuechange',{
            detail:{
                value:{
                    rating:this.rating
                }
            }
        }))
    }
}