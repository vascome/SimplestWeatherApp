//
//  Reusable.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import Foundation

extension Int {
    func toDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: Date(timeIntervalSince1970: Double(self)))
    }
}

extension Double {
    
    func temperatureForamtter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        let formatter = MeasurementFormatter()
        let temperature = Measurement(value: self, unit: Unit(symbol: "°C"))
        formatter.unitOptions = .temperatureWithoutUnit
        formatter.numberFormatter = numberFormatter
        return formatter.string(from: temperature)
    }
    
    func humidityForamtter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        let formatter = MeasurementFormatter()
        let humidity = Measurement(value: 100*self, unit: Unit(symbol: "%"))
        formatter.numberFormatter = numberFormatter
        return formatter.string(from: humidity)
    }
    
    func pressureForamtter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        let formatter = MeasurementFormatter()
        let pressure = Measurement(value: self, unit: Unit(symbol: "mb"))
        formatter.numberFormatter = numberFormatter
        return formatter.string(from: pressure)
    }
    
    func windForamtter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        let formatter = MeasurementFormatter()
        let wind = Measurement(value: self, unit: Unit(symbol: "m/s"))
        formatter.numberFormatter = numberFormatter
        return formatter.string(from: wind)
    }
    
}
