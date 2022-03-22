//
//  MyLibraryViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit
import AVFoundation

class MyLibraryViewController: UIViewController {
    
    //MARK: UI Properties
    @IBOutlet weak var playstationBTN: UIButton!
    @IBOutlet weak var xboxBTN: UIButton!
    @IBOutlet weak var nintendoBTN: UIButton!
    @IBOutlet weak var myLibraryLabel: UILabel!
    
    //MARK: Properties
    private var coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    let playstationImage = "ps4Image"
    let xboxImage = "XboxImage"
    let nintendoImage = "switchImage"
    var playstationGames = [MyGame]()
    var xboxGames = [MyGame]()
    var nintendoGames = [MyGame]()
    var elements: MyLibraryElements?
    var platformArray = ["playstation4","xbox-one","nintendo-switch"]
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabel()
        setupBTN()
    }
    
    //MARK: Segue Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameTabVC = segue.destination as! GamesFavoriteViewController
        gameTabVC.platformElements = elements
    }
    
    //MARK: Methods
    private func setUpLabel() {
        myLibraryLabel.setMargins(margin: 10)
        myLibraryLabel.layer.masksToBounds = true
        myLibraryLabel.textAlignment = .center
        myLibraryLabel.layer.cornerRadius = myLibraryLabel.frame.height/2
    }
    
    private func setupBTN() {
        playstationBTN.layer.cornerRadius = 20
        xboxBTN.layer.cornerRadius = 20
        nintendoBTN.layer.cornerRadius = 20
    }
    
    func fetchGame(listOfGames: [MyGame], platform: String) -> [MyGame] {
        var gamesList = listOfGames
        gamesList = coreDataManager.fetchGames(mygames: gamesList)
        let platformGames = gamesList.filter { $0.platform?.range(of: platform) != nil}
        return platformGames
    }
    
    //MARK: UI Action Methods
    @IBAction func playstationBtnAction(_ sender: Any) {
        playstationGames = fetchGame(listOfGames: playstationGames, platform: "playstation4")
        elements = MyLibraryElements(background: playstationImage, games: playstationGames)
        performSegue(withIdentifier: "GamesLibraries", sender: elements)
    }
    
    @IBAction func xboxBTNAction(_ sender: Any) {
        xboxGames = fetchGame(listOfGames: xboxGames, platform: "xbox-one")
        elements = MyLibraryElements(background: xboxImage, games: xboxGames)
        performSegue(withIdentifier: "GamesLibraries", sender: elements)
    }
    
    @IBAction func nintendoBTNAction(_ sender: Any) {
        nintendoGames = fetchGame(listOfGames: nintendoGames, platform: "nintendo-switch")
        elements = MyLibraryElements(background: nintendoImage, games: nintendoGames)
        performSegue(withIdentifier: "GamesLibraries", sender: elements)
    }
}


