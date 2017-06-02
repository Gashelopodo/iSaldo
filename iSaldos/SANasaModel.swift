//
//  SANasaModel.swift
//  iSaldos
//
//  Created by cice on 2/6/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

class SANasaModel: NSObject {
    
    var id : String?
    var fecha : String?
    var date : String?
    var explanation : String?
    var hdurl : String?
    var media_type : String?
    var service : String?
    var title : String?
    var url : String?
    
    
    init(pId : String, pFecha: String, pDate: String, pExplanation : String, pHdurl : String, pMedia_type : String, pService : String, pTitle : String, pUrl : String){
        
        self.id = pId
        self.fecha = pFecha
        self.date = pDate
        self.explanation = pExplanation
        self.hdurl = pHdurl
        self.media_type = pMedia_type
        self.service = pService
        self.title = pTitle
        self.url = pUrl
        
        super.init()
        
        
    }
    
}
