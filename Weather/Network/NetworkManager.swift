//
//  NetworkManager.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

public struct NetworkManager {
    
    private let session = URLSession(configuration: .default)
    
    public init() {}
    
    public func send<Output: Decodable>(request: EndPointType, completion: @escaping (Result<Output, APIError>) -> Void) {
        
        let result = buildRequest(request: request)
        
        var url: URLRequest!
        
        switch result {
        case .success(let urlRequest):
            url = urlRequest
        case.failure(let err):
            completion(.failure(err))
            return
        }
        let task = session.dataTask(with: url) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(.custom(error.localizedDescription)))
                return
            }
            if let urlResponse = urlResponse as? HTTPURLResponse {
                let response = handleNetworkResponse(urlResponse)
                
                switch response {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(APIError.dataMissing))
                        return
                    }
                    
                    do {
                        let response = try JSONDecoder().decode(Output.self, from: responseData)
                        completion(.success(response))
                    } catch {
                        completion(.failure(APIError.custom(error.localizedDescription)))
                    }
                    
                    
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            } else {
                completion(.failure(APIError.failed))
            }
        }
        
        task.resume()
    }
    
    
    public func loadData(request: EndPointType, completion: @escaping (Result<Data, APIError>) -> Void) {
        
        let result = buildRequest(request: request)
        
        var url: URLRequest!
        
        switch result {
        case .success(let urlRequest):
            url = urlRequest
        case.failure(let err):
            completion(.failure(err))
            return
        }
        let task = session.dataTask(with: url) { (data, urlResponse, error) in
            if let error = error {
                completion(.failure(.custom(error.localizedDescription)))
                return
            }
            if let urlResponse = urlResponse as? HTTPURLResponse {
                let response = handleNetworkResponse(urlResponse)
                
                switch response {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(APIError.dataMissing))
                        return
                    }
                    completion(.success(responseData))
                    
                case .failure(let networkFailureError):
                    completion(.failure(networkFailureError))
                }
            } else {
                completion(.failure(APIError.failed))
            }
        }
        
        task.resume()
    }
    
}

private func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<HTTPURLResponse, APIError> {
    switch response.statusCode {
    case 200...299: return .success(response)
    default: return .failure(APIError.failed)
    }
}

private func buildRequest(request: EndPointType) -> Result<URLRequest, APIError> {
    
    var urlComponents = URLComponents()
    urlComponents.scheme = request.baseURL.scheme
    urlComponents.host = request.baseURL.host
    urlComponents.path = request.baseURL.path + "/" + request.path
    let queryItems = request.queries?.map {
        URLQueryItem(name: $0.key, value: $0.value)
    }
    urlComponents.queryItems = queryItems
    
    guard let url = urlComponents.url else {
        return .failure(APIError.invalidUrl)
    }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.httpMethod.rawValue
    
    return .success(urlRequest)
}
