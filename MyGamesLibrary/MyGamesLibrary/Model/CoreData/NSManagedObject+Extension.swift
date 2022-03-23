//
//  NSManagedObject+Extension.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 02/03/2022.
//

import Foundation
import CoreData

extension NSManagedObject {
    //Convenience initialization to save a entity in Data Base, not save with default method.
    convenience init(usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }

}
