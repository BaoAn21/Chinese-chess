//
//  MenuView.swift
//  ChineseChess
//
//  Created by Trần Ân on 23/7/24.
//

import SwiftUI
import Firebase

struct MenuView: View {
    private var db = Firestore.firestore()
    @State var showCreatedGame = false
    @State var userName: String = ""
    @State var userId: String = ""
    @State var gameList = [Game]()
    @State var realtimeListener: ListenerRegistration?
    
    var body: some View {
        NavigationStack {
            if userName.isEmpty {
                Text("Loading user...")
            } else {
                Text("Welcome, \(userName)!")
            }
            Divider()
            VStack(alignment: .leading) {
                if gameList.isEmpty {
                    Text("There is no game right now")
                } else {
                    ScrollView {
                        VStack(alignment:.leading) {
                            ForEach(gameList) { game in
                                VStack(alignment: .leading){
                                    NavigationLink {
                                        PlayView(game: game)
                                    } label: {
                                        GameInfoView(game: game)
                                        Divider()
                                    }
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                    
                }
            }
            .navigationTitle("Game List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreatedGame = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                fetchGames()
                fetchUserName()
            }
            .sheet(isPresented: $showCreatedGame, content: {
                CreateNewGameView()
            })
            .onDisappear {
                realtimeListener?.remove()
                realtimeListener = nil
                print("da out roi?")
            }
        }
    }
    
    // -------------FUNCTION-----------
    private func fetchGames() {
         realtimeListener = db.collection("games").addSnapshotListener { querySnapshot, error in
            print("fetch game is called")
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            gameList = documents.compactMap { queryDocumentSnapshot -> Game? in
                do {
                    let game = try queryDocumentSnapshot.data(as: Game.self)
                    return game
                } catch {
                    print(error)
                    return nil
                }
            }
        }
    }
    
    private func fetchUserName() {
        if let user = Auth.auth().currentUser {
            print("current user fetch")
            self.userId = user.uid
            self.userName = user.email ?? "No Name"
        } else {
            print("No user is signed in.")
        }
    }
}

#Preview {
    MenuView()
}
