//
//  ViewController.swift
//  browser
//
//  Created by Karthik on 13/4/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController , WKNavigationDelegate{

    var webView : WKWebView!
    var progressView : UIProgressView!
    var websites = ["maalaimalar.com", "dinakaran.com","dinamalar.com" ,"dailythanthi.com",
                    "tamil.oneindia.com"]


    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NEWS", style: .plain, target: self, action: #selector(openTapped))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let backA = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forwardA = UIBarButtonItem(title: "forward", style: .plain, target: webView, action: #selector(webView.goForward))

        toolbarItems = [backA,spacer,forwardA, spacer, progressButton, spacer , refresh]
        navigationController?.isToolbarHidden = false
        
        let url = URL(string: "https://" + websites[0])!
        webView.load(URLRequest(url: url))
        
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

    }
    
    @objc func openTapped(){
        let barMenu =  UIAlertController(title: "Web Sites", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            barMenu.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        barMenu.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        barMenu.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(barMenu,animated: true)
    }
    
    func openPage(action : UIAlertAction){
        let url = URL(string : "https://" + action.title!)!
        webView.load(URLRequest(url : url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
//        let alert = UIAlertController(title: "Message", message: "You have dont have permission to access", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:  nil))
//
//        self.present(alert, animated: true);
    }
}

