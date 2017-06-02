//
//  SARegistroTableViewController.swift
//  iSaldos
//
//  Created by cice on 12/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Parse


class SARegistroTableViewController: UITableViewController {
    
    
    //MARK: - Variables locales
    
    var fotoSeleccionada = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var myImagePerfil: UIImageView!
    @IBOutlet weak var myUserName: UITextField!
    @IBOutlet weak var myPassword: UITextField!
    @IBOutlet weak var myName: UITextField!
    @IBOutlet weak var myLastName: UITextField!
    @IBOutlet weak var myEmail: UITextField!
    @IBOutlet weak var myMobile: UITextField!
    @IBOutlet weak var myIndicator: UIActivityIndicatorView!
    
    @IBOutlet var tabview: UITableView!
    
    
    //MARK: - Actions
    
    @IBAction func hideVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func registroEnParse(_ sender: Any) {
        var errorInicial = ""
        
        if myImagePerfil.image == nil || verifTextField(myUserName.text) || verifTextField(myPassword.text) ||  verifTextField(myName.text) ||  verifTextField(myLastName.text) || verifTextField(myEmail.text){
            errorInicial = "Estimado usuario rellene los campos obligatorios"
        }else{
            let newUser = PFUser()
            newUser.username = myUserName.text
            newUser.password = myPassword.text
            newUser.email = myEmail.text
            newUser["name"] = myName.text
            newUser["lastname"] = myLastName.text
            newUser["mobile"] = myMobile.text
            
            myIndicator.isHidden = false
            myIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            newUser.signUpInBackground(block: { (exitoso, errorRegistro) in
                
                self.myIndicator.isHidden = true
                self.myIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if errorRegistro != nil{
                    errorInicial = "Error al registrar"
                }else{
                    self.signUpWithPhoto()
                    self.performSegue(withIdentifier: "jumpFromRegisterVC", sender: self)
                }
                
            })
            
            if errorInicial != ""{
                self.present(muestraAlertVC("Atención", messageData: errorInicial), animated: true, completion: nil)
            }
            
            
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Mostrar o ocultar el activity indicator
        myIndicator.isHidden = true
        
        // Gesto sobre la imagen para que el usuario pueda interactuar
        myImagePerfil.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(pickerPhoto))
        myImagePerfil.addGestureRecognizer(tapGR)
        
        let tapGR_close_keybord = UITapGestureRecognizer(target: self, action: #selector(close_keybord))
        tabview.addGestureRecognizer(tapGR_close_keybord)
        
    }
    
    func signUpWithPhoto(){
        
        if fotoSeleccionada{
            let imageProfile = PFObject(className: "ImageProfile")
            let imageDataProfile = UIImageJPEGRepresentation(myImagePerfil.image!, 0.3)
            let imageProfileFile = PFFile(name: "userImageProfile.jpg", data: imageDataProfile!)
            
            imageProfile["imageProfile"] = imageProfileFile
            imageProfile["userName"] = PFUser.current()?.username
            imageProfile.saveInBackground()
            
        }else{
            self.present(muestraAlertVC("Atención", messageData: "Foto no seleccionada"), animated: true, completion: nil)
        }
    }

    func verifTextField(_ string : String?) -> Bool{
        return string?.trimmingCharacters(in: .whitespaces) == ""
    }
    
    func close_keybord() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

extension SARegistroTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    
    func pickerPhoto(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            muestraMenu()
        }else{
            muestraLibreriaFotos()
        }
    }
    
    func muestraMenu(){
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        let tomaFotoCamaraAction = UIAlertAction(title: "Toma foto", style: .default) { _ in
            self.muestraCamaraDispositivo()
        }
        let seleccionaFotoAction = UIAlertAction(title: "Selecciona desde la libreria", style: .default) { _ in
            self.muestraLibreriaFotos()
        }
        alertVC.addAction(cancelAction)
        alertVC.addAction(tomaFotoCamaraAction)
        alertVC.addAction(seleccionaFotoAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func muestraLibreriaFotos(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func muestraCamaraDispositivo(){
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let imageData = info[UIImagePickerControllerOriginalImage] as? UIImage{
            fotoSeleccionada = true
            myImagePerfil.image = imageData
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

