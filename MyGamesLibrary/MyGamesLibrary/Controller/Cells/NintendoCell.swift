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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}
