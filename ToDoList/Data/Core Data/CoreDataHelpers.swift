//
//  CoreDataHelpers.swift
//  ToDoList
//
//  Created by Ty Septiani on 01/08/23.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    enum CoreDataError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }
    
    static func load(modelName: String, url: URL,in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: modelName, in: bundle) else {
            throw CoreDataError.modelNotFound
        }
        
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw CoreDataError.failedToLoadPersistentStores($0) }
        return container
    }
}

extension NSManagedObjectModel {
    static func with(name:String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle.url(forResource: name, withExtension: "momd").flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}

extension NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
