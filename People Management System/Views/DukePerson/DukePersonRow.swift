//
//  DukePersonRow.swift
//  Megan
//
//  Created by Megan Lin on 2/16/24.
//

import SwiftUI

struct DukePersonRow: View {
    @Environment(ModelData.self) var modelData
    @State private var showAddEditSheet = false
    @State var dukePerson: DukePerson
    //@Binding var refresh: Bool

    var body: some View {
        HStack (spacing: 10){
            CircleImage(image: imageFromString(dukePerson.picture))
                .scaleEffect(0.3)
                .frame(width: 100, height: 100)
            VStack (alignment: .leading, spacing: 5){
                HStack {
                    Text("\(dukePerson.fName) \(dukePerson.lName)")
                    Text("(\(dukePerson.netID))").font(.footnote)
                }
                
                HStack {
                    Text("DUID: \(String(dukePerson.DUID))")
                }.font(.footnote)
                
                Text("\(dukePerson.program.rawValue)    \(dukePerson.plan.rawValue)").font(.footnote)
                
                Text("email: \(dukePerson.email)").font(.footnote)
            }
            
            Spacer()

        }
        .swipeActions(edge: .trailing) {
            Button {
                showAddEditSheet = true
            } label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
        }
        .swipeActions(edge: .leading) {
            Button(role: .destructive) {
                deletePerson(DUID: dukePerson.DUID)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .sheet(isPresented: $showAddEditSheet){
            AddEditView(dukePerson: $dukePerson)
        }
    }
    
    private func deletePerson(DUID: Int) {
        @Bindable var Data = modelData
        Data.DukePeople[dukePerson.DUID] = nil
    }
    
}

#Preview {
    let modelData = ModelData()
    let dukePeople = ModelData().DukePeople
    return DukePersonRow(dukePerson: dukePeople[829820]!)//, refresh: .constant(false))
        .environment(modelData)
}
