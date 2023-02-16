//
//  GameProvider.swift
//  Game App
//
//  Created by OjekBro - Ahfas on 16/02/23.
//
import CoreData
import Foundation

class GameProvider {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GameDataModel")

        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(String(describing: error))")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil

        return container
    }()

    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil

        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }

    // Function CRUD
    func getAllGame(completion: @escaping (_ game: [GameModel]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var games: [GameModel] = []
                for result in results {
                    let game = GameModel(
                        id: result.value(forKey: "id") as! Int,
                        name: result.value(forKey: "name") as! String,
                        released: result.value(forKey: "released") as! Date,
                        rating: result.value(forKey: "rating") as! Double,
                        backgroundImage: result.value(forKey: "backgroundImage") as! URL
                    )

                    games.append(game)
                }

                completion(games)
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }

    func getGame(_ id: Int, completion: @escaping (GameModel) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            do {
                if let result = try taskContext.fetch(fetchRequest).first {
                    let game = GameModel(
                        id: result.value(forKey: "id") as! Int,
                        name: result.value(forKey: "name") as! String,
                        released: result.value(forKey: "released") as! Date,
                        rating: result.value(forKey: "rating") as! Double,
                        backgroundImage: result.value(forKey: "backgroundImage") as! URL
                    )

                    completion(game)
                }
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }

    func createGame(
        _ id: Int,
        _ name: String,
        _ released: Date,
        _ rating: Double,
        _ backgroundImage: URL,
        completion: @escaping () -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            if let entity = NSEntityDescription.entity(forEntityName: "Game", in: taskContext) {
                let game = NSManagedObject(entity: entity, insertInto: taskContext)

                game.setValue(id, forKey: "id")
                game.setValue(name, forKey: "name")
                game.setValue(released, forKey: "released")
                game.setValue(rating, forKey: "rating")
                game.setValue(backgroundImage, forKey: "backgroundImage")

                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }

    func getMaxId(completion: @escaping (_ maxId: Int) -> Void) {
        let taskContext = newTaskContext()
        taskContext.performAndWait {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchLimit = 1
            do {
                let lastGame = try taskContext.fetch(fetchRequest)
                if let game = lastGame.first, let position = game.value(forKeyPath: "id") as? Int {
                    completion(position)
                } else {
                    completion(0)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func updateGame(
        _ id: Int,
        _ name: String,
        _ released: Date,
        _ rating: Double,
        _ backgroundImage: URL,
        completion: @escaping () -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            if let result = try? taskContext.fetch(fetchRequest), let game = result.first as? Game {
                game.setValue(name, forKey: "name")
                game.setValue(released, forKey: "released")
                game.setValue(rating, forKey: "rating")
                game.setValue(backgroundImage, forKey: "backgroundImage")
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            }
        }
    }

    func deleteGame(_ id: Int, completion: @escaping () -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }

    func deleteAllGame(completion: @escaping () -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Game")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult = try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
                if batchDeleteResult.result != nil {
                    completion()
                }
            }
        }
    }
}
