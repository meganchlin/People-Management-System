//
//  AddEditView.swift
//  Megan
//
//  Created by Megan Lin on 2/24/24.
//

import SwiftUI

struct AddEditView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(ModelData.self) var modelData
    @Binding var dukePerson: DukePerson
    @State var uploadToServer: Bool = false
    var authStr: String {
        let defaults = UserDefaults.standard
        guard let authStr = defaults.object(forKey: "AuthString") as? String else {
            return ""
        }
        print("auth in addEditView: ", authStr)
        return authStr
    }
    
    @State var netID: String
    @State var fName: String
    @State var lName: String
    @State var from: String
    @State var hobby: String
    @State var languages: String
    @State var moviegenre: String
    @State var gender: Gender
    @State var role: Role
    @State var program: Program
    @State var plan: Plan
    @State var team: String
    @State var picture: String
    
    @State private var fullname: String = ""
    @State private var firstChoice: String = "None"
    @State private var secondChoice: String = "None"
    @State private var thirdChoice: String = "None"
    @State private var selectedArray: [String] = []
    @State private var number: Int = 1
    
    init(dukePerson: Binding<DukePerson>) {
        print("edit view init --------")
        _dukePerson = dukePerson
        _netID = State(initialValue: dukePerson.netID.wrappedValue)
        _fName = State(initialValue: dukePerson.fName.wrappedValue)
        _lName = State(initialValue: dukePerson.lName.wrappedValue)
        _from = State(initialValue: dukePerson.from.wrappedValue)
        _hobby = State(initialValue: dukePerson.hobby.wrappedValue)
        _languages = State(initialValue: dukePerson.languages.wrappedValue.joined(separator: ";"))
        _moviegenre = State(initialValue: dukePerson.moviegenre.wrappedValue)
        _gender = State(initialValue: dukePerson.gender.wrappedValue)
        _role = State(initialValue: dukePerson.role.wrappedValue)
        _program = State(initialValue: dukePerson.program.wrappedValue)
        _plan = State(initialValue: dukePerson.plan.wrappedValue)
        _team = State(initialValue: dukePerson.team.wrappedValue)
        _picture = State(initialValue: dukePerson.picture.wrappedValue)
    }
    
    var body: some View {
        NavigationSplitView {
            CircleImage(image: imageFromString(dukePerson.picture))
                .scaleEffect(0.3)
                .frame(width: 100, height: 100)
            List {
                Section (header: Text("Personal Info")){
                    HStack {
                        Text("NetID").frame(width: 90)
                        TextField("", text: $netID)
                            //.disabled(true)
                    }
                    HStack {
                        Text("Full Name").frame(width: 90)
                        TextField("", text: $fullname)
                    }
                    HStack {
                        Text("Gender").frame(width: 90)
                        Picker("", selection: $gender) {
                            ForEach(Array(Gender.allCases), id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 0.5))
                        
                    }
                    HStack {
                        Text("Role").frame(width: 90)
                        Picker("", selection: $role) {
                            ForEach(Array(Role.allCases), id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 0.5))
                    }
                    HStack {
                        Text("Program").frame(width: 90)
                        Picker("", selection: $program) {
                            ForEach(Array(Program.allCases), id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 0.5))
                    }
                    HStack {
                        Text("Plan").frame(width: 90)
                        Picker("", selection: $plan) {
                            ForEach(Array(Plan.allCases), id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 0.5))
                    }
                    HStack {
                        Text("Team").frame(width: 90)
                        TextField("", text: $team)
                    }
                    HStack {
                        Text("From").frame(width: 90)
                        TextField("", text: $from)
                    }
                    HStack {
                        VStack {
                            Text("Selected Languages: \(firstChoice ) (1st), \(secondChoice) (2nd), \(thirdChoice) (3rd)")
                                .padding()
                                .padding()
                            
                            Picker("Choices", selection: $number){
                                Text("First").tag(1)
                                Text("Second").tag(2)
                                Text("Third").tag(3)
                                
                            }.pickerStyle(.segmented)
                            
                            switch number {
                            case 1:
                                Picker("First Choice", selection: $firstChoice) {
                                    HStack {
                                        Text("")
                                            .font(.title)
                                        Text("None")
                                            .font(.headline)
                                            .padding(.leading, 10)
                                    }
                                    .tag("None") // Add an option for an empty choice
                                    ForEach(programmingLanguages.keys.sorted(), id: \.self) { language in
                                        HStack {
                                            Text(programmingLanguages[language] ?? "")
                                                .font(.title)
                                            Text(language)
                                                .font(.headline)
                                                .padding(.leading, 10)
                                        }
                                        .tag(language)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .padding()
                                .onChange(of: firstChoice, {
                                    print("Value 1 changed to \(firstChoice)")
                                    //selectedLanguages = ""
                                    selectedArray[0] = firstChoice
                                    languages = selectedArray.joined(separator: ";")
                                })
                                
                            case 2:
                                Picker("Second Choice", selection: $secondChoice) {
                                    HStack {
                                        Text("")
                                            .font(.title)
                                        Text("None")
                                            .font(.headline)
                                            .padding(.leading, 10)
                                    }
                                    .tag("None") // Add an option for an empty choice
                                    ForEach(programmingLanguages.keys.sorted(), id: \.self) { language in
                                        HStack {
                                            Text(programmingLanguages[language] ?? "")
                                                .font(.title)
                                            Text(language)
                                                .font(.headline)
                                                .padding(.leading, 10)
                                        }
                                        .tag(language)
                                        
                                    }
                                }
                                .pickerStyle(.wheel)
                                .padding()
                                .onChange(of: secondChoice, {
                                    print("Value 2 changed to \(secondChoice)")
                                    //selectedLanguages = ""
                                    selectedArray[1] = secondChoice
                                    languages = selectedArray.joined(separator: ";")
                                })
                                
                            case 3:
                                Picker("Third Choice", selection: $thirdChoice) {
                                    HStack {
                                        Text("")
                                            .font(.title)
                                        Text("None")
                                            .font(.headline)
                                            .padding(.leading, 10)
                                    }
                                    .tag("None") // Add an option for an empty choice
                                    ForEach(programmingLanguages.keys.sorted(), id: \.self) { language in
                                        HStack {
                                            Text(programmingLanguages[language] ?? "")
                                                .font(.title)
                                            Text(language)
                                                .font(.headline)
                                                .padding(.leading, 10)
                                        }
                                        .tag(language)
                                        
                                    }
                                }
                                .pickerStyle(.wheel)
                                .padding()
                                .onChange(of: thirdChoice, {
                                    print("Value 3 changed to \(thirdChoice)")
                                    //selectedLanguages = ""
                                    selectedArray[2] = thirdChoice
                                    languages = selectedArray.joined(separator: ";")
                                })
                                
                            default:
                                Picker("First Choice", selection: $firstChoice) {
                                    Text("None").tag("None") // Add an option for an empty choice
                                    ForEach(programmingLanguages.keys.sorted(), id: \.self) { language in
                                        HStack {
                                            Text(programmingLanguages[language] ?? "")
                                                .font(.title)
                                            Text(language)
                                                .font(.headline)
                                                .padding(.leading, 10)
                                        }
                                        .tag(language)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .padding()
                            }
                        }
                    }
                    HStack {
                        Text("Hobby").frame(width: 90)
                        TextField("", text: $hobby)
                    }
                    HStack {
                        Text("Movie Genre").frame(width: 90)
                        TextField("", text: $moviegenre)
                    }
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocorrectionDisabled()
                .autocapitalization(.none)
            }
            .toolbar {
                ToolbarItem() {
                    if dukePerson.netID == modelData.auth {
                        Toggle(isOn: $uploadToServer) {
                            Image(systemName: uploadToServer ? "square.and.arrow.up.fill" : "square.and.arrow.up")
                            //.font(.system(size: 50))
                        }
                        .tint(.blue)
                        .toggleStyle(.button)
                        .clipShape(Circle())
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        savePerson()
                    }, label: {
                        Text("Save")
                    })
                    .padding(10)
                }
                
            }
        } detail: {
            Text("Add/Edit a DukePerson")
        }
        .onAppear {
            print("on appear")
            fullname = fName + " " + lName
            selectedArray = languages.components(separatedBy: ";")
            firstChoice = selectedArray.indices.contains(0) ?  setInitialValue(for: selectedArray[0]) : "None"
            secondChoice = selectedArray.indices.contains(1) ?  setInitialValue(for: selectedArray[1]) : "None"
            thirdChoice = selectedArray.indices.contains(2) ?  setInitialValue(for: selectedArray[2]) : "None"
            selectedArray = [firstChoice, secondChoice, thirdChoice]
            languages = selectedArray.joined(separator: ";")
            print(dukePerson.DUID)
            print(modelData.DukePeople.keys.contains(dukePerson.DUID))
            modelData.DukePeople[dukePerson.DUID]?.languages = selectedArray
        }
        .onDisappear{
            print("edit view disappear")
        }
    }
        
    private func savePerson() {
        //@Bindable var Data = modelData]
        fullname = fullname.trimmingCharacters(in: .whitespaces)
        if fullname.count > 0 {
            let name = fullname.components(separatedBy: " ")
            fName = name[0]
            if name.count > 1{
                lName = name[name.count - 1]
            } else {
                lName = ""
            }
        } else {
            fName = ""
            lName = ""
        }
        dukePerson = DukePerson(DUID: dukePerson.DUID, netid: netID, fName: fName, lName: lName, from: from, hobby: hobby,  languages: languages, moviegenre: moviegenre, gender: gender.rawValue, role: role.rawValue, plan: plan.rawValue, program: program.rawValue, team: team, picture: picture)
        modelData.DukePeople[dukePerson.DUID] = dukePerson
        _ = save(modelData.DukePeople.map{$0.value}, str: modelData.auth)
        if uploadToServer {
            uploadSelf(user: dukePerson)
        }
        presentationMode.wrappedValue.dismiss()
    }
    
    private func setInitialValue(for choice: String) -> String {
        //print("choice")
        guard !choice.isEmpty else {
            return "None"
        }

        if let initialIndex = programmingLanguages.keys.sorted().firstIndex(where: { $0.caseInsensitiveCompare(choice) == .orderedSame }) {
            return programmingLanguages.keys.sorted()[initialIndex]
        } else {
            return "None"
        }
    }
    
    private func uploadSelf(user: DukePerson){
        let auth = authStr.split(separator: ":")
        
        let urlStr = "" + auth[0]
            
        _ = ModelData().upload(website: urlStr, auth: authStr, person: user, update: true)
    }

}

#Preview {
    let modelData = ModelData()
    let dukePeople = ModelData().DukePeople
    return AddEditView(dukePerson: .constant(dukePeople[123456]!))
        .environment(modelData)
}
