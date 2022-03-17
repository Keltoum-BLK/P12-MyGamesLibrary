//
//  FakeResponseData.swift
//  MyGamesLibraryTests
//
//  Created by Kel_Jellysh on 17/03/2022.
//

import Foundation

class FakeResponseData {
    //MARK: Response
    static let responseOK = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    //faire une réponse KO code 500
    static let responseKO = HTTPURLResponse(url: URL(string: "https://google.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    //MARK: Data
    static var rawCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "RawPlatformGames", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static let rawIncorrectData = "Error" .data(using: .utf8)!

    //translate correct incorrect
    static var searchCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "SearchJSON", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static let searchIncorrectData = "Error" .data(using: .utf8)!
    
    static var upcCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "UPCJSON", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    static let upcIncorrectData = "Error" .data(using: .utf8)!
}

