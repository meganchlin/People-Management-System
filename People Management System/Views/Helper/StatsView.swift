//
//  StatsView.swift
//  Megan
//
//  Created by Megan Lin on 2/24/24.
//

import SwiftUI

struct StatsView: View {
    @Environment(ModelData.self) var modelData
    
    var body: some View {
        
        VStack {
            Text("Total: \(modelData.DukePeople.keys.count) people").bold()
            List {
                Section(header: Text("Program").bold()) {
                    ForEach(programData.sorted(by: { $0.key < $1.key }), id: \.key) { programEntry in
                        Text("\(programEntry.key): \(programEntry.value)")
                            .padding()
                            .cornerRadius(8)
                        }
                    }
                    Section(header: Text("Plan").bold()){
                        ForEach(planData.sorted(by: { $0.key < $1.key }), id: \.key) { planEntry in
                            Text("\(planEntry.key): \(planEntry.value)")
                                .padding()
                                .cornerRadius(8)
                    }
                }
            }
            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        }
        .padding()
        .foregroundColor(.white)
        .background(.blue.gradient)
        
    }
    
    var programData: [String: Int] {
        var data: [String: Int] = [:]
        for prog in Program.allCases {
            let tmp = modelData.DukePeople.values.filter { $0.program.rawValue == prog.rawValue}
            if !tmp.isEmpty {
                data[prog.rawValue] = tmp.count
            }
        }
        return data
    }
    
    var planData: [String: Int] {
        var data: [String: Int] = [:]
        for plan in Plan.allCases {
            let tmp = modelData.DukePeople.values.filter { $0.plan.rawValue == plan.rawValue}
            if !tmp.isEmpty {
                data[plan.rawValue] = tmp.count
            }
        }
        return data
    }
}

#Preview {
    StatsView()
        .environment(ModelData())
}
