//
//  StateManagementApp.swift
//  StateManagement
//
//  Created by Sai Pasumarthy on 09/04/23.
//

import SwiftUI

@main
struct StateManagementApp: App {
    var contentViewModel: ContentViewModel = ContentViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(contentViewModel: contentViewModel)
        }
    }
}
