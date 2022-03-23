//
//  MyGamesLibraryTests.swift
//  MyGamesLibraryTests
//
//  Created by Kel_Jellysh on 09/02/2022.
//

import XCTest
@testable import MyGamesLibrary

class MyGamesLibraryTests: XCTestCase {
    
    private var tool: Tool!
    private var game: Game!
    private var game2: Game!
    private var item: Item!
    private var myLibraryElements : MyLibraryElements!
    
    override func setUp() {
        super.setUp()
        tool = Tool()
        game = Game(name: "Dead Cell",
                    released: "2022",
                    backgroundImage: "ps4Image",
                    rating: 4.75,
                    platforms: [PlatformElements(platform: Platform(slug: "playstation4", name: "Playstation 4"))],
                    short_screenshots: [ShortScreenshot(image: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg"), ShortScreenshot(image: "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg")])
        item = Item(ean: "23904548", title: "Dragon Dogma", description: "Capcom Game", elid: "lol")
        myLibraryElements = MyLibraryElements(background: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg", games: [])
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    override func tearDownWithError() throws {
        tool = nil
        game = nil
        item = nil
        myLibraryElements = nil
    }
    
    //MARK: Tests on Constants Class
    func testGivenAGame_WhenFilterForEachImage_ThenReturnAnArrayOfString() {
        //Given
        let listOfImages = [String]()
        //When
        let result = tool.listOfScreenshots(game: game, images: listOfImages)
        //Then
        XCTAssertTrue(result.count == 2)
    }
    
    func testGivenDoubleValue_WhenConvert_ThenReturnAString() {
        //Given
        let ratingValue = game.rating
        //When
        let result = tool.getDoubleToString(number: ratingValue)
        //Then
        XCTAssertTrue(result == "4")
    }
    
    func testGivenAnEmptyObject_WhenCreateTheObject_ThenResultGameObject() {
        //Given
        var game: Game!
        //When
        game = Game(name: "GTA 5",
                    released: "2015",
                    backgroundImage: "ps4Image",
                    rating: 4.75,
                    platforms: [PlatformElements(platform: Platform(slug: "playstation4", name: "Playstation 4"))],
                    short_screenshots: [ShortScreenshot(image: "https://media.rawg.io/media/games/456/456dea5e1c7e3cd07060c14e96612001.jpg"), ShortScreenshot(image: "https://media.rawg.io/media/games/618/618c2031a07bbff6b4f611f10b6bcdbc.jpg")])
        
        //Then
        XCTAssertNotNil(game)
        XCTAssertTrue(game.name == "GTA 5")
    }
    
    func testGivenAnEmptyObject_WhenCreateTheObject_ThenResultItemObject() {
        //Given
        var item: Item!
        //When
        item = Item(ean: "0000015468", title: "Assassin's Creed Black Flag", description: "Pirates", elid: "54682")
        
        //Then
        XCTAssertNotNil(item)
        XCTAssertTrue(item.title == "Assassin's Creed Black Flag")
    }
    
    func testGivenAnEmptyObject_WhenCreateTheObject_ThenResultLibraryElementsObject() {
        //Given
        var myElements: MyLibraryElements!
        //When
        myElements = MyLibraryElements(background: "XboxImage", games: [])
        
        //Then
        XCTAssertNotNil(myElements)
        XCTAssertTrue(myElements.image == "XboxImage")
        XCTAssertTrue(myElements.myGames.isEmpty)
    }
    
    
    func testGivenAGame_WhenCreateAListOfSlug_ThenResultAString() {
        //Given
        let platforms = game.platforms
        //When
        let platformSlugList = game.createSlugList(for: platforms)
        
        //Then
        XCTAssertNotNil(platformSlugList)
        XCTAssertTrue(platformSlugList == "playstation4")
    }
    
    func testGivenAGame_WhenCreateAListOfName_ThenResultAString() {
        //Given
        let platforms = game.platforms
        //When
        let platformNamesList = game.createNameList(for: platforms)
        
        //Then
        XCTAssertNotNil(platformNamesList)
        XCTAssertTrue(platformNamesList == "Playstation 4")
    }
    
    func testGivenAPlatform_WhenAskDescription_ThenResultAPlatformDescription() {
        //Given
        let platform1 = GamePlatform.playstation
        let platform2 = GamePlatform.nintendo
        let platform3 = GamePlatform.xbox
        //When
        let platformNamesList = [platform1.description, platform2.description, platform3.description]
        //Then
        XCTAssertNotNil(platformNamesList)
        XCTAssertEqual(platform1.description, "Playstation")
        XCTAssertEqual(platform2.description, "Nintendo")
        XCTAssertEqual(platform3.description, "Xbox")
        XCTAssertEqual(platform1.rawValue, "18")
        XCTAssertEqual(platform2.rawValue, "7")
        XCTAssertEqual(platform3.rawValue, "1")
    }
    
    func testApiErrorDescription_WhenErrorIsServer() {
        //When
        let apiError = APIError.server
        //Then
        XCTAssertTrue(apiError.description == "Error server")
    }

    func testApiErrorDescription_WhenErrorIsNetwork() {
        //When
        let apiError = APIError.network
        //Then
        XCTAssertTrue(apiError.description == "Error network")
    }

    func testApiErrorDescription_WhenErrorIsDecoding() {
        //When
        let apiError = APIError.decoding
        //Then
        XCTAssertTrue(apiError.description == "Error decoding")
    }
}
