//
//  ContentView.swift
//  PolymorphicSwiftUI
//
//  Created by Sai Pasumarthy on 14/06/23.
//

import SwiftUI

protocol ResponseTypeProtocol {
    init(title: String)
}

struct View1: View, ResponseTypeProtocol {
    private let title: String
    init(title: String) {
        self.title = title
    }
    var body: some View {
        Text(title)
    }
}

struct View2: View, ResponseTypeProtocol {
    private let title: String
    init(title: String) {
        self.title = title
    }
    var body: some View {
        Text(title)
    }
}

struct ResponsiveViewFactory {
    static func getResponsiveView(model: SampleModel) ->  some View {
        Group {
            switch model.responseType {
            case .responseType1:
                View1(title: model.title)
            case .responseType2:
                View2(title: model.title)
            }
        }
    }
}

enum ResponseType {
    case responseType1
    case responseType2
}

struct SampleModel: Identifiable {
    let id: UUID = UUID()
    let responseType: ResponseType
    let title: String
}

struct ContentView: View {
    let modelData: [SampleModel]
    var body: some View {
        VStack(spacing: 12) {
            ForEach(modelData, id: \.id) { data in
                VStack(spacing: 24) {
                    ResponsiveViewFactory.getResponsiveView(model: data)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(modelData: [
            SampleModel(responseType: .responseType1, title: "Response 1"),
            SampleModel(responseType: .responseType2, title: "Response 2")
        ]
        )
    }
}
