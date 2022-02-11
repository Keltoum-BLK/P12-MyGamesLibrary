//
//  GameTableViewCell.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var favoriteBTN: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpContetView()
        setUpUI()
    }

    func setUpContetView() {
        contentView.layer.cornerRadius = 20
        layer.cornerRadius = 20
        contentView.clipsToBounds = true
        layer.shadowOpacity = 0.5
        layer.shadowColor = UIColor.black.cgColor
       layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowRadius = 10
    }
    
    func setUpUI() {
        favoriteBTN.layer.cornerRadius = 10
        favoriteBTN.layer.borderWidth = 2
        favoriteBTN.layer.borderColor = UIColor.black.cgColor
        favoriteBTN.layer.shadowOpacity = 0.3
        favoriteBTN.layer.shadowColor = UIColor.black.cgColor
        favoriteBTN.layer.shadowOffset = CGSize(width: 0, height: 10)
        favoriteBTN.layer.shadowRadius = 10
    }
}
