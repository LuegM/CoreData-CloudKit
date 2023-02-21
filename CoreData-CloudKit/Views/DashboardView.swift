//
//  ContentView.swift
//  CoreData-CloudKit
//
//  Created by Michael Luegmayer on 15.02.23.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
            TabView {
                ListView()
                    .tabItem {
                        Label("List", systemImage: "list.dash")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
    }
}


struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
