import UIKit

class WeatherSummaryTableViewCell: UITableViewCell, Initializable {
    @IBOutlet weak var weatherOverview: UILabel!
    
    func initialize(withData data: Any) {
        guard let weather = data as? Weather else { return }
        guard let currentTemp = weather.daily.first?.temp,
              let description = weather.current.weather.first?.description
              else { return }
        weatherOverview.text = String(format: Strings.weatherDescriptionPattenr, description,
              Int(currentTemp.max),
              Int(currentTemp.min))
    }
}
