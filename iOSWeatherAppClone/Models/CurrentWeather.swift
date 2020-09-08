import Foundation

struct CurrentWeather: Codable {
    var unixTime: Int64
    var sunrise: Int64?
    var sunset: Int64?
    var temp: Float
    var humidity: Float
    var windSpeed: Float
    var windDeg: Int
    var feelsLike: Float
    var rain: Rain?
    var pressure: Float
    var visibility: Float
    var weather: [WeatherOverview]
    var clouds: Float
    var uvi: Float?
    var pop: Float?
    
    enum CodingKeys: String, CodingKey {
        case unixTime = "dt"
        case sunrise
        case sunset
        case temp
        case humidity
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case feelsLike = "feels_like"
        case rain
        case pressure
        case visibility
        case weather
        case clouds
        case uvi
    }
}
