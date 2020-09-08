import Foundation

struct DetailedTemperature: Codable {
    var min: Float
    var max: Float
    
    enum CodingKeys: String, CodingKey {
        case min
        case max
    }
}
