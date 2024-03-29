//
//  TeamView.swift
//  Megan
//
//  Created by Megan Lin on 2/29/24.
//

import SwiftUI

struct GroupView: View {
    @Environment(ModelData.self) var modelData
    
    @State private var showAddGroupSheet = false
    
    @State private var groupedItems: [String: [DukePerson]] = [:]
  
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedItems.keys.sorted(), id: \.self) { key in
                    GroupRow(groupName: key, groupMember: groupedItems[key] ?? [])
                }
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("Group")
            .toolbar {
                ToolbarItem (){
                    Button(action: {
                        showAddGroupSheet = true
                    }) {
                        Label("Add Group", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showAddGroupSheet) {
            AddGroupView()
        }
        .onAppear {
            var group = Dictionary(grouping: modelData.DukePeople.map{$0.value}, by: { $0.team })
               
            let people = modelData.DukePeople.map{$0.value}
            for groupName in modelData.Group.keys.sorted() {
                group[groupName] = filterDukePerson(all: people, params: modelData.Group[groupName]!)
            }
            groupedItems = group
        }
    }
}

#Preview {
    GroupView()
        .environment(ModelData())
}
