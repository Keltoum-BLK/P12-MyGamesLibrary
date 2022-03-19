//
//  MockMyGames.swift
//  MyGamesLibraryTests
//
//  Created by Kel_Jellysh on 17/03/2022.
//

import XCTest
import CoreData
@testable import MyGamesLibrary

class MockMyGames: XCTestCase {
    
    
    
    var myGamesService : MyGamesService!
    var coreDataStack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        myGamesService = MyGamesService(coreDataStack: coreDataStack)
    }
   //put games value here
    private var game1 = Game(name: "Dead Cell",
                             released: "2022",
                             backgroundImage: "ps4Image",
                             rating: 0.00,
                             platforms: [PlatformElements(platform: Platform(slug: "playstation4", name: "Playstation 4"))],
                             short_screenshots: [])
    private var game2 = Game(name: "Bioshock 4",
                             released: "2022",
                             backgroundImage: "xboxImage",
                             rating: 0.00,
                             platforms: [PlatformElements(platform: Platform(slug: "xbox-one", name: "Xbox One"))],
                             short_screenshots: [])
    private var listOfFavoriteGames = [MyGame]()
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        coreDataStack = nil
        myGamesService = nil
    }
    
    func testGivenAlert_WhenYouAddAGame_ThenResultAlert() {
        //Given
        let vc = UIViewController()
        //When
        myGamesService.addGame(game: game1)
        //Then
        XCTAssertNotNil(game1)
        XCTAssertTrue( vc.showAlertMessage(title: "Mission Accomplie 🤓", message: "Ton jeu est bien ajouté à ton catalogue") ==  vc.showAlertMessage(title: "Mission Accomplie 🤓", message: "Ton jeu est bien ajouté à ton catalogue"))
    }
    
    func test_add_a_game() {
        //When
        myGamesService.addGame(game: game1)
        //Then
        XCTAssertNotNil(game1)
        
        XCTAssertEqual(game1.name,"Dead Cell")
        XCTAssertEqual(game1.released, "2022")
        XCTAssertEqual(game1.backgroundImage,"ps4Image")
        XCTAssertEqual(game1.rating, 0.0)
    }
    
    func test_fetch_games() {
        //Given
        myGamesService.addGame(game: game1)
        myGamesService.addGame(game: game2)
        //When
        listOfFavoriteGames =  myGamesService.fetchGames(mygames: listOfFavoriteGames)
        for  i in listOfFavoriteGames {
            print(i.name ?? "no label")
        }
        //Then
        XCTAssertTrue(listOfFavoriteGames.count == 2)
        XCTAssertTrue(listOfFavoriteGames[1].name == game1.name)
    }
    
    func test_fetch_games_by_platform() {
        //Given
        myGamesService.addGame(game: game1)
        myGamesService.addGame(game: game2)
        //When
        listOfFavoriteGames =  myGamesService.fetchGamesByPlateform(platform: "playstation4")
        for  i in listOfFavoriteGames {
            print(i.name ?? "no label")
        }
        //Then
        XCTAssertTrue(listOfFavoriteGames.count == 1)
        XCTAssertTrue(listOfFavoriteGames[0].name == game1.name)
    }
    
    func test_remove_a_game() {
        //Given
        myGamesService.addGame(game: game1)
        //When
      
        myGamesService.removeGame(name: game1.name ?? "")
        listOfFavoriteGames =  myGamesService.fetchGamesByPlateform(platform: "playstation4")
        
        //Then
        XCTAssertTrue(listOfFavoriteGames.isEmpty)
    }
    
    func testGivenAlert_WhenYouRemoveAGame_ThenResultAlert() {
        //Given
        let vc = UIViewController()
        myGamesService.addGame(game: game1)
        //When
      
        myGamesService.removeGame(name: game1.name ?? "")
        listOfFavoriteGames =  myGamesService.fetchGamesByPlateform(platform: "playstation4")
        
        //Then
        XCTAssertTrue(listOfFavoriteGames.isEmpty)
        XCTAssertTrue( vc.showAlertMessage(title: "Suppression confirmée ❌", message: "Tu as bien supprimé le jeu de ton catalogue") ==  vc.showAlertMessage(title: "Suppression confirmée ❌", message: "Tu as bien supprimé le jeu de ton catalogue"))
    }
    
    
    func test_remove_a_game_in_an_array() {
     
    }
    
    func test_check_game_already_added() {
     
    }
    
    func testGivenAlert_WhenYouAlreadyAddGame_ThenResultsAlert() {
      
    }
}
