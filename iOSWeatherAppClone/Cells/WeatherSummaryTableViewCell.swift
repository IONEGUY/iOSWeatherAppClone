import UIKit

class WeatherSummaryTableViewCell: UITableViewCell, Initializable {
    @IBOutlet weak var weatherOverview: UILabel!
    
    func initialize(withData data: Any) {
        guard let weather = data as? Weather else { return }
        let currentTemp = weather.daily.first!.temp
        weatherOverview.text = String(format: Strings.weatherDescriptionPattenr,
              weather.current.weather.first!.description,
              Int(currentTemp.max),
              Int(currentTemp.min))
    }
}
