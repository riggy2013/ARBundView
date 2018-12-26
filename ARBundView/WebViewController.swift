//
//  WebViewController.swift
//  ARBundView
//
//  Created by David Peng on 2018/12/25.
//  Copyright © 2018 David Peng. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate{

    @IBOutlet var webView: WKWebView!
    
    var build: Building?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        let myURL = build!.url
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        
        // Do any additional setup after loading th
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    */
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let JSPath = Bundle.main.path(forResource: "hideWikiHeader", ofType: "js") {
            do {
                let JSString = try String(contentsOfFile: JSPath)
                webView.evaluateJavaScript(JSString, completionHandler: nil)
            } catch {
                fatalError("Error while processing JS file: \(error)")
            }
        } else {
            fatalError("Unable to read resource file: hideWikiHeader.js")
        }
    }
    // MARK: Private function

}
