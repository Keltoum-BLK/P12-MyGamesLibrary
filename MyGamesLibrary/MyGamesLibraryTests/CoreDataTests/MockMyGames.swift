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
    private var listOfFavoriteGames = [MyGame]()
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        coreDataStack = nil
        myGamesService = nil
    }
    
    func testGivenAlert_WhenYouAddAGame_ThenResultAlert() {
    
    }
    
    func test_add_a_game() {
 
    }
    
    func test_fetch_games() {
    
    }
    
    func test_fetch_games_by_platform() {
    
    }
    
    func test_remove_a_game() {
     
    }
    
    func test_remove_a_game_in_an_array() {
     
    }
    
    func test_check_game_already_added() {
     
    }
    
    func testGivenAlert_WhenYouAlreadyAddGame_ThenResultsAlert() {
      
    }
}
