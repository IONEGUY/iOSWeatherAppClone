import UIKit

class DetailedWeatherInfoTableViewCell: UITableViewCell, Initializable {
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    @IBOutlet weak var chanceOfRain: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var wind: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var precipiation: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var uvIndex: UILabel!
    
    func initialize(withData data: Any) {
        guard let weather = data as? Weather else { return }
        
        sunset.text = convertUnitTimeToDateTime(weather.current.sunset!, withMinutes: true)
        sunrise.text = convertUnitTimeToDateTime(weather.current.sunrise!, withMinutes: true)
        chanceOfRain.text = "\((weather.hourly.first?.pop ?? 0))%"
        humidity.text = "\(weather.current.humidity)%"
        wind.text = "\(Direction(Double(weather.current.windDeg))) \(weather.current.windSpeed) km/h"
        feelsLike.text = "\(Int(weather.current.feelsLike))\(Strings.celsiusMarker)"
        precipiation.text = "\(weather.hourly.first?.rain?.precipitation ?? 0) cm"
        pressure.text = "\(weather.current.pressure) hPa"
        visibility.text = "\(weather.current.visibility / 1000) km"
        uvIndex.text = "\(weather.current.uvi ?? 0)"
    }
    
    private func convertUnitTimeToDateTime(_ unixTime: Int64, withMinutes: Bool = false) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withMinutes ? Strings.hoursFormatWithMinutes : Strings.hoursFormat
        return dateFormatter.string(from: date)
    }
}
