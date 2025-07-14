//import Foundation
//
//class DatabaseManager {
//    static let shared = DatabaseManager()
//    var dbQueue: DatabaseQueue?
//
//    private init() {
//        setupDatabase()
//    }
//
//    private func setupDatabase() {
//        do {
//            let fileManager = FileManager.default
//            let folderURL = try fileManager.url(
//                for: .documentDirectory,
//                in: .userDomainMask,
//                appropriateFor: nil,
//                create: true
//            )
//
//            let dbURL = folderURL.appendingPathComponent("my_database.sqlite")
//
//            dbQueue = try DatabaseQueue(path: dbURL.path)
//
//            // Print the full path
//            print(" Database created\(dbURL.path)")
//        } catch {
//            print("\(error)")
//        }
//    }
//}
