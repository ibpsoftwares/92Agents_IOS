//
//  SharedProposalViewController.swift
//  92Agents
//
//  Created by Apple on 27/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import WebKit

class SharedProposalViewController: UIViewController , WKUIDelegate, WKNavigationDelegate{

     @IBOutlet weak var webView: WKWebView!
    var urlString = String()
    @IBOutlet weak var Activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        
        // Do any additional setup after loading the view.
        print(urlString)
        self.webView.addSubview(self.Activity)
        self.Activity.startAnimating()
        self.webView.navigationDelegate = self
        self.Activity.hidesWhenStopped = true
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Activity.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Activity.stopAnimating()
    }
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
}
