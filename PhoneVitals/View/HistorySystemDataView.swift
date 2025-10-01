//
//  HistorySystemDataView.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import SwiftUI
import SwiftData

struct HistorySystemDataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [SystemDataProfile]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    HistorySystemDataView()
        .modelContainer(for: SystemDataProfile.self, inMemory: true)
}
