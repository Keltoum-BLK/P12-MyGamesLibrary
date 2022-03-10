//
//  MyLibraryElements.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 10/03/2022.
//

import Foundation


class MyLibraryElements {
    var image: String
    var myGames: [MyGame]
    
    init(background: String, games: [MyGame]) {
        self.image = background
        self.myGames = games
    }
}
