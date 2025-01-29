//
//  LogInView.swift
//  clicker
//
//  Created by Reese Jednorozec on 1/25/25.
//

import SwiftUI
import FirebaseAuth

struct LogInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isLoggedIn = false
    
    
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
                Text("Log In")
                    .font(.largeTitle)
                        .bold()
                Spacer()
                Form {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                            .autocapitalization(.none)
                                        
                    SecureField("Password", text: $password)
                        .textContentType(.password)
                }
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                            .padding()
                }
                
                Button("Log In") {
                    login()
                }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .navigationDestination(isPresented: $isLoggedIn) {
                        ContentView()
                    }
                
                Spacer()
                NavigationLink("Create Account") {
                    CreateAccountView()
                }
                Spacer()
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                    showError = true
                    errorMessage = error.localizedDescription
                } else {
                    isLoggedIn = true  
            }
        }
    }
}

#Preview {
    LogInView()
}
