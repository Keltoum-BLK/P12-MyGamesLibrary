//
//  NintendoCell.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 13/02/2022.
//

import UIKit

class NintendoCell: UICollectionViewCell {

    @IBOutlet weak var nintendoImage: UIImageView!
    @IBOutlet weak var nintendoGameLabel: UILabel!
    @IBOutlet weak var nintendoOptionCell: UIButton!
    
    
  
    // Inside UICollectionCell subclass
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func setUpContentView() {
        contentView.layer.cornerRadius = 20
        layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
}
