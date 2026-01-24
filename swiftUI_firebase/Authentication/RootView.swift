//
//  RootView.swift
//  swiftUI_firebase
//
//  Created by Henrique Alves Batochi on 17/12/25.
//

import SwiftUI

struct RootView: View {

    @State private var showSignInView: Bool =  false
    
    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showSignView: $showSignInView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    RootView()
}
