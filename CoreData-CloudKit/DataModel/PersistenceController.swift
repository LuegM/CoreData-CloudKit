//
//  PersistenceController.swift
//  CoreData-CloudKit
//
//  Created by Michael Luegmayer on 15.02.23.
//
import CloudKit
import CoreData

class PersistenceController: ObservableObject{
    
    static let shared = PersistenceController()
    
    lazy var container: NSPersistentContainer = {
        setupContainer()
    }()
    
    init() {
        container = setupContainer()
    }
    
    func updateContainer() {
        saveContext()
        container = setupContainer()
    }
    
    private func setupContainer() -> NSPersistentContainer {
        let iCloud = UserDefaults.standard.bool(forKey: "iCloud")
        
        do {
            let newContainer = try PersistentContainer.getContainer(iCloud: iCloud)
            guard let description = newContainer.persistentStoreDescriptions.first else { fatalError("No description found") }
            
            if iCloud {
                newContainer.viewContext.automaticallyMergesChangesFromParent = true
                newContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            } else {
                description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
            }
            
            description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
            
            newContainer.loadPersistentStores { (storeDescription, error) in
                if let error = error as NSError? { fatalError("Unresolved error \(error), \(error.userInfo)") }
            }
            
            return newContainer
            
        } catch {
            print(error)
        }
        
        fatalError("Could not setup Container")
    }
    
    private func saveContext() {
        do {
            try container.viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("ERROR: \(error)")
        }
    }
}

final class PersistentContainer {
    
    private static var _model: NSManagedObjectModel?
    
    private static func model(name: String) throws -> NSManagedObjectModel {
        if _model == nil {
            _model = try loadModel(name: name, bundle: Bundle.main)
        }
        return _model!
    }
    
    private static func loadModel(name: String, bundle: Bundle) throws -> NSManagedObjectModel {
        guard let modelURL = bundle.url(forResource: name, withExtension: "momd") else {
            throw CoreDataModelError.modelURLNotFound(forResourceName: name)
        }

        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            throw CoreDataModelError.modelLoadingFailed(forURL: modelURL)
       }
        return model
    }

    enum CoreDataModelError: Error {
        case modelURLNotFound(forResourceName: String)
        case modelLoadingFailed(forURL: URL)
    }

    public static func getContainer(iCloud: Bool) throws -> NSPersistentContainer {
        let name = "LogModel"
        if iCloud {
            return NSPersistentCloudKitContainer(name: name, managedObjectModel: try model(name: name))
        } else {
            return NSPersistentContainer(name: name, managedObjectModel: try model(name: name))
        }
    }
}

