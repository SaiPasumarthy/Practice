//
//  PolymorphicSwiftUIApp.swift
//  PolymorphicSwiftUI
//
//  Created by Sai Pasumarthy on 14/06/23.
//

import SwiftUI

@main
struct PolymorphicSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(modelData: [
                SampleModel(responseType: .responseType1, title: "Response 1"),
                SampleModel(responseType: .responseType2, title: "Response 2")
            ]
            )
        }
    }
}
