//
//  SAMenuLateralTableViewController.swift
//  iSaldos
//
//  Created by cice on 19/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Parse
import MessageUI

class SAMenuLateralTableViewController: UITableViewController {
    
    //MARK: - outlet
    
    @IBOutlet weak var myImagePerfil: UIImageView!
    @IBOutlet weak var myName: UILabel!
    @IBOutlet weak var myLastName: UILabel!
    @IBOutlet weak var myEmail: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // llamada a parse
        dameInfoParse()
        
        myImagePerfil.layer.cornerRadius = myImagePerfil.frame.width / 2
        myImagePerfil.layer.borderColor = CONSTANTES.COLORES.GRIS_NAV_TAB.cgColor
        myImagePerfil.layer.borderWidth = 1
        myImagePerfil.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - utils
    
    func dameInfoParse(){
        
        //1. primera consulta
        let queryData = PFUser.query()
        queryData?.whereKey("username", equalTo: (PFUser.current()?.username)!)
        queryData?.findObjectsInBackground(block: { (objQueryUno, errorUno) in
            if errorUno == nil{
                if let objQueryUnoDes = objQueryUno?.first{
                    self.myName.text = objQueryUnoDes["name"] as? String
                    self.myLastName.text = objQueryUnoDes["lastname"] as? String
                    self.myEmail.text = objQueryUnoDes["email"] as? String
                    
                    //2. segunda consulta
                    let queryFoto = PFQuery(className: "ImageProfile")
                    queryFoto.whereKey("userName", equalTo: (PFUser.current()?.username)!)
                    queryFoto.findObjectsInBackground(block: { (objQueryDos, errorDos) in
                        if errorDos == nil{
                            if let objQueryDosDes = objQueryDos?.first{
                                
                                //3. tercera consulta
                                let imageDataFile = objQueryDosDes["imageProfile"] as! PFFile
                                
                                imageDataFile.getDataInBackground(block: { (imageDataTres, errorTres) in
                                    if errorTres == nil{
                                        if let imageDataTresDes = imageDataTres{
                                            let imageDataFinal = UIImage(data: imageDataTresDes)
                                            self.myImagePerfil.image = imageDataFinal
                                        }
                                    }
                                })
                            }
                        }
                    })
                    
                }
            }
        })
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            switch indexPath.row {
            case 2:
                sendMessage()
            case 3:
                showRateAlertInmediatly(self)
            case 4:
                logout()
            default:
                break
            }
        }
    }
    
    func sendMessage(){
        let mailComposeVC = configuredMailCompose()
        mailComposeVC.mailComposeDelegate = self
        if MFMailComposeViewController.canSendMail(){
            present(mailComposeVC, animated: true, completion: nil)
        }else{
            present(muestraAlertVC("Atención", messageData: "El mail no se ha enviado correctamente"), animated: true, completion: nil)
        }
    }
    

    func logout(){
        PFUser.logOut()
    }
    
    
    
    

    
    
}

extension SAMenuLateralTableViewController : MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion:  nil)
    }
}











