//
//  GameService.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 14/02/2022.
//

import Foundation
import UIKit

protocol NetworkService {
    func fetchGames(platform: Platform.RawValue, page: Int, completion: @escaping (Result<Games, APIError>) -> Void)
    func fetchSearchGames(search: String, page_Size: Int, completion: @escaping (Result<Games, APIError>) -> Void)
    func loadMore(next: String, completion: @escaping (Result<Games, APIError>) -> Void)
}

class GameService: NetworkService {
   
    
    
    //MARK: Singleton
    static let shared = GameService()
    private init() {}
    
    //MARK: Properties
    private var dataTask: URLSessionDataTask?
    var session = URLSession(configuration: .default)
   
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchGames(platform: Platform.RawValue, page: Int, completion: @escaping (Result<Games, APIError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.rawg.io"
        urlComponents.path = "/api/games"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: SecretApiKey.rawgApiKey),
            URLQueryItem(name: "platforms", value: platform),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "page_size", value: "40")]
        
        guard let urlRawg = urlComponents.url?.absoluteString else { return }
        guard let url = URL(string: urlRawg) else { return }
        
        dataTask = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else { completion(.failure(.server))
                    return
                }
               
                guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(.network))
                    return
                }
                
                guard let gameInfo = try? JSONDecoder().decode(Games.self, from: data) else {
                    completion(.failure(.decoding))
                    return
                }
                completion(.success(gameInfo))
            }
        }
        dataTask?.resume()
    }
    
    func fetchSearchGames(search: String, page_Size: Int = 40, completion: @escaping (Result<Games, APIError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.rawg.io"
        urlComponents.path = "/api/games"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: SecretApiKey.rawgApiKey),
            URLQueryItem(name: "search", value: search),
            URLQueryItem(name: "plateforms", value: "18,7,1"),
            URLQueryItem(name: "page_size", value: String(page_Size))]
        
        guard let urlRawg = urlComponents.url?.absoluteString else { return }
        guard let url = URL(string: urlRawg) else { return }
        print(urlRawg)
        dataTask = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else { completion(.failure(.server))
                    return
                }
               
                guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(.network))
                    return
                }
                
                guard let gameInfo = try? JSONDecoder().decode(Games.self, from: data) else {
                    completion(.failure(.decoding))
                    return
                }
                completion(.success(gameInfo))
            }
        }
        dataTask?.resume()
    }
    
    func loadMore(next: String, completion: @escaping (Result<Games, APIError>) -> Void) {
        guard let url = URL(string: next) else { return }
        dataTask = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else { completion(.failure(.server))
                    return
                }
               
                guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(.network))
                    return
                }
                
                guard let gameInfo = try? JSONDecoder().decode(Games.self, from: data) else {
                    completion(.failure(.decoding))
                    return
                }
                completion(.success(gameInfo))
            }
        }
        dataTask?.resume()
    }
    
}

