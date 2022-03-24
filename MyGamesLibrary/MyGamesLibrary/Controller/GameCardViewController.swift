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
    @IBOutlet weak var favBTN: UIButton!
    @IBOutlet weak var marketBTN: UIButton!
    @IBOutlet weak var youtubeBTN: UIButton!
    @IBOutlet weak var dismissBTN: UIButton!
    @IBOutlet weak var platformInformationBTN: UIButton!
    //game's informations
    @IBOutlet weak var infoContainer: UIStackView!
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var release_date: UILabel!
    //rating
    @IBOutlet weak var ratingHeartsStack: UIStackView!
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart4: UIImageView!
    @IBOutlet weak var heart5: UIImageView!
    
    //MARK: Properties
    var gamesAdded = [MyGame]()
    var game: Game?
    var gamePlatforms : String = ""
    var screenshots = [String]()
    var layout : UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 270, height: 170)
        layout.scrollDirection = .horizontal
        layout.sectionInset = .zero
        return layout
    }()
    var ratingViews = [UIImageView]()
    
    //MARK: CoreDataManager
    let coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setupConstraints()
        view.backgroundColor = .white
        
        screenshotCollectionView.dataSource = self
        screenshotCollectionView.delegate = self
        layout.scrollDirection = .horizontal
        screenshotCollectionView.collectionViewLayout = layout
    }
    
    override func viewDidLayoutSubviews() {
        gameImage.addGradientLayerInBackground(frame: gameImage.bounds, colors: [UIColor(ciColor: .clear), UIColor(ciColor: .white)])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gameExist = coreDataManager.checkGameIsAlreadySaved(with: game?.name)
        let buttonImageName = gameExist ? "heart.fill" : "heart.slash"
        favBTN.setImage(UIImage(systemName: buttonImageName), for: .normal)
    }
    
    //MARK: Segue Method to pass Data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WebPage" {
            let controller = segue.destination as? WebViewController
            controller?.url = sender as? String
        } else if segue.identifier == "PopView" {
            let controller = segue.destination as? PlatformsViewController
            controller?.modalPresentationStyle = .pageSheet
            let sheet = controller?.sheetPresentationController
            sheet?.detents = [.medium()]
            controller?.game = sender as? Game
        }
    }
    
    //MARK: Methods
    private func setUp(){
        //        give data value to variables
        guard let finalGame = game else { return }
        gameImage.cacheImage(urlString: finalGame.backgroundImage ?? "no image")
        gameTitle.text = finalGame.name ?? "no name"
        release_date.text = finalGame.released ?? "no date"
        setRating(for: finalGame.rating ?? 0)
        screenshots =  Tool.shared.listOfScreenshots(game: finalGame, images: self.screenshots)
        screenshotCollectionView.showsHorizontalScrollIndicator = true
        
        gameTitle.layer.cornerRadius = gameTitle.frame.height / 2
        gameTitle.layer.masksToBounds = true
        gameTitle.setMargins()
        gameTitle.textAlignment = .center
        
        //
        favBTN.layer.cornerRadius = favBTN.frame.height / 2
        
        youtubeBTN.layer.cornerRadius = youtubeBTN.frame.height / 2
        youtubeBTN.layer.borderColor = UIColor.black.cgColor
        youtubeBTN.layer.borderWidth = 1
        marketBTN.layer.cornerRadius = marketBTN.frame.height / 2
        dismissBTN.layer.cornerRadius = 10
        dismissBTN.setUpShadow(color: UIColor.black.cgColor, cell: dismissBTN, width: 3, height: 3)
        
        screenshotCollectionView.translatesAutoresizingMaskIntoConstraints = false
        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        infoContainer.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: -20).isActive = true
        
        platformInformationBTN.layer.cornerRadius = platformInformationBTN.frame.height / 2
        platformInformationBTN.setUpShadow(color: UIColor.black.cgColor, cell: platformInformationBTN, width: 3, height: 3)
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
    
    //MARK: SetUp and method for update the rating star for each destination.
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
    
    private func setupConstraints() {
        //image constraints
        gameImage.backgroundImage(view: self.view, multiplier: 0.40)
        gameImage.contentMode = .scaleAspectFill
    }
    
    //MARK: UI Action Methods 
    @IBAction func addGameInLibrary(_ sender: Any) {
        addGameInLibraryWithPlatform()
    }
    
    @IBAction func goToYoutubePage(_ sender: Any) {
        let gameUrl = "https://www.youtube.com/results?search_query=\(game?.name?.replacingOccurrences(of: " ", with: "+") ?? "no url")"
        performSegue(withIdentifier: "WebPage", sender: gameUrl)
    }
    
    
    @IBAction func goToTheMarketPage(_ sender: Any) {
        let gameUrl = "https://ledenicheur.fr/search?search=\(game?.name?.replacingOccurrences(of: " ", with: "%20") ?? "no url")"
        performSegue(withIdentifier: "WebPage", sender: gameUrl)
    }
    
    @IBAction func dismissBTN(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func popInformationAction(_ sender: Any) {
        performSegue(withIdentifier: "PopView", sender: game)
    }
    
    private func addGameInLibraryWithPlatform() {
        let gameExist = coreDataManager.checkGameIsAlreadySaved(with: game?.name)
        if !gameExist {
            guard let game = game else { return }
            coreDataManager.addGame(game: game)
            favBTN.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: Notification.Name(rawValue: "needReload"), object: nil)
                self.showAlertMessage(title: "Mission Accomplie 🤓", message: "Ton jeu est bien ajouté à ton catalogue")
            }
        } else {
            guard let gameToRemove = game?.name else { return }
            coreDataManager.removeGame(name: gameToRemove)
            favBTN.setImage(UIImage(systemName: "heart.slash"), for: .normal)
            DispatchQueue.main.async {
                self.showAlertMessage(title: "Suppression confirmée ❌", message: "Tu as bien supprimé le jeu de ton catalogue")
            }
        }
    }
}

extension GameCardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let finalGame = game else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotsViewCell", for: indexPath) as! ScreenshotsViewCell
        cell.setup(screenshot: finalGame.short_screenshots?[indexPath.row] ?? ShortScreenshot(image: "no image"))
        return cell
    }
}
