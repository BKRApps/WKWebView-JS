//
//  ViewController.swift
//  WKWebView-JS-Examples
//
//  Created by Birapuram Kumar Reddy on 12/12/17.
//  Copyright © 2017 KRiOSApps. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var wkWebView:WKWebView!
    let versionHandler = "VersionHandler"
    let verifyHandler = "VerifyHandler"

    override func loadView() {
        super.loadView()
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: versionHandler)
        configuration.userContentController.add(self, name: verifyHandler)
        wkWebView = WKWebView(frame: view.frame, configuration: configuration)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        loadHtmlIntoWebview()
    }

    internal func loadHtmlIntoWebview() -> Void {
        let fileURL = Bundle.main.url(forResource: "sample", withExtension: "html")
        wkWebView.loadFileURL(fileURL!, allowingReadAccessTo: fileURL!)
    }

}

extension ViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case versionHandler:
            let mobileVersion = true // you can write custom logic here.
            let script = "receivedMobileVersion(\(mobileVersion))" // true or false dependeing upon your logic.
            self.wkWebView.evaluateJavaScript(script, completionHandler: { (data, error) in
                if let err = error{
                    print(err)
                }
            })
        case verifyHandler:
            print("Validation of version")
            print(message.body)
        default:
            print(message.body)
        }
    }
}



