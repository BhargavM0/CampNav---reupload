//
//  RegistrationView.swift
//  CampNav
//
//  Created by Zahir Rivas on 1/14/25.
//

import SwiftUI
import FirebaseAuth


struct RegistrationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullName = ""
    @State private var confirmPassword: String = ""
    @State private var showVerification = false
    @State private var isEmailVerified = false
    @State private var navigateToHome = false
    @State private var timer: Timer?
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    
    
    var body: some View {
            VStack{
                // image
                
                // form field
                
                VStack(spacing: 24) {
                    // full name
                    InputView(text: $fullName, title: "Full Name", placeholder: "Enter your name")
                    
                    // email
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    // password
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                    
                    // confirm password
                    ZStack (alignment: .trailing) {
                        InputView(text: $confirmPassword, title: "Confirm Password", placeholder: "Confirm your password", isSecureField: true)
                        
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemGreen))
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(.systemRed))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
                Button  {
                    Task {
                        try await viewModel.createUser(withEmail: email, password: password, fullName: fullName)
                        
                        if let currentUser = Auth.auth().currentUser, !currentUser.isEmailVerified {
                            showVerification = true
                        }
                    }
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                
                Button {
                    dismiss()
                } label: {
                    HStack (spacing: 3){
                        Text("Already have an account?")
                        Text("Sign In!")
                            .fontWeight(.bold)
                    }
                }
                .font(.system(size: 14 ))
            }
            .alert(isPresented: $showVerification) {
                Alert(
                    title: Text("Email verification pending"),
                    message: Text("Please verify your email to complete your registration."),
                    primaryButton: .default(Text("Resend email")) {
                        resendVerification()
                    },
                    secondaryButton: .cancel(Text("Cancel"))
                )
            }
            .onAppear { startVerificationTimer() }
            .onDisappear { timer?.invalidate() }
            .navigationDestination(isPresented: $navigateToHome){
                HomePageView()
            }
        }
    
    
    
    
    
        
        func startVerificationTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in guard let currentUser = Auth.auth().currentUser else { return }
                checkEmailVerification(currentUser)
            }
        }
        
        
        func checkEmailVerification(_ user: FirebaseAuth.User) {
            if user.isEmailVerified {
                isEmailVerified = true
                navigateToHome = true
                timer?.invalidate()
            }
        }
        
        func resendVerification() {
            Task {
                do {
                    try await viewModel.resendEmailVerification()
                } catch {
                    print("DEBUG: Error resending verification email: \(error.localizedDescription)")
                }
            }
        }
        
    }



extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && !fullName.isEmpty
        && confirmPassword == password
    }
}

#Preview {
    RegistrationView()
}
