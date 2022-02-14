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
    @IBOutlet weak var myLibraryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playstationCollection.dataSource = self
        playstationCollection.delegate = self
        
        xboxCollection.dataSource = self
        xboxCollection.delegate = self
        
        nintendoCollection.dataSource = self
        nintendoCollection.delegate = self
        
        setUpLayout()
        setUpLabel()
    }
    private func setUpLayout() {
        playstationCollection.collectionViewLayout = CustomLayout().setUp(height: 190, width: 130)
        xboxCollection.collectionViewLayout = CustomLayout().setUp(height: 190, width: 130)
        nintendoCollection.collectionViewLayout = CustomLayout().setUp(height: 190, width: 130)
    }
    
    private func setUpLabel() {
        myLibraryLabel.setMargins(margin: 10)
        myLibraryLabel.layer.masksToBounds = true
        myLibraryLabel.textAlignment = .center
        myLibraryLabel.layer.cornerRadius = myLibraryLabel.frame.height/2
    }
}

extension MyLibraryViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.playstationCollection {
        let cell = playstationCollection.dequeueReusableCell(withReuseIdentifier: "PlaystationCell", for: indexPath) as! PlaystationCell
        Tool.shared.setUpShadowCollectionCell(color: UIColor.systemBlue.cgColor, cell: cell)
        return cell
        } else if collectionView == self.xboxCollection {
            let cell = xboxCollection.dequeueReusableCell(withReuseIdentifier: "XboxCell", for: indexPath) as! XboxCell
            Tool.shared.setUpShadowCollectionCell(color: UIColor.systemGreen.cgColor, cell: cell)
            return cell
        } else {
            let cell = nintendoCollection.dequeueReusableCell(withReuseIdentifier: "NintendoCell", for: indexPath) as! NintendoCell
            Tool.shared.setUpShadowCollectionCell(color: UIColor.systemRed.cgColor, cell: cell)
            return cell
        }
     
    }
    
    
}
