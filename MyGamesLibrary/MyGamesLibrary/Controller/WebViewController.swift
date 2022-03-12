//
//  WebViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 10/03/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var youtubeVideosWebPage: WKWebView!
    
    var url: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeVideosWebPage.navigationDelegate = self
        self.setupNavigationBar()
        guard let url = URL(string: url ?? "no url") else { return }
        youtubeVideosWebPage.load(URLRequest(url: url))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        youtubeVideosWebPage.stopLoading()
    }
    private func setupNavigationBar() {
        if #available(iOS 15.0, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        }
    }

}
