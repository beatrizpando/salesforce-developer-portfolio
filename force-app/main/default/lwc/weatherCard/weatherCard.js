import { LightningElement, api } from 'lwc';
import processAccountInfoLwc from '@salesforce/apex/WeatherComponentController.processAccountInfoLwc';
import capturarRegion from '@salesforce/apex/WeatherComponentController.capturarRegion';

export default class WeatherCard extends LightningElement {
    @api recordId;
    accData; 
    error;
    regionModificada;

    connectedCallback() {
        console.log ('test', this.recordId );

        this.conectorController();

    }   
    
    conectorController(){
        processAccountInfoLwc({recordId: this.recordId})
            .then((result)=>{
               if (result && result.length > 0 && result != undefined) {
                this.accData = result[0];
                this.error = undefined;
                console.log('Datos del clima completos:', this.accData);
                console.log('Datos de la ubicacion:', this.accData.accountDataLwc.BillingCity);
                console.log('+++mensajeclima', this.accData.mensajeClimaLwc);
            } else {
                this.accData = undefined;
                this.error = 'El servidor devolvió una lista vacía.';
            }
            })
            .catch((error) => {
                this.error = error;
                console.error('Error al conectar con el controlador:', error);
            });
    }

    nuevaRegion(event){
        this.regionModificada = event.target.value;
        console.log('+++regionModificada', this.regionModificada);
    }

    nuevaRegionClick(){
        capturarRegion({ region: this.regionModificada })
            .then(() => {
                console.error('Todo correcto');
            })
            .catch((error)=>{
                console.error('Error', error);
            });
    }
}
