//
//  WebViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 10/03/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    //MARK: UI Property
    @IBOutlet weak var webPage: WKWebView!
    
    //MARK: Property
    var url: String?
    
    //MARK: Life Cycle
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
