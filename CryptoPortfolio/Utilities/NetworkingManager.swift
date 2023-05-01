//
//  NetworkingManager.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 19.04.2023.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        
        case badURLResponse(url: URL)
        case unowned
        
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "[🔥] Bad response from URL: \(url)"
            case .unowned                     : return "[⚠️] Unowned error"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleUrlResponse(output: $0, url: url )})
          //.receive(on: DispatchQueue.main) -> The best thin -> receive after decoding Data
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleUrlResponse(output:  URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        ///throw NetworkingError.badURLResponse(url: url) ///  check throw -> error
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(_ completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print("[🔥] Error handleCompletion: \(error.localizedDescription)")
        }
    }
    
}
