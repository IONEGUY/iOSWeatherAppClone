import Foundation

struct DailyWeather: Codable {
    var sunrise: Int64
    var sunset: Int64
    var temp: DetailedTemperature
    var weather: [WeatherOverview]
    
    enum CodingKeys: String, CodingKey {
        case sunrise
        case sunset
        case temp
        case weather
    }
}
