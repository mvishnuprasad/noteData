//
//  ContentView.swift
//  notes
//
//  Created by vishnuprasad on 08/06/25.
//

import SwiftUI



struct ContentView: View {
    @State private var title : String = ""
    
    // STEP 3: View reaches into Environment "backpack" and pulls out database connection
    // This @Environment gives us access to the shared database connection
    @Environment(\.managedObjectContext) private var context
  
    
    private var isFormValid : Bool {
        !title.isEmptyOrSpace
    }
    
    private func saveToDoItem() {
        // STEP 4: Use the database connection to create and save new item
        let toDoItem = ToDoItem(context: context)  // Creates new item using database connection
        toDoItem.title = title                     // Sets the title from TextField
        do {
            try context.save()                     // STEP 5: Saves to real database on disk permanently
        }catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
    var body: some View {
        VStack {
            TextField(
                "Title",
                text: $title
                
            ).textFieldStyle(.roundedBorder)
                .onSubmit {
                    if isFormValid{
                        // User presses return -> validation -> save to database
                        saveToDoItem()
                    }
                }
            Spacer()
            
        }
        .padding()
        .navigationTitle("ToDo")
    }
}

#Preview {
    NavigationStack {
        ContentView()
        // PREVIEW ENVIRONMENT: Uses FAKE in-memory data for development
        // This data disappears when preview closes - separate from real app
            .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
    }
}

/*
 FLOW SUMMARY:
 1. App Launch -> Creates real database connection
 2. Database connection put in Environment "backpack"
 3. ContentView pulls database connection from "backpack"
 4. User types in TextField
 5. User presses return -> saveToDoItem() called
 6. New ToDoItem created using database connection
 7. Data saved to disk permanently (persists between app launches)
 
 PREVIEW vs REAL APP:
 - Preview: Uses CoreDataProvider.preview (fake sample data in memory)
 - Real App: Uses CoreDataProvider() (real persistent database on disk)
 */

#Preview {
    NavigationStack {
        ContentView()
            .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
    }
}
