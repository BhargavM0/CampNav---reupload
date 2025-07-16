//
//  EmailVerificationView.swift
//  CampNav
//
//  Created by Zahir Rivas on 1/15/25.
//

// not being used at the moment
import SwiftUI

struct EmailVerificationView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack (spacing: 20) {
            Text("Email Verification")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button ("Resend Email Verification") {
                Task {
                    do {
                        try await viewModel.resendEmailVerification()
                        alertMessage = "Verification email sent."
                    } catch {
                        alertMessage = "Failed to send verification email. Please try again later."
                    }
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Verification Email"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Button ("Sign Out") {
                viewModel.signOut()
            }
            .foregroundColor(.red)
        }
        .padding()
    }
}

#Preview {
    EmailVerificationView()
}
