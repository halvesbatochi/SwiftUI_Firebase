//
//  AuthenticationManager.swift
//  swiftUI_firebase
//
//  Created by Henrique Alves Batochi on 17/12/25.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        
        return AuthDataResultModel(user: user)
    }
    
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let auth = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: auth.user)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
