//
//  People_Management_SystemApp.swift
//  People Management System
//
//  Created by Megan Lin on 3/29/24.
//

import SwiftUI

@main
struct People_Management_SystemApp: App {
    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(modelData)
        }
    }
}
