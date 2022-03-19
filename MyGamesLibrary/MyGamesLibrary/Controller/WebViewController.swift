//
//  WebViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 10/03/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webPage: WKWebView!
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webPage.navigationDelegate = self
        guard let url = URL(string: url ?? "no url") else { return }
        webPage.load(URLRequest(url: url))
        webPage.allowsBackForwardNavigationGestures = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webPage.stopLoading()
    }
}
