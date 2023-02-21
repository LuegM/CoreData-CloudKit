//
//  ListView.swift
//  CoreData-CloudKit
//
//  Created by Michael Luegmayer on 15.02.23.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.id, order: .forward)])
    var logs: FetchedResults<Log>
    
    @State private var showAddSheet = false
    
    var body: some View {
        NavigationStack {
            List{
                if logs.count == 0 {
                    Text("no Logs found")
                }
                ForEach(logs){log in
                    VStack(alignment: .leading) {
                        Text(log.text!)
                        Text("\(log.id!)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .onDelete(perform: deleteLog)
            }
            .navigationTitle("Logs")
            .sheet(isPresented: $showAddSheet, onDismiss: {
                showAddSheet = false
            }, content: {
                AddView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
        }
    }
    
    // MARK: - save Context
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("ERROR: \(error)")
        }
    }
    
    // MARK: - delete Log
    private func deleteLog(offset: IndexSet) {
        withAnimation {
            offset.map { logs[$0] }.forEach(viewContext.delete(_:))
            saveContext()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
