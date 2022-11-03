//
//  NetworkDataFetch.swift
//  BloggingMe
//
//  Created by Антон Стафеев on 03.11.2022.
//

import Foundation

class NetworkDataFetch {
    
    static let shared = NetworkDataFetch()
    private init() {}
    
    func fetchMail(verifableMail: String, response: @escaping(MailResponseModel?, Error?) -> Void) {
        NetworkRequest.shared.requestData(varifableMail: verifableMail) { result in
            switch result {
            case .success(let data):
                do {
                    let mail = try JSONDecoder().decode(MailResponseModel.self
                                                        , from: data)
                    response(mail, nil)
                }
                catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requestind data: \(error.localizedDescription)")
                response(nil, error)
            }
        }
    }
}
