//
//  ChatTableView.swift
//  ChatBot
//
//  Created by Sai Pasumarthy on 14/03/24.
//

import SwiftUI

struct ChatTableView: View {
    let tables: [ChatTableData]
    let viewModel: ChatViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(tables, id: \.self) { table in
                HStack {
                    Text(table.title)
                    Spacer()
                    Text(table.subtitle)
                }
                .padding()
            }
        }
    }
}

//#Preview {
//    ChatTableView(tables: <#T##[ChatTableData]#>, viewModel: <#T##ChatViewModel#>)
//}
