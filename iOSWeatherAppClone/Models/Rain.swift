import Foundation

struct Rain: Codable {
    var precipitation: Float
    
    enum CodingKeys: String, CodingKey {
        case precipitation = "1h"
    }
}
