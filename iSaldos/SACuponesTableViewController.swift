//
//  SACuponesTableViewController.swift
//  iSaldos
//
//  Created by cice on 26/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD
import PromiseKit

class SACuponesTableViewController: UITableViewController {
    
    
    //MARK: variables
    var arrayCupones = [SAPromocionesModel]()
    var imageViewArray = [UIImage]()
    var imageView : UIImage?
    
    
    //outlet
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //llamada
        llamadaCupones()
        
        //TODO: - Mostramos el menu lateral
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rightViewRevealWidth = 150
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //registro de la celda
        tableView.register(UINib(nibName: "ISOfertaCustomCell", bundle: nil), forCellReuseIdentifier: "ISOfertaCustomCell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        // #warning Incomplete implementation, return the number of rows
        return arrayCupones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCuponesCell = tableView.dequeueReusableCell(withIdentifier: "ISOfertaCustomCell", for: indexPath) as! ISOfertaCustomCell
        
        let model = arrayCupones[indexPath.row]
        customCuponesCell.myNombreOferta.text = model.nombre
        customCuponesCell.myFechaOferta.text = model.fechaFin
        customCuponesCell.myInformacionOferta.text = model.masInformacion
        customCuponesCell.myImporteOferta.text = model.importe
        
        
        customCuponesCell.myImagenOferta.kf.setImage(with: ImageResource(downloadURL: URL(string: getImagePath(CONSTANTES.LLAMADAS.OFERTA, id: model.id!, name: model.imagen!))!), placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil) { (image, error, cachetype, url) in
            self.imageViewArray.append(image!)
            
        }
        

        // Configure the cell...
        
        return customCuponesCell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customCuponesCell = tableView.dequeueReusableCell(withIdentifier: "ISOfertaCustomCell", for: indexPath) as! ISOfertaCustomCell
        //let customOfertasCell = tableView.cellForRow(at: indexPath)
        imageView = imageViewArray[indexPath.row]
        performSegue(withIdentifier: "showCuponSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCuponSegue"{
            let detalleVC = segue.destination as! SACuponDetalleTableViewController
            let selectInd = tableView.indexPathForSelectedRow?.row
            let objInd = arrayCupones[selectInd!]
            detalleVC.cupon = objInd
            detalleVC.detalleImagen = imageView!
        }
    }
    
    func llamadaCupones(){
        let datosOferta = SAParserPromociones()
        let idLocalidad = "11"
        let tipoOferta = CONSTANTES.LLAMADAS.CUPON
        let tipoParametro = CONSTANTES.LLAMADAS.PROMOCIONES_SERVICE
        
        HUD.show(.progress)
        firstly{
            return when(resolved: datosOferta.getDatosPromociones(idLocalidad, idTipo: tipoOferta, idParametro: tipoParametro))
            
            }.then{_ in
                self.arrayCupones = datosOferta.getParserPromociones()
            }.then{_ in
                self.tableView.reloadData()
            }.then{_ in
                HUD.hide(afterDelay: 0)
            }.catch { (error) in
                self.present(muestraAlertVC("Atención", messageData: "Problemas"), animated: true, completion: nil)
        }
        
        
    }


    

}
