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
    let slug, name: String?
    let playtime: Int?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let id: Int?
    let short_screenshots: [ShortScreenshot]?
    
    enum CodingKeys: String, CodingKey {
        case slug, name, playtime, released
        case backgroundImage = "background_image"
        case rating
        case  id
        case short_screenshots
    }
}

// MARK: - ShortScreenshot
struct ShortScreenshot: Decodable {
    let id: Int?
    let image: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case image
    }
    
}
