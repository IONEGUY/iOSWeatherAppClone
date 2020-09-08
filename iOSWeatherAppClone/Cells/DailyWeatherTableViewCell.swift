import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var minTemperatureValue: UILabel!
    @IBOutlet weak var maxTemperatureValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        selectedBackgroundView = backgroundView
    }
    
    func fillData(dayName: String, iconName: String?, minTemp: Float?, maxTemp: Float?) {
        self.dayName.text = dayName
        self.minTemperatureValue.text = "\(Int(minTemp ?? 0))"
        self.maxTemperatureValue.text = "\(Int(maxTemp ?? 0))"
        weatherIcon.initWith(url: String(format: ApiConstants.iconsUrl, iconName ?? String.empty))
    }
}
