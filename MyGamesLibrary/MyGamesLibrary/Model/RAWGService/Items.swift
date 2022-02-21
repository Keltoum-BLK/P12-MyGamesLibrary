//
//  UPCService.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 20/02/2022.
//

import Foundation

struct ItemsList: Decodable {
    let items: [Item]
    
    enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}
struct Item: Decodable {
    let ean: String?
    let title: String?
    let description: String?
    let elid: String?
    
    enum CodingKeys: String, CodingKey {
        case ean = "ean"
        case title = "title"
        case description = "description"
        case elid = "elid"
    }
}
