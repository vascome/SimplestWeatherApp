//
//  NetworkGateway.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

public final class NetworkGateway {
    
    private let manager = NetworkManager()
    public static let shared = NetworkGateway()
    private init () {}
    
    public func getForecast(for location: WeatherLocation, completion: @escaping (_ result: Result<ForecastResponse, APIError>) -> Void) {
        
        let endPoint = ForecastEndPoint.getForecast(latitude: location.lat, longitude: location.lon)
        manager.send(request: endPoint, completion: completion)
    }
    
    
    public func loadImage(_ name: String, completion: @escaping (_ result: Result<Data, APIError>) -> Void) {
        
        let endPoint = ImageEndPoint.getImage(name: name)
        manager.loadData(request: endPoint, completion: completion)
    }
}
