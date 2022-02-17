//
//  MyLibraryViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit
import AVFoundation

class MyLibraryViewController: UIViewController {


    @IBOutlet weak var myLibraryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabel()
    }

    
    private func setUpLabel() {
        myLibraryLabel.setMargins(margin: 10)
        myLibraryLabel.layer.masksToBounds = true
        myLibraryLabel.textAlignment = .center
        myLibraryLabel.layer.cornerRadius = myLibraryLabel.frame.height/2
    }
}


