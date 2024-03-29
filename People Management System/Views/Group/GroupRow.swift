//
//  TeamRow.swift
//  Megan
//
//  Created by Megan Lin on 2/29/24.
//

import SwiftUI

struct GroupRow: View {
    @Environment(ModelData.self) var modelData
    @State private var showEditSheet = false
    @State var groupName: String
    var groupMember: [DukePerson]
    
    var body: some View {
        VStack(alignment: .leading) {
            let groupNamesSet = Set(modelData.DukePeople.map { $0.value.team })
                
            if groupNamesSet.contains(groupName) {
                Text(groupName)
                    .font(.headline)
                    .padding(.leading, 15)
                    .padding(.top, 5)
            } else {
                Text(groupName)
                    .font(.headline)
                    .padding(.leading, 15)
                    .padding(.top, 5)
                
                    .contextMenu {
                        Button(role: .none) {
                            showEditSheet = true
                        } label: {
                            HStack {
                                Text("Edit")
                                Image(systemName: "pencil.and.scribble")
                            }
                        }
                        
                        Button(role: .destructive) {
                            deleteGroup(name: groupName)
                        } label: {
                            HStack {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
                        }
                    }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(groupMember) {dukePerson in
                        NavigationLink {
                            DukePersonDetail(dukePerson: dukePerson)
                        } label: {
                            GroupItem(dukePerson: dukePerson)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
        .sheet(isPresented: $showEditSheet){
            let filterStr = constructFilterText(filter: modelData.Group[groupName] ?? [:])
            AddGroupView(groupName: groupName, filterText: filterStr, edit: true)
        }
    }
    
    private func deleteGroup(name: String) {
        modelData.Group[name] = nil
        print("delete group: ", modelData.Group)
        _ = People_Management_System.saveGroup(modelData.Group, str: modelData.auth)
    }
}

#Preview {
    GroupRow(groupName: "TripMaker", groupMember: [ModelData().DukePeople[123456]!])
        .environment(ModelData())
}
