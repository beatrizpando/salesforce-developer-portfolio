import { LightningElement } from 'lwc';
export default class HelloWorld extends LightningElement {
        greeting = 'mundo';
        changeHandler(event) {
        this.greeting = event.target.value;
        }
}