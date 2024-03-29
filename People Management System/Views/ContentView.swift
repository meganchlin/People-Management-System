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
            //ECE564Login()
        }
    }
}

#Preview {
    ContentView()
        .environment(ModelData())
}
