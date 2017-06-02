//
//  SANasaTableViewController.swift
//  iSaldos
//
//  Created by cice on 2/6/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Kingfisher
import PKHUD
import PromiseKit

class SANasaTableViewController: UITableViewController {
    
    
    //MARK: variables
    var arrayNasa = [SANasaModel]()
    var imageViewArray = [UIImage]()
    var imageView : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        //llamada
        llamadaNasa()
        
        
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
        // #warning Incomplete implementation, return the number of rows
        return arrayNasa.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customOfertasCell = tableView.dequeueReusableCell(withIdentifier: "ISOfertaCustomCell", for: indexPath) as! ISOfertaCustomCell
        
        
        let model = arrayNasa[indexPath.row]
        customOfertasCell.myNombreOferta.text = model.title
        customOfertasCell.myFechaOferta.text = model.date
        customOfertasCell.myInformacionOferta.text = model.explanation
        customOfertasCell.myImporteOferta.text = "0"
        
     
        customOfertasCell.myImagenOferta.kf.setImage(with: ImageResource(downloadURL: URL(string: model.url!)!), placeholder: #imageLiteral(resourceName: "placeholder"), options: nil, progressBlock: nil) { (image, error, cachetype, url) in
            if image != nil {
                self.imageViewArray.append(image!)
            }
            
        }


        return customOfertasCell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customOfertasCell = tableView.dequeueReusableCell(withIdentifier: "ISOfertaCustomCell", for: indexPath) as! ISOfertaCustomCell
        imageView = imageViewArray[indexPath.row]
        performSegue(withIdentifier: "showOfertaSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNasaSegue"{
            let detalleVC = segue.destination as! SANasaDetalleTableViewController
            let selectInd = tableView.indexPathForSelectedRow?.row
            let objInd = arrayNasa[selectInd!]
            detalleVC.nasa = objInd
            detalleVC.detalleImagen = imageView!
        }
    }
    
    func llamadaNasa(){
        let datosNasa = SAParserNasa()
        
        HUD.show(.progress)
        firstly{
            return when(resolved: datosNasa.getDataNasa())
            
            }.then{_ in
                self.arrayNasa = datosNasa.getParserNasa()
            }.then{_ in
                self.tableView.reloadData()
            }.then{_ in
                HUD.hide(afterDelay: 0)
            }.catch { (error) in
                self.present(muestraAlertVC("Atención", messageData: "Problemas"), animated: true, completion: nil)
        }
        
        
    }
    
    

}
