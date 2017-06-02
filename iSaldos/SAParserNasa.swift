//
//  SAParserNasa.swift
//  iSaldos
//
//  Created by cice on 2/6/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import PromiseKit
import Alamofire

class SAParserNasa: NSObject {
    
    var jsonDataNasa : JSON?
    
    
    func getDataNasa() -> Promise<JSON>{
    
        let customRequest = URLRequest(url: URL(string: CONSTANTES.LLAMADAS.URL_NASA)!)
        return Alamofire.request(customRequest).responseJSON().then(execute: { (dataJson) -> JSON in
            self.jsonDataNasa = JSON(dataJson)
            return self.jsonDataNasa!
        })
    
    }
    
    
    
    func getParserNasa() -> [SANasaModel]{
        
        var arrayNasa = [SANasaModel]()
        
        for c_nasa in (jsonDataNasa?["news"])!{
        
            let nasaModel = SANasaModel(pId: dimeString(c_nasa.1, nombre: "id"),
                                        pFecha: dimeString(c_nasa.1, nombre: "fecha"),
                                        pDate: dimeString(c_nasa.1, nombre: "date"),
                                        pExplanation: dimeString(c_nasa.1, nombre: "explanation"),
                                        pHdurl: dimeString(c_nasa.1, nombre: "hdurl"),
                                        pMedia_type: dimeString(c_nasa.1, nombre: "media_type"),
                                        pService: dimeString(c_nasa.1, nombre: "service_version"),
                                        pTitle: dimeString(c_nasa.1, nombre: "title"),
                                        pUrl: dimeString(c_nasa.1, nombre: "url"))
            
            arrayNasa.append(nasaModel)
        }
        
        return arrayNasa
        
    }

}
