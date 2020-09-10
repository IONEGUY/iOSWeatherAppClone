import UIKit

class WeatherForDaysTableViewCell: UITableViewCell, UITableViewDataSource, Initializable {
    @IBOutlet weak var dailyWeatherTableView: UITableView!
    
    private var dailyWeather = ArraySlice<DailyWeather>()
    private var dayNames = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeather.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: DailyWeatherTableViewCell.self, for: indexPath)
        let dayWeather = dailyWeather[indexPath.item]
        cell.fillData(dayName: dayNames[indexPath.item],
                      iconName: dayWeather.weather.first!.icon,
                      minTemp: dayWeather.temp.min,
                      maxTemp: dayWeather.temp.max)
        return cell
    }
    
    func initialize(withData data: Any) {
        guard let weather = data as? Weather else { return }
        dailyWeatherTableView.dataSource = self
        dailyWeatherTableView.separatorStyle = .none
        dailyWeatherTableView.separatorColor = .clear
        dailyWeatherTableView.register(cellType: DailyWeatherTableViewCell.self)
        
        dayNames = enumerateDaysFromCurrent(daysCount: 6)
        dailyWeather = weather.daily.prefix(dayNames.count)
        
        dailyWeatherTableView.reloadData()
    }
    
    private func enumerateDaysFromCurrent(daysCount: Int) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.dayNameDateFormat
        var days = [String]()
        for dayIndex in 0...daysCount {
            let day = Calendar.current.date(byAdding: .day, value: dayIndex, to: Date())
            days.append(dateFormatter.string(from: day!))
        }
        
        return days
    }
}
