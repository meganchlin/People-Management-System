//
//  ContentView.swift
//  Megan
//
//  Created by Megan Lin on 2/13/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var isLoggedIn = false
    @State private var selection: Tab = .list
     
    
    enum Tab {
        case list
        case team
    }

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                DukePersonList()
                    .tabItem {
                        Label("List", systemImage: "list.bullet")
                    }
                    .tag(Tab.list)
            
                GroupView()
                    .tabItem {
                        Label("Group", systemImage: "person.3.fill")
                        
                    }
                    .tag(Tab.list)
            }
            if !isLoggedIn {
                Login(isLoggedIn: $isLoggedIn)
                    .transition(.opacity) // Optional animation for showing/hiding the login view
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
