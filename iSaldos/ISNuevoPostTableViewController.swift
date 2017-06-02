//
//  ISNuevoPostTableViewController.swift
//  iSaldos
//
//  Created by cice on 2/6/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Parse

class ISNuevoPostTableViewController: UITableViewController {

    //MARK: - variables
    var fotoSeleccionada = false
    var fechaHumana = Date()
    
    
    
    //MARK: - outlet
    
    @IBOutlet weak var myImagenPerfil: UIImageView!
    @IBOutlet weak var myUserNamePerfil: UILabel!
    @IBOutlet weak var myNombreApellidoPerfil: UILabel!
    @IBOutlet weak var myFechaHumanaPerfil: UILabel!
    @IBOutlet weak var myDescripcionPoster: UITextView!
    @IBOutlet weak var myImagenPoster: UIImageView!
    
    
    
    @IBAction func hideVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        myDescripcionPoster.delegate = self
        
        
        //Bloque de toolbar
        let barraFlexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let colorBB = CONSTANTES.COLORES.BLANCO_TEXTO_NAB
        let colorTO = CONSTANTES.COLORES.GRIS_NAV_TAB
        
        let camara = UIBarButtonItem(image: UIImage(named: "camara"), style: .done, target: self, action: #selector(pickerPhoto))
        let guardar = UIBarButtonItem(title: "Guardar", style: .plain, target: self, action: #selector(salvarDatos))
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        toolbar.barStyle = .blackOpaque
        toolbar.tintColor = colorBB
        toolbar.barTintColor = colorTO
        toolbar.items = [camara, barraFlexible, guardar]
        myDescripcionPoster.inputAccessoryView = toolbar
        
        let customDateFor = DateFormatter()
        customDateFor.dateStyle = .medium
        myFechaHumanaPerfil.text = "fecha" + " " + customDateFor.string(from: fechaHumana)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(bajarTeclado))
        tableView.addGestureRecognizer(tapGR)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myDescripcionPoster.becomeFirstResponder()
        informacionUsuario()
    }

    
    func bajarTeclado(){
        myDescripcionPoster.resignFirstResponder()
    }
    
    func salvarDatos(){
    
    }
    
    func informacionUsuario(){
        //1.consulta
        let queryUser = PFUser.query()
        queryUser?.whereKey("username", equalTo: (PFUser.current()?.username)!)
        queryUser?.findObjectsInBackground(block: { (objectUno, errorUno) in
            if errorUno == nil{
                if let objectUnoDes = objectUno?[0]{
                    self.myNombreApellidoPerfil.text = objectUnoDes["name"] as? String
                    self.myNombreApellidoPerfil.text?.append(" "+(objectUnoDes["lastname"] as? String)!)
                    self.myUserNamePerfil.text = PFUser.current()?.username
                    //2.consulta
                    let imagenPerfil = PFQuery(className: "ImageProfile")
                    imagenPerfil.whereKey("username", equalTo: (PFUser.current()?.username)!)
                    imagenPerfil.findObjectsInBackground(block: { (objectDos, errorDos) in
                        if errorDos == nil{
                            if let objectDosDes = objectDos?[0]{
                                let imageUserData = objectDosDes["imageProfile"] as! PFFile
                                imageUserData.getDataInBackground(block: { (imageData, errorData) in
                                    if let imageDataDes = imageData{
                                        self.myImagenPerfil.image = UIImage(data: imageDataDes)
                                    }
                                })
                            }
                        }
                        
                    })
                }
                
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return UITableViewAutomaticDimension
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    
    
    
}


extension ISNuevoPostTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    
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
            myImagenPoster.image = imageData
            if myImagenPoster != nil{
                fotoSeleccionada = true
            }
           
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ISNuevoPostTableViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray{
            textView.text = nil
            textView.textColor = UIColor.black
            self.navigationController?.setToolbarHidden(true, animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty{
            textView.text = "¿Qué está pasando?"
            textView.textColor = UIColor.lightGray
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
    
}




