//
//  Game.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 14/02/2022.
//

import Foundation
// MARK: - Games
struct Games: Decodable {
    let next: String?
    let results: [Game]?
    
    enum CodingKeys: String, CodingKey {
        case next
        case results
    }
}

// MARK: - Game
struct Game: Decodable {
    let name: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    var platforms: [Platform]?
    let short_screenshots: [ShortScreenshot]?
    
    enum CodingKeys: String, CodingKey {
        case name, released
        case backgroundImage = "background_image"
        case rating
        case platforms = "platforms"
        case short_screenshots
        
    }
    

    //MARK: Method to convert array of object values to string array
    func createList(for platforms: [Platform]?) -> String {
            guard let platforms = platforms else { return "" }
            return  platforms
                .compactMap { $0.name }
                .joined(separator: ", ")
        }
     
    
}

struct Platform: Decodable {
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}


// MARK: - ShortScreenshot
struct ShortScreenshot: Decodable {
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case image
    }
    
}
