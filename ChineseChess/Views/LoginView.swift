//
//  LoginView.swift
//  ChineseChess
//
//  Created by Trần Ân on 23/7/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State var isLoginPage = true
    @State var email = ""
    @State var password = ""
    @State var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 12) {
                    // Picker ---
                    Picker(selection: $isLoginPage,
                           label: Text("Picker herre")) {
                        Text("Login").tag(true)
                        Text("Create Account").tag(false)
                    }
                           .pickerStyle(SegmentedPickerStyle())
                           .padding()
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(Color.white)
                    // Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    // Login/Create Account Button
                    Button(action: {
                        handleAuthAction()
                    }) {
                        Text(isLoginPage ? "Login" : "Create Account")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    // Anonymous Login Button
                    Button(action: {
                        //                        loginAnonymously()
                    }) {
                        Text("Login Anonymously")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                }.padding()
            }
            .navigationTitle(isLoginPage ? "Login" : "Create account")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    // -----------FUNCTION--------------
    // Handle Authentication Action
    private func handleAuthAction() {
        if isLoginPage {
            login()
        } else {
            createAccount()
        }
    }
    
    private func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = "Failed to login: \(error.localizedDescription)"
                return
            }
            // Handle successful login
            errorMessage = nil
            print("Successfully logged in: \(result?.user.email ?? "No Email")")
        }
    }
    
    private func createAccount() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = "Failed to create account: \(error.localizedDescription)"
                return
            }
            // Handle successful account creation
            errorMessage = nil
            guard let user = result?.user else { return }
            print("Successfully created account: \(result?.user.email ?? "No Email")")
            saveUserData(user: user)
        }
        
    }
    private func saveUserData(user: User) {
            let db = Firestore.firestore()
            db.collection("users").document(user.uid).setData([
                "uid": user.uid,
                "email": user.email ?? ""
            ]) { error in
                if let error = error {
                    print("Error saving user data: \(error)")
                } else {
                    print("User data saved successfully")
                }
            }
        }
}

#Preview {
    LoginView()
}
