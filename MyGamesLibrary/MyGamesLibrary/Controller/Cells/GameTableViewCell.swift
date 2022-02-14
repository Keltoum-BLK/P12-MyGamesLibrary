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
        setUpContentView()
        
    }
    
    // Inside UITableViewCell subclass
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.clear
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        setUpImage()
        gameImage.addGradientLayerInBackground(frame: gameImage.frame, colors: [UIColor(ciColor: .clear),UIColor(ciColor: .white)])
        favoriteBTN.layer.cornerRadius = favoriteBTN.frame.height / 2
        favoriteBTN.backgroundColor = .red
        Tool.shared.setUpShadowView(color: UIColor.black.cgColor, view: favoriteBTN)
    }
    
    private func setUpContentView() {
        contentView.layer.cornerRadius = 20
        layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    private func setUpImage() {
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            gameImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            gameImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            gameImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }
    
}
