//
//  MyLibraryViewController.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 11/02/2022.
//

import UIKit
import AVFoundation

class MyLibraryViewController: UIViewController {


    @IBOutlet weak var playstationBTN: UIButton!
    @IBOutlet weak var xboxBTN: UIButton!
    @IBOutlet weak var nintendoBTN: UIButton!
    @IBOutlet weak var myLibraryLabel: UILabel!
    
    private var coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    let playstationImage = "ps4Image"
    let xboxImage = "XboxImage"
    let nintendoImage = "switchImage"
    var playstationGames = [MyGame]()
    var xboxGames = [MyGame]()
    var nintendoGames = [MyGame]()
    var elements: MyLibraryElements?
    var platformArray = ["playstation4","xbox-one","nintendo-switch"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabel()
        setupBTN()
    }

    
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameTabVC = segue.destination as! GamesFavoriteViewController
        gameTabVC.platformElements = elements
    }
    
    @IBAction func playstationBtnAction(_ sender: Any) {
        playstationGames = fetchGame(array: playstationGames, platform: "playstation4")
        elements = MyLibraryElements(background: playstationImage, games: playstationGames)
        performSegue(withIdentifier: "GamesLibraries", sender: elements)
    }
    
    @IBAction func xboxBTNAction(_ sender: Any) {
        xboxGames = fetchGame(array: xboxGames, platform: "xbox-one")
        elements = MyLibraryElements(background: xboxImage, games: xboxGames)
        performSegue(withIdentifier: "GamesLibraries", sender: xboxImage)
    }
    
    @IBAction func nintendoBTNAction(_ sender: Any) {
        nintendoGames = fetchGame(array: nintendoGames, platform: "nintendo-switch")
        elements = MyLibraryElements(background: nintendoImage, games: nintendoGames)
        performSegue(withIdentifier: "GamesLibraries", sender: nintendoImage)
    }
    
    func fetchGame(array: [MyGame], platform: String) -> [MyGame] {
        var gamesList = array
        gamesList = coreDataManager.fetchGames(mygames: array)
        let platformGames = gamesList.filter { $0.platform?.range(of: platform) != nil}
        return platformGames
    }
}


