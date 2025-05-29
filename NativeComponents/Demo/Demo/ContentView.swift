//
//  ContentView.swift
//  Demo
//
//  Created by Sai Pasumarthy on 29/05/25.
//

import SwiftUI
import NativeComponents

struct ContentView: View {
    @State private var textFieldText = ""
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("NativeComponents Demo")
                    .font(.title)
                    .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("SPTextField Example")
                        .font(.headline)
                    
                    SPTextField(
                        placeholder: "Enter some text",
                        text: $textFieldText
                    )
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("SPButton Examples")
                        .font(.headline)
                    
                    SPButton(title: "Primary Button") {
                        isLoading.toggle()
                    }
                    
                    SPButton(title: "Secondary Button", style: .secondary) {
                        print("Secondary button tapped")
                    }
                    
                    SPButton(title: "Disabled Button", isEnabled: false) {
                        print("This won't be called")
                    }
                }
                .padding()
                
                if isLoading {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Loading Spinner Example")
                            .font(.headline)
                        
                        HStack {
                            SPLoadingSpinner(color: .blue, size: 40)
                            Text("Loading...")
                        }
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
