//
//  ProgrammingLanguagePicker.swift
//  Megan
//
//  Created by Megan Lin on 2/25/24.
//

import SwiftUI





struct ProgrammingLanguagePicker: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(ModelData.self) var modelData
  
    @Binding var dukePerson: DukePerson
    @Binding var selectedLanguages: String
    @State var selectedArray: [String] = []
    
    @State private var firstChoice: String = "None"
    @State private var secondChoice: String = "None"
    @State private var thirdChoice: String = "None"
    @State private var number: Int = 1
        

    var body: some View {
        
        //let languageArray = selectedLanguages.components(separatedBy: ",")
        
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
                    selectedArray = []
                    if firstChoice != "" {
                        selectedArray.append(firstChoice)
                    }
                    if secondChoice != "" {
                        selectedArray.append(secondChoice)
                    }
                    if thirdChoice != "" {
                        selectedArray.append(thirdChoice)
                    }
                    selectedLanguages = selectedArray.joined(separator: ";")
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
                    selectedArray = []
                    if firstChoice != "" {
                        selectedArray.append(firstChoice)
                    }
                    if secondChoice != "" {
                        selectedArray.append(secondChoice)
                    }
                    if thirdChoice != "" {
                        selectedArray.append(thirdChoice)
                    }
                    selectedLanguages = selectedArray.joined(separator: ";")
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
                    selectedArray = []
                    if firstChoice != "" {
                        selectedArray.append(firstChoice)
                    }
                    if secondChoice != "" {
                        selectedArray.append(secondChoice)
                    }
                    if thirdChoice != "" {
                        selectedArray.append(thirdChoice)
                    }
                    selectedLanguages = selectedArray.joined(separator: ";")
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

            /*
            Button("OK") {
                print("ok")
                selectedLanguages = ""
                selectedArray = []
                if firstChoice != "" {
                    selectedArray.append(firstChoice)
                }
                if secondChoice != "" {
                    selectedArray.append(secondChoice)
                }
                if thirdChoice != "" {
                    selectedArray.append(thirdChoice)
                }
                selectedLanguages = selectedArray.joined(separator: ";")
                presentationMode.wrappedValue.dismiss()
            }
            .font(.title2)
            .bold()
             */
        }
 
        .onAppear {
            print("on appear")
            selectedArray = $selectedLanguages.wrappedValue.components(separatedBy: ";")
            firstChoice = $selectedArray.wrappedValue.indices.contains(0) ?  setInitialValue(for: _selectedArray.wrappedValue[0]) : "None"
            secondChoice = $selectedArray.wrappedValue.indices.contains(1) ?  setInitialValue(for: _selectedArray.wrappedValue[1]) : "None"
            thirdChoice = $selectedArray.wrappedValue.indices.contains(2) ?  setInitialValue(for: _selectedArray.wrappedValue[2]) : "None"
            selectedArray = [firstChoice, secondChoice, thirdChoice]
            selectedLanguages = selectedArray.joined(separator: ";")
            print(dukePerson.DUID)
            print(modelData.DukePeople.keys.contains(dukePerson.DUID))
            modelData.DukePeople[dukePerson.DUID]?.languages = selectedArray
        }
        .onDisappear {
            print("on disappear")
        }
    }
}

private func setInitialValue(for choice: String) -> String {
    print("choice")
    guard !choice.isEmpty else {
        return "None"
    }

    if let initialIndex = programmingLanguages.keys.sorted().firstIndex(where: { $0.caseInsensitiveCompare(choice) == .orderedSame }) {
        return programmingLanguages.keys.sorted()[initialIndex]
    } else {
        return "None"
    }
}

#Preview {
    let modelData = ModelData()
    let dukePeople = ModelData().DukePeople
    return ProgrammingLanguagePicker(dukePerson: .constant(dukePeople[829820]!), selectedLanguages: .constant(""))
        .environment(modelData)
}
