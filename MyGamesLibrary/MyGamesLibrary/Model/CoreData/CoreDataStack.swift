//
//  CoreDataStack.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 01/03/2022.
//

import Foundation
import CoreData

class CoreDataStack {
    
    //MARK: property
    var persistentContainer: NSPersistentContainer
    
    //MARK: Singleton property
    static let shared = CoreDataStack(modelName: "MyGamesLibrary")
    
    //MARK: Iniialization 
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard let unwrappedError = error else { return }
            fatalError("Unsolved error \(unwrappedError.localizedDescription)")
        }
    }
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //MARK: Method to save
    func saveContext() {
        do {
            try mainContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
