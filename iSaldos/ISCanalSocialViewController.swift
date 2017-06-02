//
//  ISCanalSocialViewController.swift
//  iSaldos
//
//  Created by cice on 2/6/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Parse

class ISCanalSocialViewController: UIViewController {

    //MARK: - variables locales
    var userPost = [UserPostModel]()
    var refreshList : UIRefreshControl?
    var nombreUser = ""
    var apellidoUser = ""
    var imagenUser : UIImage?
    
    
    //MAR: - oultet
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        refreshList = UIRefreshControl()
        refreshList?.addTarget(self, action: #selector(llamadaPosters), for: .valueChanged)
        myTableView.addSubview(refreshList!)
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.register(UINib(nibName: "SRMiPerfilCustomCell", bundle: nil), forCellReuseIdentifier: "SRMiPerfilCustomCell")
        myTableView.register(UINib(nibName: "ISPostCustomCell", bundle: nil), forCellReuseIdentifier: "ISPostCustomCell")
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        informacionUsuario()
        llamadaPosters()
        myTableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        llamadaPosters()
        myTableView.reloadData()
    }
    
    
    func llamadaPosters(){
        
    }
    
    func informacionUsuario(){
        //1.consulta
        let queryUser = PFUser.query()
        queryUser?.whereKey("username", equalTo: (PFUser.current()?.username)!)
        queryUser?.findObjectsInBackground(block: { (objectUno, errorUno) in
            if errorUno == nil{
                if let objectUnoDes = objectUno?[0]{
                    self.nombreUser = (objectUnoDes["name"] as? String)!
                    self.apellidoUser = (objectUnoDes["lastname"] as? String)!
                    //2.consulta
                    let imagenPerfil = PFQuery(className: "ImageProfile")
                    imagenPerfil.whereKey("username", equalTo: (PFUser.current()?.username)!)
                    imagenPerfil.findObjectsInBackground(block: { (objectDos, errorDos) in
                        if errorDos == nil{
                            if let objectDosDes = objectDos?[0]{
                                let imageUserData = objectDosDes["imageProfile"] as! PFFile
                                imageUserData.getDataInBackground(block: { (imageData, errorData) in
                                    if let imageDataDes = imageData{
                                        self.imagenUser = UIImage(data: imageDataDes)
                                        self.myTableView.reloadData()
                                    }
                                })
                            }
                        }
                        
                    })
                }
               
            }
        })
    }
    

}

extension ISCanalSocialViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return userPost.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let perfilCell = tableView.dequeueReusableCell(withIdentifier: "SRMiPerfilCustomCell", for: indexPath) as! SRMiPerfilCustomCell
            perfilCell.myNombrePerfilUsuario.text = self.nombreUser+" "+self.apellidoUser
            perfilCell.myUsernameSportReviewLBL.text = "@ " + (PFUser.current()?.username)!
            perfilCell.myFotoFondoPerfil.image = self.imagenUser
            return perfilCell
        }else{
            let posterCell = tableView.dequeueReusableCell(withIdentifier: "ISPostCustomCell", for: indexPath) as! ISPostCustomCell
            return posterCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 305
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    
    

}
