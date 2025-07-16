//
//  ForgotPassword.swift
//  CampNav
//
//  Created by Zahir Rivas on 1/15/25.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var showAlert = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("A reset password link will be sent to your email if it exists.")
                .font(.caption)
                .fontWeight(.medium)
            
            InputView(text: $email, title: "Email Address", placeholder: "Enter your email address")
                .autocapitalization(.none)
                .padding()
            
            Button {
                resetPassword()
            } label: {
                Text("Send Reset Link")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
            }
            .disabled(email.isEmpty || !email.contains("@"))
            
            Spacer()

        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Reset Password"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) {
            error in if let error = error {
                alertMessage = "Failed to send reset link \(error.localizedDescription)"
            } else {
                alertMessage = "A reset link has been sent to \(email)."
                showAlert = true
            }
        }
    }
}

#Preview {
    ForgotPasswordView()
}
