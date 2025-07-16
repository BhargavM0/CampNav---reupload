//
//  AuthViewModel.swift
//  CampNav
//
//  Created by Zahir Rivas on 1/15/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

enum SignInError: Error {
    case emailNotVerified
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var navigateToProfile: Bool = false // Track if navigation is required

    
    init() {
        if let user = Auth.auth().currentUser {
            if user.isEmailVerified {
                self.userSession = user
                navigateToProfile = true // Navigate to ProfileView
                
                Task {
                    await fetchUser()
                }
                
            } else {
                self.userSession = nil
                self.currentUser = nil
            }
        } else {
            self.userSession = nil
            self.currentUser = nil
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            let user = result.user
            if !user.isEmailVerified {
                try Auth.auth().signOut()
                throw SignInError.emailNotVerified // Use custom error for email verification

            }
            
            self.userSession = result.user
            navigateToProfile = true
            await fetchUser()
        } catch {
            print("DEBUG: failed to log in with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser (withEmail email: String, password: String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            self.userSession = result.user
            // sends user verification email
            if let user = Auth.auth().currentUser {
                try await user.sendEmailVerification()
            }
            
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            try Firestore.firestore().collection("users").document(user.id).setData(from: user)
            await fetchUser()
            
            
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    
    func signOut() {
        do {
            try Auth.auth().signOut() // signs out user on backend
            navigateToProfile = false
            self.userSession = nil // wipes out user session
            self.currentUser = nil // wipes out current user data model
        } catch {
            print("DEBUG: failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    
    
    
    func fetchUser() async {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
    
    
    func resendEmailVerification() async throws {
        if let user = Auth.auth().currentUser {
            do {
                try await user.sendEmailVerification()
            } catch {
                print("DEBUG: failed to resend email verification with error \(error.localizedDescription)")
                throw error
            }
        }
    }
}
