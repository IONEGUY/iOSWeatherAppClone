import Foundation

struct Weather: Codable {
    var timezone: String
    var current: CurrentWeather
    var hourly: [CurrentWeather]
    var daily: [DailyWeather]
    
    enum CodingKeys: String, CodingKey {
        case timezone
        case current
        case hourly
        case daily
    }
}
