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
        view=wkWebView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        loadHtmlIntoWebview()

        //create a simple cookie and set the cookie to cookie store.
        let cookiestore = wkWebView.configuration.websiteDataStore.httpCookieStore
        let cookiePropDict:[HTTPCookiePropertyKey:Any] = [.name:"WhatIsYourName",.value:"Kumar Reddy",.secure:true,.domain:".apple.com",.originURL:".apple.com",HTTPCookiePropertyKey.path:"/",.version:"0"];
        let cookie = HTTPCookie(properties: cookiePropDict)
        //setCookie is an Async call. load the url in the completion handler.
        cookiestore.setCookie(cookie!) { [unowned self] in
            self.loadHtmlIntoWebview()
            // you can retrieve cookie here.
            cookiestore.getAllCookies({ (cookies) in
                print("\n Cookie Example",_:"\n")
                for cookie in cookies {
                    print("\(cookie.name) -> \(cookie.value)")
                }
            })
        }
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
            print("\n JS bridge Example",_:"\n")
            print("Validation of version")
            print(message.body)
        default:
            print(message.body)
        }
    }
}



