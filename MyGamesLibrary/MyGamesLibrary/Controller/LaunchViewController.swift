//
//  ViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 09/02/2022.
//

import UIKit
import SwiftyGif

class LaunchViewController: UIViewController {
    
    let logoAnimationView = LogoAnimationView()

    @IBOutlet weak var bienvenueLabel: UILabel!
    @IBOutlet weak var startBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoAnimationView)
        logoAnimationView.pinEdgesToSuperView()
        logoAnimationView.logoGifImageView.delegate = self
        setup()
    }
    
    func setup() {
        bienvenueLabel.text = "Bienvenue dans My Game Store! \n\n Ici c'est votre librairie de jeux vidéo, vous pouvez rechercher et enregistrer vos jeux, à emporter partout et ne jamais vous demander en prenant un nouveau jeu, si vous l'avez déjà?"
        bienvenueLabel.layer.masksToBounds = true
        bienvenueLabel.layer.cornerRadius = 20
        bienvenueLabel.layer.borderWidth = 5
        bienvenueLabel.layer.borderColor = UIColor.black.cgColor
        bienvenueLabel.setMargins()
        bienvenueLabel.textAlignment = .center
        startBTN.layer.cornerRadius = 40
        startBTN.layer.borderWidth = 5
        startBTN.layer.borderColor = UIColor.black.cgColor
    }
}

extension LaunchViewController: SwiftyGifDelegate {
    func gifDidStop(sender: UIImageView) {
        logoAnimationView.isHidden = true
    }
}
