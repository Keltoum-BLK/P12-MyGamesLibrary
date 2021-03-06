//
//  TestCoreDataStack.swift
//  MyGamesLibraryTests
//
//  Created by Kel_Jellysh on 17/03/2022.
//

import Foundation

import CoreData
@testable import MyGamesLibrary

final class TestCoreDataStack: CoreDataStack{
   
    convenience init() {
          self.init(modelName: "MyGamesLibrary")
      }

    // MARK: -Override init
    override init(modelName: String) {
        super.init(modelName: modelName)
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores { storeDescription, error in
         if let error = error as NSError? {
                fatalError("Unresolved error \(String(describing: error)), \(error.userInfo)")
            }
        }
 
        self.persistentContainer = container
        
        var mainContext: NSManagedObjectContext {
                  return persistentContainer.viewContext
              }
        func saveContext() {
            do {
                try mainContext.save()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

