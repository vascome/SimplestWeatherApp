//
//  NetworkProtocols.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

public enum APIError: Error {
    case invalidUrl
    case dataMissing
    case failed
    case custom(String)
}


public typealias HTTPQueries = [String:String]

public enum HTTPMethod : String {
    case get = "GET"
}

public protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var queries: HTTPQueries? { get }
}
