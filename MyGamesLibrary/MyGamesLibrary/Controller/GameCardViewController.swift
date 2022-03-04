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
    //game's informations
    @IBOutlet weak var gameTitle: UILabel!
    @IBOutlet weak var release_date: UILabel!
    //rating
    @IBOutlet weak var ratingHeartsStack: UIStackView!
    @IBOutlet weak var heart1: UIImageView!
    @IBOutlet weak var heart2: UIImageView!
    @IBOutlet weak var heart3: UIImageView!
    @IBOutlet weak var heart4: UIImageView!
    @IBOutlet weak var heart5: UIImageView!
    
    var gamesAdded = [MyGame]()
    var game: Game?
    var screenshots = [String]()
    var layout = UICollectionViewFlowLayout()
    var ratingViews = [UIImageView]()
    //MARK: CoreDataManager
    let coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    
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
        Tool.shared.setUpShadowView(color: UIColor.black.cgColor, view: favBTN)
        
        screenshotCollectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    private func setUpHeart() {
        ratingViews = [heart1, heart2, heart3, heart4, heart5]
        ratingViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.image = UIImage(systemName: "heart.fill")
            $0.sizeThatFits(CGSize(width: 8, height: 8))
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = true
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
        gameImage.backgroundImage(view: self.view, multiplier: 0.45)
        gameImage.contentMode = .scaleAspectFill
    }
    
    func checkData() {
        gamesAdded = coreDataManager.fetchGames(mygames: self.gamesAdded)
    }
    @IBAction func addGameInLibrary(_ sender: Any) {
        addGameInLibraryWithPlatform()
        favBTN.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        self.showAlertMessage(title: "Mission Accomplie 🤓", message: "Ton jeu est bien ajouté à ton catalogue")
    }
    
    private func addGameInLibraryWithPlatform() {
        if !coreDataManager.checkGameIsAlreadySaved(with: game?.name ?? "no name") {
        guard let tabIndex = tabBarController?.selectedIndex else { return }
        let platform = PlatformType.allCases[tabIndex].rawValue
        game?.platforms = [Platform(name: platform)]
        guard let game = game else { return }
        coreDataManager.addGame(game: game)
            navigationController?.popViewController(animated: true)
        } else {
            self.showAlertMessage(title: "Mission échouée ☠️", message: "Tu as déjà ajouté ce jeu à ton catalogue")
        }
    }
    
    enum PlatformType: String, CaseIterable {
        case playsstation = "Playstation 4"
        case xbox = "Xbox One"
        case nintendo = "Nintendo"
    }
}

extension GameCardViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let finalGame = game else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotsViewCell", for: indexPath) as! ScreenshotsViewCell
        cell.setup(screenshot: finalGame.short_screenshots?[indexPath.row] ?? ShortScreenshot(image: "no image"))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 270, height: 170)
    }
}
