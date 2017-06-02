//
//  SAPromocionesModel.swift
//  iSaldos
//
//  Created by cice on 19/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

class SAPromocionesModel: NSObject {
    
    var id : String?
    var tipoPromocion : String?
    var nombre : String?
    var importe : String?
    var imagen : String?
    var fechaFin : String?
    var masInformacion : String?
    var asociado : SAAsociadoModel?
    
    init(pId : String, pTipoPromocion : String, pNombre : String, pImporte : String, pImagen : String, pFechaFin : String, pMasInformacion : String, pAsociado : SAAsociadoModel){
        self.id = pId
        self.tipoPromocion = pTipoPromocion
        self.nombre = pNombre
        self.importe = pImporte
        self.imagen = pImagen
        self.fechaFin = pFechaFin
        self.masInformacion = pMasInformacion
        self.asociado = pAsociado
        super.init()
    }
    
    
    
    
    
    
}
