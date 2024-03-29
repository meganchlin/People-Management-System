//
//  TeamRow.swift
//  Megan
//
//  Created by Megan Lin on 2/29/24.
//

import SwiftUI

struct GroupRow: View {
    var groupName: String
    var groupMember: [DukePerson]
    
    var body: some View {
        VStack(alignment: .leading) {
        Text(groupName)
            .font(.headline)
            .padding(.leading, 15)
            .padding(.top, 5)
            
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
    }
}

#Preview {
    GroupRow(groupName: "TripMaker", groupMember: [ModelData().DukePeople[829820]!])
}
