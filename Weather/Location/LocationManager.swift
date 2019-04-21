//
//  UserLocation.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager : NSObject {
    
    private let manager = CLLocationManager()
    public static let shared = LocationManager()
    
    private override init() {
        super.init()
    }
    
    let location = Event<WeatherLocation>()
    let placeName = Event<String>()
    
    func startUpdatingLocation() {
        
        if CLLocationManager.locationServicesEnabled() {
            
            if CLLocationManager.authorizationStatus() == .restricted ||
                CLLocationManager.authorizationStatus() == .denied ||
                CLLocationManager.authorizationStatus() == .notDetermined {
                manager.requestWhenInUseAuthorization()
            }
            manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            manager.delegate = self
            manager.startUpdatingLocation()
        } else {
            print("location service is disabled")
        }
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
}

extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let weatherLocation = WeatherLocation(lat: locValue.latitude, lon: locValue.longitude)
        self.location.raise(weatherLocation)
    }
    
}

extension LocationManager {
    
    func getPlace(for location: WeatherLocation) {
        
        let requestLocation = CLLocation(latitude: location.lat, longitude: location.lon)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(requestLocation) { [weak self] placemarks, error in
            
            guard error == nil else {
                self?.placeName.raise("\(location.lat), \(location.lon)")
                return
            }
            
            guard let placemark = placemarks?[0] else {
                self?.placeName.raise("\(location.lat), \(location.lon)")
                return
            }
            
            var name = ""
            
            if let locality = placemark.locality {
                name.append(contentsOf: locality)
            }
            if let country = placemark.country {
                if name.count > 0 {
                    name += ", "
                }
                name.append(contentsOf: country)
            }

            if name.count == 0 {
                self?.placeName.raise("\(location.lat), \(location.lon)")
            }
            else {
                self?.placeName.raise(name)
            }
        }
    }
}
