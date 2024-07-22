//
//  ViewController.swift
//  Lab8
//
//  Created by user246846 on 7/21/24.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           if let location = locations.last {
               let lat = location.coordinate.latitude
               let lon = location.coordinate.longitude
               fetchWeather(lat: lat, lon: lon)
               locationManager.stopUpdatingLocation()
           }
       }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to get user location: \(error.localizedDescription)")
    }

    
    func fetchWeather(lat: Double, lon: Double) {
        let apiKey = "cbbd921f6312d873f6ffe09293631771"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        print("urlString: \(urlString)")
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error fetching weather data: \(error.localizedDescription)")
                    return
                }
                if let data = data {
                    self.parseWeatherData(data)
                }
            }
            task.resume()
        }
    }

    func parseWeatherData(_ data: Data) {
        let decoder = JSONDecoder()
        do {
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            DispatchQueue.main.async {
                self.updateUI(weather: weatherResponse)
            }
        } catch {
            print("Error decoding weather data: \(error.localizedDescription)")
        }
    }
    
    func updateUI(weather: WeatherResponse) {
        cityNameLabel.text = weather.name
        if let weatherDescription = weather.weather.first?.description {
            weatherDescriptionLabel.text = weatherDescription
        }
        if let icon = weather.weather.first?.icon {
            loadWeatherIcon(icon: icon)
        }
        temperatureLabel.text = "\(weather.main.temp)°C"
        humidityLabel.text = "Humidity: \(weather.main.humidity)%"
        windSpeedLabel.text = "Wind Speed: \(weather.wind.speed) m/s"
    }

    func loadWeatherIcon(icon: String) {
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.weatherIconImageView.image = image
                    }
                    
                }
            }
            task.resume()
        }
    }
}

