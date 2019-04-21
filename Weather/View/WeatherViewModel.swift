//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Vasily Popov on 20/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

typealias ForecaseResultCompletion = (Result<ForecastResponse,APIError>)->Void

final class WeatherViewModel {
    
    let forecast = Event<Forecast>()
    let placeName = Event<String>()
    let weatherIcon = Event<Data>()
    let error = Event<String>()
    
    private let locationManager : LocationManager
    private let bag = DisposeBag()
    
    
    init(_ locationManager : LocationManager) {
        self.locationManager = locationManager
        self.locationManager.location.addHandler(target: self) { [weak self] _ in  self?.locationReceived }.disposed(by: bag)
        self.locationManager.placeName.addHandler(target: self) { [weak self] _ in  self?.placeReceived }.disposed(by: bag)
    }
    
    func viewDidLoad() {
        self.locationManager.startUpdatingLocation()
    }
    
    deinit {
        self.locationManager.stopUpdatingLocation()
    }
}

extension WeatherViewModel {
    
    private func locationReceived(_ location: WeatherLocation)
    {
        locationManager.stopUpdatingLocation()
        locationManager.getPlace(for: location)
        
        getForecast(location) { [weak self] (result) in
            
            switch result {
            case .failure(let error):
                self?.error.raise(error.localizedDescription)
            case .success(let response):
                
                if let forecast = response.currently {
                    self?.forecast.raise(forecast)
                    if let name = forecast.icon {
                        self?.loadImage(name: name)
                    }
                }
                else {
                    self?.error.raise("no forecast for your location")
                }
            }
        }
    }
    
    private func placeReceived(_ name: String)
    {
        self.placeName.raise(name)
    }
    
    private func getForecast(_ location: WeatherLocation, _ completion: @escaping ForecaseResultCompletion) {
        NetworkGateway.shared.getForecast(for: location) { (result) in
            completion(result)
        }
    }
    
    private func loadImage(name: String) {
        NetworkGateway.shared.loadImage(name, completion: { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.error.raise(error.localizedDescription)
            case .success(let data):
                self?.weatherIcon.raise(data)
            }
        })
    }
}
