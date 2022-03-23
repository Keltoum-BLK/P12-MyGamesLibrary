//
//  MyLibraryElements.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 10/03/2022.
//

import Foundation
//MARK: Class to create an object to manage background image and list of games in Library 
class MyLibraryElements {
    var image: String
    var myGames: [MyGame]
    
    init(background: String, games: [MyGame]) {
        self.image = background
        self.myGames = games
    }
}
