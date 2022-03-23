//
//  MockGameService.swift
//  MyGamesLibraryTests
//
//  Created by Kel_Jellysh on 17/03/2022.
//

import XCTest
@testable import MyGamesLibrary

class MockGameService: XCTestCase {
    
    var gameService: GameService!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLTestProtocol.self]
        let session = URLSession(configuration: configuration)
        gameService = GameService(session: session)
    }
    
    func testGivenAPlatformPlaystation_WhenYouCallApi_ThenResultSuccessCorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK!
            let error: Error? = nil
            let data = FakeResponseData.rawPlaystationCorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.fetchGames(platform: GamePlatform.playstation.rawValue, page: 1) { (result) in
            guard case .success(let gamesData) = result else { XCTFail("failure")
                return
            }
            
            let gamesList = gamesData.results
            
            let gameName = "Grand Theft Auto V"
            
            XCTAssertNotNil(gamesList)
            XCTAssertEqual(gameName, gamesList?[0].name)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testGivenAPlatformXbox_WhenYouCallApi_ThenResultSuccessCorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK!
            let error: Error? = nil
            let data = FakeResponseData.rawXboxCorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.fetchGames(platform: GamePlatform.playstation.rawValue, page: 1) { (result) in
            guard case .success(let gamesData) = result else { XCTFail("failure")
                return
            }
            
            let gamesList = gamesData.results
            
            let gameName = "Grand Theft Auto V"
            
            XCTAssertNotNil(gamesList)
            XCTAssertEqual(gameName, gamesList?[0].name)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenAPlatformNintendo_WhenYouCallApi_ThenResultSuccessCorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK!
            let error: Error? = nil
            let data = FakeResponseData.rawNintendoCorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.fetchGames(platform: GamePlatform.playstation.rawValue, page: 1) { (result) in
            guard case .success(let gamesData) = result else { XCTFail("failure")
                return
            }
            
            let gamesList = gamesData.results
            
            let gameName = "The Witcher 3: Wild Hunt"
            
            XCTAssertNotNil(gamesList)
            XCTAssertEqual(gameName, gamesList?[0].name)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetPlaystationGamesShouldPostFailWithIncorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO!
            let error: Error? = nil
            let data = FakeResponseData.rawPlaystationIncorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.fetchGames(platform: GamePlatform.playstation.rawValue, page: 1) { (result) in
            print(result)
            guard case .failure(let error) = result else { XCTFail("failure")
                return
            }
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetXboxGamesShouldPostFailWithIncorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO!
            let error: Error? = nil
            let data = FakeResponseData.rawXboxIncorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.fetchGames(platform: GamePlatform.playstation.rawValue, page: 1) { (result) in
            print(result)
            guard case .failure(let error) = result else { XCTFail("failure")
                return
            }
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetNintendoGamesShouldPostFailWithIncorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO!
            let error: Error? = nil
            let data = FakeResponseData.rawNintendoIncorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.fetchGames(platform: GamePlatform.playstation.rawValue, page: 1) { (result) in
            print(result)
            guard case .failure(let error) = result else { XCTFail("failure")
                return
            }
            
            XCTAssertNotNil(error)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenAKeywork_WhenYouSearchWithCallApi_ThenResultSuccessCorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK!
            let error: Error? = nil
            let data = FakeResponseData.searchCorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.fetchSearchGames(search: "zelda") { (result) in
            guard case .success(let gamesData) = result else { XCTFail("failure")
                return
            }
            
            let gamesList = gamesData.results
            
            let gameName = "ZELDA (Raul Fernandes)"
            
            XCTAssertNotNil(gamesList)
            XCTAssertEqual(gameName, gamesList?[0].name)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenAKeywork_WhenYouSearchWithCallApi_ThenResultFailInCorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO!
            let error: Error? = nil
            let data = FakeResponseData.searchIncorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.fetchSearchGames(search: "") { (result) in
            print(result)
            guard case .failure(let error) = result else { XCTFail("failure")
                return
            }
            
            XCTAssertNotNil(error)
            XCTAssertEqual(error.description, "Error network")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenAEmptyKeywork_WhenYouSearchWithCallApi_ThenResultAlertMessage() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK!
            let error: Error? = nil
            let data = FakeResponseData.searchCorrectData
            return (response, data, error)
        }
         
        let viewController = UIViewController()
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.fetchSearchGames(search: "") { (result) in
            guard case .success(let gamesData) = result else { XCTFail("failure")
                return
            }
            
            XCTAssertNotNil(gamesData)
            XCTAssertTrue(viewController.showAlertMessage(title: "Erreur détectée ⛔️",
                                                           message: "Tu ne peux pas faire requête avec un champ vide 👾, il faut saisir le nom entier du jeu.\n exemple: King of fighter") ==  viewController.showAlertMessage(title: "Erreur détectée ⛔️",
                                                                                                                                                                                                                               message: "Tu ne peux pas faire requête avec un champ vide 👾, il faut saisir le nom entier du jeu.\n exemple: King of fighter"))
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenAnUPC_WhenYouCallApi_ThenResultSuccessCorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK!
            let error: Error? = nil
            let data = FakeResponseData.upcCorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.getDataWithUPC(barCode: "5030947112332") { (result) in
            guard case .success(let itemData) = result else { XCTFail("failure")
                return
            }
            
            let gameInfo = itemData.items
            
            let gameName = "Electronic Arts Dragon Age In (uk Import) Dvd [region 2]"
            
            XCTAssertNotNil(gameInfo)
            XCTAssertEqual(gameName, gameInfo[0].title)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenAnUPC_WhenYouCallApi_ThenResultFailNetworkWithIncorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO!
            let error: Error? = nil
            let data = FakeResponseData.upcIncorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.getDataWithUPC(barCode: "5030947112332") { (result) in
            print(result)
            guard case .failure(let error) = result else { XCTFail("failure")
                return
            }
            
            XCTAssertNotNil(error)
            XCTAssertEqual(error.description, "Error network")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenAnUPC_WhenYouCallApi_ThenResultFailServerWithIncorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK!
            let error: Error? = nil
            let data = FakeResponseData.upcIncorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.getDataWithUPC(barCode: "") { (result) in
            print(result)
            guard case .failure(let error) = result else { XCTFail("failure")
                return
            }
            
            XCTAssertNotNil(error)
            XCTAssertEqual(error.description, "Error decoding")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
    func testGivenAnURL_WhenYouCallApi_ThenResultSuccessCorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK!
            let error: Error? = nil
            let data = FakeResponseData.rawPaginationCorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.getDataFromUrl(next: "https://api.rawg.io/api/games?key=d3ddbff177a54ba3aff10986628d8498&page=3&platforms=18") { (result) in
            guard case .success(let urlData) = result else { XCTFail("failure")
                return
            }
            
            let gameInfo = urlData.results
            
            let gameName = "Batman: Arkham Knight"
            
            XCTAssertNotNil(gameInfo)
            XCTAssertEqual(gameName, gameInfo?[0].name)
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenAnURL_WhenYouCallApi_ThenResultFailNetworkWithIncorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseKO!
            let error: Error? = nil
            let data = FakeResponseData.rawPaginationIncorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.getDataFromUrl(next: "https://api.rawg.io/api/games?key=d3ddbff177a54ba3aff10986628d8498&page=2&platforms=18") { (result) in
            print(result)
            guard case .failure(let error) = result else { XCTFail("failure")
                return
            }
            
            XCTAssertNotNil(error)
            XCTAssertEqual(error.description, "Error network")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGivenAnWrongURL_WhenYouCallApi_ThenResultFailServerWithIncorrectData() {
        
        URLTestProtocol.loadingHandler = { request in
            let response: HTTPURLResponse = FakeResponseData.responseOK!
            let error: Error? = nil
            let data = FakeResponseData.rawPaginationIncorrectData
            return (response, data, error)
        }
        
        let expectation = XCTestExpectation(description: "wait for change")
        
        gameService.getDataFromUrl(next: "https://api.rawg.io/api/games?key=d3ddbff177a54ba3aff10986628d8498&page=0&platforms=18") { (result) in
            print(result)
            guard case .failure(let error) = result else { XCTFail("failure")
                return
            }
            
            XCTAssertNotNil(error)
            XCTAssertEqual(error.description, "Error decoding")
            
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }
    
    
}
