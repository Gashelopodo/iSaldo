//
//  SASingin.swift
//  iSaldos
//
//  Created by cice on 19/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import Foundation
import Parse


class APISignin : NSObject{
    var username : String?
    var password : String?
    
    init(pUsername : String, pPassword : String){
        self.username = pUsername
        self.password = pPassword
    }
    
    func signUser() throws{
        guard camposVacios() else {
            throw CustomError.campoVacio
        }
        guard validarDatosUsuario() else {
            throw CustomError.campoVacio
        }
    }
    
    func camposVacios() -> Bool{
        return (!(username?.isEmpty)! && !(password?.isEmpty)!)
    }
    
    func validarDatosUsuario() -> Bool{
        
        do {
            try PFUser.logIn(withUsername: username!, password: password!)
        } catch  {
            print("Error: \(error.localizedDescription)")
        }
        
        return (PFUser.current() != nil)
        
    }
    
}
