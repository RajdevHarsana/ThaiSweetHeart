//
//  WebviewPagesVC.swift
//  ThaiSweetHeart
//
//  Created by MAC-25 on 06/01/21.
//  Copyright © 2021 mac-15. All rights reserved.
//

import UIKit

class WebviewPagesVC: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var indicationView: UIActivityIndicatorView!
    @IBOutlet weak var webviewvc: UIWebView!
    var webtype:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        webviewvc.delegate = self
        indicationView.style =  .whiteLarge
        indicationView.color = UIColor.black
        indicationView.center = self.view.center
        termsandconditionmethod()
        // Do any additional setup after loading the view.
    }
    
    func termsandconditionmethod() {
        var urlString = ""
        if webtype == "about" {
            urlString = "https://thaisweetheart.com/page/about-us"
        }else if webtype == "how" {
            urlString = "https://thaisweetheart.com/page/how-it-works"
        }else if webtype == "faq" {
            urlString = "https://thaisweetheart.com/page/faq"
        }else if webtype == "safety" {
            urlString = "https://thaisweetheart.com/page/safety-tips"
        }else if webtype == "terms" {
            urlString = "https://thaisweetheart.com/page/terms-of-service"
        }else if webtype == "privacy" {
            urlString = "https://thaisweetheart.com/page/privacy-policy"
       }
        
        indicationView.startAnimating()
        indicationView.isHidden = false
        webviewvc.scrollView.isScrollEnabled = true
        webviewvc.scrollView.contentOffset = CGPoint(x: 0, y: 800)
        webviewvc.scalesPageToFit = true
        webviewvc.scrollView.bounces = false
        if let aString = URL(string: urlString) {
            webviewvc.loadRequest(URLRequest(url: aString))
        }
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        indicationView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        indicationView.stopAnimating()
        indicationView.isHidden = true
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
