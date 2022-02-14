//
//  GameService.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 14/02/2022.
//

import Foundation

protocol RawGService {
    func fetchGames(platform: Platform.RawValue, completion: @escaping (Result<Games, APIError>) -> Void)
}

class GameService: RawGService {
    
    //MARK: Singleton
    static let shared = GameService()
    private init() {}
    
    //MARK: Properties
    private var dataTask: URLSessionDataTask?
    var session = URLSession(configuration: .default)
    var scannerViewController = ScannerViewController()
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchGames(platform: Platform.RawValue, completion: @escaping (Result<Games, APIError>) -> Void) {
   
        guard let url = URL(string: "https://api.rawg.io/api/games?key=\(SecretApiKey.rawgApiKey)&platforms=\(platform)") else { return }
        print(url)
        dataTask = session.dataTask(with: url) { (data, response, error) in
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
        dataTask?.resume()
    }
    
    
}
