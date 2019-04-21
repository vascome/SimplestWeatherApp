//
//  WeatherModel.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

typealias Latitude = Double
typealias Longitude = Double
typealias TimeZome = String

public struct WeatherLocation {
    let lat: Latitude
    let lon: Longitude
}

public struct Forecast : Decodable {
    let time: Int?
    let summary: String?
    let icon: String?
    let precipIntensity: Double?
    let precipProbability: Double?
    let temperature: Double?
    let apparentTemperature: Double?
    let dewPoint: Double?
    let humidity: Double?
    let pressure: Double?
    let windSpeed: Double?
    let windGust: Double?
    let windBearing: Double?
    let cloudCover: Double?
    let uvIndex: Int?
    let visibility: Double?
    let ozone: Double?
}

public struct ForecastMetaData : Decodable {
    let sources: [String]?
    let meteoalarmLicense: String?
    let nearestStation: Double?
    let units: String?
    
    enum CodingKeys: String, CodingKey {
        case meteoalarmLicense = "meteoalarm-license"
        case nearestStation = "nearest-station"
        case sources
        case units
    }
    
}

public struct ForecastResponse : Decodable {
    let latitude: Latitude?
    let longitude: Longitude?
    let timezone: TimeZome?
    let currently: Forecast?
    let flags: ForecastMetaData?
}
