//
//  SAParserPromociones.swift
//  iSaldos
//
//  Created by cice on 26/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import SwiftyJSON
import PromiseKit
import Alamofire

class SAParserPromociones: NSObject {
    
    //http://app.clubsinergias.es/api_comercios.php?idlocalidad=11&tipo=oferta&p=promociones
    var jsonDataPromociones : JSON?
    
    func getDatosPromociones(_ idLocalidad : String, idTipo : String, idParametro : String) -> Promise<JSON>{
        
        let customRequest = URLRequest(url: URL(string: CONSTANTES.LLAMADAS.BASE_URL + CONSTANTES.LLAMADAS.BASE_URL_LOCALIDAD + idLocalidad + "&tipo=" + idTipo + "&p=" + idParametro)!)
        print(customRequest)
        return Alamofire.request(customRequest).responseJSON().then(execute: { (dataJson) -> JSON in
            self.jsonDataPromociones = JSON(dataJson)
            return self.jsonDataPromociones!
        })
        
    }
    
    func getParserPromociones() -> [SAPromocionesModel]{
    
        var arrayPromociones = [SAPromocionesModel]()
        
        for c_promocion in (jsonDataPromociones?["promociones"])!{
            
            let asociadoModel = SAAsociadoModel(pId: dimeString(c_promocion.1["asociado"], nombre: "id"),
                                                pNombre: dimeString(c_promocion.1["asociado"], nombre: "nombre"),
                                                pDescripcion: dimeString(c_promocion.1["asociado"], nombre: "descripcion"),
                                                pCondicionesEspeciales: dimeString(c_promocion.1["asociado"], nombre: "condicionesEspeciales"),
                                                pDireccion: dimeString(c_promocion.1["asociado"], nombre: "direccion"),
                                                pIdActividad: dimeString(c_promocion.1["asociado"], nombre: "idActividad"),
                                                pIdLocalidad: dimeString(c_promocion.1["asociado"], nombre: "idLocalidad"),
                                                pImagen: dimeString(c_promocion.1["asociado"], nombre: "imagen"),
                                                pTelefonoFijo: dimeString(c_promocion.1["asociado"], nombre: "telefonoFijo"),
                                                pTelefonoMovil: dimeString(c_promocion.1["asociado"], nombre: "telefonoMovil"),
                                                pMail: dimeString(c_promocion.1["asociado"], nombre: "mail"),
                                                pWeb: dimeString(c_promocion.1["asociado"], nombre: "web"))
            
            
            let promocionModel = SAPromocionesModel(pId: dimeString(c_promocion.1, nombre: "id"),
                                                    pTipoPromocion: dimeString(c_promocion.1, nombre: "nombre"),
                                                    pNombre: dimeString(c_promocion.1, nombre: "nombre"),
                                                    pImporte: dimeString(c_promocion.1, nombre: "importe"),
                                                    pImagen: dimeString(c_promocion.1, nombre: "imagen"),
                                                    pFechaFin: dimeString(c_promocion.1, nombre: "fechaFin"),
                                                    pMasInformacion: dimeString(c_promocion.1, nombre: "masInformacion"),
                                                    pAsociado: asociadoModel)
            
            arrayPromociones.append(promocionModel)

            
        }
        
        return arrayPromociones
        
    }
    

}
