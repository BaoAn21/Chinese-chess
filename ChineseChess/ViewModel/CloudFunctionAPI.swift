//
//  CloudFunctionAPI.swift
//  ChineseChess
//
//  Created by Trần Ân on 27/7/24.
//

import Foundation

struct CloudFunctionAPI {
    static func getValidMoves(gameId: String, completion: @escaping (Result<[String], Error>) -> Void) {
        // Define the URL of your Cloud Function endpoint
        guard let url = URL(string: "https://getlegitmoves-o7dsehv4jq-uc.a.run.app?gameId=\(gameId)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET" // Use GET method
        
        // Create the URLSession
        let session = URLSession.shared
        
        // Create the data task
        let task = session.dataTask(with: request) { data, response, error in
            // Handle any errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check if the response is valid
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            // Ensure we have data
            guard let data = data else {
                completion(.failure(URLError(.unknown)))
                return
            }
            
            do {
                // Decode the JSON response into ValidMove struct
                let validMoveResponse = try JSONDecoder().decode(ValidMove.self, from: data)
                if let responseString = String(data: data, encoding: .utf8) {
//                    print(responseString)
                }
                completion(.success(validMoveResponse.validMoves))
            } catch {
                completion(.failure(error))
            }
        }
        
        // Start the task
        task.resume()
    }
    static func makeMove(gameId: String, move: String, completion: @escaping (Result<[String], Error>) -> Void) {
        // Define the URL of your Cloud Function endpoint
        guard let url = URL(string: "https://makemove-o7dsehv4jq-uc.a.run.app?move=\(move)&gameId=\(gameId)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        // Create the URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Create the URLSession
        let session = URLSession.shared
        
        // Create the data task
        let task = session.dataTask(with: request) { data, response, error in
            // Handle any errors
            if let error = error {
                print(error)
                completion(.failure(error))
                return
            }
            
            // Check if the response is valid
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("hmm")
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            // Ensure we have data
            guard let data = data else {
                print("nodata")
                completion(.failure(URLError(.unknown)))
                return
            }
            
            do {
                // Decode the JSON response into ValidMove struct
                let validMoveResponse = try JSONDecoder().decode(ValidMove.self, from: data)
                if let responseString = String(data: data, encoding: .utf8) {
//                    print(responseString)
                }
                completion(.success(validMoveResponse.validMoves))
            } catch {
                print(error)
                completion(.failure(error))
            }
        }
        
        // Start the task
        task.resume()
    }
}
