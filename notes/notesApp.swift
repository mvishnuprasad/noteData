//
//  notesApp.swift
//  notes
//
//  Created by vishnuprasad on 08/06/25.
//

import SwiftUI

@main
struct notesApp: App {
    // STEP 1: App creates ONE database connection for entire app
    // This uses REAL persistent storage (saves to disk permanently)
    /// This will create a persistant storage save data in persistent storage and not in the memory
    let provider = CoreDataProvider()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
                    // STEP 2: Inject database connection into Environment "magical backpack"
                    // Every child view can now access this database connection
                    .environment(\.managedObjectContext, provider.viewContext)
            }
        }
    }
}
