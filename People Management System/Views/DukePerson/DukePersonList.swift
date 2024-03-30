//
//  DukePersonList.swift
//  Megan
//
//  Created by Megan Lin on 2/16/24.
//

import SwiftUI
import PopupView


struct DukePersonList: View {
    @Environment(ModelData.self) var modelData
    @State private var searchText: String = ""
    @State private var showAlert = false
    @State private var showStats = false
    @State private var showHelp = false
    @State private var showDownloadSheet = false
    @State private var showAddEditSheet = false
    //@State private var refresh = false
    
    @State private var editPerson: DukePerson = DukePerson(DUID: 0)
    
    let role: [Role] = [.Professor, .TA, .Student, .Other, .Unknown]
    
    var filteredDukePerson: [DukePerson] {
        if searchText.contains("=") {
            var people: [DukePerson] = Array(modelData.DukePeople.values)
            let params = parseParams(searchText)
            
            if params.isEmpty {
                return []
            }
                
            for param in params {
                if param.key == "la" {
                    let tmp = param.value.split(separator: ";")
                    var langs: [String] = []
                    for language in tmp {
                        langs.append(language.trimmingCharacters(in: .whitespaces))
                    }
                    print(langs)
                    people = people.filter { person in
                        param.value.isEmpty ||
                           langs.allSatisfy { language in
                               person.languages.contains {
                                   personLanguage in
                                        return language.caseInsensitiveCompare(personLanguage) == .orderedSame
                               }
                           }
                    }
                } else {
                    people = people.filter { person in
                        param.value.isEmpty || {
                            if let val = (Mirror(reflecting: person).children.first { prop in
                                prop.label!.lowercased().hasPrefix(param.key) == true
                            })?.value {
                                if let check = val as? String {
                                    return check.range(of: param.value, options: .caseInsensitive) != nil
                                } else if let enumValue = val as? (any EnumWithRawValue), let rawValue = enumValue.rawValue as? String {
                                    return rawValue.range(of: param.value, options: .caseInsensitive) != nil
                                } else {
                                    return false
                                }
                            } else {
                                return false
                            }
                        }()
                    }
                }
            }
            return people
        } else {
            return modelData.DukePeople.values.filter {
                searchText.isEmpty || $0.description.range(of: searchText, options: .caseInsensitive) != nil
            }
        }
    }
    
    
    

    var body: some View {
        NavigationSplitView {
            HStack (spacing: 20) {
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 50)
                    .autocorrectionDisabled()
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                   
                Button(action: {
                    showHelp = true
                }, label: {
                    Label("", systemImage: "questionmark.bubble")
                })
            }

            

            List {
                ForEach(role, id:\.self){ role in
                    Section(header: Text("\(role.rawValue)").bold()) {
                        ForEach(filteredDukePerson.filter { $0.role == role }, id: \.DUID)
                        { person in
                            NavigationLink {
                                DukePersonDetail(dukePerson: person)
                            } label: {
                                DukePersonRow(dukePerson: person)//, refresh: $refresh)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showDownloadSheet = true
                    }, label: {
                        Label("Download", systemImage: "arrow.clockwise")
                    })
                }
                
                ToolbarItem (){
                    Button(action: {
                        showAddEditSheet = true
                        editPerson = DukePerson(DUID: randomDUID(maximumValue: 1300000, excludedNumbers: Array(modelData.DukePeople.keys)))
                        //editPerson = DukePerson()
                    }) {
                        Label("Add Person", systemImage: "plus")
                    }
                }
                
                ToolbarItem (placement: .navigationBarTrailing){
                    Button(action: {
                        showStats = true
                    }) {
                        Label("stats", systemImage: "list.clipboard")
                    }
                    .popover(isPresented: $showStats){
                        StatsView()
                            .frame(width: 300, height: 400)
                            .presentationCompactAdaptation(.none)
                    }
                }
            }
            .navigationBarTitle(Text("People Management"), displayMode: .inline)
            .animation(.default, value: filteredDukePerson)
        } detail: {
            Text("Select a Person")
        }
        .actionSheet(isPresented: $showDownloadSheet) {
            ActionSheet(
                title: Text("Download?"),
                // message: Text("You can't undo this action."),
                buttons:[
                    //.destructive(Text("Empty Trash"),
                    //            action: emptyTrashAction),
                    .destructive(
                        Text("Download and Replace"),
                        action: {
                            showAlert = true
                            downloadList(upload: false)
                        }
                    ),
                    .default(
                        Text("Download and Update"),
                        action: {
                            showAlert = true
                            downloadList(upload: true)
                        }
                    ),
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showAddEditSheet) {
            AddEditView(dukePerson: $editPerson)
        }
        .popup(isPresented: $showHelp) {
            Text(helpMessage)
                .padding(10)
                .frame(width: 300, height: 600)
                .background(Color(red: 0.8, green: 0.8, blue: 0.95))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .cornerRadius(30.0)
        }
        .alert(isPresented: $showAlert) {
            if modelData.downloadState {
                Alert(title: Text("In progress ..."),
                      message: Text(""),
                      dismissButton: .destructive(Text("Cencel"),
                            action: {modelData.cancelDownload()})
                )
            } else {
                Alert(
                    title: Text(modelData.downloadResult ? "Success" : "Failed"),
                    message: Text(modelData.downloadMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    
    
    private func downloadList(upload: Bool) {
        let urlStr = ""
        let authStr = ""
            
        _ = modelData.download(website: urlStr, auth: authStr, delegate: nil, upload: upload)
        
    }

}




#Preview {
    DukePersonList()
        .environment(ModelData())
}
