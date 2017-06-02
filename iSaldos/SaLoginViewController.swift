//
//  SaLoginViewController.swift
//  iSaldos
//
//  Created by cice on 12/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class SaLoginViewController: UIViewController {
    
    //Variables locales
    
    var player : AVPlayer!
    
    
    //Outlet
    
    @IBOutlet weak var myUserName: UITextField!
    @IBOutlet weak var myPassword: UITextField!
    @IBOutlet weak var myAccederBTN: UIButton!
    @IBOutlet weak var myRegistrarseBTN: UIButton!
    
    //Action
    
    @IBAction func accederApp(_ sender: Any) {
        
        let sign = APISignin(pUsername: myUserName.text!, pPassword: myPassword.text!)
        
        do {
            try sign.signUser()
            self.performSegue(withIdentifier: "jumpFromLogin", sender: self)
        } catch {
            present(muestraAlertVC("Lo sentimos", messageData: "\(error.localizedDescription)"), animated: true, completion: nil)
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showVideoInVC()
        
        myAccederBTN.layer.cornerRadius = 5
        myRegistrarseBTN.layer.cornerRadius = 5
        //padding textfield
        myUserName.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        myPassword.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        // Do any additional setup after loading the view.
    }
    
    
    func showVideoInVC(){
        //video
        let path = Bundle.main.path(forResource: "Nike_iOS", ofType: "mp4")
        player = AVPlayer(url: URL(fileURLWithPath: path!))
        player.actionAtItemEnd = .none
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.insertSublayer(playerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItem), name: Notification.Name.AVPlayerItemDidPlayToEndTime , object: player.currentItem)
        
        player.seek(to: kCMTimeZero)
        player.play()
        
    }
    
    
    func playerItem(){
        player.seek(to: kCMTimeZero)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
