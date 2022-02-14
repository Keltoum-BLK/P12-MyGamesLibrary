//
//  ViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 09/02/2022.
//

import UIKit
import LocalAuthentication
import SwiftyGif

class LaunchViewController: UIViewController {
    
    let logoAnimationView = LogoAnimationView()

 
    @IBOutlet weak var startBTN: UIButton!
    @IBOutlet weak var titileStack: UIStackView!
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
        setUp()
    }
    
    func setUp() {
        startBTN.layer.cornerRadius = startBTN.frame.height/2
        startBTN.layer.backgroundColor = UIColor.black.cgColor
        startBTN.tintColor = .white
    }
    @IBAction func TouchIDAuthentification(_ sender: Any) {
        AuthHelper.startAuth { (success, errString) in
                if success {
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                } else {
                    if errString != nil {
                        AlertHelper().errorAlert(errString!, self)
                    }
                }
        }
    }
}

extension LaunchViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}
