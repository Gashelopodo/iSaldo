//
//  SAWebViewController.swift
//  iSaldos
//
//  Created by cice on 26/5/17.
//  Copyright © 2017 icologic. All rights reserved.
//

import UIKit

class SAWebViewController: UIViewController {
    
    var urlweb : String?
    
    //outlet
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var myIndicator: UIActivityIndicatorView!
    
    
    //action
    @IBAction func closeWebView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myIndicator.isHidden = true
        myWebView.delegate = self
        
        let customUrl = URL(string: "http://\(urlweb!)")!
        let customUrlRequest = URLRequest(url: customUrl)
        myWebView.loadRequest(customUrlRequest)

        // Do any additional setup after loading the view.
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

extension SAWebViewController : UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        myIndicator.isHidden = false
        myIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        myIndicator.isHidden = true
        myIndicator.stopAnimating()
    }
    
}
