//
//  SettingsViewModel.swift
//  swiftUI_firebase
//
//  Created by Henrique Alves Batochi on 14/02/26.
//
import Combine
import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func deleteAccount() async throws {
        try await AuthenticationManager.shared.delete()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        try await AuthenticationManager.shared.updateEmail(email: "reset@testing.com")
    }
    
    func updatePassword() async throws {
        try await AuthenticationManager.shared.updatePassword(password: "Hello123!")
    }
    
    func linkGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkEmailAccount() async throws {
        let email = "hello123@gmail.com"
        let password = "Hello123"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
}
