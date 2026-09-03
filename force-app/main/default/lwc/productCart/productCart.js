import { LightningElement, wire, track } from 'lwc';
import getInventory from '@salesforce/apex/CartController.getInventory';


export default class ProductCart extends LightningElement {
    @track products = []; // Aquí se guardarán los productos reales de la org
    @track cart = [];
    error;


    @wire(getInventory, { pricebookId: '$pricebookId' })
    wiredProducts({ error, data }) {
        if (data) {
            // Mapeamos los datos reales del objeto PricebookEntry para adaptarlos al formato del HTML
            this.products = data.map(item => ({
                Id: item.Product2.Id,
                Name: item.Product2.Name,
                ProductCode: item.Product2.ProductCode,
                Price: item.UnitPrice, // El precio unitario viene de PricebookEntry, no de Product2 [1]
                PricebookEntryId: item.Id // Guardamos esto para cuando creemos el Pedido/Orden final
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            console.error('Error cargando el inventario real:', error);
        }
    }
}