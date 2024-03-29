//
//  AddGroupView.swift
//  Megan
//
//  Created by Megan Lin on 2/29/24.
//

import SwiftUI

struct AddGroupView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(ModelData.self) var modelData
    @State var groupName: String
    @State var filterText: String = ""
    @State private var showAlert = false
    var edit = false
    
    var filteredDukePerson: [DukePerson] {
        
        var people: [DukePerson] = Array(modelData.DukePeople.values)
        let params = parseParams(filterText)
        people = filterDukePerson(all: people, params: params)
        
        return people
    }
    
    var body: some View {
        NavigationSplitView {
            HStack {
                Text("Group Name:").frame(width: 140)
                if edit {
                    TextField("", text: $groupName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 220, height: 50)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .disabled(true)
                } else {
                    TextField("", text: $groupName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 220, height: 50)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                }
                Spacer()
            }
            
            TextField("Filter", text: $filterText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 350, height: 50)
                .autocorrectionDisabled()
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            
            List {
                ForEach(filteredDukePerson, id: \.DUID) { person in
                    DukePersonRow(dukePerson: person)
                }
            }
            
            .toolbar {
                ToolbarItem (){
                    Button(action: {
                        saveGroup()
                    }) {
                        Text("Save")
                    }
                }
            }
            
        } detail: {
            Text("Create a New Group")
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"),
                message: Text("The group name already exists."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func saveGroup(){
        if !edit {
            var groupNamesSet = Set(modelData.DukePeople.map { $0.value.team })
            groupNamesSet.formUnion(modelData.Group.keys)
            
            if groupNamesSet.contains(groupName) {
                showAlert = true
                print("The group name already exists.")
                return
            }
        }
        modelData.Group[groupName] = parseParams(filterText)
        _ = People_Management_System.saveGroup(modelData.Group, str: modelData.auth)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    AddGroupView(groupName: "")
        .environment(ModelData())
}
