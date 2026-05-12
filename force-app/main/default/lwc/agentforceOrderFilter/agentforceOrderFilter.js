import OrderNumber from '@salesforce/schema/Order.OrderNumber';
import { LightningElement,api } from 'lwc';

export default class AgentforceOrderFilter extends LightningElement {

    
    @api
    email = '';
    @api
    orderName = '';
    

    handleInputChange(event){
   
        const {name,value}=event.target;
        this[name] = value;
        this.dispatchEvent('valuechange',{
            detail:{
                value:{
                    email:this.email,
                    orderName : this.orderName
                }
            }
        })
    }
}