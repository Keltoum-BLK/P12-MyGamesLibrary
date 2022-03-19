//
//  MyGamesService.swift
//  MyGamesLibraryTests
//
//  Created by Kel_Jellysh on 17/03/2022.
//

import Foundation
import CoreData
@testable import MyGamesLibrary

class MyGamesService {
    
    private let coreDataStack: TestCoreDataStack
    private let managedObjectContext: NSManagedObjectContext
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack as! TestCoreDataStack
        self.managedObjectContext = coreDataStack.mainContext    }
    
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
  
        coreDataStack.saveContext()
    }
    
    
    //add Data to a array
    func fetchGames(mygames: [MyGame]) -> [MyGame] {
        let request: NSFetchRequest<MyGame> = MyGame.fetchRequest()
        request.returnsObjectsAsFaults = false
        do {
            var mygamesList = mygames
            mygamesList = try managedObjectContext.fetch(request)
            return mygamesList
        } catch {
            return []
        }
    }
    
    func fetchGamesByPlateform(platform: String) -> [MyGame] {
        let request: NSFetchRequest<MyGame> = MyGame.fetchRequest()
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "platform == %@", platform)
        let games = (try? managedObjectContext.fetch(request)) ?? []
        return games
    }
//
    
    //remove
    func removeGameInArray(row: Int, array: [MyGame]) {
        managedObjectContext.delete(array[row])
        do {
            try managedObjectContext.save()
        } catch {
            debugPrint("Couldn't remove \(error.localizedDescription)")
        }
    }
    
    func removeGame(name: String) {
        let request: NSFetchRequest<MyGame> = MyGame.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        guard let game = try? managedObjectContext.fetch(request) else { return }
        game.forEach { game in
            managedObjectContext.delete(game)
        }
        do {
            try managedObjectContext.save()
        } catch {
            debugPrint("Couldn't remove \(error.localizedDescription)")
        }
    }
    
    //check if already added
    func checkGameIsAlreadySaved(with name: String?) -> Bool {
        guard let name = name else { return false }
        let request: NSFetchRequest<MyGame> = MyGame.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        guard let gamesList = try? managedObjectContext.fetch(request) else { return false }
        return !gamesList.isEmpty
    }
}


