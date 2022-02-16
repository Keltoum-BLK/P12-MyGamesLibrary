//
//  TabBarViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 12/02/2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    //MARK: Orientation property
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        // Do any additional setup after loading the view.
    }
    
    
    private func setUpTabBar() {
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            let tabBarItemAppearance = UITabBarItemAppearance()
            appearance.stackedLayoutAppearance = tabBarItemAppearance
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
