//
//  CoreDataManager.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 01/03/2022.
//

import Foundation
import CoreData

class CoreDataManager {
    //MARK: Property
    let managedObjectContext: NSManagedObjectContext
   
    //MARK: Iniialization
    init(managedObjectContext: NSManagedObjectContext = CoreDataStack.shared.mainContext ) {
        self.managedObjectContext = managedObjectContext
    }
    //MARK: Methods
    //add game to Data Base
    func addGame(game: Game) {
        
        let platformsList = game.createList(for: game.platforms)
        
        let entity = MyGame(context: managedObjectContext)
        entity.name = game.name
        entity.rating = game.rating ?? 0.0
        entity.release_date = game.released
        entity.backgroundImage = game.backgroundImage?.data(using: .utf8)
        entity.platform = platformsList
  
        CoreDataStack.shared.saveContext()
    }
    
    
    //add Data to a array
    func fetchGames(mygames: [MyGame]) -> [MyGame] {
        let request: NSFetchRequest<MyGame> = MyGame.fetchRequest()
        do {
            var mygamesList = mygames
            mygamesList = try managedObjectContext.fetch(request)
            return mygamesList
        } catch {
            return []
        }
    }
    
    
    //remove
    func removeGame(row: Int, array: [MyGame]) {
        managedObjectContext.delete(array[row])
        do {
            try managedObjectContext.save()
        } catch {
            debugPrint("Couldn't remove \(error.localizedDescription)")
        }
    }
    
    //check if already added
    func checkGameIsAlreadySaved(backgroundImage: String) -> Bool {
        let request: NSFetchRequest<MyGame> = MyGame.fetchRequest()
        request.predicate = NSPredicate(format: "backgroundImage == %@", backgroundImage)
        guard let gamesList = try? managedObjectContext.fetch(request) else { return false }
        if gamesList.isEmpty { return false }
        return true
    }
   
}
