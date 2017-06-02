//
//  SAOfertasTableViewController.swift
//  iSaldos
//
//  Created by cice on 19/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD
import PromiseKit

class SAOfertasTableViewController: UITableViewController {
    
    
    //MARK: variables
    var arrayOfertas = [SAPromocionesModel]()
    var imageViewArray = [UIImage]()
    var imageView : UIImage?
    
    
    //MARK: - outlet
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //llamada
        llamadaOfertas()

        //TODO: - Mostramos el menu lateral
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //registro de la celda
        tableView.register(UINib(nibName: "ISOfertaCustomCell", bundle: nil), forCellReuseIdentifier: "ISOfertaCustomCell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tamañao de array: \(self.arrayOfertas.count) ")
        // #warning Incomplete implementation, return the number of rows
        return arrayOfertas.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customOfertasCell = tableView.dequeueReusableCell(withIdentifier: "ISOfertaCustomCell", for: indexPath) as! ISOfertaCustomCell
        
        let model = arrayOfertas[indexPath.row]
        customOfertasCell.myNombreOferta.text = model.nombre
        customOfertasCell.myFechaOferta.text = model.fechaFin
        customOfertasCell.myInformacionOferta.text = model.masInformacion
        customOfertasCell.myImporteOferta.text = model.importe
        
        /*customOfertasCell.myImagenOferta.kf.setImage(with: ImageResource(downloadURL: URL(string: getImagePath(CONSTANTES.LLAMADAS.OFERTA, id: model.id!, name: model.imagen!))!),
                                                     placeholder: #imageLiteral(resourceName: "placeholder"),
                                                     options: nil,
                                                     progressBlock: nil,
                                                     completionHandler: nil)
        */
        customOfertasCell.myImagenOferta.kf.setImage(with: ImageResource(downloadURL: URL(string: getImagePath(CONSTANTES.LLAMADAS.OFERTA, id: model.id!, name: model.imagen!))!), placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil) { (image, error, cachetype, url) in
            self.imageViewArray.append(image!)
            
        }
        
        
 
       
        

        // Configure the cell...

        return customOfertasCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customOfertasCell = tableView.dequeueReusableCell(withIdentifier: "ISOfertaCustomCell", for: indexPath) as! ISOfertaCustomCell
        //let customOfertasCell = tableView.cellForRow(at: indexPath)
        imageView = imageViewArray[indexPath.row]
        performSegue(withIdentifier: "showOfertaSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showOfertaSegue"{
            let detalleVC = segue.destination as! SAOfertaDetalleTableViewController
            let selectInd = tableView.indexPathForSelectedRow?.row
            let objInd = arrayOfertas[selectInd!]
            detalleVC.oferta = objInd
            detalleVC.detalleImagen = imageView!
        }
    }
    

  
    
    func llamadaOfertas(){
        let datosOferta = SAParserPromociones()
        let idLocalidad = "11"
        let tipoOferta = CONSTANTES.LLAMADAS.OFERTA
        let tipoParametro = CONSTANTES.LLAMADAS.PROMOCIONES_SERVICE
        
        HUD.show(.progress)
        firstly{
            return when(resolved: datosOferta.getDatosPromociones(idLocalidad, idTipo: tipoOferta, idParametro: tipoParametro))
            
            }.then{_ in
                self.arrayOfertas = datosOferta.getParserPromociones()
            }.then{_ in
                self.tableView.reloadData()
            }.then{_ in
                HUD.hide(afterDelay: 0)
            }.catch { (error) in
                self.present(muestraAlertVC("Atención", messageData: "Problemas"), animated: true, completion: nil)
            }
        
        
    }
    
    
    
    

}
