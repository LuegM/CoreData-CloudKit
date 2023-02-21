//
//  SettingsView.swift
//  CoreData-CloudKit
//
//  Created by Michael Luegmayer on 15.02.23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var cloudEnabled = true
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Settings") {
                    Toggle("iCloud sync", isOn: $cloudEnabled)
                        .onChange(of: cloudEnabled) { value in
                            UserDefaults.standard.set(value, forKey: "iCloud")
                            PersistenceController.shared.updateContainer()
                        }
                        .onAppear {
                            self.cloudEnabled = UserDefaults.standard.bool(forKey: "iCloud")
                        }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
