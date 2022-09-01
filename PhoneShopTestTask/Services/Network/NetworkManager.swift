//
//  NetworkManager.swift
//  PhoneShopTestTask
//
//  Created by антон кочетков on 30.08.2022.
//

import Foundation

struct NetworkManager: Networking {
    
    static let shared = NetworkManager()
    
    private let urlStringForMainScreenData = "https://run.mocky.io/v3/654bd15e-b121-49ba-a588-960956b15175"
    private let urlStringForItemScreen = ""
    
    func getMainScreenData(completion: @escaping (Result<MainScreenData, Error>) -> Void) {
        guard let url = URL(string: urlStringForMainScreenData) else { return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let formatterData = try decoder.decode(MainScreenData.self, from: data)
                    completion(.success(formatterData))
                } catch let error where error is DecodingError {
                    completion(.failure(NetworkError.NotValidData(error)))
                } catch  {
                    completion(.failure(NetworkError.UnknownError))
                }
            } else {
                completion(.failure(NetworkError.DataNil))
            }
        }
        
        task.resume()
    }
    
    func loadImageData(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.InvalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.DataNil))
            }
        }
        
        task.resume()
    }
 
    
}

extension NetworkManager {
    enum NetworkError: Error {
        case DataNil
        case NotValidData(Error?)
        case UnknownError
        case InvalidURL
    }
}
