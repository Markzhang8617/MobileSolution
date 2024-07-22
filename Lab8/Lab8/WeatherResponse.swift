import Foundation

struct WeatherResponse: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
    let wind: Wind
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
}
