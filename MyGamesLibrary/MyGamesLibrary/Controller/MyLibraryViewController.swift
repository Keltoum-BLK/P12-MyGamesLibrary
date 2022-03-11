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
    var elements: MyLibraryElements?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabel()
        setupBTN()
        self.setupNavigationBack()
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
        playstationGames = fetchGame(array: playstationGames)
        elements = MyLibraryElements(background: playstationImage, games: playstationGames)
        performSegue(withIdentifier: "GamesLibraries", sender: elements)
    }
    
    @IBAction func xboxBTNAction(_ sender: Any) {
        performSegue(withIdentifier: "GamesLibraries", sender: xboxImage)
    }
    
    @IBAction func nintendoBTNAction(_ sender: Any) {
        performSegue(withIdentifier: "GamesLibraries", sender: nintendoImage)
    }
    
    func fetchGame(array: [MyGame]) -> [MyGame] {
        var gamesList = array
//        gamesList = coreDataManager.fetchGamesByPlateform(platform: platform)
        gamesList = coreDataManager.fetchGames(mygames: gamesList)
        return gamesList
    }
}


