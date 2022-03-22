//
//  Platform.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 14/02/2022.
//

import Foundation
//MARK: Games Platform
enum GamePlatform: String {
    case playstation = "18"
    case xbox = "1"
    case nintendo = "7"
    
    var description: String {
        switch self {
        case .playstation: return "Playstation "
        case .xbox: return "Xbox"
        case .nintendo: return "Nintendo"
        }
    }
}
