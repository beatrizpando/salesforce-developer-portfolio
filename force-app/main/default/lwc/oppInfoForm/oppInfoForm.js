import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CloseActionScreenEvent } from 'lightning/actions';
import { RefreshEvent } from 'lightning/actions';

import infoFormComponentController from '@salesforce/apex/InfoFormComponentController.infoFormComponentController';
import updateOppInfo from '@salesforce/apex/InfoFormComponentController.updateOppInfo';

export default class OppInfoForm extends LightningElement {
    _recordId;
    oppData;
    nuevoNombre;
    nuevaAmount;
    errorName;
    errorAmount;

    @api 
    set recordId(value) {
        this._recordId = value;
        
        if (value) {
            console.log('+++ ID real capturado por el Setter:', this._recordId);
            this.connectorController();
        }
    }

    get recordId() {
        return this._recordId;
    }

    connectorController(){
        infoFormComponentController({recordId: this.recordId})
            .then((result)=>{
                if (result && result.length > 0) {
                this.oppData = result[0];
                this.error = undefined;
                console.log('Datos de la opp:', this.oppData);
                console.log('+++Nombre opp: ', this.oppData.oppName);
                console.log('+++Cantidad opp: ', this.oppData.oppAmount);

                this.nuevoNombre = this.oppData.oppName;
                this.nuevaAmount = this.oppData.oppAmount;

                } else {
                    this.oppData = undefined;
                    this.error = 'El servidor devolvió una lista vacía.';
                }
            })
        
            .catch((error) => {
                this.error = error;
                console.error('Error al conectar con el controlador:', error);
            });
    }

    newName(event){
        this.nuevoNombre = event.target.value;
        console.log('+++nuevoNombre', this.nuevoNombre);
        
    }

    newAmount(event){
        this.nuevaAmount = event.target.value;
        console.log('+++nuevaAmount', this.nuevaAmount);
        
    }
    
    newDataClick(){
        console.log('+++nuevo nombre ', this.nuevoNombre );
        console.log('+++old nombre ', this.oppData.oppName );
        console.log('+++comparativa nombres ', this.nuevoNombre !== this.oppData.oppName );
        console.log('+++nueva amount', this.nuevaAmount );
        console.log('+++old amount ', this.oppData.oppAmount );
        console.log('+++comparativa amount ', this.nuevaAmount !== this.oppData.oppAmount);

        this.errorName = false;
        this.errorAmount = false;

        if(!this.nuevoNombre || this.nuevoNombre === this.oppData.oppName){
            this.errorName = true;
            console.log('+++errorName: ', this.errorName);
            
        }
        if(!this.nuevaAmount || this.nuevaAmount === this.oppData.oppAmount){
            this.errorAmount= true;
            console.log('+++errorAmount: ', this.errorAmount);
            
        }

        if(this.errorName === true || this.errorAmount === true){
            console.warn('No se detectaron cambios en los campos.');
            this.showToast('Sin cambios', 'Debes modificar ambos campos para continuar', 'warning');
            return;

        }
            
        updateOppInfo({recordId: this.recordId, oppName : this.nuevoNombre, oppAmount : this.nuevaAmount })
            .then((result) => {
                console.log('+++actualizado correctamente: ', result);
                this.showToast('Éxito', 'Todo correcto' , 'success');

                //utilizar un metodo navigatormixin en vez del refreshevent
                
                this.connectorController();
                this.dispatchEvent(new CloseActionScreenEvent());
                 
            })
            .catch((error)=>{
                console.error('Error recibido desde Apex:', error.body.message);
            });
    }

    showToast(title , message , variant) {
        const event = new ShowToastEvent({  title: title, message: message , variant: variant});
        this.dispatchEvent(event);
    }

}       

    
