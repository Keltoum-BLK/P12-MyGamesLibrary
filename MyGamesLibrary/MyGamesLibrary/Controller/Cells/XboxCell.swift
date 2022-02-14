//
//  XboxCell.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 13/02/2022.
//

import UIKit

class XboxCell: UICollectionViewCell {

    @IBOutlet weak var xboxImage: UIImageView!
    @IBOutlet weak var xboxOption: UIButton!
    @IBOutlet weak var xboxGameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}
