import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import CARRITO_CHANNEL from '@salesforce/messageChannel/CarritoChannel__c';
import getProductos from '@salesforce/apex/CatalogueController.getProductos';

export default class Catalogo extends LightningElement {
    @wire(MessageContext)
    messageContext;

    productos = [];
    error;

    @wire(getProductos)
    wiredProductos({ data, error }) {
        if (data) {
            this.productos = data.map(entry => ({
                id: entry.Product2.Id,
                pricebookEntryId: entry.Id, // útil si luego creas OrderItem/OpportunityLineItem
                nombre: entry.Product2.Name,
                descripcion: entry.Product2.Description,
                precio: entry.UnitPrice,
                precioFormateado: entry.UnitPrice.toFixed(2)
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error.body?.message || 'Error al cargar productos';
            this.productos = [];
        }
    }

    handleAgregar(event) {
        const id = event.target.dataset.id;
        const producto = this.productos.find(p => p.id === id);

        publish(this.messageContext, CARRITO_CHANNEL, {
            action: 'ADD_ITEM',
            payload: producto
        });
    }
}