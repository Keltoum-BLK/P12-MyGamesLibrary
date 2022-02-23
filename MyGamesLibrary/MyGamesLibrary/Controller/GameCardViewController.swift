//
//  GameCardViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 17/02/2022.
//

import UIKit

class GameCardViewController: UIViewController {
    //MARK: Properties
    //images
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var screenshotCollectionView: UICollectionView!
    //btn to add in favorite
    @IBOutlet weak var playstationFavBTN: UIButton!
    @IBOutlet weak var xboxFavBTN: UIButton!
    @IBOutlet weak var nintendoFavBTN: UIButton!
    @IBOutlet weak var favBTN: UIButton!
    //game's informations
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var release_date: UILabel!
    //rating
    @IBOutlet weak var addFavoriteStack: UIStackView!
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart4: UIImageView!
    @IBOutlet weak var heart5: UIImageView!
    @IBOutlet weak var backBTN: UIButton!
    
    
    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setupConstraints()
        view.backgroundColor = .white
        navigationItem.backButtonTitle = "back"
        navigationItem.titleView?.tintColor = .black
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        gameImage.addGradientLayerInBackground(frame: gameImage.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    private func setUp(){
        //give data value to variables
        guard let finalGame = game else { return }
        setRating(for: finalGame.rating ?? 0)
        gameImage.cacheImage(urlString: finalGame.backgroundImage ?? "no image")
        gameTitle.text = finalGame.name ?? "no name"
        release_date.text = finalGame.released ?? "no date"
       
        backBTN.backgroundColor = .white
        backBTN.layer.cornerRadius = backBTN.frame.height / 2
        
        gameTitle.layer.cornerRadius = gameTitle.frame.height / 2
        gameTitle.layer.masksToBounds = true 
        gameTitle.setMargins()
        gameTitle.textAlignment = .center
        
        
    }
    private func setUpHeart(image : UIImageView) {
            image.image = UIImage(systemName: "heart.fill")
            image.sizeThatFits(CGSize(width: 8, height: 8))
            image.contentMode = .scaleAspectFit
            image.translatesAutoresizingMaskIntoConstraints = true
        }
        
        //MARK: SetUp and method for update the rating star for each destination.
        //condition to change the star's shape according to the rating
        func setRating(for star : Double) {
            setUpHeart(image: heart1)
            setUpHeart(image: heart2)
            setUpHeart(image: heart3)
            setUpHeart(image: heart4)
            setUpHeart(image: heart5)
            let rating = Int(star)
            switch rating {
            case 0:
                heart1.image = UIImage(systemName: "heart")
                heart2.image = UIImage(systemName: "heart")
                heart3.image = UIImage(systemName: "heart")
                heart4.image = UIImage(systemName: "heart")
                heart5.image = UIImage(systemName: "heart")
            case 1:
                heart2.image = UIImage(systemName: "heart")
                heart3.image = UIImage(systemName: "heart")
                heart4.image = UIImage(systemName: "heart")
                heart5.image = UIImage(systemName: "heart")
                
            case 2:
                heart3.image = UIImage(systemName: "heart")
                heart4.image = UIImage(systemName: "heart")
                heart5.image = UIImage(systemName: "heart")
            case 3:
                heart4.image = UIImage(systemName: "heart")
                heart5.image = UIImage(systemName: "heart")
            case 4:
                heart5.image = UIImage(systemName: "heart")
                
            default:
                break
            }
        }

    private func setupConstraints() {
        //image constraints
        gameImage.backgroundImage(view: self.view, multiplier: 0.45)
        gameImage.contentMode = .scaleAspectFill
        
    }
    @IBAction func BacktoTheList(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
