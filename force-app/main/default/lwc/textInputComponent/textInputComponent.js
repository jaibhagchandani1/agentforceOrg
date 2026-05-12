import { LightningElement,api } from 'lwc';

export default class TextInputComponent extends LightningElement {

    _readOnly = false;
    bookName;

    @api get readOnly(){
        return this._readOnly;
    }

    set readOnly(value){
        this._readOnly = value;
    }

    @api get value(){
        return this._value;
    }

    set value(value){
        this._value = value;
    }

    connectedCallback(){
        if(this.value){
            this.bookName = this.value?.bookName || '';
        }
    }

    handleInputChange(event){
        event.stopPropogation();
        this.bookName = event.target.value;
        this.dispatchEvent(new CustomEvent('valueChange',{
            detail : {
                value : {
                    bookName : this.bookName
                }
            }
        }))
    }


}