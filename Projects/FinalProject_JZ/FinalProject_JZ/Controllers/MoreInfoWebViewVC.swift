//
//  ThirdViewController.swift
//  FinalProject_JZ
//
//  Created by Juan Zaragoza on 5/13/18.
//  Copyright © 2018 Juan Zaragoza. All rights reserved.
//

import UIKit
import WebKit

class MoreInfoWebViewVC: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var moreInfowebview: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        moreInfowebview.navigationDelegate = self
        moreInfowebview.uiDelegate = self
        setUpIndicator()
        makeURLRequest()
    }
    
    private func makeURLRequest(){
        let url = URL(string: "https://www.acurite.com/learn/weather-stations/what-is-a-weather-station")
        let request = URLRequest(url: url!)
        moreInfowebview.load(request)
    }
    
    private func setUpIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
    }
    
    private func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
}
