//
//  AuthStateManager.swift
//  ChineseChess
//
//  Created by Trần Ân on 23/7/24.
//

import Foundation
import Firebase

class AuthManager: ObservableObject {
    @Published var user: User?
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user {
                print("login")
                self.user = user
            }
            else {
                print("register")
                self.user = nil
            }
        }
    }
}
