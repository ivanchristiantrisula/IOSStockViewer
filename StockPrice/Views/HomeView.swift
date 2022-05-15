//
//  HomeView.swift
//  StockPrice
//
//  Created by Ivan Christian on 13/05/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct GridData: Identifiable, Equatable {
    let id = UUID()
    let ticker : String
}

//MARK: - Model

class Model: ObservableObject {
    @Published var data: [GridData]

    let columns = [
        GridItem(.fixed(160)),
        GridItem(.fixed(160))
    ]

    init() {
        self.data = [
            GridData(ticker: "SPY"),
            GridData(ticker: "QQQ"),
            GridData(ticker: "MSFT"),
            GridData(ticker: "AAPL")
        ]
    }
    
    func removeTicker(data : GridData) {
        self.data = self.data.filter{$0 != data}
    }
}

//MARK: - Grid

struct HomeView: View {
    @StateObject private var model = Model()

    @State private var dragging: GridData?

    var body: some View {
        ScrollView {
           LazyVGrid(columns: model.columns, spacing: 32) {
                ForEach(model.data) { d in
                    StockCardView(vm: HomeViewModel(d.ticker))
                        .overlay(dragging?.id == d.id ? Color.white.opacity(0.8) : Color.clear)
                        .onDrag {
                            self.dragging = d
                            return NSItemProvider(object: String(d.id.uuidString) as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: DragRelocateDelegate(item: d, listData: $model.data, current: $dragging))
                        .contextMenu{
                            Button {
                                model.removeTicker(data: d)
                            } label: {
                                Label("Remove", systemImage : "trash")
                            }

                        }
                }
            }.animation(.default, value: model.data)
        }
        .padding()
        .navigationTitle("Watchlist")
    }
}

struct DragRelocateDelegate: DropDelegate {
    let item: GridData
    @Binding var listData: [GridData]
    @Binding var current: GridData?

    func dropEntered(info: DropInfo) {
        if item != current {
            let from = listData.firstIndex(of: current!)!
            let to = listData.firstIndex(of: item)!
            if listData[to].id != current!.id {
                listData.move(fromOffsets: IndexSet(integer: from),
                    toOffset: to > from ? to + 1 : to)
            }
        }
    }

    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }

    func performDrop(info: DropInfo) -> Bool {
        self.current = nil
        return true
    }
}
