//
//  UserPostModel.swift
//  iSaldos
//
//  Created by cice on 2/6/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Parse

class UserPostModel: NSObject {
    
    var nombre : String?
    var apellido : String?
    var username : String?
    var imageProfile : PFFile?
    var imagePoster : PFFile?
    var fechaCreacion : Date?
    var descripcionImagen : String?
    
    init(pNombre : String, pApellido : String, pUserName : String, pImageProfile : PFFile, pImagePoster : PFFile, pFechaCreacion : Date, pDescripcionImagen : String){
    
        self.nombre = pNombre
        self.apellido = pApellido
        self.username = pUserName
        self.imagePoster = pImagePoster
        self.imageProfile = pImageProfile
        self.fechaCreacion = pFechaCreacion
        self.descripcionImagen = pDescripcionImagen
   
    }
    

}
