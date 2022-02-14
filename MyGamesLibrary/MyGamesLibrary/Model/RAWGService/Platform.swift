//
//  Platform.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 14/02/2022.
//

import Foundation

enum Platform: String {
    case ps4 = "18"
    case xboxone = "1"
    case nswitch = "7"
    
    var description: String {
        switch self {
        case .ps4: return "Playstation 4"
        case .xboxone: return "Xbox One"
        case .nswitch: return "Nintendo Switch"
        }
    }
}
