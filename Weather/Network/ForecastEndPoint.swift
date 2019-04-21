//
//  ForecastEndPoint.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

let weatherKey = "2bb07c3bece89caf533ac9a5d23d8417"

public enum ForecastEndPoint {
    case getForecast(latitude: Double, longitude: Double)
}


extension ForecastEndPoint : EndPointType {
    public var baseURL: URL {
        return URL(string: "https://api.darksky.net")!
    }
    public var path: String {
        
        switch self {
        case .getForecast(let lat, let lon):
            return "forecast/\(weatherKey)/\(lat),\(lon)"
        }
        
    }
    public var httpMethod: HTTPMethod { return .get }
    
    public var queries: HTTPQueries? {
        switch self {
        case .getForecast:
            return ["units":"si"]
        }
    }
}


public enum ImageEndPoint {
    case getImage(name: String)
}


extension ImageEndPoint : EndPointType {
    public var baseURL: URL {
        return URL(string: "https://darksky.net/")!
    }
    public var path: String {
        
        switch self {
        case .getImage(let name):
            return "images/weather-icons/\(name).png"
        }
        
    }
    public var httpMethod: HTTPMethod { return .get }
    
    public var queries: HTTPQueries? {
        return nil
    }
}
