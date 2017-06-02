//
//  SASplashViewController.swift
//  iSaldos
//
//  Created by cice on 12/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit
import Parse

class SASplashViewController: UIViewController {
    
    //MARK: - Variables locales
    var viewAnimator : UIViewPropertyAnimator!
    var timerDesbloqueo = Timer()
    
    
    //MARK: - Outlets
    
    @IBOutlet var myImageSplash: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewAnimator = UIViewPropertyAnimator(duration: 1.0, curve: .easeInOut, animations: { 
            self.myImageSplash.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.timerDesbloqueo = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(self.manejadorAutomatico), userInfo: nil, repeats: false)
        })
        viewAnimator.startAnimation()
        
        
        
        
        
        
        
        
        

        // Do any additional setup after loading the view.
    }

   
    //MARK: - Utils
    
    func manejadorAutomatico(){
        let logoAnimacion = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { 
            self.myImageSplash.transform = CGAffineTransform(scaleX: 25, y: 25)
        }
        logoAnimacion.startAnimation()
        logoAnimacion.addCompletion { _ in
            self.beginApp()
        }
    }
    
    func beginApp(){
        if customPrefs.string(forKey: CONSTANTES.CUSTOM_USER_DEFAULTS.VISTA_GALERIA_INICIAL) != nil{
            if PFUser.current() == nil{
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "SaLoginViewController") as! SaLoginViewController
                loginVC.modalTransitionStyle = .crossDissolve
                present(loginVC, animated: true, completion: nil)
            }else{
                let revealVC = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                revealVC.modalTransitionStyle = .crossDissolve
                present(revealVC, animated: true, completion: nil)
            }
            
        }else{
            customPrefs.setValue("OK", forKey: CONSTANTES.CUSTOM_USER_DEFAULTS.VISTA_GALERIA_INICIAL)
            let galeriaVC = self.storyboard?.instantiateViewController(withIdentifier: "SAGaleriaImagenesViewController") as! SAGaleriaImagenesViewController
            galeriaVC.modalTransitionStyle = .crossDissolve
            present(galeriaVC, animated: true, completion: nil)
        }
    }
    
    
}
