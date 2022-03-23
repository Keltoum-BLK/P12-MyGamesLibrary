//
//  MyGameViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 15/03/2022.
//

import UIKit

class MyGameViewController: UIViewController {
    //MARK: UI Properties
    @IBOutlet weak var backBTN: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var marketBTN: UIButton!
    @IBOutlet weak var videoWebBTN: UIButton!
    @IBOutlet weak var addFavoriteBTN: UIButton!
    @IBOutlet weak var infoContainer: UIStackView!
    
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart4: UIImageView!
    @IBOutlet weak var heart5: UIImageView!
    
    //MARK: Properties
    var myGame: MyGame?
    private var ratingViews = [UIImageView]()
    private var images = [String]()
    private let coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let gameExist = coreDataManager.checkGameIsAlreadySaved(with: myGame?.name)
        let buttonImageName = gameExist ? "heart.fill" : "heart.slash"
        addFavoriteBTN.setImage(UIImage(systemName: buttonImageName), for: .normal)
    }
    
    override func viewDidLayoutSubviews() {
        backgroundImage.addGradientLayerInBackground(frame: backgroundImage.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyWebPage", let next = segue.destination as? WebViewController {
            next.modalPresentationStyle = .pageSheet
            next.url = sender as? String
        }
    }
    
    //MARK: Methods
   private func setupUI() {
       //give value to UI
       guard let myGameCard = myGame else { return }
       guard let dataImage = myGameCard.backgroundImage else { return }
       backgroundImage.cacheImage(urlString: String(decoding: dataImage, as: UTF8.self))
       gameImage.cacheImage(urlString: String(decoding: dataImage, as: UTF8.self))
       gameTitle.text = myGameCard.name
       releaseDate.text = myGameCard.release_date
       setRating(for: myGameCard.rating)
       
       //Setup UI
       gameImage.layer.borderColor = UIColor.white.cgColor
       gameImage.layer.borderWidth = 3
       gameImage.layer.cornerRadius = 20
       gameImage.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([gameImage.bottomAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: -20)])
       
       videoWebBTN.layer.borderWidth = 3
       videoWebBTN.layer.borderColor = UIColor.black.cgColor
       videoWebBTN.layer.cornerRadius = 20
       
      
       gameTitle.layer.masksToBounds = true
       gameTitle.layer.cornerRadius = 20
       gameTitle.setMargins()
       gameTitle.textAlignment = .center
       
       marketBTN.layer.cornerRadius = 20
       
       ratingStack.translatesAutoresizingMaskIntoConstraints = false
       
       backgroundImage.backgroundImage(view: self.view, multiplier: 0.60)
       
       addFavoriteBTN.layer.cornerRadius = 20
       
       infoContainer.translatesAutoresizingMaskIntoConstraints = false
       infoContainer.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor).isActive = true
       
       backBTN.layer.cornerRadius = 10
       backBTN.setUpShadow(color: UIColor.black.cgColor, cell: backBTN, width: 3, height: 3)
    }

    private func setUpHeart() {
        ratingViews = [heart1, heart2, heart3, heart4, heart5]
        ratingViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(systemName: "heart.fill")
            $0.sizeThatFits(CGSize(width: 8, height: 8))
            $0.contentMode = .scaleAspectFit
        }
    }
    
    //MARK: Set Up and method for update the rating star for each destination.
    //condition to change the star's shape according to the rating
    func setRating(for star : Double) {
        setUpHeart()
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
    
    private func removeGameInLibraryWithPlatform() {
        let gameExist = coreDataManager.checkGameIsAlreadySaved(with: myGame?.name)
        if gameExist {
            guard let gameToRemove = myGame?.name else { return }
            coreDataManager.removeGame(name: gameToRemove)
            addFavoriteBTN.setImage(UIImage(systemName: "heart.slash"), for: .normal)
            DispatchQueue.main.async {
                self.showAlertMessageBeforeToDismiss(title: "Suppression confirmée ❌", message: "Tu as bien supprimé le jeu de ton catalogue")
            }
        }
    }
    
    //MARK: UI Action Methods
    @IBAction func dismissBTN(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func marketAction(_ sender: Any) {
        let gameUrl = "https://ledenicheur.fr/search?search=\(myGame?.name?.replacingOccurrences(of: " ", with: "%20") ?? "no url")"
        performSegue(withIdentifier: "MyWebPage", sender: gameUrl)
    }
    
    @IBAction func videoWebAction(_ sender: Any) {
        let gameUrl = "https://www.youtube.com/results?search_query=\(myGame?.name?.replacingOccurrences(of: " ", with: "+") ?? "no url")"
        performSegue(withIdentifier: "MyWebPage", sender: gameUrl)
    }
}

