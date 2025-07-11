//import SQLite3
//import Foundation
//
//class DatabaseManager {
//    var db: OpaquePointer?
//    
//    func createDatabase() {
//        // Get the documents directory path
//        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("Error: Unable to access documents directory")
//            return
//        }
//        
//        // Define the database path
//        let dbPath = documentsDirectory.appendingPathComponent("example.db").path
//        
//        // Print the full path of the database
//        print("Database path: \(dbPath)")
//        
//        // Open the database
//        if sqlite3_open(dbPath, &db) == SQLITE_OK {
//            print("Successfully opened database at: \(dbPath)")
//            
//            // Close the database
//            sqlite3_close(db)
//        } else {
//            let errorMessage = String(cString: sqlite3_errmsg(db) ?? "Unknown error")
//            print("Error opening database: \(errorMessage)")
//        }
//    }
//}
