import { LightningElement, wire } from 'lwc';
import { subscribe, unsubscribe, MessageContext } from 'lightning/messageService';
import CARRITO_CHANNEL from '@salesforce/messageChannel/CarritoChannel__c';

export default class Carrito extends LightningElement {
    items = [];
    subscription = null;

    @wire(MessageContext)
    messageContext;

    connectedCallback() {
        this.subscription = subscribe(
            this.messageContext,
            CARRITO_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    disconnectedCallback() {
        unsubscribe(this.subscription);
        this.subscription = null;
    }

    handleMessage(message) {
        if (message.action === 'ADD_ITEM') {
            this.agregarItem(message.payload);
        } else if (message.action === 'REMOVE_ITEM') {
            this.eliminarItem(message.payload.id);
        }
    }

    agregarItem(producto) {
        const existente = this.items.find(i => i.id === producto.id);
        if (existente) {
            existente.cantidad += 1;
            existente.subtotalFormateado = (existente.precio * existente.cantidad).toFixed(2);
            this.items = [...this.items];
        } else {
            this.items = [
                ...this.items,
                { ...producto, cantidad: 1, subtotalFormateado: producto.precio.toFixed(2) }
            ];
        }
    }

    eliminarItem(id) {
        this.items = this.items.filter(i => i.id !== id);
    }

    handleEliminar(event) {
        const id = event.target.dataset.id;
        this.eliminarItem(id);
    }

    get cantidadItems() {
        return this.items.reduce((acc, i) => acc + i.cantidad, 0);
    }

    get totalFormateado() {
        return this.items
            .reduce((acc, i) => acc + i.precio * i.cantidad, 0)
            .toFixed(2);
    }
}