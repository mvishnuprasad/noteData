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
    @FetchRequest(sortDescriptors: []) private var todoItems : FetchedResults<ToDoItem>
    
    private var isFormValid : Bool {
        !title.isEmptyOrSpace
    }
    
    private func saveToDoItem() {
        // STEP 4: Use the database connection to create and save new item
        let toDoItem = ToDoItem(context: context)  // Creates new item using database connection
        toDoItem.title = title                     // Sets the title from TextField
        do {
            try context.save()                // STEP 5: Saves to real database on disk permanently
        }catch {
            print("Error \(error.localizedDescription)")
        }
    }
    private var pendingTasks: [ToDoItem] {
        todoItems.filter { toDoItem in
            !toDoItem.isCompleted
        }
    }
    private var  finishedTasks: [ToDoItem] {
        todoItems.filter { toDoItem in
            toDoItem.isCompleted
        }
    }
    private func   updateItem(_ todoItem : ToDoItem) {
        do {
            try context.save()
        }catch{
            print("Error")
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
            List{
                Section("Pending"){
                    ForEach(pendingTasks){ pendingTask in
                        
                        ToDoCellView(todoItem: pendingTask) { item in
                            updateItem(pendingTask)
                        }
                        
                    }
                }
                Section("Completed"){
                    ForEach(finishedTasks){ finishedTask in
                        ToDoCellView(todoItem: finishedTask) { item in
                            updateItem(finishedTask)
                        }
                        
                    }
                }
            }.listStyle(.plain)
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
struct ToDoCellView : View{
    let todoItem : ToDoItem
    let onChanged : (ToDoItem) -> Void
    var body: some View{
        HStack{
            Image(systemName: todoItem.isCompleted ? "checkmark.square" : "square")
                .onTapGesture {
                    todoItem.isCompleted.toggle()
                    onChanged(todoItem)
                }
            Text(todoItem.title ?? "")
        }
    }
}
#Preview {
    NavigationStack {
        ContentView()
            .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
    }
}
