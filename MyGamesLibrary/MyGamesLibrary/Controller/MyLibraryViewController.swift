//
//  MyLibraryViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit
import AVFoundation

class MyLibraryViewController: UIViewController {


    @IBOutlet weak var playstationBTN: UIButton!
    @IBOutlet weak var xboxBTN: UIButton!
    @IBOutlet weak var nintendoBTN: UIButton!
    @IBOutlet weak var myLibraryLabel: UILabel!
    
    var playstationImage = UIImage(named: "ps4Image")
    var xboxImage = UIImage(named: "XboxImage")
    var nintendoImage = UIImage(named: "switchImage")
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabel()
        setupBTN()
        self.setupNavigationBack()
    }

    
    private func setUpLabel() {
        myLibraryLabel.setMargins(margin: 10)
        myLibraryLabel.layer.masksToBounds = true
        myLibraryLabel.textAlignment = .center
        myLibraryLabel.layer.cornerRadius = myLibraryLabel.frame.height/2
    }
    
    private func setupBTN() {
        playstationBTN.layer.cornerRadius = 20
        xboxBTN.layer.cornerRadius = 20
        nintendoBTN.layer.cornerRadius = 20
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GamesLibraries", let next = segue.destination as? GamesFavoriteViewController {
            next.image = sender as? UIImage
        }
    }
    
    @IBAction func playstationBtnAction(_ sender: Any) {
        performSegue(withIdentifier: "GamesLibraries", sender: playstationImage)
    }
    
    @IBAction func xboxBTNAction(_ sender: Any) {
        performSegue(withIdentifier: "GamesLibraries", sender: xboxImage)
    }
    
    @IBAction func nintendoBTNAction(_ sender: Any) {
        performSegue(withIdentifier: "GamesLibraries", sender: nintendoImage)
    }
}


