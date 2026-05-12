import { LightningElement,api,track,wire } from 'lwc';

export default class Bookslwc extends LightningElement {
    books = []

    @api get value(){
        return this._value;
    }

    set value(value){
        this._value = value;
    } 

    connectedCallback(){
        try{
            if(this.value){
                this.updatedValue = [];
                this.value.bookOptions.map(record=>{

                    const fullStars = Math.floor(record.rating);
                    const halfStar = record.rating - fullStars >= 0.5;
                    const stars = [];
                    for(let i=0; i < fullStars ; i++){
                        stars.push({ key : `${record.name}-stars-${i}`, icon:'utility:favorite'})
                    }
                    if(halfStar){
                        stars.push({ key : `${record.name}-half`, icon:'utility:favorite_half'})
                    }
                    while(stars.length < 5){
                        stars.push({ key : `${record.name}-empty-${stars.length}`, icon:'utility:favorite_outline'})
                    }

                    this.updatedValue.push({
                        ...record,
                        stars,
                        isBestSeller : record.bestSeller ? 'Yes':'No'
                    });
                })
                this.books = this.updatedValue;
            }
        }
        catch(error){
            console.log('Error on fetching data' , JSON.stringify(error));
        }
    }

    handleBuyNow(event){
        console.alert('Buy Now Clicked');
    }
}