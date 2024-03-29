//
//  TeamItem.swift
//  Megan
//
//  Created by Megan Lin on 2/29/24.
//

import SwiftUI

struct GroupItem: View {
    var dukePerson: DukePerson
    
    var body: some View {
        VStack(alignment: .leading) {
            imageFromString(dukePerson.picture)
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text("\(dukePerson.fName) \(dukePerson.lName)")
                .foregroundColor(.primary)
                .font(.system(size: 16))
        }
        .padding(.leading, 15)
    }
}

#Preview {
    GroupItem(dukePerson: ModelData().DukePeople[123456]!)
}

