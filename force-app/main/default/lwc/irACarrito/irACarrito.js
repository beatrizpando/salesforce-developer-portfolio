import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class IrACarrito extends NavigationMixin(LightningElement) {

    irACarrito() {
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'Product_Cart'
            }
        });
    }
}