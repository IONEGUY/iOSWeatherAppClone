import Foundation

extension Date {
    static func convertUnitTimeToDateTime(_ unixTime: Int64?, withMinutes: Bool = false) -> String {
        guard let unixTime = unixTime else { return String.empty }
        
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withMinutes ? Strings.hoursFormatWithMinutes : Strings.hoursFormat
        return dateFormatter.string(from: date)
    }
}
