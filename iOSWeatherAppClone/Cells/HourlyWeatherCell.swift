import UIKit

class HourlyWeatherCell: UICollectionViewCell {
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!

    func fillData(_ model: HourlyWeatherCellModel) {
        hourLabel.text = model.hour
        temperatureLabel.text = model.temperature
        
        if model.cellType == .temperature {
            weatherIcon.initWith(url: String(format: ApiConstants.iconsUrl, model.icon ?? String.empty))
        } else {
            weatherIcon.image = UIImage(named: model.cellType.rawValue)
        }
    }
}
