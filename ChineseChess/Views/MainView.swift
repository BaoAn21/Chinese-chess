//
//  MainView.swift
//  ChineseChess
//
//  Created by Trần Ân on 23/7/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var authStateManager = AuthManager()
    
    var body: some View {
        if authStateManager.user != nil {
            MenuView()
        } else {
            LoginView()
        }
    }
    
    
    
}

#Preview {
    MainView()
}
