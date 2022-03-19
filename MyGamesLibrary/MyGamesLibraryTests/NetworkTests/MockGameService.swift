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
    
}
