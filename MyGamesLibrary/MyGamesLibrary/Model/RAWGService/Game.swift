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
    let platforms: [PlatformElements]?
    let short_screenshots: [ShortScreenshot]?
    
    enum CodingKeys: String, CodingKey {
        case name, released
        case backgroundImage = "background_image"
        case rating
        case platforms = "platforms"
        case short_screenshots
        
    }
    

    //MARK: Method to convert array of object values to string array
    func createList(for platforms: [PlatformElements]?) -> String {
        guard let platforms = platforms else { return "" }
            return  platforms
            .compactMap { $0.platform.slug }
                .joined(separator: ", ")
        }
    
   
}

struct PlatformElements: Decodable {
    let platform: Platform
}

struct Platform: Decodable {
    let slug: String?
    
    enum CodingKeys: String, CodingKey {
        case slug
    }
}


// MARK: - ShortScreenshot
struct ShortScreenshot: Decodable {
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case image
    }
    
}
