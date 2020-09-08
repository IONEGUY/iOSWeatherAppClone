import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, CLLocationManagerDelegate {
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var dayType: UILabel!
    @IBOutlet weak var hourlyWeatherCollectionViewContainer: UIView!
    @IBOutlet weak var minTemperature: UILabel!
    @IBOutlet weak var maxTemperature: UILabel!
    
    private let dayCellsSpacing: CGFloat = 10
    private let locationManager = CLLocationManager()
    private let errorHandler = AlertErrorMessageHandler()
    private var weather: Weather!
    private var hourlyWeather = [HourlyWeatherCellModel]()
    private var hourlyWeatherCollectionView: UICollectionView!
    private var cells = [WeatherForDaysTableViewCell.self,
                         WeatherSummaryTableViewCell.self,
                         DetailedWeatherInfoTableViewCell.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSelfTableView()
        initHorizontalLayoutForHourlyWeatherCollectionView()
        
        hourlyWeatherCollectionView.dataSource = self
        hourlyWeatherCollectionView?.delegate = self
        hourlyWeatherCollectionView.register(cellType: HourlyWeatherCell.self)
               
        initLocationManager()
        
        hourlyWeatherCollectionViewContainer.addSubview(hourlyWeatherCollectionView ?? UICollectionView())
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        getWeather(location)
    }
    
    private func initSelfTableView() {
        tableView.register(cellType: WeatherForDaysTableViewCell.self)
        tableView.register(cellType: WeatherSummaryTableViewCell.self)
        tableView.register(cellType: DetailedWeatherInfoTableViewCell.self)
        tableView.separatorInset = .zero
        tableView.separatorColor = .white
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func initLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    private func initHorizontalLayoutForHourlyWeatherCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        hourlyWeatherCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        hourlyWeatherCollectionView?.showsHorizontalScrollIndicator = false
    }
    
    override func viewWillLayoutSubviews() {
        hourlyWeatherCollectionView?.frame = hourlyWeatherCollectionViewContainer.bounds
        hourlyWeatherCollectionView.backgroundColor = .clear
        self.view.layoutIfNeeded()
    }
    
    private func getWeather(_ location: CLLocationCoordinate2D) {
        ActivityIndicatorHelper.show(self.view)
        WeatherService.shared.getWeather(weatherRequest:
            WeatherRequest(latitude: location.latitude,
                                     longitude: location.longitude,
                                     appid: AppSecrets.appId,
                                     units: Strings.unit))
        { (result) in
            ActivityIndicatorHelper.hide()
            let weather: Weather?
            switch result {
                case .success(let success):
                    weather = success
                case .failure(let error):
                    self.errorHandler.handle(error.localizedDescription)
                    weather = CashHelper.weather
            }
            DispatchQueue.main.async {
                self.initUI(weather)
            }
        }
    }
    
    private func initUI(_ weather: Weather?) {
        guard let weather = weather else { return }
        self.weather = weather
        cityName.text = weather.timezone.components(separatedBy: "/")[1]
        weatherDescription.text = weather.current.weather.first!.description
        temperature.text = "\(Int(weather.current.temp))\(Strings.celsiusMarker)"
        dayName.text = getCurrentDayName()
        dayType.text = weather.current.weather.first!.icon.contains("d") ? Strings.day : Strings.night
        let currentTemp = weather.daily.first!.temp
        minTemperature.text = "\(Int(currentTemp.min))"
        maxTemperature.text = "\(Int(currentTemp.max))"
        
        initHourlyWeatherCollection()
        
        tableView.reloadData()
    }
    
    private func initHourlyWeatherCollection() {
        hourlyWeather = weather.hourly.prefix(24).map {
            HourlyWeatherCellModel(
                hour: convertUnitTimeToDateTime($0.unixTime),
                icon: $0.weather.first?.icon,
                cellType: .temperature,
                temperature: "\(String(Int($0.temp)))\(Strings.celsiusMarker)")
        }
        
        hourlyWeather[0].hour = Strings.now
        
        let currentUnixTime = Int64(Date().timeIntervalSince1970)
        let sunrise = currentUnixTime > weather.current.sunrise!
            ? weather.daily[1].sunrise
            : weather.current.sunrise
        
        let sunset = currentUnixTime > weather.current.sunset!
            ? weather.daily[1].sunset
            : weather.current.sunset
        
        hourlyWeather.insert(createSunrizeSunsetModel(sunrise!, .sunrize),
                             at: getIndex(byTime: sunrise!))
        hourlyWeather.insert(createSunrizeSunsetModel(sunset!, .sunset),
                             at: getIndex(byTime: sunset!) + 1)
        
        hourlyWeatherCollectionView.reloadData()
    }
    
    private func getIndex(byTime time: Int64) -> Int {
        return weather.hourly.firstIndex(where: { (weatherItem) in
            weatherItem.unixTime > time
        })!
    }
    
    private func createSunrizeSunsetModel(_ time: Int64, _ cellType: HourlyCellType) -> HourlyWeatherCellModel {
        return HourlyWeatherCellModel(
            hour: convertUnitTimeToDateTime(time, withMinutes: true),
            icon: cellType.rawValue,
            cellType: cellType,
            temperature: cellType.rawValue)
    }
    
    private func convertUnitTimeToDateTime(_ unixTime: Int64, withMinutes: Bool = false) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = withMinutes ? Strings.hoursFormatWithMinutes : Strings.hoursFormat
        return dateFormatter.string(from: date)
    }
    
    private func getCurrentDayName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.dayNameDateFormat
        return dateFormatter.string(from: Date())
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: cells[indexPath.row], for: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        (cell as? Initializable)?.initialize(withData: weather as Any)
        return cell
    }
}

extension WeatherTableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: HourlyWeatherCell.self, for: indexPath)
        let hourWeather = hourlyWeather[indexPath.item]

        cell.fillData(hourWeather)
        return cell
    }
}

extension WeatherTableViewController: UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return dayCellsSpacing
    }
}
