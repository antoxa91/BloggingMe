//
//  NetworkRequest.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 03.11.2022.
//

import Foundation

class NetworkRequest {
    
    static let shared = NetworkRequest()
    private init() {}
    
    func requestData(varifableMail: String, completion: @escaping(Result<Data, Error>) -> Void) {
        let urlString = "https://api.kickbox.com/v2/verify?email=\(varifableMail)&apikey=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                completion(.success(data))
            }
        }
        .resume()
    }
}
