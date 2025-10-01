//
//  ContentView.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 1/10/25.
//

import SwiftUI
import SwiftData

struct MainSystemDataView: View {
    //MARK: - PROPERTIES
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [SystemDataProfile]

    //MARK: - BODY
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.green, .white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 10) {
                    //MARK: - Section Overview
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Overview")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, -5)
                    }

                    //MARK: - Section Device Information
                    //MARK: - Section Thermal State
                    //MARK: - Section Battery
                    //MARK: - Section Storage
                    //MARK: - Section RAM Memory
                    //MARK: - Section CPU

                    Spacer()
                }
                .navigationTitle(Text("Phone Vitals"))
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(.clear)
        }
    }

    //MARK: - FUNCTIONS
    private func addItem() {
        withAnimation {
            let newItem = SystemDataProfile(timestamp: Date())
            modelContext.insert(newItem)
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

//MARK: - PREVIEW
#Preview {
    MainSystemDataView()
        .modelContainer(for: SystemDataProfile.self, inMemory: true)
}
