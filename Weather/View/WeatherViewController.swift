//
//  ViewController.swift
//  Weather
//
//  Created by Vasily Popov on 21/04/2019.
//  Copyright © 2019 Vasily Popov. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    private let viewModel : WeatherViewModel
    private let bag = DisposeBag()
    
    init(viewModel : WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "WeatherViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.placeName.addHandler(target: self) { [weak self] _ in  self?.bindPlaceName }.disposed(by: bag)
        viewModel.forecast.addHandler(target: self) { [weak self] _ in  self?.bindForecast }.disposed(by: bag)
        viewModel.weatherIcon.addHandler(target: self) { [weak self] _ in  self?.bindIcon }.disposed(by: bag)
        viewModel.error.addHandler(target: self) { [weak self] _ in  self?.bindError }.disposed(by: bag)
        self.viewModel.viewDidLoad()
    }
    
    private func bindPlaceName(_ name: String)
    {
        DispatchQueue.main.async { [weak self] in
            self?.placeNameLabel.text = name
        }
    }
    
    private func bindForecast(_ forecast: Forecast)
    {
        DispatchQueue.main.async { [weak self] in
            self?.summaryLabel.text = forecast.summary
            self?.temperatureLabel.text = "Temperature - \(forecast.temperature?.temperatureForamtter() ?? "")"
            self?.dateLabel.text = forecast.time?.toDateString()
            self?.humidityLabel.text = "Humidity - \(forecast.humidity?.humidityForamtter() ?? "")"
            self?.pressureLabel.text = "Pressure - \(forecast.pressure?.pressureForamtter() ?? "")"
            self?.windLabel.text = "Wind - \(forecast.windSpeed?.windForamtter() ?? "")"
        }
    }
    
    private func bindIcon(_ data: Data)
    {
        DispatchQueue.main.async { [weak self] in
            self?.weatherImage.image = UIImage(data: data)
        }
    }
    
    private func bindError(_ error: String)
    {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "We have some problems", message: error, preferredStyle: .alert)
            let action =  UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alert.addAction(action)
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    
}

