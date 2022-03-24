//
//  Tool.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 12/02/2022.
//

import Foundation
import UIKit
import CoreData

class Tool {
    //MARK: properties
    static let shared = Tool()
    let coreDataManager = CoreDataManager(managedObjectContext: CoreDataStack.shared.mainContext)
    
    //MARK: Methods
    func getDoubleToString(number : Double?)-> (String) {
        //convert a Int? to String
        // unwrapped the optional with a guard let syntax
        guard let fullNumber = number  else { return "N/A"}
        let numberValue = Int(fullNumber)
        //convert a Int? to String
        let ID = String(numberValue)
        
        return ID
    }
    //
    func listOfScreenshots(game: Game, images: [String]) -> [String] {
        var list = images
        game.short_screenshots?.forEach({ image in
            if image.image != game.short_screenshots?.last?.image {
                list.append(image.image ?? "no data")
            } else {
                list.append(image.image ?? "no data")
            }
        })
        return list
    }
}
