//
//  ApiErrorManager.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 09/02/2022.
//

import Foundation

//MARK: Error Manager
enum APIError: Error {
    case decoding
    case server
    case network
    
    var description : String {
        switch self {
        case APIError.decoding:
            return "Error decoding"
            
        case APIError.network:
            return "Error network"
            
        case APIError.server:
            return "Error server"
        }
    }
}
