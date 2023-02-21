//
//  AddView.swift
//  CoreData-CloudKit
//
//  Created by Michael Luegmayer on 15.02.23.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var textValue = ""
    
    var body: some View {
        Form {
            TextField("Text", text: $textValue)
            Button("add") {
                addLog()
                dismiss()
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
    
    // MARK: - addLog
    private func addLog() {
        withAnimation {
            let newLog = Log(context: viewContext)
            
            newLog.id = UUID()
            newLog.text = textValue
            
            saveContext()
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
