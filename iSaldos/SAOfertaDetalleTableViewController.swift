//
//  SAOfertaDetalleTableViewController.swift
//  iSaldos
//
//  Created by cice on 19/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import MapKit

class SAOfertaDetalleTableViewController: UITableViewController {
    
    var oferta : SAPromocionesModel?
    var detalleImagen : UIImage?
    
    
    //outlet
    
    @IBOutlet weak var myImageOferta: UIImageView!
    @IBOutlet weak var myNombreOferta: UILabel!
    @IBOutlet weak var myFechaFin: UILabel!
    @IBOutlet weak var myMasInformacion: UILabel!
    @IBOutlet weak var myNombreAsociado: UILabel!
    @IBOutlet weak var myDescripcionAsociado: UILabel!
    @IBOutlet weak var myDireccionAsociado: UILabel!
    @IBOutlet weak var myTelefonoMovilAsociado: UILabel!
    @IBOutlet weak var myEmail: UILabel!
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var myTelefonoButton: UIButton!
    @IBOutlet weak var myWebButton: UIButton!
    
    
    //action
    @IBAction func hacerLlamadaTelefono(_ sender: UIButton) {
        
        let stringUno = sender.titleLabel?.text
        let phoneUrl  = URL(string: "tel://\(stringUno)")
        
        if let phoneUrlDes = phoneUrl{
        
            if UIApplication.shared.canOpenURL(phoneUrlDes){
                UIApplication.shared.open(phoneUrl!, options: [:], completionHandler: nil)
            }
        }else{
            self.present(muestraAlertVC("Atención", messageData: "No se puede hacer llamada en simulador"), animated: true, completion:     nil)
        }
        
    }
    
    @IBAction func showWeb(_ sender: UIButton) {
        let stringWeb = sender.titleLabel?.text
        let webVC = self.storyboard?.instantiateViewController(withIdentifier: "SAWebViewController") as! SAWebViewController
        webVC.urlweb = stringWeb
        present(webVC, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(detalleImagen)
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        myImageOferta.image = detalleImagen
        myNombreOferta.text = oferta?.nombre
        myFechaFin.text = oferta?.fechaFin
        myMasInformacion.text = oferta?.masInformacion
        myNombreAsociado.text = oferta?.asociado?.nombre
        myTelefonoMovilAsociado.text = oferta?.asociado?.telefonoMovil
        myEmail.text = oferta?.asociado?.mail
        myTelefonoButton.setTitle(oferta?.asociado?.telefonoFijo, for: .normal)
        myWebButton.setTitle(oferta?.asociado?.web, for: .normal)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(40.352494, -3.809620), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        myMap.setRegion(region, animated: true)
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(40.352494, -3.809620)
        pointAnnotation.title = oferta?.asociado?.direccion
        pointAnnotation.subtitle = oferta?.asociado?.nombre
        myMap.addAnnotation(pointAnnotation)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showOfertaSegue", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
