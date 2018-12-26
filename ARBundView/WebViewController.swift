//
//  WebViewController.swift
//  ARBundView
//
//  Created by David Peng on 2018/12/25.
//  Copyright © 2018 David Peng. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {

    @IBOutlet var webView: WKWebView!
    
    var build: Building?

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        
        if let JSPath = Bundle.main.path(forResource: "hideWikiHeader", ofType: "js") {
            do {
                let JSString = try String(contentsOfFile: JSPath)
                let JSScript = WKUserScript(source: JSString, injectionTime: .atDocumentStart, forMainFrameOnly: true)
                contentController.addUserScript(JSScript)
            } catch {
                fatalError("Error while processing JS file: \(error)")
            }
        } else {
            fatalError("Unable to read resource file: hideWikiHeader.js")
        }
        
        webConfiguration.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let myURL = build!.url
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
        
        // Do any additional setup after loading the view.
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private function

}
