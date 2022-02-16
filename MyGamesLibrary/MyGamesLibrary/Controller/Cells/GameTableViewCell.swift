//
//  GameTableViewCell.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameContainerInfo: UIStackView!
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var favoriteBTN: UIButton!
    @IBOutlet weak var gameRating: UIStackView!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    

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
    
    
    //MARK: SetUp and method for update the rating star for each destination.
    //condition to change the star's shape according to the rating
    func setRating(for star : Int) {
        switch star {
        case 0:
            star1.image = UIImage(systemName: "star")
            star2.image = UIImage(systemName: "star")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 1:
            star2.image = UIImage(systemName: "star")
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
            
        case 2:
            star3.image = UIImage(systemName: "star")
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 3:
            star4.image = UIImage(systemName: "star")
            star5.image = UIImage(systemName: "star")
        case 4:
            star5.image = UIImage(systemName: "star")
            
        default:
            break
        }
    }
    
}
