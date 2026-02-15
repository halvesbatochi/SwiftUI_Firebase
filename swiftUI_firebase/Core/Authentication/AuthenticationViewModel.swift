//
//  AuthenticationViewModel.swift
//  swiftUI_firebase
//
//  Created by Henrique Alves Batochi on 14/02/26.
//
import Combine

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        try await UserManager.shared.createNewUser(auth: authDataResult)
    }
}
