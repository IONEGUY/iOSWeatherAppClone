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
        
        dayNames = enumerateDaysFromCurrent()
        dailyWeather = weather.daily.prefix(7)
        
        dailyWeatherTableView.reloadData()
    }
    
    private func enumerateDaysFromCurrent() -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.dayNameDateFormat
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = (weekdays.lowerBound ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        return days.map({ dateFormatter.string(from: $0) })
    }
}
