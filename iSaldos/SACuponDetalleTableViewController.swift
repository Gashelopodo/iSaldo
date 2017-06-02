//
//  SACuponDetalleTableViewController.swift
//  iSaldos
//
//  Created by cice on 26/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

class SACuponDetalleTableViewController: UITableViewController {
    
    //MARK: - variables locales
    var cupon : SAPromocionesModel?
    var detalleImagen : UIImage?
    
    //MARK: - variables CB
    var qrData : String?
    var imageGroupTag = 3
    
    //MARK: - Outlet
    @IBOutlet weak var myImageOferta: UIImageView!
    @IBOutlet weak var myNombreOferta: UILabel!
    @IBOutlet weak var myFechaFin: UILabel!
    @IBOutlet weak var myMasInformacion: UILabel!
    @IBOutlet weak var myNombreAsociado: UILabel!
    @IBOutlet weak var myDescripcionAsociado: UILabel!
    @IBOutlet weak var myDireccionAsociado: UILabel!
    @IBOutlet weak var myTelefonoMovilAsociado: UILabel!
    @IBOutlet weak var myEmail: UILabel!
    @IBOutlet weak var myMovilAsociado: UILabel!
    @IBOutlet weak var myWebAsociado: UILabel!
    @IBOutlet weak var myIdActividadAsociado: UILabel!
    
    
    @IBAction func muestraBarCode(_ sender: Any) {
        
        let customBackground = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*2))
        customBackground.backgroundColor = CONSTANTES.COLORES.GRIS_NAV_TAB
        customBackground.alpha = 0.0
        customBackground.tag = imageGroupTag
        
        let customBackgroundAnimator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) { 
            customBackground.alpha = 0.5
            self.view.addSubview(customBackground)
        }
        
        customBackgroundAnimator.startAnimation()
        customBackgroundAnimator.addCompletion { _ in
            self.muestraImagenBarCode()
        }
        
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(quitarCB))
        view.addGestureRecognizer(tapGR)
        
        
    }
    
    //función nueva
    func quitarCB(){
        
        for c_subvista in self.view.subviews{
            
            if c_subvista.tag == self.imageGroupTag{
                c_subvista.removeFromSuperview()
            }
            
        }
        
    }
    
    func muestraImagenBarCode(){
        if myIdActividadAsociado.text == qrData{
            let anchoImagen = self.view.frame.width / 1.5
            let altoImagen = self.view.frame.height / 3
            
            let imageView = UIImageView(frame: CGRect(x: (self.view.frame.width/2) - (anchoImagen/2), y: (self.view.frame.height/2) - (altoImagen/2), width: anchoImagen, height: altoImagen))
            imageView.contentMode = .scaleAspectFit
            imageView.tag = imageGroupTag
            imageView.image = fromString(qrData!)
            self.view.addSubview(imageView)
        }
    }
    
    
    func fromString(_ string: String) -> UIImage{
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        return UIImage(ciImage: (filter?.outputImage)!)
    }
    
    
    @IBAction func muestraActionSheetPersonalizado(_ sender: Any) {
        
        let sbData = UIStoryboard(name: "ActionSheet", bundle: nil)
        let actionSheetVC = sbData.instantiateInitialViewController()
        actionSheetVC?.modalPresentationStyle = .overCurrentContext
        show(actionSheetVC as! UINavigationController, sender: self)
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        myImageOferta.image = detalleImagen
        myNombreOferta.text = cupon?.nombre
        myFechaFin.text = cupon?.fechaFin
        myMasInformacion.text = cupon?.masInformacion
        myNombreAsociado.text = cupon?.asociado?.nombre
        myTelefonoMovilAsociado.text = cupon?.asociado?.telefonoMovil
        myEmail.text = cupon?.asociado?.mail
        myMovilAsociado.text = cupon?.asociado?.telefonoFijo
        myWebAsociado.text = cupon?.asociado?.web
        myIdActividadAsociado.text = cupon?.asociado?.idActividad
        
        qrData = cupon?.asociado?.idActividad
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 1{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
