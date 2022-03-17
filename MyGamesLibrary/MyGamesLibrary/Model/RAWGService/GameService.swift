//
//  GameService.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 14/02/2022.
//

import Foundation

protocol NetworkService {
    func fetchGames(platform: GamePlatform.RawValue, page: Int, completion: @escaping (Result<Games, APIError>) -> Void)
    func fetchSearchGames(search: String, completion: @escaping (Result<Games, APIError>) -> Void)
    func getDataFromUrl(next: String, completion: @escaping (Result<Games, APIError>) -> Void)
    func getDataWithUPC(barCode: String, completion: @escaping (Result<ItemsList, APIError>) -> Void)
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
    
    func fetchGames(platform: GamePlatform.RawValue, page: Int, completion: @escaping (Result<Games, APIError>) -> Void) {
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
    
    func fetchSearchGames(search: String, completion: @escaping (Result<Games, APIError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.rawg.io"
        urlComponents.path = "/api/games"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: SecretApiKey.rawgApiKey),
            URLQueryItem(name: "search", value: search)]
        
        guard let urlRawg = urlComponents.url?.absoluteString else { return }
        guard let url = URL(string: urlRawg) else { return }
       print(url)
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
                dump(gameInfo)
                completion(.success(gameInfo))
            }
        }
        dataTask?.resume()
    }
    
    func getDataFromUrl(next: String, completion: @escaping (Result<Games, APIError>) -> Void) {
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
    
    func getDataWithUPC(barCode: String, completion: @escaping (Result<ItemsList, APIError>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.upcitemdb.com"
        urlComponents.path = "/prod/trial/lookup"
        urlComponents.queryItems = [ URLQueryItem(name: "upc", value: barCode)]

       guard let urlUPC = urlComponents.url?.absoluteString else { return }
        guard let url = URL(string: urlUPC) else { return }

        dataTask = session.dataTask(with: url) { (data, response, error) in
      
                guard error == nil else { completion(.failure(.server))
                    return
                }

                guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(.network))
                    return
                }

                guard let upcInfo = try? JSONDecoder().decode(ItemsList.self, from: data) else {
                    completion(.failure(.decoding))
                    return
                }
            DispatchQueue.main.async {
                completion(.success(upcInfo))
            }
        }
        dataTask?.resume()
        }
}
    
