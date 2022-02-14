//
//  MyLibraryViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit

class MyLibraryViewController: UIViewController {

    @IBOutlet weak var playstationCollection: UICollectionView!
    @IBOutlet weak var xboxCollection: UICollectionView!
    @IBOutlet weak var nintendoCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playstationCollection.dataSource = self
        playstationCollection.delegate = self
      
    }
    
    private func setUpCollections() {
        playstationCollection.register(UINib(nibName: "PlaystationCell", bundle: nil), forCellWithReuseIdentifier: "PlaystationCell")
        xboxCollection.register(UINib(nibName: "XboxCell", bundle: nil), forCellWithReuseIdentifier: "XboxCell")
        nintendoCollection.register(UINib(nibName: "NintendoCell", bundle: nil), forCellWithReuseIdentifier: "NintendoCell")
    }
}

extension MyLibraryViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
    
    
}
