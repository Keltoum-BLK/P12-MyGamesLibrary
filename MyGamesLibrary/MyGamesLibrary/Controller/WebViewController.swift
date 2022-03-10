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
    
    var query: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        youtubeVideosWebPage.navigationDelegate = self
        guard let searchQuery = query?.replacingOccurrences(of: " ", with: "+") else { return }
        guard let url = URL(string: "https://www.youtube.com/results?search_query=\(searchQuery)") else { return }
        youtubeVideosWebPage.load(URLRequest(url: url))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        youtubeVideosWebPage.stopLoading()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
