//
//  CreateAccountView.swift
//  clicker
//
//  Created by Reese Jednorozec on 1/27/25.
//

import SwiftUI
import FirebaseAuth

struct CreateAccountView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var accountCreated = false
    
    var body: some View {
        VStack {
            Text("Create Account")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 30)
                        
                        Form {
                            TextField("Email", text: $email)
                                .textContentType(.emailAddress)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                            
                            SecureField("Password", text: $password)
                                .textContentType(.newPassword)
                            
                            SecureField("Confirm Password", text: $confirmPassword)
                                .textContentType(.newPassword)
                        }
                        
                        if showError {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        Button("Create Account") {
                            createAccount()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                        
                        Spacer()
            }
        .navigationDestination(isPresented: $accountCreated) {
            ContentView()
        }
    }
    
    func createAccount() {
        // First validate passwords match
        guard password == confirmPassword else {
            showError = true
            errorMessage = "Passwords do not match"
            return
        }
        
        // Validate password length
        guard password.count >= 6 else {
            showError = true
            errorMessage = "Password must be at least 6 characters"
            return
        }
        
        // Create account with Firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                showError = true
                errorMessage = error.localizedDescription
            } else {
                // Account created successfully
                accountCreated = true
            }
        }
    }
}

#Preview {
    CreateAccountView()
}
