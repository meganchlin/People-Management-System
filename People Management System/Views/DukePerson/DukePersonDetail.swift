//
//  DukePersonDetail.swift
//  Megan
//
//  Created by Megan Lin on 2/16/24.
//

import SwiftUI

struct DukePersonDetail: View {
    // @Environment(ModelData.self) var modelData
    var dukePerson: DukePerson

    var body: some View {
        if (dukePerson.DUID == 123456) {
            MeView(dukePerson: dukePerson)
        } else {
            ScrollView {
                CircleImage(image: imageFromString(dukePerson.picture))
                    .scaleEffect(0.8)
                    .frame(width: 250, height: 250)
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                
                VStack(spacing: 20) {
                    HStack {
                        Text("\(dukePerson.fName) \(dukePerson.lName)")
                            .font(.title)
                            .bold()
                    }
                    
                    HStack {
                        Text(dukePerson.role.rawValue)
                        Spacer()
                        Text(dukePerson.program.rawValue)
                        Text(dukePerson.plan.rawValue)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    
                    Divider()
                    
                    Text("About")
                        .font(.title2)
                    Text(dukePerson.description)
                }
                .padding()
            }
            .navigationTitle(dukePerson.netID)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let modelData = ModelData()
    return DukePersonDetail(dukePerson: modelData.DukePeople[829820]!)
        //.environment(modelData)
}
