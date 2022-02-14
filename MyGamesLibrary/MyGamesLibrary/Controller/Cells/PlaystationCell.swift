//
//  PlaystationCell.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 13/02/2022.
//

import UIKit

class PlaystationCell: UICollectionViewCell {

    @IBOutlet weak var psImage: UIImageView!
    @IBOutlet weak var psOptionCell: UIButton!
    @IBOutlet weak var psGameTitle: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
}
