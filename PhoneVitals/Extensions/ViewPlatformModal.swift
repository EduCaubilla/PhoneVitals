//
//  ViewPlatformModal.swift
//  PhoneVitals
//
//  Created by Edu Caubilla on 31/10/25.
//

import SwiftUI

extension View {
    func platformModal(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> some View) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return AnyView(
                self.fullScreenCover(isPresented: isPresented, content: content)
            )
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(
                self.sheet(isPresented: isPresented, content: content)
            )
        }
        return AnyView(self)
    }
}
