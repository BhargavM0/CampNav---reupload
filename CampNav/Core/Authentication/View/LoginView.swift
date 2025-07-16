//
//  LoginView.swift
//  CampNav
//
//  Created by Zahir Rivas on 1/14/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isShowingPopup: Bool = false
    @State private var isLoginErrorPresented: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToProfile: Bool = false // Track navigation to ProfileView



    @State private var path: [String] = []
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationStack (path: $path) {
            VStack {
                // image
                
                
                
                // form fields
                VStack(spacing: 24) {
                    InputView(text: $email, title: "Email Address", placeholder: "name@example.com")
                        .autocapitalization(.none)
                    
                    InputView(text: $password, title: "Password", placeholder: "Enter your password", isSecureField: true)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                
                
                // sign in button
                Button {
                    Task {
                        do {
                            try await viewModel.signIn(withEmail: email, password: password)
                            
                            if let currentUser = Auth.auth().currentUser, !currentUser.isEmailVerified {
                                alertMessage = "Please verify your email address before logging in."
                                isLoginErrorPresented = true // Show the alert
                            } else {
                                navigateToProfile = true
                            }
                        } catch {
                                
                            let nsError = error as NSError
                            if let authErrorCode = AuthErrorCode.init(rawValue: nsError.code) {
                                
                                switch authErrorCode {
                                case .wrongPassword:
                                    alertMessage = "Invalid password. Please Try again!"
                                    isLoginErrorPresented = true
                                case .userNotFound:
                                    alertMessage = "This email address is not registered. Please try again!"
                                    isLoginErrorPresented = true
                                default:
                                    alertMessage = "An unknown error occurred. Please try again!"
                                    isLoginErrorPresented = true
                                }
                            }
                        }
                    }
                } label: {
                    HStack{
                        Text("SIGN IN")
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
                .padding(.bottom, 5)
                
                // test
                .alert(isPresented: $isLoginErrorPresented) {
                    Alert(
                        title: Text("Error"),
                        message: Text(alertMessage),
                        primaryButton: .default(Text("Resend email")) {
                            Task {
                                do {
                                    try await viewModel.resendEmailVerification()
                                } catch {
                                    print("DEBUG: Failed to resend verification email.")
                                }
                            }
                        },
                        secondaryButton: .cancel(Text("Cancel"))
                    )
                }
                .navigationDestination(isPresented: $navigateToProfile) {
                    HomePageView()
                }
                
                
                
                
                // navigate user to home page as guest (data not saved)
                Button {
                    isShowingPopup = true //trigger the popup
                } label: {
                    HStack (spacing: 3){
                        Text("use CampNav as a ")
                            .foregroundColor(.gray)
                        Text("guest")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                    }
                }
                .font(.system(size: 14 ))
                // alert button confirming data wont be saved
                .alert("Are you sure you want to log in as a guest? All your data will be lost!", isPresented: $isShowingPopup){
                    Button("Register") {
                        path.append("register")
                    }
                    
                    Button("Continue anyways") {
                        path.append("home")
                    }
                }
                
                NavigationLink {
                    ForgotPasswordView()
                } label: {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                

                
                Spacer()
                
                Button {
                    path.append("register")
                } label: {
                    HStack (spacing: 3){
                        Text("Don't have an account?")
                        Text("Sign Up!")
                            .fontWeight(.bold)
                    }
                }
                .font(.system(size: 14))
                
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "register" {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(viewModel)
                } else if destination == "home" {
                    HomePageView()
                }
            }
        }
    }
}

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty && email.contains("@") && !password.isEmpty && password.count > 5
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
