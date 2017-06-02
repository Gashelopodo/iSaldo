//
//  ApiHelpers.swift
//  iSaldos
//
//  Created by cice on 12/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import Foundation
import SwiftyJSON
import MessageUI

let customPrefs = UserDefaults.standard

// funcion de alertvc generica
func muestraAlertVC(_ titleData : String, messageData : String)-> UIAlertController{
    let alertVC = UIAlertController(title: titleData, message: messageData, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    return alertVC
}

// funcion de configuracion de MFMailComposeVC
func configuredMailCompose() -> MFMailComposeViewController{
    let mailCompose = MFMailComposeViewController()
    mailCompose.setToRecipients([""])
    mailCompose.setSubject("Ayuda para saber mas de la App")
    mailCompose.setMessageBody("Escriba por favor un corto mensaje al equipo de soporte de la App", isHTML: false)
    return mailCompose
}

// funcion de nil a string vacio // Politica de nulos
func dimeString(_ json : JSON, nombre : String) -> String{
    if let stringResult = json[nombre].string
    {
        return stringResult
    }else{
        return ""
    }
}

func getImagePath(_ type : String, id : String, name : String) -> String{
    return CONSTANTES.LLAMADAS.BASE_URL_PHOTO + id + "/" + name;
}
